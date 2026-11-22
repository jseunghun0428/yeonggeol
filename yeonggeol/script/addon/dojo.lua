-- ko 5.2.5 (10-18): 연무장 (무장 메뉴). 금을 내고 뒤처진 무장의 레벨을 올린다.
--   카페 제보: 주력이 빠지면 이야기 중에 일찍 합류한 무장(무송 Lv9·노지심 Lv18, 적 평균 Lv30)을 써야 하는데, 경험치가
--   레벨 차와 상관없이 때리기 24·잡기 +32 에서 막혀(jymain WarAtkHurt) 300% 로도 한 마리에 1.7 레벨밖에 안 오르고
--   병력이 작아 버티지도 못한다. 술집 무장은 들어올 때 우리 편 평균에 맞춰지니 이야기 무장만 겪는 문제.
--   한도 = 우리 편에서 레벨이 가장 높은 무장 − (0~5, 사용자: 가장 높은 장수와 같게부터 −1~5 까지 고르게). 연무장 목록 맨 위
--   「한도」 줄에서 고르고 CC.koDojoGap 으로 ko_settings.lua 에 남는다(기본 3). 가장 높은 무장보다 높아질 수는 없다.
--   (처음 판은 상위 평균 pjlv − 3 고정이었음.)
--   값 = 올리는 한 레벨마다 (그때 레벨 × 10)금 (Lv9→27 = 3,150금, Lv18→27 = 1,980금; 처음 ×50 → ×30 → ×20 → 사용자 지정 ×10). 경험치 칸은 그대로 둔다.
--   레벨만 바꾸고 ReSetAttrib(최대 병력·책략치)·병력 가득. 기술·책략은 원래 레벨로 정해지므로 저절로 익힌다.
--   「모두 훈련」 줄(사용자: 한 명씩 말고 일괄로): 한도 밑 전원을 한도까지. 금이 모자라면 가장 낮은 무장부터 한 레벨씩 번갈아
--   올려 가진 금으로 되는 만큼 (낮은 무장들이 고르게 따라옴). 끝나면 결과(새 레벨별로 묶음)를 보이고 연무장을 닫는다
--   (사용자: 예 눌렀더니 장수 고르는 목록이 다시 나와 안 된 줄 앎).
-- Source: 개발용/addon/dojo_src.lua (UTF-8); script/addon/dojo.lua is made from it by 개발용/도구/free_hz.pl.
if not koNeeds("base") then return end

local F_LORD=string.char(190,253,214,247)  -- 君主
local F_NAME=string.char(208,213,195,251)  -- 姓名
local F_LV=string.char(181,200,188,182)    -- 等级
local F_HP=string.char(177,248,193,166)    -- 兵力
local F_HPM=string.char(215,238,180,243,177,248,193,166) -- 最大兵力
local F_MP=string.char(178,223,194,212)    -- 策略
local F_MPM=string.char(215,238,180,243,178,223,194,212) -- 最大策略
local F_GROW=string.char(179,201,179,164)  -- 成长
local F_SK=string.char(204,216,188,188)    -- 特技 (1..6)
local F_SNAME=string.char(195,251,179,198) -- 名称

koDojo={per=10,maxGap=5}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koDojoGap",default=3}
function koDojoGap() return limitX(math.floor(tonumber(CC.koDojoGap) or 3),0,koDojo.maxGap) end
-- my highest-level general: level, id
function koDojoTop()
local top,id=1,0
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
if p[F_LORD]==1 and (p[F_LV] or 0)>top then top,id=p[F_LV],i end
end
return top,id
end
function koDojoCap() return limitX(koDojoTop()-koDojoGap(),1,99) end
local function gapText(g) return (g==0) and "\132\071\129\081" or ("-"..g) end
-- gold to go from lv to lv+n
function koDojoCost(lv,n)
local c=0
for l=lv,lv+n-1 do c=c+l*koDojo.per end
return c
end

