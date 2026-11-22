-- ko 3.1: "기능 확장" — the 유광판 base itself (배속·배율·연출·대화·씨앗·코스트·회차·술집 무장·전투 화면·저장 슬롯 …), which lives in
-- script/jymain.lua rather than in an addon. This file only marks it on/off in addons.lua: off (with every addon off, which it
-- forces) means config.lua starts the 순정(오리진) scripts instead. Nothing to load here.

-- ---- ko 3.3: 씨앗·상점 일괄 처리와 출전 성장 (UTF-8 원본: 개발용/addon/base33_src.lua -> free_hz.pl -> base.lua 끝)
--   jymain.lua 쪽 호출: 무장 메뉴 "\131\084\132\104 \130\114\132\111" -> koSeedUse2(), 상점 구입 -> koShopBuy(pid,iid), WarStart 승리 -> koHook("war_won")
local F_LORD=string.char(190,253,214,247)   -- 君主
local F_NAME=string.char(208,213,195,251)   -- 姓名
local F_BZ=string.char(177,248,214,214)     -- 兵种
local F_STR=string.char(206,228,193,166)    -- 武力
local F_INT=string.char(214,199,193,166)    -- 智力
local F_LEAD=string.char(205,179,194,202)   -- 统率
local F_LV=string.char(181,200,188,182)     -- 等级
local F_ITEM=string.char(181,192,190,223)   -- 道具
local F_KIND=string.char(192,224,208,205)   -- 类型
local F_SLOT=string.char(215,176,177,184,206,187) -- 装备位
local F_INAME=string.char(195,251,179,198)  -- 名称
local F_PRICE=string.char(188,219,214,181)  -- 价值
local F_SECRET1=string.char(195,216,188,188,49) -- 秘技1
local X_STR=F_STR..string.char(190,173,209,233)   -- 武力经验
local X_INT=F_INT..string.char(190,173,209,233)   -- 智力经验
local X_LEAD=F_LEAD..string.char(190,173,209,233) -- 统率经验

