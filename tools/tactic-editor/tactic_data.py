"""Edit shared skill and strategy records without changing section offsets."""

import bisect
import io
import json
import re
import struct
import sys
from pathlib import Path

from PIL import Image

TOOLS = Path(__file__).resolve().parents[1]
sys.path[:0] = [str(TOOLS / "troop-editor"), str(TOOLS / "officer-editor")]
from awakening import Awakening
from data import Archive, SKILLS, replace_files
from troop_data import TroopProject
from usages import COMMENTS


FIELDS = {
    "S": tuple(f"매개변수 {i}" for i in range(1, 7)),
    "M": ("책략 유형", "MP 소모", "기본 위력", "시전 범위", "효과 범위", "애니메이션", "효과음"),
}
SECTIONS = {"S": (5, 228, 216), "M": (4, 30, 16)}
EVENTS = {"S": ("턴 시작", "공격 후", "피격 후", "책략 사용 후"), "M": ("책략 적중",)}
CONDITIONS = ("항상", "자신의 병력 % 이하", "대상의 병력 % 이하", "자신의 MP % 이하", "대상이 혼란 상태",
              "대상이 중독 상태")
EFFECTS = ("병력 회복", "최대 병력 비례 회복 (%)", "병력 피해", "MP 회복", "MP 감소",
           "사기 회복", "사기 감소", "혼란 부여", "혼란 해제", "중독 부여 (턴)", "중독 해제")
TARGETS = ("자신", "대상")
STRATEGY_KINDS = ("화계", "수계", "석계", "혼란", "사기 감소", "사기 회복",
                  "병력 회복", "병력·사기 회복", "독계", "뇌계", "특수")

