-- ko 5.2.8 (10-26): enemygear — 회차가 오를수록 적장이 진짜 보물을 든다
-- (사용자: "\130\125\132\121\129\094 \129\091\130\104\129\113\133\108 \131\076\131\097\129\071 \129\103\138\097 \131\115\131\065\129\083 \131\082\129\081"; 카페 제보 "2\130\125\132\121\130\094\131\104 \131\076 \130\075\129\090 \131\097\129\113 \131\097\130\080\129\094 \130\114\130\102\137\099")
-- 원작 데이터는 위·오 장수 95명에게 옛 보물 사본(도구 181~195, 이름만 같고 효과 0)을 두 개씩 쥐여 둠
-- (위 184+195 = 청강검·오자병법, 오 181+191 = 손자병법·영웅지검 등). 5.1.9 의 jymain koOldCopy3 이 사본을 모두 지움.
-- 이제 그 칸에 진짜를 회차만큼 준다: 1회차 없음, 2회차 첫째 칸 하나, 3회차부터 둘 다.
-- · 내 편(君主 1) 아닌 기록에만. 불러올 때(LoadRecord 뒤, koOldCopy3 뒤)와 전투 시작(war_begin, storyhire 주차로
--   처음 소지품=사본으로 돌아온 이야기 무장 포함) 때 맞춤.
-- · 적은 쓰러져도 도구를 떨구지 않음(도구는 kdef 사건으로만 얻음). 합류(ModifyForce fid 1) 때 받은 진짜를 하나씩 버림
--   (합류 전 일이라 따로 얻은 것과 섞이지 않음; 가방이 당겨져 칸이 바뀌었으면 값으로 찾음).
-- · 소유 판정(koHasItem 등)은 君主 1 만 세므로 적이 든 진짜는 「가진 보물」 에 안 잡힘.
local REAL={[181]=4,[182]=5,[183]=10,[184]=11,[185]=12,[186]=13,[187]=14,[188]=15,[189]=16,[190]=58,[191]=59,[192]=60,[193]=61,[194]=62,[195]=63}
local ITEM="\181\192\190\223"   -- 道具 (..1~8)
local LORD="\190\253\214\247"   -- 君主
local KEYS={} for k=1,8 do KEYS[k]=ITEM..k end
local GIFT=nil-- pid -> {{key,real},...} in slot order, from the newgame record
local function gifts()
if GIFT then return GIFT end
GIFT={}
local data=Byte.create(32)
Byte.loadfile(data,CC.R_IDXFilename[0],0,32)
local i1,i2=Byte.get32(data,0),Byte.get32(data,4)
local PS=CC.PersonSize
local N=math.floor((i2-i1)/PS)
local B=Byte.create(PS*N)
Byte.loadfile(B,CC.R_GRPFilename[0],i1,PS*N)
for i=1,N-1 do
local t
-- 6.0 (10-28 밤): 무장 전용 보물로 새 칸에 옮긴 원작 보물(의천검 · 청강검 · 청룡언월도 · 방천화극 · 장팔사모 · 자웅쌍검)은 새 번호로 (gear_data koGearMove)
local MV=rawget(_G,"koGearMove") or {}
for _,k in ipairs(KEYS) do
local r=REAL[GetDataFromStruct(B,i*PS,CC.Person_S,k)]
if r then r=MV[r] or r end
if r then t=t or {} t[#t+1]={k,r} end
end
if t then GIFT[i]=t end
end
return GIFT
end
local function allow()
local NG=CC.koNG
local n=(NG and NG.rcycle) and NG.rcycle() or 1
if n<=1 then return 0 end
if n==2 then return 1 end
return 99
end
local function find(p,item)
for _,k in ipairs(KEYS) do if p[k]==item then return k end end
end
-- one record not ours: the first `a` gifts are in the bag (their own slot, or the first empty one once the bag got packed),
-- a later gift still standing in its own slot goes
local function fit(pid,a)
local p=JY.Person[pid]
if p==nil or p[LORD]==1 then return false end
local changed=false
for n,g in ipairs(gifts()[pid]) do
local v=p[g[1]]
if REAL[v] then p[g[1]]=0 v=0 changed=true end-- a copy put back (storyhire parking)
if n<=a then
if not find(p,g[2]) then
local k=(v==0) and g[1] or find(p,0)
if k then p[k]=g[2] changed=true end
end
elseif v==g[2] then p[g[1]]=0 changed=true
end
end
return changed
end
local function fitAll()
if JY.Person==nil or JY.PersonNum==nil then return end
local a=allow()
for pid,_ in pairs(gifts()) do
if pid<JY.PersonNum then fit(pid,a) end
end
end
local lr=rawget(_G,"LoadRecord")
if type(lr)=="function" then
function LoadRecord(...)
local r=table.pack(lr(...))
local ok,err=pcall(fitAll)
if not ok then koAddonLog("enemygear load: "..tostring(err)) end
return table.unpack(r,1,r.n)
end
end
koOn("war_begin",function()
if (War.Turn or 1)~=1 or War.Person==nil then return end
local a=allow()
local G=gifts()
for _,v in pairs(War.Person) do
if v.enemy and v.id and G[v.id] and fit(v.id,a) then pcall(ReSetAttrib,v.id,false) end
end
end)
local mf=rawget(_G,"ModifyForce")
if type(mf)=="function" then
function ModifyForce(pid,fid,...)
if pid and (fid or 1)==1 and JY.Person[pid] and JY.Person[pid][LORD]~=1 then
local g=gifts()[pid]
if g then
local p=JY.Person[pid]
for _,s in ipairs(g) do
local k=(p[s[1]]==s[2]) and s[1] or find(p,s[2])
if k then p[k]=0 end
end
end
end
return mf(pid,fid,...)
end
end
