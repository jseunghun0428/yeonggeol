-- ko 6.0 (10-30): 적 진영 외전 (addon "foeside"). 설계: 개발용/문서/적 진영 외전 설계안.md
--   제목 「다른 모드 > 적 진영」: 본편에서 유비와 맞섰던 쪽(조조 · 손권 · 위)이 되어 막마다 전투 셋을 차례로.
--   전투 = 본편 전투의 공수 뒤집기(foeside_data.lua = 본편 배치 그대로, 도구/적진영_배치.pl): 본편의 적 부대(앞 10)가 우리 편,
--   본편 아군 칸에 유비군(빈자리는 그 무렵 유비군 장수). 이기는 조건 = 유비군 대장(맨 앞 칸, 대개 유비) 격퇴, 우리 대장이 퇴각하면 패배.
--   막이 열리는 때 = 본편에서 그 막의 마지막 전투를 이김(기기 공통 CC.koFoeOpen, 옛 세이브는 불러올 때 진행으로 채움).
--   새 기록(LoadRecord(0))에서 돌림 = 이야기 세이브와 무관, 자유 전투로 취급(CC.koFree = 이 애드온의 줄, 탭에 안 보임).
--   임시 기록의 事件 377 = 막, 378 = 몇째 전투. 사건 = Event[900] 준비 · [901] 시작 · [902] 전투 중.
-- Source: 개발용/addon/foeside_src.lua (UTF-8) → script/addon/foeside.lua (도구/free_hz.pl). free · view 뒤.
if not koNeeds("free") then return end
pcall(dofile,CONFIG.ScriptPath.."addon/foeside_data.lua")   -- koFoeRaw
local RAW={} for _,b in ipairs(rawget(_G,"koFoeRaw") or {}) do RAW[b.war]=b end
-- 6.0 (11-02) 이야기판: 이야기 모드면 script/camp/<id>/foeside_data.lua(koFoeStory = 막 표, 전투는 사건 번호)를 읽고 전투 배치는
-- 그 이야기 자유 전투 표(koFreeData, 도구/캠페인자유전투.py 의 ally · enemy)에서 뒤집음. 막 표가 없으면 이 메뉴를 내지 않음.
local STORY=nil
local HERO,HEROWA="\130\071\130\080","\130\071\130\080\135\122"
if rawget(_G,"koCamp") then
	koFoeStory=nil
	pcall(dofile,CONFIG.koCampScript.."foeside_data.lua")
	STORY=rawget(_G,"koFoeStory")
	if not STORY then return end
	HERO,HEROWA=STORY.hero,STORY.herowa
	RAW={}
	for _,a in ipairs(STORY.acts) do
		for k,ev in ipairs(a.wars) do
			for _,b in ipairs(koFreeData) do
				if b.ev==ev and b.ally then
					local en={}
					for _,r in ipairs(b.enemy) do en[#en+1]={r[1]+1,r[2],r[3],r[4],r[5],math.min(99,r[6]),r[7],0} end
					RAW[b.name]={war=b.name,map=b.map,turn=b.turn,l2=b.l2+1,ally=b.ally,enemy=en}
					a.wars[k]=b.name
					break
				end
			end
		end
	end
end
local function short(w) return (string.gsub(w,"^[^ ]*\131\097 ","")) end
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

local EV="\202\194\188\254"   -- 事件
local function fv(n) return JY.Base[EV..n] or 0 end
local function setv(n,v) JY.Base[EV..n]=v end
local P_LORD="\190\253\214\247"   -- 君主
local P_NAME="\208\213\195\251"   -- 姓名
local P_LV="\181\200\188\182"   -- 等级
local P_BZ="\177\248\214\214"   -- 兵种
local S_ACT,S_K=377,378
local E0=900
local MAXUS,MAXFOE=10,10

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koFoeOpen",default=""}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koFoeWon",default=""}

