-- ko 5.0 (10-13): 도전 난이도 개편 (addon "diff"; 사용자 "\130\113\129\071\129\068\130\104 \130\066\133\114\131\076\131\109\132\083 \129\191\130\083\131\100\132\081\131\100 \138\093\130\083, \133\114\135\078\129\071 \129\105\129\105 \132\067\129\068\133\108").
-- 도전 모드에서만. 1~10 모두 1회차부터 (jymain koNG.maxdiff = 10, 개발용/addon/patch_난이도개편.pl).
--   단계마다: 적 병력 % · 적이 주는 피해 + % · 적 레벨 +d (레벨은 jymain SelectEnemy 가 원래 하던 대로) · 승리 보상 + %
--   규칙 (그 단계부터 계속): 2 적 병종 조기 승급 / 4 적 총대장 강화 (병력 x1.5, 무·지·통 +10) / 6 적 회복 (적 차례 시작마다 병력 5%)
--                          8 적 책략 강화 (책략 피해 +25%, 지력 +10) / 10 적 반격 강화 (반격 피해 +25%) · 적 무장 전원 보물 1개
--   6.0 (10-28): 5 적장 전용 보물 (이름난 적장 모두 원본, 2회차와 같음) · 9 적장 각성 장비 (모두 ★) — 실제 장비는 gear 애드온이 koDiffLv 로 읽음 (시련 카드였던 것을 옮김)
-- 옛 6~10 능력치 보정((상한-100)x(d-5)/5)은 없앰. 승리 보상의 능력치 경험이 창에는 30+5(d-1) 로 나오고 실제로는 30 이던 것도 바로잡음.
-- 배율은 전투 중(JY.Status==GAME_WMAP, 또는 SelectEnemy 안)에만: 전투 뒤 합류 사건에서 옛 적의 병력이 부풀지 않게.
-- Source: 개발용/addon/diff_src.lua (UTF-8); script/addon/diff.lua is made from it by 개발용/도구/free_hz.pl.
local P_BL,P_MAXBL="\177\248\193\166","\215\238\180\243\177\248\193\166"-- 兵力 最大兵力
local P_BZ="\177\248\214\214"-- 兵种
local P_ITEM="\181\192\190\223"-- 道具
local P_WL,P_ZL="\206\228\193\166","\214\199\193\166"-- 武力 智力
local B_SND,B_ASND,B_MOV,B_MSPD,B_AFW="\210\244\208\167","\185\165\187\247\210\244\208\167","\210\198\182\175","\210\198\182\175\203\217\182\200","\185\165\187\247\183\182\206\167"
local K_MJ,K_DIF="\195\216\188\188\49","\183\220\213\189"-- JY.Person[1]: 도전 모드 표시, 도전 난이도
-- d = {적 병력 %, 적이 주는 피해 + %, 보상 + %}
local DT={
[1]={110,5,10},[2]={120,10,20},[3]={130,15,30},[4]={140,20,45},[5]={150,25,60},
[6]={165,30,80},[7]={180,35,100},[8]={200,40,125},[9]={220,45,150},[10]={250,50,200},
}
local RULES={
{2,"\131\076 \130\126\129\084 \129\118\131\071 \129\116\134\080","\130\082\130\123\129\123 \129\067\129\101\130\097\129\071 \129\111 \134\077\132\084 \130\110 \130\126\129\084"},
{4,"\131\076 \135\084\130\095\131\097 \130\073\129\064","\135\084\130\095\131\097 \130\126\131\125 x1.5, \129\073\131\125\161\164\130\067\131\125\161\164\132\119\132\120 +10"},
{5,"\131\076\131\097 \130\066\132\111 \131\115\131\065","\129\071\138\075\130\113 \131\076\131\097 \130\090\130\091 \133\120\131\071 \130\066\132\111 \131\115\131\065"},
{6,"\131\076 \130\125\130\068","\131\076 \132\121\139\126\133\088\129\077 \131\076 \130\126\131\125 5% \130\125\130\068"},
{8,"\131\076 \130\117\130\118 \130\073\129\064","\131\076 \130\117\130\118 \137\088\129\066 +25%, \131\076 \130\067\131\125 +10"},
{9,"\131\076\131\097 \130\069\131\123 \131\097\130\080","\129\071\138\075\130\113 \131\076\131\097 \130\090\130\091 \130\069\131\123\129\111 \130\066\132\111 \131\115\131\065 \161\239"},
{10,"\131\076 \133\065\130\112 \130\073\129\064\161\164\131\115\131\065","\133\065\130\112 \137\088\129\066 +25%, \131\076 \129\073\131\097 \130\066\131\081 \131\115\131\065 1\134\075"},
}
koDiffTable,koDiffRules=DT,RULES
function koDiffLv()
if not CC.Enhancement or JY.Person==nil or JY.Person[1]==nil then return 0 end
if (JY.Person[1][K_MJ] or 0)==0 then return 0 end
local d=JY.Person[1][K_DIF] or 0
if d<1 then return 0 end
if d>10 then d=10 end
return d
end
local setup,ended=false,false
local function inWar() return setup or (JY.Status==GAME_WMAP and not ended) end
-- 21회차 시련 (trial addon): the value of one trial at its chosen stage (0 when none / before cycle 21)
local function TV(k) local f=rawget(_G,"koTrialV") if f then return f(k) or 0 end return 0 end
local function warWid(id)
if not inWar() then return 0 end
return GetWarID(id)
end
-- jymain ReSetAttrib (koNG.ebonus): extra 무·지·통 for every stat, extra 지력
function koDiffStatBonus(wid)
local d=koDiffLv()
if d<1 or not inWar() then return 0,0 end
local v=wid and War.Person[wid]
if not (v and v.enemy) then return 0,0 end
local b,z=0,0
if d>=4 and v.leader then b=10 end
if d>=8 then z=10 end
return b,z
end
-- 10: the treasure every enemy carries in this battle. Put into an empty bag slot only while ReSetAttrib reads the bag
-- (so it never stays in the record, never drops, never counts as owned); 무력형 삼첨도 (14, 공격 때 사기 깎기), 지력형 칠성검 (12, 책략 소비 절반)
local function giftFor(p)
if (p[P_ZL] or 0)>(p[P_WL] or 0) then return 12 end
return 14
end
-- ---------------------------------------------------------------- troops (difficulty + trials), our 책략치 (trial)
local P_MP,P_MAXMP="\178\223\194\212","\215\238\180\243\178\223\194\212"-- 策略 最大策略
-- 10-16: 병력 / 최대병력 sat in the person record as signed 16-bit, so 도전 10 (x2.5) on a high-level 총대장 (x1.5) went past
--        32767 and wrapped to minus (팽성II 고순 Lv115 -32236 -> 첫 적 차례에 퇴각); with trials (적 병력 +50%, 총대장 x3) a
--        Lv160 총대장 reaches about 160000. The record keeps its 152-byte layout (old saves load as they are):
--        · the field's own two bytes hold the low part, read and written unsigned (0~65535, like the sprite field in unique);
--        · the high part goes in the save bytes of 不屈 (offset 100, for 병력) / 强运 (102, for 최대병력), duel skills the
--          game always reads from newgame (Person_S flag false), so their save bytes were never read. It is written as
--          0x7A00 + high (old saves hold small skill values there = high 0; a record copied byte for byte by storyhire
--          keeps its pair, a record reset to newgame bytes drops to the low part). Writes to those two keys are dropped.
--        Every value is kept in 0~KO_HPMAX (a minus troop count is 0); every multiplied max stays under KO_HPCAP
--        (999999: the status window has room for 6 digits on each side).
local KO_HPCAP,KO_HPMAX=999999,16777215
local K_BUQU,K_QIANGYUN="\178\187\199\252","\199\191\212\203"-- 不屈 强运
local HI_OFF={[P_BL]=100,[P_MAXBL]=102}
local HI_TAG=0x7A00
CC.Person_S[P_BL][2]=1 CC.Person_S[P_MAXBL][2]=1
do local rawSDS,rawGDS=SetDataFromStruct,GetDataFromStruct
function SetDataFromStruct(data,offset,t_struct,key,v)
if t_struct==CC.Person_S then
if (key==K_BUQU or key==K_QIANGYUN) and data~=JY.Data_Person_Base then return end
local h=HI_OFF[key]
if h and type(v)=="number" then
v=math.max(0,math.min(KO_HPMAX,math.floor(v)))
local hi=math.floor(v/65536)
local cur=Byte.get16(data,offset+h)
if hi>0 then Byte.set16(data,offset+h,HI_TAG+hi) elseif cur>=HI_TAG and cur<HI_TAG+256 then Byte.set16(data,offset+h,0) end
v=v%65536
end
end
return rawSDS(data,offset,t_struct,key,v)
end
function GetDataFromStruct(data,offset,t_struct,key)
local r=rawGDS(data,offset,t_struct,key)
if t_struct==CC.Person_S then
local h=HI_OFF[key]
if h then local t=Byte.get16(data,offset+h) if t>HI_TAG and t<HI_TAG+256 then r=r+(t-HI_TAG)*65536 end end
end
return r
end
end
local rawMax={}
local rawReSet=ReSetAttrib
function ReSetAttrib(id,flag)
local wid=warWid(id)
local v=(wid>0) and War.Person[wid] or nil
if not v then return rawReSet(id,flag) end
local p=JY.Person[id]
if not v.enemy then
-- trials / boons on our own units (not 우군) in battle: 「아군 책략치」 ± and 「아군 병력」 +
local mpP=v.friend and 0 or (TV("b_mp")-TV("mp"))
local hpP=v.friend and 0 or TV("b_hp")
local mp,hp=p[P_MP] or 0,p[P_BL] or 0
rawReSet(id,flag)
if mpP~=0 then
local mx=math.floor((p[P_MAXMP] or 0)*(100+mpP)/100)
p[P_MAXMP]=mx
p[P_MP]=flag and mx or math.min(mp,mx)
end
if hpP~=0 then
local mx=math.min(KO_HPCAP,math.floor((p[P_MAXBL] or 0)*(100+hpP)/100))
p[P_MAXBL]=mx
p[P_BL]=flag and mx or math.min(hp,mx)
end
return
end
local d=koDiffLv()
local hpT,leadT,moveT=TV("hp"),TV("lead"),TV("move")
if d<1 and hpT==0 and leadT==0 and moveT==0 then return rawReSet(id,flag) end
local hp=p[P_BL] or 0
local slot=0
if d>=10 then
for i=1,8 do if p[P_ITEM..i]==0 then slot=i break end end
if slot>0 then p[P_ITEM..slot]=giftFor(p) end
end
local ok,err=pcall(rawReSet,id,flag)
if slot>0 then p[P_ITEM..slot]=0 end
if not ok then error(err,0) end
local raw=p[P_MAXBL] or 0
rawMax[id]=raw
local m=((d>0) and DT[d][1] or 100)+hpT
if v.leader then
if d>=4 then m=m*1.5 end
if leadT>0 then m=m*leadT/100 end
end
local mx=math.min(KO_HPCAP,math.floor(raw*m/100))
p[P_MAXBL]=mx
if flag then p[P_BL]=mx else p[P_BL]=math.min(hp,mx) end
if moveT>0 then v.movestep=(v.movestep or 0)+moveT end
end
-- safety: anything between SelectEnemy and the battle loop that set the raw max (and clamped the troops to it)
koOn("war_begin",function()
ended=false
if (War.Turn or 1)~=1 then return end
for _,v in pairs(War.Person) do
if v.enemy and v.id>0 then
local p=JY.Person[v.id]
local hp=p[P_BL] or 0
ReSetAttrib(v.id,false)
if rawMax[v.id] and hp>=rawMax[v.id] then p[P_BL]=p[P_MAXBL] end
end
end
end)
-- ---------------------------------------------------------------- trial 「증원」: copies of an enemy in the empty records 531~601
local P_FACE,P_LORD,P_LV="\205\183\207\241\180\250\186\197","\190\253\214\247","\181\200\188\182"
local P_GEAR={"\206\228\198\247","\183\192\190\223","\184\168\214\250"}-- 武器 防具 辅助
local spawned={}-- record id -> its own record before the copy
local reinfDone=false
local function freeRecord()
for s=662,math.min(761,(JY.PersonNum or 0)-1) do-- 5.1 storyhire (10-14): own records 662~761 (531~601 were borrowed)
if not spawned[s] and (JY.Person[s][P_LORD] or 0)~=1 and GetWarID(s)==0 then return s end-- 531~601 are unused records (a copy left by a mid-battle load is reused)
end
end
local function farFromUs(x,y)
for _,a in pairs(War.Person) do
if not a.enemy and a.live and not a.hide and math.max(math.abs(a.x-x),math.abs(a.y-y))<4 then return false end
end
return true
end
local function spawn(n)
local src={}
for wid,v in pairs(War.Person) do
if v.enemy and v.live and not v.hide and not v.leader and v.id>0 then src[#src+1]=wid end
end
if #src==0 then return end
table.sort(src,function(a,b)
local ga=(War.Person[a].id>=257 and War.Person[a].id<=374) and 0 or 1
local gb=(War.Person[b].id>=257 and War.Person[b].id<=374) and 0 or 1
if ga~=gb then return ga<gb end
return a<b
end)
for k=1,n do
local s=freeRecord()
if not s then return end
local sw=src[(k-1)%#src+1]
local sv=War.Person[sw]
local old={}
for key,_ in pairs(CC.Person_S) do old[key]=JY.Person[s][key] JY.Person[s][key]=JY.Person[sv.id][key] end
spawned[s]=old
for i=1,8 do JY.Person[s][P_ITEM..i]=0 end
for _,g in ipairs(P_GEAR) do JY.Person[s][g]=0 end
local b=JY.Bingzhong[JY.Person[s][P_BZ]]
table.insert(War.Person,{id=s,x=sv.x,y=sv.y,action=1,effect=0,hurt=-1,bz=sv.bz,movewav=sv.movewav,atkwav=sv.atkwav,movestep=sv.movestep,movespeed=sv.movespeed,atkfw=sv.atkfw,
sq_limited=100,atk_buff=0,def_buff=0,frame=-1,d=sv.d,active=true,enemy=true,friend=false,ai=1,aitarget=sv.aitarget,ai_dx=sv.ai_dx,ai_dy=sv.ai_dy,
live=true,hide=false,was_hide=false,troubled=false,leader=false,koSpawn=true})
local w=#War.Person
War.PersonNum=w
War.EnemyNum=War.EnemyNum+1
-- the nearest free cell around one of the enemies that is at least 4 cells from our units
local bx,by
for t=0,#src-1 do
local o=War.Person[src[(k-1+t)%#src+1]]
local nx,ny=WarGetExistXY(o.x,o.y,w)
if WarCanExistXY(nx,ny,w) and farFromUs(nx,ny) then bx,by=nx,ny break end
if not bx and WarCanExistXY(nx,ny,w) then bx,by=nx,ny end
end
if bx then
War.Person[w].x,War.Person[w].y=bx,by
SetWarMap(bx,by,2,w)
else
War.Person[w].hide=true War.Person[w].live=false
end
ReSetAttrib(s,true)
War.Person[w].pic=WarGetPic(w)
end
end
-- ---------------------------------------------------------------- 2: early class-up (put back when the battle ends), trial levels and 증원
local UP={[1]=2,[2]=3,[4]=5,[5]=6,[7]=8,[8]=9,[10]=11,[11]=12,[23]=24,[24]=25}
local oldBZ={}
local rawSel=SelectEnemy
function SelectEnemy(...)
ended=false
setup=true
local r=table.pack(rawSel(...))
local d=koDiffLv()
local lvT=TV("lv")-TV("b_elv")
for wid,v in pairs(War.Person) do
if v.enemy and v.id>0 and not v.koDiffUp then
v.koDiffUp=true
local p=JY.Person[v.id]
local changed=false
if lvT~=0 then p[P_LV]=math.max(1,math.min(99,(p[P_LV] or 1)+lvT)) changed=true end
local nb=(d>=2) and UP[p[P_BZ]]
if nb and JY.Bingzhong[nb] then
if oldBZ[v.id]==nil then oldBZ[v.id]=p[P_BZ] end
p[P_BZ]=nb
local b=JY.Bingzhong[nb]
v.bz=nb
v.movewav=b[B_SND] v.atkwav=b[B_ASND] v.movestep=b[B_MOV] v.movespeed=b[B_MSPD] v.atkfw=b[B_AFW]
v.pic=WarGetPic(wid)
changed=true
end
if changed then ReSetAttrib(v.id,true) end
end
end
local rn=TV("reinf")
if rn>0 and not reinfDone then reinfDone=true spawn(rn) end
setup=false
return table.unpack(r,1,r.n)
end
koOn("war_end",function()
ended=true
for id,bz in pairs(oldBZ) do JY.Person[id][P_BZ]=bz end
oldBZ={}
-- the records of this battle's enemies back to their own numbers (raw max, the real bag's weapon)
if War and War.Person then
for _,v in pairs(War.Person) do
if v.enemy and v.id>0 and not spawned[v.id] then ReSetAttrib(v.id,true) end
end
end
-- the 증원 copies give their records back
for s,old in pairs(spawned) do for key,val in pairs(old) do JY.Person[s][key]=val end end
spawned={}
reinfDone=false
rawMax={}
end)
koOn("record_load",function() setup=false ended=false oldBZ={} spawned={} reinfDone=false end)
-- ---------------------------------------------------------------- damage (difficulty + trials)
local function foeHit(a,b) return a and b and a.enemy and not b.enemy end
local function ourHit(a,b) return a and b and not a.enemy and b.enemy end
local rawAtk=WarAtkHurt
function WarAtkHurt(pid,eid,...)
local r=table.pack(rawAtk(pid,eid,...))
if inWar() and type(r[1])=="number" and r[1]>0 then
local a,b=War.Person[pid],War.Person[eid]
if foeHit(a,b) then
local d=koDiffLv()
local pct=((d>0) and DT[d][2] or 0)+TV("dmg")
if d>=10 and (...)==1 then pct=pct+25 end-- the counter (flag 1)
local def=TV("b_def")
if pct~=0 or def>0 then
local p2=JY.Person[b.id]
r[1]=math.min(math.max(1,math.floor(r[1]*(100+pct)*(100-def)/10000+0.5)),p2[P_BL] or r[1])
end
elseif ourHit(a,b) then
local cut,add=TV("taken"),TV("b_atk")
if cut>0 or add>0 then
local p2=JY.Person[b.id]
r[1]=math.min(math.max(1,math.floor(r[1]*(100-cut)*(100+add)/10000+0.5)),p2[P_BL] or r[1])
end
end
end
return table.unpack(r,1,r.n)
end
local rawMHurt=WarMagicHurt
function WarMagicHurt(wid,eid,...)
local r=table.pack(rawMHurt(wid,eid,...))
if inWar() and type(r[1])=="number" and r[1]>0 then
local a,b=War.Person[wid],War.Person[eid]
if foeHit(a,b) then
local d=koDiffLv()
local f=(100+((d>0) and DT[d][2] or 0)+TV("dmg"))/100*(100-TV("b_def"))/100
if d>=8 then f=f*1.25 end
if f~=1 then
local p2=JY.Person[b.id]
r[1]=math.min(math.floor(r[1]*f+0.5),p2[P_BL] or r[1])
end
elseif ourHit(a,b) then
local cut,add=TV("taken"),TV("b_atk")
if cut>0 or add>0 then
local p2=JY.Person[b.id]
r[1]=math.min(math.max(1,math.floor(r[1]*(100-cut)*(100+add)/10000+0.5)),p2[P_BL] or r[1])
end
end
end
return table.unpack(r,1,r.n)
end
-- ---------------------------------------------------------------- 6: the enemy heals at the start of its phase
local rawAI=AI
function AI(...)
if koDiffLv()>=6 and inWar() then
for _,v in pairs(War.Person) do
if v.enemy and v.live and not v.hide and v.id>0 then
local p=JY.Person[v.id]
local mx,cur=p[P_MAXBL] or 0,p[P_BL] or 0
if cur>0 and cur<mx then p[P_BL]=math.min(mx,cur+math.max(1,math.floor(mx*5/100))) end
end
end
end
return rawAI(...)
end
-- ---------------------------------------------------------------- the challenge reward (jymain bonus_moneyexp_8 / _4)
local function challengeBonus(st)
if JY.Status~=st or (JY.Person[1][K_MJ] or 0)==0 then return end
local d=math.max(1,koDiffLv())
local pct=DT[d][3]
local g=math.floor((rawget(_G,"bonus_money") or 100)*(100+pct)/100)
local e=math.floor(30*(100+pct)/100)
local live=0
local old=bonus_exp
bonus_exp=e
for _,v in pairs(War.Person) do
if v.live and not v.hide and not v.enemy and not v.friend then
live=live+1
win_exp(v.id)
end
end
bonus_exp=old
koSetGold(koGold()+g*live)-- not GetMoney: jymain GetMoney calls bonus_moneyexp_8 again
koHook("gold_gain",g*live)
WarDrawStrBoxConfirm("\129\068\130\066 \130\113\129\071\129\068 "..d.." \133\099\129\094 \131\115\129\067 \163\171"..pct.."\163\165*"..live.."\130\088 \135\084 "..(g*live).."\131\103, 1\130\088\135\105 \131\077\131\125\132\081 \131\064\133\085 "..e,M_White)
koHook("battle_won_bonus")
os.remove(CC.R_GRPFilename[11])
end
function bonus_moneyexp_8() challengeBonus(8) end
function bonus_moneyexp_4() challengeBonus(4) end
-- ---------------------------------------------------------------- the info box beside the difficulty list (jymain koDiffPick)
function koDiffInfo(d)
local t=DT[d]
if not t then return {} end
local L={
{"\129\068\130\066 "..d,C_Name},
{"\131\076 \130\126\131\125 "..t[1].."\163\165",M_White},
{"\131\076\129\071 \130\075\130\098 \137\088\129\066 \163\171"..t[2].."\163\165",M_White},
{"\131\076 \130\082\130\123 \163\171"..d,M_White},
{"\129\116\129\117 \131\115\129\067 \163\171"..t[3].."\163\165",M_White},
}
for _,r in ipairs(RULES) do
if d>=r[1] then L[#L+1]={"\161\164 "..r[2]..((d==r[1]) and " (\134\068)" or ""),(d==r[1]) and M_Yellow or M_Silver} end
end
return L
end
function koDiffInfoDraw(d,bx,by,bw,bh)
local L=koDiffInfo(d)
if #L==0 then return end
local w,rh=236,18
local h=#L*rh+20
local x=bx+bw+4
if x+w>CC.ScreenW-4 then x=bx-4-w end
local y=by
if y+h>CC.ScreenH-4 then y=CC.ScreenH-4-h end
koRecordClassicFrame(x,y,w,h)
for i,l in ipairs(L) do DrawString(x+8,y+10+(i-1)*rh,l[1],l[2],16) end
end
