-- ko 3.0: battle scene ("전투 장면"), an optional replacement for the on-map attack animation, drawn the way
-- the duel (일기토, fight_sub) is: terrain backdrop by the defender's tile, the duel's large figures of both
-- generals (grp 11, JY.Person "战斗形象"), portraits, troop bars and the duel frame (ui 412).
-- Called from WarAtk after the hit is already decided; it only shows the result and applies the
-- troop/morale change the way the on-map path does (the same interpolation loop).
--   pid,eid : War.Person indices (attacker, defender)   hurt,sq_hurt : troops / morale lost
--   flag2   : 0 normal, 1 guarded, 2 critical            str : "X의 공격" title from WarAtk
local koFK_BL="\177\248\193\166"          -- 병력
local koFK_BLMAX="\215\238\180\243\177\248\193\166"
local koFK_SQ="\202\191\198\248"          -- 사기
local koFK_NAME="\208\213\195\251"
local koFK_BZ="\177\248\214\214"
local koFK_FIG="\213\189\182\183\182\175\215\247"     -- 战斗形象 (duel figure)
local koFK_FACE="\205\183\207\241\180\250\186\197"    -- portrait
local koFK_WAV="\210\244\208\167"                     -- move sound (per class)
local koL_BL="\130\126\131\125"           -- 병력
local koL_SQ="\130\114\131\071"           -- 사기
local koL_CRIT="\130\125\134\100\131\080 \133\073\130\112" -- 회심의 일격
local koL_GUARD="\132\078\130\083"        -- 방어
local koL_KILL="\130\112\134\086"         -- 격파
local koL_MISS="\137\088\129\066 \130\097\130\077"     -- 피해 없음
local koL_CL="\130\117\130\118"           -- 책략
local koFK_BZNAME="\195\251\179\198"
local koFK_LV="\181\200\188\182"
local koFK_CL="\178\223\194\212"
local koFK_CLMAX="\215\238\180\243\178\223\194\212"
local koFK_ATK="\185\165\187\247"       -- 공격력
local koFK_DEF="\183\192\211\249"       -- 방어력
local koL_ATK="\130\074\130\112"        -- 공격
local koL_DEF="\132\078\130\083"        -- 방어
local koL_TERR="\130\067\136\069"       -- 지형
local koL_STAT="\129\067\130\124"       -- 상태
local koL_TROUBLE="\130\099\130\100"    -- 혼란
local koL_POISON="\130\101\132\096"     -- 중독
local koL_NORMAL="\129\070\129\067"     -- 정상
-- defence bonus (%) of each terrain type, the table WarAtkHurt / ReSetBuff use
koFightTerrain={[0]=0,20,30,0,0,0,0,5,5,0,0,0,0,30,10}

-- sky tone (r,g,b) at the top edge of each far-layer picture (grp 1 ids 0..4), measured from the pictures:
-- 0,2,3,4 share one sky, 1 (forest) is a little lighter
koFightSky={[0]={62,146,252},[1]={92,168,252},[2]={62,146,252},[3]={62,146,252},[4]={62,146,252}}
function koFightOn()
local m=CC.koFight or 0
if War.koSkip then return false end   -- ko 3.1: the enemy phase is being skipped (Space)
if m==2 then return War.ControlStatus~='AI' end   -- 아군: skip the scene during the enemy phase
return m==1
end

