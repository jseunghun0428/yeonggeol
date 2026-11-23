"""Preview the project's Lua appearance rules with fresh-game data."""

import struct

from lupa.lua52 import LuaRuntime

from data import CAMPAIGNS, TROOP_SIZE, Game


def game_key(text):
    return text.encode("gbk")


class AppearanceRules:
    def __init__(self, game, campaign):
        script = game.folder / "script"
        lua = self.lua = LuaRuntime(encoding=None, register_eval=False, register_builtins=False)
        env = lua.globals()
        for name in (b"python", b"dofile", b"loadfile", b"require", b"package", b"io", b"os", b"debug"):
            env[name] = None
        lua.execute(br"""
            JY={Person={}, Bingzhong={}, OfficerOverrides={},OfficerBattleSlots={}}
            CC={Person_S=setmetatable({},{__index=function() return {} end})}
            CONFIG={}
            function between(v,a,b) return a<=v and v<=b end
            function koOn() end
            function koWujeCampaignActive() return true end
            RenderedCity={}
            function DrawSMap()
                for pid,p in pairs(JY.Person) do RenderedCity[pid]=p["\208\206\207\243"] end
            end
            function koOfficerEdited(pid,bit)
                local e=JY.OfficerOverrides[pid]
                return e and math.floor(e.mask/bit)%2==1
            end
        """)
        jy = env.JY
        if campaign:
            env.CONFIG.koCamp = campaign.encode()
            source = (script / "camp" / campaign / "wuje_campaign.lua").read_bytes()
            person = next(line for line in source.splitlines() if line.startswith(b"local PERSON="))
            lua.execute(person + b"\nCampaignPeople=PERSON")
            lua.execute((script / "camp" / campaign / "campaign" / "city_roles.lua").read_bytes())
        campaign_people = {row[1]: (row[2], row[3], row[4]) for _, row in env.CampaignPeople.items()} if campaign else {}
        if campaign:
            identities = lua.table_from({pid: row[0] for pid, row in campaign_people.items()})
            env.CampaignIdentities = identities
            lua.execute(b"function koWujeIdentity(pid) return CampaignIdentities[pid] end")
        jy.PersonNum = (game.offsets[1] - game.offsets[0]) // 152
        self.face = {}
        for pid in range(jy.PersonNum):
            mask, _ = game.flags.get(pid, (0, -1))
            face, city = game.value(pid, 6), game.value(pid, 2)
            if pid in campaign_people:
                _, base_face, base_city = campaign_people[pid]
                if not mask & 2:
                    face = base_face
                if not mask & 1:
                    city = base_city
            self.face[pid] = face
            name = game.raw[game.offset(pid) + 10:game.offset(pid) + 24].split(b"\0", 1)[0]
            jy.Person[pid] = lua.table_from({
                game_key("姓名"): name, game_key("头像代号"): face,
                game_key("形象"): city, game_key("代号"): pid if pid in campaign_people else game.value(pid, 0),
                game_key("等级"): game.value(pid, 42), game_key("兵种"): game.value(pid, 64),
            })
        for troop, start in enumerate(range(0, len(game.troop_data), TROOP_SIZE)):
            pic, middle, high, enemy, friend, ally = struct.unpack_from("<6h", game.troop_data, start + 138)
            jy.Bingzhong[troop] = lua.table_from({
                game_key("贴图1"): pic, game_key("贴图2"): middle, game_key("贴图3"): high,
                game_key("敌军偏移"): enemy, game_key("友军偏移"): friend, game_key("我军偏移"): ally,
            })
        for pid, (mask, war) in game.flags.items():
            jy.OfficerOverrides[pid] = lua.table_from({b"mask": mask, b"war": war})
        for (pid, troop), (slot, order) in game.battle_slots.items():
            if jy.OfficerBattleSlots[pid] is None:
                jy.OfficerBattleSlots[pid] = lua.table()
            jy.OfficerBattleSlots[pid][troop] = lua.table_from([slot, order])
        main = (script / "jymain.lua").read_bytes()
        lua.execute(main[main.index(b"function GetBZPic("):main.index(b"function koTourRoster(")])
        for file in ("unique.lua", "spriteclass.lua", "officer_editor.lua"):
            lua.execute((script / "addon" / file).read_bytes())
        env.DrawSMap()
        self.city = dict(env.RenderedCity.items())

        env.PreviewPeople = lua.table_from(list(game.people))
        env.PreviewTroops = lua.table_from(list(game.troops))
        self.get_slot, self.find_usage = lua.execute(br"""
            local BZ,LV="\177\248\214\214","\181\200\188\182"
            local usage
            local function slot(pid,bz,lv,enemy,friend)
                local p=JY.Person[pid]
                local oldBZ,oldLV=p[BZ],p[LV]
                p[BZ],p[LV]=bz,lv
                local picture=GetPic(pid,enemy,friend)
                p[BZ],p[LV]=oldBZ,oldLV
                return picture
            end
            local function buildUsage()
                local index={}
                for _,pid in ipairs(PreviewPeople) do
                    local base=JY.Person[pid][BZ]
                    for _,bz in ipairs(PreviewTroops) do
                        local seen={}
                        for _,lv in ipairs({1,20,40}) do
                            for side=1,3 do
                                local pic=slot(pid,bz,lv,side==2,side==3)
                                if not seen[pic] then
                                    seen[pic]=true
                                    if not index[pic] then index[pic]={} end
                                    local rows=index[pic]
                                    rows[#rows+1]={pid,bz,bz==base}
                                end
                            end
                        end
                    end
                end
                return index
            end
            return slot, function(picture)
                usage=usage or buildUsage()
                return usage[picture]
            end
        """)
        self.game = game

    def slot(self, pid, kind, troop=None):
        if kind == "얼굴":
            return self.face[pid]
        if kind == "평상시":
            return self.city[pid]
        troop = self.game.value(pid, 64) if troop is None else troop
        return self.get_slot(pid, troop, self.game.value(pid, 42), False, False)


class AppearanceUsage:
    def __init__(self, root, current, campaign):
        self.root, self.current, self.campaign = root, current, campaign
        self.rules = {}

    def for_story(self, campaign):
        if campaign not in self.rules:
            game = self.current if campaign == self.campaign else Game(self.root, campaign)
            self.rules[campaign] = AppearanceRules(game, campaign)
        return self.rules[campaign]

    def users(self, kind, slot):
        for story, campaign in CAMPAIGNS.items():
            rules = self.for_story(campaign)
            people, troops = rules.game.people, rules.game.troops
            if kind != "전투":
                for pid, name in people.items():
                    if rules.slot(pid, kind) == slot:
                        yield f"{story} · #{pid} {name}"
                continue
            found = rules.find_usage(slot)
            if found is not None:
                by_person = {}
                for row in found.values():
                    pid, troop, current = row[1], row[2], row[3]
                    by_person.setdefault(pid, []).append(troops[troop] + (" (기본)" if current else ""))
                for pid, classes in by_person.items():
                    yield f"{story} · #{pid} {people[pid]} · {', '.join(classes)}"
