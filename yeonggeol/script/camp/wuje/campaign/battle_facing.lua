-- Deployment presentation only; never turn units during normal player actions.
local function active()
 return koWujeCampaignActive() and War and War.Person
end
local function face(unit)
 if not unit or not unit.live then return end
 local target,best
 for _,other in ipairs(War.Person) do
  if other.live and not other.hide and (not not other.enemy)~=(not not unit.enemy) then
   local dx,dy=other.x-unit.x,other.y-unit.y
   local distance=dx*dx+dy*dy
   if distance>0 and (not best or distance<best) then target,best=other,distance end
  end
 end
 if target then
  local dx,dy=target.x-unit.x,target.y-unit.y
  -- Native direction: 1 down, 2 up, 3 left, 4 right.
  if math.abs(dx)>math.abs(dy) then unit.d=dx>0 and 4 or 3
  else unit.d=dy>0 and 1 or 2 end
 end
end
rawset(_G,"SnrFaceArmies",function()
 if not active() then return end
 for _,unit in ipairs(War.Person) do if not unit.hide then face(unit) end end
end)
local start=SnrStartWar
function SnrStartWar(...)
 local r=start(...)
 if active() then
  -- Positions now include native selection, flags and blocked-tile relocation.
  SnrFaceArmies()
  War.koSnrFacingIntro=true
 end
 return r
end
local reveal=WarShowArmy
function WarShowArmy(pid,...)
 local unit=active() and War.Person[GetWarID(pid+1)]
 if unit and unit.hide then face(unit) end
 local r=reveal(pid,...)
 -- Native reveal may relocate a blocked spawn before it becomes visible.
 if unit and not unit.hide then face(unit) end
 return r
end
local event=DoEvent
function DoEvent(id,...)
 local intro=active() and JY.Status==GAME_WMAP and War.koSnrFacingIntro
 if intro then War.koSnrFacingIntro=nil end
 local r=event(id,...)
 if intro and active() and JY.Status==GAME_WMAP then SnrFaceArmies() end
 return r
end
