-- ko 6.0 (10-28): gear — 무장 전용 보물 4단계 (설계: 개발용/문서/무장 전용 보물 설계안.md 7 · 6-3)
-- (UTF-8 원본: 개발용/addon/gear_src.lua -> 도구/free_hz.pl -> script/addon/gear.lua, addons.lua 에서 storyhire · awaken 뒤, recsave 앞)
-- 데이터 = script/addon/gear_data.lua (koGearData, 도구/전용보물_데이터lua.pl 이 자료/전용보물_번호.tsv 에서 만듦): {무장, 원본, ★(0 없음), 조건, 수, 각성 특기, 대사}
--
-- 1. 합류 지급: 그 무장이 우리 편이 되면 (ModifyForce 1 · 전투 뒤 · 불러온 뒤 훑기) 자기 전용 보물을 가방에 (차면 창고). 회차마다 한 번,
--    이미 아군 · 창고에 있으면 주지 않음 (지급 비트 = 인물 칸 786 · 787).
-- 2. 적 일시 장비: 2회차부터 적으로 나온 무장이 자기 전용 보물을 듦 (전투 시작에 가방 빈칸에 넣고, 전투 끝 · 전투 밖 불러오기 때 거둠).
--    10-28 밤부터 2회차 또는 도전 난이도 5 이상 (9 이상이면 ★). 적도 주인이라 전용 특기가 켜짐.
--    전투 중에 설득 · 합류하면 들고 있던 그 보물이 바로 지급분이 됨.
-- 3. 각성: 주인이 원본을 장비하고 싸워 조건(격파 · 책략으로 격파 · 들고 이긴 전투)을 채우면 이긴 전투 끝(war_won)에 가방 속 원본을 ★ 으로,
--    ★ 을 주인이 들면 각성 특기 (koLinkSkill 감싸기). 진행은 원본 설명 끝 「각성: …」. 세는 곳 = 이야기 · 외전 · 시련 (자유 · 마을 · 다시 전투 제외) · 정벌(10-29, 판 한정 = 자유 전투 임시 기록, 조건 수 절반).
--    저장: 누적 = 인물 칸 788~797 (8비트씩, 120 상한), 이번 전투 = 798 · 799 (번호*64+수), 셈 켬 = 800. 모두 storyhire 예비 칸(君主 0)의 안전한 칸(외호 · 136~150).
-- 10-28 저녁 사용자: 「원작 명품」 을 따로 두지 않고 전용 보물로 합침 — 관우 청룡언월도(13→218) · 장비 장팔사모(16→219) · 여포 방천화극(15→220)
--    · 유비 자웅쌍검(58→221) · 하후은 청강검(11→222, 조운은 함께 쓰는 줄: 들면 파진, 자기 조건으로 각성 · 강행). awaken 애드온은 끔.
--    조건 4 격파일기토(장비: 격파 수 + 일기토 덧, 일기토 누적 = 칸 번호 300 자리) · 5 한전투격파(조운: 한 전투 덧 격파를 수 번).
--    옛 awaken 진행(인물 칸 784)은 불러올 때 한 번 옮기고 지움.
-- 10-28 밤 사용자: 원작 보물 여섯(의천검 10 · 청강검 11 · 청룡언월도 13 · 방천화극 15 · 장팔사모 16 · 자웅쌍검 58)도 새 칸 770~775 로 옮겨
--    다른 전용 보물과 한 규칙 (번호표 옛번호 → koGearMove). 옛 칸은 은퇴: 이야기 대본 · newgame 가방 · enemygear 는 새 번호를 쓰고,
--    옛 세이브는 불러올 때 모든 기록(창고 포함)의 옛 번호를 새 번호로. 이야기 사건이 주는 전용 보물(GetItem · WarGetItem)은
--    이미 지급했거나 우리 편이 가졌으면 건너뛰고, 처음 주면 지급 비트를 세움 (합류 지급과 사건이 겹쳐 둘이 되지 않게).
--    (같은 날 저녁의 「빌려준 기록」(인물 칸 785) 장치는 없앰 — 모든 전용 보물을 번호로 거둠.)

pcall(dofile,CONFIG.ScriptPath.."addon/gear_data.lua")
if type(rawget(_G,"koGearData"))~="table" then return end
local D=koGearData
local NAME=string.char(208,213,195,251)      -- 姓名
local LORD=string.char(190,253,214,247)      -- 君主
local ITEM=string.char(181,192,190,223)      -- 道具 (..1~8)
local EQUIP={string.char(206,228,198,247),string.char(183,192,190,223),string.char(184,168,214,250)}-- 武器 防具 辅助
local DESC=string.char(203,181,195,247)      -- 说明
local INAME=string.char(195,251,179,198)     -- 名称
local HP=string.char(177,248,193,166)        -- 兵力
local WARSAVE=string.char(213,189,179,161,180,230,181,181)-- 战场存档
local PS=CC.PersonSize
local W15={24,26,28,30,32,34,36,136,138,140,142,144,146,148,150}
local S_GIFT={786,787}
local S_CNT={788,789,790,791,792,793,794,795,796,797}
local S_TMP={798,799}
local S_ON=800
local BYNAME,BYITEM,BYSTAR,ROWS={},{},{},{}
-- 함께 쓰는 줄(e[9]>0, 조운)은 BYNAME 에만 (도구 → 줄은 주인 줄)
-- 10-28 밤: 기존 전용 보물(원본 < 223: 3.6~4.0 의 초진창 · 팔진서 등 16개)의 ★ 줄은 「각성만」 — 합류 지급 · 적에게 빌려주기 · 거두기 · 이야기 지급 셈에서 빠짐
--   (얻는 길은 예전 그대로), 한 무장이 두 줄(항우 · 유방): ROWS[이름] = 줄 목록, BYNAME = 첫 줄
for k,e in ipairs(D) do
if not BYNAME[e[1]] then BYNAME[e[1]]=k end
ROWS[e[1]]=ROWS[e[1]] or {} table.insert(ROWS[e[1]],k)
if (e[9] or 0)==0 and e[2]>=223 then BYITEM[e[2]]=k if e[3]>0 then BYSTAR[e[3]]=k end end
end
local function awOnly(e) return e[2]<223 end
local MOVE=rawget(_G,"koGearMove") or {}-- 옛 번호 → 새 번호
local DUELK=300-- 일기토 누적 자리 (cnt · tmp 의 마지막 칸, 줄 번호와 겹치지 않음)
function koGearIndexT(name) return BYNAME[name] end-- for test scripts

local function have() return (JY.PersonNum or 0)>801 end
local function dlv() return (rawget(_G,"koDiffLv") and koDiffLv()) or 0 end-- 도전 난이도 (diff 애드온): 5 모든 적장 전용 보물 · 9 모든 적장 ★
local function ownerRow(k) return k and (D[k][9] or 0)==0 end
local function raw(i,o) return Byte.get16(JY.Data_Person,i*PS+o) end
local function setraw(i,o,v) Byte.set16(JY.Data_Person,i*PS+o,math.floor(v)) end
local function cyc() local ng=CC.koNG return (ng and ng.rcycle and ng.rcycle()) or 1 end
local function active() return have() and not CC.koFree and not CC.koTownBattle and not CC.koReplay end

