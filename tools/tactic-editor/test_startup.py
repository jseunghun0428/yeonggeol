from contextlib import chdir
from functools import lru_cache
from pathlib import Path
import struct
import tempfile
import unittest

from lupa.lua52 import LuaRuntime

ROOT = Path(__file__).resolve().parents[2]


@lru_cache(maxsize=None)
def read(path):
    return Path(path.decode()).read_bytes()


def load(data, path, offset, count):
    data[:count] = read(path)[offset:offset+count]


def get(data, offset, fmt):
    return struct.unpack_from(fmt, data, offset)[0]


def put(data, offset, value, size):
    data[offset:offset+size] = (int(value) & ((1 << (size * 8))-1)).to_bytes(size, 'little')


def getstr(data, offset, count):
    return bytes(data[offset:offset+count]).split(b'\0', 1)[0]


def putstr(data, offset, count, value):
    data[offset:offset+count] = value[:count].ljust(count, b'\0')


def unexpected_write(*args):
    raise RuntimeError("Startup test attempted to change game files")


def boot_campaign(campaign, log):
    lua = LuaRuntime(encoding=None)
    lua.globals().Byte = lua.table_from({
        b"create": bytearray, b"loadfile": load, b"savefile": unexpected_write,
        b"get8": lambda data, offset: data[offset], b"get16": lambda data, offset: get(data, offset, "<h"),
        b"getu16": lambda data, offset: get(data, offset, "<H"), b"get32": lambda data, offset: get(data, offset, "<i"),
        b"getstr": getstr, b"setstr": putstr, b"set8": lambda data, offset, value: put(data, offset, value, 1),
        b"set16": lambda data, offset, value: put(data, offset, value, 2),
        b"setu16": lambda data, offset, value: put(data, offset, value, 2),
    })
    lua.globals().smokeLog = log.as_posix().encode()
    lua.globals().os.remove = unexpected_write
    lua.execute(br'''
config={GetPath=function() return "yeonggeol/" end}
lib=setmetatable({Debug=function() end,CharSet=function(s) return s end,GetKey=function() return 0,0,0 end},
                  {__index=function() return function() return 0 end end})
dofile("yeonggeol/config.lua")
local open=io.open
function io.open(path,mode)
    if mode and mode:match("[aw+]") then
        assert(path:match("error%.txt$") or path:match("_campaign%.log$"), "Startup test attempted to write "..path)
        return open(smokeLog,mode)
    end
    return open(path,mode)
end
''')
    config = lua.globals().CONFIG
    config.koCamp = campaign.encode() if campaign else None
    config.koCampData = f"yeonggeol/data/camp/{campaign}/".encode() if campaign else None
    config.koCampScript = f"yeonggeol/script/camp/{campaign}/".encode() if campaign else None
    lua.execute(read(b"yeonggeol/script/jymain.lua"))
    lua.execute(br'''
bootLoaded=false
function YJZMain()
    LoadRecord(0)
    assert(type(koTactics)=="table" and JY.PersonNum>0 and JY.ItemNum>0 and koHas("treasure_inventory"))
    for i=1,JY.PersonNum-1 do GetPic(i) end
    bootLoaded=true
end
''')
    lua.eval(b"JY_Main_sub")()
    return lua.globals().bootLoaded


class StartupTest(unittest.TestCase):
    def test_boot_loads_first_record_with_strict_globals(self):
        with chdir(ROOT), tempfile.TemporaryDirectory() as scratch:
            for campaign in ("", "wuje", "sunjian", "yuanshao"):
                with self.subTest(campaign=campaign or "base"):
                    log = Path(scratch) / f"{campaign or 'base'}.txt"
                    self.assertTrue(boot_campaign(campaign, log))
                    if log.exists():
                        entries = log.read_text(encoding="utf-8", errors="replace").splitlines()
                        errors = [entry for entry in entries if entry and not entry.endswith(" FULL CAMPAIGN LOADED")]
                        self.assertFalse(errors, "\n".join(errors))
