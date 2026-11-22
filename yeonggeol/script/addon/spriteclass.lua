-- ko 5.0 spriteclass (10-11): battle sprites taken from 성삼국촉한전 6.1 for generals that had none (installed into the
-- unique addon list by SetWarSprite), and each of them gets a class that matches the sprite.
--  kind: S foot sword, P spear, B bow/crossbow, H cavalry, HA mounted archer (돌기병), M strategist, MS strategist with sword.
--  An enemy row keeps its class when the class already fits the sprite; otherwise it moves to the matching family and keeps
--  the tier (1~3) of the old class (a single class takes the tier most common among the other rows of the same battle).
--  Person records (allies, tavern copies, old saves) are fixed the same way when a record is loaded.
--  Tiered sets (조홍·유봉·진도·미방·간옹): tier 1 at the normal unique slot, tiers 2·3 at wmap 20000+(602+2k+tier-2)*50.
local KIND={
[7]="M",[8]="M",[12]="H",[14]="H",[16]="M",[21]="S",[22]="H",[24]="H",[26]="H",[28]="H",[29]="B",[32]="S",[33]="H",
[37]="S",[38]="M",[39]="S",[42]="H",[44]="H",[45]="H",[46]="P",[47]="H",[48]="H",[50]="M",[51]="MS",[55]="M",[56]="MS",
[57]="M",[60]="H",[61]="P",[62]="MS",[63]="H",[66]="MS",[67]="H",[69]="MS",[72]="H",[74]="H",[75]="H",[76]="MS",[77]="M",
[78]="M",[81]="S",[84]="S",[87]="H",[88]="HA",[89]="S",[91]="B",[92]="H",[93]="MS",[94]="H",[95]="MS",[96]="H",[98]="H",
[101]="MS",[102]="H",[104]="HA",[106]="S",[108]="B",[109]="S",[110]="P",[112]="H",[113]="H",[114]="M",[115]="H",[120]="M",
[121]="MS",[122]="H",[123]="H",[124]="H",[125]="HA",[130]="S",[131]="S",[134]="S",[136]="H",[138]="H",[139]="H",[140]="HA",
[141]="H",[144]="M",[145]="M",[146]="MS",[147]="MS",[148]="S",[149]="H",[153]="H",[157]="M",[158]="B",[162]="S",[165]="P",
[166]="HA",[167]="H",[169]="M",[171]="H",[172]="M",[173]="H",[174]="S",[175]="M",[176]="M",[177]="P",[178]="H",[179]="S",
[180]="P",[181]="H",[182]="B",[183]="S",[184]="H",[188]="MS",[189]="MS",[191]="B",[193]="MS",[195]="B",[197]="P",[198]="P",
[199]="S",[200]="H",[201]="S",[202]="H",[203]="B",[206]="S",[208]="S",[209]="S",[210]="CAT",[211]="S",[212]="H",[213]="H",
[215]="HA",[217]="P",[218]="H",[221]="S",[222]="H",[223]="H",[224]="S",[228]="H",[229]="S",[239]="MS",[242]="H",[248]="S",
[249]="H",[250]="M",[251]="M",[252]="S",[254]="P",[255]="M",[378]="M",
[20]="B",[117]="B",[402]="B",[82]="HA",[83]="B",   -- 10-13 간옹: 삼국지11 궁병 1~3단 조형으로 바꾸며 궁병 계열
[65]="BAND",[64]="SUP",   -- 10-11 삼국지11 조형 (미축 피리·손건 수레)
-- 10-11 user: 유표·곽준 단병 계열, 진식 창병, 하후상 경기병(발석거여도 바꿈), 유엽 발석거 그림(발석거), 서서 격검 그림(요술사 고정)
-- 10-19 user (카페 제보 「와구관II 보너스 목표 발석거(하후상)인데 친위대」): 하후상 다시 발석거, 전투 조형 = 사용자 제공 문빙 발석거 BMP
--  (unique koUniqueBz[210][21] = wmap 50600, 발석거는 공통 고유 조형을 안 쓰므로 병종 세트로)
[95]="S1",[208]="S1",[209]="P",[210]="CAT",[402]="B",[101]="CAT",[112]="SORC",
-- 10-13 user: 왕보 새 전투 조형(사용자 제공 BMP) + 단병 계열
[38]="S1",
-- 10-20 user: 이명 맹수사 (조형 = 금도대장군 이명 BMP), 조하 산적 계열 (조형 = 287 조하 BMP); newgame 병종도 14 · 10 으로 바꿈
[376]="BEAST",[224]="BAN",
}
koSpriteKind=KIND
local TIERSET={[20]=0,[117]=1,[402]=2,[82]=3,[83]=4}
-- classes that already fit each kind
local FIT={
S={[1]=1,[2]=1,[3]=1,[10]=1,[11]=1,[12]=1,[14]=1,[15]=1,[17]=1,[18]=1},
P={[23]=1,[24]=1,[25]=1},
B={[4]=1,[5]=1,[6]=1},
H={[7]=1,[8]=1,[9]=1},
HA={[22]=1},
M={[13]=1,[16]=1,[19]=1,[26]=1,[27]=1},
MS={[13]=1,[16]=1,[19]=1,[26]=1,[27]=1,[1]=1,[2]=1,[3]=1},
BAND={[13]=1},
SUP={[19]=1},
S1={[1]=1,[2]=1,[3]=1},
CAT={[21]=1},
SORC={[16]=1},
BEAST={[14]=1},
BAN={[10]=1,[11]=1,[12]=1},
}
local BASE={S=0,S1=0,P=22,B=3,H=6,BAN=9}          -- family first class - 1 (tier 1..3 added)
local SINGLE={HA=22,M=26,MS=26,BAND=13,SUP=19,CAT=21,SORC=16,BEAST=14}
-- a catapult row (21) keeps the catapult, except these (user asked for their own class)
local FORCE21={[95]=1,[208]=1,[209]=1,[112]=1}
local function tierOf(bz)
	if bz>=1 and bz<=12 then return (bz-1)%3+1 end
	if bz>=23 and bz<=25 then return bz-22 end
	return nil