# Positional meanings read by the native skill formulas in jymain.lua.
SKILL_PARAMETERS = {
    1: ("인덕 습득 레벨", "대덕 습득 레벨"),
    2: ("병력 회복 배율 (%)", "사기 회복 배율 (%)"),
    3: ("수신 책략 습득 레벨",),
    4: ("화신 책략 습득 레벨",),
    6: ("기본 병력 증가", "레벨당 병력 증가"),
    7: ("최대 사기",),
    8: ("레벨당 공격력 증가",),
    9: ("레벨당 방어력 증가",),
    10: ("이동력 증가",),
    11: ("수계 피해 증가 (%)",),
    12: ("화계 피해 증가 (%)",),
    13: ("받는 화계 피해 감소 (%)",),
    14: ("석계 피해 증가 (%)",),
    15: ("석계 혼란 확률 (%)",),
    16: ("받는 공격 책략 피해 감소 (%)",),
    17: ("책략 성공 계산 지력 배율 (%)",),
    18: ("상대 책략 성공 계산 저항 배율 (%)",),
    19: ("반격 확률에 쓰는 무력 배율 (%)",),
    20: ("사기 회복 배율 (%)",),
    21: ("석계 피해·매복 공격 보정 (%)",),
    22: ("병력 회복 배율 (%)",),
    23: ("받는 물리 피해 감소 (%)", "받는 화계 피해 증가 (%)"),
    24: ("레벨당 원거리 병종 공격·방어 증가",),
    25: ("레벨당 기마 병종 공격·방어 증가",),
    26: ("병력 손실 구간 (%)", "구간당 방어 보정 (%)"),
    27: ("병력 손실 구간 (%)", "구간당 공격 보정 (%)"),
    28: ("병력 손실 구간 (%)", "구간당 공격·방어 보정 (%)"),
    29: ("공격 보정 감소 (%)", "방어 보정 증가 (%)"),
    30: ("레벨당 공격·방어 증가",),
    31: ("최소 사기",),
    32: ("특정 지형 공격 보정 (%)",),
    33: ("입힌 피해 대비 병력 회복 (%)",),
    35: ("턴당 MP 회복의 레벨 계수 (%)",),
    36: ("방어 보정 (%)",),
    37: ("적중한 공격 책략 피해 감소 (%)",),
    38: ("", "팔진 책략 습득 레벨"),
    39: ("공격 책략 피해 증가 (%)", "독연 습득 레벨", "독무 습득 레벨"),
    40: ("낙뢰 습득 레벨", "대낙뢰 습득 레벨"),
    41: ("병력 회복 책략 보정 (%)",),
    43: ("한 번에 받는 피해 상한 (최대 병력 %)",),
    44: ("난사 최대 공격 횟수",),
    45: ("공격 범위 번호",),
    47: ("받는 물리 피해 감소 (%)",),
    48: ("난무 최대 공격 횟수",),
    49: ("상하좌우 적 1명당 공격·방어 보정 (%)", "대각선 적 1명당 공격·방어 보정 (%)"),
    50: ("공격 책략 피해 증가 (%)",),
    51: ("호위 범위 (칸)", "호위에 필요한 최소 병력 (%)"),
    52: ("도발 범위 (칸)", "적 AI 공격 우선도 증가"),
    104: ("한 번에 받는 피해 상한 (최대 병력 %)",),
    107: ("반격 위력 (일반 공격 대비 %)",),
    112: ("책략 MP 절감률 (%)",),
    113: ("공격 시 추가 사기 감소량",),
    115: ("치명타 최소 피해 (적 현재 병력 %)",),
    116: ("공격 후 혼란 부여 확률 (%)",),
    119: ("단일 대상 공격 책략 추가 시전 횟수",),
    120: ("중독 지속 시간 (턴)",),
    123: ("책략 위력 배율 (%)", "책략 추가 시전 횟수"),
    130: ("공격할 추가 대상 수 상한",),
    131: ("아군 사기 회복 범위 (칸)", "턴당 사기 회복량"),
}
RECOVERY_PARAMETERS = {2: (0, 1), 20: (0,), 22: (0,)}
SKILL_VALUE_DEFAULTS = {
    **{number: {index: 100 for index in indices} for number, indices in RECOVERY_PARAMETERS.items()},
    113: {0: 10},
}
# Newly connected fields opt in with a negative stored value. Existing raw
# values in those fields were unused and retain the original combat defaults.
SKILL_SETTINGS = {
    17: ((200, 1, 1000),),
    18: ((200, 0, 1000),),
    19: ((100, 0, 1000),),
    43: ((20, 0, 100),),
    51: ((2, 0, 20), (30, 0, 100)),
    52: ((3, 0, 20), (40, 0, 32767)),
    104: ((20, 0, 100),),
    107: ((100, 0, 1000),),
    112: ((50, 0, 100),),
    115: ((40, 0, 100),),
    116: ((100, 0, 100),),
    119: ((1, 0, 10),),
    120: ((3, 0, 255),),
    123: ((150, 0, 1000), (1, 0, 10)),
    130: ((60, 0, 60),),
    131: ((2, 0, 20), (5, 0, 100)),
}


def skill_description(number, description, values):
    if number in (8, 9, 30):
        return re.sub(r"\(레벨당 [+-]?\d+\)", f"(레벨당 {values[0]:+d})", description)
    if number == 32:
        return re.sub(r"\([+-]?\d+%\)", f"({values[0]:+d}%)", description)
    if number == 23:
        return f"받는 물리 피해 {values[0]}% 감소, 수계 면역\n받는 화계 피해 {values[1]}% 증가"
    if number == 19:
        return f"반격 확률을 무력의 {values[0]}%로 계산한다.\n반격할 수 있는 부대에 적용된다."
    if number == 51:
        return re.sub(r"병력 \d+% 이상", f"병력 {values[1]}% 이상",
                      re.sub(r"주위 \d+칸", f"주위 {values[0]}칸", description))
    if number in (52, 131):
        text = re.sub(r"주위 \d+칸", f"주위 {values[0]}칸", description)
        return re.sub(r"사기(?:를)? \d+", f"사기를 {values[1]}", text) if number == 131 else text
    if number == 104:
        return re.sub(r"최대 병력의 (?:1/5|\d+%)", f"최대 병력의 {values[0]}%", description)
    if number == 107:
        return f"반격 위력은 일반 공격의 {values[0]}%.\n반격할 수 있는 부대에 적용된다."
    if number == 112:
        return f"책략을 쓸 때 소모하는 책략치가 {values[0]}% 감소한다."
    if number == 116:
        return f"공격 후 적 부대를 {values[0]}% 확률로 혼란시킨다."
    if number == 119:
        return f"단일 대상 공격 책략을 {values[0]}회 추가 시전한다."
    if number == 120:
        return re.sub(r"\d+턴 동안", f"{values[0]}턴 동안", description)
    if number == 123:
        return f"책략 위력은 기본의 {values[0]}%.\n책략을 {values[1]}회 추가 시전한다."
    if number == 130:
        return f"공격하면 범위 안의 다른 적 최대 {values[0]}명을 한 번씩 더 공격한다."
    return description

