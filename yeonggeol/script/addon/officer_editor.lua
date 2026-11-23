local getPic=GetPic
local sprite="\213\189\182\183\182\175\215\247"
local troop="\177\248\214\214"

function koOfficerBattleSlot(pid,bz)
	local rules=JY.OfficerBattleSlots or {}
	local personal=rules[pid]
	local shared=rules[0]
	local own=personal and personal[bz]
	local common=shared and shared[bz]
	if own and (not common or own[2]>=common[2]) then return own[1] end
	if common then return common[1] end
	local edit=JY.OfficerOverrides and JY.OfficerOverrides[pid]
	if edit and edit.war>=0 then return edit.war end
end

local loadRecord=LoadRecord
if loadRecord then
	function LoadRecord(...)
		local rules={}
		local path=string.gsub(CC.R_GRPFilename[0],"newgame%.grp$","officer_war.txt")
		local file=io.open(path,"r")
		if file then
			for line in file:lines() do
				local pid,bz,slot,order=string.match(line,"^(%d+) (%d+) (%d+) (%d+)$")
				pid,bz,slot,order=tonumber(pid),tonumber(bz),tonumber(slot),tonumber(order)
				if pid and slot<1000000 then
					rules[pid]=rules[pid] or {}
					rules[pid][bz]={slot,order}
				end
			end
			file:close()
		end
		JY.OfficerBattleSlots=rules
		return loadRecord(...)
	end
end

function GetPic(pid,enemy,friend)
	local slot=koOfficerBattleSlot(pid,JY.Person[pid][troop])
	if slot then
		local fallback=getPic(pid,enemy,friend)
		KO_SPR_FALLBACK=fallback<=65535 and fallback or 0
		JY.Person[pid][sprite]=slot
		return slot
	end
	return getPic(pid,enemy,friend)
end
