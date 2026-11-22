-- ko 5.0: 삼형제 분기 (view) — 유비 본편으로 진행하다가 분기마다 따라갈 형제(유비·관우·장비)를 골라 외전 막을 플레이.
-- 따로 켜고 끄는 모드가 아니라 늘 켜져 있음(10-07 사용자: 종횡·자유 모드 모두 삼형제 분기 고정).
-- 설계: 개발용/문서/삼형제 시점 설계안.md. Source: 개발용/addon/view_src.lua (UTF-8) → script/addon/view.lua (도구/free_hz.pl).
-- 플래그(事件): 400 지금 외전의 형제(0 없음·2 관우·3 장비), 401 안 씀(예전 「삼형제 모드 켜기」 칸, 10-07 없앰),
--  402 외전 중이면 갈라져 나온 본편 사건 번호(koStoryEv, jymain), 403 시점 엔딩을 봄, 404~419 막 완료, 420~449 외전 이야기·보너스,
--  450~459 분기에서 고른 형제 기록(450 ① 서주 함락, 451 ② 남정, 452 ③ 형주 남부, 453 ④ 장비, 454 ④ 관우, 455 ⑤ 맥성 이후).
-- 외전이 아니면(402=0) 진행도 판정은 지금과 똑같음.

local EV="\202\194\188\254"   -- 事件 (GBK)
local function fv(n) return JY.Base[EV..n] or 0 end
local function setv(n,v) JY.Base[EV..n]=v end

-- koStoryEv 는 jymain(patch_삼형제_기반.pl)에 있음. 없을 때를 대비한 대체
if not rawget(_G,"koStoryEv") then
function koStoryEv() local v=fv(402) if v>0 then return v end return JY.EventID end
end

function koViewOn() return not (CC.koReplay or CC.koFree) end
function koViewSide() return fv(402)>0 end
function koViewBro() return fv(400) end

-- 진행도를 JY.EventID 로 판정하는 전역 함수는 부르는 동안만 JY.EventID 를 본편 사건 번호로 (외전 사건 710~ 이 장 경계보다 커서)
local function asStory(f)
	return function(...)
		local raw=JY.EventID
		local s=koStoryEv()
		if s==raw then return f(...) end
		JY.EventID=s
		local r={pcall(f,...)}
		JY.EventID=raw
		if not r[1] then error(r[2],0) end
		return (table.unpack or rawget(_G,"unpack"))(r,2)
	end
end
for _,n in ipairs({"koRecAvail","koUnlock","koUnlockText","koHireTables","koFreeChapter"}) do
	local f=rawget(_G,n)
	if type(f)=="function" then _G[n]=asStory(f) end
end

-- 자유 전투의 저장 칸 미리보기: 외전 중 저장이면 장 판정을 402 로
do
	local peek=rawget(_G,"koFreeSlotPeek")
	if type(peek)=="function" then
		function koFreeSlotPeek(id)
			local r=peek(id)
			if r and r.flag then
				local s=r.flag(402) or 0
				if s>0 then
					r.chapter=(s>=592 and 4) or (s>=382 and 3) or (s>=226 and 2) or (s>=23 and 1) or 0
					r.used=((r.flag(1993) or 0)==r.chapter+1) and (r.flag(1992) or 0) or 0
					local mx=rawget(_G,"koFreeExpMax")
					if mx then r.left=math.max(0,mx-r.used) end
				end
			end
			return r
		end
	end
end

-- 술집: 본편 사건 번호로 (외전 중에도 열림 — 10-07 사용자 「외전도 본편처럼」)
do
	local hire=rawget(_G,"HirePerson")
	if type(hire)=="function" then
		local h2=asStory(hire)
		function HirePerson(...)
			return h2(...)
		end
	end
end

-- 외전 전투: 그 형제가 퇴각하면 패배 (설계안 4.4). 되감기·전투 중 불러오기는 war_begin 을 다시 부르지 않으므로 WarLoad 도 감쌈
local function markLeader()
	if ((CC.koFree or CC.koReplay) and not CC.koSideReplay) or not koViewSide() then return end
	local b=koViewBro()
	if b<=0 then return end
	local w=GetWarID(b)
	if w>0 then War.Person[w].leader=true end
end
koOn("war_begin",markLeader)
do
	local wl=rawget(_G,"WarLoad")
	if type(wl)=="function" then
		function WarLoad(...)
			local r=wl(...)
			markLeader()
			return r
		end
	end
end

-- 외전 전투의 빈자리 2개(10-07 사용자): 출진 후보 = 해금(술집·마을·술 겨루기 등)으로 들인 장수만.
-- 이야기로 합류하는 장수(kdef 의 ModifyForce(n,1) 전부)와 유비는 출진 화면 동안만 君主 를 0 으로 숨겼다가 되돌림.
-- 코스트 출진은 본편과 같음(10-07 사용자).
local KLORD0="\190\253\214\247"   -- 君主
local STORY={}
for _,p in ipairs({1,2,3,24,30,31,34,35,38,39,44,54,58,59,64,65,80,82,83,91,112,114,117,126,127,128,129,133,148,155,165,166,167,170,175,182,188,190,191,
	200,201,202,203,204,208,209,221,224,229,235,236,237,244,245,246,248,252,253,254,255,376}) do STORY[p]=true end
