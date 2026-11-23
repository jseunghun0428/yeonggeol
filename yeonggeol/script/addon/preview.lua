-- ko 3.0: battle preview ("전투 미리보기"). While the player is picking the target of a normal attack,
-- the popup over an enemy in range shows what WarAtkHurt will do (damage is deterministic in this
-- engine: no random roll) and what the counterattack would be, with its chance (random(150) <= 武力2).
local koPK_BL="\177\248\193\166"          -- 兵力
local koPK_BLMAX="\215\238\180\243\177\248\193\166"
local koPK_SQ="\202\191\198\248"          -- 士气
local koPK_NAME="\208\213\195\251"        -- 姓名
local koPK_BZ="\177\248\214\214"          -- 兵种
local koPK_LV="\181\200\188\182"          -- 等级
local koPK_WU2="\206\228\193\166\050"     -- 武力2 (with equipment)
local koPK_WEAPON="\206\228\198\247"      -- 武器
local koPK_SKILL="\204\216\188\188"       -- 特技 (of an item)
local koPK_RANGED="\212\182\179\204"      -- 远程 (of a class)
local koPL_TITLE="\129\107\129\067"       -- 예상
local koPL_HURT="\137\088\129\066"        -- 피해
local koPL_CTR="\133\065\130\112"         -- 반격
local koPL_CRIT="\130\125\134\100"        -- 회심
local koPL_GUARD="\132\078\130\083"       -- 방어
local koPL_KILL="\130\112\134\086"        -- 격파
local koPL_EXP="\131\064\133\085"         -- 경험
local koPL_BL="\130\126\131\125"          -- 병력
local koPL_SQ="\130\114\131\071"          -- 사기
local koPL_KS="\134\064\130\114"          -- ko 3.2: 결사 (the extra counter)
local koPL_KJ="\134\064\130\066"          -- ko 3.2: 결전 (the attacker's riposte)
local koPL_NONE="\130\097\130\077"        --없음
local koPL_FIRST="\133\109\129\100"       -- 선제
local koPL_ARROW="\161\250"               -- →
local koPL_MOD="\131\115\129\070"         -- ko 3.3: 보정
local koPL_ATKB="\130\074"                -- 공
local koPL_DEFB="\132\078"                -- 방
local koPL_TERR="\130\067\136\069"        -- 지형
-- defence bonus (%) of each terrain type, the table in WarAtkHurt
local koPK_TERRT={[0]=0,20,30,0,0,0,0,5,5,0,0,0,0,30,10}

-- ko 3.3 hotfix 5: the buff part of WarAtkHurt for pid hitting eid, read at the moment the hit is rolled.
-- Returns net (the % the damage is changed by), atk (the attacker's atk_buff), def (the defender's def_buff; with
-- 118 the terrain part of it does not count). Not enhanced: only the terrain, net = -terrain, atk=nil
local function koAtkMod(pid,eid)
local a,d=War.Person[pid],War.Person[eid]
local t=koPK_TERRT[GetWarMap(d.x,d.y,1)] or 0
if not CC.Enhancement then return -t,nil,t end
local atk,def=a.atk_buff or 0,d.def_buff or 0
local w=JY.Person[a.id][koPK_WEAPON]
if WarCheckSkill(pid,118) or (w and w>0 and JY.Item[w] and JY.Item[w][koPK_SKILL]==118) then def=def-t end
local koFB=rawget(_G,"koFormBuff")-- ko 5.0: the formation parts of atk_buff/def_buff, shown on a row of their own
local fn1,fa,fn2,fd=nil,0,nil,0
if koFB then fn1,fa=koFB(pid,1) fn2,fd=koFB(eid,2) end
return limitX(100+atk-def,10,200)-100,atk,def,fa,fd,fn1,fn2
end

-- ko 3.4: class matchup of pid hitting eid, the same order as WarAtkHurt: 1 advantage (the target's defence
-- x3/4), -1 disadvantage (x5/4), 0 none. 파진(110)/weapon 10 always wins, 견고(111)/weapon 11 always holds, then the class table
local koPL_BZUP="\161\248\130\071\129\117"   -- ▲유리
local koPL_BZDN="\168\139\133\100\129\117"   -- ▼불리
local koPL_BZ="\129\067\131\123"             -- 상성
local function koBZColor(m) if m>0 then return RGB(24,150,48) end return RGB(200,40,40) end-- RGB is defined after the addons load
function koMatchup(pid,eid)
local a,d=War.Person[pid],War.Person[eid]
local p1,p2=JY.Person[a.id],JY.Person[d.id]
if CC.Enhancement and (p1[koPK_WEAPON]==10 or WarCheckSkill(pid,110)) then return 1 end
local w2=p2[koPK_WEAPON]
if CC.Enhancement and (w2==11 or WarCheckSkill(eid,111) or (w2 and JY.Item[w2] and JY.Item[w2][koPK_SKILL]==111)) then return -1 end
if BZSuper(p1[koPK_BZ],p2[koPK_BZ]) then return 1 end
if BZSuper(p2[koPK_BZ],p1[koPK_BZ]) then return -1 end
return 0
end
-- the damage the matchup adds (+) or takes away (-): the same hit rolled again with the matchup switched off
local function koMatchupHurt(pid,eid,flag,hurt)
local m=koMatchup(pid,eid)
if m==0 then return 0,0 end
CC.koBZOff=true
local ok,h0=pcall(WarAtkHurt,pid,eid,flag)
CC.koBZOff=nil
if not ok then return m,0 end
return m,hurt-h0
end

function koPreviewOn()
return (CC.koPreview or 1)==1
end

-- what the game does after "공격" on eid (see the r==1 branch of the action menu), without doing it.
-- Returns a table: hurt,sq,flag2,jy of the player's hit; bl2,sq2 the defender's troops/morale after it;
-- first=true when the defender strikes first (skill 117); ctr={chance,hurt,flag2,bl1} for the counter;
-- ko 3.2: ctr2={hurt,flag2,bl1} for the 결사 second counter, rip={hurt,flag2} and bl3 for the 결전 riposte
function koAtkPreview(scl,eid)
local wa,wd=War.Person[scl],War.Person[eid]
local p1,p2=JY.Person[wa.id],JY.Person[wd.id]
local enh=CC.Enhancement
local function itemskill(p)
local w=p[koPK_WEAPON]
return w and w>0 and JY.Item[w] and JY.Item[w][koPK_SKILL] or 0
end
local function inrange(fromid,toid)
local f=War.Person[fromid]
local arr=WarGetAtkFW(f.x,f.y,f.atkfw)
for n=1,arr.num do
if between(arr[n][1],1,War.Width) and between(arr[n][2],1,War.Depth) and GetWarMap(arr[n][1],arr[n][2],2)==toid then return true end
end
return false
end
-- can the defender hit back at all (same test as the game's fj_flag)
local function canhit()
if JY.Bingzhong[wd.bz][koPK_RANGED]==1 and JY.Bingzhong[wa.bz][koPK_RANGED]==1 then return true end
if enh and WarCheckSkill(eid,102) then return true end
if enh and (WarCheckSkill(eid,42) or itemskill(p2)==42) then return true end
return inrange(eid,scl)
end
local r={}
r.first=enh and WarCheckSkill(eid,117) and not WarCheckSkill(scl,105) and p2[koPK_BL]>0 and (not wd.troubled) and canhit()-- ko 3.2: 파적(105) 은 선공도 막는다
r.mod={koAtkMod(scl,eid)}
r.hurt,r.sq,r.jy,r.flag2=WarAtkHurt(scl,eid,0)
r.bz,r.bzd=koMatchupHurt(scl,eid,0,r.hurt)-- ko 3.4
r.bl2=math.max(p2[koPK_BL]-r.hurt,0)
r.sq2=math.max(p2[koPK_SQ]-r.sq,0)
-- ko 3.2: 결사(106) adds a second counter, and the attacker's 결전(103) hits back once after the counters.
-- Call with the defender already in the state it counters from; the attacker's stats are put back before returning.
-- Each hit is rolled with the attacker refreshed from its lowered troops/morale, as WarResetStatus does between them.
local function chain(h,s)
local abl,asq=p1[koPK_BL],p1[koPK_SQ]
local bl=math.max(abl-h,0)
local sq=math.max(asq-(s or 0),0)
r.ctr.bl1=bl
local moved=false
if enh and bl>0 and WarCheckSkill(eid,106) then
p1[koPK_BL]=bl p1[koPK_SQ]=sq ReSetAttrib(wa.id,false) moved=true
local h2,s2,_,f2=WarAtkHurt(eid,scl,1)
bl=math.max(bl-h2,0)
sq=math.max(sq-(s2 or 0),0)
r.ctr2={hurt=h2,flag2=f2,bl1=bl}
end
if enh and bl>0 and WarCheckSkill(scl,103) and not WarCheckSkill(eid,105) then-- ko 5.2.5: 파적 counters cannot be riposted
p1[koPK_BL]=bl p1[koPK_SQ]=sq ReSetAttrib(wa.id,false) moved=true
local h3,_,_,f3=WarAtkHurt(scl,eid,1)
r.rip={hurt=h3,flag2=f3}
end
if moved then
p1[koPK_BL]=abl p1[koPK_SQ]=asq ReSetAttrib(wa.id,false)
end
end
if r.first then
-- pre-emptive strike: the defender attacks first with its current stats, then the hit above follows
local mod={koAtkMod(eid,scl)}
local h,s,_,f=WarAtkHurt(eid,scl,1)
r.ctr={chance=100,hurt=h,flag2=f,mod=mod}
r.ctr.bz,r.ctr.bzd=koMatchupHurt(eid,scl,1,h)
chain(h,s)
elseif r.bl2>0 and (not wd.troubled) and not (enh and WarCheckSkill(scl,105)) and canhit() then
local chance
if enh and WarCheckSkill(eid,102) then chance=100
elseif enh and (WarCheckSkill(eid,19) or itemskill(p2)==19) then chance=math.min(100,math.floor(p2[koPK_WU2]*koTactics.setting(19,1,100)/100))
else chance=math.min(100,math.floor(p2[koPK_WU2]*100/150)) end
-- the counter is rolled with the defender's stats after the hit (WarResetStatus recomputes them from
-- the lowered morale in enhanced mode), so simulate that and put everything back
local bl0,sq0=p2[koPK_BL],p2[koPK_SQ]
p2[koPK_BL]=r.bl2 p2[koPK_SQ]=r.sq2
if enh then ReSetAttrib(wd.id,false) end
local mod={koAtkMod(eid,scl)}-- the defender's buffs after the hit (배수 and the like follow its troops)
local h,s,_,f=WarAtkHurt(eid,scl,1)
r.ctr={chance=chance,hurt=h,flag2=f,mod=mod}
r.ctr.bz,r.ctr.bzd=koMatchupHurt(eid,scl,1,h)
chain(h,s)-- ko 3.2: 결사/결전 are rolled while the defender is still in its post-hit state
p2[koPK_BL]=bl0 p2[koPK_SQ]=sq0
if enh then ReSetAttrib(wd.id,false) end
end
if r.rip then r.bl3=math.max(r.bl2-r.rip.hurt,0) end
return r
end

-- ko 3.3 hotfix 5: a row "보정 -20%  (공+15% 방+35%)" — the buffs already counted in the damage above it
local function koModRow(L,label,m)
if not m then return end
if m[6] or m[7] then-- ko 5.0: 진형 row (attacker's 공 → defender's 방, the net), then the rest of the buffs (지형·특기) as before
local fa,fd=m[4] or 0,m[5] or 0
local l0=L.row()
L.seg(l0,"\129\103\136\069 "..(m[6] or "-")..string.format("(\130\074%+d%%)",fa).." \161\250 "..(m[7] or "-")..string.format("(\132\078%+d%%)",fd))
local net=fa-fd
L.seg(l0,string.format("\132\065 %+d%%",net),(net>0 and M_Lime) or (net<0 and M_Red) or M_Gray,8)
m={limitX(100+(m[2]-fa)-(m[3]-fd),10,200)-100,m[2]-fa,m[3]-fd}
end
local l=L.row()
L.seg(l,label.." "..string.format("%+d%%",m[1]),(m[1]>0 and M_Lime) or (m[1]<0 and M_Red) or M_Gray)
if m[2] then
L.seg(l,string.format("(%s%+d%% %s%+d%%)",koPL_ATKB,m[2],koPL_DEFB,m[3]),M_Gray,8)
else
L.seg(l,string.format("(%s %+d%%)",koPL_TERR,m[3]),M_Gray,8)
end
end

-- ko 3.4: "(상성 +16)" after a damage figure, coloured for the player: green when the matchup is on the
-- player's side (the player's hit gains, or the counter loses), red otherwise. ctr = the enemy's counter
local function koBZSeg(L,l,m,d,ctr)
if (m or 0)==0 or (d or 0)==0 then return end
local good=(m>0)~=(ctr==true)
L.seg(l,string.format("(%s %+d)",koPL_BZ,d),good and M_Lime or M_Red,8)
end

