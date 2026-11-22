-- ko 6.0 (10-30): 고사 재현 퍼즐 전투 2판 (addon "puzzle"). 설계: 개발용/문서/고사 재현 퍼즐 전투 설계안.md 9절
--   제목 「다른 모드 > 고사 재현 퍼즐」: 고사 8개. 2판(10-30 사용자 「진짜 퍼즐로」): 적은 대본대로만 움직이고(엔진 AI 6 = 제자리, 움직임은
--   턴마다 이 애드온이 옮김), 피해 · 승패는 규칙이 정한다 → 레벨 · 운이 아니라 위치 · 순서 · 타이밍으로 풀린다.
--   「대기」로 발동하는 규칙(고함 · 화공 · 깃발 · 다리 끊기)은 전투 메뉴의 대기 그대로(새 메뉴 없음). 열쇠 칸은 바닥에 표시(draw_overlay).
--   틀리면 이유 한 줄 → 「다시 하겠습니까?」. 두 번 실패하면 시작 설명에 실마리 한 줄.
--   새 기록(LoadRecord(0))에서 돌림 = 이야기 세이브와 무관. 사건 = Event[940] 준비 · [941] 시작 · [942] 전투 중.
--   자유 전투로 취급(CC.koFree = 이 애드온의 koFreeData 줄, 탭에는 안 보임): 도감 · 현상 · 각성 · 인연 셈에서 빠지고 자동 저장도 막힘.
--   임시 기록 事件 362 = 퍼즐 번호. 퍼즐 진행은 전투 중 기억(P)에만 있어 전투 중 저장을 불러오면 그 퍼즐을 처음부터.
--   기록 = 기기 공통 CC.koPuzzle2 (",\130\087\134\113:\138\090:\129\112,", 1판 기록 CC.koPuzzle 은 버림).
-- Source: 개발용/addon/puzzle_src.lua (UTF-8) → script/addon/puzzle.lua (도구/free_hz.pl). free · view 뒤. 1판 = addon/보관/puzzle_src_1판_1030.lua
if not koNeeds("free") then return end

local EV="\202\194\188\254"   -- 事件
local function fv(n) return JY.Base[EV..n] or 0 end
local function setv(n,v) JY.Base[EV..n]=v end
local P_LORD="\190\253\214\247"   -- 君主
local P_HP,P_MHP="\177\248\193\166","\215\238\180\243\177\248\193\166"   -- 兵力 最大兵力
local P_NAME="\208\213\195\251"   -- 姓名
local P_ITEM="\181\192\190\223"   -- 道具
local B_SORTIE="\181\208\190\252\179\246\187\247"   -- 敌军出击 (1 이면 엔진이 ai 0 · 2 를 공격형으로 바꿈)
local S_IDX=362
local E0=940

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koPuzzle2",default=""}

-- ---------------------------------------------------------------- 도우미 (좌표는 0부터, 엔진 War.Person.x · y 는 1부터)
local P={}   -- 지금 퍼즐 진행
local FAILS={}   -- 퍼즐마다 이번 실행에서 실패한 수 (실마리)
local function W(pid) local w=GetWarID(pid) if w and w>0 then return w end return nil end
local function U(pid) local w=W(pid) return w and War.Person[w] end
local function alive(pid) local v=U(pid) return v and v.live and not v.hide end
local function at(pid) local v=U(pid) if not v then return nil end return v.x-1,v.y-1 end
local function isAt(pid,x,y) local a,b=at(pid) return alive(pid) and a==x and b==y end
local function inRect(pid,x0,y0,x1,y1) local a,b=at(pid) return alive(pid) and a>=x0 and a<=x1 and b>=y0 and b<=y1 end
local function dist(p1,p2) local a,b=at(p1) local c,d=at(p2) if not (a and c) then return 99 end return math.max(math.abs(a-c),math.abs(b-d)) end
local function adj4(p1,p2) local a,b=at(p1) local c,d=at(p2) if not (a and c) then return false end return math.abs(a-c)+math.abs(b-d)==1 end
local function hpPct(pid) local Q=JY.Person[pid] if (Q[P_MHP] or 0)<=0 then return 0 end return Q[P_HP]*100/Q[P_MHP] end
local function free(x,y)
	if x<0 or y<0 or x>=War.Width or y>=War.Depth then return false end
	return GetWarMap(x+1,y+1,2)==0
end
local function tp(pid,x,y)   -- 칸 옮기기 (대본 움직임)
	local w=W(pid) if not w then return false end
	local v=War.Person[w]
	if not free(x,y) then return false end
	if not v.hide then SetWarMap(v.x,v.y,2,0) end
	v.x,v.y=x+1,y+1
	v.hide=false SetWarMap(v.x,v.y,2,w)   -- (WarShowArmy 는 그 병종이 못 서는 칸이면 옆으로 옮겨서 안 씀)
	v.ai=6 v.ai_dx=v.x v.ai_dy=v.y
	if not (P.fight and P.fight[pid]) then v.active=false end   -- 대본 적은 엔진 AI 로 움직이지 않게
	return true
end
local function stay(v) v.ai=6 v.ai_dx=v.x v.ai_dy=v.y end
local function fightOn(pid) local v=U(pid) if v then P.fight[pid]=true v.ai=1 v.active=true end end   -- 엔진 AI 로 맞붙음 (깨어남 · 화공 뒤 · 드러난 복병)
local function stun(pid,untilT) local v=U(pid) if v then P.stun[pid]=untilT v.troubled=true end end
local function stunned(pid,t) return (P.stun[pid] or 0)>=t end
local function kill(pid)
	local w=W(pid) if not w then return end
	JY.Person[pid][P_HP]=0
	WarResetStatus(w)
end
local function hit(pid,pct,msg)   -- 대본 공격: 최대 병력의 pct%
	local Q=JY.Person[pid]
	local d=math.floor(Q[P_MHP]*pct/100)
	if msg then WarDrawStrBoxDelay(msg,M_White) end
	if Q[P_HP]-d<=0 then kill(pid) else Q[P_HP]=Q[P_HP]-d end
