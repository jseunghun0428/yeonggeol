-- ko 6.0 (11-01): 이야기 메인 화면 (addon "campsel"). 게임을 켜면 먼저 메인 화면 — 영걸전 · 원소전 · 손견전 · 무제전 로고가 2x2 로 나오고
-- 로고를 누르면 그 이야기의 타이틀. 각 타이틀 첫 목록 「메인으로」 = 메인 화면으로 돌아감.
-- 고른 이야기는 ko_camp.txt 에 씀(영걸전이면 지움) — config.lua 가 그 파일을 읽어 data/camp/<id> · script/camp/<id> · data/save/<id> 로
-- 바꾸고, 메인 화면은 마지막에 한 이야기에서 열림. 지금 불러온 이야기와 다르면 프로그램을 끄지 않고 같은 실행 안에서 다시 띄움(koSoftRestart).
-- 묶음(script/camp/<id>/camp.lua)이 없는 이야기는 안 보이고, 이야기가 하나뿐이면 메인 화면 없음.
-- 빌드: perl 개발용/도구/free_hz.pl < 개발용/addon/campsel_src.lua > script/addon/campsel.lua (게임 폴더에서)
local STORIES={-- 11-03 사용자 「무제전과 원소전 위치 바꿔」: 칸 순서는 이 순서, 로고 그림 번호는 pic(title_main.grp)
{id=nil,pic=0,name="\129\126\130\064\130\066"},
{id="wuje",pic=3,name="\129\073\129\100\130\066"},
{id="sunjian",pic=2,name="\135\089\134\084\130\066"},
{id="yuanshao",pic=1,name="\131\081\129\109\130\066"},
}
local function has(id)
	if not id then return true end
	local f=io.open(CONFIG.ScriptPath.."camp/"..id.."/camp.lua","r")
	if f then f:close() return true end
	return false
