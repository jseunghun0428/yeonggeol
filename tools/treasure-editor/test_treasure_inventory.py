import unittest
from pathlib import Path

from lupa.lua52 import LuaRuntime


SCRIPT = Path(__file__).resolve().parents[2] / "yeonggeol" / "script" / "addon"


class TreasureInventoryTest(unittest.TestCase):
    def setUp(self):
        self.lua = LuaRuntime(encoding=None)
        for path in ("bogam_data.lua", "gear_data.lua"):
            self.lua.execute((SCRIPT / path).read_bytes())
        self.lua.execute(br'''
LORD,NAME,ITEM="\190\253\214\247","\208\213\195\251","\181\192\190\223"
WEAPON="\206\228\198\247"
INAME="\195\251\179\198"
TIER="\206\222\211\195\051"
CC={PersonSize=152,koNG={selall=function() return {item=true} end}}
JY={PersonNum=802,Person={},Data_Person={},Base={[TIER]=4},Item={}}
for i=1,801 do JY.Person[i]={[LORD]=0} end
for i=1,1003 do JY.Item[i]={[INAME]="item"..i} end
JY.Person[1][LORD]=1
War={Person={{id=1}}}
local copies={[1001]=222,[1002]=61}
function koItemBaseId(i) return copies[i] or i end
function treasureOwner(i)
 for _,r in ipairs(koBogamList) do if r[1]==i then return r[4] end end
end
function ByteRead(data,addr) return data[addr] or 0 end
Byte={get16=ByteRead,set16=function(data,addr,value) data[addr]=value end}
function bag(pid,k,item) JY.Person[pid][ITEM..k]=item end
function held(pid,item)
 for k=1,8 do if JY.Person[pid][ITEM..k]==item then return true end end
 return false
end
function warehouse(k,item)
 local row=762+math.floor((k-1)/8)
 local offset=120+2*((k-1)%8)
 if item then Byte.set16(JY.Data_Person,row*152+offset,item) end
 return {i=row,o=offset,iid=ByteRead(JY.Data_Person,row*152+offset)}
end
function koStoreList()
 local list={}
 for n=1,160 do local slot=warehouse(n) if slot.iid>0 then list[#list+1]=slot end end
 return list
end
function koStorePut(item)
 for n=1,160 do if warehouse(n).iid==0 then warehouse(n,item) return true end end
 return false
end
function koPackBag(pid)
 local p=JY.Person[pid]
 local kept={}
 for k=1,8 do local v=p[ITEM..k] or 0 if v>0 then kept[#kept+1]=v end end
 for k=1,8 do p[ITEM..k]=kept[k] or 0 end
end
gold,notice,refreshes=0,{},0
function koGold() return gold end
function koSetGold(n) gold=n end
function koHook() end
function koHas() return false end
function WarDrawStrBoxConfirm(text) notice[#notice+1]=text end
function ReSetAttrib() refreshes=refreshes+1 end
function ModifyForce(pid,fid) JY.Person[pid][LORD]=fid end
function LoadRecord(id) return id end
function GetItem(pid,item) bag(pid,8,item) return true end
function WarGetItem(wid,item) bag(War.Person[wid].id,8,item) return true end
function CC.koNG.reset(sel)
 LoadRecord(11)
 for addr in pairs(JY.Data_Person) do if addr>=782*152 then JY.Data_Person[addr]=nil end end
 JY.Person[5][LORD]=0
 if not sel.item then for k=1,8 do bag(1,k,0) end end
 return true
end
''')
        self.lua.execute((SCRIPT / "treasure_inventory.lua").read_bytes())

    def test_load_prefers_engraved_star_and_counts_worn_once(self):
        self.lua.execute(br'''
JY.Person[2][LORD]=1
bag(1,1,775) JY.Person[1][WEAPON]=775
bag(1,2,74) bag(1,3,74)
warehouse(1,222)
bag(2,1,1001)
bag(4,1,222) -- enemy stock is independent
assert(LoadRecord(11)==11 and gold==0)
assert(LoadRecord(2)==2 and gold==2000)
assert(not held(1,775) and JY.Person[1][WEAPON]==0 and refreshes==1)
assert(held(2,1001) and warehouse(1).iid==0 and held(4,222))
assert(JY.Person[1][ITEM..1]==74 and JY.Person[1][ITEM..2]==74)
assert(#notice==1 and notice[1]:find("item775",1,true) and notice[1]:find("item222",1,true))
LoadRecord(2)
assert(gold==2000 and #notice==1)
''')

    def test_story_gifts_and_hiring_use_same_ownership(self):
        self.lua.execute(br'''
warehouse(1,61)
assert(GetItem(1,61) and gold==1000 and not held(1,61))
assert(GetItem(1,62) and gold==1000 and held(1,62))
bag(3,1,1002) ModifyForce(3,1)
assert(held(3,1002) and warehouse(1).iid==0 and gold==2000)
bag(4,1,1002) ModifyForce(4,1)
assert(held(3,1002) and not held(4,1002) and gold==3000)
bag(1,1,775) JY.Person[1][WEAPON]=775
assert(WarGetItem(1,222) and gold==4000)
assert(not held(1,775) and held(1,222) and JY.Person[1][WEAPON]==222)
''')

    def test_parked_allies_and_gear_story_wrapper(self):
        source = (SCRIPT / "gear.lua").read_bytes()
        start = source.index(b"local function storyGive(raw,who,pid,item,")
        end = source.index(b"local rawLR=LoadRecord", start)
        chunk = source[start:end].rsplit(b"\ndo", 1)[0]
        self.lua.execute(b'''
local MOVE,BYITEM=koGearMove,{[775]=1}
local function have() return true end
local function owned() return false end
function setGift(k) gift=k end
GetItem=function(pid,item) bag(pid,8,item) return true end
WarGetItem=function(wid,item) bag(War.Person[wid].id,8,item) return true end
'''+chunk)
        self.lua.execute(br'''
function koStoryParkedTreasureHolders() return {[4]=602} end
JY.Person[4][LORD]=1 -- a temporary ally, whose real gear is parked
bag(4,1,61) bag(602,1,61) bag(602,2,775)
assert(GetItem(1,11) and gold==1000 and gift==1 and not held(1,775))
assert(WarGetItem(1,61) and gold==2000 and not held(1,61))
LoadRecord(3)
assert(held(602,61) and held(4,61) and gold==2000)
''')

    def test_next_cycle_places_owned_treasures_and_protects_dormant_items(self):
        self.lua.execute(br'''
JY.Person[5][LORD]=1
JY.Person[5][NAME]=treasureOwner(775)
bag(1,1,1001) JY.Person[1][WEAPON]=1001
bag(1,2,61) bag(1,3,74)
bag(5,1,61) -- duplicate inherited outside the active starting roster
bag(4,1,59) -- NPC item was never the player's
assert(CC.koNG.reset({item=true}))
assert(held(5,1001) and not held(1,1001) and not held(1,61) and not held(5,61))
assert(warehouse(1).iid==61 and held(1,74) and held(4,59) and gold==1000)
assert(koTreasureKeeps(5,1001) and koTreasureHasReserved(222) and not koTreasureHasReserved(775))
assert(GetItem(1,775) and gold==2000 and held(5,1001) and not held(1,775))
LoadRecord(2)
assert(held(5,1001) and gold==2000)
ModifyForce(5,1)
assert(held(5,1001) and not koTreasureKeeps(5,1001) and gold==2000)
''')

    def test_capacity_and_disabled_inheritance(self):
        self.lua.execute(br'''
JY.Person[5][NAME]=treasureOwner(775)
for k=1,8 do bag(5,k,74) end
for k=1,159 do warehouse(k,74) end
bag(1,1,222)
bag(1,2,61)
assert(CC.koNG.reset({item=true}))
assert(warehouse(160).iid==61 and held(1,222) and not held(5,222) and gold==0)
assert(#notice==1 and notice[1]:find("item222",1,true))
warehouse(160,0)
assert(CC.koNG.reset({item=true}))
assert(warehouse(160).iid==222 and not held(1,222))
bag(1,1,63)
assert(CC.koNG.reset({item=false}) and not held(1,63))
for _,slot in ipairs(koStoreList()) do assert(slot.iid~=63) end
''')

    def test_warehouse_move_reuses_slots_freed_by_owner_transfer(self):
        self.lua.execute(br'''
JY.Person[5][NAME]=treasureOwner(775)
for k=1,159 do warehouse(k,74) end
warehouse(160,222)
bag(1,1,61)
local reset=CC.koNG.reset
assert(reset({item=true}))
assert(held(5,222) and warehouse(160).iid==61 and not held(1,61))
assert(#notice==0 and gold==0)
''')


if __name__ == "__main__":
    unittest.main()