-- 막: 전투 셋(본편 이름) · 열리는 본편 사건(옛 세이브 진행 판정) · 빈자리에 설 유비군 · 전투마다 우리 대장 한마디
local ACT=STORY and STORY.acts or {
{key="\129\118\129\118",title="\129\118\129\118 \161\164 \130\071\130\080\130\104 \139\075\129\110\130\102",open=360,
	wars={"\129\1001\131\097 \129\109\129\079 \130\066\132\101","\129\1002\131\097 \129\098\133\103 \130\066\132\101","\129\1002\131\097 \136\123\136\111\134\086 \130\066\132\101"},
	fill={2,3,54,64,65,83,82,114,112,30,44},
	intro="\161\161\130\115\129\097\130\104 \131\089\129\117\130\098 \129\118\129\118\129\102\129\081 \130\071\130\080\130\098 \131\088 \132\073\129\204\129\094\130\086\138\098\129\077. \131\087\130\075\129\102\131\087, \129\098\133\103\129\102\131\087, \131\078\133\069\129\102\131\087 \129\118\129\118\130\084\131\098 \130\071\130\080\130\104 \139\075\131\116\129\077.",
	lines={{9,"\130\071\130\080\129\094 \129\109\129\079\129\102 \131\082\130\083\140\095\131\116\129\077. \129\071\130\087\129\102\133\069\136\124\132\083 \140\081\141\121\129\110 \132\113\131\096\130\102!"},{19,"\130\071\130\080 \140\078\129\071 \129\098\133\103\129\102\131\087 \135\079 \133\073\130\083\140\085\129\077. \129\118\129\106\131\080 \129\071\138\075\131\109\132\083 \132\080\130\083\132\113\129\117\134\121\129\077!"},{17,"\129\100\135\121\132\088\129\071\130\102\130\098 \140\105\135\112\129\071\129\094 \129\073\135\074\129\083 \129\097\134\121\134\115\138\109. \131\078\133\069\130\104 \134\077\133\126\129\102 \137\072\136\121\129\097\130\102!"}},
	ending="\161\161\129\118\129\118\130\084\131\098 \133\088\131\108\131\095 \130\071\130\080\130\104 \140\123\129\110\140\069\138\098\129\077. \131\091\133\101\131\118 \130\071\130\080\130\098 \136\065\129\100\131\118\139\110\134\123 \134\106\129\110\133\103\129\110 \129\077\130\086 \133\073\130\083\140\085\129\077\161\173\161\173."},
{key="\135\089\135\098",title="\135\089\135\098 \161\164 \130\073\130\108\131\080 \131\085\134\118",open=590,
	wars={"\129\1003\131\097 \130\074\130\111 \130\066\132\101","\129\1003\131\097 \131\087\142\083 \130\066\132\101","\129\1003\131\097 \129\071\142\083 \130\066\132\101"},
	fill={2,3,54,170,127,128,155,190,204,30,44,126,133,188},
	intro="\161\161\136\069\130\075\130\104 \130\091\131\100 \135\089\135\098\129\123 \130\071\130\080\131\080 \130\108\134\095\131\098 \131\103\129\071 \137\116\129\077. \130\073\130\108\131\080 \131\097\129\113\131\082\131\098 \136\069\130\075\135\122 \129\071\142\083\129\102\131\087 \130\071\130\080\130\084\129\123 \138\071\140\085\129\077.",
	lines={{143,"\136\069\130\075\130\098 \131\081\134\071 \131\079\129\117 \130\073\130\108\131\080 \131\117\129\071\129\077. \130\071\130\080\129\102\129\081 \140\102\131\096\132\123 \129\089\141\086\129\071 \130\097\129\077!"},{42,"\130\075\130\074\131\080 \130\088\129\071\129\077. \131\087\142\083\129\083 \130\067\137\097 \130\071\130\080\131\080 \139\070\139\091\129\083 \132\095\130\083\130\102!"},{151,"\131\087\130\091\130\106\130\067 \133\088\130\102. \131\076\129\071 \130\067\132\081\131\071\130\104 \131\071\129\077\132\126\129\077\129\094 \133\100\132\083 \136\106\129\077."}},
	ending="\161\161\130\073\130\108\131\080 \131\097\129\113\131\082\131\098 \139\091\129\089\130\067 \137\106\141\102\129\077. \129\071\142\083\131\080 \133\100\134\114 \133\123\129\102\131\087\129\068 \130\071\130\080\130\098 \132\095\129\071\130\067 \130\107\131\116\129\077\161\173\161\173."},
{key="\130\110",title="\130\110 \161\164 \133\088\130\067\135\102 \132\078\133\087",open=663,
	wars={"\129\1004\131\097 \129\103\134\103 \130\066\132\101","\129\1004\131\097 \131\097\130\111 \130\066\132\101","\129\1004\131\097 \134\110II \130\066\132\101"},
	fill={2,3,170,127,190,204,30,44,128,155,126,133,244},
	intro="\161\161\129\118\129\118\129\094 \131\111\129\067\129\083 \139\088\130\113 \135\068\129\102\129\068 \130\110\131\080 \131\097\129\113\131\082\131\098 \129\103\134\103\129\123 \131\097\130\111, \131\091\129\117\131\100 \134\110\129\102\131\087 \135\123\131\080 \135\107\137\114\129\083 \135\102\129\110\140\085\129\077.",
	lines={{243,"\129\103\134\103\131\098 \129\071 \135\115\129\109\129\094 \130\067\137\074\130\098 \129\111 \134\064\138\072 \132\110\130\083\130\067\130\067 \130\107\130\098\129\077!"},{242,"\131\097\130\111\129\083 \131\095\132\123 \129\113\130\098 \130\097\129\077. \130\095\131\097\130\084\131\080 \129\071\138\075\129\083 \130\064\131\100 \135\102\129\110\130\102!"},{214,"\129\118\129\118 \130\075\130\074\131\080 \131\093\129\083 \137\123\130\098\129\077. \134\110\129\102\131\087 \139\091\129\083 \131\115\133\120!"}},
	ending="\161\161\130\110\131\080 \131\097\129\113\131\082\131\098 \133\088\130\067\135\102\129\089\130\067 \132\113\144\078\129\077. \131\091\133\101\131\118 \130\115\130\088\131\098 \139\091\131\095 \130\071\130\080\129\102\129\081 \137\066\129\110\137\116\129\077\161\173\161\173."},
}
-- 이야기판에서 막 열기 사건 번호가 없으면 마지막 전투 사건 다음
for _,a in ipairs(ACT) do if not a.open then a.open=1 end end
koFoeActs=ACT   -- 시험용

