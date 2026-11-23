"""Read the relative attack tiles from the game's range function."""

from lupa.lua52 import LuaRuntime


def load_attack_ranges(script_path):
    source = script_path.read_bytes()
    start = source.index(b"function WarGetAtkFW(")
    end = source.index(b"function WarSetAtkFW(", start)
    lua = LuaRuntime(encoding=None, register_eval=False, register_builtins=False)
    lua.execute(b"python, dofile, loadfile, require, package, io, os, debug = nil, nil, nil, nil, nil, nil, nil, nil")
    lua.execute(source[start:end])
    game_range = lua.globals().WarGetAtkFW
    ranges = {}
    for number in range(27):
        tiles = game_range(0, 0, number)
        ranges[number] = {(tiles[i][1], tiles[i][2]) for i in range(1, tiles.num + 1)}
    return ranges
