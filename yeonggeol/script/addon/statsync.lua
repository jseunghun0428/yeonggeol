-- 군웅록 11-14 (사용자 「이름이 같은데 이야기마다 능력치가 다른 무장 — 장수편집 · 도감 · 실제 무장의 열전이 모두 같게」): addon "statsync"
-- (UTF-8 원본: 개발용/addon/statsync_src.lua -> 도구/free_hz.pl -> script/addon/statsync.lua, addons.lua 에서 newgen · gesync 뒤)
--
-- 이야기의 적 전용 칸(무제전 동탁 303 · 서영 304 등)과 숨은 무장 사본 칸은 장수편집 통합 명단에 없어서, 장수편집 · 도감이 보여 주는
-- 명단 칸 값과 실제 전투의 값이 달랐다. 도구/patch_통합능력치.py 가 newgame 기본값을 맞추고 그 칸 목록(statsync_data.lua koStatAlias)을 쓴다.
-- 이 애드온 (newgen 의 koGenStatApply = 불러올 때마다 · 장수편집 능력치 편집 뒤를 감쌈):
--  · 우리 편이 아닌 별칭 칸: 무력 · 지력 · 통솔 = 장수편집 편집값(그 명단 키), 없으면 새 기본값 — 옛 세이브의 옛 값도 여기서 바뀜
--  · 우리 편 별칭 칸: 성장분을 지키려고 옛 기본값 그대로일 때만 새 기본값(+ 편집값)으로
pcall(dofile,CONFIG.ScriptPath.."addon/statsync_data.lua")
if type(rawget(_G,"koStatAlias"))~="table" then return end
local WL,ZL,TS="\206\228\193\166","\214\199\193\166","\205\179\194\202"   -- 武力 智力 统率
local LORD="\190\253\214\247"                                             -- 君主
local COL={yeonggeol=3,wuje=4,sunjian=5,yuanshao=6}
local function mode() return CONFIG.koCamp or "yeonggeol" end
-- 명단 키 → 이 모드의 명단 칸 (genedit_roster.lua koGenRoster: {키, 이름, 영걸전, 무제전, 손견전, 원소전})
local K2P=nil
local function keyPid(key)
	if not K2P then
		K2P={}
		local c=COL[mode()]
		for _,r in ipairs(rawget(_G,"koGenRoster") or {}) do
			local k=(type(r[1])=="number") and tostring(r[1]) or (string.gsub(r[1],":","@"))
			if c and r[c] and r[c]>0 then K2P[k]=r[c] end
		end
	end
	return K2P[key]
end
-- 장수편집 편집값: 이 모드 명단 칸의 CC.koGenStat ",\135\066:\129\073:\130\067:\132\119," 먼저, 없으면 공용 CC.koGenStatAll ",\137\074:\129\073:\130\067:\132\119,"
local function editOf(key)
	if not key or key=="" then return nil end
	local p=keyPid(key)
	if p then
		for q,a,b,c in string.gmatch(CC.koGenStat or "","(%d+):(%d+):(%d+):(%d+)") do
			if tonumber(q)==p then return tonumber(a),tonumber(b),tonumber(c) end
		end
	end
	for k,a,b,c in string.gmatch(CC.koGenStatAll or "","([^,:]+):(%d+):(%d+):(%d+)") do
		if k==key then return tonumber(a),tonumber(b),tonumber(c) end
	end
	return nil
end
local function sync()
	if not (JY and JY.Person and JY.PersonNum) then return 0 end
	local A=koStatAlias[mode()] or {}
	local n=0
	for pid,e in pairs(A) do
		if pid>0 and pid<JY.PersonNum then
			local p=JY.Person[pid]
			local w,z,t=e[5],e[6],e[7]
			local a,b,c=editOf(e[1])
			if a then w,z,t=a,b,c end
			local mine=p[LORD]==1
			local fresh=(p[WL]==e[2] and p[ZL]==e[3] and p[TS]==e[4])
			if (not mine or fresh) and (p[WL]~=w or p[ZL]~=z or p[TS]~=t) then
				p[WL],p[ZL],p[TS]=w,z,t
				pcall(ReSetAttrib,pid,false)
				n=n+1
			end
		end
	end
	return n
end
function koStatSyncT() return sync() end-- for test scripts
local raw=rawget(_G,"koGenStatApply")
function koGenStatApply(...)
	if raw then pcall(raw,...) end
	pcall(sync)
end
