"""Edit the shared troop schema while preserving each campaign's other data."""

import struct
import sys
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parents[1] / "officer-editor"))
from data import CAMPAIGNS, TROOP_SIZE, Game, replace_files

from usages import find_battle_usages


GENERAL = {
    116: "책략 성장", 122: "이동 애니메이션 속도", 124: "기본 병력",
    126: "병력 성장", 128: "공격 보정", 130: "방어 보정",
    132: "이동력", 133: "공격 범위", 134: "반격 가능",
    135: "반격 받음", 136: "사용 가능", 172: "원거리", 174: "기마",
}
ART = {
    118: "이동 효과음 번호", 120: "공격 효과음 번호", 138: "초급 조형",
    140: "중급 조형", 142: "고급 조형", 144: "적군 조형 오프셋",
    146: "우군 조형 오프셋", 148: "아군 조형 오프셋",
}
COUNTERS = {150 + i * 2: f"상성 대상 {i + 1}" for i in range(9)}
# Same order and Korean names as War.DX in script/jymain.lua.
TERRAIN = dict(enumerate((
    "평원", "삼림", "산지", "하천", "교량", "성벽", "성지", "초원", "마을", "절벽",
    "성문", "황무지", "울타리", "성채", "병영", "군량고", "보물고", "가옥", "화염", "탁류",
), 176))
STRATEGIES = range(196, 232)
NUMERIC = set(GENERAL) | set(ART) | set(COUNTERS) | set(TERRAIN) | set(STRATEGIES)
BYTE = set(range(132, 136)) | set(range(176, 232))


