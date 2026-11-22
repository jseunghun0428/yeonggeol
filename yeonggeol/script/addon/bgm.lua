-- 군웅록 (11-03): 새 배경 음악. sound/B###.mp3 (新영걸전 BGM 133곡, 개발용/도구/BGM_변환.py 로 -24 LUFS 96kbps)
-- 원작 칸 0~19(PlayBGM 번호)마다 이야기별 곡 묶음, 부를 때마다 묶음에서 하나 (같은 칸을 이어 부르면 같은 곡).
-- 특별 번호: 100 이야기 타이틀, 101 메인 화면, 102 마을 거리, 103 모드 첫 화면.
-- 모드(자유 전투 · 정벌 · 적 진영 · 고사 재현 · 와룡의 시련 · 무술 대회 · 술 겨루기 · 도감 화면)는 들어가는 함수를 감싸
-- 그 모드 묶음을 쓰고, 타이틀로 돌아오면(타이틀 음악을 부르면) 풀림. 기능설정 「배경 음악」 원본 = 예전 M00~M19 그대로.
local TITLE,MAIN,TOWN,MENU=100,101,102,103
local B={}
-- 이야기: [칸]={곡 번호...}
B.yg={-- 영걸전: 삼국지 5 · 6 관현악 위주
title={20},
[0]={124,128,120},[1]={163,122},[2]={125,129,94},[3]={43,150},[4]={134,127},[5]={144,126},[6]={149,65},[7]={132,35},
[8]={121,37},[9]={168,177},[10]={158,32},[11]={123,142,155,164,145},[12]={140,36},[13]={113,115},[14]={152,166},
[15]={151},[16]={153,17},[17]={148},[18]={21,118},[19]={167,22},
}
B.wuje={-- 무제전 (조조): 조조전 OST 와 그 편곡
title={168},
[0]={170,20},[1]={114,95},[2]={146,23},[3]={33,90},[4]={30,134},[5]={177,169},[6]={39,165},[7]={133,132},
[8]={42,29},[9]={168,14},[10]={32,160},[11]={5,7,9,24,26,171,173,174,176},[12]={36,110},[13]={40,113},[14]={166},
[15]={19},[16]={6,17},[17]={156},[18]={21,141},[19]={11,16,172,175,1},
}
B.sunjian={-- 손견전: 수군 · 동쪽 악기
title={10},
[0]={0,12},[1]={89,143},[2]={157,159},[3]={145,152},[4]={127,30},[5]={139,100},[6]={65,117},[7]={132,35},
[8]={135,121},[9]={131,115},[10]={160},[11]={64,66,152,166,155,164},[12]={140,43},[13]={113,147},[14]={152,163},
[15]={101,105},[16]={153,4},[17]={148,156},[18]={118,21},[19]={106,22,92},
}
B.yuanshao={-- 원소전: 삼국지 7 · 10 · 랑그릿사
title={12},
[0]={147,31},[1]={121,104},[2]={125,23},[3]={150,25},[4]={134,127},[5]={126,144},[6]={128,149},[7]={132,35},
[8]={37,29},[9]={168,131},[10]={158},[11]={115,117,119,142,155,64,27},[12]={36,140},[13]={113,34},[14]={152},
[15]={151,177},[16]={153,8},[17]={148},[18]={118,141},[19]={22,18},
}
-- 모드: menu = 첫 화면, any = 그 밖의 칸 전부(전투), [4] · [7] = 패배 · 승리
local JING={[4]={134,127,30},[7]={133,132,35}}
local M={
main={menu={147}},
town={menu={114,95,163,89,143,170,104,96}},
book={menu={148,37,135,121,143}},
free={menu={130},any={4,8,13,15,18,38,116,136,137,167,110,162}},
conquest={menu={150},any={155,164,142,109,115,118,145,66,90,117,27,31,34,16,26}},
foeside={menu={160},any={131,153,108,168,6,17,154,138}},
puzzle={menu={28},any={111,40,32,158,92,93,41,19,5}},
trial={menu={156},any={6,17,108,15,4,38,153,131}},
tourney={any={118,21,141,98,91,109,161}},
drink={any={162,101,105,99,97,103,107,112,161,165,169,100,130,98}},
}
M.tourney.menu=M.tourney.any   -- 무술 대회 · 술 겨루기는 첫 화면부터 같은 묶음
M.drink.menu=M.drink.any
koBGMData={story=B,mode=M,jingle=JING}

