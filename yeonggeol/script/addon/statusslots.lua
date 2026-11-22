-- ko 6.0 (10-28): statusslots — 무장 정보창 장비 칸 (무기 · 방어구 · 보조) + 장비를 골라서 착용
-- (UTF-8 원본: 개발용/addon/statusslots_src.lua -> 도구/free_hz.pl -> script/addon/statusslots.lua, addons.lua 끝 쪽)
-- jymain PersonStatus_sub 가 koStatusSlotsDraw(pid,x,y) · koStatusSlotsHit(pid,x,y) 를 부름 (있으면 옛 「무 기 / 방 구 / 보 조」 글자 줄 대신).
-- 10-28 저녁: 칸 그리기 · 누르면 설명 (사용자 쪽에서 먼저 만든 판) → 10-28 밤 사용자 「기능 구현해줘」 · 「우리 편은 전부 수동으로」:
--   · 우리 편 무장의 칸을 누르면 원작 메뉴: 가방에서 그 칸에 낄 수 있는 도구 (지금 장비 = ●) · 「설명 보기」. 고르면 그것을 장비.
--   · 우리 편은 수동: 지금 끼고 있는 도구가 가방에 있고 쓸 수 있으면(병종 · 레벨) 계속 그대로 — 더 좋은 도구가 들어와도 바뀌지 않음.
--     칸이 비었거나 끼던 도구가 가방에서 없어지면(팔기 · 건네기 등) 그때만 원작 우선순위로 채움. 해제(빈 칸으로 두기)는 없음.
--     따로 저장하는 칸 없음 (장비 칸 武器 · 防具 · 辅助 이 세이브에 남는 것을 그대로 씀).
--   · 가방 8칸 · 오른쪽 도구 목록은 원작 그대로 (장비한 것도 가방에 있음). 우리 편이 아니면 누르면 설명만.
--   · ReSetAttrib 감싸기: 우리 편이면 칸마다 지금 장비가 유효하면 같은 칸의 다른 도구를 잠깐 가방에서 빼고 원래 계산
--     (원작 우선순위 고르기가 그 도구를 고름) → 가방 그대로 되돌림.
--     적 · 우리 편 아닌 무장은 원작 그대로 (gear 의 적 장비 빌려주기 · 난이도 규칙이 우선순위에 기대므로).
--   (같은 날 잠깐 「고른 칸만 고정」(性别 비트 · 자물쇠 · 「자동」 메뉴) 으로 만들었다가 사용자 결정으로 바꿈)
local function K(...) return string.char(...) end
local KEYS={K(206,228,198,247),K(183,192,190,223),K(184,168,214,250)}-- 武器 防具 辅助
local NAME=K(195,251,179,198)          -- 名称
local OWNER=K(215,168,202,244,204,216,188,188,200,203)-- 专属特技人
local SLOTF=K(215,176,177,184,206,187)  -- 装备位
local NEEDBZ=K(208,232,177,248,214,214) -- 需兵种 (1~7)
local NEEDLV=K(208,232,181,200,188,182) -- 需等级
local BZ=K(177,248,214,214)             -- 兵种
local LV=K(181,200,188,182)             -- 等级
local ITEM=K(181,192,190,223)           -- 道具 (1~8)
local LORD=K(190,253,214,247)           -- 君主
local LABEL={"\129\073\131\071","\132\078\130\083\130\119","\131\115\129\118"}
local EXCLUSIVE="\130\066\132\111"
-- jymain ReSetAttrib 의 koEquipAlias (local 이라 여기 베낌): 새 병종이 장비를 빌려 쓰는 원래 병종
local ALIAS={[30]=9,[31]=3,[32]=16,[33]=4,[34]=27,[35]=16,[36]=29,[37]=4}

-- ---------------------------------------------------------------- 수동 장비
local function canUse(p,iid)
	local it=JY.Item[iid]
	if not it then return false end
	local ok=(it[NEEDBZ.."1"]==0)
	if not ok then
		for n=1,7 do
			local b=it[NEEDBZ..n]
			if b==p[BZ] or (ALIAS[p[BZ]] and b==ALIAS[p[BZ]]) then ok=true break end
		end
	end
	if p[LV]<(it[NEEDLV] or 0) then ok=false end
	return ok