function koViewEligible(p) return not STORY[p] end   -- 외전 빈자리에 들어갈 수 있는 장수인가 (하네스도 씀)
do
	local st=rawget(_G,"SelectTerm")
	if type(st)=="function" then
		function SelectTerm(fid,team)
			if fid~=1 or not koViewSide() or ((CC.koFree or CC.koReplay) and not CC.koSideReplay) then return st(fid,team) end
			local fixed={}
			for j=1,30 do
				local v=team[(j-1)*7+1]
				if v==nil then break end
				if v>=0 then fixed[v+1]=true end
			end
			local hid={}
			for i=1,JY.PersonNum-1 do
				if not koViewEligible(i) and not fixed[i] and JY.Person[i][KLORD0]==1 then
					hid[#hid+1]=i
					JY.Person[i][KLORD0]=0
				end
			end
			-- 빈자리에 넣을 장수가 하나도 없으면(해금 장수 없음) 빈 출진 화면 없이 고정 인원만으로 시작 (10-10 사용자: 장비 소패 야습)
			local koAny=false
			for i=1,JY.PersonNum-1 do if not fixed[i] and JY.Person[i][KLORD0]==1 then koAny=true break end end
			if not koAny and rawget(_G,"SelectTerm_sub") then
				local t={}
				for i=1,#team,7 do if team[i]>=0 then for j=0,6 do t[#t+1]=team[i+j] end end end
				CC.koSlotBase=#t/7
				local ok,e=pcall(SelectTerm_sub,1,t)
				for _,i in ipairs(hid) do JY.Person[i][KLORD0]=1 end
				if not ok then error(e,0) end
				return
			end
			local data=JY.Data_Person
			local ok,e=pcall(st,fid,team)
			if JY.Data_Person==data then   -- 출진 화면에서 세이브를 불러왔으면 되돌리지 않음(새 기록)
				for _,i in ipairs(hid) do JY.Person[i][KLORD0]=1 end
			end
			if not ok then error(e,0) end
		end
	end
end

-- 원작 틀 메뉴 (DrawYJZBox + ShowMenu): 위에 설명 상자, 아래 고르기. 고른 번호(1부터)
local function pick(desc,items)
	local m={}
	for i,s in ipairs(items) do m[i]={s,nil,1} end
	local r
	repeat
		if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then DrawSMap() end   -- 지금 장면 위에 (10-07: 검은 화면 아님)
		DrawYJZBox(-1,70,desc,M_White,true)
		ShowScreen()
		r=ShowMenu(m,#m,0,0,0,0,0,2,0,16,M_White,M_White)
	until r and r>0
	return r
end
koViewPickMenu=pick

-- 분기에서 따라갈 형제 고르기 (1단계부터 kdef 분기 지점에서 부름). who = 고를 수 있는 형제 pid 목록(1 유비 포함), 기록 칸 slot(450~459).
-- 장면 재현·자유 전투 중이면 늘 1(유비). 이미 고른 칸이면 그 값.
local NAME={[1]="\130\071\130\080\130\104 \130\105\135\077\129\077 (\132\118\132\075)",[2]="\129\101\131\079\130\104 \130\105\135\077\129\077",[3]="\131\097\130\080\130\104 \130\105\135\077\129\077"}
function koViewPick(slot,desc,who)
	if not koViewOn() then return 1 end
	local v=fv(slot)
	if v>0 then return v end
	local items={}
	for i,p in ipairs(who) do items[i]=NAME[p] end
	local r=pick(desc,items)
	setv(slot,who[r])
	return who[r]
end

-- 새 무장(관우 외전): 391~396 오관 장수(일기토 사본이던 칸), 416 배원소, 417 호반. 원본 무장표(newgame.grp, patch_삼형제_무장.pl)를
--  기준으로, 옛 세이브에 남은 다른 기록(일기토 사본·빈 칸)이면 불러올 때 원본 기록으로 바꿈. 아군이 된 무장(君主=1)은 건드리지 않음.
local NEWP={391,392,393,394,395,396,397,398,416,417}
local KNAME,KLORD="\208\213\195\251","\190\253\214\247"   -- 姓名, 君主 (GBK)
function koViewFixPersons()
	if not (JY.Person and JY.Data_Person_Base) then return end
	for _,p in ipairs(NEWP) do
		-- 얼굴은 아군이 된 뒤에도 원본 기록을 따름 (10-11: 배원소 새 얼굴 1244, 옛 세이브는 예비 얼굴 154)
		if JY.PersonNum>p then local FC="\205\183\207\241\180\250\186\197" local bf=GetDataFromStruct(JY.Data_Person_Base,p*CC.PersonSize,CC.Person_S,FC) if JY.Person[p][FC]~=bf then JY.Person[p][FC]=bf end end
		-- 천부·특기가 아직 옛 틀(장연 220: 천부 22, 특기 10·13·20·12·11·6)이면 원본 기록의 것으로 (10-11: 술집 등용 때 각자 특기를 줌, 옛 세이브)
		if JY.PersonNum>p and JY.Person[p]["\204\236\184\179"]==22 and JY.Person[p]["\204\216\188\188".."1"]==10 and JY.Person[p]["\204\216\188\188".."2"]==13 then
			JY.Person[p]["\204\236\184\179"]=GetDataFromStruct(JY.Data_Person_Base,p*CC.PersonSize,CC.Person_S,"\204\236\184\179")
			for k=1,6 do JY.Person[p]["\204\216\188\188"..k]=GetDataFromStruct(JY.Data_Person_Base,p*CC.PersonSize,CC.Person_S,"\204\216\188\188"..k) end
		end
		if JY.PersonNum>p and JY.Person[p][KLORD]~=1 then
			local bn=GetDataFromStruct(JY.Data_Person_Base,p*CC.PersonSize,CC.Person_S,KNAME)
			if JY.Person[p][KNAME]~=bn then
				for k,_ in pairs(CC.Person_S) do
					JY.Person[p][k]=GetDataFromStruct(JY.Data_Person_Base,p*CC.PersonSize,CC.Person_S,k)
				end
			end
		end
	end
end
do
	local lr=rawget(_G,"LoadRecord")
	if type(lr)=="function" then
		function LoadRecord(...)
			local r=lr(...)
			koViewFixPersons()
			if rawget(_G,"koViewFixTitle") then koViewFixTitle() end
			if rawget(_G,"koViewFixZhao") then koViewFixZhao() end
			if rawget(_G,"koViewFixJing") then koViewFixJing() end
			return r
		end
	end
end

-- 술집 등용 (10-11 사용자: 새 무장 8명): 관우 외전 ① 의 오관 장수 6명·배원소·호반. 조건 = 이 기기에서 관우 외전 ① 을 한 번이라도 끝냄
--  (CC.koViewClr, 설정 파일에 남음 — 이 판의 407 도 됨) + 본편이 고성 재회(263)를 지남. 지난 회차에서 이어받은 장수도 263 을 지나야 나옴
--  (koExtraHire 다섯째 칸 true, patch_술집이어받기문턱.pl) — 외전 ① 에서 이들이 적으로 나오므로. 이어받기 칸 1802~1809.
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koViewClr",default=0} end
function koViewMarkClr()
	if (CC.koViewClr or 0)<1 then CC.koViewClr=1 if rawget(_G,"koSave") then pcall(koSave) end end
end
if type(rawget(_G,"koExtraHire"))=="table" then
	for i,p in ipairs({391,392,393,394,395,396,416,417}) do
		koExtraHire[#koExtraHire+1]={p,263,1801+i,{"view1"},true}
		koExtraEv[p]=1801+i
	end
	local rawReq=koExtraReq
	function koExtraReq(x)
		local r=x[4]
		if type(r)=="table" and r[1]=="view1" then return (CC.koViewClr or 0)>=1 or fv(407)>0 end
		return rawReq(x)
	end
end

-- 외전 들어가기·나오기 (kdef 외전 사건이 부름)
local KCH,KPLACE="\213\194\189\218\195\251","\207\214\212\218\181\216"   -- 章节名, 现在地 (GBK)
local TITLE={[2]="\131\107\130\066\161\161\129\101\131\079 \130\115\129\117\130\093",[3]="\131\107\130\066\161\161\131\097\130\080 \131\100\131\123\131\071"}
-- bro 2 관우·3 장비, story = 갈라져 나온 본편 사건, first = 외전 첫 사건. 장 제목이 「외전」으로 시작하면 마을(town)이 꺼짐
function koViewGo(bro,story,first)
	setv(400,bro) setv(402,story)
	ModifyForce(bro,1)
	JY.Base[KCH]=TITLE[bro] or "\131\107\130\066"
	JY.Smap={}
	JY.Status=GAME_SMAP_AUTO
	NextEvent(first)
end
-- 외전 진행 중 장 제목(세이브 목록·화면 왼쪽 아래)을 지금 장소로: 「외전 관우 백마」 (10-07 사용자: 전부 「관우 천리행」이라 구분이 안 됨)
--  「외전」으로 시작해야 town 애드온의 외전 마을 표가 켜짐
-- 10-07 사용자: 본편 장 제목처럼 이야기가 드러나게 — 장소 → 제목
local PTITLE={
	[2]={["\131\097\130\114"]="\134\077\129\068\130\094\130\125",["\130\087\131\123"]="\129\113\135\110\134\082\130\084",["\129\097\130\080"]="\137\083\132\091\131\080 \131\111 \135\067\133\123",["\135\109\129\068"]="\135\109\129\068\131\080 \136\079\131\097",["\134\101\133\088"]="\130\111\132\088\129\083 \131\113\129\077",["\133\066\129\103"]="\133\066\129\103\131\080 \133\100\134\114",["\139\085\129\106\135\087\131\103"]="\139\085\129\106\135\087\131\103",["\129\091\129\101"]="\129\077\144\093 \129\101\133\090\129\083 \132\124\130\083",["\131\100\131\123"]="\131\100\131\123\131\080 \129\115\130\125"},
	[3]={["\134\107\130\101"]="\134\107\130\101\131\080 \141\066",["\134\086\130\084"]="\131\080\132\090\135\110\130\111",["\129\109\129\079"]="\129\109\129\079\131\080 \141\066",["\136\111\140\109\132\091"]="\136\111\140\109\132\091\131\080 \131\097\133\083\135\086",["\131\100\131\123"]="\131\100\131\123\129\083 \132\121\130\067\129\097\129\077"},
}
local PLOC={["\135\109\129\068"]="\135\109\134\103",["\139\085\129\106\135\087\131\103"]="\135\109\134\103",["\129\091\129\101"]="\130\108\130\089\129\101"}
function koViewLoc(name) JY.Base[KPLACE]=name end
function koViewPlace(place)
	-- 보병대 병사(259·260)의 장면 그림: 원작 보병 레코드의 녹색 옷(175)은 농민처럼 보임 → 파란 갑옷 병사(172) (10-10 사용자)
	for _,p in ipairs({259,260}) do if JY.PersonNum>p and JY.Person[p]["\208\206\207\243"]==175 then JY.Person[p]["\208\206\207\243"]=172 end end   -- 形象
	-- 장비 외전의 산적 부하(311·312, 원작 「적병」 레코드): 이름 「산적」(koViewBack 이 되돌림). 그림은 unique 애드온의 고유 도시 조형(사용자가 준 산적 평상조형, smap 2644~2655, 311~313) — 잠깐 바꿨던 192·193 은 197 로 되돌림 (10-10 사용자)
	if fv(400)==3 then for _,p in ipairs({311,312}) do local P=JY.Person[p] if P["\208\206\207\243"]==192 or P["\208\206\207\243"]==193 then P["\208\206\207\243"]=197 end if P["\208\213\195\251"]=="\131\076\130\126" then P["\208\213\195\251"]="\132\091\131\076" end end end
	local t=PTITLE[fv(400)]
	JY.Base[KCH]="\131\107\130\066\161\161"..((t and t[place]) or place)
	JY.Base[KPLACE]=PLOC[place] or place   -- 현재위치도 (10-09 사용자: 오관인데 백마로 나옴)
end
-- 옛 외전 세이브(장 제목이 아직 「외전　관우 천리행」·「외전　장비 고성기」)를 불러오면 사건 번호로 장소 제목을 넣음 (10-07 사용자)
local PLACE_EV={{710,714,"\129\097\130\080"},{715,717,"\135\109\129\068"},{733,733,"\135\109\129\068"},{718,721,"\134\101\133\088"},{734,734,"\134\101\133\088"},{722,724,"\133\066\129\103"},
	{725,725,"\139\085\129\106\135\087\131\103"},{749,749,"\139\085\129\106\135\087\131\103"},{726,731,"\129\091\129\101"},{740,748,"\129\091\129\101"},{732,732,"\131\100\131\123"},{760,765,"\131\097\130\114"},{770,774,"\130\087\131\123"},{814,817,"\129\109\129\079"},{800,804,"\136\111\140\109\132\091"},{818,821,"\136\111\140\109\132\091"},{805,813,"\131\100\131\123"},{822,826,"\131\100\131\123"},
	{827,827,"\129\097\130\080"},{828,829,"\139\085\129\106\135\087\131\103"},{830,831,"\131\097\130\114"},{832,833,"\130\087\131\123"},{834,835,"\129\109\129\079"},{836,836,"\136\111\140\109\132\091"},{837,837,"\131\100\131\123"},{840,845,"\134\086\130\084"},{850,855,"\134\107\130\101"}}
function koViewFixTitle()
	local b=fv(400)
	if b<=0 then return end
	-- 고칠 제목: 옛 「외전　관우 천리행」·「외전　장비 고성기」, 10-07 잠깐 쓴 「외전 관우 백마」 꼴
	local cur=JY.Base[KCH]
	local old=(cur==TITLE[b])
	for _,r in ipairs(PLACE_EV) do
		if cur==((b==3 and "\131\107\130\066 \131\097\130\080 " or "\131\107\130\066 \129\101\131\079 ")..r[3]) or (r[3]=="\139\085\129\106\135\087\131\103" and cur=="\131\107\130\066 \129\101\131\079 \135\109\129\068") then old=true end
	end
	if not old then return end
	for _,r in ipairs(PLACE_EV) do
		if JY.EventID>=r[1] and JY.EventID<=r[2] then koViewPlace(r[3]) return end
	end
end
-- 외전을 마치고 본편 사건 ret 으로. title·place 가 있으면 장 제목·현재 위치를 다시 넣음
function koViewBack(ret,title,place,keep)
	local b=fv(400)
	if b>0 then ModifyForce(b,0) end
	if b==3 then for _,p in ipairs({311,312}) do local P=JY.Person[p] if P["\208\213\195\251"]=="\132\091\131\076" then P["\208\213\195\251"]="\131\076\130\126" end end end   -- 산적 부하를 원작 「적병」으로
	setv(400,0) setv(402,0)
	if title then JY.Base[KCH]=title end
	if place then JY.Base[KPLACE]=place JY.Base["\129\068\130\119\129\067"]=0 end
	if not keep then JY.Smap={} end   -- keep: 본편 첫 대사를 이 장면 위에서 (관우 외전 → 영천 263, 10-09)
	JY.Status=GAME_SMAP_AUTO
	NextEvent(ret)
end
-- 외전 중 마을에 머묾 (10-07 사용자 「외전도 본편처럼」): 지금 장면 그대로 직접 조작으로. 현재 위치·도구상을 그 마을로 해서
-- 본편처럼 상점·술집 단추와 「나가기」 화살표(town 애드온: 외전 마을 허창·백마·고성)를 씀. ev = 사람을 누를 때 부를 사건(JY.Tid 로 갈라짐)
-- 10-17 카페 제보: 관우 외전 ④ 강릉(단도부회 830·번성 앞 832)에 머무는 동안 형주 장수(관평·주창·요화·왕보·조루)가
--  무장 정보에 없어 씨앗을 못 줌 — kdef 는 전투(762·771) 때만 君主=1 로 했음. 머무는 동안에도 아군으로 (단도부회 뒤 764·765 가 0 으로 되돌림, 번성 뒤는 본편 568 합류라 그대로)
local JING={128,155,34,38,39}
local function jingOurs(ev)
	if fv(400)==2 and (ev==830 or ev==832) then
		for _,p in ipairs(JING) do if JY.PersonNum>p then JY.Person[p][KLORD0]=1 end end
	end
end
function koViewStop(place,shop,ev)
	jingOurs(ev)
	JY.Base[KPLACE]=place
	JY.Base["\129\068\130\119\129\067"]=shop or 0
	JY.Status=GAME_SMAP_MANUAL
	NextEvent(ev)
end
function koViewFixJing() jingOurs(JY.EventID) end   -- 강릉에 머물던 옛 세이브

-- 마을 주민으로 쓰면 안 되는 레코드 (10-10 사용자: 하비 마을에 미부인이 주민으로 나옴): 형수님 대역 371·361 이 「감부인」·「미부인」인 동안
function koViewReserved(pid)
	local NM="\208\213\195\251"
	return (pid==371 and JY.Person[371][NM]=="\135\078\130\094\129\106") or (pid==361 and JY.Person[361][NM]=="\134\119\130\094\129\106")
end

-- 관우 외전 하비·허창 장면의 두 형수 (10-10): 일반 레코드 371(부인)·361(여자)을 장면 동안 「감부인」·「미부인」으로 부르고
--  361 은 r형상 미씨 그림(형상 750)으로 바꿈. 장면 끝의 마을 정비 멈춤 동안에도 그대로 두었다가, 다음 사건 첫머리에서 이것으로 되돌림.
function koViewLadiesOff()
	local NM,FG="\208\213\195\251","\208\206\207\243"   -- 姓名, 形象
	if JY.Person[371][NM]=="\135\078\130\094\129\106" then JY.Person[371][NM]="\130\094\129\106" end
	if JY.Person[361][NM]=="\134\119\130\094\129\106" then JY.Person[361][NM]="\129\098\133\120" end
	if JY.Person[361][FG]==750 then JY.Person[361][FG]=154 end
end

-- 장비 외전 고성 대치(809)의 「？？？」(373): 원작에서 고성의 정체 모를 관우로 쓰던 레코드라 전투 그림이 관우 것 →
--  장비 외전(형제 3) 동안에는 유비(1)의 전투 그림으로 그림 (10-10 사용자). 세이브를 불러와 그림을 다시 계산해도 같게 GetPic 을 감쌈.
do
	local koGP=GetPic
	function GetPic(pid,enemy,friend)
		if pid==373 and fv(400)==3 then
			local r=koGP(1,enemy,friend)
			JY.Person[373]["\213\189\182\183\182\175\215\247"]=r   -- 战斗动作
			return r
		end
		if pid==261 and fv(400)==3 and fv(402)==485 and type(War)=="table" and War.Person then   -- 파군 전투의 가짜 장비(보병대 261)는 장비 그림 (10-10)
			return koGP(3,enemy,friend)
		end
		return koGP(pid,enemy,friend)
	end
end

-- 장면 인물을 지점들을 거쳐 걸려 보냄 (10-10 사용자: 의석엄안에서 책상을 뚫고 지나감·원하는 자리에 못 섬). MovePerson 은 (±2,±1) 칸 단위라
--  자리를 마음대로 못 고름 → 소수 좌표까지 곧게 걷기. 걸음 빠르기·걷기 그림·그리는 순서는 MovePerson 과 같음(한 칸에 5번 그림).
--  pts = {{x,y},{x,y},...}, face = 끝에서 볼 방향(없으면 걸어온 방향). 방향: 0 오른쪽 위, 1 왼쪽 아래, 2 왼쪽 위, 3 오른쪽 아래.
function koViewWalk(pid,pts,face)
	local v
	for _,s in pairs(JY.Smap) do if s[1]==pid then v=s break end end
	if not v then return end
	for _,p in ipairs(pts) do
		local x0,y0=v[2],v[3]
		local dx,dy=p[1]-x0,p[2]-y0
		local n=math.max(1,math.floor(math.max(math.abs(dx)/2,math.abs(dy))*5+0.5))
		if dx>=0 and dy<0 then v[4]=0 elseif dx<0 and dy>=0 then v[4]=1 elseif dx<0 and dy<0 then v[4]=2 else v[4]=3 end
		v[5]=1
		for i=1,n do
			v[2]=x0+dx*i/n v[3]=y0+dy*i/n
			JY.ReFreshTime=lib.GetTime()
			DrawSMap()
			lib.GetKey()
			ReFresh(1.25)
		end
	end
	v[5]=0
	if face then v[4]=face end
	SortPerson()
	DrawSMap()
	ShowScreen()
end

-- 외전 전투 앞 마을 정비 (10-10 사용자: 「관우외전처럼 마을 돌아다니게」): 장면 끝에서 koViewStop(마을, 상점, 손잡이 사건) 으로 멈추면
--  town 애드온이 그 마을 거리·주점·도구상을 열어 줌(외전 마을 표 EXT). 손잡이 사건(827~837)은 이 함수 하나: 부관(aide)을 누르면 ask 로 묻고
--  예면 ev 로. 형제 자신을 누르면 self 혼잣말(있으면). 손잡이 사건 번호가 마을 대사의 때(REVISIT after)를 가름.
function koViewTownGo(aide,ev,ask,self)
	if JY.Tid==aide then
		if talkYesNo(aide,ask) then
			JY.Status=GAME_SMAP_AUTO
			NextEvent(ev)
		end
	elseif self and JY.Tid==koViewBro() then
		talk(JY.Tid,self)
	end
end

-- 외전 전투의 우군(조조 진영 장수·일반 병사): 세이브에 남은 레벨이 낮으면(본편에서 적으로 나왔던 값) 그 형제 레벨+add 까지 올림 (10-07 사용자)
function koViewAllyLv(list,add)
	local LV="\181\200\188\182"   -- 等级
	local b=koViewBro()
	if b<=0 then b=1 end
	local lv=JY.Person[b][LV]+(add or 2)
	local BZ="\177\248\214\214"   -- 兵种
	for _,p in ipairs(list) do
		if JY.PersonNum>p and JY.Person[p][LV]<lv then JY.Person[p][LV]=lv end
		-- 일반 병사(보병·궁병·기병·적병대 257~328)는 적 일반병의 종횡 자동 승급과 같은 규칙으로 병종 단계를 레벨에 맞춤 (Lv15 2단계·Lv30 3단계, 10-08 사용자: 우군이 단병)
		local bz=JY.PersonNum>p and p>=257 and p<=328 and JY.Person[p][BZ] or 0
		if bz>=1 and bz<=12 then
			local plv=JY.Person[p][LV]
			local tier=(plv>=30 and 3) or (plv>=15 and 2) or 1
			JY.Person[p][BZ]=math.floor((bz-1)/3)*3+tier
		end
	end
end

-- 형주에 남아 싸우지 못한 관우 쪽 장수를 그 시점 유비군 상위 평균(pjlv) + add 까지 끌어올림. 원래 더 높으면 그대로 (10-10 사용자: 익주에서 키운 만큼 따라오게)
-- pjlv 는 君主 1 인 장수로 셈하므로 형주 장수의 君主 를 1 로 바꾸기 전에 부를 것
function koViewLvToArmy(list,add)
	local LV="\181\200\188\182"   -- 等级
	local ok,avg=pcall(pjlv)
	if not ok or type(avg)~="number" or avg<=0 then return end
	local lv=math.min(99,avg+(add or -2))
	for _,p in ipairs(list) do if JY.PersonNum>p and JY.Person[p][LV]<lv then JY.Person[p][LV]=lv end end
end

-- 구간 ① 을 건너뛴 몫 (서주II·연주·고성, 219~257): 조운 합류, 금 2,000(600+700+700), 유비 Lv+2, 고성 대역 정리
function koViewGiveSeg1()
	ModifyBZ(54,({[1]=2,[4]=5,[7]=8,[10]=11,[23]=24})[JY.Person[54]["\177\248\214\214"]] or JY.Person[54]["\177\248\214\214"]) LvUp(54,7) ModifyForce(54,1)--ko 4.0: tier-1 class goes up one step (original 경기병 -> 중기병); a class changed while he was a guest is kept (10-14: LvUp·ModifyForce 가 주석 안에 들어가 조운이 합류 안 하던 것 고침)
	ModifyForce(374,0)
	LvUp(1,2)
	koSetGold(koGold()+2000) koHook("gold_gain",2000)
	DrawStrBoxCenter("\129\118\135\083\129\071 \130\071\130\080\130\084\129\102 \129\087\129\093\129\080\129\077! \130\085\131\103 2,000\129\083 \133\072\131\116\129\077.")
end

-- 10-14 사용자: 외전 ① 을 마치고 본편으로 온 세이브에 조운이 없음(위 koViewGiveSeg1 의 합류 줄이 주석 안에 있었음) → 불러올 때 채움.
--  ① 에서 형제를 골랐고(450 = 2·3) 외전 밖이며 본편 258~398(399 에서 조운이 잠시 떠남) 사이인데 조운이 아군이 아니면
function koViewFixZhao()
	local e=JY.EventID or 0
	if (fv(450)==2 or fv(450)==3) and fv(400)==0 and e>=258 and e<=398 and JY.PersonNum>54 and JY.Person[54][KLORD0]~=1 then
		local BZ="\177\248\214\214"   -- 兵种
		ModifyBZ(54,({[1]=2,[4]=5,[7]=8,[10]=11,[23]=24})[JY.Person[54][BZ]] or JY.Person[54][BZ]) LvUp(54,7) ModifyForce(54,1)
	end
end

-- 외전 전투 앞 저장 확인: 한 번만. 플래그를 저장 전에 켜 두므로, 이 확인창에서 저장한 세이브를 불러오면 다시 묻지 않고 전투로 감
-- (외전 전투 준비 사건은 장면에서 저절로 이어지는 사건이라, 그대로 RemindSave 를 두면 불러올 때마다 다시 물음 — 10-07 사용자 보고)
function koViewRemind(flag)
	if GetFlag(flag) then return end
	SetFlag(flag,1)
	RemindSave()
end

-- 장면용 마차 (10-09 사용자 제공 「대마차」 144x64 x2): 48x64 조각 5장을 장면 조형 231~235 에 넣어 둠(232·234 = 윗줄 가운데·오른쪽, 231·233·235 = 아랫줄).
-- 일반 칸 344~348(민중) 다섯을 장면 동안만 그 形象 으로 바꿔 맞붙여 세운다. x,y = 왼쪽 아래 조각(말 머리) 자리. 말 머리는 왼쪽 아래를 봄.
-- 반환값 = 되돌리는 함수 (장면 끝에 부를 것). 움직일 때는 koCartMove(걸음, 방향).
local CART0={[343]=180,[344]=180,[345]=195,[346]=195,[347]=195,[348]=195}   -- 민중 칸의 원래 形象
-- 장면 도중(저장 확인 창) 저장한 세이브를 불러오면 바뀐 모습이 남아 있으므로 되돌림 (말 탄 관우 199 → 6, 마차 조각 → 민중)
function koSceneFix()
	local XS="\208\206\207\243"
	if JY.Person[2][XS]==199 then JY.Person[2][XS]=6 end
	for p,v in pairs(CART0) do local x=JY.Person[p][XS] if x>=231 and x<=246 then JY.Person[p][XS]=v end end
end
local CART={{344,231,0,0},{345,232,1,-1},{346,233,1,0},{347,234,2,-1},{348,235,2,0}}
local CARTF={{344,236,2,0},{345,237,1,-1},{346,238,1,0},{347,239,0,-1},{348,240,0,0}}   -- 좌우 뒤집은 판(말 머리가 오른쪽 아래, 形象 236~240): x,y = 왼쪽 아래 조각 자리 그대로
local CARTR={{343,241,0,-1},{344,242,0,0},{345,243,1,-1},{346,244,1,0},{347,245,2,-1},{348,246,2,0}}   -- 말 머리가 오른쪽 위를 보는 판 (10-09 사용자 그림, 形象 241~246, patch_삼형제_장면마차우상단.pl): 3열x2줄, x,y = 왼쪽 아래 조각 자리. koCartAdd(x,y,d,"ur")
function koCartAdd(x,y,d,flip)
	local L=(flip=="ur" and CARTR) or (flip and CARTF) or CART
	local XS="\208\206\207\243"   -- 形象
	local keep={}
	for _,c in ipairs(L) do
		keep[c[1]]=JY.Person[c[1]][XS]
		if keep[c[1]]>=231 and keep[c[1]]<=246 then keep[c[1]]=CART0[c[1]] end   -- a save made while the carriage was up: back to the commoner figure
		JY.Person[c[1]][XS]=c[2]
		AddPerson(c[1],x+c[3]*48/18,y+c[4]*64/18,d or 1)
	end
	return function() for p,v in pairs(keep) do JY.Person[p][XS]=v end end
end
function koCartMove(n,d)
	local a={}
	for _,c in ipairs(CART) do a[#a+1]=c[1] a[#a+1]=n a[#a+1]=d end
	MovePerson(table.unpack and table.unpack(a) or unpack(a))
end

-- 오관 (10-09): 두 형수의 마차 = 장수 352(보급대 칸, 고유 전투 조형 마차). 전투 동안만 아군·이름 「마차」, 끝나면 되돌림.
local P_NAME,P_LORD="\208\213\195\251","\190\253\214\247"   -- 姓名 君主
-- 10-09 사용자: 마차는 우군(스스로 목표로 가는 NPC), 출진 화면에는 나오지 않음
local P_BZ="\177\248\214\214"   -- 兵种: 전투 동안만 38 마차 (숲·산 못 감, patch_삼형제_마차병종.pl)
function koCarriageOn() JY.Person[352][P_LORD]=0 JY.Person[352][P_NAME]="\133\088\132\121" JY.Person[352][P_BZ]=38 end
function koCarriageOff() JY.Person[352][P_LORD]=0 JY.Person[352][P_NAME]="\131\115\134\080\130\095" JY.Person[352][P_BZ]=19 end
-- pid 가 전장에 살아 있고 0부터 센 칸 x0..x1, y0..y1 안에 있는가
function koUnitIn(pid,x0,y0,x1,y1)
	local w=GetWarID(pid) if w<=0 then return false end
	local v=War.Person[w] if (not v.live) or v.hide then return false end
	return v.x-1>=x0 and v.x-1<=x1 and v.y-1>=y0 and v.y-1<=y1
end
function koCarriageAt(x0,y0,x1,y1) return koUnitIn(352,x0,y0,x1,y1) end
-- 마차가 쓰러지면 패배 (true = 끝남, 사건은 바로 return)
function koCarriageLost()
	if JY.Status~=GAME_WMAP then return false end
	local w=GetWarID(352)
	if w>0 and not War.Person[w].live then
		talk(2,"\136\069\129\113\138\105\161\173\161\173! \129\071 \129\101\131\079\129\094 \136\069\138\105\129\083 \142\105 \141\072\129\071 \130\097\130\119\131\118\161\173\161\173.")
		koCarriageOff()
		JY.Status=GAME_WARLOSE PlayBGM(4) WarDelay(4)
		return true
	end
	return false
end

-- 오관 5연전 병력 이어 가기 (10-09 사용자): 판이 끝날 때 아군(+마차) 병력을 적어 두고, 다음 판 출진 뒤 그 값으로 되돌림.
-- 퇴각한 장수는 최대 병력의 1/4 로. 새로 나온 장수는 가득 찬 채로. (WarSave 가 출진 뒤에 있어 그 판 자동 저장에도 남음)
local P_BL,P_MAXBL="\177\248\193\166","\215\238\180\243\177\248\193\166"   -- 兵力 最大兵力
local OGK=nil
local OGT=nil   -- 첫 판에서 고른 장수 (10-09 사용자: 편성은 첫 판만)
function koOgwanReset() OGK=nil OGT=nil end
function koOgwanKeep()
	OGK={}
	if not OGT then OGT={} for _,v in pairs(War.Person) do if (not v.enemy) and (not v.friend) and v.id~=2 then OGT[#OGT+1]=v.id end end end
	rawset(_G,"koNoWarSave",true)   -- 다음 관문으로 바로: 전투 뒤 「지금 저장할까요?」 안 물음 (jymain 기반 패치 ③-2)
	for _,v in pairs(War.Person) do
		if (not v.enemy) and ((not v.friend) or v.id==352) then
			local p=JY.Person[v.id]
			OGK[v.id]=v.live and p[P_BL] or math.floor(p[P_MAXBL]/4)
		end
	end
end
function koOgwanApply()
	if not OGK then return end
	for pid,b in pairs(OGK) do
		local w=GetWarID(pid)
		if w>0 then local p=JY.Person[pid] p[P_BL]=math.max(1,math.min(b,p[P_MAXBL])) end
	end
end
-- 2~5판 출진: 첫 판에서 고른 장수를 빈자리(-1)에 그대로 넣고 출진 화면 없이 시작. 모르면(게임을 껐다 켜서 자동 저장을 불러온 경우 등) 평소 출진 화면.
function koOgwanSelect(team)
	if not OGT then SelectTerm(1,team) return end   -- 첫 판에 관우만 나갔으면 OGT={} 이고, 그때도 출진 화면 없이 관우만 (10-09)
	local k=1
	for i=1,#team,7 do
		if team[i]==-1 then
			while OGT[k] and JY.Person[OGT[k]]["\190\253\214\247"]~=1 do k=k+1 end   -- 君主: 아직 아군인 장수만
			if OGT[k] then team[i]=OGT[k]-1 k=k+1 else team[i]=-2 end
		end
	end
	local t={}
	for i=1,#team,7 do if team[i]>=0 then for j=0,6 do t[#t+1]=team[i+j] end end end
	CC.koSlotBase=#t/7
	SelectTerm_sub(1,t)
end
-- 매복 (10-10 사용자: 「매복이니까 아무도 없다가 장비가 접근하면 튀어 나와야」): pids(실제 무장 번호) 가운데 아직 숨어 있는 적에게
--  아군·우군이 dist 칸(가로세로대각선) 안으로 들어왔는가. 숨긴 적은 SelectEnemy 의 마지막 칸 1, 꺼내기는 WarShowArmy(번호-1)
function koViewAmbushNear(pids,dist,who)   -- who: 이 무장들이 다가올 때만 (없으면 아군·우군 누구나)
	local W=nil if who then W={} for _,p in ipairs(who) do W[p]=true end end
	for _,p in ipairs(pids) do
		local w=GetWarID(p)
		local e=w>0 and War.Person[w]
		if e and e.hide and e.live then
			for _,a in ipairs(War.Person) do
				if a.live and (not a.hide) and (not a.enemy) and ((not W) or W[a.id]) and math.max(math.abs(a.x-e.x),math.abs(a.y-e.y))<=dist then return true end
			end
		end
	end
	return false
end

-- 두 장수가 맞붙어 있는가 (누가 움직였든). WarMeet 은 지금 행동한 아군만 봐서 적이 다가와 붙으면 안 걸림 (10-09 사용자: 맹탄이 붙었는데 일기토 없음)
function koViewMeet(a,b)
	local wa,wb=GetWarID(a),GetWarID(b)
	if wa<=0 or wb<=0 then return false end
	local p,q=War.Person[wa],War.Person[wb]
	if (not p.live) or (not q.live) or p.hide or q.hide then return false end
	if (JY.Person[a]["\177\248\193\166"] or 0)<=0 or (JY.Person[b]["\177\248\193\166"] or 0)<=0 then return false end   -- 11-09: 병력 0 = 퇴각 사건 중(엔진은 live 를 끄기 전에 사건을 부름) — 여기서 일기토를 걸면 WarAction 이 다시 사건을 불러 끝없이 되풀이(백마 안량)
	if War.koDuelLost and War.koDuelLost[b] then return false end   -- 이 전투에서 이미 일기토에 졌으면 다시 붙지 않음
	return math.abs(p.x-q.x)+math.abs(p.y-q.y)==1
end
-- 사건 플래그에 넣어 둔 수 (SetFlag(n, 값) 의 값; GetFlag 는 참·거짓만 줌)
function koFlagVal(n) return JY.Base["\202\194\188\254"..n] or 0 end
-- 외전 일기토 (10-10 사용자): 짜인 연출 대신 본편처럼 진짜 일기토 화면(fight)을 띄움 — 기능설정의 일기토 수동/자동을 따름. a 가 이기면 true
function koViewDuel(a,b)
	return fight(a,b)==1
end
-- 일기토에 졌을 때: 상대가 한 번 치고, 진 쪽은 병력 절반을 잃고 그 자리에 남음(퇴각·패배 없음). 이 전투에서는 다시 일기토가 일어나지 않음
function koViewDuelLost(a,b)
	War.koDuelLost=War.koDuelLost or {}
	War.koDuelLost[b]=true
	WarAction(8,b,a)
	local p=JY.Person[a]
	p[P_BL]=math.max(1,math.floor(p[P_BL]/2))
	talk(a,"\161\173\161\173\132\094\140\070, \129\071\130\087\129\102\130\098 \131\065\133\101\129\069 \129\113\139\119\129\102 \130\097\130\119\131\118.")
end
-- 외전 전투의 적 병종 단계를 그 형제의 병종 단계까지로 (10-10 사용자: 장비는 1차인데 적은 2차 — 종횡은 Lv15 넘는 적을 2차로 올림)
-- SelectEnemy 뒤에 부름. 1~12·23~25 (3단계씩 묶인 병종)만, 형제보다 높은 단계면 같은 줄에서 내림
local function koTier(bz) if bz>=1 and bz<=12 then return (bz-1)%3+1 elseif bz>=23 and bz<=25 then return bz-22 end return nil end
function koViewCapTier(bro)
	local b=bro or koViewBro()
	if b<=0 then return end
	local BZ="\177\248\214\214"   -- 兵种
	local mt=koTier(JY.Person[b][BZ]) or 3
	for i,v in ipairs(War.Person) do
		if v.enemy or (v.id>=257 and v.id<=328) then   -- 적 전부 + 우군 일반병(패잔병 등 257~328, koViewAllyLv 가 레벨로 올린 단계) (10-10 사용자: 우군 보병이 중보병)
			local p=JY.Person[v.id]
			local t=koTier(p[BZ])
			if t and t>mt then
				local nb=p[BZ]-(t-mt)
				p[BZ]=nb
				local B=JY.Bingzhong[nb]
				v.bz=nb
				v.movewav=B["\210\244\208\167"]
				v.atkwav=B["\185\165\187\247\210\244\208\167"]
				v.movestep=B["\210\198\182\175"]
				v.movespeed=B["\210\198\182\175\203\217\182\200"]
				v.atkfw=B["\185\165\187\247\183\182\206\167"]
				ReSetAttrib(v.id,true)
				v.pic=WarGetPic(i)
			end
		end
	end
end
-- 자유 전투 「삼형제」 탭 (10-11 사용자: 외전의 전투를 그대로 쓰기). 외전 전투 사건을 새 기록(LoadRecord(0))에서 그대로 돌림 —
--  대사·원군·매복·탈출·호위·버티기·사로잡기·일기토가 이야기와 같음. 전투가 끝나면(war_end) 승패만 자유 전투 기록에 남기고 타이틀로.
--  해금 = 이야기에서 그 전투를 이김(기기 전체 CC.koViewWon ",711,718,", 옛 판은 막 완료 플래그로 채움). 잠긴 줄은 ？？？.
--  전투 중 저장해 불러와도 재현 중임을 잊지 않게 事件483 에 표 순번을 둠. 슬롯 6 자동 저장(WarSave(6))·저장 확인은 하지 않음.
local SIDE={
-- ev, 형제, 갈라진 본편 사건(402), 장소(장 제목), 이름, 형제 레벨, {pid=레벨} 함께 나오는 장수(君主 1)
{711,2,218,"\129\097\130\080","\129\101\131\079 \161\164 \129\097\130\080 \137\083\132\091",22},
{718,2,218,"\134\101\133\088","\129\101\131\079 \161\164 \134\101\133\088",22},
{722,2,218,"\133\066\129\103","\129\101\131\079 \161\164 \133\066\129\103",22},
{726,2,218,"\129\091\129\101","\129\101\131\079 \161\164 \129\091\129\101 \130\108\130\089\129\101",22},
{729,2,218,"\129\091\129\101","\129\101\131\079 \161\164 \129\091\129\101 \132\089\134\111",22},
{740,2,218,"\129\091\129\101","\129\101\131\079 \161\164 \129\091\129\101 \130\114\129\113\129\101",22},
{743,2,218,"\129\091\129\101","\129\101\131\079 \161\164 \129\091\129\101 \136\069\134\111",22},
{746,2,218,"\129\091\129\101","\129\101\131\079 \161\164 \129\091\129\101 \130\085\129\097 \131\118\131\094",22},
{815,3,218,"\129\109\129\079","\131\097\130\080 \161\164 \129\109\129\079 \133\069\129\075",20},
{801,3,218,"\136\111\140\109\132\091","\131\097\130\080 \161\164 \136\111\140\109\132\091 \133\099\130\112",20},
{819,3,218,"\136\111\140\109\132\091","\131\097\130\080 \161\164 \136\111\140\109\132\091 \132\091\133\094",20},
{805,3,218,"\131\100\131\123","\131\097\130\080 \161\164 \131\100\131\123 \135\070\134\069",20},
{822,3,218,"\131\100\131\123","\131\097\130\080 \161\164 \130\084\132\088\130\095 \129\075\130\112",20},
{809,3,218,"\131\100\131\123","\131\097\130\080 \161\164 \131\100\131\123 \130\095\132\081",20},
{762,2,513,"\131\097\130\114","\129\101\131\079 \161\164 \131\097\130\114",40,{[128]=38,[155]=38,[34]=38,[38]=38,[39]=38}},
{771,2,568,"\130\087\131\123","\129\101\131\079 \161\164 \130\087\131\123 \129\113\135\110\134\082\130\084",45,{[128]=43,[155]=43,[34]=43,[38]=43,[39]=43}},
{841,3,485,"\134\086\130\084","\131\097\130\080 \161\164 \134\086\130\084",37},
{851,3,578,"\134\107\130\101","\131\097\130\080 \161\164 \134\107\130\101\131\080 \141\066",45},
}
-- 옛 판(이 기능 전)에 이긴 외전 전투: 막 완료 플래그로 짐작 (로드할 때 채움)
local DONEFLAG={[711]=404,[718]=405,[722]=406,[726]=407,[729]=407,[740]=407,[743]=407,[746]=407,[762]=409,[771]=410,
	[815]=493,[801]=414,[819]=494,[805]=415,[822]=495,[809]=416,[841]=418}
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koViewWon",default=""} end
local function wonHas(ev) return string.find(CC.koViewWon or "",","..ev..",",1,true)~=nil end
local function wonAdd(ev)
	if wonHas(ev) then return end
	local s=CC.koViewWon or "" if s=="" then s="," end
	CC.koViewWon=s..ev.."," if rawget(_G,"koSave") then pcall(koSave) end
end
function koSideOpen(b) return b and b.koSide and wonHas(b.koSide) end
local function backfill()
	for ev,f in pairs(DONEFLAG) do if fv(f)>0 then wonAdd(ev) end end
	if fv(419)>0 and GetFlag(135) and not GetFlag(58) then wonAdd(851) end
end
-- 자유 전투 표 끝에 붙임 (순번이 기록·저장에 쓰이므로 맨 끝에만)
local SIDE_IDX={}
if type(rawget(_G,"koFreeData"))=="table" then
	for _,s in ipairs(SIDE) do
		koFreeData[#koFreeData+1]={map=0,ch=6,name=s[5],turn=20,l2=-1,bgm=9,team={},enemy={},items={},golds={},
			koSide=s[1],koBro=s[2],koStory=s[3],koPlace=s[4],koLv=s[6],koJoin=s[7] or {},koWho=(s[2]==2 and "\129\101\131\079" or "\131\097\130\080").." Lv"..s[6]}
		SIDE_IDX[#koFreeData]=true
	end
end
local SIDEFLAG=483   -- 재현 중인 표 순번 (새 기록에만 씀)
local function sideRow() local i=fv(SIDEFLAG) if i>0 and koFreeData and koFreeData[i] and koFreeData[i].koSide then return i end return nil end
function koSideStart(idx)
	local b=koFreeData[idx]
	if not koSideOpen(b) then
		PlayWavE(2) WarDrawStrBoxConfirm("\129\071\133\069\131\071\129\102\131\087 \129\071 \130\066\132\101\130\104 \129\071\131\071\129\065 \130\065\132\116\129\076\129\077",M_White,true)
		return false
	end
	LoadRecord(0)
	JY.Base["\211\206\207\183\196\163\202\189"]=1   -- 游戏模式 1 (종횡), free 와 같게 저장했다 다시 읽음
	if not SaveRecord(11) then JY.Status=GAME_START return false end
	LoadRecord(11) os.remove(CC.R_GRPFilename[11])
	for i=1,JY.PersonNum-1 do GetPic(i) end
	CC.Enhancement=true CC.koReplay=true CC.koSideReplay=true
	JY.Base["\206\222\211\195\053"]=0   -- 无用5: 코스트 없음
	setv(SIDEFLAG,idx)
	setv(400,b.koBro) setv(402,b.koStory)
	if b.koStory==218 then setv(450,b.koBro) end
	local LV,LORD="\181\200\188\182","\190\253\214\247"
	JY.Person[b.koBro][LV]=b.koLv JY.Person[b.koBro][LORD]=1
	for p,lv in pairs(b.koJoin) do JY.Person[p][LV]=lv JY.Person[p][LORD]=1 end
	koViewPlace(b.koPlace)
	JY.Smap={} JY.SubScene=-1
	JY.Status=GAME_SMAP_AUTO
	JY.EventID=b.koSide
	return true
end
-- 저장 확인·슬롯 6 자동 저장은 재현 중엔 안 함
do
	local ws=rawget(_G,"WarSave")
	if type(ws)=="function" then function WarSave(id,...) if CC.koSideReplay and id==6 then return end return ws(id,...) end end
	local vr=koViewRemind
	function koViewRemind(flag) if CC.koSideReplay then SetFlag(flag,1) return end return vr(flag) end
end
-- 이야기의 외전 전투가 어느 사건인지 (DefineWarMap 을 부른 사건)
local sideCur=nil
do
	local dw=rawget(_G,"DefineWarMap")
	if type(dw)=="function" then
		function DefineWarMap(...)
			sideCur=(fv(402)>0) and JY.EventID or nil
			return dw(...)
		end
	end
end
koOn("war_end",function()
	local kw=rawget(_G,"koWar")
	local won=kw and not kw.lost and not kw.abort and JY.Status~=GAME_WARLOSE and JY.Status~=GAME_START
		and JY.Status~=GAME_DEAD and JY.Status~=GAME_END and JY.EventID~=999
	if CC.koSideReplay then
		local i=sideRow()
		if i and rawget(_G,"koFreeRecAdd") then koFreeRecAdd(i,won and true or false,War.Turn or 1) end
		if won then PlayBGM(7) WarDrawStrBoxWaitKey("\131\107\130\066 \130\066\132\101 \129\116\129\117!",M_White)
		else PlayBGM(4) WarDrawStrBoxWaitKey("\129\079\134\099...  \133\064\129\071\140\071\132\083 \137\066\129\110\134\104\129\076\129\077",M_White) end
		CC.koSideReplay=nil CC.koReplay=nil
		JY.Status=GAME_START
	elseif won and sideCur and not CC.koFree and not CC.koReplay then
		for _,s in ipairs(SIDE) do if s[1]==sideCur then wonAdd(sideCur) end end
	end
	sideCur=nil
	return nil
end)
koOn("title",function() CC.koSideReplay=nil return nil end)
do
	local lr=rawget(_G,"LoadRecord")
	if type(lr)=="function" then
		function LoadRecord(...)
			local r=lr(...)
			if sideRow() then CC.koSideReplay=true CC.koReplay=true CC.Enhancement=true else CC.koSideReplay=nil backfill() end
			return r
		end
	end
end

-- 열전 단락 (10-11 사용자): 관우·장비 열전 뒤에 외전 단락을 붙임. 그 외전의 마지막 전투를 이야기에서 이긴 기록(CC.koViewWon)이 있으면.
--  부르는 동안만 CC.LieZhuan[이름] 을 늘렸다가 되돌림 (저장되지 않음).
local LZ_ADD={
[2]={{746,"\161\184\130\115\129\117\130\093\161\185 \129\097\130\080\129\094 \132\110\130\083\130\067\133\120 \130\091 \136\069\129\113\130\104 \130\067\137\074\131\096 \131\111 \129\094\130\067\130\104 \135\067\129\118\129\097\131\100 \129\118\129\118\129\102\129\081 \136\117\129\083 \138\069\139\072\129\077. \134\101\133\088\129\102\131\087 \130\111\132\088\129\083, \133\066\129\103\129\102\131\087 \133\090\133\099\130\104 \131\113\130\083 \131\098\131\112\130\104 \139\121\131\098 \135\068, \130\071\130\080\131\080 \129\109\130\121\129\083 \138\094\133\120 \133\072\131\098 \129\115\131\065\129\083 \135\087\129\097\131\100 \129\106\129\113\130\104 \130\064\130\083 \137\081 \133\094 \139\088\138\103\129\077. \129\077\144\093 \129\101\133\090\129\083 \130\067\131\118\134\066 \135\102\129\110\131\087\130\098 \131\097\129\113\131\082\129\083 \131\113\131\100 \130\115 \129\117\130\104 \136\071\131\096, \131\100\131\123\129\102\131\087 \136\069\129\100\131\082\129\123 \129\077\130\086 \132\086\138\103\129\077."},
 {762,"\161\184\134\077\129\068\130\094\130\125\161\185 \136\069\130\075\130\104 \130\067\135\081 \132\085 \130\108\129\091\131\080 \131\089\134\102\129\071 \137\120\132\081\130\104 \130\065\130\083 \136\069\130\075\130\104 \137\066\131\096 \136\071\130\102 \129\097\133\120, \139\070 \129\111 \133\120\131\094\132\086 \131\082\131\100 \129\119\129\072\129\094 \131\089\134\102\131\080 \135\089\131\099\129\083 \139\081\131\098 \133\094 \130\071\130\071\138\087 \137\066\129\110\138\088\129\077. \129\071\130\083 \131\097\130\114\132\083 \139\104\131\096\134\091 \129\098\135\126\131\080 \130\084\130\114\130\104 \131\065\129\117\138\080 \136\069\130\075 \133\103\139\074\129\083 \130\067\137\097 \132\106\129\077."},
 {771,"\161\184\129\113\135\110\134\082\130\084\161\185 \130\087\131\123\129\083 \134\082 \132\085 \129\094\129\083\130\080\132\083 \129\111\129\113\129\094 \132\124\132\081\133\120 \141\070\129\083 \131\104 \131\079\131\103\129\071 \129\071\136\097\130\098 \133\073\144\098 \130\084\129\083 \131\065\129\102 \135\100\131\071\129\081 \129\080\129\077. \131\079\131\103\131\098 \135\103\130\068\129\097\131\100 \132\078\135\086\131\098 \139\091\131\095 \141\110\138\087\130\067 \130\107\129\110 \131\113\138\098\131\109\129\076, \131\091 \130\110\131\111\129\094 \130\101\131\081\129\083 \132\110\129\081 \129\097\138\098\129\077."}},
[3]={{809,"\161\184\131\100\131\123\131\071\161\185 \131\087\130\075\129\094 \129\073\129\072\129\103 \141\066 \129\109\129\079\129\102\131\087 \134\097\130\110\130\104 \140\067\131\100 \136\111\140\109\132\091\129\102 \131\082\130\083\129\094 \132\091\131\076\131\082\129\083 \134\069\130\091\132\107\129\077. \131\100\131\123\131\080 \129\114\130\089\129\083 \139\075\129\110\131\095\131\100 \129\118\129\118\131\080 \130\084\132\088\129\083 \138\102\132\104\129\110 \134\101\131\123\129\102\129\081 \131\118\134\117\130\083 \130\075\134\066 \136\069\138\105\131\082\131\080 \129\109\130\121\129\083 \131\071\129\077\129\117\129\077, \133\088\131\108\131\095 \131\100\131\123 \131\123\133\090 \139\073\129\102\131\087 \130\071\130\080\135\122 \129\077\130\086 \132\086\138\103\129\077."},
 {841,"\161\184\131\080\132\090\135\110\130\111\161\185 \135\123\131\109\132\083 \131\082\130\083\135\121 \132\085 \134\086\130\084\131\080 \131\089\131\097 \135\110\130\111\129\071 \131\123\133\090\129\083 \129\138\131\100 \132\113\144\068\133\120, \129\133\134\114\132\083 \130\067\131\118\133\121\129\077\130\098 \129\109\133\090\129\083 \131\095\130\083 \131\091\130\104 \136\110\130\083\131\095 \130\114\132\083\139\081\131\116\129\077. \131\099\129\083 \131\113\130\102 \134\113\132\119\132\081\129\077\129\094\129\068 \135\110\130\111\131\080 \141\073\144\085 \131\071\134\075\129\102 \135\078\130\068\129\066 \135\089\129\113 \134\064\136\123\129\083 \139\069\132\107\131\100, \135\110\130\111\131\080 \130\111\131\095\132\083 \129\101\133\090\131\082\129\083 \137\106\136\108 \130\097\129\071 \130\067\138\103\129\077."},
 {851,"\161\184\134\107\130\101\131\080 \141\066\161\185 \129\101\131\079\131\080 \131\081\129\113\130\104 \139\121\131\109\131\096 \133\098\129\070\129\083 \131\087\130\091\130\106\138\066 \141\066, \135\071\139\084\129\102 \131\081\129\111\129\083 \131\066\131\098 \130\109\130\073\129\123 \131\097\136\071\129\071 \135\102\130\114\130\104 \129\143\135\082\131\109\131\118 \129\108\131\071\130\104 \132\110\132\081\131\100 \133\065\130\100\129\083 \141\083\138\106\129\077. \131\091 \135\068\132\083 \131\081\129\113\130\104 \139\121\129\083 \132\085\129\089\130\067 \131\072\129\083 \141\099\131\100 \130\084\130\114\130\104 \129\072\131\091\138\112\129\081 \130\095\129\080\129\077\131\100 \129\111\129\077."}},
}
do
	local dl=rawget(_G,"DrawLieZhuan")
	if type(dl)=="function" then
		function DrawLieZhuan(name,pid)
			local add=pid and LZ_ADD[pid]
			local base=name and CC.LieZhuan[name]
			if add and base and not (CC.LieZhuanPid and CC.LieZhuanPid[pid]) then
				local s=base
				for _,a in ipairs(add) do if wonHas(a[1]) then s=s.."*"..a[2] end end
				CC.LieZhuan[name]=s
				local ok,e=pcall(dl,name,pid)
				CC.LieZhuan[name]=base
				if not ok then error(e,0) end
				return
			end
			return dl(name,pid)
		end
	end
end
-- 술집 고용 전용 등장 연출 (10-11 사용자): 새 무장 8명. jymain koHeroEntrance 가 표에 없는 장수를 이리 물음(patch_등장연출확장.pl).
--  {장수, 대사, 0 왼쪽 / 1 오른쪽} — 1 은 유비(외전 중이면 그 형제). has(pid) = 그 장수가 이미 아군. 관우·주창이 있으면 옛 인연을 말함.
function koHeroSceneExtra(cid)
	local S={
	[391]={caption="\130\108\130\089\129\101\131\080 \129\113\131\097",frame=M_Silver,flash={{76,M_White}},lines=function(has)
		local t={{391,"\130\108\130\089\129\101\131\080 \130\074\129\113\129\090.*\132\119\130\093\137\100\131\098 \129\071\129\100 \132\115\129\090 \130\097\129\109.*\131\091\130\095\131\080 \130\084\137\104\129\083 \130\105\130\106\134\121\129\109.",0}}
		if has(2) then t[#t+1]={2,"\130\074\129\113\161\173\161\173*\131\091\131\083 \129\101\133\090\129\102\131\087*\131\091\130\095\131\080 \131\100\134\076\131\098 \131\115\131\116\129\077.",1} t[#t+1]={391,"\129\101\135\083\131\097\161\173\161\173*\129\071\130\087\137\096 \132\071\131\098 \132\075\129\102\131\087*\129\101\133\090\129\083 \130\067\137\074\134\121\129\109.",0}
		else t[#t+1]={1,"\131\081\135\111\129\083 \129\110\130\098 \131\097\129\113\130\102\129\076*\136\101\136\101\129\097\130\119\131\096.",1} end
		return t end},
	[392]={caption="\132\089\134\111 \130\124\129\113",frame=M_Cyan,flash={{76,M_White},{34,M_Cyan}},lines=function(has)
		local t={{392,"\132\089\134\111 \130\124\129\113\138\098\138\066 \129\111\130\068\129\071\129\091.*\129\071 \136\100, \131\091\130\095\129\102\129\081*\138\069\131\071\134\121\129\109.",0}}
		if has(2) then t[#t+1]={2,"\161\173\161\173\131\095 \144\101\137\079\129\102 \136\123\133\084\138\066*\131\091 \129\064\134\106\129\071\132\083\130\084.",1} t[#t+1]={392,"\135\109\135\109, \131\091 \133\073\131\098*\138\107\130\083 \130\075\130\086\129\091.*\133\114\129\065\129\071 \136\124\129\071 \129\110\129\076\130\119\131\096.",0}
		else t[#t+1]={1,"\130\088\134\088\129\071 \135\122 \130\075\132\107\130\119\131\096.*\136\091\130\077\132\076\129\097\129\091.",1} end
		return t end},
	[393]={caption="\132\089\134\111\131\080 \133\109\135\087",frame=M_Orange,flash={{24,M_DarkRed},{24,M_Orange}},lines=function(has)
		local t={{393,"\133\109\135\087\131\098 \129\071 \134\095\132\100\129\102\129\081*\138\069\131\071\130\086\129\091!*\130\074\131\098 \131\095\129\094 \129\077 \131\111\131\079\134\121\129\109!",0}}
		if has(2) then t[#t+1]={2,"\131\076\137\083\133\088\130\104 \139\075\129\110\129\091\138\066*\131\091 \131\123\134\080\129\111 \131\097\129\113\132\083\130\084.",1} t[#t+1]={393,"\161\173\161\173\131\091 \136\124\131\098 \129\071\129\100 \131\091\132\086!*\129\071\130\087\137\096 \139\073\129\102\131\087*\136\071\129\117\134\121\129\109!",0}
		else t[#t+1]={1,"\131\071\131\111\129\094 \130\095\134\077\129\097\130\119\131\096.*\131\071\130\095\129\097\134\121\129\109.",1} end
		return t end},
	[394]={caption="\129\103\129\125\130\114\131\080 \130\071\131\123\133\099",frame=M_Purple,flash={{72,M_Purple},{56,M_White}},lines=function(has)
		local t={{394,"\135\109\135\109, \130\116\138\115\129\090.*\129\071\129\100\130\098 \131\091\130\095 \139\074\131\109\132\083*\131\085\134\118\129\071 \130\094\130\098\130\119\131\096.",0}}
		if has(2) then t[#t+1]={2,"\129\103\129\125\130\114\131\080 \131\091 \137\121\130\077\161\173\161\173*\129\071\130\087\137\096 \133\125 \135\068\130\104*\129\118\134\100\129\088 \132\115\129\090 \130\097\134\121\130\067?",1} t[#t+1]={394,"\135\109\135\109, \142\079\129\070 \133\088\130\086\129\091.*\139\070\131\098 \139\073\129\102\132\086*\133\126\131\071\134\121\129\109.",0}
		else t[#t+1]={1,"\161\173\161\173\137\121\130\098 \140\118\134\094\129\071*\130\083\142\090\130\067 \129\073\134\098\130\119\131\096.",1} end
		return t end},
	[395]={caption="\136\069\134\111 \130\124\129\113",frame=M_Red,flash={{52,M_Red},{52,M_Orange}},lines=function(has)
		local t={{395,"\135\101\130\121\129\071\129\091.*\142\103\129\083 \129\066 \131\115\129\076*\131\091\130\095 \139\074\129\071 \129\071\131\068\129\071\132\108\130\084.",0}}
		if has(2) then t[#t+1]={2,"\134\074\129\101\129\102 \133\100\129\083 \130\067\135\077*\131\091 \135\101\130\121\129\106\129\094!",1} t[#t+1]={395,"\161\173\161\173\129\071\130\087\137\096 \131\076\129\103\129\102*\133\100\129\083 \130\067\130\106\134\121\129\109.*\131\091\133\101\129\065 \142\103\129\071 \138\071\130\067 \130\107\129\109.",0}
		else t[#t+1]={1,"\133\100\129\083 \138\085 \129\077\143\095\129\077 \131\082\132\107\129\109.*\136\096\129\082\129\071 \135\065\134\121\130\119\131\096.",1} end
		return t end},
	[396]={caption="\130\085\129\097 \131\118\131\094\131\080 \129\103\131\071",frame=M_Silver,flash={{24,M_White}},lines=function(has)
		local t={{396,"\130\085\129\097 \131\118\131\094\131\080 \129\103\131\071\129\090.*\129\071\129\100 \131\091\130\095\129\094 \131\095 \130\075\129\106\129\071\129\091.*\130\088\132\086 \131\095\129\117\130\086\129\091.",0}}
		if has(2) then t[#t+1]={2,"\131\118\131\094\130\104 \139\091\129\089\130\067 \135\102\129\110\131\087\138\066*\131\091 \131\100\134\076,*\131\071\132\070\129\097\131\100 \132\079\129\077.",1} t[#t+1]={396,"\129\071\130\087\137\096 \131\091 \131\100\134\076\131\109\132\083*\131\091\130\095\131\082\131\080 \134\114\129\083*\130\067\137\074\134\121\129\109.",0}
		else t[#t+1]={1,"\135\116\132\076\129\111 \131\097\129\113\132\083\130\119\131\096.*\138\085 \130\094\133\097\129\097\129\091.",1} end
		return t end},
	[416]={caption="\135\122\131\079\132\091\131\080 \131\080\131\076",frame=M_SandyBrown,flash={{24,M_Sienna},{75,M_Yellow}},lines=function(has)
		local t={{416,"\135\122\131\079\132\091 \134\099\131\081\129\109\129\077!*\136\069\138\105, \129\091\131\088\130\094\131\104*\130\105\130\102\129\094\134\121\129\113!",0}}
		if has(2) then t[#t+1]={416,"\129\110, \133\102\131\071 \129\113\133\096 \140\073 \134\111\133\065!*\129\071\130\087\137\096 \133\072\129\110 \130\075\130\098*\134\069\130\067?",0} t[#t+1]={2,"\161\173\161\173\135\109\135\109.*\129\071\130\087\137\096 \134\069\133\089\129\097\130\067*\130\107\134\121\129\077.",1} end
		if has(155) then t[#t+1]={155,"\131\081\129\109, \129\072\129\068 \138\088\130\119\131\118!",1} t[#t+1]={416,"\130\075\134\103 \136\069\138\105!*\135\079 \132\071\129\071 \137\106\131\079\129\081*\139\107\132\112!",0} end
		if not has(2) and not has(155) then t[#t+1]={1,"\132\064\129\071 \132\124\132\081\130\098\130\119\131\096.*\138\085 \135\122 \130\075\132\107\129\109.",1} end
		return t end},
	[417]={caption="\136\069\134\111\131\080 \131\080\129\106",frame=M_Lime,flash={{83,M_Lime},{76,M_White}},lines=function(has)
		local t={{417,"\134\113\133\065\129\071\130\102 \129\087\129\076\129\077.*\133\100\131\080\130\104 \131\115\131\100 \132\073\135\078\130\067 \130\107\130\098*\135\076\129\071\130\102 \131\082\132\107\129\075\129\076\129\077.",0}}
		if has(2) then t[#t+1]={2,"\134\113\133\065!*\136\069\134\111\129\102\131\087 \133\072\131\098 \131\098\131\112\130\104*\129\110\132\076 \139\121\130\067 \136\102\129\080\130\119\131\096.",1} t[#t+1]={417,"\131\097\130\084, \131\098\131\112\130\102\129\076\129\090.*\129\071\129\100\130\094\131\104 \142\080\129\102\131\087*\137\072\138\095 \137\106\131\079\134\121\129\075\129\076\129\077.",0}
		else t[#t+1]={1,"\131\080\132\083\135\083 \135\076\129\071*\135\122 \130\075\132\107\130\119\131\096.",1} end
		return t end},
	}
	return S[cid]
end