-- 지급 비트 (k = 1..)
local function gotGift(k)
local n=k-1
local s=S_GIFT[math.floor(n/225)+1] local w=W15[math.floor((n%225)/15)+1]
return math.floor(raw(s,w)/2^(n%15))%2==1
end
local function setGift(k)
if gotGift(k) then return end
local n=k-1
local s=S_GIFT[math.floor(n/225)+1] local w=W15[math.floor((n%225)/15)+1]
setraw(s,w,raw(s,w)+2^(n%15))
end
-- 11-10 카페 제보 (2회차 관우 외전에서 장비가 떠났다 돌아오니 장팔사모 ★ 이 원본으로, 여포도): 각성한 ★ 표시 1비트씩
--  (인물 칸 785 의 W15 15칸 + 784 의 136~150 8칸 = 345 · 784 의 24~36 은 옛 awaken 자리라 쓰지 않음). 이 표시가 있는 ★ 은
--  주인이 우리 편이 아닐 때도(떠남 · 지난 회차에서 이어 옴) takeBack 이 원본으로 바꾸지 않고, 적으로 나오는 전투 동안만 원본(끝나면 ★).
--  세우는 곳: 각성할 때 · 불러올 때와 전투 끝 우리 편(창고 포함)이 든 ★ · 회차를 넘길 때 이어진 ★.
local W8={136,138,140,142,144,146,148,150}
local function earnPos(k) local n=k-1 local a=math.floor(n/15) if a<15 then return 785,W15[a+1],n%15 end a=a-15 if a<8 then return 784,W8[a+1],n%15 end end
local function earned(k) local s,w,b=earnPos(k) if not s then return false end return math.floor(raw(s,w)/2^b)%2==1 end
local function setEarned(k) local s,w,b=earnPos(k) if s and not earned(k) then setraw(s,w,raw(s,w)+2^b) end end
function koGearEarnedT(k) return earned(k) end-- for test scripts
-- 누적 (8비트)
local function cntPos(k) local n=k-1 return S_CNT[math.floor(n/30)+1],W15[math.floor((n%30)/2)+1],n%2 end
local function cnt(k) local s,w,b=cntPos(k) return math.floor(raw(s,w)/256^b)%256 end
local function setCnt(k,v)
v=math.max(0,math.min(120,v))
local s,w,b=cntPos(k)
local o=raw(s,w)
setraw(s,w,o-cnt(k)*256^b+v*256^b)
end
function koGearStateT(k) return cnt(k),gotGift(k) end-- for test scripts
function koGearSetCntT(k,v) setCnt(k,v) end-- for test scripts
-- 이번 전투 (번호*64+수, 30쌍)
local function tmpGet(k)
for _,s in ipairs(S_TMP) do for _,w in ipairs(W15) do local v=raw(s,w) if v>0 and math.floor(v/64)==k then return v%64,s,w end end end
return 0
end
local function tmpAdd(k)
local c,s,w=tmpGet(k)
if s then setraw(s,w,k*64+math.min(63,c+1)) return end
for _,s2 in ipairs(S_TMP) do for _,w2 in ipairs(W15) do if raw(s2,w2)==0 then setraw(s2,w2,k*64+1) return end end end
end
local function tmpClear() for _,s in ipairs(S_TMP) do for _,w in ipairs(W15) do setraw(s,w,0) end end end

local function pname(pid) return JY.Person[pid] and JY.Person[pid][NAME] or "" end
local function iname(it) return (JY.Item[it] and JY.Item[it][INAME]) or "" end
-- 11-21 카페 제보 (엄안 각성 갑옷 · 여포 방천화극★ 이 계속 복제): 천공개물로 새긴 복사본(도구 1000~1999, engrave)을 원래 번호로 못 알아봐
--  「받았는데 어디에도 없다」(restoreLost) → 원본을 다시 주고 「★ 이 어디에도 없다」(restoreStar) → ★ 으로 바꿔 하나 더 생겼음.
--  → 가진 것 · ★ 찾기 · 각성 진행 · 각성 특기에서 복사본은 원래 번호로 봄 (engrave 는 gear 뒤에 깔리므로 부를 때 찾음)
local function base(v) local f=rawget(_G,"koItemBaseId") if f and type(v)=="number" and v>=1000 then return f(v) end return v end
local function findBag(pid,it) local p=JY.Person[pid] for k=1,8 do if p[ITEM..k]==it or base(p[ITEM..k])==it then return k end end end
-- 아군 가방 · 장비 · 창고에 있는 도구 번호 모음 (한 번 훑어 OWNSET 에, 바뀌는 곳에서 OWNSET=nil)
local OWNSET=nil
function koGearInvalidateOwnership() OWNSET=nil end
local function ownSet()
if OWNSET then return OWNSET end
local t={}
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
if p[LORD]==1 then
for k=1,8 do local v=p[ITEM..k] if v and v>0 then t[v]=true t[base(v)]=true end end
for _,q in ipairs(EQUIP) do local v=p[q] if v and v>0 then t[v]=true t[base(v)]=true end end
end
end
if rawget(_G,"koStoreList") then for _,s in ipairs(koStoreList()) do t[s.iid]=true t[base(s.iid)]=true end end
OWNSET=t
return t
end
local function ownedId(id) if not id or id<=0 then return false end return ownSet()[id]==true or (koTreasureHasReserved and koTreasureHasReserved(id)) end
local function owned(e) return ownedId(e[2]) or ownedId(e[3]) end
local function box(s) WarDrawStrBoxConfirm(s,M_White,JY.Status~=GAME_WMAP) end