SCRIPT_REFS = {
    "S": re.compile(rb"\b(?:WarCheckSkill|CheckSkill|koHasSkill|koAwakeHas)\s*\([^,\r\n]+,\s*(\d+)\b|\bJY\.Skill\s*\[\s*(\d+)\s*\]|\[\s*(?:TF|SP\s*\.\.\s*[\w\"']+)\s*\]\s*=(?!=)\s*(\d+)\b"),
    "M": re.compile(rb"\bPlayMagic\s*\(\s*(\d+)\b|\b(?:WarHaveMagic|HaveMagic|WarMagicMenu_sub)\s*\([^,\r\n]+,\s*(\d+)\b|\b(?:WarMagic|koWarMagic2)\s*\([^,\r\n]+,[^,\r\n]+,\s*(\d+)\b|\bJY\.Magic\s*\[\s*(\d+)\s*\]"),
}


def effect_frames(data, number=None):
    try:
        with Image.open(io.BytesIO(data)) as source:
            if source.format != "PNG" or getattr(source, "n_frames", 1) != 1:
                raise ValueError("단일 PNG 이미지가 필요합니다.")
            source.load()
            width, height = source.size
            count = {241: 7, 242: 13, 243: 13}.get(number)
            if count is None:
                if height < width or height % width:
                    raise ValueError("같은 크기의 정사각형 프레임을 세로 한 열로 배치하세요.")
                count = height // width
            if height % count:
                raise ValueError("이미지 높이가 재생 프레임 수로 나누어떨어져야 합니다.")
            if number is None and count < 2:
                raise ValueError("새 이펙트에는 프레임이 두 장 이상 필요합니다.")
            rgba = source.convert("RGBA")
            if number is None and not rgba.getchannel("A").getbbox():
                raise ValueError("이펙트에 보이는 픽셀이 없습니다.")
            step = height // count
            return [rgba.crop((0, i * step, width, (i + 1) * step)) for i in range(count)]
    except (OSError, Image.DecompressionBombError) as error:
        raise ValueError("PNG 이미지를 읽을 수 없습니다.") from error