end
local LIST={}
for _,s in ipairs(STORIES) do if has(s.id) then LIST[#LIST+1]=s end end

-- koSoftRestart: 엔진이 처음 준 전역(config.lua 맨 앞에서 찍어 둔 koPristineG)으로 새 전역 표를 만들어 Lua 의 전역 표
-- (레지스트리 LUA_RIDX_GLOBALS = 2)로 바꿔 끼우고, 엔진이 켤 때처럼 config.lua → jymain.lua → JY_Main() 을 다시 돈다.
-- 앞 판의 함수 · 애드온 감싸기는 새 표에 하나도 안 남음. 앞 판 호출 스택(타이틀 메뉴)은 돌아오지 않고 그대로 남는다(게임 종료는 os.exit).
-- 새 판은 창을 다시 만들지 않고(jymain Config 가 koSoftBoot 를 봄) 타이틀 음악도 이어서, 메인 화면 없이 바로 그 이야기 타이틀(koMainDone).
-- 준비가 안 되면(옛 config.lua 등) false — 부른 쪽이 예전 방식(koRestart)으로.
function koSoftRestart()
	local P=rawget(_G,"koPristineG")
	local reg=rawget(_G,"debug") and debug.getregistry and debug.getregistry()
	if type(P)~="table" or type(reg)~="table" or reg[2]~=_G then return false end
	local G={}
	for k,v in pairs(P) do
		if type(v)=="table" then local c={} for a,b in pairs(v) do c[a]=b end G[k]=c else G[k]=v end
	end
	G._G=G
	G.koPristineG=P
	G.koSoftBoot={bgm=JY.CurrentBGM}
	G.koMainDone=true
	local cf=loadfile(CONFIG.CurrentPath.."config.lua","bt",G)
	if not cf then return false end
	if rawget(_G,"koTitleAnimRelease") then pcall(koTitleAnimRelease) end
	pcall(Dark)
	reg[2]=G
	local ok,err=pcall(cf)
	local mf=ok and G.CONFIG and loadfile(G.CONFIG.JYMain_Lua,"bt",G)
	if not mf then reg[2]=_G return false end
	mf()
	G.JY_Main()
	os.exit(0)
end

-- 메인 화면 (11-01 사용자 「로고 4개를 격자로, 로고를 눌러서 시작」): 화면 가득 2x2 칸에 이야기 로고(data/title_main.grp, 도구/메인화면_그림.py,
-- 그림 번호 = STORIES 의 pic). 마우스가 올라간(또는 방향키로 고른) 칸만 밝게, 나머지는 어둡게. 칸을 누르거나 Enter/Space 로 시작.
local CW,CH=380,236
local CELL={{4,2},{388,2},{4,242},{388,242}}-- STORIES 순서대로 칸 왼쪽 위
-- 11-03 사용자 「기능설정은 메인메뉴로 — 4개 모드에서 공통」: 가운데(네 칸이 만나는 곳)에 「기능 설정」 단추, F 키로도. 값은 공용 ko_settings.lua(jymain koSettingKeys)
local GRID_H,FOOTER_H=480,30
-- 11-11 사용자 「메인 메뉴를 그룹으로 묶어줘」 → 두 묶음 단추: 「장수 · 도감」(장수편집 · 신무장 등록 · 무장 도감 · 보물 도감), 「설정 · 저장」(기능 설정 · 저장 옮기기).
--  누르면 단추 위로 항목 목록이 펼쳐짐(항목을 누르면 그 화면, 바깥을 누르거나 Esc 면 닫힘). 함수가 없는 항목(휴대폰의 저장 옮기기 등)은 안 보임.
--  단축키는 그대로 바로: G 장수 관리(장수편집 · 신무장 고르기) · B 도감(무장 · 보물 고르기) · S 저장 옮기기 · F 기능 설정
-- Two levels share one compact panel; pop=0 is the category list.
local GROUPS={
{label="\130\066\132\101",items={{"\133\120\130\071 \130\066\132\101","#run:free"},{"\129\070\137\114","#run:conq"}}},
{label="\131\097\129\113",items={{"\131\097\129\113 \132\075\134\076","koGenEditScreen"},{"\131\078\129\073\131\097 \133\125\133\108","koNewGenScreen"}}},
{label="\129\068\135\078",items={{"\129\073\131\097 \129\068\135\078","koBookUnifiedScreen"},{"\131\115\131\065 \129\068\135\078","koBogamScreen"}}},
{label="\129\069\129\070",items={{"\131\071\131\077 \129\069\129\070","#setting"},{"\133\102\131\097 \139\090\131\071\131\071","koSaveAllScreen"}}},
}
local BX1,BX2,BY1,BY2=664,756,483,507
local POPW,ROWH=168,24
local FOOTNOTE="\129\071\133\069\131\071\130\104 \140\065\130\102 \134\117\130\106\135\073\130\086\129\091"
function koMainScreen()
	if #LIST<2 then return end
	local ok0=io.open(CONFIG.DataPath.."title_main.grp","rb")
	if not ok0 then return end
	ok0:close()
	local oldH=CC.ScreenH
	CC.ScreenH=GRID_H+FOOTER_H
	Config()
	PicCatchIni()
	lib.PicLoadFile(CONFIG.DataPath.."title_main.idx",CONFIG.DataPath.."title_main.grp",14)
	koTitleAnimReady=false koTitleStillReady=false-- slot 14 now holds the grid pictures; the title reloads its own
	local cells={}-- {story, picture, x, y}
	for i,s in ipairs(STORIES) do if has(s.id) then cells[#cells+1]={s,s.pic,CELL[i][1],CELL[i][2]} end end
	local sel=1
	for k,c in ipairs(cells) do if c[1].id==CONFIG.koCamp then sel=k end end
	local function at(k) local c=cells[k] return c[3],c[4],c[3]+CW,c[4]+CH end
	local function near(dx,dy)-- the cell in that direction from the chosen one (grid by position)
		local c=cells[sel]
		local best,bd=nil,1e9
		for k,o in ipairs(cells) do
			local ox,oy=o[3]-c[3],o[4]-c[4]
			if k~=sel and ((dx~=0 and ox*dx>0 and oy==0) or (dy~=0 and oy*dy>0 and ox==0)) then
				local d=math.abs(ox)+math.abs(oy) if d<bd then best,bd=k,d end
			end
		end
		return best
	end
	local pop=nil-- the group whose list is open
	local pick=nil-- 11-11 battlehub: a mode chosen from 「전투」, waiting for the story cell ("tour" · "free" · "conq")
	local PICKNAME={tour="\129\073\131\072 \130\095\130\125",free="\133\120\130\071 \130\066\132\101",conq="\129\070\137\114"}
	local function rows(g)
		local t={}
		for _,it in ipairs(GROUPS[g].items) do
			local ok=(it[2]=="#setting") or (string.sub(it[2],1,5)=="#hub:" and type(rawget(_G,"koHubPick"))=="function") or (string.sub(it[2],1,5)=="#run:" and type(rawget(_G,"koHubRun"))=="function") or type(rawget(_G,it[2]))=="function"
			if ok then t[#t+1]=it end
		end
		return t
	end
	local menuSel=1
	local menuMX,menuMY=MOUSE.x,MOUSE.y
	local function menuRows()
		if pop==0 then
			local t={}
			for g,G in ipairs(GROUPS) do if #rows(g)>0 then t[#t+1]={G.label,"#group:"..g} end end
			return t
		end
		local t={{"< \137\066\129\110\129\094\131\071","#back"}}
		for _,it in ipairs(rows(pop)) do t[#t+1]=it end
		return t
	end
	local function rowRect(i)
		local y=BY1-8-4*ROWH+(i-1)*ROWH
		return BX2-POPW+5,y,BX2-5,y+ROWH-1
	end
	local function menuPick(it)
		if string.sub(it[2],1,7)=="#group:" then pop=tonumber(string.sub(it[2],8)) menuSel=1 PlayWavE(0)
		elseif it[2]=="#back" then menuSel=pop pop=0 PlayWavE(0)
		else return it[2] end
	end
	-- Quiet gold accents; shared panel and left-aligned labels.
	local function button(x1,y1,x2,y2,label,on,solid)
		local hot,pressed=MOUSE.IN(x1,y1,x2,y2),MOUSE.HOLD(x1,y1,x2,y2)
		local active=hot or on or pressed
		if active then
			lib.FillColor(x1,y1,x2,y2,pressed and RGB(76,58,35) or RGB(55,44,31))
			lib.FillColor(x1,y1+5,x1+2,y2-5,RGB(215,179,111))
		end
		local ty=y1+math.floor((y2-y1-16)/2)+(pressed and 1 or 0)
		DrawString(x1+8,ty,label,active and RGB(255,231,180) or RGB(213,197,164),16)

	end
	local function drawGrid()
		lib.FillColor(0,0,0,0,0)
		for k,c in ipairs(cells) do
			local a1,b1,c1,d1=at(k)
			lib.PicLoadCache(14,c[2]*2,a1,b1,1)
			if k~=sel then lib.Background(a1,b1,c1,d1,150,M_Black)
			else lib.DrawRect(a1,b1,c1-1,d1-1,RGB(208,174,109)) end
		end
		lib.FillColor(0,GRID_H,CC.ScreenW,GRID_H+FOOTER_H,RGB(27,24,20))
		lib.FillColor(0,GRID_H,CC.ScreenW,GRID_H+1,RGB(104,84,53))
		if pick then DrawString(16,GRID_H+7,"\161\184"..PICKNAME[pick].."\161\185 \129\071\133\069\131\071\130\104 \131\100\130\106\135\073\130\086\129\091 (Esc \129\108\129\109)",RGB(255,232,170),16)
		else DrawString(16,GRID_H+7,FOOTNOTE,RGB(200,178,135),16) end-- 11-03 사용자 「기능설정 왼쪽 빈칸에 적절한 문구」
		button(BX1,BY1,BX2,BY2,"",pop~=nil)
		local col=pop~=nil and RGB(255,231,180) or RGB(213,197,164)
		for i=0,2 do lib.DrawRect(BX1+9,BY1+7+i*4,BX1+21,BY1+7+i*4,col) end
		DrawString(BX1+31,BY1+4,"\129\253\199\245",col,16)
		if pop~=nil then
			local R=menuRows()
			local px,py=BX2-POPW,BY1-8-4*ROWH-4
			lib.FillColor(px,py,BX2,BY1-4,RGB(29,26,22))
			lib.DrawRect(px,py,BX2,BY1-4,RGB(112,91,57))
			for i,it in ipairs(R) do
				local a,b,c,d=rowRect(i)
				if (MOUSE.x~=menuMX or MOUSE.y~=menuMY) and MOUSE.IN(a,b,c,d) then menuSel=i end
				button(a,b,c,d,it[1],menuSel==i,true)
			end
		end
		menuMX,menuMY=MOUSE.x,MOUSE.y
	end
	local mx,my=MOUSE.x,MOUSE.y
	koMouseReset()
	local go
	local function runItem(name)
		pop=nil
		PlayWavE(0)
		if string.sub(name,1,5)=="#hub:" then pick=string.sub(name,6) return end
		if string.sub(name,1,5)=="#run:" then   -- 11-11 「자유 전투는 바로, 이야기는 그 안의 단추로」: 지금 이야기에서 바로 (battlehub koHubRun)
			CC.ScreenH=oldH Config() PicCatchIni()
			if koHubRun(string.sub(name,6)) then return "battle" end   -- 전투 시작: 메인 화면을 닫고 본 루프로
			CC.ScreenH=GRID_H+FOOTER_H Config() PicCatchIni()
			lib.PicLoadFile(CONFIG.DataPath.."title_main.idx",CONFIG.DataPath.."title_main.grp",14)
			koTitleAnimReady=false koTitleStillReady=false
			mx,my=-1,-1 koMouseReset()
			return
		end
		if name=="#setting" then
			rawset(_G,"koSettingBg",function()-- jymain SettingMenu draws this behind its box on the title (else the story's logo)
				if not koTitleStillReady then-- PicCatchIni (a scale change rebuilds the window) clears it: load the grid again
					lib.PicLoadFile(CONFIG.DataPath.."title_main.idx",CONFIG.DataPath.."title_main.grp",14)
					koTitleStillReady=true
				end
				drawGrid()
			end)
			SettingMenu()
			rawset(_G,"koSettingBg",nil)
		else
			local f=rawget(_G,name)
			if type(f)~="function" then return end
			CC.ScreenH=oldH Config() PicCatchIni()
			f()
			CC.ScreenH=GRID_H+FOOTER_H Config() PicCatchIni()
		end
		lib.PicLoadFile(CONFIG.DataPath.."title_main.idx",CONFIG.DataPath.."title_main.grp",14)
		koTitleAnimReady=false koTitleStillReady=false
		mx,my=-1,-1 koMouseReset()
	end
	while true do
		JY.ReFreshTime=lib.GetTime()
		if MOUSE.x~=mx or MOUSE.y~=my then
			mx,my=MOUSE.x,MOUSE.y
			if not pop and not MOUSE.IN(0,GRID_H,CC.ScreenW,GRID_H+FOOTER_H) then
				for k=1,#cells do local a1,b1,c1,d1=at(k) if MOUSE.IN(a1,b1,c1,d1) then sel=k end end
			end
		end
		drawGrid()
		ShowScreen()
		if JY.Dark then Light() end
		local e,key=koPollKey()
		if e==0 or MOUSE.EXIT() then koExit() end
		local item=nil
		if e==1 then
			local k
			if key==27 and pop~=nil then
				if pop==0 then pop=nil else menuSel=pop pop=0 end
			elseif key==27 and pick then pick=nil
			elseif key==109 then pop=pop==nil and 0 or nil menuSel=1 PlayWavE(0)
			elseif pop~=nil then
				local R=menuRows()
				if key==1073741906 then menuSel=math.max(1,menuSel-1)
				elseif key==1073741905 then menuSel=math.min(#R,menuSel+1)
				elseif key==13 or key==32 then if R[menuSel] then item=menuPick(R[menuSel]) end end
			elseif key==1073741904 then k=near(-1,0) elseif key==1073741903 then k=near(1,0)
			elseif key==1073741906 then k=near(0,-1) elseif key==1073741905 then k=near(0,1)
			elseif key==13 or key==32 then go=sel
			elseif key==102 then item="#setting"
			elseif key==103 then item="koGenManageMenu"
			elseif key==98 then item="koBookMainMenu"
			elseif key==115 then item="koSaveAllScreen" end
			if k then sel=k PlayWavE(0) end
		end
		if MOUSE.ESC() then
			if pop~=nil then if pop==0 then pop=nil else menuSel=pop pop=0 end else pick=nil end
		end
		if MOUSE.CLICK(BX1,BY1,BX2,BY2) then
			pop=pop==nil and 0 or nil menuSel=1 pick=nil PlayWavE(0)
		elseif pop~=nil then
			local hit=false
			for i,it in ipairs(menuRows()) do
				local a,b,c,d=rowRect(i)
				if MOUSE.CLICK(a,b,c,d) then item=menuPick(it) hit=true break end
			end
			if not hit and MOUSE.CLICK() then pop=nil end
		else
			for k=1,#cells do local a,b,c,d=at(k) if MOUSE.CLICK(a,b,c,d) then go=k end end
		end
		if item and runItem(item)=="battle" then return end   -- 화면 크기는 이미 원래대로
		if go and pick then koHubPick(pick) end   -- 11-11: the story's title opens that mode (battlehub)
		if go then sel=go PlayWavE(0) break end
	end
	CC.ScreenH=oldH
	Config()
	PicCatchIni()
	local s=cells[sel][1]
	if s.id then
		local h=io.open(CONFIG.CurrentPath.."ko_camp.txt","w")
		if h then h:write(s.id.."\n") h:close() end
	else
		os.remove(CONFIG.CurrentPath.."ko_camp.txt")
	end
	if s.id==CONFIG.koCamp then Dark() return end-- the story already running: its title fades in (YJZMain_sub)
	if not koSoftRestart() then
		if rawget(_G,"koRestart") then koRestart() else koExit() end
	end
end

if #LIST>1 then
	local done=rawget(_G,"koMainDone")-- after a pick (koSoftRestart) the new run goes straight to that story's title
	koOn("title",function()
		if done or rawget(_G,"koMainSkip") then return end
		done=true
		koMainScreen()
	end)
	koAddon.titleMenu[#koAddon.titleMenu+1]={label="\129\253\129\106\131\109\132\083",main=true,run=function() koMainScreen() end}
	rawset(_G,"koMainSettings",true)-- jymain: the title list leaves 기능 설정 out (it is here)
end

-- 11-10 제보 「현재위치에 4글자 넘는 이름이 틀 밖으로 나온다 — 여포의 군막, 여러 날 뒤 … 그냥 도시 이름만」:
--   이야기 대본(이식판 변환)이 원작 DOS 의 알림 줄(장면 제목 · 「포상으로 황금 600냥」 · 레벨업 문장, 무제전은 첫 단어)을
--   JY.Base 현재위치 칸에 넣는다. 화면 오른쪽 「현재위치」 칸에 그릴 때만 도시 이름으로 바꿔 끼우고 저장값은 그대로 둔다.
--   도시 = 들어 있는 값이 그 이야기의 도시 이름(EVENTS · 마을 목록)이면 그대로(마을 걷기 중 다른 도시), 아니면 지금 장면의 도시
--   (campaign/town.lua 의 koWujeTownFacts: 사건 번호 -> 도시 표). 영걸전 본편은 손대지 않음(본편 값은 원래 도시 이름).
do
local LOC="\207\214\212\218\181\216"
local raw=DrawGameStatus
if type(raw)=="function" then
function DrawGameStatus(...)
local facts=rawget(_G,"koWujeTownFacts")
if not (facts and CONFIG.koCamp and JY and JY.Base) then return raw(...) end
local ok,city,cat=pcall(facts)
if not ok or type(city)~="string" or city=="" then return raw(...) end
local old=JY.Base[LOC]
local show=city
if type(old)=="string" and old~="" then
for _,p in ipairs(cat or {}) do if p[1]==old then show=old break end end
end
JY.Base[LOC]=show
local ok2,err=pcall(raw,...)
JY.Base[LOC]=old
if not ok2 then error(err,0) end
end
end
end

-- 11-10 사용자 「도시 화면에서 무장이 출구로 나갈 때 한 명씩 이동하니 나가는 무장이 많으면 시간을 많이 잡아먹는다, 한 번에 나가게」:
--   이야기 도시의 퇴장 SnrLeave(문 밖으로 나가 사라짐) · SnrToDoor(문 앞까지)는 무장마다 걷기를 끝까지 기다리며 차례로 걷는다
--   (걷기는 엔진 MovePerson · 런타임 · calculated_routes 의 animate 가 층층이 맡음). 대본에 이어 붙은 퇴장 줄은
--   patch_퇴장한번에.py 가 한 호출로 합치고, 여기서 여러 명이 든 호출은
--   ① 녹화: 기다림 · 화면 출력을 끄고 그대로 돌리며, 그림을 그릴 때(DrawSMap)마다 사람별로 바뀐 위치 · 방향 · 걷는 모습을 한 칸씩 적음
--      (빠진 사람은 「빠짐」으로) — 계산은 한 명씩 나갈 때와 똑같음
--   ② 처음 상태로 되돌린 뒤 ③ 사람별 기록을 같은 프레임에 겹쳐 재생 (한 프레임 = ReFresh(1.25), 원래 걸음과 같은 빠르기)
--   ④ 끝 상태(남은 사람 · 순서)를 그대로 놓는다. 걸리는 시간 = 가장 먼 사람 한 명 분.
do
local GONE={}
local function parallel(base)
return function(ids,...)
if type(ids)~="table" or #ids<2 or not JY or type(JY.Smap)~="table" then return base(ids,...) end
local ents,snap,tracks,last,gone={},{},{},{},{}
for _,e in ipairs(JY.Smap) do ents[#ents+1]=e snap[e]={e[2],e[3],e[4],e[5]} tracks[e]={} last[e]=snap[e] end
local function capture()
local here={}
for _,e in ipairs(JY.Smap) do here[e]=true end
for _,e in ipairs(ents) do
if here[e] then
local l=last[e]
if e[2]~=l[1] or e[3]~=l[2] or e[4]~=l[3] or e[5]~=l[4] then local st={e[2],e[3],e[4],e[5]} table.insert(tracks[e],st) last[e]=st end
elseif not gone[e] then gone[e]=true table.insert(tracks[e],GONE) end
end
end
local DS,SS,RF,DL=DrawSMap,ShowScreen,ReFresh,lib.Delay
DrawSMap=function() capture() end
ShowScreen=function() end ReFresh=function() end lib.Delay=function() end
local ok,err=pcall(base,ids,...)
DrawSMap,ShowScreen,ReFresh,lib.Delay=DS,SS,RF,DL
if not ok then error(err,0) end
capture()
local final={}
for i,e in ipairs(JY.Smap) do final[i]=e end
local fin={}
for _,e in ipairs(ents) do fin[e]={e[2],e[3],e[4],e[5]} end
-- 처음 상태로
local cur={}
for i,e in ipairs(ents) do cur[i]=e local s=snap[e] e[2],e[3],e[4],e[5]=s[1],s[2],s[3],s[4] end
JY.Smap=cur
local n=0
for _,e in ipairs(ents) do if #tracks[e]>n then n=#tracks[e] end end
for k=1,n do
for _,e in ipairs(ents) do
local st=tracks[e][k]
if st==GONE then
for i,v in ipairs(JY.Smap) do if v==e then table.remove(JY.Smap,i) break end end
elseif st then e[2],e[3],e[4],e[5]=st[1],st[2],st[3],st[4] end
end
JY.ReFreshTime=lib.GetTime()
DrawSMap()
lib.GetKey()
ReFresh(1.25)
end
for _,e in ipairs(ents) do local f=fin[e] e[2],e[3],e[4],e[5]=f[1],f[2],f[3],f[4] end
JY.Smap=final
DrawSMap() ShowScreen()
end
end
local function wrap()
if rawget(_G,"koSnrParDone") then return end
local L,T=rawget(_G,"SnrLeave"),rawget(_G,"SnrToDoor")
if type(L)~="function" or type(T)~="function" then return end
rawset(_G,"koSnrParDone",true)
rawset(_G,"SnrLeave",parallel(L))
rawset(_G,"SnrToDoor",parallel(T))
end
-- 이야기 런타임 · calculated_routes 는 애드온보다 늦게(camp addons) 읽히므로 타이틀에서 감싼다
koOn("title",wrap)
end

-- 11-10 사용자 「원소전 무장 천부들이 말도 안 되게 구리다 · 안량 문추도」 → 표 확인 「바꿔줘」:
--   원소전은 같은 이름 무장의 천부를 영걸전 본편(원소군 = 지나가는 적장)에서, 원소전 전용 무장은 기본값을 받아 약했다.
--   data/camp/yuanshao/newgame.grp 를 고쳤고(patch_원소전천부.py), 진행 중 세이브는 불러온 뒤 · 회차를 넘긴 뒤 여기서 같은 값으로.
--   {옛 천부, 새 천부} — 천부가 아직 옛 값일 때만 바꾸고, 새 천부가 특기 칸에 이미 있으면 그 칸에 옛 천부를 넣어 맞바꿈(원소 포진 · 고간 강인).
do
local TF,SP="\204\236\184\179","\204\216\188\188"
local YS={[1]={22,36},[13]={31,113},[14]={25,105},[19]={6,42},[36]={27,106},[4]={6,9},[8]={22,27},[10]={32,10},[141]={22,26},[21]={6,31},[38]={6,35},[26]={0,6}}
local function fixTf()
if CONFIG.koCamp~="yuanshao" or not JY or not JY.Person then return end
for pid,t in pairs(YS) do
local p=JY.Person[pid]
if p and not koOfficerEdited(pid,16) and p[TF]==t[1] then
p[TF]=t[2]
for k=1,6 do if p[SP..k]==t[2] then p[SP..k]=t[1] break end end
end
end
end
rawset(_G,"koYsTalentFix",fixTf)
koOn("title",function()
if rawget(_G,"koYsTfWrapped") then return end
rawset(_G,"koYsTfWrapped",true)
local LR=LoadRecord
LoadRecord=function(...) local r={LR(...)} fixTf() return (table.unpack or unpack)(r) end
local NG=CC.koNG-- jymain 의 회차 표(local koNG)는 CC.koNG 로만 보인다 (gear 애드온과 같음)
if type(NG)=="table" and type(NG.reset)=="function" then
local R=NG.reset
NG.reset=function(...) local r={R(...)} fixTf() return (table.unpack or unpack)(r) end
end
end)
end

-- 11-11 사용자 「387번처럼 바꿔」: 무제전 전위(인물 8)는 이식판 원작 데이터(얼굴 1126 · 단병 · 98/30/50)라 영걸전 전위(387)와 달랐다.
--   data/camp/wuje/newgame.grp 를 고쳤고(patch_무제전전위.py), 진행 중 세이브는 불러온 뒤 · 회차를 넘긴 뒤 여기서 387 의 값으로.
--   (무력2 · 지력2 · 통솔2 는 장비를 더한 값이라 ReSetAttrib 가 다시 셈.) 특기가 아직 옛 묶음(8 9 10 …)일 때만. 병종은 단병 계열(1~3)일 때만 무술가(15)로 — 병종 교환으로 바꾼 것은 그대로. 레벨 · 경험치 · 도구 · 천부는 그대로.
do
local F={"\208\206\207\243","\205\183\207\241\180\250\186\197","\208\194\205\183\207\241\180\250\186\197","\206\228\193\166","\214\199\193\166","\205\179\194\202","\211\194\195\205","\177\169\187\247","\193\172\187\247","\187\216\194\237","\195\216\188\1881","\176\181\198\247","\183\220\213\189","\188\177\190\200","\181\215\193\166","\197\173\183\162","\205\254\183\231","\178\187\199\252","\199\191\212\203","\210\187\187\247","\179\201\179\164"}
local SP,BZ,FACE,NAME="\204\216\188\188","\177\248\214\214","\205\183\207\241\180\250\186\197","\208\213\195\251"
local function fixDw()
if CONFIG.koCamp~="wuje" or not JY or not JY.Person or (JY.PersonNum or 0)<=387 then return end
local p,q=JY.Person[8],JY.Person[387]
local skip={}
if koOfficerEdited(8,1) then skip[F[1]]=true end
if koOfficerEdited(8,2) then skip[FACE]=true end
if koOfficerEdited(8,8) then for i=4,8 do skip[F[i]]=true end end
if not p or not q or p[NAME]~=q[NAME] or not (p[SP.."1"]==8 and p[SP.."2"]==9 and p[SP.."3"]==10) then return end-- 옛 특기 묶음(8 9 10)일 때만: 얼굴은 wuje_campaign PERSON 표가 불러올 때 먼저 24 로 바꿈
for _,f in ipairs(F) do if not skip[f] then pcall(function() p[f]=q[f] end) end end
if not koOfficerEdited(8,16) then for k=1,6 do p[SP..k]=q[SP..k] end end
if not koOfficerEdited(8,4) and p[BZ]>=1 and p[BZ]<=3 then p[BZ]=q[BZ] end
pcall(ReSetAttrib,8,false)
end
rawset(_G,"koWjDianweiFix",fixDw)
koOn("title",function()
if rawget(_G,"koWjDwWrapped") then return end
rawset(_G,"koWjDwWrapped",true)
local LR=LoadRecord
LoadRecord=function(...) local r={LR(...)} fixDw() return (table.unpack or unpack)(r) end
local NG=CC.koNG
if type(NG)=="table" and type(NG.reset)=="function" then
local R=NG.reset
NG.reset=function(...) local r={R(...)} fixDw() return (table.unpack or unpack)(r) end
end
end)
end
