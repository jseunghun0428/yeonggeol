-- ko 6.0 (10-30): conquest — 정벌 모드 4판 (설계 = Downloads/영걸전/conquest_design_v1.md, 사용자 10-30 「나머지는 md 대로」)
-- (UTF-8 원본: 개발용/addon/conquest_src.lua -> 도구/free_hz.pl -> script/addon/conquest.lua, addons.lua 에서 bogam 뒤 · recsave 앞, free · freeplus 필요)
-- 앞 판(10-29, 구역 2 × 5칸 · 원작 전투 26개 · 事件 1940~1982)은 이 판으로 바뀜. 옛 판의 전투 중 저장은 이어 하지 못하고 제목으로 돌아감.
--   · 길 = 구역 3 × 10단. 단 1 = 일반전 하나, 단 2~8 = 갈림길 2~3칸, 단 9 = 보급, 단 10 = 보스. 실제로 지나가는 칸 = 30
--     지도 칸 = 일반 · 정예 · 보스 · 상점 · 쉼터 · ? 여섯 가지 (10-30 사용자). ? = 들어가면 일반전 · 상점 · 보물 상자 · 사건 중 누적 확률로 (첫 정예 = 4단부터, 정예 연속 없음, 같은 종류 세 번 연속 없음,
--     구역마다 상점 1~2개, 어느 길로 가도 전투 4~7번). 지도는 판 시작 씨앗으로 정해져 판 내내 같음(불러와도 같음)
--   · 전투 지도 = 사용자 정벌 지도 24장(지도 74~97, 개발용/정벌 지도, add_정벌_지도.pl), 배치 = deployment_notes 좌표 그대로(아래 MAPS)
--     일반전 = 적 5 · 정예전 = 적 6 · 보스전 = 보스 + 호위 5. 출진 최대 4명(배치 칸 4개), 부대 최대 6명
--   · 패배 = 출진한 무장이 모두 퇴각할 때뿐 (주장 개념 없음, 10-30 사용자). 전투에서 이기면 퇴각한 무장은 병력 1로 돌아옴 (10-30 사용자)
--   · 병력 · 책략은 다음 전투로 이어짐: 이긴 뒤 출진해 살아남은 무장 병력 +5% · 책략 +15% (구역 보스 뒤 +20% · +30%), 뒤에 남은 무장은 그대로
--     레벨이 오를 때(훈련 · 사건)는 병력 · 책략 비율을 그대로 둠
--   · 적 레벨 = 시작 레벨 + 5 × (구역-1) + 구역 안 진행 0~2, 정예 +2, 보스 호위 +2 · 보스 +4, 어려움 단계마다 +1 (부대 레벨을 따라 오르지 않음)
--   · 군자금 = 시작 150, 일반전 100 + 30 × (구역-1), 정예 ×1.5, 보스 ×2 (정벌 안에서만 쓰는 돈, 이야기 금과 따로)
--   · 보상: 일반전 3택1 (군령 · 보물 · 합류 · 훈련 · 응급 복구, 구역마다 가중치), 정예 = 군령 3택1 + 일반 보상, 보스 = 핵심 3택1 + 대장의 전용 보물
--   · 군령 12종 (C 기병 · D 방어 · S 책략 · U 공용, 강화 한 번, 보유 8개): WarAtkHurt · WarAtk · WarMagic 감싸기 — 미리보기와 실제 피해가 같은 계산
--   · 사건 12종 (8종 + 공적 500 해금 4종, 판 안 중복 없음) · 상점(칸마다 재고 한 번씩) · 쉼터 · 보물 상자(? 에서만)
--   · 정산: 공적 = 10 × 일반전 + 30 × 정예 + 60 × 보스 + 완주 150, 어려움 단계마다 ×0.2 더. 이야기 세이브 · 도감에는 남지 않음
-- 판 상태 = 자유 전투 임시 기록의 예비 인물 칸 650 · 651 (storyhire 주차 칸 602~661 의 끝, 정벌 기록에서는 주차가 일어나지 않음),
--   gear 와 같은 안전한 칸(외호 24~36 · 136~150) 15칸씩 = 30칸 (아래 S_*). 전투 중 저장하면 지도 · 경로 · 군령이 함께 저장됨
if not koNeeds("free") then return end
local function K(...) return string.char(...) end
local LORD=K(190,253,214,247)      -- 君主
local NAME=K(208,213,195,251)      -- 姓名
local HP,HPMAX=K(177,248,193,166),K(215,238,180,243,177,248,193,166)-- 兵力 最大兵力
local SP,SPMAX=K(178,223,194,212),K(215,238,180,243,178,223,194,212)-- 策略 最大策略
local LV=K(181,200,188,182)        -- 等级
local BZ=K(177,248,214,214)        -- 兵种
local FACE=K(205,183,207,241,180,250,186,197)-- 头像代号
local ITEM=K(181,192,190,223)      -- 道具
local INAME=K(195,251,179,198)     -- 名称
local OWNER=K(215,168,202,244,204,216,188,188,200,203)-- 专属特技人
local WU,ZHI,TONG=K(206,228,193,166),K(214,199,193,166),K(205,179,194,202)-- 武力 智力 统率
local ATK,SATK,DEF=K(185,165,187,247),K(178,223,194,212,185,165,187,247),K(183,192,211,249)-- 攻击 策略攻击 防御
local MAXARMY=6
local SORTIE=4