end
local function inBag(p,iid) for k=1,8 do if p[ITEM..k]==iid then return k end end end
local function ours(p) return p and p[LORD]==1 end
do
	local raw=ReSetAttrib
	function ReSetAttrib(id,...)
		local p=JY.Person[id]
		if not ours(p) then return raw(id,...) end
		-- 칸마다 지금 장비가 가방에 있고 쓸 수 있으면 같은 칸의 다른 도구를 잠깐 뺌 (비었거나 없어졌으면 원작대로 채움)
		local hide={}
		for s=1,3 do
			local want=p[KEYS[s]] or 0
			if want>0 and inBag(p,want) and canUse(p,want) and JY.Item[want][SLOTF]==s then
				for k=1,8 do
					local v=p[ITEM..k] or 0
					if v>0 and v~=want and JY.Item[v] and JY.Item[v][SLOTF]==s then hide[#hide+1]={k,v} p[ITEM..k]=0 end
				end
			end
		end
		if #hide==0 then return raw(id,...) end
		local r=table.pack(pcall(raw,id,...))
		for _,h in ipairs(hide) do p[ITEM..h[1]]=h[2] end
		if not r[1] then error(r[2],0) end
		return table.unpack(r,2,r.n)
	end
end

-- ---------------------------------------------------------------- 그림
local ART={}
if not rawget(_G,"koBogamList") then pcall(dofile,CONFIG.ScriptPath.."addon/bogam_data.lua") end
for k,e in ipairs(rawget(_G,"koBogamList") or {}) do
	ART[e[1]]={k,0,e[4]}
	if e[2]>0 then ART[e[2]]={k,1,e[4]} end
end
local ready=false
local EQUIPPIC=false
local function pictures()
	if ready and not CC.koBogamPic then return end
	-- 도감 그림 묶음을 30% 로 (도감은 다음에 열 때 50% 로 다시 읽음)
	CC.koBogamPic=nil
	lib.PicLoadFile(CONFIG.DataPath.."bogam.idx",CONFIG.DataPath.."bogam.grp",10,30)
	-- 10-28 밤: 일반 장비 81장 (data/equip.grp, 칸 = 도구 번호 74~154, 128px = 32px 아이콘 4배) → 그림 칸 8 에 25% (원래 32px 그대로라 또렷함)
	if fileexist(CONFIG.DataPath.."equip.grp") then lib.PicLoadFile(CONFIG.DataPath.."equip.idx",CONFIG.DataPath.."equip.grp",8,25) EQUIPPIC=true end
	ready=true
end
local function outline(x,y,slot,color)
	local function ln(a,b,c,d)
		local dx,dy=math.abs(c-a),math.abs(d-b)
		local sx,sy=(a<c and 1 or -1),(b<d and 1 or -1)
		local err=dx-dy
		while true do
			lib.FillColor(x+a,y+b,x+a+1,y+b+1,color)
			if a==c and b==d then break end
			local e=2*err
			if e>-dy then err=err-dy a=a+sx end
			if e<dx then err=err+dx b=b+sy end
		end
	end
	if slot==1 then
		for n=0,1 do ln(10+n,31,29+n,12) end
		ln(25,10,31,8) ln(31,8,30,15) ln(30,15,25,17)
		ln(8,27,15,34) ln(7,34,10,37)
	elseif slot==2 then
		local pts={{13,8},{18,8},{18,12},{24,12},{24,8},{29,8},{35,18},{30,23},{28,20},{29,35},{13,35},{14,20},{12,23},{7,18},{13,8}}
		for i=2,#pts do ln(pts[i-1][1],pts[i-1][2],pts[i][1],pts[i][2]) end
	else
		ln(11,11,31,11) ln(31,11,31,33) ln(31,33,11,33) ln(11,33,11,11)
		ln(15,11,15,33) ln(19,17,27,17) ln(19,22,27,22) ln(19,27,26,27)
	end
end
-- 11-20: 천공개물 복사본(1000~1999)은 원본 번호로 그림 · 전용 표시를 찾음 (제보 「새긴 뒤 방어구 칸이 검은색」)
local function base(iid) local f=rawget(_G,"koItemBaseId") if f then return f(iid) end return iid end
local function exclusive(iid)
	local a=ART[base(iid)]
	if a and a[3] and a[3]~="" then return true end
	local it=JY.Item[iid]
	return it and type(it[OWNER])=="string" and it[OWNER]~=""
end
local function slotXY(x,y,i) return x+184+(i-1)*48,y+216 end
function koStatusSlotsDraw(pid,x,y)
	local p=JY.Person[pid]
	pictures()
	for i,key in ipairs(KEYS) do
		local sx,sy=slotXY(x,y,i)
		local iid=p[key] or 0
		DrawString(sx+22-#LABEL[i]*3,sy-14,LABEL[i],M_White,12)
		lib.FillColor(sx,sy,sx+44,sy+44,RGB(6,12,30))
		DrawBox(sx,sy,sx+44,sy+44,RGB(179,145,70),-1)
		DrawBox(sx+2,sy+2,sx+42,sy+42,RGB(34,89,165),-1)
		local bid=base(iid)
		local a=ART[bid]
		if iid>0 and JY.Item[iid] then
			if a then
				lib.SetClip(sx+3,sy+3,sx+41,sy+41)
				lib.PicLoadCache(10,((a[1]-1)*3+a[2])*2,sx+3,sy+3,1)
				lib.SetClip(0,0,0,0)
			elseif EQUIPPIC and bid>=74 and bid<=154 then
				lib.PicLoadCache(8,bid*2,sx+6,sy+6,1)
			else
				-- 그림 없는 도구: 이름을 그대로
				local nm=JY.Item[iid][NAME] or ""
				for row=1,3 do local s=string.sub(nm,(row-1)*6+1,row*6) if s~="" then DrawString(sx+4,sy+4+(row-1)*12,s,M_White,12) end end
			end
			if exclusive(iid) then
				lib.FillColor(sx+20,sy+31,sx+41,sy+41,RGB(72,49,12))
				DrawString(sx+20,sy+30,EXCLUSIVE,M_Yellow,10)
			end
		else outline(sx,sy,i,RGB(83,93,115)) end
	end
	DrawBox(x+334,y+124,x+444,y+264,RGB(50,177,206),-1)
	DrawBox(x+336,y+126,x+442,y+262,RGB(32,79,153),-1)
	-- 10-28 밤 사용자: 마우스를 올린 칸의 이름 상자 · 노란 테두리는 뺌 (MOUSE.x/y 는 마지막 위치라, 정보창을 연 자리가 칸과 겹치면 올리지 않아도 떠 있었음)
end
-- 칸을 누르면: 우리 편은 고르기 메뉴, 아니면 설명
local function choose(pid,i,sx,sy)
	local p=JY.Person[pid]
	local cur=p[KEYS[i]] or 0
	local menu,act={},{}
	local seen={}
	for k=1,8 do
		local v=p[ITEM..k] or 0
		if v>0 and not seen[v] and JY.Item[v] and JY.Item[v][SLOTF]==i and canUse(p,v) then
			seen[v]=true
			local mark=(v==cur) and "\161\241 " or ""
			menu[#menu+1]={fillblank(mark..JY.Item[v][NAME],15),nil,(v==cur) and 2 or 1}
			act[#menu]=v
		end
	end
	if cur>0 and JY.Item[cur] then menu[#menu+1]={"\129\069\130\088 \131\115\131\071",nil,1} act[#menu]="info" end
	-- 낄 수 있는 도구가 하나도 없으면(빈 방어구 칸 등) 원작 메뉴가 0줄로 열려 아무것도 안 그린 채 멈춤 (10-28 밤 「반짝 떴다 사라짐」) → 안내 한 줄
	if #menu==0 then menu[1]={"\129\094\132\078\129\102 \143\079 \129\113 \132\079\130\098 "..LABEL[i].." \130\097\130\077",nil,1} act[1]="none" end
	-- 칸을 누른 클릭이 메뉴로 넘어가면 메뉴가 「밖을 누름」으로 받아 바로 닫힘 (10-28 밤 「반짝 떴다 사라짐」) → 마우스 상태를 비우고 띄움
	koMouseReset() MOUSE.status='IDLE' lib.GetKey()
	local r=ShowMenu(menu,#menu,0,math.min(sx,CC.ScreenW-200),math.max(16,sy-24*#menu-12),0,0,3,1,16,M_White,M_White)
	MOUSE.koSwallowR=true MOUSE.status='IDLE'-- 메뉴를 닫은 오른쪽 누름이 정보창까지 닫지 않게
	local a=act[r]
	if a=="info" then
		DrawItemStatus(cur,pid)
	elseif type(a)=="number" then
		p[KEYS[i]]=a pcall(ReSetAttrib,pid,false)
	end
end
function koStatusMenuT(pid,i,sx,sy) choose(pid,i,sx,sy) end-- for test scripts
function koStatusSlotsHit(pid,x,y)
	local p=JY.Person[pid]
	for i,key in ipairs(KEYS) do
		local sx,sy=slotXY(x,y,i)
		local iid=p[key] or 0
		if MOUSE.CLICK(sx,sy,sx+44,sy+44) then
			-- 이 클릭을 여기서 소모: 남아 있으면 뜨는 설명 창이 같은 클릭을 「닫기」로 받아 반짝 떴다 사라짐 (10-28 밤 제보)
			MOUSE.status='IDLE' koMouseReset()
			if ours(p) then
				PlayWavE(0) choose(pid,i,sx,sy) return true
			elseif iid>0 and JY.Item[iid] then
				PlayWavE(0) DrawItemStatus(iid,pid) return true
			end
		end
	end
	return false
end
function koStatusChooseT(pid,i,v)-- for test scripts: 고르기 메뉴 없이 도구 번호 v 를 장비
	local p=JY.Person[pid]
	p[KEYS[i]]=v
	pcall(ReSetAttrib,pid,false)
end
-- 설명 창(DrawStrStatus)은 창 안을 누르면 다음 쪽 · 닫기라, 여는 클릭이 남아 있으면 바로 닫힘 (정보창 칸 · 오른쪽 도구 목록 모두) → 열 때 남은 클릭을 비움
do
	local rawDIS=DrawItemStatus
	function DrawItemStatus(...)
		if MOUSE.status=='CLICK' then MOUSE.status='IDLE' end
		koMouseReset()
		return rawDIS(...)
	end
end
-- 오른쪽 도구 목록: 장비 중인 도구 이름을 노란색으로 (10-28 밤 사용자, 처음엔 「장착」 배지였다가 이름 색으로 바꿈). 목록은 원작이 장비 칸보다 나중에 그리므로 PersonStatus_sub 를 감싸 맨 끝에
do
	local rawSub=PersonStatus_sub
	if type(rawSub)=="function" then
		function PersonStatus_sub(pid,x,y,...)
			local r=table.pack(rawSub(pid,x,y,...))
			pcall(function()
				x=x or 208 y=(y or 72)+koAwakeDY(pid)
				local p=JY.Person[pid]
				local left={}
				for _,key in ipairs(KEYS) do local v=p[key] or 0 if v>0 then left[v]=(left[v] or 0)+1 end end
				for i=1,8 do
					local v=p[ITEM..i] or 0
					if v>0 and (left[v] or 0)>0 then
						left[v]=left[v]-1
						-- 같은 자리에 노란 글씨로 덧그림 (10-28 밤 사용자: 배지 대신 이름만 노란색)
						DrawString(x+340,y+112+i*16,JY.Item[v][NAME],M_Yellow,16)
					end
				end
			end)
			return table.unpack(r,1,r.n)
		end
	end
end
local original=PersonStatus
function PersonStatus(...)
	ready=false
	local r=table.pack(pcall(original,...))
	ready=false CC.koBogamPic=nil
	if not r[1] then error(r[2],0) end
	return table.unpack(r,2,r.n)
end
-- 직접 미리보기도 PersonStatus_sub 를 부르고, 불러오기는 그림 칸을 비움
local originalLoad=LoadRecord
if type(originalLoad)=="function" then
	local SEXF=K(208,212,177,240)-- 性别
	function LoadRecord(...)
		ready=false
		local r=table.pack(originalLoad(...))
		-- 10-28 밤 잠깐 쓴 「고른 칸 고정」 비트(性别 256 · 512 · 1024)가 그때 저장된 세이브에 남아 있으면 지움 (지금은 쓰지 않음, 성별은 0/1)
		pcall(function() for i=1,JY.PersonNum-1 do local v=JY.Person[i][SEXF] or 0 if v>=256 then JY.Person[i][SEXF]=v%256 end end end)
		return table.unpack(r,1,r.n)
	end
end
