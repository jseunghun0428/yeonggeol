-- ko 5.0: 진형 (addon "formation"; 삼국지5의 陣形). 종횡 모드, 기능설정 "\129\103\136\069" 켬. 설계: 개발용\문서\진형 12종 설계안.md (사용자 권장안 승인)
--  · 원작 12진형, 지형별: 평지형 추행·기형·어린·언월·방원·학익·안행 / 산악형 장사·형액·봉시·구행 / 수상형 수진.
--    원작 수치 → % = (값-8)x2.5, 활공·활방은 원거리 병종이 치거나 원거리 병종에게 맞을 때만. 기동 24 → 이동 +1, 형액 -1.
--  · 지형 궁합: 서 있는 칸이 진형의 지형이 아니면 플러스 보정 절반·특수 꺼짐. 수진은 수상에서만 (물 밖에선 보정 없음, 전투 중엔 물 위에서만 고를 수 있음).
--    추행은 평지형 (나무위키 3.3.1 확인, 사용자 지적). 진형 상성(계열)은 원작에 없어 뺐음.
--  · 특수: 어린·봉시 돌격(근접 공격 +10) · 언월 회심 10%(피해 1.5배) · 학익 일제(대상 옆 아군 1명당 +5, 최대 +15, 형액에는 없음) ·
--    기형·구행 부상병(잃은 병력의 20%를 다음 아군 턴 시작에 회복) · 수진 받는 수계 책략 피해 절반.
--  · 무장마다 진형 4개(고정), 10-13 부터 역할마다 하나: 공격(어린·봉시·언월) · 방어(방원·형액) · 기동/원거리(추행·장사·안행) · 보조(학익·기형·구행·수진).
--    지정표·세력(오 수진·원소군 학익·서촉 장사)이 그 역할 칸을 먼저 차지하고, 빈 칸은 병종·능력치로.
--  · 공/방 % 는 ReSetBuff 끝에 atk_buff/def_buff 로 (미니 상태창·미리보기·AI 피해 예측이 따라감), 활·돌격·일제·회심은 WarAtkHurt 감싸기에서
--    그 한 번만. 이동은 ReSetAttrib 뒤 movestep. 아군 기본 진형 = 事件 600~699·905~976·850~(무장당 4비트), 적·우군·기본 진형 없는 아군은 「자동」: 제 편 차례가 시작될 때마다 서 있는 칸의 지형에 맞춰 4개 중 하나 (10-14).
-- Build (game folder): perl "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/\129\068\130\119/free_hz.pl" < "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/addon/formation_src.lua" > script/addon/formation.lua
local EVK="\202\194\188\254"-- 事件
local P_NAME,P_LORD,P_LV,P_BZ="\208\213\195\251","\190\253\214\247","\181\200\188\182","\177\248\214\214"-- 姓名 君主 等级 兵种
local P_WU,P_ZHI,P_TONG="\206\228\193\166\050","\214\199\193\166\050","\205\179\194\202\050"-- 武力2 智力2 统率2
local P_BWU,P_BZHI,P_BTONG="\206\228\193\166","\214\199\193\166","\205\179\194\202"-- 武力 智力 统率 (without gear: the four do not move with equipment, QA)
local P_BL,P_MAXBL="\177\248\193\166","\215\238\180\243\177\248\193\166"-- 兵力 最大兵力
local B_RANGED,B_HORSE="\212\182\179\204","\198\239\194\237"-- 远程 骑马
local T_PLAIN,T_MOUNT,T_WATER=1,2,3
local TERN={"\131\119\130\067","\132\091\133\118","\129\113\129\067"}
-- {이름, 공%, 방%, 이동, 특수 설명(짧게), 지형, 활공%, 활방%, 지형 불이익 없음}
local F={
{"\130\083\131\106",20,-10,0,"\137\066\130\112",T_PLAIN,0,0},
{"\135\115\133\083",0,5,0,"\133\073\129\100",T_PLAIN,15,0},
{"\135\087\130\086",20,-5,0,"\137\066\130\112",T_MOUNT,0,0},
{"\133\099\130\093",5,-5,1,"\131\071\130\108",T_PLAIN,0,0},
{"\131\097\130\114",5,-5,1,"\131\071\130\108",T_MOUNT,0,0},
{"\130\111\130\093",0,0,0,"\130\114\130\112",T_PLAIN,20,10},
{"\136\069\129\128",-10,10,-1,"\133\073\129\100 \129\073\130\086",T_MOUNT,0,0},
{"\132\078\131\081",-5,20,0,"\136\075\133\087",T_PLAIN,0,20},
{"\136\065\135\099",10,5,0,"\130\125\134\100 10%",T_PLAIN,0,0},
{"\131\071\136\069",0,0,0,"\130\094\129\067\130\126",T_PLAIN,0,0},
{"\130\119\130\093",0,0,0,"\130\094\129\067\130\126",T_MOUNT,15,0},
{"\129\113\129\103",10,5,0,"\129\113\129\067 \130\066\132\111",T_WATER,-5,5},-- (원작 공12 방10 활공6 활방10, 수상에서만 쓸 수 있음)
}
local F_EORIN,F_HAKIK,F_BONGSI,F_CHUHAENG,F_JANGSA,F_ANHAENG,F_HYEONGAEK,F_BANGWON,F_EONWOL,F_GIHYEONG,F_GUHAENG,F_SUJIN=1,2,3,4,5,6,7,8,9,10,11,12
-- the long descriptions (the picker's 특수 column and the preview)
local LONG={[1]="\137\066\130\112: \134\090\137\110 \130\074\130\112 \137\088\129\066 +10%",[2]="\133\073\129\100: \130\095\129\067 \142\070 \129\110\130\084 1\130\088\135\105 +5% (\136\122\130\095 +15%)",[3]="\137\066\130\112: \134\090\137\110 \130\074\130\112 \137\088\129\066 +10%",[4]="\129\071\130\108 +1 (\131\119\130\067\129\102\131\087)",
[5]="\129\071\130\108 +1",[6]="\136\100 \130\074\130\112 +20%, \136\100 \132\078\130\083 +10%",[7]="\135\115\133\083\131\080 \133\073\129\100 \131\115\129\072\131\126\130\104 \133\072\130\067 \130\107\130\077",[8]="\136\100 \132\078\130\083 +20%, \136\075\133\087(\134\069\135\070\129\102\131\087 \133\072\130\098 \133\065\130\112 \133\089\133\065)",[9]="\130\125\134\100 \129\105\137\101 10% (\137\088\129\066 1.5\134\099)",
[10]="\130\094\129\067\130\126: \140\079\131\098 \130\126\131\125 20% \129\077\130\077 \129\112 \130\125\130\068",[11]="\130\094\129\067\130\126, \136\100 \130\074\130\112 +15%",[12]="\129\113\129\067(\129\097\130\115\161\164\133\097\129\093)\129\102\131\087\132\086 \132\080 \129\113 \132\079\130\077, \133\072\130\098 \129\113\132\084 \137\088\129\066 \133\089\133\065"}
-- 영걸전 지형(War.DX 0~19) → 진형 지형: 삼림·산지·절벽 = 산악, 하천·탁류 = 수상, 나머지 = 평지
local TERR={[1]=T_MOUNT,[2]=T_MOUNT,[9]=T_MOUNT,[3]=T_WATER,[19]=T_WATER}
local function cellTer(x,y) local d=GetWarMap(x,y,1) return TERR[d] or T_PLAIN end
-- ko 5.0 (10-13 건의 「거점 수비」): 거점 칸 = 마을·성문·성채·병영·군량고·보물고·가옥 (성지는 성 안 바닥 전체라 뺌)
local STRONG={[8]=true,[10]=true,[13]=true,[14]=true,[15]=true,[16]=true,[17]=true}
local function onStrong(v) return v and v.x and v.x>0 and STRONG[GetWarMap(v.x,v.y,1)]==true end
local TDEF={[1]=20,[2]=30,[7]=5,[8]=5,[13]=30,[14]=10}-- the cell defence % (jymain ReSetBuff / WarAtkHurt T)
local function on() return CC.Enhancement and (CC.koFormation or 1)==1 end
local function ev(n) return JY.Base[EVK..n] or 0 end
local function setev(n,v) JY.Base[EVK..n]=v end
-- 기본 진형 of a general (0 = none set): 4 bits, three a slot
local function slotOf(pid)
if pid<300 then return 600+math.floor(pid/3),pid%3 end
if pid<516 then return 905+math.floor((pid-300)/3),(pid-300)%3 end
if pid<=668 then return 850+math.floor((pid-516)/3),(pid-516)%3 end-- (QA: 516+ ran into 977..1005, and 1001+ are story flags; 850~ is free)
return nil-- 6.0 (10-30): 669+ (시련 증원 · 창고 · 예비 칸, 우리 편이 아님) 은 저장하지 않음 = 늘 자동. 850+ 를 그대로 늘리면 901~904(kdef 이야기 플래그) · 905~(300~515 칸 진형)를 덮음
end
local function getForm(pid)
local s,k=slotOf(pid)
if not s then return 0 end
return math.floor(ev(s)/16^k)%16
end
local function setForm(pid,f)
local s,k=slotOf(pid)
if not s then return end
local v=ev(s)
local old=math.floor(v/16^k)%16
setev(s,v+(f-old)*16^k)
end
local function bzOf(pid) return JY.Bingzhong[JY.Person[pid][P_BZ]] or {} end

-- ---- 무장마다 4개 (원작처럼 고정). 지정표 → 세력 → 병종 → 가장 높은 능력치 → 산악형 하나 → 채움
local OVER={
["\130\071\130\080"]={F_GIHYEONG,F_HAKIK,F_EORIN,F_HYEONGAEK},["\129\101\131\079"]={F_EORIN,F_BONGSI,F_EONWOL,F_SUJIN},["\131\097\130\080"]={F_EONWOL,F_BONGSI,F_EORIN,F_CHUHAENG},
["\129\118\135\083"]={F_CHUHAENG,F_EORIN,F_BONGSI,F_JANGSA},["\129\100\135\121\132\088"]={F_BANGWON,F_HAKIK,F_ANHAENG,F_GUHAENG},["\132\078\132\119"]={F_BANGWON,F_GUHAENG,F_HAKIK,F_GIHYEONG},
["\129\098\134\097"]={F_EONWOL,F_CHUHAENG,F_BONGSI,F_EORIN},["\133\090\133\099"]={F_EONWOL,F_CHUHAENG,F_EORIN,F_BONGSI},["\130\111\132\088"]={F_EORIN,F_BONGSI,F_EONWOL,F_HAKIK},
["\131\081\129\109"]={F_HAKIK,F_BANGWON,F_GIHYEONG,F_HYEONGAEK},["\133\088\135\101"]={F_BANGWON,F_EONWOL,F_HAKIK,F_BONGSI},
["\130\085\135\116"]={F_ANHAENG,F_BONGSI,F_GUHAENG,F_EONWOL},["\133\088\131\124"]={F_CHUHAENG,F_EONWOL,F_BONGSI,F_EORIN},["\130\110\133\066"]={F_BONGSI,F_EORIN,F_JANGSA,F_EONWOL},
["\130\075\130\071"]={F_SUJIN,F_HAKIK,F_BANGWON,F_EORIN},["\129\118\129\118"]={F_HAKIK,F_EORIN,F_BANGWON,F_BONGSI},["\130\114\133\088\131\080"]={F_BANGWON,F_HAKIK,F_HYEONGAEK,F_GUHAENG},
}
local WU={}
for _,n in ipairs({"\135\089\134\084","\135\089\130\117","\135\089\135\098","\130\075\130\071","\131\089\134\102","\129\098\135\126","\134\081\135\089","\135\078\135\125","\130\085\134\075","\129\070\131\115","\129\111\135\105","\130\124\130\114\133\120","\130\075\130\124","\131\097\136\067","\131\077\132\119","\131\087\131\123","\129\070\135\087","\133\065\131\097",
"\130\095\132\087","\129\109\132\087","\135\089\129\067\134\089","\129\100\135\121\134\090","\131\097\129\109","\131\100\135\114","\131\079\130\087","\131\115\136\066","\130\075\133\066","\130\075\134\073","\130\066\129\084","\135\089\134\073","\135\089\130\071","\135\089\129\101","\135\110\131\101","\129\069\129\084","\134\081\131\076","\129\097\129\100","\135\089\129\109","\129\091\135\090"}) do WU[n]=true end
local YUAN={}
for _,n in ipairs({"\131\081\129\109","\130\111\132\088","\133\090\133\099","\131\097\129\087","\131\100\134\118","\130\066\134\083","\133\102\129\113","\134\100\134\099","\135\087\131\071","\135\109\130\071","\132\065\131\079\131\064","\131\081\134\105","\131\081\129\067","\131\081\138\115","\135\106\129\068","\131\078\131\119","\131\097\131\080\134\069"}) do YUAN[n]=true end
local SHU_W={}
for _,n in ipairs({"\130\071\131\097","\131\097\129\082","\135\110\130\111","\136\070\129\070","\130\085\135\098","\129\071\135\110","\129\091\131\080","\136\073\134\097","\133\125\129\114","\130\071\136\072","\134\111\130\125","\131\100\129\079","\129\091\130\100","\136\074\130\108","\130\071\132\065","\131\097\135\112","\134\095\136\071","\130\080\129\101","\129\091\133\065"}) do SHU_W[n]=true end
local setCache={}
-- 10-13 (사용자 "\130\090\136\101 \129\103\136\069\129\083 \132\080 \129\113 \132\079\129\081, \139\110\130\077\130\094\131\104 \129\077 \130\065\131\096 \132\079\130\067\130\098 \130\107\131\100 \129\075\131\068\129\066\131\087"): 진형 습득. Every general can learn all twelve:
--  · he knows two at first — his 공격 one and the one of his bent (무력형 기동/원거리 · 통솔형 보조 · 지력형 방어),
--  · learns the next one of his own order at Lv 10 · 20 · 30 … (one each ten levels),
--  · and any one from its 병법서 (items 200~211 = 199+f, 무장 메뉴 「병서 읽기」; 事件500~599 keep pid*16+f each).
-- Enemies: the level ones (a record that read a book keeps it too). The order: the four role picks (공격 · 방어 · 기동/원거리 · 보조,
-- from the 지정표 / 세력 / class / stats — the 10-13 role version), the bent one second, the other roles, then the eight left by fit.
local ROLE={[F_EORIN]=1,[F_BONGSI]=1,[F_EONWOL]=1,[F_BANGWON]=2,[F_HYEONGAEK]=2,[F_CHUHAENG]=3,[F_JANGSA]=3,[F_ANHAENG]=3,
[F_HAKIK]=4,[F_GIHYEONG]=4,[F_GUHAENG]=4,[F_SUJIN]=4}
-- class lines that fight in the hills: 산적 · 악적 · 의적 · 맹수사 · 무술가 · 이민족 · 무녀 · 유협 · 선인 · 흙인형
local HILL={[10]=true,[11]=true,[12]=true,[14]=true,[15]=true,[17]=true,[27]=true,[28]=true,[35]=true,[36]=true}
local BK={first=199,ev=500,n=100,ver=0}-- 병법서 item = BK.first+f; 事件 BK.ev .. BK.ev+BK.n-1
function BK.list(pid) local r={} for i=0,BK.n-1 do local v=ev(BK.ev+i) if v>0 and math.floor(v/16)==pid then r[v%16]=true end end return r end
function BK.add(pid,f) for i=0,BK.n-1 do if ev(BK.ev+i)==0 then setev(BK.ev+i,pid*16+f) BK.ver=BK.ver+1 return true end end return false end
-- (10-13: a battle save keeps each unit's atk_buff/def_buff; after loading, the enemies re-pick (learned set changed) — refresh every unit's
--  buffs once on the first battle frame instead of waiting for the first move)
local koBuffStale=false
koOn("record_load",function() BK.ver=BK.ver+1 koBuffStale=true end)
koOn("draw_overlay",function()
if not koBuffStale or JY.Status~=GAME_WMAP or not (War and War.Person) then return end
koBuffStale=false
if on() then ReSetAllBuff() end
end)
local function orderOf(pid)
local p=JY.Person[pid]
local b=bzOf(pid)
local slot={}
local function want(f) if f and not slot[ROLE[f]] then slot[ROLE[f]]=f end end
local nm=p[P_NAME]
for _,f in ipairs(OVER[nm] or {}) do want(f) end
if WU[nm] then want(F_SUJIN) end
if YUAN[nm] then want(F_HAKIK) end
if SHU_W[nm] then want(F_JANGSA) end
local wu,tong,zhi=p[P_BWU] or 0,p[P_BTONG] or 0,p[P_BZHI] or 0
local horse,ranged=b[B_HORSE]==1,b[B_RANGED]==1
local hill=SHU_W[nm] or HILL[p[P_BZ]]
local top=(wu>=tong and wu>=zhi) and 1 or ((tong>=zhi) and 2 or 3)
want((wu>=85 and F_EONWOL) or (hill and F_BONGSI) or F_EORIN)
want((not ranged and (hill or (top==2 and tong>=70))) and F_HYEONGAEK or F_BANGWON)
want(((ranged or top==3) and F_ANHAENG) or (hill and F_JANGSA) or F_CHUHAENG)
want(((ranged or hill) and F_GUHAENG) or ((top==2 or horse) and F_HAKIK) or F_GIHYEONG)
local bent=(top==1 and 3) or (top==2 and 4) or 2
local o,has={},{}
local function add(f) if f and not has[f] then has[f]=true o[#o+1]=f end end
add(slot[1]) add(slot[bent])
for r=2,4 do add(slot[r]) end
if WU[nm] then add(F_SUJIN) end
if ranged then add(F_GUHAENG) add(F_ANHAENG) end
if hill then add(F_BONGSI) add(F_JANGSA) add(F_HYEONGAEK) add(F_GUHAENG) end
if horse then add(F_CHUHAENG) add(F_HAKIK) end
if top==1 then add(F_EONWOL) add(F_EORIN) add(F_BONGSI) elseif top==2 then add(F_HAKIK) add(F_HYEONGAEK) add(F_BANGWON) else add(F_BANGWON) add(F_GIHYEONG) add(F_ANHAENG) end
for _,f in ipairs({F_EORIN,F_BANGWON,F_CHUHAENG,F_GIHYEONG,F_HAKIK,F_BONGSI,F_HYEONGAEK,F_JANGSA,F_EONWOL,F_ANHAENG,F_GUHAENG,F_SUJIN}) do add(f) end
return o
end
-- the level he learns order position i at (1·2 = from the start)
local function lvAt(i) return (i<=2) and 0 or (i-2)*10 end
local function formSet(pid)
local p=JY.Person[pid]
local lv=p[P_LV] or 1
local key=tostring(p[P_NAME])..":"..tostring(p[P_BZ])..":"..tostring(p[P_BWU])..":"..tostring(p[P_BTONG])..":"..tostring(p[P_BZHI])..":"..lv..":"..BK.ver
local c=setCache[pid]
if c and c.key==key then return c.set,c.has,c.order end
local o=orderOf(pid)
local bl=BK.list(pid)
local set,has={},{}
for i,f in ipairs(o) do if lvAt(i)<=lv then set[#set+1]=f has[f]=true end end
for _,f in ipairs(o) do if bl[f] and not has[f] then set[#set+1]=f has[f]=true end end
setCache[pid]={key=key,set=set,has=has,order=o}
return set,has,o
end
-- the picker's 특수 cell for one he has not learned: the level it comes at, or 병법서
local function lockText(pid,f)
local _,_,o=formSet(pid)
for i,g in ipairs(o) do if g==f then local L=lvAt(i) return (L<=99) and ("Lv "..L.." \129\075\131\068") or "\130\126\136\070\131\087" end end
return "\130\126\136\070\131\087"
end
local function learned(pid,f) local _,has=formSet(pid) return has[f]==true end
-- 10-14 (사용자 "\133\120\130\108\129\071\129\076\129\089 \129\112\133\088\129\077 \131\087 \132\079\130\098 \130\067\136\069\129\102 \138\071\139\116", 적군도): 자동 진형 = 기본 진형 없는 아군 · 적 · 우군. The one of its four that
-- suits the cell it stands on, picked again at the start of its own side's phase (ours: player_phase, after 부상병; enemy and allied: as AI
-- begins) and kept through the phase — moving onto other ground mid-phase does not switch it (that is what a hand pick costs an action for).
-- (Before: once a battle from the ground most of the units stood on — counted while ours were still being placed, the enemy not at all.)
local function pickFor(v,hold)
-- A (거점 수비): 거점 칸에 선 적·우군은 방원을 익혔으면 방원 (공격 가중 점수로는 어린을 골라 성채 수비가 오히려 약해졌음)
if hold and onStrong(v) and learned(v.id,F_BANGWON) then return F_BANGWON end
-- C (책사, 10-13): 요술사·모사는 방원을 익혔으면 방원 (jymain koStratBZ)
local SB=rawget(_G,"koStratBZ") if SB and SB[JY.Person[v.id][P_BZ]] and learned(v.id,F_BANGWON) then return F_BANGWON end
local t=(v.x and v.x>0) and cellTer(v.x,v.y) or T_PLAIN
local best,bs=nil,-999
for k,f in ipairs(formSet(v.id)) do
local x=F[f]
local fit=(x[9] or x[6]==t)
local rg=bzOf(v.id)[B_RANGED]==1
local s=(fit and 100 or 0)+2*(rg and x[7] or x[2])+x[3]+x[8]/2+(5-k)*3-- (attack counts double; a ranged unit counts its bow)
if s>bs then best,bs=f,s end
end
return best
end
local function picked(pid) local f=getForm(pid) return f>=1 and f<=#F and learned(pid,f) end
local function isAuto(v) return v.enemy or v.friend or not picked(v.id) end
local function autoPick(v)
v.koForm=pickFor(v,v.enemy or v.friend) v.koFormId=v.id v.koFormAt=(v.x and v.x>0) or nil
end
local function unitForm(v)
if not on() then return nil end
if type(v)=="number" then v=War.Person[v] end
if not v or not v.id or v.id<=0 then return nil end
if not isAuto(v) then return getForm(v.id) end
-- (a first pick before the unit stands on the map is picked again once it does; and when the one it holds is not his —
--  10-13: a battle is set up with the enemy's raw record (냉포 Lv5 기병) and gets his level/class after)
if not v.koForm or v.koFormId~=v.id or (not v.koFormAt and v.x and v.x>0) or not learned(v.id,v.koForm) then autoPick(v) end
return v.koForm
end
-- 지형 궁합: the unit's cell suits its formation (or the formation does not care)
local function fits(v,f)
f=f or unitForm(v)
if not f then return true end
return F[f][9] or F[f][6]==cellTer(v.x,v.y)
end
local function eff(val,fit,f) if fit or val<=0 then return val end if f==12 then return 0 end return math.floor(val/2) end-- (off its ground: plus half; 수진 off the water: none)
function koFormName(v) local f=unitForm(v) return f and F[f][1] or nil end
-- the mini status row (about 15 bytes after the name): 「어린 평지」, off its ground 「봉시 지형불일치」
function koFormLine(v)
if type(v)=="number" then v=War.Person[v] end
local f=unitForm(v)
if not f then return nil end
if not fits(v,f) then return F[f][1].." \130\067\136\069\133\100\133\073\132\081" end
return F[f][1].." "..TERN[F[f][6]]
end
function koFormOf(v) return unitForm(v) end-- for test scripts and other addons
function koFormSetDefault(pid,f) setForm(pid,f) end-- for test scripts
function koFormPicked(pid) return picked(pid) and getForm(pid) or 0 end-- for test scripts (0 = 자동)
function koFormSet4(pid) return formSet(pid) end
function koFormFits(wid) local v=War.Person[wid] return v and fits(v) end
function koFormCounter(wid) return 0 end-- (학익의 반격 +15% 는 원작 일제로 바꿈; jymain 패치는 그대로 두고 0)
function koFormMatch() return 0 end-- (진형 상성은 원작에 없어 뺐음)
function koFormMatchPct() return 0 end
function koFormFamily(f) return f and F[f] and TERN[F[f][6]] or nil end

-- the per-hit parts (WarAtkHurt): 활공/활방 (원거리 병종이 칠 때), 돌격 (근접), 일제 (학익, 대상 옆 아군), returned as hitter atk add, target def add
local function ranged(v) return bzOf(v.id)[B_RANGED]==1 end
local P_WEAPON,I_SKILL="\206\228\198\247","\204\216\188\188"-- 武器 特技 (of an item)
local function itemSkill(id) local w=JY.Person[id][P_WEAPON] return w and w>0 and JY.Item[w] and JY.Item[w][I_SKILL] or 0 end
local function hitMod(pid,eid,ctr)
local a,d=War.Person[pid],War.Person[eid]
if not (a and d) then return 0,0,nil end
local fa,fd=unitForm(a),unitForm(d)
local atk,def,why=0,0,{}
local ra=ranged(a)
if fa then
local fit=fits(a,fa)
if ra and F[fa][7]~=0 then local x=eff(F[fa][7],fit,fa) atk=atk+x why[#why+1]="\136\100\130\074 "..string.format("%+d",x) end
if fit and (fa==F_EORIN or fa==F_BONGSI) and not ra then atk=atk+10 why[#why+1]="\137\066\130\112 +10" end
if fit and fa==F_HAKIK and fd~=F_HYEONGAEK then
local n=0
for _,u in pairs(War.Person) do
if u~=a and u.live and (not u.hide) and (u.enemy and 1 or 0)==(a.enemy and 1 or 0) and (u.friend and 1 or 0)==(a.friend and 1 or 0) and math.abs(u.x-d.x)+math.abs(u.y-d.y)==1 then n=n+1 end
end
n=math.min(n,3)
if n>0 then atk=atk+5*n why[#why+1]="\133\073\129\100 +"..(5*n) end
end
end
-- C (거점 수비): 향도(특기 118·무기 특기 118)는 지형 방어에 더해 상대 진형의 방어 플러스(방%·활방%)도 무시
local hy=WarCheckSkill(pid,118) or itemSkill(a.id)==118
if fd and ra and F[fd][8]~=0 then local x=eff(F[fd][8],fits(d,fd),fd) if hy and x>0 then x=0 end if x~=0 then def=def+x why[#why+1]="\136\100\132\078 "..string.format("%+d",-x) end end
if hy and fd then
local x=eff(F[fd][3],fits(d,fd),fd)
if x>0 then def=def-x why[#why+1]="\134\089\129\068 \129\103\136\069\132\078\130\083 \129\073\130\086 +"..x end
end
-- B (거점 수비): 방원 「철벽」 — 거점 칸에서 제 지형(평지)이면 받는 반격 피해 절반. jymain 의 배율 (100+공격버프-방어버프[+향도면 지형], 10~200)
-- 을 절반으로 만드는 만큼 방어를 더함 (피해·격파 경험치·미리보기가 같은 값을 씀)
if ctr and fd==F_BANGWON and fits(d,fd) and onStrong(d) then
local base=100+(a.atk_buff or 0)+atk-((d.def_buff or 0)+def)+(hy and (TDEF[GetWarMap(d.x,d.y,1)] or 0) or 0)+((rawget(_G,"koSiegePct") and koSiegePct(pid,eid)) or 0)
local cb=limitX(base,10,200)
local add=math.max(0,base-math.max(10,math.floor(cb/2)))
if add>0 then def=def+add why[#why+1]="\136\075\133\087 \133\065\130\112 \133\089\133\065" end
end
return atk,def,(#why>0) and table.concat(why," ") or nil
end
function koFormHitMod(pid,eid,ctr) if not on() then return 0,0,nil end return hitMod(pid,eid,ctr) end
local oldAtkHurt=WarAtkHurt
function WarAtkHurt(pid,eid,...)
if not on() then return oldAtkHurt(pid,eid,...) end
local a,d=War.Person[pid],War.Person[eid]
local ma,md=hitMod(pid,eid,(...)==1)
local r
if ma~=0 or md~=0 then
local sa,sd=a.atk_buff or 0,d.def_buff or 0
a.atk_buff=sa+ma d.def_buff=sd+md
r=table.pack(pcall(oldAtkHurt,pid,eid,...))
a.atk_buff=sa d.def_buff=sd
if not r[1] then error(r[2],0) end
table.remove(r,1) r.n=r.n-1
else
r=table.pack(oldAtkHurt(pid,eid,...))
end
-- 언월 회심: 10% (the preview asks with rawget(_G,"koFormNoRoll") set: no roll then)
local fa=unitForm(a)
if fa==F_EONWOL and fits(a,fa) and type(r[1])=="number" and r[1]>0 and r[4]~=1 and not (WarCheckSkill(eid,104) or WarCheckSkill(eid,43) or WarCheckSkill(eid,23) or WarCheckSkill(eid,47)) and not rawget(_G,"koFormNoRoll") and math.random(100)<=10 then
local p2=JY.Person[d.id]
r[1]=math.min(math.floor(r[1]*1.5),p2[P_BL] or r[1])
r[4]=2
end
return table.unpack(r,1,r.n)
end

-- the AI's target scoring (jymain WarGetAtkValue) asks WarAtkHurt for a guess: no 언월 roll there either
local oldGAV=WarGetAtkValue
function WarGetAtkValue(...)
local o=rawget(_G,"koFormNoRoll")
rawset(_G,"koFormNoRoll",true)
local r=table.pack(pcall(oldGAV,...))
rawset(_G,"koFormNoRoll",o)
if not r[1] then error(r[2],0) end
return table.unpack(r,2,r.n)
end
-- 공/방 % after every other buff (ReSetBuff ends by clamping to -50..95: the same clamp again after ours); off its ground the plus half
local oldBuff=ReSetBuff
function ReSetBuff(wid,...)
local r=table.pack(oldBuff(wid,...))
local v=War and War.Person and War.Person[wid]
local f=v and unitForm(v)
if f then
local fit=fits(v,f)
v.atk_buff=limitX((v.atk_buff or 0)+eff(F[f][2],fit,f),-50,95)
v.def_buff=limitX((v.def_buff or 0)+eff(F[f][3],fit,f),-50,95)
end
return table.unpack(r,1,r.n)
end
-- 이동 (movestep is set from the class and gear every time ReSetAttrib runs: ours on top of it; the +1 only on its own ground)
local oldAttrib=ReSetAttrib
function ReSetAttrib(id,...)
local r=table.pack(oldAttrib(id,...))
if JY.Status==GAME_WMAP and War and War.Person then
local wid=GetWarID(id)
local v=wid>0 and War.Person[wid]
local f=v and unitForm(v)
if f and v.movestep then
local m=F[f][4]
if m>0 and not fits(v,f) then m=0 end
if m~=0 then v.movestep=math.max(1,v.movestep+m) end
end
end
return table.unpack(r,1,r.n)
end
-- 수진: 받는 수계 책략 피해 절반 (다른 편끼리, 제 지형 무관)
local MT="\192\224\208\205"-- 类型
local function foes(wid,eid) local a,b=War.Person[wid],War.Person[eid] return a and b and ((a.enemy and true or false)~=(b.enemy and true or false)) end
local oldMHurt=WarMagicHurt
function WarMagicHurt(wid,eid,mid,...)
local r=table.pack(oldMHurt(wid,eid,mid,...))
if type(r[1])=="number" and r[1]>0 and foes(wid,eid) and unitForm(eid)==F_SUJIN and fits(War.Person[eid],F_SUJIN) and mid and JY.Magic[mid] and JY.Magic[mid][MT]==2 then r[1]=math.floor(r[1]*0.5) end
return table.unpack(r,1,r.n)
end
-- 기형·구행 부상병: at each of our phases every unit in one of them (on its ground) gets back 20% of (QA: 30 was stronger than 방원) what it lost since the last time
-- (10-20 카페 제보 「구행진 부상병 회복이 발동 안 됨」 — 맥성 숲의 관평·주창: the heal did run, but silently, so it looked like nothing
--  happened. Now it shows like the terrain recovery of WarRest: the camera on the unit, the troop bar filling, and a line in the 전투 기록)
local function healFx(i,v,from,to)
if JY.Status~=GAME_WMAP or War.koSkip or not rawget(_G,"DrawStatusMini") then return end
War.MX=v.x War.MY=v.y
War.CX=limitX(War.MX-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(War.MY-math.modf(War.MD/2),1,War.Depth-War.MD+1)
WarDelay(8)
local p=JY.Person[v.id]
local tmax=math.min(16,math.max(2,math.floor((to-from)/50)))
for t=0,tmax do
JY.ReFreshTime=lib.GetTime()
p[P_BL]=math.floor(from+(to-from)*t/tmax)
DrawWarMap() DrawStatusMini(i) lib.GetKey() ReFresh()
end
JY.ReFreshTime=lib.GetTime() ReFresh(CC.OpearteSpeed*4) WarDelay(4)
end
koOn("player_phase",function()
if not on() then return end
local healed=false
for i,v in pairs(War.Person) do
if v.live and not v.hide and v.id>0 then
local p=JY.Person[v.id]
local f=unitForm(v)
local cur=p[P_BL] or 0
if (f==F_GIHYEONG or f==F_GUHAENG) and fits(v,f) and v.koMark and v.koMark>cur then
local back=math.floor((v.koMark-cur)*0.2)
local to=math.min(p[P_MAXBL] or cur,cur+back)
if to>cur then
healFx(i,v,cur,to)
p[P_BL]=to
if rawget(_G,"koBattleLogNote") then koBattleLogNote(i,"\130\094\129\067\130\126: \130\126\131\125 +"..(to-cur)) end
cur=to healed=true
end
end
v.koMark=cur
end
end
if healed then ReSetAllBuff() end-- (맹장·불굴·배수 follow the troops)
end)
-- 자동 진형: picked again at the start of each side's phase by the cell each unit stands on (see pickFor). A unit whose pick
-- changes gets its move/buffs set again and a dim line in the 전투 기록 (no box on screen: it would come every turn)
-- (10-16 제보 「추행진 첫 턴 이동 +1 안 됨, 부대 정보를 열어야 붙음」: the move part is set by ReSetAttrib from the cell the unit stood on
--  then — at setup, before it was placed — and only the auto units were set again. Now every unit whose formation moves it (추행·장사 +1,
--  형액 -1) gets ReSetAttrib at the start of its side's phase too, so the +1 follows the cell it starts the phase on.)
local function moveFormed(v) local f=unitForm(v) return f and F[f][4]~=0 end
local function rePick(ours)
if not on() or not (War and War.Person) then return end
for i,v in pairs(War.Person) do
if v.live and not v.hide and v.id and v.id>0 and ((not v.enemy and not v.friend)==ours) then
local done=false
if isAuto(v) then
local old=unitForm(v)
autoPick(v)
if v.koForm~=old then
ReSetAttrib(v.id,false) done=true
local n=v.koForm and F[v.koForm][1]
if n and rawget(_G,"koBattleLogNote") then koBattleLogNote(i,"\133\120\130\108 \129\103\136\069: "..n) end
end
end
if not done and moveFormed(v) then ReSetAttrib(v.id,false) end
end
end
end
local function moveAll() for _,v in pairs(War.Person) do if v.id and v.id>0 and v.x and v.x>0 and moveFormed(v) then ReSetAttrib(v.id,false) end end end
koOn("war_begin",function() -- (everyone set up — levels, classes, places — before the first phase: a quiet pick for all)
if not on() or not (War and War.Person) then return end
for _,v in pairs(War.Person) do if v.id and v.id>0 and isAuto(v) then local old=v.koForm autoPick(v) if v.koForm~=old then ReSetAttrib(v.id,false) end end end
moveAll()
ReSetAllBuff()
end)
-- (a battle save: the loader sets each unit's move from its class and runs ReSetAttrib before the map is up — set it again on the first frame)
local koMoveStale=false
koOn("record_load",function() koMoveStale=true end)
koOn("draw_overlay",function()
if not koMoveStale or JY.Status~=GAME_WMAP or not (War and War.Person) then return end
koMoveStale=false
if on() then moveAll() end
end)
koOn("player_phase",function() rePick(true) end)-- (after 부상병 above: a 기형/구행 unit heals before it may leave the formation)
local oldAI=AI
function AI(...) rePick(false) return oldAI(...) end


-- the picker: a table of its own — 진형 / 지형 / 공격 / 방어 / 활 / 이동 / 특수. His four on top (the one in use on a blue band ●), the other
-- eight grey 「미습득」; in battle the 지형 cell is marked ◎ when it suits the cell he stands on (the header says which ground that is).
-- The pointer row lights up and its full effect shows at the foot; click (or ↑↓ + Enter) picks, right click / Esc closes.
-- x,y = where it should open (top-left; nil: centred), kept on screen; a table that does not fit below y opens above y2. Returns f or nil.
local PW,RH,HEAD=560,22,52
local function sgn(v) return (v>0 and "+"..v) or tostring(v) end
local function vcol(v,on) if not on then return M_Gray end return (v>0 and M_Lime) or (v<0 and M_Red) or M_Gray end
-- 10-14 (사용자 "\134\119\129\076\134\103 \129\103\136\069 \132\123\129\102\129\068 \143\108\192\086"): the 진형 row of the mini status window, hovered — the formation's numbers, its 특수, and
-- whether the unit's cell suits it. Same look as the 특기 tooltip (koSkillTipBox: 원작풍 틀, a silver rule under the name), beside the pointer.
function koFormTip(wid)
local v=War.Person[wid]
local f=v and unitForm(v)
if not f then return end
local x=F[f]
local name=(x[1]=="\129\113\129\103") and x[1] or (x[1].."\129\103")
local here=cellTer(v.x,v.y)
local fit=fits(v,f)
local segs={{"\130\074\130\112 "..sgn(x[2]).."%",x[2]},{"\132\078\130\083 "..sgn(x[3]).."%",x[3]}}
if x[4]~=0 then segs[#segs+1]={"\129\071\130\108 "..sgn(x[4]),x[4]} end
if x[7]~=0 or x[8]~=0 then segs[#segs+1]={"\136\100 \130\074/\132\078 "..sgn(x[7]).."/"..sgn(x[8]),x[7]+x[8]} end
local lines={}
lines[#lines+1]={LONG[f] or x[5],M_White}
if fit then lines[#lines+1]={"\130\067\131\103 \135\066 "..TERN[here].." \161\164 \130\067\136\069 \138\071\130\077",M_Lime}
elseif f==F_SUJIN then lines[#lines+1]={"\130\067\131\103 \135\066 "..TERN[here].." \161\164 \129\113\129\067\129\071 \129\110\129\076\130\102 \131\115\129\070\161\164\129\120\129\113 \130\097\130\077",M_Red}
else lines[#lines+1]={"\130\067\131\103 \135\066 "..TERN[here].." \161\164 \130\067\136\069 \133\100\133\073\132\081: \130\081\133\101\131\126 \131\115\129\070 \133\089\133\065\161\164\129\120\129\113 \140\077\137\099",M_Red} end
if isAuto(v) and not v.enemy and not v.friend then lines[#lines+1]={"\133\120\130\108: \132\121\139\126\133\088\129\077 \135\066 \130\067\136\069\129\102 \138\071\139\116 \131\100\138\075",M_Silver} end
local head=name.." ("..TERN[x[6]].." \129\103\136\069)"
local sw=0 for i,s in ipairs(segs) do sw=sw+#s[1]*8+(i>1 and 16 or 0) end
local w=math.max(#head*8,sw)
for _,l in ipairs(lines) do w=math.max(w,#l[1]*8) end
w=w+24
local h=44+(1+#lines)*20
local tx,ty=MOUSE.x+16,MOUSE.y+16
if tx+w>CC.ScreenW then tx=MOUSE.x-16-w end
if ty+h>CC.ScreenH then ty=MOUSE.y-16-h end
tx=limitX(tx,0,math.max(0,CC.ScreenW-w)) ty=limitX(ty,0,math.max(0,CC.ScreenH-h))
lib.SetClip(0,0,0,0)
koRecordClassicFrame(tx,ty,w,h)
lib.DrawRect(tx+12,ty+31,tx+w-12,ty+31,M_Silver)
DrawString(tx+12,ty+10,head,C_Name,16)
local sx=tx+12
for _,s in ipairs(segs) do DrawString(sx,ty+38,s[1],vcol(s[2],true),16) sx=sx+#s[1]*8+16 end
for i,l in ipairs(lines) do DrawString(tx+12,ty+38+i*20,l[1],l[2],16) end
end
local function pick(pid,cur,war,x,y,y2)
local set=formSet(pid)
local rows={}
local off=war and 0 or 1-- 10-14: outside a battle the first row is 「자동」 (0 = no 기본 진형)
if off==1 then rows[1]=0 end
for _,f in ipairs(set) do rows[#rows+1]=f end
do local _,_,ord=formSet(pid) for _,f in ipairs(ord) do if not learned(pid,f) then rows[#rows+1]=f end end end-- 10-13: the rest in the order he learns them
local h=HEAD+#rows*RH+54
local px,py
if x==nil and not war then px,py=16+math.floor((640-PW)/2),16+math.floor((400-h)/2)-- 10-14: the city map frame (16,16)-(656,416)
elseif x==nil then px,py=math.floor((CC.ScreenW-PW)/2),math.floor((CC.ScreenH-h)/2)
else
local bl,bt,br,bb=4,4,CC.ScreenW-4,CC.ScreenH-4
if war and JY.Status==GAME_WMAP then bl,bt=War.OX or 0,War.OY or 0 br=bl+(War.BoxWidth or 48)*(War.MW or 12) bb=bt+(War.BoxDepth or 48)*(War.MD or 9) end-- 10-14: in battle inside the map (frame mode)
px=math.max(bl,math.min(x,br-PW))
py=y or 0
if py+h>bb and y2 then py=y2-h-4 end
py=math.max(bt,math.min(py,bb-h))
end
local here=nil-- the ground of the cell he stands on (battle only)
if war and JY.Status==GAME_WMAP then for _,u in pairs(War.Person) do if u.id==pid and u.live then here=cellTer(u.x,u.y) end end end
local C1,C2,C3,C4,C5,C6,C7=px+12,px+80,px+160,px+212,px+264,px+350,px+392-- 진형 지형 공격 방어 활 이동 특수
local sel=1
for k,f in ipairs(rows) do if f==cur then sel=k end end
local note=""
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function rowY(k) return py+HEAD+(k-1)*RH end
local function draw(hov)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
koRecordClassicFrame(px,py,PW,h)
DrawString(px+12,py+8,"\129\103\136\069 \131\100\130\106\131\071  "..JY.Person[pid][P_NAME],C_Name,16)
local hs="\129\114\129\115 "..((cur==0) and "\133\120\130\108" or F[cur][1])..(here and ("  \161\164  \130\067\131\103 \135\066 "..TERN[here]) or "")
DrawString(px+PW-12-#hs*8,py+8,hs,M_White,16)
for _,c in ipairs({{C1,"\129\103\136\069"},{C2,"\130\067\136\069"},{C3,"\130\074\130\112"},{C4,"\132\078\130\083"},{C5,"\136\100 \130\074/\132\078"},{C6,"\129\071\130\108"},{C7,"\129\120\129\113"}}) do DrawString(c[1],py+30,c[2],M_Silver,16) end
lib.DrawRect(px+8,py+HEAD-3,px+PW-8,py+HEAD-3,M_Gray)
for k,f in ipairs(rows) do
local yy=rowY(k)
if f==0 then
if f==cur then lib.FillColor(px+8,yy-1,px+PW-8,yy+RH-3,RGB(40,70,150)) end
if k==hov or k==sel then lib.DrawRect(px+8,yy-1,px+PW-8,yy-1,M_White) lib.DrawRect(px+8,yy+RH-3,px+PW-8,yy+RH-3,M_White) lib.DrawRect(px+8,yy-1,px+8,yy+RH-3,M_White) lib.DrawRect(px+PW-8,yy-1,px+PW-8,yy+RH-3,M_White) end
DrawString(C1,yy+2,"\133\120\130\108"..((f==cur) and " \161\241" or ""),(f==cur) and M_White or C_Name,16)
DrawString(C2,yy+2,"\135\066\133\088\129\077",M_White,16)
DrawString(C7,yy+2,"\132\121\139\126\133\088\129\077 \130\067\136\069 \138\071\144\084",M_White,16)
lib.DrawRect(px+8,yy+RH-2,px+PW-8,yy+RH-2,M_Silver)
else
local x=F[f]
local on=learned(pid,f)
if k==#set+1+off then lib.DrawRect(px+8,yy-2,px+PW-8,yy-2,M_Silver) end-- his four | the rest
if f==cur then lib.FillColor(px+8,yy-1,px+PW-8,yy+RH-3,RGB(40,70,150)) end
if k==hov or k==sel then lib.DrawRect(px+8,yy-1,px+PW-8,yy-1,M_White) lib.DrawRect(px+8,yy+RH-3,px+PW-8,yy+RH-3,M_White) lib.DrawRect(px+8,yy-1,px+8,yy+RH-3,M_White) lib.DrawRect(px+PW-8,yy-1,px+PW-8,yy+RH-3,M_White) end
DrawString(C1,yy+2,x[1]..((f==cur) and " \161\241" or ""),on and ((f==cur) and M_White or C_Name) or M_Gray,16)
local fitHere=here and (x[9] or x[6]==here)
DrawString(C2,yy+2,(x[9] and "\130\066\130\067\136\069" or TERN[x[6]])..(fitHere and "\161\242" or ""),on and (fitHere and M_Lime or M_White) or M_Gray,16)
DrawString(C3,yy+2,sgn(x[2]).."%",vcol(x[2],on),16)
DrawString(C4,yy+2,sgn(x[3]).."%",vcol(x[3],on),16)
DrawString(C5,yy+2,(x[7]==0 and x[8]==0) and "-" or (sgn(x[7]).."/"..sgn(x[8])),(x[7]+x[8]>0 and on) and M_Lime or M_Gray,16)
DrawString(C6,yy+2,(x[4]~=0) and sgn(x[4]) or "-",vcol(x[4],on),16)
DrawString(C7,yy+2,on and x[5] or lockText(pid,f),on and M_White or M_Gray,16)
end
end
local fk=(hov>0 and hov) or sel
DrawString(px+12,py+h-46,(note~="" and note) or ((rows[fk]==0) and "\133\120\130\108: \132\121\139\126\133\088\129\077 \131\087 \132\079\130\098 \135\066\131\080 \130\067\136\069\129\102 \138\071\130\098 \129\103\136\069\129\083 \131\100\138\075" or (F[rows[fk]][1]..": "..LONG[rows[fk]])),(note~="" and M_Red) or M_White,16)
DrawString(px+12,py+h-24,"\130\067\136\069\129\071 \130\111 \138\071\131\109\129\065 \130\081\133\101\131\126 \131\115\129\070 \133\089\133\065\161\164\129\120\129\113 \140\077\137\099 \161\164 \129\091\135\077\139\074 \134\077\133\099: \129\108\129\109",M_Gray,16)
ShowScreen()
end
koMouseReset()
local res=nil
while true do
local hov=0
for k=1,#rows do local yy=rowY(k) if MOUSE.IN(px+8,yy-1,px+PW-8,yy+RH-3) then hov=k end end
draw(hov)
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then koExit() end
local hit=nil
if (e==1 and k==VK_ESCAPE) or MOUSE.ESC() then break end
if e==1 and k==VK_UP then sel=(sel+#rows-2)%#rows+1 elseif e==1 and k==VK_DOWN then sel=sel%#rows+1
elseif e==1 and (k==VK_RETURN or k==VK_SPACE) then hit=sel end
for kk=1,#rows do local yy=rowY(kk) if MOUSE.CLICK(px+8,yy-1,px+PW-8,yy+RH-3) then hit=kk end end
if hit then
local f=rows[hit]
sel=hit
if f==0 then res=0 PlayWavE(0) break end
if learned(pid,f) and f==F_SUJIN and here and here~=T_WATER then PlayWavE(2) note="\129\113\129\103\131\098 \129\113\129\067(\129\097\130\115\161\164\133\097\129\093)\129\102\131\087\132\086 \132\080 \129\113 \132\079\129\075\129\076\129\077" hit=nil
elseif learned(pid,f) then res=f PlayWavE(0) break end
if hit then
PlayWavE(2)
note=F[f][1].."\131\098(\130\098) \129\110\132\076 \133\083\138\087\130\067 \130\107\131\098 \129\103\136\069\129\104\129\076\129\077 (\130\082\130\123 10\133\088\129\077 \129\097\131\118, \130\126\136\070\131\087\132\083\129\068 \133\083\132\064)"
end
end
end
lib.LoadSur(sid,0,0) ShowScreen()
lib.FreeSur(sid)
if war then MOUSE.koSwallowR=true end
MOUSE.status='IDLE'
return res
end
-- the unit command (jymain patch: m[11], r==11)
function koFormMenuRow(wid)
if not on() then return nil end
return {"\161\161\129\103\136\069",nil,1}
end
function koFormPick(wid,mx,my)
local v=War.Person[wid]
if not v then return false end
local cur=unitForm(v)
local f=pick(v.id,cur,true,mx or War.OX+War.BoxWidth*2,my or War.OY+20)
if not f or f==cur then return false end
setForm(v.id,f)
ReSetAttrib(v.id,false)
PlayWavE(0)
WarDrawStrBoxConfirm(JY.Person[v.id][P_NAME].." \130\094\130\095\129\094 "..F[f][1]..((F[f][1]=="\135\087\130\086" or F[f][1]=="\131\097\130\114" or F[f][1]=="\136\065\135\099") and "\132\083" or "\131\109\132\083").." \129\103\136\069\129\083 \131\085\131\086\132\107\129\077.",M_White)
return true
end
-- the city menu: 진형 편성 (each of ours: 기본 진형)
local function cityScreen()
if not on() then WarDrawStrBoxConfirm("\129\103\136\069\131\098 \129\084\134\072 \130\090\133\119\129\102\131\087 \131\071\131\077\129\069\129\070 \161\184\129\103\136\069\161\185\129\083 \137\097\129\065 \132\080 \129\113 \132\079\129\075\129\076\129\077.",M_White,true) return end
while true do
local m={}
for p=1,JY.PersonNum-1 do
if JY.Person[p][P_LORD]==1 then
m[#m+1]={fillblank(JY.Person[p][P_NAME],12)..(picked(p) and F[getForm(p)][1] or "\133\120\130\108 (\132\121\139\126\133\088\129\077 \130\067\136\069\129\102 \138\071\139\116)"),nil,1,p}
end
end
if #m==0 then return end
DrawSMap()
DrawYJZBox(32,32,"\129\103\136\069 \132\075\131\123: \129\073\131\097\129\083 \131\100\130\106\131\111\129\090",M_White,true)
-- Fixed columns: name and formation, with the automatic rule explained once below.
local page,pages=1,math.max(1,math.ceil(#m/12))
local r=0
local W,H=420,380
local X,Y=math.floor((CC.ScreenW-W)/2),16+math.floor((400-H)/2)
while true do
local buttons={}
for k=1,12 do
local index=(page-1)*12+k
if index>#m then break end
local column,row=(k-1)%3,math.floor((k-1)/3)
buttons[#buttons+1]={x=X+20+column*128,y=Y+58+row*66,w=124,h=56,plain=true,index=index,draw=function() end}
end
local function add(x,w,s,action)
buttons[#buttons+1]={x=x,y=Y+H-32,w=w,h=24,s=s,action=action}
end
add(X+12,100,"\129\071\130\066","prev")
add(X+W-112,100,"\129\077\130\077","next")
buttons[#buttons+1]={x=X+W-184,y=Y+10,w=96,h=24,s="\133\073\129\249\130\116\131\064",action="bulk"}
buttons[#buttons+1]={x=X+W-84,y=Y+10,w=72,h=24,s="\131\118\129\094\131\071",action="close"}
for _,b in ipairs(buttons) do
if not b.plain then b.draw=function(b,on)
koRecordClassicBar(b.x,b.y+1,b.w,on)
DrawString(b.x+b.w/2-#b.s*4,b.y+4,b.s,M_White,16)
end end
end
local hit=koTourWait(function(hov)
DrawSMap()
koRecordClassicFrame(X,Y,W,H)
DrawString(X+16,Y+12,"\129\103\136\069 \132\075\131\123",C_Name,16)

lib.DrawRect(X+12,Y+48,X+W-12,Y+48,M_Silver)

for _,b in ipairs(buttons) do if b.index then
local person=m[b.index][4]
local form=getForm(person)
local manual=form>=1 and form<=#F and learned(person,form)
local value=manual and F[form][1] or "\133\120\130\108"
local hot=hov>0 and buttons[hov]==b
lib.FillColor(b.x,b.y,b.x+b.w,b.y+b.h,hot and RGB(20,36,88) or RGB(0,0,48))
if hot then
lib.DrawRect(b.x,b.y,b.x+b.w,b.y,M_Yellow)
lib.DrawRect(b.x,b.y+b.h,b.x+b.w,b.y+b.h,M_Yellow)
lib.DrawRect(b.x,b.y,b.x,b.y+b.h,M_Yellow)
lib.DrawRect(b.x+b.w,b.y,b.x+b.w,b.y+b.h,M_Yellow)
end
-- Fixed positions inside every card: name left, short formation right.
lib.SetClip(b.x+8,b.y+18,b.x+72,b.y+38)
DrawString(b.x+8,b.y+20,JY.Person[person][P_NAME],M_White,16)
lib.SetClip(0,0,0,0)
DrawString(b.x+82,b.y+20,value,manual and M_Yellow or M_Silver,16)
end end
lib.DrawRect(X+12,Y+326,X+W-12,Y+326,M_Silver)
DrawString(X+16,Y+332,"\133\120\130\108: \132\121\139\126\133\088\129\077 \130\067\136\069\129\102 \138\071\139\116",M_Silver,16)
local count=page.." / "..pages
DrawString(X+W/2-#count*4,Y+H-28,count,M_White,16)
end,buttons)
if hit==0 or not buttons[hit] or buttons[hit].action=="close" then break end
local b=buttons[hit]
if b.index then r=b.index break
elseif b.action=="bulk" then
local options={{"\133\120\130\108",nil,1}}
for f=1,#F do
local count=0
for _,entry in ipairs(m) do if learned(entry[4],f) then count=count+1 end end
options[#options+1]={F[f][1].."  ("..count..")",nil,count>0 and 1 or 0}
end
DrawSMap()
DrawYJZBox(32,32,"\133\109\133\110\129\111 \129\103\136\069\129\083 \129\075\131\068\129\111 \129\073\131\097\129\102\129\081\132\086 \131\076\132\111\129\087\129\076\129\077",M_White,true)
local choice=ShowMenu(options,#options,12,0,60,0,0,3,1,16,M_White,M_White)
if choice>0 then
local formation=choice-1
local changed=0
for _,entry in ipairs(m) do
if formation==0 or learned(entry[4],formation) then setForm(entry[4],formation) changed=changed+1 end
end
PlayWavE(0)
WarDrawStrBoxConfirm(changed.."\130\088 \131\076\132\111",M_White,true)
end
elseif b.action=="prev" then page=math.max(1,page-1)
elseif b.action=="next" then page=math.min(pages,page+1) end
end
if r<=0 then return end
local p=m[r][4]
local cur=picked(p) and getForm(p) or 0
DrawSMap()
DrawYJZBox(32,32,JY.Person[p][P_NAME].."\131\080 \131\071\132\118 \129\103\136\069",M_White,true)
local f=pick(p,cur,false)
if f then setForm(p,f) PlayWavE(0) end
end
end
-- 출진 편성 화면 (jymain SelectTerm patch): each card's name box is split in two, 이름 | 진형 (사용자: 카드의 이름 칸을 둘로);
-- a click on the 진형 half picks that general's 기본 진형 (the rest of the card still selects him)
local cells={}-- [card index] = {pid, x1,y1,x2,y2, time drawn}
local function sortieForm(pid) return picked(pid) and getForm(pid) or 0 end
-- true = drawn here (the jymain line then draws no name)
function koFormCardName(i,pid,x1,y1,x3,y3,color)
if not on() or not pid or pid<=0 then return false end
local nm=JY.Person[pid][P_NAME]
local bx1,by1,bx2,by2=x1+64,y3-3,x1+154,y3+16
local mid=bx2-40
lib.FillColor(bx1,by1,bx2,by2,RGB(36,32,28))
lib.DrawRect(bx1,by1,bx2,by1,M_Gray) lib.DrawRect(bx1,by2,bx2,by2,M_Gray)
lib.DrawRect(bx1,by1,bx1,by2,M_Gray) lib.DrawRect(bx2,by1,bx2,by2,M_Gray) lib.DrawRect(mid,by1,mid,by2,M_Gray)
local sz=(#nm<=6 and 16) or (#nm<=8 and 12) or 10
DrawString((bx1+mid)/2-#nm*sz/4,y3+(16-sz)/2,nm,color,sz)
local hov=MOUSE.IN(mid,by1,bx2,by2)
local pk=picked(pid)
DrawString(mid+4,y3,pk and F[getForm(pid)][1] or "\133\120\130\108",hov and M_White or (pk and C_Name or M_Silver),16)-- (silver = 자동: picked at each phase by the cell he stands on)
cells[i]={pid,mid,by1,bx2,by2,lib.GetTime()}
return true
end
function koFormSortieDraw(pid) end-- (the box under the big name panel: replaced by the cards' 진형 half)
function koFormSortieHit(cid)
if not on() then return false end
local now=lib.GetTime()
for _,c in pairs(cells) do
if now-c[6]<500 and MOUSE.CLICK(c[2],c[3],c[4],c[5]) then
PlayWavE(0)
local f=pick(c[1],sortieForm(c[1]),false,c[2]-120,c[5]+4,c[3])
if f then setForm(c[1],f) PlayWavE(0) end
return true
end
end
return false
end
koAddon.cityMenu[#koAddon.cityMenu+1]={label="\129\103\136\069 \132\075\131\123",run=function() cityScreen() end}
koAddon.settings[#koAddon.settings+1]={key="koFormation",label="\129\103\136\069",opts={{"\133\122",1},{"\133\117",0}},default=1}
-- 무장 409 이름 "\133\088\135\101\129\100\135\121\132\088" → "\133\088\135\101" (사용자, patch_마왕이름.pl 이 새 게임 자료를 고침): a save from before keeps the old name in the
-- general's record, the owner field of his treasure and its description — set right on every load
local OLDN,NEWN="\133\088\135\101\129\100\135\121\132\088","\133\088\135\101"
local I_OWN,I_DESC="\215\168\202\244\204\216\188\188\200\203","\203\181\195\247"-- 专属特技人 说明
local function swapName(s)
local a=string.find(s,OLDN,1,true)
if not a then return nil end
return string.sub(s,1,a-1)..NEWN..string.sub(s,a+#OLDN)
end
local oldLoadRecord=LoadRecord
function LoadRecord(...)
local r=table.pack(oldLoadRecord(...))
pcall(function()
if JY.PersonNum>409 and JY.Person[409][P_NAME]==OLDN then JY.Person[409][P_NAME]=NEWN end
for it=1,JY.ItemNum-1 do
local o=JY.Item[it][I_OWN]
if type(o)=="string" and string.find(o,OLDN,1,true) then JY.Item[it][I_OWN]=NEWN end
local ds=JY.Item[it][I_DESC]
local d2=type(ds)=="string" and swapName(ds)
if d2 then JY.Item[it][I_DESC]=d2 end
end
end)
return table.unpack(r,1,r.n)
end
-- the battle preview (preview.lua patch): name and 공 % (kind 1) or 방 % (kind 2) of the formation a unit is in, or nil
function koFormBuff(wid,kind)
local f=unitForm(wid)
if not f then return nil,0 end
local v=War.Person[wid]
local fit=v and fits(v,f)
return F[f][1],eff((kind==1) and F[f][2] or F[f][3],fit,f)-- (off its ground the plus half, as ReSetBuff)
end

-- ---- 10-13 병법서 (items 200~211): 무장 메뉴 「병서 읽기」 — a book any of my generals carries, read by any of my generals who
-- has not learned that formation yet (the book is used up). Got from 전투 보너스 rewards (below) and the town 특산품 상인 (town addon).
local P_ITEM="\181\192\190\223"-- 道具 (1..8)
local function bookName(f) return F[f][1].." \130\126\136\070\131\087" end
function BK.jin(f) local n=F[f][1] return (n=="\129\113\129\103") and n or (n.."\129\103") end-- 어린진 · 수진 (not 수진진)
local function readBooks()
while true do
local held={}
for pid=1,JY.PersonNum-1 do
if JY.Person[pid][P_LORD]==1 then
for s=1,8 do local iid=JY.Person[pid][P_ITEM..s] or 0 if iid>BK.first and iid<=BK.first+#F then held[#held+1]={pid,s,iid-BK.first} end end
end
end
if #held==0 then
PlayWavE(2)
WarDrawStrBoxConfirm("\129\094\129\103 \130\126\136\070\131\087\129\094 \130\097\129\075\129\076\129\077.*\130\126\136\070\131\087\130\098 \130\066\132\101 \131\115\129\072\131\126 \131\115\129\067\129\071\131\118 \133\088\129\083 \129\120\132\091\131\066 \129\067\129\106\129\102\129\081\131\087 \133\086\129\075\129\076\129\077.",M_White,true)
return
end
table.sort(held,function(a,b) if a[3]~=b[3] then return a[3]<b[3] end return a[1]<b[1] end)
-- 10-13 (사용자 "\129\109\130\067 \136\124\131\100 \130\166\129\113"): one row per book with how many the army has; reading uses up the first copy found
local m,first,cnt={},{},{}
for _,h in ipairs(held) do local f=h[3] if not cnt[f] then cnt[f]=0 first[#first+1]=h end cnt[f]=cnt[f]+1 end
for k,h in ipairs(first) do m[k]={bookName(h[3]).."  "..cnt[h[3]].."\135\098",nil,1} end
DrawYJZBox2(-1,40,"\130\083\134\115 \130\126\136\070\131\087\130\104 \143\070\134\121\129\075\129\076\129\089?",M_White)
local r=ShowMenu(m,#m,math.min(#m,10),0,0,0,0,3,1,16,M_White,M_White)-- (box 3 fits the longest row)
if r<=0 then return end
local h=first[r]
local f=h[3]
-- who reads it: my generals, those who already know it greyed
local pm,ids={},{}
for i=1,JY.PersonNum-1 do pm[i]={"",nil,0} end
local any=false
for pid=1,JY.PersonNum-1 do
if JY.Person[pid][P_LORD]==1 then
local knows=learned(pid,f)
pm[pid]={fillblank(JY.Person[pid][P_NAME],10)..(knows and "\133\083\132\064" or ""),nil,knows and 0 or 1}
if not knows then any=true end
end
end
if not any then
PlayWavE(2)
WarDrawStrBoxConfirm("\130\090\136\101 \129\073\131\097\129\071 \129\071\134\119 "..BK.jin(f).."\129\083 \133\083\133\084\129\075\129\076\129\077.",M_White,true)
else
DrawYJZBox2(-1,40,bookName(f).."\130\104 \143\070\129\083 \129\073\131\097\129\083 \131\100\130\106\131\111\129\090.",M_White)
local who=ShowMenu(pm,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
if who>0 and WarDrawStrBoxYesNo(JY.Person[who][P_NAME].."\129\102\129\081 "..bookName(f).."\130\104 \143\070\198\163\129\076\129\089?",M_White,true) then
if not BK.add(who,f) then
PlayWavE(2)
WarDrawStrBoxConfirm("\132\108 \131\071\133\108\129\088 \133\120\129\117\129\094 \130\097\129\075\129\076\129\077 (\130\126\136\070\131\087 \131\071\133\108 "..BK.n.."\134\075).",M_White,true)
else
local hp=JY.Person[h[1]]
for s=h[2],7 do hp[P_ITEM..s]=hp[P_ITEM..(s+1)] end
hp[P_ITEM.."8"]=0
PlayWavE(11)
WarDrawStrBoxConfirm(JY.Person[who][P_NAME].." : "..BK.jin(f).."\129\083 \133\083\133\084\129\077!",M_White,true)
end
end
end
end
end
koAddon.personMenu[#koAddon.personMenu+1]={label="\130\126\131\087 \143\070\131\071",run=function() readBooks() end}
-- 전투 보너스 rewards that become a 병법서 (사용자 10-13): the bonus flag (koBonusDone) → formation. battlebonus loads after this
-- addon: its koBonusDone / koBonusItem are wrapped at the first title
local BONUS_BOOK={[273]=F_CHUHAENG,[240]=F_EORIN,[253]=F_HAKIK,[283]=F_JANGSA,[287]=F_BANGWON,[280]=F_GIHYEONG,[300]=F_HYEONGAEK,
[305]=F_BONGSI,[343]=F_GUHAENG,[348]=F_ANHAENG,[345]=F_SUJIN,[386]=F_EONWOL}
BK.wrapped=false
koOn("title",function()
if BK.wrapped then return end
local done,item=rawget(_G,"koBonusDone"),rawget(_G,"koBonusItem")
if not (done and item) then return end
BK.wrapped=true
BK.last=nil
koBonusDone=function(flag,...) local r=done(flag,...) if r then BK.last=flag end return r end
koBonusItem=function(iid,...) local f=BK.last and BONUS_BOOK[BK.last] BK.last=nil if f then iid=BK.first+f end return item(iid,...) end
end)

-- ---- 10-13 (사용자 "\131\071\133\108\129\102\131\087 \133\120\130\071 \130\066\132\101 \161\164 \134\084\133\090\133\108 \138\102\131\100 \129\103\136\069 \129\068\135\078 \161\164 \129\120\132\091\131\066 \129\068\135\078"): the record screen's tabs. The two dropped ones and the
-- two new ones are set at the first title (every addon loaded by then); 특산품 도감 is the town addon's (koTownSpecialTab)
local BONUS_NAME={[273]="\131\097\129\085 \130\112\133\068",[240]="\129\124\129\126\130\066\129\098\134\097",[253]="\131\081\129\109\130\084 6\129\112 \130\112\133\068",[283]="\132\089\129\091 \130\097\129\071 \137\066\134\086",[287]="\131\071\129\075 \130\094\130\095 \133\065\130\112",
[280]="\131\081\131\072 \130\112\133\068 (\129\110\130\084 \135\089\129\078 \130\097\129\071)",[300]="\131\087\131\087 \130\067\137\074\131\071",[305]="\133\094\130\090 \131\113\131\071",[343]="\129\071\136\077\132\082 \131\081\130\084 \130\112\133\068",[348]="\132\089\135\087\134\086\129\102\131\087 \132\078\132\119 \130\119\129\097\131\071",
[345]="\131\097\130\114 \129\113\130\074 \134\084\131\090\131\071",[386]="\129\103\134\103 \137\072\136\121"}
local KEY_CHAP="\213\194\189\218\195\251"-- 章节名 (chapter name)
local function sources(f)
local s={}
for flag,g in pairs(BONUS_BOOK) do if g==f then s[#s+1]="\130\066\132\101 \131\115\129\072\131\126 \161\184"..(BONUS_NAME[flag] or flag).."\161\185" end end
local sd=rawget(_G,"koTownSpecialData")
if sd then
local SP=sd()
local m,later={},0
local now=9-- the chapter reached (the ones after it are not named, as on the 특산품 도감)
if JY.Base and JY.Status~=GAME_START then local cs=JY.Base[KEY_CHAP] or "" for ci,ck in ipairs({"\129\1001\131\097","\129\1002\131\097","\129\1003\131\097","\129\1004\131\097"}) do if string.sub(cs,1,#ck)==ck then now=ci end end end
local KS=(rawget(_G,"koSpecialTable") and select(2,koSpecialTable())) or {"\129\1001\131\097","\129\1002\131\097","\129\1003\131\097","\129\1004\131\097"}--6.0: story phases
do local sp=rawget(_G,"koSpecialPhase") and koSpecialPhase() if sp then now=sp end end
for ci,ck in ipairs(KS) do
for town,ids in pairs(SP[ck] or {}) do for _,i in ipairs(ids) do if i==BK.first+f then if ci<=now then m[#m+1]=ck.." "..town else later=later+1 end end end end
end
table.sort(m)
if #m>0 or later>0 then s[#s+1]="\129\120\132\091\131\066 \129\067\129\106 "..table.concat(m,", ")..((later>0) and (((#m>0) and ", " or "").."\139\073\131\109\132\083 \135\121 \135\069 "..later.."\135\069") or "") end
end
return s
end
local FORM_TAB={label="\129\103\136\069 \129\068\135\078",per=12,
n=function() return #F end,
draw=function(page,c)
local y0=c.oy+58
local C={c.ox+24,c.ox+92,c.ox+178,c.ox+238,c.ox+298,c.ox+392,c.ox+440}-- (10-13 사용자: 익힌 아군 column dropped)
for i,s in ipairs({"\129\103\136\069","\130\067\136\069","\130\074\130\112","\132\078\130\083","\136\100 \130\074/\132\078","\129\071\130\108","\129\120\129\113"}) do c.txt(C[i],y0,s,M_Gray) end
lib.DrawRect(c.ox+16,y0+20,c.ox+752,y0+20,RGB(112,91,57))
for f=1,#F do
local x=F[f]
local y=y0+28+(f-1)*27
if f%2==0 then lib.Background(c.ox+20,y-3,c.ox+748,y+21,190,RGB(46,35,24)) end
c.txt(C[1],y,x[1],C_Name)
c.txt(C[2],y,TERN[x[6]],M_White)
c.txt(C[3],y,sgn(x[2]).."%",vcol(x[2],true))
c.txt(C[4],y,sgn(x[3]).."%",vcol(x[3],true))
c.txt(C[5],y,(x[7]==0 and x[8]==0) and "-" or (sgn(x[7]).."/"..sgn(x[8])),(x[7]+x[8]>0) and M_Lime or M_Gray)
c.txt(C[6],y,(x[4]~=0) and sgn(x[4]) or "-",vcol(x[4],true))
c.txt(C[7],y,x[5],M_White)
end
c.txt(c.ox+24,c.oy+418,"\132\123\129\102 \133\088\131\079\131\126\130\104 \131\105\129\117\129\065 \129\121\129\123\135\122 \130\126\136\070\131\087 \130\119\129\097\130\098 \135\069\129\071 \131\118\133\111\129\076\129\077.",M_Gray)
end,
btns=function(page,c)
local out={}
for f=1,#F do out[#out+1]={x=c.ox+18,y=c.oy+58+28+(f-1)*27-3,w=732,h=25,s="",plain=true,form=f} end
return out
end,
tip=function(b,c)
local f=b.form
if not f then return end
local lines={{BK.jin(f).."  ("..TERN[F[f][6]].." \129\103\136\069)",C_Name},{LONG[f],M_White}}
for _,s in ipairs(sources(f)) do lines[#lines+1]={"\130\126\136\070\131\087: "..s,M_White} end
local w=0 for _,l in ipairs(lines) do w=math.max(w,#l[1]*8) end
w=w+24
local h=#lines*22+24
local tx=math.min(b.x+80,c.ox+760-w)
local ty=b.y+b.h+4
if ty+h>c.oy+470 then ty=b.y-h-4 end
koRecordClassicFrame(tx,ty,w,h)
for i,l in ipairs(lines) do DrawString(tx+12,ty+12+(i-1)*22,l[1],l[2],16) end
end}
koOn("title",function()
if BK.tabs or not rawget(_G,"koRecTabs") then return end
BK.tabs=true
for i=#koRecTabs,1,-1 do local l=koRecTabs[i].label if l=="\133\120\130\071 \130\066\132\101" or l=="\134\084\133\090\133\108" then table.remove(koRecTabs,i) end end
koRecTabs[#koRecTabs+1]=FORM_TAB
local sp=rawget(_G,"koTownSpecialTab") if sp then koRecTabs[#koRecTabs+1]=sp() end
local fr=rawget(_G,"koTownFreeTab") if fr then koRecTabs[#koRecTabs+1]=fr() end-- 6.0 (11-03): stories too (their own battles)-- 10-13: 재도전 보상
end)
