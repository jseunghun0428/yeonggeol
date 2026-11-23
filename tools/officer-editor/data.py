"""Readers and writers for the game's newgame tables and picture archives."""

import io
import os
import shutil
import struct
import tempfile
from dataclasses import dataclass
from pathlib import Path

from PIL import Image, ImageOps


CAMPAIGNS = {
    "영걸전": "",
    "무제전": "wuje",
    "손견전": "sunjian",
    "원소전": "yuanshao",
}
STATS = {
    48: ("무력", 100), 50: ("지력", 100), 52: ("통솔", 100),
    60: ("용맹", 9), 62: ("냉정", 9),
}
SKILLS = {138: "천부", **{140 + i * 2: f"특기 {i + 1}" for i in range(6)}}
ASSETS = {"얼굴": "hdgrp", "평상시": "smap", "전투": "wmap"}
TROOP_SIZE = 232
EXTRA_TROOPS = "officer_troops.grp"
DELETED_TROOPS = "officer_troops_deleted.txt"
ART_COUNTS = {"얼굴": 1, "평상시": 4, "전투": 46}
INPUTS = {
    "얼굴": (("face", 64, 80, "초상화 한 장"),),
    "평상시": (("1", 48, 192, "전면, 48×64 프레임 3장부터"),
              ("2", 48, 192, "후면, 48×64 프레임 3장부터")),
    "전투": (("MOV", 48, 528, "이동·대기, 48×48 프레임 11장"),
            ("SPC", 48, 240, "특수 동작, 48×48 프레임 5장"),
            ("ATK", 64, 768, "공격, 64×64 프레임 12장")),
}
MOV = {0: 0, 1: 1, 4: 2, 5: 3, 8: 4, 9: 5, 12: -5, 13: -6,
       16: 6, 17: 7, 18: 8, 19: -9, 20: 9, 21: 10}
SPC = {22: 0, 23: 1, 24: 2, 25: -3, 26: 3, 27: -4, 28: 4}


@dataclass
class BattleAssignment:
    troop: int
    shared: bool
    art: int | list


def integers(raw):
    return [row[0] for row in struct.iter_unpack("<I", raw)]


class Archive:
    def __init__(self, folder, stem):
        self.idx = folder / f"{stem}.idx"
        self.grp = folder / f"{stem}.grp"
        self.index = self.idx.read_bytes()
        self.ends = [0, *integers(self.index)]
        stat = self.grp.stat()
        self.size, self.modified = stat.st_size, stat.st_mtime_ns
        if self.ends != sorted(self.ends) or self.ends[-1] != self.size:
            raise ValueError(f"{stem}: 그림 인덱스와 그림 파일이 일치하지 않습니다.")

    def present(self, index):
        return 0 <= index < len(self.ends) - 1 and self.ends[index] != self.ends[index + 1]

    def cell(self, index):
        if not self.present(index):
            return b""
        with self.grp.open("rb") as file:
            file.seek(self.ends[index])
            return file.read(self.ends[index + 1] - self.ends[index])

    def append(self, start, cells):
        count = len(self.ends) - 1
        if start < count:
            raise ValueError("이미 사용 중인 조형 번호입니다.")
        data = b"".join(cells)
        end = self.size
        offsets = [end] * (start - count)
        for cell in cells:
            end += len(cell)
            offsets.append(end)
        index = self.index + struct.pack(f"<{len(offsets)}I", *offsets)
        return [(self.grp, data, True), (self.idx, index, False)]

    def check_unchanged(self):
        stat = self.grp.stat()
        if self.idx.read_bytes() != self.index or (stat.st_size, stat.st_mtime_ns) != (self.size, self.modified):
            raise ValueError("그림 파일이 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")

    def replace(self, start, cells):
        end = start + len(cells)
        if start < 0 or end >= len(self.ends):
            raise ValueError("교체할 조형 범위가 그림 파일에 없습니다.")
        original = self.grp.read_bytes()
        offsets = self.ends[1:start + 1]
        cursor = self.ends[start]
        for cell in cells:
            cursor += len(cell)
            offsets.append(cursor)
        shift = cursor - self.ends[end]
        offsets.extend(offset + shift for offset in self.ends[end + 1:])
        data = original[:self.ends[start]] + b"".join(cells) + original[self.ends[end]:]
        return [(self.grp, data, False), (self.idx, struct.pack(f"<{len(offsets)}I", *offsets), False)]


