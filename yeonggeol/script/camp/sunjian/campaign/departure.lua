-- Keep source march commands out of the native city-to-battle transition.
local hall,actors
local function active()
 return koWujeCampaignActive() and SnrW and SnrW.allies and JY.Status~=GAME_WMAP
end
local function copy(t)
 local out={}
 for i,v in ipairs(t or {}) do
  if type(v)=="table" then out[i]=copy(v) else out[i]=v end
 end
 return out
end
local prepare=SnrSetAllies
function SnrSetAllies(...)
 hall=JY.SubScene actors=copy(JY.Smap)
 return prepare(...)
end
local scene=SetSceneID
function SetSceneID(id,bgm,...)
 if id==0 and active() then
  -- Keep departure dialogue in the hall instead of the DOS march map.
  if hall and hall>0 then
   JY.Smap=copy(actors) SnrRoom=hall
   return scene(hall,bgm,...)
  end
  SnrRoom=-1
  return scene(-1,bgm,...)
 end
 return scene(id,bgm,...)
end
local add,move=SnrWorldAdd,SnrWorldMove
function SnrWorldAdd(...)
 if active() then return end
 return add(...)
end
function SnrWorldMove(...)
 if active() then return end
 return move(...)
end
local start=SnrStartWar
function SnrStartWar(...)
 local result=start(...)
 -- Native WarStart draws the prepared battlefield and fades it in.
 if koWujeCampaignActive() then Dark() end
 hall=nil actors=nil
 return result
end
-- Some source events continue with battle dialogue in the same event.
local function reveal()
 if koWujeCampaignActive() and JY.Status==GAME_WMAP and JY.Dark then
  DrawWarMap(War.CX,War.CY) Light()
 end
end
local speak=SnrTalk
if speak then
 function SnrTalk(...) reveal() return speak(...) end
end
local nativeTalk=talk
function talk(...) reveal() return nativeTalk(...) end
local objective=WarShowTarget
function WarShowTarget(...) reveal() return objective(...) end
