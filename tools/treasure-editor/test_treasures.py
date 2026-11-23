import locale
import shutil
import struct
import tempfile
import unittest
from pathlib import Path

from lupa.lua52 import LuaRuntime
from PIL import Image

from treasure_data import ITEM_SIZE, PERCENT_OPTIONS, TreasureProject, import_picture
from data import ASSETS, CAMPAIGNS


ROOT = Path(__file__).resolve().parents[2]


class TreasureTest(unittest.TestCase):
    def test_percentage_descriptions_match_runtime(self):
        project = TreasureProject(ROOT)
        lua = LuaRuntime(encoding=None)
        runtime = lua.execute((ROOT / "yeonggeol/script/addon/treasure_editor.lua").read_bytes())
        item = 170  # The old text includes an inline attack bonus beside the strength bonus.
        source = project.record(project.base, item)[16:216].split(b"\0", 1)[0]
        stats = project.stats(item) | {228: 15, 230: 8, 232: -5}
        names = dict(zip(PERCENT_OPTIONS, ("攻击", "策略攻击", "防御")))
        runtime_item = {name.encode("gbk"): stats[offset] for offset, name in names.items()}
        slot = "装备位".encode("gbk")
        runtime_item[slot] = 1
        actual = runtime.description(lua.table_from(runtime_item), source)
        expected = project.description(item, stats)
        self.assertEqual(project.base.decode(actual).replace("*", "\n"), expected)
        self.assertIn("공격 +15%\n책략 +8%\n방어 -5%", expected)
        self.assertNotIn("공격＋", expected)
        self.assertIn("무력＋", expected)
        zero = stats | dict.fromkeys(PERCENT_OPTIONS, 0)
        self.assertFalse(any("%" in line for line in project.description(item, zero).splitlines()))
        self.assertEqual(runtime.description(lua.table_from({slot: 0}), source), source)

    def test_skill_names_in_equipment_descriptions(self):
        project = TreasureProject(ROOT)
        lua = LuaRuntime(encoding=None)
        runtime = lua.execute((ROOT / "yeonggeol/script/addon/treasure_editor.lua").read_bytes())
        item = lua.table_from({"装备位".encode("gbk"): 1})
        self.assertIn("특기: 위압", project.description(14))
        self.assertIn("특기: 용담", project.description(14, skills={("regular", 14): 49}))
        self.assertNotIn("특기:", project.description(14, skills={("regular", 14): 0}))
        other_skills = project.skill_fields(503)
        awaken = next(key for key in other_skills if key[0] == "awaken")
        description = project.description(503, skills={("exclusive", 503): 32, awaken: 34})
        self.assertIn("감녕 전용 특기: 공성", description)
        self.assertIn("각성 특기: 강행", description)

        raw = project.encode_text("병서*특기: 신산 (책략 성공률 상승)")
        original = runtime.description(item, raw, project.encode_text("신산"))
        self.assertEqual(original, raw)
        engraved = runtime.description(item, raw, project.encode_text("위압"))
        self.assertEqual(project.base.decode(engraved), "병서*특기: 위압")
        self.assertEqual(project.base.decode(runtime.description(item, raw)), "병서")

    def test_edit_both_variants_and_update_existing_save(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            files = ["hzmb.dat", "script/addon/bogam_data.lua", "script/addon/gear_data.lua", "data/newgame.grp"]
            files.extend(f"data/camp/{slug}/newgame.grp" for slug in CAMPAIGNS.values() if slug)
            files.extend(f"data/{stem}.idx" for stem in ("newgame", "bogam", *ASSETS.values()))
            files.extend(f"data/{stem}.grp" for stem in ("bogam", *ASSETS.values()))
            for name in files:
                target = root / "yeonggeol" / name
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(ROOT / "yeonggeol" / name, target)

            project = TreasureProject(root)
            original = project.archive.cell(0)
            star = project.archive.cell(1)
            silhouette = project.archive.cell(2)
            neighbor = project.archive.cell(3)
            before = project.record(project.base, 502)
            original_stats = project.stats(502)
            star_stats = project.stats(503)
            path = root / "image.png"
            Image.new("RGBA", (64, 32), (255, 0, 0, 128)).save(path)
            picture = import_picture(path)
            self.assertEqual(picture.getchannel("A").getbbox(), (0, 32, 128, 96))

            self.assertFalse(project.save(502, original_stats))
            self.assertFalse(project.stat_file.exists())
            self.assertTrue(project.save(502, {220: -7}, picture))
            with self.assertRaisesRegex(ValueError, "외부에서 바뀌었습니다"):
                project.save(503, {220: 11})
            project = TreasureProject(root)
            self.assertEqual(project.stats(502), original_stats | {220: -7})
            self.assertEqual(project.stats(503), star_stats)
            self.assertIn("무력－７", project.description(502))
            self.assertEqual(project.picture(502).tobytes(), picture.tobytes())
            self.assertNotEqual(project.archive.cell(0), original)
            self.assertEqual(project.archive.cell(1), star)
            self.assertNotEqual(project.archive.cell(2), silhouette)
            normal_cells = [project.archive.cell(i) for i in (0, 2)]

            self.assertTrue(project.save(503, {220: 13}, Image.new("RGBA", (128, 128), "blue")))
            project = TreasureProject(root)
            self.assertEqual(project.stats(503), star_stats | {220: 13})
            self.assertEqual([project.archive.cell(i) for i in (0, 2)], normal_cells)
            self.assertEqual(project.picture(503).getpixel((0, 0)), (0, 0, 255, 255))
            self.assertEqual(project.archive.cell(3), neighbor)
            self.assertEqual(project.edited, {(502, 220), (503, 220)})
            for game in project.games.values():
                row = project.record(game, 502)
                self.assertEqual(struct.unpack_from("<h", row, 220)[0], -7)
                self.assertEqual(row[216:220] + row[222:], before[216:220] + before[222:])

            updated = self.check_skill_editing(project)
            updated = self.check_regular_skills(updated)
            self.check_save_sync(updated)

    def check_save_sync(self, project):
        lua = LuaRuntime(encoding=None)
        lua.globals().CC = lua.table()
        lua.globals().Byte = lua.table_from({
            b"get16": lambda data, offset: struct.unpack_from("<h", data, offset)[0],
            b"set16": lambda data, offset, value: struct.pack_into("<h", data, offset, value),
        })
        base = project.base.raw[project.base.offsets[3]:project.base.offsets[4]]
        old = bytearray(base)
        base_id, awakened, copy, untouched, exclusive, engraved = 502, 503, 1000, 504, 222, 1001
        old[copy * ITEM_SIZE:(copy + 1) * ITEM_SIZE] = project.record(project.base, awakened)
        old[engraved * ITEM_SIZE:(engraved + 1) * ITEM_SIZE] = project.record(project.base, 6)
        for number, field, value in ((base_id, 220, 6), (awakened, 220, 9), (copy, 220, 9),
                                     (copy, 228, 77), (copy, 256, 92), (untouched, 220, 99), (exclusive, 272, 8),
                                     (6, 256, 0), (7, 256, 49), (8, 256, 92), (14, 256, 21), (engraved, 256, 17)):
            struct.pack_into("<h", old, number * ITEM_SIZE + field, value)

        script = ROOT / "yeonggeol" / "script"
        runtime = lua.execute((script / "addon" / "treasure_editor.lua").read_bytes())
        self.assertTrue(callable(lua.eval(b"load")((script / "jymain.lua").read_bytes())))
        path = str(project.stat_file).encode(locale.getencoding())
        args = (path, old, base, ITEM_SIZE, len(old) // ITEM_SIZE)
        change = runtime.apply(*args)
        self.assertEqual(set(change.keys()), {base_id, awakened, copy, exclusive, 6, 7, 14})
        self.assertEqual(struct.unpack_from("<h", old, base_id * ITEM_SIZE + 220)[0], -7)
        self.assertEqual(struct.unpack_from("<h", old, awakened * ITEM_SIZE + 220)[0], 13)
        self.assertEqual(struct.unpack_from("<h", old, copy * ITEM_SIZE)[0], awakened)
        self.assertEqual(struct.unpack_from("<h", old, copy * ITEM_SIZE + 220)[0], 13)
        self.assertEqual(struct.unpack_from("<h", old, copy * ITEM_SIZE + 228)[0], 77)
        self.assertEqual(struct.unpack_from("<h", old, copy * ITEM_SIZE + 256)[0], 92)
        self.assertEqual(struct.unpack_from("<h", old, untouched * ITEM_SIZE + 220)[0], 99)
        self.assertEqual(struct.unpack_from("<h", old, exclusive * ITEM_SIZE + 272)[0], 0)
        for number, expected in ((6, 49), (7, 0), (8, 92), (14, 49), (engraved, 17)):
            self.assertEqual(struct.unpack_from("<h", old, number * ITEM_SIZE + 256)[0], expected)
        self.assertTrue(lua.globals().CC.koTreasureRegular[8][0])
        self.assertIsNone(runtime.apply(*args))
        lua.execute(b'''JY={PersonNum=4,Person={
            { ["\\206\\228\\198\\247"]=502 },
            { ["\\206\\228\\198\\247"]=504 },
            { ["\\184\\168\\214\\250"]=1000 },
        }}
        refreshed={}
        function ReSetAttrib(number,flag) refreshed[#refreshed+1]=number end''')
        runtime.refresh(change)
        self.assertEqual(list(lua.globals().refreshed.values()), [1, 3])

    def check_regular_skills(self, project):
        for item in (6, 7, 8):
            _, existing = project.skill_fields(item)["regular", item]
            if existing:
                project.save(item, {}, skills={("regular", item): 0})
                project = TreasureProject(project.root)
            self.assertEqual(project.skill_fields(item)["regular", item], ("일반 특기", 0))
            self.assertTrue(project.save(item, {}, skills={("regular", item): 49}))
            project = TreasureProject(project.root)
            self.assertIn("특기: 용담", project.description(item))
            for game in project.games.values():
                self.assertEqual(struct.unpack_from("<h", project.record(game, item), 256)[0], 49)
        self.assertEqual(project.skill_fields(174)["regular", 174][1], 17)
        self.assertFalse(project.skill_fields(9))
        for item in (12, 14, 59, 60, 215, 216):
            label, value = project.skill_fields(item)["regular", item]
            self.assertEqual(label, "일반 특기")
            self.assertIn(value, project.skills)
        self.assertNotIn(("regular", 502), project.skill_fields(502))
        for item in (774, 775):
            self.assertEqual(project.skill_fields(item)["regular", item][0], "일반 특기")
        self.assertTrue(project.save(774, {}, skills={("regular", 774): 0}))
        project = TreasureProject(project.root)
        self.assertEqual(project.skill_fields(774)["regular", 774][1], 0)
        self.assertTrue(project.save(14, {}, skills={("regular", 14): 49}))
        project = TreasureProject(project.root)
        self.assertIn("특기: 용담", project.description(14))
        self.assertTrue(project.save(7, {}, skills={("regular", 7): 0}))
        project = TreasureProject(project.root)
        self.assertNotIn("특기:", project.description(7))
        self.assertTrue({0, 49}.issubset(project.skill_history[7]))
        return project

    def check_skill_editing(self, project):
        normal, star = 775, 222
        fields = project.skill_fields(star)
        shared = next(key for key in fields if key[0] == "shared")
        awaken = {label: key for key, (label, _) in fields.items() if key[0] == "awaken"}
        self.assertTrue(project.save(star, {}, skills={
            ("exclusive", star): 0, awaken["각성 · 하후은"]: 49, awaken["각성 · 조운"]: 32, shared: 0,
        }))
        project = TreasureProject(project.root)
        self.assertEqual(project.skill_fields(normal)["exclusive", normal][1], 8)
        self.assertNotIn("하후은 전용 특기:", project.description(star))
        self.assertIn("각성 특기: 용담", project.description(star))
        self.assertIn("조운이 들면: 각성 특기 공성", project.description(star))
        self.assertNotIn("조운이 들면:", project.description(normal))
        self.assertIn((star, 272), project.edited)
        for game in project.games.values():
            row = project.record(game, star)
            self.assertEqual(struct.unpack_from("<h", row, 272)[0], 0)

        lua = LuaRuntime(encoding=None)
        lua.execute(project.gear_raw)
        lua.execute(b'''local OWNER="name"
local D=koGearData
local NAME=OWNER
local ROWS={}
for k,e in ipairs(D) do
 ROWS[e[1]]=ROWS[e[1]] or {}
 table.insert(ROWS[e[1]],k)
 if e[2]==775 and e[3]==222 then
  if e[9]>0 then assert(e[10]==0 and e[6]==32) sharedOwner=e[1]
  else assert(e[6]==49) mainOwner=e[1] end
 end
end
local EQUIP={"weapon"}
local function base(iid) return iid end
function koLinkSkill() return false end
function koHas() return true end
JY={Person={{name=mainOwner,weapon=222},{name=sharedOwner,weapon=222},{name=sharedOwner,weapon=775}}}
'''+self.link_skill_block())
        self.assertTrue(lua.globals().koLinkSkill(1, 49))
        self.assertFalse(lua.globals().koLinkSkill(1, 103))
        self.assertTrue(lua.globals().koLinkSkill(2, 32))
        self.assertFalse(lua.globals().koLinkSkill(2, 110))
        self.assertFalse(lua.globals().koLinkSkill(3, 32))
        self.assertFalse(lua.globals().koLinkSkill(3, 110))
        return project

    @staticmethod
    def link_skill_block():
        gear = (ROOT / "yeonggeol" / "script" / "addon" / "gear.lua").read_bytes()
        start = gear.index(b'if type(rawget(_G,"koLinkSkill"))')
        end = gear.index(b'if type(rawget(_G,"koLinkIdx"))', start)
        return gear[start:end]


if __name__ == "__main__":
    unittest.main()