class TacticProject:
    def __init__(self, root):
        troop_project = TroopProject(root)
        self.games = troop_project.games
        self.base = troop_project.base
        self.troops = troop_project.troops
        self.troop_project = troop_project
        self.archives = {story: Archive(game.path.parent, "mmap") for story, game in self.games.items()}
        self.rule_path = self.base.path.with_name("tactic_rules.txt")
        self.desc_path = self.base.path.with_name("tactic_descriptions.json")
        self.rule_raw = self.rule_path.read_bytes() if self.rule_path.exists() else b""
        self.desc_raw = self.desc_path.read_bytes() if self.desc_path.exists() else b""
        self.descriptions = json.loads(self.desc_raw) if self.desc_raw else {}
        self.deleted = set()
        self.registered = set()
        self.rules = {}
        self.learning = {}
        for line in self.rule_raw.decode("ascii").splitlines():
            tag, *parts = line.split()
            if tag == "D":
                self.deleted.add((parts[0], int(parts[1])))
            elif tag == "A":
                self.registered.add(int(parts[0]))
            elif tag == "L":
                mid, troop, level = map(int, parts)
                self.learning.setdefault(mid, {})[troop] = level
            elif tag in FIELDS:
                number, *rule = map(int, parts)
                self.rules.setdefault((tag, number), []).append(tuple(rule))
        self.script_refs = None
        self.awakenings = {}

    def row(self, game, kind, number):
        section, size, _ = SECTIONS[kind]
        start = game.offsets[section] + number * size
        return start, game.raw[start:start + size]

    def entries(self, kind):
        section, size, _ = SECTIONS[kind]
        return {number: name for number, name in self.base.names(section, size).items()
                if number and (kind, number) not in self.deleted}

    def fields(self, kind, number):
        _, row = self.row(self.base, kind, number)
        if kind == "S":
            description = self.base.decode(row[16:216]).replace("*", "\n")
        else:
            description = self.descriptions.get(str(number), "")
        return self.base.decode(row[2:16]), description, struct.unpack_from("<" + "h" * len(FIELDS[kind]), row, SECTIONS[kind][2])

    def next_id(self, kind):
        for number, name in reversed(list(self.entries(kind).items())):
            if name == "보류" and not self.usages(kind, number):
                if all(game.decode(self.row(game, kind, number)[1][2:16]) == name for game in self.games.values()):
                    return number
        raise ValueError("사용할 수 있는 보류 번호가 없습니다.")

    def skill_parameters(self, number):
        return SKILL_PARAMETERS.get(number, ())

    def skill_values(self, number):
        return self.decode_skill_values(number, self.fields("S", number)[2])

    def decode_skill_values(self, number, raw):
        values = list(raw)
        for i, default in SKILL_VALUE_DEFAULTS.get(number, {}).items():
            values[i] = values[i] - 2 if values[i] >= 2 else default
        for i, (default, _, _) in enumerate(SKILL_SETTINGS.get(number, ())):
            values[i] = -values[i] - 1 if values[i] < 0 else default
        return values

    def encode_skill_values(self, number, values):
        values = list(values)
        previous = self.skill_values(number)
        raw = self.fields("S", number)[2]
        labels = self.skill_parameters(number)
        for i in SKILL_VALUE_DEFAULTS.get(number, {}):
            if not 0 <= values[i] <= 32765:
                raise ValueError(f"{labels[i]}은 0~32765 사이로 입력하세요.")
            values[i] = raw[i] if values[i] == previous[i] else values[i] + 2
        for i, (_, minimum, maximum) in enumerate(SKILL_SETTINGS.get(number, ())):
            if not minimum <= values[i] <= maximum:
                raise ValueError(f"{labels[i]}은 {minimum}~{maximum} 사이로 입력하세요.")
            values[i] = raw[i] if values[i] == previous[i] else -values[i] - 1
        return values

    def effect_numbers(self):
        used = self.registered.copy()
        for game in self.games.values():
            for number in game.names(4, 30):
                animation = struct.unpack_from("<h", self.row(game, "M", number)[1], 26)[0]
                used.add(animation)
        return {number for number in used if all(archive.present(number) for archive in self.archives.values())}

    def load_script_refs(self):
        self.script_refs = {}
        for path in (self.base.folder / "script").rglob("*.lua"):
            rel = path.relative_to(self.base.folder)
            if "origin" in rel.parts:
                continue
            source = COMMENTS.sub(lambda match: re.sub(rb"[^\r\n]", b" ", match[0])
                                  if match[0].startswith(b"--") else match[0], path.read_bytes())
            lines = [m.start() for m in re.finditer(rb"\n", source)]
            for kind, pattern in SCRIPT_REFS.items():
                for match in pattern.finditer(source):
                    number = int(next(value for value in match.groups() if value is not None))
                    line = bisect.bisect_left(lines, match.start()) + 1
                    self.script_refs.setdefault((kind, number), []).append(f"전투·게임 스크립트 · {rel.as_posix()}:{line}")

    def usages(self, kind, number):
        if self.script_refs is None:
            self.load_script_refs()
        found = list(self.script_refs.get((kind, number), ()))
        # These IDs are also selected from hard-coded tables and ranges during battle.
        if kind == "M" and 1 <= number <= 46:
            found.append("기본 전투 규칙 · 기존 책략 선택 및 시전")
        for story, game in self.games.items():
            if kind == "S":
                for pid in range(1, (game.offsets[1] - game.offsets[0]) // 152):
                    if any(game.value(pid, offset) == number for offset in SKILLS):
                        found.append(f"{story} · 무장 #{pid} {game.people.get(pid, '')}")
                if story not in self.awakenings:
                    self.awakenings[story] = Awakening(game).skills
                for pid, skills in (self.awakenings[story] | game.awakening_edits).items():
                    if number in skills:
                        found.append(f"{story} · 각성 #{pid} {game.people.get(pid, '')}")
                for i, start in enumerate(range(game.offsets[3], game.offsets[4], 274)):
                    if any(struct.unpack_from("<h", game.raw, start + offset)[0] == number for offset in (256, 272)):
                        found.append(f"{story} · 장비 #{i} {game.decode(game.raw[start+2:start+16])}")
            elif 1 <= number <= 36:
                for troop in game.troops:
                    if game.troop_data[troop * 232 + 195 + number] > 0:
                        found.append(f"{story} · 병종 #{troop} {game.troops[troop]}")
        if kind == "M":
            for troop in self.learning.get(number, {}):
                found.append(f"공통 습득 · 병종 #{troop} {self.troops.get(troop, '')}")
        return sorted(set(found))

    def save(self, kind, number, name="", description="", values=(), rules=(), learning=None, image=None, delete=False):
        if number not in self.entries(kind):
            raise ValueError("편집할 수 없는 번호입니다.")
        for game in self.games.values():
            if game.path.read_bytes() != game.raw or game.idx.read_bytes() != game.index:
                raise ValueError("기본 데이터가 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
        for path, before in ((self.rule_path, self.rule_raw), (self.desc_path, self.desc_raw)):
            if (path.read_bytes() if path.exists() else b"") != before:
                raise ValueError("편집기 데이터가 바뀌었습니다. 프로젝트를 다시 열어 주세요.")
        key = kind, number
        deleted, descriptions = self.deleted.copy(), self.descriptions.copy()
        rule_map, levels, registered = self.rules.copy(), self.learning.copy(), self.registered.copy()
        changes = []
        if delete:
            if kind == "S":
                raise ValueError("특기의 효과 수치만 편집할 수 있습니다.")
            self.script_refs = None
            self.awakenings.clear()
            if self.usages(kind, number):
                raise ValueError("사용 중인 항목은 삭제할 수 없습니다.")
            deleted.add(key)
            rule_map.pop(key, None)
            for game in self.games.values():
                start, _ = self.row(game, kind, number)
                changes.append((game.path, game.raw[:start + 2] + bytes(14) + game.raw[start + 16:], False))
            if kind == "M":
                levels.pop(number, None)
                descriptions.pop(str(number), None)
        else:
            name = name.strip()
            if not name:
                raise ValueError("이름을 입력해 주세요.")
            if len(values) != len(FIELDS[kind]) or any(not -32768 <= value <= 32767 for value in values):
                raise ValueError("수치는 -32768~32767 범위의 정수여야 합니다.")
            if kind == "S":
                original_name, original_text, before = self.fields(kind, number)
                labels = dict(enumerate(self.skill_parameters(number)))
                if (original_name == "보류" or name != original_name
                        or any(value != before[i] and not labels.get(i) for i, value in enumerate(values))):
                    raise ValueError("특기의 효과 수치만 편집할 수 있습니다.")
                settings = self.decode_skill_values(number, values)
                for i, (_, minimum, maximum) in enumerate(SKILL_SETTINGS.get(number, ())):
                    if not minimum <= settings[i] <= maximum:
                        raise ValueError(f"{labels[i]}은 {minimum}~{maximum} 사이로 입력하세요.")
                description = skill_description(number, original_text, settings) if tuple(values) != before else original_text
            if kind == "S" and number in (26, 27, 28) and values[0] < 1:
                raise ValueError("병력 손실 구간은 1% 이상이어야 합니다.")
            previous = self.rules.get(key, ())
            if len(rules) != len(previous) or any(
                tuple(rule[i] for i in (0, 1, 3, 4)) != tuple(old[i] for i in (0, 1, 3, 4))
                or (old[1] not in (1, 2, 3) and rule[2] != old[2])
                or (old[4] in (7, 8, 10) and rule[5] != old[5])
                for old, rule in zip(previous, rules)
            ):
                raise ValueError("기존 발동 규칙의 조건 기준과 효과량만 변경할 수 있습니다.")
            for event, condition, threshold, target, effect, amount in rules:
                if (not 0 <= event < len(EVENTS[kind]) or not 0 <= condition < len(CONDITIONS)
                        or not 0 <= threshold <= 100 or not 0 <= target < len(TARGETS)
                        or not 0 <= effect < len(EFFECTS)
                        or not 0 <= amount <= {1: 100, 9: 255}.get(effect, 32767)):
                    raise ValueError("발동 규칙의 값이 올바르지 않습니다.")
            if rules:
                rule_map[key] = list(rules)
            else:
                rule_map.pop(key, None)
            values = list(values)
            if kind == "M":
                learning = learning or {}
                if any(troop not in self.troops or not 1 <= level <= 99 for troop, level in learning.items()):
                    raise ValueError("습득 병종이나 레벨이 올바르지 않습니다.")
                if learning:
                    levels[number] = learning
                else:
                    levels.pop(number, None)
                if description:
                    descriptions[str(number)] = description
                else:
                    descriptions.pop(str(number), None)
                if image is not None:
                    effect_frames(image)
                    values[5] = max(len(a.ends) - 1 for a in self.archives.values())
                    if values[5] > 32767:
                        raise ValueError("추가할 수 있는 애니메이션 번호가 없습니다.")
                    for archive in self.archives.values():
                        archive.check_unchanged()
                        changes.extend(archive.append(values[5], [image]))
                    registered.add(values[5])
                before = self.fields(kind, number)[2]
                if rules and (not 1 <= values[0] <= len(STRATEGY_KINDS) or values[3] in (0, 19, 20) or values[4] in (0, 19, 20)):
                    raise ValueError("발동 규칙을 쓰려면 책략 유형과 실제 칸이 있는 시전·효과 범위가 필요합니다.")
                if values[0] != before[0] and not 1 <= values[0] <= len(STRATEGY_KINDS):
                    raise ValueError("책략 유형을 선택해 주세요.")
                if any(value != before[i] and not 0 <= value <= 26 for i, value in enumerate(values) if i in (3, 4)):
                    raise ValueError("책략 범위 번호는 0~26입니다.")
                if image is None and values[5] != before[5] and not all(a.present(values[5]) for a in self.archives.values()):
                    raise ValueError("네 이야기 모두에 있는 이펙트를 선택해 주세요.")
                if values[1] < 0 or values[6] < 0:
                    raise ValueError("MP 소모와 효과음 번호는 0 이상이어야 합니다.")
            for game in self.games.values():
                start, old = self.row(game, kind, number)
                row = bytearray(old)
                if name != self.base.decode(old[2:16]):
                    row[2:16] = self.troop_project.encode(name, 14, "이름")
                if kind == "S" and description != self.base.decode(old[16:216]).replace("*", "\n"):
                    row[16:216] = self.troop_project.encode(description.replace("\n", "*"), 200, "설명")
                struct.pack_into("<" + "h" * len(values), row, SECTIONS[kind][2], *values)
                if row != old:
                    changes.append((game.path, game.raw[:start] + row + game.raw[start + len(old):], False))
        lines = [f"D {tag} {i}" for tag, i in sorted(deleted)]
        lines += [f"A {number}" for number in sorted(registered)]
        lines += [f"{tag} {i} " + " ".join(map(str, rule))
                  for (tag, i), records in sorted(rule_map.items()) for rule in records]
        lines += [f"L {mid} {troop} {level}" for mid, rows in sorted(levels.items()) for troop, level in sorted(rows.items())]
        raw = "".join(f"{line}\n" for line in lines).encode("ascii")
        if raw != self.rule_raw:
            changes.append((self.rule_path, raw, False))
        if descriptions != self.descriptions:
            raw = (json.dumps(descriptions, ensure_ascii=False, indent=2, sort_keys=True) + "\n").encode("utf-8")
            changes.append((self.desc_path, raw, False))
        if changes:
            replace_files(changes)