local ctx=nil          -- 지금 모드 이름 (nil = 이야기)
local last={}          -- 묶음 → 마지막으로 고른 곡 (같은 칸 이어 부르기 · 바로 되풀이 피하기)
local lastKey=nil
local origPlay=PlayBGM
function koBGMOn() return (CC.koBGMNew or 1)==1 end
local function story() return B[CONFIG.koCamp or "yg"] or B.yg end
local function pool(id)
	local m=ctx and M[ctx]
	if id==TITLE then return story().title,"t" end
	if id==MAIN then return M.main.menu,"main" end
	if id==TOWN then return M.town.menu,"town" end
	if id==MENU then if m and m.menu then return m.menu,ctx..".menu" end return nil end
	if m then
		if m.any and (id==4 or id==7) then return JING[id],ctx..id end
		if m.any then return m.any,ctx..".any" end
	end
	return story()[id],(CONFIG.koCamp or "yg")..id
end
local function pick(p,key,same)
	if same and last[key] then return last[key] end
	local k=p[math.random(#p)]
	while #p>1 and k==last[key] do k=p[math.random(#p)] end
	last[key]=k
	return k
end
function PlayBGM(id)
	id=id or 0
	if id==TITLE then ctx=nil end
	if not koBGMOn() then
		if id==TITLE or id==MAIN then id=1 elseif id>=TOWN then return end
		return origPlay(id)
	end
	local p,key=pool(id)
	if not p then return end   -- 모드 첫 화면 곡이 없는 모드: 하던 곡 그대로
	local same=(id==JY.CurrentBGM and key==lastKey)
	JY.CurrentBGM=id
	lastKey=key
	if JY.EnableMusic==0 then return end
	lib.PlayMIDI(CONFIG.SoundPath..string.format("B%03d.mp3",pick(p,key,same)))
end
-- 이야기 안 화면(마을 · 도감 · 술 겨루기 ...)에서 나올 때: 하던 그 곡으로 (묶음에서 다시 고르지 않음)
local function resume(prevCtx,prevBGM,prevKey)
	ctx=prevCtx
	if not prevBGM or prevBGM<0 then return end
	if koBGMOn() and prevKey and last[prevKey] then
		JY.CurrentBGM=prevBGM lastKey=prevKey
		if JY.EnableMusic~=0 then lib.PlayMIDI(CONFIG.SoundPath..string.format("B%03d.mp3",last[prevKey])) end
	else
		PlayBGM(prevBGM)
	end
end
CC.koTitleBGM=TITLE

-- 모드 들어가는 함수 감싸기: 첫 화면 곡, 끝나고 타이틀로 돌아오면 모드 풀기. back = 끝나면 하던 곡으로 (이야기 안 화면)
local function wrap(name,mode,back)
	local f=rawget(_G,name)
	if type(f)~="function" then return end
	_G[name]=function(...)
		local prevCtx,prevBGM,prevKey=ctx,JY.CurrentBGM,lastKey
		if mode~="town" and mode~="book" and mode~="main" then ctx=mode end
		if mode=="town" then PlayBGM(TOWN) elseif mode=="main" then PlayBGM(MAIN) else PlayBGM(MENU) end
		local r={f(...)}
		if back then
			resume(prevCtx,prevBGM,prevKey)
		elseif JY.Status==GAME_START then
			ctx=nil
		end
		return table.unpack(r)
	end
end
-- 도감 · 기록 화면은 「book」 곡을 MENU 로 (모드 아님)
M.book.any=nil
local function wrapBook(name)
	local f=rawget(_G,name)
	if type(f)~="function" then return end
	_G[name]=function(...)
		local prevCtx,prevBGM,prevKey=ctx,JY.CurrentBGM,lastKey
		ctx="book"
		PlayBGM(MENU)
		local r={f(...)}
		resume(prevCtx,prevBGM,prevKey)
		return table.unpack(r)
	end
end
wrap("koMainScreen","main",false)
wrap("koFreeBattle","free",false)
wrap("koConqScreen","conquest",false)
wrap("koFoeScreen","foeside",false)
wrap("koPuzzleScreen","puzzle",false)
wrap("koPalScreen","trial",false)
wrap("FightMenu","tourney",false)
wrap("koTourneyCity","tourney",true)
wrap("koDrink","drink",true)
wrap("Game_Cycle","drink",true)   -- 짝 맞추기 (숨은 입구)
wrap("koTownVisit","town",true)
for _,n in ipairs({"koBogamScreen","koBookTitleScreen","koRecordScreen","koNewGenScreen","koGenEditScreen"}) do wrapBook(n) end

koAddon.settings[#koAddon.settings+1]={key="koBGMNew",label="\134\099\131\064 \130\077\133\118",opts={{"\134\068 \137\086",1},{"\131\081\132\118",0}},default=1,
	onchange=function() local c=JY.CurrentBGM if c and c>=0 then JY.CurrentBGM=-1 PlayBGM(c) end end}
koSetOrder.koBGMNew=9
