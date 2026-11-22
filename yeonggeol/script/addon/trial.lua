-- ko 5.0 (10-13): 21회차부터의 시련·축복 (addon "trial"; 카페 건의 "\130\125\132\121 \129\073\129\111" → 사용자 "\130\086\131\120\133\088\129\077 \138\072\131\126\141\074, \130\125\132\121\133\088\129\077 \138\072\131\126\141\074\132\086\141\065 \131\100\130\106\129\081",
-- 이어서 "\143\085\133\119 \136\069\130\124\132\083, \143\085\133\119\133\088\129\077 <> \132\083 \129\118\133\089", "\130\086\131\120 \136\124\131\100 \129\099\130\068\129\068: \130\086\131\120\131\098 \138\072\131\126\141\074 +, \129\071\132\083\135\083 \129\119 -", "\129\099\130\068\129\068 5\134\077\132\084").
-- 회차를 시작할 때(koNG.reset 뒤, 또는 21회차 이상인데 아직 안 골랐으면 출진 화면 전) 고르기 화면: [시련] [축복] 두 탭, 4x4 카드.
-- 합계 = 시련 코스트 - 축복 코스트 가 요구 코스트(2 x (회차 - 20), 상한 60) 이상이면 결정. 서로 반대인 시련·축복은 하나만.
-- 회차 중에는 바꿀 수 없음. 회차를 마칠 때 합계가 「최고 시련」 기록(설정 파일 CC.koTrialBest / koTrialBestCyc)이 된다.
-- 단계는 세이브의 事件 1964·1966·1967·1968 에 혼합 진법으로 (칸마다 단계 수를 곱해 65536 안; 마지막 칸 끝에 「골랐음」·「이 전투 선공 함」).
-- 적 쪽 효과(병력·레벨·피해·받는 피해·증원·총대장·이동력)와 아군 병력·책략치·피해는 diff 애드온이 koTrialV 로 읽는다.
-- 여기서: 아군 출진(SelectTerm 의 빈 자리 줄), 회복(jymain koHealCut), 경험치(WarAddExp), 전투 금(gold_gain), 상점(jymain koShopP + koShopBuy),
-- 적 선공(war_begin 에 적 차례 한 번), 적 총공격·복병 출현(예전 기능설정 두 줄 = JY.Base 敌军出击 / 无用4).
-- 「턴 제한」 은 뺌(kdef 가 턴 번호로 증원·승리를 거는 전투가 많음) → 「적 이동력 +1」. 「책략 소비」 → 「아군 책략치 최대」.
-- Source: 개발용/addon/trial_src.lua (UTF-8); script/addon/trial.lua is made from it by 개발용/도구/free_hz.pl.
-- Original UI artwork for trial configuration and the in-battle overview (10-14 design: buttons as the record screen's classic bars).
function koTrialClassicWait(draw,buttons)
for _,b in ipairs(buttons) do
if not b.plain and not b.draw then
b.draw=function(b,on,hover)
local yy=b.y+math.floor((b.h-22)/2)
koRecordClassicBar(b.x,yy,b.w,on or hover)
DrawString(b.x+b.w/2-#b.s*4,yy+3,b.s,M_White,16)
end
end
end
return koTourWait(draw,buttons)
end
local EV="\202\194\188\254"-- 事件
local SLOT={1964,1966,1967,1968}
local K_ENEMY,K_SORT="\181\208\190\252\179\246\187\247","\206\222\211\195\052"-- 敌军出击 无用4
local I_PRICE="\188\219\214\181"-- 价值
local P_BL,P_MAXBL="\177\248\193\166","\215\238\180\243\177\248\193\166"
local NG=CC.koNG
-- b = 축복 (코스트를 뺌), e = 경제 항목 (전투 합계에 안 들어감), pair = 서로 반대라 하나만 고를 수 있는 짝
local TR={
{k="hp",n="\131\076 \130\126\131\125",s={"\163\17110\163\165","\163\17120\163\165","\163\17130\163\165","\163\17140\163\165","\163\17150\163\165"},c={1,2,3,5,7},v={10,20,30,40,50},d="\131\076 \130\094\130\095\131\080 \130\126\131\125 \136\122\130\095\132\081\129\094 \131\088\130\083\139\095\129\076\129\077"},
{k="lv",n="\131\076 \130\082\130\123",s={"\163\1712","\163\1714","\163\1716","\163\1718","\163\17110"},c={1,2,3,5,7},v={2,4,6,8,10},d="\131\076 \129\073\131\097\131\080 \130\082\130\123\129\071 \129\091\139\123\129\076\129\077",pair="b_elv"},
{k="dmg",n="\131\076\129\071 \130\075\130\098 \137\088\129\066",s={"\163\17110\163\165","\163\17120\163\165","\163\17130\163\165","\163\17140\163\165","\163\17150\163\165"},c={2,3,5,7,9},v={10,20,30,40,50},d="\131\076\131\080 \130\074\130\112\161\164\133\065\130\112\161\164\130\117\130\118 \137\088\129\066\129\094 \131\088\130\083\139\095\129\076\129\077",pair="b_def"},
{k="taken",n="\131\076\129\071 \133\072\130\098 \137\088\129\066",s={"\163\17310\163\165","\163\17320\163\165","\163\17330\163\165"},c={2,4,6},v={10,20,30},d="\129\110\130\084\129\071 \131\076\129\102\129\081 \130\075\130\098 \137\088\129\066\129\094 \132\123\130\083\143\120\129\076\129\077",pair="b_atk"},
{k="reinf",n="\131\076 \137\100\131\081",s={"1\130\094\130\095","2\130\094\130\095","3\130\094\130\095"},c={3,5,8},v={1,2,3},d="\130\066\132\101\133\088\129\077 \131\076 \130\094\130\095\129\094 \132\108 \131\118\133\111\129\076\129\077 (\129\110\130\084\129\123 4\135\066 \129\071\129\067 \132\110\130\083\129\103 \135\069)"},
{k="lead",n="\131\076 \135\084\130\095\131\097 \130\126\131\125",s={"x1.5","x2","x2.5","x3"},c={1,2,4,6},v={150,200,250,300},d="\131\076 \135\084\130\095\131\097\131\080 \130\126\131\125\129\071 \140\090 \134\099\129\094 \140\106\129\076\129\077"},
{k="move",n="\131\076 \129\071\130\108\131\125",s={"\163\1711"},c={3},v={1},d="\130\090\136\101 \131\076 \130\094\130\095\131\080 \129\071\130\108\131\125\129\071 1 \131\088\130\083\139\095\129\076\129\077"},
{k="first",n="\131\076 \133\109\130\074",s={"\133\122"},c={2},v={1},d="\137\112 \129\112\129\102 \131\076\129\071 \137\113\133\102 \136\108\132\076\129\104\129\076\129\077"},
{k="allout",n="\131\076 \135\084\130\074\130\112",s={"\133\122"},c={1},v={1},d="\129\100\133\120\129\117\130\104 \130\067\137\074\138\066 \131\076\129\068 \139\110\130\077\130\094\131\104 \130\074\130\112\129\066 \133\111\129\076\129\077"},
{k="ambush",n="\130\068\130\126 \133\098\129\114",s={"\133\122"},c={1},v={1},d="\133\126\130\083 \132\079\138\066 \131\076\129\071 \130\066\132\101 \130\086\129\074\130\094\131\104 \131\118\133\111\129\076\129\077 (\129\110\130\084 3\135\066 \130\111\131\098 \131\091\130\095\132\083)"},
-- 6.0 (10-28): ext 카드 = 혼합 진법(事件 4칸, 남은 자리 없음) 밖, 인물 칸 801 에 따로 (회차마다 새로). 「적장 각성 장비」 카드는 넣었다가 같은 날 빼고 난이도 규칙(diff 5·7·9)으로 옮김 — 지금 ext 카드 없음
{k="sortie",n="\129\110\130\084 \133\098\129\103",s={"\163\1731","\163\1732","\163\1733"},c={3,5,8},v={1,2,3},d="\133\098\129\103\129\088 \129\113 \132\079\130\098 \133\105 \133\120\129\117\129\094 \132\123\130\083\143\120\129\076\129\077 (\130\090\130\091 \129\087\138\080 3\130\088\131\098 \133\103\130\077)"},
{k="heal",n="\129\110\130\084 \130\125\130\068",s={"\163\17320\163\165","\163\17340\163\165","\163\17360\163\165","\163\17380\163\165"},c={1,2,3,5},v={20,40,60,80},d="\129\110\130\084 \130\126\131\125 \130\125\130\068(\130\117\130\118\161\164\129\068\130\119\161\164\129\112 \130\086\129\074 \130\125\130\068)\129\071 \132\123\130\083\143\120\129\076\129\077",pair="b_heal"},
{k="mp",n="\129\110\130\084 \130\117\130\118\132\081",s={"\163\17320\163\165","\163\17335\163\165","\163\17345\163\165","\163\17350\163\165"},c={1,2,3,5},v={20,35,45,50},d="\130\066\132\101 \130\101 \129\110\130\084 \130\117\130\118\132\081 \136\122\130\095\132\081\129\094 \132\123\130\083\143\120\129\076\129\077",pair="b_mp"},
{e=true,k="exp",n="\131\064\133\085\132\081",s={"\163\17320\163\165","\163\17340\163\165","\163\17360\163\165"},c={2,3,5},v={20,40,60},d="\130\066\132\101\129\102\131\087 \133\086\130\098 \131\064\133\085\132\081\129\094 \132\123\130\083\143\120\129\076\129\077",pair="b_exp"},
{e=true,k="gold",n="\130\066\132\101 \131\103",s={"\163\17320\163\165","\163\17340\163\165","\163\17360\163\165","\163\17380\163\165"},c={1,2,3,4},v={20,40,60,80},d="\130\066\132\101\129\102\131\087 \133\086\130\098 \131\103\129\071 \132\123\130\083\143\120\129\076\129\077",pair="b_gold"},
{e=true,k="shop",n="\129\067\135\070 \129\094\130\112",s={"\163\17125\163\165","\163\17150\163\165","\163\171100\163\165"},c={1,2,3},v={25,50,100},d="\129\068\130\119\130\104 \134\106 \132\085 \137\093\129\071 \129\091\139\123\129\076\129\077 (\134\086\130\098 \137\093\131\098 \131\091\130\095\132\083)",pair="b_shop"},
{b=true,k="b_hp",n="\129\110\130\084 \130\126\131\125",s={"\163\17110\163\165","\163\17120\163\165","\163\17130\163\165","\163\17140\163\165","\163\17150\163\165"},c={2,4,6,9,12},v={10,20,30,40,50},d="\129\110\130\084 \130\094\130\095\131\080 \130\126\131\125 \136\122\130\095\132\081\129\094 \131\088\130\083\139\095\129\076\129\077 (\131\079\130\084 \129\100\131\107)"},
{b=true,k="b_atk",n="\129\110\130\084 \130\074\130\112",s={"\163\17110\163\165","\163\17120\163\165","\163\17130\163\165","\163\17140\163\165","\163\17150\163\165"},c={2,4,6,9,12},v={10,20,30,40,50},d="\129\110\130\084\129\071 \130\075\130\098 \137\088\129\066(\130\074\130\112\161\164\133\065\130\112\161\164\130\117\130\118)\129\094 \131\088\130\083\139\095\129\076\129\077",pair="taken"},
{b=true,k="b_def",n="\129\110\130\084 \132\078\130\083",s={"\163\1735\163\165","\163\17310\163\165","\163\17315\163\165","\163\17320\163\165","\163\17325\163\165"},c={2,3,5,7,9},v={5,10,15,20,25},d="\131\076\129\102\129\081 \133\072\130\098 \137\088\129\066\129\094 \132\123\130\083\143\120\129\076\129\077",pair="dmg"},
{b=true,k="b_elv",n="\131\076 \130\082\130\123",s={"\163\1731","\163\1732","\163\1733","\163\1734","\163\1735"},c={2,4,6,8,10},v={1,2,3,4,5},d="\131\076 \129\073\131\097\131\080 \130\082\130\123\129\071 \131\095\131\096\134\104\129\076\129\077 (1 \129\110\134\071\132\083\130\098 \130\111 \131\095\131\096\135\078)",pair="lv"},
{b=true,k="b_mp",n="\129\110\130\084 \130\117\130\118\132\081",s={"\163\17120\163\165","\163\17140\163\165","\163\17160\163\165","\163\17180\163\165","\163\171100\163\165"},c={1,2,3,4,6},v={20,40,60,80,100},d="\130\066\132\101 \130\101 \129\110\130\084 \130\117\130\118\132\081 \136\122\130\095\132\081\129\094 \131\088\130\083\139\095\129\076\129\077",pair="mp"},
{b=true,k="b_heal",n="\129\110\130\084 \130\125\130\068",s={"\163\17120\163\165","\163\17140\163\165","\163\17160\163\165","\163\17180\163\165","\163\171100\163\165"},c={1,2,3,4,5},v={20,40,60,80,100},d="\129\110\130\084 \130\126\131\125 \130\125\130\068(\130\117\130\118\161\164\129\068\130\119\161\164\129\112 \130\086\129\074 \130\125\130\068)\129\071 \131\088\130\083\139\095\129\076\129\077",pair="heal"},
{b=true,e=true,k="b_exp",n="\131\064\133\085\132\081",s={"\163\17120\163\165","\163\17140\163\165","\163\17160\163\165","\163\17180\163\165","\163\171100\163\165"},c={1,2,3,5,7},v={20,40,60,80,100},d="\130\066\132\101\129\102\131\087 \133\086\130\098 \131\064\133\085\132\081\129\094 \131\088\130\083\139\095\129\076\129\077",pair="exp"},
{b=true,e=true,k="b_gold",n="\130\066\132\101 \131\103",s={"\163\17120\163\165","\163\17140\163\165","\163\17160\163\165","\163\17180\163\165","\163\171100\163\165"},c={1,2,3,4,5},v={20,40,60,80,100},d="\130\066\132\101\129\102\131\087 \133\086\130\098 \131\103\129\071 \131\088\130\083\139\095\129\076\129\077",pair="gold"},
{b=true,e=true,k="b_shop",n="\129\067\135\070 \129\088\129\106",s={"\163\17310\163\165","\163\17320\163\165","\163\17330\163\165","\163\17340\163\165","\163\17350\163\165"},c={1,2,3,4,5},v={10,20,30,40,50},d="\129\068\130\119\130\104 \134\106 \132\085 \137\093\129\071 \131\095\131\096\134\104\129\076\129\077",pair="shop"},
-- head = not a card: the 「난이도 고정」 control in the screen's head row; late = stored after the flag digit (old saves read 0 there)
{head=true,late=true,k="dlock",n="\130\113\129\071\129\068 \131\100\129\070",s={"\129\068\130\066 6 \129\071\129\067","\129\068\130\066 7 \129\071\129\067","\129\068\130\066 8 \129\071\129\067","\129\068\130\066 9 \129\071\129\067","\129\068\130\066 10"},c={3,6,9,12,16},v={6,7,8,9,10},d="\129\071\130\087 \130\125\132\121 \129\068\130\066 \130\113\129\071\129\068\130\104 \129\071 \134\077\132\084 \129\110\134\071\132\083 \131\095\132\117 \129\113 \130\097\129\075\129\076\129\077"},
}
-- the lowest challenge level a cycle must be played at: 도전 5 from cycle 21, +1 every 10 cycles (31 도전 6 … 71 도전 10) (user 10-14)
function koTrialFloor(n)
n=n or ((CC.koNG and CC.koNG.rcycle) and CC.koNG.rcycle() or 1)
if n<21 then return 0 end
return math.min(10,5+math.floor((n-21)/10))
end
-- 「난이도 고정」 is worth only what it adds above the cycle's floor: base value (도전 5 = 0, 6 3, 7 6, 8 9, 9 12, 10 16) minus the floor's
local DLV={[5]=0,[6]=3,[7]=6,[8]=9,[9]=12,[10]=16}
local function costOf(t,g)
if t.k=="dlock" then return math.max(0,t.c[g]-(DLV[koTrialFloor()] or 0)) end
return t.c[g]
end
koTrialCostOf=costOf
local IDX={} for i,t in ipairs(TR) do IDX[t.k]=i end
koTrialList=TR
-- ---------------------------------------------------------------- storage: mixed radix, each slot's product of (stages+1) <= 65536
-- GROUP[g] = list of item indexes, "F" = the flag digit (radix 4) after the cards, then the late items and "S" = the cycle's
-- starting challenge level (radix 11: 0 = 보통 … 10); a save made before 「난이도 고정」 has 0 in those high digits
local GROUP={}
do
local seq={}
for i,t in ipairs(TR) do if not t.late and not t.ext then seq[#seq+1]=i end end
seq[#seq+1]="F"
for i,t in ipairs(TR) do if t.late and not t.ext then seq[#seq+1]=i end end
seq[#seq+1]="S"
local g,prod=1,1
GROUP[1]={}
for _,it in ipairs(seq) do
local r=(it=="F") and 4 or (it=="S") and 11 or (#TR[it].c+1)
if prod*r>65536 then g=g+1 prod=1 GROUP[g]={} end
table.insert(GROUP[g],it) prod=prod*r
end
assert(g<=#SLOT,"trial: too many slots")
end
local function radixOf(it) if it=="F" then return 4 elseif it=="S" then return 11 end return #TR[it].c+1 end
local function readSlot(s) local v=JY.Base and JY.Base[EV..s] or 0 if v==nil then v=0 end if v<0 then v=v+65536 end return v end
local function writeSlot(s,v) if v>32767 then v=v-65536 end JY.Base[EV..s]=v end
-- ext 카드 (인물 칸 801, 외호 24~ 의 16비트 칸 하나씩, 카드 순서대로) — 802칸 표가 아니면 0
local EXTP,EXTO=801,24
local function extIdx() local t={} for i,c in ipairs(TR) do if c.ext then t[#t+1]=i end end return t end
local EXT=extIdx()
local function extGet(n) if (JY.PersonNum or 0)<=EXTP or not JY.Data_Person then return 0 end return Byte.get16(JY.Data_Person,EXTP*CC.PersonSize+EXTO+2*(n-1)) end
local function extSet(n,v) if (JY.PersonNum or 0)<=EXTP or not JY.Data_Person then return end Byte.set16(JY.Data_Person,EXTP*CC.PersonSize+EXTO+2*(n-1),v) end
local function decode()
local st,fl,sd={},0,0
for g,list in ipairs(GROUP) do
local v=readSlot(SLOT[g])
for _,it in ipairs(list) do
local r=radixOf(it)
local d=v%r v=math.floor(v/r)
if it=="F" then fl=d elseif it=="S" then sd=d else st[it]=math.min(d,#TR[it].c) end
end
end
for n,i in ipairs(EXT) do st[i]=math.max(0,math.min(extGet(n),#TR[i].c)) end
return st,fl,sd
end
local function encode(st,fl,sd)
if sd==nil then local _,_,o=decode() sd=o end
for g,list in ipairs(GROUP) do
local v,m=0,1
for _,it in ipairs(list) do
local d=(it=="F") and fl or (it=="S") and sd or (st[it] or 0)
v=v+d*m m=m*radixOf(it)
end
writeSlot(SLOT[g],v)
end
for n,i in ipairs(EXT) do extSet(n,st[i] or 0) end
end
local F_CHOSEN,F_FIRST=1,2
local function getStage(i) local st=decode() return st[i] or 0 end
local function flag(bit) local _,fl=decode() return math.floor(fl/bit)%2==1 end
local function setFlag(bit,on) local st,fl,sd=decode() local o=math.floor(fl/bit)%2 encode(st,fl+((on and 1 or 0)-o)*bit,sd) end
-- the cycle's starting challenge level (0 = 보통 or not chosen yet): the difficulty may not go below it this cycle
function koTrialStartDiff() if not koTrialOn() then return 0 end local _,fl,sd=decode() if math.floor(fl/F_CHOSEN)%2~=1 then return 0 end return sd end
local function cycle() return (NG and NG.rcycle) and NG.rcycle() or 1 end
function koTrialOn() return CC.Enhancement and JY.Base~=nil and cycle()>=21 end
function koTrialReq(n) n=n or cycle() if n<21 then return 0 end return math.min(60,2*(n-20)) end
-- the sums: total (trials - blessings), trials, blessings, battle total (the same without the economy items: 경험치·전투 금·상점);
-- both totals must reach the requirement, so economy trials cannot buy battle blessings. st = stages table, or the saved ones
function koTrialCost(st)
st=st or decode()
local up,down,bat=0,0,0
for i,t in ipairs(TR) do local g=st[i] or 0 if g>0 then local c=costOf(t,g) if t.b then down=down+c else up=up+c end if not t.e then bat=bat+(t.b and -c or c) end end end
return up-down,up,down,bat
end
function koTrialOK(st,req) local tot,_,_,bat=koTrialCost(st) return tot>=req and bat>=req end
-- the value of item k at its stage (0 = off / before cycle 21)
function koTrialV(k)
if not koTrialOn() then return 0 end
local i=IDX[k]
if not i then return 0 end
local g=getStage(i)
return (g>0) and TR[i].v[g] or 0
end
-- ---------------------------------------------------------------- the choosing screen (cards)
local function autoPick(st,req)
for i,t in ipairs(TR) do if not t.head then st[i]=0 end end
local guard=0
while not koTrialOK(st,req) and guard<300 do
guard=guard+1
local c={}
for i,t in ipairs(TR) do if not t.b and not t.e and not t.head and st[i]<#t.c then c[#c+1]=i end end
if #c==0 then break end
local i=c[math.random(#c)]
st[i]=st[i]+1
end
end
function koTrialBestStr()
local b=tonumber(CC.koTrialBest)
if b==nil or (tonumber(CC.koTrialBestCyc) or 0)<=0 then return "-" end
return "\138\072\131\126\141\074 "..b.." ("..(tonumber(CC.koTrialBestCyc) or 0).."\130\125\132\121)"
end
function koTrialNowStr()
if not koTrialOn() then return "-" end
local tot,_,_,bat=koTrialCost()
return "\138\072\131\126\141\074 "..tot.." (\130\066\132\101 "..bat..", \129\090\130\119 "..koTrialReq()..")"
end
local CW,CH,GX,GY=174,76,6,6
local function cardBox(x,y,w,h,edge,fill)
koRecordClassicFrame(x,y,w,h)
if edge==M_White or edge==C_Name or edge==M_DeepSkyBlue then
-- Outline the original frame itself so selected cards remain identifiable off hover.
for inset=0,1 do
lib.DrawRect(x+inset,y+inset,x+w-inset,y+inset,edge)
lib.DrawRect(x+inset,y+h-inset,x+w-inset,y+h-inset,edge)
lib.DrawRect(x+inset,y+inset,x+inset,y+h-inset,edge)
lib.DrawRect(x+w-inset,y+inset,x+w-inset,y+h-inset,edge)
end
lib.DrawRect(x+8,y+24,x+w-8,y+24,edge)
end
end
function koTrialChoose()
local n=cycle()
local req=koTrialReq(n)
local st=decode()
for i=1,#TR do st[i]=st[i] or 0 end
local tab=1-- 1 시련, 2 축복
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
local gx0,gy0=ox+(768-(4*CW+3*GX))/2,oy+70
local B_OK,B_AUTO,B_OFF,B_T1,B_T2,B_DL,B_DR,B_DH=1,2,3,4,5,6,7,8
local DL=IDX.dlock
local floor=koTrialFloor(n)
-- the 「난이도 고정」 stages at or below the cycle's own floor give nothing new: skipped
if st[DL]>0 and TR[DL].v[st[DL]]<=floor then st[DL]=0 end
local function list() local L={} for i,t in ipairs(TR) do if not t.head and (tab==2)==(t.b==true) then L[#L+1]=i end end return L end
-- 6.0 (10-28): 카드가 16장을 넘으면 (시련 탭 17장) 칸 높이 76 → 62 · 줄 사이 4 로 5줄 (글자 · 단추를 위로 당김, 너비 · 4열은 그대로 — 5열은 긴 이름이 비용과 겹침)
local function grid(n) local sm=(n>16) return 4,CW,gx0,sm and 62 or CH,sm and 4 or GY,sm end
local function curDiff() if (JY.Person[1]["\195\216\188\188\49"] or 0)==0 then return 0 end return JY.Person[1]["\183\220\213\189"] or 0 end
local function startOf() local dv=(st[DL]>0) and TR[DL].v[st[DL]] or 0 return math.max(curDiff(),floor,dv) end
local btns
local function build()
btns={}
btns[B_OK]={x=ox+454,y=oy+446,w=100,h=24,s="\134\064\129\070"}
btns[B_AUTO]={x=ox+214,y=oy+446,w=100,h=24,s="\133\120\130\108 \131\100\130\106\131\071"}
btns[B_OFF]={x=ox+334,y=oy+446,w=100,h=24,s="\130\090\130\091 \136\097\131\071"}
btns[B_T1]={x=ox+24,y=oy+40,w=96,h=22,s="\130\086\131\120",sel=(tab==1)}
btns[B_T2]={x=ox+124,y=oy+40,w=96,h=22,s="\129\099\130\068",sel=(tab==2)}
btns[B_DL]={x=ox+352,y=oy+41,w=22,h=20,s="<",item=DL,dir=-1}
btns[B_DR]={x=ox+500,y=oy+41,w=22,h=20,s=">",item=DL,dir=1}
btns[B_DH]={x=ox+236,y=oy+40,w=330,h=22,plain=true,item=DL,draw=function() end}
local L=list()
local cols,cw,gx,ch,gy,sm=grid(#L)
for k,i in ipairs(L) do
local x=gx+((k-1)%cols)*(cw+GX)
local y=gy0+math.floor((k-1)/cols)*(ch+gy)
local by,bh=sm and (y+ch-24) or (y+ch-30),sm and 20 or 22
btns[#btns+1]={x=x+12,y=by,w=28,h=bh,s="<",item=i,dir=-1}
btns[#btns+1]={x=x+cw-40,y=by,w=28,h=bh,s=">",item=i,dir=1}
btns[#btns+1]={x=x,y=y,w=cw,h=ch,plain=true,item=i,draw=function() end}
end
end
local function draw(hov)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
koRecordClassicFrame(ox,oy,768,480)
local tot,up,down,bat=koTrialCost(st)
DrawString(ox+24,oy+14,n.."\130\125\132\121 \130\086\131\120",C_Name,16)
local s="\129\090\130\119 "..req.."  \129\087\132\084 "..tot.."  \130\066\132\101 "..bat.."  (\130\086\131\120 \163\171"..up.."  \129\099\130\068 \163\173"..down..")"
DrawString(ox+744-#s*8,oy+14,s,koTrialOK(st,req) and M_Yellow or M_Red,16)
local dg=st[DL]
DrawString(ox+244,oy+44,TR[DL].n,(dg>0) and M_White or M_Silver,16)
local dlab=(dg>0) and TR[DL].s[dg] or "\130\097\130\077"
DrawString(ox+437-#dlab*4,oy+44,dlab,(dg>0) and C_Name or M_Gray,16)
local dcs=(dg>0) and ("\163\171"..costOf(TR[DL],dg)) or "0"
DrawString(ox+530,oy+44,dcs,(dg>0) and M_Red or M_DimGray,16)
if floor>0 then DrawString(ox+580,oy+44,"(\130\125\132\121 \131\071\132\118 \129\068\130\066 "..floor..")",M_Gray,16) end
local hi=hov>0 and btns[hov] and btns[hov].item
local L=list()
local cols,CWd,gx,CHd,GYd,sm=grid(#L)
for k,i in ipairs(L) do
local t=TR[i]
local x=gx+((k-1)%cols)*(CWd+GX)
local y=gy0+math.floor((k-1)/cols)*(CHd+GYd)
local y1,y2,y3=sm and 6 or 8,sm and 23 or 30,sm and (CHd-21) or (CHd-27)
local g=st[i]
local edge=(g>0) and (t.b and M_DeepSkyBlue or C_Name) or M_Gray
cardBox(x,y,CWd,CHd,(hi==i) and M_White or edge,(hi==i) and 64 or 112)
DrawString(x+8,y+y1,t.n,(g>0) and M_White or M_Silver,16)
local cs=(g>0) and ((t.b and "\163\173" or "\163\171")..t.c[g]) or "0"-- the cost of the current stage (0 = none)
DrawString(x+CWd-8-#cs*8,y+y1,cs,(g>0) and (t.b and M_DeepSkyBlue or M_Red) or M_Silver,16)
local lab=(g>0) and t.s[g] or "\130\097\130\077"
DrawString(x+CWd/2-#lab*4,y+y2,lab,(g>0) and C_Name or M_Silver,16)
local ds=g.." / "..#t.c
DrawString(x+CWd/2-#ds*4,y+y3,ds,M_Silver,16)
end
if hi then
local t=TR[hi]
DrawString(ox+24,oy+402,t.d,M_Silver,16)
local s2=""
if t.pair and IDX[t.pair] then s2="\161\184"..TR[IDX[t.pair]].n.."\161\185 "..(t.b and "\130\086\131\120" or "\129\099\130\068").."\129\123 \137\072\138\095 \136\102 \131\100\138\075" end
if t.e then s2=s2..((s2~="") and " \161\164 " or "").."\130\066\132\101 \129\087\132\084\129\102\130\098 \130\111 \131\082\130\083\135\078" end
if s2~="" then DrawString(ox+24,oy+422,s2,M_Gray,16) end
end
if not hi then DrawString(ox+24,oy+402,"\129\087\132\084\135\122 \130\066\132\101 \129\087\132\084(\131\064\133\085\132\081\161\164\130\066\132\101 \131\103\161\164\129\067\135\070 \138\102\131\100)\129\094 \130\090\130\091 \129\090\130\119 \129\071\129\067\129\071\130\083\133\069 \134\064\129\070\140\106\129\076\129\077",M_Gray,16) end
local sd=startOf()
if not hi then DrawString(ox+24,oy+422,"\130\086\129\074 \130\113\129\071\129\068: "..((sd>0) and ("\129\068\130\066 "..sd.." (\130\125\132\121 \130\101 \129\071 \129\110\134\071\132\083 \136\102 \131\095\130\079)") or "\131\115\132\119").."   \136\122\131\100 \131\071\133\108: "..koTrialBestStr(),M_Gray,16) end
end
build()
while true do
local r=koTrialClassicWait(draw,btns)
local b=btns[r]
if b and b.dir then
local t=TR[b.item]
local nv=math.max(0,math.min(#t.c,st[b.item]+b.dir))
if b.item==DL then
while nv>0 and nv<=#t.c and t.v[nv]<=floor do nv=nv+b.dir end-- below the cycle's floor: skipped
if nv>#t.c then nv=st[DL] elseif nv<0 then nv=0 end
end
st[b.item]=nv
if nv>0 and t.pair and IDX[t.pair] then st[IDX[t.pair]]=0 end
elseif r==B_T1 or r==B_T2 then tab=(r==B_T1) and 1 or 2 build()
elseif r==B_AUTO then autoPick(st,req)
elseif r==B_OFF then for i=1,#TR do st[i]=0 end
elseif r==B_OK then
if koTrialOK(st,req) then break end
PlayWavE(2)
end
end
-- the cycle's starting level: the current one, the cycle floor or the lock, whichever is highest; never lower than it this cycle
local sd=startOf()
if sd>0 then
JY.Person[1]["\195\216\188\188\49"]=1
if (JY.Person[1]["\183\220\213\189"] or 0)<sd then JY.Person[1]["\183\220\213\189"]=sd end
end
encode(st,F_CHOSEN,sd)
koTrialSync()
end
-- the two old settings rows are trials now: their JY.Base fields follow the trial (off before cycle 21)
function koTrialSync()
if JY.Base==nil then return end
JY.Base[K_ENEMY]=koTrialV("allout")
JY.Base[K_SORT]=koTrialV("ambush")
end
local function needChoose() return koTrialOn() and not flag(F_CHOSEN) end
-- the starting level holds for the whole cycle: lowering below it (기능설정 보통 / 도전 N) is refused. Every lowering in the settings
-- goes through koNG.warnLower(newd) (newd 0 = 보통); an old save below it is raised before the next battle (koTrialEnforce)
if NG and NG.warnLower then
local rawWarn=NG.warnLower
NG.warnLower=function(newd,...)
local sd=koTrialStartDiff()
if sd>0 and (newd or 0)<sd then
WarDrawStrBoxConfirm("\129\071\130\087 \130\125\132\121\130\098 \129\068\130\066 "..sd.." \129\110\134\071\132\083 \131\095\132\117 \129\113 \130\097\129\075\129\076\129\077*(21\130\125\132\121\130\094\131\104\130\098 \130\125\132\121\130\104 \130\086\129\074\129\088 \132\085\131\080 \130\113\129\071\129\068\129\094 \131\085\136\118)",M_White,true)
return false
end
return rawWarn(newd,...)
end
end
function koTrialEnforce()
local sd=koTrialStartDiff()
if sd<=0 then return end
JY.Person[1]["\195\216\188\188\49"]=1
if (JY.Person[1]["\183\220\213\189"] or 0)<sd then JY.Person[1]["\183\220\213\189"]=sd end
end
-- ---------------------------------------------------------------- the cycle: choose after koNG.reset, record the best at the clear
if NG then
local rawReset=NG.reset
NG.reset=function(...)
local a,b,c=rawReset(...)
if a~=false and koTrialOn() then koTrialChoose() end
koTrialSync()
return a,b,c
end
local rawKeep=NG.keepClear
NG.keepClear=function(n,...)
if koTrialOn() and flag(F_CHOSEN) then
local c=koTrialCost()
if (tonumber(CC.koTrialBestCyc) or 0)<=0 or c>(tonumber(CC.koTrialBest) or 0) then CC.koTrialBest=c CC.koTrialBestCyc=n koSave() end
end
return rawKeep(n,...)
end
end
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koTrialBest",default=0}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koTrialBestCyc",default=0}
koOn("record_load",function() koTrialSync() end)
-- ---------------------------------------------------------------- 아군 출진: fewer free rows in the team table
local function cutTeam(team,k)
local rows,free,fixed={},0,0
for j=1,30 do
local idx=(j-1)*7
if team[idx+7]==nil then break end
local r={} for q=1,7 do r[q]=team[idx+q] end
rows[#rows+1]=r
if r[1]==-1 then free=free+1 else fixed=fixed+1 end
end
if free==0 then return team end
local keep=math.max(free-k,math.max(0,3-fixed))
if keep>=free then return team end
local out,used={},0
for _,r in ipairs(rows) do
if r[1]~=-1 or used<keep then
if r[1]==-1 then used=used+1 end
for q=1,7 do out[#out+1]=r[q] end
end
end
return out
end
local rawST=SelectTerm
function SelectTerm(fid,team,...)
if needChoose() then koTrialChoose() end
koTrialSync()
koTrialEnforce()
local k=koTrialV("sortie")
if k>0 and type(team)=="table" then team=cutTeam(team,k) end
return rawST(fid,team,...)
end
-- ---------------------------------------------------------------- 회복 (jymain koHealCut), 경험치, 전투 금, 상점
function koHealCut(h,wid)
local v=War.Person[wid]
if not v or v.enemy or type(h)~="number" or h<=0 then return h end
local pct=koTrialV("b_heal")-koTrialV("heal")
if pct==0 then return h end
local nh=math.floor(h*(100+pct)/100)
local p=JY.Person[v.id]
if pct>0 and p then nh=math.min(nh,math.max(h,(p[P_MAXBL] or 0)-(p[P_BL] or 0))) end
return nh
end
local rawAdd=WarAddExp
function WarAddExp(id,Exp,...)
local pct=koTrialV("b_exp")-koTrialV("exp")
if pct~=0 and type(Exp)=="number" and Exp>0 then Exp=math.max(1,math.floor(Exp*(100+pct)/100)) end
return rawAdd(id,Exp,...)
end
koOn("gold_gain",function(n)
local pct=koTrialV("b_gold")-koTrialV("gold")
if pct~=0 and type(n)=="number" and n>0 and (JY.Status==GAME_WMAP or JY.Status==GAME_WMAP2 or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE) then
koSetGold(math.max(0,koGold()+math.floor(n*pct/100)))
end
end)
function koTrialShopPct() return koTrialV("shop")-koTrialV("b_shop") end
local rawBuy=rawget(_G,"koShopBuy")
if rawBuy then
function koShopBuy(pid,iid,...)
local c=koTrialShopPct()
if c==0 then return rawBuy(pid,iid,...) end
local it=JY.Item[iid]
local p0=it[I_PRICE]
it[I_PRICE]=math.floor(p0*(100+c)/100)
local r=table.pack(pcall(rawBuy,pid,iid,...))
it[I_PRICE]=p0
if not r[1] then error(r[2],0) end
return table.unpack(r,2,r.n)
end
end
-- ---------------------------------------------------------------- 적 선공: one extra enemy phase before our first turn
-- jymain koHook("turn_ready") = the turn's own events (승리 조건 안내 등) are over and our phase is next (addon/patch_턴준비고리.pl).
-- Only the enemy moves (우군 such as 보급대 rest), and afterwards every enemy may act again in turn 1's own enemy phase.
koOn("war_begin",function() koTrialSync() end)
koOn("turn_ready",function()
if JY.Status~=GAME_WMAP or koTrialV("first")<=0 or (War.Turn or 1)~=1 or flag(F_FIRST) then return end
setFlag(F_FIRST,true)
WarDrawStrBoxDelay("\131\076\130\084\129\071 \137\113\133\102 \136\108\132\076\129\104\129\076\129\077",M_White)
local rested={}
for _,v in pairs(War.Person) do if not v.enemy and v.active then rested[#rested+1]=v v.active=false end end
War.ControlStatus='AI'
War.koSkip=false
if (CC.koSkipAI or 0)==1 then War.koSkip=true War.koSkipKeep=true end
War.koAI=true
War.koAIStart=lib.GetTime()
local ok,err=pcall(AI)
War.koAI=false
War.koSkip=false
War.koSkipKeep=false
for _,v in ipairs(rested) do v.active=true end
for _,v in pairs(War.Person) do if v.enemy and v.live then v.active=true end end
if not ok then error(err,0) end
end)
koOn("war_end",function() if JY.Base and flag(F_FIRST) then setFlag(F_FIRST,false) end end)
-- the record screen's statistics (record.lua, addon/patch_시련_기록.pl)
function koTrialRecRows() return {{"\129\071\130\087 \130\086\131\120",koTrialNowStr()},{"\136\122\131\100 \130\086\131\120",koTrialBestStr()}} end
-- set the stages directly (tests, and anything that wants to restore a choice): st[i] = stage of TR[i] (by index or key)
function koTrialSet(t)
local st={}
for i,it in ipairs(TR) do st[i]=math.max(0,math.min(#it.c,t[i] or t[it.k] or 0)) end
encode(st,F_CHOSEN,t.sd or 0)
koTrialSync()
end
koTrialCutTeam=cutTeam
-- ---------------------------------------------------------------- what is on this cycle: a plain list (기록 화면 「시련」 탭, 전투 기능 메뉴 「시련·축복」)
-- (사용자: 고르기 화면과 같을 필요 없이 적용된 것만)
local function onList()
local st=decode()
local A,B={},{}
for i,t in ipairs(TR) do local g=st[i] or 0 if g>0 then table.insert(t.b and B or A,{t=t,g=g}) end end
return A,B
end
-- draws at (x,y), w wide; txt(x,y,s,color) / rtext(right,y,s,color)
local function drawList(x,y,w,txt,rtext)
local n=cycle()
if not koTrialOn() then txt(x,y,"\130\086\131\120\129\123 \129\099\130\068\131\098 21\130\125\132\121\130\094\131\104 \131\100\139\123\129\076\129\077 (\130\067\131\103 "..n.."\130\125\132\121)",M_Gray) return end
local tot,up,down,bat=koTrialCost()
txt(x,y,n.."\130\125\132\121 \130\086\131\120 \161\164 \129\099\130\068",C_Name)
rtext(x+w,y,"\129\087\132\084 "..tot.."  \130\066\132\101 "..bat.."  \129\090\130\119 "..koTrialReq(),M_Silver)
local sd=koTrialStartDiff()
txt(x,y+58+math.max(#onList(),#select(2,onList()),1)*20+8,"\130\086\129\074 \130\113\129\071\129\068: "..((sd>0) and ("\129\068\130\066 "..sd.." (\130\125\132\121 \130\101 \129\071 \129\110\134\071\132\083 \136\102 \131\095\130\079)") or "\131\115\132\119"),M_Silver)
local A,B=onList()
local cw=math.floor((w-24)/2)
for col,L in ipairs({A,B}) do
local cx=x+(col-1)*(cw+24)
local isB=(col==2)
lib.FillColor(cx,y+26,cx+cw,y+48,RGB(0,0,48))
txt(cx,y+30,isB and ("\129\099\130\068  \163\173"..down) or ("\130\086\131\120  \163\171"..up),isB and M_DeepSkyBlue or M_Red)
lib.DrawRect(cx,y+50,cx+cw,y+50,M_Gray)
if #L==0 then txt(cx,y+58,"\130\097\130\077",M_Gray) end
for r,e in ipairs(L) do
local yy=y+58+(r-1)*20
if r%2==0 then lib.FillColor(cx,yy-1,cx+cw,yy+18,RGB(0,0,48)) end
txt(cx,yy,e.t.n,M_White)
txt(cx+cw-math.min(150,cw-120),yy,e.t.s[e.g],C_Name)
rtext(cx+cw,yy,(isB and "\163\173" or "\163\171")..costOf(e.t,e.g),isB and M_DeepSkyBlue or M_Red)
end
end
end
koOn("title",function()
if rawget(_G,"koRecTabs")==nil or koTrialTabAdded then return end
koTrialTabAdded=true
koRecTabs[#koRecTabs+1]={label="\130\086\131\120",per=1,n=function() return 1 end,
draw=function(page,c) drawList(c.ox+24,c.oy+60,720,c.txt,c.rtext) end}
end)
koTrialTabAdded=false
function koTrialShow()
local W=math.min(640,(War.BoxWidth or 48)*(War.MW or 12)-8)-- 10-14: no wider than the map (frame mode: 576)
local A,B=onList()
local H=58+math.max(#A,#B,1)*20+48+28
local X=math.floor(rawget(_G,"koMapCenterX") and koMapCenterX(W) or (CC.ScreenW-W)/2)
local Y=math.floor(rawget(_G,"koMapCenterY") and koMapCenterY(H) or (CC.ScreenH-H)/2)
local function txt(x,y,s,c) DrawString(x,y,s,c or M_White,16) end
local function rtext(x,y,s,c) DrawString(x-#s*8,y,s,c or M_White,16) end
local btns={{x=X+W/2-50,y=Y+H-34,w=100,h=24,s="\129\138\131\071"}}
koTrialClassicWait(function()
DrawWarMap()
koRecordClassicFrame(X,Y,W,H)
drawList(X+16,Y+14,W-32,txt,rtext)
end,btns)
end
koAddon.warMenu[#koAddon.warMenu+1]={label="\130\086\131\120\161\164\129\099\130\068",enabled=function() return koTrialOn() end,run=function() koTrialShow() end}
