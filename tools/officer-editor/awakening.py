"""Read the same awakening entries the game assigns to its officers."""

import re

from lupa.lua52 import LuaRuntime

from data import CAMPAIGNS, Game


def roster_lua():
    lua = LuaRuntime(encoding=None, register_eval=False, register_builtins=False)
    for name in (b"python", b"dofile", b"loadfile", b"require", b"package", b"io", b"os", b"debug"):
        lua.globals()[name] = None
    return lua


class Awakening:
    def __init__(self, game):
        script = game.folder / "script"
        lua = roster_lua()
        lua.execute((script / "addon" / "awakeperson_data.lua").read_bytes())
        roster = lua.execute((script / "addon" / "awakeperson_roster.lua").read_bytes())
        if game.campaign:
            book_source = (script / "camp" / game.campaign / "camp.lua").read_bytes()
            book = re.search(rb"\brecBook\s*=\s*\{([0-9,\s]+)\}", book_source)
        else:
            book_source = (script / "addon" / "record.lua").read_bytes()
            book = re.search(rb"\bkoRecBook=[^\r\n]*? or \{([0-9,\s]+)\}", book_source)
        if not book:
            raise ValueError("각성 대상 판정에 필요한 무장 도감 목록을 찾을 수 없습니다.")
        ids = lua.table_from([int(value) for value in book[1].split(b",") if value.strip()])
        people = lua.table_from({
            pid: lua.table_from({b"\xd0\xd5\xc3\xfb": game.raw[game.offset(pid) + 10:game.offset(pid) + 24].split(b"\0", 1)[0]})
            for pid in game.people
        })
        data = lua.globals().koAwakeData
        self.skills = {}
        for pid in game.people:
            row = roster(pid, people, (game.campaign or "base").encode(), ids)
            if row is not None:
                self.skills[pid] = tuple(data[row][5].values())


class AwakeningStories:
    def __init__(self, root, current):
        folder = current.folder / "script" / "addon"
        lua = roster_lua()
        lua.execute((folder / "genedit_roster.lua").read_bytes())
        lua.execute((folder / "statsync_data.lua").read_bytes())
        self.ids = {}
        by_key = {}
        for row in lua.globals().koGenRoster.values():
            ids = {slug: row[index] for index, slug in enumerate(CAMPAIGNS.values(), 3) if row[index]}
            key = row[1]
            key = str(key).encode() if isinstance(key, int) else key.replace(b":", b"@")
            by_key[key] = ids
            for slug, pid in ids.items():
                self.ids[slug, pid] = ids
        for slug in CAMPAIGNS.values():
            alias = lua.globals().koStatAlias[(slug or "yeonggeol").encode()]
            for pid, row in alias.items() if alias is not None else ():
                if row[1] in by_key:
                    self.ids.setdefault((slug, pid), by_key[row[1]])
        self.root = root
        self.current = current
        self.games = {current.campaign: current}

    def targets(self, pid):
        current = self.current.campaign
        ids = {**self.ids.get((current, pid), {}), current: pid}
        targets = {}
        for slug, target in ids.items():
            if slug not in self.games:
                self.games[slug] = Game(self.root, slug)
            game = self.games[slug]
            if target in game.people:
                targets[slug] = game, target
        return targets
