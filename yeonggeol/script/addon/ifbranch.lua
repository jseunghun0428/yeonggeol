-- ko 6.0 (10-30): 역사 IF 분기 (addon "ifbranch"). 설계: 개발용/문서/역사 IF 분기 설계안.md · 6.0 새 기능 4종 저장 칸 배분.md
--   본편 세 곳에서 「역사대로 / ★ 역사와 다르게」 를 고른다: 1 여포를 살리다(171) · 2 서서를 붙잡다(326) · 3 장송을 구하라(473).
--   IF 장면 · 전투는 kdef 사건 860~889 (patch_IF분기.pl). 들어갈 때 事件402 = 갈라져 나온 본편 사건(koStoryEv: 진행도 판정은 본편 번호로),
--   나올 때 0. 형제 외전(view, 400>0)과 달리 출진 제한 · 형제 대장 같은 외전 규칙은 쓰지 않는다(koViewSide 를 형제 외전일 때만 참으로).
--   事件: 243 고른 것(IF 마다 2비트: 0 아직 · 1 역사대로 · 2 IF), 244 IF 이룸 비트, 245 여포 신뢰, 246 IF 전투 진행, 247~249 보너스 · 예비.
--   0~499 라 새 회차에서 지워짐 = 회차마다 다시 고른다. 본 IF 결말은 기기 공통 CC.koIfSeen (",\131\087\131\087,\131\097\135\112," 꼴).
-- Source: 개발용/addon/ifbranch_src.lua (UTF-8) → script/addon/ifbranch.lua (도구/free_hz.pl). view 뒤에 둘 것.
if not koNeeds("view") then return end

local EV="\202\194\188\254"   -- 事件
local function fv(n) return JY.Base[EV..n] or 0 end
local function setv(n,v) JY.Base[EV..n]=v end
local P_NAME="\208\213\195\251"   -- 姓名
local S_PICK,S_DONE,S_TRUST,S_WAR=243,244,245,246
local NAME={"\129\098\134\097","\131\087\131\087","\131\097\135\112"}

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koIfSeen",default=""}

-- 형제 외전만 「외전」 (402 는 IF 사건도 씀)
do
	local side=rawget(_G,"koViewSide")
	if type(side)=="function" then
		function koViewSide() return side() and koViewBro()>0 end
	end
end

local function on() return not (CC.koReplay or CC.koFree) end
function koIfChoice(k) return math.floor(fv(S_PICK)/4^(k-1))%4 end
local function setChoice(k,v) setv(S_PICK,fv(S_PICK)+(v-koIfChoice(k))*4^(k-1)) end
function koIfDoneOf(k) return math.floor(fv(S_DONE)/2^(k-1))%2==1 end
-- 아직 안 고른 갈림길인가 (kdef 가 원래 대사 대신 IF 대사를 쓸지)
function koIfOffer(k) return on() and koIfChoice(k)==0 end
-- 갈림길: items[1] = 역사대로, items[2] = IF. 이미 고른 칸이면 그 값, 장면 재현 · 자유 전투면 1
function koIfPick(k,desc,items)
	if not on() then return 1 end
	local v=koIfChoice(k)
	if v>0 then return v end
	local r=koViewPickMenu(desc.."*(IF \130\104 \131\100\130\106\129\065 \129\071\130\087 \130\070 \129\071\133\069\131\071\129\094 \129\118\131\103 \131\085\136\149\129\076\129\077. \131\097 \132\065\131\087 \161\164 \137\096\143\228\131\098 \132\071\129\075\129\076\129\077)",items)
	setChoice(k,r)
	return r
end
-- IF 이룸: 비트 + 기기 공통 모음
function koIfDone(k)
	if not koIfDoneOf(k) then setv(S_DONE,fv(S_DONE)+2^(k-1)) end
	local nm=NAME[k]
	if nm and not string.find(CC.koIfSeen or "",","..nm..",",1,true) then
		CC.koIfSeen=((CC.koIfSeen or "")=="" and "," or CC.koIfSeen)..nm..","
		if rawget(_G,"koSave") then pcall(koSave) end
	end
end
function koIfSeenOf(k) return string.find(CC.koIfSeen or "",","..(NAME[k] or "?")..",",1,true)~=nil end

-- 들어가기 · 나오기
function koIfGo(story,first,keep)   -- keep: 지금 장면 그대로 (사람 · 배경)
	setv(402,story)
	setv(S_WAR,0)
	if not keep then JY.Smap={} end
	JY.Status=GAME_SMAP_AUTO
	NextEvent(first)
end
function koIfBack(ret,manual)
	setv(402,0)
	JY.Status=manual and GAME_SMAP_MANUAL or GAME_SMAP_AUTO
	NextEvent(ret)
end

-- 호위 수레 (관우 외전 마차 = 장수 352 를 빌림, view koCarriageOn/Off)
-- 11-10 (제보: 서서 잠입 못 깸): 수레 이동력 4 로는 적이 없어도 출구까지 17턴 → 이 전투 동안만 +2 (12턴).
--  이동력은 ReSetAttrib 가 koAwakeMove 를 더해 정함 (awakeperson 이 이 애드온 뒤에 실려 처음 켤 때 감쌈)
--  이 전투인지는 수레 이름(「서모의 수레」, 관우 외전 마차는 「마차」)으로 봄 → 전투 중 세이브를 불러와도 같음
local CARTNAME="\131\087\130\090\131\080 \129\113\130\082"
local function cartHere() return JY.Person[352] and JY.Person[352][P_NAME]==CARTNAME end
local cartRaw=nil
local function cartMove()
	local cur=rawget(_G,"koAwakeMove")
	if cur~=nil and cur==cartRaw then return end
	local raw=cur
	cartRaw=function(id)
		local m=raw and raw(id) or 0
		if id==352 and cartHere() then m=m+2 end
		return m
	end
	rawset(_G,"koAwakeMove",cartRaw)
end
function koIfCartOn(name)
	koCarriageOn() JY.Person[352][P_NAME]=name
	cartMove()
end
function koIfCartOff() koCarriageOff() end
-- 수레를 놓을 때 이동력이 병종 값으로 정해지므로 전투 사건(매번 불림)에서 다시 계산
function koIfCartBoost()
	if not cartHere() then return end
	cartMove()
	local w=GetWarID(352)
	if w>0 then pcall(ReSetAttrib,352,false) end
end
function koIfCartLost(who,line)
	if JY.Status~=GAME_WMAP then return false end
	local w=GetWarID(352)
	if w>0 and not War.Person[w].live then
		talk(who,line)
		koCarriageOff()
		JY.Status=GAME_WARLOSE PlayBGM(4) WarDelay(4)
		return true
	end
	return false
