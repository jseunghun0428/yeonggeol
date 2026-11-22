-- ko 3.6 later → 5.0 10-10: 이 전투 처음부터 (addon "rewind"). When our first phase of a battle begins (hook player_phase,
-- patch_턴되감기_훅, turn 1 only), the battle is written to its own slot data/save/rewind.sav (slot 16; 15 is the 원정 exp.sav)
-- - the log with it (battlelog writes rewind.blog). The 기능 menu row "\129\071 \130\066\132\101 \139\110\130\077\130\094\131\104" (or the R key) loads it back: the
-- battle starts over from its first turn (after the deployment). Until 10-10 this saved every turn ("\129\071\130\087 \129\112 \139\110\130\077\130\094\131\104");
-- the user asked for a restart of the whole battle instead (a turn save that failed to write once loaded the previous battle).
-- Story battles only (a free battle keeps its own state outside the save). The slot is dropped when the battle ends.
-- Source: 개발용/addon/rewind_src.lua (UTF-8); script/addon/rewind.lua is made from it by 개발용/도구/free_hz.pl.
local SLOT=16
CC.R_GRPFilename[SLOT]=CONFIG.Save.."rewind.sav"
local function blog() return (CC.R_GRPFilename[SLOT]:gsub("%.sav$",""))..".blog" end
local function drop()
pcall(os.remove,CC.R_GRPFilename[SLOT])
pcall(os.remove,blog())
end
local function usable()
return not CC.koFree and not CC.koReplay and JY.Status==GAME_WMAP
end
-- what the file on disk really holds: battle map and turn read back from its base block (file offset 100, like SaveRecord)
local function onDisk(f)
f=f or CC.R_GRPFilename[SLOT]
if not fileexist(f) then return nil end
local d=Byte.create(160)
local ok=pcall(Byte.loadfile,d,f,100,160)
if not ok then return nil end
return Byte.get8(d,136),Byte.get8(d,144)
end
-- the start of this battle is there (same battle map, saved on turn 1)
function koRewindReady()
local r=War and War.koRewind
if not (usable() and r~=nil and r.map==War.MapID) then return false end
local m,t=onDisk()
return m==War.MapID and t==1
end
koOn("player_phase",function()
if not usable() or War.Turn~=1 or War.koRewind then return nil end
drop()   -- never keep an older file: if this write fails there is simply nothing to go back to
local ok,err=pcall(WarSave,SLOT)
if ok then War.koRewind={map=War.MapID}
else lib.Debug("koRewind save: "..tostring(err)) War.koRewind=nil end
return nil
end)
function koRewind()
if not koRewindReady() then
WarDrawStrBoxConfirm("\129\077\130\086 \130\086\129\074\129\088 \130\066\132\101 \131\071\133\108\129\071 \130\097\129\075\129\076\129\077",M_White,true)
return false
end
if not WarDrawStrBoxYesNo("\129\071 \130\066\132\101\130\104 \139\110\130\077\130\094\131\104 \129\077\130\086 \129\087\129\076\129\077.*\130\067\131\103\129\089\130\067 \129\111 \130\093\130\108\131\098 \130\090\130\091 \130\114\130\102\134\076\129\076\129\077.*\129\088\129\089\129\090?",M_White) then return false end
local map=War.MapID
LoadRecord(SLOT)
if JY.Status==GAME_WMAP then
War.koRewind={map=map}
War.ControlStatus="select"
War.ControlEnable=true
WarDrawStrBoxDelay("\130\066\132\101\130\104 \139\110\130\077\130\094\131\104 \129\077\130\086 \130\086\129\074\129\087\129\076\129\077",M_White)
end
return true
end
-- 11-08 (제보: 손견전 낙양에서 옥새를 못 줍고 이기면 안내 없이 타이틀로): 전투가 이야기 끝(게임 오버)으로 끝날 때
--  이야기 쪽에서 불러 「처음부터 다시」를 물음. 승리·패배 판정 중(GAME_WARWIN/WARLOSE)에도 됨. 다시 하면 true.
function koRewindOffer(msg)
local r=War and War.koRewind
if CC.koFree or CC.koReplay or not (r and r.map==War.MapID) then return false end
local m,t=onDisk()
if not (m==War.MapID and t==1) then return false end
if not WarDrawStrBoxYesNo(msg or "\129\071\133\069\131\071\129\094 \129\098\131\071\131\087 \139\091\139\095\129\076\129\077.*\129\071 \130\066\132\101\130\104 \139\110\130\077\130\094\131\104 \129\077\130\086 \129\088\129\089\129\090?",M_White) then return false end
local map=War.MapID
LoadRecord(SLOT)
if JY.Status~=GAME_WMAP then return false end
War.koRewind={map=map}
War.ControlStatus="select"
War.ControlEnable=true
WarDrawStrBoxDelay("\130\066\132\101\130\104 \139\110\130\077\130\094\131\104 \129\077\130\086 \130\086\129\074\129\087\129\076\129\077",M_White)
return true
end
koAddon.warMenu[#koAddon.warMenu+1]={group="system",label="\129\071 \130\066\132\101 \139\110\130\077\130\094\131\104",enabled=function() return koRewindReady() end,run=function() koRewind() end}
koOn("battle_key",function(k)
if k==114 and War.ControlStatus=="select" and War.ControlEnable and usable() then koRewind() return 0 end-- R
return nil
end)
-- 10-10: a save made during a battle keeps the start of that battle next to it (save6.sav -> save6.rws), and loading that
-- save brings it back, so 「이 전투 처음부터」 still works after quitting and loading. Same idea as the battle log (.blog).
local function rwsPath(id)
local f=CC.R_GRPFilename[id]
if not f or id==SLOT then return nil end
return (f:gsub("%.sav$",""))..".rws"
end
local rawSave=SaveRecord
SaveRecord=function(id,...)
local a,b,c=rawSave(id,...)
pcall(function()
local p=rwsPath(id)
if not p then return end
os.remove(p)
if JY.Status==GAME_WMAP and koRewindReady() then copyfile(CC.R_GRPFilename[SLOT],p) end
end)
return a,b,c
end
local pending=nil
local rawWarLoad=WarLoad
WarLoad=function(id,...)
local a,b,c=rawWarLoad(id,...)
if id~=SLOT then
pending=nil
pcall(function()
local p=rwsPath(id)
local m,t=nil,nil
if p then m,t=onDisk(p) end
if m==War.MapID and t==1 then
drop()
if copyfile(p,CC.R_GRPFilename[SLOT]) then pending=War.MapID War.koRewind={map=War.MapID} end
else
drop() War.koRewind=nil
end
end)
end
return a,b,c
end
-- a battle resumed from a save starts its loop again: keep what WarLoad just set
koOn("war_begin",function()
if pending and pending==War.MapID then War.koRewind={map=pending} end
pending=nil
return nil
end)
-- 자동 저장 turns A1 -> A2 -> A3 by renaming the files before writing A1: turn the .rws files the same way
local rawAuto=koAutoSave
koAutoSave=function(...)
if koAutoSaveOn() and not koHook("autosave_block") then
pcall(function()
local p12,p13,p14=rwsPath(12),rwsPath(13),rwsPath(14)
os.remove(p14)
if fileexist(p13) then os.rename(p13,p14) end
if fileexist(p12) then os.rename(p12,p13) end
end)
end
return rawAuto(...)
end
-- 10-10 (사용자: 전투 세이브를 불러오니 승리조건이 「1. 장비가 북동」까지만): 세이브의 战场目标 칸은 14바이트라 긴 승리조건이 잘림.
-- 전투 중 저장하면 승리조건 전체를 옆 파일(save6.sav -> save6.wtg)에 두고, 그 세이브를 불러오면 되살림. 자동 저장 A1~A3 도 같이 돌림.
local function wtgPath(id)
local f=CC.R_GRPFilename[id]
if not f then return nil end
return (f:gsub("%.sav$",""))..".wtg"
end
local rawSaveW=SaveRecord
SaveRecord=function(id,...)
local a,b,c=rawSaveW(id,...)
pcall(function()
local p=wtgPath(id)
if not p then return end
os.remove(p)
if JY.Status==GAME_WMAP and type(War)=="table" and type(War.WarTarget)=="string" then
local fo=io.open(p,"wb") if fo then fo:write(War.WarTarget) fo:close() end
end
end)
return a,b,c
end
local rawWarLoadW=WarLoad
WarLoad=function(id,...)
local a,b,c=rawWarLoadW(id,...)
pcall(function()
local p=wtgPath(id)
local fi=p and io.open(p,"rb")
if fi then local s=fi:read("*a") fi:close() if s and #s>0 then War.WarTarget=s end end
end)
return a,b,c
end
local rawAutoW=koAutoSave
koAutoSave=function(...)
if koAutoSaveOn() and not koHook("autosave_block") then
pcall(function()
local p12,p13,p14=wtgPath(12),wtgPath(13),wtgPath(14)
os.remove(p14)
if fileexist(p13) then os.rename(p13,p14) end
if fileexist(p12) then os.rename(p12,p13) end
end)
end
return rawAutoW(...)
end
koOn("war_end",function() drop() return nil end)
koOn("title",function() drop() return nil end)
