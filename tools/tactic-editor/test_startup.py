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


def boot_campaign(campaign, log, checks=b"", legacy_save=None):
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
    lua.globals().legacySave = legacy_save.as_posix().encode() if legacy_save else False
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
''' + checks + br'''
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

    def test_final_troops_in_campaigns_battles_and_older_saves(self):
        checks = br'''
    local bz="\177\248\214\214"
    local lord="\190\253\214\247"
    local level="\181\200\188\182"
    local atkfw="\185\165\187\247\183\182\206\167"
    for pid=1,math.min(761,JY.PersonNum-1) do
        assert(JY.Person[pid][bz]==koFinalTroop(JY.Person[pid][bz]))
    end
    assert(JY.Bingzhong[6][atkfw]==5)
    assert(JY.Bingzhong[4]["\211\208\208\167"]==0)
    assert(koEquipmentClassMatches(4,6) and koEquipmentClassMatches(6,33))
    assert(not koEquipmentClassMatches(1,6))
    if legacySave then
    CC.R_GRPFilename[1]=legacySave
    WarIni()
    LoadRecord(1)
    assert(JY.Person[1][bz]==3 and JY.Person[1][level]==12)
    assert(JY.Person[1]["\215\238\180\243\177\248\193\166"]>0)
    assert(Byte.get16(JY.Data_Person,762*CC.PersonSize+64)==7)
    ModifyBZ(1,4)
    assert(JY.Person[1][bz]==6)
    ModifyBZ(1,5)
    assert(JY.Person[1][bz]==6)

    JY.Person[54][lord]=1
    JY.Person[54][bz]=7
    koStoryMarkTavernHire(54)
    ModifyBZ(54,16)
    assert(JY.Person[54][bz]==9)

    WarIni()
    War.EnemyNum=0
    CC.Enhancement=false
    SelectEnemy({299,0,0,1,0,1,4,0,0,-1,1})
    assert(War.Person[1].bz==6 and War.Person[1].atkfw==5)
    JY.Person[300]["\181\192\190\2231"]=20
    War.SelID=1
    local drawDelay=WarDrawStrBoxDelay
    WarDrawStrBoxDelay=function() end
    assert(Item_Use(1)==0 and JY.Person[300]["\181\192\190\2231"]==20)
    WarDrawStrBoxDelay=drawDelay
    end
'''
        with chdir(ROOT), tempfile.TemporaryDirectory() as scratch:
            scratch = Path(scratch)
            data = Path("yeonggeol/data")
            person_base = struct.unpack_from("<I", (data / "newgame.idx").read_bytes())[0]
            save = bytearray((data / "newgame.grp").read_bytes())
            struct.pack_into("<h", save, person_base + 152 + 38, 1)
            struct.pack_into("<h", save, person_base + 152 + 42, 12)
            struct.pack_into("<h", save, person_base + 152 + 64, 2)
            struct.pack_into("<h", save, person_base + 152 + 68, 0)
            struct.pack_into("<h", save, person_base + 762 * 152 + 64, 7)
            legacy_save = scratch / "legacy.grp"
            legacy_save.write_bytes(save)
            for campaign in ("", "wuje", "sunjian", "yuanshao"):
                with self.subTest(campaign=campaign or "base"):
                    save_path = legacy_save if not campaign else None
                    self.assertTrue(boot_campaign(campaign, scratch / f"{campaign or 'base'}.txt",
                                                  checks, save_path))
