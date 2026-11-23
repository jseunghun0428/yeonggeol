import io
import shutil
import tempfile
import unittest
from pathlib import Path

from PIL import Image
from lupa.lua52 import LuaRuntime

from tactic_data import ELEMENT_SKILL_STRATEGIES, SKILL_SETTINGS, TacticProject, effect_frames
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
            paths = ["hzmb.dat", "data/newgame.idx", "data/newgame.grp", "script/jymain.lua"]
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
            self.assertEqual(project.strategy_ranges[1], {(-1, 0), (0, -1), (0, 1), (1, 0)})
            self.assertEqual(project.strategy_ranges[11], {(0, 0)})
            self.assertEqual(project.strategy_ranges[19], set())
            self.assertEqual(len(project.strategy_ranges[24]), 60)
            original_effect = project.archives["영걸전"].cell(200)
            self.assertEqual(len(effect_frames(original_effect, 200)), 7)
            self.assertEqual(len(effect_frames(png((32, 96)))), 3)
            with self.assertRaisesRegex(ValueError, "정사각형"):
                effect_frames(png((32, 95)))
            with self.assertRaisesRegex(ValueError, "두 장 이상"):
                effect_frames(png((32, 32)))

            name, description, values = project.fields("S", 39)
            edited = project.encode_skill_values(39, (25, 5, 28, 9, 40, 30))
            project.save("S", 39, name, description, edited)
            project = TacticProject(root)
            self.assertEqual(project.skill_values(39), [25, 5, 28, 9, 40, 30])
            for game in project.games.values():
                _, row = project.row(game, "S", 39)
                lines = game.decode(row[16:216]).split("*")
                self.assertEqual(lines[0], "독연 5, 독무 28, 독룡 9, 독천 30, 혈독 40레벨")
                self.assertIn("독계 위력 +25%", lines[1])
                self.assertEqual(row[216:228], b"\x19\x00\x05\x00\x1c\x00\x09\x00\x28\x00\x1e\x00")
            for mid in (47, 48, 49):
                self.assertIn("특기 #39 독계 · 책략 습득과 중독", project.usages("M", mid))

            for skill, strategies in ELEMENT_SKILL_STRATEGIES.items():
                name, description, values = project.fields("S", skill)
                self.assertEqual(project.skill_parameters(skill)[1:], tuple(
                    f"{project.fields('M', mid)[0]} 습득 레벨" for mid in strategies))
                with self.assertRaisesRegex(ValueError, "0~99"):
                    project.save("S", skill, name, description, (values[0], 100, 0, 0, 0, 0))
                edited = (values[0], 7, 0, 15, 0, 45)
                project.save("S", skill, name, description, project.encode_skill_values(skill, edited))
                project = TacticProject(root)
                self.assertEqual(project.skill_values(skill), list(edited))
                for game in project.games.values():
                    _, row = project.row(game, "S", skill)
                    self.assertEqual(row[218:228], b"\x07\x00\x00\x00\x0f\x00\x00\x00\x2d\x00")

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

    def test_poison_learning_and_status(self):
        lua = LuaRuntime(encoding=None)
        source = (ROOT / "yeonggeol/script/jymain.lua").read_bytes()
        start = source.index(b"koPoisonMag={")
        lua.execute(source[start:source.index(b"\r\n}", start) + 3])
        start = source.index(b"local koElementMagicSkill=")
        lua.execute(source[start:source.index(b"function WarHaveMagic(", start)])
        lua.execute(br'''
local class,lv,kind,param="\177\248\214\214","\181\200\188\182","\192\224\208\205","\178\206\202\253"
local person={[class]=1}
local emptyClass=setmetatable({},{__index=function() return 0 end})
JY={Person={person}, Bingzhong={[1]=emptyClass}, Skill={[39]={}}, Magic={}, Status=0}
CC={Enhancement=true}
GAME_WMAP=1
local active=true
function CheckSkill(_, skill) return active and skill==39 end
function between(value, lower, upper) return value>=lower and value<=upper end
for i,rule in ipairs({{41,1,3,75},{42,6,2,50},{47,12,3,75},{48,32,3,75},{49,24,2,50}}) do
    local mid,level,turns,rate=table.unpack(rule)
    JY.Magic[mid]={[kind]=9}
    JY.Skill[39][param..(i+1)]=level
    assert(koPoisonMag[mid].turns==turns and koPoisonMag[mid].rate==rate)
    person[lv]=level-1
    assert(not HaveMagic(1,mid))
    person[lv]=level
    assert(HaveMagic(1,mid))
    active=false
    assert(not HaveMagic(1,mid))
    active=true
    JY.Magic[mid][kind]=0
    assert(not HaveMagic(1,mid))
end
''')

    def test_element_learning_levels(self):
        lua = LuaRuntime(encoding=None)
        source = (ROOT / "yeonggeol/script/jymain.lua").read_bytes()
        start = source.index(b"local koElementMagicSkill=")
        lua.execute(source[start:source.index(b"function WarHaveMagic(", start)])
        lua.execute(br'''
local class,lv,kind,spell,param="\177\248\214\214","\181\200\188\182","\192\224\208\205","\178\223\194\212","\178\206\202\253"
local person, selfClass, sorcerer = {[class]=1}, {}, {}
local function zeroFields(fields) return setmetatable(fields,{__index=function() return 0 end}) end
JY={Person={person}, Bingzhong={[1]=zeroFields(selfClass),[16]=zeroFields(sorcerer)}, Skill={}, Magic={}, Status=0}
CC={Enhancement=true}
GAME_WMAP=1
local active
function CheckSkill(_, skill) return skill==active end
function between(value, lower, upper) return value>=lower and value<=upper end
for family,skill in ipairs({12,11,14}) do
    local first=(family-1)*5+1
    active=skill
    JY.Skill[skill]=zeroFields({[param..2]=7,[param..6]=45})
    for n=0,4 do
        JY.Magic[first+n]={[kind]=family}
        sorcerer[spell..(first+n)]=2+n
    end
    person[lv]=6
    assert(not HaveMagic(1,first))
    assert(HaveMagic(1,first+1))
    person[lv]=7
    assert(HaveMagic(1,first))
    assert(not HaveMagic(1,first+4))
    person[lv]=45
    assert(HaveMagic(1,first+4))
    active=nil
    assert(not HaveMagic(1,first))
    selfClass[spell..first]=1
    person[lv]=1
    assert(HaveMagic(1,first))
end
''')

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
        start = source.index(b"if CC.Enhancement and WarCheckSkill(pid,113) then")
        end = source.index(b"sq_hurt=limitX", start)
        lua.globals().koTactics = tactics
        calculate = lua.execute(br'''return function(skill,value)
            local CC,JY={Enhancement=true},{Skill={[113]={["\178\206\202\253".."1"]=value}}}
            local pid,sq_hurt=1,0
            local function WarCheckSkill() return skill end
        ''' + source[start:end] + b"return sq_hurt end")
        self.assertEqual(calculate(True, 0), 10)
        self.assertEqual(calculate(True, 17), 15)
        self.assertEqual(calculate(False, 17), 0)
        self.assertEqual(calculate(True, 7), 5)
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
local discount=true
function WarCheckSkill(_,id) return (id==112 and discount) or id==119 end
assert(koTactics.setting(112,1,50)==25)
assert(koTactics.setting(123,1,150)==150)
assert(koStrategyMPCost(1,20)==15)
JY.Person[1][weapon]=12
assert(koStrategyMPCost(1,20)==15)
discount=false
assert(koStrategyMPCost(1,20)==20)
assert(koTacticScholarCasts(1,1)==2)
local casts=0
function WarMagic() casts=casts+1 end
koWarMagic2(1,2,1)
assert(casts==4)
JY.Person[2][hp]=0
koTacticExtraStrategy(1,2,1,false,3)
assert(casts==4)
''')

    def test_weapon_effects_require_active_skills(self):
        script = ROOT / "yeonggeol" / "script"
        main = (script / "jymain.lua").read_bytes()
        lua = LuaRuntime(encoding=None)
        lua.globals().koTactics = lua.execute((script / "addon" / "tactic_editor.lua").read_bytes())
        start = main.index(b"local koTalentSet=")
        lua.execute(main[start:main.index(b"function CheckSkill(", start)])
        start = main.index(b"function WarAtkHurt(")
        lua.execute(main[start:main.index(b"function WarAtk(", start)])
        pierce = main.index(b"local xx=War.Person[eid].x")
        start = main.rfind(b"if JY.Status==GAME_WMAP", 0, pierce)
        lua.execute(b"function canPierce(pid,scl)\n" + main[start:pierce] + b"return true end\nreturn false end")
        lua.execute(br'''
