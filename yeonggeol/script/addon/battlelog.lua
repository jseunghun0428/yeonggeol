-- ko 3.6: 전투 기록 (addon "battlelog"). Every attack and every strategy / tool use in a battle leaves one entry:
-- who acted, what it did, and what changed on each unit (troops, 격파, 혼란, 독, 사기, 책략치). It is read from the units'
-- state before and after the base's own WarAtk / WarMagic, so it follows every path (the player, 위임, the enemy AI,
-- 적 턴 생략). A unit that ends its action without either gets a dim entry: 이동 / 대기 / 혼란으로 움직이지 못함.
-- A header "3\129\112 \131\076\130\084" starts each side's phase (a counterattack stays under the phase it happened in).
-- 사기 is shown only when troops did not change (격려·위압 and the like; every hit also lowers it).
-- The window: three columns (unit | action | result, one target per row, numbers coloured by kind), filters 전체 / 아군 /
-- 적군 by who acted and 이동·대기 on/off (kept for the battle). Opens from the wide top bar button 기록, the 기능 menu row
-- 전투 기록 or the L key. The log lives in War (one battle).
-- A save made during a battle (by hand, 자동 저장 A1~A3, the turn-end temp slot) writes the log next to it
-- (data/save/save6.sav -> save6.blog) and loading that save brings it back; a save made outside a battle removes it.
-- Source: 개발용/addon/battlelog_src.lua (UTF-8); script/addon/battlelog.lua is made from it by 개발용/도구/free_hz.pl.
local PN="\208\213\195\251"-- 姓名
local HP="\177\248\193\166"-- 兵力
local SQ="\202\191\198\248"-- 士气
local MP="\178\223\194\212"-- 策略
local MN="\195\251\179\198"-- 名称
local MAXLOG=3000-- the victory summary adds it all up, so keep a whole battle
local busy=0-- >0 while a logged action runs (the attacks and strategies it sets off belong to it)
local lastFlag2=0