end
local function fit(kind,bz,tier)
	if FIT[kind][bz] then return bz end
	if SINGLE[kind] then return SINGLE[kind] end
	return BASE[kind]+(tierOf(bz) or tier or 1)
end
koSpriteFit=fit
local BZ="\177\248\214\214"                   -- class
local LV="\181\200\188\182"                   -- level
local NM="\208\213\195\251"                   -- name
local FACE="\205\183\207\241\180\250\186\197" -- portrait
local SPR="\213\189\182\183\182\175\215\247"  -- battle sprite
-- tavern copies (421+) take the kind of the listed person with the same name and portrait
local KEY=nil   -- name:portrait -> listed pid (built once per load)
-- 군웅록 (11-03): in a story (CONFIG.koCamp) a person stands for a 영걸전 person through koWujeIdentity (the same map unique uses
--  for the sprites), so the kind is looked up by that id; copies 421+ by name+portrait among the story's own records
local function campWI() return CONFIG.koCamp and rawget(_G,"koWujeIdentity") or nil end
local function src(pid)
	local ps=rawget(_G,"koGenPrivSlot") local pv=ps and ps(pid)-- 11-08: an officer with his own edited slot (newgen) keeps his class, like kindOff
	if pv and ((rawget(_G,"koUniqueWar") and koUniqueWar[pv]) or (rawget(_G,"koUniqueBz") and koUniqueBz[pv] and next(koUniqueBz[pv]))) then return nil end
	local wi=campWI()
	if wi then
		local id=wi(pid)
		if id and KIND[id] then return id end
		if pid<=420 then return nil end
		local p=JY.Person[pid]
		if not p then return nil end
		if not KEY then
			KEY={}
			for q=1,math.min(420,(JY.PersonNum or 1)-1) do
				local i=wi(q)
				local r=i and KIND[i] and JY.Person[q]
				if r then KEY[tostring(r[NM])..":"..tostring(r[FACE])]=i end
			end
		end
		return KEY[tostring(p[NM])..":"..tostring(p[FACE])]
	end
	if KIND[pid] then return pid end
	if pid<=420 then return nil end
	local p=JY.Person[pid]
	if not p then return nil end
	if not KEY then
		KEY={}
		for s in pairs(KIND) do
			local q=JY.Person[s]
			if q then KEY[tostring(q[NM])..":"..tostring(q[FACE])]=s end
		end
	end
	return KEY[tostring(p[NM])..":"..tostring(p[FACE])]
