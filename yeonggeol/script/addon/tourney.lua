-- ko 3.0: 무술 대회 (title menu). An 8-man single-elimination duel tournament: the player's general plus seven
if not koNeeds("record") then return end
-- random ones from the FightMenu roster T. The player's own matches run the real duel (fight); the other matches
-- are settled at once by a strength roll (koTourRoll). Wins, the streak and the last champion live in
-- ko_settings.lua (CC.koTourWin / koTourStreak / koTourLast) and are shown on the entry screen.
function koTourRoll(a,b)
local function sc(id)
local p=JY.Person[id]
local s=p["\206\228\193\166"]+p["\181\200\188\182"]*0.3-- 武力 + 等级*0.3
for _,k in pairs({"\211\194\195\205","\192\228\190\178","\199\191\212\203","\205\254\183\231","\197\173\183\162","\181\215\193\166","\188\177\190\200","\178\187\199\252"}) do-- 勇猛 冷静 强运 威风 怒发 底力 急救 不屈
s=s+(p[k] or 0)*4
end
return s
end
local x,y=sc(a),sc(b)
x=x*x y=y*y
if math.random()*(x+y)<x then return a end
return b
end
function koTourney(T)
koTourneySub(T,false)
Dark()-- the title loop redraws the art and fades in
end
-- 무장 메뉴 > 무술 대회: one of my generals against seven from the roster; 참가비 500, 우승 상금 3000. Wins (事件1971) and
-- semifinal entries (事件1972) gate 여포·호적·목인·진평 in the tavern
koTourFee=500
koTourPrize=5000--ko 5.0: 3000 -> 5000 (player feedback; still once per story battle won)
-- 3.6 later: the prize is paid once per story battle won (事件1960 = 事件1999 + 1 when it was last paid). Before, 참가비 500 /
-- 상금 3000 could be repeated without end in the city (endless gold). Entering again still counts the wins (tavern gates).
function koTourPrizeReady() return koRec(1963)~=koRec(1999)+1 end
function koTourPrizeTake() koRecSet(1963,koRec(1999)+1) end
-- koTourFix1963 5.0 (10-11): the prize record moved 1960 -> 1963. 1960 is the carry flag of tavern slot 510 (장로, 1870+90), so a
-- prize marked him as carried. An old save: 1960 set but 510 is not a carried record (carried = portrait set and 新头像代号 0,
-- koNG.reset) -> it was the prize: move it to 1963 and clear 1960 so 장로 comes back to the tavern.
do
local lr=LoadRecord
function LoadRecord(...)
local r=lr(...)
pcall(function()
local v=koRec(1960)
local p=JY.Person[510]
if v>0 and p and (p["\205\183\207\241\180\250\186\197"]==0 or p["\208\194\205\183\207\241\180\250\186\197"]~=0) then
if koRec(1963)==0 then koRecSet(1963,v) end
koRecSet(1960,0)
end
end)
return r
end
end
function koTourneyCity(T)
koTourneySub(T,true)
DrawSMap()
if JY.Dark then Light() end
end
function koTourneySub(T,ingame)
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
local cx=ox+384
local function classicBack()
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
koRecordClassicFrame(ox,oy,768,480)
end
local function classicButton(b,on,hover)
local pic=((on or hover) and 62 or 61)*2
local yy=b.y+math.floor((b.h-22)/2)
local split=math.min(126,math.floor(b.w/2))
lib.SetClip(b.x,yy,b.x+split,yy+22)
lib.PicLoadCache(4,pic,b.x,yy,1)
lib.SetClip(b.x+split,yy,b.x+b.w,yy+22)
lib.PicLoadCache(4,pic,b.x+b.w-130,yy,1)
lib.SetClip(0,0,0,0)
DrawString(b.x+b.w/2-#b.s*4,yy+3,b.s,M_White,16)
end
local function classicWait(draw,buttons)
for _,b in ipairs(buttons) do if not b.plain then b.draw=classicButton end end
return koTourWait(draw,buttons)
end
local NAME="\208\213\195\251"-- 姓名
local WL="\206\228\193\166"-- 武力
local function ctext(y,s,color,size)
size=size or 16
DrawString(cx-#s*size/4,y,s,color,size)
end
-- 5.0 (10-13, 사용자): pick the general from a 5x3 face grid in a window over the entry screen (like 도감, without its
-- full screen and buttons), page by page. Mouse: click a face; 이전 / 다음 under the grid. Keys: arrows (left / right off a
-- row's end turn the page), PgUp / PgDn, Enter, Esc.
-- 10-13 (사용자 "\133\090\129\101\131\098 \133\109\133\110\131\099\133\108\129\102\131\087 \129\100\131\107"): 군악대 13 · 요술사 16 · 보급대 19 · 모사 26 · 선인 35 are left out of the
-- tourney: the pick list, 무작위 무장 and (사용자 10-13, later) the bracket's opponents
-- (사용자 10-13: 선자 stays; bttt 406 — a test entry with an ad picture for a face — is left out here and from the opponents)
local KEY_BZ="\177\248\214\214"-- 兵种
local function fighters(list)
local r={}
for _,id in ipairs(list) do local b=JY.Person[id][KEY_BZ] if id~=406 and (id==389 or (b~=13 and b~=16 and b~=19 and b~=26 and b~=35)) then r[#r+1]=id end end-- 兵种; 389 선자 (선인, 무력 78) stays, 406 bttt (the original engine's test entry) never
return r
end
local function classicSelect(roster,bg)
local NM,WLK,FC="\208\213\195\251","\206\228\193\166","\205\183\207\241\180\250\186\197"-- 姓名 武力 头像代号
local COLS,ROWS,CW,CH=5,3,92,100
local per=COLS*ROWS
local page,pages=1,math.max(1,math.ceil(#roster/per))
local pw,ph=COLS*CW+24,34+ROWS*CH+38
local px,py=ox+math.floor((768-pw)/2),oy+math.floor((480-ph)/2)
local prevB={px+16,py+ph-34,px+136,py+ph-8}
local nextB={px+pw-136,py+ph-34,px+pw-16,py+ph-8}
local sel,kbd,mx,my=1,false,MOUSE.x,MOUSE.y
local function count() return math.max(0,math.min(per,#roster-(page-1)*per)) end
local function cell(k) local c,r=(k-1)%COLS,math.floor((k-1)/COLS) local x,y=px+24+c*CW,py+34+r*CH return x,y,x+68,y+100 end
local function link(b,s,ok)
local on=ok and MOUSE.IN(b[1],b[2],b[3],b[4])
koRecordClassicBar(b[1],b[2]+2,b[3]-b[1],on)
DrawString(math.floor((b[1]+b[3])/2-#s*4),b[2]+5,s,ok and M_White or M_Gray,16)
end
local function draw()
if bg then bg(0) else classicBack() end
lib.Background(0,0,CC.ScreenW,CC.ScreenH,128,M_Black)
koRecordClassicFrame(px,py,pw,ph)
DrawString(px+18,py+10,"\129\073\131\097 \131\100\130\106\131\071",C_Name,16)
local hov=0
for k=1,count() do
local id=roster[(page-1)*per+k]
local p=JY.Person[id]
local x,y,x2,y2=cell(k)
local on=(kbd and sel==k) or (not kbd and MOUSE.IN(x,y,x2,y2))
if on then hov=k end
lib.FillColor(x,y,x+68,y+84,RGB(0,0,0))
DrawBox(x,y,x+68,y+84,on and M_White or M_Yellow,-1)
if on then for d=0,1 do lib.DrawRect(x+d,y+d,x+68-d,y+d,C_Name) lib.DrawRect(x+d,y+84-d,x+68-d,y+84-d,C_Name) lib.DrawRect(x+d,y+d,x+d,y+84-d,C_Name) lib.DrawRect(x+68-d,y+d,x+68-d,y+84-d,C_Name) end end
lib.PicLoadCache(2,p[FC]*2,x+2,y+2,1)
local nm=p[NM]
DrawString(x+34-#nm*4,y+86,nm,on and C_Name or M_White,16)
end
local s=page.." / "..pages
DrawString(px+math.floor(pw/2)-#s*4,py+ph-29,s,M_Silver,16)
link(prevB,"\129\071\130\066",page>1)
link(nextB,"\129\077\130\077",page<pages)
if hov>0 then-- 10-13: a tooltip beside the face: what the duel uses — 무력 (bar) and the nine duel moves, the ones this general has bright
local p=JY.Person[roster[(page-1)*per+hov]]
local bj,lj,wl=p["\177\169\187\247"],p["\193\172\187\247"],p[WLK]-- 暴击 连击 武力
local mv={-- the duel's 규칙 table (fight_sub draw_help): name, usable
{"\130\073\133\064",bj%2==1},{"\132\115\134\106 \130\073\133\064",math.floor(bj/2)%2==1},{"\130\073\133\064 \137\066\129\103",bj>=4},
{"3\133\066\130\112",lj%2==1},{"5\133\066\130\112",math.floor(lj/2)%2==1},{"\132\087\132\121 \133\066\130\112",lj>=4},
{"\130\125\133\088",p["\187\216\194\237"]>0},{"\130\080\131\071",p["\195\216\188\188\049"]>0},{"\134\088\136\112\131\071",wl>=100},-- 回马 秘技1
}
local got=0 for _,m in ipairs(mv) do if m[2] then got=got+1 end end
local w,h=300,154
local x,y=cell(hov)
local tx=x+76
if tx+w>ox+764 then tx=x-8-w end-- right of the face while the screen has room (it may leave the window)
tx=math.max(4,tx)
local ty=math.min(y-6,py+ph-h-4)
koRecordClassicFrame(tx,ty,w,h)
DrawString(tx+12,ty+10,p[NM],C_Name,16)
-- 무력: number and a bar (100 = full)
DrawString(tx+12,ty+34,"\129\073\131\125",M_Silver,16)
DrawString(tx+56,ty+34,tostring(wl),M_White,16)
local bx,bw=tx+92,w-104
DrawBox(bx-1,ty+37,bx+bw+1,ty+49,M_Silver,-1)
lib.FillColor(bx,ty+38,bx+bw,ty+48,M_Black)
lib.FillColor(bx,ty+38,bx+math.floor(bw*math.min(wl,100)/100),ty+48,wl>=90 and RGB(220,80,60) or (wl>=70 and RGB(230,170,60) or RGB(120,170,220)))
lib.DrawRect(tx+10,ty+60,tx+w-10,ty+60,M_Silver)
DrawString(tx+12,ty+68,"\133\073\131\071\137\083 \131\071\131\072  "..got.." / 9",M_Silver,16)
for i,m in ipairs(mv) do
local c,r=(i-1)%3,math.floor((i-1)/3)
DrawString(tx+12+c*96,ty+92+r*20,m[1],m[2] and M_White or RGB(150,150,150),16)
end
end
end
koMouseReset()
while true do
JY.ReFreshTime=lib.GetTime()
if MOUSE.x~=mx or MOUSE.y~=my then kbd=false mx,my=MOUSE.x,MOUSE.y end
draw()
ShowScreen()
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then koExit() end
local n=count()
local pick
local oldPage=page
if e==1 then
if k==27 then return 0
elseif k==13 or k==32 then if kbd then pick=sel else kbd=true end
elseif k==1073741899 then if page>1 then page=page-1 end
elseif k==1073741902 then if page<pages then page=page+1 end
elseif k>=1073741903 and k<=1073741906 then
if not kbd then kbd=true
elseif k==1073741904 then-- left
if (sel-1)%COLS==0 then if page>1 then page=page-1 sel=sel+COLS-1 end else sel=sel-1 end
elseif k==1073741903 then-- right
if sel%COLS==0 or sel>=n then if page<pages then page=page+1 sel=sel-(sel-1)%COLS end else sel=sel+1 end
elseif k==1073741906 then if sel>COLS then sel=sel-COLS end-- up
elseif k==1073741905 then if sel+COLS<=n then sel=sel+COLS end-- down
end
end
end
if MOUSE.ESC() then return 0 end
if page>1 and MOUSE.CLICK(prevB[1],prevB[2],prevB[3],prevB[4]) then page=page-1
elseif page<pages and MOUSE.CLICK(nextB[1],nextB[2],nextB[3],nextB[4]) then page=page+1
else
for c=1,n do local x,y,x2,y2=cell(c) if MOUSE.CLICK(x,y,x2,y2) then pick=c end end
end
if page~=oldPage then PlayWavE(0) end
sel=math.max(1,math.min(sel,count()))
if pick then
PlayWavE(0)
local id=roster[(page-1)*per+pick]
local p=JY.Person[id]
if WarDrawStrBoxYesNo(p[NM].."  \129\073\131\125 "..p[WLK],M_White,true) then return id end
koMouseReset()
end
if MOUSE.status=="CLICK" then MOUSE.status="IDLE" end
end
end
-- entry screen
local wins=CC.koTourWin or 0
local streak=CC.koTourStreak or 0
local last=CC.koTourLast or 0
if ingame then wins=koRec(1971) streak=koRec(1972) end-- in the city: 우승 / 4강 진출 from the save
local lastname="\130\097\130\077"-- 없음
if (CC.koTourLastName or "")~="" then lastname=CC.koTourLastName-- 11-11: the winner's name (any story's general; shared by the four stories)
elseif last>0 and last<JY.PersonNum and JY.Person[last] then lastname=JY.Person[last][NAME] end
local btns={
{x=cx-270,y=oy+330,w=160,h=28,s="\129\073\131\097 \131\100\130\106\131\071"},-- 무장 고르기
{x=cx-80,y=oy+330,w=160,h=28,s="\129\073\129\074\130\110 \129\073\131\097",hide=ingame},-- 무작위 무장 (title only)
{x=cx+110,y=oy+330,w=160,h=28,s="\137\066\129\110\129\094\131\071"},-- 돌아가기
}
local function intro(hov)
classicBack()
ctext(oy+96,"\129\073\131\072 \130\095\130\125",C_Name,32)-- 무술 대회
ctext(oy+164,"\129\073\131\097 \129\098\144\106\129\071 \132\125\131\094\130\098 \137\083\129\072\137\113\141\074",M_White)-- 무장 여덟이 겨루는 토너먼트
ctext(oy+190,"\131\111 \130\087 \129\071\132\125 \131\079\129\116\129\097\131\111\129\090",M_White)-- 세 번 이겨 우승하세요
if ingame then
ctext(oy+250,"\131\079\129\116 "..wins.."\130\125   4\130\073 \129\103\133\098 "..streak.."\130\125",M_Silver)-- 우승 N회  4강 진출 N회
ctext(oy+276,"\134\126\129\094\130\080 "..koTourFee.."\131\103   \131\079\129\116 \129\067\131\103 "..(koTourPrizeReady() and (koTourPrize.."\131\103") or "\130\097\130\077"),M_Silver)
ctext(oy+302,koTourPrizeReady() and "\129\067\131\103\131\098 \130\066\132\101\129\102\131\087 \129\071\134\114 \132\085\133\088\129\077 \129\111 \130\087 \133\072\129\075\129\076\129\077" or "\129\067\131\103\131\098 \129\077\130\077 \130\066\132\101\129\102\131\087 \129\071\140\073 \135\068\129\102 \129\077\130\086 \130\064\132\116\129\076\129\077",M_Gray)-- 참가비 N금  우승 상금 N금
else
ctext(oy+250,"\131\079\129\116 "..wins.."\130\125   \133\066\129\116 "..streak.."   \136\122\134\090 \131\079\129\116 "..lastname,M_Silver)-- 우승 N회 연승 N 최근 우승 X
end
end
local r=classicWait(intro,btns)
if r==0 or r==3 or (ingame and r==2) then return end
local me=0
if ingame then
if koGold()<koTourFee then WarDrawStrBoxConfirm("\131\103\129\071 \130\090\133\120\140\101\129\076\129\077",M_White,true) return end-- 금이 모자랍니다
local mine={}
for i=1,JY.PersonNum-1 do if JY.Person[i]["\190\253\214\247"]==1 then mine[#mine+1]=i end end
mine=fighters(mine)-- 10-13: no 문관
if #mine==0 then WarDrawStrBoxConfirm("\131\095\131\115\137\077 \129\073\131\097\129\071 \130\097\129\075\129\076\129\077",M_White,true) return end-- 내보낼 무장이 없습니다
me=classicSelect(mine,intro)
if me==0 then return end
koSetGold(koGold()-koTourFee)
elseif r==1 then
me=classicSelect(fighters(T),intro)
if me==0 then return end
else
local F=fighters(T) me=F[math.random(#F)]-- 10-13: no 문관
end
-- the field: me + 7 others, shuffled into the bracket
local pool={}
for _,v in pairs(fighters(T)) do if v~=me and JY.Person[v]["\190\253\214\247"]~=1 then pool[#pool+1]=v end end-- never my own generals
local P={}
for i=1,7 do P[i]=table.remove(pool,math.random(#pool)) end
P[8]=me
for i=8,2,-1 do local j=math.random(i) P[i],P[j]=P[j],P[i] end
-- R[1]=8 entrants, R[2]=4, R[3]=2, R[4]={champion}; lost[id]=true once beaten
local R={P,{},{},{}}
local lost={}
local msg=""
local sub=""
-- 3.6 later: the bracket as a tree growing upward: the eight portraits at the bottom, round winners on plates above,
-- the champion's portrait on top; the path of every winner lit in gold
local FACE="\205\183\207\241\180\250\186\197"
local GOLD,LINE,PLATE,EDGE=M_Yellow,M_Silver,RGB(0,0,48),M_Silver-- lines white, the winners' path gold
local fy=oy+272
local function x0(k) return ox+76+(k-1)*88 end
local function xc(c,i)
if c==1 then return x0(i) end
return math.floor((xc(c-1,2*i-1)+xc(c-1,2*i))/2)
end
local PY={[2]=oy+218,[3]=oy+162}
local JY_={oy+250,oy+206,oy+150}
local function hl(x1,x2,y,col) if x1>x2 then x1,x2=x2,x1 end lib.FillColor(x1-1,y-1,x2+1,y+1,col) end
local function vl(x,y1,y2,col) if y1>y2 then y1,y2=y2,y1 end lib.FillColor(x-1,y1,x+1,y2+1,col) end
local function frame(x1,y1,x2,y2,col)
lib.DrawRect(x1,y1,x2,y1,col) lib.DrawRect(x1,y2,x2,y2,col) lib.DrawRect(x1,y1,x1,y2,col) lib.DrawRect(x2,y1,x2,y2,col)
end
local function plate(x,y,w,id)
koRecordClassicFrame(x-w/2-4,y-4,w+8,30)
local col=EDGE
if id==me then col=C_Name elseif not id then col=LINE end
frame(x-w/2,y,x+w/2,y+22,col)
if id then
local s=JY.Person[id][NAME]
DrawString(x-#s*4,y+3,s,lost[id] and M_Gray or ((id==me) and C_Name or M_White),16)
end
end
local function face(x,y,id,big)
local col=(id==me) and C_Name or EDGE
if big then col=GOLD end
lib.FillColor(x-4,y-4,x+68,y+84,M_Black)
frame(x-4,y-4,x+68,y+84,col) frame(x-2,y-2,x+66,y+82,big and M_Yellow or M_Silver)
if id then
lib.PicLoadCache(2,JY.Person[id][FACE]*2,x,y,1)
if lost[id] then lib.Background(x,y,x+64,y+80,90,M_Black) end
else
DrawString(x+24,y+24,"?",M_Gray,32)
end
end
local function bracket(hov)
classicBack()
-- title plaque
koRecordClassicFrame(cx-120,oy+6,240,32)

ctext(oy+10,"\129\073\131\072 \130\095\130\125",C_Name,24)
-- lines: dim first, then the lit ones over them
for pass=1,2 do
for c=1,3 do
local n=2^(4-c)
for i=1,n do
local id=R[c][i]
local up=R[c+1][math.floor((i+1)/2)]
local lit=(id~=nil) and (up==id)
if (pass==1)==(not lit) then
local col=lit and GOLD or LINE
local ytop=(c==1) and (fy-4) or PY[c]
local x,xp=xc(c,i),xc(c+1,math.floor((i+1)/2))
vl(x,JY_[c],ytop,col)
hl(x,xp,JY_[c],col)
local yb=(c==3) and (oy+140) or (PY[c+1]+22)
vl(xp,JY_[c],yb,col)
end
end
end
end
-- the eight portraits with their names and war power
for k=1,8 do
local id=R[1][k]
local x=x0(k)
face(x-32,fy,id)
plate(x,fy+86,80,id)
if id then
local s="\129\073\131\125 "..JY.Person[id][WL]
DrawString(x-#s*4,fy+110,s,lost[id] and M_Gray or M_Silver,16)
end
end
for c=2,3 do for i=1,2^(4-c) do plate(xc(c,i),PY[c],96,R[c][i]) end end
-- the champion
local ch=R[4][1]
face(cx-32,oy+56,ch,true)
for i=0,4 do lib.FillColor(cx-18+i*9,oy+44-((i%2==0) and 4 or 0),cx-14+i*9,oy+50,GOLD) end
lib.FillColor(cx-18,oy+48,cx+22,oy+52,GOLD)
if ch then
local s=JY.Person[ch][NAME]
koRecordClassicFrame(cx+44,oy+80,#s*8+20,32)
DrawString(cx+54,oy+88,s,C_Name,16)
end
-- round names on the left
DrawString(ox+8,fy+32,"8\130\073",M_Gray,16)
DrawString(ox+8,PY[2]+3,"4\130\073",M_Gray,16)
DrawString(ox+8,PY[3]+3,"\134\064\129\116",M_Gray,16)
DrawString(ox+8,oy+88,"\131\079\129\116",M_Gray,16)
ctext(oy+410,msg..((sub~="") and ("  "..sub) or ""),M_White)
end
local function bracketOld(hov)
classicBack()
ctext(oy+6,"\129\073\131\072 \130\095\130\125  \130\095\129\103\133\113",C_Name,24)-- 무술 대회 대진표
local colx={ox+70,ox+250,ox+430,ox+610}
local head={"8\130\073","4\130\073","\134\064\129\116","\131\079\129\116"}-- 8강 4강 결승 우승
for c=1,4 do DrawString(colx[c]+20,oy+60,head[c],M_Gray,16) end
local function rowy(c,i)-- y of slot i in column c
local step=40*2^(c-1)
return oy+86+step/2-20+(i-1)*step
end
local function cell(c,i,id)
local x,y=colx[c],rowy(c,i)
if id then
local col=M_White
if lost[id] then col=M_Gray elseif id==me then col=C_Name end
local s=JY.Person[id][NAME]
DrawString(x,y,s,col,16)
if c==1 then DrawString(x+80,y,tostring(JY.Person[id][WL]),lost[id] and M_Gray or M_Silver,16) end
else
lib.DrawRect(x,y+18,x+100,y+18,M_Gray)
end
end
for c=1,4 do
local n=2^(4-c)
for i=1,n do cell(c,i,R[c][i]) end
if c<4 then
for i=1,n,2 do
local y1,y2=rowy(c,i)+8,rowy(c,i+1)+8
local x=colx[c]+124
lib.DrawRect(x,y1,x,y2,M_Gray)
lib.DrawRect(x,(y1+y2)/2,colx[c+1]-6,(y1+y2)/2,M_Gray)
end
end
end
ctext(oy+400,msg..((sub~="") and ("  "..sub) or ""),M_White)
end
-- 3.6 later: a second button (or Esc) leaves the tourney after a yes; pause returns true then (koTourQuit)
local go={{x=cx-190,y=oy+436,w=180,h=26,s=""},{x=cx+10,y=oy+436,w=180,h=26,s="\131\091\132\086\130\091\131\071"}}
local function pause(label)
go[1].s=label
if JY.Dark then bracket(0) Light() end
while true do
if classicWait(bracket,go)==1 then return false end
if WarDrawStrBoxYesNo("\130\095\130\125\130\104 \131\091\132\086\130\091\131\100 \131\118\135\121\129\089\129\090?*\131\071\135\098\131\109\132\083 \139\110\129\117\140\106\129\076\129\077",M_White,true) then return true end-- 10-16 (cafe report, android): notWar=true; without it the box drew the war map (War.Width nil at the title / in the city) and the Lua error closed the game
end
end
local NEXT="\134\117\130\106\129\065 \131\064\131\071 \130\086\129\074"-- 누르면 경기 시작
local CONT="\134\117\130\106\129\065 \132\084\133\123"-- 누르면 계속
local VS=" \130\095 "
local alive=true
for rd=1,3 do
local n=2^(4-rd)
local mine=0
-- everyone else first (instant)
for i=1,n,2 do
local a,b=R[rd][i],R[rd][i+1]
if alive and (a==me or b==me) then
mine=i
else
local w=koTourRoll(a,b)
R[rd+1][(i+1)/2]=w
lost[(w==a) and b or a]=true
end
end
if mine>0 then
local a,b=R[rd][mine],R[rd][mine+1]
local opp=(a==me) and b or a
msg=rd.."\130\102\135\083\133\119  \131\095 \129\073\131\097 "..JY.Person[me][NAME]..VS..JY.Person[opp][NAME]-- N라운드  내 무장 X 대 Y
sub=""
if pause(NEXT) then if not ingame then CC.koTourStreak=0 koSave() end return end-- koTourQuit: a forfeit ends the streak
local s={0,1,2,4,6}
koDuelPlayer=me-- ko 3.1: my general picks its cards (fight_sub is_human)
pcall(GetPic,a) pcall(GetPic,b)-- 10-16 (cafe report): the duel draws the record's 战斗形象 as it is, stale after LoadRecord (장수 관리) or at the title; work it out again (unique · 장수편집 · tiered sets) like a battle does
local res=fight(a,b,s[math.random(5)])
koDuelPlayer=0
local w=(res==1) and a or b
R[rd+1][(mine+1)/2]=w
lost[(w==a) and b or a]=true
if w==me then
if rd==1 and ingame then koRecAdd(1972) end-- 4강 진출
if rd==3 then
if ingame then
koRecAdd(1971)
local prize=koTourPrizeReady() and koTourPrize or 0
if prize>0 then koSetGold(koGold()+prize) koRecGold(prize) koTourPrizeTake() end
msg=JY.Person[me][NAME].." \131\079\129\116  "..((prize>0) and ("\131\079\129\116 \129\067\131\103 "..prize.."\131\103") or "(\129\067\131\103 \130\097\130\077)")-- X 우승  우승 상금 N금
sub=""
else
CC.koTourWin=wins+1
CC.koTourStreak=streak+1
CC.koTourLast=me CC.koTourLastName=JY.Person[me][NAME]
koSave()
msg=JY.Person[me][NAME].." \131\079\129\116  \129\099\129\097\129\087\129\076\129\077"-- X 우승  축하합니다
sub=(streak+1).."\133\066\129\116"-- N연승
end
else
msg=JY.Person[me][NAME].." \129\116\129\117"-- X 승리
sub=""
end
else
alive=false
if not ingame then CC.koTourStreak=0 koSave() end
msg=JY.Person[me][NAME].." \138\120\136\121"-- X 탈락
sub=""
end
if pause(CONT) then return end
end
end
if not alive then
msg="\131\079\129\116\133\120  "..JY.Person[R[4][1]][NAME]-- 우승자 X
sub=""
if pause(CONT) then return end
end
end


-- ---- registration (ko 3.1 addon "tourney": 무술 대회; needs record for the city counters)
for _,k in ipairs({"koTourWin","koTourStreak","koTourLast"}) do koAddon.saveKeys[#koAddon.saveKeys+1]={key=k,default=0} end
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koTourLastName",default=""}-- 11-11
koOn("title_fight",function(T)-- 11-11: the four stories' generals in one roster (newgen koTourAllRoster), the temporary slots cleared after
if rawget(_G,"koTourAllRoster") then T=koTourAllRoster(T) end
local ok,err=pcall(koTourney,T)
if rawget(_G,"koTourAllCleanup") then koTourAllCleanup() end
if not ok then error(err,0) end
return true end)
koAddon.personMenu[#koAddon.personMenu+1]={label="\129\073\131\072 \130\095\130\125",run=function() koTourneyCity(koTourRoster()) end}
