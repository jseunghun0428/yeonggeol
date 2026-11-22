-- 11-15: engrave — 천공개물로 새긴 장비는 그 한 개만 (카페 제보 「백은갑 하나에 속공을 새기면 강기를 새겼던 다른 백은갑도 모두 속공」)
-- (UTF-8 원본: 개발용/addon/engrave_src.lua -> 도구/free_hz.pl -> script/addon/engrave.lua)
-- 엔진은 가방에 도구 번호만 두고 특기는 도구 종류(JY.Item)에 붙어 있어, 새기면 같은 이름 장비 모두(상점 · 적 것 포함)가 바뀌었다.
-- 이제 새길 때 그 칸의 도구를 도구 표 1000~1999 칸의 복사본으로 바꾸고 특기는 복사본에만 붙임 (도구 표 2000 칸: 도구/patch_도구표확장.py).
--  · 복사본 표시 = 代号(0번 값)에 원본 번호 (보통 도구는 代号 = 자기 번호). 이름 · 설명은 불러올 때마다 원본에서.
--  · 복사본에 다시 새기면 그 자리에서. 문양 지우기: 원본 특기가 0 이면 원본으로 되돌리고 칸을 비움, 아니면 복사본 특기를 0 (원래 처리와 같음).
--  · 아무도 안 가진 복사본 칸(팔았음 등)은 다음에 새길 때 다시 씀. 새 회차(koNG.reset)는 newgame 도구 표를 다시 깔므로 가진 복사본은 되살림.
--  · 794~999 는 앞으로 늘 새 도구 자리로 비워 둠.
local IS=CC.ItemSize
local FIRST=1000
local CODE=string.char(180,250,186,197)    -- 代号
local SK=string.char(204,216,188,188)      -- 特技
local TYPE=string.char(192,224,208,205)    -- 类型
local NAME=string.char(195,251,179,198)    -- 名称
local DESC=string.char(203,181,195,247)    -- 说明
local ITEM=string.char(181,192,190,223)    -- 道具 (..1~8)
local EQUIP={string.char(206,228,198,247),string.char(183,192,190,223),string.char(184,168,214,250)}-- 武器 防具 辅助
local function num() return JY.ItemNum or 0 end
local function isCopy(c)
if c<FIRST or c>=num() then return false end
local it=JY.Item[c]
local o=it[CODE]
return it[TYPE]~=0 and o>0 and o<FIRST and o~=c
end
function koItemBaseId(id)
if type(id)=="number" and isCopy(id) then return JY.Item[id][CODE] end
return id
end
function koItemIsCopy(id) return type(id)=="number" and isCopy(id) end
local function heldSet()
local h={}
for i=1,(JY.PersonNum or 0)-1 do
local p=JY.Person[i]
for s=1,8 do local v=p[ITEM..s] if v and v>=FIRST then h[v]=true end end
for _,f in ipairs(EQUIP) do local v=p[f] if v and v>=FIRST then h[v]=true end end
end
if rawget(_G,"koStoreList") then
local ok,t=pcall(koStoreList)
if ok and type(t)=="table" then for _,x in ipairs(t) do if x.iid and x.iid>=FIRST then h[x.iid]=true end end end
end
return h
end
local function clear(c)
for o=0,IS-2,2 do Byte.set16(JY.Data_Item,c*IS+o,0) end
end
local function copyRec(from,to)
for o=0,IS-2,2 do Byte.set16(JY.Data_Item,to*IS+o,Byte.get16(JY.Data_Item,from*IS+o)) end
end
local function freeSlot()
local h=nil
for c=FIRST,num()-1 do
local it=JY.Item[c]
if it[TYPE]==0 then return c end
if isCopy(c) then
h=h or heldSet()
if not h[c] then clear(c) return c end
end
end
return nil
end
local function say(s)
if rawget(_G,"talk") then pcall(talk,369,s) end
end
-- 새기기: 성공하면 true (그때만 금을 냄)
function koEngraveSet(r,slot,sk)
local p=JY.Person[r]
local id=p[ITEM..slot]
if not id or id<=0 then return false end
if isCopy(id) then
JY.Item[id][SK]=sk
pcall(ReSetAttrib,r,false)
return true
end
local c=freeSlot()
if not c then
say("\134\068\140\073 \131\097\130\080\129\094 \129\072\129\073 \135\065\129\110 \132\108 \134\068\134\114 \129\113 \130\097\129\075\129\076\129\077.*\133\090\134\111\129\083 \130\067\131\079\134\069\131\118 \134\068\140\073 \131\097\130\080\130\104 \130\070 \135\068 \129\077\130\086 \129\091\135\073\130\086\129\091.")
return false
end
copyRec(id,c)
JY.Item[c][CODE]=id
JY.Item[c][SK]=sk
CC.koItemSk0=CC.koItemSk0 or {} CC.koItemSk0[c]=CC.koItemSk0[id] or 0
p[ITEM..slot]=c
for _,f in ipairs(EQUIP) do if p[f]==id then p[f]=c end end
pcall(ReSetAttrib,r,false)
return true
end
-- 문양 지우기
function koEngraveErase(r,slot)
local p=JY.Person[r]
local id=p[ITEM..slot]
if not id or id<=0 then return end
if isCopy(id) then
local o=JY.Item[id][CODE]
if (JY.Item[o][SK] or 0)==0 then
p[ITEM..slot]=o
for _,f in ipairs(EQUIP) do if p[f]==id then p[f]=o end end
clear(id)
else
JY.Item[id][SK]=0
end
else
JY.Item[id][SK]=0-- an old save's engraving on the shared item (before 11-15): as before
end
pcall(ReSetAttrib,r,false)
end
-- 불러온 뒤: 복사본 이름 · 설명 · 원래 특기는 원본에서 (jymain 이 newgame 의 빈 칸 이름으로 덮음)
local function fixNames()
for c=FIRST,num()-1 do
if isCopy(c) then
local o=JY.Item[c][CODE]
JY.Item[c][NAME]=JY.Item[o][NAME]
JY.Item[c][DESC]=JY.Item[o][DESC]
CC.koItemSk0=CC.koItemSk0 or {} CC.koItemSk0[c]=CC.koItemSk0[o] or 0
end
end
end
function koEngraveFixT() return fixNames() end-- for test scripts
local lr=rawget(_G,"LoadRecord")
if type(lr)=="function" then
function LoadRecord(...)
local r=table.pack(lr(...))
local ok,err=pcall(fixNames)
if not ok then koAddonLog("engrave load: "..tostring(err)) end
return table.unpack(r,1,r.n)
end
end
-- 새 회차: newgame 을 다시 까는 동안 복사본 칸이 지워지므로 앞뒤로 옮겨 둠 (넘어온 가방 · 창고에 있는 것만)
local NG=CC.koNG
if NG and type(NG.reset)=="function" then
local R=NG.reset
NG.reset=function(...)
local keep={}
pcall(function()
for c=FIRST,num()-1 do
if isCopy(c) then
local t={}
for o=0,IS-2,2 do t[#t+1]=Byte.get16(JY.Data_Item,c*IS+o) end
keep[c]=t
end
end
end)
local res=table.pack(R(...))
pcall(function()
local h=heldSet()
for c,t in pairs(keep) do
if h[c] and c<num() then
for n,v in ipairs(t) do Byte.set16(JY.Data_Item,c*IS+(n-1)*2,v) end
end
end
fixNames()
end)
return table.unpack(res,1,res.n)
end
end
