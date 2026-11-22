-- ko 3.6 later: 자유 전투 외전 추가 (addon "freeplus", needs free). Three new rows in the 외전 tab, after 마왕 토벌:
-- * 강동의 세 여걸: 손상향 leads 대교·소교·주유 and the Wu generals on the 공안 field (the story's 공안 rows, re-cast).
-- * 선인의 시험: 좌자 leads 선자, 목인, 토인 and a band of sorcerers on 정군산.
--   Both keep every named enemy (fixedAll: never swapped for random generals). In 원정 the leader may not be one of ours.
-- * 와룡의 시련 (8진 = the eight gates of 팔진, its own title-menu row and screen; hidden from the 자유 전투 list: ch 6 has no tab): 북해 > 서주I > 하비 >
--   여남 > 낙II > 한수 > 양평관 > 허창II back to back, then 제8진 on the 이릉 field against 제갈량 and the Shu generals
--   (the stone maze of 어복포 follows 이릉 in the story; they leave my army for that battle). Troops and strategy points are not refilled between
--   floors (the survivors get back 20% of their troops); a general who falls is out for the rest of the run, the others
--   can be sent to any later floor. Enemy level = my level - 2 + 2 a floor (floor 10 = +16; leaders +5). Named enemies who are in my army are
--   swapped for other generals. Floor in 事件1985, base level in 事件1986 of the battle's own record, so a save resumes it.
--   Best floor cleared: CC.koTowerBest (ko_settings), shown in the list.
-- Hooks from free.lua (patch 3.6추가/free_훅): free_prepare, free_tick, free_floor_won, free_next, free_won.
-- Source: 개발용/addon/freeplus_src.lua (UTF-8); script/addon/freeplus.lua is made from it by 개발용/도구/free_hz.pl.
if not koNeeds("free") then return end
local function K(...) return string.char(...) end
local LORD=K(190,253,214,247)-- 君主
local NAME=K(208,213,195,251)-- 姓名
local EV=K(202,194,188,254)-- 事件
local HP,HPMAX=K(177,248,193,166),K(215,238,180,243,177,248,193,166)-- 兵力 最大兵力
local SP,SPMAX=K(178,223,194,212),K(215,238,180,243,178,223,194,212)-- 策略 最大策略
local function find(map,ch,nth)
local k=0
for _,b in ipairs(koFreeData) do if b.map==map and b.ch==ch and not b.side and not b.tower then k=k+1 if k==(nth or 1) then return b end end end
end
local function copyRows(src)
local t={}
for _,r in ipairs(src) do local row={} for k=1,11 do row[k]=r[k] end t[#t+1]=row end
return t
end
local function copyTeam(src)
local t={}
for _,s in ipairs(src) do t[#t+1]={s[1],s[2],s[3]} end
return t
end
-- recast rows: {old pid-1, new pid, class, level}
local function recast(rows,list)
for _,x in ipairs(list) do
for _,r in ipairs(rows) do
if r[1]==x[1] then r[1]=x[2]-1 r[7]=x[3] r[6]=x[4] break end
end
end
return rows
end
-- 6.0 (11-02) 이야기판: 이야기 모드면 script/camp/<id>/tower_data.lua(koTowerStory, 도구/캠페인시련.py)의 이름 · 전투(사건 번호) · 마지막 진 대장 · 대사.
-- 외전 두 전투(세 여걸 · 선인)는 영걸전 지도 · 사람이라 이야기 모드엔 그 이야기판(side_data.lua, 아래)으로 바꿈. 표가 없으면 시련도 없음.
local TS=nil
if rawget(_G,"koCamp") then
koTowerStory=nil
pcall(dofile,CONFIG.koCampScript.."tower_data.lua")
TS=rawget(_G,"koTowerStory")
end
local TN=TS and TS.name or "\135\122\135\108\131\080 \130\086\131\120"
local TBOSS=TS and TS.talker or 126
local function byEv(ev) for _,b in ipairs(koFreeData) do if b.ev==ev and not b.side and not b.tower then return b end end end
local function short(w) return (string.gsub(w,"^[^ ]*\131\097 ","")) end
-- ---------------------------------------------------------------- 외전 two battles
local SIDE={}
if not rawget(_G,"koCamp") then
local a=find(28,3)-- 공안
if a then
local rows=recast(copyRows(a.enemy),{{142,410,33,68},{164,411,34,64},{147,412,34,64},{173,143,16,64}})
-- 3.6 later, harder: everyone but 손상향 comes at you (ai 1 적극, the story had them all holding), story levels 58~68,
-- and +8 levels over the chosen enemy level in the other two modes (lvBonus, free.lua)
for _,r in ipairs(rows) do
if r[1]~=409 then r[5]=1 end
if r[6]<64 then r[6]=koFreeIsGeneric(r[1]+1) and 58 or 62 end
end
SIDE[#SIDE+1]={map=a.map,ch=5,name="\130\073\130\108\131\080 \131\111 \129\098\130\064",turn=a.turn,l2=409,bgm=a.bgm,fixed=true,lvBonus=8,fixedAll=true,side=true,
 team=copyTeam(a.team),enemy=rows,items={},golds={},
 intro={"\135\089\129\067\134\089\129\071 \130\095\132\087\161\164\129\109\132\087\135\122 \137\072\138\095*\130\073\130\108\131\080 \131\097\129\113\131\082\129\083 \129\071\136\110\131\100 \134\114\129\083 \135\102\131\116\129\077.","\136\100\129\123 \130\094\133\094\130\104 \136\101 \131\111 \129\098\130\064\129\083*\135\105\129\066 \137\077 \129\113 \132\079\134\121\130\098\129\094!"}}
end
local c=find(39,3)-- 정군산
if c then
local rows=recast(copyRows(c.enemy),{{17,390,35,50},{102,389,35,48},{209,388,29,48},{36,414,36,46}})
for _,r in ipairs(rows) do if r[1]==293 or r[1]==294 or r[1]==295 or r[1]==300 then r[7]=16 end end-- sorcerers
SIDE[#SIDE+1]={map=c.map,ch=5,name="\133\109\129\106\131\080 \130\086\133\085",turn=c.turn,l2=389,bgm=c.bgm,fixed=true,fixedAll=true,side=true,
 team=copyTeam(c.team),enemy=rows,items={},golds={},
 intro={"\129\070\130\084\132\091 \137\064\130\095\131\071\129\102\131\087 \133\112\133\120\129\094 \137\121\130\098\129\077.*'\133\109\129\068\130\104 \130\119\129\111\129\077\129\065 \137\113\133\102 \131\095 \130\086\133\085\129\083 \132\124\130\083\130\102.'","\133\109\133\120\135\122 \131\099\129\106\161\164\137\083\129\106, \131\091\129\117\131\100 \131\072\130\114\131\082\129\071*\132\091\134\114 \135\069\135\069\129\102\131\087 \131\071\129\077\129\117\131\100 \132\079\129\077."}}
end
end
-- 6.0 (11-03) 이야기판 외전 두 전투: script/camp/<id>/side_data.lua(koSideStory, 도구/캠페인외전.py) — 그 이야기 자유 전투(사건 번호)의 지도 · 적 줄에
-- 이름 있는 장수를 바꿔 넣음(recast {옛 번호, 새 번호, 병종, 원작 레벨}, 번호는 1부터). kind A = 세 여걸 자리(대장 말고 모두 적극, 레벨 58~68, lvBonus 8),
-- kind B = 선인의 시험 자리(좌자 · 선자 · 목인 · 토인 + 술사 sorc, 나머지 42 이상). 줄은 모든 애드온이 올라온 뒤(loaded, free.lua 의 이야기 마왕 토벌 다음)에 붙임.
local SIDES=nil
if rawget(_G,"koCamp") then
koSideStory=nil
pcall(dofile,CONFIG.koCampScript.."side_data.lua")
SIDES=rawget(_G,"koSideStory")
end
for _,s in ipairs(SIDES or {}) do
local a=byEv(s.ev)
if a then
local rows=copyRows(a.enemy)
local new={}
for _,x in ipairs(s.recast) do
for _,r in ipairs(rows) do
if r[1]==x[1]-1 and not new[r] then r[1]=x[2]-1 r[7]=x[3] r[6]=x[4] r[11]=0 new[r]=true break end
end
end
local sorc={}
for _,p in ipairs(s.sorc or {}) do sorc[p-1]=true end
for _,r in ipairs(rows) do
if sorc[r[1]] and not new[r] then r[7]=16 end
if s.kind=="A" then
if r[1]~=s.leader-1 then r[5]=1 end
if not new[r] then r[6]=koFreeIsGeneric(r[1]+1) and 58 or 62 end
elseif not new[r] then r[6]=math.max(r[6],42)
end
end
SIDE[#SIDE+1]={map=a.map,ch=5,name=s.name,turn=a.turn,l2=s.leader-1,bgm=a.bgm,fixed=true,lvBonus=(s.kind=="A") and 8 or nil,fixedAll=true,side=true,
 team=copyTeam(a.team),enemy=rows,items={},golds={},intro=s.intro}
end
end
if SIDES then
koOn("loaded",function() for _,b in ipairs(SIDE) do koFreeData[#koFreeData+1]=b end return nil end)
else
for _,b in ipairs(SIDE) do koFreeData[#koFreeData+1]=b end
end
-- ---------------------------------------------------------------- 와룡의 시련
local FLOORS={}
if TS then
for _,ev in ipairs(TS.floors) do local b=byEv(ev) if b then FLOORS[#FLOORS+1]={src=b,label=short(b.name)} end end
local y=byEv(TS.boss.ev)
if y then
local rows=copyRows(y.enemy)
local l2=TS.boss.leader-1
for _,r in ipairs(rows) do r[5]=(r[1]==l2) and 2 or 1 end
FLOORS[#FLOORS+1]={src={map=y.map,turn=45,l2=l2,bgm=y.bgm,team=copyTeam(y.team),enemy=rows,fixed=true},label=short(y.name),boss=true}
end
else
for _,m in ipairs({{8,1,"\131\087\130\075I"},{14,1,"\129\097\130\080"},{19,2,"\129\098\133\103"},{33,3,"\132\089II",2},{41,3,"\129\111\129\113"},{42,3,"\134\111\131\119\129\101"},{51,4,"\135\109\134\103II"}}) do
local b=find(m[1],m[2],m[4])
if b then FLOORS[#FLOORS+1]={src=b,label=m[3]} end
end
-- 제8진: the 이릉 rows with 제갈량 (holding, leader) and Shu generals (attacking) in the places of 육손 and the Wu officers;
-- classes are each general's own (set when the floor starts), the soldiers' 창·기병 rows become sorcerers
do
local y=find(44,3)
if y then
local rows=recast(copyRows(y.enemy),{{150,126,0,0},{44,244,0,0},{162,127,0,0},{147,204,0,0},{166,252,0,0},{165,30,0,0},{164,44,0,0},
 {173,175,0,0},{107,31,0,0},{45,34,0,0},{155,170,0,0},{156,190,0,0},{157,188,0,0},{158,128,0,0}})
for _,r in ipairs(rows) do
r[5]=(r[1]==125) and 2 or 1
if r[7]==12 or r[7]==17 then r[7]=16 end
end
FLOORS[#FLOORS+1]={src={map=y.map,turn=45,l2=125,bgm=y.bgm,team=copyTeam(y.team),enemy=rows,fixed=true},label="\129\071\142\083",boss=true}
end
end
end
-- the eight formations of the 팔진도, one to a 진 (the last, 사반진, is 제갈량's own)
local JIN=TS and TS.jin or {"\130\115\130\068\129\103","\130\067\129\115\129\103","\134\083\134\111\129\103","\135\083\129\113\129\103","\132\111\130\080\129\103","\134\113\133\083\129\103","\129\118\129\067\129\103","\130\114\133\065\129\103"}
for i,fl in ipairs(FLOORS) do fl.jin=JIN[i] or "" end
local TOWER=nil
if #FLOORS==8 then
local f1=FLOORS[1].src
TOWER={map=f1.map,ch=6,name=TN,turn=f1.turn,l2=f1.l2,bgm=f1.bgm,tower=true,
 team=copyTeam(f1.team),enemy=copyRows(f1.enemy),items={},golds={}}
koFreeData[#koFreeData+1]=TOWER
end
local function towerFloor() return math.max(1,JY.Base[EV.."1985"] or 1) end
local function setFloor(n) JY.Base[EV.."1985"]=n end
local function towerBase() return JY.Base[EV.."1986"] or 20 end
-- floor n's enemy level: two below mine on floor 1, two more a floor. 5.0: an army that grew faster than that pulls the
-- enemies along (its six highest levels now, -2, +1 a floor), so the later floors do not turn easy (player feedback)
local function armyLevel()
local LV=K(181,200,188,182)-- 等级
local t={}
for i=1,JY.PersonNum-1 do if JY.Person[i][LORD]==1 then t[#t+1]=JY.Person[i][LV] end end
table.sort(t,function(a,b) return a>b end)
local n=math.min(6,#t)
if n==0 then return 0 end
local s=0
for k=1,n do s=s+t[k] end
return math.floor(s/n)
end
local function floorLevel(n) return math.max(1,math.min(99,math.max(towerBase()-2+(n-1)*2,armyLevel()-2+(n-1)))) end
-- floor n: its rows at the tower levels, named enemies of my army swapped. Returns rows, leader (pid-1 or -1)
local function floorRows(n,pool,mine)
local src=FLOORS[n].src
local rows=copyRows(src.enemy)
local leader=-1
local lv=floorLevel(n)
-- 4.0 fix: the named enemies who stay on this floor are never drawn as stand-ins (two units on one record: a fallen copy stood in the way at 0 troops)
local stay={}
for _,r in ipairs(rows) do local id=r[1]+1 if src.fixed or not mine[id] then stay[id]=true end end
for k=#pool,1,-1 do if stay[pool[k]] then table.remove(pool,k) end end
for _,r in ipairs(rows) do
local id=r[1]+1
local isLeader=(r[1]==src.l2)
if src.fixed then-- 제8진: nobody is swapped; named generals fight in their own class, 6 levels up (제갈량 12)
if not koFreeIsGeneric(id) then r[7]=JY.Person[id][K(177,248,214,214)] if not isLeader then r[6]=math.min(99,lv+6) end end
elseif mine[id] and not koFreeIsGeneric(id) and #pool>0 then
local nid=table.remove(pool,math.random(#pool))
r[1]=nid-1
r[7]=JY.Person[nid][K(177,248,214,214)]-- 兵种: its own class
end
if isLeader then leader=r[1] end
if isLeader then r[6]=math.min(99,lv+(src.fixed and 12 or 5)) elseif not (src.fixed and not koFreeIsGeneric(id)) then r[6]=math.min(99,lv) end
end
return rows,leader
end
-- koFreeStart, after the record is set up: the tower's floor 1 / the side battles' checks
koOn("free_prepare",function(b,opt,exp)
if b.side and exp and JY.Person[b.l2+1][LORD]==1 then
WarDrawStrBoxConfirm(JY.Person[b.l2+1][NAME].."\129\071(\129\094) \129\071\134\119 \129\110\130\084\129\071\130\102*\129\071 \130\066\132\101\130\098 \131\081\129\070\131\109\132\083 \129\088 \129\113 \130\097\129\075\129\076\129\077",M_White,true)
return false
end
if b.tower then
if exp then WarDrawStrBoxConfirm(TN.."\131\098 \131\081\129\070\131\109\132\083 \129\088 \129\113 \130\097\129\075\129\076\129\077",M_White,true) return false end
-- floor 1 at my level (the rows are set now; the level buttons of the settings screen are overridden)
opt.elvmode=2 opt.elv=math.max(1,opt.mylv-2)
local f1=FLOORS[1].src
b.map,b.turn,b.l2,b.bgm=f1.map,f1.turn,f1.l2,f1.bgm
b.team=copyTeam(f1.team) b.enemy=copyRows(f1.enemy)
end
return nil
end)
-- the first event of every battle / floor
koOn("free_tick",function(f,b)
if b.side and not f.sideIntro then
f.sideIntro=true
if (War.Turn or 1)==1 then for _,s in ipairs(b.intro or {}) do WarDrawStrBoxWaitKey(s,M_White) end end
end
if not b.tower then return nil end
if (JY.Base[EV.."1985"] or 0)==0 then-- a fresh run: floor 1, the base level from the settings
setFloor(1)
JY.Base[EV.."1986"]=(f.opt and f.opt.mylv) or 20
end
if f.towerTroops then-- the floor has begun: my generals back to the troops they carried in
for i=1,War.PersonNum do
local v=War.Person[i]
local s=f.towerTroops[v.id]
if s and not v.enemy then
local p=JY.Person[v.id]
p[HP]=math.max(1,math.min(s[1],p[HPMAX]))
p[SP]=math.min(s[2],p[SPMAX])
WarResetStatus(i)
end
end
f.towerTroops=nil
end
if f.towerIntro~=towerFloor() then
f.towerIntro=towerFloor()
if (War.Turn or 1)==1 then
local n=towerFloor()
WarDrawStrBoxWaitKey(TN.." \129\100"..n.."\129\103 "..FLOORS[n].jin.." ("..n.."/"..#FLOORS..")*"..FLOORS[n].label.." \130\066\131\097  (\131\076 \130\082\130\123 "..floorLevel(n)..")",M_White)
if FLOORS[n].boss then
for _,l in ipairs(TS and TS.bossLines or {"\129\098\131\071\129\089\130\067 \131\105\130\102\134\091 \131\117\131\098 \141\087\135\090\129\066 \133\119\129\117\130\067\129\090.*\135\109\131\118 \129\071 \137\079\129\103\131\098 \131\091\129\117 \135\064\129\081 \141\090\130\067\130\067 \130\107\129\083 \131\117\129\071\129\091.","\129\098\144\106 \133\090 \129\094\135\083\133\104 \134\106\129\110 \131\118\135\121 \133\090\131\098 \129\097\131\118.*\129\071 \135\122\135\108\129\083 \132\124\130\083 \131\115\130\086\129\091!"}) do talk(TBOSS,l) end
end
end
end
return nil
end)
local function towerBestSet(n)
if n>(CC.koTowerBest or 0) then CC.koTowerBest=n koSave() end
end
-- a floor won: below the top, the fallen are marked (troops 0) and the survivors heal 20%; on to the next floor
koOn("free_floor_won",function(f)
local b=koFreeData[f.idx]
if not (b and b.tower) then return nil end
local n=towerFloor()
towerBestSet(n)
if n>=#FLOORS then return nil end-- the top: the normal win
for i=1,War.PersonNum do
local v=War.Person[i]
if v and not v.enemy and not v.friend then
local p=JY.Person[v.id]
if v.live then p[HP]=math.min(p[HPMAX],p[HP]+math.floor(p[HPMAX]/5))
elseif not v.hide then p[HP]=0 end
end
end
PlayWavE(12)
WarDrawStrBoxWaitKey("\129\100"..n.."\129\103 "..FLOORS[n].jin.." \137\066\134\086!*\134\106\129\110\133\103\131\098 \130\094\130\095\130\098 \130\126\131\125\129\083 \129\118\131\103 \130\125\130\068\129\097\131\100*\129\077\130\077 \129\103\131\109\132\083 \131\118\129\110\133\121\129\077.",M_White)
f.towerNext=true
JY.Status=GAME_SMAP_AUTO
return true
end)
-- the next floor (the event run after the floor's end)
koOn("free_next",function(f)
if not f.towerNext then return nil end
f.towerNext=nil
local b=koFreeData[f.idx]
local n=towerFloor()+1
setFloor(n)
local fl=FLOORS[n].src
-- my army as it stands: troops now (0 = fallen, out of the run)
-- 제8진: its named generals leave my army for good (the run ends with this battle)
if fl.fixed then
for _,r in ipairs(fl.enemy) do local id=r[1]+1 if not koFreeIsGeneric(id) then JY.Person[id][LORD]=0 end end
end
local mine,alive,off={},{},{}
for i=1,JY.PersonNum-1 do
if JY.Person[i][LORD]==1 then
mine[i]=true
local p=JY.Person[i]
if (p[HP] or 0)>0 then alive[i]={p[HP],p[SP]} else off[#off+1]=i end
end
end
local pool=koFreePool(true)
local rows,leader=floorRows(n,pool,mine)
for _,i in ipairs(off) do JY.Person[i][LORD]=0 end
b.bgm=fl.bgm
WarIni()
local target="1. \131\076 \130\066\134\085"
if leader>=0 then target="1. "..JY.Person[leader+1][NAME].." \130\112\134\086*2. \131\076 \130\066\134\085" end
DefineWarMap(fl.map,b.name,target,fl.turn,-1,leader)
local team={}
for _,s in ipairs(fl.team) do
local k=#team
team[k+1]=-1 team[k+2]=s[1] team[k+3]=s[2] team[k+4]=s[3] team[k+5]=0 team[k+6]=-1 team[k+7]=0
end
JY.Status=GAME_SMAP_AUTO
SelectTerm(1,team)-- (refills everyone: put the carried troops back just after)
for _,i in ipairs(off) do JY.Person[i][LORD]=1 JY.Person[i][HP]=0 end
for i,s in pairs(alive) do JY.Person[i][HP]=s[1] JY.Person[i][SP]=s[2] end
if War.PersonNum==0 then
koFreeLost(f)
CC.koFree=nil
CC.koReplay=nil
JY.Status=GAME_START
return true
end
f.towerTroops=alive-- the battle start refills the deployed ones again: put back at the first event (free_tick)
local flat={}
for _,r in ipairs(rows) do for k=1,11 do flat[#flat+1]=r[k] end end
SelectEnemy(flat)
local k=0
for wid=1,War.PersonNum do
local v=War.Person[wid]
if v.enemy then
k=k+1
local r=rows[k]
if r then koFreeSetLevel(v.id,r[6],r[7]) end
end
end
f.started=false f.towerIntro=nil
Event[koFreeEID]=koFreeEvent
JY.EventID=koFreeEID
JY.Status=GAME_WMAP
return true
end)
-- a lost run: the floors cleared so far are what counts
local rawLost=koFreeLost
koFreeLost=function(f,...)
local b=koFreeData[f.idx or 0]
if b and b.tower and not f.recorded then towerBestSet(towerFloor()-1) end
return rawLost(f,...)
end
local rawShort=koFreeRecShort
koFreeRecShort=function(idx,t,...)
local s=rawShort(idx,t,...)
local b=koFreeData[idx]
if b and b.tower and (CC.koTowerBest or 0)>0 then s=((s~="") and (s.." ") or "").."\136\122\131\100 \129\100"..CC.koTowerBest.."\129\103" end
return s
end
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koTowerBest",default=0}
-- the whole maze broken (제8진 won): 제갈량's word, then the normal free-battle win
koOn("free_won",function(f)
local b=koFreeData[f.idx or 0]
if not (b and b.tower) then return nil end
talk(TBOSS,TS and TS.winLine or "\134\124\134\125\129\097\129\091. \129\071 \137\079\129\103\129\083 \141\090\132\093\129\117\129\077\129\076*\130\115\129\097\130\104 \138\069\134\114 \132\086\129\111 \131\097\129\113\131\082\129\071\130\119\131\096.")
PlayWavE(12)
WarDrawStrBoxWaitKey(TS and TS.winBox or "\135\122\135\108\131\080 \130\086\131\120 \137\066\134\086!*\129\098\144\106 \143\119\131\080 \129\103\129\083 \130\090\130\091 \140\067\131\100 \135\122\135\108\129\083 \132\124\130\083\140\085\129\077.",M_White)
return nil
end)
-- ---------------------------------------------------------------- the 와룡의 시련 title-menu row and its screen
local function towerIdx()
for i,b in ipairs(koFreeData) do if b.tower then return i end end
return 0
end
function koPalScreen()
local idx=towerIdx()
if idx==0 then return end
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
local cx=ox+384
local lv=50-- 11-04: fixed level (no picker)
local function ctext(y,s,color,size) size=size or 16 DrawString(cx-#s*size/4,y,s,color or M_White,size) end
local LY=oy+372
local btns={
{x=cx-200,y=oy+430,w=180,h=28,s="\129\068\130\066 \130\086\129\074"},
{x=cx+20,y=oy+430,w=180,h=28,s="\137\066\129\110\129\094\131\071"},
}
local function draw(hov)
koFreeClassicBack()
ctext(oy+34,TN,C_Name,32)
ctext(oy+86,TS and TS.desc or "\129\100\135\121\132\088\129\071 \144\067\131\098 \137\066\131\080 \129\103\136\070. \129\098\144\106 \143\119\131\080 \129\103\129\083 \140\067\131\100 \135\122\135\108\129\123 \132\125\131\094\130\086\129\091",M_White)
ctext(oy+112,"\129\103 \130\114\129\071\129\102 \130\126\131\125\161\164\130\117\130\118\132\081\129\094 \132\121\130\067 \130\107\129\075\129\076\129\077 (\134\106\129\110\133\103\131\098 \130\094\130\095\132\086 20% \130\125\130\068)",M_Silver)
ctext(oy+136,"\129\110\130\084\131\098 \130\090\130\091 \130\082\130\123 "..lv.."\132\083 \131\118\134\098\129\076\129\077. \133\068\130\069\129\111 \131\097\129\113\130\098 \136\102 \131\118\129\094\131\100, \131\076 \130\082\130\123\131\098 \129\103\133\088\129\077 2\143\093 \129\091\139\123\129\076\129\077",M_Silver)
local base=lv
for n=1,#FLOORS do
local col,row=(n>4) and 1 or 0,(n-1)%4
local x=ox+60+col*340
local y=oy+180+row*38
local fl=FLOORS[n]
local elv=math.max(1,math.min(99,base-2+(n-1)*2))
local best=CC.koTowerBest or 0
local c=(n<=best) and C_Name or M_White
DrawString(x,y,"\129\100"..n.."\129\103",c,16)
DrawString(x+56,y,fl.jin,fl.boss and M_Yellow or c,16)
DrawString(x+112,y,fl.boss and (TS and TS.bossLabel or "\129\071\142\083\161\164\129\100\135\121\132\088") or fl.label,fl.boss and M_Yellow or M_Silver,16)
local s="\131\076"..#fl.src.enemy.." Lv"..elv
DrawString(x+300-#s*8,y,s,M_Gray,16)
end
local r=(koFreeRecTable()[idx]) or {w=0,l=0}
ctext(oy+346,TS and "\131\071\133\108 \161\164 \131\115\129\067\131\098 \129\071 \129\071\133\069\131\071\129\102\132\086 \133\103\129\075\129\076\129\077" or "\129\1005\129\103 \137\066\134\086: \131\072\134\076\129\102 \163\191\163\191\163\191   \129\1008\129\103 \137\066\134\086: \131\072\134\076\129\102 \129\113\131\064 \133\109\129\096 \130\114\133\088\130\103",M_Yellow)
ctext(oy+382,"\136\122\131\100 \131\071\133\108 \129\100"..math.min(CC.koTowerBest or 0,#FLOORS).."\129\103   \129\068\130\066 "..(r.w+r.l).."\130\125   \137\066\134\086 "..r.w.."\130\125",C_Name)
end
while true do
local r=koFreeClassicWait(draw,btns)
if r==0 or r==2 then return end
if r==1 then

if koFreeStart(idx,{rand=0,elvmode=2,elv=math.max(1,lv-2),mylv=lv,cost=0}) then return end
end
end
end
if TOWER then koAddon.titleMenu[#koAddon.titleMenu+1]={label=TN,run=function() koPalScreen() end} end
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koTowerLv",default=50}
-- ---------------------------------------------------------------- 와룡의 시련 보상 (도시 기능 메뉴)
-- Each 진 broken is recorded machine-wide (CC.koTowerBest); each story save (and each cycle) can then take the reward of
-- every 진 up to that once here. Taken = 事件1987 bit 2^(n-1). 제8진 = 팔진서 (도구 174, patch_팔진서_데이터.pl).
local TREWARD={
{gold=2000},
{items={173}},
{items={71}},
{items={72}},
{items={73},gold=5000},
{items={173,173}},
{items={71,72,73}},
{items={174}},
}
local ITEM=K(181,192,190,223)-- 道具
local INAME=K(195,251,179,198)-- 名称
local function bitOf(n) return 2^(n-1) end
local function taken(n) return math.floor((JY.Base[EV.."1987"] or 0)/bitOf(n))%2==1 end
local function take(n) if not taken(n) then JY.Base[EV.."1987"]=(JY.Base[EV.."1987"] or 0)+bitOf(n) end end
local function rewardText(r)
local t={}
if r.gold then t[#t+1]="\131\103 "..r.gold end
local cnt,ord={},{}
for _,it in ipairs(r.items or {}) do if not cnt[it] then ord[#ord+1]=it cnt[it]=0 end cnt[it]=cnt[it]+1 end
for _,it in ipairs(ord) do t[#t+1]=JY.Item[it][INAME]..((cnt[it]>1) and (" "..cnt[it].."\134\075") or "") end
return table.concat(t,", ")
end
-- the bags of my generals (유비 first): free slots, and putting one item in; returns the holder's name
local function bagOrder()
local order={}
if JY.Person[1][LORD]==1 then order[1]=1 end
for i=2,JY.PersonNum-1 do if JY.Person[i][LORD]==1 then order[#order+1]=i end end
return order
end
local function freeSlots()
local n=0
for _,pid in ipairs(bagOrder()) do for s=1,8 do if JY.Person[pid][ITEM..s]==0 then n=n+1 end end end
return n
end
local function putItem(it)
for _,pid in ipairs(bagOrder()) do
for s=1,8 do if JY.Person[pid][ITEM..s]==0 then JY.Person[pid][ITEM..s]=it return JY.Person[pid][NAME] end end
end
return nil
end
-- the panel: a row per 진 (name, reward, 받음 / 받을 수 있음 / 아직), [모두 받기] [닫기]
function koTowerReward()
local best=math.min(CC.koTowerBest or 0,#FLOORS)
local W,RH=600,26
local H=56+#TREWARD*RH+70
local X=math.floor((CC.ScreenW-W)/2)
local Y=math.floor((CC.ScreenH-H)/2)
if JY.Status~=GAME_WMAP then X=16+math.floor((640-W)/2) Y=16+math.floor((400-H)/2) end-- 10-14: the city map frame (16,16)-(656,416), not the whole screen
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local note=""
local function readyList()
local t={}
for n=1,#TREWARD do if not taken(n) and best>=n then t[#t+1]=n end end
return t
end
local btns={}
local function mk()
btns={}
if #readyList()>0 then btns[#btns+1]={x=X+W/2-170,y=Y+H-40,w=160,h=28,s="\130\090\130\091 \133\072\131\071",get=true} end
btns[#btns+1]={x=X+W/2+10,y=Y+H-40,w=160,h=28,s="\137\066\129\110\129\094\131\071"}
if #btns==1 then btns[1].x=X+W/2-80 end
for _,b in ipairs(btns) do
b.draw=function(b,on,hover)
-- A wider bar uses the same clipped artwork pieces as the original menu.
local pic=((on or hover) and 62 or 61)*2
local yy=b.y+3
lib.SetClip(b.x,yy,b.x+126,yy+22)
lib.PicLoadCache(4,pic,b.x,yy,1)
lib.SetClip(b.x+126,yy,b.x+b.w,yy+22)
lib.PicLoadCache(4,pic,b.x+b.w-130,yy,1)
lib.SetClip(0,0,0,0)
DrawString(b.x+b.w/2-#b.s*4,b.y+6,b.s,M_White,16)
end
end
end
local function draw()
lib.LoadSur(sid,0,0)
lib.Background(0,0,CC.ScreenW,CC.ScreenH,128,M_Black)
koRecordClassicFrame(X,Y,W,H)
DrawString(X+20,Y+14,TN.." \131\115\129\067",M_Yellow,16)
local sub="\136\122\131\100 \131\071\133\108 \129\100"..best.."\129\103"
DrawString(X+W-20-#sub*8,Y+14,sub,M_White,16)
lib.DrawRect(X+10,Y+40,X+W-10,Y+40,M_Silver)
for n,r in ipairs(TREWARD) do
local y=Y+48+(n-1)*RH
local st,sc
if taken(n) then st,sc="\133\072\130\077",M_Gray elseif best>=n then st,sc="\133\072\129\083 \129\113 \132\079\130\077",M_Yellow else st,sc="\129\110\132\076",M_Silver end
local nc=(best>=n) and C_Name or M_Silver
DrawString(X+20,y,"\129\100"..n.."\129\103 "..(FLOORS[n] and FLOORS[n].jin or ""),nc,16)
DrawString(X+140,y,rewardText(r),(best>=n) and M_White or M_Silver,16)
DrawString(X+W-20-#st*8,y,st,sc,16)
end
if note~="" then DrawString(X+W/2-#note*4,Y+H-64,note,M_Yellow,16)
elseif best<#TREWARD then local s=TN.."\131\098 \133\064\129\071\140\071 \129\064\129\065\129\102\131\087 \129\087\129\076\129\077" DrawString(X+W/2-#s*4,Y+H-64,s,M_Silver,16) end
end
while true do
mk()
local r=koFreeClassicWait(draw,btns)
if r==0 or not btns[r] or not btns[r].get then break end
local got,short={},false
local cnt={}
for _,n in ipairs(readyList()) do
local rw=TREWARD[n]
if #(rw.items or {})>freeSlots() then short=true break end
if rw.gold then koSetGold(koGold()+rw.gold) koHook("gold_gain",rw.gold) got[#got+1]="\131\103 "..rw.gold end
for _,it in ipairs(rw.items or {}) do local who=putItem(it) if who then if not cnt[who] then cnt[who]=0 got[#got+1]=who end cnt[who]=cnt[who]+1 end end
take(n)
end
local t={}
for _,g in ipairs(got) do t[#t+1]=cnt[g] and (g.." \129\068\130\119 "..cnt[g].."\134\075") or g end
PlayWavE(11)
note=(#t>0) and ("\133\072\131\116\129\075\129\076\129\077: "..table.concat(t,", ")) or ""
if short then note=note..((note~="") and "  " or "").."(\129\068\130\119 \135\066\129\071 \130\090\133\120\130\102 \133\103\131\098 \131\117\131\098 \136\102 \133\072\130\077)" end
end
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
end
if TOWER then koAddon.cityMenu[#koAddon.cityMenu+1]={label=TS and TS.reward or "\135\122\135\108\131\080 \131\115\129\067",run=function() koTowerReward() end} end