local function koIsSeed(iid)
if iid==nil or iid<=0 then return false end
local k=JY.Item[iid][F_KIND]
return k==8 or k==9 or k==10 or (k==13 and JY.Item[iid][F_SLOT]==0)
end
local function koSeedAttr(iid)
local k=JY.Item[iid][F_KIND]
if k==8 then return F_STR,"\129\073\131\125",CC.koNG.cap() end
if k==9 then return F_INT,"\130\067\131\125",CC.koNG.cap() end
if k==10 then return F_LEAD,"\132\119\132\120",CC.koNG.cap() end
return F_LV,"\130\082\130\123",99
end
local function koLords()
local t={}
for i=1,JY.PersonNum-1 do if JY.Person[i][F_LORD]==1 then t[#t+1]=i end end
return t
end
-- take n of item iid out of the army's bags, the user's own bag first; each bag is packed again afterwards
local function koTakeItems(first,iid,n)
local order={first}
for _,i in ipairs(koLords()) do if i~=first then order[#order+1]=i end end
for _,i in ipairs(order) do
if n<=0 then break end
local p=JY.Person[i]
local keep={}
for s=1,8 do
local v=p[F_ITEM..s]
if v==iid and n>0 then n=n-1 elseif v>0 then keep[#keep+1]=v end
end
for s=1,8 do p[F_ITEM..s]=keep[s] or 0 end
end
end
local function koCountMenu(max,fmt)
local t,vals={},{}
for _,v in ipairs({1,5,10,20,50}) do if v<max then vals[#vals+1]=v end end
vals[#vals+1]=max
for _,v in ipairs(vals) do t[#t+1]={fmt(v),nil,1} end
return t,vals
end

-- 무장 메뉴 "\131\084\132\104 \130\114\132\111": 부대 전체가 가진 씨앗을 모아 보여 주고, 고른 무장에게 여러 개를 한 번에 쓴다
function koSeedUse2()
local lords=koLords()
local personmenu={}
for i=1,JY.PersonNum-1 do personmenu[i]={"",nil,0} end
for _,i in ipairs(lords) do personmenu[i]={fillblank(JY.Person[i][F_NAME],11),nil,1} end
while true do
talk(369,"\131\084\132\104\129\083 \130\114\132\111\129\088 \129\073\131\097\129\083 \133\109\133\110\129\097\131\111\129\090.*\130\094\130\095 \130\090\136\101 \129\073\131\097\131\080 \131\084\132\104\129\083 \132\080 \129\113 \132\079\129\075\129\076\129\077.")
local r
if #lords<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r<=0 then return end
local p=JY.Person[r]
while true do
local cnt,ids={},{}
for _,i in ipairs(lords) do
for s=1,8 do
local v=JY.Person[i][F_ITEM..s]
if koIsSeed(v) then
if not cnt[v] then cnt[v]=0 ids[#ids+1]=v end
cnt[v]=cnt[v]+1
end
end
end
if #ids==0 then
PlayWavE(2)
talk(369,"\130\094\130\095\129\102 \131\084\132\104\129\071 \129\097\131\118\129\068 \130\097\129\075\129\076\129\077.")
return
end
table.sort(ids)
local menu={}
for k,v in ipairs(ids) do menu[k]={fillblank(JY.Item[v][F_INAME],13)..string.format("%3d",cnt[v]).."\134\075",nil,1} end
talk(369,p[F_NAME].."  \129\073\131\125 "..p[F_STR].." \130\067\131\125 "..p[F_INT].." \132\119\132\120 "..p[F_LEAD].." \130\082\130\123 "..p[F_LV].."*\130\114\132\111\129\088 \131\084\132\104\129\083 \133\109\133\110\129\097\131\111\129\090.")
local s=ShowMenu(menu,#menu,0,0,156,0,0,5,1,16,M_White,M_White)
if s<=0 then break end
local iid=ids[s]
local attr,label,cap=koSeedAttr(iid)
local old=p[attr]
if attr~=F_LV and not CC.Person_S[attr][4] then
PlayWavE(2)
talk(369,"\129\073\131\125\161\164\130\067\131\125\161\164\132\119\132\120\129\071 \133\102\131\097\132\067\130\067 \130\107\130\098 \129\069\129\070\129\071\130\102 \129\071 \131\084\132\104\129\083 \130\114\132\111\129\088 \129\113 \130\097\129\075\129\076\129\077.")
elseif old>=cap then
PlayWavE(2)
talk(369,label.."\129\071(\129\094) \129\071\134\119 \136\122\130\095\130\102 \132\108 \131\105\132\117 \129\113 \130\097\129\075\129\076\129\077.")
else
local max=math.min(cnt[iid],cap-old)
local n=1
if max>1 then
local cm,vals=koCountMenu(max,function(v) return v.."\134\075  "..label.." "..(old+v) end)
talk_sub(369,"\140\090 \134\075 \130\114\132\111\129\097\130\086\134\121\129\075\129\076\129\089? (\136\122\130\095 "..max.."\134\075)")
local c=ShowMenu(cm,#cm,0,0,156,0,0,5,1,16,M_White,M_White)
n=(c>0) and vals[c] or 0
end
if n>0 and WarDrawStrBoxYesNo(p[F_NAME].."\131\080 "..label.." "..old.." \161\250 "..(old+n).."*"..JY.Item[iid][F_INAME].." "..n.."\134\075. \130\114\132\111\129\088\129\089\129\090?",M_White,true) then
koTakeItems(r,iid,n)
p[attr]=old+n
ReSetAttrib(r,true)
PlayWavE(12)
talk(369,p[F_NAME].."\131\080 "..label.." "..old.." \161\250 "..p[attr])
end
end
end
end
end

-- 도구 교환: 주는 무장에게 같은 도구가 여럿이면 "1\134\075 / \130\090\130\091(\133\072\130\098 \139\074 \133\105 \135\066\129\089\130\067)" 를 고른다. 옮길 개수(0 = 취소)
function koGiveAsk(oid,cid,iid)
local item=JY.Person[oid][F_ITEM..iid]
local same,free=0,0
for s=1,8 do
if JY.Person[oid][F_ITEM..s]==item then same=same+1 end
if JY.Person[cid][F_ITEM..s]==0 then free=free+1 end
end
local max=math.min(same,free)
if same<=1 then
if WarDrawStrBoxYesNo("\133\072\130\098 \130\114\134\118: "..JY.Person[cid][F_NAME]..". \131\074\131\075\129\075\129\076\129\089?",M_White,true) then return 1 end
return 0
end
-- 같은 도구가 여럿이면 메뉴. 받는 쪽 빈칸이 1개면 "1\134\075 \130\075\131\071" 한 줄만
local menu={{"1\134\075 \130\075\131\071",nil,1}}
if max>1 then menu[2]={(max<same) and "\133\105\135\066\132\086\141\065 \130\075\131\071" or "\130\090\130\091 \130\075\131\071",nil,1} end
local r=ShowMenu(menu,#menu,0,0,0,0,0,5,1,16,M_White,M_White)
if r==1 then return 1 elseif r==2 then return max end
return 0
end
-- oid 의 iid 칸 도구를 n 개(같은 도구의 다른 칸 포함) cid 에게 옮긴다
function koGiveItems(oid,cid,iid,n)
local po,pc=JY.Person[oid],JY.Person[cid]
local item=po[F_ITEM..iid]
local left=n
local keep={}
if left>0 then left=left-1 end -- iid 칸 자신부터
for s=1,8 do
local v=po[F_ITEM..s]
if s~=iid and v>0 then
if v==item and left>0 then left=left-1 else keep[#keep+1]=v end
end
end
for s=1,8 do po[F_ITEM..s]=keep[s] or 0 end
local give=n-left
for s=1,8 do
if give<=0 then break end
if pc[F_ITEM..s]==0 then pc[F_ITEM..s]=item give=give-1 end
end
end

-- 상점 구입: 받을 무장을 고른 뒤 개수(빈 칸과 금이 허락하는 만큼)를 한 번에. 산 게 있으면 true
function koShopBuy(pid,iid)
local p=JY.Person[pid]
local price=10*JY.Item[iid][F_PRICE]
local free=0
for s=1,8 do if p[F_ITEM..s]==0 then free=free+1 end end
local max=free
if price>0 then max=math.min(free,math.floor(koGold()/price)) end
if max<1 then return false end
local n=1
if max>1 then
local cm,vals={},{}
for v=1,max do cm[v]={v.."\134\075  "..(v*price).."\131\103",nil,1} vals[v]=v end
-- 최대 개수가 무장마다 다른 까닭(가방 빈 칸 / 가진 금)을 함께 보여 준다
if max<free then
talk_sub(375,"\140\090 \134\075 \130\114\130\086\134\121\129\075\129\076\129\089?*(\129\094\129\103 \131\103\131\109\132\083 "..max.."\134\075\129\089\130\067)")
else
talk_sub(375,"\140\090 \134\075 \130\114\130\086\134\121\129\075\129\076\129\089?*("..p[F_NAME].."\131\080 \129\068\130\119 \133\105 \135\066 "..free.."\134\075)")
end
local c=ShowMenu(cm,#cm,0,0,156,0,0,5,1,16,M_White,M_White)
if c<=0 then return false end
n=vals[c]
end
if not talkYesNo(375,JY.Item[iid][F_INAME].." "..n.."\134\075 \161\250 "..p[F_NAME]..", \130\085\131\103 "..(n*price)..". \131\074\131\075\129\075\129\076\129\089?") then return false end
UseMoney(n*price)
for s=1,8 do
if n<=0 then break end
if p[F_ITEM..s]==0 then p[F_ITEM..s]=iid n=n-1 end
end
return true
end

-- 출전 성장 (종횡 모드면 늘, 3.3 에서 기능설정 켬/끔 줄은 뺌): 이긴 전투에 출전한 아군마다 능력치 경험 30(도전 난이도의 win_exp 와 같은 규칙).
--   200 이 되면 그 능력치의 씨앗 1개. 도전 난이도 추가 보상(bonus_moneyexp_*)을 이미 받은 생존 부대는 빼서 두 번 받지 않게.
--   가방이 차 있으면 경험을 깎지 않고 두었다가 다음에 준다. 자유 전투는 대상이 아님
local function koGrowthGive(pid)
local p=JY.Person[pid]
local cap=CC.koNG.cap()
-- 어느 능력치로 갈지는 win_exp 와 같은 순서로 정하고, 그 능력치가 상한이면 상한 아래인 다음 능력치로
local S={F_STR,X_STR,71} local I={F_INT,X_INT,72} local L={F_LEAD,X_LEAD,73}
local order
local bz=p[F_BZ]
if (p[F_INT]>p[F_STR] and p[F_INT]>p[F_LEAD] and p[F_INT]>=zlyz) or bz==13 or bz==16 or bz==19 or bz==26 then
order={I,L,S}
elseif p[F_STR]>=wlyz and p[F_STR]>=p[F_LEAD] then
order={S,L,I}
else
order={L,S,I}
end
local attr,xattr,seed
for _,o in ipairs(order) do
if p[o[1]]<cap then attr,xattr,seed=o[1],o[2],o[3] break end
end
if not attr then return nil end
p[xattr]=math.min(p[xattr]+bonus_exp,999)
if p[xattr]<200 then return nil end
for s=1,8 do
if p[F_ITEM..s]==0 then
p[F_ITEM..s]=seed
p[xattr]=p[xattr]-200
return seed
end
end
return nil
end
function koGrowthWon()
if not CC.Enhancement or CC.koFree or type(War)~="table" or type(War.Person)~="table" then return end -- 종횡 모드면 늘 (설정 없음)
local skipLive=CC.koGrowthBonus and JY.Person[1][F_SECRET1]==1
local got={}
for _,v in pairs(War.Person) do
if (not v.enemy) and (not v.friend) and not (v.live and v.hide) and not (skipLive and v.live) then
local seed=koGrowthGive(v.id)
if seed then got[#got+1]=JY.Person[v.id][F_NAME].."("..JY.Item[seed][F_INAME]..")" end
end
end
if #got>0 then
PlayWavE(12)
WarDrawStrBoxConfirm("\133\098\130\066 \131\123\131\097  \131\084\132\104 "..#got.."\134\075*"..table.concat(got,", "),M_White,true)
end
end

koOn("war_begin",function() CC.koGrowthBonus=false War.koAutoAll=false War.koAutoOff=false War.koAutoRun=false end)

-- 전체위임 (전투 기능 메뉴 3번째 줄): 전군위임을 이번 턴과 이후 모든 아군 턴에 자동으로. Esc·우클릭으로 해제
--   (jymain 의 입력 래퍼가 War.koAutoRun 동안에도 입력을 읽어 War.koAutoAll 을 끈다. 해제는 그 턴의 위임이 끝난 뒤부터)
--   위임 중에는 적 턴처럼 Space 로 연출을 건너뛸 수 있다
local function koDelegateRest()
War.koAutoRun=true
War.koAIStart=lib.GetTime()
War.koSkip=false
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then War.koAutoRun=false War.koSkip=false return nil end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and (not v.friend) and v.active then
War.ControlEnable=false
War.InMap=false
AI_Sub(i)
end
end
War.koAutoRun=false
War.koSkip=false
return true
end
function koAutoAllStart()
if WarDrawStrBoxYesNo("\133\103\131\098 \130\094\130\095\135\122 \129\071\133\067 \130\090\136\101 \129\112\131\080 \130\088\130\089\129\083 \130\110\129\082\129\088\129\089\129\090?*(Esc \135\079\130\098 \133\088\131\079\131\126 \129\091\135\077\139\074 \134\077\133\099\132\083 \129\066\129\100)",M_White) then
War.koAutoAll=true
War.koAutoOff=false
return koDelegateRest()
end
return nil
end
-- 아군 턴 시작(opn): false = 평소대로 조작, 그 밖 = opn 이 돌려줄 값
function koAutoAllTurn()
if War.koAutoOff then
War.koAutoOff=false
WarDrawStrBoxConfirm("\130\066\133\114\130\110\129\082\129\083 \129\066\129\100\129\080\129\075\129\076\129\077.",M_White)
return false
end
if not War.koAutoAll then return false end
return koDelegateRest()
end
koOn("draw_units_over",function()-- 5.0: over the units (was draw_overlay = under the unit sprites)
if War.koAutoAll then
local s="\130\066\133\114\130\110\129\082 \130\101  (Esc\161\164\129\091\135\077\139\074 \134\077\133\099: \129\066\129\100)"
local x=math.floor(CC.ScreenW/2-#s*4)
lib.Background(x-8,56,x+#s*8+8,76,96,M_Black)
DrawString(x,58,s,M_Yellow,16)
end
end)
koOn("battle_won_bonus",function() CC.koGrowthBonus=true end)
koOn("war_won",function() koGrowthWon() end)
-- 10-21 (user): during full delegation the level-up boxes (level, skill, strategy) close by themselves (shorter with Space skip)
do
local lvup=WarLvUp
if type(lvup)=="function" then
function WarLvUp(...)
if not (War and (War.koAutoAll or War.koAutoRun)) then return lvup(...) end
local wk=WarDrawStrBoxWaitKey
WarDrawStrBoxWaitKey=function(s,color,x,y) return WarDrawStrBoxDelay(s,color,x,y,48) end
local r=table.pack(pcall(lvup,...))
WarDrawStrBoxWaitKey=wk
if not r[1] then error(r[2],0) end
return table.unpack(r,2,r.n)
end
end
end
