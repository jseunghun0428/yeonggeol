-- 군웅록 (11-04): 이야기 IF 분기 (addon "ifcamp"). 설계: 개발용/문서/이야기 IF 분기 설계안.md
--   이야기 모드(CONFIG.koCamp)에서만. 영걸전 IF 는 ifbranch(view · kdef). 대본(story.lua)은 안 고치고, 그 이야기의
--   script/camp/<id>/ifcamp_data.lua(원본 개발용/camp_src/<id>/if_*_src.lua, 도구/이야기IF_빌드.py)가 대본을 불러온 뒤 Event[n] 을 감싼다.
--   事件: 243 고른 것(IF 마다 2비트: 0 아직 · 1 역사대로 · 2 IF), 244 이룸 비트, 245~249 IF 별 진행값. 0~499 라 새 회차에서 지워짐 = 회차마다 다시 고른다.
--   본 IF 결말 = CC.koIfSeen (이야기마다 ko_settings 가 따로). 후일담은 koIfEnd · koIfSummary 를 부른다(epilogue).
-- Source: 개발용/addon/ifcamp_src.lua (UTF-8) → script/addon/ifcamp.lua (도구/free_hz.pl).
if not CONFIG.koCamp then return end

local EV="\202\194\188\254"   -- 事件
local S_PICK,S_DONE=243,244
local function fv(n) return JY.Base[EV..n] or 0 end
local function setv(n,v) JY.Base[EV..n]=v end

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koIfSeen",default=""}

local DEF={}       -- k -> {name=모음 이름, ends={[무장]=문장 또는 function(c)}}
local DEFN=0
function koIfDef(k,d) if not DEF[k] then DEFN=DEFN+1 end DEF[k]=d end

function koIfVal(n) return fv(n) end
function koIfSetVal(n,v) setv(n,v) end
-- 갈림길이 뜰 수 있는 때: 이야기 본편만 (다시 전투 · 자유 전투 · 정벌 · 외전은 역사대로)
function koIfOn()
	if CC.koReplay or CC.koFree then return false end
	local f=rawget(_G,"koWujeCampaignActive")
	return f==nil or f()
end
function koIfChoice(k) return math.floor(fv(S_PICK)/4^(k-1))%4 end
local function setChoice(k,v) setv(S_PICK,fv(S_PICK)+(v-koIfChoice(k))*4^(k-1)) end
function koIfDoneOf(k) return math.floor(fv(S_DONE)/2^(k-1))%2==1 end
-- 장면 바꾸기 조건: 이번 판에 그 IF 를 이룸 (다시 전투 안에서는 역사대로)
function koIfAct(k) return koIfOn() and koIfDoneOf(k) end
-- 갈림길: 1 = 역사대로, 2 = IF. 이미 고른 칸이면 그 값
function koIfPick(k,desc,hist,alt)
	if not koIfOn() then return 1 end
	local v=koIfChoice(k)
	if v>0 then return v end
	if fv(S_PICK)==0 then DrawMulitStrBox("\134\074\130\114\130\104 \131\085\134\078 \129\113 \132\079\130\098 \132\065\133\121\129\104\129\076\129\077.*\161\239 \130\104 \131\100\130\106\129\065 \129\071 \130\070\131\080 \129\071\133\069\131\071\129\094 \133\073\130\094 \131\085\136\149\129\076\129\077.*\131\097 \132\065\131\087 \161\164 \137\096\143\228\131\098 \132\071\129\075\129\076\129\077.") end
	if desc then DrawMulitStrBox(desc) end
	local r=SnrChoice({hist,"\161\239 "..alt})
	setChoice(k,r)
	return r
end
-- 고른 값만 적음 (조건을 못 채워 역사대로 돌아갈 때)
function koIfSetChoice(k,v) setChoice(k,v) end
function koIfDone(k)
	if not koIfDoneOf(k) then setv(S_DONE,fv(S_DONE)+2^(k-1)) end
	local nm=DEF[k] and DEF[k].name
	if nm and not string.find(CC.koIfSeen or "",","..nm..",",1,true) then
		CC.koIfSeen=((CC.koIfSeen or "")=="" and "," or CC.koIfSeen)..nm..","
		if rawget(_G,"koSave") then pcall(koSave) end
	end
end
-- 후일담 (epilogue card): 이룬 IF 의 무장 결말이 먼저
function koIfEnd(name)
	for k,d in pairs(DEF) do
		if koIfDoneOf(k) and d.ends and d.ends[name] then return d.ends[name] end
	end
	return nil