local function hasKey(s,k) return string.find(s or "",","..k..",",1,true)~=nil end
local function addKey(field,k) if hasKey(CC[field],k) then return end local s=CC[field] or "" if s=="" then s="," end CC[field]=s..k.."," if rawget(_G,"koSave") then pcall(koSave) end end
function koFoeIsOpen(a) return hasKey(CC.koFoeOpen,ACT[a].key) end

-- 막 열기: 본편에서 그 막의 마지막 전투를 이김 / 옛 세이브는 진행으로
local function story() return not (CC.koFree or CC.koTownBattle or CC.koReplay) end
koOn("war_won",function()
	if not story() then return end
	for _,a in ipairs(ACT) do if War.WarName==a.wars[#a.wars] then addKey("koFoeOpen",a.key) end end
end)
local function backfill()
	if not story() or not JY.Base then return end
	local ev=(rawget(_G,"koStoryEv") and koStoryEv()) or JY.EventID or 0
	for _,a in ipairs(ACT) do if ev>=a.open and (STORY or ev<700) then addKey("koFoeOpen",a.key) end end
end

-- 자유 전투 표 줄
local ROW={map=0,ch=99,name="\131\076 \129\103\129\126",turn=20,l2=-1,bgm=9,team={},enemy={},items={},golds={},foe=true}
koFreeData[#koFreeData+1]=ROW
local function rowIdx() for i,b in ipairs(koFreeData) do if b==ROW then return i end end return 0 end
local function active() return CC.koFree and CC.koFree.foe and fv(S_ACT)>0 end
function koFoeActive() return active() end
local function curAct() return ACT[fv(S_ACT)] end
local function curWar() local a=curAct() return a and RAW[a.wars[fv(S_K)]],a end

-- 한 전투의 양쪽 (본편 적 → 우리, 본편 아군 칸 → 유비군)
local function build(b,a)
	local us,usSet={},{}
	for _,e in ipairs(b.enemy) do
		if #us>=MAXUS then break end
		if not usSet[e[1]] then us[#us+1]=e usSet[e[1]]=true end
	end
	local lead=usSet[b.l2] and b.l2 or us[1][1]
	local sum=0 for _,e in ipairs(us) do sum=sum+e[6] end
	local lv=math.max(1,math.floor(sum/#us)-3)
	local foe,used,fi={},{},1
	for _,s in ipairs(b.ally) do
		if #foe>=MAXFOE then break end
		local p=s[1]
		if p==0 or usSet[p] or used[p] then
			p=nil
			while fi<=#a.fill do local c=a.fill[fi] fi=fi+1 if not usSet[c] and not used[c] then p=c break end end
		end
		if p then used[p]=true foe[#foe+1]={p,s[2],s[3],s[4]} end
	end
	return us,lead,foe,lv
end
koFoeBuild=build   -- 시험용

local function evPrep()   -- 준비
	local b,a=curWar()
	if not b then JY.Status=GAME_START return end
	local us,lead,foe,lv=build(b,a)
	WarIni()
	local boss=foe[1][1]
	DefineWarMap(b.map,a.key.." \161\164 "..short(b.war),"1. "..JY.Person[boss][P_NAME].." \130\112\133\068*2. "..JY.Person[lead][P_NAME].." \133\068\130\069 \130\086 \129\079\134\099",b.turn,lead-1,boss-1)
	for i=1,JY.PersonNum-1 do if JY.Person[i][P_LORD]==1 then JY.Person[i][P_LORD]=0 end end
	local team={}
	for _,e in ipairs(us) do
		JY.Person[e[1]][P_LORD]=1
		if rawget(_G,"koFreeSetLevel") then koFreeSetLevel(e[1],math.min(99,e[6]),e[7]) end
		for _,v in ipairs({e[1]-1,e[2],e[3],e[4],0,-1,0}) do team[#team+1]=v end
	end
	SelectTerm(1,team)
	local rows={}
	for _,f in ipairs(foe) do
		local bz=JY.Person[f[1]][P_BZ]
		for _,v in ipairs({f[1]-1,f[2],f[3],f[4],1,lv,bz,0,0,-1,0}) do rows[#rows+1]=v end
	end
	local enh=CC.Enhancement CC.Enhancement=false
	SelectEnemy(rows)
	CC.Enhancement=enh
	for _,f in ipairs(foe) do if rawget(_G,"koFreeSetLevel") then koFreeSetLevel(f[1],lv,JY.Person[f[1]][P_BZ]) end end
	JY.Status=GAME_WMAP
	NextEvent()
end
local function evStart()   -- 시작
	local b,a=curWar()
	PlayBGM(11)
	if fv(S_K)==1 then DrawMulitStrBox(a.intro) end
	local l=a.lines[fv(S_K)]
	if l then talk(l[1],l[2]) end
	WarShowTarget(true)
	PlayBGM(14)
	NextEvent()
end
local function reg()   -- 6.0 이야기판: 이야기 대본이 Event 표를 통째로 바꾸므로 시작 · 불러오기 때 다시 걺
	Event[E0]=evPrep
	Event[E0+1]=evStart
	Event[E0+2]=function() end   -- 전투 중: 승패는 엔진(대장 격퇴 · 우리 대장 퇴각 · 턴 끝)
end
reg()

koOn("war_end",function()
	if not active() then return nil end
	local b,a=curWar()
	local kw=rawget(_G,"koWar")
	local won=(JY.Status==GAME_WARWIN or JY.Status==GAME_SMAP_AUTO) and not (kw and kw.lost)
	if won and fv(S_K)<#a.wars then
		PlayBGM(7)
		WarDrawStrBoxWaitKey(a.key.." \129\103\129\126  "..fv(S_K).." / "..#a.wars.." \129\116\129\117!  \129\077\130\077 \130\066\132\101\132\083",M_White)
		setv(S_K,fv(S_K)+1)
		JY.Smap={} JY.SubScene=-1
		JY.Status=GAME_SMAP_AUTO
		JY.EventID=E0
		return nil
	end
	if won then
		addKey("koFoeWon",a.key)
		PlayBGM(7)
		WarDrawStrBoxWaitKey("\161\184"..a.title.."\161\185 \134\108\129\085!",M_White)
		DrawMulitStrBox(a.ending)
	else
		PlayBGM(4)
		WarDrawStrBoxWaitKey("\129\079\134\099\161\173\161\173  \133\064\129\071\140\071\132\083 \137\066\129\110\134\104\129\076\129\077",M_White)
	end
	setv(S_ACT,0) setv(S_K,0)
	CC.koFree=nil CC.koReplay=nil
	JY.Status=GAME_START
	return nil
end)
do
	local lr=rawget(_G,"LoadRecord")
	function LoadRecord(...)
		local r=lr(...)
		if fv(S_ACT)>0 and ACT[fv(S_ACT)] then CC.koFree={idx=rowIdx(),foe=true,started=true} CC.koReplay=true CC.Enhancement=true reg()
		else pcall(backfill) end
		return r
	end
end

function koFoeStart(i,k)
	if not ACT[i] then return false end
	LoadRecord(0)
	JY.Base["\211\206\207\183\196\163\202\189"]=1   -- 游戏模式 1
	if not SaveRecord(11) then JY.Status=GAME_START return false end
	LoadRecord(11) os.remove(CC.R_GRPFilename[11])
	reg()
	for p=1,JY.PersonNum-1 do GetPic(p) end
	CC.Enhancement=true CC.koReplay=true
	CC.koFree={idx=rowIdx(),foe=true,started=true}
	JY.Base["\206\222\211\195\053"]=0   -- 无用5: 코스트 없음
	JY.Base["\213\194\189\218\195\251"]="\131\076 \129\103\129\126\161\161"..ACT[i].key   -- 章节名
	JY.Person[1]["\195\216\188\1881"]=0   -- 秘技1 0
	setv(S_ACT,i) setv(S_K,k or 1)
	JY.Smap={} JY.SubScene=-1
	JY.Status=GAME_SMAP_AUTO
	JY.EventID=E0
	return true
end
function koFoeScreen()
	while true do
		lib.FillColor(0,0,0,0,0)
		local items={}
		for i,a in ipairs(ACT) do
			if koFoeIsOpen(i) then items[i]=a.title..(hasKey(CC.koFoeWon,a.key) and "  (\134\108\129\085)" or "")
			else items[i]="\163\191\163\191\163\191" end
		end
		items[#items+1]="\137\066\129\110\129\094\131\071"
		local r=pickMenu("\131\076 \129\103\129\126 \131\107\130\066 : \132\118\132\075\129\102\131\087 "..HEROWA.." \138\071\140\085\138\066 \139\074\129\071 \132\067\130\083 \137\106\135\083\129\077. (\129\071\133\069\131\071 \131\111\129\071\153\228\135\122 \129\073\129\101)",items)
		if r>#ACT then return end
		local a=ACT[r]
		if not koFoeIsOpen(r) then
			lib.FillColor(0,0,0,0,0)
			pickMenu("\132\118\132\075\129\102\131\087 \161\184"..short(a.wars[#a.wars]).."\161\185 \129\083 \129\071\131\071\129\065 \130\065\132\116\129\076\129\077.",{"\129\105\129\106"})
		else
			lib.FillColor(0,0,0,0,0)
			local info="\161\184"..a.title.."\161\185*"..table.concat(a.wars," \161\250 ")
			if pickMenu(info,{"\130\086\129\074\129\111\129\077","\131\099\133\108\131\109\132\083"})==1 then
				if koFoeStart(r) then return end
			end
		end
	end
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\131\076 \129\103\129\126 \131\107\130\066",run=function() koFoeScreen() end}