-- the 한도 choice: same as the top general, or 1~5 below
local function pickGap()
local top,tid=koDojoTop()
local m={}
for g=0,koDojo.maxGap do
m[#m+1]={((g==0) and "\129\094\131\097 \137\069\131\098 \129\073\131\097\129\123 \132\071\129\081" or ("\129\094\131\097 \137\069\131\098 \129\073\131\097 -"..g)).."  Lv"..limitX(top-g,1,99),nil,1}
end
talk(369,"\129\094\131\097 \137\069\131\098 \129\073\131\097: "..((tid>0) and JY.Person[tid][F_NAME] or "").." Lv"..top.."*\130\083\131\090\129\089\130\067 \136\068\131\120\129\088 \129\113 \132\079\129\081 \129\088\129\089\129\090?")
local r=ShowMenu(m,#m,0,0,0,0,0,5,1,16,M_White,M_White)
if r>0 then CC.koDojoGap=r-1 if rawget(_G,"koSave") then pcall(koSave) end end
end

-- my generals below the cap, lowest first
local function below(cap)
local ids={}
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
if p[F_LORD]==1 and (p[F_LV] or 99)<cap then ids[#ids+1]=i end
end
table.sort(ids,function(a,b) local la,lb=JY.Person[a][F_LV],JY.Person[b][F_LV] if la~=lb then return la<lb end return a<b end)
return ids
end
local function allCost(ids,cap)
local c=0
for _,i in ipairs(ids) do local lv=JY.Person[i][F_LV] c=c+koDojoCost(lv,cap-lv) end
return c
end

-- the list: row 1 = 한도, row 2 = 모두 훈련, then the generals below it (lowest first).
-- Returns a person id, -3 (한도 changed), -4 (모두 훈련) or 0 (closed)
local function pickPerson(cap)
local ids=below(cap)
local per=(#ids<=10) and 10 or 8
local pages=math.max(1,math.ceil(#ids/per))
local page=1
while true do
local pm,map={},{}
pm[#pm+1]={"\129\111\129\068 Lv"..cap.." (\129\094\131\097 \137\069\131\098 \129\073\131\097 "..gapText(koDojoGap())..")  \131\085\131\086\131\071",nil,1}
map[#pm]=-3
if #ids==0 then
pm[#pm+1]={"  \136\068\131\120\129\088 \129\073\131\097\129\071 \130\097\129\075\129\076\129\077",nil,0}
map[#pm]=0
else
pm[#pm+1]={"\130\090\130\091 \136\068\131\120  "..#ids.."\130\088  "..allCost(ids,cap).."\131\103",nil,1}
map[#pm]=-4
end
if page>1 then
pm[#pm+1]={"\139\073 \139\074 ("..(page-1).."/"..pages..")",nil,1}
map[#pm]=-1
end
for j=(page-1)*per+1,math.min(#ids,page*per) do
local i=ids[j]
local lv=JY.Person[i][F_LV]
pm[#pm+1]={fillblank(JY.Person[i][F_NAME],9)..string.format("Lv%2d",lv)..string.format("%7d",koDojoCost(lv,cap-lv)).."\131\103",nil,1}
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
elseif map[r]==-3 then pickGap() return -3
elseif map[r]==-4 then return -4
elseif map[r]>0 then return map[r] end
end
end

-- the skills a level change from a to b teaches (the engine checks 等级 >= CC.SkillExp[成长][i] for 特技i)
local function newSkills(p,a,b)
local t={}
local tab=CC.Enhancement and CC.SkillExp and CC.SkillExp[p[F_GROW]]
if not tab then return t end
for i=1,6 do
local need=tab[i]
local sid=p[F_SK..i]
if need and need>a and need<=b and sid and sid>0 and JY.Skill[sid] then t[#t+1]=JY.Skill[sid][F_SNAME] end
end
return t
end

-- 모두 훈련: everyone below the cap up to it, or (not enough gold) the lowest one level at a time while the gold lasts
local function batchTrain(cap)
local ids=below(cap)
if #ids==0 then return end
local total=allCost(ids,cap)
local gold=koGold()
local plan={}-- id -> new level
if total<=gold then
if not WarDrawStrBoxYesNo(#ids.."\130\088\129\083 \130\090\130\091 Lv"..cap.." \129\089\130\067*\130\080\132\111 "..total.."\131\103*\131\074\131\075\129\075\129\076\129\089?",M_White,true) then return end
for _,i in ipairs(ids) do plan[i]=cap end
else
local lv={}
for _,i in ipairs(ids) do lv[i]=JY.Person[i][F_LV] end
local spent=0
while true do
local low=nil
for _,i in ipairs(ids) do if lv[i]<cap and (not low or lv[i]<lv[low]) then low=i end end
if not low or spent+lv[low]*koDojo.per>gold then break end
spent=spent+lv[low]*koDojo.per
lv[low]=lv[low]+1
end
local n=0
for _,i in ipairs(ids) do if lv[i]>JY.Person[i][F_LV] then plan[i]=lv[i] n=n+1 end end
if n==0 then
PlayWavE(2)
WarDrawStrBoxConfirm("\130\085\131\103\129\071 \130\094\132\082\129\087\129\076\129\077.*(\130\090\130\091 \136\068\131\120 "..total.."\131\103, \129\094\129\103 \131\103 "..gold..")",M_White,true)
return
end
local minLv=cap
for _,i in ipairs(ids) do minLv=math.min(minLv,lv[i]) end
if not WarDrawStrBoxYesNo("\130\090\130\091 \136\068\131\120\129\097\131\096\129\065 "..total.."\131\103\129\071 \143\120\129\076\129\077 (\129\094\129\103 \131\103 "..gold..").*\129\094\129\103 \131\103\131\109\132\083 \137\105\131\098 \129\073\131\097\130\094\131\104 \131\100\130\106\129\081 \131\105\132\117\129\089\129\090?*("..n.."\130\088, \129\094\131\097 \137\105\131\098 \129\073\131\097 Lv"..minLv..", \130\080\132\111 "..spent.."\131\103)",M_White,true) then return end
end
local cost,n,grp,lvs=0,0,{},{}
for _,i in ipairs(ids) do
local to=plan[i]
if to then
local p=JY.Person[i]
local from=p[F_LV]
cost=cost+koDojoCost(from,to-from)
p[F_LV]=to
ReSetAttrib(i,true)
p[F_HP]=p[F_HPM]
p[F_MP]=p[F_MPM]
n=n+1
if not grp[to] then grp[to]={} lvs[#lvs+1]=to end
grp[to][#grp[to]+1]=p[F_NAME]
end
end
UseMoney(cost)
PlayWavE(12)
-- one line per new level (the talk box shows 3 lines a page): "Lv19: \129\101\132\065\161\164\129\111\129\126\161\164\131\064\129\073\161\164\135\106\131\076 \131\107 2\130\088"
table.sort(lvs,function(a,b) return a>b end)
local lines={}
for _,l in ipairs(lvs) do
local g=grp[l]
local s="Lv"..l..": "..table.concat(g,"\161\164",1,math.min(#g,4))
if #g>4 then s=s.." \131\107 "..(#g-4).."\130\088" end
lines[#lines+1]=s
end
talk(369,n.."\130\088 \136\068\131\120 \139\091 ("..cost.."\131\103, \133\103\131\098 \131\103 "..koGold()..")*"..table.concat(lines,"*"))
return true
end

function koDojoRun()
talk(369,"\133\066\129\073\131\097\129\104\129\076\129\077. \131\103\129\083 \131\095\129\065 \129\070\129\111 \129\111\129\068\129\089\130\067 \136\068\131\120\130\086\137\097 \133\119\132\116\129\076\129\077.*(\129\111 \130\082\130\123\129\102 \131\091 \130\082\130\123 \161\193 "..koDojo.per.."\131\103, \129\111\129\068\130\098 \131\099\133\108 \144\089 \130\110 \132\123\129\102\131\087 \131\085\132\114\129\076\129\077)*\136\068\131\120\129\088 \129\073\131\097\129\083 \133\109\133\110\129\097\131\111\129\090.")
while true do
local cap=koDojoCap()
local pid=pickPerson(cap)
if pid==-3 then pid=nil
elseif pid==-4 then if batchTrain(cap) then return end pid=nil
elseif pid<=0 then return end
if pid then
local p=JY.Person[pid]
local lv=p[F_LV]
local opts,ns={},{}
for _,n in ipairs({1,5,10}) do
if lv+n<cap then ns[#ns+1]=n end
end
ns[#ns+1]=cap-lv
for _,n in ipairs(ns) do
local to=lv+n
opts[#opts+1]={((to==cap) and "\139\091\129\089\130\067 " or string.format("%2d\130\082\130\123  ",n))..string.format("Lv%2d \161\250 Lv%2d",lv,to)..string.format("%7d",koDojoCost(lv,n)).."\131\103",nil,1}
end
talk(369,p[F_NAME].."  Lv"..lv.."*\129\094\129\103 \131\103 "..koGold().."*\140\118\133\088\131\118 \136\068\131\120\129\088\129\089\129\090?")
local k=ShowMenu(opts,#opts,0,0,0,0,0,5,1,16,M_White,M_White)
if k>0 then
local n=ns[k]
local cost=koDojoCost(lv,n)
if cost>koGold() then
PlayWavE(2)
WarDrawStrBoxConfirm("\130\085\131\103\129\071 \130\094\132\082\129\087\129\076\129\077.*("..cost.."\131\103 \132\115\129\090, \129\094\129\103 \131\103 "..koGold()..")",M_White,true)
elseif WarDrawStrBoxYesNo(p[F_NAME].."  Lv"..lv.." \161\250 Lv"..(lv+n).."*\130\080\132\111 "..cost.."\131\103*\131\074\131\075\129\075\129\076\129\089?",M_White,true) then
local oldHp=p[F_HPM]
UseMoney(cost)
p[F_LV]=lv+n
ReSetAttrib(pid,true)
p[F_HP]=p[F_HPM]
p[F_MP]=p[F_MPM]
PlayWavE(12)
local s=p[F_NAME].."  Lv"..lv.." \161\250 Lv"..p[F_LV].."*\130\126\131\125 "..oldHp.." \161\250 "..p[F_HPM]
local sk=newSkills(p,lv,p[F_LV])
if #sk>0 then s=s.."*\133\083\137\111 \131\071\131\072: "..table.concat(sk,", ") end
talk(369,s)
end
end
end
end
end

-- ---- registration (ko 5.2.5 addon "dojo": 연무장)
koAddon.personMenu[#koAddon.personMenu+1]={label="\133\066\129\073\131\097",run=function() koDojoRun() end}
