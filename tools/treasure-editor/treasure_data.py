"""Edit treasure records and the pictures shared by the codex and equipment UI."""

import io
import os
import re
import struct
import sys
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageOps

if os.name == "nt":
    import msvcrt
else:
    import fcntl

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "officer-editor"))
from data import Archive, CAMPAIGNS, Game, encode, replace_files


ITEM_SIZE = 274
ART_SIZE = (128, 128)
PERCENT_OPTIONS = {228: "공격", 230: "책략", 232: "방어"}
STAT_NAMES = {
    220: "무력", 222: "지력", 224: "통솔", 226: "이동",
    **PERCENT_OPTIONS,
}
LEGACY_OPTION = re.compile(r"(?:^|[ 　]+)(?:책략 ?공격|공격|책략|방어)\s*[+＋－-]\s*\d+[％%]?\s*$")
CATEGORIES = ("무기", "책략무기", "갑옷", "병서", "보조", "말", "특수")
CATALOG_ROW = re.compile(rb"^\s*\{\s*(\d+)\s*,\s*(\d+)\s*,\s*([1-7])\s*,", re.MULTILINE)
GEAR_ROW = re.compile(
    rb'^\{"(?P<owner>(?:\\.|[^"\\])*)",(?P<normal>\d+),(?P<star>\d+),\d+,\d+,'
    rb'(?P<awaken>\d+),"(?:\\.|[^"\\])*",\d+,(?P<shared>\d+)(?:,(?P<override>\d+))?\},',
    re.MULTILINE,
)
EXCLUSIVE_OFFSET = 272
REGULAR_OFFSET = 256


@dataclass(frozen=True)
class Treasure:
    number: int
    name: str
    category: str
    picture: int
    awakened: bool