-- Pixel-native effects matched to the actual 5.0 class IDs.
local function koFightShotKind(bz)
if bz==4 or bz==22 or bz==33 then return "arrow" end
if bz==5 or bz==37 or bz==38 then return "bolt" end
if bz==6 then return "volley" end
if bz==21 or bz==29 or bz==36 then return "stone" end
if bz==16 or bz==27 or bz==35 then return "talisman" end
if bz==26 or bz==32 then return "flame" end
if bz==13 or bz==34 then return "sound" end
if bz==10 or bz==11 or bz==12 or bz==15 or bz==17 or bz==28 then return "blade" end
return "spear"
end
local function koFightDrawShot(kind,s)
local x,y=math.floor(s.x),math.floor(s.y)
local length=math.max(1,math.sqrt(s.dx*s.dx+s.dy*s.dy))
local co,si=s.dx/length,s.dy/length
local dark=RGB(44,33,23)
local wood=RGB(161,111,56)
local steel=RGB(193,203,203)
local pale=RGB(228,216,178)
local function pt(u,v)
return math.floor(x+u*co-v*si+0.5),math.floor(y+u*si+v*co+0.5)
end
local function line(u,v,a,b,color,width)
local x1,y1=pt(u,v) local x2,y2=pt(a,b)
local dx,dy=math.abs(x2-x1),math.abs(y2-y1)
local sx,sy=(x1<x2) and 1 or -1,(y1<y2) and 1 or -1
local err=dx-dy
while true do
lib.FillColor(x1,y1,x1+(width or 1),y1+(width or 1),color)
if x1==x2 and y1==y2 then break end
local e=2*err
if e>-dy then err=err-dy x1=x1+sx end
if e<dx then err=err+dx y1=y1+sy end
end
end
local function poly(points,color)
local p={} local lo,hi=9999,-9999
for _,v in ipairs(points) do local a,b=pt(v[1],v[2]) p[#p+1]={a,b} lo=math.min(lo,b) hi=math.max(hi,b) end
for yy=lo,hi do
local cross={}
for i=1,#p do
local a,b=p[i],p[i%#p+1]
if (a[2]<=yy and b[2]>yy) or (b[2]<=yy and a[2]>yy) then
cross[#cross+1]=a[1]+(yy-a[2])*(b[1]-a[1])/(b[2]-a[2])
end
end
table.sort(cross)
for i=1,#cross-1,2 do lib.FillColor(math.floor(cross[i]),yy,math.ceil(cross[i+1])+1,yy+1,color) end
end
end
local function arrow(offset,bolt)
local len=bolt and 24 or 36
line(-len,offset,-7,offset,dark,3)
line(-len,offset,-7,offset,wood,1)
poly({{-10,offset-4},{1,offset},{-10,offset+4},{-7,offset}},dark)
poly({{-8,offset-2},{0,offset},{-8,offset+2},{-6,offset}},steel)
line(-8,offset,-1,offset,pale,1)
poly({{-len+1,offset},{-len-4,offset-5},{-len+5,offset-3},{-len+9,offset}},dark)
poly({{-len+1,offset},{-len-4,offset+5},{-len+5,offset+3},{-len+9,offset}},dark)
line(-len-2,offset-4,-len+7,offset-1,pale,1)
line(-len-2,offset+4,-len+7,offset+1,pale,1)
end
if kind=="arrow" or kind=="bolt" then arrow(0,kind=="bolt")
elseif kind=="volley" then arrow(-7,true) arrow(0,true) arrow(7,true)
elseif kind=="stone" then
poly({{-9,-5},{-3,-10},{5,-8},{10,-2},{8,7},{0,10},{-8,6}},dark)
poly({{-7,-4},{-2,-8},{5,-6},{8,-1},{6,6},{0,8},{-6,4}},RGB(113,107,91))
poly({{-5,-4},{-1,-7},{4,-5},{1,-1},{-4,0}},RGB(171,163,137))
line(2,2,5,5,RGB(74,71,63),2)
elseif kind=="talisman" then
-- Cream ritual paper and vermilion strokes, rather than a physical arrow.
local tilt=math.sin(s.t*math.pi*6)*3
poly({{-11,-10+tilt},{1,-8+tilt},{-1,11+tilt},{-13,9+tilt}},dark)
poly({{-10,-8+tilt},{0,-7+tilt},{-2,9+tilt},{-12,8+tilt}},RGB(237,212,154))
line(-8,-5+tilt,-4,-4+tilt,RGB(160,48,29),1)
line(-6,-5+tilt,-7,5+tilt,RGB(160,48,29),1)
line(-10,0+tilt,-3,1+tilt,RGB(160,48,29),1)
line(-9,5+tilt,-4,6+tilt,RGB(160,48,29),1)
line(-22,-2,-19,-2,RGB(191,128,53),1)
line(-28,5,-26,5,pale,1)
elseif kind=="flame" then
poly({{1,0},{-4,-7},{-12,-4},{-25,-8},{-20,-1},{-30,2},{-14,4},{-6,7}},RGB(136,48,24))
poly({{0,0},{-5,-4},{-12,-2},{-22,-4},{-16,1},{-22,3},{-9,4}},RGB(230,129,43))
poly({{0,0},{-6,-2},{-14,0},{-6,2}},RGB(249,213,109))
elseif kind=="sound" then
for k=0,2 do
local u=-k*9
line(u-5,-9,u,-4,pale,1) line(u,-4,u+2,0,pale,1)
line(u+2,0,u,4,pale,1) line(u,4,u-5,9,pale,1)
end
elseif kind=="blade" then
poly({{0,0},{-10,-5},{-23,-3},{-12,2}},dark)
poly({{0,0},{-10,-3},{-20,-2},{-11,1}},steel)
line(-22,-2,-29,-2,wood,3)
else
line(-44,0,-10,0,dark,3) line(-44,0,-10,0,wood,1)
poly({{0,0},{-15,-5},{-10,0},{-15,5}},dark)
poly({{0,0},{-13,-3},{-9,0},{-13,3}},steel)
end
end

function koFightScene(pid,eid,hurt,sq_hurt,flag2,str)
local a,dfn=War.Person[pid],War.Person[eid]
local pa,pd=JY.Person[a.id],JY.Person[dfn.id]
local step=CC.koAnim or 1
-- the duel screen is laid out for 768x480; centre it on bigger battle screens
local SW,SH=768,480
local ox,oy=math.floor((CC.ScreenW-SW)/2),math.floor((CC.ScreenH-SH)/2)
-- the duel frame (ui 412) has a "기능" button drawn in at its top left that does nothing here: keep a
-- copy of the ornament next to it (its pattern repeats every 24 px) and paste it over the button each frame
lib.PicLoadCache(4,412,ox,oy,1)
local patch=lib.SaveSur(ox+84,oy+2,ox+156,oy+28)
local CX=384
local LX,RX=CX-300,CX+232
local sy=330
local size,size2=96,128
-- backdrop layers by the defender's terrain (same table as the duel)
local sid=GetWarMap(dfn.x,dfn.y,1)
local pic1,pic2=0,10
if sid==0 or sid==7 then pic1=4 pic2=12
elseif sid==2 or sid==11 then pic1=0 pic2=13
elseif sid==1 then pic1=3 pic2=12
elseif sid==4 then pic1=1 pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then pic1=2 pic2=10 end
-- figures: attacker left facing right (d=3), defender right facing left (d=2)
local f={}
f[1]={x=CX-240,d=3,pic=pa[koFK_FIG] or 0,action=0,frame=0,effect=0,alpha=nil,wav=JY.Bingzhong[pa[koFK_BZ]][koFK_WAV]}
f[2]={x=CX+144,d=2,pic=pd[koFK_FIG] or 0,action=0,frame=0,effect=0,alpha=nil,wav=JY.Bingzhong[pd[koFK_BZ]][koFK_WAV]}
-- ko 5.0 (10-10): an attack from two or more tiles away (archers, strategists, catapults) is shot from where the
-- attacker stands - no charge - and an arrow flies across to the defender. A diagonal neighbour (1,1) is still a melee blow (10-10 user)
-- 10-10 user: by class - ranged classes always shoot from where they stand (even at a diagonal neighbour), the mixed ones
-- (Demon King, Gungyohui, the puppets) shoot only from beyond the 8 cells around, every other class (Xichu Bawang and
-- Han Gaozu included) always charges
local koRangedBZ={[4]=true,[5]=true,[6]=true,[13]=true,[16]=true,[21]=true,[22]=true,[26]=true,[35]=true,[37]=true,[38]=true}   -- dancers (27 무녀, 34 무희) charge with their blades (10-10 user)
local koMixedBZ={[32]=true,[33]=true,[36]=true}   -- the wooden puppet (29) charges instead of throwing stones (10-10 user)
local far=false
if koRangedBZ[pa[koFK_BZ]] then far=true
elseif koMixedBZ[pa[koFK_BZ]] then far=math.max(math.abs(a.x-dfn.x),math.abs(a.y-dfn.y))>1 end
local shot=nil
local shotKind=koFightShotKind(pa[koFK_BZ])
local P={pa,pd}
local WP={a,dfn}
local blmax={math.max(pa[koFK_BLMAX],1),math.max(pd[koFK_BLMAX],1)}
local bl={pa[koFK_BL],pd[koFK_BL]}
local sq={pa[koFK_SQ],pd[koFK_SQ]}
local blD0,sqD0=pd[koFK_BL],pd[koFK_SQ]
local msg,msgcolor=nil,M_White
local skip=false
local function teamcolor(wp)
if wp.enemy then return M_Red elseif wp.friend then return M_DarkOrange end
return M_Cyan
end
local function figure(i)
local s=f[i]
local id
local x,y=s.x,sy
if s.action==1 then id=(s.pic+s.frame+s.d*4)*2
elseif s.action==2 then id=(s.pic+30+s.frame+s.d*4)*2 x=x+(size-size2)/2 y=y+(size-size2)/2
elseif s.action==3 then id=(s.pic+22+s.d)*2
elseif s.action==4 then id=(s.pic+26+s.d%2)*2
elseif s.action==5 then id=(s.pic+20+s.frame)*2   -- ko 5.0: kneel / collapse (the duel loser frames)
elseif s.action==6 then id=(s.pic+28)*2
else id=(s.pic+16+s.d)*2 end
if s.alpha then
lib.PicLoadCache(11,id,x,y,1+2,s.alpha)
else
lib.PicLoadCache(11,id,x,y,1)
if s.effect>0 then lib.PicLoadCache(11,id,x,y,11,s.effect) end
end
end
-- info like the hover popup on the map (DrawStatusMini): name, class Lv, then bars with numbers
local function bar(x,y,ratio,len)
lib.Background(x,y+3,x+len,y+13,110,M_Black)
local color=212
if ratio<30 then color=210 elseif ratio<70 then color=211 end
if ratio>0 then
lib.SetClip(x,y+3,x+math.max(1,math.floor(len*ratio/100)),y+13)
lib.PicLoadCache(4,color*2,x,y+3,1)
lib.SetClip(0,0,0,0)
end
lib.DrawRect(x,y+3,x+len,y+13,M_DimGray)
end
local function panel(i,left)
local p,wp=P[i],WP[i]
local bx=left and LX or RX
local py=38
-- portrait, dimmed when the unit is gone
DrawBox(bx,py,bx+68,py+84,M_White)
lib.PicLoadCache(2,p[koFK_FACE]*2,bx+2,py+2,1)
if bl[i]<=0 then lib.Background(bx+2,py+2,bx+66,py+82,106) end
local x=left and bx+76 or bx-216
local y=py
lib.Background(x,y,x+208,y+124,160)
x=x+4 y=y+2
DrawString(x,y,p[koFK_NAME],teamcolor(wp),16)
DrawString(x+64,y,JY.Bingzhong[p[koFK_BZ]][koFK_BZNAME].."\161\161Lv"..p[koFK_LV],M_White,16)
local rows={
{koL_BL,100*math.max(bl[i],0)/blmax[i],string.format("%4d/%d",math.floor(bl[i]),blmax[i])},
{koL_SQ,math.min(100*math.max(sq[i],0)/math.max(wp.sq_limited or 100,1),100),string.format("%4d/%d",math.floor(sq[i]),wp.sq_limited or 100)},
{koL_CL,math.min(100*p[koFK_CL]/math.max(p[koFK_CLMAX],1),100),string.format("%4d/%d",p[koFK_CL],p[koFK_CLMAX])},
}
for r=1,3 do
y=y+20
bar(x+48,y,rows[r][2],120)
DrawString(x,y,rows[r][1].."\161\161\161\161 "..rows[r][3],M_White,16)
end
-- attack / defence, with the battle buffs (skills, terrain) that ReSetBuff put on the unit
local function buff(bx2,v)
if not v or v==0 then return end
DrawString(bx2,y,string.format("%+d%%",v),v>0 and M_Lime or M_Red,16)
end
-- attack / defence in two columns. The defence modifier is the battle buff (skills + terrain, kept in
-- def_buff by ReSetBuff) in enhanced mode, or just the terrain bonus otherwise (what WarAtkHurt applies)
local dx=GetWarMap(wp.x,wp.y,1)
y=y+20
local function koStat(cx,lab,val) DrawString(cx,y,(val>=1000) and string.format("%s%d",lab,val) or string.format("%s %3d",lab,val),M_White,16) end-- 11-06: four digits fill the column without the space (the % stays clear)
koStat(x,koL_ATK,p[koFK_ATK])
buff(x+64,CC.Enhancement and wp.atk_buff)
koStat(x+96,koL_DEF,p[koFK_DEF])
buff(x+160,CC.Enhancement and wp.def_buff or koFightTerrain[dx])
-- terrain the unit stands on | status, in the same two columns
y=y+20
DrawString(x,y,koL_TERR.." "..(War.DX[dx] or ""),M_White,16)
DrawString(x+96,y,koL_STAT,M_White,16)
local sx=x+136
if wp.troubled then DrawString(sx,y,koL_TROUBLE,M_Yellow,16) sx=sx+32 end
if (wp.poison or 0)>0 then DrawString(sx,y,koL_POISON,M_Lime,16) sx=sx+32 end
if sx==x+136 then DrawString(sx,y,koL_NORMAL,M_Gray,16) end
end
local function frame()
-- on a wider battle screen the scene is a 768x480 box over the map, so keep everything inside it
lib.SetClip(0,0,SW,SH)
lib.FillColor(0,0,SW,SH,M_Black)
-- the duel backdrops start at y=190; above that a flat fill in the sky tone of the far layer in use
-- (per-terrain averages measured from the pictures), darkening slightly towards the top
local skyc=koFightSky[pic1] or koFightSky[4]
for y=0,189,8 do
local k=(190-y)/190
lib.FillColor(0,y,SW,y+8,RGB(math.floor(skyc[1]*(1-0.25*k)),math.floor(skyc[2]*(1-0.2*k)),math.floor(skyc[3]*(1-0.08*k))))
end
lib.PicLoadCache(1,pic2*2,0,310,1)
lib.PicLoadCache(1,pic1*2,-68,190,1)
lib.SetClip(0,0,0,0)
panel(1,true)
panel(2,false)
-- far figure first
figure(2)
figure(1)
if shot then koFightDrawShot(shotKind,shot) end
lib.PicLoadCache(4,412,0,0,1)
lib.LoadSur(patch,12,2)
if str then DrawString(CX-3-#str*4,8,str,M_White,16) end
if msg and false then-- captions off (user request 2026-09-20)
local w=#msg*8+24
lib.Background(math.floor(CX-w/2),sy+94,math.floor(CX+w/2),sy+118,176,M_Black)
DrawString(math.floor(CX-#msg*4),sy+98,msg,msgcolor or M_White,16)
end
end
local function draw()
JY.ReFreshTime=lib.GetTime()
if ox~=0 or oy~=0 then
-- the (wider) battle screen stays behind the box, dimmed
DrawWarMap()
lib.Background(0,0,CC.ScreenW,CC.ScreenH,128)
koDrawShift(ox,oy,frame)
else
frame()
end
ReFresh(35/(CC.FrameNum or 35))--ko 11-10: the scene runs at the 1x frame (35 ms) whatever the speed setting; only koAnim speeds it up
local e=lib.GetKey(1)
if e==0 then koExit() end
if e==1 or e==3 then skip=true end
end
local function hold(n)
for i=1,math.max(1,math.floor(n/step)) do
if skip then return end
draw()
end
end
-- 1. face off
hold(6)
-- 2. charge: walk up to the defender
local target=f[2].x-112
if far then target=f[1].x end   -- ranged: stay put
f[1].action=1
local wavn=1
while f[1].x<target and not skip do
f[1].x=math.min(target,f[1].x+12*step)
f[1].frame=(f[1].frame+1)%2
if wavn==1 then PlayWavE(f[1].wav) wavn=4 else wavn=wavn-1 end
draw()
end
f[1].x=target
f[1].action=0
f[1].frame=0
-- 3. strike
local poseD=4
if flag2==1 then poseD=3 end   -- guard: just the pose (the "방어" caption was dropped on request)
-- (no "피해 없음" caption either: every mid-screen caption was dropped on request, 2026-09-20)
-- critical: the attacker charges up (brightens), same as the on-map animation
if flag2==2 then
PlayWavE(33)
for t=8,192,8*step do
if skip then break end
f[1].effect=t
draw()
end
f[1].effect=0
end
PlayWavE(a.atkwav)
f[1].action=2
for fr=0,3 do
f[1].frame=fr
if fr==2 and far then
local x0,x1=f[1].x+size-16,f[2].x+24
local count=math.max(4,math.ceil((shotKind=="stone" and 18 or 14)/step))
for n=1,count do
if skip then break end
local t=n/count
local arc=(shotKind=="stone") and 96 or 0
local rise=(shotKind=="talisman") and math.sin(t*math.pi*2)*5 or 0
shot={x=x0+(x1-x0)*t,y=sy+46-4*arc*t*(1-t)+rise,
dx=x1-x0,dy=-4*arc*(1-2*t),t=t}
draw()
end
shot=nil
end
if fr==2 then
f[2].action=poseD
if dfn.troubled then PlayWavE(35) elseif flag2==1 then PlayWavE(30) elseif flag2==2 then PlayWavE(36) else PlayWavE(35) end
f[2].effect=240
end
for r=1,math.max(1,math.floor(3/step)) do
if skip then break end
if fr>=2 then f[2].x=f[2].x+((r%2==0) and 6 or -6) end
draw()
if fr>=2 then f[2].x=f[2].x-((r%2==0) and 6 or -6) end
end
f[2].effect=0
end
f[1].frame=3
-- 4. troops / morale count down (this is what applies the damage, as on the map)
local t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
t=math.max(1,math.floor(t/step))--ko 11-11: the troop count-down follows koAnim too
for i=0,t do
if skip then break end
pd[koFK_BL]=blD0-hurt*i/t
pd[koFK_SQ]=sqD0-sq_hurt*i/t
bl[2]=pd[koFK_BL]
sq[2]=pd[koFK_SQ]
draw()
end
pd[koFK_BL]=blD0-hurt
pd[koFK_SQ]=sqD0-sq_hurt
bl[2]=pd[koFK_BL]
sq[2]=pd[koFK_SQ]
-- 5. defeated: fall and fade
if pd[koFK_BL]<=0 then
-- (no "격파" caption: the fall itself says it - user request 2026-09-20)
f[2].action=5 f[2].frame=1   -- ko 5.0 (10-10): the loser collapses like in the duel; 28 (action 6) is the winner raising his arms
for al=240,0,-math.max(24,24*step) do
if skip then break end
f[2].alpha=al
draw()
end
f[2].alpha=0
end
-- 6. hold
f[1].action=0
f[1].frame=0
if pd[koFK_BL]>0 then f[2].action=0 end
hold(6)
lib.FreeSur(patch)
lib.GetKey()
end


-- ---- registration (ko 3.1 addon "fight": 전투 장면)
-- ko 3.2: 가운데 칸은 "아군"이었는데, 판정이 공격자가 아니라 턴 주인이라(koFightOn 의 War.ControlStatus~='AI')
--   내 턴이면 적의 반격도 장면이 나오고 적 턴이면 내 반격도 안 나온다. 이름이 오해를 불러 "내턴"으로 바꿨다
--   (단추 칸이 36px = 한글 두 자라 더 길게는 못 쓴다). 저장되는 값은 숫자(CC.koFight)라 기존 설정은 그대로.
koAddon.settings[#koAddon.settings+1]={key="koFight",label="\130\066\132\101 \131\097\129\065",opts={{"\133\122",1},{"\131\095\129\112",2},{"\133\117",0}},default=0}
koOn("war_atk_scene",function(pid,eid,hurt,sq_hurt,flag2,str)
if not koFightOn() then return false end
koFightScene(pid,eid,hurt,sq_hurt,flag2,str)
return true
end)
