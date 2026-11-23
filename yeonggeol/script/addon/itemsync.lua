-- ko 6.0 (10-27): itemsync — 옛 세이브의 보물 특기 · 전용 무장 · 전용 특기 칸을 newgame 값으로
-- (UTF-8 원본: 개발용/addon/itemsync_src.lua -> 도구/free_hz.pl -> script/addon/itemsync.lua, addons.lua 에서 awaken 앞)
--
-- 도구 표는 세이브에 통째로 들어 있어서, jymain LoadRecord 는 이름 · 설명만 newgame 에서 다시 읽고(「표시용 글」) 나머지 숫자는 세이브 것을 쓴다.
-- 그래서 나중에 바뀐 보물 데이터가 옛 세이브에서는 안 보였다 (10-27 시험: 4.0 09-30 의 청강검 「조운 전용 파진」 — 10-13 세이브의 청강검은
-- 전용 무장 칸이 비어 있어 조운이 들어도 파진이 안 켜짐). 이제 세이브를 불러온 뒤(LoadRecord 0 번 = 새 게임은 빼고):
--  · 전용 무장(专属特技人) · 전용 특기(专属特技) = 모든 도구를 newgame 값으로 (게임 중에 바꾸는 기능이 없음)
--  · 특기(特技) = 마을 「기술 새기기」 가 새길 수 없는 도구만 newgame 값으로: 종류 4 (무기 보물) · 7, 그리고 newgame 에 특기가 있는 종류 5 · 6 (병서 · 말).
--    새길 수 있는 것(일반 무기 74~139 · 방어구 종류 12 · 특기 없는 병서 · 말)은 플레이어가 새긴 특기라서 세이브 것 그대로.
--    (jymain 의 새기기 조건 = 74~139 또는 종류 12(방패 147~151 빼고) 또는 종류 5 · 6 이면서 newgame 특기 0)
-- 수치(공격 · 방어 등)는 이번에 손대지 않음.

local IS=CC.ItemSize
local K_TYPE=string.char(192,224,208,205)                         -- 类型
local K_SK=string.char(204,216,188,188)                           -- 特技
local K_OWNER=string.char(215,168,202,244,204,216,188,188,200,203) -- 专属特技人
local K_ESK=string.char(215,168,202,244,204,216,188,188)          -- 专属特技
local BASE,BASEN=nil,0
local function base()
if BASE then return BASE,BASEN end
local d=Byte.create(32)
Byte.loadfile(d,CC.R_IDXFilename[0],0,32)
local i1,i2=Byte.get32(d,12),Byte.get32(d,16)
BASEN=math.floor((i2-i1)/IS)
BASE=Byte.create(IS*BASEN)
Byte.loadfile(BASE,CC.R_GRPFilename[0],i1,IS*BASEN)
return BASE,BASEN
end
local function nv(i,k) return GetDataFromStruct(BASE,i*IS,CC.Item_S,k) end
local function sync()
local b,n=base()
local changed=0
for i=1,math.min(n,JY.ItemNum or 0)-1 do
local t=nv(i,K_TYPE)
if t~=0 then
local it=JY.Item[i]
for _,k in ipairs({K_OWNER,K_ESK}) do
local v=nv(i,k)
if it[k]~=v then it[k]=v changed=changed+1 end
end
local sk=nv(i,K_SK)
-- The treasure editor already migrated edited defaults and kept legacy engravings.
if not (CC.koTreasureRegular and CC.koTreasureRegular[i]) and
   (t==4 or t==7 or ((t==5 or t==6) and sk~=0)) and it[K_SK]~=sk then it[K_SK]=sk changed=changed+1 end
end
end
-- 군웅록 11-14 (학우선): 793 학우선(옛 세이브엔 빈 칸) · 776 학우선★(옛 팔진서★, 병서 → 책략무기)은 숫자까지 통째로 newgame 값
for _,i in ipairs({776,793}) do
if i<n and i<(JY.ItemNum or 0) then
local it=JY.Item[i]
for k,_ in pairs(CC.Item_S) do
local v=nv(i,k)
if it[k]~=v then it[k]=v changed=changed+1 end
end
end
end
return changed
end
function koItemSyncT() return sync() end-- for test scripts
local rawLR=LoadRecord
function LoadRecord(id,...)
local r=table.pack(rawLR(id,...))
if id and id>0 then pcall(sync) end
return table.unpack(r,1,r.n)
end