-- the popup, placed next to the target cell like DrawStatusMini
function koDrawAtkPreview(scl,eid)
-- WarAtkHurt can pop a message box (skill 115 vs 23/43/47); silence it while only predicting
local D=WarDrawStrBoxDelay
WarDrawStrBoxDelay=function() end
local ok,r=pcall(koAtkPreview,scl,eid)
WarDrawStrBoxDelay=D
CC.koBZOff=nil-- ko 3.4: never left on by an error
if not ok then lib.Debug("koAtkPreview: "..tostring(r)) return end
local wa,wd=War.Person[scl],War.Person[eid]
local p1,p2=JY.Person[wa.id],JY.Person[wd.id]
local function tag(f,dead)
if dead then return koPL_KILL,M_Yellow end
if f==2 then return koPL_CRIT,M_Yellow elseif f==1 then return koPL_GUARD,M_Gray end
return nil
end
local L=koPreviewLines()
-- 예상  attacker → defender
local l=L.row()
L.seg(l,koPL_TITLE) L.seg(l,p1[koPK_NAME],koTeamColor(wa),8) L.seg(l,koPL_ARROW,nil,8) L.seg(l,p2[koPK_NAME],koTeamColor(wd),8)
if (r.bz or 0)~=0 then L.seg(l,r.bz>0 and koPL_BZUP or koPL_BZDN,M_White,12) l[#l].bg=koBZColor(r.bz) end-- ko 3.4: ▲유리 / ▼불리 badge
-- 피해 N  회심/방어/격파  (선제)
l=L.row()
L.seg(l,koPL_HURT.." "..r.hurt)
koBZSeg(L,l,r.bz,r.bzd)
local t,tc=tag(r.flag2,r.bl2<=0)
if t then L.seg(l,t,tc,8) end
if r.first then L.seg(l,koPL_FIRST,M_Red) end
koModRow(L,koPL_MOD,r.mod)
-- 병력 a→b  사기 c→d  (defender)
l=L.row()
if r.bl3 then-- ko 3.2: the 결전 riposte takes another bite out of the target
L.seg(l,string.format("%s %d%s%d%s%d",koPL_BL,p2[koPK_BL],koPL_ARROW,r.bl2,koPL_ARROW,r.bl3))
else
L.seg(l,string.format("%s %d%s%d",koPL_BL,p2[koPK_BL],koPL_ARROW,r.bl2))
end
L.seg(l,string.format("%s %d%s%d",koPL_SQ,p2[koPK_SQ],koPL_ARROW,r.sq2))
-- 반격 P%  피해 M  회심/방어/격파  + my 병력      or   반격 없음
l=L.row()
if r.ctr then
L.seg(l,string.format("%s %d%%",r.first and koPL_FIRST or koPL_CTR,r.ctr.chance),r.first and M_Red or M_White)
L.seg(l,koPL_HURT.." "..r.ctr.hurt)
koBZSeg(L,l,r.ctr.bz,r.ctr.bzd,true)
local t2,tc2=tag(r.ctr.flag2,r.ctr.bl1<=0)
if t2 then L.seg(l,t2,tc2,8) end
if r.ctr2 then-- ko 3.2: 결사 하나 더
L.seg(l,koPL_KS.." "..r.ctr2.hurt)
local t3,tc3=tag(r.ctr2.flag2,r.ctr2.bl1<=0)
if t3 then L.seg(l,t3,tc3,8) end
end
koModRow(L,koPL_CTR.." "..koPL_MOD,r.ctr.mod)
L.seg(L.row(),string.format("%s %d%s%d",koPL_BL,p1[koPK_BL],koPL_ARROW,(r.ctr2 or r.ctr).bl1))
if r.rip then-- ko 3.2: 결전 되받아치기
local l2=L.row()
L.seg(l2,koPL_KJ.." "..koPL_HURT.." "..r.rip.hurt)
local t4,tc4=tag(r.rip.flag2,(r.bl3 or 1)<=0)
if t4 then L.seg(l2,t4,tc4,8) end
end
else
L.seg(l,koPL_CTR.." "..koPL_NONE,M_Gray)
end
-- 경험 +N (only the player's own units gain any)
if (r.jy or 0)>0 then L.seg(L.row(),string.format("%s +%d",koPL_EXP,r.jy)) end
-- keep the panel clear of the attacker too: hang it off the attacker's column when it stands on the panel's side
local bx,left=wd.x,wd.x-War.CX>math.modf(War.MW/2)
if math.abs(wa.y-wd.y)<=#L.rows then if left then bx=math.min(bx,wa.x) else bx=math.max(bx,wa.x) end end
koPreviewDraw({x=bx,y=wd.y,side=left and "L" or "R"},L)
end

function koTeamColor(w)
if w.enemy then return M_Red elseif w.friend then return M_DarkOrange end
return M_Cyan
end

-- text rows for a preview panel, laid out before anything is drawn so the panel can be as wide as its longest row.
-- L.row() adds a row; L.seg(row,text[,color][,gap|x]) appends a segment: gap = pixels after the previous segment
-- (default 16), or an absolute x when given as {x=..} (column layouts)
function koPreviewLines()
local L={rows={}}
function L.row() local l={w=0} L.rows[#L.rows+1]=l return l end
function L.seg(l,s,c,g)
s=tostring(s)
local x
if type(g)=="table" then x=g.x else x=(#l>0) and l.w+(g or 16) or 0 end
l[#l+1]={x=x,s=s,c=c or M_White}
l.w=math.max(l.w,x+#s*8)
return l
end
return L
end
function koPreviewDraw(w,L)
local W=0
for _,l in ipairs(L.rows) do W=math.max(W,l.w) end
local mx,my=koPreviewBox(w,W+16,#L.rows)
for _,l in ipairs(L.rows) do
for _,s in ipairs(l) do
if s.bg then lib.FillColor(mx+s.x-3,my-1,mx+s.x+#s.s*8+3,my+18,s.bg) end-- ko 3.4: a badge (matchup)
DrawString(mx+s.x,my,s.s,s.c,16)
end
my=my+20
end
end

-- the popup panel beside unit w (W wide, rows text rows of 20 px), kept on screen: dark backing plus a thin frame so the
-- text stays readable over any terrain. Returns the text origin and the width
function koPreviewBox(w,W,rows)
local H=8+20*rows
local x,y=w.x,w.y
local menux,menuy
local left=(w.side=="L") or (w.side==nil and x-War.CX>math.modf(War.MW/2))-- w.side forces the side
if left then
menux=War.OX+War.BoxWidth*(x-War.CX)-W-2
else
menux=War.OX+War.BoxWidth*(x-War.CX+1)+2
end
if y-War.CY>math.modf(War.MD/2) then
menuy=War.OY+War.BoxDepth*(y-War.CY)-H+War.BoxDepth
else
menuy=War.OY+War.BoxDepth*(y-War.CY)
end
menux=limitX(menux,0,math.max(0,CC.ScreenW-W))
menuy=limitX(menuy,0,math.max(0,CC.ScreenH-H))
lib.Background(menux,menuy,menux+W,menuy+H,96,M_Black)
lib.DrawRect(menux,menuy,menux+W,menuy,M_Gray)
lib.DrawRect(menux,menuy+H,menux+W,menuy+H,M_Gray)
lib.DrawRect(menux,menuy,menux,menuy+H,M_Gray)
lib.DrawRect(menux+W,menuy,menux+W,menuy+H,M_Gray)
return menux+8,menuy+4,W
end


-- ---- ko 3.1: 책략 미리보기. While WarMagicMenu_sub is picking the target of a 책략 (War.koMagicSel={mid,item}, set by
-- the base), the popup over a valid target shows what WarMagic would do to every unit in the effect area: success chance
-- (WarMagicHitRatio), damage (WarMagicHurt, which rolls a 0~2% bonus, so a range), morale, recovery, 혼란, terrain refusals,
-- the 책략 cost and the experience. Nothing here changes game state: the random roll is stubbed while predicting.
local koPK_MTYPE="\192\224\208\205"      -- 类型
local koPK_MCOST="\207\251\186\196"      -- 消耗
local koPK_MEFW="\208\167\185\251\183\182\206\167"  -- 效果范围
local koPK_MEFF="\208\167\185\251"       -- 效果
local koPK_MNAME="\195\251\179\198"      -- 名称 (of a 책략)
local koPK_INT2="\214\199\193\166\050"   -- 智力2
local koPK_TS="\205\179\194\202"         -- 统率 (base; WarTroubleShooting reads this, not 统率2)
local koPL_CURE="\130\099\130\100 \129\066\129\100"  -- 혼란 해제
local koPL_POI="\132\096"                -- ko 3.5: 독
local koPL_TURN="\129\112"               -- 턴
local koPL_DETOX="\129\066\132\096"      -- 해독
local koPL_TWICE="2\130\125 \130\086\130\066"        -- 2회 시전
local function itemskill20(p)-- WarTroubleShooting also accepts 침착 on the weapon
local w=p[koPK_WEAPON]
return w and w>0 and JY.Item[w] and JY.Item[w][koPK_SKILL]==20 or false
end
local koPK_MP="\178\223\194\212"         -- 策略 (the caster's remaining points)
local koPK_ARG1="\178\206\202\253\049"   -- 参数1 (of a skill)
local koPL_OK="\131\123\130\074"         -- 성공
local koPL_HEAL="\130\125\130\068"       -- 회복
local koPL_CONF="\130\099\130\100"       -- 혼란
local koPL_NO="\133\100\129\094"         -- 불가
local koPL_COST="\129\109\130\090"       -- 소모
local koPL_UNIT="\130\094\130\095"       -- 부대
local koPL_ETC="\131\107"                -- 외
local koPL_ING="\130\101"                -- 중
local koPL_ITEM="\129\068\130\119"       -- 도구
local koPL_TWIN="\129\071\132\087 \133\066\132\084" -- 이교 연계 (ko 3.6)

-- run fn with math.random pinned to its lowest (lo=true) or highest possible roll
local function koWithRand(lo,fn)
local R=math.random
math.random=function(n,m)
if n==nil then return lo and 0 or 0.99999 end
if m==nil then return lo and 1 or n end
return lo and n or m
end
local ok,a,b,c,d=pcall(fn)
math.random=R
if not ok then error(a,0) end
return a,b,c,d
end

-- one target of the 책략: what WarMagic would do to War.Person[id] (eid = the picked centre, mid = the 책략)
local function koMagicTarget(scl,id,eid,mid,item,kind)
local M=JY.Magic[mid]
local p1,p2=JY.Person[War.Person[scl].id],JY.Person[War.Person[id].id]
local w2=War.Person[id]
local t={id=id,name=p2[koPK_NAME],w=w2}
t.hit=item and 1 or WarMagicHitRatio(scl,id,mid)
if between(kind,6,8) then
local lv1=p1[koPK_LV]
local hp,sp=-1,-1
if kind==6 then
sp=item and M[koPK_MEFF] or M[koPK_MEFF]+lv1/10
elseif kind==7 then
hp=item and M[koPK_MEFF] or M[koPK_MEFF]+p1[koPK_INT2]*lv1/20
if (not item) and CC.Enhancement and WarCheckSkill(id,41) then hp=math.modf(hp*(100+JY.Skill[41][koPK_ARG1])/100) end-- ko 3.2: 보급 counts for each target
else
local HP,SP={600,1200,1800},{30,40,50}
hp,sp=HP[M[koPK_MEFF]] or 0,SP[M[koPK_MEFF]] or 0
if not item then
hp=hp+p1[koPK_INT2]*lv1/20
sp=sp+lv1/10
if CC.Enhancement and WarCheckSkill(id,41) then hp=math.modf(hp*(100+JY.Skill[41][koPK_ARG1])/100) end-- ko 3.2: 보급 counts for each target
end
end
-- ko 3.6: 천부 마왕(123) heals x1.5 (not from a tool), as WarMagic does
if (not item) and rawget(_G,"koDemon") and koDemon(scl) then
local power=koTactics.setting(123,1,150)/100
if hp>=0 then hp=hp*power end
if sp>=0 then sp=sp*power end
end
-- ko 3.6: 이교 연계 (대교·소교 side by side) heals x1.3 (not from a tool), as WarMagic does
if (not item) and rawget(_G,"koTwinOn") and koTwinOn(scl) then
if hp>=0 then hp=hp*1.3 end
if sp>=0 then sp=sp*1.3 end
end
if hp>=0 then
local room=p2[koPK_BLMAX]-p2[koPK_BL]
t.hp1,t.hp2=limitX(math.modf(hp),0,room),limitX(math.modf(hp*1.09999),0,room)
end
if sp>=0 then
local room=(w2.sq_limited or 100)-p2[koPK_SQ]
t.sq1,t.sq2=limitX(math.modf(sp),0,room),limitX(math.modf(sp*1.09999),0,room)
end
-- ko 3.2: 격려·간호 (kinds 6 and 8) end with WarTroubleShooting on each target: a 혼란 unit wakes when a 0~99 roll is
-- below (统率+士气 after the recovery)/3, always with 침착(20). 원조 (kind 7) does not try.
if (kind==6 or kind==8) and w2.troubled then
local function cure(sq)
if CC.Enhancement and (WarCheckSkill(id,20) or itemskill20(p2)) then return 100 end
return limitX(math.ceil((p2[koPK_TS]+p2[koPK_SQ]+(sq or 0))/3),0,100)
end
t.cure1,t.cure2=cure(t.sq1),cure(t.sq2)
end
if kind==8 and CC.Enhancement and (w2.poison or 0)>0 then t.detox=true end-- ko 3.5: 간호 계열은 독을 반드시 푼다
t.jy=CC.Enhancement and M[koPK_MCOST] or 8
elseif kind==4 then
t.troubled=w2.troubled
t.jy=CC.Enhancement and M[koPK_MCOST] or 8
elseif kind==5 then
local sq
if item then sq=math.modf(M[koPK_MEFF]-p2[koPK_LV]/10) else sq=math.modf(M[koPK_MEFF]+p1[koPK_LV]/10-p2[koPK_LV]/10) end
t.sq1=limitX(sq,0,p2[koPK_SQ]) t.sq2=t.sq1
t.jy=CC.Enhancement and M[koPK_MCOST] or 8
else
t.ok=WarMagicCheck(scl,id,mid)
if t.ok then
local h1,s1,jy,jy2=koWithRand(true,function() return WarMagicHurt(scl,id,mid,item) end)
local h2,s2=koWithRand(false,function() return WarMagicHurt(scl,id,mid,item) end)
t.hurt1,t.hurt2,t.sq1,t.sq2,t.jy,t.jy2=h1,h2,s1,s2,jy,jy2
t.kill=h1>=p2[koPK_BL]
if kind==3 and CC.Enhancement and WarCheckSkill(scl,15) and (not t.kill) and (not w2.troubled) then t.conf=JY.Skill[15][koPK_ARG1] end
local pm=rawget(_G,"koPoisonMag")-- ko 3.5: 독연·독무 poison chance (jymain koPoisonMag)
if kind==9 and CC.Enhancement and pm and pm[mid] and (not t.kill) then t.poi=pm[mid] end
end
end
return t
end

-- everything the popup needs: the targets in the effect area (the picked one first), cost and experience
function koMagicPreview(scl,eid,mid,item)
local M=JY.Magic[mid]
local kind=M[koPK_MTYPE]
local p1=JY.Person[War.Person[scl].id]
local r={kind=kind,name=M[koPK_MNAME],item=item,targets={},aid=between(kind,6,8)}
r.cost=item and 0 or koStrategyMPCost(scl,M[koPK_MCOST])
r.mp=p1[koPK_MP]
local arr=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,M[koPK_MEFW])
local ids={}
for i=1,arr.num do
local x,y=arr[i][1],arr[i][2]
if between(x,1,War.Width) and between(y,1,War.Depth) then
local id=GetWarMap(x,y,2)
if id>0 and id~=eid and War.Person[id].live and (not War.Person[id].hide) and War.Person[id].enemy==War.Person[eid].enemy then ids[#ids+1]=id end
end
end
table.insert(ids,1,eid)
r.jy=0
for _,id in ipairs(ids) do
local t=koMagicTarget(scl,id,eid,mid,item,kind)
r.targets[#r.targets+1]=t
-- WarMagic adds the experience per target for damage 책략 (when the terrain allows it), once for the other kinds
if between(kind,1,3) or kind>=9 then if t.ok then r.jy=r.jy+(t.jy or 0) end else r.jy=t.jy or 0 end
end
if p1[koPK_LV]>=99 then r.jy=0 end
-- ko 3.2: 지낭(119) casts a single-target 화계·수계·낙석·독·낙뢰 twice (koWarMagicMenu_sub), the second time only if the target stands
local t=r.targets[1]
if t and t.ok~=false and not t.kill then
local scholar=t.ok and koTacticScholarCasts(scl,mid) or 0
local demon=(not item) and mid~=45 and koDemon(scl) and koTactics.setting(123,2,1) or 0
r.casts=1+scholar+demon
end
return r
end

function koDrawMagicPreview(scl,eid,mid,item)
local D=WarDrawStrBoxDelay
WarDrawStrBoxDelay=function() end
local ok,r=pcall(koMagicPreview,scl,eid,mid,item)
WarDrawStrBoxDelay=D
if not ok then lib.Debug("koMagicPreview: "..tostring(r)) return end
local wa,wd=War.Person[scl],War.Person[eid]
local p1=JY.Person[wa.id]
local multi=#r.targets>1
local maxrows=6
local shown=multi and math.min(#r.targets,maxrows) or 1
local team=koTeamColor
local function pct(v) return string.format("%d%%",math.floor(v*100+0.5)) end
local function range(a,b) if a==b then return tostring(a) end return a.."~"..b end
local L=koPreviewLines()
-- 예상 책략명 → 대상   /   예상 책략명 (N부대)
local l=L.row()
L.seg(l,koPL_TITLE) L.seg(l,r.name,M_Yellow,8)
if multi then
L.seg(l,string.format("(%d%s)",#r.targets,koPL_UNIT),nil,8)
else
L.seg(l,koPL_ARROW,nil,8) L.seg(l,r.targets[1].name,team(wd),8)
end
if r.casts and r.casts>1 then
L.seg(l,r.casts==2 and "("..koPL_TWICE..")" or "(x"..r.casts..")",M_Yellow,8)
end
if (not r.item) and rawget(_G,"koTwinOn") and koTwinOn(scl) then L.seg(l,"("..koPL_TWIN..")",M_Magenta,8) end-- ko 3.6: 이교 연계
if multi then
-- one row per unit: name column, then chance / damage (or recovery) columns
local namew=0
for i=1,shown do namew=math.max(namew,#r.targets[i].name*8) end
local c1={x=namew+16}
for i=1,shown do
local t=r.targets[i]
l=L.row()
L.seg(l,t.name,team(t.w))
if r.aid then
if t.hp1 then L.seg(l,koPL_BL.." +"..range(t.hp1,t.hp2),t.hp2>0 and M_White or M_Gray,c1) end
if t.sq1 then L.seg(l,koPL_SQ.." +"..range(t.sq1,t.sq2),t.sq2>0 and M_White or M_Gray,t.hp1 and 16 or c1) end
if t.cure1 then L.seg(l,koPL_CURE.." "..range(t.cure1,t.cure2).."%",nil,16) end-- ko 3.2
if t.detox then L.seg(l,koPL_DETOX,M_Lime,16) end-- ko 3.5
elseif r.kind==4 then
if t.troubled then L.seg(l,koPL_CONF.." "..koPL_ING,M_Gray,c1) else L.seg(l,koPL_CONF.." "..pct(t.hit),nil,c1) end
elseif r.kind==5 then
L.seg(l,pct(t.hit),nil,c1) L.seg(l,koPL_SQ.." -"..t.sq1,nil,{x=c1.x+40})
elseif not t.ok then
L.seg(l,koPL_NO,M_Gray,c1)
else
L.seg(l,pct(t.hit),nil,c1) L.seg(l,koPL_HURT.." "..range(t.hurt1,t.hurt2),nil,{x=c1.x+40})
if t.kill then L.seg(l,koPL_KILL,M_Yellow,8) elseif t.conf then L.seg(l,koPL_CONF..t.conf.."%",nil,8) elseif t.poi then L.seg(l,koPL_POI..t.poi.rate.."%",M_Lime,8) end
end
end
if #r.targets>maxrows then L.seg(L.row(),string.format("%s %d%s",koPL_ETC,#r.targets-maxrows,koPL_UNIT),M_Gray) end
else
local t=r.targets[1]
local p2=JY.Person[wd.id]
if r.aid then
if t.hp1 then
l=L.row()
L.seg(l,string.format("%s %d%s%s",koPL_BL,p2[koPK_BL],koPL_ARROW,range(p2[koPK_BL]+t.hp1,p2[koPK_BL]+t.hp2)))
if t.hp2==0 then L.seg(l,koPL_HEAL.." "..koPL_NONE,M_Gray) end
end
if t.sq1 then
l=L.row()
L.seg(l,string.format("%s %d%s%s",koPL_SQ,p2[koPK_SQ],koPL_ARROW,range(p2[koPK_SQ]+t.sq1,p2[koPK_SQ]+t.sq2)))
if t.sq2==0 then L.seg(l,koPL_HEAL.." "..koPL_NONE,M_Gray) end
end
if t.cure1 then L.seg(L.row(),koPL_CURE.." "..range(t.cure1,t.cure2).."%") end-- ko 3.2
if t.detox then L.seg(L.row(),koPL_DETOX,M_Lime) end-- ko 3.5
elseif r.kind==4 then
if t.troubled then L.seg(L.row(),koPL_CONF.." "..koPL_ING,M_Gray) else L.seg(L.row(),koPL_CONF.." "..pct(t.hit)) end
elseif r.kind==5 then
l=L.row()
L.seg(l,koPL_OK.." "..pct(t.hit)) L.seg(l,string.format("%s %d%s%d",koPL_SQ,p2[koPK_SQ],koPL_ARROW,p2[koPK_SQ]-t.sq1))
elseif not t.ok then
L.seg(L.row(),koPL_NO,M_Gray)
else
l=L.row()
L.seg(l,koPL_OK.." "..pct(t.hit)) L.seg(l,koPL_HURT.." "..range(t.hurt1,t.hurt2))
if t.kill then L.seg(l,koPL_KILL,M_Yellow,8) end
l=L.row()
-- the damage is a range, so the troops/morale left are too (lowest first: the biggest hit leaves the least)
L.seg(l,string.format("%s %d%s%s",koPL_BL,p2[koPK_BL],koPL_ARROW,range(math.max(p2[koPK_BL]-t.hurt2,0),math.max(p2[koPK_BL]-t.hurt1,0))))
L.seg(l,string.format("%s %d%s%s",koPL_SQ,p2[koPK_SQ],koPL_ARROW,range(math.max(p2[koPK_SQ]-t.sq2,0),math.max(p2[koPK_SQ]-t.sq1,0))))
if t.conf then L.seg(L.row(),koPL_CONF.." "..t.conf.."%") end
if t.poi then L.seg(L.row(),string.format("%s %d%% (%d%s)",koPL_POI,t.poi.rate,t.poi.turns,koPL_TURN),M_Lime) end-- ko 3.5
end
end
-- 소모 N (책략 a→b)  경험 +N      /  도구 (no cost)
l=L.row()
if r.item then
L.seg(l,koPL_ITEM,M_Gray)
else
L.seg(l,string.format("%s %d (%d%s%d)",koPL_COST,r.cost,r.mp,koPL_ARROW,math.max(r.mp-r.cost,0)),r.mp<r.cost and M_Red or M_White)
end
if (r.jy or 0)>0 then L.seg(l,string.format("%s +%d",koPL_EXP,r.jy)) end
-- keep the panel clear of every unit in the effect area: hang it off the outermost affected column on its side
local bx,left=wd.x,wd.x-War.CX>math.modf(War.MW/2)
for _,t in ipairs(r.targets) do if left then bx=math.min(bx,t.w.x) else bx=math.max(bx,t.w.x) end end
local wc=War.Person[scl]-- and of the caster, when it stands on that side within the panel's rows
if wc and math.abs(wc.y-wd.y)<=#L.rows then if left then bx=math.min(bx,wc.x) else bx=math.max(bx,wc.x) end end
koPreviewDraw({x=bx,y=wd.y,side=left and "L" or "R"},L)
end

-- ---- registration (ko 3.1 addon "preview": 전투 미리보기)
koAddon.settings[#koAddon.settings+1]={key="koPreview",label="\130\066\132\101 \134\119\129\117\131\115\131\071",opts={{"\133\122",1},{"\133\117",0}},default=1}
koOn("hover_atk",function(scl,eid)
if not koPreviewOn() or GetWarMap(War.MX,War.MY,4)<=0 then return false end
local ms=War.koMagicSel
if ms and (not War.koAtkSel) then scl=ms.wid or scl end-- the caster (WarMagicMenu_sub's id; War.SelID may differ for item use)
if not (War.Person[eid] and War.Person[scl]) then return false end
local same=War.Person[eid].enemy==War.Person[scl].enemy
if War.koAtkSel and not same then
koDrawAtkPreview(scl,eid)
return true
end
if ms and (not War.koAtkSel) then
-- the target rule of WarSelectAtk: 6~8 (격려/원조/간호) pick one's own side, the rest an enemy
if between(JY.Magic[ms.mid][koPK_MTYPE],6,8)==same then
koDrawMagicPreview(scl,eid,ms.mid,ms.item)
return true
end
end
return false
end)
-- ko 3.4: class matchup marks on the map, a small ▲ (green, advantage) / ▼ (red, disadvantage) at the top right of
-- an enemy whose matchup is not even: every enemy on screen while an own unit picks where to move, the targets in range
-- while it picks what to attack. Drawn as a filled triangle with a dark rim (the font's arrows were too big on a 48 px cell)
-- an equilateral triangle h rows tall, apex at the top (up) or bottom: the half width grows by tan 30 deg a row (user: "not a right triangle")
local function koTri(cx,y,up,h,c)
for r=0,h-1 do
local d=up and r or (h-1-r)
local hw=math.floor(d*0.5774+0.5)
lib.FillColor(cx-hw,y+r,cx+hw+1,y+r+1,c)
end
end
local function koBZMark(v,m)
local cx=War.OX+War.BoxWidth*(v.x-War.CX+1)-9
local y=War.OY+War.BoxDepth*(v.y-War.CY)+2
koTri(cx,y,m>0,11,M_Black)--ko 5.0: same weight as the formation square (13 wide, 11 tall, a 1 px rim)
-- the coloured inner one, inset about 2 px on every side (an equilateral inset moves the apex twice as far as the base)
koTri(cx,m>0 and y+2 or y+1,m>0,8,(m>0) and RGB(90,240,70) or RGB(250,60,60))-- brighter than the popup badge: it sits on grass
end
koOn("draw_units_over",function()
if not koPreviewOn() or not War.ControlEnable then return nil end
local atk=(War.ControlStatus=="selectAtk" and War.koAtkSel)
if not (atk or War.ControlStatus=="move") then return nil end
local scl=War.SelID
local a=War.Person[scl]
if not a or a.enemy or a.friend then return nil end-- own units only (the move state is also used to show an enemy's reach)
for i,v in pairs(War.Person) do
if v.live and (not v.hide) and v.enemy and between(v.x,War.CX,War.CX+War.MW-1) and between(v.y,War.CY,War.CY+War.MD-1)
and ((not atk) or GetWarMap(v.x,v.y,4)>0) then
local ok,m=pcall(koMatchup,scl,i)
if ok and m~=0 then koBZMark(v,m) end
end
end
return nil
end)
