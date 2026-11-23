-- ko 5.0 tank (2026-10-11, 추가 작업 체크리스트 2번): 탱커 특기 둘.
--  · 호위(51): 주위 2칸 안의 같은 편이 물리 공격을 받으면 대신 받음. 병력 30% 이상·혼란 아님일 때(10-11: 한 턴 횟수 제한 없앰). 책략·관통·난사는 그대로.
--    대상을 바꾸는 곳은 jymain 두 곳(플레이어 공격 대상 고른 직후, AI 공격 직전 — patch_탱커.pl)이라 선공·반격·충살도 호위 무장 기준.
--  · 도발(52): 주위 3칸 안의 적 AI 가 이 부대를 먼저 노림 (WarGetAtkValue 에 +40).
--  · AI 도 호위를 앎: 호위가 걸리는 대상의 공격 가치는 호위 무장을 칠 때의 가치로 계산(헛공격 줄임).
--  · 가진 무장 (합성 천부, jymain koTalentSet 에 추가): 허저 호치(강공·호위·도발) · 전위 악래(선공·호위) · 관평 충의(침착·호위) ·
--    주태 호주(연환·호위) · 장비 장판(위압·도발). 방패 5종(수패·단패·추패·연미패·무적신패)은 특기 호위.
--  · 천부와 장비 기록은 세이브에 들어 있어, 불러올 때 옛 값이면 새 값으로 맞춤(사용자가 바꾼 것은 그대로).
-- Build (game folder): perl "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/\129\068\130\119/free_hz.pl" < "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/addon/tank_src.lua" > script/addon/tank.lua
local GUARD,TAUNT=51,52
local P_NAME,P_BL,P_MAXBL="\208\213\195\251","\177\248\193\166","\215\238\180\243\177\248\193\166"-- 姓名 兵力 最大兵力
local P_TF,P_FACE="\204\236\184\179","\205\183\207\241\180\250\186\197"-- 天赋 头像代号
local I_SKILL,I_DESC="\204\216\188\188","\203\181\195\247"-- 特技 说明 (of an item)

local function dist(a,b) return math.abs(a.x-b.x)+math.abs(a.y-b.y) end
local function sameSide(a,b) return a.enemy==b.enemy end
local function usable(i,u)
	if not (u and u.live and not u.hide and not u.troubled) then return false end
	local p=JY.Person[u.id]
	if (p[P_BL] or 0)<(p[P_MAXBL] or 1)*koTactics.setting(GUARD,2,30)/100 then return false end
	return WarCheckSkill(i,GUARD)
end
-- who would take a physical attack of war unit atk on war unit eid (nil = nobody)
function koGuardFind(atk,eid)
	if not (CC.Enhancement and War and War.Person and atk and eid and eid>0) then return nil end
	local t=War.Person[eid]
	local a=War.Person[atk]
	if not (t and a) or sameSide(a,t) then return nil end
	local best,bd,bb=nil,99,-1
	local range=koTactics.setting(GUARD,1,2)
	for i,u in pairs(War.Person) do
		if i~=eid and i~=atk and sameSide(u,t) and dist(u,t)<=range and usable(i,u) then
			local d,b=dist(u,t),JY.Person[u.id][P_BL]
			if d<bd or (d==bd and b>bb) then best,bd,bb=i,d,b end
		end
	end
	return best
end
-- the attack really happens: say so
function koGuardSwap(atk,eid)
	local g=koGuardFind(atk,eid)
	if not g then return eid end
	pcall(WarDrawStrBoxDelay,JY.Person[War.Person[g].id][P_NAME].."\131\080 \134\113\130\110! "..JY.Person[War.Person[eid].id][P_NAME].." \130\095\131\078 \130\074\130\112\129\083 \133\072\130\098\129\077",M_Yellow)
	return g
end
-- AI: value of hitting (x,y) = value of hitting whoever really takes it; 도발 pulls nearby enemies
do
	local orig=WarGetAtkValue
	function WarGetAtkValue(pid,x,y)
		local v=orig(pid,x,y)
		if not (CC.Enhancement and v and v>0) then return v end
		local eid=GetWarMap(x,y,2)
		if not (eid and eid>0) then return v end
		local g=koGuardFind(pid,eid)
		local t=eid
		if g then
			local u=War.Person[g]
			v=orig(pid,u.x,u.y)
			t=g
		end
		local tu,au=War.Person[t],War.Person[pid]
		if v>0 and tu and au and dist(tu,au)<=koTactics.setting(TAUNT,1,3) and WarCheckSkill(t,TAUNT) then
			v=v+koTactics.setting(TAUNT,2,40)
		end
		return v
	end
end
-- 공격 미리보기: 호위가 걸리면 대신 받는 무장 기준으로 (preview2 가 제목에 「(호위)」)
do
	local orig=rawget(_G,"koDrawAtkPreview")
	if type(orig)=="function" then
		function koDrawAtkPreview(scl,eid)
			local g=koGuardFind(scl,eid)
			if g then rawset(_G,"koGuardPreview",eid) local r=orig(scl,g) rawset(_G,"koGuardPreview",nil) return r end
			return orig(scl,eid)
		end
	end
end
-- 옛 세이브: 천부·방패 특기를 새 값으로 (천부는 옛 값 그대로일 때만, 방패는 특기가 비어 있을 때만)
local TALENT=(rawget(_G,"koCamp") and koCamp.tankTalent) or {[68]={115,125},[387]={117,126},[128]={20,127},[163]={109,128},[3]={113,129}}
local SHIELDS={147,148,149,150,151}   -- 수패 단패 추패 연미패 무적신패 (the item screen adds the skill text itself)
function koTankFix()
	local base={}
	for pid,t in pairs(TALENT) do
		local p=JY.Person[pid]
		if p then
			base[tostring(p[P_NAME])..":"..tostring(p[P_FACE])]=t
			if p[P_TF]==t[1] then p[P_TF]=t[2] end
		end
	end
	for pid=421,(JY.PersonNum or 0)-1 do   -- tavern copies of them
		local p=JY.Person[pid]
		local t=p and base[tostring(p[P_NAME])..":"..tostring(p[P_FACE])]
		if t and p[P_TF]==t[1] then p[P_TF]=t[2] end
	end
	for _,i in ipairs(SHIELDS) do
		local it=JY.Item[i]
		if it and it[I_SKILL]~=GUARD then it[I_SKILL]=GUARD end-- 10-21: always guard (shields left 천공개물; one engraved before gets guard back)
	end
end
do
	local lr=LoadRecord
	function LoadRecord(...)
		local r=lr(...)
		pcall(koTankFix)
		return r
	end
end
