-- ko 6.0 (10-28): bogam — 보물 도감 (기록 화면 「보물 도감」 탭 · 타이틀 메뉴 「보물 도감」)
-- (UTF-8 원본: 개발용/addon/bogam_src.lua -> 도구/free_hz.pl -> script/addon/bogam.lua, addons.lua 에서 gear 뒤 · recsave 앞)
-- 데이터 = script/addon/bogam_data.lua (koBogamList, 도구/보물도감_그림만들기.py 가 만듦): {도구, ★ 도구(0 없음), 종류, 주인 이름}
-- 그림 = data/bogam.grp (같은 도구가 만듦): 칸 3k-3 원본 · 3k-2 ★ · 3k-1 실루엣, 128px. 그림 칸 9 = 100%(상세), 10 = 50%(목록)
--
-- 사용자 결정 (10-28): 적 · 아군 모든 보물(보물 316 + ★ 279), 보상 없음, 기록은 기기 공통(회차 · 세이브 공유, ko_settings.lua CC.koBogam),
--   「아군 / 적장」 두 갈래 — 주인이 등용 가능한 무장(무장 도감 명단)이거나 주인이 없는 보물은 아군, 끝내 등용 못 하는 무장의 보물은 적장.
-- 기록 = 그 도구를 우리 편이 가졌거나(가방 · 장비 · 창고) 전투에서 적이 든 것을 봄 (원본 · ★ 따로).
--   훑는 때: 세이브를 불러온 뒤 · 아군 차례마다(보이는 적의 장비 + 우리 편) · 전투 끝 · 기록 화면을 열 때. 자유 전투(새 기록)는 세지 않음.
-- CC.koBogam = 목록 순서대로 한 글자씩 "0"~"3" (1 = 원본, 2 = ★)

pcall(dofile,CONFIG.ScriptPath.."addon/bogam_data.lua")
if type(rawget(_G,"koBogamList"))~="table" then return end
local L=koBogamList
local NAME=string.char(208,213,195,251)      -- 姓名
local LORD=string.char(190,253,214,247)      -- 君主
local ITEM=string.char(181,192,190,223)      -- 道具 (..1~8)
local EQUIP={string.char(206,228,198,247),string.char(183,192,190,223),string.char(184,168,214,250)}-- 武器 防具 辅助
local DESC=string.char(203,181,195,247)      -- 说明
local INAME=string.char(195,251,179,198)     -- 名称
local KIND={"\129\073\131\071","\130\117\130\118\129\073\131\071","\134\104\129\149","\130\126\131\087","\131\115\129\118","\136\124","\129\120\129\113"}
local BYID,BYSTAR={},{}
for k,e in ipairs(L) do BYID[e[1]]=k if e[2]>0 then BYSTAR[e[2]]=k end end

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koBogam",default=""}
-- 11-11 사용자 「도감도 메인 화면으로」: 보물 도감 기록은 모든 모드 공용(게임 폴더 ko_settings.lua). 처음 합치기 = newgen koGenShare.bogamMigrate
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koBogamShared",default=0}
if type(rawget(_G,"koSharedKeys"))=="table" then table.insert(koSharedKeys,"koBogam") table.insert(koSharedKeys,"koBogamShared") end
local function stateOf(k) return tonumber(string.sub(CC.koBogam or "",k,k)) or 0 end
local function hasOrig(k) return stateOf(k)%2==1 end
local function hasStar(k) return stateOf(k)>=2 end
-- 한 번 훑는 동안 바뀐 것을 모았다가 끝에 한 번 저장
local function markAll(ids)
	local s=CC.koBogam or ""
	if #s<#L then s=s..string.rep("0",#L-#s) end
	local t={}
	for i=1,#L do t[i]=tonumber(string.sub(s,i,i)) or 0 end
	local dirty=false
	for id,_ in pairs(ids) do
		local k,bit=BYID[id],1
		if not k then k,bit=BYSTAR[id],2 end
		if k and math.floor(t[k]/bit)%2==0 then t[k]=t[k]+bit dirty=true end
	end
	if dirty then
		for i=1,#L do t[i]=tostring(t[i]) end
		CC.koBogam=table.concat(t)
		if rawget(_G,"koSave") then pcall(koSave) end
	end
	return dirty
