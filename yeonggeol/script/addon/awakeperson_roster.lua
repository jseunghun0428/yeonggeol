-- Used by the game and the developer editor to match the same awakening rows.
local rows={}
for r,d in ipairs(koAwakeData) do
	for _,name in ipairs(d[1]) do rows[name]=rows[name] or r end
end

return function(pid,people,story,book)
	local person=people[pid]
	if not person then return nil end
	local nameKey="\208\213\195\251"
	local name=person[nameKey] or ""
	if pid>=511 and pid<=530 then
		if name~="" then return 238+pid-510 end
		return nil
	end
	local fix=koAwakeFix and koAwakeFix[story]
	if fix and fix[pid] then return fix[pid] end
	local r=rows[name]
	if r and fix then
		for _,value in pairs(fix) do
			if value==r then
				for _,id in ipairs(book or {}) do
					if people[id] and people[id][nameKey]==name then return fix[id] or koAwakeFixDefault end
				end
				return koAwakeFixDefault
			end
		end
	end
	return r
end