def encode(image):
    result = io.BytesIO()
    image.save(result, format="PNG")
    return result.getvalue()


def read_sheet(path, width, height, city):
    with Image.open(path) as source:
        if source.format not in {"BMP", "PNG"} or getattr(source, "n_frames", 1) != 1:
            raise ValueError(f"{path.name}: BMP 또는 단일 이미지 PNG만 등록할 수 있습니다.")
        actual_w, actual_h = source.size
        height_ok = actual_h >= height and actual_h % 64 == 0 if city else actual_h == height
        if actual_w != width or not height_ok:
            expected = f"{width}×{height} 이상(높이 64의 배수)" if city else f"{width}×{height}"
            raise ValueError(f"{path.name}: {expected} 규격이 필요합니다. 현재 {actual_w}×{actual_h}입니다.")
        source.verify()
    with Image.open(path) as source:
        image = source.convert("RGBA").crop((0, 0, width, height))
        if source.format == "BMP" or ("A" not in source.mode and "transparency" not in source.info):
            key = image.getpixel((0, 0))[:3]
            image.putdata([
                (0, 0, 0, 0) if pixel[:3] == key or (pixel[0] > 230 and pixel[1] < 20 and pixel[2] > 230)
                else pixel for pixel in image.getdata()
            ])
        if not image.getchannel("A").getbbox():
            raise ValueError(f"{path.name}: 보이는 이미지가 없습니다.")
        return image


def import_cells(kind, selection):
    if kind == "얼굴":
        return [encode(read_sheet(selection, 64, 80, False))]
    files = {path.name.casefold(): path for path in selection.iterdir() if path.is_file()}
    images = []
    for stem, width, height, role in INPUTS[kind]:
        matches = [files[name] for name in (f"{stem.casefold()}.bmp", f"{stem.casefold()}.png") if name in files]
        if len(matches) != 1:
            raise ValueError(f"{role}에 쓸 {stem}.bmp 또는 {stem}.png 파일이 정확히 하나 필요합니다.")
        images.append(read_sheet(matches[0], width, height, kind == "평상시"))
    if kind == "평상시":
        front, back = images
        return [encode(image) for image in (back, front, ImageOps.mirror(back), ImageOps.mirror(front))]
    cells = [b""] * 50
    attack = {30 + i: i for i in range(12)}
    attack.update({42 + i: -(9 + i) for i in range(4)})
    for sheet, frames in zip(images, (MOV, SPC, attack)):
        width = sheet.width
        for slot, frame in frames.items():
            index = frame if frame >= 0 else -frame - 1
            image = sheet.crop((0, index * width, width, (index + 1) * width))
            cells[slot] = encode(ImageOps.mirror(image) if frame < 0 else image)
    return cells


def replace_files(changes):
    """Stage every write first; restore replaced files if a later write fails."""
    with tempfile.TemporaryDirectory(prefix=".officer-editor-", dir=changes[0][0].parent) as temp:
        staged = []
        for i, (target, data, append) in enumerate(changes):
            old, new = Path(temp) / f"{i}.old", Path(temp) / f"{i}.new"
            if target.exists():
                shutil.copyfile(target, old)
            with new.open("wb") as stream:
                if append:
                    with old.open("rb") as original:
                        shutil.copyfileobj(original, stream)
                stream.write(data)
                stream.flush()
                os.fsync(stream.fileno())
            staged.append((target, old, new))
        done = []
        try:
            for target, old, new in staged:
                os.replace(new, target)
                done.append((target, old))
        except OSError:
            for target, old in reversed(done):
                if old.exists():
                    os.replace(old, target)
                else:
                    target.unlink()
            raise


