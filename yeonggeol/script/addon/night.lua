-- ko 5.0 night (10-11): night pictures for the night battles. The night set (야간 지도 패키지) is appended to mmap / mbig / mmini
-- by 개발용/도구/야간지도_덧붙이기.pl: maps at 271~274, their minimaps at 275~278 (terrain and map number unchanged).
-- A map is drawn at night only in its 외전 battle: the map number and the story event the side story branched from (事件402),
-- so the same maps stay daylight in the story (소패 91, 영천 263, 정군산 534). Side replays set 402 too.
-- ko 군웅록 (11-03): in a story (CONFIG.koCamp) the 영걸전 table is not used; the story's own night battles come from
-- script/camp/<id>/night_data.lua (개발용/도구/야간지도_이야기.py, which also appends that story's night pictures to its own
-- data/camp/<id>/ mmap · mbig · mmini): [map]={{ev0=,ev1=,pic=,mini=}}, night only while the story event is in [ev0,ev1)
-- (the battle's SnrStartWar event up to the next battle), so a daytime battle on the same map (무제전 합비 246) stays day.
-- A free battle / replay (CC.koFree) is judged by its source event koFreeData[idx].ev.
local NIGHT={
[71]={218,0},   -- 관우 형양 (743): fire at the guest house at night
[9]={218,1},    -- 장비 소패 야습 (815)
[39]={485,2},   -- 장비 파군 (841): leaving 파군 at night
[18]={578,3},   -- 장비 낭중의 밤 (851)
}
local F402="\202\194\188\254".."402"
local CAMP=nil
if rawget(_G,"koCamp") or CONFIG.koCamp then
	local ok,t=pcall(dofile,(CONFIG.koCampScript or "").."night_data.lua")
	CAMP=(ok and type(t)=="table") and t or {}
end
local function campEntry(m)
	local list=CAMP[m]
	if not list then return nil end
	local ev=JY.EventID or 0
	local f=CC.koFree
	if f and f.idx then
		local fd=rawget(_G,"koFreeData")
		local b=fd and fd[f.idx]
		ev=(b and b.ev) or -1
	end
	for _,e in ipairs(list) do
		if ev>=e.ev0 and ev<e.ev1 then return e end
	end
	return nil
end
local function idx(m)
	local n=NIGHT[m]
	if n and JY.Base and (JY.Base[F402] or 0)==n[1] then return n[2] end
	return nil
end
function koNightPic(m)
	if CAMP then local e=campEntry(m) return e and e.pic or nil end
	local k=idx(m) if k then return 271+k end return nil
end
function koNightMini(m)
	if CAMP then local e=campEntry(m) return e and e.mini or nil end
	local k=idx(m) if k then return 275+k end return nil
end
