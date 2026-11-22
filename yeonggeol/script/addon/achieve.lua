-- ko 3.6 later: 업적·무장 전적·마왕 토벌 등급 (addon "achieve", needs record; uses free / tourney / battlelog when loaded).
-- * 무장 전적: the record screen's third tab (was 격파 순위) lists every general with 출전 / 격파 / 준 피해 / MVP.
--   출전 and 준 피해 are counted when a story battle ends (war_end; 준 피해 = enemy troops taken, counters included, read from
--   the battle log). They live in the save's person record, in two duel-skill fields the game only ever reads from newgame
--   (Person_S flag false; the same trick as the MVP count in 一击): 暗器 (offset 88) = 출전, 连击 / 回马 (82 / 84) =
--   준 피해 below / above 10000. Value = save bytes - newgame bytes, on the general's 도감 record (always below 421).
-- * 마왕 토벌 등급: S / A / B from the turns of both phases and how many of ours fell (S: 30 turns or fewer, nobody lost;
--   A: 40 turns or fewer, 2 lost or fewer). Best grade in ko_settings (CC.koDemonGrade), shown in the 자유 전투 list.
--   Phase 1's turns / losses are kept in the free battle's own record (事件1983 / 1984) so a phase-2 save still knows them.
-- * 업적: twenty goals, kept machine-wide in ko_settings.lua (CC.koAch = "1,4,9"); a 기록 screen tab lists them.
--   Checked after a won battle, a free battle, the tournament, the tavern and when the record screen opens.
-- Source: 개발용/addon/achieve_src.lua (UTF-8); script/addon/achieve.lua is made from it by 개발용/도구/free_hz.pl.
if not koNeeds("record") then return end
local function K(...) return string.char(...) end
local LORD=K(190,253,214,247)-- 君主
local NAME=K(208,213,195,251)-- 姓名
local LV=K(181,200,188,182)-- 等级
local EV=K(202,194,188,254)-- 事件
-- ---------------------------------------------------------------- 무장 전적
local OFF_SORTIE,OFF_DLO,OFF_DHI=88,82,84
local function slot(pid)
local c=pid
if pid>=421 then c=koRecCanonOf(pid) end
if not c or c<=0 or c>=421 then return nil end
return c*CC.PersonSize
end
local function rd(pid,off)
local o=slot(pid)
if not o then return 0 end
return math.max(Byte.get16(JY.Data_Person,o+off)-Byte.get16(JY.Data_Person_Base,o+off),0)
end
local function wr(pid,off,v)
local o=slot(pid)
if o then Byte.set16(JY.Data_Person,o+off,Byte.get16(JY.Data_Person_Base,o+off)+v) end
end
function koCareerOf(pid)
return {sorties=rd(pid,OFF_SORTIE),dmg=rd(pid,OFF_DLO)+rd(pid,OFF_DHI)*10000}
end
local function careerSet(pid,sorties,dmg)
dmg=math.max(0,math.min(dmg,299999999))
wr(pid,OFF_SORTIE,math.min(sorties,29999))
wr(pid,OFF_DLO,dmg%10000)
wr(pid,OFF_DHI,math.floor(dmg/10000))
end
-- the battle's damage by general (pid of the unit that acted), from the battle log
local function battleDamage()
local byName={}
for i=1,War.PersonNum do
local v=War.Person[i]
if v and not v.enemy and not v.friend then byName[JY.Person[v.id][NAME]]=v.id end
end
local out={}
for _,e in ipairs(War.koLog or {}) do
if not e.h and not e.t and e.s==0 then
local pid=byName[e.a]
if pid then
for _,r in ipairs(e.r or {}) do
if r.s==2 then
for _,v in ipairs(r.v) do
local n=tonumber(v[2])
if v[1]=="d" and n and n<0 then out[pid]=(out[pid] or 0)-n end
end
end
end
end
end
end
return out
end
koOn("war_end",function()
if CC.koFree or CC.koReplay or type(War)~="table" or type(War.Person)~="table" then return nil end
local ok,err=pcall(function()
local dmg=battleDamage()
local seen={}
for i=1,War.PersonNum do
local v=War.Person[i]
if v and not v.enemy and not v.friend and not (v.hide and v.live) then
local o=slot(v.id)
if o and not seen[o] then
seen[o]=true
local c=koCareerOf(v.id)
careerSet(v.id,c.sorties+1,c.dmg+(dmg[v.id] or 0))
end
end
end
end)
if not ok then lib.Debug("achieve war_end: "..tostring(err)) end
return nil
end)
-- one row per general (a tavern copy counts on its 도감 record): {pid, 격파, MVP, 출전, 준 피해}, most 격파 first
function koCareerRank()
local rows,byKey={},{}
for i=1,math.min(JY.PersonNum-1,601) do-- 5.1 storyhire
local key=i
if i>=421 then local c=koRecCanonOf(i) if c and c>0 then key=c end end
local k=koRec(1200+i)
local mv=rawget(_G,"koMVPCount") and koMVPCount(i) or 0
local c=koCareerOf(i)
if k>0 or mv>0 or c.sorties>0 then
local r=byKey[key]
if not r then r={key,0,0,0,0} byKey[key]=r rows[#rows+1]=r end
r[2]=r[2]+k
r[3]=math.max(r[3],mv)
r[4]=math.max(r[4],c.sorties)
r[5]=math.max(r[5],c.dmg)
if JY.Person[i][LORD]==1 then r[1]=i end
end
end
table.sort(rows,function(a,b)
if a[2]~=b[2] then return a[2]>b[2] end
if a[5]~=b[5] then return a[5]>b[5] end
return a[1]<b[1]
end)
return rows
end
local function big(n)
if n>=100000 then return string.format("%.1f\132\086",n/10000) end
return tostring(n)
end
function koCareerDraw(rank,page,PER,c)
if #rank==0 then c.ctext(c.oy+220,"\129\110\132\076 \130\066\131\076\129\071 \130\097\129\075\129\076\129\077",M_Silver) return end
local pages=math.max(1,math.ceil(#rank/PER))
c.ctext(c.oy+445,page.." / "..pages,M_Gray)
for col=0,1 do
local x=c.ox+24+col*372
local y=c.oy+58
c.txt(x+42,y,"\129\073\131\097",M_Gray)
c.rtext(x+178,y,"\133\098\130\066",M_Gray) c.rtext(x+230,y,"\130\112\134\086",M_Gray) c.rtext(x+310,y,"\131\101 \137\088\129\066",M_Gray) c.rtext(x+356,y,"MVP",M_Gray)
lib.DrawRect(x,y+20,x+360,y+20,M_Gray)
end
for k=1,PER do
local idx=(page-1)*PER+k
if idx>#rank then break end
local r=rank[idx]
local col,row=math.floor((k-1)/12),(k-1)%12
local x=c.ox+24+col*372
local y=c.oy+84+row*28
local p=JY.Person[r[1]]
local color=(p[LORD]==1) and M_White or M_Gray
c.rtext(x+36,y,idx.."\130\110",M_Silver)
c.txt(x+42,y,p[NAME],color)
c.rtext(x+178,y,tostring(r[4]),M_White)
c.rtext(x+230,y,tostring(r[2]),C_Name)
c.rtext(x+310,y,big(r[5]),RGB(255,185,90))
c.rtext(x+356,y,tostring(r[3]),(r[3]>0) and M_Yellow or M_Gray)
end
end
-- the counts go into the next cycle with the save (koNG.reset rebuilds the records from newgame)
if type(CC.koNG)=="table" and type(CC.koNG.reset)=="function" then
local rawReset=CC.koNG.reset
CC.koNG.reset=function(...)
local keep={}
for i=1,420 do local c=koCareerOf(i) if c.sorties>0 or c.dmg>0 then keep[i]=c end end
local a,b,c=rawReset(...)
if a~=false then for i,v in pairs(keep) do careerSet(i,v.sorties,v.dmg) end end
return a,b,c
end
end
-- ---------------------------------------------------------------- 마왕 토벌 등급
local GRADE={"B","A","S"}
function koDemonGradeStr(g) return GRADE[g or 0] or "-" end
local function mineFallen()
local n=0
for i=1,War.PersonNum do
local v=War.Person[i]
if v and not v.enemy and not v.friend and not v.live then n=n+1 end
end
return n
end
if rawget(_G,"koFreeDemonToPhase2") then
local rawTo2=koFreeDemonToPhase2
koFreeDemonToPhase2=function(f,...)
local b=koFreeData[f.idx]
if b and b.phase2 and koFreeDemonPhase(f)==1 and JY.Status==GAME_WARWIN then
JY.Base[EV.."1983"]=War.Turn or 0
JY.Base[EV.."1984"]=mineFallen()
end
return rawTo2(f,...)
end
local rawWin=koFreeDemonWin
koFreeDemonWin=function(f,b,...)
local r=rawWin(f,b,...)
local t1,l1=JY.Base[EV.."1983"] or 0,JY.Base[EV.."1984"] or 0
local t2,l2=War.Turn or 0,mineFallen()
local T,L=t1+t2,l1+l2
local g=1
if T<=30 and L==0 then g=3 elseif T<=40 and L<=2 then g=2 end
local best=CC.koDemonGrade or 0
if g>best then CC.koDemonGrade=g koSave() end
PlayWavE(12)
WarDrawStrBoxWaitKey("\137\083\137\114 \133\125\134\080 "..GRADE[g].."*\131\123 \139\119 "..t1.."\129\112 + \133\088\135\101\131\123 "..t2.."\129\112 = "..T.."\129\112, \133\068\130\069 "..L.."*S: 30\129\112\161\164\133\068\130\069 0  A: 40\129\112\161\164\133\068\130\069 2 \129\071\129\097",M_White)
return r
end
local rawShort=koFreeRecShort
koFreeRecShort=function(idx,t,...)
local s=rawShort(idx,t,...)
local b=koFreeData[idx]
if b and b.demon and (CC.koDemonGrade or 0)>0 and s~="" then s=s.." "..GRADE[CC.koDemonGrade] end
return s
end
end
-- (업적은 10-11 사용자 요청으로 없앰: 보상이 없어 쓸모가 없음. 옛 판은 보관/achieve_*_업적전.lua.txt)
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koDemonGrade",default=0}