end
function koIfSummary()
	if DEFN==0 then return nil end
	local n=0
	for _,d in pairs(DEF) do if string.find(CC.koIfSeen or "",","..tostring(d.name)..",",1,true) then n=n+1 end end
	return "IF \134\064\136\124 "..n.." / "..DEFN
end
-- 사건 감싸기: fn(원래 함수, 사건 인자...)
function koIfWrap(ev,fn)
	local orig=Event[ev]
	if orig==nil then error("ifcamp: no event "..tostring(ev)) end
	Event[ev]=function(...) return fn(orig,...) end
end

-- ---------------------------------------------------------------- 대사 몇 줄만 바꾸기
-- koIfLines(사건, 조건, 표): 조건(k 번호 또는 function)이 참인 동안 그 사건의 talk · DrawMulitStrBox · DrawStrBoxCenter 에서
--   표[원문]= 새 문장 / false(그 줄 지움) / {화자,문장} (화자도 바꿈) / {화자,문장,화자,문장…} (여러 줄로).
--   원문은 대본 그대로(대사고침 뒤). 시험용 koIfLinesMiss() = 한 번도 안 맞은 원문.
local LINES={}   -- ev -> {{cond,map},...}
local HIT,ALL={},{}
local function active(ev)
	local t={}
	for _,e in ipairs(LINES[ev] or {}) do
		local c=e[1]
		local ok=(type(c)=="function" and c()) or (type(c)=="number" and koIfAct(c))
		if ok then for o,n in pairs(e[2]) do t[o]=n end end
	end
	return t
end
local function withLines(ev,orig,...)
	local map=active(ev)
	if next(map)==nil then return orig(...) end
	local T,B,C=talk,DrawMulitStrBox,DrawStrBoxCenter
	talk=function(...)
		local a,o={...},{}
		for i=1,select("#",...),2 do
			local who,s=a[i],a[i+1]
			local n=map[s]
			if n==nil then o[#o+1]=who o[#o+1]=s
			else
				HIT[s]=true
				if type(n)=="string" then o[#o+1]=who o[#o+1]=n
				elseif type(n)=="table" then for _,x in ipairs(n) do o[#o+1]=x end end
			end
		end
		if #o>0 then return T(table.unpack(o)) end
	end
	local function box(F)
		return function(s,...)
			local n=map[s]
			if n==nil then return F(s,...) end
			HIT[s]=true
			if type(n)=="string" then return F(n,...) end
		end
	end
	DrawMulitStrBox=box(B)
	DrawStrBoxCenter=box(C)
	local r={pcall(orig,...)}
	talk,DrawMulitStrBox,DrawStrBoxCenter=T,B,C
	if not r[1] then error(r[2],0) end
	return table.unpack(r,2)
end
function koIfLines(ev,cond,map)
	if not LINES[ev] then
		LINES[ev]={}
		koIfWrap(ev,function(orig,...) return withLines(ev,orig,...) end)
	end
	table.insert(LINES[ev],{cond,map})
	for o,_ in pairs(map) do ALL[o]=ev end
end
function koIfLinesMiss()
	local m={}
	for o,ev in pairs(ALL) do if not HIT[o] then m[#m+1]=ev..": "..o end end
	return m
end

-- 전투 적 바꾸기: 조건이 참일 때 그 사건의 SnrSetEnemies 표를 fn(표) 로 고침. 표 = 11칸씩(첫 칸 = 인물 번호-1)
function koIfEnemies(ev,cond,fn)
	koIfWrap(ev,function(orig,...)
		local ok=(type(cond)=="function" and cond()) or (type(cond)=="number" and koIfAct(cond))
		if not ok then return orig(...) end
		local S=SnrSetEnemies
		SnrSetEnemies=function(list) fn(list) return S(list) end
		local r={pcall(orig,...)}
		SnrSetEnemies=S
		if not r[1] then error(r[2],0) end
		return table.unpack(r,2)
	end)
end
function koIfRowDrop(list,pid)
	for i=1,#list,11 do
		if list[i]==pid-1 then for _=1,11 do table.remove(list,i) end return true end
	end
	return false
end
function koIfRowSwap(list,from,to)
	for i=1,#list,11 do
		if list[i]==from-1 then list[i]=to-1 return true end
	end
	return false
end
-- 전투 안 무장이 아직 살아 있나
function koIfAlive(pid)
	local wid=GetWarID(pid)
	if not wid or wid<=0 then return false end
	local v=War.Person[wid]
	return v~=nil and v.live==true
end
