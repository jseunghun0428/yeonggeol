import io
import shutil
import tempfile
import unittest
from pathlib import Path

from PIL import Image
from lupa.lua52 import LuaRuntime

from tactic_data import SKILL_SETTINGS, TacticProject, effect_frames
from data import ASSETS, CAMPAIGNS


ROOT = Path(__file__).resolve().parents[2]


def png(size):
    result = io.BytesIO()
    Image.new("RGBA", size, "red").save(result, format="PNG")
    return result.getvalue()


class TacticEditorTest(unittest.TestCase):
    def test_rules_and_effect_storage(self):
        original = ROOT / "yeonggeol"
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            assets = root / "yeonggeol"
            paths = ["hzmb.dat", "data/newgame.idx", "data/newgame.grp"]
            paths += [f"data/{stem}.{ext}" for stem in ASSETS.values() for ext in ("idx", "grp")]
            paths += [f"script/addon/{name}.lua" for name in ("awakeperson_data", "awakeperson_roster", "record")]
            for slug in CAMPAIGNS.values():
                folder = f"data/camp/{slug}" if slug else "data"
                paths += [f"{folder}/mmap.idx", f"{folder}/mmap.grp"]
                if slug:
                    paths += [f"{folder}/newgame.grp", f"script/camp/{slug}/camp.lua"]
            for path in paths:
                target = assets / path
                target.parent.mkdir(parents=True, exist_ok=True)
                shutil.copyfile(original / path, target)
            project = TacticProject(root)
            original_effect = project.archives["영걸전"].cell(200)
            self.assertEqual(len(effect_frames(original_effect, 200)), 7)
            self.assertEqual(len(effect_frames(png((32, 96)))), 3)
            with self.assertRaisesRegex(ValueError, "정사각형"):
                effect_frames(png((32, 95)))
            with self.assertRaisesRegex(ValueError, "두 장 이상"):
                effect_frames(png((32, 32)))

            skill = 22
            self.assertEqual(project.decode_skill_values(skill, (0,) * 6)[0], 100)
            name, description, values = project.fields("S", skill)
            with self.assertRaisesRegex(ValueError, "효과 수치만"):
                project.save("S", skill, delete=True)
            with self.assertRaisesRegex(ValueError, "효과 수치만"):
                project.save("S", skill, "다른 이름", description, values)
            with self.assertRaisesRegex(ValueError, "효과 수치만"):
                project.save("S", project.next_id("S"), "새 특기", "", (0,) * 6)
            project.rule_path.write_text("S 22 0 1 50 0 1 10\n", encoding="ascii")
            project = TacticProject(root)
            rules = [(0, 1, 40, 0, 1, 30)]
            project.save("S", skill, name, description, (152, *values[1:]), rules)
            project = TacticProject(root)
            self.assertEqual(project.skill_values(skill)[0], 150)
            self.assertEqual(project.rules["S", skill], rules)
            with self.assertRaisesRegex(ValueError, "조건 기준과 효과량"):
                project.save("S", skill, name, description, (152, *values[1:]), [])
            with self.assertRaisesRegex(ValueError, "조건 기준과 효과량"):
                project.save("S", skill, name, description, (152, *values[1:]), [(1, 1, 40, 0, 1, 30)])
            self.assertEqual(project.decode_skill_values(113, (0,) * 6)[0], 10)
            name, description, values = project.fields("S", 113)
            project.save("S", 113, name, description, (17, *values[1:]))
            project = TacticProject(root)
            self.assertEqual(project.skill_values(113)[0], 15)
            for game in project.games.values():
                _, row = project.row(game, "S", 113)
                self.assertEqual(row[216:218], b"\x11\x00")
            for number, settings in SKILL_SETTINGS.items():
                with self.subTest(skill=number):
                    _, _, original_values = project.fields("S", number)
                    values = project.skill_values(number)
                    defaults = project.decode_skill_values(number, (0,) * 6)
                    self.assertEqual(defaults[:len(settings)], [default for default, _, _ in settings])
                    self.assertEqual(tuple(project.encode_skill_values(number, values)), original_values)
                    values[0] = settings[0][2] + 1
                    with self.assertRaises(ValueError):
                        project.encode_skill_values(number, values)
            for number, new_value in ((51, 4), (104, 30), (112, 25), (120, 6), (123, 200)):
                name, description, _ = project.fields("S", number)
                values = project.skill_values(number)
                values[0] = new_value
                project.save("S", number, name, description, project.encode_skill_values(number, values))
                project = TacticProject(root)
                self.assertEqual(project.skill_values(number)[0], new_value)

            strategy = project.next_id("M")
            values = (4, 5, 100, 13, 11, 200, 50)
            rules = ((0, 0, 0, 1, 2, 25),)
            with self.assertRaisesRegex(ValueError, "조건 기준과 효과량"):
                project.save("M", strategy, "새 책략", "테스트", values, rules)
            project.save("M", strategy, "새 책략", "테스트", values, (), {1: 4}, png((32, 96)))
            project = TacticProject(root)
            animation = project.fields("M", strategy)[2][5]
            self.assertNotEqual(animation, 200)
            self.assertIn(animation, project.effect_numbers())
            for story, game in project.games.items():
                self.assertEqual(game.names(4, 30)[strategy], "새 책략")
                self.assertEqual(project.archives[story].cell(animation), png((32, 96)))
                self.assertEqual(project.archives[story].cell(200), original_effect)
                self.assertEqual(game.index, project.base.index)
            with self.assertRaisesRegex(ValueError, "사용 중"):
                project.save("M", strategy, delete=True)
            with project.rule_path.open("a", encoding="ascii") as file:
                file.write(f"M {strategy} 0 0 0 1 2 25\n")
            project = TacticProject(root)
            name, description, values = project.fields("M", strategy)
            project.save("M", strategy, name, description, values, ((0, 0, 0, 1, 2, 30),), {})
            project = TacticProject(root)
            project.save("M", strategy, delete=True)
            project = TacticProject(root)
            self.assertNotIn(strategy, project.entries("M"))
            self.assertNotIn(strategy, project.base.names(4, 30))
            self.assertIn(animation, project.effect_numbers())

    def test_battle_rules(self):
        script = ROOT / "yeonggeol" / "script"
        lua = LuaRuntime(encoding=None)
        for path in ("jymain.lua", "addon/preview.lua", "addon/tank.lua", "addon/uhui.lua"):
            compiled = lua.globals().load((script / path).read_bytes())
            self.assertFalse(isinstance(compiled, tuple), (path, compiled))
        tactics = lua.execute((script / "addon" / "tactic_editor.lua").read_bytes())
        lua.globals().tactics = tactics
        self.assertEqual(tactics.skillValue(0, 100), 100)
        self.assertEqual(tactics.skillValue(1, 100), 100)
        self.assertEqual(tactics.skillValue(152, 100), 150)
        self.assertEqual(tactics.skillValue(2, 10), 0)
        source = (script / "jymain.lua").read_bytes()
        start = source.index(b"if CC.Enhancement then\r\nlocal moraleBonus=")
        end = source.index(b"sq_hurt=limitX", start)
        lua.globals().koTactics = tactics
        calculate = lua.execute(br'''return function(weapon,skill,value)
            local p1={["\206\228\198\247"]=weapon}
            local CC,JY={Enhancement=true},{Skill={[113]={["\178\206\202\253".."1"]=value}}}
            local pid,sq_hurt=1,0
            local function WarCheckSkill() return skill end
        ''' + source[start:end] + b"return sq_hurt end")
        self.assertEqual(calculate(0, True, 0), 10)
        self.assertEqual(calculate(0, True, 17), 15)
        self.assertEqual(calculate(14, False, 17), 10)
        self.assertEqual(calculate(14, True, 7), 10)
        self.assertEqual(calculate(14, True, 17), 15)
        with tempfile.TemporaryDirectory() as directory:
            rules = Path(directory) / "tactic_rules.txt"
            rules.write_text("S 512 0 1 50 0 1 10\nM 99 0 0 0 1 2 25\nL 99 1 4\n", encoding="ascii")
            tactics.load(str(rules).encode())
        lua.execute(br'''
local hp,maxhp,class,level="\177\248\193\166","\215\238\180\243\177\248\193\166","\177\248\214\214","\181\200\188\182"
local range,kind="\208\167\185\251\183\182\206\167","\192\224\208\205"
GAME_WMAP=1
War={Width=6,Depth=6,PersonNum=2,Person={
 {id=1,live=true,enemy=false,x=2,y=2},{id=2,live=true,enemy=true,x=3,y=2}}}
JY={Status=GAME_WMAP,Person={{[hp]=40,[maxhp]=100,[class]=1,[level]=4},{[hp]=100,[maxhp]=100}},
 Magic={[99]={[range]=11,[kind]=4}}}
function WarResetStatus() end
function WarGetAtkFW(x,y,fw) assert(fw==11) return {num=1,{x,y}} end
function GetWarMap() return 2 end
function PlayMagic(id,x,y,pid) shown={id,x,y,pid} end
local function has(pid,skill) return pid==1 and skill==512 end
tactics.turn(has)
assert(JY.Person[1][hp]==50 and JY.Person[2][hp]==100)
assert(tactics.learns(1,99))
assert(tactics.strategyScore(1,2,99)==25)
assert(tactics.strategy(1,2,99,true,function() error("not lethal") end,function() end))
assert(JY.Person[2][hp]==75 and shown[1]==99 and shown[4]==1)
''')

    def test_configured_skill_combat_helpers(self):
        script = ROOT / "yeonggeol" / "script"
        lua = LuaRuntime(encoding=None)
        lua.globals().koTactics = lua.execute((script / "addon" / "tactic_editor.lua").read_bytes())
        main = (script / "jymain.lua").read_bytes()
        start = main.index(b"function koStrategyMPCost(")
        lua.execute(main[start:main.index(b"function WarMagicMenu(", start)])
        start = main.index(b"function koDemon(")
        lua.execute(main[start:main.index(b"koExtraHire=", start)])
        lua.execute(br'''
local param="\178\206\202\253"
local weapon,hp,talent="\206\228\198\247","\177\248\193\166","\204\236\184\179"
local kind,range="\192\224\208\205","\208\167\185\251\183\182\206\167"
GAME_WMAP=1
CC={Enhancement=true}
War={Person={{id=1,live=true},{id=2,live=true}}}
JY={Status=GAME_WMAP,Person={{[weapon]=0,[talent]=123},{[hp]=100}},
     Skill={[112]={[param.."1"]=-26},[119]={[param.."1"]=-3},[123]={[param.."2"]=-4}},
     Magic={[1]={[kind]=1,[range]=11}}}
function between(v,a,b) return v>=a and v<=b end
function WarCheckSkill(_,id) return id==112 or id==119 end
assert(koTactics.setting(112,1,50)==25)
assert(koTactics.setting(123,1,150)==150)
assert(koStrategyMPCost(1,20,true)==15)
JY.Person[1][weapon]=12
assert(koStrategyMPCost(1,20,true)==10)
assert(koStrategyMPCost(1,20,false)==15)
assert(koTacticScholarCasts(1,1)==2)
local casts=0
function WarMagic() casts=casts+1 end
koWarMagic2(1,2,1)
assert(casts==4)
JY.Person[2][hp]=0
koTacticExtraStrategy(1,2,1,false,3)
assert(casts==4)
''')

if __name__ == "__main__":
    unittest.main()
