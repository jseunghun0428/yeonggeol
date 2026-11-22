-- ko 6.0 (10-27, 카페 건의 「새 판에서 와룡의 시련·자유 모드·무술 대회 전적이 안 이어진다」): addon "recsave"
-- (UTF-8 원본: 개발용/addon/recsave_src.lua -> 도구/free_hz.pl -> script/addon/recsave.lua, addons.lua 맨 끝)
--
-- 기기 공통 기록(koAddon.saveKeys: 무술 대회·자유 전투·탑·시련·마왕 등급·후일담 모음·출진 편성·신무장 등록부 ...)은
-- 게임 폴더 ko_settings.lua 에만 있어서, 새 판으로 data/save 만 옮기면 빠졌다. 이제 koSave 때마다 같은 값을
-- data/save/ko_records.lua 에도 적고, 타이틀에 처음 올 때 그 사본과 ko_settings.lua 를 맞춘다 (화면 설정은 건드리지 않음).
--  · 순번 CC.koRecSeq: koSave 마다 1 씩 올라 두 파일에 같이 적힌다 (0 = 6.0 전 판이 쓴 ko_settings.lua).
--  · 사본이 있고 설정 순번 > 0 → 사본 값을 가져온다. 같은 폴더면 둘이 같고, 다르면 설정 쪽이 새 판 zip 에 딸려 온
--    것이거나 다른 폴더 것이라 사본(세이브와 함께 옮겨 온 쪽)이 맞다. 순번 크기는 비교하지 않음(배포 zip 의 설정에도
--    개발 때 순번이 남아 있을 수 있음).
--  · 설정 순번이 0 (옛 판에서 일부러 복사한 ko_settings.lua) → 칸마다: 설정이 기본값이고 사본이 기본값이 아닐 때만 사본 값.
--  · 사본이 없으면 지금 값으로 새로 쓴다.
local FILE=CONFIG.Save.."ko_records.lua"
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koRecSeq",default=0}
local function recLines()
local s=""
local seen={}
for _,r in ipairs(koAddon.saveKeys) do
if not seen[r.key] then
seen[r.key]=true
local v=CC[r.key]
if v==nil then v=r.default end
if type(v)=="string" then v=string.format("%q",v) else v=tostring(v) end
s=s.."CC."..r.key.."="..v.."\010"
end
end
return s
end
local function writeCopy()
local h=io.open(FILE,"w")
if not h then return end
h:write(recLines())
h:close()
end
-- 군웅록 11-14 (카페 제보 「1.0.26 에서 적 레벨 원작인데 아군 레벨을 따라옴」): 배포 zip 맨 위의 ko_settings.lua(앞 6줄)를
-- 옛 폴더에 덮어 풀면 기능설정(적 레벨 · 경험치 · 피해 변동 · 배속 ...)이 모두 기본값으로 돌아갔다. 기능설정 값을
-- data/save/ko_setbak.lua 에도 적어 두고(koSave 마다), 게임 폴더 ko_settings.lua 가 배포판 그대로(koSave 가 늘 쓰는 CC.koEntrance 줄이 없음)이면
-- 처음 타이틀에서 사본 값을 되살린다. 화면 칸(배율 · 넓게 · 틀 맞춤)은 배포판 값 그대로.
local SETBAK=CONFIG.CurrentPath.."data/save/ko_setbak.lua"
local SCREEN={koScale=true,koWide=true,koFrameFit=true}
local function setKeys()
local t={}
for _,k in ipairs(koSettingKeys()) do if not SCREEN[k] then t[#t+1]=k end end
return t
end
local function writeSetBak()
local h=io.open(SETBAK,"w")
if not h then return end
for _,k in ipairs(setKeys()) do
local v=CC[k]
if v~=nil then
if type(v)=="string" then v=string.format("%q",v) else v=tostring(v) end
h:write("CC."..k.."="..v.."\010")
end
end
h:close()
end
function koSetRestore()
local r=io.open(CONFIG.CurrentPath.."ko_settings.lua","r")
if not r then return 0 end
local t=r:read("*a") r:close()
if string.find(t,"CC.koEntrance=",1,true) then return 0 end-- the player's own file: nothing to bring back
local h=io.open(SETBAK,"r")
if not h then return 0 end
local src=h:read("*a") h:close()
local env={CC={}}
local chunk=load(src,"ko_setbak","t",env)
if not chunk or not pcall(chunk) then return 0 end
local n=0
for _,k in ipairs(setKeys()) do
local v=env.CC[k]
if v~=nil and type(v)==type(CC[k]) and v~=CC[k] then CC[k]=v n=n+1 end
end
return n
end
local synced=false
local rawSave=koSave
function koSave(...)
-- a koSave before the first title (startup) must not write the zip's values over the copy first
if not synced then synced=true pcall(koSetRestore) pcall(koRecSync) end
CC.koRecSeq=(tonumber(CC.koRecSeq) or 0)+1
local r=rawSave(...)
writeCopy()
pcall(writeSetBak)
return r
end
local function readCopy()
local h=io.open(FILE,"r")
if not h then return nil end
local src=h:read("*a") h:close()
local env={CC={}}
local chunk=load(src,"ko_records","t",env)
if not chunk or not pcall(chunk) then return nil end
return env.CC
end
-- the copy against ko_settings.lua (values already in CC); returns how many rows came from the copy
function koRecSync()
local c=readCopy()
if not c then koSave() return 0 end
local cs=tonumber(CC.koRecSeq) or 0
local rs=tonumber(c.koRecSeq) or 0
-- 6.0 (11-01): the records every story shares (jymain koSharedKeys: 신무장 등록부 · 장수편집 그림) live in the shared ko_settings.lua only;
-- a story folder's copy (or 영걸전's) is not newer than another story's koSave, so it never wins here (newgen keeps its own registry backup)
local shared={} for _,k in ipairs(rawget(_G,"koSharedKeys") or {}) do shared[k]=true end
local n=0
for _,r in ipairs(koAddon.saveKeys) do
local v=c[r.key]
if r.key~="koRecSeq" and not shared[r.key] and v~=nil and type(v)==type(r.default) and v~=CC[r.key] then
if cs>0 or (CC[r.key]==r.default and v~=r.default) then CC[r.key]=v n=n+1 end
end
end
if rs>cs then CC.koRecSeq=rs end
if n>0 or rs~=cs then koSave() end
return n
end
koAddon.hooks.title=koAddon.hooks.title or {}
table.insert(koAddon.hooks.title,1,function()
if not synced then synced=true local ok,n=pcall(koSetRestore) pcall(koRecSync) if ok and (n or 0)>0 then koSave() end end
return nil
end)