end
-- 자유 전투(정벌 포함)는 도감에 기록하지 않음 (10-29 밤 사용자 「정벌은 도감에 안 올라가게」, 낮의 「정벌은 셈」 결정을 되돌림)
local function counting() return not CC.koFree and (JY.PersonNum or 0)>1 end
-- 우리 편: 가방 · 장비 · 창고
local function addOurs(ids)
	for i=1,JY.PersonNum-1 do
		local p=JY.Person[i]
		if p[LORD]==1 then
			for k=1,8 do local v=p[ITEM..k] if v and v>0 then ids[v]=true end end
			for _,q in ipairs(EQUIP) do local v=p[q] if v and v>0 then ids[v]=true end end
		end
	end
	if rawget(_G,"koStoreList") then for _,s in ipairs(koStoreList()) do ids[s.iid]=true end end
end
-- 전투에 보이는 적이 든 것 (장비 세 칸)
local function addSeen(ids)
	for _,v in pairs((War and War.Person) or {}) do
		if v.id and v.id>0 and not v.hide and JY.Person[v.id] and JY.Person[v.id][LORD]~=1 then
			local p=JY.Person[v.id]
			for _,q in ipairs(EQUIP) do local x=p[q] if x and x>0 then ids[x]=true end end
		end
	end
end
function koBogamScan(inWar)
	if not counting() then return false end
	local ids={}
	addOurs(ids)
	if inWar then addSeen(ids) end
	return markAll(ids)
end
koOn("player_phase",function() pcall(koBogamScan,true) end)
koOn("war_begin",function() pcall(koBogamScan,true) end)
koOn("war_end",function() pcall(koBogamScan,false) end)
do
	local rawLR=LoadRecord
	function LoadRecord(id,...)
		local r=table.pack(rawLR(id,...))
		CC.koBogamPic=nil-- 불러오면 그림 칸이 비므로 다음에 다시 읽음
		if id and id>0 then pcall(koBogamScan,false) if rawget(_G,"koBookSync") then pcall(koBookSync) end end
		return table.unpack(r,1,r.n)
	end
end

-- ---------------------------------------------------------------- 무장 도감도 기기 공통 (10-29 사용자 「이어서 해줘」 — 10-28 결정: 무장 도감 기록도 회차 · 세이브 공유)
-- 무장 도감 비트(事件 1810+ 해금 · 1840+ 아군이었음)는 세이브 것. 1840 은 주점 · 이야기 무장 조기 등용 조건(storyhire · town)이라 게임 동작은 그대로 두고,
-- 기기 공통 사본 CC.koBookG (ko_settings.lua, koRecBook 순서대로 한 글자 "0"~"3": 1 = 도감이 열림(koRecUnlocked), 2 = 이름이 보임(koRecSeen))
-- 에 모았다가 기록 화면을 보는 동안에만 koRecUnlocked · koRecSeen 을 「세이브 것 또는 사본」 으로 바꿔 보여 줌.
-- 모으는 때: 세이브 불러온 뒤 · 전투 끝 · 기록 화면 열 때 · 무장이 합류 · 해금될 때(koRecMeet · koRecUnlock 감싸기).
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koBookG",default=""}
local BOOKPOS=nil
local function bookPos()
	if not BOOKPOS then BOOKPOS={} for i,c in ipairs(rawget(_G,"koRecBook") or {}) do BOOKPOS[c]=i end end
	return BOOKPOS
