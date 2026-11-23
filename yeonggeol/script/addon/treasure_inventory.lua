-- Story treasure ownership, duplicate awards, and next-cycle placement.
local LORD="\190\253\214\247"
local NAME="\208\213\195\251"
local INAME="\195\251\179\198"
local ITEM="\181\192\190\223"
local TIER="\206\222\211\195\051"
local EQUIP={"\206\228\198\247","\183\192\190\223","\184\168\214\250"}
local MARK_VERSION=19071
if not rawget(_G,"koBogamList") then dofile(CONFIG.ScriptPath.."addon/bogam_data.lua") end
local MOVE=rawget(_G,"koGearMove") or {}
local families,byId={},{}
for _,row in ipairs(koBogamList or {}) do
 local family={index=#families+1,owner=row[4]}
 families[#families+1]=family
 byId[row[1]]=family
 if row[2]>0 then family.star=row[2] byId[row[2]]=family end
end
if #families==0 then return end
local resetting=false
local loadDepth=0

local function supported()
 return JY and JY.Data_Person and (JY.PersonNum or 0)>801
end

local function active()
 return supported() and not (CC.koFree or CC.koTownBattle or CC.koReplay)
end

local function classify(item)
 if not item or item<=0 then return end
 local base=rawget(_G,"koItemBaseId") and koItemBaseId(item) or item
 return byId[MOVE[base] or base],MOVE[base] or base,base~=item
end

-- Reserved person rows 782–800, offsets 40–118, are separate from the
-- awakening and bounty offsets. Track dormant carry-over in the save itself.
local function markOffset(family)
 local n=family.index-1
 return (782+math.floor(n/20))*CC.PersonSize+40+4*(n%20)
end

local function getMark(family)
 if family.index>380 or Byte.get16(JY.Data_Person,801*CC.PersonSize+118)~=MARK_VERSION then return 0,0 end
 local offset=markOffset(family)
 return Byte.get16(JY.Data_Person,offset),Byte.get16(JY.Data_Person,offset+2)
end

local function mark(family,pid,item)
 if family.index>380 then return end
 local header=801*CC.PersonSize+118
 if Byte.get16(JY.Data_Person,header)~=MARK_VERSION then
  for _,group in ipairs(families) do
   if group.index<=380 then
    local offset=markOffset(group)
    Byte.set16(JY.Data_Person,offset,0)
    Byte.set16(JY.Data_Person,offset+2,0)
   end
  end
  Byte.set16(JY.Data_Person,header,MARK_VERSION)
 end
 local offset=markOffset(family)
 Byte.set16(JY.Data_Person,offset,pid or 0)
 Byte.set16(JY.Data_Person,offset+2,item or 0)
end

function koTreasureKeeps(pid,item)
 if not supported() then return false end
 local family=classify(item)
 if not family then return false end
 local owner,held=getMark(family)
 return pid==owner and item==held
end

function koTreasureReserves(pid,item)
 if not supported() then return false end
 local family=classify(item)
 if not family then return false end
 local owner,held=getMark(family)
 if owner~=pid then return false end
 for k=1,8 do if JY.Person[pid][ITEM..k]==held then return true end end
 return false
end

local function record(pid,key,item,worn,slot)
 local family,base,engraved=classify(item)
 if family then
  return {pid=pid,key=key,item=item,worn=worn,slot=slot,family=family,
          priority=(base==family.star and 4 or 0)+(engraved and 2 or 0)+(worn and 1 or 0)}
 end
end

local function records(pid)
 local result,first={},{}
 local person=JY.Person[pid]
 for k=1,8 do
  local item=person[ITEM..k]
  local entry=record(pid,ITEM..k,item)
  if entry then result[#result+1]=entry first[item]=first[item] or entry end
 end
 for _,key in ipairs(EQUIP) do
  local item=person[key]
  local entry=first[item]
  if entry then
   if not entry.worn then entry.priority=entry.priority+1 entry.worn=key end
  else
   entry=record(pid,key,item,key)
   if entry then result[#result+1]=entry first[item]=entry end
  end
 end
 return result
end

local function collect(family)
 local result,party={},{}
 local parked=rawget(_G,"koStoryParkedTreasureHolders") and koStoryParkedTreasureHolders() or {}
 local backups={}
 for _,pid in pairs(parked) do backups[pid]=true end
 for pid=1,JY.PersonNum-1 do
  if backups[pid] or ((pid<762 or pid>801) and not parked[pid] and JY.Person[pid][LORD]==1) then
   party[pid]=true
   for _,entry in ipairs(records(pid)) do
    if not family or family==entry.family then result[#result+1]=entry end
   end
  end
 end
 for _,slot in ipairs(rawget(_G,"koStoreList") and koStoreList() or {}) do
  local entry=record(nil,nil,slot.iid,nil,slot)
  if entry and (not family or family==entry.family) then result[#result+1]=entry end
 end
 for _,group in ipairs(family and {family} or families) do
  local pid,item=getMark(group)
  if pid>0 and pid<JY.PersonNum and not party[pid] then
   for _,entry in ipairs(records(pid)) do
    if entry.item==item then result[#result+1]=entry break end
   end
  end
 end
 return result
end

function koTreasureHasReserved(item)
 if not supported() then return false end
 local family,wanted=classify(item)
 if not family then return false end
 local pid,held=getMark(family)
 if pid<=0 or pid>=JY.PersonNum then return false end
 local _,base=classify(held)
 if base~=wanted then return false end
 for _,entry in ipairs(records(pid)) do if entry.item==held then return true end end
 return false
end

local function write(entry,item,changed)
 if entry.slot then
  Byte.set16(JY.Data_Person,entry.slot.i*CC.PersonSize+entry.slot.o,item)
 else
  local person=JY.Person[entry.pid]
  local worn=entry.worn and person[entry.worn]==entry.item and entry.worn
  person[entry.key]=item
  if not worn then
   local stillInBag=false
   for k=1,8 do if person[ITEM..k]==entry.item then stillInBag=true break end end
   if not stillInBag then
    for _,key in ipairs(EQUIP) do if person[key]==entry.item then worn=key break end end
   end
  end
  if worn then person[worn]=item end
  changed[entry.pid]=changed[entry.pid] or not not worn
  if koTreasureKeeps(entry.pid,entry.item) then
   if classify(item)==entry.family then mark(entry.family,entry.pid,item) else mark(entry.family) end
  end
 end
end

local function refresh(changed)
 for pid,worn in pairs(changed) do
  if rawget(_G,"koPackBag") then koPackBag(pid) end
  if worn then
   local wornOnly={}
   for _,entry in ipairs(records(pid)) do
    if entry.key==entry.worn then wornOnly[#wornOnly+1]=entry end
   end
   local ok,err=pcall(ReSetAttrib,pid,false)
   if not ok and rawget(_G,"koAddonLog") then koAddonLog("treasure equipment refresh: "..tostring(err)) end
   for _,entry in ipairs(wornOnly) do JY.Person[pid][entry.key]=entry.item end
  end
 end
 if rawget(_G,"koGearInvalidateOwnership") then koGearInvalidateOwnership() end
end

local function itemName(entry)
 local _,base=classify(entry.item)
 local item=JY.Item[entry.item]
 local name=item and item[INAME]
 if name and name~="" then return name end
 return (JY.Item[base] and JY.Item[base][INAME]) or tostring(entry.item)
end

local function announce(header,entries,reward)
 if #entries==0 then return end
 local counts,ordered={},{}
 for _,entry in ipairs(entries) do
  local name=itemName(entry)
  if not counts[name] then ordered[#ordered+1]=name counts[name]=0 end
  counts[name]=counts[name]+1
 end
 -- A dialog page holds four lines including its heading.
 for first=1,#ordered,3 do
  local lines={header}
  for i=first,math.min(first+2,#ordered) do
   local name=ordered[i]
   local amount=counts[name]
   local suffix=amount>1 and (" x"..amount) or ""
   if reward then suffix=suffix.."  \130\085\131\103 "..(amount*1000) end
   lines[#lines+1]=name..suffix
  end
  WarDrawStrBoxConfirm(table.concat(lines,"*"),M_White,JY.Status~=GAME_WMAP)
 end
end

local function reward(removed)
 if #removed==0 then return end
 local gold=1000*#removed
 koSetGold(koGold()+gold)
 pcall(koHook,"gold_gain",gold)
 announce("\130\101\130\068 \131\115\131\065",removed,true) -- 중복 보물
end

local function better(a,b,joining)
 if a.priority~=b.priority then return a.priority>b.priority end
 return joining and b.pid==joining and a.pid~=joining
end

local function deduplicate(entries,joining,changed)
 local best,kept,removed={},{},{}
 for _,entry in ipairs(entries) do
  local other=best[entry.family]
  if not other or better(entry,other,joining) then best[entry.family]=entry end
 end
 for _,entry in ipairs(entries) do
  if best[entry.family]==entry then kept[#kept+1]=entry
  else write(entry,0,changed) removed[#removed+1]=entry end
 end
 return kept,removed
end

local function clean(joining)
 local changed={}
 local _,removed=deduplicate(collect(),joining,changed)
 if #removed>0 then refresh(changed) reward(removed) end
end

-- The gear wrapper already remaps legacy IDs and marks a successful story gift.
function koTreasureStoryGive(pid,item)
 local family=classify(item)
 if resetting or loadDepth>0 or not family or not active() or not pid or not JY.Person[pid] or JY.Person[pid][LORD]~=1 then return false end
 local held=collect(family)
 if #held==0 then return false end
 local changed={}
 local kept,removed=deduplicate(held,nil,changed)
 local incumbent=kept[1]
 local incoming=record(nil,nil,item)
 if better(incoming,incumbent) then
  write(incumbent,item,changed)
  removed[#removed+1]=incumbent
 else
  removed[#removed+1]=incoming
 end
 refresh(changed)
 reward(removed)
 return true
end

if not koHas("gear") then
 local rawGet,rawWarGet=GetItem,WarGetItem
 function GetItem(pid,item,...)
  if koTreasureStoryGive(pid,item) then return true end
  return rawGet(pid,item,...)
 end
 function WarGetItem(wid,item,...)
  local unit=War.Person[wid]
  if unit and koTreasureStoryGive(unit.id,item) then return true end
  return rawWarGet(wid,item,...)
 end
end

local function owners()
 local result={}
 for pid=1,math.min(601,JY.PersonNum-1) do
  local p=JY.Person[pid]
  local name=p[NAME]
  if name and name~="" and (not result[name] or (p[LORD]==1 and JY.Person[result[name]][LORD]~=1)) then
   result[name]=pid
  end
 end
 return result
end

local function emptyBag(pid)
 for k=1,8 do if (JY.Person[pid][ITEM..k] or 0)==0 then return ITEM..k end end
end

local function place(entry,owner,changed)
 if owner and entry.pid==owner and entry.key~=entry.worn then
  if JY.Person[owner][LORD]~=1 then mark(entry.family,owner,entry.item) end
  return true
 end
 if not owner and entry.slot then return true end
 if owner then
  local key=emptyBag(owner)
  if not key then return false end
  JY.Person[owner][key]=entry.item
  changed[owner]=true
 else
  if not rawget(_G,"koStorePut") or not koStorePut(entry.item) then return false end
 end
 write(entry,0,changed)
 if owner and JY.Person[owner][LORD]~=1 then mark(entry.family,owner,entry.item) end
 return true
end

local function carriedRecords(before)
 local result,seen={},{}
 local function append(entry)
  local address=entry.slot and (entry.slot.i..":"..entry.slot.o) or (entry.pid..":"..entry.key)
  if not seen[address] then result[#result+1]=entry seen[address]=true end
 end
 for _,entry in ipairs(before) do
  -- The base reset copies each old bag and warehouse item to its original slot.
  local item=entry.slot and Byte.get16(JY.Data_Person,entry.slot.i*CC.PersonSize+entry.slot.o)
             or JY.Person[entry.pid][entry.key]
  if item~=entry.item and entry.key and entry.key==entry.worn then
   -- The base reset rebuilds equipment from bags. Preserve equipment-only rows in old saves.
   JY.Person[entry.pid][entry.key]=entry.item
   item=entry.item
  end
  if item==entry.item then
   append(entry)
  end
 end
 for _,entry in ipairs(collect()) do append(entry) end
 return result
end

local function arrange(before)
 local changed,waiting,overflow={},{},{}
 local kept,removed=deduplicate(carriedRecords(before),nil,changed)
 local byName=owners()
 for _,entry in ipairs(kept) do
  local owner=byName[entry.family.owner]
  if not place(entry,owner,changed) then waiting[#waiting+1]={entry=entry,owner=owner} end
 end
 -- A transfer can free space needed by an earlier item.
 local moved=true
 while moved and #waiting>0 do
  moved=false
  for i=#waiting,1,-1 do
   local move=waiting[i]
   if place(move.entry,move.owner,changed) then table.remove(waiting,i) moved=true end
  end
 end
 for _,move in ipairs(waiting) do
  local entry=move.entry
  if not place(entry,nil,changed) then
   if entry.pid and JY.Person[entry.pid][LORD]~=1 then mark(entry.family,entry.pid,entry.item) end
   overflow[#overflow+1]=entry
  end
 end
 refresh(changed)
 reward(removed)
 announce("\130\074\133\121 \130\094\132\082: \139\090\131\071\130\067 \136\102\129\111 \131\115\131\065",overflow,false)
end

local rawModify=ModifyForce
function ModifyForce(pid,fid,...)
 local joining=not resetting and loadDepth==0 and active() and (fid or 1)==1
               and pid and JY.Person[pid] and JY.Person[pid][LORD]~=1
 local result=table.pack(rawModify(pid,fid,...))
 if joining and JY.Person[pid][LORD]==1 and not (rawget(_G,"koStoryParked") and koStoryParked(pid)) then
  clean(pid)
  for _,family in ipairs(families) do if getMark(family)==pid then mark(family) end end
 end
 return table.unpack(result,1,result.n)
end

local rawLoad=LoadRecord
function LoadRecord(id,...)
 loadDepth=loadDepth+1
 local result=table.pack(pcall(rawLoad,id,...))
 loadDepth=loadDepth-1
 if not result[1] then error(result[2],0) end
 if not resetting and loadDepth==0 and id and id>0 and id~=11 and active() then clean() end
 return table.unpack(result,2,result.n)
end

local NG=CC.koNG
local rawReset=NG.reset
function NG.reset(sel,...)
 sel=sel or NG.selall()
 local before=active() and sel.item and (JY.Base[TIER] or 0)>=4 and collect() or nil
 resetting=true
 local result=table.pack(pcall(rawReset,sel,...))
 resetting=false
 if not result[1] then error(result[2],0) end
 if before and result[2]~=false and active() then arrange(before) end
 return table.unpack(result,2,result.n)
end