local function pname(wid)
local v=War.Person[wid]
if not v then return "?" end
return JY.Person[v.id][PN] or "?"
end
local function side(wid)
local v=War.Person[wid]
if not v then return 0 end
if v.enemy then return 2 elseif v.friend then return 1 end
return 0
end
local function snap()
local t={}
for i=1,War.PersonNum do
local v=War.Person[i]
if v then
local p=JY.Person[v.id]
t[i]={live=v.live,hide=v.hide,hp=p[HP] or 0,sq=p[SQ] or 0,mp=p[MP] or 0,tr=v.troubled and true or false,po=(v.poison or 0)>0}
end
end
return t
end
-- what happened to unit i between two snapshots: a list of {kind,text}; kind d damage, h heal, k 격파, s status/other
-- skipMP: the caster's own 책략치 cost, skipSQ: 사기 (every hit lowers it)
local function change(b,i,skipMP,skipSQ)
local v=War.Person[i]
local o=b[i]
local s={}
if not v or not o then return s end
local p=JY.Person[v.id]
local d=(p[HP] or 0)-o.hp
if d<0 then s[#s+1]={"d",tostring(d)} elseif d>0 then s[#s+1]={"h","+"..d} end
if o.live and not v.live then s[#s+1]={"k","\130\112\134\086"} end
if v.live then
if v.troubled and not o.tr then s[#s+1]={"s","\130\099\130\100"} elseif o.tr and not v.troubled then s[#s+1]={"s","\130\099\130\100 \139\069\130\079"} end
local po=(v.poison or 0)>0
if po and not o.po then s[#s+1]={"s","\132\096"} elseif o.po and not po then s[#s+1]={"s","\129\066\132\096"} end
local q=(p[SQ] or 0)-o.sq
if q~=0 and d==0 and not skipSQ then s[#s+1]={"s","\130\114\131\071"..(q>0 and "+" or "")..q} end
if not skipMP then
local m=(p[MP] or 0)-o.mp
if m~=0 then s[#s+1]={"s","\130\117\130\118"..(m>0 and "+" or "")..m} end
end
end
return s
end
-- the units that changed: {n=name, s=side, v=values}; the main target first, then the others, the actor last
local function changes(b,main,actor,actorSkipMP,skipSQ)
local out={}
local function one(i,skip)
local c=change(b,i,skip,skipSQ)
if #c>0 then out[#out+1]={n=pname(i),s=side(i),v=c} end
end
if main and main>0 and main~=actor then one(main,false) end
for i=1,War.PersonNum do
if i~=main and i~=actor then one(i,false) end
end
if actor and actor>0 then one(actor,actorSkipMP) end
return out
end
-- e = {a=actor name, k=action, c=critical, r=targets, m=minor}
local function add(actor,e,counter)
War.koLog=War.koLog or {}
local L=War.koLog
local sd=side(actor)
local turn=War.Turn or 0
if not counter and (War.koLogTurn~=turn or War.koLogSide~=sd) then
War.koLogTurn,War.koLogSide=turn,sd
L[#L+1]={h=true,turn=turn,s=sd}
end
e.s=sd
e.r=e.r or {}
L[#L+1]=e
while #L>MAXLOG do table.remove(L,1) end
end
-- 10-14: a dim line from another addon (formation: 자동 진형 changed at the start of a phase), under that unit's side
function koBattleLogNote(wid,text) if JY.Status==GAME_WMAP and War and War.Person and War.Person[wid] then add(wid,{a=pname(wid),k=text,m=true}) end end

-- ---- the log file next to a battle save. First line "turn side" of the last header, then one entry a line:
-- "H<tab>turn<tab>side" or "<side>[m][c]<tab>actor<tab>action<tab>targets" (targets split by \1, a target
-- "side\2name\2values", values split by \3, a value = its kind letter + text). A line without tabs is an older plain entry
local SEP1,SEP2,SEP3="\1","\2","\3"
local pending=nil-- the log read by WarLoad, kept for war_begin when the loaded battle (re)starts its loop
local function logPath(id)
local f=CC.R_GRPFilename[id]
if not f then return nil end
return (f:gsub("%.sav$",""))..".blog"
end
local function writeLog(id)
local p=logPath(id)
if not p then return end
if JY.Status~=GAME_WMAP or not War.koLog then os.remove(p) return end
local h=io.open(p,"wb")
if not h then return end
h:write((War.koLogTurn or -1).." "..(War.koLogSide or -1).."\n")
for _,e in ipairs(War.koLog) do
if e.h then
h:write("H\t"..(e.turn or 0).."\t"..(e.s or 0).."\n")
elseif e.t then
h:write(tostring(e.s or 0).." "..e.t.."\n")
else
local ts={}
for _,r in ipairs(e.r or {}) do
local vs={}
for _,v in ipairs(r.v) do vs[#vs+1]=v[1]..v[2] end
ts[#ts+1]=(r.s or 0)..SEP2..r.n..SEP2..table.concat(vs,SEP3)
end
h:write(tostring(e.s or 0)..(e.m and "m" or "")..(e.c and "c" or "").."\t"..(e.a or "").."\t"..(e.k or "").."\t"..table.concat(ts,SEP1).."\n")
end
end
h:close()
end
local function split(s,sep)
local t={}
if s=="" then return t end
local i=1
while true do
local j=s:find(sep,i,true)
if not j then t[#t+1]=s:sub(i) break end
t[#t+1]=s:sub(i,j-1)
i=j+1
end
return t
end
local function readLog(id)
local p=logPath(id)
local h=p and io.open(p,"rb")
if not h then return nil end
local r={log={}}
local first=true
for line in h:lines() do
line=line:gsub("\r$","")
if first then
first=false
local t,s=line:match("^(%-?%d+) (%-?%d+)$")
r.turn,r.side=tonumber(t),tonumber(s)
elseif line:find("\t",1,true) then
local f=split(line,"\t")
if f[1]=="H" then
r.log[#r.log+1]={h=true,turn=tonumber(f[2]) or 0,s=tonumber(f[3]) or 0}
else
local e={s=tonumber(f[1]:match("^%d+")) or 0,m=f[1]:find("m",1,true) and true or nil,c=f[1]:find("c",1,true) and true or nil,a=f[2] or "",k=f[3] or "",r={}}
for _,ts in ipairs(split(f[4] or "",SEP1)) do
local g=split(ts,SEP2)
local vs={}
for _,v in ipairs(split(g[3] or "",SEP3)) do vs[#vs+1]={v:sub(1,1),v:sub(2)} end
e.r[#e.r+1]={s=tonumber(g[1]) or 0,n=g[2] or "?",v=vs}
end
r.log[#r.log+1]=e
end
else
-- an older plain line: "H text" or "<side>[m] text"
local k,t=line:match("^(%S+) (.*)$")
if k=="H" then r.log[#r.log+1]={t=t,s=-1} elseif k then r.log[#r.log+1]={s=tonumber((k:gsub("m$",""))) or 0,t=t,m=k:sub(-1)=="m" or nil} end
end
end
h:close()
if r.turn==-1 then r.turn=nil end
if r.side==-1 then r.side=nil end
return r
end
local function useLog(r)
War.koLog=r and r.log or {}
War.koLogTurn=r and r.turn or nil
War.koLogSide=r and r.side or nil
end
local rawSave=SaveRecord
SaveRecord=function(id,...)
local a,b,c=rawSave(id,...)
pcall(writeLog,id)
return a,b,c
end
local rawWarLoad=WarLoad
WarLoad=function(id,...)
local a,b,c=rawWarLoad(id,...)
local ok,r=pcall(readLog,id)
if not ok then r=nil end
useLog(r)
pending=r and {r=r,map=War.MapID,turn=War.Turn} or nil
return a,b,c
end
-- 자동 저장 turns A1 -> A2 -> A3 by renaming the files before writing A1: turn the log files the same way
local rawAuto=koAutoSave
koAutoSave=function(...)
if koAutoSaveOn() and not koHook("autosave_block") then
pcall(function()
local p12,p13,p14=logPath(12),logPath(13),logPath(14)
os.remove(p14)
if fileexist(p13) then os.rename(p13,p14) end
if fileexist(p12) then os.rename(p12,p13) end
end)
end
return rawAuto(...)
end

koOn("war_begin",function()
-- a battle resumed from a save starts its loop again: keep the log WarLoad just read (same map and turn)
if pending and pending.map==War.MapID and pending.turn==War.Turn then useLog(pending.r) else useLog(nil) end
pending=nil
end)
koOn("war_atk_scene",function(pid,eid,hurt,sq_hurt,flag2) lastFlag2=flag2 or 0 return nil end)

-- ---- units that end their action without an attack or a strategy (move only, wait, confused): seen when active turns
-- false. Polled from DrawWarMap and before every logged action, so the entries keep their order
local function pollActs()
if JY.Status~=GAME_WMAP or not War.Person then return end
War.koActSeen=War.koActSeen or {}
War.koActPos=War.koActPos or {}
War.koActed=War.koActed or {}
local seen,pos,acted=War.koActSeen,War.koActPos,War.koActed
for i=1,War.PersonNum do
local v=War.Person[i]
if v and v.live and not v.hide then
if v.active then
if seen[i]~=true then pos[i]={v.x,v.y} acted[i]=nil end
elseif seen[i]==true then
if not acted[i] then
local p=pos[i]
local what="\130\095\131\071"
if v.troubled then what="\130\099\130\100\131\109\132\083 \136\108\132\076\129\071\130\067 \136\102\137\072"
elseif p and (p[1]~=v.x or p[2]~=v.y) then what="\129\071\130\108" end
add(i,{a=pname(i),k=what,m=true})
end
acted[i]=nil
end
seen[i]=v.active and true or false
end
end
end
koOn("draw_overlay",function() pollActs() end)

local rawAtk=WarAtk
WarAtk=function(pid,eid,flag)
if busy>0 or JY.Status~=GAME_WMAP then return rawAtk(pid,eid,flag) end
pollActs()
if flag~=1 then War.koActed=War.koActed or {} War.koActed[pid]=true end
local b=snap()
lastFlag2=0
busy=busy+1
local r1,r2,r3=rawAtk(pid,eid,flag)
busy=busy-1
local kind=({[1]="\133\065\130\112",[2]="\130\113\130\114",[3]="\133\066\130\112"})[flag or 0] or "\130\074\130\112"
local r=changes(b,eid,pid,false,true)
if #r==0 then r={{n=pname(eid),s=side(eid),v={{"s","\137\088\129\066 \130\097\130\077"}}}} end
add(pid,{a=pname(pid),k=kind,c=(lastFlag2==2) or nil,r=r},flag==1)
return r1,r2,r3
end

local rawMagic=WarMagic
WarMagic=function(wid,eid,mid,ItemFlag)
if busy>0 or JY.Status~=GAME_WMAP then return rawMagic(wid,eid,mid,ItemFlag) end
pollActs()
War.koActed=War.koActed or {} War.koActed[wid]=true
local b=snap()
busy=busy+1
local r1,r2,r3=rawMagic(wid,eid,mid,ItemFlag)
busy=busy-1
local mname=(JY.Magic[mid] and JY.Magic[mid][MN]) or "?"
local r=changes(b,eid,wid,not ItemFlag,false)
if #r==0 then r={{n=pname(eid),s=side(eid),v={{"s","\129\121\129\123 \130\097\130\077"}}}} end
add(wid,{a=pname(wid),k=mname,r=r})
return r1,r2,r3
end

-- ---- the window
local SIDE={[0]=RGB(130,180,255),[1]=RGB(255,200,120),[2]=RGB(255,150,135)}-- 아군 · 우군 · 적군 (the minimap's blue / orange / red)
local SIDEDIM={[0]=RGB(140,165,210),[1]=RGB(210,180,130),[2]=RGB(215,155,145)}-- 3.6 later: lighter over the pixel panel
local VAL={d=RGB(255,185,90),h=RGB(120,225,120),k=RGB(255,70,70),s=RGB(205,165,255)}-- 피해 · 회복 · 격파 · 상태
local SNAME={[0]="\129\110\130\084",[1]="\131\079\130\084",[2]="\131\076\130\084"}
function koBattleLogShow()
local L=War.koLog or {}
local W,rows,rowh=math.min(660,(War.BoxWidth or 48)*(War.MW or 12)-8),17,20-- 10-14: no wider than the map (frame mode: 576)
local X=math.floor(koMapCenterX(W))
local H=66+rows*rowh+10
local Y=math.floor(koMapCenterY(H))
local C1,C2,C3=X+14,X+14+104,X+14+214-- columns: unit | action | result
local top=Y+66
local sx=X+W-22
War.koLogView=War.koLogView or {f=1,minor=true}
local view=War.koLogView
local lines,n,nn,start
-- entries -> screen rows under the filter (1 전체, 2 아군·우군, 3 적군; minor = 이동·대기 shown)
local function build()
lines={}
local head=nil
for _,e in ipairs(L) do
if e.h then
head=e
else
local ok=(view.f==1) or (view.f==2 and (e.s==0 or e.s==1)) or (view.f==3 and e.s==2)
if e.m and not view.minor then ok=false end
if ok then
if head then lines[#lines+1]={h=head} head=nil end
if e.t then
lines[#lines+1]={t=e.t,s=e.s,m=e.m}
else
local first=true
if #e.r==0 then lines[#lines+1]={e=e} end
for _,r in ipairs(e.r) do
lines[#lines+1]={e=first and e or nil,r=r}
first=false
end
end
end
end
end
n=#lines
nn=math.max(n-rows,0)
start=nn+1-- newest at the bottom
end
build()
local tabs={{"\130\066\133\114",1},{"\129\110\130\084",2},{"\131\076\130\084",3}}
local tabR={}
do
local x=X+14
for i,t in ipairs(tabs) do tabR[i]={x,Y+38,x+52,Y+60} x=x+56 end
end
local minR={X+W-14-120,Y+38,X+W-14,Y+60}
local up={sx,top,sx+16,top+16}
local dn={sx,top+rows*rowh-16,sx+16,top+rows*rowh}
local tr0,tr1=up[4]+2,dn[2]-2
local function tri(r,d)
lib.FillColor(r[1],r[2],r[3],r[4],RGB(0,0,48))
lib.DrawRect(r[1],r[2],r[3],r[4],M_Gray)
local cx,cy=r[1]+8,r[2]+8
for i=0,5 do
local y=(d<0) and (cy-3+i) or (cy+3-i)
lib.FillColor(cx-i,y,cx+i+1,y+1,M_White)
end
end
local function button(r,label,on)
koRecordClassicBar(r[1],r[2],r[3]-r[1],on)
DrawString(r[1]+math.floor((r[3]-r[1]-#label*8)/2),r[2]+3,label,M_White,16)
end
local function vals(x,y,v,maxx)
for _,it in ipairs(v) do
local s=it[2]
if x+#s*8>maxx then DrawString(x,y,"...",M_Gray,16) return end
DrawString(x,y,s,VAL[it[1]] or M_White,16)
x=x+#s*8+8
end
end
local function draw()
DrawWarMap()
koRecordClassicFrame(X,Y,W,H)-- 3.6 later: the pixel panel (ui.grp 270, 660x416)
koBrightText=true-- 3.6 later: lighter greys over the panel (_core.lua)
DrawString(X+14,Y+10,"\130\066\132\101 \131\071\133\108",M_Yellow,16)
DrawString(X+W-14-#"Esc: \131\118\129\094\131\071"*8,Y+10,"Esc: \131\118\129\094\131\071",M_Gray,16)
for i,t in ipairs(tabs) do button(tabR[i],t[1],view.f==t[2]) end
-- legend: who acted (the minimap's colours) next to the tabs, the result numbers on the title row
do
local lx=X+214
for _,k in ipairs({0,1,2}) do
lib.FillColor(lx,Y+44,lx+10,Y+54,SIDE[k])
DrawString(lx+14,Y+41,SNAME[k],SIDE[k],16)
lx=lx+14+#SNAME[k]*8+14
end
lx=X+120
for _,it in ipairs({{"d","\137\088\129\066"},{"h","\130\125\130\068"},{"k","\130\112\134\086"},{"s","\129\067\130\124"}}) do
DrawString(lx,Y+10,it[2],VAL[it[1]],16)
lx=lx+#it[2]*8+12
end
end
button(minR,(view.minor and "[v] " or "[ ] ").."\129\071\130\108\161\164\130\095\131\071",view.minor)
lib.DrawRect(X+8,Y+63,X+W-8,Y+64,M_DimGray)
if n==0 then
DrawString(C1,top+2,#L==0 and "\129\110\132\076 \131\071\133\108\129\071 \130\097\129\075\129\076\129\077." or "\129\071 \129\118\129\119\129\102 \138\071\130\098 \131\071\133\108\129\071 \130\097\129\075\129\076\129\077.",M_Gray,16)
end
local right=(nn>0) and (sx-6) or (X+W-12)
for row=0,rows-1 do
local l=lines[start+row]
if not l then break end
local y=top+row*rowh
if l.h then
lib.FillColor(X+8,y,right,y+rowh-2,RGB(0,0,48))
DrawString(C1,y+1,l.h.turn.."\129\112 "..(SNAME[l.h.s] or ""),M_Yellow,16)
elseif l.t then
DrawString(C1,y+1,l.t,(l.m and SIDEDIM or SIDE)[l.s] or M_Gray,16)
else
local e=l.e
if e then
local sc=(e.m and SIDEDIM or SIDE)[e.s] or M_White
lib.SetClip(C1,y,C2-6,y+rowh)
DrawString(C1,y+1,e.a,sc,16)
lib.SetClip(0,0,0,0)
local kc=e.m and M_Gray or M_White
if e.m then
DrawString(C2,y+1,e.k,kc,16)
else
lib.SetClip(C2,y,C3-6,y+rowh)
DrawString(C2,y+1,e.k,kc,16)
if e.c then DrawString(C2+#e.k*8,y+1,"(\132\081\130\088\133\064)",M_Yellow,16) end
lib.SetClip(0,0,0,0)
end
end
if l.r then
local r=l.r
local nx=C3
DrawString(nx,y+1,r.n,SIDE[r.s] or M_White,16)
nx=nx+#r.n*8+8
vals(nx,y+1,r.v,right-4)
end
end
end
if nn>0 then
tri(up,-1) tri(dn,1)
lib.DrawRect(sx+2,tr0,sx+14,tr1,M_DimGray)
local ty=tr0+math.floor((tr1-tr0-16)*(start-1)/nn)
lib.FillColor(sx+3,ty,sx+14,ty+16,M_Gray)
end
koBrightText=false
end
PlayWavE(0)
koMouseReset()
while true do
JY.ReFreshTime=lib.GetTime()
draw()
ReFresh(0.4)
local e,k=getkey()
if MOUSE.EXIT() then
if koExit then koExit() else koExitAsk() end
end
if (e==3 and k==3) or (e==1 and (k==27 or k==108)) then break end
if e==1 and k==1073741906 then start=math.max(start-1,1) end
if e==1 and k==1073741905 then start=math.min(start+1,nn+1) end
if e==1 and k==1073741899 then start=math.max(start-rows,1) end-- PageUp
if e==1 and k==1073741902 then start=math.min(start+rows,nn+1) end-- PageDown
local hit=false
for i,t in ipairs(tabs) do
local r=tabR[i]
if MOUSE.CLICK(r[1],r[2],r[3],r[4]) then hit=true if view.f~=t[2] then view.f=t[2] PlayWavE(0) build() end end
end
if hit then
elseif MOUSE.CLICK(minR[1],minR[2],minR[3],minR[4]) then
view.minor=not view.minor PlayWavE(0) build()
elseif nn>0 and MOUSE.CLICK(up[1],up[2],up[3],up[4]) then
start=math.max(start-1,1)
elseif nn>0 and MOUSE.CLICK(dn[1],dn[2],dn[3],dn[4]) then
start=math.min(start+1,nn+1)
elseif nn>0 and MOUSE.HOLD(sx,tr0,sx+16,tr1) then
MOUSE.enableclick=false
start=limitX(1+math.floor((MOUSE.y-8-tr0)*nn/math.max(tr1-tr0-16,1)+0.5),1,nn+1)
elseif MOUSE.CLICK(X,Y,X+W,Y+H) then
-- a click inside the window does nothing
elseif MOUSE.CLICK() then
break
end
end
PlayWavE(1)
end

-- ---- 전투 결과 (victory summary): every general of our army that took part, from the log: 격파 (enemies routed by
-- its action), 준 피해 (enemy troops it took, counters included), 회복 (troops it gave back to our side), 받은 피해.
-- MVP = the highest 준 피해 + 회복 + 격파 x 500. Shown on war_won (before the other war_won handlers), 기능설정 "\130\066\132\101 \134\064\129\123"
local function koBattleStats()
local own={}-- name -> row
local order={}
for i=1,War.PersonNum do
local v=War.Person[i]
if v and (not v.enemy) and (not v.friend) and not (v.hide and v.live) then
local nm=pname(i)
if not own[nm] then
own[nm]={n=nm,pid=v.id,live=v.live,kill=0,dmg=0,heal=0,hurt=0}
order[#order+1]=own[nm]
end
end
end
for _,e in ipairs(War.koLog or {}) do
if not e.h and not e.t then
local me=(e.s==0) and own[e.a]
for _,r in ipairs(e.r or {}) do
for _,v in ipairs(r.v) do
local num=tonumber(v[2])
if me and r.s==2 then
if v[1]=="d" and num then me.dmg=me.dmg-num elseif v[1]=="k" then me.kill=me.kill+1 end
elseif me and r.s~=2 and v[1]=="h" and num then
me.heal=me.heal+num
end
if e.s==2 and r.s==0 and own[r.n] and v[1]=="d" and num then own[r.n].hurt=own[r.n].hurt-num end
end
end
end
end
for _,o in ipairs(order) do o.score=o.dmg+o.heal+o.kill*500 end
table.sort(order,function(a,b) if a.score~=b.score then return a.score>b.score end return a.pid<b.pid end)
local mvp=(order[1] and order[1].score>0) and order[1] or nil
return order,mvp
end
-- ---- MVP reward: 경험 +50 (a level up past 100 is done here: level +1, ReSetAttrib, like WarLvUp without its scene)
-- and one more MVP in the 도감 (격파 순위 tab). Not in a free battle (like 출전 성장).
-- The count lives in the save's person record, field 一击 (offset 104): a duel skill the game always reads from
-- newgame (Person_S flag false), so the save's two bytes there are never read; count = save value - newgame value.
-- It is kept on the general's 도감 (canonical) record, always below 421 where that rule holds, and carried to the next cycle
local MVPOFF=104
local EXP="\190\173\209\233"-- 经验
local LV="\181\200\188\182"-- 等级
local function mvpSlot(pid)
local c=pid
if pid>=421 then c=(rawget(_G,"koRecCanonOf") and koRecCanonOf(pid)) or 0 end
if c<=0 or c>=421 then return nil end
return c*CC.PersonSize+MVPOFF
end
function koMVPCount(pid)
local o=mvpSlot(pid)
if not o then return 0 end
return math.max(Byte.get16(JY.Data_Person,o)-Byte.get16(JY.Data_Person_Base,o),0)
end
local function mvpSet(pid,n)
local o=mvpSlot(pid)
if o then Byte.set16(JY.Data_Person,o,Byte.get16(JY.Data_Person_Base,o)+math.min(n,9999)) end
end
local function giveExp(pid,n)
local p=JY.Person[pid]
local lv0=p[LV]
if lv0>=99 then return {lv0=lv0,lv1=lv0,max=true} end
local e=p[EXP]+n
while e>=100 and p[LV]<99 do
e=e-100
p[LV]=p[LV]+1
ReSetAttrib(pid,false)
end
if p[LV]>=99 then e=0 end
p[EXP]=e
return {lv0=lv0,lv1=p[LV]}
end
local function mvpReward(mvp)
if CC.koFree or not CC.Enhancement then return nil end
mvpSet(mvp.pid,koMVPCount(mvp.pid)+1)
local r=giveExp(mvp.pid,50)
r.count=koMVPCount(mvp.pid)
return r
end
if type(CC.koNG)=="table" and type(CC.koNG.reset)=="function" then
local rawReset=CC.koNG.reset
CC.koNG.reset=function(...)
local keep={}
for i=1,420 do local n=koMVPCount(i) if n>0 then keep[i]=n end end
local a,b,c=rawReset(...)
if a~=false then for i,n in pairs(keep) do mvpSet(i,n) end end
return a,b,c
end
end
local function rewardText(r)
if not r then return nil end
local s="\131\115\129\067: \131\064\133\085 +50"
if r.max then s="\131\115\129\067: \131\064\133\085 (\136\122\131\100 \130\082\130\123)" elseif r.lv1>r.lv0 then s=s.."  Lv "..r.lv0.." > "..r.lv1 end
return s.."  (MVP "..r.count.."\130\125\142\091)"
end
function koBattleSummary()
if type(War)~="table" or type(War.Person)~="table" then return end
local list,mvp=koBattleStats()
if not mvp then return end
War.koMVP=mvp.pid
local reward=mvpReward(mvp)
if (CC.koBattleSum or 1)~=1 then
local t=rewardText(reward)
if t then PlayWavE(12) WarDrawStrBoxConfirm("MVP "..mvp.n.."*"..t,M_White,true) end
return
end
local rows=math.min(#list,13)
local W,rowh=600,24
local H=116+(rows+1)*rowh+46
local X=math.floor((CC.ScreenW-W)/2)
local Y=math.floor((CC.ScreenH-H)/2)
local cols={{"\130\112\134\086",X+300,"kill"},{"\131\101 \137\088\129\066",X+400,"dmg"},{"\130\125\130\068",X+480,"heal"},{"\133\072\131\098 \137\088\129\066",X+W-20,"hurt"}}-- right edges
local ok={X+W/2-40,Y+H-36,X+W/2+40,Y+H-12}
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function rnum(xr,y,s,c) DrawString(xr-#s*8,y,s,c,16) end
local function draw()
lib.LoadSur(sid,0,0)
lib.Background(0,0,CC.ScreenW,CC.ScreenH,128,M_Black)
koRecordClassicFrame(X,Y,W,H)
local title="\130\066\132\101 \134\064\129\123"
DrawString(X+20,Y+12,title,M_Yellow,16)
local sub=(War.WarName or "").."  "..(War.Turn or 0).."\129\112 \129\116\129\117"
DrawString(X+W-20-#sub*8,Y+12,sub,M_White,16)
lib.DrawRect(X+10,Y+36,X+W-10,Y+37,M_DimGray)
-- MVP line
local mp=JY.Person[mvp.pid]
koRecordClassicFrame(X+10,Y+44,W-20,52)
lib.DrawRect(X+10,Y+44,X+W-10,Y+96,RGB(220,170,60))
DrawString(X+22,Y+52,"MVP",M_Yellow,16)
DrawString(X+70,Y+52,mvp.n,M_White,16)
local why="\130\112\134\086 "..mvp.kill.."  \131\101 \137\088\129\066 "..mvp.dmg..(mvp.heal>0 and ("  \130\125\130\068 "..mvp.heal) or "")
DrawString(X+W-22-#why*8,Y+52,why,RGB(255,220,140),16)
local rt=rewardText(reward) or (CC.koFree and "\133\120\130\071 \130\066\132\101\130\098 MVP \131\115\129\067\129\071 \130\097\129\075\129\076\129\077") or nil
if rt then DrawString(X+70,Y+72,rt,RGB(120,225,120),16) end
-- table
local ty=Y+106
DrawString(X+20,ty,"\129\073\131\097",M_Gray,16)
for _,c in ipairs(cols) do rnum(c[2],ty,c[1],M_Gray) end
for i=1,rows do
local o=list[i]
local y=ty+i*rowh
if i%2==0 then lib.FillColor(X+10,y-3,X+W-10,y+rowh-5,RGB(0,0,48)) end
local nc=o.live and RGB(130,180,255) or M_Gray
DrawString(X+20,y,o.n,nc,16)
if not o.live then DrawString(X+20+#o.n*8+6,y,"(\133\068\130\069)",M_Gray,16) end
rnum(X+300,y,tostring(o.kill),o.kill>0 and RGB(255,70,70) or M_DimGray)
rnum(X+400,y,tostring(o.dmg),o.dmg>0 and RGB(255,185,90) or M_DimGray)
rnum(X+480,y,tostring(o.heal),o.heal>0 and RGB(120,225,120) or M_DimGray)
rnum(X+W-20,y,tostring(o.hurt),o.hurt>0 and RGB(205,165,255) or M_DimGray)
end
if #list>rows then DrawString(X+20,ty+(rows+1)*rowh,"\131\107 "..(#list-rows).."\130\088",M_Gray,16) end
local hot=MOUSE.IN(ok[1],ok[2],ok[3],ok[4])
koRecordClassicBar(ok[1],ok[2]+1,ok[3]-ok[1],hot)
DrawString(ok[1]+24,ok[2]+4,"\129\105\129\106",M_White,16)
end
PlayWavE(12)
koMouseReset()
while true do
JY.ReFreshTime=lib.GetTime()
draw()
ReFresh(0.4)
local e,k=getkey()
if MOUSE.EXIT() then
if koExit then koExit() else koExitAsk() end
end
if (e==3 and k==3) or (e==1 and (k==27 or k==13 or k==32)) then break end
if MOUSE.CLICK() then break end
end
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
PlayWavE(0)
end
koAddon.hooks.war_won=koAddon.hooks.war_won or {}
table.insert(koAddon.hooks.war_won,1,function() local ok,err=pcall(koBattleSummary) if not ok then lib.Debug("koBattleSummary: "..tostring(err)) end return nil end)
koAddon.settings[#koAddon.settings+1]={key="koBattleSum",label="\130\066\132\101 \134\064\129\123",opts={{"\131\115\131\071",1},{"\133\117",0}},default=1}

koAddon.barButtons[#koAddon.barButtons+1]={label="\131\071\133\108",run=function() koBattleLogShow() return false end}
koAddon.warMenu[#koAddon.warMenu+1]={label="\130\066\132\101 \131\071\133\108",run=function() koBattleLogShow() end}
koOn("battle_key",function(k)
if k==108 and War.ControlStatus=="select" and War.ControlEnable then koBattleLogShow() return 0 end
return nil
end)
