-- ko 3.2: 병종 교환 (무장 메뉴). 금을 내고 부하 한 명의 병종을 바꾼다.
--   원작에서 병종을 바꾸는 도구 16종(검술지침서·둔갑천서 …)은 도구점에 없고 전장의 숨은 도구나
--   이벤트로만 나와, 한 회차에 한 번 지나치면 그만이었다(도구 자체의 값이 255 = 1바이트 상한이라
--   상점에 올려도 2,550금밖에 못 매긴다). 그래서 도구 대신 메뉴에서 금을 받고 바꿔 준다.
--   계열 안에서 한 단계 올리는 승급 도구 8종(보병갑·마갑 …)은 예전처럼 도구점에서 사면 된다.
--   목인(388)·유방(407)·항우(408)은 전용 병종이라 koFixedBZ 로 목록에서 빠지고,
--   그들의 병종(나무인형 29·서초패왕 30·한고제 31)도 고를 수 있는 병종에 넣지 않는다.
if not koNeeds("base") then return end

local F_LORD=string.char(190,253,214,247)  -- 君主
local F_NAME=string.char(208,213,195,251)  -- 姓名
local F_BZ=string.char(177,248,214,214)    -- 兵种
local F_HP=string.char(177,248,193,166)    -- 兵力
local F_HPM=string.char(215,238,180,243,177,248,193,166) -- 最大兵力
local F_MP=string.char(178,223,194,212)    -- 策略
local F_MPM=string.char(215,238,180,243,178,223,194,212) -- 最大策略
local F_BNAME=string.char(195,251,179,198) -- 名称

-- 바꿀 수 있는 병종과 값. 승급 계열(2·3·5·6·8·9·11·12)은 도구점 몫이라 넣지 않는다
--   고를 수 있는 병종 16종 = 전직 도구 16종이 주는 병종 그대로. 도구 이름과 병종 이름이 다른 것이 있다
--   (창술지침서 -> 호위병, 궁기지침서 -> 돌기병, 청낭서 -> 보급대).
local koBzPrice={
[1]=5000,   -- 단병    (검술지침서)
[4]=5000,   -- 궁병    (궁술지침서)
[7]=5000,   -- 경기병  (마술지침서)
[15]=5000,  -- 무술가  (무도지침서)
[25]=5000,  -- 호위병  (창술지침서)
[10]=8000,  -- 산적    (산적 맹세서)
[13]=8000,  -- 군악대  (군악기)
[14]=8000,  -- 맹수사  (조수지침서)
[17]=8000,  -- 이민족  (이민족 증표)
[20]=8000,  -- 전차    (보병거)
[21]=8000,  -- 발석거  (발석거)
[22]=8000,  -- 돌기병  (궁기지침서)
[19]=8000,  -- 보급대  (청낭서) - 회복·보급이라 책략 계열보다 한 단계 아래로
[16]=15000, -- 요술사  (둔갑천서)
[26]=15000, -- 모사    (귀곡자)
[27]=15000, -- 무녀    (무녀 입문서)
}
--   장 제한은 두지 않는다. 원작도 1장부터 전직 도구를 주고(계교·하구·팽성·회남), 이야기에서 받는 금이
--   1장까지 누적 14,500 이라 값 자체가 이미 게이트 노릇을 한다(서장은 700금이라 아무것도 못 산다).

local function koBzList()
local t={}
for bz,price in pairs(koBzPrice) do
local b=JY.Bingzhong[bz]
if b~=nil and b[F_BNAME]~="" then t[#t+1]={bz=bz,price=price,name=b[F_BNAME]} end
end
table.sort(t,function(a,b) if a.price~=b.price then return a.price<b.price end return a.bz<b.bz end)
return t
end

local function koBzPickPerson()
local ids={}
for i=1,JY.PersonNum-1 do
if JY.Person[i][F_LORD]==1 and not koFixedBZ(i) then ids[#ids+1]=i end
end
if #ids==0 then
WarDrawStrBoxConfirm("\131\085\134\078 \129\113 \132\079\130\098 \129\073\131\097\129\071 \130\097\129\075\129\076\129\077.",M_White,true)
return 0
end
talk(369,"\130\126\129\084\129\083 \131\085\134\078 \129\073\131\097\129\083 \133\109\133\110\129\097\131\111\129\090.")
-- 상자 모양 5 = 가장 긴 줄에 맞춰 폭이 늘어나는 상자. 모양 6(고정 100px)은 "이름 + 병종"이 안 들어간다
-- ko 3.3: 모양 5 는 스크롤이 없어 13번째 무장부터 고를 수 없었다 → 12명이 넘으면 10명씩 쪽을 나눈다
local per=(#ids<=12) and 12 or 10
local pages=math.ceil(#ids/per)
local page=1
while true do
local pm,map={},{}
if page>1 then
pm[#pm+1]={"\139\073 \139\074 ("..(page-1).."/"..pages..")",nil,1}
map[#pm]=-1
end
for j=(page-1)*per+1,math.min(#ids,page*per) do
local i=ids[j]
local b=JY.Bingzhong[JY.Person[i][F_BZ]]
pm[#pm+1]={fillblank(JY.Person[i][F_NAME],9)..((b and b[F_BNAME]) or ""),nil,1}
map[#pm]=i
end
if page<pages then
pm[#pm+1]={"\129\077\130\077 \139\074 ("..(page+1).."/"..pages..")",nil,1}
map[#pm]=-2
end
local r=ShowMenu(pm,#pm,0,0,0,0,0,5,1,16,M_White,M_White)
if r<=0 then return 0 end
if map[r]==-1 then page=page-1
elseif map[r]==-2 then page=page+1
else return map[r] end
end
end

function koBzShop()
while true do
local pid=koBzPickPerson()
if pid<=0 then return end
local p=JY.Person[pid]
local now=p[F_BZ]
local list=koBzList()
local items,ids={},{}
for _,v in ipairs(list) do
if v.bz~=now then
items[#items+1]={fillblank(v.name,8)..string.format("%6d",v.price).."\131\103",nil,1}
ids[#ids+1]=v
end
end
local cur=JY.Bingzhong[now]
talk(369,p[F_NAME].."  \129\114\129\115 "..(((cur and cur[F_BNAME]) or "")).."*\131\085\134\078 \130\126\129\084\129\083 \133\109\133\110\129\097\131\111\129\090.")
local k=ShowMenu(items,#items,0,0,0,0,0,5,1,16,M_White,M_White)
if k>0 then
local sel=ids[k]
if sel.price>koGold() then
PlayWavE(2)
WarDrawStrBoxConfirm("\130\085\131\103\129\071 \130\094\132\082\129\087\129\076\129\077.",M_White,true)
elseif WarDrawStrBoxYesNo(p[F_NAME].."  ->  "..sel.name.."*\130\080\132\111 "..sel.price.."\131\103*\131\074\131\075\129\075\129\076\129\089?",M_White,true) then
UseMoney(sel.price)
ModifyBZ(pid,sel.bz)
ReSetAttrib(pid,true)
if p[F_HP]>p[F_HPM] then p[F_HP]=p[F_HPM] end
if p[F_MP]>p[F_MPM] then p[F_MP]=p[F_MPM] end
GetPic(pid)
PlayWavE(12)
talk(369,p[F_NAME].."  ->  "..sel.name)
end
end
end
end

-- ---- registration (ko 3.2 addon "bzshop": 병종 교환)
koAddon.personMenu[#koAddon.personMenu+1]={label="\130\126\129\084 \132\087\134\073",run=function() koBzShop() end}
