-- ko 6.0 (10-30): 무장 인연 이벤트 (addon "kinship"). 설계: 개발용/문서/무장 인연 이벤트 설계안.md · 6.0 새 기능 4종 저장 칸 배분.md
--   정한 짝 30쌍이 이야기 전투(자유 · 마을 · 다시 전투 · 정벌 빼고)에 함께 나가 둘 다 살아서 이기면 셈 +1 (최대 15).
--   3 · 6 · 10 번째에 다음 자유 행동 화면(SMAP_MANUAL)에서 인연 장면 하나(한 번에 하나, 남은 것은 다음 전투 뒤).
--   보상: 1단계 둘 다 경험치 +50(99 넘지 않게) · 2단계 하 등급 도구 하나(가방이 차면 금 300) ·
--   3단계 「인연 연계」 = 둘이 같은 전투에 출진해 있으면 둘 다 공격 · 책략 피해 +10% (10-30 사용자: 이웃 칸이 아니라 같이 출진, 짝이 퇴각하면 꺼짐).
--   저장: 事件 317~331 (짝 2개 = 한 칸, 짝마다 6비트: 셈 4 + 단계 2). 0~499 라 회차마다 새로. 본 장면은 기기 공통 CC.koKinSeen.
--   대사 = kinship_data.lua (koKinData, 개발용/addon/kinship_part1~3.lua 를 합친 것).
-- Source: 개발용/addon/kinship_src.lua (UTF-8) → script/addon/kinship.lua (도구/free_hz.pl).
if not koNeeds("record") then return end
pcall(dofile,(rawget(_G,"koCamp") and koCamp.kinshipData) or CONFIG.ScriptPath.."addon/kinship_data.lua")   -- koKinData

local EV="\202\194\188\254"   -- 事件
local function fv(n) return JY.Base[EV..n] or 0 end
local function setv(n,v) JY.Base[EV..n]=v end
local P_LORD="\190\253\214\247"   -- 君主
local P_EXP="\190\173\209\233"   -- 经验
local P_ITEM="\181\192\190\223"   -- 道具
local BASE=317
local DUE={3,6,10}
local GIFT={53,54,29,48,50}   -- 하 등급 도구 (현상수배 POOL 하 등급과 같음)

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koKinSeen",default=""}

local function D() return rawget(_G,"koKinData") or {} end
local function slot(i) return BASE+math.floor((i-1)/2),((i-1)%2)*6 end
function koKinGet(i)   -- 셈, 단계
	local s,sh=slot(i)
	local v=math.floor(fv(s)/2^sh)%64
	return v%16,math.floor(v/16)
end
function koKinSet(i,cnt,st)
	local s,sh=slot(i)
	local o=math.floor(fv(s)/2^sh)%64
	setv(s,fv(s)+((st*16+cnt)-o)*2^sh)
end
local function dueOf(cnt) local d=0 for k,n in ipairs(DUE) do if cnt>=n then d=k end end return d end
local function story() return not (CC.koFree or CC.koTownBattle or CC.koReplay) end
local function ours(p) return JY.PersonNum>p and JY.Person[p][P_LORD]==1 end

-- 셈: 승리 때 출진해 끝까지 살아 있던 우리 편
local ready=false
koOn("war_won",function()
	if not story() then return end
	local alive={}
	for i=1,War.PersonNum do
		local v=War.Person[i]
		if not v.enemy and v.live and ours(v.id) then alive[v.id]=true end
	end
	for i,e in pairs(D()) do
		if alive[e.a] and alive[e.b] then
			local c,st=koKinGet(i)
			if c<15 then koKinSet(i,c+1,st) end
			if dueOf(c+1)>st then ready=true end
		end
	end
end)
koOn("record_load",function() ready=true return nil end)

local function seenAdd(i,st)
	local k=","..i.."."..st..","
	local s=CC.koKinSeen or ""
	if string.find(s,k,1,true) then return end
	CC.koKinSeen=(s=="" and "," or s)..i.."."..st..","
	if rawget(_G,"koSave") then pcall(koSave) end
end
function koKinSeenOf(i,st) return string.find(CC.koKinSeen or "",","..i.."."..st..",",1,true)~=nil end

