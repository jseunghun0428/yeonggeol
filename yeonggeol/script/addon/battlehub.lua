-- 11-11 사용자 「무술 대회 · 자유 전투 · 정벌도 메인 화면으로, 전투 목록은 네 이야기 합쳐서」 (battlehub)
--  · 메인 화면 「전투」 묶음(campsel) → 모드를 고르고 이야기 칸을 누르면 그 이야기에서 그 모드가 바로 열림
--    (지금 이야기면 그대로, 다른 이야기면 ko_camp.txt + koSoftRestart). 요청 = 게임 폴더 battle_open.txt "\130\090\133\119\n\133\120\130\071 \130\066\132\101 \130\087\134\113".
--    이야기 타이틀이 뜰 때(title 훅) 요청을 읽어, 타이틀 목록(koTitleMenu)이 그 줄을 고른 것처럼 돌려줌. 끝나면 메인 화면으로.
--  · 이야기 타이틀의 무술 대회 · 자유 전투 · 정벌 줄은 숨김(메인 화면에만).
--  · 자유 전투 목록에 이야기 단추 넷(free.lua koFreeBattle 목록 화면): 다른 이야기 전투는 그 이야기가 마지막으로 열렸을 때 적어 둔 목록
--    (공용 저장 폴더 battlehub/free_<이야기>.lua, 없으면 배포본 script/addon/battlehub_free_<이야기>.lua)으로 보여 주고, 누르면 그 이야기로 바꿔 그 전투 설정 화면.
--  · 정벌 기록(공적 · 최고 기록 · 판 수 · 완주 수 · 레벨 · 난이도)은 네 이야기 공용(koSharedKeys). 처음 한 번 네 이야기 값을 합침
--    (공적 · 판 수 · 완주 수 = 더하기, 최고 기록 = 가장 좋은 것, 레벨 · 난이도 = 최고 기록 이야기 것).
local HB={}
rawset(_G,"koHub",HB)
HB.MODES={"yeonggeol","wuje","sunjian","yuanshao"}
HB.NAME={yeonggeol="\129\126\130\064\130\066",wuje="\129\073\129\100\130\066",sunjian="\135\089\134\084\130\066",yuanshao="\131\081\129\109\130\066"}
HB.KIND={tour="\129\073\131\072 \130\095\130\125",free="\133\120\130\071 \130\066\132\101",conq="\129\070\137\114"}
HB.LABEL={free="\133\120\130\071 \130\066\132\101",conq="\129\070\137\114"}   -- free.lua · conquest.lua 타이틀 줄 이름(같은 hz 바이트)
local REQ=CONFIG.CurrentPath.."battle_open.txt"
local function cur() return CONFIG.koCamp or "yeonggeol" end
HB.cur=cur
local function readAll(p) local f=io.open(p,"rb") if not f then return nil end local s=f:read("*a") f:close() return s end
local function writeAll(p,s) local f=io.open(p,"wb") if not f then return false end f:write(s) f:close() return true end
local function root() if CONFIG.koCamp then return string.sub(CONFIG.Save,1,#CONFIG.Save-#CONFIG.koCamp-1) end return CONFIG.Save end
local function settingsFile(m) if m=="yeonggeol" then return CONFIG.CurrentPath.."ko_settings.lua" end return root()..m.."/ko_settings.lua" end
local function readSettings(m)
	if m==cur() then return CC end
	local s=readAll(settingsFile(m)) if not s then return {} end
	local env={CC={}}
	local fn=load(s,"ko_settings","t",env)
	if fn then pcall(fn) end
	return env.CC
end
HB.readSettings=readSettings

-- ---- 정벌 기록 공용
local CQ={"koConqMerit","koConqBest","koConqBestPos","koConqRuns","koConqClears","koConqLv","koConqDiff","koConqShared"}
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqShared",default=0} end
if type(rawget(_G,"koSharedKeys"))=="table" then for _,k in ipairs(CQ) do table.insert(koSharedKeys,k) end end
function HB.conqMerge()
	if (CC.koConqShared or 0)==1 then return false end
	local merit,runs,clears,best,bpos,lv,diff=0,0,0,-1,0,nil,nil
	for _,m in ipairs(HB.MODES) do
		local c=readSettings(m)
		merit=merit+(tonumber(c.koConqMerit) or 0)
		runs=runs+(tonumber(c.koConqRuns) or 0)
		clears=clears+(tonumber(c.koConqClears) or 0)
		local b=tonumber(c.koConqBest) or 0
		if b>best then best=b bpos=tonumber(c.koConqBestPos) or 0 lv=c.koConqLv diff=c.koConqDiff end
	end
	CC.koConqMerit,CC.koConqRuns,CC.koConqClears=merit,runs,clears
	CC.koConqBest,CC.koConqBestPos=math.max(best,0),bpos
	if lv then CC.koConqLv=lv end
	if diff then CC.koConqDiff=diff end
	CC.koConqShared=1
	if rawget(_G,"koSave") then pcall(koSave) end
	return true
end

-- ---- 11-11 사용자 「무술 대회도 하나로」: 우승 · 연승 공용(최근 우승 = 무장 번호라 이야기마다 그대로). 처음 한 번 우승 더하기 · 연승 가장 큰 것
local TQ={"koTourWin","koTourStreak","koTourShared","koTourLastName"}   -- 최근 우승 = 이름(어느 이야기 무장이든, tourney.lua)
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koTourShared",default=0} end
if type(rawget(_G,"koSharedKeys"))=="table" then for _,k in ipairs(TQ) do table.insert(koSharedKeys,k) end end
function HB.tourMerge()
	if (CC.koTourLastName or "")=="" and (CC.koTourLast or 0)>0 and JY.Person[CC.koTourLast] then   -- 예전 기록(무장 번호)을 이름으로 한 번
		local ok,nm=pcall(function() return JY.Person[CC.koTourLast][string.char(208,213,195,251)] end)   -- 姓名
		if ok and nm then CC.koTourLastName=nm if rawget(_G,"koSave") then pcall(koSave) end end
	end
	if (CC.koTourShared or 0)==1 then return false end
	local w,st=0,0
	for _,m in ipairs(HB.MODES) do local c=readSettings(m) w=w+(tonumber(c.koTourWin) or 0) st=math.max(st,tonumber(c.koTourStreak) or 0) end
	CC.koTourWin,CC.koTourStreak,CC.koTourShared=w,st,1
	if rawget(_G,"koSave") then pcall(koSave) end
	return true
end

-- ---- 자유 전투 목록 사본 (이야기마다, 다른 이야기 화면에서 보려고). 11-11 「켜지는 게 느려짐」: 새 폴더를 만들면 PC 에서 cmd 가 떠서
--  느려지므로 이미 있는 세이브 폴더(영걸전 세이브 폴더)에 바로 둠: data/save/battlehub_free_<이야기>.lua
local function cachePath(m) return root().."battlehub_free_"..m..".lua" end
local function q(v) if type(v)=="string" then return string.format("%q",v) end return tostring(v) end
function HB.freeDump()
	local FD=rawget(_G,"koFreeData")
	if type(FD)~="table" then return nil end
	local L={"return {"}
	for i,b in ipairs(FD) do
		local nm=b.name or ""
		if b.koSide and rawget(_G,"koSideOpen") then local ok,o=pcall(koSideOpen,b) if ok and not o then nm=string.rep(string.char(163,191),3) end end
		local en={}
		for _,r in ipairs(b.enemy or {}) do en[#en+1]="{[11]="..(tonumber(r[11]) or 0).."}" end
		L[#L+1]="{i="..i..",ch="..(tonumber(b.ch) or 0)..",name="..q(nm)..",turn="..(tonumber(b.turn) or 0)
			..(b.tower and ",tower=true" or "")..(b.koSide and ",koSide=true" or "")..(b.koWho and (",koWho="..q(b.koWho)) or "")
			..",enemy={"..table.concat(en,",").."}},"
	end
	L[#L+1]="}"
	return table.concat(L,"\n").."\n"
end
local SAVED=false
function HB.freeSave()
	if SAVED then return end
	SAVED=true
	local s=HB.freeDump()
	if not s then return end
	local p=cachePath(cur())
	if readAll(p)==s then return end
	writeAll(p,s)
end
local LIST={}
function HB.freeList(m)
	if LIST[m] then return LIST[m] end
	local s=readAll(cachePath(m)) or readAll(CONFIG.ScriptPath.."addon/battlehub_free_"..m..".lua")
	local t={}
	local fn=s and load(s,"hubfree","t",{})
	if fn then local ok,r=pcall(fn) if ok and type(r)=="table" then t=r end end
	local out={}
	for _,b in ipairs(t) do b.koHub=m out[b.i]=b end
	LIST[m]=out
	return out
end
function HB.freeRec(m)
	local s=readSettings(m).koFreeRec or ""
	local t={}
	for a,b,c,d in string.gmatch(s,"(%d+):(%d+):(%d+):(%d+)") do t[tonumber(a)]={w=tonumber(b),l=tonumber(c),best=tonumber(d)} end
	return t
end
-- free.lua 목록 화면이 부름: 이야기 단추들
function koHubStories() local t={} for _,m in ipairs(HB.MODES) do t[#t+1]={id=m,name=HB.NAME[m]} end return t end
function koHubCur() return cur() end
function koHubFreeList(m) if not m or m==cur() then return nil end return HB.freeList(m) end
function koHubFreeRec(m) return HB.freeRec(m) end
function koHubFreeGo(m,idx) return HB.go("free",m,idx) end
function koHubGo(kind,m) return HB.go(kind,m,0) end   -- 무술 대회 · 정벌 첫 화면의 이야기 단추

-- ---- 모드 열기. 11-11 「이야기 메인(타이틀)을 거쳐 가는 게 부자연스러움」: 타이틀 목록을 거치지 않고 바로 그 화면을 부름.
--  전투가 시작되면(JY.Status 가 타이틀이 아님) 이번 타이틀은 그림 · 목록 없이 지나감(SKIP) → 본 루프가 바로 전투.
local SKIP,AFTER=false,false   -- AFTER: 메인 화면에서 시작한 전투가 끝나 타이틀로 오면 메인 화면으로
function HB.run(kind,idx)
	if kind=="tour" then PlayBGM(18) FightMenu()
	elseif kind=="free" then
		if (idx or 0)>0 then rawset(_G,"koFreeOpenSel",idx) end
		koFreeBattle()
		rawset(_G,"koFreeOpenSel",nil)
	elseif kind=="conq" then koConqScreen() end
	if JY.Status~=GAME_START then SKIP=true AFTER=true return true end
	return false
end
-- 메인 화면(campsel)이 부름: 자유 전투는 지금 이야기에서 바로(목록 안 이야기 단추로 다른 이야기), 전투가 시작되면 true
function koHubRun(kind) return HB.run(kind,0) end
function HB.go(kind,m,idx)
	m=m or cur()
	writeAll(REQ,kind.."\n"..tostring(idx or 0).."\n")
	if m==cur() then return "here" end
	if m=="yeonggeol" then os.remove(CONFIG.CurrentPath.."ko_camp.txt") else writeAll(CONFIG.CurrentPath.."ko_camp.txt",m.."\n") end
	if type(rawget(_G,"koSoftRestart"))=="function" and koSoftRestart() then return "gone" end
	os.remove(REQ)
	return "fail"
end
-- 메인 화면(campsel)이 부름: 무술 대회 · 정벌은 이야기 칸을 고른 뒤 — 요청만 적고, campsel 이 평소처럼 그 이야기로(같으면 그대로)
function koHubPick(kind) return writeAll(REQ,kind.."\n0\n") end
local function takeReq()
	local s=readAll(REQ)
	if not s then return nil end
	os.remove(REQ)
	local kind,idx=string.match(s,"^(%a+)%s+(%d+)")
	if not kind or not HB.KIND[kind] then return nil end
	return kind,tonumber(idx) or 0
end
koOn("title",function()
	pcall(HB.conqMerge) pcall(HB.tourMerge)
	pcall(HB.freeSave)
	while not SKIP do
		local kind,idx=takeReq()
		if not kind and AFTER and type(rawget(_G,"koMainScreen"))=="function" then AFTER=false koMainScreen() kind,idx=takeReq() end
		if not kind then break end
		if HB.run(kind,idx) then break end
		if type(rawget(_G,"koMainScreen"))~="function" then break end
		koMainScreen()   -- 그 모드를 나옴 → 메인 화면으로 (거기서 또 고르면 위에서 요청을 읽음)
	end
	return nil
end)
-- 메인 화면에서 바로 다른 이야기로 바뀌면 이 이야기의 title 훅까지 안 옴 → 메인 화면 들어갈 때도 목록 사본 · 정벌 합치기
do local rawMS=rawget(_G,"koMainScreen") if type(rawMS)=="function" then koMainScreen=function(...) pcall(HB.conqMerge) pcall(HB.tourMerge) pcall(HB.freeSave) return rawMS(...) end end end
-- 전투가 시작된 타이틀: 로고 · 밝히기 · 목록 건너뜀
do
	local rawTS,rawL=rawget(_G,"koTitleStill"),rawget(_G,"Light")
	if type(rawTS)=="function" then koTitleStill=function(...) if SKIP then return end return rawTS(...) end end
	if type(rawL)=="function" then Light=function(...) if SKIP then return end return rawL(...) end end
end
-- 11-13 제보 「자유 전투 출진하면 화면이 하얗게 되고 먹통」: 이야기 타이틀 줄 「메인 화면」(koAddon.titleMenu run)으로 메인 화면에 가서
--  자유 전투 · 정벌을 시작하면 YJZMain_sub 가 그 줄의 run() 뒤에 바로 끝나 koTitleMenu(SKIP 을 푸는 곳)를 다시 안 거침 → SKIP 이 남아
--  전투 중 Light() 가 계속 무시됨 → ShowScreen 이 JY.Dark 인 채 화면을 한 번도 안 내보냄(마지막 화면 · 빈 화면에서 멈춘 것처럼 보임).
--  타이틀 차례(YJZMain_sub)가 끝나면 어느 길이든 SKIP 을 풂.
do
	local rawYS=rawget(_G,"YJZMain_sub")
	if type(rawYS)=="function" then YJZMain_sub=function(...) local r={rawYS(...)} SKIP=false return (table.unpack or unpack)(r) end end
end
-- 타이틀 목록: 세 줄 숨기기 · 전투가 시작됐으면 아무 줄도 고르지 않음(-99)
local rawTM=koTitleMenu
local function rowOf(menu,label)
	for i,koM in ipairs(koAddon.titleMenu) do if koM.label==label then return 5+i end end
	return nil
end
koTitleMenu=function(menu,n,...)
	if SKIP then SKIP=false return -99 end
	if type(menu)=="table" and menu[5] and n==7+#koAddon.titleMenu then
		menu[5][3]=0
		for _,lb in pairs(HB.LABEL) do local r=rowOf(menu,lb) if r and menu[r] then menu[r][3]=0 end end
	end
	return rawTM(menu,n,...)
end
