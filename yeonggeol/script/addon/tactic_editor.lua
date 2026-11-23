-- Shared numeric rules written by the desktop editor.
local T={rules={S={},M={}},deleted={S={},M={}},learning={}}
local HP,MAXHP,MP,MAXMP,MORALE,CLASS,LEVEL=
 "\177\248\193\166","\215\238\180\243\177\248\193\166",
 "\178\223\194\212","\215\238\180\243\178\223\194\212",
 "\202\191\198\248","\177\248\214\214","\181\200\188\182"
local RANGE="\208\167\185\251\183\182\206\167"
local KIND="\192\224\208\205"

function T.load(path)
 T.rules={S={},M={}}
 T.deleted={S={},M={}}
 T.learning={}
 local file=io.open(path,"r")
 if not file then return end
 for line in file:lines() do
  local tag,number,event,condition,threshold,target,effect,amount=
   line:match("^([SM]) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+) (%d+)$")
  if tag then
   number,event,condition,threshold,target,effect,amount=
    tonumber(number),tonumber(event),tonumber(condition),tonumber(threshold),tonumber(target),tonumber(effect),tonumber(amount)
   if number>0 and event<=(tag=="S" and 3 or 0) and condition<=5 and threshold<=100 and target<=1 and effect<=10 and amount<=32767 then
    local rows=T.rules[tag][number] or {}
    rows[#rows+1]={event,condition,threshold,target,effect,amount}
    T.rules[tag][number]=rows
   end
  else
   tag,number=line:match("^D ([SM]) (%d+)$")
   if tag then T.deleted[tag][tonumber(number)]=true end
   local mid,troop,level=line:match("^L (%d+) (%d+) (%d+)$")
   if mid then
    mid,troop,level=tonumber(mid),tonumber(troop),tonumber(level)
    T.learning[mid]=T.learning[mid] or {}
    T.learning[mid][troop]=level
   end
  end
 end
 file:close()
end

function T.skillValue(value,default)
 return value>=2 and value-2 or default
end

function T.setting(number,index,default)
 local row=JY.Skill[number]
 local value=row and row["\178\206\202\253"..index]
 return value and value<0 and -value-1 or default
end

function T.learns(pid,mid)
 local levels=T.learning[mid]
 local person=JY.Person[pid]
 local level=levels and levels[person[CLASS]]
 return level and level>0 and person[LEVEL]>=level
end

local function unit(wid)
 local w=War.Person[wid]
 if not w or not w.live or w.hide then return end
 local p=JY.Person[w.id]
 if p[HP]>0 then return w,p end
end

local function below(value,maximum,percent)
 return maximum>0 and value*100<=maximum*percent
end

local function passes(rule,actor,target,defender)
 local condition,threshold=rule[2],rule[3]
 return condition==0
  or condition==1 and below(actor[HP],actor[MAXHP],threshold)
  or condition==2 and defender and below(defender[HP],defender[MAXHP],threshold)
  or condition==3 and below(actor[MP],actor[MAXMP],threshold)
  or condition==4 and target and target.troubled
  or condition==5 and target and (target.poison or 0)>0
end

local function change(p,key,maximum,delta)
 p[key]=math.max(0,math.min(maximum,p[key]+delta))
end

local function apply(rule,w,p)
 local effect,amount=rule[5],rule[6]
 if effect==0 then change(p,HP,p[MAXHP],amount)
 elseif effect==1 then change(p,HP,p[MAXHP],math.floor(p[MAXHP]*amount/100))
 elseif effect==2 then change(p,HP,p[MAXHP],-amount)
 elseif effect==3 then change(p,MP,p[MAXMP],amount)
 elseif effect==4 then change(p,MP,p[MAXMP],-amount)
 elseif effect==5 then change(p,MORALE,w.sq_limited or 100,amount)
 elseif effect==6 then change(p,MORALE,w.sq_limited or 100,-amount)
 elseif effect==7 then w.troubled=true
 elseif effect==8 then w.troubled=false
 elseif effect==9 then w.poison=math.max(w.poison or 0,math.min(amount,255))
 elseif effect==10 then w.poison=0 end
end

local function run(rows,event,wid,eid)
 local changed=false
 for _,rule in ipairs(rows) do
  local actor,p=unit(wid)
  if not actor then break end
  local target,defender=unit(eid)
  if rule[1]==event and passes(rule,p,target,defender) then
   local receiver,person=target,defender
   if rule[4]==0 then receiver,person=actor,p end
   if receiver then
    apply(rule,receiver,person)
    changed=true
   end
  end
 end
 return changed
end

function T.skill(event,wid,eid,hasSkill)
 local actor=unit(wid)
 if not actor then return end
 local changed=false
 for number,rows in pairs(T.rules.S) do
  if not T.deleted.S[number] and hasSkill(actor.id,number) and run(rows,event,wid,eid) then changed=true end
 end
 return changed
end

function T.turn(hasSkill)
 if next(T.rules.S)==nil then return end
 for wid=1,War.PersonNum do
  local changed=T.skill(0,wid,wid,hasSkill)
  if JY.Status~=GAME_WMAP then return end
  if changed then WarResetStatus(wid) end
 end
end

function T.strategy(wid,eid,mid,item,onKill,after)
 local rows=T.rules.M[mid]
 if not rows then return false end
 local actor=unit(wid)
 local target=unit(eid)
 if not actor or not target then return true end
 War.ControlStatus="actionMenu"
 local tiles=WarGetAtkFW(target.x,target.y,JY.Magic[mid][RANGE])
 local targets={}
 for i=1,tiles.num do
  local x,y=tiles[i][1],tiles[i][2]
  if x>=1 and x<=War.Width and y>=1 and y<=War.Depth then
   local id=GetWarMap(x,y,2)
   local other=unit(id)
   if other and other.enemy==target.enemy then targets[#targets+1]={id,x,y} end
  end
 end
 for _,tile in ipairs(targets) do
  local id,x,y=tile[1],tile[2],tile[3]
  local other,p=unit(id)
  if JY.Status~=GAME_WMAP or not unit(wid) then break end
  if other and (item or math.random()<WarMagicHitRatio(wid,id,mid)) then
   PlayMagic(mid,x,y,actor.id)
   run(rows,0,wid,id)
   if p[HP]<=0 then onKill(wid,id) end
   WarResetStatus(id)
  end
 end
 if JY.Status==GAME_WMAP then
  after(wid,eid)
  WarResetStatus(wid)
 end
 return true
end

function T.strategyDamage(wid,eid,mid)
 local actor,p=unit(wid)
 local target,defender=unit(eid)
 if not actor or not target then return 0 end
 local damage=0
 for _,rule in ipairs(T.rules.M[mid]) do
  if rule[4]==1 and rule[5]==2 and passes(rule,p,target,defender) then
   damage=damage+rule[6]
  end
 end
 return damage
end

local function value(rule,w,p)
 local effect,amount=rule[5],rule[6]
 if effect==0 then return math.min(amount,p[MAXHP]-p[HP])
 elseif effect==1 then return math.min(math.floor(p[MAXHP]*amount/100),p[MAXHP]-p[HP])
 elseif effect==2 then return -math.min(amount,p[HP])*(amount>=p[HP] and 3 or 1)
 elseif effect==3 then return 10*math.min(amount,p[MAXMP]-p[MP])
 elseif effect==4 then return -10*math.min(amount,p[MP])
 elseif effect==5 then return 5*math.min(amount,(w.sq_limited or 100)-p[MORALE])
 elseif effect==6 then return -5*math.min(amount,p[MORALE])
 elseif effect==7 then return w.troubled and 0 or -200
 elseif effect==8 then return w.troubled and 200 or 0
 elseif effect==9 then return amount>(w.poison or 0) and -150 or 0
 else return (w.poison or 0)>0 and 150 or 0 end
end

function T.strategyScore(wid,eid,mid)
 local actor,p=unit(wid)
 local target=unit(eid)
 if not actor or not target then return 0 end
 local kind=JY.Magic[mid][KIND]
 if (actor.enemy==target.enemy)~=(kind>=6 and kind<=8) then return 0 end
 local tiles=WarGetAtkFW(target.x,target.y,JY.Magic[mid][RANGE])
 local score=0
 for i=1,tiles.num do
  local x,y=tiles[i][1],tiles[i][2]
  if x>=1 and x<=War.Width and y>=1 and y<=War.Depth then
   local other,defender=unit(GetWarMap(x,y,2))
   if other and other.enemy==target.enemy then
    for _,rule in ipairs(T.rules.M[mid]) do
     if passes(rule,p,other,defender) then
      if rule[4]==0 then score=score+value(rule,actor,p)
      else score=score+value(rule,other,defender)*(actor.enemy==other.enemy and 1 or -1) end
     end
    end
   end
  end
 end
 return math.max(0,score)
end

return T