local function reward(e,st)
	if st==1 then
		for _,p in ipairs({e.a,e.b}) do local P=JY.Person[p] P[P_EXP]=math.min(99,P[P_EXP]+50) end
		DrawStrBoxCenter(JY.Person[e.a]["\208\213\195\251"].." \161\164 "..JY.Person[e.b]["\208\213\195\251"].." \131\064\133\085\132\081 +50")
	elseif st==2 then
		local it=GIFT[math.random(#GIFT)]
		for _,p in ipairs({e.a,e.b}) do
			local P=JY.Person[p]
			for k=1,8 do if P[P_ITEM..k]==0 then P[P_ITEM..k]=it DrawStrBoxCenter(P["\208\213\195\251"].."\129\102\129\081 "..JY.Item[it]["\195\251\179\198"].." \129\097\131\118") return end end
		end
		if rawget(_G,"koSetGold") then koSetGold(koGold()+300) end
		DrawStrBoxCenter("\129\094\132\078\129\071 \129\094\131\068 \132\121 \130\095\131\078 \130\085\131\103 300\129\083 \133\086\132\107\129\077.")
	else
		DrawStrBoxCenter("\129\106\133\066 \133\066\132\084\129\094 \130\065\132\126\129\077! \138\101\129\071 \137\072\138\095 \133\098\129\103\129\097\129\065 \130\074\130\112 \161\164 \130\117\130\118 \137\088\129\066 +10%")
	end
end
-- 장면 하나 (기록 화면 다시 보기도 씀). give = 보상까지
function koKinPlay(i,st,give)
	local e=D()[i]
	if not (e and e.s and e.s[st]) then return end
	DrawStrBoxCenter("\129\106\133\066 \161\184"..e.title.."\161\185 "..st.." / 3")
	talk((table.unpack or unpack)(e.s[st]))
	if give then reward(e,st) end
	seenAdd(i,st)
end
local function showDue()
	ready=false
	if not story() then return end
	local list={}
	for i,_ in pairs(D()) do list[#list+1]=i end
	table.sort(list)
	local more=false
	for _,i in ipairs(list) do
		local e=D()[i]
		local c,st=koKinGet(i)
		if dueOf(c)>st and ours(e.a) and ours(e.b) then
			if more then ready=true return end   -- 남은 것은 다음에
			koKinSet(i,c,st+1)
			koKinPlay(i,st+1,true)
			more=true
		end
	end
end
do
	local se=rawget(_G,"SMapEvent")
	if type(se)=="function" then
		function SMapEvent(...)
			if ready and JY.Status==GAME_SMAP_MANUAL then
				local ok,err=pcall(showDue)
				if not ok then ready=false error(err,0) end
			end
			return se(...)
		end
	end
end

-- 인연 연계: 3단계 짝이 같은 전투에 살아 있으면 공격 · 책략 피해 +10%
local function linked(wid)
	if not story() or not (War and War.Person) then return false end
	local v=War.Person[wid]
	if not v or v.enemy or not ours(v.id) then return false end
	for i,e in pairs(D()) do
		local o=(e.a==v.id and e.b) or (e.b==v.id and e.a) or nil
		if o then
			local _,st=koKinGet(i)
			if st>=3 then
				local w=GetWarID(o)
				if w>0 and War.Person[w].live and not War.Person[w].hide and not War.Person[w].enemy then return true end
			end
		end
	end
	return false
end
koKinLinked=linked   -- 시험용
koKinShowDueT=function() ready=true showDue() end   -- 시험용
do
	local ah=rawget(_G,"WarAtkHurt")
	if type(ah)=="function" then
		function WarAtkHurt(pid,eid,...)
			local r=table.pack(ah(pid,eid,...))
			if type(r[1])=="number" and r[1]>0 and War.Person[eid] and War.Person[eid].enemy and linked(pid) then
				r[1]=math.floor(r[1]*1.1+0.5)
			end
			return table.unpack(r,1,r.n)
		end
	end
	local mh=rawget(_G,"WarMagicHurt")
	if type(mh)=="function" then
		function WarMagicHurt(wid,eid,...)
			local r=table.pack(mh(wid,eid,...))
			if type(r[1])=="number" and r[1]>0 and War.Person[eid] and War.Person[eid].enemy and linked(wid) then
				r[1]=math.floor(r[1]*1.1+0.5)
			end
			return table.unpack(r,1,r.n)
		end
	end
end

-- 기록 화면 「인연」 탭: 짝 · 이번 판 셈 · 단계, 본 장면은 기기 공통
local PER=15
local function rows() local t={} for i,_ in pairs(D()) do t[#t+1]=i end table.sort(t) return t end
local function tabPages() return math.max(1,math.ceil(#rows()/PER)) end
local function tabDraw(page,c)
	local t=rows()
	local n3,seen=0,0
	for _,i in ipairs(t) do local _,st=koKinGet(i) if st>=3 then n3=n3+1 end for s=1,3 do if koKinSeenOf(i,s) then seen=seen+1 end end end
	c.txt(c.ox+24,c.oy+60,"\129\073\131\097 \129\106\133\066 (\129\071\130\087 \130\125\132\121)",rawget(_G,"C_Name") or M_Yellow)
	c.rtext(c.ox+744,c.oy+60,"\129\106\133\066 \133\066\132\084 "..n3.." / "..#t.."   \132\118 \131\097\129\065 "..seen.." / "..(#t*3),M_Gray)
	local x=c.ox+24
	for r=1,PER do
		local i=t[(page-1)*PER+r]
		if not i then break end
		local e=D()[i]
		local y=c.oy+90+(r-1)*22
		local cnt,st=koKinGet(i)
		local nm=JY.Person[e.a]["\208\213\195\251"].." \161\164 "..JY.Person[e.b]["\208\213\195\251"]
		local mark="" for s=1,3 do mark=mark..((st>=s) and "\161\246" or "\161\245") end
		c.txt(x,y,mark,(st>=3) and M_Yellow or M_White)
		c.txt(x+60,y,nm,M_White)
		c.txt(x+260,y,"\161\184"..e.title.."\161\185",M_Gray)
		c.rtext(c.ox+744,y,"\137\072\138\095 \129\071\141\091 "..cnt.." / "..DUE[math.min(3,st+1)],M_Gray)
	end
end
if rawget(_G,"koRecTabs") then
	koRecTabs[#koRecTabs+1]={label="\129\106\133\066",per=1,n=tabPages,draw=tabDraw}
end
