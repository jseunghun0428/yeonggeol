-- ko 5.0: 전투·책략 미리보기 다시 그리기 (addon "preview2", preview 다음에 로드; 사용자 "\131\115\131\071\129\094 \130\083\138\113\131\100 \129\094\132\096\131\123\129\071 \138\090\132\083 / \131\115\129\070\129\071 \129\073\135\074\129\106\130\067").
-- The numbers are still those of the preview addon (koAtkPreview / koMagicPreview: the game's own WarAtkHurt / WarMagicHurt); only the
-- panel is new: 공격 and 반격 in sections of their own, the troops as a bar (before → after), the damage on its own line, and the
-- "\131\115\129\070" split by where it comes from — 상성 (class matchup, damage points), 진형, 지형 (the defender's cell), 특기 (the rest) — only the
-- ones that are not zero, green when they help the player and red when they hurt. The 책략 panel is a table: 대상 / 성공 / 피해 / 효과.
-- Build (game folder): perl "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/\129\068\130\119/free_hz.pl" < "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/addon/preview2_src.lua" > script/addon/preview2.lua
if not rawget(_G,"koAtkPreview") then return end
local P_NAME,P_BL,P_MAXBL,P_SQ,P_MP,P_WEAPON="\208\213\195\251","\177\248\193\166","\215\238\180\243\177\248\193\166","\202\191\198\248","\178\223\194\212","\206\228\198\247"
local I_SKILL="\204\216\188\188"-- 特技 (of an item)
local TERR={[0]=0,20,30,0,0,0,0,5,5,0,0,0,0,30,10}-- the defence % of a cell (as ReSetBuff)
local PW=300-- panel width (the 책략 panel 340: its 효과 column, QA)
local GOOD,BAD,DIM-- (the colours are defined after the addons load: set on first draw)
local function colours() GOOD,BAD,DIM=M_Lime,M_Red,M_Silver end

-- the panel: a list of rows {h=height, draw=function(x,y)}; placed like the old one (beside the target, clear of the attacker)
local function newPanel() local P={rows={},h=0} function P.add(h,f) P.rows[#P.rows+1]={h=h,f=f} P.h=P.h+h end return P end
-- (QA: the old placement — beside the target, on the side away from the screen's middle — often covered other units)
-- tgt = the War unit the panel is about, avoid = units it must never cover (attacker, target, every unit in a 책략's area).
-- A few spots around the target are tried (right, left, above, below — each kept on screen); the one covering the fewest
-- units wins, any covering an avoid unit only if nothing else is left. Same frame as koPreviewBox (dark backing, thin border).
local function showPanel(P,tgt,avoid)
local rows=math.ceil((P.h+4)/20)
local W,H=PW,16+20*rows
local BW,BD=War.BoxWidth,War.BoxDepth
local function cell(u) return War.OX+BW*(u.x-War.CX),War.OY+BD*(u.y-War.CY) end
local cx,cy=cell(tgt)
local cand={{cx+BW+2,cy},{cx+BW+2,cy-H+BD},{cx-W-2,cy},{cx-W-2,cy-H+BD},{cx+BW/2-W/2,cy-H-2},{cx+BW/2-W/2,cy+BD+2}}
if tgt.x-War.CX>math.modf(War.MW/2) then cand[1],cand[3]=cand[3],cand[1] cand[2],cand[4]=cand[4],cand[2] end-- the old side first on ties
local av={} for _,u in ipairs(avoid or {}) do av[u]=true end
local best,bs=nil,math.huge
for k,c in ipairs(cand) do
local x=limitX(math.floor(c[1]),War.OX or 0,math.max(War.OX or 0,((War.OX or 0)+(War.BoxWidth or 48)*(War.MW or 12))-W))-- 10-14: inside the map, not the whole screen
local y=limitX(math.floor(c[2]),War.OY or 0,math.max(War.OY or 0,((War.OY or 0)+(War.BoxDepth or 48)*(War.MD or 9))-H))
local s=k*0.01
for _,u in pairs(War.Person) do
if u.live and not u.hide then
local ux,uy=cell(u)
if ux+BW>x and ux<x+W and uy+BD>y and uy<y+H then s=s+(av[u] and 100 or 1) end
end
end
if s<bs then best,bs={x,y},s end
end
local x,y=best[1],best[2]
koRecordClassicFrame(x,y,W,H)
lib.SetClip(x+8,y+8,x+W-8,y+H-8)
x,y=x+8,y+8
for _,r in ipairs(P.rows) do r.f(x,y) y=y+r.h end
lib.SetClip(0,0,0,0)
end
local function hline(x,y) lib.DrawRect(x,y,x+PW-16,y,M_Silver) end
-- a section head: a dim band with the label (and a note on its right)
local function head(P,label,note,col)
P.add(22,function(x,y)
lib.FillColor(x,y+1,x+PW-16,y+19,RGB(0,0,48))
DrawString(x,y+2,label,col or C_Name,16)
if note then DrawString(x+PW-20-#note*8,y+2,note,M_White,16) end
end)
end
-- troops before → after as text and a bar (grey = lost, colour = left; scale = the unit's full troops)
local function troopRow(P,name,team,b0,b1,mx,kill,b1txt)-- b1txt: ko 5.0 dmgvary, "0~59" when the spread may or may not kill
P.add(20,function(x,y)
DrawString(x,y,name,team,16)
local s=b0.."\161\250"..(b1txt or b1)
DrawString(x+#name*8+8,y,s,M_White,16)
local bx,bw=x+PW-122,104
mx=math.max(mx or 1,1)
local f0,f1=math.floor(bw*math.min(b0,mx)/mx),math.floor(bw*math.min(b1,mx)/mx)
lib.FillColor(bx,y+5,bx+bw,y+13,RGB(30,30,30))
if f0>f1 then lib.FillColor(bx+f1,y+5,bx+f0,y+13,RGB(120,40,40)) end
local ra=b1/mx
if f1>0 then lib.FillColor(bx,y+5,bx+f1,y+13,(ra>0.6 and RGB(60,190,80)) or (ra>0.3 and RGB(220,190,50)) or RGB(220,70,60)) end
lib.DrawRect(bx,y+4,bx+bw,y+4,M_Gray) lib.DrawRect(bx,y+14,bx+bw,y+14,M_Gray) lib.DrawRect(bx,y+4,bx,y+14,M_Gray) lib.DrawRect(bx+bw,y+4,bx+bw,y+14,M_Gray)
if kill then DrawString(bx-36,y,"\130\112\134\086",M_Yellow,16) end
end)
end
-- the "where the % comes from" row: chips {text, good?}; nothing when every part is zero
local function chipRow(P,chips)
if #chips==0 then return end
-- wrapped onto as many rows as needed (the matchup chip is long)
local line,w={},0
local function flush()
if #line==0 then return end
local l=line
P.add(20,function(x,y) local cx=x for _,c in ipairs(l) do DrawString(cx,y,c[1],c[2] and GOOD or BAD,16) cx=cx+#c[1]*8+14 end end)
line,w={},0
end
for _,c in ipairs(chips) do
local cw=#c[1]*8+14
if w>0 and w+cw-14>PW-16 then flush() end
line[#line+1]=c w=w+cw
end
flush()
end
local function itemskill(pid) local w=JY.Person[War.Person[pid].id][P_WEAPON] return w and w>0 and JY.Item[w] and JY.Item[w][I_SKILL] or 0 end
-- chips for hitter hid hitting tid: m = koAtkMod's {net,atk,def,fa,fd,fn1,fn2}, bz/bzd = matchup and its damage
-- ko 5.0 (10-10 사용자: 같은 기병인데 「병종상성 불리」): koMatchup 의 ±1 은 병종표만이 아니라 파진(특기 110·무기 10)·견고(특기 111·무기 11·무기 특기 111)
--  에서도 나옴 → 그 까닭을 이름으로 (무기면 무기 이름)
local I_NAME="\195\251\179\198"-- 名称 (of an item)
local function matchWhy(hid,tid,bz)
if CC.Enhancement then
local pa,pd=JY.Person[War.Person[hid].id],JY.Person[War.Person[tid].id]
if bz>0 then
if WarCheckSkill(hid,110) then return "\134\086\129\103" end
if pa[P_WEAPON]==10 then return "\134\086\129\103("..JY.Item[10][I_NAME]..")" end
else
if WarCheckSkill(tid,111) then return "\134\084\131\100" end
local w=pd[P_WEAPON]
if w==11 or (w and w>0 and JY.Item[w] and JY.Item[w][I_SKILL]==111) then return "\134\084\131\100("..JY.Item[w][I_NAME]..")" end
end
end
return "\130\126\129\084\129\067\131\123"
end
local function factors(hid,tid,m,bz,bzd,ctr)
local chips={}
local mine=not (War.Person[hid].enemy or War.Person[hid].friend)-- a + helps the player when the hitter is ours
local function add(txt,v) if v~=0 then chips[#chips+1]={txt,(v>0)==mine} end end
if (bz or 0)~=0 and (bzd or 0)~=0 then add(string.format("%s%s %s(\137\088\129\066%+d)",bz>0 and "\161\248" or "\168\139",matchWhy(hid,tid,bz),bz>0 and "\130\071\129\117" or "\133\100\129\117",bzd),bzd) end
if m and m[2] then
local fa,fd=m[4] or 0,m[5] or 0
if m[6] or m[7] then add(string.format("\129\103\136\069 %+d%%",fa-fd),fa-fd) end
-- ko 5.0 진형 12종: 그 한 번의 몫(활공·활방·돌격·일제), 지형 불일치(보정 절반·특수 꺼짐), 언월 회심
if rawget(_G,"koFormHitMod") then
local ha,hd,why=koFormHitMod(hid,tid,ctr)
if why and ha-hd~=0 then add("\129\103\136\069("..why..")",ha-hd) end
if not koFormFits(hid) then add("\129\103\136\069 \130\067\136\069\133\100\133\073\132\081",-1) end
if koFormName(War.Person[hid])=="\136\065\135\099" and koFormFits(hid) then add("\136\065\135\099 \130\125\134\100 10%",1) end
end
local t=War.Person[tid]
local dx=GetWarMap(t.x,t.y,1)
local tp=TERR[dx] or 0
if WarCheckSkill(hid,118) or itemskill(hid)==118 then tp=0 end
if tp~=0 then add("\130\067\136\069("..(War.DX[dx] or "")..string.format(") %+d%%",-tp),-tp) end
local sg=rawget(_G,"koSiegePct") and koSiegePct(hid,tid) or 0
if sg~=0 then add(string.format("\130\074\131\123 %+d%%",sg),sg) end
if rawget(_G,"koStratClass") and koStratClass(tid) then add("\130\117\130\114 -15%",-15) end-- (jymain patch_책사: strategists take 15% less physical damage)
local sk=(m[2]-fa)-((m[3]-fd)-tp)
add(string.format("\129\120\131\071 %+d%%",sk),sk)
elseif m and m[3] and m[3]~=0 then
add(string.format("\130\067\136\069 %+d%%",-m[3]),-m[3])-- (not enhanced: only the terrain)
end
return chips
end
local function tagOf(f,dead)
if dead then return "\130\112\134\086",M_Yellow end
if f==2 then return "\132\081\130\088",M_Yellow elseif f==1 then return "\132\078\130\083\144\091",DIM end
return nil
end
-- the hit line: "\137\088\129\066 N" in yellow, then its tag
local function hurtRow(P,label,h,tag,tagc)
P.add(20,function(x,y)
DrawString(x,y,label,M_White,16)
DrawString(x+#label*8+8,y,tostring(h),M_Yellow,16)
if tag then DrawString(x+#label*8+16+#tostring(h)*8,y,tag,tagc,16) end
end)
end

function koDrawAtkPreview(scl,eid)
PW=300
colours()
local D=WarDrawStrBoxDelay
WarDrawStrBoxDelay=function() end
rawset(_G,"koFormNoRoll",true)-- (formation: no 언월 회심 roll while predicting)
local ok,r=pcall(koAtkPreview,scl,eid)
-- ko 5.0 (10-13) dmgvary: the same prediction at the low and high end of the ±10% spread (each hit of the chain at that end)
local rlo,rhi
if ok and rawget(_G,"koVaryOn") and koVaryOn() then
local ok1,a,ok2,b
rawset(_G,"koVaryMode","min") ok1,a=pcall(koAtkPreview,scl,eid)
rawset(_G,"koVaryMode","max") ok2,b=pcall(koAtkPreview,scl,eid)
rawset(_G,"koVaryMode",nil)
if ok1 and ok2 then rlo,rhi=a,b end
end
rawset(_G,"koFormNoRoll",nil)
WarDrawStrBoxDelay=D
CC.koBZOff=nil
if not ok then lib.Debug("koAtkPreview: "..tostring(r)) return end
local wa,wd=War.Person[scl],War.Person[eid]
local p1,p2=JY.Person[wa.id],JY.Person[wd.id]
-- 학익 (formation addon): the counter roll gets +15% of 150 (not shown by the preview addon's chance)
if r.ctr and rawget(_G,"koFormCounter") and r.ctr.chance<100 and not (CC.Enhancement and (WarCheckSkill(eid,102) or WarCheckSkill(eid,19) or itemskill(eid)==19)) then
r.ctr.chance=math.min(100,math.floor((JY.Person[wd.id]["\206\228\193\166\050"]+koFormCounter(eid))*100/150))
end
local P=newPanel()
-- title: attacker → defender
P.add(22,function(x,y)
DrawString(x,y+2,p1[P_NAME],koTeamColor(wa),16)
local ax=x+#p1[P_NAME]*8+8
DrawString(ax,y+2,"\161\250",M_White,16)
DrawString(ax+24,y+2,p2[P_NAME],koTeamColor(wd),16)
if rawget(_G,"koGuardPreview") then DrawString(ax+24+#p2[P_NAME]*8+6,y+2,"(\134\113\130\110)",M_Yellow,16) end-- 10-11 tank: this unit takes the hit for the one picked
-- (머리의 ▲유리/▼불리 배지는 뺌 — 사용자: 칩 줄에 병종상성·진형상성이 따로 나오니 필요 없음)
end)
-- 공격
head(P,"\130\074\130\112",r.first and "\129\067\130\095\129\094 \137\113\133\102 \133\065\130\112" or nil,r.first and M_Red or nil)
local runs={r,rlo,rhi}
local function span(get) local lo,hi for i=1,3 do local v=runs[i] and get(runs[i]) if v then lo=math.min(lo or v,v) hi=math.max(hi or v,v) end end return lo,hi end
local function rng(a,b) if a==b then return a end return a.."~"..b end
-- tag: 격파 when even the weakest roll kills, 격파 가능 when only the stronger ones do
local function tagV(f,blmax,blmin) if blmax<=0 then return tagOf(f,true) end if blmin<=0 then return "\130\112\134\086 \129\094\131\077",M_Yellow end return tagOf(f,false) end
local h1,h2=span(function(t) return t.hurt end)
local b1,b2=span(function(t) return t.bl2 end)
local t1,tc1=tagV(r.flag2,b2,b1)
hurtRow(P,"\137\088\129\066",rng(h1,h2),t1,tc1)
local f1,f2=span(function(t) return t.bl3 or t.bl2 end)
troopRow(P,p2[P_NAME],koTeamColor(wd),p2[P_BL],r.bl3 or r.bl2,p2[P_MAXBL],f2<=0,(f1<=0 and f2>0) and ("0~"..f2) or nil)
P.add(20,function(x,y) DrawString(x,y,"\130\114\131\071 "..p2[P_SQ].."\161\250"..r.sq2,M_White,16) end)
chipRow(P,factors(scl,eid,r.mod,r.bz,r.bzd))
-- 반격
if not r.ctr and rlo and rlo.ctr then r.ctr,r.ctr2,r.rip,r.bl3=rlo.ctr,rlo.ctr2,rlo.rip,rlo.bl3 runs[1]=rlo end-- the middle kills, the low end does not: the counter can still come
if r.ctr then
head(P,r.first and "\133\109\129\100 \133\065\130\112" or "\133\065\130\112",string.format("\129\105\137\101 %d%%",r.ctr.chance),r.first and M_Red or nil)
local last=(r.ctr2 or r.ctr).bl1
local c1,c2=span(function(t) return t.ctr and t.ctr.hurt end)
local k1,k2=span(function(t) return t.ctr and t.ctr.bl1 end)
local t2,tc2=tagV(r.ctr.flag2,k2,k1)
hurtRow(P,"\137\088\129\066",rng(c1,c2),t2,tc2)
if r.ctr2 then local d1,d2=span(function(t) return t.ctr2 and t.ctr2.hurt end) local e1,e2=span(function(t) return t.ctr2 and t.ctr2.bl1 end) local t3,tc3=tagV(r.ctr2.flag2,e2,e1) hurtRow(P,"\129\111 \130\087 \132\108",rng(d1,d2),t3,tc3) end
local l1,l2=span(function(t) return t.ctr and (t.ctr2 or t.ctr).bl1 end)
troopRow(P,p1[P_NAME],koTeamColor(wa),p1[P_BL],last,p1[P_MAXBL],l2<=0,(l1<=0 and l2>0) and ("0~"..l2) or nil)
chipRow(P,factors(eid,scl,r.ctr.mod,r.ctr.bz,r.ctr.bzd,true))
if r.rip then local g1,g2=span(function(t) return t.rip and t.rip.hurt end) local m1,m2=span(function(t) return t.rip and (t.bl3 or 1) end) local t4,tc4=tagV(r.rip.flag2,m2,m1) hurtRow(P,"\132\067\133\072\129\110\132\081\131\071",rng(g1,g2),t4,tc4) end
else
head(P,"\133\065\130\112 \130\097\130\077",nil,DIM)
end
if (r.jy or 0)>0 then P.add(20,function(x,y) DrawString(x,y,"\131\064\133\085 +"..r.jy,M_White,16) end) end
showPanel(P,wd,{wa,wd})
end

function koDrawMagicPreview(scl,eid,mid,item)
PW=340
colours()
local D=WarDrawStrBoxDelay
WarDrawStrBoxDelay=function() end
local ok,r=pcall(koMagicPreview,scl,eid,mid,item)
WarDrawStrBoxDelay=D
if not ok then lib.Debug("koMagicPreview: "..tostring(r)) return end
local wa,wd=War.Person[scl],War.Person[eid]
local p1=JY.Person[wa.id]
local function pct(v) return math.floor(v*100+0.5) end
local function range(a,b) if a==b then return tostring(a) end return a.."~"..b end
local function pcol(p) return (p>=70 and GOOD) or (p>=40 and M_Yellow) or BAD end
local P=newPanel()
-- title: the 책략 (twice / 연계 notes on the right)
P.add(22,function(x,y)
DrawString(x,y+2,r.name,M_Yellow,16)
local n=(#r.targets>1) and ("("..#r.targets.."\130\094\130\095)") or ""
DrawString(x+#r.name*8+8,y+2,n,M_White,16)
local tags={}
if r.twice then tags[#tags+1]="2\130\125 \130\086\130\066" end
if (not r.item) and rawget(_G,"koTwinOn") and koTwinOn(scl) then tags[#tags+1]="\133\066\132\084" end
local s=table.concat(tags," \161\164 ")
if s~="" then DrawString(x+PW-20-#s*8,y+2,s,M_Magenta,16) end
end)
-- the table
local C2,C3,C4=96,148,232
P.add(22,function(x,y)
lib.FillColor(x,y+1,x+PW-16,y+19,RGB(0,0,48))
DrawString(x,y+2,"\130\095\129\067",C_Name,16) DrawString(x+C2,y+2,"\131\123\130\074",C_Name,16)
DrawString(x+C3,y+2,r.aid and "\130\125\130\068" or "\137\088\129\066",C_Name,16) DrawString(x+C4,y+2,"\129\121\129\123",C_Name,16)
end)
local maxrows=6
for i=1,math.min(#r.targets,maxrows) do
local t=r.targets[i]
P.add(20,function(x,y)
DrawString(x,y,t.name,koTeamColor(t.w),(#t.name>8) and 12 or 16)
if r.aid then
DrawString(x+C2,y,"-",DIM,16)
if t.hp1 then DrawString(x+C3,y,"+"..range(t.hp1,t.hp2),t.hp2>0 and GOOD or DIM,16) end
local fx=(t.sq1 and t.sq2>0 and ("\130\114\131\071+"..range(t.sq1,t.sq2))) or (t.detox and "\129\066\132\096") or (t.cure1 and ("\130\099\130\100\161\253"..range(t.cure1,t.cure2).."%")) or ""
if fx=="" and (t.hp2 or 0)==0 then DrawString(x+C4,y,"\129\121\129\123 \130\097\130\077",DIM,16) else DrawString(x+C4,y,fx,GOOD,16) end
elseif r.kind==4 then
if t.troubled then DrawString(x+C2,y,"\129\071\134\119 \130\099\130\100",DIM,16) else local p=pct(t.hit) DrawString(x+C2,y,p.."%",pcol(p),16) DrawString(x+C4,y,"\130\099\130\100",M_White,16) end
elseif r.kind==5 then
local p=pct(t.hit) DrawString(x+C2,y,p.."%",pcol(p),16) DrawString(x+C4,y,"\130\114\131\071-"..t.sq1,M_White,16)
elseif not t.ok then
DrawString(x+C2,y,"\133\100\129\094",DIM,16)
else
local p=pct(t.hit)
DrawString(x+C2,y,p.."%",pcol(p),16)
DrawString(x+C3,y,range(t.hurt1,t.hurt2),M_Yellow,16)
local fx,fc=nil,M_White
if t.kill then fx,fc="\130\112\134\086",M_Yellow elseif t.conf then fx="\130\099\130\100"..t.conf.."%" elseif t.poi then fx,fc="\132\096"..t.poi.rate.."%",GOOD end
if fx then DrawString(x+C4,y,fx,fc,16) end
end
end)
end
if #r.targets>maxrows then P.add(20,function(x,y) DrawString(x,y,"\131\107 "..(#r.targets-maxrows).."\130\094\130\095",DIM,16) end) end
-- the first target's troops (damage: the biggest hit leaves the least)
local t=r.targets[1]
local p2=JY.Person[wd.id]
if t and not r.aid and t.ok and t.hurt2 then
troopRow(P,p2[P_NAME],koTeamColor(wd),p2[P_BL],math.max(p2[P_BL]-t.hurt2,0),p2[P_MAXBL],t.kill)
if (t.sq2 or 0)>0 then P.add(20,function(x,y) DrawString(x,y,"\130\114\131\071 "..p2[P_SQ].."\161\250"..math.max(p2[P_SQ]-t.sq2,0)..((t.poi and ("  \132\096 "..t.poi.turns.."\129\112")) or ""),M_White,16) end) end
elseif t and r.aid and t.hp1 then
troopRow(P,p2[P_NAME],koTeamColor(wd),p2[P_BL],math.min(p2[P_BL]+t.hp2,p2[P_MAXBL]),p2[P_MAXBL],false)
end
-- cost and experience
P.add(20,function(x,y)
hline(x,y)
local s=r.item and "\129\068\130\119 \130\114\132\111" or ("\130\117\130\118 "..r.cost.." \129\109\130\090 ("..r.mp.."\161\250"..math.max(r.mp-r.cost,0)..")")
DrawString(x,y+2,s,(not r.item and r.mp<r.cost) and BAD or M_White,16)
if (r.jy or 0)>0 then local e="\131\064\133\085 +"..r.jy DrawString(x+PW-20-#e*8,y+2,e,M_White,16) end
end)
local av={War.Person[scl],wd} for _,tt in ipairs(r.targets) do av[#av+1]=tt.w end
showPanel(P,wd,av)
end

