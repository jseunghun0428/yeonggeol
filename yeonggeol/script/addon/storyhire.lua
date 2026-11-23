-- ko 5.1 (10-14): storyhire — 이야기 무장 조기 등용 · 적으로 나올 때 주차 · 창고
-- (UTF-8 원본: 개발용/addon/storyhire_src.lua -> 도구/free_hz.pl -> script/addon/storyhire.lua)
--
-- 1. 술집: 2회차부터, 지난 회차에 한 번이라도 아군이었던(도감 1840 비트, koRecMet) 이야기 무장을
--    1장부터 그 무장의 첫 이야기 합류 사건 전까지 주점에서 등용할 수 있다 (jymain HirePerson 의 tavern_more 훅,
--    가격 = 술집 무장과 같은 GetPersonValue, 대화 대사가 없으니 town 의 옛 구매 방식). 이야기가 소속을 바꾼 무장
--    (君主 가 처음 값과 다름: 적 소속으로 빠진 장료 등)은 다시 내놓지 않는다.
-- 2. 주차: 우리 편인 이야기 무장이 적으로 나오는 전투(ENEMY, kdef SelectEnemy 에서 뽑은 표: 전투를 정하는 사건 번호 → 무장)에
--    들어갈 때(DefineWarMap) 그 기록 152바이트를 영구 칸 602~661 에 통째로 옮겨 두고, 원래 칸은 적에게 준다
--    (소속 = 처음 값, 소지품 = 처음 값; 능력치·특기는 그대로). 전투가 끝나면(war_end) 되돌린다. 술집 등용 무장은 이 보관 칸으로
--    아군 출진이 가능하다. 적 설득·일기토는 원래 칸을 사용한다. 두 유닛과 아군 기록은 전투 중 저장에도 남는다.
-- 3. 창고: 영구 칸 762~781 의 소지품 8칸씩(160칸). 아군 무장이 적 소속 등(ModifyForce fid 0·1 이 아님)으로 빠지면 그 소지품을
--    창고에 맡긴다. 무장 메뉴 「창고」 에서 맡기기·찾기.
-- 칸 602~801 은 jymain 쪽에서 술집·기록 루프가 건드리지 않게 막아 두었다 (patch_이야기조기등용_jymain.pl, _addon.pl).
if not koNeeds("record","town") then return end

local PS=CC.PersonSize
local LORD=string.char(190,253,214,247)      -- 君主
local NAME=string.char(208,213,195,251)      -- 姓名
local LV=string.char(181,200,188,182)        -- 等级
local BZ=string.char(177,248,214,214)        -- 兵种
local SH=rawget(_G,"koCamp") and koCamp.storyhire--ko 6.0 campaigns: that story's own generals (nil = Liu Bei story)
local STORYBZ=(SH and SH.STORYBZ) or {[376]=14,[224]=10}            -- 10-20: the class of the story join when it is not the record's (이명 맹수사, 조하 산적)
local ITEM=string.char(181,192,190,223)      -- 道具 (..1~8)
local WARPIC=string.char(213,189,182,183,182,175,215,247) -- 战斗动作
local COUNT=string.char(206,228,189,171,202,253,193,191)  -- 武将数量
local INAME=string.char(195,251,179,198)     -- 名称 (item)
local O_FACE,O_LORD=6,38                     -- 头像代号, 君主 (byte offsets in a record)
local function O_ITEM(k) return 118+2*k end  -- 道具k

