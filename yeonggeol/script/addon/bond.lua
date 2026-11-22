-- ko 5.0: 연계 손질 (addon "bond"). 사용자 2026-10-03:
--  · 연계는 "\132\071\129\071 \133\098\129\103": 같은 편·둘 다 전장에 서 있음(숨은 복병·증원은 나타난 뒤부터, 퇴각하면 꺼짐)이면 켜짐. (10-03 「3칸 안」 → 10-11 사용자: 거리 없이) 기존 연계 6종(jymain koLinkPairs: 선인·강동·
--    수경·와룡 부부·기관, 이교)도 같은 규칙. 한 무장이 여러 연계를 함께 받음.
--  · 역사 관계 연계 4종: 도원결의(유비·관우·장비 중 둘 맹장·불굴, 셋이 다 가까우면 + 정병) · 이세 결의(관흥·장포 속공·용무) ·
--    적벽 부부(주유·소교 화계·신산) · 봉의정 부부(여포·초선 무쌍·수습).
--  · 10-15 직함·집단 연계 9종 (HIST 아래쪽): 오호대장군·와룡봉추·촉한 사상·서량 마씨 / 여포 팔건장·하북 사정주·강동 십이호신·
--    동오 4대 도독 / 오자양장. 오호대장군·와룡봉추·촉한 사상·서량 마씨·동오 4대 도독·오자양장은 전원 출진일 때만. 멤버 셈은 서로 다른 이름으로 (사본 둘은 한 명).
--    (결의·혼인을 직접 맺는 도시 메뉴도 만들었다가 뺐음 — 삼국지5 에 없는 시스템이라 사용자 결정. 그 판은 개발용 기록에만)
--  · jymain 의 koHasSkill 이 읽는 전역 koLinkIdx / koLinkSkill / koTwinOn(Pid) 와 미니 상태창 연계 줄(threat.lua)이 읽는 koLinkOnPid 를 바꿔 끼움.
-- Build (game folder): build_tavern.sh (perl "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/\129\068\130\119/free_hz.pl" < ".../addon/bond_src.lua" > script/addon/bond.lua)
local P_NAME="\208\213\195\251"-- 姓名
local RANGE=3
local SKN={[2]="\129\113\129\075",[8]="\132\111\129\073",[10]="\133\123\130\074",[11]="\129\113\132\084",[12]="\129\064\132\084",[13]="\134\085\129\064",[17]="\131\078\132\091",[18]="\133\121\134\086",[19]="\131\115\130\068",[20]="\131\108\134\087",[24]="\130\073\134\088",[26]="\133\100\134\094",[27]="\134\095\131\097",[30]="\129\073\134\096",[31]="\129\070\130\126",[36]="\134\097\129\103",[16]="\130\088\131\064",[25]="\130\073\131\071",[42]="\133\065\130\112",[113]="\130\110\133\070"}
-- 역사 관계 (by name: 관우·장비·여포 have more than one record)
local HIST={
{name="\129\068\131\081\134\064\131\080",names={"\130\071\130\080","\129\101\131\079","\131\097\130\080"},sk={27,26},trio={31}},
{name="\129\071\131\111 \134\064\131\080",names={"\129\101\133\077","\131\097\134\097"},sk={10,8}},
{name="\131\076\133\087 \130\094\130\094",names={"\130\075\130\071","\129\109\132\087"},sk={12,17}},
{name="\135\087\131\080\129\070 \130\094\130\094",names={"\129\098\134\097","\131\124\133\109"},sk={30,2}},-- (봉의정: 여포가 초선을 만난 곳)
-- 10-15 직함·집단 연계 9종 (사용자 "\151\229\139\064\131\126 \131\100\131\096\129\066\131\087" → 아군 4·적 4, + 오자양장은 사용자 지시로 전원 출진일 때만).
--   trio = 서로 다른 멤버 3명 이상이면 더 붙는 특기, all = 멤버 전원(서로 다른 이름 전부)이 서 있어야 켜짐,
--   only = 이름이 같은 다른 인물을 거름 (우금: 于禁 63 만, 牛金 171·그 술집 사본은 아님)
--   4장 위나라 집단(조위 팔호기)·조조 모사단·사마씨는 이미 큰 전투가 더 어려워져서 뺐음
--   10-15 사용자 "\131\118\138\099\130\067 \133\066\132\084\129\068 \130\066\131\081\131\109\132\083" → 전원이 실제로 모일 수 있는 5개만 all (십이호신·팔건장·사정주는 이야기 전투에
--   멤버가 다 나오지 않고 진무·위속 등은 등용도 안 돼서 2명 이상 그대로). 오호대장군은 전원이라 3명 단계 없이 위압·강기
{name="\129\091\134\113\130\095\131\097\130\084",names={"\129\101\131\079","\131\097\130\080","\129\118\135\083","\133\088\131\124","\130\085\135\116"},sk={113,25},all=true},
{name="\135\122\135\108\135\087\133\099",names={"\129\100\135\121\132\088","\132\078\132\119"},sk={12,18},all=true},
{name="\135\123\129\111 \130\114\129\067",names={"\129\100\135\121\132\088","\131\097\134\108","\130\080\130\110"},sk={16,20},all=true},
{name="\131\087\132\088 \133\088\131\084",names={"\133\088\133\125","\133\088\131\124","\133\088\130\095"},sk={25,8},all=true},
{name="\129\098\134\097 \137\079\129\119\131\097",names={"\131\097\129\085","\135\115\134\095","\129\118\131\123","\130\110\133\123","\135\112\135\113","\133\067\131\123"},sk={31}},
{name="\129\097\135\107 \130\114\129\070\130\075",names={"\130\111\132\088","\133\090\133\099","\131\097\129\087","\131\100\134\118"},sk={25}},
{name="\130\073\130\108 \135\073\129\071\134\113\131\078",names={"\129\070\131\115","\130\085\134\075","\129\111\135\105","\131\097\136\067","\130\075\130\124","\129\103\129\073","\135\078\135\125","\131\077\132\119","\131\087\131\123","\133\065\131\097","\129\070\135\087"},sk={42}},
{name="\130\108\129\091 4\130\095 \129\068\132\096",names={"\130\075\130\071","\131\089\134\102","\129\098\135\126","\134\081\135\089"},sk={18},all=true},
{name="\129\091\133\120\134\111\131\097",names={"\131\097\129\085","\133\118\129\103","\131\079\131\103","\131\097\129\087","\131\087\130\085"},sk={36},all=true,only={["\131\079\131\103"]={[63]=true}}},
}
local function nameOf(pid) return JY.Person[pid] and JY.Person[pid][P_NAME] or "" end
local function skText(sk) local t={} for _,s in ipairs(sk) do t[#t+1]=SKN[s] or "?" end return table.concat(t,"\161\164") end
local function skSet(sk,extra) local t={} for _,s in ipairs(sk) do t[s]=true end if extra then for _,s in ipairs(extra) do t[s]=true end end return t end
local function allBonds()
local B={}
local H={}
for _,h in ipairs(HIST) do H[#H+1]=h end
-- 군주판 연계 (camp 애드온 koCampBonds: 유표판의 단기입형·유표 부자 …). 유비판의 4종도 같은 이름이 있으면 그대로 켜짐
local cb=rawget(_G,"koCampBonds") and koCampBonds()
if cb then for _,h in ipairs(cb) do H[#H+1]=h end end
for _,h in ipairs(H) do
local set={} for _,n in ipairs(h.names) do set[n]=true end
local only=h.only
B[#B+1]={name=h.name,match=function(p) local n=nameOf(p) if set[n]~=true then return false end return not (only and only[n]) or only[n][p]==true end,sk=h.sk,trio=h.trio,all=h.all and #h.names}
end
return B
end

-- ---- on the battlefield: who is linked now (same side, both standing; no distance since 10-11). Cached for 100 ms (skill checks are many)
local function on() return CC.Enhancement and JY.Status==GAME_WMAP and War and War.Person end
local function side(u) return (u.enemy and 1 or 0)+(u.friend and 2 or 0) end
local function near(u,v) return u~=v and u.live and (not u.hide) and side(u)==side(v) end-- 10-11: same battle is enough (was within RANGE 3)
local function unitOf(pid) for _,u in pairs(War.Person) do if u.id==pid and u.live and not u.hide then return u end end return nil end
local cache={t=-1,war=nil,rows={},bonds=nil}
local function rowsOf(pid)
local now=lib.GetTime()
if cache.war~=War or now-cache.t>100 then cache.t,cache.war,cache.rows,cache.bonds=now,War,{},nil end
local r=cache.rows[pid]
if r then return r end
r={}
local v=unitOf(pid)
if v then
cache.bonds=cache.bonds or allBonds()
for _,b in ipairs(cache.bonds) do
if b.match(pid) then
-- 10-15: count different members (by name), not records — two copies of one general are one member
local seen,n={[nameOf(pid)]=true},0
for _,u in pairs(War.Person) do if u.id~=pid and b.match(u.id) and near(u,v) then local m=nameOf(u.id) if not seen[m] then seen[m]=true n=n+1 end end end
if n>=1 and ((not b.all) or n+1>=b.all) then
local trio=b.trio and n>=2
r[#r+1]={name=b.name,what=skText(b.sk)..(trio and ("\161\164"..skText(b.trio)) or ""),sk=skSet(b.sk,trio and b.trio)}
end
end
end
-- the old pairs (koLinkPairs: {a,b,{skills},name,what}), now by distance too
for _,row in ipairs(rawget(_G,"koLinkPairs") or {}) do
local o=(row[1]==pid and row[2]) or (row[2]==pid and row[1]) or nil
if o then local u=unitOf(o) if u and near(u,v) then r[#r+1]={name=row[4],what=row[5],sk=row[3]} end end
end
end
cache.rows[pid]=r
return r
end
koLinkIdx=setmetatable({},{__index=function() return true end})-- (the base's fast reject: every general may have a bond now)
function koLinkSkill(pid,sid)
if not on() then return false end
for _,row in ipairs(rowsOf(pid)) do if row.sk[sid] then return true end end
return false
end
-- the hover tag (threat.lua shows row[4]..": "..row[5]): every link at once
function koLinkOnPid(pid)
if not on() then return nil end
local r=rowsOf(pid)
if #r==0 then return nil end
local t,seen={},{[r[1].name]=true}
for k=2,#r do if not seen[r[k].name] then seen[r[k].name]=true t[#t+1]=r[k].name..": "..r[k].what end end
local what=r[1].what..((#t>0) and (" / "..table.concat(t," / ")) or "")
return {0,0,{},r[1].name,what}
end
-- 이교 연계 (대교·소교: 숙려, 회복 1.3배) by distance too
function koTwinOn(wid)
if not on() then return false end
local v=War.Person[wid]
if v==nil or (not v.live) or v.hide then return false end
local o=(v.id==411 and 412) or (v.id==412 and 411) or nil
if o==nil then return false end
local u=unitOf(o)
return u~=nil and near(u,v)
end
function koTwinOnPid(pid)
if (pid~=411 and pid~=412) or not on() then return false end
for i,u in pairs(War.Person) do if u.id==pid then return koTwinOn(i) end end
return false
end
function koBondRange() return RANGE end

-- for test scripts
function koBondRows(pid) if not on() then return {} end return rowsOf(pid) end
-- QA 2026-10-03: the 100 ms cache could hold a link state from a cell the unit only passed through, and a partner's
-- ReSetAttrib parts (속공·용무·무쌍) only changed when the partner itself moved. After any unit's ReSetAttrib in battle the
-- cache is cleared and every unit that shares a link with it is refreshed too; a fallen unit clears it as well.
local busy=false
local function partners(pid)
local t={}
local n=nameOf(pid)
for _,h in ipairs(HIST) do
local inn=false for _,m in ipairs(h.names) do if m==n then inn=true end end
if inn then for _,u in pairs(War.Person) do if u.id~=pid and u.live and not u.hide then for _,m in ipairs(h.names) do if nameOf(u.id)==m then t[u.id]=true end end end end end
end
for _,row in ipairs(rawget(_G,"koLinkPairs") or {}) do
if row[1]==pid then t[row[2]]=true elseif row[2]==pid then t[row[1]]=true end
end
if pid==411 then t[412]=true elseif pid==412 then t[411]=true end
return t
end
local oldAttrib=ReSetAttrib
function ReSetAttrib(id,...)
local r=table.pack(oldAttrib(id,...))
if not busy and on() then
busy=true
cache.t=-1
-- 10-17: partners go through the global ReSetAttrib (diff wraps it later): oldAttrib skipped the difficulty troop max,
-- so a linked enemy dropped to the raw max (9960/9960 -> 24900 after a later refresh; healers kept refilling 우금)
pcall(function() for o in pairs(partners(id)) do if unitOf(o) then ReSetAttrib(o,false) end end end)
cache.t=-1
busy=false
end
return table.unpack(r,1,r.n)
end
koOn("unit_down",function() cache.t=-1 end)
