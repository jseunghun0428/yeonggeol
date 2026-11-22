-- snr_rt.lua : snr2lua.pl 이 만든 사건 표가 쓰는 도움 함수 (생성 파일 머리에 그대로 붙음)
-- strict _G 라 새 전역은 rawset 으로 만든다. 한글 문자열은 free_hz.pl 이 hz 로 바꾼다.
local function G(name, v) rawset(_G, name, v) end
G("SnrRoom", 0)
-- 장면 배경 번호: 대본은 SnrRoom=n → SnrAdd(인물 세움) → SetSceneID(배경 표시) 순서라, 인물을 세우는 동안 JY.SubScene 은 아직 앞 장면 배경이다.
-- 그래서 자리 보정·좌석·막힌 칸·문은 SnrRoom(새로 정한 배경)을 먼저 본다 (10-05: 양양 의사청 85번 인물을 앞 장면 54번 좌석표로 옮겨 뭉쳤던 문제)
G("SnrBg", function() local r = rawget(_G, "SnrRoom") if r and r > 0 then return r end return JY.SubScene end)
G("SnrChoiceResult", 0)
G("SnrW", {})

-- 장면 인물 이동: DOS 는 목표 좌표로 걷는다. 5.0 장면 걸음은 대각선 4방향(CC.DX/DY: 0=(+2,-1) 1=(-2,+1) 2=(-2,-1) 3=(+2,+1))
-- 목표까지를 두 대각선으로 나눔: dx=2a+2b, dy=-a+b -> a=(dx-2dy)/4 (방향 0, 음수면 1), b=(dx+2dy)/4 (방향 3, 음수면 2)
-- 가구 피해 걷기: SnrBlock[배경]["x,y"] = 못 지나는 칸 (생성 파일 끝에 붙음, 장애물.tsv → block.pl)
local SDX, SDY = {[0] = 2, -2, -2, 2}, {[0] = -1, 1, -1, 1}
local function r5(v) local s = v < 0 and -1 or 1; return s * math.floor(math.abs(v) * 5 + 0.5) / 5 end
-- 두 대각선 다리 (a: 방향 0/1, b: 방향 3/2)
local function SnrLegs(sx, sy, tx, ty, afirst)
	local dx, dy = tx - sx, ty - sy
	local a, b = r5((dx - 2 * dy) / 4), r5((dx + 2 * dy) / 4)
	local A = a ~= 0 and {math.abs(a), a > 0 and 0 or 1} or nil
	local B = b ~= 0 and {math.abs(b), b > 0 and 3 or 2} or nil
	local L = {}
	if afirst then L[#L + 1] = A; L[#L + 1] = B else L[#L + 1] = B; L[#L + 1] = A end
	return L
end
-- 걸음 막힘(10-05): SnrBlockE[배경]["x,y,d"] = 칸 (x,y) 에서 방향 d 한 걸음이 가구·벽을 지남 (block.pl block_edges)
local function SnrBlkE() return rawget(_G, "SnrBlockE") and SnrBlockE[SnrBg()] end
-- 가구·벽 다각형(SnrPolys[배경] = {{x1,y1,x2,y2,...},...}, 배경 그림 픽셀) 안의 점인가
local function SnrInPoly(px, py)
	local PP = rawget(_G, "SnrPolys") and SnrPolys[SnrBg()]
	if not PP then return false end
	for _, P in ipairs(PP) do
		local inside, n = false, #P / 2
		local j = n
		for i = 1, n do
			local xi, yi, xj, yj = P[2 * i - 1], P[2 * i], P[2 * j - 1], P[2 * j]
			if ((yi > py) ~= (yj > py)) and (px < (xj - xi) * (py - yi) / ((yj - yi) ~= 0 and (yj - yi) or 1e-9) + xi) then inside = not inside end
			j = i
		end
		if inside then return true end
	end
	return false
end
local function SnrClear(sx, sy, legs, blk, tx, ty)
	local E = SnrBlkE()
	if not blk and not E then return true end
	-- 곧은 걸음 선분을 1/12 걸음(약 3px)마다 다각형으로 검사 (출발·도착 발에서 8px 안은 뺌 — 의자 바로 뒤 자리에서 일어서기)
	local sx0, sy0, tx0, ty0 = 11 + 18 * sx, 3 + 18 * sy, 11 + 18 * tx, 3 + 18 * ty
	do local x, y = sx, sy
		for _, s in ipairs(legs) do
			local n, d = s[1], s[2]
			for k = 1, math.ceil(n * 12) do
				local t = math.min(k / 12, n); local px, py = 11 + 18 * (x + SDX[d] * t), 3 + 18 * (y + SDY[d] * t)
				if sx >= 0 and sx <= 35 and sy >= 0 and sy <= 22 and (px < 11 or px > 641 or py < 3 or py > 399) then return false end   -- 화면 안에서 출발하면 화면 밖을 지나지 않음
				if (px - sx0) ^ 2 + (py - sy0) ^ 2 > 64 and (px - tx0) ^ 2 + (py - ty0) ^ 2 > 64 and SnrInPoly(px, py) then return false end
			end
			x, y = x + SDX[d] * n, y + SDY[d] * n
		end
	end
	local x, y = sx, sy
	for _, s in ipairs(legs) do
		local n, d = s[1], s[2]
		if E then   -- 한 걸음씩: 걸음 시작 칸에서 그 방향 걸음이 막혔나
			for k = 0, math.ceil(n) - 1 do
				local cx, cy = math.floor(x + SDX[d] * k + 0.5), math.floor(y + SDY[d] * k + 0.5)
				if E[cx .. "," .. cy .. "," .. d] then return false end
			end
		end
		for k2 = 1, blk and math.ceil(n * 2) or 0 do   -- 반 걸음마다 검사(칸 사이를 스치는 경우)
			local t = math.min(k2 / 2, n); local cx, cy = x + SDX[d] * t, y + SDY[d] * t
			local key = math.floor(cx + 0.5) .. "," .. math.floor(cy + 0.5)
			if blk[key] and not (math.abs(cx - tx) < 0.6 and math.abs(cy - ty) < 0.6) then return false end
		end
		x, y = x + SDX[d] * n, y + SDY[d] * n
	end
	return true
end
-- 걸음 계획: 곧장 두 다리가 막히지 않으면 그것, 막히면 칸 길찾기(꺾임 적은 길) + 마지막 두 다리
-- 칸 길찾기: 상태 (칸, 방향), 걸음 2 · 꺾임 1 (지그재그 막기). 결과 dist/prev 를 돌려줌
local PX0, PY0, PNX, PNY = -10, -8, 56, 42
local function pid4(x, y, d) return ((y - PY0) * PNX + (x - PX0)) * 4 + d end
local function SnrSearch(sx, sy, blk, free)
	local INF = 1e9; local dist, prev = {}, {}
	local E = SnrBlkE()
	local buckets = {[0] = {}}
	for d = 0, 3 do dist[pid4(sx, sy, d)] = 0; buckets[0][#buckets[0] + 1] = {sx, sy, d} end
	for c = 0, 400 do
		local B = buckets[c]
		if B then
			for _, s in ipairs(B) do
				local x, y, d = s[1], s[2], s[3]
				if dist[pid4(x, y, d)] == c then
					for nd = 0, 3 do
						local nx, ny = x + SDX[nd], y + SDY[nd]
						if nx >= PX0 and nx < PX0 + PNX and ny >= PY0 and ny < PY0 + PNY and not (blk and blk[nx .. "," .. ny] and not (free and free[nx .. "," .. ny])) and not (E and E[x .. "," .. y .. "," .. nd])
							and not (x >= 0 and x <= 35 and y >= 0 and y <= 22 and (nx < 0 or nx > 35 or ny < 0 or ny > 22)) then   -- 화면 안에서 화면 밖으로 돌아가지 않음
							local nc = c + 2 + ((nd ~= d and c > 0) and 1 or 0)
							local ni = pid4(nx, ny, nd)
							if (dist[ni] or INF) > nc then dist[ni] = nc; prev[ni] = pid4(x, y, d); buckets[nc] = buckets[nc] or {}; local q = buckets[nc]; q[#q + 1] = {nx, ny, nd} end
						end
					end
				end
			end
			buckets[c] = nil
		end
	end
	return dist, prev
end
-- 칸 (x,y) 에 닿는 가장 싼 비용과 그 상태 번호
local function SnrCost(dist, x, y)
	local bc, bi = nil, nil
	for d = 0, 3 do local i = pid4(x, y, d); local c = dist[i]; if c and (not bc or c < bc) then bc, bi = c, i end end
	return bc, bi
end
-- 상태 번호까지의 길 -> (걸음수, 방향) 묶음
local function SnrTrace(prev, i)
	local seq = {}
	while prev[i] do seq[#seq + 1] = i % 4; i = prev[i] end
	local L = {}
	for k = #seq, 1, -1 do local d = seq[k]; local last = L[#L]; if last and last[2] == d then last[1] = last[1] + 1 else L[#L + 1] = {1, d} end end
	return L
end
local function SnrBlk() return rawget(_G, "SnrBlock") and SnrBlock[SnrBg()] end
-- 길 곧게 펴기(10-06): 칸 길찾기 길은 칸 격자를 따라 꺾이고, 대각선 격자는 네 칸 중 한 칸에만 정수 걸음으로 닿아 끝에 잔걸음(0.2~0.8칸 앞뒤)이 붙는다.
-- 길 위의 점들 가운데, 지금 자리에서 가구 안 지나는 두 다리(분수 걸음 허용)로 곧장 닿는 가장 먼 점으로 건너뛰기를 되풀이 → 꺾임·잔걸음이 사라짐
-- 잔걸음 접기(10-06): 1 걸음 못 되는 걸음(대각선 격자 맞춤용)을 빼고, 그만큼을 같은 축의 가장 뒤쪽 긴 걸음 길이에 더한다.
-- 끝에서 앞뒤로 까딱이는 걸음이 없어짐. 바꾼 길이 가구를 지나면 그대로 둠
local function SnrAbsorb(sx, sy, L, blk)
	local ta, tb, M = 0, 0, {}
	for _, s in ipairs(L) do
		if s[1] < 1 then
			if s[2] == 0 then ta = ta + s[1] elseif s[2] == 1 then ta = ta - s[1] elseif s[2] == 3 then tb = tb + s[1] else tb = tb - s[1] end
		else local last = M[#M]; if last and last[2] == s[2] then last[1] = last[1] + s[1] else M[#M + 1] = {s[1], s[2]} end end
	end
	if #M == #L or #M == 0 then return L end
	local function fold(v, dp, dn)
		if math.abs(v) < 1e-6 then return true end
		for i = #M, 1, -1 do local s = M[i]
			if s[2] == dp or s[2] == dn then local nl = s[1] + (s[2] == dp and v or -v)   -- 줄면 짧아지고, 0 을 넘으면 반대 방향
				nl = math.floor(nl * 5 + 0.5) / 5
				if nl < 0 then s[1] = -nl; s[2] = (s[2] == dp) and dn or dp else s[1] = nl end
				if s[1] < 0.1 then table.remove(M, i) end
				return true end
		end
		return false
	end
	local function ok(P)
		local x, y, ex, ey = sx, sy, sx, sy
		for _, s in ipairs(P) do ex, ey = ex + SDX[s[2]] * s[1], ey + SDY[s[2]] * s[1] end
		for _, s in ipairs(P) do if not SnrClear(x, y, {s}, blk, ex, ey) then return false end; x, y = x + SDX[s[2]] * s[1], y + SDY[s[2]] * s[1] end
		return true
	end
	local M0 = {} for i, s in ipairs(M) do M0[i] = {s[1], s[2]} end
	if fold(ta, 0, 1) and fold(tb, 3, 2) and ok(M) then return M end
	-- 접을 수 없으면 맞춤 걸음을 맨 앞으로 (자리에서 비켜 나오는 한 걸음) — 도착해서 까딱이는 것보다 자연스럽다
	local P = {}
	if math.abs(ta) > 1e-6 then P[#P + 1] = {math.abs(ta), ta > 0 and 0 or 1} end
	if math.abs(tb) > 1e-6 then P[#P + 1] = {math.abs(tb), tb > 0 and 3 or 2} end
	for _, s in ipairs(M0) do P[#P + 1] = s end
	if ok(P) then return P end
	return L
end
local function SnrSmooth(sx, sy, L, blk)
	if #L < 2 then return L end
	local W = {}
	do local x, y = sx, sy; for _, s in ipairs(L) do x, y = x + SDX[s[2]] * s[1], y + SDY[s[2]] * s[1]; W[#W + 1] = {x, y} end end
	local out, cx, cy, i = {}, sx, sy, 0
	while i < #W do
		local done = false
		for j = #W, i + 1, -1 do
			local tx, ty = W[j][1], W[j][2]
			for _, af in ipairs({true, false}) do
				local L2 = SnrLegs(cx, cy, tx, ty, af)
				if j == i + 1 or SnrClear(cx, cy, L2, blk, tx, ty) then
					if j == i + 1 and not SnrClear(cx, cy, L2, blk, tx, ty) then L2 = {L[j]} end   -- 원래 걸음 그대로
					for _, s in ipairs(L2) do out[#out + 1] = s; cx, cy = cx + SDX[s[2]] * s[1], cy + SDY[s[2]] * s[1] end
					i, done = j, true
					break
				end
			end
			if done then break end
		end
	end
	return SnrAbsorb(sx, sy, out, blk)
end
-- 걸음 계획: 곧장 두 다리가 막히지 않으면 그것. 막히면 목표에서 1칸 안(거리² ≤ 5)의 칸 중 가장 싼 곳까지 칸 길 + 마지막 짧은 두 다리
G("SnrPlan", function(sx, sy, tx, ty, pid)
	local blk = SnrBlk()
	-- 10-06 (사용자: 사람을 통과해 걸어 나옴): 다른 사람이 선 칸도 막힌 칸으로 (목표 칸은 빼고)
	if pid then
		local B0 = blk or {}
		local P = {}
		for _, w in pairs(JY.Smap) do if w[1] ~= pid then local k = math.floor(w[2] + 0.5) .. "," .. math.floor(w[3] + 0.5); if k ~= math.floor(tx + 0.5) .. "," .. math.floor(ty + 0.5) then P[k] = true end end end
		blk = setmetatable(P, {__index = B0})
	end
	sx, sy = math.floor(sx + 0.5), math.floor(sy + 0.5)
	for _, af in ipairs({true, false}) do
		local L = SnrLegs(sx, sy, tx, ty, af)
		if SnrClear(sx, sy, L, blk, tx, ty) then return L, tx, ty end
	end
	-- 목표 칸(과 그 1칸 둘레 격자)은 막혀 있어도 들어갈 수 있음 (상석이 탁자 바로 뒤인 경우 등)
	local free = {}
	for y = math.floor(ty) - 1, math.floor(ty) + 1 do for x = math.floor(tx) - 2, math.floor(tx) + 2 do if (x - tx) ^ 2 + (2 * (y - ty)) ^ 2 <= 1 then free[x .. "," .. y] = true end end end
	local dist, prev = SnrSearch(sx, sy, blk, free)
	local exact = tx == math.floor(tx) and ty == math.floor(ty)
	-- 목표 칸 자체에 닿을 수 있으면 반드시 거기 (5.0 자리가 의자 끝처럼 막힌 칸이라도 옆 칸에서 멈추지 않게)
	if exact then local c, i = SnrCost(dist, tx, ty); if c then return SnrSmooth(sx, sy, SnrTrace(prev, i), blk), tx, ty end end
	-- 아니면 목표 둘레 격자 칸까지 가서 짧은 마무리 걸음으로 정확히 목표에 (10-05: 5.0 자리에 서도록. 대각선 격자는 출발점과 다른 줄의
	-- 칸에 칸 걸음만으로는 못 닿음). 마무리 걸음이 가구를 지나지 않는 칸을 먼저 (5.0 상석이 의자·탁자 바로 뒤인 경우)
	local best, bs, fin
	for y = math.floor(ty) - 3, math.floor(ty) + 3 do for x = math.floor(tx) - 4, math.floor(tx) + 4 do
		local g = (x - tx) ^ 2 + (2 * (y - ty)) ^ 2
		if g <= (exact and 20 or 5) then local c, i = SnrCost(dist, x, y)
			if c then
				local F, clear = nil, true
				if exact and (x ~= tx or y ~= ty) then
					clear = false
					for _, af in ipairs({true, false}) do local L2 = SnrLegs(x, y, tx, ty, af); if SnrClear(x, y, L2, blk, tx, ty) then F, clear = L2, true; break end end
					F = F or SnrLegs(x, y, tx, ty, true)
				end
				local sc = c + g * 0.5 + (clear and 0 or 1000) + ((not exact and g > 5) and 1000 or 0)
				if not bs or sc < bs then best, bs, fin = {x, y, i}, sc, F end
			end
		end
	end end
	if not best then return SnrLegs(sx, sy, tx, ty, true), tx, ty end
	local L = SnrTrace(prev, best[3])
	if fin then for _, s in ipairs(fin) do L[#L + 1] = s end; return SnrSmooth(sx, sy, L, blk), tx, ty end
	return SnrSmooth(sx, sy, L, blk), best[1], best[2]
end)
-- 퇴장 계획: 통로(방향 1 로 뻗는 줄) 위 칸들 가운데 "\134\069\131\071\129\089\130\067 + \132\119\132\083 \130\105\130\102 \129\064\129\065 \139\119\129\089\130\067" 가 가장 싼 칸으로 들어선 뒤 통로를 따라 나감
G("SnrPlanExit", function(sx, sy, px, py, n)
	local blk = SnrBlk()
	sx, sy = math.floor(sx + 0.5), math.floor(sy + 0.5)
	local dist, prev = SnrSearch(sx, sy, blk)
	local bk, bt, bi
	-- 통로 위에 가구가 있으면 그 너머(화면 쪽) 칸부터만 통로를 탐
	local k0 = 0
	local E = SnrBlkE()   -- 통로 줄의 칸 사이 걸음이 가구를 지나도(나무 줄기 등) 그 너머부터
	for k = n, 0, -1 do
		if (blk and blk[(px - 2 * k) .. "," .. (py + k)]) or (E and k < n and E[(px - 2 * k) .. "," .. (py + k) .. ",1"]) then k0 = k + 1; break end
	end
	for k = k0, n do
		local c, i = SnrCost(dist, px - 2 * k, py + k)
		if c then local t = c + 2 * (n - k); if not bt or t < bt then bk, bt, bi = k, t, i end end
	end
	if not bk then return {{n, 1}} end
	local L = SnrTrace(prev, bi)
	if n - bk > 0 then local last = L[#L]; if last and last[2] == 1 then last[1] = last[1] + (n - bk) else L[#L + 1] = {n - bk, 1} end end
	return SnrSmooth(sx, sy, L, blk)
end)
-- 인물 걷기: 계획대로 MovePerson, 끝에 정확한 자리·방향
G("SnrWalk", function(pid, x, y, d)
	for _, v in pairs(JY.Smap) do
		if v[1] == pid then
			local L, fx, fy = SnrPlan(v[2], v[3], x, y, pid)
			for _, s in ipairs(L) do MovePerson(pid, s[1], s[2]) end
			for _, w in pairs(JY.Smap) do if w[1] == pid then w[2] = fx; w[3] = fy; if d then w[4] = d end end end
			return true
		end
	end
	return false
end)
G("SnrMoveTo", function(pid, x, y, d, exact)
	if not exact then x, y = SnrFixSpot(pid, x, y, true) end   -- exact: 연출 인물 (seat50 "-- \133\066\133\098"), 원작 기하 그대로
	if SnrWalk(pid, x, y, d) then DrawSMap(); ShowScreen(); return end
	AddPerson(pid, x, y, d); DrawSMap(); ShowScreen()
end)

G("SnrAskSortie", function()
	return WarDrawStrBoxYesNo("\133\098\129\103\129\097\130\086\134\121\129\075\129\076\129\089?", M_White, true)
end)

G("SnrChoice", function(opts)
	local menu = {}
	for i, s in ipairs(opts) do menu[i] = {s, nil, 1} end
	local r = ShowMenu(menu, #opts, 0, 0, 0, 0, 0, 3, 0, 16, M_White, M_White)
	if r == nil or r < 1 then r = 1 end
	return r
end)

-- 전투 준비: 03(아군)·22(적)를 모아 두었다가 09 전장 지정에서 시작
G("SnrSetAllies", function(turn, leader2, list) SnrW.turn = turn; SnrW.leader2 = leader2; SnrW.allies = list end)
G("SnrSetEnemies", function(list) SnrW.enemies = list end)
-- 자동 승리 끔(SnrStartWar 셋째 인자, bld2talk 가 승리 처리 없는 전투에 붙임): 적 전멸·적 총대장 격파로 끝내지 않고
-- 대본의 목표(접촉 등)가 끝을 정한다. 아군 총대장이 쓰러지면 패배는 그대로. 나머지는 jymain WarCheckStatus 와 같음
local SnrOrigWCS = WarCheckStatus
WarCheckStatus = function(...)
	-- ko 11-15: 주인공이 안 나온 전투(백마 안량 등) = 아군 첫 부대가 총대장 (patch_총대장.py)
	if JY.Status == GAME_WMAP and War and War.Person and GetWarID(War.Leader1 or -1) == 0 then
		local best
		for wid, v in pairs(War.Person) do
			if not v.enemy and not v.friend and (best == nil or wid < best) then best = wid end
		end
		if best then War.Leader1 = War.Person[best].id; War.Person[best].leader = true end
	end
	if not (JY.Status == GAME_WMAP and War.koSnrNoAuto) then return SnrOrigWCS(...) end
	for _, v in pairs(War.Person) do
		if v.leader and not v.live and not v.enemy then
			JY.Status = GAME_WARLOSE
			local kw = rawget(_G, "koWar") if kw then kw.lost = true end
			break
		end
	end
	local ce = War.ControlEnable
	War.ControlEnableOld = War.ControlEnable
	War.ControlEnable = false
	War.InMap = false
	if DoEvent(JY.EventID) then
		if JY.Status == GAME_WMAP or JY.Status == GAME_WARWIN then DoEvent(JY.EventID) end
	end
	War.ControlEnable = ce
end
G("SnrStartWar", function(map, name, noauto)
	WarIni()
	DefineWarMap(map, name, "", SnrW.turn or 30, 0, SnrW.leader2 or -1)
	War.koSnrNoAuto = noauto or nil
	if SnrW.allies then SelectTerm(1, SnrW.allies) end
	if SnrW.enemies then SelectEnemy(SnrW.enemies) end
	SnrFixStart()
	SnrW = {}
	JY.Status = GAME_WMAP
end)
-- 원작이 못 서는 칸(성벽·울타리·산지·강물 등, 그 병종 지형 비용 0)이나 지도 밖에 세워 둔 부대를 가장 가까운 설 수 있는 빈칸으로.
-- 숨은 증원은 나타날 때 엔진(WarShowArmy)이 같은 일을 하므로 건너뜀. 물 위 무리는 지도에 배를 그려 넣어 두었음(군주판/지도/배.tsv)
G("SnrFixStart", function()
	local occ, bad = {}, {}
	local function key(x, y) return x * 1000 + y end
	local function stand(x, y, wid)
		if x < 1 or y < 1 or x > War.Width or y > War.Depth then return false end
		local own = GetWarMap(x, y, 2) == wid
		if own then SetWarMap(x, y, 2, 0) end
		local ok = WarCanExistXY(x, y, wid)
		if own then SetWarMap(x, y, 2, wid) end
		return ok
	end
	for wid = 1, War.PersonNum do
		local v = War.Person[wid]
		if v and v.live and not v.hide then
			if stand(v.x, v.y, wid) and not occ[key(v.x, v.y)] then occ[key(v.x, v.y)] = true else bad[#bad + 1] = wid end
		end
	end
	for _, wid in ipairs(bad) do
		local v = War.Person[wid]
		local done = false
		for r = 1, 12 do
			for dx = -r, r do
				for s = -1, 1, 2 do
					local dy = s * (r - math.abs(dx))
					local nx, ny = v.x + dx, v.y + dy
					if not done and not occ[key(nx, ny)] and stand(nx, ny, wid) then
						if GetWarMap(v.x, v.y, 2) == wid then SetWarMap(v.x, v.y, 2, 0) end
						lib.Debug(string.format("SnrFixStart: %d (%d,%d) -> (%d,%d)", v.id, v.x, v.y, nx, ny))
						v.x, v.y = nx, ny
						if GetWarMap(nx, ny, 2) == 0 then SetWarMap(nx, ny, 2, wid) end
						done = true
					end
					if dy == 0 then break end
				end
			end
			if done then break end
		end
		occ[key(v.x, v.y)] = true
	end
end)
G("SnrSelectTerm", function() end)
-- 목표문 줄바꿈: 승리조건 창 안쪽 폭(약 264px, 한글 16px·반각 8px)을 넘으면 단어 단위로 다음 줄, 이어지는 줄은 번호 뒤로 들여쓰기
G("SnrWrap", function(s, maxw)
	maxw = maxw or 256
	local out = {}
	for line in (s .. "*"):gmatch("(.-)%*") do
		local cur, w, first = "", 0, true
		for word in line:gmatch("%S+") do
			local ww = 0; local i = 1
			while i <= #word do if word:byte(i) >= 128 then ww = ww + 16; i = i + 2 else ww = ww + 8; i = i + 1 end end
			local sp = (cur == "") and 0 or 8
			if cur ~= "" and w + sp + ww > maxw then out[#out + 1] = cur; cur = "   " .. word; w = 24 + ww
			else cur = (cur == "") and word or (cur .. " " .. word); w = w + sp + ww end
		end
		if cur ~= "" then out[#out + 1] = cur end
	end
	return table.concat(out, "*")
end)
G("SnrObjective", function(s)
	s = SnrWrap(s)
	-- 전투 중이면 바로 띄우지 않고 그 단계가 끝날 때(개전 대사 뒤) 띄움 — 5.0 원본 순서
	-- 도시 장면(JY.Status 가 도시)이면 그냥 상자 (10-06 사용자: 도시에서 "\133\098\129\070 \131\101\130\080\130\104 \129\111\129\077" 가 지난 전투 지도 위 승리조건 창으로 뜸 — War.MapID 는 지난 전투 값이 남아 있음)
	local inwar = JY.Status == GAME_WMAP or JY.Status == GAME_WARWIN or JY.Status == GAME_WARLOSE
	if inwar and War and War.MapID then War.WarTarget = s; War.koSnrPend = true else DrawStrBoxCenter(s) end
end)
G("SnrFlushTarget", function()
	if War and War.koSnrPend and (JY.Status == GAME_WMAP or JY.Status == GAME_WARWIN or JY.Status == GAME_WARLOSE) then War.koSnrPend = nil; WarShowTarget(true) end
end)

-- 단계 끝(13): 다음 사건으로. 도시 조작·전투 중이면 자동 진행으로 돌린다
-- keepWar(true) = 같은 전투의 다음 단계로: 전투 중이면 전투 상태를 그대로 둔다 (bld2talk 가 다음 사건이 전투 사건일 때 붙임)
G("SnrEndStage", function(keepWar)
	if keepWar and JY.Status == GAME_WMAP then
		-- 전투 그대로
	elseif JY.Status == GAME_WMAP or JY.Status == GAME_WARWIN or JY.Status == GAME_WARLOSE or JY.Status == GAME_SMAP_MANUAL then
		JY.Status = GAME_SMAP_AUTO
	end
	NextEvent()
	JY.Tid = -1
end)

-- 전투 사건 한 번만 (전투마다 새로)
G("SnrOnce", function(no, k)
	War.koSnrOnce = War.koSnrOnce or {}
	local key = no * 64 + k
	if War.koSnrOnce[key] then return false end
	War.koSnrOnce[key] = true
	return true
end)

G("SnrFlagList", function(clear, flags)
	-- DOS 20: 대지도 장소(0~31) 목록 — 사건 깃발과 다른 공간. 5.0 은 대지도 장소를 안 쓰므로 기억만 해 둠
	SnrW.places = flags
end)

G("SnrWarHide", function(pid)
	local wid = GetWarID(pid)
	if wid > 0 then
		local v = War.Person[wid]
		if v.live and not v.hide then SetWarMap(v.x, v.y, 2, 0) end
		-- 이야기 연출로 치우는 것(원작 퇴장)은 격파가 아니다: 총대장 표시를 떼야 5.0 엔진이 "\135\084\130\095\131\097 \130\112\134\086 = \129\116\129\117/\129\079\134\099"로 보지 않음
		-- (4장 예장 전투: 착융이 주호를 죽이는 장면에서 전투가 승리로 끝나 버렸음)
		v.leader = false
		v.live = false; v.hide = true
	end
end)
G("SnrWarSide", function(pid, side)
	if koStoryRetireEnemy and koStoryRetireEnemy(pid) then return end
	local wid = GetWarID(pid)
	if wid > 0 then War.Person[wid].enemy = false; War.Person[wid].friend = (side ~= 0) end
end)
G("SnrDuel", function(a, b) end)          -- 일기토 화면은 아직 안 옮김(대사만 나옴)
G("SnrDuelAct", function(pid, act) end)
G("SnrGetItem", function(item)
	if JY.Status == GAME_WMAP and War.SelID and War.SelID > 0 then WarGetItem(War.SelID, item + 1)
	else GetItem(1, item + 1) end
end)
G("SnrLvUp", function(pid, n)
	if koStoryKeepsTraining and koStoryKeepsTraining(pid) then return end
	if JY.Status == GAME_WMAP and GetWarID(pid) > 0 then
		for _ = 1, n do WarLvUp(GetWarID(pid)) end
	else LvUp(pid, n) end
end)
G("SnrReward", function(kind, amount) if kind == 1 or kind == 4 then WarGetExp(amount) end end)
G("SnrHalve", function(who, what) WarEnemyWeak(who + 1, what + 1) end)
G("SnrBld", 0)   -- 지금 들어간 건물(방 번호), 0 = 없음
G("SnrBuilding", function(n) return SnrBld == n end)
G("SnrEnterCity", function() return false end)
G("SnrEnding", function(n) end)
G("SnrGameOver", function() JY.Status = GAME_START end)
-- 장면 이동(0F): 도시 조작 중이면 자동 진행으로 돌리고 그 장면으로
G("SnrJump", function(k)
	if JY.Status == GAME_SMAP_MANUAL then JY.Status = GAME_SMAP_AUTO end
	NextEvent(k)
	JY.Tid = -1
end)
-- 퇴장(18): 5.0 원본처럼 왼쪽 아래 대각선(방향 1 = (-2,+1))으로 화면 밖까지 걸어 나간 뒤 지움
G("SnrExit", function(pid)
	for _, v in pairs(JY.Smap) do
		if v[1] == pid then
			local n = math.ceil(math.min(24 - v[3], (v[2] + 2) / 2))
			if n > 0 then MovePerson(pid, n, 1) end
			break
		end
	end
	DecPerson(pid); DrawSMap(); ShowScreen()
end)
-- 출입문으로 등장: 화면 밖(문 자리에서 왼쪽 아래로 연장)에 세우고 문 자리까지 걸어 들어옴 (방향 0 = (+2,-1))
G("SnrEnter", function(pid, x, y, d)
	x, y = SnrFixSpot(pid, x, y)
	local live = JY.SubScene and JY.SubScene >= 0
	local D = rawget(_G, "SnrDoors"); local door = D and D[SnrBg()]
	if door then   -- 출입구가 있는 배경: 바깥 → 문턱 곧게 → 가구 피해 자리로
		AddPerson(pid, door[3], door[4], 0)
		if live then
			for _, s in ipairs(SnrLegs(door[3], door[4], door[1], door[2], true)) do MovePerson(pid, s[1], s[2]) end
			for _, w in pairs(JY.Smap) do if w[1] == pid then w[2] = door[1]; w[3] = door[2] end end
			SnrWalk(pid, x, y)
		end
	else           -- 왼쪽 아래 화면 밖에서 (예전엔 곧게 들어와 가구를 지났음 → 이제 가구 피해 걸음)
		local n = math.ceil(math.min(24 - y, (x + 2) / 2))
		if n < 0 then n = 0 end
		AddPerson(pid, x - 2 * n, y + n, 0)
		if live and n > 0 then SnrWalk(pid, x, y) end
	end
	for _, w in pairs(JY.Smap) do if w[1] == pid then w[2] = x; w[3] = y; w[4] = d end end
end)
-- 화면 틀(ui 201)에 유비 초상이 그려져 있음 -> 캠페인에서는 주인공(1번 무장) 얼굴을 그 자리(679,23, 64x80)에 덧그림
if not rawget(_G, "SnrStatusWrapped") then
	G("SnrStatusWrapped", true)
	local rawDGS = DrawGameStatus
	G("DrawGameStatus", function(...)
		local f = JY.Person[1]["\205\183\207\241\180\250\186\197"]
		if f and f > 0 then lib.SetClip(679, 23, 743, 103); lib.PicLoadCache(2, f * 2, 679, 23, 1); lib.SetClip(0, 0, 0, 0) end
		return rawDGS(...)
	end)
end
local SnrUnpack = table.unpack or rawget(_G, "unpack")   -- 엔진 Lua 판에 따라
-- 5.0 원본 방식의 들고 남: 출입문 한 점으로 모이지 않고, 각자 자기 자리의 왼쪽 아래 대각선(방향 1 = (-2,+1))을 따라 곧장
-- (5.0 유비편: 동탁 MovePerson(4,8,1), 전령 AddPerson(369,4,21,0) 뒤 MovePerson(369,8,0) 처럼)
-- 몸 전체가 화면 밖으로 나가는 걸음 수 (왼쪽: x <= -2, 아래: y >= 26 — 조형이 64px 라 발만 나가면 몸통이 보임)
local function SnrOffSteps(x, y) local n = math.ceil(math.min(26 - y, (x + 2) / 2)); if n < 1 then n = 1 end; return n end
-- 통로 축: 상석(ax,ay)을 지나 왼쪽 아래(방향 1)로 뻗는 대각선. 가로 성분 b = ((x-ax)+2(y-ay))/4 (방향 3 한 걸음 = b+1)
local function SnrAcross(x, y, ax, ay) return math.floor(((x - ax) + 2 * (y - ay)) / 4 + 0.5) end   -- 정수 걸음(통로 위 점이 칸에 맞게)
-- 퇴장: 한 사람씩 차례로 — 자기 자리에서 통로(축)로 비켜 들어선 뒤 통로를 따라 왼쪽 아래 화면 밖까지, 그리고 지움
-- 출입구(10-05, doors.tsv → SnrDoors[배경] = {안쪽 x,y, 바깥 x,y}): 있는 배경은 그 문으로 드나든다 (없으면 예전처럼 왼쪽 아래 통로)
local function SnrDoorOf() local D = rawget(_G, "SnrDoors"); return D and D[SnrBg()] end
local function SnrStraight(pid, sx, sy, tx, ty)   -- 문턱 ↔ 바깥: 가구 무시하고 곧게
	for _, s in ipairs(SnrLegs(sx, sy, tx, ty, true)) do MovePerson(pid, s[1], s[2]) end
end
local function SnrSetPos(pid, x, y, d) for _, w in pairs(JY.Smap) do if w[1] == pid then w[2] = x; w[3] = y; if d then w[4] = d end end end end
-- 자리 보정(10-05): 서는 자리가 화면 밖이거나 가구·벽 위면 가장 가까운 빈 바닥으로. 5.0 이 손으로 세운 자리(SnrKeep)는 가구 위라도 그대로
G("SnrFixSpot", function(pid, x, y, noseat)
	local bg = SnrBg()
	if not bg or bg <= 0 then return x, y end   -- 대지도(0)·없음은 그대로
	local B = (rawget(_G, "SnrBlock") and SnrBlock[bg]) or {}
	local K = (rawget(_G, "SnrKeep") and SnrKeep[bg]) or {}
	local function off(a, b) return a < 1 or a > 34 or b < 1 or b > 21 end
	local function taken(a, b) for _, w in pairs(JY.Smap) do if w[1] ~= pid and w[2] == a and w[3] == b then return true end end return false end
	local E = (rawget(_G, "SnrBlockE") and SnrBlockE[bg]) or {}
	local function shut(k) return E[k .. ",0"] and E[k .. ",1"] and E[k .. ",2"] and E[k .. ",3"] end   -- 네 방향 걸음이 다 막힌 칸 (나무와 물길 사이 등)
	local key = x .. "," .. y
	-- 좌석(SnrSeats: 5.0 이 세운 자리와 그 줄): 약 2칸 안(가로² + (2·세로)² ≤ 20)에 빈 좌석이 있으면 가장 가까운 좌석으로 (줄 맞춤)
	local S = rawget(_G, "SnrSeats") and SnrSeats[bg]
	if S and not K[key] and not noseat then   -- noseat: 장면 중 이동(SnrMoveTo)은 좌석에 안 붙임 (10-06)
		local sb, sx, sy
		for _, s in ipairs(S) do
			local g = (s[1] - x) ^ 2 + (2 * (s[2] - y)) ^ 2
			if g <= 20 and not taken(s[1], s[2]) and (not sb or g < sb) then sb, sx, sy = g, s[1], s[2] end
		end
		if sb then return sx, sy end
	end
	if not off(x, y) and ((not B[key] and not shut(key)) or K[key]) and not taken(x, y) then return x, y end
	-- 자리가 차 있거나 못 서는 곳: 5.0 자리(SnrKeep) 중 가까운 빈자리 먼저 (4칸 안), 없으면 아래에서 빈 바닥
	do local kb, kx, ky
		for k in pairs(K) do local a, b = k:match("^(-?%d+),(-?%d+)$"); a, b = tonumber(a), tonumber(b)
			if a and not off(a, b) and not taken(a, b) then local g = (a - x) ^ 2 + (2 * (b - y)) ^ 2; if g <= 64 and (not kb or g < kb) then kb, kx, ky = g, a, b end end
		end
		if kb then return kx, ky end
	end
	local best, bx, by
	for b = math.max(1, y - 8), math.min(21, y + 8) do for a = math.max(1, x - 14), math.min(34, x + 14) do
		local k = a .. "," .. b
		if not B[k] and not shut(k) and not taken(a, b) then local g = (a - x) ^ 2 + (2 * (b - y)) ^ 2; if not best or g < best then best, bx, by = g, a, b end end
	end end
	if best then return bx, by end
	return x, y
end)
G("SnrAdd", function(pid, x, y, d, exact) if not exact then x, y = SnrFixSpot(pid, x, y) end; AddPerson(pid, x, y, d) end)
-- 통로로 들어서서 문으로 (10-06 사용자: 줄에서 곧장이 아니라 통로 줄에 올라선 뒤 통로를 따라 문으로): 문 안쪽 점을 지나는 통로 줄(문 → 바깥 방향) 위에서 자기와 같은 깊이의 점
local function SnrAisleSpot(pid, door)
	local function SnrPosOf(id) for _, v in pairs(JY.Smap) do if v[1] == id then return v[2], v[3] end end end
	local x, y = SnrPosOf(pid); if not x then return end
	local ux = door[3] > door[1] and 2 or -2; local uy = door[4] > door[2] and 1 or -1
	local px, py = ux, -uy   -- 통로에 직각인 대각선 한 걸음
	-- x + k*px = door1 + t*ux , y + k*py = door2 + t*uy → k = ((door1-x)*uy - (door2-y)*ux) / (px*uy - py*ux)
	local det = px * uy - py * ux
	if det == 0 then return end
	local k = ((door[1] - x) * uy - (door[2] - y) * ux) / det
	k = math.floor(k + 0.5)
	if k == 0 then return end
	local tx, ty = x + k * px, y + k * py
	local B = SnrBlk() or {}
	if B[tx .. "," .. ty] or tx < 1 or ty < 1 or tx > 34 or ty > 21 then return end
	-- 통로까지 곧게(가구 안 지나게) 닿을 때만 (돌아가는 길은 안 감)
	local pd; for dd = 0, 3 do if SDX[dd] == (k > 0 and px or -px) and SDY[dd] == (k > 0 and py or -py) then pd = dd end end
	if not pd or not SnrClear(x, y, {{math.abs(k), pd}}, SnrBlk(), tx, ty) then return end
	return tx, ty
end
G("SnrLeave", function(ids, ax, ay)
	local door = SnrDoorOf()
	if door then
		for _, pid in ipairs(ids) do
			local ax1, ay1 = SnrAisleSpot(pid, door)
			if ax1 then SnrWalk(pid, ax1, ay1) end
			if SnrWalk(pid, door[1], door[2]) then SnrStraight(pid, door[1], door[2], door[3], door[4]) end
			DecPerson(pid); DrawSMap(); ShowScreen()
		end
		return
	end
	for _, pid in ipairs(ids) do
		for _, v in pairs(JY.Smap) do
			if v[1] == pid then
				local b = SnrAcross(v[2], v[3], ax, ay)
				local px, py = v[2] - 2 * b, v[3] - b             -- 자기 깊이의 통로 위 점 (통로 줄의 시작)
				local n = SnrOffSteps(px, py)
				-- 통로 줄 위에서 가장 빨리 닿는 칸으로 들어서(의자 틈 등) 통로를 따라 화면 밖으로
				for _, s in ipairs(SnrPlanExit(v[2], v[3], px, py, n)) do MovePerson(pid, s[1], s[2]) end
				break
			end
		end
		DecPerson(pid); DrawSMap(); ShowScreen()
	end
end)
-- 출입구 앞까지만: 퇴장과 같은 길을 가되 화면 안(발이 y<=19, x>=3)에서 멈춤 — 문 앞 대사 뒤에 SnrLeave 로 마저 나감
G("SnrToDoor", function(ids, ax, ay)
	local door = SnrDoorOf()
	-- 여럿이 문 앞에 갈 때 한 칸에 겹치지 않게: 문 쪽 다음 칸에 이미 누가 서 있으면 그 뒤에서 멈춤 (10-05 "\129\071\129\067\129\111 \133\104 \130\090\129\098 \132\079\130\077")
	local function busy(pid, a, b) for _, w in pairs(JY.Smap) do if w[1] ~= pid and w[2] == a and w[3] == b then return true end end return false end
	if door then
		local ux = door[3] > door[1] and 2 or -2; local uy = door[4] > door[2] and 1 or -1   -- 문 → 바깥 한 걸음
		local B = SnrBlk() or {}
		-- 두 줄로 (10-06 사용자: 넷이 한 줄로 서려니 길게 늘어짐): 문 안쪽으로 줄을 서되, 둘째 줄은 문 방향에 직각인 대각선으로 한 칸 옆
		local px, py = ux, -uy   -- 직각 대각선 한 걸음
		if B[(door[1] - ux + px) .. "," .. (door[2] - uy + py)] then px, py = -px, -py end
		for i, pid in ipairs(ids) do
			local col = (#ids >= 3) and ((i - 1) % 2) or 0
			local tx, ty = door[1] + col * px, door[2] + col * py
			for _ = 1, 12 do if busy(pid, tx, ty) or B[tx .. "," .. ty] then tx, ty = tx - ux, ty - uy else break end end   -- 문 안쪽으로 한 칸씩 줄
			SnrWalk(pid, tx, ty); DrawSMap(); ShowScreen()
		end
		return
	end
	for _, pid in ipairs(ids) do
		for _, v in pairs(JY.Smap) do
			if v[1] == pid then
				local b = SnrAcross(v[2], v[3], ax, ay)
				local px, py = v[2] - 2 * b, v[3] - b
				local x, y = v[2], v[3]
				local stopq = false
				for _, s in ipairs(SnrPlanExit(v[2], v[3], px, py, SnrOffSteps(px, py))) do
					local n, d = s[1], s[2]; local m = 0
					while m < n do
						local nx, ny = x + SDX[d], y + SDY[d]
						if d == 1 and (ny > 19 or nx < 3) then break end
						if busy(pid, nx, ny) then stopq = true break end   -- 앞사람 뒤에서 멈춤
						x, y, m = nx, ny, m + 1
					end
					if m > 0 then MovePerson(pid, m, d) end
					if stopq or m < n then break end
				end
				for _, w in pairs(JY.Smap) do if w[1] == pid then w[2] = x; w[3] = y; w[4] = 1 end end
				break
			end
		end
		DrawSMap(); ShowScreen()
	end
end)
-- 등장: 한 사람씩 차례로 — 통로 끝 화면 밖에서 통로를 따라 들어와(방향 0) 자기 자리 옆에서 비켜 섬
G("SnrEnterMany", function(list, ax, ay)
	local live = JY.SubScene and JY.SubScene >= 0
	local door = SnrDoorOf()
	for _, t in ipairs(list) do
		local pid, x, y, d = t[1], t[2], t[3], t[4]
		x, y = SnrFixSpot(pid, x, y)
		if door then
			AddPerson(pid, door[3], door[4], 0)
			if live then SnrStraight(pid, door[3], door[4], door[1], door[2]); SnrSetPos(pid, door[1], door[2]); SnrWalk(pid, x, y) end
			SnrSetPos(pid, x, y, d); DrawSMap(); ShowScreen()
			goto nextone
		end
		do
		local b = SnrAcross(x, y, ax, ay)
		local px, py = x - 2 * b, y - b          -- 자기 자리와 같은 깊이의 통로 위 점
		local n = SnrOffSteps(px, py)
		AddPerson(pid, px - 2 * n, py + n, 0)
		if live then
			SnrWalk(pid, px, py)                                   -- 통로 따라 들어옴
			SnrWalk(pid, x, y)                                     -- 가구 피해 자기 자리로
		end
		for _, w in pairs(JY.Smap) do if w[1] == pid then w[2] = x; w[3] = y; w[4] = d end end
		DrawSMap(); ShowScreen()
		end
		::nextone::
	end
end)
-- 출진 준비(원작에 없음, 긴 연속 전투 구간에만): 군막에 주인공, 화면 단추로 장비·도구상, 주인공을 누르면 출진 확인
G("SnrPrepShow", function(shop)
	JY.Smap = {}
	JY.Base["\129\68\130\119\129\67"] = shop
	AddPerson(1, 25, 9, 1)
	SetSceneID(95)
	DrawStrBoxCenter("\133\098\129\103 \131\101\130\080")
	DrawMulitStrBox("\129\077\130\077 \137\106\136\108\129\102 \139\073\131\087 \131\097\130\080\135\122 \129\068\130\119\130\104 \129\070\130\080\129\088 \129\113 \132\079\129\075\129\076\129\077.*\131\101\130\080\129\094 \132\067\129\065 \130\075\130\084\129\083 \141\083\133\101 \133\098\129\103\129\097\135\073\130\086\129\091.")
end)

-- 건물 방문 → 5.0식 대화 (bld2talk.pl): 원작의 "\129\119\131\065\129\102 \131\082\130\083\129\094 \131\091 \130\111 \129\106\131\065\129\123 \130\095\129\064"를, 그 인물을 지금 장면에 세워 두고 말을 거는 것으로 바꿨다.
-- SnrExtra(pid, d) = 지금 장면에 없으면 빈자리에 세움. 자리 = 이 방에서 대본이 실제로 써 온 자리(SnrSpots, bld2talk 가 파일 끝에 붙임) 중
-- 아무도 안 선 곳, 없으면 막힌 칸(SnrBlock)이 아닌 가장 가까운 칸
-- 주인(1번)을 바라보는 방향 (10-06 사용자: 부인이 엉뚱한 곳을 보고 있었음)
local function SnrFaceHost(x, y, d)
	for _, v in ipairs(JY.Smap) do if v[1] == 1 then
		local bd, bv
		for dd = 0, 3 do local val = SDX[dd] * (v[2] - x) + 4 * SDY[dd] * (v[3] - y); if not bv or val > bv then bd, bv = dd, val end end
		return bd
	end end
	return d
end
G("SnrExtra", function(pid, d)
	for _, v in ipairs(JY.Smap) do if v[1] == pid then return end end
	if JY.Dark and JY.SubScene and JY.SubScene > 0 then DrawSMap(); Light() end   -- 세이브에서 이 단계 처음을 불러오면 화면이 어두운 채라 (10-06 394 시험 세이브)
	local used = {}
	for _, v in ipairs(JY.Smap) do used[v[2] .. "," .. v[3]] = true end
	local S = rawget(_G, "SnrSpots") and SnrSpots[SnrBg()] or {}
	for _, s in ipairs(S) do
		local ok = not used[s[1] .. "," .. s[2]]
		-- 바로 옆 칸에 다른 사람이 있으면 피함 (겹쳐 보이지 않게)
		if ok then for _, v in ipairs(JY.Smap) do if math.abs(v[2] - s[1]) + math.abs(v[3] - s[2]) < 2 then ok = false break end end end
		if ok then
			local fx, fy = SnrFixSpot(pid, s[1], s[2]); local fd = SnrFaceHost(fx, fy, d or s[3])
			if JY.SubScene and JY.SubScene > 0 then SnrEnter(pid, fx, fy, fd) else AddPerson(pid, fx, fy, fd) end   -- 문으로 걸어 들어옴 (10-06 사용자: 순간이동으로 나타났음)
			return
		end
	end
	local B = SnrBlk() or {}
	for r = 0, 12 do
		for dx = -r, r do for dy = -r, r do
			local x, y = 15 + dx, 12 + dy
			if math.abs(dx) + math.abs(dy) == r and x >= 1 and y >= 1 and not B[x .. "," .. y] and not used[x .. "," .. y] then AddPerson(pid, x, y, d or 1) return end
		end end
	end
end)

-- 좌석에서 곧게 들고 나기 (10-06, 5.0 유비판 방식): 5.0 대본은 줄에 선 사람을 그 줄을 따라 곧게 화면 밖으로 내보내고(MovePerson(64,10,2)),
-- 들어오는 사람도 줄 끝 화면 밖에서 곧게 들여온다. 좌석표(seat50.pl)가 좌석마다 가구를 안 지나는 곧은 방향을 SnrSeatExit 로 붙여 둠.
-- 그 좌석에 서 있으면 퇴장·문앞·등장을 이 곧은 길로 하고, 없으면 예전 길찾기(문·통로).
-- 방향이 둘이면 길 위에 다른 사람이 적은 쪽(같으면 출입 쪽에 가까운 쪽 = 표 순서)
G("SnrExitD", {})   -- 문앞(SnrToDoor)에서 멈춘 사람의 나가는 방향 → 이어지는 SnrLeave 가 같은 방향으로 마저 나감
local SnrOpp = {[0] = 1, 0, 3, 2}
local function SnrGone(x, y) local px, py = 11 + 18 * x, 3 + 18 * y; return px + 32 < 0 or px - 32 > 640 or py < 0 or py - 64 > 400 end
local function SnrStepsOut(x, y, d) local n = 0; repeat n = n + 1 until n > 40 or SnrGone(x + SDX[d] * n, y + SDY[d] * n); return n end
local function SnrSeatOpts(x, y)
	local rx, ry = math.floor(x + 0.5), math.floor(y + 0.5)
	if math.abs(x - rx) > 0.05 or math.abs(y - ry) > 0.05 then return nil end
	local T = rawget(_G, "SnrSeatExit"); T = T and T[SnrBg()]
	return T and T[rx .. "," .. ry], rx, ry
end
local function SnrPickExit(pid, x, y, o)
	-- 10-06 (사용자: 출입구와 전혀 다른 방향으로 나감): 곧은 길은 출구 쪽으로 가장 곧장 향하는 방향일 때만. 아니면 nil → 문까지 걸어가는 예전 길
	local D = rawget(_G, "SnrDoors"); D = D and D[SnrBg()]
	local ex, ey = -4, 24   -- 문 없는 방 = 5.0 처럼 왼쪽 아래로
	if D then ex, ey = D[3], D[4] end
	local best, bv
	for dd = 0, 3 do local v = SDX[dd] * (ex - x) + 4 * SDY[dd] * (ey - y); if not bv or v > bv then best, bv = dd, v end end
	local bd, bn, bc
	for i = 1, #o, 2 do
		local d, n, c = o[i], o[i + 1], 0
		if d ~= best then goto skip end
		-- 문이 있는 방(10-06 사용자: 줄 따라 곧게 나가면 문과 상관없는 데로 감, 통로로 들어서 문으로): 곧은 길이 문 바깥 점 가까이(통로 줄 위)를 지날 때만
		if D then
			local wx, wy = D[3] - x, 2 * (D[4] - y); local ddx, ddy = SDX[d], 2 * SDY[d]
			local pr = wx * ddx + wy * ddy; local dist2 = wx * wx + wy * wy - pr * pr / (ddx * ddx + ddy * ddy)
			if dist2 > 20 then goto skip end
		end
		for _, w in pairs(JY.Smap) do
			if w[1] ~= pid then
				for t = 0.5, n, 0.5 do if math.abs(w[2] - (x + SDX[d] * t)) < 1.1 and math.abs(w[3] - (y + SDY[d] * t)) < 0.6 then c = c + 1; break end end
			end
		end
		if not bc or c < bc then bd, bn, bc = d, n, c end
		::skip::
	end
	return bd, bn
end
local function SnrPosOf(pid) for _, v in pairs(JY.Smap) do if v[1] == pid then return v[2], v[3] end end end
-- 곧게 나감: 했으면 true
local function SnrStraightOut(pid)
	local x, y = SnrPosOf(pid)
	if not x then return false end
	local m, d, n = SnrExitD[pid], nil, nil
	SnrExitD[pid] = nil
	if m and math.abs(m[2] - x) < 0.05 and math.abs(m[3] - y) < 0.05 then d = m[1]; n = SnrStepsOut(x, y, d)
	else
		local o, rx, ry = SnrSeatOpts(x, y)
		if not o then return false end
		x, y = rx, ry
		d, n = SnrPickExit(pid, x, y, o)
		if not d then return false end
	end
	MovePerson(pid, n, d)
	DecPerson(pid); DrawSMap(); ShowScreen()
	return true
end
local SnrLeaveBase = SnrLeave
G("SnrLeave", function(ids, ax, ay)
	for _, pid in ipairs(ids) do if not SnrStraightOut(pid) then SnrLeaveBase({pid}, ax, ay) end end
end)
-- 문 앞까지: 나가는 줄을 따라 화면 가장자리 앞(몸이 다 보이는 데)까지
local SnrToDoorBase = SnrToDoor
G("SnrToDoor", function(ids, ax, ay)
	local rest = {}   -- 좌석 곧은 길이 없는 사람은 한꺼번에 예전 문 앞 줄서기(두 줄)로 (10-06: 한 명씩 불러 늘 1열이 됐음)
	for _, pid in ipairs(ids) do
		local x, y = SnrPosOf(pid)
		local o, rx, ry
		if x then o, rx, ry = SnrSeatOpts(x, y) end
		local d, n
		if o then d, n = SnrPickExit(pid, rx, ry, o) end
		if d then
			local k = 0
			while k < n do
				local nx, ny = rx + SDX[d] * (k + 1), ry + SDY[d] * (k + 1)
				local px, py = 11 + 18 * nx, 3 + 18 * ny
				if px < 40 or px > 600 or py < 70 or py > 392 then break end
				k = k + 1
			end
			if k > 0 then MovePerson(pid, k, d) end
			SnrSetPos(pid, rx + SDX[d] * k, ry + SDY[d] * k, d)
			SnrExitD[pid] = {d, rx + SDX[d] * k, ry + SDY[d] * k}
			DrawSMap(); ShowScreen()
		else rest[#rest + 1] = pid end
	end
	if #rest > 0 then SnrToDoorBase(rest, ax, ay) end
end)
-- 등장: 좌석의 곧은 길 끝(화면 밖)에서 걸어 들어옴
local function SnrStraightIn(pid, x, y, d)
	if not (JY.SubScene and JY.SubScene >= 0) then return false end
	x, y = SnrFixSpot(pid, x, y)
	local o = SnrSeatOpts(x, y)
	if not o then return false end
	local e, n = SnrPickExit(pid, x, y, o)
	if not e then return false end
	AddPerson(pid, x + SDX[e] * n, y + SDY[e] * n, SnrOpp[e])
	MovePerson(pid, n, SnrOpp[e])
	SnrSetPos(pid, x, y, d)
	DrawSMap(); ShowScreen()
	return true
end
local SnrEnterBase = SnrEnter
G("SnrEnter", function(pid, x, y, d) if not SnrStraightIn(pid, x, y, d) then SnrEnterBase(pid, x, y, d) end end)
local SnrEnterManyBase = SnrEnterMany
G("SnrEnterMany", function(list, ax, ay)
	for _, t in ipairs(list) do if not SnrStraightIn(t[1], t[2], t[3], t[4]) then SnrEnterManyBase({t}, ax, ay) end end
end)

-- 쓰러져 숨짐(10-06, 사용자: 유협이 시위 칼에 맞아 죽은 뒤 걸어 나갔음): 그 자리에서 깜빡이다 사라짐 (전투에서 부대가 쓰러질 때처럼).
-- snr2lua 가 바로 앞 상자·해설이 "\133\126\129\083 \134\069\130\091\161\164\136\096\133\101\136\107\161\164\133\089\130\088\161\164\133\126\131\070" 인 퇴장(18)을 SnrDie 로 냄
G("SnrDie", function(ids)
	for _, pid in ipairs(ids) do
		local keep
		for i, v in ipairs(JY.Smap) do if v[1] == pid then keep = v; break end end
		if keep then
			for _ = 1, 4 do
				DecPerson(pid); DrawSMap(); ShowScreen(); lib.Delay(110)
				table.insert(JY.Smap, keep); DrawSMap(); ShowScreen(); lib.Delay(110)
			end
			DecPerson(pid); DrawSMap(); ShowScreen(); lib.Delay(200)
		end
	end
end)