-- ---------------------------------------------------------------- 전투 지도 24장 (개발용/정벌 지도/배치.lua 를 그대로 옮김)
-- {지도 번호, 이름, 종류 1 일반 2 정예 3 보스, 너비, 높이, 아군 {{x,y}...}, 적 {{x,y,역할}...}}. 역할: 1 보병 2 기병 3 궁병 4 책사 5 호위 9 보스. 좌표는 0부터.
local MAPS={
	{74,"\137\095\134\114 \129\101\133\090",1,12,12,{{3,4},{3,5},{2,4},{2,5}},{{7,3,1},{7,4,2},{9,2,3},{9,3,4},{9,4,3}}},
	{75,"\129\097\130\115 \132\087\132\088",2,14,12,{{3,5},{3,6},{2,5},{2,6}},{{9,4,1},{9,5,1},{9,6,1},{11,4,3},{11,5,4},{11,6,3}}},
	{76,"\129\109\136\069 \131\123\133\094",3,14,14,{{5,11},{7,11},{5,12},{7,12}},{{6,3,9},{3,5,3},{9,5,4},{4,7,5},{8,7,5},{6,9,1}}},
	{77,"\131\124\131\081 \132\091\131\071\159\071",1,12,12,{{6,8},{7,8},{6,9},{7,9}},{{6,3,1},{7,3,1},{5,1,3},{6,1,4},{7,1,3}}},
	{78,"\137\075\131\098 \137\095 \129\094\131\097\133\120\129\117",1,12,12,{{8,6},{8,7},{9,6},{9,7}},{{3,6,1},{3,7,1},{1,5,3},{1,6,4},{1,7,3}}},
	{79,"\129\071\130\101 \133\089\133\087 \137\071\137\086",2,14,12,{{2,6},{2,7},{1,6},{1,7}},{{7,6,1},{7,7,1},{7,5,5},{9,5,3},{9,6,4},{9,7,3}}},
	{80,"\130\085\137\083 \131\100\130\166\134\114",1,12,12,{{8,6},{8,7},{9,6},{9,7}},{{3,6,1},{3,7,1},{1,5,3},{1,6,4},{1,7,3}}},
	{81,"\130\085\129\073\130\067 \132\091\133\108",1,12,12,{{8,6},{8,7},{9,6},{9,7}},{{3,6,1},{3,7,1},{1,5,3},{1,6,4},{1,7,3}}},
	{82,"\130\073\130\116 \130\085\137\083 \130\095\130\067",2,14,12,{{6,8},{7,8},{6,9},{7,9}},{{6,3,1},{7,3,1},{5,3,5},{5,1,3},{6,1,4},{7,1,3}}},
	{83,"\134\072\134\077 \129\097\130\115",2,14,12,{{4,6},{4,7},{3,6},{3,7}},{{9,6,1},{9,7,1},{9,5,5},{11,5,3},{11,6,4},{11,7,3}}},
	{84,"\136\095\131\098 \130\073 \129\068\129\097",2,14,12,{{6,8},{7,8},{6,9},{7,9}},{{6,3,1},{7,3,1},{5,3,5},{5,1,3},{6,1,4},{7,1,3}}},
	{85,"\134\113\129\113 \130\108\139\074 \131\065\129\094",1,12,12,{{8,6},{8,7},{9,6},{9,7}},{{3,6,1},{3,7,1},{1,5,3},{1,6,4},{1,7,3}}},
	{86,"\134\113\129\113 \131\087\130\111 \132\087\132\088",2,14,12,{{4,2},{4,3},{3,2},{3,3}},{{9,2,1},{9,3,1},{9,1,5},{11,1,3},{11,2,4},{11,3,3}}},
	{87,"\130\085\137\083 \130\073\130\116",1,12,12,{{8,6},{8,7},{9,6},{9,7}},{{3,6,1},{3,7,1},{1,5,3},{1,6,4},{1,7,3}}},
	{88,"\129\066\133\120 \131\123\133\090",3,14,14,{{10,2},{10,3},{11,2},{11,3}},{{4,2,1},{4,3,1},{4,1,5},{2,1,3},{2,2,9},{2,3,3}}},
	{89,"\129\071\130\101 \131\123\135\106",3,14,14,{{8,8},{9,8},{8,9},{9,9}},{{8,3,1},{9,3,1},{7,3,5},{7,1,3},{8,1,9},{9,1,3}}},
	{90,"\129\068\130\086 \140\065\131\099",2,14,12,{{8,2},{9,2},{8,1},{9,1}},{{8,7,1},{9,7,1},{7,7,5},{7,9,3},{8,9,4},{9,9,3}}},
	{91,"\131\123\131\095 \130\072\131\097",3,14,14,{{4,8},{4,9},{3,8},{3,9}},{{9,8,1},{9,9,1},{9,7,5},{11,7,3},{11,8,9},{11,9,3}}},
	{92,"\131\065\129\094 \129\090\134\068",3,14,14,{{6,8},{6,9},{5,8},{5,9}},{{10,8,1},{10,9,1},{10,7,5},{12,7,3},{12,8,9},{12,9,3}}},
	{93,"\130\073\130\116 \132\091\133\094",3,14,14,{{10,6},{10,7},{11,6},{11,7}},{{5,6,1},{5,7,1},{5,5,5},{3,5,3},{3,6,9},{3,7,3}}},
	{94,"\133\069\129\126\130\067 \131\107\135\106",1,12,12,{{2,8},{2,9},{1,8},{1,9}},{{7,8,1},{7,9,1},{9,7,3},{9,8,4},{9,9,3}}},
	{95,"\137\095 \130\114\129\071 \133\091\133\064\129\117",1,12,12,{{8,8},{9,8},{8,9},{9,9}},{{8,3,1},{9,3,1},{7,1,3},{8,1,4},{9,1,3}}},
	{96,"\133\091\133\064\129\117 \129\103\130\067",2,14,12,{{10,6},{10,7},{11,6},{11,7}},{{5,6,1},{5,7,1},{5,5,5},{3,5,3},{3,6,4},{3,7,3}}},
	{97,"\130\095\130\066 \130\125\135\124",3,14,14,{{8,10},{9,10},{8,11},{9,11}},{{8,5,1},{9,5,1},{7,5,5},{7,3,3},{8,3,9},{9,3,3}}},
}
local MAPBYKIND={{},{},{}}
for i,m in ipairs(MAPS) do local t=MAPBYKIND[m[3]] t[#t+1]=i end
-- 미니맵: 정벌 지도는 12~14칸이라 칸 4px 이면 48~56px 로 너무 작음 → 칸 6px (10-30 사용자) (mmap 100+NN 그림도 8px, add_정벌_지도.pl). 10-30 사용자
do
	local rawMS=koMiniS
	if type(rawMS)=="function" then
		-- 모든 정벌 지도 칸 6px (12칸 72px · 14칸 84px, 오른쪽 아래 틀 안). 그림(mini8_NN.png)도 6px
		local MS={} for _,m in ipairs(MAPS) do MS[m[1]]=6 end
		function koMiniS() if War and War.MapID and MS[War.MapID] then return MS[War.MapID] end return rawMS() end
	end
end
-- 병종 계열 (역할 고르기 · 기병 군령): 1 보병 2 기병 3 궁병 4 책사
local FAM={[1]=1,[2]=1,[3]=1,[10]=1,[11]=1,[12]=1,[15]=1,[17]=1,[18]=1,[20]=1,[23]=1,[24]=1,[25]=1,[29]=1,[36]=1,
	[7]=2,[8]=2,[9]=2,[22]=2,[30]=2,[31]=2,
	[4]=3,[5]=3,[6]=3,[21]=3,[37]=3,
	[13]=4,[14]=4,[16]=4,[19]=4,[26]=4,[27]=4,[32]=4,[33]=4,[34]=4,[35]=4,[38]=4}
local function famOf(pid) return FAM[JY.Person[pid][BZ] or 0] or 1 end
local FIRE={[0]=true,[1]=true,[2]=true,[3]=true,[4]=true,[5]=true,[39]=true}-- 초열 · 화룡 · 맹화 · 대초열 · 대화룡 · 화신

-- 배경 음악: 원작 전투 몇 개의 것을 빌려 씀
local BGMS={}
for _,b in ipairs(koFreeData) do if b.bgm and b.ch and b.ch<=4 and not (b.tower or b.demon or b.side) then BGMS[#BGMS+1]=b.bgm end end
if #BGMS==0 then BGMS={9} end

local CONQ={map=MAPS[1][1],ch=7,name="\129\070\137\114",turn=20,l2=-1,bgm=BGMS[1],conquest=true,
	team={{3,4,4},{3,5,4},{2,4,4},{2,5,4}},enemy={},items={},golds={}}
koFreeData[#koFreeData+1]=CONQ
function koConqActive()
	local f=CC.koFree
	return f~=nil and koFreeData[f.idx or 0]~=nil and koFreeData[f.idx].conquest==true
end

-- ---------------------------------------------------------------- 판 상태 (인물 칸 650 · 651 의 15칸씩)
local VER=4
local PS=CC.PersonSize
local REC={650,651}
local W15={24,26,28,30,32,34,36,136,138,140,142,144,146,148,150}
local S={VER=1,SA=2,SB=3,POS=4,GOLD=5,DIFF=6,LV=7,WN=8,WE=9,WB=10,FLAG=11,NB=12,KIND=13,MAP=14,EVU=15,
	LANE=16,-- 16~20: 새 경로는 5진수 6단씩(1~5), 이전 경로는 2비트 7단씩
	ORD=21,-- 21 · 22: 군령 12개 2비트씩 (0 없음 1 보유 2 강화), 칸 하나에 7개
	REM=23,U01=24,S02=25,-- 군령 제거 횟수 · 전장 구호 이번 전투 횟수 · 군사 보좌 쓴 턴
	MARK=26,MTURN=27,RAGE=28,-- 보스 기믹: 계략 표시 칸(x*100+y) · 표시한 턴 · 혼합형 분노
	QPITY=29,ROUTE=30}-- ? 칸 누적 단계: 일반전 · 상점 · 보물 상자 4비트씩 (나오지 않을 때마다 +1, 나오면 0)
local NSLOT=30
local function haveRec() return (JY.PersonNum or 0)>REC[#REC] end
local function addr(k) return REC[math.floor((k-1)/15)+1]*PS+W15[(k-1)%15+1] end
local function sget(k) if not haveRec() then return 0 end return Byte.get16(JY.Data_Person,addr(k)) end
local function sset(k,v) if haveRec() then Byte.set16(JY.Data_Person,addr(k),math.max(0,math.min(32767,math.floor(v)))) end end
local function flag(b) return math.floor(sget(S.FLAG)/b)%2==1 end
local function setFlag(b) if not flag(b) then sset(S.FLAG,sget(S.FLAG)+b) end end
-- S.FLAG: 1 다시 뽑기 씀 · 2 시작 준비 끝 · 4 보물 지도(다음 보물 후보 좋게) · 8 정산 끝
local function gold() return sget(S.GOLD) end
local function addGold(d) sset(S.GOLD,math.max(0,gold()+d)) end
local function diff() return sget(S.DIFF) end
local function baseLv() local v=sget(S.LV) return (v>0) and v or 20 end
local function curPos() return math.max(1,sget(S.POS)) end
local function zoneOf(s) return math.floor((s-1)/10)+1 end
local function rowOf(s) return (s-1)%10+1 end
local function bits2(base,i) local k=base+math.floor((i-1)/7) local sh=((i-1)%7)*2 return math.floor(sget(k)/(2^sh))%4,k,sh end
local function setBits2(base,i,v) local old,k,sh=bits2(base,i) sset(k,sget(k)+(v-old)*(2^sh)) end
-- New routes encode six base-5 lane digits per slot (0..15624); 5 slots hold all 30 visits.
-- Old routes keep their original 2-bit representation.
local function laneAt(s)
	if sget(S.ROUTE)<2 then return (bits2(S.LANE,s)) end
	local k=S.LANE+math.floor((s-1)/6)
	return math.floor(sget(k)/(5^((s-1)%6)))%5+1
end
local function setLane(s,l)
	if sget(S.ROUTE)<2 then setBits2(S.LANE,s,l) return end
	local k=S.LANE+math.floor((s-1)/6) local mul=5^((s-1)%6)
	local old=math.floor(sget(k)/mul)%5
	sset(k,sget(k)+((l-1)-old)*mul)
end

-- ---------------------------------------------------------------- 씨앗 난수 (판마다 같은 결과: 지도 · 보상 후보 · 재고 · 사건, 불러와도 다시 뽑히지 않음)
local function seed() return sget(S.SA)*32768+sget(S.SB) end
local function mkRng(...)
	local s=seed()+1
	for _,v in ipairs({...}) do s=(s*31+v*7919+17)%2147483647 end
	if s<=0 then s=s+2147483646 end
	local st=s
	local r={}
	function r.next() st=(st*48271)%2147483647 return st end
	function r.int(n) if n<=1 then return 1 end return (r.next()%n)+1 end
	function r.pct(p) return r.int(100)<=p end
	function r.pick(t) if #t==0 then return nil end return t[r.int(#t)] end
	for _=1,3 do r.next() end
	return r
end

-- ---------------------------------------------------------------- 지도 만들기 (구역 3 × 10단, 씨앗에서)
local NORMAL,ELITE,BOSSK,SUPPLY,EVENT,SHOP,TREASURE=1,2,3,4,5,6,7
-- 10-30 사용자: 지도 칸은 일반 · 정예 · 보스 · 상점 · 쉼터 · ? 만. 사건은 ? (들어갈 때 정해짐, 아래 qRoll), 보물(TREASURE)은 ? 의 보물 상자로만
local KNAME={"\133\073\133\065\130\066","\129\070\129\107\130\066","\131\115\131\126","\158\220\131\104","?","\129\067\135\070","\131\115\131\065 \129\067\133\120"}
local KSHORT={"\133\073\133\065","\129\070\129\107","\131\115\131\126","\158\220\131\104","?","\129\067\135\070","\131\115\131\065"}
local function isBattle(k) return k==NORMAL or k==ELITE or k==BOSSK end
local KW={{NORMAL,36},{ELITE,15},{EVENT,34},{SHOP,9},{SUPPLY,6}}
local KCAP={[SHOP]=2,[SUPPLY]=2}-- 구역마다 많아야
local function lanesOf(row) local t={} for l=1,5 do if row[l] then t[#t+1]=l end end return t end
local function parentsOf(rows,i,l) local t={} if i<=1 then return t end for pl,nd in pairs(rows[i-1]) do if nd.out[l] then t[#t+1]=nd end end return t end
local function genZoneTry(r)
	local rows={}
	for i=1,10 do rows[i]={} end
	-- 1단도 갈림길: 일반전 2~3칸 중 골라 출발 (10-30 사용자 「슬더슬2 처럼 경로를 고르고 시작」)
	do
		local lanes
		if r.pct(50) then lanes={1,2,3} else local c=r.int(3) lanes=(c==1) and {1,3} or ((c==2) and {1,2} or {2,3}) end
		for _,l in ipairs(lanes) do rows[1][l]={kind=NORMAL} end
	end
	for i=2,8 do
		local lanes
		if r.pct(50) then lanes={1,2,3} else local c=r.int(3) lanes=(c==1) and {1,3} or ((c==2) and {1,2} or {2,3}) end
		for _,l in ipairs(lanes) do rows[i][l]={} end
	end
	rows[9][2]={kind=SUPPLY}
	rows[10][2]={kind=BOSSK,out={}}
	-- 길: 이웃 칸(차이 1 이하)으로, 들어오는 길이 없는 칸은 가장 가까운 칸에서, 엇갈리는 길은 하나 지움
	for i=1,9 do
		local nxt=lanesOf(rows[i+1])
		for l,nd in pairs(rows[i]) do
			nd.out={}
			for _,m in ipairs(nxt) do if math.abs(m-l)<=1 then nd.out[m]=true end end
			if next(nd.out)==nil then
				local best for _,m in ipairs(nxt) do if not best or math.abs(m-l)<math.abs(best-l) then best=m end end
				nd.out[best]=true
			end
		end
		for _,m in ipairs(nxt) do
			local has=false for _,nd in pairs(rows[i]) do if nd.out[m] then has=true end end
			if not has then
				local best for l,_ in pairs(rows[i]) do if not best or math.abs(m-l)<math.abs(best-l) then best=l end end
				rows[i][best].out[m]=true
			end
		end
		for l=1,2 do
			local a,b=rows[i][l],rows[i][l+1]
			if a and b and a.out[l+1] and b.out[l] then
				local function outs(nd) local c=0 for _ in pairs(nd.out) do c=c+1 end return c end
				local function ins(m) local c=0 for _,nd in pairs(rows[i]) do if nd.out[m] then c=c+1 end end return c end
				if outs(b)>1 and ins(l)>1 then b.out[l]=nil elseif outs(a)>1 and ins(l+1)>1 then a.out[l+1]=nil end
			end
		end
	end
	-- 칸 종류 (2~8단)
	local tot=0 for _,w in ipairs(KW) do tot=tot+w[2] end
	local zc={}
	for i=2,8 do
		local inRow={}
		for _,l in ipairs(lanesOf(rows[i])) do
			local par=parentsOf(rows,i,l)
			local pick=nil
			for att=1,40 do
				local x=r.int(tot) local k=NORMAL
				for _,w in ipairs(KW) do x=x-w[2] if x<=0 then k=w[1] break end end
				local ok=true
				if k==ELITE and i<4 then ok=false end
				if k==SUPPLY and i==8 then ok=false end-- 9단이 보급
				if ok and att<=25 and inRow[k] then ok=false end
				if ok and KCAP[k] and (zc[k] or 0)>=KCAP[k] then ok=false end
				for _,p in ipairs(par) do
					if p.kind==k and k~=NORMAL and k~=EVENT then ok=false end
					if k==ELITE and p.kind==ELITE then ok=false end
					if p.kind==k then
						for pl,pp in pairs(rows[i-2] or {}) do for ll,nd in pairs(rows[i-1]) do if nd==p and pp.out[ll] and pp.kind==k then ok=false end end end
					end
				end
				if ok then pick=k break end
			end
			rows[i][l].kind=pick or NORMAL
			inRow[rows[i][l].kind]=true
			zc[rows[i][l].kind]=(zc[rows[i][l].kind] or 0)+1
		end
	end
	-- 상점이 하나씩은 있게
	for _,need in ipairs({SHOP}) do
		local has=false
		for i=2,8 do for _,nd in pairs(rows[i]) do if nd.kind==need then has=true end end end
		if not has then
			local c={}
			for i=3,7 do for l,nd in pairs(rows[i]) do
				if nd.kind==NORMAL or nd.kind==EVENT then
					local bad=false for _,p in ipairs(parentsOf(rows,i,l)) do if p.kind==need then bad=true end end
					if not bad then c[#c+1]=nd end
				end
			end end
			local nd=r.pick(c) if nd then nd.kind=need end
		end
	end
	-- 어느 길로 가도 전투 4~7번
	local lo,hi={},{}
	for l,nd in pairs(rows[10]) do lo[l]=1 hi[l]=1 end
	for i=9,1,-1 do
		local nlo,nhi={},{}
		for l,nd in pairs(rows[i]) do
			local a,b=99,-1
			for m,_ in pairs(nd.out) do a=math.min(a,lo[m]) b=math.max(b,hi[m]) end
			local add=isBattle(nd.kind) and 1 or 0
			nlo[l]=a+add nhi[l]=b+add
		end
		lo,hi=nlo,nhi
	end
	for l,_ in pairs(rows[1]) do if lo[l]<4 or hi[l]>7 then return nil end end
	return rows
end
local function genZoneTemplate()
	-- 실패했을 때 쓰는 고정 틀 (검증됨: 가운데 줄 = 일반 · 사건 · 일반 · 군량 · 정예 · 보물 · 일반)
	local K2={{NORMAL,EVENT},{EVENT,NORMAL},{NORMAL,SHOP},{SHOP,NORMAL},{ELITE,EVENT},{EVENT,NORMAL},{NORMAL,SUPPLY}}
	local rows={}
	for i=1,10 do rows[i]={} end
	rows[1][2]={kind=NORMAL,out={[1]=true,[3]=true}}
	for i=2,8 do
		local k=K2[i-1]
		rows[i][1]={kind=k[1],out={}} rows[i][3]={kind=k[2],out={}}
		if i<8 then rows[i][1].out[1]=true rows[i][3].out[3]=true else rows[i][1].out[2]=true rows[i][3].out[2]=true end
	end
	rows[9][2]={kind=SUPPLY,out={[2]=true}}
	rows[10][2]={kind=BOSSK,out={}}
	return rows
end
local function genZoneBranch(r)
	local rows={}
	for i=1,10 do rows[i]={} end
	-- 1단도 갈림길: 일반전 2~3칸 중 골라 출발 (10-30 사용자 「슬더슬2 처럼 경로를 고르고 시작」)
	do
		local lanes
		if r.pct(50) then lanes={1,2,3} else local c=r.int(3) lanes=(c==1) and {1,3} or ((c==2) and {1,2} or {2,3}) end
		for _,l in ipairs(lanes) do rows[1][l]={kind=NORMAL} end
	end
	for i=2,8 do
		local lanes
		if r.pct(50) then lanes={1,2,3} else local c=r.int(3) lanes=(c==1) and {1,3} or ((c==2) and {1,2} or {2,3}) end
		for _,l in ipairs(lanes) do rows[i][l]={} end
	end
	-- Parallel camps remain separate until the single boss gate.
	do
		local lanes=r.pct(50) and {1,2,3} or {1,3}
		for _,l in ipairs(lanes) do rows[9][l]={kind=SUPPLY} end
	end
	rows[10][2]={kind=BOSSK,out={}}
	-- A random monotone walk through sorted source/destination lanes:
	-- every node gets an incoming/outgoing edge, branches and merges vary,
	-- and edges cannot cross. The last row naturally converges at the boss.
	for i=1,9 do
		local from,to=lanesOf(rows[i]),lanesOf(rows[i+1])
		for _,l in ipairs(from) do rows[i][l].out={} end
		local a,b=1,1
		while true do
			rows[i][from[a]].out[to[b]]=true
			if a==#from and b==#to then break end
			if a==#from then b=b+1
			elseif b==#to then a=a+1
			else
				local step=r.int(100)
				if step<=40 then a=a+1 b=b+1
				elseif step<=70 then a=a+1
				else b=b+1 end
			end
		end
	end
	-- 칸 종류 (2~8단)
	local tot=0 for _,w in ipairs(KW) do tot=tot+w[2] end
	local zc={}
	for i=2,8 do
		local inRow={}
		for _,l in ipairs(lanesOf(rows[i])) do
			local par=parentsOf(rows,i,l)
			local pick=nil
			for att=1,40 do
				local x=r.int(tot) local k=NORMAL
				for _,w in ipairs(KW) do x=x-w[2] if x<=0 then k=w[1] break end end
				local ok=true
				if k==ELITE and i<4 then ok=false end
				if k==SUPPLY and i==8 then ok=false end-- 9단이 보급
				if ok and att<=25 and inRow[k] then ok=false end
				if ok and KCAP[k] and (zc[k] or 0)>=KCAP[k] then ok=false end
				for _,p in ipairs(par) do
					if p.kind==k and k~=NORMAL and k~=EVENT then ok=false end
					if k==ELITE and p.kind==ELITE then ok=false end
					if p.kind==k then
						for pl,pp in pairs(rows[i-2] or {}) do for ll,nd in pairs(rows[i-1]) do if nd==p and pp.out[ll] and pp.kind==k then ok=false end end end
					end
				end
				if ok then pick=k break end
			end
			rows[i][l].kind=pick or NORMAL
			inRow[rows[i][l].kind]=true
			zc[rows[i][l].kind]=(zc[rows[i][l].kind] or 0)+1
		end
	end
	-- 상점이 하나씩은 있게
	for _,need in ipairs({SHOP}) do
		local has=false
		for i=2,8 do for _,nd in pairs(rows[i]) do if nd.kind==need then has=true end end end
		if not has then
			local c={}
			for i=3,7 do for l,nd in pairs(rows[i]) do
				if nd.kind==NORMAL or nd.kind==EVENT then
					local bad=false for _,p in ipairs(parentsOf(rows,i,l)) do if p.kind==need then bad=true end end
					if not bad then c[#c+1]=nd end
				end
			end end
			local nd=r.pick(c) if nd then nd.kind=need end
		end
	end
	-- 어느 길로 가도 전투 4~7번
	local lo,hi={},{}
	for l,nd in pairs(rows[10]) do lo[l]=1 hi[l]=1 end
	for i=9,1,-1 do
		local nlo,nhi={},{}
		for l,nd in pairs(rows[i]) do
			local a,b=99,-1
			for m,_ in pairs(nd.out) do a=math.min(a,lo[m]) b=math.max(b,hi[m]) end
			local add=isBattle(nd.kind) and 1 or 0
			nlo[l]=a+add nhi[l]=b+add
		end
		lo,hi=nlo,nhi
	end
	for l,_ in pairs(rows[1]) do if lo[l]<4 or hi[l]>7 then return nil end end
	return rows
end
local function genZoneBranchTemplate()
	-- 실패했을 때 쓰는 고정 틀 (검증됨: 가운데 줄 = 일반 · 사건 · 일반 · 군량 · 정예 · 보물 · 일반)
	local K2={{NORMAL,EVENT},{EVENT,NORMAL},{NORMAL,SHOP},{SHOP,NORMAL},{ELITE,EVENT},{EVENT,NORMAL},{NORMAL,SUPPLY}}
	local rows={}
	for i=1,10 do rows[i]={} end
	rows[1][2]={kind=NORMAL,out={[1]=true,[3]=true}}
	for i=2,8 do
		local k=K2[i-1]
		rows[i][1]={kind=k[1],out={}} rows[i][3]={kind=k[2],out={}}
		if i<8 then rows[i][1].out[1]=true rows[i][3].out[3]=true else rows[i][1].out[1]=true rows[i][3].out[3]=true end
	end
	rows[9][1]={kind=SUPPLY,out={[2]=true}}
	rows[9][3]={kind=SUPPLY,out={[2]=true}}
	rows[10][2]={kind=BOSSK,out={}}
	return rows
end
local function genZoneFive(r)
	local rows={}
	for i=1,10 do rows[i]={} end
	local function randomLanes()
		local lanes={1,2,3,4,5}
		local n=r.int(4)+1 -- 2..5 parallel lanes
		while #lanes>n do table.remove(lanes,r.int(#lanes)) end
		return lanes
	end
	for i=1,9 do
		for _,l in ipairs(randomLanes()) do
			rows[i][l]={kind=(i==1) and NORMAL or ((i==9) and SUPPLY or nil)}
		end
	end
	rows[10][3]={kind=BOSSK,out={}}
	-- A random monotone walk through sorted source/destination lanes:
	-- every node gets an incoming/outgoing edge, branches and merges vary,
	-- and edges cannot cross. The last row naturally converges at the boss.
	for i=1,9 do
		local from,to=lanesOf(rows[i]),lanesOf(rows[i+1])
		for _,l in ipairs(from) do rows[i][l].out={} end
		local a,b=1,1
		while true do
			rows[i][from[a]].out[to[b]]=true
			if a==#from and b==#to then break end
			if a==#from then b=b+1
			elseif b==#to then a=a+1
			else
				local step=r.int(100)
				if step<=40 then a=a+1 b=b+1
				elseif step<=70 then a=a+1
				else b=b+1 end
			end
		end
	end
	-- 칸 종류 (2~8단)
	local tot=0 for _,w in ipairs(KW) do tot=tot+w[2] end
	local zc={}
	for i=2,8 do
		local inRow={}
		for _,l in ipairs(lanesOf(rows[i])) do
			local par=parentsOf(rows,i,l)
			local pick=nil
			for att=1,40 do
				local x=r.int(tot) local k=NORMAL
				for _,w in ipairs(KW) do x=x-w[2] if x<=0 then k=w[1] break end end
				local ok=true
				if k==ELITE and i<4 then ok=false end
				if k==SUPPLY and i==8 then ok=false end-- 9단이 보급
				if ok and att<=25 and inRow[k] then ok=false end
				if ok and KCAP[k] and (zc[k] or 0)>=KCAP[k] then ok=false end
				for _,p in ipairs(par) do
					if p.kind==k and k~=NORMAL and k~=EVENT then ok=false end
					if k==ELITE and p.kind==ELITE then ok=false end
					if p.kind==k then
						for pl,pp in pairs(rows[i-2] or {}) do for ll,nd in pairs(rows[i-1]) do if nd==p and pp.out[ll] and pp.kind==k then ok=false end end end
					end
				end
				if ok then pick=k break end
			end
			rows[i][l].kind=pick or NORMAL
			inRow[rows[i][l].kind]=true
			zc[rows[i][l].kind]=(zc[rows[i][l].kind] or 0)+1
		end
	end
	-- 상점이 하나씩은 있게
	for _,need in ipairs({SHOP}) do
		local has=false
		for i=2,8 do for _,nd in pairs(rows[i]) do if nd.kind==need then has=true end end end
		if not has then
			local c={}
			for i=3,7 do for l,nd in pairs(rows[i]) do
				if nd.kind==NORMAL or nd.kind==EVENT then
					local bad=false for _,p in ipairs(parentsOf(rows,i,l)) do if p.kind==need then bad=true end end
					if not bad then c[#c+1]=nd end
				end
			end end
			local nd=r.pick(c) if nd then nd.kind=need end
		end
	end
	-- 어느 길로 가도 전투 4~7번
	local lo,hi={},{}
	for l,nd in pairs(rows[10]) do lo[l]=1 hi[l]=1 end
	for i=9,1,-1 do
		local nlo,nhi={},{}
		for l,nd in pairs(rows[i]) do
			local a,b=99,-1
			for m,_ in pairs(nd.out) do a=math.min(a,lo[m]) b=math.max(b,hi[m]) end
			local add=isBattle(nd.kind) and 1 or 0
			nlo[l]=a+add nhi[l]=b+add
		end
		lo,hi=nlo,nhi
	end
	for l,_ in pairs(rows[1]) do if lo[l]<4 or hi[l]>7 then return nil end end
	return rows
end
local function genZoneFiveTemplate(r)
	local kinds={NORMAL,EVENT,NORMAL,SHOP,ELITE,EVENT,NORMAL,EVENT,SUPPLY,BOSSK}
	local rows={}
	for i=1,9 do
		rows[i]={}
		local lanes={1,2,3,4,5} local n=r.int(4)+1
		while #lanes>n do table.remove(lanes,r.int(#lanes)) end
		for _,l in ipairs(lanes) do rows[i][l]={kind=kinds[i],out={}} end
	end
	rows[10]={[3]={kind=BOSSK,out={}}}
	for i=1,9 do
		local a,b=lanesOf(rows[i]),lanesOf(rows[i+1]) local x,y=1,1
		while true do
			rows[i][a[x]].out[b[y]]=true
			if x==#a and y==#b then break end
			if x==#a then y=y+1 elseif y==#b then x=x+1
			elseif r.pct(50) then x=x+1 y=y+1 elseif r.pct(50) then x=x+1 else y=y+1 end
		end
	end
	return rows
end
local GENC=nil
local function GEN()
	local key=seed()*3+sget(S.ROUTE)
	if GENC and GENC.key==key then return GENC end
	local r=mkRng(1)
	local g={key=key,zones={}}
	local use={}
	for z=1,3 do
		local rows=nil
		local mode=sget(S.ROUTE)
		local generate=(mode>=2) and genZoneFive or ((mode==1) and genZoneBranch or genZoneTry)
		local fallback=(mode>=2) and genZoneFiveTemplate or ((mode==1) and genZoneBranchTemplate or genZoneTemplate)
		for _=1,40 do rows=generate(r) if rows then break end end
		if not rows then koConqTplN=(rawget(_G,"koConqTplN") or 0)+1 rows=fallback(r) end
		-- 전투 칸 지도: 덜 쓴 지도부터, 앞 단의 지도와 다르게
		for i=1,10 do
			for l,nd in pairs(rows[i]) do
				if isBattle(nd.kind) then
					local list=MAPBYKIND[(nd.kind==NORMAL) and 1 or ((nd.kind==ELITE) and 2 or 3)]
					local par={} for _,p in ipairs(parentsOf(rows,i,l)) do if p.map then par[p.map]=true end end
					local best,bn={},999
					for _,mi in ipairs(list) do
						local n=(use[mi] or 0)*2+(par[mi] and 1 or 0)
						if n<bn then best={mi} bn=n elseif n==bn then best[#best+1]=mi end
					end
					nd.map=r.pick(best)
					use[nd.map]=(use[nd.map] or 0)+1
				end
			end
		end
		g.zones[z]=rows
	end
	GENC=g
	return g
end
local function nodeAt(s,l) local rows=GEN().zones[zoneOf(s)] return rows[rowOf(s)][l or laneAt(s)] end
function koConqGenT(sa,sb)-- for test scripts: the map of a seed, as text rows
	sset(S.SA,sa) sset(S.SB,sb) GENC=nil
	local out={}
	for z=1,3 do
		local rows=GEN().zones[z]
		for i=1,10 do
			local s=""
			for l=1,5 do local nd=rows[i][l] if nd then local o="" for m=1,5 do if nd.out[m] then o=o..m end end s=s..l..":"..KSHORT[nd.kind]..(nd.map and ("#"..MAPS[nd.map][1]) or "").."->"..o.."  " end end
			out[#out+1]="z"..z.." r"..i.." "..s
		end
	end
	return out
end

-- ---------------------------------------------------------------- 부대
local function rosterIds()
	local t={}
	for i=1,JY.PersonNum-1 do if JY.Person[i][LORD]==1 then t[#t+1]=i end end
	return t
end
local function pctOf(id) local p=JY.Person[id] if (p[HP] or 0)<=0 or p[HPMAX]<=0 then return 0 end return math.max(1,math.floor(p[HP]*100/p[HPMAX])) end
local function healHP(id,pct) local p=JY.Person[id] p[HP]=math.min(p[HPMAX],math.max(p[HP],0)+math.floor(p[HPMAX]*pct/100)) if p[HP]<1 then p[HP]=1 end end
local function healSP(id,pct) local p=JY.Person[id] p[SP]=math.min(p[SPMAX],p[SP]+math.floor(p[SPMAX]*pct/100)) end
local function healAll(hp,sp) for _,id in ipairs(rosterIds()) do healHP(id,hp) if sp then healSP(id,sp) end end end
-- 레벨을 바꿔도 병력 · 책략 비율은 그대로 (설계 7.2: 내림, 살아 있으면 1 이상)
local function setLvKeep(id,lv)
	local p=JY.Person[id]
	local hr=(p[HPMAX]>0) and p[HP]/p[HPMAX] or 1
	local sr=(p[SPMAX]>0) and p[SP]/p[SPMAX] or 1
	koFreeSetLevel(id,lv,nil)
	p[HP]=math.floor(p[HPMAX]*hr) if hr>0 and p[HP]<1 then p[HP]=1 end
	p[SP]=math.floor(p[SPMAX]*sr)
end
local function putItem(it)
	for _,pid in ipairs(rosterIds()) do
		for s=1,8 do if (JY.Person[pid][ITEM..s] or 0)==0 then JY.Person[pid][ITEM..s]=it pcall(ReSetAttrib,pid,false) return JY.Person[pid][NAME] end end
	end
	return nil
end
local function gotItem(it,head)
	local who=putItem(it)
	WarDrawStrBoxWaitKey((head or "")..JY.Item[it][INAME].." \129\083(\130\104) \133\086\132\107\129\077"..(who and ("*"..who.."\131\080 \129\094\132\078") or "*\129\094\132\078\129\071 \130\090\130\091 \132\077\129\077"),M_White)
end
-- 보물 등급: 공격 + 책략 공격 + 방어 + 능력 합 (★ 판 제외). 1 = 일반 상급 · D/C 급, 2 = B/A 급 · 원작 병서, 3 = S 급 · 원작 명품
local TIERS=nil
local function tiers()
	if TIERS then return TIERS end
	TIERS={{},{},{}}
	local function add(id)
		local it=JY.Item[id]
		if not it or (it[INAME] or "")=="" then return end
		if string.find(it[INAME],"\161\239",1,true) then return end
		local s=(it[ATK] or 0)+(it[SATK] or 0)+(it[DEF] or 0)+(it[WU] or 0)+(it[ZHI] or 0)+(it[TONG] or 0)
		if s<=0 then return end
		local t=(s>=20) and 3 or ((s>=12) and 2 or 1)
		TIERS[t][#TIERS[t]+1]=id
	end
	for id=74,154 do add(id) end
	for id=223,math.min(JY.ItemNum,1000)-1 do local it=JY.Item[id] if it and type(it[OWNER])=="string" and it[OWNER]~="" then add(id) end end-- 11-15: 1000+ = engrave copies
	for _,id in ipairs({4,5,59,60,61,62,63}) do add(id) end
	return TIERS
end
local function rollTier(t,r)
	local T=tiers()
	while #T[t]==0 and t>1 do t=t-1 end
	if #T[t]==0 then return nil end
	return T[t][r.int(#T[t])]
end
local function rollItem(z,r,boost)
	local w=(z<=1) and {70,30,0} or ((z==2) and {25,60,15} or {10,50,40})
	if boost or flag(4) then w={0,30,70} end
	local x=r.int(100)
	return rollTier((x<=w[1]) and 1 or ((x<=w[1]+w[2]) and 2 or 3),r)
end
-- 판 한정 각성 (3단계에서 그대로): 무장은 자기 전용 보물(원본, gear_data 의 주인 줄)을 들고 옴 — 시작 부대 · 합류 무장. 가방에 넣고 그 칸에 장비.
-- 들고 싸우면 gear 애드온이 판 안에서 각성 진행을 셈(조건 수 절반) → ★. 임시 기록이라 판이 끝나면 함께 사라짐
local SLOTF=K(215,176,177,184,206,187)-- 装备位
local EQK={K(206,228,198,247),K(183,192,190,223),K(184,168,214,250)}-- 武器 防具 辅助
local function ownTreasure(pid)
	local nm=JY.Person[pid][NAME]
	for _,e in ipairs(rawget(_G,"koGearData") or {}) do if e[1]==nm and (e[9] or 0)==0 then return e[2] end end
	return nil
end
local function bringOwn(pid)
	local it=ownTreasure(pid)
	if not it or not JY.Item[it] then return nil end
	local p=JY.Person[pid]
	for i=1,JY.PersonNum-1 do if i~=pid and JY.Person[i][LORD]==1 then for s=1,8 do if JY.Person[i][ITEM..s]==it then return nil end end end end
	local slot=nil
	for s=1,8 do if p[ITEM..s]==it then slot=s end end
	if not slot then for s=1,8 do if (p[ITEM..s] or 0)==0 then slot=s break end end end
	if not slot then return nil end
	p[ITEM..slot]=it
	local q=EQK[JY.Item[it][SLOTF] or 0]
	if q then p[q]=it end
	pcall(ReSetAttrib,pid,false)
	return JY.Item[it][INAME]
end

-- ---------------------------------------------------------------- 판 밖 해금 (누적 공적, 쓰지 않고 쌓임). 1번은 옛 「시작 인원 7명」 을 새 편성 규칙에 맞게 바꾼 것
local UNLOCK={{100,"\130\086\129\074 \130\108\129\085 \133\067\131\115 6\130\088"},{250,"\131\115\129\067 \129\077\130\086 \144\102\131\071 (\130\070\133\088\129\077 \129\111 \130\087)"},{500,"\134\068 \130\114\129\119 4\129\084"},{800,"\130\086\129\074 \131\115\131\065 \129\097\131\118 \131\100\130\106\131\071"},
	{1200,"\130\083\131\096\136\108 1\134\077\132\084"},{1600,"\133\126\131\098 \129\073\131\097 \131\115\131\126 (\130\119\134\074 3)"},{2000,"\130\083\131\096\136\108 2 \161\164 3\134\077\132\084"}}
local function unlocked(i,m) return (m or CC.koConqMerit or 0)>=UNLOCK[i][1] end
local function maxDiff() return unlocked(7) and 3 or (unlocked(5) and 1 or 0) end

-- ---------------------------------------------------------------- 군령 12종 (설계 10.2)
-- v = {기본, 강화} 퍼센트. fam = 1 기병 2 방어 3 책략 4 공용
local ORDERS={
	{"C01","\131\071\130\126 \137\066\130\112",1,{15,22},"\131\071\130\126\129\071 3\135\066 \129\071\129\067 \136\108\132\076\129\098 \132\076\137\110 \130\074\130\112\129\097\129\065 \137\088\129\066 +%d%%"},
	{"C02","\133\099\130\112 \130\088\130\089",1,{15,22},"\131\071\130\126\129\071 \132\076\137\110 \130\074\130\112\131\109\132\083 \131\076\129\083 \136\096\133\101\132\093\129\117\129\065 \129\071\130\087 \129\112 \133\072\130\098 \137\088\129\066 -%d%%"},
	{"C03","\130\066\130\065 \132\087\130\100",1,{8,12},"\136\108\132\076\129\106 \135\068 \132\076\137\110 \130\074\130\112\129\111 \131\076\131\098 \129\071\130\087 \129\112 \131\079\129\117 \130\074\130\112\129\102 \137\088\129\066 +%d%%"},
	{"D01","\136\075\133\087 \129\103\136\069",2,{12,18},"\129\071\130\087 \129\112 \136\108\132\076\129\071\130\067 \130\107\131\098 \129\073\131\097\131\098 \133\072\130\098 \132\076\137\110 \137\088\129\066 -%d%%"},
	{"D02","\132\078\129\079 \133\066\130\095",2,{6,9},"\129\067\129\097\133\112\131\079\129\102 \129\110\130\084\129\071 \132\079\131\109\129\065 \133\072\130\098 \137\088\129\066 -%d%%"},
	{"D03","\133\065\130\112 \131\101\130\080",2,{20,30},"\129\071\130\087 \129\112 \130\074\130\112\129\097\130\067 \130\107\131\098 \129\073\131\097\131\080 \129\077\130\077 \133\065\130\112 \137\088\129\066 +%d%% (\129\111 \130\087)"},
	{"S01","\129\064\130\074 \133\066\132\084",3,{15,22},"\129\064\132\084 \130\117\130\118\129\083 \138\071\131\098 \131\076\129\102\129\081 \129\077\130\077 \132\076\137\110 \130\074\130\112 \137\088\129\066 +%d%% (\129\111 \130\087)"},
	{"S02","\130\084\130\114 \131\115\133\112",3,{20,30},"\129\112\133\088\129\077 \139\110\130\077 \136\096\130\098 \130\117\130\118\131\080 \130\117\130\118 \129\109\130\080 -%d%%"},
	{"S03","\135\109\129\078 \133\121\134\086",3,{8,12},"\130\099\130\100 \161\164 \135\067\129\064\136\089 \131\076\129\102\129\081 \132\076\137\110 \130\074\130\112 \137\088\129\066 +%d%%"},
	{"U01","\130\066\131\097 \130\119\134\113",4,{5,8},"\132\076\137\110 \130\074\130\112\131\109\132\083 \131\076\129\083 \136\096\133\101\132\093\129\117\129\065 \130\126\131\125\129\071 \129\094\131\097 \131\076\131\098 \129\110\130\084 +%d%% (\130\066\132\101\135\105 2\130\087)"},
	{"U02","\130\066\129\117\131\066 \136\114\129\095",4,{20,30},"\130\066\132\101 \130\084\133\120\131\103 +%d%%, \130\095\131\078 \158\220\131\104 \161\164 \129\067\135\070 \130\126\131\125 \130\125\130\068 -10%%p"},
	{"U03","\134\064\130\114 \135\103\130\066",4,{18,26},"\130\126\131\125 35%% \129\071\129\097\129\106 \129\073\131\097\131\080 \132\076\137\110 \130\074\130\112 \137\088\129\066 +%d%%"},
}
local OFAM={"\131\071\130\126","\132\078\130\083","\130\117\130\118","\130\074\132\111"}
local OMAX=8
local OIDX={} for i,o in ipairs(ORDERS) do OIDX[o[1]]=i end
local function ordLv(i) if type(i)=="string" then i=OIDX[i] end return (bits2(S.ORD,i)) end
local function ordV(i) if type(i)=="string" then i=OIDX[i] end local lv=ordLv(i) if lv==0 then return 0 end return ORDERS[i][4][lv] end
local function setOrd(i,v) setBits2(S.ORD,i,v) end
local function ordCount() local n=0 for i=1,#ORDERS do if ordLv(i)>0 then n=n+1 end end return n end
local function ordDesc(i,lv) local o=ORDERS[i] return string.format(o[5],o[4][math.max(1,lv or 1)]) end
local function ordList() local t={} for i=1,#ORDERS do local lv=ordLv(i) if lv>0 then t[#t+1]=ORDERS[i][2]..((lv==2) and "+" or "") end end return t end
local function newOrders(fam) local t={} for i,o in ipairs(ORDERS) do if ordLv(i)==0 and (not fam or o[3]==fam) then t[#t+1]=i end end return t end
local function upOrders(fam) local t={} for i,o in ipairs(ORDERS) do if ordLv(i)==1 and (not fam or o[3]==fam) then t[#t+1]=i end end return t end

-- ---------------------------------------------------------------- 정벌 화면 (원작 메뉴 틀 + 군령장식 남색 / 금색 / 주홍색)
local function conqText(cx,y,s,col,size)
	size=size or 16
	DrawString(math.floor(cx-#s*size/4),y,s,col or M_White,size)
end
local function conqPanel(x,y,w,h) koRecordClassicFrame(x,y,w,h) end
local function conqHead(ox,oy,title,sub)
	koFreeClassicBack()
	lib.FillColor(ox+16,oy+14,ox+752,oy+52,RGB(29,35,58))
	lib.FillColor(ox+24,oy+22,ox+28,oy+43,RGB(153,55,43))
	conqText(ox+384,oy+20,title,C_Name,24)
	lib.FillColor(ox+24,oy+53,ox+744,oy+54,RGB(161,133,77))
	if sub then conqText(ox+384,oy+62,sub,M_Silver) end
end
local function conqFoot(ox,oy,s)
	lib.FillColor(ox+24,oy+422,ox+744,oy+423,RGB(105,94,67))
	conqText(ox+384,oy+401,s,M_Silver)
end
-- hz 문자열은 한글 두 바이트. 칸 너비에 맞춰 줄바꿈
local function conqWrap(s,cols)
	local rows,line={},""
	local i=1
	while i<=#s do
		local n=(string.byte(s,i)>=128) and 2 or 1
		if #line+n>cols and #line>0 then rows[#rows+1]=line line="" end
		line=line..string.sub(s,i,i+n-1) i=i+n
	end
	if #line>0 then rows[#rows+1]=line end
	return rows
end
local function statusLine()
	local s=curPos()
	return "\130\119\134\074 "..zoneOf(s).." \161\164 "..rowOf(s).." / 10\134\077   \130\094\130\095 "..#rosterIds().." / "..MAXARMY.."\130\088   \130\084\130\089 "..ordCount().." / "..OMAX.."   \130\084\133\120\131\103 "..gold()
end
-- cards = {{t=제목, l={줄...}, dis=true 면 못 고름}, ...}, extras = 아래 단추 글들 (누르면 -번호), noEsc = 오른쪽 누름으로 0 을 돌려주지 않음
-- 보물 그림 (10-30 사용자 「선택지에 장비가 나오면 그 보물 그림」): 보물 도감 그림(data/bogam.grp, 128px, 보물마다 원본 · ★ · 실루엣 세 칸,
-- 표 = bogam_data.lua koBogamList)을 그림 칸 3 에 50%(64px), 도감에 없는 일반 장비(data/equip.grp, 도구 74~154)는 그림 칸 15 에 50%(64px).
-- 칸 3 · 15 는 다른 화면이 쓰지 않음 (13 은 마을, 7 은 정벌 지도). 기록을 불러오면 그림 칸이 비므로 record_load 에서 다시 읽게 함
local ICON=nil
local iconsLoaded=false
local function iconOf(iid)
	if not iid or iid<=0 then return nil end
	if not ICON then
		ICON={}
		if not rawget(_G,"koBogamList") then pcall(dofile,CONFIG.ScriptPath.."addon/bogam_data.lua") end
		for k,e in ipairs(rawget(_G,"koBogamList") or {}) do
			ICON[e[1]]={3,(k-1)*3}
			if e[2]>0 then ICON[e[2]]={3,(k-1)*3+1} end
		end
	end
	if ICON[iid] then return ICON[iid] end
	if iid>=74 and iid<=154 and fileexist(CONFIG.DataPath.."equip.grp") then return {15,iid} end
	return nil
end
local function loadIcons()
	if iconsLoaded then return end
	if fileexist(CONFIG.DataPath.."bogam.grp") then lib.PicLoadFile(CONFIG.DataPath.."bogam.idx",CONFIG.DataPath.."bogam.grp",3,50) end
	if fileexist(CONFIG.DataPath.."equip.grp") then lib.PicLoadFile(CONFIG.DataPath.."equip.idx",CONFIG.DataPath.."equip.grp",15,50) end
	iconsLoaded=true
end
koOn("record_load",function() iconsLoaded=false end)
-- 64px 그림 + 틀 (정보창 장비 칸과 같은 남색 바탕 · 금색 테두리)
local function drawIcon(iid,cx,y)
	local ic=iconOf(iid)
	local x=math.floor(cx-34)
	lib.FillColor(x,y,x+68,y+68,RGB(6,12,30))
	DrawBox(x,y,x+68,y+68,RGB(179,145,70),-1)
	DrawBox(x+2,y+2,x+66,y+66,RGB(34,89,165),-1)
	if ic then
		lib.SetClip(x+2,y+2,x+66,y+66)
		lib.PicLoadCache(ic[1],ic[2]*2,x+2+(ic[3] or 0),y+2+(ic[3] or 0),1)
		lib.SetClip(0,0,0,0)
	end
end
local function cardPick(title,cards,extras,noEsc)
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	local n=#cards
	local two=(n>5)
	local per=two and math.ceil(n/2) or n
	local W=(per>=5) and 138 or ((per>=4) and 170 or 208)
	local gap=(per>=5) and 8 or ((per>=4) and 12 or 18)
	local H=two and 158 or 214
	local btns={}
	for _,c in ipairs(cards) do if c.item then loadIcons() break end end
	for k=1,n do
		local row=two and math.floor((k-1)/per) or 0
		local col=(k-1)-row*per
		local cnt=two and ((row==0) and per or (n-per)) or n
		local x0=ox+384-math.floor((cnt*W+(cnt-1)*gap)/2)
		local b={x=x0+col*(W+gap),y=oy+(two and 100 or 120)+row*(H+8),w=W,h=H,s="",plain=true}
		if not cards[k].dis then b.card=k end
		btns[#btns+1]=b
	end
	extras=extras or {}
	local ew=180
	local ex0=ox+384-math.floor((#extras*ew+(#extras-1)*16)/2)
	for k,e in ipairs(extras) do btns[#btns+1]={x=ex0+(k-1)*(ew+16),y=oy+438,w=ew,h=28,s=e,extra=k} end
	local function draw(hov)
		conqHead(ox,oy,"\129\070\137\114",title)
		conqText(ox+384,oy+(two and 80 or 92),statusLine(),C_Name)
		local ts=16-- 카드 제목은 늘 16 (10-30 사용자 「전부 16으로 통일」)
		for k,c in ipairs(cards) do
			local b=btns[k]
			local active=hov==k and not c.dis
			conqPanel(b.x,b.y,b.w,b.h)
			if active then DrawBox(b.x+3,b.y+3,b.x+b.w-3,b.y+b.h-3,M_Yellow,-1) end
			lib.FillColor(b.x+10,b.y+10,b.x+34,b.y+34,c.dis and RGB(65,66,70) or RGB(130,49,39))
			conqText(b.x+22,b.y+14,tostring(k),M_White)
			conqText(b.x+b.w/2+12,b.y+(ts==24 and 12 or 16),c.t,c.dis and M_Gray or C_Name,ts)
			lib.FillColor(b.x+14,b.y+44,b.x+b.w-14,b.y+45,RGB(128,113,78))
			-- 아래 한 줄 = 값 · 못 고르는 까닭 (c.foot / c.why), 글은 그 위까지만
			local foot=(c.dis and (c.why or "\131\100\130\104 \129\113 \130\097\130\077")) or c.foot
			local yy=b.y+54
			local pic=c.item and iconOf(c.item)-- 그림이 없는 도구는 글자만 (10-30 사용자)
			if pic then drawIcon(c.item,b.x+b.w/2,b.y+50) yy=b.y+(two and 120 or 124) end-- 보물 그림 (그 아래로 이름)
			local last=b.y+b.h-(foot and 40 or 22)
			if pic then last=math.max(last,yy) end-- 두 줄 카드(상점)도 이름 한 줄은
			for _,l in ipairs(c.l or {}) do
				for _,line in ipairs(conqWrap(l,math.floor((b.w-20)/8))) do
					if yy<=last then conqText(b.x+b.w/2,yy,line,c.dis and M_Gray or (c.col or M_White)) end
					yy=yy+18
				end
			end
			if foot then conqText(b.x+b.w/2,b.y+b.h-22,foot,c.dis and M_Gray or C_Name) end
		end
		if not two then conqFoot(ox,oy,(#extras>0) and "\143\085\133\119\130\104 \131\100\130\106\134\069\131\118 \129\110\134\071 \134\077\133\099\130\104 \134\117\130\106\135\073\130\086\129\091" or "\143\085\133\119\130\104 \129\097\131\118 \131\100\130\106\135\073\130\086\129\091") end
	end
	while true do
		local r=koFreeClassicWait(draw,btns)
		local b=btns[r]
		if b and b.card then MOUSE.koSwallowR=true MOUSE.status='IDLE' return b.card end
		if b and b.extra then MOUSE.koSwallowR=true MOUSE.status='IDLE' return -b.extra end
		if r==0 and not noEsc and #extras>0 then MOUSE.koSwallowR=true MOUSE.status='IDLE' return -1 end
	end
end
local function pickFrom(title,ids,label)
	if #ids==0 then return nil end
	local m={}
	for k,id in ipairs(ids) do m[k]={fillblank(label(id),20),nil,1} end
	WarDrawStrBoxWaitKey(title,M_White)
	koMouseReset() MOUSE.status='IDLE'
	local r=ShowMenu(m,#m,10,0,120,0,0,5,0,16,M_White,M_White)
	return ids[r]
end
local function lvLabel(id) local p=JY.Person[id] return p[NAME].." Lv"..p[LV].." \130\126\131\125"..pctOf(id).."%" end

-- ---------------------------------------------------------------- 군령 얻기 · 강화 · 버리기
local function gainOrder(i)
	if ordLv(i)>0 then
		if ordLv(i)==1 then setOrd(i,2) WarDrawStrBoxWaitKey("\130\084\130\089 \161\184"..ORDERS[i][2].."\161\185 \130\073\129\064*"..ordDesc(i,2),M_White) end
		return true
	end
	if ordCount()>=OMAX then
		local held={} for k=1,#ORDERS do if ordLv(k)>0 then held[#held+1]=k end end
		local cards={}
		for k,j in ipairs(held) do cards[k]={t=ORDERS[j][2]..((ordLv(j)==2) and "+" or ""),l={OFAM[ORDERS[j][3]],ordDesc(j,ordLv(j))}} end
		local r=cardPick("\130\084\130\089\129\071 \129\094\131\068 \132\077\129\075\129\076\129\077 \161\164 \132\113\132\117 \130\084\130\089\129\083 \131\100\130\106\135\073\130\086\129\091 (\134\068 \130\084\130\089 \161\184"..ORDERS[i][2].."\161\185)",cards,{"\134\068 \130\084\130\089 \134\097\131\071"},true)
		if r<=0 then return false end
		setOrd(held[r],0)
	end
	setOrd(i,1)
	WarDrawStrBoxWaitKey("\130\084\130\089 \161\184"..ORDERS[i][2].."\161\185 \129\083(\130\104) \133\086\132\107\129\077*"..ordDesc(i,1),M_White)
	return true
end
local function orderCard(i)
	local up=ordLv(i)==1
	return {t=(up and "\130\073\129\064 " or "")..ORDERS[i][2],l={"\130\084\130\089 \161\164 "..OFAM[ORDERS[i][3]],ordDesc(i,up and 2 or 1)}}
end
local function pickUpgrade(fam)
	local ids=upOrders(fam)
	if #ids==0 then return false end
	local cards={} for k,i in ipairs(ids) do cards[k]=orderCard(i) end
	local r=cardPick("\130\073\129\064\129\088 \130\084\130\089\129\083 \131\100\130\106\135\073\130\086\129\091",cards)
	if r>0 then gainOrder(ids[r]) return true end
	return false
end
-- 군령 3택1 (새 군령, 모자라면 강화로 채움)
local function orderOffer(r,n,fam)
	local pool=newOrders(fam)
	local up=upOrders(fam)
	local out,seen={},{}
	for _=1,40 do
		if #out>=n then break end
		local src=(#pool>0 and (r.pct(75) or #up==0)) and pool or up
		local i=r.pick(src)
		if i and not seen[i] then seen[i]=true out[#out+1]=i end
		if #pool==0 and #up==0 then break end
	end
	return out
end

-- ---------------------------------------------------------------- 합류 · 내보내기
local function joinAt(id,lv)
	if #rosterIds()>=MAXARMY then
		local ids=rosterIds()
		local cards={}
		for k,j in ipairs(ids) do cards[k]={t=JY.Person[j][NAME],l={"Lv "..JY.Person[j][LV],"\130\126\131\125 "..pctOf(j).."%"}} end
		local r=cardPick("\130\094\130\095\129\094 \129\094\131\068 \132\077\129\075\129\076\129\077 \161\164 "..JY.Person[id][NAME].." \130\095\131\078 \131\095\131\115\137\077 \129\073\131\097\129\083 \131\100\130\106\135\073\130\086\129\091",cards,{"\129\087\129\093 \134\069\133\089"},true)
		if r<=0 then return false end
		local out=ids[r]
		local p=JY.Person[out]
		p[LORD]=0
		local bag={} for s=1,8 do local it=p[ITEM..s] or 0 if it>0 and it~=ownTreasure(out) then bag[#bag+1]=it end p[ITEM..s]=0 end
		JY.Person[id][LORD]=1
		for _,it in ipairs(bag) do putItem(it) end
		WarDrawStrBoxWaitKey(p[NAME].." \129\071(\129\094) \130\094\130\095\130\104 \139\088\138\103\129\077"..((#bag>0) and "*\129\109\130\067\131\066\131\098 \130\094\130\095\129\094 \131\118\144\066 \129\094\131\070\129\077" or ""),M_White)
	end
	JY.Person[id][LORD]=1
	koFreeSetLevel(id,lv,JY.Person[id][BZ])
	JY.Person[id][HP]=JY.Person[id][HPMAX] JY.Person[id][SP]=JY.Person[id][SPMAX]
	local own=bringOwn(id)
	WarDrawStrBoxWaitKey(JY.Person[id][NAME].." \129\071(\129\094) \130\094\130\095\129\102 \129\087\129\093\129\080\129\077"..(own and ("*\130\066\132\111 \131\115\131\065 "..own.." \129\083(\130\104) \131\082\131\100 \138\088\129\077") or ""),M_White)
	return true
end
local function trainOne(n)
	local id=pickFrom("\130\082\130\123\129\083 \131\105\132\117 \129\073\131\097\129\083 \131\100\130\106\135\073\130\086\129\091 (+"..n..")",rosterIds(),lvLabel)
	if id then setLvKeep(id,JY.Person[id][LV]+n) WarDrawStrBoxWaitKey(JY.Person[id][NAME].." \130\082\130\123 "..JY.Person[id][LV],M_White) end
	return id~=nil
end
local function focusHeal()
	local id=pickFrom("\132\081\129\085\129\088 \129\073\131\097\129\083 \131\100\130\106\135\073\130\086\129\091 (\130\126\131\125 \161\164 \130\117\130\118 100%)",rosterIds(),lvLabel)
	if id then local p=JY.Person[id] p[HP]=p[HPMAX] p[SP]=p[SPMAX] WarDrawStrBoxWaitKey(p[NAME].." \129\071(\129\094) \131\071\135\083\129\083 \132\067\139\113\131\116\129\077",M_White) end
	return id~=nil
end
local function supplyCut() return (ordLv("U02")>0) and 10 or 0 end

-- ---------------------------------------------------------------- 적 레벨 · 적 고르기
local function enemyLv(s,kind)
	local l=baseLv()+5*(zoneOf(s)-1)+math.floor((rowOf(s)-1)*2/9)+diff()
	if kind==ELITE then l=l+2 end
	return math.max(1,math.min(99,l))
end
local HIDDEN={"\135\103\131\079","\130\071\132\078","\133\088\135\101","\131\099\129\106","\137\083\129\106","\133\112\133\120","\131\079\138\115"}
local HIDSET=nil
local function isHidden(id)
	if not HIDSET then HIDSET={} for _,nm in ipairs(HIDDEN) do HIDSET[nm]=true end end
	return HIDSET[JY.Person[id][NAME]]==true
end
-- 적으로 나올 수 있는 무장: 자유 전투 후보에서 우리 편 · 숨은 무장(해금 6 의 구역 3 보스로만) 뺌
local function enemyPool(all)
	local t={}
	for _,id in ipairs(koFreePool(not all)) do if not isHidden(id) then t[#t+1]=id end end
	return t
end
local function statSum(id) local p=JY.Person[id] return (p[WU] or 0)+(p[ZHI] or 0)+(p[TONG] or 0) end
-- 구역 보스 (지도에 미리 보임): 씨앗으로 정해짐. 구역 1 = 이름난 무장 위 40명 중, 2 = 위 20명, 3 = 위 10명 (해금 6: 숨은 무장 절반)
local function bossOf(z)
	local mine={} for _,id in ipairs(rosterIds()) do mine[id]=true end
	local r=mkRng(8,z)
	if z==3 and unlocked(6) and r.pct(50) then
		local c={}
		for _,nm in ipairs(HIDDEN) do for i=1,JY.PersonNum-1 do if JY.Person[i][NAME]==nm then if not mine[i] then c[#c+1]=i end break end end end
		if #c>0 then return r.pick(c) end
	end
	local pool=enemyPool(true)
	table.sort(pool,function(a,b) local x,y=statSum(a),statSum(b) if x~=y then return x>y end return a<b end)
	-- 부대가 바뀌어도 같은 보스가 보이게: 순위표에서 씨앗으로 고른 자리부터, 우리 편이면 다음 사람
	local top=math.min(#pool,(z==1) and 40 or ((z==2) and 20 or 10))
	local k=r.int(top)
	for _=1,#pool do local id=pool[k] if id and not mine[id] then return id end k=k%#pool+1 end
	return pool[1]
end
-- 보스 기믹 (설계 9절, 10-30 사용자 「보스 기믹 먼저」): 1·2구역 = 돌격 · 수비 · 책략 중 씨앗으로 서로 다르게, 3구역 = 혼합형
--   돌격형: 3턴마다(3·6·9...) 우리 차례 시작에 알림 → 그 턴 적 차례에 대장이 나서고(AI 능동) 대장과 주변 2칸 적의 피해 +20%
--   수비형: 대장 주변 3칸에 다른 적이 살아 있으면 대장이 받는 피해 -30% (호위를 떼어 내면 약해짐)
--   책략형: 3턴마다 우리 편이 가장 많이 모인 3×3 에 붉은 표시 → 다음 턴 시작에 그 안의 우리 편 병력 -20% (퇴각하지는 않음)
--   혼합형: 대장 병력 절반까지 수비형, 그 아래로 떨어지면 알리고 돌격형
-- 모두 미리 알리며, 무작위 즉사 · 예고 없는 증원 없음. 상태는 S.MARK · S.MTURN · S.RAGE (전투 중 저장에 함께)
local GIM={CHARGE=1,GUARD=2,STRAT=3,MIX=4}
local GNAME={"\137\066\130\112\136\069","\129\113\130\080\136\069","\130\117\130\118\136\069","\130\099\129\087\136\069"}
local GDESC={"3\129\112\133\088\129\077 \130\095\131\097\129\123 \130\075\130\116 \131\076\129\071 \137\066\130\112 (\131\091 \129\112 \137\088\129\066 +20%)","\130\095\131\097 \130\075\130\116 3\135\066\129\102 \134\113\130\110\129\094 \132\079\131\109\129\065 \130\095\131\097\129\071 \133\072\130\098 \137\088\129\066 -30%",
	"3\129\112\133\088\129\077 \131\079\129\117 \132\075\129\071 \130\090\129\106 3\161\1933 \129\102 \132\084\130\118, \129\077\130\077 \129\112 \130\086\129\074\129\102 \130\126\131\125 -20%","\130\126\131\125 \133\089\133\065\129\089\130\067 \129\113\130\080\136\069, \131\091 \129\110\134\071\132\083 \137\066\130\112\136\069"}
local function gimOf(z)
	if z>=3 then return GIM.MIX end
	if rawget(_G,"koConqGimT") then return koConqGimT end-- 시험용
	local r=mkRng(11)
	local a=r.int(3) local b=r.int(2) if b>=a then b=b+1 end
	return (z==1) and a or b
end
local function faceDir(fx,fy,tx,ty)
	local dx,dy=tx-fx,ty-fy
	if math.abs(dy)>math.abs(dx) then return (dy>0) and 1 or 2 end
	return (dx>0) and 4 or 3
end
-- 한 전투의 배치: 아군 칸 4개(고르기) · 적 줄 (SelectEnemy 11칸) · 대장
local function buildBattle(s,nd)
	local m=MAPS[nd.map]
	local kind=nd.kind
	local r=mkRng(2,s)
	local ax,ay,ex,ey=0,0,0,0
	for _,a in ipairs(m[6]) do ax=ax+a[1] ay=ay+a[2] end
	for _,e in ipairs(m[7]) do ex=ex+e[1] ey=ey+e[2] end
	ax,ay=ax/#m[6],ay/#m[6] ex,ey=ex/#m[7],ey/#m[7]
	local team={}
	for _,a in ipairs(m[6]) do team[#team+1]={a[1],a[2],faceDir(a[1],a[2],ex,ey)} end
	local mine={} for _,id in ipairs(rosterIds()) do mine[id]=true end
	local pool=enemyPool(false)
	for k=#pool,1,-1 do if mine[pool[k]] then table.remove(pool,k) end end
	local boss=(kind==BOSSK) and bossOf(zoneOf(s)) or nil
	if boss then for k=#pool,1,-1 do if pool[k]==boss then table.remove(pool,k) end end end
	local lv=enemyLv(s,kind)
	local rows,leader={},-1
	for _,e in ipairs(m[7]) do
		local role=e[3]
		local id
		if role==9 and boss then id=boss
		else
			local want=(role==5) and 1 or ((role==9) and 1 or role)
			local c={} for k,pid in ipairs(pool) do if famOf(pid)==want then c[#c+1]=k end end
			local k=(#c>0) and r.pick(c) or r.int(#pool)
			id=table.remove(pool,k)
		end
		local l=lv+((role==9) and 4 or ((kind==BOSSK) and 2 or 0))
		local ai=(role==9) and 2 or ((role==5) and 0 or 1)
		rows[#rows+1]={id-1,e[1],e[2],faceDir(e[1],e[2],ax,ay),ai,math.min(99,l),JY.Person[id][BZ],0,0,-1,0}
		if role==9 then leader=id-1 end
	end
	local turn=(kind==NORMAL) and 20 or ((kind==ELITE) and 25 or 30)
	return rows,leader,team,m,turn
end

-- ---------------------------------------------------------------- 보상
local function joinCandidates()
	local t={}
	for i=1,War.PersonNum do
		local v=War.Person[i]
		if v.enemy and v.id and not koFreeIsGeneric(v.id) and JY.Person[v.id][LORD]~=1 then t[#t+1]=v.id end
	end
	return t
end
-- 일반 보상 카드 종류 가중치 (설계 12.2): 군령 · 보물 · 합류 · 훈련 · 응급 복구
local RW={{30,20,30,10,10},{35,25,15,15,10},{35,30,10,15,10}}
local function makeCards(kinds,z,r,cands)
	local picks,cards={},{}
	for _,k in ipairs(kinds) do
		local c={kind=k}
		if k==1 then local o=orderOffer(r,1) c.ord=o[1] if not c.ord then c=nil end
		elseif k==2 then c.item=rollItem(z,r) if not c.item then c=nil end
		elseif k==3 then c.join=r.pick(cands) if not c.join then c=nil end end
		if c then picks[#picks+1]=c end
	end
	for i,c in ipairs(picks) do
		if c.kind==1 then cards[i]=orderCard(c.ord)
		elseif c.kind==2 then cards[i]={t="\131\115\131\065",item=c.item,l={JY.Item[c.item][INAME],"(\129\071\130\087 \130\070 \130\108\130\111)"}}
		elseif c.kind==3 then local p=JY.Person[c.join] cards[i]={t="\129\087\129\093",l={p[NAME],"\129\071\130\087 \130\066\132\101\131\080 \131\076\131\097","Lv "..(enemyLv(curPos(),NORMAL)-2)..((#rosterIds()>=MAXARMY) and " \161\164 \132\087\133\114" or "")}}
		elseif c.kind==4 then cards[i]={t="\136\068\131\120",l={"\129\073\131\097 \129\111 \130\088","\130\082\130\123 +2","(\130\126\131\125 \130\080\137\104 \131\091\130\095\132\083)"}}
		else cards[i]={t="\132\105\134\080 \130\068\130\119",l={"\130\094\130\095 \130\090\130\091","\130\126\131\125 +30%","\130\117\130\118 +30%"}} end
	end
	return picks,cards
end
local function applyCard(c)
	if c.kind==1 then gainOrder(c.ord)
	elseif c.kind==2 then gotItem(c.item)
	elseif c.kind==3 then joinAt(c.join,math.max(1,enemyLv(curPos(),NORMAL)-2))
	elseif c.kind==4 then trainOne(2)
	else healAll(30,30) WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \130\126\131\125\129\123 \130\117\130\118\129\083 \132\067\139\113\131\116\129\077",M_White) end
end
local function reward(kind,round,cands)
	local s=curPos()
	local z=zoneOf(s)
	local rr=0
	while true do
		local r=mkRng(3,s,round,rr)
		local picks,cards
		local head=KNAME[kind].." \129\116\129\117 \161\164 \131\115\129\067\129\083 \129\097\131\118 \131\100\130\106\135\073\130\086\129\091"
		if kind==ELITE and round==1 then
			local ids=orderOffer(r,3)
			picks,cards={},{}
			for k,i in ipairs(ids) do picks[k]={kind=1,ord=i} cards[k]=orderCard(i) end
			head="\129\070\129\107\130\066 \129\116\129\117 \161\164 \130\084\130\089\129\083 \129\097\131\118 \131\100\130\106\135\073\130\086\129\091"
		elseif kind==BOSSK then
			local ids=orderOffer(r,1)
			picks,cards={},{}
			if ids[1] then picks[#picks+1]={kind=1,ord=ids[1]} end
			local it=rollItem(z,r,true) if it then picks[#picks+1]={kind=2,item=it} end
			picks[#picks+1]={kind=6}
			for k,c in ipairs(picks) do
				if c.kind==1 then cards[k]=orderCard(c.ord)
				elseif c.kind==2 then cards[k]={t="\129\067\134\080 \131\115\131\065",item=c.item,l={JY.Item[c.item][INAME],"(\129\071\130\087 \130\070 \130\108\130\111)"}}
				else cards[k]={t="\130\066\130\084 \136\068\131\120",l={"\130\094\130\095 \130\090\130\091","\130\082\130\123 +1"}} end
			end
			head="\130\119\134\074 "..z.." \131\115\131\126 \130\112\134\086 \161\164 \129\212\134\100 \131\115\129\067\129\083 \129\097\131\118 \131\100\130\106\135\073\130\086\129\091"
		else
			local w=RW[z]
			local avail={true,true,#cands>0,true,true}
			local kinds,seen={},{}
			for _=1,60 do
				if #kinds>=3 then break end
				local tot=0 for k=1,5 do if avail[k] and not seen[k] then tot=tot+w[k] end end
				if tot<=0 then break end
				local x=r.int(tot)
				for k=1,5 do if avail[k] and not seen[k] then x=x-w[k] if x<=0 then seen[k]=true kinds[#kinds+1]=k break end end end
			end
			picks,cards=makeCards(kinds,z,r,cands)
		end
		local ex={"\131\115\129\067 \134\097\131\071"}
		local re=unlocked(2) and not flag(1)
		if re then table.insert(ex,1,"\129\077\130\086 \144\102\131\071 (\130\070\129\102 \129\111 \130\087)") end
		local x=cardPick(head,cards,ex,true)
		if x>0 then
			local c=picks[x]
			if c.kind==6 then for _,id in ipairs(rosterIds()) do setLvKeep(id,JY.Person[id][LV]+1) end WarDrawStrBoxWaitKey("\130\094\130\095 \130\090\130\091 \130\082\130\123 +1",M_White)
			else applyCard(c) end
			return
		end
		if re and x==-1 then setFlag(1) rr=rr+1
		else return end
	end
end
local function bossTreasure()
	local lid=nil
	for i=1,War.PersonNum do local v=War.Person[i] if v.enemy and v.leader then lid=v.id end end
	local it=nil
	if lid and rawget(_G,"koGearData") and JY.Person[lid][LORD]~=1 then it=ownTreasure(lid) end
	it=it or rollItem(zoneOf(curPos()),mkRng(7,curPos()),true)
	if it then PlayWavE(11) gotItem(it,"\131\115\131\126 \130\112\134\086! ") end
end

-- ---------------------------------------------------------------- 쉼터 · 보물 상자 · 상점
local function doSupply()
	local cut=supplyCut()
	local cards={{t="\130\066\131\081 \130\120\130\121",l={"\130\094\130\095 \130\090\130\091","\130\126\131\125 +"..(40-cut).."%","\130\117\130\118 +50%"}},
		{t="\134\076\130\101 \132\081\129\085",l={"\129\073\131\097 \129\111 \130\088","\130\126\131\125 \161\164 \130\117\130\118 100%"}},
		{t="\130\084\130\089 \129\070\130\080",l={"\130\084\130\089 \129\097\131\118 \130\073\129\064"},dis=(#upOrders()==0),why="\130\073\129\064\129\088 \130\084\130\089 \130\097\130\077"}}
	while true do
		local r=cardPick("\158\220\131\104 \161\164 \129\097\131\118\130\104 \131\100\130\106\135\073\130\086\129\091",cards)
		if r==1 then healAll(40-cut,50) WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \139\093\134\066 \130\126\131\125\129\083 \132\067\139\113\131\116\129\077",M_White) return
		elseif r==2 then if focusHeal() then return end
		elseif r==3 then if pickUpgrade() then return end end
	end
end
local function doTreasure()
	local s=curPos()
	local r=mkRng(6,s)
	local z=zoneOf(s)
	local picks,cards={},{}
	local seen={}
	for _=1,10 do
		if #picks>=2 then break end
		local it=rollItem(z,r,flag(4))
		if it and not seen[it] then seen[it]=true picks[#picks+1]={kind=2,item=it} cards[#cards+1]={t="\131\115\131\065",item=it,l={JY.Item[it][INAME],"(\129\071\130\087 \130\070 \130\108\130\111)"}} end
	end
	local o=orderOffer(r,1)
	if o[1] then picks[#picks+1]={kind=1,ord=o[1]} cards[#cards+1]=orderCard(o[1]) end
	if flag(4) then sset(S.FLAG,sget(S.FLAG)-4) end
	local x=cardPick("\131\115\131\065 \129\067\133\120 \161\164 \129\097\131\118\130\104 \131\100\130\106\135\073\130\086\129\091",cards,{"\131\091\136\125 \130\067\131\118\133\121\129\077"},true)
	if x>0 then applyCard(picks[x]) end
end
local function doShop()
	local s=curPos()
	local z=zoneOf(s)
	local r=mkRng(5,s)
	local ord=r.pick(newOrders())
	local it=rollItem(z,r)
	local it2=nil for _=1,8 do local x=rollItem(z,r) if x and x~=it then it2=x break end end
	local pool=enemyPool(false)
	local rec=r.pick(pool)
	local d=z-1
	local list={
		{t="\130\125\130\068\135\067",l={"\130\094\130\095 \130\090\130\091","\130\126\131\125 +"..(25-supplyCut()).."%"},cost=120+20*d,go=function() healAll(25-supplyCut()) WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \130\126\131\125\129\083 \132\067\139\113\131\116\129\077",M_White) return true end},
		{t="\130\117\130\118\134\073",l={"\130\094\130\095 \130\090\130\091","\130\117\130\118 +40%"},cost=90+20*d,go=function() for _,id in ipairs(rosterIds()) do healSP(id,40) end WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \130\117\130\118\129\083 \132\067\139\113\131\116\129\077",M_White) return true end},
		{t="\130\088\131\080",l={"\129\073\131\097 \129\111 \130\088","\130\126\131\125 \161\164 \130\117\130\118","\130\090\130\091 \130\125\130\068"},cost=180+20*d,go=focusHeal},
		{t="\131\115\131\065",item=it,l={it and JY.Item[it][INAME] or "\130\097\130\077","(\129\071\130\087 \130\070 \130\108\130\111)"},cost=180+30*d,dis=(it==nil),go=function() gotItem(it) return true end},
		{t="\131\115\131\065",item=it2,l={it2 and JY.Item[it2][INAME] or "\130\097\130\077","(\129\071\130\087 \130\070 \130\108\130\111)"},cost=180+30*d,dis=(it2==nil),go=function() gotItem(it2) return true end},
		{t=ord and ORDERS[ord][2] or "\130\084\130\089",l={ord and ordDesc(ord,1) or "\130\097\130\077"},cost=220+30*d,dis=(ord==nil),go=function() return gainOrder(ord) end},
		{t="\130\084\130\089 \130\073\129\064",l={"\131\115\130\071 \130\084\130\089 \129\097\131\118","\130\073\129\064"},cost=160+20*d,dis=(#upOrders()==0),go=function() return pickUpgrade() end},
		{t="\131\097\129\113 \129\126\129\104",l={rec and JY.Person[rec][NAME] or "\130\097\130\077","Lv "..(enemyLv(s,NORMAL)-2)},cost=200+30*d,dis=(rec==nil),go=function() return joinAt(rec,math.max(1,enemyLv(s,NORMAL)-2)) end},
		{t="\136\068\131\120",l={"\129\073\131\097 \129\111 \130\088","\130\082\130\123 +1"},cost=150+20*d,go=function() return trainOne(1) end},
		{t="\130\084\130\089 \129\100\134\069",l={"\131\115\130\071 \130\084\130\089 \129\097\131\118","\132\113\129\117\131\071"},cost=80+20*sget(S.REM),dis=(ordCount()==0),go=function()
			local held={} for i=1,#ORDERS do if ordLv(i)>0 then held[#held+1]=i end end
			local cards={} for k,i in ipairs(held) do cards[k]={t=ORDERS[i][2],l={ordDesc(i,ordLv(i))}} end
			local x=cardPick("\132\113\132\117 \130\084\130\089\129\083 \131\100\130\106\135\073\130\086\129\091",cards,{"\131\091\132\086\130\091\131\071"},false)
			if x>0 then setOrd(held[x],0) sset(S.REM,sget(S.REM)+1) return true end
			return false end},
	}
	local sold={}
	while true do
		local cards={}
		for i,e in ipairs(list) do
			cards[i]={t=e.t,item=e.item,l=e.l,foot="\130\084\133\120\131\103 "..e.cost,dis=sold[i] or e.dis or gold()<e.cost,why=sold[i] and "\135\071\129\103" or ((gold()<e.cost) and ("\130\084\133\120\131\103 "..e.cost.." \130\094\132\082") or nil)}
		end
		local x=cardPick("\129\067\135\070 \161\164 \134\106 \131\117\129\083 \131\100\130\106\135\073\130\086\129\091 (\135\066\133\088\129\077 \129\097\131\118\143\093)",cards,{"\131\118\129\094\131\071"})
		if x<=0 then return end
		local e=list[x]
		if e.go() then addGold(-e.cost) sold[x]=true PlayWavE(0) end
	end
end

-- ---------------------------------------------------------------- 사건 15종 (설계 14절). 1~8 · 13~15(군자금) 기본, 9~12 = 공적 500 해금
local function evRng() return mkRng(4,curPos()) end
local function noteGold(g) addGold(g) WarDrawStrBoxWaitKey("\130\084\133\120\131\103 "..((g>=0) and "+" or "")..g,M_White) end
local function loseHP(pct) for _,id in ipairs(rosterIds()) do local p=JY.Person[id] p[HP]=math.max(1,p[HP]-math.floor(p[HPMAX]*pct/100)) end end
local EVENTS={
	function(r)-- 투항 장수
		local pool=enemyPool(false)
		local id=r.pick(pool)
		local ok=id and gold()>=150
		local x=cardPick("\130\114\129\119 \161\164 \131\076\129\103\129\102\131\087 \129\068\136\111\136\106 \131\097\129\113\129\094 \129\087\129\093\130\104 \137\082\129\111\129\077",{{t="\133\072\129\110\131\082\129\106\129\077",l={id and JY.Person[id][NAME] or "?","\130\084\133\120\131\103 150"},dis=not ok,why="\130\084\133\120\131\103 \130\094\132\082"},{t="\131\065\133\120\132\086 \133\072\130\098\129\077",l={"\130\084\133\120\131\103 +100"}},{t="\139\088\130\113\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then if joinAt(id,math.max(1,enemyLv(curPos(),NORMAL)-2)) then addGold(-150) end elseif x==2 then noteGold(100) end
	end,
	function(r)-- 버려진 보급고
		local it=rollItem(zoneOf(curPos()),r)
		local x=cardPick("\130\114\129\119 \161\164 \132\113\131\096\129\103 \131\115\134\080\131\100\130\104 \139\113\131\116\129\077",{{t="\130\126\131\125 \131\115\135\116",l={"\130\094\130\095 \130\090\130\091","\130\126\131\125 +20%"}},{t="\131\097\130\080 \142\126\140\089",item=it,l={it and JY.Item[it][INAME] or "?","(\129\071\130\087 \130\070 \130\108\130\111)"},dis=(it==nil)},{t="\139\088\130\113\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then healAll(20) WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \130\126\131\125\129\083 \133\094\141\102\129\077",M_White) elseif x==2 then gotItem(it) end
	end,
	function(r)-- 강행군
		local x=cardPick("\130\114\129\119 \161\164 \130\067\138\075\134\114\129\071 \131\115\129\106\129\077. \131\087\130\091\130\104\129\089?",{{t="\130\073\130\093\130\084",l={"\130\094\130\095 \130\090\130\091 \130\126\131\125 -10%","\130\084\130\089 \129\097\131\118 \130\073\129\064"},dis=(#upOrders()==0),why="\130\073\129\064\129\088 \130\084\130\089 \130\097\130\077"},{t="\135\067\138\120\131\066",l={"\130\084\133\120\131\103 +60"}},{t="\139\093\130\067 \130\107\131\100 \132\119\129\123",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then if pickUpgrade() then loseHP(10) end elseif x==2 then noteGold(60) end
	end,
	function(r)-- 떠돌이 의원
		local x=cardPick("\130\114\129\119 \161\164 \139\088\137\066\129\071 \131\080\131\081\129\083 \132\086\138\103\129\077",{{t="\130\066\131\081 \132\081\129\085",l={"\130\094\130\095 \130\090\130\091 \130\126\131\125 +35%","\130\084\133\120\131\103 120"},dis=gold()<120,why="\130\084\133\120\131\103 \130\094\132\082"},{t="\129\111 \130\088 \132\081\129\085",l={"\129\073\131\097 \129\111 \130\088 100%","\130\084\133\120\131\103 80"},dis=gold()<80,why="\130\084\133\120\131\103 \130\094\132\082"},{t="\139\088\130\113\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then addGold(-120) healAll(35) WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \132\081\129\085\130\104 \133\072\131\116\129\077",M_White) elseif x==2 then if focusHeal() then addGold(-80) end end
	end,
	function(r)-- 무너진 관문
		local x=cardPick("\130\114\129\119 \161\164 \129\073\129\072\129\103 \129\101\133\090\129\083 \130\067\131\118\133\069 \129\111\129\077",{{t="\132\070\130\067\132\083 \137\066\134\086",l={"\130\094\130\095 \130\090\130\091 \130\126\131\125 -15%","\130\084\133\120\131\103 +150"}},{t="\134\114\129\083 \134\120\130\098\129\077",l={"\130\084\133\120\131\103 80","\130\094\130\095 \130\090\130\091 \130\117\130\118 +30%"},dis=gold()<80,why="\130\084\133\120\131\103 \130\094\132\082"},{t="\131\079\130\125\129\111\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then loseHP(15) noteGold(150) elseif x==2 then addGold(-80) for _,id in ipairs(rosterIds()) do healSP(id,30) end WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \129\070\130\080\130\104 \133\088\135\082\129\077",M_White) end
	end,
	function(r)-- 군량 배분
		local x=cardPick("\130\114\129\119 \161\164 \131\089\131\067\129\111 \130\084\132\088\129\083 \130\083\139\099\129\081 \131\118\141\083\129\089?",{{t="\131\100\131\094 \131\118\132\073\129\077",l={"\130\094\130\095 \130\090\130\091","\130\126\131\125 +25%"}},{t="\129\111 \130\088\129\102\129\081",l={"\129\073\131\097 \129\111 \130\088","\130\126\131\125 \161\164 \130\117\130\118 100%"}},{t="\137\079\129\110 \132\113\131\106\129\077",l={"\130\084\133\120\131\103 +70"}}})
		if x==1 then healAll(25) WarDrawStrBoxWaitKey("\130\094\130\095\129\094 \134\099\133\100\129\117 \141\075\132\107\129\077",M_White) elseif x==2 then focusHeal() else noteGold(70) end
	end,
	function(r)-- 진형 훈련
		local function one(fam) local u=upOrders(fam) if #u>0 then return u end return newOrders(fam) end
		local d,c=one(2),one(1)
		local x=cardPick("\130\114\129\119 \161\164 \129\103\136\069 \136\068\131\120\129\083 \129\088 \129\113 \132\079\129\077",{{t="\132\078\130\083 \129\103\136\069",l={"\132\078\130\083 \130\084\130\089 \129\097\131\118","\133\086\131\071 \135\079\130\098 \130\073\129\064"},dis=(#d==0)},{t="\131\071\130\126 \129\103\136\069",l={"\131\071\130\126 \130\084\130\089 \129\097\131\118","\133\086\131\071 \135\079\130\098 \130\073\129\064"},dis=(#c==0)},{t="\134\075\129\106 \136\068\131\120",l={"\129\073\131\097 \129\111 \130\088","\130\082\130\123 +1"}}})
		if x==1 then gainOrder(r.pick(d)) elseif x==2 then gainOrder(r.pick(c)) else trainOne(1) end
	end,
	function(r)-- 패잔병 수습
		local pool=enemyPool(false)
		local c={} for _,id in ipairs(pool) do if famOf(id)==4 then c[#c+1]=id end end
		local id=r.pick(c) or r.pick(pool)
		local x=cardPick("\130\114\129\119 \161\164 \139\101\130\083\129\103 \129\079\137\120\130\126\129\083 \130\090\131\116\129\077",{{t="\131\097\129\113 \129\126\129\104",l={id and JY.Person[id][NAME] or "?","\130\117\130\114 \161\164 \130\067\131\081"},dis=(id==nil)},{t="\131\065\133\120 \129\070\129\117",l={"\130\084\133\120\131\103 +100"}},{t="\134\069\133\089\129\111\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then joinAt(id,math.max(1,enemyLv(curPos(),NORMAL)-2)) elseif x==2 then noteGold(100) end
	end,
	-- 아래 4종: 공적 500 해금
	function(r)-- 보물 지도
		local x=cardPick("\130\114\129\119 \161\164 \131\115\131\065 \130\067\129\068\130\104 \130\070\129\077\130\098 \129\067\129\106\129\083 \132\086\138\103\129\077",{{t="\132\091\129\077",l={"\130\084\133\120\131\103 100","\129\077\130\077 \131\115\131\065 \133\067\131\115\129\094 \129\067\134\080\131\109\132\083"},dis=gold()<100,why="\130\084\133\120\131\103 \130\094\132\082"},{t="\132\067\130\070\129\077",l={"\130\084\133\120\131\103 +80"}},{t="\139\088\130\113\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then addGold(-100) setFlag(4) WarDrawStrBoxWaitKey("\129\077\130\077 \131\115\131\065 \133\067\131\115\129\094 \138\111\129\110\129\103\129\077",M_White) elseif x==2 then noteGold(80) end
	end,
	function(r)-- 장기 내기 (확률 공개 50%)
		local win=r.pct(50)
		local x=cardPick("\130\114\129\119 \161\164 \134\097\132\083\129\094 \136\089 \131\076\131\097\129\071 \131\097\131\071 \131\095\131\071\130\104 \130\064\130\083 \138\088\129\077",{{t="\133\072\130\098\129\077",l={"\130\084\133\120\131\103 100\129\083 \130\064\131\100","\129\071\134\114 \129\105\137\101 50%","\129\071\131\071\129\065 +100 \161\164 \130\067\129\065 -100"},dis=gold()<100,why="\130\084\133\120\131\103 \130\094\132\082"},{t="\129\074\131\098 \134\069\134\071",l={"\130\084\133\120\131\103 +40"}},{t="\134\069\133\089\129\111\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then if win then PlayWavE(12) noteGold(100) else noteGold(-100) end elseif x==2 then noteGold(40) end
	end,
	function(r)-- 군사의 제안
		local s=newOrders(3)
		local x=cardPick("\130\114\129\119 \161\164 \139\088\137\066\129\071 \130\084\130\114\129\094 \132\084\130\117\129\083 \129\119\129\229\129\077",{{t="\130\117\130\118 \130\084\130\089",l={"\130\117\130\118 \130\084\130\089 \129\097\131\118 \133\086\131\071"},dis=(#s==0)},{t="\130\084\130\089 \132\087\133\114",l={"\131\115\130\071 \130\084\130\089 \129\097\131\118\130\104 \132\113\129\117\131\100","\134\068 \130\084\130\089 \129\097\131\118"},dis=(ordCount()==0 or #newOrders()==0)},{t="\134\069\133\089\129\111\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then gainOrder(r.pick(s))
		elseif x==2 then
			local held={} for i=1,#ORDERS do if ordLv(i)>0 then held[#held+1]=i end end
			local cards={} for k,i in ipairs(held) do cards[k]={t=ORDERS[i][2],l={ordDesc(i,ordLv(i))}} end
			local y=cardPick("\132\113\132\117 \130\084\130\089\129\083 \131\100\130\106\135\073\130\086\129\091",cards,{"\131\091\132\086\130\091\131\071"},false)
			if y>0 then local nw=r.pick(newOrders()) setOrd(held[y],0) gainOrder(nw) end
		end
	end,
	function(r)-- 봉인된 병기
		local hi=rollTier(3,r) local lo=rollTier(1,r)
		local x=cardPick("\130\114\129\119 \161\164 \135\087\129\106\136\089 \130\126\131\071\131\100\130\104 \139\113\131\116\129\077",{{t="\135\087\129\106\129\083 \137\102\129\077",item=hi,l={hi and JY.Item[hi][INAME] or "?","\130\094\130\095 \130\090\130\091 \130\126\131\125 -15%"},dis=(hi==nil)},{t="\143\111\132\086 \135\068\129\103\129\077",item=lo,l={lo and JY.Item[lo][INAME] or "?","(\129\097\134\080 \131\115\131\065)"},dis=(lo==nil)},{t="\130\065\130\067 \130\107\130\098\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then loseHP(15) gotItem(hi) elseif x==2 then gotItem(lo) end
	end,
	-- 아래 3종: 군자금 사건 (10-30 사용자 「사건에서 군자금을 얻는 것도」), 기본 사건
	function(r)-- 숨겨진 군자금
		local z=zoneOf(curPos())
		local g=80+30*z
		local x=cardPick("\130\114\129\119 \161\164 \132\113\131\096\129\103 \129\101\137\082 \134\103\131\100\129\102\131\087 \130\084\133\120\131\103\129\083 \139\113\131\116\129\077",{{t="\142\074\140\073\129\077",l={"\130\084\133\120\131\103 +"..g}},{t="\130\126\130\114\129\102\129\081 \131\118\132\073\129\077",l={"\130\094\130\095 \130\090\130\091","\130\117\130\118 +30%","\130\084\133\120\131\103 +"..math.floor(g/3)}},{t="\131\091\136\125 \137\081\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then noteGold(g) elseif x==2 then for _,id in ipairs(rosterIds()) do healSP(id,30) end noteGold(math.floor(g/3)) end
	end,
	function(r)-- 상인 호위
		local z=zoneOf(curPos())
		local g=150+40*z
		local x=cardPick("\130\114\129\119 \161\164 \132\091\131\076\129\102\129\081 \139\075\131\071\130\098 \129\067\129\106\129\071 \134\113\130\110\130\104 \137\082\129\111\129\077",{{t="\134\113\130\110\129\111\129\077",l={"\130\094\130\095 \130\090\130\091 \130\126\131\125 -10%","\130\114\139\126\131\103 +"..g}},{t="\132\119\130\093\131\111\132\086 \133\072\130\098\129\077",l={"\130\084\133\120\131\103 +60"}},{t="\130\067\131\118\133\121\129\077",l={"\129\110\129\073 \133\073\129\068 \130\097\130\077"}}})
		if x==1 then loseHP(10) noteGold(g) elseif x==2 then noteGold(60) end
	end,
	function(r)-- 포로 몸값
		local z=zoneOf(curPos())
		local pool=enemyPool(false)
		local id=r.pick(pool)
		local g=100+30*z
		local x=cardPick("\130\114\129\119 \161\164 \130\114\132\083\139\081\131\098 \131\076\131\097\131\080 \134\076\130\111\129\102\131\087 \136\117\137\093\129\083 \131\115\131\095 \138\088\129\077",{{t="\136\117\137\093\129\083 \133\072\130\098\129\077",l={"\130\084\133\120\131\103 +"..g}},{t="\130\094\130\095\129\102 \133\072\129\110\131\082\129\106\129\077",l={id and JY.Person[id][NAME] or "?","\136\117\137\093 \130\095\131\078 \129\087\129\093"},dis=(id==nil)},{t="\131\091\136\125 \139\069\130\083 \131\101\129\077",l={"\130\094\130\095 \130\090\130\091","\130\126\131\125 +10%"}}})
		if x==1 then noteGold(g) elseif x==2 then joinAt(id,math.max(1,enemyLv(curPos(),NORMAL)-2)) else healAll(10) WarDrawStrBoxWaitKey("\131\076\131\097\129\071 \131\100\133\088\132\069\129\097\134\066 \139\088\138\103\129\077",M_White) end
	end,
}
-- ? 칸 (슬더슬 방식 누적 확률, 10-29 밤 사용자 확정): 일반전 10% · 상점 3% · 보물 상자 2% · 나머지 사건, 정예전은 안 나옴.
-- 나오지 않은 쪽은 다음 ? 에서 기본값만큼 오르고(+10 · +3 · +2), 나온 쪽은 기본값으로. 단계 = S.QPITY 4비트씩 (전투 중 저장에 함께)
local QBASE={10,3,2}
local function qStep(i) return math.floor(sget(S.QPITY)/(16^(i-1)))%16 end
local function qChance() local t={} for i=1,3 do t[i]=QBASE[i]*(1+qStep(i)) end return t[1],t[2],t[3] end
local function qRoll()
	local a,b,c=qChance()
	local x=mkRng(12,curPos()).int(100)
	local out=(x<=a) and 1 or ((x<=a+b) and 2 or ((x<=a+b+c) and 3 or 4))
	local v=0
	for i=1,3 do local st=(i==out) and 0 or math.min(15,qStep(i)+1) v=v+st*(16^(i-1)) end
	sset(S.QPITY,v)
	return out-- 1 일반전 · 2 상점 · 3 보물 상자 · 4 사건
end
-- 사건 번호: 1~8 · 13~15 기본 (13~15 = 군자금 사건, 10-30 사용자), 9~12 = 공적 500 해금. 판 안 중복 없음 (S.EVU 비트)
local EV_BASE={1,2,3,4,5,6,7,8,13,14,15}
local EV_UNLOCK={9,10,11,12}
local function doEvent()
	local r=evRng()
	local list={} for _,i in ipairs(EV_BASE) do list[#list+1]=i end
	if unlocked(3) then for _,i in ipairs(EV_UNLOCK) do list[#list+1]=i end end
	local used=sget(S.EVU)
	local c={}
	for _,i in ipairs(list) do if math.floor(used/(2^(i-1)))%2==0 then c[#c+1]=i end end
	if #c==0 then c=list end
	local i=r.pick(c)
	if math.floor(used/(2^(i-1)))%2==0 then sset(S.EVU,used+2^(i-1)) end
	EVENTS[i](r)
end

-- ---------------------------------------------------------------- 지도 화면 (다음 칸 고르기)
local function dotLine(x1,y1,x2,y2,col)
	local n=math.max(1,math.abs(x2-x1),math.abs(y2-y1))
	for k=0,n,6 do
		local x=math.floor(x1+(x2-x1)*k/n) local y=math.floor(y1+(y2-y1)*k/n)
		lib.FillColor(x,y,x+2,y+2,col)
	end
end
local function nodeInfo(s,nd)
	local k=nd.kind
	if isBattle(k) then
		local m=MAPS[nd.map]
		local lv=enemyLv(s,k)
		if k==BOSSK then local b=bossOf(zoneOf(s)) return "\131\115\131\126\130\066 \161\164 "..m[2].."   \130\095\131\097 "..JY.Person[b][NAME].." Lv "..(lv+4).." \161\164 "..GNAME[gimOf(zoneOf(s))].."   \134\113\130\110 Lv "..(lv+2) end
		return KNAME[k].." \161\164 "..m[2].." ("..m[4].."\161\193"..m[5]..")   \131\076 "..#m[7].."\130\088 Lv "..lv..((k==ELITE) and "   \130\084\130\089 \131\115\129\067" or "")
	end
	if k==SUPPLY then return "\158\220\131\104 \161\164 \130\094\130\095 \130\120\130\121, \129\111 \130\088 \132\081\129\085, \130\084\130\089 \130\073\129\064 \130\101 \129\097\131\118" end
	if k==EVENT then local a,b,c=qChance() return "? \161\164 \131\082\130\083\129\094\129\065 \129\070\129\066\137\099   \133\073\133\065\130\066 "..a.."% \161\164 \129\067\135\070 "..b.."% \161\164 \131\115\131\065 \129\067\133\120 "..c.."% \161\164 \130\114\129\119 "..(100-a-b-c).."%" end
	if k==SHOP then return "\129\067\135\070 \161\164 \130\084\133\120\131\103\131\109\132\083 \130\125\130\068 \161\164 \130\084\130\089 \161\164 \131\115\131\065 \161\164 \131\097\129\113 \130\114\131\071" end
	return "\131\115\131\065 \161\164 \131\115\131\065 \138\101\129\123 \130\084\130\089 \129\097\131\118 \130\101 \129\097\131\118\130\104 \131\100\138\075"
end
local function partyText()
	local t={}
	for _,id in ipairs(rosterIds()) do local p=JY.Person[id] t[#t+1]=p[NAME].." Lv"..p[LV].." "..pctOf(id).."%" end
	local o=ordList()
	return "\130\094\130\095  "..table.concat(t," \161\164 ").."*\130\084\130\089  "..((#o>0) and table.concat(o," \161\164 ") or "\130\097\130\077").."*\130\084\133\120\131\103 "..gold()
end
-- 2026-10-30: classic navy/gold vertical route viewport; run state is unchanged.
local function mapStroke(x1,y1,x2,y2,col,w)
	local n=math.max(1,math.abs(x2-x1),math.abs(y2-y1))
	for j=0,n do
		local x=math.floor(x1+(x2-x1)*j/n) local y=math.floor(y1+(y2-y1)*j/n)
		lib.FillColor(x,y,x+(w or 1),y+(w or 1),col)
	end
end
-- Independent slot 7: the game's portrait, equipment, minimap and title slots stay untouched.
local MAPICON={[NORMAL]=0,[ELITE]=1,[BOSSK]=2,[SHOP]=3,[SUPPLY]=4,[EVENT]=5}
local function mapSprite(id,x,y)
	lib.PicLoadCache(7,id*2,math.floor(x),math.floor(y),1)
end
local function mapIcon(x,y,k,dim,small)
	local id=MAPICON[k] or 5
	mapSprite(id+(small and 12 or (dim and 6 or 0)),x-(small and 9 or 20),y-(small and 9 or 20))
end
local function mapScreen(s,choices,canBack,onCamp)
	if rawget(_G,"koConqMapPickT") then return koConqMapPickT(s,choices,canBack) end-- for test scripts (자동 시험이 칸을 고름)
	local campReady=not onCamp
	local z,row=zoneOf(s),rowOf(s)
	local rows=GEN().zones[z]
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	local top,bottom=oy+88,oy+404
	local viewH=bottom-top
	local spacing,contentH=86,940
	local maxScroll=contentH-viewH
	local scroll=math.max(0,math.min(maxScroll,(10-row)*spacing+40-viewH*0.68))
	if row==1 then scroll=maxScroll end
	local home=scroll
	local drag,dragOffset=nil,0
	local goldCol=RGB(232,192,72)
	local dim=RGB(101,118,153)
	local selected={} for _,l in ipairs(choices) do selected[l]=true end
	-- Visual variation uses a separate seeded RNG, never the encounter/reward RNG.
	local layout={} local vr=mkRng(401,z)
	for i=1,10 do
		layout[i]={}
		local lanes=lanesOf(rows[i]) local n=#lanes
		local span=({[1]=0,[2]=220,[3]=330,[4]=440,[5]=530})[n]
		local center=384+vr.int(31)-16
		if n==1 then center=384 end
		for j,l in ipairs(lanes) do
			layout[i][l]={x=center+((n>1) and ((j-1)/(n-1)-0.5)*span or 0)+vr.int(17)-9,y=vr.int(15)-8}
		end
	end
	local function nx(l,i)
		if not i or i==0 then return ox+384 end
		return math.floor(ox+layout[i][l].x)
	end
	local function ny(i,l)
		local offset=(l and layout[i] and layout[i][l]) and layout[i][l].y or 0
		return top+40+(10-i)*spacing-scroll+offset
	end
	local function move(v) scroll=math.max(0,math.min(maxScroll,v)) end
	local function thumb()
		local h=math.floor((viewH-32)*viewH/contentH)
		return top+16+math.floor((viewH-32-h)*scroll/maxScroll),h
	end
	local function button(x,y,w,label,hover)
		koRecordClassicBar(x,y,w,hover)
		conqText(x+w/2,y+3,label,M_White)
	end
	lib.PicLoadFile(CONFIG.DataPath.."conquest_ui.idx",CONFIG.DataPath.."conquest_ui.grp",7)
	koMouseReset()
	while true do
		JY.ReFreshTime=lib.GetTime()
		koFreeClassicBack()
		conqText(ox+384,oy+20,"\129\070\137\114 \161\164 \129\100 "..z.." \130\119\134\074",C_Name,24)
		conqText(ox+384,oy+63,"\129\103\130\093 "..(row-1).." / 10   \130\094\130\095 "..#rosterIds().." / "..MAXARMY.."   \130\084\130\089 "..ordCount().."   \130\084\133\120\131\103 "..gold(),C_Name)
		-- Keep the original brocade visible through the inset, matching the actual game menus.
		lib.Background(ox+26,top,ox+724,bottom,112,M_Black)
		DrawBox(ox+24,top-2,ox+744,bottom+2,RGB(151,125,72),-1)
		lib.SetClip(ox+28,top+1,ox+722,bottom-1)
		-- One visual departure camp below the first playable tier (not an extra encounter).
		for l in pairs(rows[1]) do
			dotLine(nx(2),ny(0)-30,nx(l,1),ny(1,l)+30,(row==1 and campReady) and goldCol or RGB(116,128,155))
		end
		if ny(0)>top-34 and ny(0)<bottom+34 then
			mapSprite((row==1) and 20 or 18,nx(2)-28,ny(0)-28)
			mapIcon(nx(2),ny(0),SUPPLY,row>1)
			conqText(nx(2)+64,ny(0)-7,(not campReady) and "\133\098\129\095 \131\101\130\080" or "\133\098\129\095",(row==1) and goldCol or M_Silver)
		end
		for i=1,9 do
			for l,nd in pairs(rows[i]) do
				for m in pairs(nd.out) do
					local gs=(z-1)*10+i
					local walked=gs+1<s and laneAt(gs)==l and laneAt(gs+1)==m
					local open=gs==s-1 and laneAt(gs)==l and selected[m]
					dotLine(nx(l,i),ny(i,l)-30,nx(m,i+1),ny(i+1,m)+30,open and goldCol or (walked and RGB(162,145,106) or RGB(113,130,165)))
				end
			end
		end
		local hovered=nil
		for i=1,10 do
			local y=ny(i)
			if y>top-42 and y<bottom+42 then
				conqText(ox+60,y-6,tostring(i),dim)
				for l,nd in pairs(rows[i]) do
					local y=ny(i,l)
					local gs=(z-1)*10+i
					local visited=gs<s and laneAt(gs)==l
					local current=visited and gs==s-1
					local can=gs==s and selected[l] and campReady
					local x=nx(l,i)
					local hot=can and y-29>=top and y+29<=bottom and MOUSE.IN(x-29,y-29,x+29,y+29)
					if hot then hovered=l end
					local col=(can or current) and goldCol or (visited and RGB(171,157,121) or dim)
					mapSprite((current or hot) and 20 or (can and 19 or 18),x-28,y-28)
					mapIcon(x,y,nd.kind,gs<s and not visited)
					if visited then mapSprite(21,x+17,y+14) end
				end
			end
		end
		lib.SetClip(0,0,0,0)
		local ty,th=thumb()
		local sx=ox+730
		lib.FillColor(sx,top,sx+12,bottom,RGB(20,28,45))
		DrawBox(sx,top,sx+12,bottom,RGB(151,125,72),-1)
		mapSprite(22,sx-1,top+1) mapSprite(23,sx-1,bottom-15)
		lib.FillColor(sx+2,ty,sx+10,ty+th,RGB(174,134,54))
		lib.FillColor(sx+2,ty,sx+4,ty+th,RGB(248,220,142))
		lib.FillColor(sx+8,ty+1,sx+10,ty+th,RGB(99,67,27))
		for yy=ty+math.floor(th/2)-4,ty+math.floor(th/2)+4,3 do lib.FillColor(sx+4,yy,sx+8,yy+1,RGB(106,78,33)) end
		button(ox+26,oy+438,112,canBack and "\137\066\129\110\129\094\131\071" or "\130\094\130\095 \161\164 \130\084\130\089",MOUSE.IN(ox+26,oy+438,ox+138,oy+462))
		button(ox+626,oy+438,116,"\129\114\129\115 \130\110\132\081",MOUSE.IN(ox+626,oy+438,ox+742,oy+462))
		local legend={{NORMAL,"\133\073\133\065"},{ELITE,"\129\070\129\107"},{SHOP,"\129\067\135\070"},{SUPPLY,"\158\220\131\104"},{EVENT,"\130\114\129\119"},{BOSSK,"\131\115\131\126"}}
		for j,v in ipairs(legend) do
			local lx=ox+158+(j-1)*76
			mapIcon(lx,oy+449,v[1],false,true)
			DrawString(lx+13,oy+442,v[2],M_White,16)
		end
		conqText(ox+384,oy+414,(not campReady) and "\133\098\129\095 \129\103\129\126\129\083 \141\083\133\101 \130\086\129\074 \130\084\130\089\129\083 \131\100\130\106\135\073\130\086\129\091" or (hovered and KNAME[rows[row][hovered].kind] or "\130\110\129\110\134\071 \129\071\130\108 \161\164 \131\126\132\094\147\199 \135\102\130\095 / \132\078\134\089\137\074"),(hovered or not campReady) and goldCol or M_Silver)
		ShowScreen()
		local e,k=koPollKey()
		if e==0 or MOUSE.EXIT() then koExit() end
		if e==1 then
			if k==27 and canBack then MOUSE.status='IDLE' return nil end
			if k==1073741906 then move(scroll-38) end -- Up
			if k==1073741905 then move(scroll+38) end -- Down
			if k==1073741899 then move(scroll-viewH+76) end -- PageUp
			if k==1073741902 then move(scroll+viewH-76) end -- PageDown
			if k==1073741898 then move(0) end -- Home (boss)
			if k==1073741901 then move(maxScroll) end -- End (start)
			if k==99 then move(home) end -- C: current position
			if k==13 or k==32 then move(home) end -- Never enter a battle accidentally while scrolling.
		end
		if MOUSE.ESC() and canBack then MOUSE.status='IDLE' return nil end
		if MOUSE.status=='HOLD' then
			if not drag and MOUSE.hx and MOUSE.hx>=sx and MOUSE.hx<=sx+12 and MOUSE.hy>=top+16 and MOUSE.hy<=bottom-16 then
				drag=true dragOffset=(MOUSE.hy>=ty and MOUSE.hy<=ty+th) and (MOUSE.hy-ty) or th/2
			end
			if drag then move((MOUSE.y-top-16-dragOffset)*maxScroll/(viewH-32-th)) MOUSE.enableclick=false end
		else drag=nil end
		if MOUSE.CLICK(sx,top,sx+12,top+16) then move(scroll-38)
		elseif MOUSE.CLICK(sx,bottom-16,sx+12,bottom) then move(scroll+38)
		elseif not campReady and ny(0)-29>=top and ny(0)+29<=bottom and MOUSE.CLICK(nx(2)-29,ny(0)-29,nx(2)+29,ny(0)+29) then
			PlayWavE(0)
			campReady=onCamp() and true or false
			koMouseReset() MOUSE.status='IDLE'
		elseif MOUSE.CLICK(ox+626,oy+438,ox+742,oy+466) then move(home)
		elseif MOUSE.CLICK(ox+26,oy+438,ox+138,oy+466) then
			if canBack then MOUSE.status='IDLE' return nil else WarDrawStrBoxWaitKey(partyText(),M_White) koMouseReset() end
		else
			-- Hit rectangles use the SAME scrolled coordinates as the drawing and stay inside the viewport.
			for _,l in ipairs(choices) do
				local x,y=nx(l,row),ny(row,l)
				if campReady and y-29>=top and y+29<=bottom and MOUSE.CLICK(x-29,y-29,x+29,y+29) then
					PlayWavE(0) MOUSE.koSwallowR=true MOUSE.status='IDLE' return l
				end
			end
		end
	end
end

-- ---------------------------------------------------------------- 칸 차례로 나아가기 (전투 칸에 닿으면 true, 30칸을 다 지나면 false)
local function advance()
	while true do
		local cur=curPos()
		local s=cur+1
		if s>30 then return false end
		local nd=nodeAt(cur)
		local choices={}
		for m=1,5 do if nd.out[m] then choices[#choices+1]=m end end
		if rowOf(s)==1 then
			PlayWavE(11)
			local z=zoneOf(s)
			WarDrawStrBoxWaitKey("\129\100 "..z.." \130\119\134\074\131\109\132\083 \129\103\130\084\129\111\129\077*\130\119\134\074 \131\115\131\126 "..JY.Person[bossOf(z)][NAME].." \161\164 "..GNAME[gimOf(z)].."*"..GDESC[gimOf(z)],M_White)
			choices=lanesOf(GEN().zones[z][1])
		end
		local l=mapScreen(s,choices)
		setLane(s,l)
		sset(S.POS,s)
		local nxt=nodeAt(s)
		sset(S.KIND,nxt.kind)
		sset(S.MAP,nxt.map or 0)
		if isBattle(nxt.kind) then return true end
		if nxt.kind==EVENT then
			local q=qRoll()
			if q==1 then-- 일반전: 앞 칸과 다른 일반 지도
				local prev=sget(S.MAP)
				local c={} for _,mi in ipairs(MAPBYKIND[1]) do if mi~=prev then c[#c+1]=mi end end
				sset(S.KIND,NORMAL) sset(S.MAP,mkRng(13,s).pick(c))
				WarDrawStrBoxWaitKey("? \161\164 \135\071\130\068\129\111 \131\076\129\071 \131\118\133\064\138\103\129\077!*\133\073\133\065\130\066",M_White)
				return true
			end
			WarDrawStrBoxWaitKey("? \161\164 "..((q==2) and "\139\088\137\066\129\071 \129\067\129\106\131\080 \129\067\135\070\129\083 \132\086\138\103\129\077" or ((q==3) and "\132\113\131\096\129\103 \131\115\131\065 \129\067\133\120\130\104 \139\113\131\116\129\077" or "\129\073\135\072 \133\073\129\071 \133\073\130\083\138\103\129\077")),M_White)
			if q==2 then doShop() elseif q==3 then doTreasure() else doEvent() end
		elseif nxt.kind==SUPPLY then doSupply()
		elseif nxt.kind==SHOP then doShop()
		else doTreasure() end
	end
end

-- ---------------------------------------------------------------- 군령 효과 (WarAtkHurt · WarAtk · WarMagic 감싸기, 정벌 전투에서 우리 편만)
local function conqWar() return JY.Status==GAME_WMAP and War and War.Person and koConqActive() end
local function ours(v) return v and not v.enemy and not v.friend end
local function isCav(v) return FAM[JY.Person[v.id][BZ] or 0]==2 end
local function moved(v) if not v.kSX then return 0 end return math.abs(v.x-v.kSX)+math.abs(v.y-v.kSY) end
local function weak(v) return v.troubled or (v.def_buff or 0)<0 or (v.atk_buff or 0)<0 end
koOn("player_phase",function()
	if not conqWar() then return end
	for i=1,War.PersonNum do local v=War.Person[i] if ours(v) then v.kSX=v.x v.kSY=v.y end end
end)
-- 군령 · 보스 기믹 이펙트 (10-30 사용자 「붙여 줘」): data/conquest_fx (원본 = 개발용/정벌 이펙트, 사용자 묶음 conquest_vfx_classic_16_effects)
--   0~95 = 16종 × 6장 (64×64, 기준점 32,52, 80/80/100/100/100/100ms), 96 = 계략 예고 칸(48px). 그림 칸 16.
--   실제 공격 · 책략 · 턴 처리 때만 재생(피해 미리보기 · AI 계산 때는 안 함 — WarAtk 안에서만 FX.act>0), 확인 키 없이
--   장수 칸 위에 이펙트 0.56초 + 짧은 글자 1.2초, 전투 기록 창(battlelog)에 한 줄. 지역 변수 한도 때문에 표 하나(FX)에 모음
local FX={slot=16,loaded=false,ok=false,q={},act=0,WARN=96,t={0,80,160,260,360,460,560},
	start={C01=0,C02=6,C03=12,U03=18,D01=24,D02=30,D03=36,U01=42,S01=48,S02=54,S03=60,U02=66,B01=72,B02=78,B03=84,B04=90}}
function FX.load()
	if FX.loaded then return end
	FX.ok=fileexist(CONFIG.DataPath.."conquest_fx.grp")
	if FX.ok then lib.PicLoadFile(CONFIG.DataPath.."conquest_fx.idx",CONFIG.DataPath.."conquest_fx.grp",FX.slot) end
	FX.loaded=true
end
function FX.at(code,x,y,text,boss)
	local now=lib.GetTime()
	for _,e in ipairs(FX.q) do if e.code==code and e.x==x and e.y==y and now-e.t0<400 then return end end
	FX.q[#FX.q+1]={code=code,x=x,y=y,t0=now,text=text,boss=boss}
end
function FX.play(code,v,text,boss)
	if not (v and v.x) then return end
	FX.at(code,v.x,v.y,text,boss)
	if text and rawget(_G,"koBattleLogNote") then for i=1,War.PersonNum do if War.Person[i]==v then pcall(koBattleLogNote,i,text) break end end end
end
function FX.frame(el) for k=1,6 do if el<FX.t[k+1] then return k-1 end end return 5 end
function FX.draw()
	if #FX.q==0 then return end
	FX.load()
	local now=lib.GetTime()
	local keep,labels={},{}
	-- 1) 이펙트 그림 모두, 2) 글자는 그 위에 한꺼번에 (뒤 그림이 앞 글자를 덮지 않게, 겹치는 글자는 위로 한 줄씩 비킴)
	for _,e in ipairs(FX.q) do
		local el=now-e.t0
		if el<1200 then keep[#keep+1]=e end
		if el<1200 and between(e.x,War.CX,War.CX+War.MW-1) and between(e.y,War.CY,War.CY+War.MD-1) then
			local left=War.OX+War.BoxWidth*(e.x-War.CX)
			local top=War.OY+War.BoxDepth*(e.y-War.CY)
			local cx=left+math.floor(War.BoxWidth/2)
			if el<560 and FX.ok and FX.start[e.code] then lib.PicLoadCache(FX.slot,(FX.start[e.code]+FX.frame(el))*2,cx-32,top+War.BoxDepth-4-52,1) end
			if e.text then labels[#labels+1]={e,cx,top-20-math.floor(math.min(el,800)/50)} end
		end
	end
	local boxes={}
	for _,L in ipairs(labels) do
		local e,cx,y=L[1],L[2],L[3]
		local w=#e.text*8
		local x=cx-#e.text*4
		for _=1,6 do
			local hit=false
			for _,bx in ipairs(boxes) do if x<bx[3] and x+w>bx[1] and y<bx[4] and y+18>bx[2] then hit=true break end end
			if not hit then break end
			y=y-19
		end
		boxes[#boxes+1]={x-3,y-1,x+w+3,y+17}
		lib.Background(x-3,y-1,x+w+3,y+17,140,M_Black)
		DrawString(x,y,e.text,e.boss and RGB(255,120,90) or M_Yellow,16)
	end
	FX.q=keep
end
-- 전투가 아닌 때(승리 정산) 화면 가운데에 한 번 (확인 키 없이 0.56초)
function FX.center(code)
	FX.load()
	if not (FX.ok and FX.start[code]) then return end
	local t0=lib.GetTime()
	while true do
		local el=lib.GetTime()-t0
		if el>=560 then break end
		pcall(DrawWarMap)
		lib.PicLoadCache(FX.slot,(FX.start[code]+FX.frame(el))*2,math.floor(CC.ScreenW/2)-32,math.floor(CC.ScreenH/2)-52,1)
		ShowScreen() lib.GetKey() lib.Delay(20)
	end
end
koOn("draw_units_over",function() if conqWar() then FX.draw() end return nil end)
koOn("record_load",function() FX.loaded=false FX.q={} FX.act=0 end)
koOn("war_begin",function() FX.q={} FX.act=0 end)
function koConqFxT(code,wid,text,ahead) FX.play(code,War.Person[wid],text) if ahead then FX.q[#FX.q].t0=FX.q[#FX.q].t0+ahead end end-- for test scripts (ahead = 늦게 시작, 캡처용)
local function atkBonus(a,d,flag,col)
	local up=0
	local direct=(flag==0)
	local turn=War.Turn or 0
	-- col 이 있으면(실제 공격) 들어간 군령을 {번호, 값, 이펙트를 띄울 장수} 로 모음
	local function add(code,who) local v=ordV(code) if v>0 then up=up+v if col then col[#col+1]={code,v,who,"+"} end end end
	if direct and isCav(a) and moved(a)>=3 then add("C01",a) end
	if d.kDisrupt==turn then add("C03",d) end
	if direct and d.kFire==turn and d.kFireUsed~=turn then add("S01",d) end
	if weak(d) then add("S03",d) end
	local p=JY.Person[a.id]
	if p[HPMAX]>0 and p[HP]*100<=p[HPMAX]*35 then add("U03",a) end
	if flag==1 and a.kAtk~=turn and a.kD03~=turn then add("D03",a) end
	return math.min(50,up)
end
local function defCut(d,flag,col)
	local cut=0
	local turn=War.Turn or 0
	local function add(code) local v=ordV(code) if v>0 then cut=cut+v if col then col[#col+1]={code,v,d,"-"} end end end
	if d.kChase==turn then add("C02") end
	if d.kSX and moved(d)==0 then add("D01") end
	if ordLv("D02")>0 then
		for i=1,War.PersonNum do
			local v=War.Person[i]
			if v~=d and ours(v) and v.live and not v.hide and math.abs(v.x-d.x)+math.abs(v.y-d.y)==1 then add("D02") break end
		end
	end
	return math.min(40,cut)
end
-- 보스 기믹 (전투 중)
local function bossUnit() for i=1,War.PersonNum do local v=War.Person[i] if v.enemy and v.leader and v.live then return v end end return nil end
local function gimNow() if sget(S.KIND)~=BOSSK then return 0 end return gimOf(zoneOf(curPos())) end
local function curGim()
	local g=gimNow()
	if g==GIM.MIX then return (sget(S.RAGE)==1) and GIM.CHARGE or GIM.GUARD end
	return g
end
local function near2(v,b) return math.max(math.abs(v.x-b.x),math.abs(v.y-b.y))<=2 end
local function guarded(b)
	for i=1,War.PersonNum do local v=War.Person[i] if v~=b and v.enemy and v.live and not v.hide and math.max(math.abs(v.x-b.x),math.abs(v.y-b.y))<=3 then return true end end
	return false
end
-- 기믹 피해 보정: 적이 주는 피해 +gu%, 대장이 받는 피해 -gc%
local function bossMod(a,d)
	if not (a and d) or gimNow()==0 then return 0,0 end
	local g=curGim()
	if g==GIM.CHARGE and a.enemy and ours(d) and (War.Turn or 0)%3==0 then
		local b=bossUnit()
		if b and (a==b or near2(a,b)) then return 20,0 end
	end
	if g==GIM.GUARD and ours(a) and d.enemy and d.leader and guarded(d) then return 0,30 end
	return 0,0
end
function koConqBossModT(a,d) return bossMod(a,d) end-- for test scripts
koOn("turn_ready",function()
	if not conqWar() or gimNow()==0 then return end
	local b=bossUnit()
	if not b then return end
	local T=War.Turn or 1
	local bn=JY.Person[b.id][NAME]
	local mk=sget(S.MARK)
	if mk>0 and sget(S.MTURN)<T then-- 지난 턴에 표시한 계략이 터짐
		local mx,my=math.floor(mk/100),mk%100
		local hit={}
		for i=1,War.PersonNum do
			local v=War.Person[i]
			if ours(v) and v.live and not v.hide and math.abs(v.x-mx)<=1 and math.abs(v.y-my)<=1 then
				local p=JY.Person[v.id]
				p[HP]=math.max(1,p[HP]-math.floor(p[HPMAX]/5))
				hit[#hit+1]=p[NAME]
			end
		end
		sset(S.MARK,0)
		PlayWavE(11)
		WarDrawStrBoxWaitKey(bn.."\131\080 \132\084\130\118!*"..((#hit>0) and (table.concat(hit," \161\164 ").." \130\126\131\125 -20%") or "\133\113\130\086\129\111 \135\069\129\102 \129\110\129\073\129\068 \130\097\132\107\129\077"),M_White)
		for dx=-1,1 do for dy=-1,1 do FX.at("B03",mx+dx,my+dy) end end
		for i=1,War.PersonNum do local v=War.Person[i] if ours(v) and v.live and not v.hide and math.abs(v.x-mx)<=1 and math.abs(v.y-my)<=1 then FX.play("B03",v,"\132\084\130\118 -20%",true) end end
	end
	if gimNow()==GIM.MIX and sget(S.RAGE)==0 then
		local p=JY.Person[b.id]
		if p[HP]*2<=p[HPMAX] then sset(S.RAGE,1) PlayWavE(11) WarDrawStrBoxWaitKey(bn.." \129\071(\129\094) \135\076\131\089\129\080\129\077!*\134\113\130\110 \130\095\131\078 3\129\112\133\088\129\077 \132\076\137\110 \137\066\130\112\129\111\129\077",M_White) FX.play("B04",b,"\135\076\131\089",true) end
	end
	local g=curGim()
	if g==GIM.CHARGE then
		if T%3==0 then
			b.ai=1
			WarDrawStrBoxWaitKey("\129\071\130\087 \129\112 \131\076 \132\121\139\126\129\102 "..bn.." \129\071(\129\094) \137\066\130\112\129\111\129\077!*\130\095\131\097\129\123 \130\075\130\116 2\135\066 \131\076\131\080 \137\088\129\066 +20%",M_White)
			FX.play("B01",b,"\137\066\130\112 \131\101\130\080",true)
		else
			b.ai=2
			if T%3==2 then WarDrawStrBoxDelay("\129\077\130\077 \129\112\129\102 "..bn.." \129\071(\129\094) \137\066\130\112\129\111\129\077",M_White) end
		end
	elseif g==GIM.STRAT and T%3==0 and sget(S.MARK)==0 then
		local best,bc=nil,-1
		for i=1,War.PersonNum do
			local v=War.Person[i]
			if ours(v) and v.live and not v.hide then
				local c=0
				for j=1,War.PersonNum do local u=War.Person[j] if ours(u) and u.live and not u.hide and math.abs(u.x-v.x)<=1 and math.abs(u.y-v.y)<=1 then c=c+1 end end
				if c>bc then best,bc=v,c end
			end
		end
		if best then
			sset(S.MARK,best.x*100+best.y) sset(S.MTURN,T)
			WarDrawStrBoxWaitKey(bn.." \129\071(\129\094) \132\084\130\118\129\083 \131\101\130\080\129\111\129\077!*\137\118\131\098 \133\113\130\086(3\161\1933) \130\111\129\102 \132\079\131\109\129\065 \129\077\130\077 \129\112 \130\086\129\074\129\102 \130\126\131\125 -20%",M_White)
		end
	end
end)
-- 계략 표시: 지형 위 · 유닛 아래 (이동 범위 표시와 같은 층, 장수가 가려지지 않게)
koOn("draw_overlay",function()
	if not conqWar() then return nil end
	local mk=sget(S.MARK)
	if mk<=0 then return nil end
	local mx,my=math.floor(mk/100),mk%100
	for dx=-1,1 do for dy=-1,1 do
		local x,y=mx+dx,my+dy
		if between(x,War.CX,War.CX+War.MW-1) and between(y,War.CY,War.CY+War.MD-1) then
			local left=War.OX+War.BoxWidth*(x-War.CX)
			local top=War.OY+War.BoxDepth*(y-War.CY)
			FX.load()
			if FX.ok then lib.PicLoadCache(FX.slot,FX.WARN*2,left,top,1)-- 예고 칸 그림 (48px)
			else
				lib.Background(left+2,top+2,left+War.BoxWidth-2,top+War.BoxDepth-2,110,RGB(200,40,30))
				DrawBox(left+1,top+1,left+War.BoxWidth-1,top+War.BoxDepth-1,RGB(240,70,50),-1)
			end
		end
	end end
	return nil
end)
do
	local rawHurt=WarAtkHurt
	function WarAtkHurt(pid,eid,...)
		local r=table.pack(rawHurt(pid,eid,...))
		if conqWar() and type(r[1])=="number" and r[1]>0 then
			local a,d=War.Person[pid],War.Person[eid]
			local fl=(...) or 0
			local up,cut=0,0
			local col=(FX.act>0) and {} or nil-- 실제 공격일 때만 이펙트 (미리보기 · AI 계산은 WarAtk 밖)
			if ours(a) and d and d.enemy then up=atkBonus(a,d,fl,col) end
			if a and a.enemy and ours(d) then cut=defCut(d,fl,col) end
			local gu,gc=bossMod(a,d)
			if col then
				for _,c in ipairs(col) do FX.play(c[1],c[3],ORDERS[OIDX[c[1]]][2].." "..c[4]..c[2].."%") end
				if gu>0 then FX.play("B01",a,"\130\095\131\097 \137\066\130\112 +"..gu.."%",true) end
				if gc>0 then FX.play("B02",d,"\134\113\130\110 -"..gc.."%",true) end
			end
			if up~=0 or cut~=0 or gu~=0 or gc~=0 then
				local p2=JY.Person[d.id]
				r[1]=math.min(math.max(1,math.floor(r[1]*(100+up)*(100-cut)*(100+gu)*(100-gc)/100000000+0.5)),p2[HP] or r[1])
			end
		end
		return table.unpack(r,1,r.n)
	end
	local rawAtk=WarAtk
	function WarAtk(pid,eid,fl,...)
		if not conqWar() then return rawAtk(pid,eid,fl,...) end
		local a,d=War.Person[pid],War.Person[eid]
		local was=d and d.live and JY.Person[d.id][HP]>0
		FX.act=FX.act+1
		local res=table.pack(pcall(rawAtk,pid,eid,fl,...))
		FX.act=math.max(0,FX.act-1)
		if not res[1] then error(res[2],0) end
		table.remove(res,1) res.n=res.n-1
		if War and War.Person and ours(a) and d and d.enemy then
			local turn=War.Turn or 0
			fl=fl or 0
			if fl==0 then
				a.kAtk=turn
				if moved(a)>=1 and ordLv("C03")>0 and d.live and d.kDisrupt~=turn then d.kDisrupt=turn FX.play("C03",d,"\130\066\130\065 \132\087\130\100") end
				if d.kFire==turn then d.kFireUsed=turn end
			elseif fl==1 then a.kD03=turn end
			if was and (not d.live or JY.Person[d.id][HP]<=0) and fl==0 then
				if isCav(a) and ordLv("C02")>0 then a.kChase=turn FX.play("C02",a,"\133\099\130\112 \130\088\130\089") end
				if ordLv("U01")>0 and sget(S.U01)<2 then
					local low,lp=nil,101
					for i=1,War.PersonNum do local v=War.Person[i] if ours(v) and v.live and not v.hide then local q=pctOf(v.id) if q<lp then low,lp=v,q end end end
					if low then healHP(low.id,ordV("U01")) sset(S.U01,sget(S.U01)+1) FX.play("U01",low,"\130\066\131\097 \130\119\134\113 +"..ordV("U01").."%") end
				end
			end
		end
		return table.unpack(res,1,res.n)
	end
	local rawMagic=WarMagic
	function WarMagic(wid,eid,mid,itemFlag,...)
		if not conqWar() then return rawMagic(wid,eid,mid,itemFlag,...) end
		local c=War.Person[wid]
		local mine=ours(c)
		local sp0=mine and JY.Person[c.id][SP] or 0
		local hp0={}
		if mine and FIRE[mid] and ordLv("S01")>0 then for i=1,War.PersonNum do local v=War.Person[i] if v.enemy and v.live then hp0[i]=JY.Person[v.id][HP] end end end
		local res=table.pack(rawMagic(wid,eid,mid,itemFlag,...))
		if mine and War and War.Person then
			local turn=War.Turn or 0
			for i,h in pairs(hp0) do local v=War.Person[i] if v and JY.Person[v.id][HP]<h then v.kFire=turn if v.live then FX.play("S01",v,"\129\064\130\074 \133\066\132\084") end end end
			if ordLv("S02")>0 and not itemFlag and sget(S.S02)~=turn then
				local used=sp0-JY.Person[c.id][SP]
				if used>0 then
					local back=math.floor(used*ordV("S02")/100)
					if back>0 then JY.Person[c.id][SP]=math.min(JY.Person[c.id][SPMAX],JY.Person[c.id][SP]+back) FX.play("S02",c,"\130\084\130\114 \131\115\133\112 \130\117\130\118 +"..back) end
					sset(S.S02,turn)
				end
			end
		end
		return table.unpack(res,1,res.n)
	end
end

-- ---------------------------------------------------------------- 시작 (첫 전투 = 1구역 1단 일반전)
local START=nil-- 시작 화면에서 고른 것 {army=, lv=, diff=, order=}
do
	-- 자유 전투가 도감 무장 모두를 내 편으로 둔 직후(WarIni) 고른 무장만 남김
	local rawWI=WarIni
	function WarIni(...)
		local r=table.pack(rawWI(...))
		local picks=CC.koConqPicks
		if picks then
			CC.koConqPicks=nil
			for i=1,JY.PersonNum-1 do if JY.Person[i][LORD]==1 then JY.Person[i][LORD]=0 end end
			for _,id in ipairs(picks) do
				local q=START and START.cqmap and START.cqmap[id]   -- 11-11: 다른 이야기 무장은 옮겨 둔 칸으로
				if q then id=q end
				if JY.Person[id] then JY.Person[id][LORD]=1 end
				if q then koFreeSetLevel(id,(START and START.lv) or 50,JY.Person[id][BZ]) end   -- 자유 전투 레벨 맞추기는 도감 무장만 하므로
			end
		end
		return table.unpack(r,1,r.n)
	end
end
local function newSeed()
	local t=(os.time() or 0)%32768
	return (t*1103+math.random(0,32767))%32768,math.random(0,32767)
end
-- 판 상태 처음 값 (출발 지도 화면 = 제목의 새 게임 기록에서 한 번, 실제 시작 = free_prepare 의 새 기록에서 다시, 같은 씨앗)
local function initRun(pos)
	for k=1,NSLOT do sset(k,0) end
	sset(S.SA,START.sa) sset(S.SB,START.sb)
	sset(S.ROUTE,2)
	sset(S.VER,VER) sset(S.POS,pos) sset(S.GOLD,150) sset(S.DIFF,START.diff or 0) sset(S.LV,START.lv or 20) sset(S.NB,1)
	GENC=nil
	if START.order then setOrd(START.order,1) end
end
koOn("free_prepare",function(b,opt,exp)
	if not b.conquest then return nil end
	if exp or not START or not haveRec() then return false end
	initRun(1)
	setLane(1,START.lane or lanesOf(GEN().zones[1][1])[1])
	local nd=nodeAt(1)
	sset(S.KIND,nd.kind) sset(S.MAP,nd.map)
	-- 고른 무장은 적으로 나오지 않게: koFreePool(true) 이 君主 1 을 빼므로 미리 표시
	if rawget(_G,"koConqMaterialize") then local a,map=koConqMaterialize(START.army) START.army=a START.cqmap=map end   -- 11-11: 다른 이야기 무장 → 인물 칸 761~742
	for _,id in ipairs(START.army) do JY.Person[id][LORD]=1 end
	local rows,leader,team,m,turn=buildBattle(1,nd)
	b.map,b.turn,b.l2,b.bgm=m[1],turn,leader,BGMS[mkRng(9,1).int(#BGMS)]
	b.name="\129\070\137\114 \161\164 "..m[2]
	b.team=team
	b.enemy=rows
	b.fixed=nil
	opt.elvmode=0
	return nil
end)

-- ---------------------------------------------------------------- 전투마다 첫 사건 (옛 판 기록 거르기 · 이어 온 병력 · 안내)
koOn("free_tick",function(f,b)
	if not b.conquest then return nil end
	if sget(S.VER)~=VER then
		if not f.conqOld then
			f.conqOld=true
			WarDrawStrBoxWaitKey("\129\107\130\066 \136\069\130\121\131\080 \129\070\137\114 \131\071\133\108\129\071\130\102 \129\071\130\083\131\087 \129\088 \129\113 \130\097\129\075\129\076\129\077*\129\100\131\099 \129\064\129\065\131\109\132\083 \137\066\129\110\134\104\129\076\129\077",M_White)
			CC.koFree=nil CC.koReplay=nil
			JY.Status=GAME_START
		end
		return true
	end
	if f.conqTroops then-- 이어 온 병력으로 (전투 시작이 출진 무장을 가득 채움)
		for i=1,War.PersonNum do
			local v=War.Person[i]
			local s=f.conqTroops[v.id]
			if s and not v.enemy then
				local p=JY.Person[v.id]
				p[HP]=math.max(1,math.min(s[1],p[HPMAX])) p[SP]=math.min(s[2],p[SPMAX])
				WarResetStatus(i)
			end
		end
		f.conqTroops=nil
	end
	if f.conqIntro~=sget(S.NB) then
		f.conqIntro=sget(S.NB)
		if (War.Turn or 1)==1 then
			local s=curPos()
			local k=sget(S.KIND)
			local m=MAPS[sget(S.MAP)] or MAPS[1]
			local elv=enemyLv(s,k)+((k==BOSSK) and 2 or 0)
			local lead=""
			for i=1,War.PersonNum do local v=War.Person[i] if v.enemy and v.leader then lead="*\130\095\131\097 "..JY.Person[v.id][NAME].." \130\112\134\086 \135\079\130\098 \131\076 \130\066\134\085" end end
			local d=(diff()>0) and ("  \130\083\131\096\136\108 "..diff()) or ""
			local o=ordList()
			WarDrawStrBoxWaitKey("\129\070\137\114 \161\164 \130\119\134\074 "..zoneOf(s).." \161\164 "..rowOf(s).."\134\077 \161\164 "..(KNAME[k] or "").."  (\130\066\132\101 "..sget(S.NB)..")"..d.."*"..m[2].."  \131\076 Lv "..elv..((k==BOSSK) and (" \161\164 \130\095\131\097 Lv "..(enemyLv(s,k)+4)) or "")..lead
				.."*\130\084\130\089 "..((#o>0) and table.concat(o," \161\164 ") or "\130\097\130\077")
				..((k==BOSSK) and ("*\131\115\131\126 "..GNAME[gimOf(zoneOf(s))].." \161\164 "..GDESC[gimOf(zoneOf(s))]) or ""),M_White)
		end
	end
	return nil
end)
-- 판 시작 준비 (첫 전투 첫 턴, 한 번): 시작 부대가 자기 전용 보물을 들고 옴 · 시작 보물 하나 고르기 (해금 4)
koOn("free_tick",function(f,b)
	if not b.conquest or sget(S.VER)~=VER or sget(S.NB)~=1 or flag(2) or (War.Turn or 1)~=1 then return nil end
	setFlag(2)
	if rawget(_G,"koGearCountOn") then pcall(koGearCountOn) end
	local got={}
	for _,id in ipairs(rosterIds()) do local s=bringOwn(id) if s then got[#got+1]=JY.Person[id][NAME].." "..s end end
	if #got>0 then WarDrawStrBoxWaitKey("\130\066\132\111 \131\115\131\065\129\083 \131\082\131\100 \133\098\129\103\129\080\129\077 (\131\082\131\100 \137\106\131\079\129\065 \130\070 \130\111\129\102\131\087 \130\069\131\123)*"..table.concat(got," \161\164 "),M_White) end
	if unlocked(4) then
		local r=mkRng(10)
		local ids,seen,tier={},{},{}
		for _,t in ipairs({2,3,3,3,2}) do
			if #ids>=3 then break end
			for _=1,10 do local it=rollTier(t,r) if it and not seen[it] then seen[it]=true ids[#ids+1]=it tier[#ids]=t break end end
		end
		if #ids>0 then
			local cards={}
			for i,it in ipairs(ids) do cards[i]={t=(tier[i]==3) and "\129\067\134\080 \131\115\131\065" or "\130\101\134\080 \131\115\131\065",item=it,l={JY.Item[it][INAME],"(\129\071\130\087 \130\070 \130\108\130\111)"}} end
			local x=cardPick("\133\098\129\103 \131\101\130\080 \161\164 \130\086\129\074 \131\115\131\065\129\083 \129\097\131\118 \131\100\130\106\135\073\130\086\129\091",cards)
			if x>0 then gotItem(ids[x]) end
		end
	end
	return nil
end)

-- ---------------------------------------------------------------- 정산 (패배 문구 뒤 · 완주)
local PENDING2=nil
local function settle(f,won)
	if f.conqSettled or flag(8) or sget(S.VER)~=VER then return end
	f.conqSettled=true
	setFlag(8)
	local wn,we,wb=sget(S.WN),sget(S.WE),sget(S.WB)
	local d=diff()
	local merit=math.floor((10*wn+30*we+60*wb+(won and 150 or 0))*(10+2*d)/10)
	local before=CC.koConqMerit or 0
	CC.koConqMerit=before+merit
	CC.koConqRuns=(CC.koConqRuns or 0)+1
	local reach=won and 31 or curPos()
	if reach>(CC.koConqBestPos or 0) then CC.koConqBestPos=reach end
	if won then CC.koConqClears=(CC.koConqClears or 0)+1 end
	if rawget(_G,"koSave") then pcall(koSave) end
	local aw=0
	for _,id in ipairs(rosterIds()) do for s=1,8 do local v=JY.Person[id][ITEM..s] or 0 if v>0 and string.find(JY.Item[v][INAME] or "","\161\239",1,true) then aw=aw+1 end end end
	PlayWavE(won and 12 or 1)
	WarDrawStrBoxWaitKey((won and "\129\070\137\114 \134\108\130\075!" or "\129\070\137\114 \139\091")..((d>0) and ("  (\130\083\131\096\136\108 "..d..")") or "").."*"..(won and "3\130\119\134\074 \137\066\134\086" or ("\130\119\134\074 "..zoneOf(curPos()).." \161\164 "..rowOf(curPos()).."\134\077\129\102\131\087 \141\122\144\084"))
		.."   \133\073\133\065 "..wn.."   \129\070\129\107 "..we.."   \131\115\131\126 "..wb..((aw>0) and ("   \130\069\131\123 "..aw) or "")
		.."*\130\074\131\076 +"..merit.."  (\134\117\131\076 "..CC.koConqMerit..")",M_White)
	local newU={}
	for i=1,#UNLOCK do if not unlocked(i,before) and unlocked(i) then newU[#newU+1]=UNLOCK[i][2] end end
	if #newU>0 then PlayWavE(11) WarDrawStrBoxWaitKey("\129\070\137\114 \129\066\131\103!*"..table.concat(newU," \161\164 "),M_White) end
end

-- ---------------------------------------------------------------- 전투 사이 · 다음 전투
local function afterBattle(kind)
	-- 출진한 무장: 살아남으면 병력 +5% · 책략 +15% (구역 보스 +20% · +30%), 퇴각했으면 병력 1로 돌아옴 (10-30 사용자). 뒤에 남은 무장은 그대로
	local hpP,spP=5,15
	if kind==BOSSK then hpP,spP=20,30 end
	local back={}
	for i=1,War.PersonNum do
		local v=War.Person[i]
		if v and ours(v) then
			local p=JY.Person[v.id]
			if p[LORD]==1 then
				if v.live and (p[HP] or 0)>0 then healHP(v.id,hpP) healSP(v.id,spP)
				else p[HP]=1 back[#back+1]=p[NAME] end
			end
		end
	end
	for _,id in ipairs(rosterIds()) do if (JY.Person[id][HP] or 0)<=0 then JY.Person[id][HP]=1 end end
	return back
end
koOn("free_floor_won",function(f)
	local b=koFreeData[f.idx]
	if not (b and b.conquest) or sget(S.VER)~=VER then return nil end
	local s,kind=curPos(),sget(S.KIND)
	if kind==BOSSK then sset(S.WB,sget(S.WB)+1) elseif kind==ELITE then sset(S.WE,sget(S.WE)+1) else sset(S.WN,sget(S.WN)+1) end
	-- 판 한정 각성: 전투 사이엔 war_won 이 안 불리므로 gear 의 승리 처리를 여기서 (마지막 보스는 free_won 에서)
	if s<30 then if rawget(_G,"koGearWarWon") then pcall(koGearWarWon) end end
	if s>=30 then return nil end-- 마지막 보스: 보통 승리 → free_won → 정산
	local cands=joinCandidates()
	local back=afterBattle(kind)
	PlayWavE(12)
	local g=100+30*(zoneOf(s)-1)
	if kind==ELITE then g=math.floor(g*1.5) elseif kind==BOSSK then g=g*2 end
	g=math.floor(g*(100+ordV("U02"))/100)
	addGold(g)
	if ordLv("U02")>0 then FX.center("U02") end
	WarDrawStrBoxWaitKey(KNAME[kind].." \129\116\129\117!  \130\084\133\120\131\103 +"..g..((ordLv("U02")>0) and (" (\130\066\129\117\131\066 \136\114\129\095 +"..ordV("U02").."%)") or "")..((#back>0) and ("*\133\068\130\069\129\111 "..table.concat(back," \161\164 ").." \129\071(\129\094) \130\126\131\125 1\132\083 \137\066\129\110\138\088\129\077") or ""),M_White)
	reward(kind,1,cands)
	if kind==ELITE then reward(ELITE,2,cands) end
	if kind==BOSSK then bossTreasure() end
	if not advance() then return nil end
	f.conqNext=true
	JY.Status=GAME_SMAP_AUTO
	return true
end)
koOn("free_next",function(f)
	if not f.conqNext then return nil end
	f.conqNext=nil
	local b=koFreeData[f.idx]
	local s=curPos()
	local nd={kind=sget(S.KIND),map=sget(S.MAP)}-- (? 칸에서 나온 일반전도 이 값으로)
	sset(S.NB,sget(S.NB)+1)
	sset(S.U01,0) sset(S.S02,0) sset(S.MARK,0) sset(S.MTURN,0) sset(S.RAGE,0)
	local keep={}
	for _,i in ipairs(rosterIds()) do local p=JY.Person[i] keep[i]={math.max(1,p[HP]),p[SP]} end
	local rows,leader,team,m,turn=buildBattle(s,nd)
	b.bgm=BGMS[mkRng(9,s).int(#BGMS)] b.name="\129\070\137\114 \161\164 "..m[2]
	WarIni()
	local target="1. \131\076 \130\066\134\085"
	if leader>=0 then target="1. "..JY.Person[leader+1][NAME].." \130\112\134\086*2. \131\076 \130\066\134\085" end
	DefineWarMap(m[1],"\129\070\137\114 "..KNAME[nd.kind].." "..sget(S.NB),target,turn,-1,leader)
	local tt={}
	for _,a in ipairs(team) do local k=#tt tt[k+1]=-1 tt[k+2]=a[1] tt[k+3]=a[2] tt[k+4]=a[3] tt[k+5]=0 tt[k+6]=-1 tt[k+7]=0 end
	JY.Status=GAME_SMAP_AUTO
	SelectTerm(1,tt)
	for i,v in pairs(keep) do JY.Person[i][HP]=v[1] JY.Person[i][SP]=v[2] end
	if War.PersonNum==0 then-- 나갈 무장이 없음 (일어나지 않아야 함): 정산 바로
		koFreeLost(f)
		PENDING2=nil
		pcall(settle,f,false)
		CC.koFree=nil CC.koReplay=nil
		JY.Status=GAME_START
		return true
	end
	f.conqTroops=keep
	local flat={}
	for _,r in ipairs(rows) do for k=1,11 do flat[#flat+1]=r[k] end end
	SelectEnemy(flat)
	local k=0
	for wid=1,War.PersonNum do
		local v=War.Person[wid]
		if v.enemy then k=k+1 local r=rows[k] if r then koFreeSetLevel(v.id,r[6],r[7]) end end
	end
	f.started=false f.conqIntro=nil
	Event[koFreeEID]=koFreeEvent
	JY.EventID=koFreeEID
	JY.Status=GAME_WMAP
	return true
end)

koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqMerit",default=0}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqBest",default=0}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqRuns",default=0}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqLv",default=20}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqBestPos",default=0}
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqClears",default=0}
-- 마지막 보스를 이기면 자유 전투가 「자유 전투 승리! (통산 n승)」 을 먼저 띄움 → 정벌에선 숨기고 통산 승수에도 넣지 않음 (정산 상자가 대신)
do
	local FREEWIN="\133\120\130\071 \130\066\132\101 \129\116\129\117!"
	local rawBox=WarDrawStrBoxWaitKey
	function WarDrawStrBoxWaitKey(s,...)
		if type(s)=="string" and string.sub(s,1,#FREEWIN)==FREEWIN and koConqActive() then
			CC.koFreeWin=math.max(0,(CC.koFreeWin or 1)-1)
			return
		end
		return rawBox(s,...)
	end
end
koOn("free_won",function(f)
	local b=koFreeData[f.idx or 0]
	if not (b and b.conquest) then return nil end
	if rawget(_G,"koGearWarWon") then pcall(koGearWarWon) end
	settle(f,true)
	return nil
end)
do
	local rawLost=koFreeLost
	koFreeLost=function(f,...)
		local b=koFreeData[(f and f.idx) or 0]
		local r=rawLost(f,...)
		-- 정산은 「아군이 전멸했다」 같은 패배 문구 뒤에: 전투가 끝날 때(war_end) 띄움
		if b and b.conquest then PENDING2=f end
		return r
	end
end
koOn("war_end",function()
	local f=PENDING2
	if f then PENDING2=nil pcall(settle,f,false) end
end)

-- ---------------------------------------------------------------- 제목 화면: 출정 준비 · 장수 고르기 · 시작 군령
local function bestText()
	local p=CC.koConqBestPos or 0
	if p==0 then
		local v=CC.koConqBest or 0
		if v==0 then return "\130\097\130\077" end
		return "\140\094 \130\070 \131\115\131\126 "..math.floor(v/100)
	end
	if p>30 then return "\134\108\130\075 "..(CC.koConqClears or 0).."\130\087" end
	return "\130\119\134\074 "..zoneOf(p).." \161\164 "..rowOf(p).."\134\077"
end
local function unlockedBook()
	local t={}
	local G=CC.koBookG or ""
	for i,id in ipairs(koRecBook or {}) do
		local v=tonumber(string.sub(G,i,i)) or 0
		if v%2==1 and id>1 then t[#t+1]=id end
	end
	if #t<8 then t={} for _,id in ipairs(koRecBook or {}) do if id>1 then t[#t+1]=id end end end
	if JY.Person[1] then table.insert(t,1,1) end
	if rawget(_G,"koConqForeign") then local ok,f=pcall(koConqForeign) if ok and f then for _,id in ipairs(f) do t[#t+1]=id end end end   -- 11-11: 다른 이야기에서 해금한 무장도 (newgen, 임시 번호)-- 유비는 늘 고를 수 있음
	return t
end
-- list 에서 limit 명 고르기 (정확히 limit 명이어야 출발)
local function pickArmy(list,limit,title,sub)
	local chosen,order={},{}
	local page=1
	local PER=18
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	while true do
		local pages=math.max(1,math.ceil(#list/PER))
		local btns={{x=ox+460,y=oy+440,w=140,h=26,s="\129\105\129\070"},{x=ox+612,y=oy+440,w=140,h=26,s="\137\066\129\110\129\094\131\071"},
			{x=ox+16,y=oy+440,w=100,h=26,s="\129\071\130\066",prev=true},{x=ox+124,y=oy+440,w=100,h=26,s="\129\077\130\077",next=true}}
		local n=math.min(PER,#list-(page-1)*PER)
		local cols=math.min(6,n)
		local x0=ox+384-math.floor((cols*96-28)/2)
		for k=1,PER do
			local id=list[(page-1)*PER+k]
			if not id then break end
			local col,row=(k-1)%6,math.floor((k-1)/6)
			btns[#btns+1]={x=x0+col*96,y=oy+94+row*112,w=68,h=100,s="",plain=true,pid=id,draw=function() end}   -- 11-11 사용자 「선택틀이 글씨 위로」: 바깥 흰 틀 없이 그림 안 틀 + 노란 이름(아래 draw)
		end
		local function draw(hov)
			local names={}
			for _,id in ipairs(order) do names[#names+1]=JY.Person[id][NAME] end
			conqHead(ox,oy,title,sub.."   ("..#order.." / "..limit.."\130\088"..((#names>0) and (": "..table.concat(names," \161\164 ")) or "")..")")
			for bi,b in ipairs(btns) do
				if b.pid then
					local p=JY.Person[b.pid]
					local on=chosen[b.pid]
					local lc=on and M_Yellow or ((hov==bi) and C_Name or RGB(128,113,78))
					lib.FillColor(b.x+2,b.y+2,b.x+66,b.y+82,RGB(0,0,0))
					lib.PicLoadCache(2,p[FACE]*2,b.x+2,b.y+2,1)
					for o=0,1 do
						lib.DrawRect(b.x+2+o,b.y+2+o,b.x+65-o,b.y+2+o,lc) lib.DrawRect(b.x+2+o,b.y+81-o,b.x+65-o,b.y+81-o,lc)
						lib.DrawRect(b.x+2+o,b.y+2+o,b.x+2+o,b.y+81-o,lc) lib.DrawRect(b.x+65-o,b.y+2+o,b.x+65-o,b.y+81-o,lc)
					end
					if on then lib.FillColor(b.x+2,b.y+62,b.x+26,b.y+82,RGB(130,49,39)) conqText(b.x+14,b.y+65,tostring(on),M_White) end
					DrawString(b.x+34-#p[NAME]*4,b.y+91,p[NAME],(on or hov==bi) and C_Name or M_White,16)
				end
			end
			local s=page.." / "..pages
			DrawString(ox+300-#s*4,oy+445,s,M_Gray,16)
		end
		local r=koFreeClassicWait(draw,btns)
		local b=btns[r]
		if r==0 or r==2 then return nil end
		if r==1 then
			if #order==limit then return order end
		elseif b and b.prev then if page>1 then page=page-1 end
		elseif b and b.next then if page<pages then page=page+1 end
		elseif b and b.pid then
			if chosen[b.pid] then
				for k,id in ipairs(order) do if id==b.pid then table.remove(order,k) break end end
			elseif #order<limit then order[#order+1]=b.pid
			elseif limit==1 then order={b.pid} end
			chosen={} for k,id in ipairs(order) do chosen[id]=k end
		end
	end
end
-- 동료 후보: 첫 장수를 뺀 도감 무장 중 4명 (해금 1: 6명), 책사 계열 하나는 꼭
local function companionList(first)
	local all=unlockedBook()
	local c,strat={},{}
	for _,id in ipairs(all) do if id~=first then c[#c+1]=id if famOf(id)==4 then strat[#strat+1]=id end end end
	local n=unlocked(1) and 6 or 4
	local out,seen={},{}
	if #strat>0 then local id=strat[math.random(#strat)] out[1]=id seen[id]=true end
	for _=1,200 do
		if #out>=n or #out>=#c then break end
		local id=c[math.random(#c)]
		if not seen[id] then seen[id]=true out[#out+1]=id end
	end
	return out
end
local function startOrderPick()
	local ids,seen=(START and START.orderChoices) or {},{}
	if #ids==0 then
		for _=1,100 do
			if #ids>=3 then break end
			local i=math.random(#ORDERS)
			if not seen[i] then seen[i]=true ids[#ids+1]=i end
		end
	end
	if START then START.orderChoices=ids end
	local cards={}
	for k,i in ipairs(ids) do cards[k]={t=ORDERS[i][2],l={"\130\084\130\089 \161\164 "..OFAM[ORDERS[i][3]],ordDesc(i,1)}} end
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	local btns={}
	for k=1,#cards do btns[k]={x=ox+384-321+(k-1)*226,y=oy+120,w=208,h=214,s="",plain=true,card=k} end
	btns[#btns+1]={x=ox+300,y=oy+438,w=168,h=28,s="\137\066\129\110\129\094\131\071",back=true}
	local function draw(hov)
		conqHead(ox,oy,"\129\070\137\114 \161\164 \130\086\129\074 \130\084\130\089","\130\094\130\095 \130\066\133\114\129\102 \130\064\129\117\130\098 \130\084\130\089\129\083 \129\097\131\118 \131\100\130\106\135\073\130\086\129\091 (\130\066\132\101 \161\164 \131\115\129\067 \161\164 \129\067\135\070\129\102\131\087 \132\108 \133\086\130\077)")
		for k,c in ipairs(cards) do
			local b=btns[k]
			conqPanel(b.x,b.y,b.w,b.h)
			if hov==k then DrawBox(b.x+3,b.y+3,b.x+b.w-3,b.y+b.h-3,M_Yellow,-1) end
			conqText(b.x+b.w/2,b.y+14,c.t,C_Name,24)
			lib.FillColor(b.x+14,b.y+46,b.x+b.w-14,b.y+47,RGB(128,113,78))
			local yy=b.y+58
			for _,l in ipairs(c.l) do for _,line in ipairs(conqWrap(l,math.floor((b.w-20)/8))) do conqText(b.x+b.w/2,yy,line,M_White) yy=yy+18 end end
		end
	end
	while true do
		local r=koFreeClassicWait(draw,btns)
		local b=btns[r]
		if r==0 or (b and b.back) then return nil end
		if b and b.card then MOUSE.koSwallowR=true MOUSE.status='IDLE' return ids[b.card] end
	end
end
local function startRun(army,lv,d,order)
	local sa,sb=newSeed()
	START={army=army,lv=lv,diff=d,order=order,sa=sa,sb=sb}
	-- 출발 지도: 제1구역 지도를 보고 1단 칸을 골라야 첫 전투가 시작됨 (제목의 새 게임 기록에 잠시 판 상태를 두고 그림)
	if haveRec() then
		for i=1,JY.PersonNum-1 do if JY.Person[i][LORD]==1 then JY.Person[i][LORD]=0 end end
		for _,id in ipairs(army) do JY.Person[id][LORD]=1 end
		initRun(0)
		local onCamp=nil
		if not START.order then
			onCamp=function()
				local picked=startOrderPick()
				if not picked then return false end
				START.order=picked
				setOrd(picked,1)
				return true
			end
		end
		local l=mapScreen(1,lanesOf(GEN().zones[1][1]),true,onCamp)
		if not l then START=nil LoadRecord(0) return false end
		START.lane=l
		LoadRecord(0)
	end
	CC.koConqPicks=army
	local idx=0 for i,b in ipairs(koFreeData) do if b==CONQ then idx=i end end
	local ok=koFreeStart(idx,{rand=0,elvmode=0,elv=lv,mylv=lv,cost=0})
	CC.koConqPicks=nil
	START=nil
	return ok
end
-- 시험용: 화면 없이 부대 · 레벨로 시작 (order = 군령 번호 또는 nil)
function koConqStartT(army,lv,d,order)
	LoadRecord(0)
	local ok=startRun(army,lv,d or 0,order)
	return ok
end
function koConqStateT() local t={} for k=1,NSLOT do t[k]=sget(k) end return t end
function koConqSetOrdT(i,v) setOrd(i,v) end
function koConqCardsT(title,cards,extras) return cardPick(title,cards,extras,true) end-- for test scripts (카드 화면만)
function koConqSetGoldT(g) sset(S.GOLD,g) end
function koConqShopT() return doShop() end function koConqTreasureT() return doTreasure() end function koConqEventT(i) return EVENTS[i](evRng()) end-- for test scripts
function koConqScreen()
	LoadRecord(0)
	local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
	local cx=ox+384
	local lv=50-- 11-04: 시작 레벨 고정 (고르는 칸 없앰). 정벌 · 자유 전투 · 와룡의 시련 모두 50
	local d=limitX(CC.koConqDiff or 0,0,maxDiff())
	local LY=oy+376
	local cr=cx
	local btns={
		{x=cx-200,y=oy+430,w=180,h=28,s="\133\098\129\103 \131\097\129\113 \132\075\131\123"},
		{x=cx+20,y=oy+430,w=180,h=28,s="\137\066\129\110\129\094\131\071"},
	}
	if maxDiff()>0 then
		btns[#btns+1]={x=cr-90,y=LY,w=40,h=26,s="-1",dd=-1}
		btns[#btns+1]={x=cr+50,y=LY,w=40,h=26,s="+1",dd=1}
	end
	local function ctext(x,y,s,color,size) size=size or 16 DrawString(x-#s*size/4,y,s,color or M_White,size) end
	local function draw()
		conqHead(ox,oy,"\129\070\137\114 \161\164 \133\098\129\070 \131\101\130\080")
		conqPanel(ox+24,oy+64,720,100)
		conqPanel(ox+24,oy+174,720,32)
		conqPanel(ox+24,oy+216,720,122)
		conqPanel(ox+24,oy+344,720,64)
		ctext(cx,oy+76,"\131\111 \130\119\134\074\131\080 \135\121\130\079\134\114 30\135\066\129\083 \130\067\131\118 \130\069 \130\119\134\074\131\080 \131\115\131\126\130\104 \130\112\134\086\129\097\135\073\130\086\129\091.",M_White)
		ctext(cx,oy+96,"\130\082\130\123 50 \131\097\129\113 3\130\088\131\109\132\083 \133\098\129\095 \161\164 \133\098\129\103 4\130\088 \161\164 \130\094\130\095 6\130\088 \161\164 \130\084\130\089\131\109\132\083 \130\094\130\095\130\104 \137\074\140\124\129\076\129\077.",M_White)
		ctext(cx,oy+116,"\133\098\129\103\129\111 \131\097\129\113\129\094 \130\090\130\091 \133\068\130\069\129\097\129\065 \139\091. \129\071\131\071\129\065 \133\068\130\069\129\111 \131\097\129\113\130\098 \130\126\131\125 1\132\083 \137\066\129\110\133\111\129\076\129\077.",M_Silver)
		ctext(cx,oy+140,"\131\115\131\065 \161\164 \131\123\131\097 \161\164 \130\069\131\123\131\098 \129\071\130\087 \129\070\137\114\129\102\132\086 \131\076\132\111\140\106\129\076\129\077. \129\071\133\069\131\071\135\122 \129\068\135\078\129\102\130\098 \133\103\130\067 \130\107\129\075\129\076\129\077.",M_Silver)
		ctext(cx,oy+182,"\136\122\131\100 \131\071\133\108 "..bestText().."   \134\117\131\076 \130\074\131\076 "..(CC.koConqMerit or 0).."   \129\068\130\066 "..(CC.koConqRuns or 0).."\130\087",M_Yellow)
		DrawString(cx-330,oy+224,"\130\074\131\076\129\102 \130\105\135\077 \133\098\129\070 \129\120\130\066",C_Name,16)
		for i,u in ipairs(UNLOCK) do
			local x=(i<=4) and (cx-330) or (cx+20)
			local y=oy+248+((i-1)%4)*20
			if unlocked(i) then DrawString(x,y,"\161\241 "..u[2],M_White,16)
			else DrawString(x,y,string.format("%4d  ",u[1])..u[2],M_Gray,16) end
		end
		if maxDiff()>0 then
			ctext(cr,LY-22,"\130\083\131\096\136\108 (\131\076 +\134\077\132\084, \130\074\131\076 \161\193"..string.format("%.1f",1+0.2*d)..")",M_White)
			ctext(cr,LY+5,(d>0) and tostring(d) or "\131\115\132\119",(d>0) and C_Name or M_White)
		else
			ctext(cr,oy+368,"\130\083\131\096\136\108: \130\074\131\076 1200 \129\102 \130\065\130\079",M_Gray)
		end
	end
	while true do
		local r=koFreeClassicWait(draw,btns)
		if r==0 or r==2 then break end
		if r==1 then
			CC.koConqLv=lv CC.koConqDiff=d if rawget(_G,"koSave") then pcall(koSave) end
			local first=pickArmy(unlockedBook(),1,"\129\070\137\114 \161\164 \130\094\131\097 \133\109\133\110","\130\094\130\095\130\104 \129\071\136\110 \130\094\131\097 \129\111 \130\088\129\083 \131\100\130\106\135\073\130\086\129\091")
			if first then
				local comp=companionList(first[1])
				local two=pickArmy(comp,2,"\129\070\137\114 \161\164 \130\108\129\085","\137\072\138\095 \135\121 \130\108\129\085 \130\091 \130\088\129\083 \131\100\130\106\135\073\130\086\129\091")
				if two then
					if startRun({first[1],two[1],two[2]},lv,d,nil) then return end
					LoadRecord(0)
				end
			end
		elseif btns[r].dd then d=limitX(d+btns[r].dd,0,maxDiff())
		end
	end
	LoadRecord(0)
end
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koConqDiff",default=0}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\129\070\137\114",run=function() koConqScreen() end}