end
-- 지정 무장이 퇴각하면 패배 (조운 같은 대장은 DefineWarMap 의 leader1 이 이미 맡음)
function koIfMustLive(pid,line)
	if JY.Status==GAME_WMAP and JY.Death==pid then
		if line then talk(pid,line) end
		local w=GetWarID(pid) if w>0 then War.Person[w].action=9 end
		if koWar then koWar.lost=true end
		JY.Status=GAME_WARLOSE
		return true
	end
	return false
end
-- 출진: hide 의 무장(유비 등 그 자리에 없는 사람)은 빈자리 후보에서 뺌 (출진 화면 동안만 君主 0)
local P_LORD="\190\253\214\247"   -- 君主
function koIfSelect(hide,team)
	local back={}
	for _,p in ipairs(hide) do if JY.PersonNum>p and JY.Person[p][P_LORD]==1 then back[#back+1]=p JY.Person[p][P_LORD]=0 end end
	local data=JY.Data_Person
	local ok,e=pcall(SelectTerm,1,team)
	if JY.Data_Person==data then for _,p in ipairs(back) do JY.Person[p][P_LORD]=1 end end   -- 출진 화면에서 세이브를 불러왔으면 그대로
	if not ok then error(e,0) end
end

-- IF 3: 장송이 살아 있으면 성도 전투(509) 시작 때 적 사기 -20 (최소 30)
local P_MOR="\202\191\198\248"   -- 士气
function koIfSongAid()
	talk(187,"\131\123\130\111\131\080 \130\084\130\114\131\082\131\098 \129\071\134\119 \130\071\131\097\129\083 \132\113\132\126\129\075\129\076\129\077. \131\123\130\111 \130\114\134\118\131\082\129\102\129\081 \131\087\131\078\129\083 \137\066\131\096 \130\091\132\107\131\109\129\076 \131\076\131\098 \129\091\134\071 \132\113\144\068\130\067 \136\102\129\088 \131\117\129\104\129\076\129\077.")
	for i=1,War.PersonNum do
		local v=War.Person[i]
		if v.enemy and v.live then local P=JY.Person[v.id] P[P_MOR]=math.max(30,(P[P_MOR] or 100)-20) end
	end
	DrawStrBoxCenter("\131\097\135\112\131\080 \132\084\130\117\131\109\132\083 \131\076\131\080 \130\114\131\071\129\094 \132\110\130\083\131\070\129\077!")
end

-- IF 1: 여포를 살리다. 조건 = 하비 보너스 290(여포보다 먼저 진궁) 또는 유비 Lv >= 여포 Lv-5. 신뢰(245) 시작 30,
--  이야기 전투를 이기면 여포 출진·생존 +10 · 퇴각 -15 · 출진 안 함 -3 (0~99). 2장 첫머리(226 → 861)에서 50 이상이면 남음(11-09: 60 → 50, 그 사이 이야기 전투가 광릉 · 서주II 둘뿐이라 최대 50).
local P_LV="\181\200\188\182"   -- 等级
local P_ITEM="\181\192\190\223"   -- 道具
local LU=5
local P_EXP,P_BZ="\190\173\209\233","\177\248\214\214"   -- 经验 兵种
local P_GEAR={"\206\228\198\247","\183\192\190\223","\184\168\214\250"}   -- 武器 防具 辅助
-- 11-13: 248 은 장송 IF 8턴 보너스(kdef 사건 884 koBonusDone 248)와 겹쳤음(247 은 서서 보너스) → 빈 事件 339 로 옮김.
--  옛 세이브의 248 값(421~601 = 여포 사본 번호)은 luRetro 가 339 로 옮김.
local S_COPY=339   -- 11-08: 합친 술집 사본 번호 (0 = 없음, 11-13: 1000+번호 = 술집에 있던(아직 등용 안 한) 사본)
-- 11-13 카페 제보 (여포 IF: 술집 여포의 장비가 사라지고 능력치가 처음 값으로): 합칠 때 무력 · 지력 · 통솔과 그 경험치도
--  높은 쪽으로 (레벨만 옮겨서 성장 몫이 빠졌음). 무력2 등은 장비를 더한 값이라 ReSetAttrib 가 다시 셈.
local P_STAT={{"\206\228\193\166","\206\228\193\166\190\173\209\233"},{"\214\199\193\166","\214\199\193\166\190\173\209\233"},{"\205\179\194\202","\205\179\194\202\190\173\209\233"}}   -- 武力 智力 统率 (+经验)
-- 11-13 카페 제보 2 (「합쳐질 때 능력치와 천부는 예전 그대로」): 천부 · 특기 1~6 도 (주점에서 돈 내고 바꿀 수 있는 값) 사본 쪽 그대로
--  S_COPY: 번호(옛 합침, 불러올 때 한 번 보정) · 1000+번호(술집에 있던 사본) · 2000+번호(아군 사본, 보정 끝)
local P_TAL={"\204\236\184\179"} for k=1,6 do P_TAL[#P_TAL+1]="\204\216\188\188"..k end   -- 天赋 特技1~6
local function luTal(dst,src) for _,f in ipairs(P_TAL) do dst[f]=src[f] end end
local function luStats(dst,src)
	for _,f in ipairs(P_STAT) do
		if (src[f[1]] or 0)>(dst[f[1]] or 0) then dst[f[1]]=src[f[1]] dst[f[2]]=src[f[2]] end
	end
end
function koIfLuOk()
	if GetFlag(290) then return true end
	return JY.Person[1][P_LV]>=JY.Person[LU][P_LV]-5
end
function koIfLuTrust() return fv(S_TRUST) end
function koIfLuHere() return JY.Person[LU][P_LORD]==1 end
function koIfLuJoin()
	setChoice(1,2)
	setv(S_TRUST,30)
	ModifyForce(LU,1)
	-- 적토마(도구 8)는 하비 숨은 도구(플래그 74)와 겹치므로 들고 오지 않음
	local P=JY.Person[LU]
	for i=1,8 do if P[P_ITEM..i]==8 then P[P_ITEM..i]=0 end end
	local t={} for i=1,8 do if P[P_ITEM..i]>0 then t[#t+1]=P[P_ITEM..i] end end
	-- 11-08 (제보: 여포 둘): 술집에서 데려온 여포 사본(442 등)이 이미 아군이면 하나로 합침 — 사본의 레벨 · 경험치 · 병종 · 장비 ·
	--  도구를 이 여포가 받고 사본은 물러남(S_COPY 에 번호). 이미 함께 싸운 여포라 신뢰는 99. 떠날 때는 사본에게 되돌려 줌.
	local cp,idle=nil,false
	for i=421,math.min(601,JY.PersonNum-1) do
		if JY.Person[i][P_LORD]==1 and JY.Person[i][P_NAME]==P[P_NAME] then cp=i break end
	end
	-- 11-13: 아군 사본이 없으면 술집에 있는 사본(전 회차에서 이어받은 장비 · 도구 · 레벨)을 받음. 사본은 술집에 그대로 남고,
	--  이 여포가 아군인 동안 잠김(tavern_slot_lock). 떠날 때 돌려줌(등용은 하지 않음).
	if not cp then
		local best=-1
		for i=421,math.min(601,JY.PersonNum-1) do
			local C=JY.Person[i]
			if C[P_LORD]~=1 and C[P_NAME]==P[P_NAME] then
				local g=0
				for _,k in ipairs(P_GEAR) do if (C[k] or 0)>0 then g=g+1 end end
				for j=1,8 do if (C[P_ITEM..j] or 0)>0 then g=g+1 end end
				local sc=g*1000+(C[P_LV] or 0)
				if sc>best then best=sc cp=i end
			end
		end
		idle=cp~=nil
	end
	if cp then
		local C=JY.Person[cp]
		if C[P_LV]>=P[P_LV] then P[P_LV]=C[P_LV] P[P_EXP]=C[P_EXP] P[P_BZ]=C[P_BZ] end
		luStats(P,C) luTal(P,C)
		for _,k in ipairs(P_GEAR) do if (C[k] or 0)>0 then P[k]=C[k] C[k]=0 end end
		local u,seen={},{}
		for i=1,8 do local v=C[P_ITEM..i] if v>0 and not seen[v] then u[#u+1]=v seen[v]=true end C[P_ITEM..i]=0 end
		for _,v in ipairs(t) do if not seen[v] and #u<8 then u[#u+1]=v seen[v]=true end end
		t=u
		if idle then
			setv(S_COPY,1000+cp)
		else
			ModifyForce(cp,0)
			setv(S_COPY,2000+cp)
			setv(S_TRUST,99)
		end
	end
	for i=1,8 do P[P_ITEM..i]=t[i] or 0 end
	pcall(ReSetAttrib,LU,false)
	if cp and not idle then DrawStrBoxCenter("\131\072\134\076\129\102\131\087 \133\104\131\096\134\091 \129\098\134\097\135\122 \129\097\131\118\129\094 \132\067\132\107\129\077") end
end
function koIfLuRefused() setChoice(1,1) end
function koIfLuLeave()
	ModifyForce(LU,0)
	local cp=fv(S_COPY)
	if cp>2000 then cp=cp-2000 end
	local idle=cp>1000 if idle then cp=cp-1000 end   -- 11-13: 술집에 있던 사본 → 돌려주고 술집에 남김
	if cp>0 and cp<JY.PersonNum then   -- 11-08: 합친 사본에게 레벨 · 장비 · 도구를 돌려주고 다시 아군으로
		local P,C=JY.Person[LU],JY.Person[cp]
		C[P_LV]=P[P_LV] C[P_EXP]=P[P_EXP] C[P_BZ]=P[P_BZ]
		luStats(C,P) luTal(C,P)
		for _,k in ipairs(P_GEAR) do C[k]=P[k] P[k]=0 end
		for i=1,8 do C[P_ITEM..i]=P[P_ITEM..i] P[P_ITEM..i]=0 end
		if not idle then ModifyForce(cp,1) end
		pcall(ReSetAttrib,cp,false)
		setv(S_COPY,0)
	end
end
-- 11-13: 이 고침 전에 합친 세이브 — 불러올 때 한 번: 합친 사본(아직 사본 기록에 남은 성장 몫)의 무력 · 지력 · 통솔을 받고,
--  술집에 있던 사본과 합치지 않았으면(S_COPY 0) 그 사본의 장비 · 도구를 지금 받음 (koIfLuJoin 과 같은 규칙)
local function luRetro()
	if CONFIG.koCamp or JY.Status==GAME_WMAP or koIfChoice(1)~=2 or JY.Person[LU][P_LORD]~=1 then return end   -- 전투 세이브는 건너뜀(다음 도시 세이브에서)
	local P=JY.Person[LU]
	local old=fv(248)
	if fv(S_COPY)==0 and old>=421 and old<=601 and old<JY.PersonNum and JY.Person[old][P_NAME]==P[P_NAME] then setv(S_COPY,old) setv(248,0) end
	local cp=fv(S_COPY)
	if cp>1000 then return end
	if cp>0 and cp<JY.PersonNum then   -- 옛 합침: 한 번만 (2000+번호로 표시)
		local C=JY.Person[cp]
		if C[P_NAME]==P[P_NAME] then luStats(P,C) luTal(P,C) pcall(ReSetAttrib,LU,false) end
		setv(S_COPY,2000+cp)
		return
	end
	local best,bi=0,nil
	for i=421,math.min(601,JY.PersonNum-1) do
		local C=JY.Person[i]
		if C[P_LORD]~=1 and C[P_NAME]==P[P_NAME] then
			local g=0
			for _,k in ipairs(P_GEAR) do if (C[k] or 0)>0 then g=g+1 end end
			for j=1,8 do if (C[P_ITEM..j] or 0)>0 then g=g+1 end end
			if g*1000+(C[P_LV] or 0)>best and g>0 then best=g*1000+(C[P_LV] or 0) bi=i end
		end
	end
	if not bi then return end
	local C=JY.Person[bi]
	if C[P_LV]>=P[P_LV] then P[P_LV]=C[P_LV] P[P_EXP]=C[P_EXP] P[P_BZ]=C[P_BZ] end
	luStats(P,C) luTal(P,C)
	for _,k in ipairs(P_GEAR) do if (C[k] or 0)>0 then local o=P[k] or 0 P[k]=C[k] C[k]=o end end
	local u,seen={},{}
	for i=1,8 do local v=P[P_ITEM..i] if v>0 and not seen[v] then u[#u+1]=v seen[v]=true end end
	for i=1,8 do local v=C[P_ITEM..i] if v>0 and not seen[v] and #u<8 then u[#u+1]=v seen[v]=true C[P_ITEM..i]=0 end end
	for i=1,8 do P[P_ITEM..i]=u[i] or 0 end
	setv(S_COPY,1000+bi)
	pcall(ReSetAttrib,LU,false)
	if rawget(_G,"koAddonLog") then koAddonLog("ifbranch: Lu 5 takes tavern copy "..bi.." (retro)") end
end
do
	local lr=rawget(_G,"LoadRecord")
	if type(lr)=="function" then
		function LoadRecord(id,...)
			local r=table.pack(lr(id,...))
			if id and id>0 then pcall(luRetro) end
			return table.unpack(r,1,r.n)
		end
	end
end
-- 11-10 (제보: 2장 첫머리에 떠난 여포를 업 주점에서 등용하니 도구가 다 없어지고 새 칸으로 들어옴): IF 로 함께했던 여포(5)가
--  떠난 뒤 술집의 같은 이름 사본을 데려오면, 떠난 여포의 레벨 · 경험치 · 병종 · 장비 · 도구를 사본이 이어받음 (koIfLuLeave 와 같은 방식).
--  ModifyForce 를 감쌈: ifbranch 는 enemygear · storyhire · gear 보다 먼저 실려 이 감싸기가 가장 안쪽 → 옮긴 뒤 원래 ModifyForce,
--  gear 의 합류 지급은 그 뒤(이미 받은 회차라 겹치지 않음)
do
	local mf=rawget(_G,"ModifyForce")
	if type(mf)=="function" then
		function ModifyForce(pid,fid,...)
			if (fid or 1)==1 and pid and pid>=421 and pid<=601 and pid<JY.PersonNum and not CONFIG.koCamp and on()
				and koIfChoice(1)==2 and fv(S_COPY)==0 and JY.Person[LU][P_LORD]~=1 and JY.Person[pid][P_LORD]~=1
				and JY.Person[pid][P_NAME]==JY.Person[LU][P_NAME] then
				local P,C=JY.Person[LU],JY.Person[pid]
				if P[P_LV]>=C[P_LV] then C[P_LV]=P[P_LV] C[P_EXP]=P[P_EXP] C[P_BZ]=P[P_BZ] end
				luStats(C,P) luTal(C,P)
				for _,k in ipairs(P_GEAR) do if (P[k] or 0)>0 then C[k]=P[k] P[k]=0 end end
				local u,seen={},{}
				for i=1,8 do local v=P[P_ITEM..i] if v>0 and not seen[v] then u[#u+1]=v seen[v]=true end P[P_ITEM..i]=0 end
				for i=1,8 do local v=C[P_ITEM..i] if v>0 and not seen[v] and #u<8 then u[#u+1]=v seen[v]=true end end
				for i=1,8 do C[P_ITEM..i]=u[i] or 0 end
				if rawget(_G,"koAddonLog") then koAddonLog("ifbranch: tavern Lu "..pid.." takes over 5") end
			end
			return mf(pid,fid,...)
		end
	end
end
-- 11-08: 이 여포가 아군인 동안 술집의 같은 이름 사본은 잠금(목록에서 빠짐)
koOn("tavern_slot_lock",function(i)
	if i~=LU and JY.Person[LU][P_LORD]==1 and JY.Person[i][P_NAME]==JY.Person[LU][P_NAME] then return true end
	return nil
end)
-- 11-13 (제보: 술집 장송 + IF 장송 둘): IF 3 로 살린 장송(187)이 아군이면 술집 사본(470 등 같은 이름)을 잠그고,
--  이미 데려온 사본 / 장비를 든 사본은 장송에게 합침(레벨·경험·병종·높은 무력/지력/통솔+경험·천부특기·장비·도구). 장송은 떠나지 않으므로 플래그 없이 몇 번 해도 같음
local SONG=187
local function songBase() return not CONFIG.koCamp and on() end
local function songOurs() return JY.PersonNum>SONG and JY.Person[SONG][P_LORD]==1 and koIfDoneOf(3) end
local function songCopy(i)
	return i~=SONG and i>=421 and i<=601 and not (i>=511 and i<=530) and i<JY.PersonNum   -- 511~530 = 신무장(newgen)
		and JY.Person[i][P_NAME]==JY.Person[SONG][P_NAME]
end
local function songTake(cp)
	local P,C=JY.Person[SONG],JY.Person[cp]
	if (C[P_LV] or 0)>=(P[P_LV] or 0) then P[P_LV]=C[P_LV] P[P_EXP]=C[P_EXP] P[P_BZ]=C[P_BZ] end
	luStats(P,C) luTal(P,C)
	local u,seen,spill={},{},{}
	for _,k in ipairs(P_GEAR) do if (C[k] or 0)>0 then if (P[k] or 0)>0 then spill[#spill+1]=P[k] end P[k]=C[k] C[k]=0 end end
	for i=1,8 do local v=P[P_ITEM..i] if v>0 and not seen[v] then u[#u+1]=v seen[v]=true end end
	for _,v in ipairs(spill) do if not seen[v] and #u<8 then u[#u+1]=v seen[v]=true end end
	for i=1,8 do local v=C[P_ITEM..i] if v>0 and not seen[v] and #u<8 then u[#u+1]=v seen[v]=true C[P_ITEM..i]=0 end end
	for i=1,8 do P[P_ITEM..i]=u[i] or 0 end
	pcall(ReSetAttrib,SONG,false)
	if rawget(_G,"koAddonLog") then koAddonLog("ifbranch: Song 187 takes tavern copy "..cp) end
end
local MSG_SONG="\131\072\134\076\129\102\131\087 \133\104\131\096\134\091 \131\097\135\112\129\123 \129\097\131\118\129\094 \132\067\132\107\129\077"   -- 술집에서 데려온 장송과 하나가 되었다
-- (1) IF 이룸(사건 884 koIfDone(3)) 때: 아군 사본이면 합치고 물림, 없으면 장비를 든 술집 사본(지난 회차 계승)의 것을 받음
do
	local done=koIfDone
	function koIfDone(k,...)
		local r=done(k,...)
		if k==3 and songBase() and songOurs() then
			local cp,idle=nil,false
			for i=421,math.min(601,JY.PersonNum-1) do if songCopy(i) and JY.Person[i][P_LORD]==1 then cp=i break end end
			if not cp then
				local best=0
				for i=421,math.min(601,JY.PersonNum-1) do
					local C=JY.Person[i]
					if songCopy(i) then
						local g=0
						for _,q in ipairs(P_GEAR) do if (C[q] or 0)>0 then g=g+1 end end
						for j=1,8 do if (C[P_ITEM..j] or 0)>0 then g=g+1 end end
						if g>0 and g*1000+(C[P_LV] or 0)>best then best=g*1000+(C[P_LV] or 0) cp=i end
					end
				end
				idle=cp~=nil
			end
			if cp then
				songTake(cp)
				if not idle then ModifyForce(cp,0) DrawStrBoxCenter(MSG_SONG) end
			end
		end
		return r
	end
end
-- (2) 이미 둘 다 아군인 세이브(이번 제보): 불러올 때 사본을 장송에게 합치고 물림
local function songRetro()
	if not songBase() or JY.Status==GAME_WMAP or not songOurs() then return end
	for i=421,math.min(601,JY.PersonNum-1) do
		if songCopy(i) and JY.Person[i][P_LORD]==1 then songTake(i) ModifyForce(i,0) end
	end
end
do
	local lr=LoadRecord
	function LoadRecord(id,...)
		local r=table.pack(lr(id,...))
		if id and id>0 then pcall(songRetro) end
		return table.unpack(r,1,r.n)
	end
end
-- (3) 술집·도감·마을 주점(koRecAvail)에서 사본 잠금
koOn("tavern_slot_lock",function(i)
	if songBase() and songOurs() and songCopy(i) then return true end
	return nil
end)
-- (4) 안전망: 그래도 사본을 등용하려 하면(주점 한꺼번에 등용 등) 등용 대신 장송에게 합침
do
	local mf=ModifyForce
	function ModifyForce(pid,fid,...)
		if (fid or 1)==1 and pid and songBase() and songOurs() and songCopy(pid) and JY.Person[pid][P_LORD]~=1 then
			songTake(pid)
			DrawStrBoxCenter(MSG_SONG)
			return
		end
		return mf(pid,fid,...)
	end
end
koOn("war_won",function()
	if CC.koFree or CC.koTownBattle or CC.koReplay then return end
	if koIfChoice(1)~=2 or koIfDoneOf(1) or not koIfLuHere() then return end
	local d=-3
	for i=1,War.PersonNum do
		local v=War.Person[i]
		if v.id==LU and not v.enemy then d=v.live and 10 or -15 break end
	end
	setv(S_TRUST,math.max(0,math.min(99,fv(S_TRUST)+d)))
	-- 11-04 사용자 「영걸전 여포 IF 에도」: 전투 끝마다 신뢰 수치를 보여 줌 (2장 시험 뒤에는 위에서 돌아감)
	-- 11-13 사용자: 80 이상이면 안 띄움 (남은 이야기 전투 광릉 · 서주II 에서 둘 다 퇴각해도 -30, 50 아래로 못 내려감 — 사본과 합친 99 등)
	if fv(S_TRUST)>=80 then return end
	local why=(d==10) and "\137\072\138\095 \137\106\132\069 \129\071\141\091 +10" or ((d==-15) and "\129\098\134\097\129\094 \133\068\130\069\137\072 -15" or "\133\098\129\103\129\097\130\067 \130\107\130\077 -3")
	WarDrawStrBoxConfirm("\129\098\134\097\131\080 \131\078\132\098 "..fv(S_TRUST).." / 50*"..why.."*2\131\097 \130\086\129\074 \130\066\129\089\130\067 50 \129\071 \130\111 \132\067\129\065 \139\088\139\095\129\076\129\077.",M_White,true)
end)

-- 후일담(epilogue) 결말: 이번 판에 이룬 IF 가 있으면 그 문장이 먼저
local ENDIF={
	["\129\098\134\097"]={1,"\129\097\130\080 \134\101\133\090\131\094\129\102\131\087 \131\099\133\126\129\083 \129\119\129\103 \135\068\132\083 \129\077\130\086\130\098 \130\075\129\106\129\083 \133\102\132\113\129\117\130\067 \129\110\129\076\129\097\138\098\129\077. \130\071\130\080\131\080 \134\103\129\071 \132\067\130\083 \135\107\139\074 \130\116\131\064\129\083 \130\067\133\115\129\077."},
	["\131\087\131\087"]={2,"\130\083\138\099\129\076\130\104 \130\119\129\066 \131\101 \131\098\131\112\130\104 \138\107\130\067 \130\107\131\100 \139\091\129\089\130\067 \130\071\130\080 \142\080\129\102 \133\103\131\116\129\077. \129\100\135\121\132\088\129\123 \137\072\138\095 \135\123\131\080 \131\071\140\071\129\083 \134\120\131\116\129\077."},
	["\131\097\135\112"]={3,"\131\123\129\068\129\102\131\087 \131\099\133\126\129\083 \129\119\129\103 \135\068 \133\083\130\075\131\080 \134\114\139\081\129\071\129\094 \132\067\132\107\129\077. \135\123\129\071 \131\087\133\120 \131\118\130\102\131\080 \134\106\130\079\129\083 \138\069\129\110 \129\071\138\075\129\083 \133\103\139\072\129\077."},
}
function koIfEnd(name)
	local e=ENDIF[name]
	if e and koIfDoneOf(e[1]) then return e[2] end
	return nil
end
-- 기록 화면 「후일담」 탭 머리 줄: 본 IF 결말 (기기 공통)
function koIfSummary()
	local got={}
	for k,nm in ipairs(NAME) do if koIfSeenOf(k) then got[#got+1]=nm end end
	return "IF \134\064\136\124 "..#got.." / "..#NAME..(#got>0 and ("  ("..table.concat(got," \161\164 ")..")") or "")
end

-- 자유 전투 「삼형제」 탭 끝에 IF 전투 (view 의 외전 재현 틀: 事件483 = 표 순번, war_end 가 기록 · 타이틀). 해금 = 이야기에서 그 IF 를 이룸
--  (koIfDone 이 CC.koViewWon 에 전투 사건을 더함). 표 순번이 기록에 쓰이므로 맨 끝에만 붙임.
local IFSIDE={
-- 전투 사건, IF 번호, 갈라진 본편 사건(402), 장소, 이름, 레벨, {함께 나오는 장수}
{871,2,326,"\135\109\134\103","IF \131\087\131\087 \161\164 \135\109\134\103 \135\100\129\104",24,{54,112}},
{881,3,474,"\131\123\129\068","IF \131\097\135\112 \161\164 \131\123\129\068 \138\120\133\098",38,{187,188}},
}
local function wonAdd(ev)
	local s=CC.koViewWon or ""
	if string.find(s,","..ev..",",1,true) then return end
	if s=="" then s="," end
	CC.koViewWon=s..ev.."," if rawget(_G,"koSave") then pcall(koSave) end
end
do
	local done=koIfDone
	function koIfDone(k)
		done(k)
		for _,s in ipairs(IFSIDE) do if s[2]==k then wonAdd(s[1]) end end
	end
end
if type(rawget(_G,"koFreeData"))=="table" then
	for _,s in ipairs(IFSIDE) do
		koFreeData[#koFreeData+1]={map=0,ch=6,name=s[5],turn=20,l2=-1,bgm=9,team={},enemy={},items={},golds={},
			koSide=s[1],koIf=s[2],koStory=s[3],koPlace=s[4],koLv=s[6],koJoin=s[7],koWho="Lv"..s[6]}
	end
end
do
	local st=rawget(_G,"koSideStart")
	if type(st)=="function" then
		function koSideStart(idx)
			local b=koFreeData[idx]
			if not (b and b.koIf) then return st(idx) end
			if not koSideOpen(b) then
				PlayWavE(2) WarDrawStrBoxConfirm("\129\071\133\069\131\071\129\102\131\087 \129\071 IF \130\104 \129\071\131\094\129\065 \130\065\132\116\129\076\129\077",M_White,true)
				return false
			end
			LoadRecord(0)
			JY.Base["\211\206\207\183\196\163\202\189"]=1   -- 游戏模式 1 (종횡)
			if not SaveRecord(11) then JY.Status=GAME_START return false end
			LoadRecord(11) os.remove(CC.R_GRPFilename[11])
			for i=1,JY.PersonNum-1 do GetPic(i) end
			CC.Enhancement=true CC.koReplay=true CC.koSideReplay=true
			JY.Base["\206\222\211\195\053"]=0   -- 无用5: 코스트 없음
			setv(483,idx) setv(402,b.koStory)
			for _,p in ipairs(b.koJoin) do JY.Person[p][P_LORD]=1 end
			for i=1,JY.PersonNum-1 do if JY.Person[i][P_LORD]==1 then JY.Person[i][P_LV]=b.koLv end end
			koViewLoc(b.koPlace)
			JY.Smap={} JY.SubScene=-1
			JY.Status=GAME_SMAP_AUTO
			JY.EventID=b.koSide
			return true
		end
	end
end

-- 열전 단락: 본 IF(기기 공통)가 있으면 그 무장 열전 끝에 덧붙임 (부르는 동안만)
local LZ={
	[5]={1,"\161\184\134\101\133\090\131\094\131\080 \131\098\131\112\161\185 \129\097\130\080\129\102\131\087 \130\114\132\083\139\081\133\084\129\083 \132\085 \130\071\130\080\129\094 \129\118\129\118\129\102\129\081 \131\099\133\126\129\083 \140\102\130\083 \130\075\132\107\129\077. \131\091 \135\068 \130\071\130\080\129\094 \131\087\130\075\130\104 \140\079\131\100 \139\075\131\071\138\066 \141\066, \131\081\129\109\131\080 \130\094\138\075\129\083 \131\065\129\117\132\081\131\100 \139\091\129\089\130\067 \142\080\129\102 \133\103\131\116\129\077."},
	[112]={2,"\161\184\130\090\133\120\131\080 \129\115\130\125\161\185 \129\118\129\118\129\094 \130\083\138\099\129\076\130\104 \133\082\130\090\132\083 \133\100\138\106\129\083 \132\085, \129\118\135\083\129\123 \137\072\138\095 \135\109\134\103\129\102 \133\126\130\083\131\082\130\083 \130\083\138\099\129\076\130\104 \130\119\129\066 \132\106\129\077. \130\083\138\099\129\076\131\080 \135\105\130\094\130\095\132\083 \129\077\130\086\130\098 \130\071\130\080 \142\080\129\083 \139\088\131\118\130\067 \130\107\131\116\129\077."},
	[187]={3,"\161\184\131\123\129\068 \138\120\133\098\161\185 \139\104\130\090\129\094 \133\119\133\101\131\118\131\071 \132\076\130\066 \136\070\129\070\131\080 \129\068\136\108\131\109\132\083 \131\123\129\068\130\104 \131\069\136\107\131\118\135\122 \130\071\130\080\129\102\129\081 \131\080\133\097\129\097\138\098\129\077. \133\083\130\075\131\080 \135\109\129\078\129\083 \138\116\138\116\129\071 \132\097\131\096 \131\123\129\068\130\104 \133\086\130\098 \133\104 \131\110 \130\074\129\083 \131\111\141\102\129\077."},
}
do
	local dl=rawget(_G,"DrawLieZhuan")
	if type(dl)=="function" then
		function DrawLieZhuan(name,pid)
			local a=pid and LZ[pid]
			local base=name and CC.LieZhuan and CC.LieZhuan[name]
			if a and base and koIfSeenOf(a[1]) then
				CC.LieZhuan[name]=base.."*"..a[2]
				local ok,e=pcall(dl,name,pid)
				CC.LieZhuan[name]=base
				if not ok then error(e,0) end
				return
			end
			return dl(name,pid)
		end
	end
end

-- 11-13 카페 제보 (「서서 IF 로 붙잡았는데 장안 전투에서 서서가 또 등용됨」): 본편 대본은 329 에 떠난 서서를 장안(637) · 낙양(643)
--  전투에 위군으로 내보내고(ModifyForce(112,9)) 만나면(WarMeet, 깃발 95) 다시 합류시킴. IF 2 를 이룬 판에서는 서서가 줄곧 아군이라
--  storyhire 주차로 기록을 빼 둔 채 적으로 나왔다가 「아군에 가담」 → 이제 그 두 전투에서 적으로 돌리지 않고(주차 풀기 · 적 명단에서 빼기 ·
--  위군 서서의 첫 대사 빼기), 깃발 95 를 켜 둠(뒤 사건 647 등의 「서서 돌아옴」 이 그대로 됨).
do
	local XU,XUTALK={[637]=true,[643]=true},{[638]=true,[644]=true}
	local function xuOn() return koIfDoneOf(2) and not (CC.koFree or CC.koReplay) end
	local dw=rawget(_G,"DefineWarMap")
	if type(dw)=="function" then
		function DefineWarMap(...)
			local r=dw(...)
			if XU[JY.EventID] and xuOn() and rawget(_G,"koStoryUnparkAll") then koStoryUnparkAll() end
			return r
		end
	end
	local mf=rawget(_G,"ModifyForce")
	if type(mf)=="function" then
		function ModifyForce(pid,fid,...)
			if pid==112 and fid==9 and XU[JY.EventID] and xuOn() then SetFlag(95,1) return end
			return mf(pid,fid,...)
		end
	end
	local se=rawget(_G,"SelectEnemy")
	if type(se)=="function" then
		function SelectEnemy(T,...)
			if XU[JY.EventID] and xuOn() and type(T)=="table" then
				local n,i={},1
				while T[i+10]~=nil do
					if T[i]~=111 then for k=0,10 do n[#n+1]=T[i+k] end end
					i=i+11
				end
				T=n
			end
			return se(T,...)
		end
	end
	local tk=rawget(_G,"talk")
	if type(tk)=="function" then
		function talk(...)
			if XUTALK[JY.EventID] and xuOn() then
				local a,b={...},{}
				for i=1,select("#",...),2 do if a[i]~=112 then b[#b+1]=a[i] b[#b+1]=a[i+1] end end
				if #b==0 then return end
				return tk((table.unpack or rawget(_G,"unpack"))(b))
			end
			return tk(...)
		end
	end
end
-- 군웅록 11-16 (카페 제보 「새 회차 서장 호뢰관 여포가 아군일 때의 특성 · 능력치 · 장비(등갑 · 화신)를 들고 나옴, 피가 안 빠짐」
--  · 「술집 여포는 미각성 방천화극 하나만」): IF 로 진짜 여포(5)가 우리 편인 채 회차를 넘기면, jymain koNG.reset 이 모든 기록의
--  무력 · 지력 · 통솔(+경험) · 천부 · 특기(+도구 계승이면 가방)를 다음 회차의 같은 칸에 되살려, 처음부터 적으로 나오는 여포가 그것을 들었다.
--  (IF 전에는 술집 사본 442 가 우리 편이라 사본 기록으로 이어졌음.)
--  → 넘기기 직전: 여포의 기록을 술집 사본 칸(같은 이름, 없으면 442)에 통째로 옮겨 「우리 편 사본」 처럼 이어받게 하고,
--     진짜 여포는 newgame 값으로 (능력치 · 경험 · 천부 · 특기 · 가방 · 장비). 술집 계승을 안 고르면 다른 술집 무장처럼 이어지지 않음.
--  → 이미 넘긴 세이브(2회차 이상, 이번 회차 IF 전, 여포가 적): 불러올 때 같은 일을 한 번 (사본 칸을 「지난 회차에서 이어 옴」 으로 표시).
--     적 여포가 원래 든 것(newgame 가방 · enemygear 진짜 보물 · 자기 전용 보물 원본)은 남기고 나머지만 사본에게.
do
	local LU_COPY=442
	local FLAG0=1870-420   -- 事件 1870+i-420 = 술집 사본 i 지난 회차에서 이어 옴
	local P_FACE="\205\183\207\241\180\250\186\197"   -- 头像代号
	local P_NFACE="\208\194\205\183\207\241\180\250\186\197"   -- 新头像代号 (술집에 나오는 사건)
	local P_TRAIN="\208\222\193\182"   -- 修炼
	local P_WARSAVE="\213\189\179\161\180\230\181\181"   -- 战场存档
	local REAL={[181]=4,[182]=5,[183]=10,[184]=11,[185]=12,[186]=13,[187]=14,[188]=15,[189]=16,[190]=58,[191]=59,[192]=60,[193]=61,[194]=62,[195]=63}
	local function base(i,k) return GetDataFromStruct(JY.Data_Person_Base,i*CC.PersonSize,CC.Person_S,k) end
	local function copySlot()
		local P=JY.Person[LU]
		for i=421,math.min(601,JY.PersonNum-1) do if i~=LU and JY.Person[i][P_NAME]==P[P_NAME] then return i end end
		if JY.PersonNum>LU_COPY then return LU_COPY end
	end
	-- 진짜 여포를 newgame 값으로: 능력치(+경험) · 천부 · 특기, 가방은 keep(v) 가 참인 것만 (nil 이면 newgame 가방), 장비는 비움
	local function toBase(keep)
		local P=JY.Person[LU]
		for _,f in ipairs(P_STAT) do P[f[1]]=base(LU,f[1]) P[f[2]]=base(LU,f[2]) end
		for _,f in ipairs(P_TAL) do P[f]=base(LU,f) end
		if keep then
			local u={}
			for i=1,8 do local v=P[P_ITEM..i] or 0 if v>0 and keep(v) then u[#u+1]=v end end
			for i=1,8 do P[P_ITEM..i]=u[i] or 0 end
		else
			for i=1,8 do P[P_ITEM..i]=base(LU,P_ITEM..i) end
		end
		for _,k in ipairs(P_GEAR) do P[k]=0 end
	end
	local function grown()
		local P=JY.Person[LU]
		for _,f in ipairs(P_STAT) do if (P[f[2]] or 0)~=base(LU,f[2]) then return true end end
		for _,f in ipairs(P_TAL) do if (P[f] or 0)~=base(LU,f) then return true end end
		return false
	end
	-- 넘기기 직전 (진짜 여포가 우리 편)
	local function cycleOut()
		if CONFIG.koCamp or not JY.Data_Person_Base or (JY.PersonNum or 0)<=LU_COPY then return end
		local P=JY.Person[LU]
		if P[P_LORD]~=1 then return end
		local c=copySlot()
		if not c or JY.Person[c][P_LORD]==1 then return end
		local C=JY.Person[c]
		for k,_ in pairs(CC.Person_S) do C[k]=P[k] end
		C[P_LORD]=1   -- koNG.reset 이 우리 편 술집 사본처럼 이어 감 (레벨 1 · 술집에 해금)
		toBase(nil)
		if rawget(_G,"koAddonLog") then koAddonLog("ifbranch: cycle - Lu 5 handed to tavern copy "..c) end
	end
	-- 이미 넘긴 세이브
	local function isOwnItem(v)
		local ok={}
		for i=1,8 do local b=base(LU,P_ITEM..i) if b>0 then ok[b]=true local r=REAL[b] if r then ok[(rawget(_G,"koGearMove") or {})[r] or r]=true end end end
		local gi=rawget(_G,"koGearIndexT") local k=gi and gi(JY.Person[LU][P_NAME])
		if k and koGearData and koGearData[k] then ok[koGearData[k][2]]=true end
		return ok[v]==true
	end
	-- 11-18: 적 여포 몫 = 사본 보물(181~195) · 그 자리에 enemygear 가 주는 진짜(방천화극 773 · 손자병법 4) · 자기 전용 원본.
	--  newgame 가방의 다른 도구(적토마 8)는 넘어온 가방에 있으면 지난 회차 우리 편 여포의 것 (적 여포 몫은 newgame 가방으로 다시 받음)
	local function enemyShare()
		local MV=rawget(_G,"koGearMove") or {}
		local ok={}
		for i=1,8 do local b=base(LU,P_ITEM..i) local r=REAL[b] if r then ok[b]=true ok[MV[r] or r]=true end end
		local gi=rawget(_G,"koGearIndexT") local k=gi and gi(JY.Person[LU][P_NAME])
		if k and koGearData and koGearData[k] then ok[koGearData[k][2]]=true end
		return ok
	end
	local function retroSplit(P)
		local ok=enemyShare() local moved={}
		for i=1,8 do local v=P[P_ITEM..i] or 0 if v>0 and not ok[v] then moved[#moved+1]=v end end
		return moved
	end
	local function giveCopy(C,v)
		for i=1,8 do if (C[P_ITEM..i] or 0)==0 then C[P_ITEM..i]=v return true end end
		if rawget(_G,"koStorePut") then return koStorePut(v) end
		return false
	end
	-- 11-18: 1.0.35~1.0.37 의 옮기기를 이미 거친 세이브 — 적 여포 가방에 newgame 도구(적토마)가 원래 칸이 아닌 곳에 있으면
	--  (옛 옮기기가 넘어온 가방에서 골라 앞으로 당겨 둔 것 = 지난 회차 우리 편 여포의 것) 사본에게 돌려주고 적 여포는 newgame 가방
	local function fixOldRetro()
		if CONFIG.koCamp or not on() or not JY.Data_Person_Base or (JY.PersonNum or 0)<=LU_COPY then return end
		if JY.Status==GAME_WMAP or (JY.Base[P_WARSAVE] or 0)==1 or (CC.koNG and CC.koNG.rcycle and CC.koNG.rcycle() or 1)<2 then return end
		local P=JY.Person[LU]
		if P[P_LORD]==1 or koIfChoice(1)==2 then return end
		local c=nil
		for i=421,math.min(510,JY.PersonNum-1) do if JY.Person[i][P_NAME]==P[P_NAME] and (JY.Base[EV..(FLAG0+i)] or 0)>0 then c=i break end end   -- 이어받기 표시는 510 까지 (1961+ 은 다른 칸)
		if not c then return end
		local ok=enemyShare() local got={}
		for i=1,8 do
			local b=base(LU,P_ITEM..i)
			if b>0 and not ok[b] and P[P_ITEM..i]~=b then
				for j=1,8 do if j~=i and P[P_ITEM..j]==b and base(LU,P_ITEM..j)~=b then P[P_ITEM..j]=0 got[#got+1]=b break end end
			end
		end
		if #got==0 then return end
		local C=JY.Person[c]
		for _,v in ipairs(got) do giveCopy(C,v) end
		toBase(nil)
		pcall(ReSetAttrib,c,true) pcall(ReSetAttrib,LU,true)
		if rawget(_G,"koAddonLog") then koAddonLog("ifbranch: fixOldRetro - "..table.concat(got,",").." back to tavern copy "..c) end
	end
	function koIfLuFixOldT() return fixOldRetro() end-- for test scripts
	local function cycleRetro()
		if CONFIG.koCamp or not on() or not JY.Data_Person_Base or (JY.PersonNum or 0)<=LU_COPY then return end
		if JY.Status==GAME_WMAP or (CC.koNG and CC.koNG.rcycle and CC.koNG.rcycle() or 1)<2 then return end
		local P=JY.Person[LU]
		if P[P_LORD]==1 or koIfChoice(1)==2 or not grown() then return end
		local c=copySlot()
		if not c or JY.Person[c][P_LORD]==1 then return end
		local C=JY.Person[c]
		-- 11-18 (카페 제보 「1.0.34 3회차 세이브를 1.0.37 로 불러와 술집 여포를 데려오니 ★ 방천화극 · 방어구는 왔는데 보조로 준 적토마가 없음」):
		--  자란 여포의 가방은 지난 회차 우리 편 여포의 가방(도구 계승)인데, 적토마(8) · 손자병법(4) 처럼 newgame 가방에도 있는 도구를
		--  「적 여포 원래 것」 으로 보고 진짜 여포에게 남겼음 → 사본 보물(181~195, 우리 편은 안 가짐)과 gear 가 적일 때 준 원본(★ 도 같이 있을 때)만 남기고
		--  나머지는 모두 사본에게, 진짜 여포는 newgame 가방 (적 여포는 늘 그렇듯 자기 적토마를 듦)
		local moved=retroSplit(P)
		if (JY.Base[EV..(FLAG0+c)] or 0)>0 then   -- 사본이 이미 지난 회차 기록: 높은 능력치 · 천부 · 도구만 더함
			luStats(C,P) luTal(C,P)
			for _,v in ipairs(moved) do
				local put=false
				for i=1,8 do if (C[P_ITEM..i] or 0)==0 then C[P_ITEM..i]=v put=true break end end
				if not put and rawget(_G,"koStorePut") then koStorePut(v) end
			end
		else
			for k,_ in pairs(CC.Person_S) do C[k]=P[k] end
			C[P_LV]=1 C[P_EXP]=0 C[P_TRAIN]=0 C[P_LORD]=0 C[P_NFACE]=0
			for i=1,8 do C[P_ITEM..i]=moved[i] or 0 end
			for _,k in ipairs(P_GEAR) do C[k]=0 end
			JY.Base[EV..(FLAG0+c)]=1
		end
		toBase(nil)
		pcall(ReSetAttrib,c,true) pcall(ReSetAttrib,LU,true)
		if rawget(_G,"koAddonLog") then koAddonLog("ifbranch: retro - Lu 5 growth moved to tavern copy "..c) end
	end
	function koIfLuCycleT(retro) if retro then return cycleRetro() end return cycleOut() end-- for test scripts
	local NG=CC.koNG
	if type(NG)=="table" and type(NG.reset)=="function" then
		local rawReset=NG.reset
		NG.reset=function(...)
			pcall(cycleOut)
			return rawReset(...)
		end
	end
	local lr=rawget(_G,"LoadRecord")
	if type(lr)=="function" then
		function LoadRecord(id,...)
			local r=table.pack(lr(id,...))
			if id and id>0 then local ok,err=pcall(cycleRetro) if not ok and rawget(_G,"koAddonLog") then koAddonLog("ifbranch retro: "..tostring(err)) end end
			if id and id>0 then local ok,err=pcall(fixOldRetro) if not ok and rawget(_G,"koAddonLog") then koAddonLog("ifbranch fixOldRetro: "..tostring(err)) end end
			return table.unpack(r,1,r.n)
		end
	end
end