end
-- enemy rows: {pid-1,x,y,d,ai,lv,bz,tx,ty,cond,hide} flat
-- 10-17 cafe report (5.1.8): 여남 battle (chapter 2) 조순 (row bow 5) became cavalry for his sprite. He reached his bridge, then
--  from turn 4 (WarModifyAI 1) had to cross the forest above it, closed to cavalry (47 cells around against 11 for a bow), and
--  stood there as a sandbag. A row keeps its own class when the sprite's class reaches clearly less of the map from its start
--  (a cell is closed to a class when its terrain cost is 0 or more than the class's whole move); the picture is then the class's
--  common one (GetPic).
local K_DX,K_MOV="\181\216\208\206","\210\198\182\175"-- terrain cost, move
-- cells a class can walk to from (x,y) on this battle's map (nil when there is no map yet), and whether (tx,ty) or a cell
-- next to it is one of them
local function reach(bz,x,y,tx,ty)
	local W,D=War and War.Width,War and War.Depth
	local B=JY.Bingzhong and JY.Bingzhong[bz]
	if not (W and D and War.Map and War.Map[1] and B) then return nil end
	if x<1 or y<1 or x>W or y>D then return nil end
	local mv=B[K_MOV] or 0
	local seen={[(y-1)*W+x]=true}
	local q,h,n,hit={x,y},1,1,false
	while h<#q do
		local cx,cy=q[h],q[h+1] h=h+2
		if tx and math.abs(cx-tx)+math.abs(cy-ty)<=1 then hit=true end
		for d=1,4 do
			local nx,ny=cx+CC.DirectX[d],cy+CC.DirectY[d]
			if nx>=1 and ny>=1 and nx<=W and ny<=D and not seen[(ny-1)*W+nx] then
				seen[(ny-1)*W+nx]=true
				local c=B[K_DX..GetWarMap(nx,ny,1)]
				if c and c>0 and c<=mv then q[#q+1]=nx q[#q+1]=ny n=n+1 end
			end
		end
	end
	return n,hit
end
-- keep the row's own class instead of the sprite's? Only a row that walks to a target cell (ai 4/6): it ends up fighting from
-- there, so when the sprite's class reaches less than 85% of what the own class reaches from that cell (or cannot get to it),
-- the own class stays. (Every other row keeps the sprite's class, cavalry on a forest map included: 56 of the 186 converted
-- rows would fall under the 85% rule from their start, which undoes the 10-11 sprite classes.)
local function keepOwn(own,nb,x,y,ai,tx,ty)
	if own==21 or not (ai==4 or ai==6) or not tx or tx<1 or ty<1 then return false end   -- a catapult row here was moved on purpose (FORCE21)
	local n1,h1=reach(own,x,y,tx,ty)
	local n2,h2=reach(nb,x,y,tx,ty)
	if not (n1 and n2) then return false end
	if h1 and not h2 then return true end
	local m1,m2=reach(own,tx,ty),reach(nb,tx,ty)
	return m1 and m2 and m2<m1*0.85 or false
end
koSpriteReach,koSpriteKeepOwn=reach,keepOwn
local se=SelectEnemy
function SelectEnemy(T)
	if type(T)=="table" then
		local mt=1   -- untiered old class -> tier 1, the engine promotes enemies at level 15 / 30 (zongheng) right after
		for i=1,99 do
			local idx=(i-1)*11
			if T[idx+11]==nil then break end
			local p=T[idx+1] and T[idx+1]>=0 and T[idx+1]+1
			if p and campWI() then p=src(p) end   -- 군웅록: a story row stands for its 영걸전 person
			local k=p and KIND[p]
			if k and (T[idx+7]~=21 or FORCE21[p]) then
				local nb=fit(k,T[idx+7],mt)
				local ai=T[idx+5]
				-- 10-17: keep the own class where the sprite's class is shut out of much of the map (see keepOwn)
				if nb~=T[idx+7] and keepOwn(T[idx+7],nb,T[idx+2]+1,T[idx+3]+1,ai,T[idx+8]+1,T[idx+9]+1) then nb=T[idx+7] end
				T[idx+7]=nb
			end
		end
	end
	return se(T)
end
-- person records
-- 10-16: a general of ours (君主 1) keeps a class the player gave him (둔갑천서 and the other class books); only his newgame class
-- (old saves, untouched records) is still fitted to the sprite. Report: 손건 보급대 -> 둔갑천서 -> 보급대 again next battle.
local LORD="\190\253\214\247"
local ORIG=nil   -- pid -> newgame class (read once)
-- 10-20: an ally from before the change still has the old newgame class (이명 단병, 조하 궁병 → 단병): fit him too
local OLDNG={[376]={[1]=true},[224]={[4]=true,[1]=true}}
local function origBz(s,pid)
	if campWI() then   -- 군웅록: the story's own newgame record of this person
		return JY.Data_Person_Base and pid and GetDataFromStruct(JY.Data_Person_Base,pid*CC.PersonSize,CC.Person_S,BZ) or nil
	end
	if not ORIG then
		ORIG={}
		pcall(function()
			local d=Byte.create(4)
			Byte.loadfile(d,CC.R_IDXFilename[0],0,4)
			local n=0
			for q in pairs(KIND) do if q>n then n=q end end
			local b=Byte.create(CC.PersonSize*(n+1))
			Byte.loadfile(b,CC.R_GRPFilename[0],Byte.get32(d,0),CC.PersonSize*(n+1))
			for q in pairs(KIND) do ORIG[q]=GetDataFromStruct(b,q*CC.PersonSize,CC.Person_S,BZ) end
		end)
	end
	return ORIG[s]
end
function koSpriteClassFix()
	if not JY.Person then return end
	-- 10-20 (카페 제보 「여남 조순 기병이 숲을 다님」): a battle save is loaded with its units' classes already set by SelectEnemy
	--  (keepOwn rows like 조순 노병); WarLoad has read them before this runs, so leave the records of everyone in that battle alone,
	--  or the record (sprite, moves, the next save) turns back to the sprite's class
	local inWar={}
	if JY.Status==GAME_WMAP and War and War.Person then for _,v in pairs(War.Person) do if v and v.id then inWar[v.id]=true end end end
	for pid=1,(JY.PersonNum or 0)-1 do
		local s=src(pid)
		if inWar[pid] then s=nil end
		local p=JY.Person[pid]
		if s and p and p[LORD]==1 and p[BZ]~=origBz(s,pid) and not (not campWI() and OLDNG[s] and OLDNG[s][p[BZ]]) then s=nil end
		-- 군웅록 11-16 (카페 제보 1.0.34 「곽가를 요술사로 바꿔도 단병으로」): 이야기 모드의 우리 편은 처음 병종 옮기기를 battle_visuals 가
		--  무장마다 한 번 하고 기억함(koWujeClassDone). 그 뒤 플레이어가 처음 병종(곽가 요술사)으로 되돌려 놓으면 여기서 「안 바꾼 병종」 으로 보고
		--  조형 병종(단병)으로 다시 맞췄음 → 이미 옮긴 무장은 건드리지 않음
		if s and p and p[LORD]==1 and campWI() then local cd=rawget(_G,"koWujeClassDone") local dn=cd and cd() if dn and dn[pid] then s=nil end end
		if s and p and p[BZ] and p[BZ]>0 and (p[BZ]~=21 or FORCE21[s]) then
			local lv=p[LV] or 1
			local t=(lv<15 and 1) or (lv<30 and 2) or 3   -- same levels as the engine's enemy promotion
			p[BZ]=fit(KIND[s],p[BZ],t)
		end
	end
	-- 10-20 (「이숙 같은 경우」 점검): 관우 외전 tavern generals 391~396 (공수·한복·맹탄·변희·왕식·진기) in an older save keep the class
	--  of an older newgame (한복·왕식 궁병, now 돌기병·창병, as the 도감 says): not hired yet, a class of another family goes back
	local function famOf(b) if b>=1 and b<=12 then return math.floor((b-1)/3) end if b>=23 and b<=25 then return 100 end return 200+b end
	if JY.Data_Person_Base and (JY.PersonNum or 0)>396 and not campWI() then
		for pid=391,396 do
			local p=JY.Person[pid]
			local nb=GetDataFromStruct(JY.Data_Person_Base,pid*CC.PersonSize,CC.Person_S,BZ)
			if p and p[LORD]~=1 and nb and nb>0 and p[BZ] and famOf(p[BZ])~=famOf(nb) then p[BZ]=nb end
		end
	end
end
do
	local lr=rawget(_G,"LoadRecord")
	if type(lr)=="function" then
		function LoadRecord(...)
			local r=lr(...)
			KEY=nil rawset(_G,"koUniqueKey",nil)
			pcall(koSpriteClassFix)
			return r
		end
	end
end
-- tiered sets
local gp=GetPic
function GetPic(pid,enemy,friend)
	local r=gp(pid,enemy,friend)
	if rawget(_G,"koUniqueBzPic") and koUniqueBzPic(pid) then return r end-- 10-13: a 장수편집 class set wins over the tiered sets
	local s=src(pid)
	-- 10-16: a class the sprite cannot show (one the player gave him) is drawn with that class's common sprite
	local kd=s and KIND[s]
	local cbz=JY.Person[pid][BZ]
	if kd and cbz and cbz>0 and cbz~=21 and not FIT[kd][cbz] then
		r=GetBZPic(pid,enemy,friend)
		JY.Person[pid][SPR]=r
		return r
	end
	local k=s and TIERSET[s]
	if k and JY.Person[pid][BZ]~=21 then
		local bz=JY.Person[pid][BZ]
		local lv=tierOf(bz)
		if not lv or bz>12 then
			local l=JY.Person[pid][LV] or 1
			lv=(l<20 and 1) or (l<40 and 2) or 3
		end
		if lv>=2 then
			r=20000+(602+2*k+lv-2)*50
			JY.Person[pid][SPR]=r
		end
	end
	if s==101 and JY.Person[pid][BZ]==21 then
		r=20000+101*50   -- 유엽: his own catapult sprite (unique keeps the common catapult for class 21)
		JY.Person[pid][SPR]=r
	end
	return r
end
-- 10-11: a tavern general (copy 421+) comes at the team's level but kept the base record's first-tier class; promote him the
-- way the engine promotes enemies (level 15 -> tier 2, 30 -> tier 3) for the tiered families. Never demotes; after hiring the
-- usual item promotion applies. Runs in the tavern's lock check (called for each slot not hired yet, right after the copy).
local PROMO={[1]=2,[4]=5,[7]=8,[10]=11,[23]=24,[2]=3,[5]=6,[8]=9,[11]=12,[24]=25}
local NEED={[1]=15,[4]=15,[7]=15,[10]=15,[23]=15,[2]=30,[5]=30,[8]=30,[11]=30,[24]=30}
function koTavernPromote(i,any)   -- any: 10-20, a story general offered by the storyhire tavern (his own record, below 421)
	local p=i and (i>420 or any) and JY.Person[i]
	if not p or p[BZ]==nil or p["\190\253\214\247"]==1 then return end   -- 君主 1 = already hired
	local lv=p[LV] or 1
	local bz=p[BZ]
	while PROMO[bz] and lv>=NEED[bz] do bz=PROMO[bz] end
	if bz~=p[BZ] then
		p[BZ]=bz
		ReSetAttrib(i,true)
		p[SPR]=GetPic(i,false,false)
	end
end
koOn("tavern_slot_lock",function(i) pcall(koTavernPromote,i) return nil end)
