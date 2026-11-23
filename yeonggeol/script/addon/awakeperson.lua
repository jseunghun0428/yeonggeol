-- ko 군웅록 (11-04): awakeperson — 무장 각성. 설계: 개발용/문서/무장 각성 설계안.md
-- (UTF-8 원본: 개발용/addon/awakeperson_src.lua -> 도구/free_hz.pl -> script/addon/awakeperson.lua, addons.lua 에서 bogam 뒤 · recsave 앞)
-- 데이터 = awakeperson_data.lua (도구/무장각성_데이터.py). 줄 번호 = 저장 비트 번호.
-- 병종 · 조형은 그대로. 내 편(君主 1)일 때만 공 · 방 · 이동 보정과 특기 (jymain ReSetAttrib · koHasSkill 이 읽음).
-- 저장: 창고 칸의 빈 낱말(외호 24~36 · 136~150). 763 · 764 = 지금 각성, 765 · 766 = 각성해 본 적 있음. 한 낱말 15비트.
--   창고는 소지품 120~134 만 씀(762 는 조기 등용 금도 있어 안 씀). 회차가 바뀌면 koNG.reset 뒤에 다시 적음.
-- 해금: 그 이야기를 도전 3 이상으로 끝내면(이번 회차 최저 난이도, 无用3) CONFIG.CurrentPath/ko_awake.txt 에 이야기 이름을 적음. 기기 공통.
--   옛 세이브는 불러올 때 기록 화면의 회차 이력으로 인정. 네 이야기를 다 끝내면 비용 절반.
if not koNeeds("base") then return end
pcall(dofile,CONFIG.ScriptPath.."addon/awakeperson_data.lua")
local DATA=rawget(_G,"koAwakeData")
if type(DATA)~="table" then return end
local K=string.char
local LORD,NAME,LV=K(190,253,214,247),K(208,213,195,251),K(181,200,188,182)
local HP,HPM=K(177,248,193,166),K(215,238,180,243,177,248,193,166)
local FACE=K(205,183,207,241,180,250,186,197)
local ATK,DEF=K(185,165,187,247),K(183,192,211,249)
local SNAME,SDESC=K(195,251,179,198),K(203,181,195,247)
local NOUSE3=K(206,222,211,195,51)
local PS=CC.PersonSize
local WORDS={24,26,28,30,32,34,36,136,138,140,142,144,146,148,150}
local POW={} do local v=1 for b=0,14 do POW[b]=v v=v*2 end end
local CUR,EVER={763,764},{765,766}
local NGEN=20
local GENBASE=238   -- 11-21: 신무장 k 의 줄(저장 비트) = 238+k (예전 N+k 와 같은 자리). 데이터 표 239~258 은 빈 자리, 새 무장은 259~
local N=#DATA
local GENROW={{},20,20,0,{},"\129\070\129\107\132\083 \134\069\143\120\130\113 \131\078\129\073\131\097. \130\074\130\112\129\123 \132\078\130\083\129\094 \129\091\135\077\129\077."}
-- 11-21 카페 건의 (신무장은 각성해도 달라지는 게 없음): 신무장 등록에서 고른 「각성 특기」(등록부 aw)가 있으면 그 특기도.
--  등록부는 번호(칸 510+번호)와 이름이 같을 때만 씀 (지운 뒤 다른 무장을 같은 번호로 만든 경우 옛 무장은 공통 줄)
local GENROWS={}
local function genRow(pid)
	local sk=0
	if rawget(_G,"koNewGenList") then
		local ok,L=pcall(koNewGenList)
		local g=ok and L and L[pid-510]
		if g and g.name==JY.Person[pid][NAME] then sk=tonumber(g.aw) or 0 end
	end
	if sk<=0 or not JY.Skill[sk] then return GENROW end
	local d=GENROWS[sk]
	if not d then
		d={{},GENROW[2],GENROW[3],GENROW[4],{sk},"\129\070\129\107\132\083 \134\069\143\120\130\113 \131\078\129\073\131\097. \130\074\130\112\129\123 \132\078\130\083\129\094 \129\091\130\106\131\100 \130\069\131\123 \129\120\131\071\130\104 \133\086\130\098\129\077."}
		GENROWS[sk]=d
	end
	return d