end
local function fail(why) if not P.done then P.fail=why P.done=true P.endT=War.Turn JY.Status=GAME_WARLOSE end end
local function win() if not P.done then P.done=true P.won=true P.endT=War.Turn JY.Status=GAME_WARWIN end end
local function enemies() local t={} for i=1,War.PersonNum do local v=War.Person[i] if v.enemy and v.live and not v.hide then t[#t+1]=v end end return t end
local function say(pid,s) talk(pid,s) end
local function mustOf(p) return p.must or {p.leader} end

-- ---------------------------------------------------------------- 고사 표
-- ally/enemy: {pid,x,y,방향,레벨,병종[,숨음]}. 적은 모두 대본(ai 6 제자리). hp = {pid=병력} 고정.
-- 함수: setup(P) · turn(P,t) 턴 시작(우리 차례 앞) · act(P,pid,kind,target) 우리 행동 뒤(kind = wait · atk · magic) ·
--       hurt(P,apid,dpid,dmg) → 피해 · down(P,pid) 쓰러짐 · marks(P) → {{x,y,색}} · star2/star3 = {문구, function(P) end}
local YEL,RED,ORG,GRY,CYN=RGB(250,220,60),RGB(230,60,50),RGB(255,140,30),RGB(150,150,150),RGB(80,200,240)
local PZ={}

-- 1. 장판교의 장비 — 다리 지키기와 다리 끊기 (스크래치 sim_bridge.pl 로 맞춘 수: 고함 기절 2 · 쿨다운 3 · 범위 3, 끊기 7턴부터)
local BR={{23,15},{23,16}}
local SPAWN={[1]={{263,19,15},{264,19,16},{257,17,15}},[3]={{258,17,16},{277,16,15}},[5]={{68,19,16,true},{278,16,16}}}
PZ[1]={name="\131\097\130\070\132\087\131\080 \131\097\130\080",map=26,turns=11,leader=3,
	desc="\131\097\130\080 \143\101\132\083 \131\097\130\070\132\087\130\104 \130\067\137\109\129\077. \129\118\129\118\130\084\131\098 \133\120\131\071 \132\123\129\083 \130\105\130\102 \129\112\133\088\129\077 \129\111 \135\066\143\093 \129\077\129\117\132\083 \134\091\129\077.*\161\164 \131\076\129\071 \129\077\129\117 \130\110 \135\066(\142\087\133\121 \135\066)\129\102 \131\087\129\065 \129\078\129\079. \131\097\130\080\129\094 \133\109 \135\066\131\098 \135\102\137\111\129\077.*\161\164 \129\077\129\117 \135\066\129\102\131\087 \130\095\131\071 = \131\100\137\072: 3\135\066 \130\111 \131\076\129\071 2\129\112 \130\108\130\111 \136\102 \136\108\132\076\129\082 (3\129\112\129\102 \129\111 \130\087, \135\109\133\102\130\098 \138\094\130\067 \130\107\130\077).*\161\164 \131\097\130\080\129\094 \131\085\132\083 \139\073(\131\087\139\074)\131\080 \131\076\129\083 \132\081\129\065 1\135\066 \139\104\131\096\131\118\131\100 1\129\112 \136\102 \136\108\132\076\129\082.*\161\164 7\129\112\130\094\131\104 \129\077\129\117 \130\108\139\074 \139\091(\131\089\130\100 \135\066)\129\102\131\087 \130\095\131\071\129\097\129\065 \129\077\129\117\130\104 \141\099\131\100 \131\123\130\074.",
	hint="\129\078\133\088\129\117 : \131\100\137\072\131\098 \129\073\129\117\129\094 \129\077\129\117 \139\073\129\102 \140\069\131\098 \129\077\130\077\129\102. \131\100\137\072\129\083 \136\102 \136\096\130\098 \129\112\137\096 \130\110\133\085\129\111 \132\123\131\080 \129\077\129\117 \135\066\131\109\132\083 \139\090\132\125 \131\087\131\087 \139\073\131\080 \131\076\129\083 \138\080\130\102.",
	ally={{3,23,15,3,40,7}},
	enemy={{263,19,15,4,20,1},{264,19,16,4,20,1},{257,17,15,4,20,2},{258,2,2,4,20,2,1},{277,2,3,4,20,4,1},{68,2,4,4,28,7,1},{278,2,5,4,20,4,1}},
	setup=function(P) P.lastRoar=-9 P.roars=0 end,
	turn=function(P,t)
		for _,s in ipairs(SPAWN[t] or {}) do
			if t>1 then local x=s[2] while x>8 and not free(x,s[3]) do x=x-1 end tp(s[1],x,s[3]) end
			if s[4] then P.immune=s[1] end
		end
		if t>1 then
			local es=enemies() table.sort(es,function(a,b) return a.x>b.x end)
			for _,v in ipairs(es) do
				if not stunned(v.id,t) then
					local x,y=v.x-1,v.y-1
					if free(x+1,y) then tp(v.id,x+1,y) if x+1>=23 then fail("\129\118\129\118\130\084\129\071 \129\077\129\117\130\104 \129\119\129\072\138\088\129\077.") return end end
				end
			end
		end
	end,
	act=function(P,pid,kind,tgt)
		if pid~=3 then return end
		local x,y=at(3)
		if kind=="wait" then
			if x==24 and (y==15 or y==16) and War.Turn>=7 then say(3,"\129\071 \129\077\129\117\130\104 \141\099\130\083 \132\113\131\096\130\102! \129\118\129\118, \139\075\129\110\131\105 \129\129\129\065 \139\075\129\110\135\122 \137\125\130\102!") win() return end
			if x==23 and War.Turn-P.lastRoar>=3 then
				P.lastRoar=War.Turn P.roars=P.roars+1
				say(3,"\131\095\129\094 \131\085\132\083 \133\066\129\106 \131\097\133\083\135\086\129\071\129\077! \131\099\133\126\129\071 \129\110\135\080\130\067 \130\107\131\098 \140\078\131\098 \131\118\135\122\131\087 \132\125\143\066 \131\115\133\120!")
				local n=0
				for _,v in ipairs(enemies()) do if v.id~=P.immune and math.abs(v.x-1-x)<=3 and math.abs(v.y-1-y)<=3 then stun(v.id,War.Turn+2) n=n+1 end end
				WarDrawStrBoxDelay("\131\100\137\072\129\102 \131\076 "..n.."\130\094\130\095\129\094 \140\118\130\083\140\069\132\107\129\077!",M_White)
			end
		elseif kind=="atk" and tgt then
			local ex,ey=at(tgt)
			if ex==x-1 and ey==y then if free(ex-1,ey) then tp(tgt,ex-1,ey) end stun(tgt,War.Turn+1) end
		end
	end,
	hurt=function(P,a,d,dmg) return 1 end,
	marks=function(P) local m={} for _,c in ipairs(BR) do m[#m+1]={c[1],c[2],RED} end if War.Turn>=7 then m[#m+1]={24,15,YEL} m[#m+1]={24,16,YEL} end return m end,
	star2={"9\129\112 \130\111\129\102 \129\077\129\117 \141\099\131\071",function(P) return War.Turn<=9 end},
	star3={"\131\100\137\072 \131\111 \130\087 \129\071\129\097",function(P) return P.roars<=3 end}}

-- 2. 단기구주 — 감시를 피해 (11-07 배치 다시: 조운은 기병이라 숲에 못 들어감. 감시를 피하면 7턴, 무시하면 6턴, 하후은을 거치면 9턴. 틈 = 13줄 · 다리 앞 14줄)
local SLEEP={{79,11,10},{122,11,16},{68,19,15},{80,26,11},{63,33,19}}
PZ[2]={name="\134\077\131\071\130\119\130\075",map=25,turns=14,leader=54,
	desc="\129\110\130\091\130\104 \131\066\131\098 \129\118\135\083\129\071 \143\101\132\083 \131\076\129\103\129\083 \131\069\136\107\131\118\133\121\129\077. \129\091\135\077\139\074 \129\110\134\071 \133\088\129\083(\131\089\130\100 \135\066)\129\089\130\067.*\161\164 \135\100\136\101 \131\076\131\080 \138\101\130\082 2\135\066(\142\087\133\121 \135\066)\129\102 \131\082\130\083\131\087\129\065 \131\091 \133\120\129\117\129\102 \141\122\133\099\131\100 \131\091 \131\076\129\071 \141\090\130\083\131\118 \139\075\129\110\134\091\129\077. \141\090\130\083\130\113 \131\076\129\071 \143\071\129\071 \132\067\129\065 \134\097\130\110\132\067\130\083 \129\078\129\079.*\161\164 \129\077\129\117 \139\073 \140\065\138\097\131\071\131\080 \129\097\133\067\131\098\129\102\129\081\130\098 \135\078\130\086\129\094 \130\097\129\077. \129\097\133\067\131\098\129\083 \136\096\133\101\132\093\129\117\129\065 \137\082\130\073\136\086\129\083 \133\086\130\083 \129\118\135\083\131\080 \130\074\130\112\129\071 \131\111 \134\099\129\094 \136\089\129\077.",
	hint="\129\078\133\088\129\117 : \144\101\139\074 \142\087\133\121 \135\066 \130\114\129\071\131\080 \129\111 \132\123 \140\111\131\109\132\083 \131\118\129\094 \130\110\132\083 \137\066\131\100, \129\077\129\117 \139\073\129\068 \142\087\133\121 \135\066 \129\110\134\071 \129\111 \132\123\132\083 \130\067\131\118\130\102.",
	ally={{54,6,11,4,36,7}},
	enemy={{79,11,10,4,30,7},{122,11,16,4,30,7},{68,19,15,4,30,7},{80,26,11,4,30,7},{63,33,19,4,30,1},{136,23,19,4,26,11}},
	hp={[136]=400},
	setup=function(P) P.woke={} P.sword=false local Q=JY.Person[54] Q[P_HP]=math.floor(Q[P_MHP]*0.5) end,
	act=function(P,pid,kind,tgt)
		if pid~=54 then return end
		for _,s in ipairs(SLEEP) do
			if alive(s[1]) and not P.woke[s[1]] and dist(54,s[1])<=2 then P.woke[s[1]]=true fightOn(s[1]) say(s[1],"\133\102\140\078\129\071\129\077! \129\118\135\083\129\071\129\077!") end
		end
		local n=0 for p,_ in pairs(P.woke) do if alive(p) then n=n+1 end end
		if n>=3 then fail("\141\090\130\083\130\113 \131\076\129\102\129\081 \134\097\130\110\132\067\132\107\129\077.") return end
		if inRect(54,31,21,33,23) then win() end
	end,
	stopAt=function(P,pid,x,y)   -- 빨간 칸은 지나쳐 갈 수 없음 (기병 이동 6 이면 5칸 폭을 한 번에 건너뜀)
		if pid~=54 then return false end
		for _,s in ipairs(SLEEP) do if alive(s[1]) and not P.woke[s[1]] and math.abs(x-s[2])<=2 and math.abs(y-s[3])<=2 then return true end end
		return false
	end,
	hurt=function(P,a,d,dmg) if a==54 and P.sword then return dmg*3 end return dmg end,
	down=function(P,pid) if pid==136 and not P.sword then P.sword=true say(54,"\129\091, \129\071 \136\086\131\098\161\173\161\173? \137\082\130\073\136\086\129\071\130\102. \135\100\130\086 \140\102\131\096 \136\096\134\121\129\077!") end end,
	marks=function(P)
		local m={} for x=31,33 do for y=21,23 do m[#m+1]={x,y,YEL} end end
		for _,s in ipairs(SLEEP) do if alive(s[1]) and not P.woke[s[1]] then for dx=-2,2 do for dy=-2,2 do m[#m+1]={s[2]+dx,s[3]+dy,RED} end end end end
		return m end,
	star2={"9\129\112 \130\111\129\102",function(P) return War.Turn<=9 end},
	star3={"\129\110\129\073\129\068 \141\090\131\079\130\067 \130\107\130\077",function(P) return next(P.woke)==nil end}}

-- 3. 박망파 화공 — 유인 순서
local FIRE={12,8,20,11}
local XIA={17,63,116,218,263}
PZ[3]={name="\136\123\136\111\134\086 \129\064\130\074",map=22,turns=14,leader=126,boss=17,
	desc="\129\097\133\067\135\093\131\080 \130\095\130\084\129\083 \136\123\136\111\134\086 \140\065\138\097\131\071(\130\075\130\085 \135\066)\132\083 \136\110\130\083\131\082\129\098\130\102.*\161\164 \129\097\133\067\135\093 \129\073\129\117\130\098 10\135\066 \130\111\131\080 \129\094\131\097 \129\094\129\089\135\083 \131\079\129\117 \132\075\129\083 \134\089\129\066 \129\112\133\088\129\077 3\135\066\143\093 \134\091\129\077.*\161\164 \131\079\129\117 \132\075\129\071 \131\076\129\083 \132\081\129\065 \137\072\129\070\129\083 \131\080\134\100\129\066 3\135\066 \131\065\133\101\130\113\129\077.*\161\164 \129\097\133\067\135\093\129\123 \138\101 \129\071\129\067\129\071 \140\065\138\097\131\071\129\102 \132\079\129\083 \132\085 \129\100\135\121\132\088\129\071 \130\095\131\071\129\097\129\065 \129\064\130\074(\140\065\138\097\131\071 \130\111 \131\076 \130\126\131\125 70% \140\079\131\100 2\129\112 \136\102 \136\108\132\076\129\082). \131\091 \135\068\132\083\130\098 \138\071\140\069\130\098\129\077.",
	hint="\129\078\133\088\129\117 : \129\118\135\083 \129\097\131\118\132\086 \134\119\138\089\132\083 \139\073\129\102 \130\091\131\100, \132\081\130\067 \136\124\131\100 \129\112\133\088\129\077 \131\065\133\101\131\118\134\066 \140\065\138\097\131\071 \131\087\139\074 \139\091\129\089\130\067 \136\110\130\083\130\102.",
	ally={{126,2,9,4,30,16},{54,10,9,4,32,7},{2,6,8,4,32,7},{3,6,10,4,32,7}},
	enemy={{17,34,9,3,32,7},{63,35,10,3,28,1},{116,35,8,3,28,1},{218,36,9,3,28,7},{263,37,10,3,26,1}},
	must={126},
	setup=function(P) P.fired=0 P.burned=0 P.atkT=-1 end,
	turn=function(P,t)
		if P.fired>0 or t<=1 then return end
		if P.atkT==t-1 then
			for _,p in ipairs(XIA) do local x,y=at(p) if x and alive(p) then for k=3,1,-1 do if tp(p,math.min(39,x+k),y) then break end end end end
			WarDrawStrBoxDelay("\129\097\133\067\135\093 : \137\072\129\070\129\106\129\094\161\173\161\173? \131\065\133\101\131\087\130\102!",M_White) return
		end
		local tx=nil
		for i=1,War.PersonNum do local v=War.Person[i] if not v.enemy and v.live and not v.hide and dist(v.id,17)<=10 then if not tx or v.x-1>tx then tx=v.x-1 end end end
		if not tx then return end
		local es={} for _,p in ipairs(XIA) do if alive(p) then es[#es+1]=p end end
		table.sort(es,function(a,b) return (at(a))<(at(b)) end)
		for _,p in ipairs(es) do
			local x,y=at(p)
			for k=3,1,-1 do local nx=x-k if nx>tx and tp(p,nx,y) then break end end
		end
	end,
	act=function(P,pid,kind,tgt)
		if kind=="atk" or kind=="magic" then if P.fired==0 then P.atkT=War.Turn end return end
		if pid==126 and kind=="wait" and P.fired==0 and inRect(17,FIRE[1],FIRE[2],FIRE[3],FIRE[4]) then
			local n=0 for _,p in ipairs(XIA) do if inRect(p,FIRE[1],FIRE[2],FIRE[3],FIRE[4]) then n=n+1 end end
			if n>=3 then
				P.fired=War.Turn P.burned=n
				say(126,"\130\067\131\103\129\071\129\077! \133\100\129\083 \139\094\129\110\130\102!")
				for _,p in ipairs(XIA) do if inRect(p,FIRE[1],FIRE[2],FIRE[3],FIRE[4]) then local Q=JY.Person[p] Q[P_HP]=math.max(1,math.floor(Q[P_HP]*0.3)) stun(p,War.Turn+2) end end
				WarDrawStrBoxDelay("\140\065\138\097\131\071\129\102 \133\100\134\114\129\071 \132\081\129\193\131\116\129\077!",M_White)
				for _,p in ipairs(XIA) do fightOn(p) end
			end
		end
	end,
	marks=function(P) if P.fired>0 then return {} end local m={} for x=FIRE[1],FIRE[3] do for y=FIRE[2],FIRE[4] do m[#m+1]={x,y,ORG} end end return m end,
	star2={"8\129\112 \130\111\129\102",function(P) return War.Turn<=8 end},
	star3={"\129\064\130\074 \129\111 \130\087\129\102 \144\112 \129\071\129\067",function(P) return P.burned>=4 end}}

-- 4. 공성계 — 빈 성의 연극
local GATE={{23,9},{24,9}}
local TOWER={25,9}
local SIMA={214,257,258,263,264,277}
PZ[4]={name="\130\074\131\123\132\084",map=52,turns=11,leader=126,
	desc="\133\105 \131\123\129\102 \130\114\133\088\131\080\131\080 \130\095\130\084\129\071 \129\077\129\094\134\091\129\077. 10\129\112\129\083 \132\113\140\119\130\102.*\161\164 3\129\112\130\094\131\104 \131\089\130\126 \138\101\129\071 \131\123\133\090 \134\114(\131\089\130\100 \135\066 \138\101)\129\102, \129\100\135\121\132\088\129\071 \131\123\131\094(\134\086\130\100 \135\066)\129\102 \132\079\130\098 \130\108\130\111 \130\114\133\088\131\080\130\098 \130\068\130\126\129\083 \131\080\134\100\129\066 \129\077\129\094\129\091\130\067 \136\102\129\111\129\077.*\161\164 \134\117\129\094 \133\120\129\117\130\104 \130\080\131\079\134\069\131\118 \131\076\129\083 \132\081\129\065 \133\066\136\112\129\071 \131\082\132\119\131\118 \129\078\129\079.*\161\164 \131\097\129\087\132\086\131\098 \133\123\130\067 \130\107\130\098\129\077. \131\097\129\087\129\083 \132\081\130\098 \131\117\131\098 \131\082\132\119\131\118\130\067 \130\107\130\098\129\077.",
	hint="\129\078\133\088\129\117 : \131\097\129\087\131\098 8\129\112\129\102 \131\123\133\090 \139\073\129\102 \139\102\130\098\129\077. \131\091 \129\112\129\102 \131\123\133\090 \134\114\131\080 \131\089\130\126\129\071 \133\120\129\117\130\104 \130\067\137\109 \133\094 \131\097\129\087\129\083 \138\080\130\102.",
	ally={{126,25,9,3,30,16},{259,27,8,3,20,1},{260,27,10,3,20,1}},
	enemy={{214,3,9,4,40,16},{257,5,8,4,30,2},{258,5,10,4,30,2},{263,6,6,4,30,1},{264,6,12,4,30,1},{277,2,7,4,30,4},{103,2,2,4,30,22,1}},
	hp={[103]=1},
	setup=function(P) P.moved=false end,
	turn=function(P,t)
		if t>=3 then
			local ok=isAt(126,TOWER[1],TOWER[2])
			local g=0 for _,c in ipairs(GATE) do if isAt(259,c[1],c[2]) or isAt(260,c[1],c[2]) then g=g+1 end end
			if not ok or g<2 then fail("\131\123\133\090 \134\114\129\071\131\118 \131\123\131\094\129\094 \130\080\130\083 \133\066\136\112\129\071 \131\082\132\119\138\103\129\077.") return end
		end
		if t>=10 then say(214,"\161\173\161\173\130\068\130\126\129\071 \132\079\129\083 \131\117\129\071 \140\071\130\079\130\097\129\077. \130\066\130\084 \131\065\133\101\131\118\130\102!") win() return end
		for _,p in ipairs(SIMA) do local x,y=at(p) if x and x<14 then tp(p,math.min(14,x+3),y) end end
		if t==5 then tp(103,13,9) say(103,"\133\123\130\067 \130\107\130\098\129\077! \131\123\131\098 \189\249 \130\080\130\083 \132\079\129\077. \131\118 \130\099\133\120\131\087\130\102\129\068 \138\080\131\082\130\083\129\094\134\121\129\077!")
		elseif t>5 and alive(103) then
			local x,y=at(103)
			if x>=22 then fail("\131\097\129\087\129\071 \131\123\133\090\129\083 \140\067\132\107\129\077.") return end
			tp(103,math.min(22,x+3),y)
		end
	end,
	act=function(P,pid,kind,tgt)
		if pid==126 and not isAt(126,TOWER[1],TOWER[2]) then P.moved=true end
		if (kind=="atk" or kind=="magic") and tgt==103 and alive(103) then P.zhangBy=pid kill(103) say(pid,"\131\097\129\087, \129\098\131\071\130\098 \130\067\131\118\135\121 \129\113 \130\097\129\077!") return end   -- 장합은 한 번에 (엔진 회피로 빗나가지 않게)
		if (kind=="atk" or kind=="magic") and tgt and tgt~=103 then fail("\131\076\129\083 \138\080\131\087 \133\066\136\112\129\071 \131\082\132\119\138\103\129\077.") end
	end,
	down=function(P,pid) if pid==103 then P.zhangDown=true end end,
	marks=function(P) return {{GATE[1][1],GATE[1][2],YEL},{GATE[2][1],GATE[2][2],YEL},{TOWER[1],TOWER[2],CYN}} end,
	star2={"\131\089\130\126\129\071 \131\097\129\087\129\083 \136\096\133\101\132\093\130\079",function(P) return P.zhangBy==259 or P.zhangBy==260 end},
	star3={"\129\100\135\121\132\088\129\071 \131\123\131\094\130\104 \129\111 \130\087\129\068 \139\088\131\118\130\067 \130\107\130\077",function(P) return not P.moved end}}

-- 5. 정군산의 황충 — 망루를 먼저
local FLAG={15,7}
PZ[5]={name="\129\070\130\084\132\091\131\080 \130\085\135\116",map=39,turns=12,leader=170,boss=18,
	desc="\131\089\131\097 \130\085\135\116\129\071 \129\097\133\067\133\066\129\083 \131\089\131\106\129\077. \129\097\133\067\133\066\131\098 \129\103\130\067\129\102\131\087 \136\075\133\087\129\071\130\102 \131\115\132\119 \130\074\130\112\131\098 \134\069\131\080 \131\082\130\067 \130\107\130\098\129\077.*\161\164 \136\070\129\070\129\071 \136\111\131\094(\131\089\130\100 \135\066)\129\102\131\087 \130\095\131\071\129\097\129\065 \139\067\129\095\129\071 \129\091\130\106\131\100, \131\091 \129\112 \133\103\131\098 \130\108\130\111 \130\085\135\116\131\080 \130\074\130\112\129\071 \129\097\133\067\133\066 \130\126\131\125\131\080 \133\089\133\065 \132\124\129\081 \137\094\130\098\129\077.*\161\164 \136\111\131\094 \142\080 \134\088\130\126 \138\101\131\098 \136\070\129\070\129\071 2\135\066 \130\111\129\102 \129\091\129\065 \129\112\133\088\129\077 \160\133\129\077.",
	hint="\129\078\133\088\129\117 : \135\110\130\111\129\071 \134\088\130\126\129\083 \137\113\133\102 \132\081\131\079\131\100, \130\085\135\116\131\098 \129\097\133\067\133\066 \142\080\129\102\131\087 \131\071\129\077\132\126\129\077\129\094 \136\070\129\070\129\071 \139\067\129\095\129\083 \131\105\131\106 \131\085\132\083 \131\091 \129\112\129\102 \138\080\130\102. (\136\070\129\070\129\071 \137\113\133\102, \130\085\135\116\129\071 \131\118\130\101)",
	ally={{170,2,8,4,36,22},{188,3,9,4,32,3},{203,2,9,4,36,7}},
	enemy={{18,22,8,3,36,22},{276,14,6,4,20,4},{277,16,8,4,20,4}},
	hp={[276]=200,[277]=200},
	must={170,188},
	setup=function(P) P.flag=0 P.flags=0 end,
	turn=function(P,t)
		for _,a in ipairs({276,277}) do if alive(a) and alive(188) and dist(a,188)<=2 then hit(188,40,"\134\088\130\126\129\071 \136\070\129\070\129\083 \160\133\129\077!") end end
	end,
	act=function(P,pid,kind,tgt)
		if pid==188 and kind=="wait" and isAt(188,FLAG[1],FLAG[2]) then P.flag=War.Turn P.flags=P.flags+1 say(188,"\130\085 \131\097\130\084, \130\067\131\103\129\104\129\076\129\077! \139\067\129\095\129\083 \131\105\131\096\130\102!") end
	end,
	hurt=function(P,a,d,dmg)
		if d~=18 then return dmg end
		if a==170 and P.flag==War.Turn then return math.floor(JY.Person[18][P_MHP]*0.55)+1 end
		return math.floor(dmg/10)
	end,
	marks=function(P) return {{FLAG[1],FLAG[2],YEL}} end,
	star2={"8\129\112 \130\111\129\102",function(P) return War.Turn<=8 end},
	star3={"\139\067\129\095 \130\091 \130\087\131\109\132\083",function(P) return P.flags<=2 end}}

-- 6. 낙봉파 — 백마의 덫
local AMB={{11,18},{15,17},{20,19}}
local AMBP={196,195,197}
PZ[6]={name="\132\089\135\087\134\086",map=33,turns=13,leader=133,
	desc="\132\078\132\119\129\071 \137\095\134\114\132\083 \132\089\131\123\129\083 \137\066\129\110\133\121\129\077. \134\114 \130\083\142\090\129\094\129\102 \131\097\129\082\131\080 \130\068\130\126 \143\071\129\071 \133\126\130\083 \132\079\129\077.*\161\164 \131\079\129\117 \132\075\129\071 \130\068\130\126 \131\085\132\083 \142\080\129\102 \131\087\129\065 \130\068\130\126\129\071 \133\119\133\101\130\113\129\077.*\161\164 \132\078\132\119\129\071 \133\119\133\101\136\090 \130\068\130\126\131\098 \131\091 \133\120\129\117\129\102\131\087 \134\101\133\088\131\080 \132\078\132\119\129\102\129\081 \133\073\129\100 \130\114\130\112(\130\126\131\125 60%).*\161\164 \132\078\132\119\129\071 \130\108\139\074 \137\095(\131\089\130\100 \135\066)\129\102 \139\102\131\109\129\065 \131\123\130\074.",
	hint="\129\078\133\088\129\117 : \132\078\132\119\131\098 \144\089 \135\068\129\102. \130\110\133\066 \161\164 \130\085\135\116\129\071 \129\111 \135\066\143\093 \139\073\131\087 \130\064\131\109\134\066 \130\068\130\126\129\083 \137\113\133\102 \133\119\133\101\131\095\130\102.",
	ally={{133,2,18,4,30,16},{127,3,18,4,32,7},{170,2,19,4,32,22}},
	enemy={{196,11,18,3,30,4,1},{195,15,17,3,28,1,1},{197,20,19,3,28,1,1}},
	hp={[196]=600,[195]=500,[197]=500},
	act=function(P,pid,kind,tgt)
		for i,p in ipairs(AMBP) do
			local v=U(p)
			if v and v.hide and v.live then
				local a,b=at(pid)
				if a and math.max(math.abs(a-AMB[i][1]),math.abs(b-AMB[i][2]))<=1 then
					WarShowArmy(p-1) fightOn(p)
					if pid==133 then say(196,"\143\087 \136\124\129\083 \132\100 \133\120\129\077! \133\073\129\100\138\087 \144\103\129\110\130\102!") hit(133,60,"\130\068\130\126\129\071 \132\078\132\119\129\102\129\081 \133\073\129\100 \130\114\130\112!") P.shot=true
					else say(p,"\131\082\133\115\130\119\131\118! \138\080\130\102!") end
				end
			end
		end
		if inRect(133,27,17,31,21) then win() end
	end,
	marks=function(P) local m={} for x=27,31 do for y=17,21 do m[#m+1]={x,y,YEL} end end return m end,
	star2={"10\129\112 \130\111\129\102",function(P) return War.Turn<=10 end},
	star3={"\132\078\132\119\129\071 \129\111 \130\087\129\068 \138\071\130\067 \130\107\130\077",function(P) return not P.shot end}}

-- 7. 호뢰관 삼영전 — 셋이 함께 (이웃 형제 1 = 피해 0, 2 = 절반, 3 = 1.5배. 여포는 턴마다 이웃 형제 중 병력이 가장 낮은 이를 침)
local BRO={1,2,3}
local function broAdj() local n=0 for _,b in ipairs(BRO) do if alive(b) and adj4(b,5) then n=n+1 end end return n end
PZ[7]={name="\134\113\132\098\129\101 \129\124\129\126\130\066",map=1,turns=10,leader=1,boss=5,
	desc="\130\115\129\097\129\073\131\076 \129\098\134\097\129\094 \134\113\132\098\129\101\129\083 \131\118\138\088\129\077.*\161\164 \129\098\134\097\130\098 \129\073\134\096: \129\071\137\121\129\111 \136\069\129\100\129\094 \129\097\131\118\129\065 \137\088\129\066\129\094 \131\082\130\083\129\094\130\067 \130\107\131\100, \138\101\129\071\129\065 \133\089\133\065, \143\071\129\071\129\065 1.5\134\099.*\161\164 \129\098\134\097\130\098 \129\112\133\088\129\077 \129\071\137\121\129\111 \136\069\129\100 \130\101 \130\126\131\125\129\071 \129\094\131\097 \137\105\131\098 \129\071\130\104 \136\106\129\077.*\161\164 \129\098\134\097 \138\101\130\082(\131\089\130\100 \135\066) \130\091 \135\066\131\098 \131\100\132\065\129\123 \134\113\130\110\130\126\129\071 \135\102\131\100 \132\079\129\077.",
	hint="\129\078\133\088\129\117 : \134\113\130\110\130\104 \137\113\133\102 \132\081\132\069 \138\101\130\082 \135\066\129\083 \143\071 \130\080\131\079\131\100, \143\071\129\071 \132\071\131\098 \129\112\129\102 \138\101\133\101\137\106\131\087 \138\080\130\102.",
	ally={{1,8,13,2,40,1},{2,9,13,2,40,7},{3,10,13,2,40,7}},
	enemy={{5,6,7,1,40,7},{73,5,7,1,15,1},{263,7,7,1,15,1}},
	hp={[5]=2400,[73]=300,[263]=300},
	must={1,2,3},
	setup=function(P) P.hitBy={} end,
	turn=function(P,t)
		if t<=1 or not alive(5) then return end
		local low,lp=nil,999
		for _,b in ipairs(BRO) do if alive(b) and adj4(b,5) and hpPct(b)<lp then low,lp=b,hpPct(b) end end
		if low then hit(low,25,"\129\098\134\097\131\080 \132\078\130\115\129\064\136\112\129\071 "..JY.Person[low][P_NAME].."\129\083(\130\104) \131\089\131\106\129\077!") end
	end,
	act=function(P,pid,kind,tgt) if kind=="atk" and tgt==5 then P.hitBy[pid]=true end end,
	hurt=function(P,a,d,dmg)
		if d~=5 then return dmg end
		local n=broAdj()
		if n<=1 then WarDrawStrBoxDelay("\129\073\134\096! \130\099\133\120\131\087\130\098 \129\098\134\097\129\102\129\081 \137\088\129\066\130\104 \132\123 \129\113 \130\097\129\077",M_White) return 0 end
		if n==2 then return math.floor(dmg/2) end
		return math.floor(dmg*1.5)
	end,
	marks=function(P) local x,y=at(5) if not x or not alive(5) then return {} end return {{x-1,y,YEL},{x+1,y,YEL},{x,y-1,YEL},{x,y+1,YEL}} end,
	star2={"5\129\112 \130\111\129\102",function(P) return War.Turn<=5 end},
	star3={"\143\071 \130\090\130\091 \129\098\134\097\130\104 \130\074\130\112",function(P) return P.hitBy[1] and P.hitBy[2] and P.hitBy[3] end}}

-- 8. 화용도 — 조조의 길과 허저 붙잡기
local LANES={8,9,10}
PZ[8]={name="\129\064\132\111\129\068",map=22,turns=12,leader=2,
	desc="\131\076\133\087\129\102\131\087 \129\103 \129\118\129\118\129\094 \131\111 \135\121\134\071 \134\114 \130\101 \129\097\131\118\132\083 \131\087\139\074\131\109\132\083 \136\071\129\110\130\113\129\077. \133\066\131\071(\130\125\140\089 \135\066)\129\094 \129\091\130\106\130\098 \134\114\131\098 \137\088\129\111\129\077.*\161\164 \129\118\129\118 \139\073\129\102\130\098 \135\109\133\102\129\094 \133\109\129\077. \129\101\131\079\129\094 \129\118\129\118\130\104 \135\102\129\083 \132\085 \135\109\133\102\129\094 \129\101\131\079 \142\080\129\102 \132\079\131\109\129\065 \131\091 \140\111\129\102 \129\118\129\118\129\094 \131\069\136\107\131\118\133\121\129\077.*\161\164 \131\079\129\117 \132\075\129\071 \135\109\133\102 \142\080\129\102 \131\087\129\065 \135\109\133\102\130\098 \131\091 \133\120\129\117\129\102 \140\069\139\081\137\111\129\077.*\161\164 \129\101\131\079\129\094 \129\118\129\118 \142\080\129\102 \131\087\129\065 \139\094\129\110\132\123\130\067 \131\100\135\077\129\077. \129\118\129\118\129\094 \131\087\139\074 \139\091\129\102 \139\102\131\109\129\065 \129\078\129\079.",
	hint="\129\078\133\088\129\117 : \133\066\131\071\129\094 \130\097\130\098 \134\114\129\083 \143\070\130\083 \129\101\131\079\130\104 \131\091 \134\114 \139\073\129\102 \130\091\131\100, \129\101\131\119\129\071\131\118 \130\075\134\103\129\071 \137\113\133\102 \135\109\133\102 \142\080\129\102 \140\069\130\083\130\102.",
	ally={{2,15,9,3,36,7},{128,16,8,3,32,7},{155,16,10,3,32,1}},
	enemy={{68,36,9,3,30,7},{9,38,9,3,30,7}},
	setup=function(P)
		P.lane=LANES[math.random(3)]
		tp(68,36,P.lane) tp(9,38,P.lane)
	end,
	turn=function(P,t)
		if t<=1 or not alive(9) then return end
		local held=false
		for i=1,War.PersonNum do local v=War.Person[i] if not v.enemy and v.live and not v.hide and adj4(v.id,68) then held=true end end
		if alive(68) and not held then local x,y=at(68) for k=2,1,-1 do if tp(68,x-k,y) then break end end end
		local x,y=at(9)
		for k=2,1,-1 do if tp(9,x-k,y) then break end end
		local cx=at(9)
		if cx<=1 then fail("\129\118\129\118\129\094 \129\064\132\111\129\068\130\104 \131\069\136\107\131\118\137\116\129\077.") return end
		if alive(68) and adj4(68,2) and dist(9,2)<=2 then say(68,"\129\116\129\067, \130\083\131\087 \129\094\135\073\130\086\129\091! \129\101\131\079\130\098 \129\071 \135\109\133\102\129\094 \135\102\134\121\129\109!") fail("\135\109\133\102\129\094 \129\101\131\079\130\104 \135\102\130\098 \130\114\129\071 \129\118\129\118\129\094 \131\069\136\107\131\118\137\116\129\077.") end
	end,
	act=function(P,pid,kind,tgt)
		if P.done or not alive(9) or not alive(2) or not adj4(2,9) then return end
		say(9,"\129\101 \131\097\130\084, \130\067\130\113\131\083\131\080 \129\070\129\083 \129\096\130\069\129\066 \129\071 \129\118\129\118\130\104 \134\106\131\096 \130\075\130\086\129\091\161\173\161\173.")
		if WarDrawStrBoxYesNo("\129\118\129\118\130\104 \139\094\129\110\130\075\134\121\129\075\129\076\129\089?",M_White) then P.freed=true say(2,"\161\173\161\173\129\094\130\086\129\091. \129\071\131\117\131\109\132\083 \135\109\134\103\131\080 \131\098\131\112\130\098 \139\121\131\116\129\109.") win()
		else P.freed=false say(2,"\130\084\130\089\131\098 \130\084\130\089\129\071\129\091. \129\118\129\118, \130\069\129\091\129\097\130\086\129\091!") P.done=true P.won=true P.endT=War.Turn kill(9) JY.Status=GAME_WARWIN end
	end,
	marks=function(P) local m={} for _,y in ipairs(LANES) do if y~=P.lane then for x=20,30 do m[#m+1]={x,y,GRY} end end end return m end,
	star2={"6\129\112 \130\111\129\102",function(P) return War.Turn<=6 end},
	star3={"\129\118\129\118\130\104 \139\094\129\110\130\075\131\071 (\131\100\130\114)",function(P) return P.freed end}}
-- 6.0 (11-02) 이야기판: 이야기 모드면 영걸전 고사 대신 script/camp/<id>/puzzle_data.lua(koPuzzleStory = 그 이야기 고사 표)를 씀.
--   그 파일은 아래 koPzLib 도우미로 규칙을 짬(원본 = 개발용/camp_src/<id>/puzzle_data_src.lua). 표가 없으면 이 메뉴를 내지 않음.
koPzLib={W=W,U=U,alive=alive,at=at,isAt=isAt,inRect=inRect,dist=dist,adj4=adj4,hpPct=hpPct,free=free,tp=tp,stay=stay,
	fightOn=fightOn,stun=stun,stunned=stunned,kill=kill,hit=hit,fail=fail,win=win,enemies=enemies,say=say,
	YEL=YEL,RED=RED,ORG=ORG,GRY=GRY,CYN=CYN,HP=P_HP,MHP=P_MHP}
if rawget(_G,"koCamp") then
	koPuzzleStory=nil
	local ok,e=pcall(dofile,CONFIG.koCampScript.."puzzle_data.lua")
	koPuzzleErr=(not ok) and tostring(e) or false   -- 시험용
	if type(rawget(_G,"koPuzzleStory"))~="table" then return end
	PZ=koPuzzleStory
end
koPuzzleData=PZ   -- 시험용

-- ---------------------------------------------------------------- 기록
local function recGet(i) local s,t=string.match(CC.koPuzzle2 or "",","..i..":(%d+):(%d+),") return tonumber(s) or 0,tonumber(t) or 0 end
local function recPut(i,stars,turn)
	local s0,t0=recGet(i)
	if stars<s0 or (stars==s0 and t0>0 and turn>=t0) then return end
	local s=string.gsub(CC.koPuzzle2 or "",","..i..":%d+:%d+,",",")
	if s=="" then s="," end
	CC.koPuzzle2=s..i..":"..stars..":"..turn..","
	if rawget(_G,"koSave") then pcall(koSave) end
end
function koPuzzleRec(i) return recGet(i) end

-- 자유 전투 표 줄 (CC.koFree.idx 가 가리킴, 탭에는 안 보임)
local ROW={map=0,ch=99,name="\131\100\130\114 \129\115\129\114",turn=20,l2=-1,bgm=9,team={},enemy={},items={},golds={},puzzle=true}
koFreeData[#koFreeData+1]=ROW
local function rowIdx() for i,b in ipairs(koFreeData) do if b==ROW then return i end end return 0 end
local function cur() local i=fv(S_IDX) return PZ[i],i end
local function active() return CC.koFree and CC.koFree.puzzle and fv(S_IDX)>0 and P.p~=nil end
function koPuzzleActive() return active() end
function koPuzzleState() return P end   -- 시험용

-- ---------------------------------------------------------------- 사건
local function evPrep()   -- 준비
	local p,i=cur()
	if not p then JY.Status=GAME_START return end
	P={p=p,i=i,stun={},acted={},fight={},done=false}
	WarIni()
	DefineWarMap(p.map,"\131\100\130\114 \161\164 "..p.name,"1. \130\086\129\074 \129\069\130\088\131\080 \135\118\135\111\130\095\132\083 \139\069\131\071",p.turns,p.leader-1,p.boss and p.boss-1 or -1)
	for k=1,JY.PersonNum-1 do if JY.Person[k][P_LORD]==1 then JY.Person[k][P_LORD]=0 end end
	local team={}
	for _,a in ipairs(p.ally) do
		JY.Person[a[1]][P_LORD]=1
		for k=1,8 do JY.Person[a[1]][P_ITEM..k]=0 end   -- 장비 없이 (퍼즐은 규칙으로)
		if rawget(_G,"koFreeSetLevel") then koFreeSetLevel(a[1],a[5],a[6]) end
		for _,v in ipairs({a[1]-1,a[2],a[3],a[4],0,-1,0}) do team[#team+1]=v end
	end
	SelectTerm(1,team)
	local rows={}
	for _,e in ipairs(p.enemy) do for _,v in ipairs({e[1]-1,e[2],e[3],e[4],6,e[5],e[6],e[2],e[3],-1,e[7] and 1 or 0}) do rows[#rows+1]=v end end
	local enh=CC.Enhancement CC.Enhancement=false
	SelectEnemy(rows)
	CC.Enhancement=enh
	for _,e in ipairs(p.enemy) do
		if rawget(_G,"koFreeSetLevel") then koFreeSetLevel(e[1],e[5],e[6]) end
		local h=p.hp and p.hp[e[1]] if h then JY.Person[e[1]][P_MHP]=h JY.Person[e[1]][P_HP]=h end
		local v=U(e[1]) if v then stay(v) end
	end
	JY.Base[B_SORTIE]=0
	if p.setup then p.setup(P) end
	JY.Status=GAME_WMAP
	NextEvent()
end
local function evStart()   -- 시작
	local p,i=cur()
	PlayBGM(11)
	DrawMulitStrBox(p.desc)
	if (FAILS[i] or 0)>=2 and p.hint then DrawMulitStrBox(p.hint) end
	PlayBGM(14)
	NextEvent()
end
local function evMid()   -- 전투 중 (행동마다 · 턴마다 · 쓰러질 때)
	if fv(S_IDX)>0 and CC.koFree and CC.koFree.puzzle and P.p==nil then   -- 전투 중 저장을 불러옴: 진행 기억이 없으니 처음부터
		JY.Status=GAME_SMAP_AUTO JY.EventID=E0 return
	end
	if not active() or P.done then return end
	local p=P.p
	if (JY.Death or 0)>0 then
		if p.down then p.down(P,JY.Death) end
		for _,m in ipairs(mustOf(p)) do if JY.Death==m then fail(JY.Person[m][P_NAME].." \133\068\130\069 (\130\067\137\097\133\069 \129\088 \131\097\129\113)") return end end
		if p.boss and JY.Death==p.boss then P.done=true P.won=true P.endT=War.Turn end
		return
	end
	if JY.Status~=GAME_WMAP then return end
	-- 우리 편 대기: 행동을 마쳤고(active 아님) 이번 행동에 공격 · 책략이 없었음
	local w=War.SelID or 0
	local v=War.Person[w]
	if v and not v.enemy and v.live and not v.active and P.acted[w]~=War.Turn then
		P.acted[w]=War.Turn
		if p.act then p.act(P,v.id,"wait") end
	end
end
local function reg()   -- 6.0 이야기판: 이야기 대본이 Event 표를 통째로 바꾸므로 시작 · 불러오기 때 다시 걺
	Event[E0]=evPrep Event[E0+1]=evStart Event[E0+2]=evMid
end
reg()
function koPzWaitT(pid) if active() and P.p.act and not P.done then P.p.act(P,pid,"wait") end end   -- 시험용: pid 가 그 칸에서 대기
-- 턴 시작: 기절 정리 · 대본 움직임
koOn("turn_ready",function()
	if not active() or P.done then return nil end
	local t=War.Turn or 1
	for pid,u in pairs(P.stun) do local v=U(pid) if v then v.troubled=(u>=t) end if u<t then P.stun[pid]=nil end end
	for _,e in ipairs(enemies()) do if not P.fight[e.id] then e.active=false stay(e) end end   -- 대본 적은 이번 턴 움직이지 않음 (엔진은 ai 6 이 목표 칸에 닿으면 ai 4 로 바꿔 공격함)
	if P.p.turn then P.p.turn(P,t) end
	for _,e in ipairs(enemies()) do if not P.fight[e.id] then e.active=false end end   -- 이번 턴 새로 나온 적도
	if not P.done then for _,m in ipairs(mustOf(P.p)) do if not alive(m) then fail(JY.Person[m][P_NAME].." \133\068\130\069 (\130\067\137\097\133\069 \129\088 \131\097\129\113)") break end end end
	return nil
end)
-- 멈춤 칸 (고사의 stopAt: 그 칸에 들어서면 이동이 끝남, 엔진 ZOC 와 같은 자리에서 판정)
do
	local zoc=rawget(_G,"CheckZOC")
	function CheckZOC(id,x,y)
		if active() and P.p.stopAt and not P.done and War.Person[id] and P.p.stopAt(P,War.Person[id].id,x-1,y-1) then return true end
		return zoc(id,x,y)
	end
end
-- 우리 공격 · 책략
do
	local wa=rawget(_G,"WarAtk")
	function WarAtk(pid,eid,fl,...)
		local r=table.pack(wa(pid,eid,fl,...))
		if active() and not P.done and (fl or 0)==0 then
			local a,d=War.Person[pid],War.Person[eid]
			if a and d and not a.enemy and d.enemy then
				P.acted[pid]=War.Turn
				if P.p.act then P.p.act(P,a.id,"atk",d.id) end
			end
		end
		return table.unpack(r,1,r.n)
	end
	local wm=rawget(_G,"WarMagic")
	function WarMagic(wid,eid,...)
		local r=table.pack(wm(wid,eid,...))
		if active() and not P.done then
			local a,d=War.Person[wid],War.Person[eid]
			if a and not a.enemy then
				P.acted[wid]=War.Turn
				if P.p.act then P.p.act(P,a.id,"magic",d and d.id) end
			end
		end
		return table.unpack(r,1,r.n)
	end
	local ah=rawget(_G,"WarAtkHurt")
	function WarAtkHurt(pid,eid,...)
		local r=table.pack(ah(pid,eid,...))
		if active() and type(r[1])=="number" and P.p.hurt then
			local a,d=War.Person[pid],War.Person[eid]
			if a and d and not a.enemy and d.enemy then r[1]=math.max(0,math.min(P.p.hurt(P,a.id,d.id,r[1]),JY.Person[d.id][P_HP])) end
		end
		return table.unpack(r,1,r.n)
	end
end
-- 열쇠 칸 바닥 표시
koOn("draw_overlay",function()
	if not active() or not P.p.marks then return nil end
	local ok,m=pcall(P.p.marks,P)
	if not ok or not m then return nil end
	for _,c in ipairs(m) do
		local x,y=c[1]+1,c[2]+1
		if x>=War.CX and x<=War.CX+War.MW-1 and y>=War.CY and y<=War.CY+War.MD-1 then
			local left=War.OX+War.BoxWidth*(x-War.CX)
			local top=War.OY+War.BoxDepth*(y-War.CY)
			lib.Background(left+3,top+3,left+War.BoxWidth-3,top+War.BoxDepth-3,70,c[3])
		end
	end
	return nil
end)

-- 끝: 별 · 기록 · 다시 하기
koOn("war_end",function()
	if not (CC.koFree and CC.koFree.puzzle and fv(S_IDX)>0) then return nil end
	local p,i=P.p,P.i
	if not p then return nil end
	local won=P.won and not P.fail
	if P.endT then War.Turn=P.endT end   -- 엔진은 이긴 뒤에도 턴을 하나 올림: 별 · 기록은 끝난 턴으로
	local again=false
	if won then
		local stars=1
		if p.star2[2](P) then stars=2 end
		if stars==2 and p.star3[2](P) then stars=3 end
		recPut(i,stars,War.Turn or 1)
		PlayBGM(7)
		WarDrawStrBoxWaitKey("\131\100\130\114 \129\115\129\114 \161\184"..p.name.."\161\185 \131\123\130\074!  "..string.rep("\161\239",stars)..string.rep("\161\238",3-stars).."  ("..(War.Turn or 1).."\129\112)",M_White)
	else
		FAILS[i]=(FAILS[i] or 0)+1
		PlayBGM(4)
		WarDrawStrBoxWaitKey("\129\078\129\079 : "..(P.fail or "\129\100\129\111 \129\112\129\071 \130\067\138\103\129\077."),M_White)
		again=(not CC.koPzNoRetry) and WarDrawStrBoxYesNo("\129\077\130\086 \129\097\134\121\129\075\129\076\129\089?",M_White)
	end
	setv(S_IDX,0)
	CC.koFree=nil CC.koReplay=nil
	P={}
	if again and koPuzzleStart(i) then return nil end
	JY.Status=GAME_START
	return nil
end)
do
	local lr=rawget(_G,"LoadRecord")
	function LoadRecord(...)
		local r=lr(...)
		if fv(S_IDX)>0 and PZ[fv(S_IDX)] then CC.koFree={idx=rowIdx(),puzzle=true,started=true} CC.koReplay=true CC.Enhancement=true P={} reg() end
		return r
	end
end

-- 시작 (제목 화면에서, 또는 「다시 하기」)
function koPuzzleStart(i)
	local p=PZ[i]
	if not p then return false end
	LoadRecord(0)
	JY.Base["\211\206\207\183\196\163\202\189"]=1   -- 游戏模式 1
	if not SaveRecord(11) then JY.Status=GAME_START return false end
	LoadRecord(11) os.remove(CC.R_GRPFilename[11])
	reg()
	for k=1,JY.PersonNum-1 do GetPic(k) end
	CC.Enhancement=true CC.koReplay=true
	CC.koFree={idx=rowIdx(),puzzle=true,started=true}
	JY.Base["\206\222\211\195\053"]=0   -- 无用5: 코스트 없음
	JY.Base["\213\194\189\218\195\251"]="\131\100\130\114 \129\115\129\114"   -- 章节名
	JY.Person[1]["\195\216\188\1881"]=0   -- 秘技1 0
	setv(S_IDX,i)
	JY.Smap={} JY.SubScene=-1
	JY.Status=GAME_SMAP_AUTO
	JY.EventID=E0
	return true
end
local function pickMenu(desc,items)   -- 이야기 모드엔 view(삼형제 시점)가 꺼져 있어 그 고르기 창을 여기 둠
	if rawget(_G,"koViewPickMenu") then return koViewPickMenu(desc,items) end
	local m={}
	for i,s in ipairs(items) do m[i]={s,nil,1} end
	local r
	repeat
		DrawYJZBox(-1,70,desc,M_White,true)
		ShowScreen()
		r=ShowMenu(m,#m,0,0,0,0,0,2,0,16,M_White,M_White)
	until r and r>0
	return r
end
-- 제목 메뉴: 목록 → 설명 → 시작
function koPuzzleScreen()
	while true do
		lib.FillColor(0,0,0,0,0)
		local items={}
		local total=0
		for i,p in ipairs(PZ) do
			local s=recGet(i) total=total+s
			items[i]=i..". "..p.name.."  "..string.rep("\161\239",s)..string.rep("\161\238",3-s)
		end
		items[#items+1]="\137\066\129\110\129\094\131\071"
		local r=pickMenu("\131\100\130\114 \129\115\129\114 \143\082\136\066 : \129\070\129\066\129\103 \130\094\130\095\132\083 \129\071\138\075\130\113 \131\097\129\065\129\083 \135\118\135\111\130\095\132\083 \139\069\130\083\130\102.  \138\090 "..total.." / "..(#PZ*3),items)
		if r>#PZ then return end
		local p=PZ[r]
		lib.FillColor(0,0,0,0,0)
		local s,t=recGet(r)
		local info="\161\239\161\239 "..p.star2[1].." \161\164 \161\239\161\239\161\239 "..p.star3[1]..((s>0) and ("*\136\122\131\100 \131\071\133\108 "..string.rep("\161\239",s).." ("..t.."\129\112)") or "")
		if pickMenu("\161\184"..p.name.."\161\185*"..info,{"\130\086\129\074\129\111\129\077","\131\099\133\108\131\109\132\083"})==1 then
			if koPuzzleStart(r) then return end
		end
	end
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\131\100\130\114 \129\115\129\114 \143\082\136\066",run=function() koPuzzleScreen() end}