def import_picture(path):
    with Image.open(path) as source:
        if source.format not in {"PNG", "BMP"} or getattr(source, "n_frames", 1) != 1:
            raise ValueError("단일 PNG 또는 BMP 이미지를 선택해 주세요.")
        picture = ImageOps.contain(source.convert("RGBA"), ART_SIZE, Image.Resampling.LANCZOS)
    if not picture.getchannel("A").getbbox():
        raise ValueError("선택한 이미지에 보이는 부분이 없습니다.")
    canvas = Image.new("RGBA", ART_SIZE)
    canvas.paste(picture, ((ART_SIZE[0] - picture.width) // 2, (ART_SIZE[1] - picture.height) // 2))
    return canvas


class TreasureProject:
    def __init__(self, root):
        self.root = root
        self.games = {story: Game(root, slug) for story, slug in CAMPAIGNS.items()}
        self.base = self.games["영걸전"]
        self.catalog = self.base.folder / "script" / "addon" / "bogam_data.lua"
        self.catalog_raw = self.catalog.read_bytes()
        self.gear_path = self.catalog.with_name("gear_data.lua")
        self.gear_raw = self.gear_path.read_bytes()
        self.gear_rows = {row.start(): row for row in GEAR_ROW.finditer(self.gear_raw)}
        self.archive = Archive(self.base.path.parent, "bogam")
        self.stat_file = self.base.path.with_name("treasure_stats.txt")
        self.stat_raw = self.stat_file.read_bytes() if self.stat_file.exists() else None
        self.entries = self.read_catalog()
        self.gear_by_item = {}
        for key, row in self.gear_rows.items():
            if int(row["shared"]):
                self.gear_by_item.setdefault(int(row["normal"]), []).append(key)
            if int(row["star"]):
                self.gear_by_item.setdefault(int(row["star"]), []).append(key)
        self.skills = {number: name for number, name in self.base.skills.items() if name != "보류"}
        self.edited, self.skill_history = self.read_edited_stats()
        self.characters = {}
        for code, character in self.base.chars.items():
            self.characters.setdefault(character, code)

    def read_catalog(self):
        rows = CATALOG_ROW.findall(self.catalog_raw)
        if not rows or len(rows) * 3 != len(self.archive.ends) - 1:
            raise ValueError("보물 목록과 그림 파일의 항목 수가 일치하지 않습니다.")
        for game in self.games.values():
            if (game.offsets[4] - game.offsets[3]) % ITEM_SIZE:
                raise ValueError("보물 데이터의 레코드 길이가 올바르지 않습니다.")
        entries = {}
        names = self.base.names(3, ITEM_SIZE)
        for row, match in enumerate(rows):
            normal, star, category = map(int, match)
            for variant, number in enumerate((normal, star)):
                if not number and variant == 1:
                    continue
                picture = row * 3 + variant
                if number not in names or number in entries or not self.archive.present(picture):
                    raise ValueError(f"보물 #{number}의 이름 또는 그림을 확인할 수 없습니다.")
                for game in self.games.values():
                    record = self.record(game, number)
                    if struct.unpack_from("<h", record)[0] != number or not game.decode(record[2:16]):
                        raise ValueError(f"이야기별 데이터에서 보물 #{number}를 확인할 수 없습니다.")
                entries[number] = Treasure(number, names[number], CATEGORIES[category - 1], picture, bool(variant))
        return entries

    def read_edited_stats(self):
        edited = set()
        skill_history = {}
        for line in (self.stat_raw or b"").splitlines():
            try:
                number, offset, *previous = map(int, line.split())
                if number not in self.entries:
                    raise ValueError
                if offset == REGULAR_OFFSET:
                    if not previous or any(not 0 <= value <= 32767 for value in previous):
                        raise ValueError
                    skill_history.setdefault(number, set()).update(previous)
                elif previous or (offset not in STAT_NAMES and offset != EXCLUSIVE_OFFSET):
                    raise ValueError
            except ValueError as error:
                raise ValueError("treasure_stats.txt에 올바르지 않은 편집 항목이 있습니다.") from error
            edited.add((number, offset))
        return edited, skill_history

    @staticmethod
    def record(game, number):
        start = game.offsets[3] + number * ITEM_SIZE
        if start + ITEM_SIZE > game.offsets[4]:
            raise ValueError(f"이야기별 데이터에 보물 #{number}가 없습니다.")
        return game.raw[start:start + ITEM_SIZE]

    def stats(self, number):
        return dict(zip(STAT_NAMES, struct.unpack_from("<7h", self.record(self.base, number), 220)))

    def owner(self, number):
        return self.base.decode(self.record(self.base, number)[258:272])

    def gear_owner(self, row):
        name = re.sub(rb"\\(\d{1,3}|.)", lambda match: bytes([int(match[1])]) if match[1].isdigit() else match[1],
                      row["owner"])
        return self.base.decode(name)

    def skill_fields(self, number):
        fields = {}
        record = self.record(self.base, number)
        item_type = struct.unpack_from("<h", record, 216)[0]
        owner = self.owner(number)
        regular = struct.unpack_from("<h", record, REGULAR_OFFSET)[0]
        # Books and mounts can carry an ordinary skill or a player's engraving.
        # Weapon treasures with an inherited skill stay editable after clearing it.
        if item_type in (5, 6) or (item_type == 4 and
                                   (not owner or regular or (number, REGULAR_OFFSET) in self.edited)):
            fields["regular", number] = ("일반 특기", regular)
        if owner:
            value = struct.unpack_from("<h", record, EXCLUSIVE_OFFSET)[0]
            fields["exclusive", number] = (f"전용 · {owner}", value)
        for key in self.gear_by_item.get(number, ()):
            row = self.gear_rows[key]
            owner = self.gear_owner(row)
            if int(row["shared"]):
                fields["shared", key] = (f"공용 전용 · {owner}", int(row["override"] or row["shared"]))
            if int(row["star"]) == number:
                fields["awaken", key] = (f"각성 · {owner}", int(row["awaken"]))
        return fields

    def picture(self, number):
        with Image.open(io.BytesIO(self.archive.cell(self.entries[number].picture))) as picture:
            return picture.convert("RGBA")

    def description(self, number, stats=None, skills=None):
        record = self.record(self.base, number)
        raw = record[16:216].split(b"\0", 1)[0]
        if skills:
            fields = self.skill_fields(number)
            edits = {key: value for key, value in skills.items() if value != fields[key][1]}
            skill_lines, _ = self.skill_changes(number, edits)
            raw = self.replace_skill_lines(raw, skill_lines[number])
        description = self.base.decode(raw).replace("*", "\n")
        if struct.unpack_from("<h", record, 252)[0] <= 0:
            return description
        regular = struct.unpack_from("<h", record, REGULAR_OFFSET)[0]
        if skills:
            regular = skills.get(("regular", number), regular)
        skill = self.base.skills.get(regular, "") if regular > 0 else ""
        skill_line = f"특기: {skill}" if skill else ""
        lines = []
        for line in description.split("\n"):
            if line.startswith("특기:"):
                if skill and (line == skill_line or line.startswith((skill_line + " ", skill_line + "("))):
                    skill_line = line
                continue
            option = LEGACY_OPTION.search(line)
            if option and (option.start() == 0 or re.match(r"^(무력|지력|통솔|이동)\s*[+＋－-]", line)):
                line = line[:option.start()].rstrip()
            if line:
                lines.append(line)
        if stats is None:
            stats = self.stats(number)
        options = [f"{name} {stats[offset]:+d}%" for offset, name in PERCENT_OPTIONS.items() if stats[offset]]
        if skill_line:
            options.append(skill_line)
        lines[1:1] = options
        return "\n".join(lines)

    def encode_text(self, text):
        try:
            return b"".join(ch.encode("ascii") if ch.isascii() else self.characters[ch] for ch in text)
        except KeyError as error:
            raise ValueError(f"게임 글꼴에 없는 글자입니다 ({error.args[0]}).") from error

    def update_description(self, raw, values, skill_lines):
        if not values and not skill_lines:
            return raw
        # Preserve the original bytes and update only the edited lines.
        encoded = self.encode_text

        glyphs = {text: encoded(text) for text in "＋－０１２３４５６７８９"}
        digits = b"(?:" + b"|".join(re.escape(glyphs[ch]) for ch in "０１２３４５６７８９") + b"|[0-9])+"
        sign = b"(?:" + b"|".join(re.escape(glyphs[ch]) for ch in "＋－") + b"|[+-])"
        boundary = rb"(^|\*| |" + re.escape(encoded("　")) + b")"
        fullwidth = str.maketrans("0123456789+-", "０１２３４５６７８９＋－")
        original = text = raw.split(b"\0", 1)[0]
        for offset, value in values.items():
            label = encoded(STAT_NAMES[offset])
            pattern = boundary + b"(" + re.escape(label) + b")" + sign + digits
            replacement = encoded(f"{value:+d}".translate(fullwidth))
            text = re.sub(pattern, lambda match: match[1] + match[2] + replacement, text)
        text = self.replace_skill_lines(text, skill_lines)
        if len(text) > len(raw):
            raise ValueError("변경한 내용이 보물 설명의 저장 길이를 초과합니다.")
        return text.ljust(len(raw), b"\0") if text != original else raw

    def replace_skill_lines(self, text, skill_lines):
        lines = text.split(b"*")
        for label, name in skill_lines.items():
            prefix = self.encode_text(label)
            row = next((i for i, line in enumerate(lines) if line.startswith(prefix)), None)
            if name:
                line = prefix + b" " + self.encode_text(name)
                if row is None:
                    lines.append(line)
                else:
                    lines[row] = line
            elif row is not None:
                del lines[row]
        return b"*".join(lines)

    def save(self, number, values, picture=None, *, skills=None):
        # Serialize editor saves through the shared index without writing to it.
        with self.base.idx.open("rb") as lock:
            try:
                if os.name == "nt":
                    # Windows locks byte ranges. Ordinary buffered reads must stay clear of it.
                    lock.seek(1 << 20, io.SEEK_END)
                    msvcrt.locking(lock.fileno(), msvcrt.LK_NBLCK, 1)
                else:
                    fcntl.flock(lock, fcntl.LOCK_EX | fcntl.LOCK_NB)
            except OSError as error:
                raise ValueError("다른 보물 편집기가 파일을 저장하고 있습니다. 잠시 후 다시 시도해 주세요.") from error
            return self._save(number, values, picture, skills or {})

    def skill_changes(self, number, edits):
        lines = {number: {}}
        replacements = []
        regular = edits.get(("regular", number))
        if regular is not None:
            lines[number]["특기:"] = self.skills[regular] if regular else ""
        exclusive = edits.get(("exclusive", number))
        if exclusive is not None:
            lines[number][f"{self.owner(number)} 전용 특기:"] = self.skills[exclusive] if exclusive else ""
        for key in self.gear_by_item.get(number, ()):
            row = self.gear_rows[key]
            awaken, shared = edits.get(("awaken", key)), edits.get(("shared", key))
            star = int(row["star"])
            if awaken is not None:
                replacements.append((*row.span("awaken"), str(awaken).encode("ascii")))
                if not int(row["shared"]):
                    lines[number]["각성 특기:"] = self.skills[awaken] if awaken else ""
            if shared is not None:
                raw = str(shared).encode("ascii")
                if row["override"] is None:
                    end = row.end("shared")
                    replacements.append((end, end, b"," + raw))
                else:
                    replacements.append((*row.span("override"), raw))
            if int(row["shared"]) and (awaken is not None or shared is not None):
                owner_line = f"{self.gear_owner(row)}이 들면:"
                old_shared = int(row["override"] or row["shared"])
                shared_id = old_shared if shared is None else shared
                awaken_id = int(row["awaken"]) if awaken is None else awaken
                normal_name = self.base.skills.get(shared_id, "") if shared_id else ""
                star_names = [normal_name] if normal_name else []
                if awaken_id:
                    star_names.append(f"각성 특기 {self.base.skills[awaken_id]}")
                if shared is not None:
                    lines.setdefault(int(row["normal"]), {})[owner_line] = normal_name
                if star:
                    lines.setdefault(star, {})[owner_line] = " · ".join(star_names)
        gear = self.gear_raw
        for start, end, value in sorted(replacements, reverse=True):
            gear = gear[:start] + value + gear[end:]
        return lines, gear

    def _save(self, number, values, picture, skills):
        treasure = self.entries[number]
        if any(offset not in STAT_NAMES or type(value) is not int or not -32768 <= value <= 32767
               for offset, value in values.items()):
            raise ValueError("능력치는 -32768에서 32767 사이의 정수로 입력해 주세요.")
        before = self.stats(number)
        edited = {offset: value for offset, value in values.items() if before[offset] != value}
        fields = self.skill_fields(number)
        if any(key not in fields or type(value) is not int
               or (value not in self.skills and value != fields[key][1]) for key, value in skills.items()):
            raise ValueError("이 보물에서 사용할 수 있는 특기를 선택해 주세요.")
        skills = {key: value for key, value in skills.items() if value != fields[key][1]}
        skill_lines, gear = self.skill_changes(number, skills)
        exclusive = skills.get(("exclusive", number))
        regular = skills.get(("regular", number))
        changes = []
        pairs = self.edited | {(number, offset) for offset in edited}
        history = self.skill_history.copy()
        if regular is not None:
            pairs.add((number, REGULAR_OFFSET))
            # Old saves still store the previously shipped default in the item record.
            previous = {struct.unpack_from("<h", self.record(game, number), REGULAR_OFFSET)[0]
                        for game in self.games.values()}
            history[number] = history.get(number, set()) | previous
        if exclusive is not None:
            pairs.add((number, EXCLUSIVE_OFFSET))
        if edited or skills:
            stat_raw = self.stat_file.read_bytes() if self.stat_file.exists() else None
            if stat_raw != self.stat_raw or self.gear_path.read_bytes() != self.gear_raw:
                raise ValueError("보물 편집 데이터가 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
            for game in self.games.values():
                if game.path.read_bytes() != game.raw or game.idx.read_bytes() != game.index:
                    raise ValueError("기본 데이터가 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
                raw = bytearray(game.raw)
                for item, lines in skill_lines.items():
                    start = game.offsets[3] + item * ITEM_SIZE + 16
                    raw[start:start + 200] = self.update_description(raw[start:start + 200],
                                                                     edited if item == number else {}, lines)
                start = game.offsets[3] + number * ITEM_SIZE
                for offset, value in edited.items():
                    struct.pack_into("<h", raw, start + offset, value)
                if regular is not None:
                    struct.pack_into("<h", raw, start + REGULAR_OFFSET, regular)
                if exclusive is not None:
                    struct.pack_into("<h", raw, start + EXCLUSIVE_OFFSET, exclusive)
                if raw != game.raw:
                    changes.append((game.path, raw, False))
        if pairs != self.edited or history != self.skill_history:
            rows = []
            for item, offset in sorted(pairs):
                previous = sorted(history[item]) if offset == REGULAR_OFFSET else []
                rows.append(" ".join(map(str, (item, offset, *previous))))
            stat_raw = ("\n".join(rows) + "\n").encode("ascii")
            changes.append((self.stat_file, stat_raw, False))
        if gear != self.gear_raw:
            changes.append((self.gear_path, gear, False))
        if picture is not None:
            if picture.size != ART_SIZE or picture.mode != "RGBA" or not picture.getchannel("A").getbbox():
                raise ValueError("보이는 부분이 있는 128×128 RGBA 이미지가 필요합니다.")
            self.archive.check_unchanged()
            cells = [encode(picture)]
            if not treasure.awakened:
                silhouette = Image.new("RGBA", ART_SIZE, (52, 46, 40))
                silhouette.putalpha(picture.getchannel("A"))
                cells.extend((self.archive.cell(treasure.picture + 1), encode(silhouette)))
            changes.extend(self.archive.replace(treasure.picture, cells))
        if changes:
            if self.catalog.read_bytes() != self.catalog_raw:
                raise ValueError("보물 목록이 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
            replace_files(changes)
        return bool(changes)