end
local function have() return JY.Data_Person~=nil and (JY.PersonNum or 0)>766 end
local function story() return CONFIG.koCamp or "base" end
-- ---------------------------------------------------------------- bits
local function pos(slots,r)
	local w=math.floor((r-1)/15)
	local s=math.floor(w/#WORDS)
	return slots[s+1]*PS+WORDS[w%#WORDS+1],(r-1)%15
end
local function getbit(slots,r)
	local o,b=pos(slots,r)
	return math.floor(Byte.get16(JY.Data_Person,o)/POW[b])%2==1
end
local function setbit(slots,r,on)
	local o,b=pos(slots,r)
	local v=Byte.get16(JY.Data_Person,o)
	local has=math.floor(v/POW[b])%2==1
	if on and not has then v=v+POW[b] elseif has and not on then v=v-POW[b] end
	Byte.set16(JY.Data_Person,o,v)
end
-- 각성해 본 적: 세이브 비트 + 기기 공통 CC.koAwakeG (줄마다 "0"/"1", 이야기별). 타이틀의 도감 · 정벌 고르기처럼 세이브가 없는 화면은 이쪽을 본다
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koAwakeG",default=""}
local function gGet(r) return string.sub(CC.koAwakeG or "",r,r)=="1" end
local function gSet(r)
	local g=CC.koAwakeG or ""
	if #g<r then g=g..string.rep("0",r-#g) end
	CC.koAwakeG=string.sub(g,1,r-1).."1"..string.sub(g,r+1)
end
local function gSync()
	local ch=false
	for r=1,N+NGEN do if getbit(EVER,r) and not gGet(r) then gSet(r) ch=true end end
	if ch and rawget(_G,"koSave") then pcall(koSave) end
end
local function everRow(r) return gGet(r) or (have() and getbit(EVER,r)) end
-- ---------------------------------------------------------------- 인물 → 줄
local roster=dofile(CONFIG.ScriptPath.."addon/awakeperson_roster.lua")
koAwakeOn={}
koAwakeSk={}
local ROWOF={}
local edits={}
local function loadEdits()
	edits={}
	local path=string.gsub(CC.R_GRPFilename[0],"newgame%.grp$","officer_awake.txt")
	local file=io.open(path,"r")
	if not file then return end
	for line in file:lines() do
		local id,list=string.match(line,"^(%d+)([%s%d]*)$")
		if id then
			local skills={}
			for value in string.gmatch(list,"%d+") do
				local sk=tonumber(value)
				if sk>0 and JY.Skill[sk] then skills[#skills+1]=sk end
			end
			edits[tonumber(id)]=skills
		end
	end
	file:close()
end

local function effectiveData(pid,d)
	local skills=edits[pid]
	if not d or not skills then return d end
	local names={}
	for _,sk in ipairs(skills) do names[#names+1]=JY.Skill[sk][SNAME] end
	return {d[1],d[2],d[3],d[4],skills,table.concat(names,"\161\164")}
end

local function rowOf(pid)
	local r=roster(pid,JY.Person,story(),rawget(_G,"koRecBook"))
	if not r then return nil end
	local d=(r>GENBASE and r<=GENBASE+NGEN) and genRow(pid) or DATA[r]
	return r,effectiveData(pid,d)
end
local function offMode()
	if rawget(_G,"koFoeActive") and koFoeActive() then return true end
	if rawget(_G,"koPuzzleActive") and koPuzzleActive() then return true end
	if rawget(_G,"koConqActive") and koConqActive() then return true end
	return false
end
function koAwakeRebuild()
	koAwakeOn={} koAwakeSk={} ROWOF={}
	if not have() then return end
	local off=offMode()
	for i=1,601 do
		local r,d=rowOf(i)
		local player=koStoryBattleAlly and koStoryBattleAlly(i) or i
		if r then
			ROWOF[player]=r
			if not off and getbit(CUR,r) then
				koAwakeOn[player]=d
				local t={}
				for _,s in ipairs(d[5]) do t[s]=true end
				koAwakeSk[player]=t
			end
		end
	end
end
function koAwakeAD(id)
	local d=koAwakeOn[id]
	if d and JY.Person[id][LORD]==1 then return d[2],d[3] end
	return 0,0
end
function koAwakeMove(id)
	local d=koAwakeOn[id]
	if d and JY.Person[id][LORD]==1 then return d[4] end
	return 0
end
function koAwakeIs(pid) return koAwakeOn[pid]~=nil and JY.Person[pid][LORD]==1 end
function koAwakeEver(pid)
	if not JY.Person or not JY.Person[pid] then return false end
	local r=ROWOF[pid] or rowOf(pid)
	return r~=nil and everRow(r)
end
function koAwakeFrame(pid,x,y) if koAwakeIs(pid) then lib.PicLoadCache(4,299*2,x,y,1) end end
function koAwakeNameColor(pid,c) if koAwakeIs(pid) then return M_Yellow end return c end
-- 상태창: 공격력 · 방어력 옆 보정값
function koAwakeStatus(pid,x,y)
	if not koAwakeIs(pid) then return end
	local d=koAwakeOn[pid]
	local p=JY.Person[pid]
	if d[2]>0 then DrawString(x+184+64+#tostring(p[ATK])*8+8,y+141,"(+"..d[2]..")",M_Yellow,16) end
	if d[3]>0 then DrawString(x+184+64+#tostring(p[DEF])*8+8,y+162,"(+"..d[3]..")",M_Yellow,16) end
end
local function skillNames(d)
	local t={}
	for _,s in ipairs(d[5]) do t[#t+1]=JY.Skill[s][SNAME] end
	return table.concat(t,"\161\164")
end
-- 11-06: 각성 특기는 천부 글에 붙이지 않고(2쪽에 숨어 안 보였음) 기술 표 아래 「각성」 줄로. 천부 칸에 붙일 글은 이제 없음.
function koAwakeTfText(pid) return "" end
-- 기술 표(DrawSkillTable · koSkillTipTable: 무장 정보창 · 틀 상태판 · 호버 미니창이 모두 씀) 바로 아래 줄. 각성한 무장만.
-- 틀 상태판 자리 = 전투 창을 아래로 늘려 만듦(도구/patch_틀아래늘림.py).
local CELLW,CELLH,ROWY=36,20,42
function koAwakeRowH(pid)
	if koAwakeIs(pid) and #koAwakeOn[pid][5]>0 then return 22 end
	return 0
end
-- 무장 정보창 아래쪽 영역(막대 · 능력치 · 기술 · 장비 · 소지품)을 8 내림, 각성한 무장만. jymain 이 그릴 때 · 클릭 볼 때 y 에 더함.
function koAwakeDown(pid)
	if koAwakeRowH(pid)>0 then return 8 end
	return 0
end
-- 무장 정보창 아래쪽을 32 내려 한 번 더 그림 (창 무늬 주기가 32 라 이음매가 안 보임). jymain PersonStatus_sub 가 부름.
function koAwakeWindow(pid,x,y)
	if koAwakeRowH(pid)==0 then return end
	local function part(x1,y1,x2,y2,px,py)
		lib.SetClip(x+x1,y+y1,x+x2,y+y2)
		lib.PicLoadCache(4,85*2,x+px,y+py,1)
	end
	part(0,256,330,320,0,32)      -- 왼쪽 · 가운데
	part(448,256,470,320,0,32)    -- 오른쪽 테두리
	part(330,300,448,320,0,32)    -- 소지품 칸 아래 테두리
	part(330,118,448,268,128,0)   -- 소지품 칸 자리를 빈 무늬로 (왼쪽 빈 곳을 32 배수로 옮겨 씀)
	part(330,268,448,300,128,32)
	part(332,128,446,276,0,8)     -- 소지품 칸을 8 아래에
	lib.SetClip(0,0,0,0)
end
local function cellsOf(pid,x,y)
	if koAwakeRowH(pid)==0 then return nil end
	local t={}
	for i,sk in ipairs(koAwakeOn[pid][5]) do t[i]={x+CELLW*(i-1),y+ROWY,sk} end
	return t
end
local rawSkillTable=DrawSkillTable
function DrawSkillTable(pid,x,y,flag)
	rawSkillTable(pid,x,y,flag)
	local cells=cellsOf(pid,x,y)
	if not cells then return end
	-- 「기술」 글자와 같은 칸: 틀 상태판(flag 없음)은 34, 정보창 · 미니창은 40 왼쪽
	DrawString(x-(flag==nil and 34 or 40),y+ROWY+2,"\130\069\131\123",M_Yellow,16)
	for _,c in ipairs(cells) do
		local cx,cy=c[1],c[2]
		lib.FillColor(cx+1,cy+1,cx+CELLW,cy+CELLH,RGB(16,28,96))
		lib.DrawRect(cx,cy,cx+CELLW,cy,M_Yellow)
		lib.DrawRect(cx,cy+CELLH,cx+CELLW,cy+CELLH,M_Yellow)
		lib.DrawRect(cx,cy,cx,cy+CELLH,M_Yellow)
		lib.DrawRect(cx+CELLW,cy,cx+CELLW,cy+CELLH,M_Yellow)
		DrawString(cx+2,cy+2,JY.Skill[c[3]][SNAME],M_Yellow,16)
	end
end
local rawSkillTip=koSkillTipTable
function koSkillTipTable(pid,x,y,flag)
	local cells=cellsOf(pid,x,y)
	if cells then
		for _,c in ipairs(cells) do
			if MOUSE.IN(c[1],c[2],c[1]+CELLW,c[2]+CELLH) then
				koSkillTipBox(c[3],false,0)
				return true
			end
		end
	end
	return rawSkillTip(pid,x,y,flag)
end
-- ---------------------------------------------------------------- 해금
local CLR={}
local function clrPath() return CONFIG.CurrentPath.."ko_awake.txt" end
local function clrLoad()
	CLR={}
	local h=io.open(clrPath(),"rb")
	if not h then return end
	local s=h:read("*a") h:close()
	for w in string.gmatch(s or "","%a+") do CLR[w]=true end
end
local function clrMark(id)
	clrLoad()
	if CLR[id] then return end
	CLR[id]=true
	local t={}
	for w,_ in pairs(CLR) do t[#t+1]=w end
	table.sort(t)
	local h=io.open(clrPath(),"wb")
	if h then h:write(table.concat(t,"\n").."\n") h:close() end
end
function koAwakeUnlocked() clrLoad() return CLR[story()]==true end
function koAwakeClearCount()
	clrLoad()
	local n=0
	for _,w in ipairs({"base","wuje","sunjian","yuanshao"}) do if CLR[w] then n=n+1 end end
	return n
end
-- 옛 세이브: 기록 화면의 회차 이력(회차마다 无用3)에 도전 3 이상으로 끝낸 회차가 있으면 인정
local function legacyScan()
	if not rawget(_G,"koRec") then return end
	local NG=CC.koNG
	local cur=(NG and NG.rcycle) and NG.rcycle() or 1
	for n=math.max(1,cur-20),cur-1 do
		if koRec(1120+((n-1)%20)*4)>=4 then clrMark(story()) return end
	end
end
-- ---------------------------------------------------------------- 게임 흐름
-- 11-10: 옛 판에서 술집 사본(같은 이름 둘 중 다른 쪽)을 각성시키면 기본값 줄(于禁)에 비트가 섰음 → 그 줄의 주인(번호표 칸)이
--  우리 편이 아니고 사본이 지금 다른 줄이면 지금 각성 비트를 사본 줄로 옮김 (불러올 때)
local function migrateDup()
	local fix=koAwakeFix and koAwakeFix[story()]
	local def=koAwakeFixDefault
	if not fix or not def or not getbit(CUR,def) then return end
	for pid,r in pairs(fix) do
		if r==def and JY.Person[pid] and JY.Person[pid][LORD]==1 then return end
	end
	for i=421,math.min(601,JY.PersonNum-1) do
		local p=JY.Person[i]
		if p[LORD]==1 then
			local r=rowOf(i)
			if r and r~=def then
				for _,v in pairs(fix) do
					if v==r then
						setbit(CUR,def,false)
						setbit(CUR,r,true) setbit(EVER,r,true) gSet(r)
						return
					end
				end
			end
		end
	end
end
local lr=rawget(_G,"LoadRecord")
if type(lr)=="function" then
	function LoadRecord(...)
		local r=table.pack(lr(...))
		loadEdits()
		if have() then pcall(migrateDup) end
		local ok,err=pcall(koAwakeRebuild)
		if not ok then koAddonLog("awakeperson load: "..tostring(err)) end
		if have() then pcall(legacyScan) pcall(gSync) end
		return table.unpack(r,1,r.n)
	end
end
koOn("war_begin",function() if (War.Turn or 1)==1 then koAwakeRebuild() end end)
koOn("war_end",function() koAwakeRebuild() end)
if CC.koOffer then
	local rawOffer=CC.koOffer
	CC.koOffer=function(...)
		if have() and (JY.Base[NOUSE3] or 0)>=4 then clrMark(story()) end-- 无用3 = 최저 난이도 + 1
		return rawOffer(...)
	end
end
local NG=CC.koNG
if NG and NG.reset then
	local rawReset=NG.reset
	NG.reset=function(...)
		local keep={}
		if have() then
			for r=1,N+NGEN do keep[r]={getbit(CUR,r),getbit(EVER,r)} end
		end
		local res=rawReset(...)
		if res~=false and have() then
			for r,v in ipairs(keep) do
				if v[1] then setbit(CUR,r,true) end
				if v[2] then setbit(EVER,r,true) end
			end
			koAwakeRebuild()
		end
		return res
	end
end
local rawCost=rawget(_G,"koCostOf")
if type(rawCost)=="function" then
	function koCostOf(pid)
		local c=rawCost(pid)
		if koAwakeIs(pid) and c>0 then return math.min(10,c+1) end
		return c
	end
end
-- ---------------------------------------------------------------- 무장 메뉴
local NEEDLV=40
local function price(pid)
	local c=rawCost and rawCost(pid) or 1
	local g=5000+1000*math.max(1,c)
	if koAwakeClearCount()>=4 then g=math.floor(g/2) end
	return g
end
local function info(d)
	local s={}
	if d[2]>0 then s[#s+1]="\130\074 +"..d[2] end
	if d[3]>0 then s[#s+1]="\132\078 +"..d[3] end
	if d[4]>0 then s[#s+1]="\129\071\130\108 +"..d[4] end
	local a=table.concat(s,"  ")
	if #d[5]>0 then a=a.."*\129\120\131\071: "..skillNames(d) end
	return a
end
local function descLines(d) return (string.gsub(d[6],"%. ",".*")) end
local function listIds()
	local on,off={},{}
	for i=1,601 do
		local p=JY.Person[i]
		if p[LORD]==1 and ROWOF[i] then
			if koAwakeOn[i] then on[#on+1]=i elseif (p[LV] or 0)>=NEEDLV then off[#off+1]=i end
		end
	end
	local byLv=function(a,b) local la,lb=JY.Person[a][LV],JY.Person[b][LV] if la~=lb then return la>lb end return a<b end
	table.sort(on,byLv) table.sort(off,byLv)
	for _,i in ipairs(on) do off[#off+1]=i end
	return off
end
local function pick()
	local ids=listIds()
	if #ids==0 then
		WarDrawStrBoxConfirm("Lv"..NEEDLV.." \129\071 \136\089 \129\073\131\097\129\071 \130\097\129\075\129\076\129\077.",M_White,true)
		return 0
	end
	local per=(#ids<=10) and 10 or 8
	local pages=math.ceil(#ids/per)
	local page=1
	while true do
		local m,map={},{}
		if page>1 then m[#m+1]={"\129\071\130\066 ("..(page-1).."/"..pages..")",nil,1} map[#m]=-1 end
		for j=(page-1)*per+1,math.min(#ids,page*per) do
			local i=ids[j]
			local p=JY.Person[i]
			if koAwakeOn[i] then
				m[#m+1]={fillblank(p[NAME],9)..string.format("Lv%2d",p[LV]).."  \130\069\131\123",nil,1}
			else
				m[#m+1]={fillblank(p[NAME],9)..string.format("Lv%2d",p[LV])..string.format("%7d",price(i)).."\131\103",nil,1}
			end
			map[#m]=i
		end
		if page<pages then m[#m+1]={"\129\077\130\077 ("..(page+1).."/"..pages..")",nil,1} map[#m]=-2 end
		local r=ShowMenu(m,#m,0,0,0,0,0,5,1,16,M_White,M_White)
		if r<=0 then return 0 end
		if map[r]==-1 then page=page-1 elseif map[r]==-2 then page=page+1 else return map[r] end
	end
end
function koAwakeRun()
	-- 11-10: 술집 칸(421~601)은 고용할 때 이름이 채워져, 불러온 뒤 · 전투 뒤에 만든 표(ROWOF)에 없음 → 창을 열 때 다시 만듦 (번궁 제보)
	koAwakeRebuild()
	while true do
		local pid=pick()
		if pid<=0 then return end
		local r=ROWOF[pid]
		local d=koAwakeOn[pid] or effectiveData(pid,(r>GENBASE and r<=GENBASE+NGEN) and genRow(pid) or DATA[r])
		local p=JY.Person[pid]
		if koAwakeOn[pid] then
			if WarDrawStrBoxYesNo(p[NAME].."  \130\069\131\123 \130\101*"..info(d).."*\130\069\131\123\129\083 \132\067\137\066\132\116\129\076\129\089? (\131\103\131\098 \137\066\131\096\133\072\130\067 \136\102\129\087\129\076\129\077)",M_White,true) then
				setbit(CUR,r,false)
				koAwakeRebuild()
				ReSetAttrib(pid,true)
				PlayWavE(0)
			end
		else
			local g=price(pid)
			if g>koGold() then
				PlayWavE(2)
				WarDrawStrBoxConfirm("\131\103\129\071 \130\090\133\120\140\101\129\076\129\077.*("..g.."\131\103 \132\115\129\090, \130\067\131\103 \131\103 "..koGold()..")",M_White,true)
			elseif WarDrawStrBoxYesNo(p[NAME].."  \130\069\131\123*"..info(d).."*\130\080\132\111 "..g.."\131\103 \161\164 \138\072\131\126\141\074 +1*\130\069\131\123\129\087\129\076\129\089?",M_White,true) then
				UseMoney(g)
				setbit(CUR,r,true)
				setbit(EVER,r,true)
				gSet(r)
				if rawget(_G,"koSave") then pcall(koSave) end
				koAwakeRebuild()
				ReSetAttrib(pid,true)
				p[HP]=p[HPM]
				PlayWavE(12)
				WarDrawStrBoxConfirm(p[NAME].."  \130\069\131\123!*"..descLines(d),M_Yellow,true)
			end
		end
	end
end
function koAwakeTestRow(pid) return (rowOf(pid)) end-- for test scripts
function koAwakeTestSet(pid,on) local r=ROWOF[pid] if r then setbit(CUR,r,on) if on then setbit(EVER,r,true) gSet(r) end koAwakeRebuild() end end-- for test scripts
koAddon.personMenu[#koAddon.personMenu+1]={label="\129\073\131\097 \130\069\131\123",show=function() return koAwakeUnlocked() end,run=function() koAwakeRun() end}
-- ---------------------------------------------------------------- 기록 화면 탭
if rawget(_G,"koRecTabs") then
	local PER=12
	local function list()
		local t={}
		for _,c in ipairs(koRecBook or {}) do
			local r=ROWOF[c] or rowOf(c)
			if r and r<=N then t[#t+1]={c,r} end
		end
		return t
	end
	local function page(e)
		local c,r=e[1],e[2]
		local d=effectiveData(c,DATA[r])
		local p=JY.Person[c]
		local w,h=420,240
		local x,y=math.floor((CC.ScreenW-w)/2),math.floor((CC.ScreenH-h)/2)
		local function draw()
			lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,RGB(0,0,0))
			koRecordClassicFrame(x,y,w,h)
			local fx,fy=x+24,y+40
			lib.PicLoadCache(2,p[FACE]*2,fx,fy,1)
			lib.PicLoadCache(4,299*2,fx-7,fy-7,1)
			DrawString(x+120,y+40,p[NAME],M_Yellow,24)
			local yy=y+76
			local _,a=Split(info(d),"*")
			for _,l in ipairs(a) do DrawString(x+120,yy,l,M_White,16) yy=yy+22 end
			yy=y+150
			local _,b=Split(descLines(d),"*")
			for _,l in ipairs(b) do DrawString(x+24,yy,l,M_White,16) yy=yy+22 end
		end
		koTourWait(draw,{{x=x,y=y,w=w,h=h,s="",plain=true,draw=function() end}})
	end
	koRecTabs[#koRecTabs+1]={label="\129\073\131\097 \130\069\131\123",per=PER,
	n=function() if not koAwakeUnlocked() then return 0 end return #list() end,
	draw=function(pg,c)
		if not koAwakeUnlocked() then
			c.ctext(c.oy+180,"\129\071 \129\071\133\069\131\071\130\104 \129\068\130\066 3 \129\071\129\067\131\109\132\083 \134\070\129\117\130\083\129\097\129\065 \130\065\132\116\129\076\129\077.",M_White)
			c.ctext(c.oy+210,"\129\066\131\103\129\111 \129\071\133\069\131\071 "..koAwakeClearCount().." / 4",M_Silver)
			return
		end
		local t=list()
		local y0=c.oy+60
		local function hd(x,s,right) if right then c.rtext(x,y0,s,M_Gray) else c.txt(x,y0,s,M_Gray) end end
		hd(c.ox+52,"\129\073\131\097") hd(c.ox+240,"\130\074",true) hd(c.ox+300,"\132\078",true) hd(c.ox+370,"\129\071\130\108",true) hd(c.ox+400,"\129\120\131\071")
		lib.DrawRect(c.ox+16,y0+20,c.ox+752,y0+20,RGB(112,91,57))
		local ever=0
		for _,e in ipairs(t) do if everRow(e[2]) then ever=ever+1 end end
		for k=1,PER do
			local e=t[(pg-1)*PER+k]
			if not e then break end
			local yy=y0+30+(k-1)*27
			if k%2==0 then lib.Background(c.ox+24,yy-2,c.ox+744,yy+21,190,RGB(46,35,24)) end
			local d=effectiveData(e[1],DATA[e[2]])
			local done=everRow(e[2])
			if done then c.txt(c.ox+24,yy,"\130\069",M_Yellow) end
			c.txt(c.ox+52,yy,JY.Person[e[1]][NAME],done and M_Yellow or M_White)
			if koRecUnlocked(e[1]) then
				local function sgn(v) return (v>0) and ("+"..v) or "-" end
				c.rtext(c.ox+240,yy,sgn(d[2])) c.rtext(c.ox+300,yy,sgn(d[3])) c.rtext(c.ox+370,yy,sgn(d[4]))
				c.txt(c.ox+400,yy,(#d[5]>0) and skillNames(d) or "-")
			else
				c.rtext(c.ox+240,yy,"??",M_Gray) c.rtext(c.ox+300,yy,"??",M_Gray) c.rtext(c.ox+370,yy,"??",M_Gray)
				c.txt(c.ox+400,yy,"??",M_Gray)
			end
		end
		c.rtext(c.ox+748,c.oy+445,"\129\066\131\103 "..koAwakeClearCount().."/4 \161\164 \130\069\131\123 "..ever.."/"..#t.."\130\088",M_Silver)
	end,
	btns=function(pg,c)
		local out={}
		if not koAwakeUnlocked() then return out end
		local t=list()
		for k=1,PER do
			local e=t[(pg-1)*PER+k]
			if not e then break end
			if koRecUnlocked(e[1]) then out[#out+1]={x=c.ox+16,y=c.oy+60+28+(k-1)*27,w=736,h=25,s="",plain=true,awk=e} end
		end
		return out
	end,
	click=function(btn) page(btn.awk) end}
end