end
local function bookG(i) return tonumber(string.sub(CC.koBookG or "",i,i)) or 0 end
function koBookSync()
	if not counting() or not rawget(_G,"koRecBook") or not rawget(_G,"koRecUnlocked") then return false end
	local s=CC.koBookG or ""
	if #s<#koRecBook then s=s..string.rep("0",#koRecBook-#s) end
	local t={} for i=1,#koRecBook do t[i]=tonumber(string.sub(s,i,i)) or 0 end
	local dirty=false
	for i,c in ipairs(koRecBook) do
		local v=t[i]
		if v%2==0 and koRecUnlocked(c) then v=v+1 end
		if v<2 and rawget(_G,"koRecSeen") and koRecSeen(c) then v=v+2 end
		if v~=t[i] then t[i]=v dirty=true end
	end
	if dirty then
		for i=1,#t do t[i]=tostring(t[i]) end
		CC.koBookG=table.concat(t)
		if rawget(_G,"koSave") then pcall(koSave) end
	end
	return dirty
end
koOn("war_end",function() pcall(koBookSync) end)
for _,nm in ipairs({"koRecMeet","koRecUnlock"}) do
	local raw=rawget(_G,nm)
	if type(raw)=="function" then
		_G[nm]=function(...) local r=table.pack(raw(...)) pcall(koBookSync) return table.unpack(r,1,r.n) end
	end
end
-- 기록 화면을 보는 동안: 세이브 것 또는 기기 공통 사본
local function withShared(fn,...)
	pcall(koBookSync)
	local rawU,rawS=rawget(_G,"koRecUnlocked"),rawget(_G,"koRecSeen")
	if rawU then koRecUnlocked=function(c) if rawU(c) then return true end local i=bookPos()[c] return i~=nil and bookG(i)%2==1 end end
	if rawS then koRecSeen=function(c) if rawS(c) then return true end local i=bookPos()[c] return i~=nil and bookG(i)>=2 end end
	local r=table.pack(pcall(fn,...))
	if rawU then koRecUnlocked=rawU end
	if rawS then koRecSeen=rawS end
	if not r[1] then error(r[2],0) end
	return table.unpack(r,2,r.n)
end

-- ---- 아군 / 적장: 주인이 무장 도감 명단(등용 가능)에 있거나 주인이 없으면 아군
local SIDE=nil
local function sideOf(k)
	if not SIDE then
		SIDE={}
		local book={}
		for _,b in ipairs(rawget(_G,"koRecBook") or {}) do if JY.Person[b] then book[JY.Person[b][NAME]]=true end end
		-- 10-28 밤 사용자: 전용 보물과 일반 보물(주인 없음, 21개 — 각성 없음)로 나눔 → 1 아군 전용 · 2 적장 전용 · 3 일반 보물
		-- 11-11 사용자 「모드에 따라 아군일 수도 적군일 수도」: 도감이 모든 모드 공용이 되어 아군 · 적장 갈래를 없앰 → 1 전용 보물 · 2 일반 보물
		for i,e in ipairs(L) do SIDE[i]=(e[4]=="") and 2 or 1 end
	end
	return SIDE[k]
end

-- ---- 그림 (칸 9 = 상세 100%, 10 = 목록 50%)
local function pics()
	if CC.koBogamPic then return end
	lib.PicLoadFile(CONFIG.DataPath.."bogam.idx",CONFIG.DataPath.."bogam.grp",9)
	lib.PicLoadFile(CONFIG.DataPath.."bogam.idx",CONFIG.DataPath.."bogam.grp",10,50)
	CC.koBogamPic=true
end
local function koBogamSq(x,y,w,h,kc)
	local kr,kg,kb=GetRGB(kc) local kd=RGB(math.modf(kr/2),math.modf(kg/2),math.modf(kb/2))
	for o=0,1 do local cc=(o==0) and kc or kd
		lib.DrawRect(x+o,y+o,x+w-1-o,y+o,cc) lib.DrawRect(x+o,y+h-1-o,x+w-1-o,y+h-1-o,cc)
		lib.DrawRect(x+o,y+o,x+o,y+h-1-o,cc) lib.DrawRect(x+w-1-o,y+o,x+w-1-o,y+h-1-o,cc)
	end
end
local function pic(slot,k,which,x,y) lib.PicLoadCache(slot,((k-1)*3+which)*2,x,y,1) end-- which 0 원본 1 ★ 2 실루엣