-- 이야기 무장 58명 (view.lua STORY 에서 유비·관우·장비 뺌) — 주차 칸 = 602 + 순서 - 1
local STORY=(SH and SH.STORY) or {24,30,31,34,35,38,39,44,54,58,59,64,65,80,82,83,91,112,114,117,126,127,128,129,133,148,155,165,166,167,170,175,182,188,190,191,
200,201,202,203,204,208,209,221,224,229,235,236,237,244,245,246,248,252,253,254,255,376}
local PARK0,STORE0,STORE_N=602,762,20
local SLOT={}
local PARKED_PERSON={}
for k,p in ipairs(STORY) do
SLOT[p]=PARK0+k-1
PARKED_PERSON[SLOT[p]]=p
end
-- 첫 이야기 합류 사건 (kdef 에서 ModifyForce(p,1) 이 처음 나오는 사건 번호, 700 미만)
local FIRST=(SH and SH.FIRST) or {[24]=510,[30]=593,[31]=396,[34]=568,[35]=510,[38]=568,[39]=568,[44]=593,[54]=73,[58]=60,[59]=60,[64]=100,[65]=123,[80]=654,
[82]=123,[83]=26,[91]=510,[112]=309,[114]=286,[117]=286,[126]=347,[127]=420,[128]=263,[129]=354,[133]=460,[148]=620,[155]=263,[165]=620,
[166]=620,[167]=620,[170]=423,[175]=396,[182]=403,[188]=470,[190]=505,[191]=510,[200]=493,[201]=493,[202]=493,[203]=489,[204]=505,[208]=510,
[209]=510,[221]=37,[224]=114,[229]=118,[235]=635,[236]=635,[237]=635,[244]=635,[245]=45,[246]=45,[248]=277,[252]=536,[253]=593,[254]=493,
[255]=493,[376]=110}
-- 전투를 정하는 사건(DefineWarMap 이 있는 사건) → 그 전투에 적으로 나오는 이야기 무장
local ENEMY=(SH and SH.ENEMY) or {[15]={80},[108]={376},[112]={224},[116]={229},[133]={80},[149]={80},[162]={80},[352]={80,129},[365]={127},[370]={80},[373]={80},
[386]={148,165,166,167},[399]={182},[414]={127,170},[436]={148,165,166,167},[479]={200,201,202},[490]={200,201,202,254,255},[500]={190,204},
[508]={24,35,91,191,208,209},[534]={252},[547]={252},[586]={148,165,166,167},[621]={80},[625]={80},[633]={235,236,237,244},[637]={112},
[643]={112},[646]={80},[652]={80},[658]={80},[661]={80},[664]={80},[700]={80},[711]={80},[762]={148,167},[841]={203}}
-- 연고 마을 (주점; town 의 STAY 와 같은 뜻, 그 지역·이웃에 열린 주점이 없으면 열린 주점 아무 곳)
local HOME=(SH and SH.HOME) or {[24]="\131\123\129\068",[30]="\130\073\142\083",[31]="\134\111\134\111",[34]="\134\111\134\111",[35]="\134\101\129\100",[38]="\130\073\142\083",[39]="\130\073\142\083",[44]="\131\078\133\069",[54]="\135\107\131\119",[58]="\131\078\129\068",[59]="\131\078\129\068",
[64]="\131\087\130\075",[65]="\131\087\130\075",[80]="\129\097\130\080",[82]="\131\087\130\075",[83]="\129\109\129\079",[91]="\131\123\129\068",[112]="\131\078\133\069",[114]="\134\111\134\111",[117]="\131\078\133\069",[126]="\135\088\130\101",[127]="\134\111\134\111",
[128]="\131\100\131\123",[129]="\135\109\134\103",[133]="\135\088\130\101",[148]="\130\073\129\097",[155]="\131\100\131\123",[165]="\130\073\129\097",[166]="\130\073\129\097",[167]="\130\073\129\097",[170]="\136\074\134\111\129\114",[175]="\134\111\134\111",[182]="\136\074\134\111\129\114",
[188]="\131\123\129\068",[190]="\134\108",[191]="\131\123\129\068",[200]="\131\123\129\068",[201]="\132\089",[202]="\132\089",[203]="\134\101\129\100",[204]="\134\108",[208]="\130\094",[209]="\130\094",[221]="\131\078\129\068",[224]="\131\087\130\075",
[229]="\129\097\130\080",[235]="\134\108",[236]="\134\108",[237]="\134\108",[244]="\134\108",[245]="\131\078\129\068",[246]="\131\078\129\068",[248]="\129\098\133\103",[252]="\130\094",[253]="\131\078\133\069",[254]="\132\089",[255]="\132\089",[376]="\135\107\129\066"}
-- 11-03 (사용자 「금을 주고 등용했는데 이탈 — 불합리」 → 미리 알리기 + 금 돌려주기): 이야기에서 영영 떠나는 무장 → 마지막으로 빠지는 사건
-- (도구/이탈목록.py write: 이야기 사건의 ModifyForce 를 사건 순서로 보고 끝이 우리 편이 아닌 무장; 이야기 모드는 camp.lua storyhire.LEAVE)
local LEAVE=(SH and SH.LEAVE) or {[35]=588}
-- 11-03 (사용자 2 + 3): 한동안 떠났다 돌아오는 무장 중 대사를 읽어 고른 「진짜 이탈」 → 그 이탈 사건 (군대 나누기 · 심부름 · 전투 중 죽음은 뺌).
-- 영영 떠나는 무장처럼 미리 알리고, 떠날 때 금을 돌려준다(돌아올 때는 이야기대로 그냥 합류). 장료는 174 뒤엔 조조 소속이라 원래 규칙대로 안 내놓음
local AWAY=(SH and SH.AWAY) or {[54]=102,[80]=174,[112]=329}
local function goneEv(p) return LEAVE[p] or AWAY[p] end
-- 조기 등용 때 낸 금: 창고 첫 칸(762)의 안 쓰는 자리(소지품은 120~134, 얼굴 6 · 소속 38 · 이름 10~23 은 비움)에 무장마다 16비트 두 개
local PAIDOFS={0,2,4,8,24,26,28,30,32,34,36,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86,88}
local PAIDIX={}
do local ks={} for p,_ in pairs(LEAVE) do ks[#ks+1]=p end for p,_ in pairs(AWAY) do if not LEAVE[p] then ks[#ks+1]=p end end table.sort(ks) for i,p in ipairs(ks) do if 2*i<=#PAIDOFS then PAIDIX[p]=i end end end
local function paidGet(p)
local i=PAIDIX[p]
if not i or (JY.PersonNum or 0)<=762 then return 0 end
return Byte.get16(JY.Data_Person,762*PS+PAIDOFS[2*i-1])+Byte.get16(JY.Data_Person,762*PS+PAIDOFS[2*i])*10000
end
local function paidSet(p,v)
local i=PAIDIX[p]
if not i or (JY.PersonNum or 0)<=762 then return end
v=math.max(0,math.floor(v or 0))
Byte.set16(JY.Data_Person,762*PS+PAIDOFS[2*i-1],v%10000)
Byte.set16(JY.Data_Person,762*PS+PAIDOFS[2*i],math.floor(v/10000))
end
function koStoryLeaves(p) return LEAVE[p] end
function koStoryAway(p) return AWAY[p] end
function koStoryPaid(p) return paidGet(p) end-- for test scripts
function koStoryPaidSet(p,v) paidSet(p,v) end-- for test scripts

-- 도감 힌트: 이야기 무장의 조건 끝에 주점 문구를 붙임.
if type(rawget(_G,"koRecHint"))=="table" then
for _,p in ipairs(STORY) do
local h=koRecHint[p]
if h and not string.find(h,"\130\075\135\070",1,true) then koRecHint[p]=h.." / 2\130\125\132\121\130\094\131\104 \130\075\135\070(\130\067\130\113 \130\125\132\121 \129\110\130\084\132\086, \129\087\129\093 \130\066\129\089\130\067)" end
end
end

local function raw(i,o) return Byte.get16(JY.Data_Person,i*PS+o) end
local function setraw(i,o,v) Byte.set16(JY.Data_Person,i*PS+o,v) end
local function base(i,o) return Byte.get16(JY.Data_Person_Base,i*PS+o) end
local function copyRec(from,to) for o=0,PS-2,2 do Byte.set16(JY.Data_Person,to*PS+o,Byte.get16(JY.Data_Person,from*PS+o)) end end
local function clearRec(i) for o=0,PS-2,2 do Byte.set16(JY.Data_Person,i*PS+o,0) end end
local function have() return (JY.PersonNum or 0)>STORE0+STORE_N end-- the 802-person table (an old newgame.grp would have 602)

-- The warehouse's nickname words in records 767–772 are unused. Keep
-- tavern provenance in the person table so it follows the save and rewind.
local function hireBit(pid)
if not have() or not pid or pid<1 or pid>601 then return end
local word=math.floor((pid-1)/15)
return 767+math.floor(word/7),24+2*(word%7),2^((pid-1)%15)
end
function koStoryMarkTavernHire(pid)
local row,offset,bit=hireBit(pid)
if row and JY.Person[pid][LORD]==1 then
local value=raw(row,offset)
if math.floor(value/bit)%2==0 then setraw(row,offset,value+bit) end
paidSet(pid,0)
end
end
local function storyBattle()
return not (CC.koFree or CC.koReplay or CC.koTownBattle)
end
local function protected(pid)
local row,offset,bit=hireBit(pid)
return row and storyBattle() and (math.floor(raw(row,offset)/bit)%2==1 or paidGet(pid)>0)
end
function koStoryKeepsForce(pid,fid)
return (fid or 1)~=1 and protected(pid) and JY.Person[pid][LORD]==1
end
local function retained(pid)
local original=PARKED_PERSON[pid]
if original then return protected(original) and raw(pid,O_LORD)==1 end
return protected(pid) and JY.Person[pid][LORD]==1
end

-- ---------------------------------------------------------------- 주차
function koStoryParked(p) local s=p and SLOT[p] return s~=nil and have() and raw(s,O_FACE)>0 end
function koStoryParkedTreasureHolders()
local holders={}
if have() then for p,s in pairs(SLOT) do if raw(s,O_FACE)>0 then holders[p]=s end end end
return holders
end
local function park(p)
local s=SLOT[p]
if not s or JY.Person[p][LORD]~=1 or raw(s,O_FACE)>0 then return end
copyRec(p,s)
if not protected(p) then setraw(s,O_LORD,0) end
local lord=base(p,O_LORD)
setraw(p,O_LORD,protected(p) and lord==1 and 0 or lord)-- preserve the enemy defaults outside the player's roster
for k=1,8 do setraw(p,O_ITEM(k),base(p,O_ITEM(k))) end
koAddonLog("storyhire: parked "..p.." -> "..s)
end
function koStoryBattleAlly(pid)
local slot=SLOT[pid]
if slot and koStoryParked(pid) and raw(slot,O_LORD)==1 then return slot end
return pid
end
function koStoryOriginalPerson(pid)
local original=PARKED_PERSON[pid]
if original and koStoryBattleAlly(original)==pid then return original end
return pid
end
function koStoryBattleSource(pid)
local unit=pid and War and War.Person and War.Person[War.SelID]
if unit and not unit.enemy and PARKED_PERSON[unit.id]==pid then return unit.id end
return pid
end
function koStoryPrepareEnemy(pid)
if not (SLOT[pid] and protected(pid)) or koStoryParked(pid) then return end
-- Story events refer to the enemy by its original person ID. If the ally
-- was deployed before the enemy was announced, move its unit to the saved slot.
park(pid)
if not koStoryParked(pid) then return end
for _,unit in ipairs(War.Person) do
if unit.id==pid and not unit.enemy and not unit.friend then unit.id=SLOT[pid] end
end
if War.Leader1==pid then War.Leader1=SLOT[pid] end
if koAwakeRebuild then koAwakeRebuild() end
end
function koStoryRetireEnemy(pid)
if koStoryBattleAlly(pid)==pid or JY.Status~=GAME_WMAP then return false end
local ally=GetWarID(koStoryBattleAlly(pid))
local enemy=GetWarID(pid)
if ally==0 or enemy==0 or War.Person[ally].enemy or War.Person[ally].friend or not War.Person[enemy].enemy then return false end
local unit=War.Person[enemy]
if unit.live then
if not unit.hide then SetWarMap(unit.x,unit.y,2,0) end
War.EnemyNum=math.max(0,War.EnemyNum-1)
end
unit.live,unit.hide,unit.active,unit.leader=false,true,false,false
return true
end
function koStoryUnparkAll()
if not have() then return end
for p,s in pairs(SLOT) do
if raw(s,O_FACE)>0 then
local joined=(JY.Person[p][LORD]==1)-- won over in the battle: ModifyForce counted him once more
local active=raw(s,O_LORD)==1
copyRec(s,p)
clearRec(s)
setraw(p,O_LORD,1)
if active then
for _,unit in ipairs(War and War.Person or {}) do
if unit.id==s then unit.id=p end
end
if War and War.Leader1==s then War.Leader1=p end
end
if joined then JY.Base[COUNT]=math.max(0,(JY.Base[COUNT] or 1)-1) end
koAddonLog("storyhire: back "..p)
end
end
end
do
local dw=rawget(_G,"DefineWarMap")
if type(dw)=="function" then
function DefineWarMap(...)
if have() and storyBattle() then
koStoryUnparkAll()-- (nothing should be left; a battle never starts with one parked)
local list=ENEMY[JY.EventID]
if list then for _,p in ipairs(list) do park(p) end end
end
local result=table.pack(dw(...))
if War then War.Leader1=koStoryBattleAlly(War.Leader1) end
if koAwakeRebuild then koAwakeRebuild() end
return table.unpack(result,1,result.n)
end
end
-- (10-14 later) WarMeet·koViewMeet are left alone: the one met is the story's own (enemy) record, so duels, talking him over
-- and their bonus goals still happen; a won-over copy fights on our side to the end and the parked record comes back after
end
koOn("war_end",function() koStoryUnparkAll() end)
-- 전투 세이브가 아닌 기록을 불러오면 (전투 밖에서는 주차·증원 사본이 남아 있을 리 없음):
--  남은 주차는 되돌리고, 시련 증원 칸 662~761 은 비우고, 예전에 증원이 빌려 쓰던 531~601 에 남은 사본
--  (newgame 은 얼굴 0, 전투 중 저장을 불러온 뒤 남을 수 있었음 — 술집 루프 421~601 안이라 주점에 보일 수 있었다)은 newgame 값으로 돌린다
local BATTLESAVE=string.char(213,189,179,161,180,230,181,181)-- 战场存档
-- 소지품은 앞 칸부터 채워 있어야 함(엔진: 1번 칸이 비면 「도구 없음」, 8번 칸이 차면 「가득 참」). 창고에 맡겨 생긴 빈칸을 당긴다
local function packBag(pid)
local P=JY.Person[pid] if not P then return end
local t={}
for k=1,8 do local v=P[ITEM..k] or 0 if v>0 then t[#t+1]=v end end
for k=1,8 do local v=t[k] or 0 if (P[ITEM..k] or 0)~=v then P[ITEM..k]=v end end
end
function koPackBag(pid) packBag(pid) end
local function tidy()
if not have() or (JY.Base[BATTLESAVE] or 0)==1 then return end
koStoryUnparkAll()
for i=662,761 do if raw(i,O_FACE)~=0 or raw(i,O_LORD)~=0 then clearRec(i) end end
for i=531,601 do
if raw(i,O_FACE)>0 and base(i,O_FACE)==0 and raw(i,O_LORD)~=1 then
for o=0,PS-2,2 do Byte.set16(JY.Data_Person,i*PS+o,Byte.get16(JY.Data_Person_Base,i*PS+o)) end
end
end
end
do
local lr=rawget(_G,"LoadRecord")
if type(lr)=="function" then
function LoadRecord(...)
local r=lr(...)
pcall(tidy)
for i=1,JY.PersonNum-1 do pcall(packBag,i) end
return r
end
end
end

-- ---------------------------------------------------------------- 술집
-- the story event of his first join, and whether he is ours already / was before it (the kdef join scenes ask this)
function koStoryFirst(p) return FIRST[p] end
function koStoryOurs(p) return JY.Person[p][LORD]==1 or koStoryParked(p) end
-- 군웅록 11-16 (카페 제보 「광천 · 거록 전투를 안 하면 한영 · 곽적 · 경무 · 관순이 주점에 안 나옴」): 위 규칙은 첫 합류 사건 전까지만 내놓아,
--  갈림길(신도성/광천 · 거록/청하 · 태산 · 팽성 · 하구 소탕 등)을 다른 길로 가 합류 사건을 지나치면 그 회차에는 다시 못 데려왔다.
--  → 그 무장이 대본에서 합류할 수 있는 마지막 사건(아래 표: kdef 700 미만의 ModifyForce(p,1) 중 마지막, 그 뒤 이탈 0/적 소속이 없는 무장만 —
--  영영 떠나는 35 는 뺌)을 지났는데 우리 편이 아니면 다시 내놓는다. 조건은 같음(2회차부터 · 지난 회차에 함께한 무장 · 처음 소속 그대로). 영걸전만.
local MISSED=(not SH) and {[24]=510,[30]=593,[31]=396,[34]=642,[38]=642,[39]=642,[44]=593,[54]=652,[58]=60,[59]=60,[64]=273,[65]=652,[80]=654,[82]=652,[83]=652,[91]=510,[112]=652,[114]=652,[117]=652,[126]=592,[127]=652,[128]=642,[129]=357,[133]=652,[148]=620,[155]=642,[165]=620,[166]=620,[167]=620,[170]=655,[175]=396,[182]=403,[188]=652,[190]=652,[191]=510,[200]=493,[201]=493,[202]=493,[203]=655,[204]=592,[208]=510,[209]=510,[221]=37,[224]=114,[229]=118,[235]=652,[236]=652,[237]=652,[244]=652,[245]=45,[246]=45,[248]=277,[252]=549,[253]=593,[254]=493,[255]=493,[376]=110} or {}
local function offerable(p)
local NG=CC.koNG
if not (NG and NG.rcycle and NG.rcycle()>=2) then return false end
local ev=koStoryEv()
if ev<koHireFromEv() or (ev>=(FIRST[p] or 0) and not (MISSED[p] and ev>MISSED[p])) then return false end-- 6.0 (11-01): "from chapter 1" stretched to the running story (koEvScale, jymain) / 11-16: 놓친 무장은 다시
local P=JY.Person[p]
if P[LORD]==1 or raw(p,O_LORD)~=base(p,O_LORD) or raw(p,O_FACE)<=0 then return false end
if koStoryParked(p) then return false end
return rawget(_G,"koRecMet")~=nil and koRecMet(koRecCanonOf(p))
end
function koStoryOfferable(p) return SLOT[p]~=nil and offerable(p) end-- for test scripts
local HOMEBYNAME=nil
function koStoryHome(name)
if HOMEBYNAME==nil then
HOMEBYNAME={}
for p,t in pairs(HOME) do HOMEBYNAME[JY.Person[p][NAME]]=t end
end
return HOMEBYNAME[name]
end
-- 군웅록 11-14 (카페 제보 「무제전 2장 유엽이 99 로 합류」): 아래는 이야기 무장의 진짜 인물 칸에 술집 레벨 · 병종을 써서,
--  고용하지 않아도 그대로 남았다 → 술집에 들른 뒤 이야기에서 합류하면 그 레벨에 대본의 레벨업(유엽 +28)이 더해짐.
--  명단에 올리기 전 저장 칸을 떠 두고, HirePerson 이 끝나면 우리 편이 되지 않은 무장은 되돌린다 (아래 HirePerson 감싸기).
local SHSNAP={}
function koStoryHireRestore()
for p,s in pairs(SHSNAP) do
local P=JY.Person[p]
if P and P[LORD]~=1 then for k,v in pairs(s) do P[k]=v end end
end
SHSNAP={}
end
koOn("tavern_more",function()
local t={}
for _,p in ipairs(STORY) do
if offerable(p) then
local P=JY.Person[p]
if not SHSNAP[p] then local s={} for k,v in pairs(CC.Person_S) do if v[4] then s[k]=P[k] end end SHSNAP[p]=s end
ReSetAttrib(p,true)
P[WARPIC]=GetPic(p,false,false)
local lv=koHireLv()-- the tavern's level (HirePerson; 6.0 stories: the army average)
lv=limitX(lv,1,99)
if CC.Enhancement then local d=pjlv() if lv<d then lv=d end end
P[LV]=lv
-- 10-20 (「이숙 같은 경우」 점검): the record's class is the newgame one, not the class he joins with in the story (the 도감 shows that one):
--  이명·조하 join as the 맹수사 / 산적 of their battle; and like a tavern copy he is promoted by the tavern level (1단 → 2·3단)
if STORYBZ[p] then P[BZ]=STORYBZ[p] end
if rawget(_G,"koTavernPromote") then pcall(koTavernPromote,p,true) end
t[#t+1]=p
end
end
return t
end)

-- ---------------------------------------------------------------- 창고
local function storeSlot(r,k) return STORE0+r-1,O_ITEM(k) end
local function storeFree()
local n=0
for r=1,STORE_N do for k=1,8 do local i,o=storeSlot(r,k) if raw(i,o)==0 then n=n+1 end end end
return n
end
function koStorePut(iid)
if not have() or not iid or iid<=0 then return false end
for r=1,STORE_N do for k=1,8 do local i,o=storeSlot(r,k) if raw(i,o)==0 then setraw(i,o,iid) return true end end end
return false
end
function koStoreList()
local t={}
if not have() then return t end
for r=1,STORE_N do for k=1,8 do local i,o=storeSlot(r,k) local v=raw(i,o) if v>0 then t[#t+1]={i=i,o=o,iid=v} end end end
return t
end
-- a general of ours leaving for another side (ModifyForce fid other than 0 / 1): his bag goes to the 창고
local function stash(pid)
local moved,kept=0,0
for k=1,8 do
local v=JY.Person[pid][ITEM..k]
if v and v>0 then
if koStorePut(v) then JY.Person[pid][ITEM..k]=0 moved=moved+1 else kept=kept+1 end
end
end
packBag(pid)
if moved>0 then pcall(ReSetAttrib,pid,false) end
return moved,kept
end
function koStoreStashT(pid) return stash(pid) end-- for test scripts
-- 11-03 이탈 환불: 주점에서 금을 낸 바로 뒤(UseMoney → 10초 안) 합류 사건 전에 들어온 LEAVE 무장은 그 금액을 적어 두고,
-- 마지막 이탈 사건(LEAVE[p]) 이후 우리 편에서 빠질 때(소속 0 = 재야 · 죽음 포함) 돌려준다
local lastUse=nil
do
local um=rawget(_G,"UseMoney")
if type(um)=="function" then
function UseMoney(v,...)
lastUse={v=tonumber(v) or 0,t=lib.GetTime()}
return um(v,...)
end
end
end
local function say(s) if JY.Status==GAME_WMAP then WarDrawStrBoxConfirm(s,M_White,true) else DrawStrBoxCenter(s) end end
do
local mf=rawget(_G,"ModifyForce")
if type(mf)=="function" then
function ModifyForce(pid,fid,...)
local f=fid or 1
local P=pid and JY.Person[pid]
if pid and (koStoryKeepsForce(pid,fid) or (f==1 and (retained(pid) or koStoryRetireEnemy(pid)))) then return end
local refund=0
if have() and P and goneEv(pid) and not (CC.koFree or CC.koReplay) then
if f==1 and P[LORD]~=1 and koStoryEv()<(FIRST[pid] or 0) then
if lastUse and lastUse.v>0 and lib.GetTime()-lastUse.t<10000 then paidSet(pid,lastUse.v) koAddonLog("storyhire: paid "..pid.." "..lastUse.v) end
lastUse=nil
elseif f~=1 and P[LORD]==1 and koStoryEv()>=goneEv(pid) then
refund=paidGet(pid)
if refund>0 then paidSet(pid,0) end
end
end
local moved,kept=0,0
if have() and P and f~=1 and f~=0 and P[LORD]==1 and not (CC.koFree or CC.koReplay) then moved,kept=stash(pid) end
local r=mf(pid,fid,...)
if moved>0 then
local s=P[NAME].."\131\080 \129\109\130\067\131\066 "..moved.."\134\075\130\104 \134\103\131\100\129\102 \138\069\139\072\129\075\129\076\129\077."
if kept>0 then s=s.."*\134\103\131\100\129\094 \129\094\131\068 \132\121 "..kept.."\134\075\130\098 \131\091\130\095\132\083 \129\094\130\067\131\100 \137\116\129\075\129\076\129\077." end
say(s)
end
if refund>0 then
koSetGold(koGold()+refund)
koAddonLog("storyhire: refund "..pid.." "..refund)
say(P[NAME].."\129\071(\129\094) \139\088\131\118\134\066*\130\075\135\070\129\102\131\087 \133\125\132\111 \132\085 \133\072\131\098 \131\103\129\083 \137\066\131\096\130\075\132\107\129\075\129\076\129\077. (\131\103 +"..refund..")")
end
return r
end
end
end
-- Restore the preview records of story generals who were not hired.
do
local hp=HirePerson
function HirePerson(...)
local r=table.pack(pcall(hp,...))
pcall(koStoryHireRestore)
if not r[1] then error(r[2],0) end
return table.unpack(r,2,r.n)
end
end
local function lords()
local t={}
for i=1,JY.PersonNum-1 do if JY.Person[i][LORD]==1 then t[#t+1]=i end end
return t
end
local function pickLord(say,ok)
local ls=lords()
local menu={}
for i=1,JY.PersonNum-1 do menu[i]={"",nil,0} end
local any=false
for _,i in ipairs(ls) do if ok(i) then menu[i]={fillblank(JY.Person[i][NAME],11),nil,1} any=true end end
if not any then return 0 end
talk(369,say)
if #ls<=10 then return ShowMenu(menu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White) end
return ShowMenu(menu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
local function bagFree(pid) for k=1,8 do if (JY.Person[pid][ITEM..k] or 0)==0 then return k end end return nil end
local function storeMenu()
while true do
local list=koStoreList()
local m={{"\138\069\131\071\131\071",nil,1},{"\139\113\131\071 ("..#list.."\134\075)",nil,(#list>0) and 1 or 0},{"\129\138\131\071",nil,1}}
talk_sub(369,"\134\103\131\100  "..#list.."/"..(STORE_N*8).."\135\066*\138\069\134\114 \132\085\130\098 \129\073\131\097\131\080 \129\109\130\067\131\066\129\083, \139\113\129\083 \132\085\130\098 \133\072\129\083 \129\073\131\097\129\083 \131\100\139\123\129\076\129\077.")
local r=ShowMenu(m,#m,0,0,156,0,0,5,1,16,M_White,M_White)
if r==1 then
while true do
local pid=pickLord("\129\109\130\067\131\066\129\083 \138\069\134\114 \129\073\131\097\129\083 \133\109\133\110\129\097\131\111\129\090.",function(i) for k=1,8 do if (JY.Person[i][ITEM..k] or 0)>0 then return true end end return false end)
if pid<=0 then break end
while true do
local menu,slots={},{}
for k=1,8 do local v=JY.Person[pid][ITEM..k] or 0 if v>0 then menu[#menu+1]={fillblank(JY.Item[v][INAME],13),nil,1} slots[#menu]=k end end
if #menu==0 then break end
talk_sub(369,JY.Person[pid][NAME].."\131\080 \129\109\130\067\131\066*\134\103\131\100\129\102 \138\069\134\114 \131\117\129\083 \131\100\130\106\131\111\129\090. (\133\105 \135\066 "..storeFree()..")")
local s=ShowMenu(menu,#menu,0,0,156,0,0,5,1,16,M_White,M_White)
if s<=0 then break end
local k=slots[s]
local v=JY.Person[pid][ITEM..k]
if koStorePut(v) then
JY.Person[pid][ITEM..k]=0
packBag(pid)
pcall(ReSetAttrib,pid,false)
PlayWavE(11)
else
PlayWavE(2) WarDrawStrBoxConfirm("\134\103\131\100\129\094 \129\094\131\068 \132\077\129\075\129\076\129\077.",M_White,true) break
end
end
end
elseif r==2 then
while true do
list=koStoreList()
if #list==0 then break end
local menu={}
for k,e in ipairs(list) do menu[k]={fillblank(JY.Item[e.iid][INAME],13),nil,1} end
talk_sub(369,"\134\103\131\100\129\102\131\087 \140\077\137\077 \131\117\129\083 \131\100\130\106\131\111\129\090.")
-- 10-27 카페 건의: 모양 5 는 스크롤이 없어 11번째부터 안 보였다 → 10개가 넘으면 스크롤 틀(모양 6, 8줄)
local s
if #menu<=10 then s=ShowMenu(menu,#menu,0,0,156,0,0,5,1,16,M_White,M_White)
else s=ShowMenu(menu,#menu,8,0,156,0,0,6,1,16,M_White,M_White) end
if s<=0 then break end
local e=list[s]
local pid=pickLord(JY.Item[e.iid][INAME].."\129\083(\130\104) \133\072\129\083 \129\073\131\097\129\083 \133\109\133\110\129\097\131\111\129\090.",function(i) return bagFree(i)~=nil end)
if pid<=0 then
if #lords()>0 and pid==0 then PlayWavE(2) end
break
end
local k=bagFree(pid)
if k then
JY.Person[pid][ITEM..k]=e.iid
setraw(e.i,e.o,0)
pcall(ReSetAttrib,pid,false)
PlayWavE(11)
end
end
else
return
end
end
end
koAddon.personMenu[#koAddon.personMenu+1]={label="\134\103\131\100",run=function() if have() then storeMenu() end end}

-- ---------------------------------------------------------------- 가방이 가득 찰 때 받는 물건 (10-20 카페 제보)
-- 「유장 화친 길에서 마초가 주는 황조비룡이 없다」: jymain GetItem / WarGetItem 은 받는 무장의 가방 8칸이 차 있으면 아무 말 없이
-- false 를 돌려주고 물건을 버렸다 (이야기 보상 GetItem 15곳·WarGetItem 6곳, 보너스 목표 koBonusItem 도 같은 길).
-- 이제 가방이 차 있으면 창고에 맡기고, 창고가 없거나 차 있으면 자리가 있는 다른 아군에게 준다. 그래도 안 되면 원래처럼 false.
do
local rawGI,rawWGI=GetItem,WarGetItem
local function spill(pid,item,war)
item=koPromotionItemId(item)
if not item or item<=0 or not JY.Item[item] then return false end
local nm=JY.Item[item][INAME]
local s=nil
if koStorePut(item) then
s="\131\067\131\068: "..nm.."\163\174*(\129\094\132\078\129\071 \129\094\131\068 \132\121 \134\103\131\100\129\102 \138\069\139\072\129\075\129\076\129\077)"
else
for p=1,math.min(JY.PersonNum-1,601) do
if p~=pid and JY.Person[p][LORD]==1 and not s then
for k=1,8 do
if JY.Person[p][ITEM..k]==0 then
JY.Person[p][ITEM..k]=item
s="\131\067\131\068: "..nm.."\163\174*(\129\094\132\078\129\071 \129\094\131\068 \132\121 "..JY.Person[p][NAME].."\129\102\129\081 \178\108)"
break
end
end
end
end
end
if not s then return false end
PlayWavE(11)
if war then WarDrawStrBoxWaitKey(s,M_White) else DrawStrBoxWaitKey(s,M_White) end
return true
end
function GetItem(pid,item)
if rawGI(pid,item) then return true end
return spill(pid,item,false)
end
function WarGetItem(wid,item)
if rawWGI(wid,item) then return true end
local v=War.Person[wid]
return spill(v and v.id or 0,item,true)
end
-- 11-08 카페 제보 「보물창고마다 아이템이 안 먹어진다 (방천화극 · 칠성검)」: jymain WarLocationItem(전장 보물고)은 밟은 무장의
-- 가방 8번째 칸이 차 있으면 WarGetItem 을 부르기 전에 아무 말 없이 돌아가서, 위의 「창고에 맡김」 길도 타지 못했다.
-- 그 경우만 여기서 WarGetItem(가방 → 창고 → 다른 아군)으로 주고, 받으면 플래그를 세운다. 모두 가득이면 알려 주고 플래그는 두어
-- 자리를 비운 뒤 다시 밟으면 받게 한다. 나머지(빈칸 있음 · 다른 칸 · 이미 받음)는 원래 함수(hotkey 의 ? 표시 기록 포함)로.
local rawLoc=WarLocationItem
WarLocationItem=function(y,x,item,event,...)
if type(War)=="table" and War.SelID and War.SelID~=0 and event and not GetFlag(event) then
local v=War.Person[War.SelID]
if v and v.live and (not v.hide) and (not v.enemy) and (not v.friend) and v.x==x+1 and v.y==y+1 and (JY.Person[v.id][ITEM.."8"] or 0)>0 then
if WarGetItem(War.SelID,item) then SetFlag(event,1)
elseif JY.Item[item] then WarDrawStrBoxWaitKey("\131\115\131\065\131\100: "..JY.Item[item][INAME].."\163\174*\129\094\132\078\129\068 \134\103\131\100\129\068 \129\094\131\068 \132\121 \129\094\136\107\129\094\130\067 \136\102\129\080\129\075\129\076\129\077.*\133\120\129\117\130\104 \130\080\131\079\131\100 \129\077\130\086 \141\121\131\109\129\065 \133\086\129\075\129\076\129\077.",M_White) end
end
end
return rawLoc(y,x,item,event,...)
end
end
-- 군웅록 11-16 (카페 제보 「1.0.30 무제전: 유엽 데려오기 전으로 불러와도 94, 서주 뒤 관우 99」): 이야기 대본의 합류 레벨업은
--  「지금 레벨 + n」(SnrLvUp → LvUp, 설계 = 처음 레벨 + n)인데, 합류 전 인물 칸 레벨이 이미 올라 있었다 —
--  적으로 나온 전투의 적 레벨 맞춤(jymain SelectEnemy 가 인물 칸에 그대로 씀, 관우 382) · 1.0.28 전 술집 목록이 남긴 레벨(유엽 32).
--  이야기 모드에서 무장의 첫 합류 사건(FIRST)에, 아직 우리 편이 아닌 무장이 처음 합류하거나(ModifyForce 1) 처음 레벨업(LvUp)될 때
--  한 번 newgame 레벨 · 경험치로 되돌린 뒤 대본대로 (무제전 사건 48 은 레벨업이 합류보다 먼저). 높을 때만 (낮추기만), 불러오면 다시 셈.
--  주점에서 먼저 데려온 무장(이미 우리 편)은 그대로. 영걸전(kdef)은 손대지 않음.
function koStoryKeepsTraining(pid)
return pid and pid>0 and (retained(pid) or koStoryBattleAlly(pid)~=pid)
end
local rawClass=ModifyBZ
function ModifyBZ(pid,...)
if not koStoryKeepsTraining(pid) then return rawClass(pid,...) end
end
if SH then
local EXP=string.char(190,173,209,233)       -- 经验
local JOINFIX={}
local function joinFix(p)
if not (p and FIRST[p] and not JOINFIX[p] and have() and JY.Data_Person_Base) or CC.koFree or CC.koReplay then return end
if koStoryEv()~=FIRST[p] then return end
local P=JY.Person[p]
if not P or P[LORD]==1 then return end
JOINFIX[p]=true
local b=GetDataFromStruct(JY.Data_Person_Base,p*PS,CC.Person_S,LV)
if b and b>0 and (P[LV] or 0)>b then
koAddonLog("storyhire: join level "..p.." "..tostring(P[LV]).." -> "..b)
P[LV]=b
P[EXP]=GetDataFromStruct(JY.Data_Person_Base,p*PS,CC.Person_S,EXP)
pcall(ReSetAttrib,p,false)
end
end
function koStoryJoinFixT(p) JOINFIX[p]=nil return joinFix(p) end-- for test scripts
local mf=rawget(_G,"ModifyForce")
if type(mf)=="function" then
function ModifyForce(pid,fid,...)
if (fid or 1)==1 then pcall(joinFix,pid) end
return mf(pid,fid,...)
end
end
local lu=rawget(_G,"LvUp")
if type(lu)=="function" then
function LvUp(pid,...)
pcall(joinFix,pid)
return lu(pid,...)
end
end
local lr=rawget(_G,"LoadRecord")
if type(lr)=="function" then
function LoadRecord(...)
JOINFIX={}
return lr(...)
end
end
end