local weapon,skill,talent="\206\228\198\247","\204\216\188\188","\204\236\184\179"
local attack,defense,class="\185\165\187\247","\183\192\211\249","\177\248\214\214"
local hp,maxhp,morale,level="\177\248\193\166","\215\238\180\243\177\248\193\166","\202\191\198\248","\181\200\188\182"
local param="\178\206\202\253"
GAME_WMAP=1
CC={Enhancement=true}
koLinkIdx={}
War={Person={{id=1,enemy=true,atk_buff=0},{id=2,def_buff=0}}}
local first={[attack]=100,[class]=1,[level]=10}
local second={[defense]=100,[class]=2,[level]=10,[hp]=1000,[maxhp]=1000,[morale]=100,[weapon]=0}
JY={Status=GAME_WMAP,Person={first,second},Item={[0]={}},
    Skill={[113]={[param.."1"]=22},[115]={[param.."1"]=0}}}
function BZSuper() return false end
function GetWarMap() return 0 end
function koSiegePct() return 0 end
function koStratClass() return false end
function limitX(value,lo,hi) return math.max(lo,math.min(hi,value)) end
local function equip(person,item,skillid)
    person[weapon]=item
    JY.Item[item]={[skill]=skillid}
end
equip(first,59,0)
assert(not canPierce(1,1))
equip(first,59,114)
assert(canPierce(1,1))
equip(first,59,0)
first[talent]=114
assert(canPierce(1,1))
first[talent]=0

equip(first,14,0)
local _, moraleLoss=WarAtkHurt(1,2)
assert(moraleLoss==1)
equip(first,14,113)
_,moraleLoss=WarAtkHurt(1,2)
assert(moraleLoss==21)
JY.Skill[113][param.."1"]=2
_,moraleLoss=WarAtkHurt(1,2)
assert(moraleLoss==1)

equip(first,60,0)
assert(WarAtkHurt(1,2)==50)
equip(first,60,115)
local damage,_,_,critical=WarAtkHurt(1,2)
assert(damage==400 and critical==2)

equip(first,10,0)
equip(second,11,0)
assert(WarAtkHurt(1,2)==50)
equip(first,10,110)
assert(WarAtkHurt(1,2)==62)
equip(first,10,0)
equip(second,11,111)
assert(WarAtkHurt(1,2)==37)
''')

if __name__ == "__main__":
    unittest.main()