-- ---- 목록 상태: 갈래(1 아군 2 적장), 거르기(0 전체 1 기록 2 미기록)
local side,filt=1,0
local shown={}
local function rebuild()
	shown={}
	for k=1,#L do
		if sideOf(k)==side then
			local open=hasOrig(k) or hasStar(k)
			if filt==0 or (filt==1 and open) or (filt==2 and not open) then shown[#shown+1]=k end
		end
	end
end
local function counts(sd)
	local n,o,ns,os=0,0,0,0
	for k,e in ipairs(L) do
		if sideOf(k)==sd then
			n=n+1 if hasOrig(k) then o=o+1 end
			if e[2]>0 then ns=ns+1 if hasStar(k) then os=os+1 end end
		end
	end
	return n,o,ns,os
end
local function iname(id) return (JY.Item[id] and JY.Item[id][INAME]) or "" end

local PER=18
local SIDES={"\130\066\132\111 \131\115\131\065","\133\073\133\065 \131\115\131\065"}
local FLT={"\130\066\133\114","\131\071\133\108","\134\119\131\071\133\108"}
local function cardXY(i) local col,row=(i-1)%6,math.floor((i-1)/6) return 110+col*96,104+row*104 end
local function drawGrid(page,c)
	pics()
	rebuild()
	local n,o,ns,os=counts(side)
	c.rtext(c.ox+748,c.oy+445,"\131\071\133\108 "..o.."/"..n..((ns>0) and (" \161\164 \161\239 "..os.."/"..ns) or ""),M_Silver)
	if #shown==0 then c.ctext(c.oy+220,"\131\115\131\065\129\071 \130\097\129\075\129\076\129\077",M_Silver) return end
	for i=1,PER do
		local k=shown[(page-1)*PER+i]
		if not k then break end
		local e=L[k]
		local dx,dy=cardXY(i)
		local x,y=c.ox+dx,c.oy+dy
		local open,st=hasOrig(k),hasStar(k)
		lib.FillColor(x+2,y+2,x+66,y+66,RGB(0,0,0))
		
		if st then pic(10,k,1,x+2,y+2) elseif open then pic(10,k,0,x+2,y+2) else pic(10,k,2,x+2,y+2) end koBogamSq(x+2,y+2,64,64,(open or st) and M_Yellow or M_Silver)
		-- 10-28 사용자: 카드의 주인 이름은 뺌 (마우스를 올리면 상자에 나옴)
		local nm=(open or st) and iname(e[1]) or "???"
		DrawString(x+34-#nm*4,y+72,nm,MOUSE.IN(x,y,x+68,y+88) and C_Name or ((open or st) and M_White or M_Silver),16)
	end
end
local function gridBtns(page,c)
	local out={}
	for s=1,#SIDES do out[#out+1]={x=c.ox+16+(s-1)*96,y=c.oy+58,w=90,h=22,s=SIDES[s],sel=(side==s),bgSide=s} end
	for f=1,3 do out[#out+1]={x=c.ox+520+(f-1)*78,y=c.oy+58,w=74,h=22,s=FLT[f],sel=(filt==f-1),bgFilt=f-1} end
	rebuild()
	for i=1,PER do
		local k=shown[(page-1)*PER+i]
		if not k then break end
		local dx,dy=cardXY(i)
		out[#out+1]={x=c.ox+dx,y=c.oy+dy,w=68,h=88,s="",plain=true,bgK=k}
	end
	return out
end

-- ---- 상세 창 (카드를 누르면): 원본 · ★ 그림, 이름 · 종류 · 주인, 설명 또는 기록 조건
local function lines(s,n)
	if not s or s=="" then return {} end
	local t={}
	local _,arr=Split(GenTalkString(s,n),"*")
	for _,l in ipairs(arr) do if l~="" then t[#t+1]=l end end
	return t
end
-- 10-28 사용자: 각성 전 · 각성 후 옵션을 그림 밑에 나란히 (설명 = "\129\109\134\075*\133\111\157\178*...*\130\069\131\123: \129\118\129\119", ★ 은 "\130\069\131\123\129\111 \161\240\161\240*\133\111\157\178...")
local function split(s) local t={} if not s or s=="" then return t end local _,arr=Split(s,"*") for _,l in ipairs(arr) do if l~="" then t[#t+1]=l end end return t end
local function wrap(t,n) local o={} for _,l in ipairs(t) do for _,x in ipairs(lines(l,n)) do o[#o+1]=x end end return o end
local function detail(k)
	pics()
	local e=L[k]
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	local x,y,w,h=ox+64,oy+15,640,450
	local open,st=hasOrig(k),hasStar(k)
	local ow=(e[4]~="") and e[4] or nil
	local info=KIND[e[3]]..((ow and (" \161\164 \130\075\129\106 "..ow)) or " \161\164 \133\073\133\065 \131\115\131\065 (\130\069\131\123 \130\097\130\077)")
	-- 원본 줄 나누기: 소개 한 줄 · 옵션 · 각성 조건
	local oL=split(JY.Item[e[1]] and JY.Item[e[1]][DESC])
	local sL=(e[2]>0) and split(JY.Item[e[2]] and JY.Item[e[2]][DESC]) or {}
	if #sL>0 and string.sub(sL[1],1,#"\130\069\131\123\129\111 ")=="\130\069\131\123\129\111 " then table.remove(sL,1) end
	local inStar={} for _,l in ipairs(sL) do inStar[l]=true end
	local flavor=nil
	if #oL>1 and ((e[2]>0 and not inStar[oL[1]]) or e[2]==0) then flavor=table.remove(oL,1) end
	local cond={}
	local oOpt={} for _,l in ipairs(oL) do if string.sub(l,1,#"\130\069\131\123:")=="\130\069\131\123:" then cond[#cond+1]=l else oOpt[#oOpt+1]=l end end
	local inOrig={} for _,l in ipairs(oOpt) do inOrig[l]=true end
	local N=18
	local two=e[2]>0
	local c1=two and (x+170) or (x+w/2)
	local c2=x+470
	local A=wrap(oOpt,N)
	local B={} for _,l in ipairs(sL) do for _,q in ipairs(lines(l,N)) do B[#B+1]={q,not inOrig[l]} end end
	local hint={}
	if not open and not st then
		if sideOf(k)==2 then
			hint[1]="\135\089\129\102 \134\112\131\109\129\065 \131\071\133\108\140\106\129\076\129\077."
		else
			hint[1]=ow.."(\129\071)\129\094 \131\079\129\117 \132\075\129\102 \129\091\129\065 \137\072\138\095 \131\082\130\083\133\111\129\076\129\077."
			hint[2]="\130\066\132\101\129\102\131\087 \131\076\129\071 \131\082\131\100 \131\118\134\091 \131\117\129\083 \131\115\129\110\129\068 \131\071\133\108\140\106\129\076\129\077."
			hint[3]="(\131\076\131\097\131\098 2\130\125\132\121\130\094\131\104, \135\079\130\098 \129\068\130\066 \130\113\129\071\129\068 5 \129\071\129\067\129\102\131\087 \130\066\132\111 \131\115\131\065\129\083 \143\120\129\076\129\077)"
		end
	end
	local function col(cx,t,ty,color)
		for i=1,math.min(7,#t) do
			local s,c=t[i],color
			if type(s)=="table" then c=s[2] and C_Name or M_White s=s[1] end
			DrawString(cx-140,ty,s,c,16) ty=ty+19
		end
	end
	local function draw()
		lib.SetClip(0,0,0,0)
		lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,RGB(0,0,0))
		koRecordClassicFrame(x,y,w,h)
		local known=open or st
		local title=known and iname(e[1]) or "???"
		DrawString(x+w/2-#title*6,y+14,title,C_Name,24)
		DrawString(x+w/2-#info*4,y+44,info,M_Silver,16)
		if known and flavor then DrawString(x+w/2-#flavor*4,y+66,flavor,M_Silver,16) end
		local function box(cx,lit,which,label,lc)
			
			pic(9,k,which,cx-64,y+96) koBogamSq(cx-64,y+96,128,128,lit and M_Yellow or M_Silver)
			DrawString(cx-#label*4,y+234,label,lc,16)
		end
		box(c1,known,known and 0 or 2,two and "\130\069\131\123 \130\066" or "\129\121\129\123",M_Silver)
		if two then box(c2,st,st and 1 or 2,st and ("\130\069\131\123 \133\067 \161\164 "..iname(e[2])) or "\130\069\131\123 \133\067 ???",st and C_Name or M_Silver) end
		if known then
			col(c1,A,y+262,M_White)
			if two then
				if st then col(c2,B,y+262) else col(c2,{"\130\075\129\106\129\071 \130\069\131\123\130\086\137\074\129\065","\131\071\133\108\140\106\129\076\129\077."},y+262,M_Silver) end
			end
			local cy=y+400
			for _,l in ipairs(cond) do
				local t=lines((string.gsub(l,"^\130\069\131\123:","\130\069\131\123 \129\118\129\119:")),36)
				for i=1,math.min(2,#t) do DrawString(x+40,cy,t[i],M_Silver,16) cy=cy+19 end
				break
			end
		else
			local ty=y+270
			for _,l in ipairs(hint) do DrawString(x+40,ty,l,M_White,16) ty=ty+22 end
		end
	end
	koTourWait(draw,{{x=x,y=y,w=w,h=h,s="",plain=true,draw=function() end}})
	MOUSE.koSwallowR=true MOUSE.status='IDLE'
end
function koBogamDetailT(k) detail(k) end-- for test scripts
local function click(b)
	if b.bgSide then side=b.bgSide rebuild() return true end
	if b.bgFilt then filt=b.bgFilt rebuild() return true end
	if b.bgK then detail(b.bgK) return true end
end
-- 마우스를 올리면: 이름 · 종류 · 주인 작은 상자
local function tip(b,c)
	if not b.bgK then return end
	local k=b.bgK local e=L[k]
	local open,st=hasOrig(k),hasStar(k)
	local s1=(open or st) and iname(e[1]) or "???"
	local s2=KIND[e[3]].." \161\164 "..((e[4]~="") and e[4] or "\130\075\129\106 \130\097\130\077")
	local s3=st and ("\161\239 "..iname(e[2])) or ((e[2]>0) and "\130\069\131\123 \134\119\131\071\133\108" or "")
	local wd=math.max(#s1,#s2,#s3)*8+16
	local tx=math.min(b.x+b.w+6,c.ox+760-wd) local ty=b.y
	lib.FillColor(tx,ty,tx+wd,ty+66,RGB(16,14,12))
	DrawBox(tx,ty,tx+wd,ty+66,M_Silver,-1)
	DrawString(tx+8,ty+4,s1,C_Name,16) DrawString(tx+8,ty+24,s2,M_White,16) DrawString(tx+8,ty+44,s3,M_Silver,16)
end

-- ---- 기록 화면 탭 (병종 도감 뒤)
if rawget(_G,"koRecTabs") then
	local T={label="\131\115\131\065 \129\068\135\078",per=PER,
		n=function() rebuild() return #shown end,
		draw=drawGrid,btns=gridBtns,tip=tip,click=function(b) click(b) end}
	table.insert(koRecTabs,math.min(2,#koRecTabs+1),T)
	if rawget(_G,"koRecordScreen") then
		local raw=koRecordScreen
		function koRecordScreen(...) pcall(koBogamScan,false) CC.koBogamPic=nil return withShared(raw,...) end
	end
end

-- ---- 타이틀 메뉴 「보물 도감」: 새 기록(LoadRecord(0))으로 이름 · 설명을 읽고, 기록은 기기 공통 그대로
function koBogamScreen()
	LoadRecord(0)
	SIDE=nil
	CC.koBogamPic=nil
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	local cx=ox+384
	local page=1
	local function txt(x,y,s,color,size) DrawString(x,y,s,color or M_White,size or 16) end
	local function ctext(y,s,color,size) size=size or 16 DrawString(cx-#s*size/4,y,s,color or M_White,size) end
	local function rtext(x,y,s,color) DrawString(x-#s*8,y,s,color or M_White,16) end
	local c={ox=ox,oy=oy,cx=cx,txt=txt,ctext=ctext,rtext=rtext}
	local function bar(b,on,hover)
		if b.plain then
			if hover and b.bgK then   -- 11-11 사용자: 노란 틀이 이름 위를 지나감 → 그림 둘레만, 이름은 노란색(drawGrid)
				for d=0,1 do lib.DrawRect(b.x+d,b.y+d,b.x+67-d,b.y+d,C_Name) lib.DrawRect(b.x+d,b.y+67-d,b.x+67-d,b.y+67-d,C_Name) lib.DrawRect(b.x+d,b.y+d,b.x+d,b.y+67-d,C_Name) lib.DrawRect(b.x+67-d,b.y+d,b.x+67-d,b.y+67-d,C_Name) end
			elseif hover then DrawBox(b.x-3,b.y-3,b.x+b.w+3,b.y+b.h+3,M_Yellow,-1) end
			return
		end
		koRecordClassicBar(b.x,b.y+2,b.w,on or hover)
		DrawString(b.x+b.w/2-#b.s*4,b.y+5,b.s,M_White,16)
	end
	while true do
		rebuild()
		local pages=math.max(1,math.ceil(#shown/PER))
		if page>pages then page=pages end
		local btns={{x=ox+660,y=oy+12,w=92,h=26,s="\131\118\129\094\131\071"},
			{x=cx-150,y=oy+440,w=120,h=26,s="\129\071\130\066",prev=true},{x=cx+30,y=oy+440,w=120,h=26,s="\129\077\130\077",next=true}}
		for _,b in ipairs(gridBtns(page,c)) do btns[#btns+1]=b end
		for _,b in ipairs(btns) do b.draw=bar end
		local r=koTourWait(function()
			lib.SetClip(0,0,0,0)
			lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,RGB(0,0,0))
			koRecordClassicFrame(ox,oy,768,480)
			lib.DrawRect(ox+12,oy+48,ox+756,oy+48,M_Silver)
			lib.DrawRect(ox+12,oy+434,ox+756,oy+434,M_Silver)
			DrawString(ox+24,oy+14,"\131\115\131\065 \129\068\135\078",C_Name,24)
			drawGrid(page,c)
			ctext(oy+445,page.." / "..pages,M_Gray)
		end,btns,function(hov) if hov and btns[hov] then tip(btns[hov],c) end end)
		if r==0 or r==1 then break end
		local b=btns[r]
		if b and b.prev then if page>1 then page=page-1 end
		elseif b and b.next then if page<pages then page=page+1 end
		elseif b then if click(b) and (b.bgSide or b.bgFilt) then page=1 end end
	end
	SIDE=nil
	LoadRecord(0)
end
-- 10-29 사용자: 제목 메뉴에 「도감」 묶음 — 보물 도감 · 무장 도감 (다른 모드 아래가 아니라 따로)
-- (각 모드 타이틀 「도감」 묶음은 11-11 없앰 — 메인 화면 「도감」 단추, newgen koBookMainMenu)
-- 제목의 무장 도감: 새 기록(LoadRecord(0))으로 기록 화면을 열되 탭은 「무장 도감」 하나만 (다른 탭은 세이브 자료라 잠깐 비움), 해금은 기기 공통 사본
function koBookTitleScreen()
	if not rawget(_G,"koRecordScreen") then return end
	LoadRecord(0)
	local keep=koRecTabs
	koRecTabs={}
	local ok,err=pcall(koRecordScreen)
	koRecTabs=keep
	LoadRecord(0)
	if not ok then error(err,0) end
end

