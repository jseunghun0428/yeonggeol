-- Keep personal animations; migrate only incompatible starting classes.
local CHANGES={[1]={1,7},[3]={1,26},[6]={13,1},[8]={20,7},[15]={1,26},[16]={7,1},[19]={4,7},[21]={1,7},[22]={4,7},[23]={4,7},[24]={11,7},[27]={11,7},[32]={11,7},[33]={4,26},[34]={4,26},[35]={1,7},[36]={7,23},[38]={1,23}}
local LORD="\190\253\214\247"
local BZ="\177\248\214\214"
-- 11-13 cafe report (Guo Jia made a sorcerer, back to swordsman after a load or a battle): the move to the sprite class is
--  done once per general and remembered in the save state file (cls), so a class the player gives him later stays
local done={}
function koWujeClassDone(t) if t~=nil then done={} if type(t)=="table" then for k,v in pairs(t) do if v then done[k]=true end end end end return done end
local function repair(pid)
 local c=CHANGES[pid] local p=JY.Person[pid]
 if not c or not p or p[LORD]~=1 or done[pid] then return end
 done[pid]=true
 local bz=p[BZ] local target=nil
 if bz==c[1] then target=c[2]
 elseif c[1]>=1 and c[1]<=3 and bz>=1 and bz<=3 then
  target=(c[2]==7 or c[2]==1) and (c[2]+bz-1) or c[2]
 elseif c[1]>=4 and c[1]<=6 and bz>=4 and bz<=6 then
  target=(c[2]==7 or c[2]==1) and (c[2]+bz-4) or c[2]
 elseif c[1]>=7 and c[1]<=9 and bz>=7 and bz<=9 then
  target=(c[2]==1 or c[2]==23) and (c[2]+bz-7) or c[2]
 elseif c[1]>=23 and c[1]<=25 and bz>=23 and bz<=25 then target=c[2]+bz-23
 end
 if target and target~=bz then
  p[BZ]=target ReSetAttrib(pid,false)
  -- Loaded battle checkpoints also cache class-dependent movement/attack data.
  if JY.Status==GAME_WMAP and War and War.Person then
   local wid=GetWarID(pid) local u=War.Person[wid]
   if u then
    local b=JY.Bingzhong[target]
    u.bz=target
    u.movewav=b["\210\244\208\167"]
    u.atkwav=b["\185\165\187\247\210\244\208\167"]
    u.movestep=b["\210\198\182\175"]
    u.movespeed=b["\210\198\182\175\203\217\182\200"]
    u.atkfw=b["\185\165\187\247\183\182\206\167"]
    u.pic=WarGetPic(wid)
   end
  end
 end
end
function koWujeRepairClasses() for pid in pairs(CHANGES) do repair(pid) end end
local force=ModifyForce
function ModifyForce(pid,side,...)
 local r=force(pid,side,...)
 if side==1 and koWujeCampaignActive() then repair(pid) GetPic(pid) end
 return r
end