class TroopProject:
    def __init__(self, root):
        self.root = root
        self.games = {story: Game(root, slug) for story, slug in CAMPAIGNS.items()}
        self.base = next(iter(self.games.values()))
        self.base_count = (self.base.offsets[2] - self.base.offsets[1]) // TROOP_SIZE
        if any(game.offsets[:3] != self.base.offsets[:3] for game in self.games.values()):
            raise ValueError("이야기별 병종 표 구조가 서로 달라 공통 저장할 수 없습니다.")
        self.strategies = self.base.names(4, 30)
        self.characters = {}
        for code, decoded in self.base.chars.items():
            if len(code) == 2 and len(decoded) == 1:
                self.characters.setdefault(decoded, code)

    @property
    def troops(self):
        return self.base.troops

    def row(self, troop):
        start = troop * TROOP_SIZE
        return self.base.troop_data[start:start + TROOP_SIZE]

    def fields(self, row):
        return (self.base.decode(row[2:16]), self.base.decode(row[16:116]),
                {i: row[i] if i in BYTE else struct.unpack_from("<h", row, i)[0] for i in NUMERIC})

    def encode(self, value, size, label):
        raw = bytearray()
        for character in value:
            if character == "\n" and label == "설명":
                character = "*"
            if character.isascii() and character.isprintable():
                raw.extend(character.encode("ascii"))
            elif character in self.characters:
                raw.extend(self.characters[character])
            else:
                raise ValueError(f"{label}: 게임 글꼴에 없는 글자입니다 ({character}).")
        if len(raw) > size:
            raise ValueError(f"{label}: 게임에서 저장할 수 있는 길이는 {size}바이트입니다.")
        return bytes(raw).ljust(size, b"\0")

    def encode_fields(self, row, name, description, values):
        before_name, before_description, before_values = self.fields(row)
        if not name.strip():
            raise ValueError("병종 이름을 입력해 주세요.")
        out = bytearray(row)
        if name != before_name:
            out[2:16] = self.encode(name, 14, "이름")
        if description != before_description:
            out[16:116] = self.encode(description, 100, "설명")
        for offset, value in values.items():
            if value == before_values[offset]:
                continue
            if offset in (134, 135, 136, 172, 174):
                valid = value in (0, 1)
            elif offset == 133:
                valid = 0 <= value <= 26
            elif offset in COUNTERS:
                valid = value == 0 or value in self.troops
            else:
                valid = (0 <= value <= 127) if offset in BYTE else (-32768 <= value <= 32767)
            if not valid:
                label = GENERAL.get(offset) or ART.get(offset) or COUNTERS.get(offset) or TERRAIN.get(offset)
                raise ValueError(f"{label or '책략 습득 레벨'}에 사용할 수 없는 값입니다 ({value}).")
            struct.pack_into("<B" if offset in BYTE else "<h", out, offset, value)
        if any(values.get(i, before_values[i]) != before_values[i] for i in range(138, 150, 2)):
            archive = self.base.archives["전투"]
            pictures = struct.unpack_from("<6h", out, 138)
            for picture in pictures[:3]:
                for offset in pictures[3:]:
                    if not any(archive.present(picture + offset + frame) for frame in (16, 17, 18, 19)):
                        raise ValueError(f"전투 조형 #{picture + offset}을 찾을 수 없습니다. 등급별 조형과 진영 오프셋을 확인해 주세요.")
        return bytes(out)

    def usages(self, troop):
        found = []
        officer_troops = {}
        for story, game in self.games.items():
            rows = {pid: game.value(pid, 64) for pid in range((game.offsets[1] - game.offsets[0]) // 152)}
            officer_troops[game.campaign] = rows
            for pid, name in game.people.items():
                if rows[pid] == troop:
                    found.append(f"{story} · 무장 #{pid} {name}")
        found.extend(sorted(find_battle_usages(self.base.folder / "script", officer_troops).get(troop, ())))
        for other, name in self.troops.items():
            if other != troop and troop in struct.unpack_from("<9h", self.row(other), 150):
                found.append(f"병종 상성 · #{other} {name}")
        # Equipment and promotion manuals can require a particular class.
        for story, game in self.games.items():
            for i, start in enumerate(range(game.offsets[3], game.offsets[4], 274)):
                if troop in struct.unpack_from("<7h", game.raw, start + 236):
                    name = game.decode(game.raw[start + 2:start + 16])
                    if name:
                        found.append(f"{story} · 장비·도구 #{i} {name}")
        return found

    def next_id(self):
        return len(self.base.troop_data) // TROOP_SIZE

    def clone(self, troop):
        new = self.next_id()
        if new > 32767:
            raise ValueError("추가할 수 있는 병종 번호가 남아 있지 않습니다.")
        copy = bytearray(self.row(troop))
        struct.pack_into("<h", copy, 0, new)
        copy[2:16] = self.encode(f"새 병종 {new}", 14, "이름")
        struct.pack_into("<h", copy, 136, 1)
        return new, bytes(copy)

    def save(self, troop, row, delete=False):
        if troop == 0 or (troop not in self.troops and troop != self.next_id()):
            raise ValueError("편집할 수 없는 병종 번호입니다.")
        if len(row) != TROOP_SIZE or struct.unpack_from("<h", row)[0] != troop:
            raise ValueError("병종 번호 또는 데이터 길이가 올바르지 않습니다.")
        for game in self.games.values():
            if game.path.read_bytes() != game.raw or game.idx.read_bytes() != game.index:
                raise ValueError("기본 데이터가 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
        for path, raw in ((self.base.extra_troops_path, self.base.extra_troops),
                          (self.base.deleted_troops_path, self.base.deleted_troops_raw)):
            if (path.read_bytes() if path.exists() else b"") != raw:
                raise ValueError("공통 병종 데이터가 외부에서 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
        changes = []
        if delete:
            if troop not in self.troops or self.usages(troop):
                raise ValueError("사용 중이거나 이미 삭제된 병종은 삭제할 수 없습니다.")
            row = bytearray(row)
            struct.pack_into("<h", row, 136, 0)
            deleted = self.base.deleted_troops | {troop}
            hidden = "".join(f"{number}\n" for number in sorted(deleted)).encode("ascii")
            changes.append((self.base.deleted_troops_path, hidden, False))
        if troop < self.base_count:
            for game in self.games.values():
                start = game.offsets[1] + troop * TROOP_SIZE
                raw = game.raw[:start] + row + game.raw[start + TROOP_SIZE:]
                if raw != game.raw:
                    changes.append((game.path, raw, False))
        else:
            start = (troop - self.base_count) * TROOP_SIZE
            data = self.base.extra_troops
            new = data[:start] + row + data[start + TROOP_SIZE:]
            if new != data:
                changes.append((self.base.extra_troops_path, new, False))
        if changes:
            replace_files(changes)
