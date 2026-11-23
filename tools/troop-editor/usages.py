"""Find troop IDs in the game's battle data formats and explicit assignments."""

import bisect
import collections
import re


# Keep byte positions for reporting Lua source lines. Quoted strings can contain "--".
COMMENTS = re.compile(
    rb"""--\[(=*)\[.*?\]\1\]|--[^\r\n]*|"(?:\\.|[^"\\])*"|'(?:\\.|[^'\\])*'|\[(=*)\[.*?\]\2\]""",
    re.S,
)
FLAT = re.compile(rb"\b(?:SelectEnemy|SnrSetEnemies)\s*\(\s*\{([^{}]*)\}")
ALLIES = re.compile(rb"\b(?:SelectTerm(?:_sub)?\s*\(\s*\d+\s*,|SnrSetAllies\s*\(\s*\d+\s*,\s*-?\d+\s*,)\s*\{([^{}]*)\}")
ROWS = re.compile(rb"\b(enemy|ally)\s*=\s*\{\s*((?:\{[^{}]*\}\s*[,;]?\s*)+)\}")
TROOP_KEY = rb'(?:["\x27](?:\xb1\xf8\xd6\xd6|\\177\\248\\214\\214)["\x27]|(?:[A-Z]+[_.])?BZ)'
ASSIGN = re.compile(rb"(?:\[\s*" + TROOP_KEY + rb"\s*\]|\.\s*bz|\bbz)\s*=(?!=)\s*(\d+)\b(?!\s*[+*/%-])")
REINFORCE = re.compile(rb"\b(?:r|row|e)\[7\]\s*=(?!=)\s*(\d+)\b")
DIRECT = re.compile(rb"\bJY\.Bingzhong\s*\[\s*(\d+)\s*\]")
INT = re.compile(rb"[+-]?\d+(?:\s*[+-]\s*\d+)*")


def numeric_row(body):
    values = []
    for cell in body.rstrip().rstrip(b",;").split(b","):
        cell = cell.strip()
        if not INT.fullmatch(cell):
            values.append(None)
            continue
        values.append(sum(map(int, re.findall(rb"[+-]?\d+", re.sub(rb"\s+", b"", cell)))))
    return values


def find_battle_usages(script, officer_troops=None):
    found = collections.defaultdict(set)
    for path in sorted(script.rglob("*.lua")):
        rel = path.relative_to(script)
        if rel.parts[0] == "origin":
            continue
        raw = path.read_bytes()
        source = COMMENTS.sub(lambda match: re.sub(rb"[^\r\n]", b" ", match[0])
                             if match[0].startswith(b"--") else match[0], raw)
        newlines = [match.start() for match in re.finditer(b"\n", source)]

        def add(troop, pos, role):
            if troop is not None and 0 < troop <= 32767:
                line = bisect.bisect_left(newlines, pos) + 1
                found[troop].add(f"{role} · script/{rel.as_posix()}:{line}")

        for match in FLAT.finditer(source):
            row = numeric_row(match[1])
            if len(row) % 11 == 0:
                for i in range(0, len(row), 11):
                    if row[i] is None or row[i] >= 0:
                        add(row[i + 6], match.start(), "적군 전투 배치")
        if officer_troops:
            if rel.parts[0] == "camp":
                stories = (rel.parts[1],)
            elif rel.name == "kdef.lua":
                stories = ("",)
            else:
                stories = officer_troops
            for match in ALLIES.finditer(source):
                row = numeric_row(match[1])
                if len(row) % 7 == 0:
                    for pid in row[::7]:
                        if pid is not None and pid >= 0:
                            for story in stories:
                                troop = officer_troops.get(story, {}).get(pid + 1)
                                add(troop, match.start(), "아군·우군 전투 배치")
        for match in ROWS.finditer(source):
            for record in re.finditer(rb"\{([^{}]*)\}", match[2]):
                row = numeric_row(record[1])
                if len(row) == 11 and match[1] == b"enemy":
                    add(row[6], match.start(2) + record.start(), "적군 전투 배치")
                elif path.name.startswith("puzzle") and len(row) in (6, 7):
                    role = "아군 전투 배치" if match[1] == b"ally" else "적군 전투 배치"
                    add(row[5], match.start(2) + record.start(), role)
        for match in ASSIGN.finditer(source):
            add(int(match[1]), match.start(), "전투·병종 지정")
        for match in DIRECT.finditer(source):
            add(int(match[1]), match.start(), "게임 병종 참조")
        if path.name in {"freeplus.lua", "ifbranch.lua", "conquest.lua"}:
            for match in REINFORCE.finditer(source):
                add(int(match[1]), match.start(), "적군 병종 변경")
    return found
