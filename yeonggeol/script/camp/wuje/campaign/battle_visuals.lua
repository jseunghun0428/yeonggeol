-- Keep personal animations; migrate only incompatible starting classes.
local CHANGES={[2]={23,1},[7]={1,7},[10]={1,7},[11]={26,13},[14]={16,1},[15]={7,1},[17]={4,26},[24]={4,7},[25]={13,16},[27]={1,7},[29]={1,7},[30]={1,26},[36]={20,7},[39]={11,7},[43]={1,26},[44]={1,7},[45]={4,1},[46]={4,16},[48]={1,26},[51]={7,23},[63]={13,1},[64]={4,23},[65]={1,7},[220]={4,7},[382]={4,15}}
local LORD="\190\253\214\247"
local BZ="\177\248\214\214"
-- 11-13 cafe report (Guo Jia made a sorcerer, back to swordsman after a load or a battle): the move to the sprite class is
--  done once per general and remembered in the save state file (cls), so a class the player gives him later stays
local done={}
function koWujeClassDone(t) if t~=nil then done={} if type(t)=="table" then for k,v in pairs(t) do if v then done[k]=true end end end end return done end
local function repair(pid)
 local c=CHANGES[pid] local p=JY.Person[pid]
 if not c or not p or p[LORD]~=1 or done[pid] or koOfficerEdited(pid,4) then return end
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
 if target and target~=bz then p[BZ]=target ReSetAttrib(pid,false) end
end
function koWujeRepairClasses() for pid in pairs(CHANGES) do repair(pid) end end
local force=ModifyForce
function ModifyForce(pid,side,...)
 local r=force(pid,side,...)
 if side==1 and koWujeCampaignActive() then repair(pid) GetPic(pid) end
 return r
end