class Game:
    def __init__(self, root, campaign):
        self.campaign = campaign
        self.folder = root / "yeonggeol"
        folder = self.folder / "data"
        self.idx = folder / "newgame.idx"
        self.index = self.idx.read_bytes()
        self.path = (folder / "camp" / campaign if campaign else folder) / "newgame.grp"
        self.raw = self.path.read_bytes()
        self.offsets = integers(self.index)
        if (len(self.offsets) != 8 or self.offsets != sorted(self.offsets)
                or self.offsets[6] != len(self.raw)
                or any((self.offsets[i + 1] - self.offsets[i]) % stride
                       for i, stride in ((0, 152), (1, 232), (5, 228)))):
            raise ValueError("이 프로젝트의 기본 무장 데이터 형식을 확인할 수 없습니다.")
        table = (self.folder / "hzmb.dat").read_bytes()
        self.chars = {}
        # Later fallback entries can repeat a code with a non-Korean character.
        for i in range(0, len(table), 6):
            code = table[i:i + 2]
            self.chars.setdefault(code, table[i + 4:i + 6].decode("utf-16-le", errors="replace"))
        self.people = {i: name for i in range(1, (self.offsets[1] - self.offsets[0]) // 152)
                       if (name := self.decode(self.raw[self.offset(i) + 10:self.offset(i) + 24]))}
        self.extra_troops_path = folder / EXTRA_TROOPS
        self.extra_troops = self.extra_troops_path.read_bytes() if self.extra_troops_path.exists() else b""
        if len(self.extra_troops) % TROOP_SIZE:
            raise ValueError("추가 병종 데이터의 길이가 올바르지 않습니다.")
        self.deleted_troops_path = folder / DELETED_TROOPS
        self.deleted_troops_raw = self.deleted_troops_path.read_bytes() if self.deleted_troops_path.exists() else b""
        self.deleted_troops = set(map(int, self.deleted_troops_raw.split()))
        self.troop_data = self.raw[self.offsets[1]:self.offsets[2]] + self.extra_troops
        self.troops = {i: name for i, start in enumerate(range(0, len(self.troop_data), TROOP_SIZE))
                       if i not in self.deleted_troops and (name := self.decode(self.troop_data[start + 2:start + 16]))}
        self.skills = self.names(5, 228)
        self.skills[0] = "없음"
        self.archives = {kind: Archive(folder, stem) for kind, stem in ASSETS.items()}
        self.flags_path = self.path.with_name("officer_overrides.txt")
        self.awakening_path = self.path.with_name("officer_awake.txt")
        self.awakening_raw = self.awakening_path.read_bytes() if self.awakening_path.exists() else None
        self.awakening_edits = {}
        for line in (self.awakening_raw or b"").splitlines():
            pid, *skills = map(int, line.split())
            self.awakening_edits[pid] = tuple(skills)
        self.awakening = None
        self.battle_path = self.path.with_name("officer_war.txt")
        self.battle_raw = self.battle_path.read_bytes() if self.battle_path.exists() else None
        self.battle_slots = {}
        for line in (self.battle_raw or b"").splitlines():
            pid, troop, slot, order = map(int, line.split())
            self.battle_slots[pid, troop] = slot, order
        self.flags_raw = self.flags_path.read_bytes() if self.flags_path.exists() else None
        self.flags = {}
        for line in (self.flags_raw or b"").splitlines():
            pid, mask, war = map(int, line.split())
            self.flags[pid] = mask, war

    def decode(self, raw):
        text = []
        while raw and raw[0]:
            size = 2 if raw[0] >= 128 else 1
            token, raw = raw[:size], raw[size:]
            text.append(self.chars.get(token, token.decode("ascii", errors="replace")))
        return "".join(text).strip()

    def names(self, section, size):
        base = self.offsets[section]
        return {i: name for i, start in enumerate(range(base, self.offsets[section + 1], size))
                if (name := self.decode(self.raw[start + 2:start + 16]))}

    def skill_description(self, skill):
        if skill == 0:
            return "배정된 특기가 없습니다."
        if skill in self.skills:
            start = self.offsets[5] + skill * 228
            description = self.decode(self.raw[start + 16:start + 216])
            if description:
                return description.replace("*", "\n")
        return "등록된 설명이 없습니다."

    def awakening_skills(self, pid):
        if self.awakening is None:
            from awakening import Awakening
            self.awakening = Awakening(self)
        base = self.awakening.skills.get(pid)
        return self.awakening_edits.get(pid, base) if base is not None else None

    def offset(self, pid):
        return self.offsets[0] + pid * 152

    def value(self, pid, offset):
        return struct.unpack_from("<h", self.raw, self.offset(pid) + offset)[0]

    def appearance(self, pid, kind):
        if kind == "얼굴":
            return self.value(pid, 6)
        if kind == "평상시":
            return self.value(pid, 2)
        return self.flags.get(pid, (0, -1))[1]

    def choices(self, kind):
        archive = self.archives[kind]
        count = len(archive.ends) - 1
        if kind == "얼굴":
            choices = {i: f"얼굴 {i}" for i in range(count) if archive.present(i)}
        elif kind == "평상시":
            choices = {i: f"평상시 {i}" for i in range((count - 200) // 4)
                       if all(archive.present(200 + i * 4 + d) for d in range(4))}
        else:
            choices = {i: f"전투 {i}" for i in range(20, count - 45)
                       if i % 50 == (20 if i < 20000 else 0)
                       and all(archive.present(i + d) for d in (0, 16, 17, 18, 19))}
        names = {}
        for pid, name in self.people.items():
            slot = self.appearance(pid, kind)
            if slot in choices:
                names.setdefault(slot, set()).add(name)
        for slot, labels in names.items():
            if len(labels) <= 3:
                choices[slot] = ", ".join(sorted(labels))
        return choices

    def preview(self, kind, slot):
        frames = {"얼굴": (slot,), "평상시": tuple(200 + slot * 4 + i for i in range(4)),
                  "전투": (slot + 19, slot + 18, slot + 30, slot + 34)}
        return [self.archives[kind].cell(frame) for frame in frames[kind]]

    def original_art_path(self, kind, slot):
        return self.folder.parent / ".officer-editor-originals" / f"{ASSETS[kind]}-{slot}.bin"

    def revise_art(self, kind, slot, cells=None):
        archive = self.archives[kind]
        archive.check_unchanged()
        start = 200 + slot * 4 if kind == "평상시" else slot
        count = ART_COUNTS[kind]
        if start < 0 or start + count >= len(archive.ends) or not archive.present(start):
            raise ValueError("교체할 기존 조형이 그림 파일에 없습니다.")
        if kind == "전투" and slot % 50 != (20 if slot < 20000 else 0):
            raise ValueError("이 전투 조형은 다른 조형과 겹칠 수 있어 교체할 수 없습니다.")
        backup = self.original_art_path(kind, slot)
        changes = []
        if cells is None:
            raw = backup.read_bytes()
            offsets = [0, *integers(raw[:count * 4])]
            contents = raw[count * 4:]
            if len(offsets) != count + 1 or offsets != sorted(offsets) or offsets[-1] != len(contents):
                raise ValueError("최초 교체 전 원본 파일을 읽을 수 없습니다.")
            cells = [contents[a:b] for a, b in zip(offsets, offsets[1:])]
        elif not backup.exists():
            offsets = []
            for i in range(count):
                index = start + i + 1
                if not 0 < index < len(archive.ends):
                    raise ValueError("교체할 조형 범위가 그림 파일에 없습니다.")
                offsets.append(archive.ends[index] - archive.ends[start])
            original = b"".join(archive.cell(start + i) for i in range(count))
            backup.parent.mkdir(parents=True, exist_ok=True)
            changes.append((backup, struct.pack(f"<{count}I", *offsets) + original, False))
        if len(cells) < count:
            raise ValueError("교체할 조형 프레임이 부족합니다.")
        changes.extend(archive.replace(start, cells[:count]))
        replace_files(changes)
        self.archives[kind] = Archive(archive.grp.parent, ASSETS[kind])

    def awakening_change(self, pid, skills):
        if (self.path.read_bytes() != self.raw
                or (self.awakening_path.read_bytes() if self.awakening_path.exists() else None) != self.awakening_raw):
            raise ValueError("각성 특기가 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
        if self.awakening_skills(pid) is None or any(skill <= 0 or skill not in self.skills for skill in skills):
            raise ValueError("이 무장에 지정할 수 없는 각성 특기입니다.")
        edits = dict(self.awakening_edits)
        if tuple(skills) == self.awakening.skills[pid]:
            edits.pop(pid, None)
        else:
            edits[pid] = tuple(skills)
        if edits != self.awakening_edits:
            contents = "".join(" ".join(map(str, (officer, *values))) + "\n"
                               for officer, values in sorted(edits.items()))
            return self.awakening_path, contents.encode("ascii"), False

    def save(self, pid, fields, art, battle_edits=(), awakening=None, linked_awakenings=()):
        fields = dict(fields)
        if (self.path.read_bytes() != self.raw or self.idx.read_bytes() != self.index
                or (self.flags_path.read_bytes() if self.flags_path.exists() else None) != self.flags_raw
                or (self.battle_path.read_bytes() if self.battle_path.exists() else None) != self.battle_raw):
            raise ValueError("기본 데이터가 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
        changes = []
        edits = list(linked_awakenings)
        if awakening is not None:
            edits.append((self, pid, awakening))
        for game, officer, skills in edits:
            change = game.awakening_change(officer, skills)
            if change is not None:
                changes.append(change)
        mask, war = self.flags.get(pid, (0, -1))
        battle = dict(self.battle_slots)
        war_archive = self.archives["전투"]
        war_start = (max(61000, len(war_archive.ends) - 1) + 49) // 50 * 50
        war_cells = []
        bits = {2: 1, 6: 2, 64: 4, **dict.fromkeys(STATS, 8), **dict.fromkeys(SKILLS, 16)}
        for kind, selection in (*art.items(), *(("전투", edit) for edit in battle_edits)):
            assignment = selection if isinstance(selection, BattleAssignment) else None
            if assignment is not None:
                selection = assignment.art
            if isinstance(selection, list):
                archive = self.archives[kind]
                archive.check_unchanged()
                count = len(archive.ends) - 1
                if kind == "얼굴":
                    start = slot = count
                elif kind == "평상시":
                    # In-game private officer slots occupy the lower end of this shared archive.
                    slot = (max(90000, count) - 200 + 3) // 4
                    start = 200 + slot * 4
                else:
                    slot = war_start + len(war_cells)
                    if len(selection) != 50:
                        raise ValueError("전투 조형은 50칸 단위로 저장해야 합니다.")
                    if slot + 50 > 1_000_000:
                        raise ValueError("전투 조형을 추가할 수 있는 최대 개수에 도달했습니다.")
                    war_cells.extend(selection)
                if kind != "전투":
                    changes.extend(archive.append(start, selection))
                selection = slot
            if kind == "전투":
                if assignment is None:
                    war = selection
                else:
                    troop = assignment.troop
                    if troop not in self.troops:
                        raise ValueError("적용할 병종을 선택해 주세요.")
                    key = (0 if assignment.shared else pid, troop)
                    if selection < 0:
                        battle.pop(key, None)
                    else:
                        order = max((order for _, order in battle.values()), default=0) + 1
                        battle[key] = selection, order
            else:
                fields[6 if kind == "얼굴" else 2] = selection
        if war_cells:
            changes.extend(war_archive.append(war_start, war_cells))
        raw = bytearray(self.raw)
        for offset, value in fields.items():
            if not 0 <= value <= 32767:
                raise ValueError("저장 가능한 값은 0~32767입니다.")
            if value != self.value(pid, offset) or (offset == 2 and "평상시" in art):
                struct.pack_into("<h", raw, self.offset(pid) + offset, value)
                mask |= bits[offset]
        flags = dict(self.flags)
        if mask or war >= 0:
            flags[pid] = mask, war
        else:
            flags.pop(pid, None)
        if raw != self.raw:
            changes.append((self.path, raw, False))
        if flags != self.flags:
            encoded = "".join(f"{pid} {mask} {war}\n" for pid, (mask, war) in sorted(flags.items()))
            changes.append((self.flags_path, encoded.encode("ascii"), False))
        if battle != self.battle_slots:
            encoded = "".join(f"{pid} {troop} {slot} {order}\n"
                              for (pid, troop), (slot, order) in sorted(battle.items()))
            changes.append((self.battle_path, encoded.encode("ascii"), False))
        if changes:
            replace_files(changes)