-- ---------------------------------------------------------------- 1. 합류 지급
-- 한 무장에게: 이미 받았으면 그만, 들고 있으면(적 일시 장비) 그대로 지급분, 아군 · 창고에 있으면 비트만, 아니면 가방 → 창고. 준 보물 이름을 돌려줌
local function giveTo(pid)
if not have() then return nil end
local k=BYNAME[pname(pid)]
if not k or gotGift(k) or awOnly(D[k]) then return nil end
local e=D[k]
if findBag(pid,e[2]) or (e[3]>0 and findBag(pid,e[3])) then setGift(k) return nil end
if owned(e) then
setGift(k)
-- 11-14 (제보 「2회차 술집에서 방통을 영입했는데 전용 보물도 안내도 없음」): 이미 우리 편 누군가의 가방 · 장비나 창고에 있으면
--  (도구 계승으로 1회차 창고 · 가방의 보물이 넘어온 경우 등) 하나 더 주지 않는데 말없이 넘어갔다 → 둘째 값으로 어디 있는지 돌려줌 (합류 때 안내)
for i=1,JY.PersonNum-1 do
local q=JY.Person[i]
if i~=pid and q[LORD]==1 and not (i>=762 and i<=781) then
for _,id in ipairs({e[2],e[3]}) do
if id>0 then
for s=1,8 do if q[ITEM..s]==id then return nil,iname(id),pname(i) end end
for _,f in ipairs(EQUIP) do if q[f]==id then return nil,iname(id),pname(i) end end
end
end
end
end
return nil,iname(e[2]),"\134\103\131\100"
end
local p=JY.Person[pid]
for s=1,8 do
if (p[ITEM..s] or 0)==0 then p[ITEM..s]=e[2] setGift(k) OWNSET=nil pcall(ReSetAttrib,pid,false) return iname(e[2]) end
end
if rawget(_G,"koStorePut") and koStorePut(e[2]) then setGift(k) OWNSET=nil return iname(e[2]).."(\134\103\131\100)" end
return nil
end
-- 11-07: takeBack 이 창고의 전용 보물을 지우던 판에서 잃어버린 것을 세이브마다 한 번 되찾아 줌:
--  받은 표시는 있는데 아군 · 창고 어디에도 없고 주인이 아군일 때. 표시 = 지급 비트의 마지막 칸(450번, 표 줄 수보다 뒤)
-- 11-14 (카페 제보 세이브: 영걸전 2회차 아군 39~41명이 「받음」인데 보물이 어디에도 없음 — 11-10 전 판의 회차 넘김(특기 계승이
--  지급 비트를 되살림)으로 남은 것, 450 표시도 같이 남아 이 되찾기가 안 돌았음) → 세이브마다 한 번이 아니라 불러올 때마다 확인
local function restoreLost()
if not have() or #D>=450 then return end
OWNSET=nil
for i=1,JY.PersonNum-1 do
if i<762 or i>781 then
local k=(JY.Person[i][LORD]==1) and BYNAME[pname(i)]
if k and gotGift(k) and not awOnly(D[k]) and not owned(D[k]) then
local n=k-1
local gs=S_GIFT[math.floor(n/225)+1] local w=W15[math.floor((n%225)/15)+1]
setraw(gs,w,raw(gs,w)-2^(n%15))
OWNSET=nil
pcall(giveTo,i)
end
end
end
setGift(450)
OWNSET=nil
end
function koGearRestoreT() return restoreLost() end-- for test scripts
-- 군웅록 11-14 (팔진서 쌓임 → 제갈량 전용 보물을 새 학우선 793 으로, 팔진서 174 는 일반 보물): 옛 ★ 칸 776 (팔진서★) 이 학우선★ 이 됨.
--  팔진서를 각성해 ★ 만 들고 있던 옛 세이브에는 팔진서 한 권을 돌려줌 (제갈량 가방 → 다른 아군 가방 → 창고). 세이브마다 한 번 (표시 = 지급 비트 449)
local function paljinBack()
if not have() or #D>=449 or gotGift(449) then return nil end
setGift(449)
OWNSET=nil
if not ownedId(776) or ownedId(174) then return nil end
local order={}
for i=1,JY.PersonNum-1 do
if (i<762 or i>781) and JY.Person[i][LORD]==1 then
if pname(i)=="\129\100\135\121\132\088" then table.insert(order,1,i) else order[#order+1]=i end
end
end
for _,pid in ipairs(order) do
local p=JY.Person[pid]
for s=1,8 do if (p[ITEM..s] or 0)==0 then p[ITEM..s]=174 OWNSET=nil return pname(pid) end end
end
if rawget(_G,"koStorePut") and koStorePut(174) then OWNSET=nil return "\134\103\131\100" end
return nil
end
function koGearPaljinBackT() return paljinBack() end-- for test scripts
function koGearGiveT(pid) return giveTo(pid) end-- for test scripts
local function scan(show)
if not have() then return end
OWNSET=nil
local got={}
for i=1,JY.PersonNum-1 do
if JY.Person[i][LORD]==1 then local s=giveTo(i) if s then got[#got+1]=pname(i).." "..s end end
end
if show and #got>0 then
local t=table.concat(got," \161\164 ",1,math.min(#got,4))
if #got>4 then t=t.." \131\107 "..(#got-4).."\130\088" end
box("\130\066\132\111 \131\115\131\065\129\083 \133\072\131\116\129\075\129\076\129\077*"..t)
end
end
-- 11-08 카페 제보 (서주 뒤 떠난 조운이 다시 오니 청강검이 없음): 우리 편이 떠날 때(재야 · 남의 편) 가방의 남의 전용 보물은
-- 창고에 (차면 자리 있는 다른 아군에게) 맡긴다. 떠난 동안 takeBack(거두기)이 지워 버려 아주 없어지던 것
local function leaveStash(pid)
local p=JY.Person[pid] local nm=pname(pid) local put={}
for s=1,8 do
local v=p[ITEM..s] local k=v and v>0 and (BYITEM[base(v)] or BYSTAR[base(v)])
if k and D[k][1]~=nm then
local to=nil
if rawget(_G,"koStorePut") and koStorePut(v) then to="\134\103\131\100"
else
for i=1,JY.PersonNum-1 do
local q=JY.Person[i]
if i~=pid and q[LORD]==1 and not (i>=762 and i<=781) then
for t=1,8 do if (q[ITEM..t] or 0)==0 then q[ITEM..t]=v to=pname(i) pcall(ReSetAttrib,i,false) break end end
end
if to then break end
end
end
if to then p[ITEM..s]=0 put[#put+1]=iname(v).."("..to..")" end
end
end
if #put>0 then if rawget(_G,"koPackBag") then pcall(koPackBag,pid) end pcall(ReSetAttrib,pid,false) OWNSET=nil end
return put
end
function koGearLeaveStashT(pid) return leaveStash(pid) end-- for test scripts
-- 11-12 카페 제보 (조운이 떠날 때마다 청강검을 창고에 두고 가 불편): 함께 쓰는 줄(e[9]>0, 조운)의 무장이 돌아오면
--  창고에 있는 그 보물(원본 · ★)을 가방으로 되돌려 줌 (다른 아군이 들고 있으면 그대로). 떠날 때 맡기는 것은 그대로 — 떠난 동안 거두기 · 중복 방지
local function shareBack(pid)
if not have() or not rawget(_G,"koStoreList") then return nil end
local nm=pname(pid) local p=JY.Person[pid] local got=nil
for _,k in ipairs(ROWS[nm] or {}) do
local e=D[k]
if (e[9] or 0)>0 then
for _,v in ipairs({e[3],e[2]}) do
if v and v>0 and not got and not findBag(pid,v) then
for _,s in ipairs(koStoreList()) do
if s.iid==v then
local q=nil for t=1,8 do if (p[ITEM..t] or 0)==0 then q=t break end end
if q then setraw(s.i,s.o,0) p[ITEM..q]=v got=iname(v) pcall(ReSetAttrib,pid,false) OWNSET=nil end
break
end
end
end
end
end
end
return got
end
function koGearShareBackT(pid) return shareBack(pid) end-- for test scripts
do
local mf=rawget(_G,"ModifyForce")
if type(mf)=="function" then
function ModifyForce(pid,fid,...)
if koStoryKeepsForce and koStoryKeepsForce(pid,fid) then return end
local put=nil
if (fid or 1)~=1 and pid and JY.Person[pid] and JY.Person[pid][LORD]==1 and have() and not (CC.koFree or CC.koReplay) then
local ok,t=pcall(leaveStash,pid)
if ok and t and #t>0 then put=t end
end
local r=table.pack(mf(pid,fid,...))
if put then box(pname(pid).."\129\071(\129\094) \139\088\131\118\134\066 \138\069\140\073 \131\115\131\065: "..table.concat(put," \161\164 ")) end
if (fid or 1)==1 and pid and JY.Person[pid] and JY.Person[pid][LORD]==1 then
OWNSET=nil
-- 11-14 (카페 제보: 5회차 가맹관 뒤 마대 가방 = 0 · 0 · 참연도 — enemygear 가 1 · 2 칸 진짜 보물을 거두고 적일 때 든 자기 보물은 3 칸에 남음,
--  도구 교환은 1 칸이 비면 「소지품이 없습니다」) 합류하면 가방을 앞으로 당김
if rawget(_G,"koPackBag") then pcall(koPackBag,pid) end
local ok,s,have_it,where=pcall(giveTo,pid)
-- 11-18 (카페 제보 「3회차 북평에서 조운이 미각성 청강검으로 합류」): 각성 표시가 남은 ★ 을 원본으로 새로 받으면 되찾기(restoreStar)가
--  다음 불러오기 · 전투 끝에야 돌았음 → 합류하자마자 (안내도 ★ 이름으로)
--  (11-20: 이 블록은 1.0.38 때 게임 gear.lua 에만 넣었던 것을 src 에 맞춤)
if ok and s and rawget(_G,"koGearRestoreStarT") then
local p=JY.Person[pid] local before={} for t=1,8 do before[t]=p[ITEM..t] end
pcall(koGearRestoreStarT)
for t=1,8 do if p[ITEM..t]~=before[t] and (p[ITEM..t] or 0)>0 then s=iname(p[ITEM..t]) end end
end
if ok and s then box(pname(pid).."\129\071(\129\094) \130\066\132\111 \131\115\131\065 \161\184"..s.."\161\185\129\083(\130\104) \129\094\130\067\131\100 \138\088\129\077.")
elseif ok and have_it then box(pname(pid).."\131\080 \130\066\132\111 \131\115\131\065 \161\184"..have_it.."\161\185\131\098(\130\098) \129\071\134\119 "..(where=="\134\103\131\100" and "\134\103\131\100" or (where.."\131\080 \129\109\130\067\131\066")).."\129\102 \132\079\129\075\129\076\129\077.") end
if not (CC.koFree or CC.koReplay) then
local ok2,s2=pcall(shareBack,pid)
if ok2 and s2 then box(pname(pid).."\129\071(\129\094) \134\103\131\100\129\102 \138\069\139\072\138\066 \161\184"..s2.."\161\185\129\083(\130\104) \129\077\130\086 \131\082\132\107\129\077.") end
end
end
return table.unpack(r,1,r.n)
end
end
end

-- ---------------------------------------------------------------- 2. 적 일시 장비
-- 우리 편이 아닌 기록의 가방에서 남의 전용 보물을 거둠 (자기 것은 원본으로 둠)
-- 적이 우리 보물을 실제로 장비하도록: 같은 장비 칸(装备位)에서 우선순위(优先级)가 같거나 높은 다른 도구를 이번 전투 동안 빼 둠 (War.koGearMoved, 전투 끝에 되돌림)
-- (10-28 시험: enemygear 의 원작 청강검(우선 244) 이 우리 보물(230) 보다 먼저 장비되어 전용 · 각성 특기가 안 켜짐). 우리 편에는 쓰지 않음
local K_SLOT=string.char(215,176,177,184,206,187)   -- 装备位
local K_PRI=string.char(211,197,207,200,188,182)    -- 优先级
local function equipOwn(pid,id)
local p=JY.Person[pid] local it=JY.Item[id]
if not p or not it then return end
local sl,pr=it[K_SLOT],it[K_PRI]
local kept,moved={},{}
for s=1,8 do local v=p[ITEM..s] or 0
if v>0 then
local o=JY.Item[v]
if v~=id and o and o[K_SLOT]==sl and (o[K_PRI] or 0)>=pr then moved[#moved+1]=v else kept[#kept+1]=v end
end
end
if #moved>0 then
for s=1,8 do p[ITEM..s]=kept[s] or 0 end
War.koGearMoved=War.koGearMoved or {}
local t=War.koGearMoved[pid] or {}
for _,v in ipairs(moved) do t[#t+1]=v end
War.koGearMoved[pid]=t
end
pcall(ReSetAttrib,pid,false)
end
local function putBack()
for pid,list in pairs((War and War.koGearMoved) or {}) do
local p=JY.Person[pid]
if p then for _,v in ipairs(list) do for s=1,8 do if (p[ITEM..s] or 0)==0 then p[ITEM..s]=v break end end end pcall(ReSetAttrib,pid,false) end
end
if War then War.koGearMoved=nil end
end
-- 11-16 (카페 제보 「새 회차 술집 조운이 각성 풀린 청강검」): 함께 쓰는 줄(조운 → 하후은의 청강검)의 무장은 그 보물을 자기 것처럼 본다.
--  회차를 넘기며 조운 기록(아직 우리 편 아님)에 따라온 청강검★ 을 「남의 것」 으로 지워, 합류 때 원본을 새로 받았음
local function sharedRow(k,name)
for _,r in ipairs(ROWS[name] or {}) do local e=D[r] if (e[9] or 0)>0 and e[2]==D[k][2] then return r end end
end
local function takeBack()
if not have() then return end
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
if p[LORD]~=1 and not (i>=762 and i<=781) then-- 11-07: 762~781 = 창고 칸(사람 아님), 맡긴 전용 보물을 지우면 안 됨
local ch=false
-- 남의 전용 보물은 비우고, 자기 것은 둠 (관우 · 장비는 newgame 가방에 원래 듦, 적일 때 받은 자기 것도 합류하면 그대로 지급분) — 자기 ★ 은 원본으로
for s=1,8 do
local v=p[ITEM..s] local k=v and (BYITEM[base(v)] or BYSTAR[base(v)])
if k and not (koTreasureKeeps and koTreasureKeeps(i,v)) then
local sr=(D[k][1]~=p[NAME]) and sharedRow(k,p[NAME]) or nil
if D[k][1]~=p[NAME] and not sr then p[ITEM..s]=0 ch=true
elseif v==D[k][3] and not earned(k) and not (sr and earned(sr)) then p[ITEM..s]=D[k][2] ch=true end
end
end
if ch then if rawget(_G,"koPackBag") then pcall(koPackBag,i) end pcall(ReSetAttrib,i,false) end
end
end
end
function koGearTakeBackT() return takeBack() end-- for test scripts
-- 11-10: 우리 편(창고 칸 포함)이 든 ★ 에 각성 표시
local function markHeld()
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
if p[LORD]==1 or (i>=762 and i<=781) then
for s=1,8 do local k=BYSTAR[base(p[ITEM..s] or 0)] if k then setEarned(k) end end
for _,q in ipairs(EQUIP) do local k=BYSTAR[base(p[q] or 0)] if k then setEarned(k) end end
end
end
end
function koGearMarkHeldT() return markHeld() end-- for test scripts
local function starAnywhere(id)
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
for s=1,8 do if base(p[ITEM..s])==id then return true end end
for _,q in ipairs(EQUIP) do if base(p[q])==id then return true end end
end
return false
end
-- 각성 표시가 있는데 ★ 이 어디에도 없고 주인이 원본을 들었으면 ★ 으로 (적으로 나온 전투 동안 내려 둔 것 · 전투 중 저장으로 끊긴 것)
local function restoreStar()
for i=1,JY.PersonNum-1 do
if i<762 or i>781 then
local p=JY.Person[i]
for s=1,8 do
local v=p[ITEM..s] local k=v and v>0 and BYITEM[v]
local sr=k and D[k][1]~=p[NAME] and sharedRow(k,p[NAME]) or nil-- 11-16: 함께 쓰는 줄(조운)도 각성 표시가 있으면 ★ 으로 (지워진 청강검★ 되찾기)
if k and D[k][3]>0 and (D[k][1]==p[NAME] or sr) and (earned(k) or (sr and earned(sr))) and not starAnywhere(D[k][3])
and not (p[LORD]~=1 and koTreasureKeeps and koTreasureKeeps(i,v)) then
p[ITEM..s]=D[k][3]
for _,q in ipairs(EQUIP) do if p[q]==v then p[q]=D[k][3] end end
pcall(ReSetAttrib,i,false)
OWNSET=nil
end
end
end
end
end
function koGearRestoreStarT() return restoreStar() end-- for test scripts
local function emptySlot(p) for s=1,8 do if (p[ITEM..s] or 0)==0 then return s end end end
-- 11-10: 각성 표시가 있는 자기 ★ 을 든 적(떠난 우리 편 · 지난 회차에서 이어 옴)은 이 전투 동안만 원본 (끝나면 restoreStar 가 ★ 으로).
--  아래 두 war_begin 보다 먼저: 2회차 원본 주기는 이미 원본을 들었으니 건너뛰고, 난이도 9 의 ★ 바꿔 끼우기는 원본 자리에 ★ (끝나면 원본 → ★)
koOn("war_begin",function()
if not have() then return end
for _,v in pairs(War.Person or {}) do
if v.enemy and v.id and JY.Person[v.id][LORD]~=1 then
local p=JY.Person[v.id] local ch=false
for s=1,8 do local k=BYSTAR[p[ITEM..s] or 0] if k and D[k][1]==p[NAME] and earned(k) and not (koTreasureKeeps and koTreasureKeeps(v.id,p[ITEM..s])) then p[ITEM..s]=D[k][2] ch=true end end
for _,q in ipairs(EQUIP) do local k=BYSTAR[p[q] or 0] if k and D[k][1]==p[NAME] and earned(k) then p[q]=D[k][2] ch=true end end
if ch then pcall(ReSetAttrib,v.id,false) OWNSET=nil end
end
end
end)
-- 도전 난이도 규칙 「적장 전용 보물」 (5단계부터) · 2회차부터: 이름난 적장 모두 자기 전용 보물(원본)을 듦
koOn("war_begin",function()
War.koGearSeen={}
OWNSET=nil
if not active() or (cyc()<2 and dlv()<5) or War.koGearArmed then return end
War.koGearArmed=true
for _,v in pairs(War.Person or {}) do
if v.enemy and v.id and JY.Person[v.id][LORD]~=1 then
local k=BYNAME[pname(v.id)]
local e=ownerRow(k) and D[k]
if e and awOnly(e) then e=nil end
if e and not findBag(v.id,e[2]) and not (e[3]>0 and findBag(v.id,e[3])) then
local p=JY.Person[v.id]
local s=emptySlot(p)
if s then p[ITEM..s]=e[2] equipOwn(v.id,e[2]) end
-- 11-16 (카페 제보 「허창 전투 적이 전용 보물을 갖고도 세력 무기를 듦」): 앞 전투에서 받은 자기 보물은 기록에 남아(takeBack 은 자기 것을 둠)
--  두 번째 등장부터 위 줄을 건너뛰어, enemygear 가 준 우선순위 높은 원작 보물(청강검 등)을 장비했음 → 이미 들었어도 장비 맞춤
elseif e then
local id=(e[3]>0 and findBag(v.id,e[3])) and e[3] or e[2]
equipOwn(v.id,id)
end
end
end
end)
-- 도전 난이도 규칙 「적장 각성 장비」 (diff 애드온 9단계부터): 이름난 적장 모두 자기 ★ 을 듦 (원본이 있으면 바꿔 끼움)
-- 10-28 사용자: 처음엔 시련 카드(awgear) → 난이도 5·7·9 (총대장 → +1명 → 5명) → 두 단계(5 모든 적 원본 · 9 모든 적 ★)
koOn("war_begin",function()
if not active() or War.koGearStar then return end
if dlv()<9 then return end
War.koGearStar=true
War.koGearStarSwap={}
local got={}
for _,v in pairs(War.Person or {}) do
if v.enemy and v.id and JY.Person[v.id][LORD]~=1 then
for _,k in ipairs(ROWS[pname(v.id)] or {}) do
local e=ownerRow(k) and D[k]
if e and e[3]>0 then
local p=JY.Person[v.id]
local s0=findBag(v.id,e[3])-- 전투 저장을 불러온 경우: 이미 듦
local s=(not s0) and findBag(v.id,e[2]) or nil
if s0 then equipOwn(v.id,e[3]) got[#got+1]=e[1].."("..iname(e[3])..")"
elseif s then
-- 원래 든 · 앞에서 빌려준 원본 자리에 ★ (전투 끝에 원본으로)
War.koGearStarSwap[#War.koGearStarSwap+1]={v.id,e[3],e[2]}
p[ITEM..s]=e[3] equipOwn(v.id,e[3]) got[#got+1]=e[1].."("..iname(e[3])..")"
elseif not awOnly(e) then
local q=emptySlot(p)
if q then
War.koGearStarSwap[#War.koGearStarSwap+1]={v.id,e[3],0}
p[ITEM..q]=e[3] equipOwn(v.id,e[3]) got[#got+1]=e[1].."("..iname(e[3])..")"
end
end
end
end
end
end
if #got>0 then War.koGearStarList=table.concat(got," \161\164 ") end
end)
function koGearStarListT() return War and War.koGearStarList end-- for test scripts
-- ★ 을 준 칸은 원래 것(원본 · 빈칸)으로 되돌림
local function starBack()
for _,t in ipairs((War and War.koGearStarSwap) or {}) do
local pid,star,old=t[1],t[2],t[3]
local s=findBag(pid,star)
if s then JY.Person[pid][ITEM..s]=old pcall(ReSetAttrib,pid,false) end
end
if War then War.koGearStarSwap=nil end
end
koOn("war_end",function() pcall(starBack) pcall(takeBack) pcall(putBack) pcall(restoreStar) pcall(markHeld) War.koGearArmed=nil War.koGearStar=nil end)

-- ---------------------------------------------------------------- 3. 각성
local function holds(pid,k)
local p=JY.Person[pid]
if not p or p[LORD]~=1 or D[k][1]~=p[NAME] then return false end
for _,q in ipairs(EQUIP) do if base(p[q])==D[k][2] then return true end end
return false
end
local function holding(pid)
local p=JY.Person[pid]
if not p or p[LORD]~=1 then return nil end
local k=BYNAME[p[NAME]]
if not k then return nil end
for _,q in ipairs(EQUIP) do if base(p[q])==D[k][2] then return k end end
return nil
end
-- 정벌(conquest) 판 안: 판 한정 진행(자유 전투 임시 기록에 셈), 조건 수는 절반 (10-29 정벌 3단계)
local function conq() local f=rawget(_G,"koConqActive") return f~=nil and f()==true end
local function need5(e) local v=e[5] if conq() then v=math.max(1,math.ceil(v/2)) end return v end
local function need8(e) local v=e[8] or 0 if conq() then v=math.max(1,math.ceil(v/2)) end return v end
local COND={"\130\112\134\086","\130\117\130\118\131\109\132\083 \130\112\134\086","\133\098\130\066\129\066 \129\071\140\073 \130\066\132\101","\130\112\134\086","\129\111 \130\066\132\101 %d\130\112\134\086"}-- 10-28 밤: 「들고 들고」 고침 (앞에 「이(가) 들고」 가 붙음)
local MARK="*\130\069\131\123:"
local function progress(k)
local e=D[k]
local c=string.format(COND[e[4]] or "",e[8] or 0)
local s=e[1].." \129\071(\129\094) \131\082\131\100 "..c.." "..cnt(k).." / "..need5(e)
if e[4]==4 then s=s.." \161\164 \133\073\131\071\137\083 "..cnt(DUELK).." / "..need8(e) end
return s
end
local function done(k)
local e=D[k]
if cnt(k)<need5(e) then return false end
if e[4]==4 and cnt(DUELK)<need8(e) then return false end
return true
end
local function frac(k)
local e=D[k]
local a=cnt(k)/need5(e)
if e[4]==4 then a=math.min(a,cnt(DUELK)/need8(e)) end
return a
end
-- 진행 줄: 원본 설명 끝. 한 보물을 여럿이 쓰면(청강검: 하후은 · 조운) 「 / 」 로 이어 씀
local function refreshDesc()
if not have() then return end
OWNSET=nil
local lines,order={},{}
for k,e in ipairs(D) do
if e[3]>0 and not ownedId(e[3]) then
if not lines[e[2]] then lines[e[2]]={} order[#order+1]=e[2] end
table.insert(lines[e[2]],progress(k))
end
end
for k,e in ipairs(D) do
if e[3]>0 and not lines[e[2]] then lines[e[2]]={} order[#order+1]=e[2] end
end
for _,id in ipairs(order) do
local it=JY.Item[id]
if it then
local s=it[DESC] or ""
local a=string.find(s,MARK,1,true)
if a then s=string.sub(s,1,a-1) end
local add=table.concat(lines[id]," / ")
if add~="" and #s+#MARK+1+#add<200 then s=s..MARK.." "..add end
if #s<200 then pcall(function() it[DESC]=s end) end
end
end
end
function koGearRefreshT() return refreshDesc() end-- for test scripts
do
local rawDWM=DefineWarMap
function DefineWarMap(id,name,...)
local r=rawDWM(id,name,...)
if have() then tmpClear() setraw(S_ON,24,(active() or conq()) and 1 or 0) end
return r
end
end
local function counting() return have() and raw(S_ON,24)==1 end
-- 정벌 첫 전투는 자유 전투가 판을 켜기 전에 DefineWarMap 을 불러 셈이 꺼진 채 → conquest 가 첫 턴에 켬
function koGearCountOn() if have() then setraw(S_ON,24,1) end end
local function addKill(pid,magic)
local p=JY.Person[pid]
for _,k in ipairs((p and ROWS[p[NAME]]) or {}) do
local e=D[k]
if holds(pid,k) and e[3]>0 and not ownedId(e[3]) and e[4]~=3 and (e[4]~=2 or magic) then tmpAdd(k) end
end
end
koOn("unit_down",function(wid,atk)
if not counting() then return end
local v=War.Person[wid] local a=atk and War.Person[atk]
if not v or not a or a.enemy then return end
War.koGearSeen=War.koGearSeen or {}
if War.koGearSeen[v.id] then return end
War.koGearSeen[v.id]=true
addKill(a.id,false)
end)
koOn("magic_kill",function(cw)
if not counting() then return end
local c=War.Person[cw]
if not c or c.enemy then return end
War.koGearSeen=War.koGearSeen or {}
for _,v in pairs(War.Person) do
if v.enemy and v.live and JY.Person[v.id][HP]<=0 and not War.koGearSeen[v.id] then
War.koGearSeen[v.id]=true
addKill(c.id,true)
end
end
end)
-- 일기토 이김 (조건 4): fight 감싸기 (awaken 에서 옮김)
do
local rawFight=fight
if type(rawFight)=="function" then
function fight(a,b,...)
local r=rawFight(a,b,...)
pcall(function()
if JY.Status~=GAME_WMAP or not counting() then return end
local me=(r==1 and a) or (r==2 and b) or nil
local foe=(r==1 and b) or (r==2 and a) or nil
if not me or (foe and JY.Person[foe] and JY.Person[foe][LORD]==1) then return end
local k=holding(me)
if k and D[k][4]==4 and not ownedId(D[k][3]) then tmpAdd(DUELK) end
end)
return r
end
end
end
-- 정벌은 전투 사이(free_floor_won)에 war_won 이 안 불려서 conquest 가 koGearWarWon 을 직접 부름 (한 전투에 한 번: 들어오면 셈 켬을 끔)
function koGearWarWon()
if not counting() then return end
OWNSET=nil
setraw(S_ON,24,0)
for k,e in ipairs(D) do
if e[3]>0 and not ownedId(e[3]) then
local before=frac(k)
local add,addD=0,0
if e[4]==3 then
for i=1,JY.PersonNum-1 do if holds(i,k) and GetWarID(i)>0 then add=1 break end end
elseif e[4]==5 then
if (tmpGet(k))>=(e[8] or 1) then add=1 end
else
add=(tmpGet(k))
if e[4]==4 then addD=(tmpGet(DUELK)) end
end
-- 11-13 카페 제보 (곽적 남중복병선 「책략으로 격파 10 / 10」 인데 ★ 이 안 됨): 조건을 채운 그 전투 끝에 주인이 원본을 장비하고 있지 않으면
--  (장비를 바꿈 · 떠나 있음) 각성을 건너뛰고, 그 뒤로는 이번 전투 몫(add)이 있을 때만 다시 봐서 셈을 하나 더 쌓기 전까지 멈춰 있었음
--  → 이미 채웠으면 몫이 없어도 이긴 전투 끝마다 주인이 원본을 장비했는지 다시 봄
if add>0 or addD>0 or done(k) then
setCnt(k,cnt(k)+add)
if addD>0 then setCnt(DUELK,cnt(DUELK)+addD) end
local after=frac(k)
local pid=nil
for i=1,JY.PersonNum-1 do if holds(i,k) then pid=i break end end
if pid and done(k) then
-- 장비 칸은 ReSetAttrib 가 가방에서 다시 고르므로 가방 속 원본을 바꾸고 다시 계산
local s=findBag(pid,e[2])
if s then JY.Person[pid][ITEM..s]=e[3] end
for _,q in ipairs(EQUIP) do if JY.Person[pid][q]==e[2] then JY.Person[pid][q]=e[3] end end
setEarned(k)
pcall(ReSetAttrib,pid,false)
OWNSET=nil
PlayWavE(11)
box(e[1]..": \161\184"..e[7].."\161\185*\130\066\132\111 \131\115\131\065 \130\069\131\123! "..iname(e[2]).." \161\250 "..iname(e[3]))
elseif pid and ((before<0.5 and after>=0.5) or (before<0.8 and after>=0.8)) then
box(iname(e[2]).." \130\069\131\123\129\089\130\067*"..progress(k))
end
end
end
end
tmpClear()
pcall(refreshDesc)
end
koOn("war_won",function() koGearWarWon() end)
-- 각성 특기 (★ 을 주인이 장비했을 때) · 함께 쓰는 무장의 특기 (조운이 청강검 · 청강검★ 을 들 때 파진, ★ 이면 각성 특기도)
if type(rawget(_G,"koLinkSkill"))=="function" then
local rawLS=koLinkSkill
local SAFE=not koHas("bond")-- base koLinkSkill 은 연계 무장만 생각하고 만들어짐
function koLinkSkill(pid,sid)
if SAFE then local ok,r=pcall(rawLS,pid,sid) if ok and r then return true end elseif rawLS(pid,sid) then return true end
local p=JY.Person[pid]
for _,k in ipairs((p and ROWS[p[NAME]]) or {}) do
local e=D[k]
for _,q in ipairs(EQUIP) do
local v=base(p[q])
if e[3]>0 and v==e[3] and e[6]>0 and e[6]==sid then return true end
local sharedSkill=e[10] or e[9] or 0 -- [9] still distinguishes a shared owner
if (e[9] or 0)>0 and sharedSkill>0 and sharedSkill==sid and (v==e[2] or v==e[3]) then return true end
end
end
return false
end
end
if type(rawget(_G,"koLinkIdx"))=="table" and getmetatable(koLinkIdx)==nil then
-- bond 가 꺼져 있으면 base 의 빠른 거절표(연계 무장만)라 주인에게 koLinkSkill 이 안 불림 → 표에 있는 무장 이름은 통과
setmetatable(koLinkIdx,{__index=function(_,pid)
local p=JY.Person[pid]
return p~=nil and BYNAME[p[NAME]]~=nil
end})
end
-- 11-13 카페 제보 (장판파 적 장료: 황룡구겸도★ 을 장비하지 않았는데 패기 사거리로 공격): 각성 · 전용 특기는 설계대로 장비했을 때만 (koLinkSkill · jymain koHasSkill
--  모두 무기 · 방구 · 보조 칸만 봄). 그런데 jymain ReSetAttrib 은 패기(45)를 가방에서 장비를 다시 고르기 전의 옛 장비 칸으로 보고, 패기가 없어져도
--  사거리(atkfw)를 병종 값으로 되돌리지 않음. storyhire 주차는 소지품만 처음 값으로 돌리고 장비 칸은 우리 편 때 그대로(★)라서 전투 첫 계산에서
--  패기가 켜진 채 전투 내내 남았음 → 원래 계산 뒤에 지금 장비로 패기를 다시 보고, 없으면 패기 사거리를 병종 사거리로
do
local rawRA=ReSetAttrib
local K_BZ=string.char(177,248,214,214)-- 兵种
local K_AFW=string.char(185,165,187,247,183,182,206,167)-- 攻击范围
local K_P1=string.char(178,206,202,253).."1"-- 参数1
local NOFW={[5]=true,[6]=true,[8]=true,[9]=true,[24]=true,[10]=true,[23]=true,[26]=true}-- jymain 이 패기를 안 주는 병종 사거리
function ReSetAttrib(id,...)
local r=table.pack(rawRA(id,...))
pcall(function()
if not CC.Enhancement or not War or not War.Person then return end
local wid=GetWarID(id)
local v=wid>0 and War.Person[wid]
if not v then return end
local b=JY.Bingzhong[JY.Person[id][K_BZ]]
local base=b and b[K_AFW]
if not base or NOFW[base] then return end
local fw=JY.Skill[45][K_P1]
if CheckSkill(id,45) then v.atkfw=fw elseif v.atkfw==fw and base~=fw then v.atkfw=base end
end)
return table.unpack(r,1,r.n)
end
end
-- 11-13: ★ 설명의 「각성 특기: …」 줄은 설명 글이라 jymain DrawItemStatus 의 「(착용 시)」 표시가 안 붙었음 (전용 특기 줄에만 붙음)
--  → 보는 무장이 그 ★ 을 장비하지 않았으면 「각성 특기(착용 시):」 로 보여 줌 (보여 주는 동안만 바꾸고 되돌림)
if type(rawget(_G,"DrawItemStatus"))=="function" then
local rawDIS=DrawItemStatus
local STARID={} for _,e in ipairs(D) do if e[3]>0 then STARID[e[3]]=true end end
local AWL="\130\069\131\123 \129\120\131\071:"
local AWL2="\130\069\131\123 \129\120\131\071(\134\087\132\111 \130\086):"
function DrawItemStatus(id,pid,...)
local it=JY.Item[id] local p=pid and JY.Person[pid]
local old=nil
if STARID[base(id)] and it and p and p[EQUIP[1]]~=id and p[EQUIP[2]]~=id and p[EQUIP[3]]~=id then
local s=it[DESC] or ""
local a=string.find(s,AWL,1,true)
if a and #s+#AWL2-#AWL<200 then
local ok=pcall(function() it[DESC]=string.sub(s,1,a-1)..AWL2..string.sub(s,a+#AWL) end)
if ok then old=s end
end
end
local r=table.pack(pcall(rawDIS,id,pid,...))
if old then pcall(function() it[DESC]=old end) end
if not r[1] then error(r[2],0) end
return table.unpack(r,2,r.n)
end
end

-- ---------------------------------------------------------------- 옛 awaken 진행 옮기기 (인물 칸 784: 24~32 관우 · 장비 · 여포 · 유비 · 조운 누적, 36 장비 일기토)
local S_OLDAW=784
local OLDAW={"\129\101\131\079","\131\097\130\080","\129\098\134\097","\130\071\130\080","\129\118\135\083"}
local function migrateAwaken()
if not have() then return end
local any=false
for o=24,36,2 do if raw(S_OLDAW,o)~=0 then any=true end end
if not any then return end
for i,nm in ipairs(OLDAW) do
local k=BYNAME[nm]
local v=raw(S_OLDAW,24+2*(i-1))
if k and v>cnt(k) then setCnt(k,v) end
end
local d=raw(S_OLDAW,36)
if d>cnt(DUELK) then setCnt(DUELK,d) end
for o=24,36,2 do setraw(S_OLDAW,o,0) end
end
function koGearMigrateT() return migrateAwaken() end-- for test scripts

-- ---------------------------------------------------------------- 옛 번호 → 새 번호 (옛 세이브: 모든 기록의 가방 · 장비, 창고도 인물 기록의 가방 칸)
local function moveOld()
if next(MOVE)==nil then return end
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
local ch=false
for s=1,8 do local v=p[ITEM..s] if v and MOVE[v] then p[ITEM..s]=MOVE[v] ch=true end end
for _,q in ipairs(EQUIP) do local v=p[q] if v and MOVE[v] then p[q]=MOVE[v] ch=true end end
if ch and p[LORD]==1 then pcall(ReSetAttrib,i,false) end
end
OWNSET=nil
end
function koGearMoveOldT() return moveOld() end-- for test scripts
-- 이야기 사건이 주는 도구: 옛 번호는 새 번호로, 전용 보물이면 한 회차에 한 번 (이미 지급 · 우리 편이 가짐 → 건너뜀, 처음 → 지급 비트)
local DUPGOLD=1000
local function storyGive(raw,who,pid,item,...)
item=MOVE[item] or item
local k=BYITEM[item]
if koTreasureStoryGive and koTreasureStoryGive(pid,item) then
if k then setGift(k) end
OWNSET=nil
return true
end
if not k or not have() then return raw(who,item,...) end
OWNSET=nil
-- 11-08 카페 제보 (하비 보물고 방천화극이 안 먹어짐): 우리 편이 이미 가졌으면 그냥 건너뛰던 것을 알려 주고,
-- 지급 비트만 서 있고 우리 편 누구도 갖고 있지 않으면(술집 사본이 들고 떠남 · 팔았음 등) 다시 준다 (한 번에 하나뿐인 것은 같음).
if owned(D[k]) then
setGift(k)
-- 11-12 카페 건의 (첫 소패 휴전 길의 자웅쌍검 = 유비가 합류 때 이미 받음): 이야기 진행 중이면 대신 황금
local gold=0
if active() and type(rawget(_G,"koGold"))=="function" and type(rawget(_G,"koSetGold"))=="function" then
gold=DUPGOLD koSetGold(koGold()+gold) pcall(koHook,"gold_gain",gold)
end
if iname(item)~="" then
if gold>0 then box("\129\071\134\119 \131\079\129\117 \132\075\129\102 \132\079\130\098 \131\115\131\065: "..iname(item).."\163\174*(\130\066\132\111 \131\115\131\065\131\098 \129\097\131\118\138\070\129\071\130\102 \130\095\131\078 \130\085\131\103 "..gold.."\129\083 \133\072\131\116\129\077)")
else box("\129\071\134\119 \131\079\129\117 \132\075\129\102 \132\079\130\098 \131\115\131\065: "..iname(item).."\163\174*(\130\066\132\111 \131\115\131\065\131\098 \129\097\131\118\138\070\129\071\130\102 \132\108 \133\086\130\067 \130\107\129\075\129\076\129\077)") end
end
return true
end
local r=raw(who,item,...)
if r then setGift(k) OWNSET=nil end
return r
end
do
local gi,wgi=rawget(_G,"GetItem"),rawget(_G,"WarGetItem")
if type(gi)=="function" then function GetItem(pid,item,...) return storyGive(gi,pid,pid,item,...) end end
if type(wgi)=="function" then function WarGetItem(wid,item,...) local unit=War.Person[wid] return storyGive(wgi,wid,unit and unit.id,item,...) end end
end

-- ---------------------------------------------------------------- 불러오기 · 전투 끝
do
local rawLR=LoadRecord
function LoadRecord(id,...)
local r=table.pack(rawLR(id,...))
pcall(function()
if not have() then return end
moveOld()
markHeld()
if (JY.Base[WARSAVE] or 0)~=1 then takeBack() restoreStar() end
if id and id>0 then migrateAwaken() scan(false) if (JY.Base[WARSAVE] or 0)~=1 then restoreLost() paljinBack() end end
refreshDesc()
end)
return table.unpack(r,1,r.n)
end
end
koOn("war_end",function() if active() then pcall(restoreLost) pcall(scan,true) end end)-- 11-14: 전투 중 세이브는 불러올 때 되찾기를 건너뛰므로 전투 끝에도
function koGearDebugT(pid,k) return tostring(counting()).." hold "..tostring(holding(pid)).." tmp "..tostring((tmpGet(k))).." on "..tostring(raw(S_ON,24)) end-- for test scripts

-- 11-10: 회차 넘기기 — 이어 가는 도구(가방)에 든 ★ 의 각성 표시도 다음 회차로 (표시 칸 784 · 785 는 새 판에서 지워짐).
--  넘기기 전 각성 표시를 기억해 두고, 넘긴 뒤 그 ★ 이 실제로 어느 기록의 가방 · 장비에 있으면 다시 세움 (도구를 안 물려받으면 없음)
do
local NG=CC.koNG
if type(NG)=="table" and type(NG.reset)=="function" then
local rawReset=NG.reset
NG.reset=function(...)
local keep={}
pcall(function() if have() then markHeld() for k=1,#D do if earned(k) then keep[#keep+1]=k end end end end)
local r=table.pack(rawReset(...))
pcall(function()
if not have() then return end
-- 11-10: 특기 계승을 고르면 jymain 이 모든 기록의 天赋 · 特技1~6 (낱말 138~150) 을 되살려, 이 칸들의 뒤쪽 일곱 낱말만 지난 회차 값이 남았음
--  (장비 일기토 누적 = 797 의 150 은 남고 격파 수는 0 · 지급 비트 일부가 남아 새 회차에 보물을 안 줌) → 회차 몫은 모두 지움
for _,s in ipairs(S_GIFT) do for _,w in ipairs(W15) do setraw(s,w,0) end end
for _,s in ipairs(S_CNT) do for _,w in ipairs(W15) do setraw(s,w,0) end end
tmpClear() setraw(S_ON,24,0)
for _,w in ipairs(W15) do setraw(785,w,0) end
for _,w in ipairs(W8) do setraw(784,w,0) end
for _,k in ipairs(keep) do if D[k][3]>0 and starAnywhere(D[k][3]) then setEarned(k) end end
end)
return table.unpack(r,1,r.n)
end
end
end
-- 군웅록 11-14 (카페 제보 「2회차 해금 무장을 영입할 때 전용 보물이 안 들어오는 무장」): 전용 보물은 영걸전 무장 칸 기준이라
--  무제전 · 손견전 · 원소전에만 나오는 무장은 전용 보물이 없다 → 사용자 「없음 표시가 깔끔. 문장으로 안내하면 영걸전도 그렇다고 오해」:
--  술집 고용 확인 창(「비용 N금, 무장: 이름. 고용합니까?」)에 그 무장의 전용 보물 한 줄 — 「전용 보물: 이름」 또는 「전용 보물 없음」
do
local hp=rawget(_G,"HirePerson")
local inHire=false
if type(hp)=="function" then
function HirePerson(...)
inHire=true
local ok,a,b,c=pcall(hp,...)
inHire=false
if not ok then error(a,0) end
return a,b,c
end
end
local yn=rawget(_G,"WarDrawStrBoxYesNo")
if type(yn)=="function" then
function WarDrawStrBoxYesNo(s,...)
if inHire and have() and type(s)=="string" and string.sub(s,1,#"\130\080\132\111 ")=="\130\080\132\111 " then
local who,len=nil,0
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
local n=p and p[NAME]
if n and n~="" and #n>len and p[LORD]~=1 and string.find(s,n,1,true) then who,len=i,#n end
end
if who then
local k=BYNAME[pname(who)]
if k and D[k] then s=s.."*\130\066\132\111 \131\115\131\065: "..iname(D[k][2])
else s=s.."*\130\066\132\111 \131\115\131\065 \130\097\130\077" end
end
end
return yn(s,...)
end
end
end
