-- Original menu artwork across drinking contest rules, turns and results.
function koDrinkClassicBack()
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
koRecordClassicFrame(ox,oy,768,480)
koBrightText=true
end
function koDrinkClassicWait(draw,buttons)
for _,b in ipairs(buttons) do
if not b.plain and not b.draw then
b.draw=function(b,on,hover)
local yy=b.y+math.floor((b.h-22)/2)
koRecordClassicBar(b.x,yy,b.w,on or hover)
DrawString(b.x+b.w/2-#b.s*4,yy+3,b.s,M_White,16)
end
end
end
return koTourWait(draw,buttons)
end
-- ko 4.0 later: 술집 연전 = 술 겨루기 (addon "drink", needs record; the 연전 record no longer comes from 짝 맞추기 (lianliankan)).
-- 무장 메뉴 > 술 겨루기: one of my generals out-drinks tavern guests one after another. 취기 (0~100, falls at 100) is halved
-- between matches; the best run is the 연전 record (事件333, the field the tavern gates have always read, max 30), so an old
-- 짝 맞추기 record still counts. Opponents 4·8·9·11·12·15·16 are the generals the record unlocks, each with a rule of
-- their own. Numbers: 개발용/문서/술겨루기 설계.md (tuned with the drink2.pl simulation).
-- Build (game folder): perl "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/\129\068\130\119/free_hz.pl" < ".../addon/drink_src.lua" > script/addon/drink.lua
if not koNeeds("record") then return end
local EV="\202\194\188\254"-- 事件
local NAME="\208\213\195\251"-- 姓名
local WL="\206\228\193\166"-- 武力
local ZL="\214\199\193\166"-- 智力
local TS="\205\179\194\202"-- 统率
local LV="\181\200\188\182"-- 等级
local FACE="\205\183\207\241\180\250\186\197"-- 头像代号
local LORD="\190\253\214\247"-- 君主
-- rules (see the design doc)
local BIG,SMALL=20,8           -- 큰 사발 / 권주 (작은 잔)
local ANJU,ANJU0,ANJUMAX=12,3,5 -- 안주: 취기 -12; 3 at the start, 5 at most
local SOUP=12                  -- 판 사이 해장국
local LIMIT=12                 -- after 12 offers only 큰 사발
local CAP=30
local DRINKERS={["\131\097\130\080"]=1,["\135\109\133\102"]=1,["\132\065\131\079\131\064"]=1,["\131\089\130\067\134\100"]=1,["\129\073\135\112"]=1,["\135\089\135\098"]=1}-- 술꾼 +20
local BOSS={
[4]={id=385,rule="\130\114\129\095\132\086 \133\072\130\098\129\077. \135\098\130\075\129\097\129\065 \131\072\138\084\129\071 \132\110\130\083\131\070\129\077\134\066 \129\108\131\071\129\094 \131\095\131\096\133\121\129\077",
     win="\129\097\129\097\129\097! \129\071 \130\101\129\071 \131\070\129\109. \131\072\134\076\129\102\131\087 \129\111\137\120 \132\108 \129\087\130\086\129\077"},
[8]={id=386,rule="\130\075\132\088\129\071 \132\094\130\067\132\086 \131\110 \130\114\129\095 \130\065\129\098\144\106\129\083 \130\080\131\079\129\065 \136\096\133\101\129\103\129\077",
     win="\130\065\129\098\144\106 \130\114\129\095\129\083 \129\077 \130\080\131\079\129\081 \129\097\129\077\129\076, \131\064\134\111\130\073 \129\071\133\067 \139\110\130\077\129\071\129\091"},
[9]={id=11,rule="\129\108\131\071\129\094 80\129\083 \132\124\131\109\129\065 \129\111 \130\087 \133\126\129\083 \137\066\131\106\129\077 (\129\108\131\071 -10)",
     win="\130\073\130\108\131\080 \134\113\135\124\129\071\129\094 \131\072\129\102 \130\067\129\077\129\076. \131\072\134\076\129\102\131\087 \131\071\129\077\129\117\134\121\129\109"},
[10]={id=388,rule="\131\118\129\073 \136\117\129\071\130\102 \131\110 \130\114\129\095\129\071 \133\065\132\086 \131\126\134\066\136\101\129\077",
     win="\138\089\133\083... \131\072\129\071 \131\126\134\066 \132\108\130\098 \136\108\132\076\133\073 \129\113 \130\097\129\077... \130\075\129\106\129\083 \130\105\130\106\134\121\129\077"},
[11]={id=5,rule="\135\098\130\075\129\097\129\065 \131\123\129\083 \131\095\134\066 \129\077\130\077\129\102 \131\110 \130\114\129\095 \130\091 \134\075\130\104 \135\098\129\111\129\077",
     win="\133\077, \131\072\132\083 \131\118\130\104 \129\071\140\073 \133\120\130\098 \139\110\130\077\129\071\129\077. \138\111\129\077, \130\105\130\102\129\094 \130\075\130\067"},
[12]={id=403,rule="\133\113\129\070\129\083 \133\123\129\106\129\077 (\129\078\129\100\131\115\129\077 \136\124\140\068\129\066 \131\115\129\106\129\077)",
     win="\129\100 \140\118\134\094\129\083 \143\070\131\109\138\086\130\084\129\090. \129\071\129\100 \142\081\130\104 \140\102\131\096 \133\119\129\117\130\067\129\090"},
[13]={id=405,rule="\137\071\136\079\129\071\130\102 \131\110 \130\114\129\095\129\083 \133\072\131\109\129\065 \129\077\130\077\129\102 1.5\134\099 \130\114\129\095\132\083 \139\121\130\098\129\077",
     win="\133\072\131\098 \132\086\141\065 \139\121\131\116\130\098\133\104\129\068 \131\070\130\119\131\096. \129\071 \137\071\136\079, \131\091\130\095\130\104 \130\105\130\106\129\117\129\077"},
[15]={id=143,rule="\135\098\130\075\129\094 \132\119\129\097\130\067 \130\107\131\100, \131\091\129\094 \135\098\129\097\130\098 \137\120\131\098 \131\088 1.3\134\099",
     win="\136\124\132\083\129\068 \131\072\132\083\129\068 \131\070\130\084\129\090. \131\072\134\076\129\102\131\087 \129\077\130\086 \139\112\130\067\129\090"},
[16]={id=404,rule="\134\119\129\106 \139\073\129\071\130\102 \131\095 \129\108\131\071\130\104 \129\113\132\081\132\083 \133\082 \129\113 \130\097\129\077",
     win="\129\108\129\097\130\067 \130\107\130\098 \135\076\129\071\130\086\132\112\129\090. \131\072\134\076\129\102\131\087 \131\071\129\077\132\117\129\081\129\090"},
}
-- 6.0 (11-01): in a story (koCamp) person 11 / 143 is somebody else — find 손견 / 주유 there by name; when he is the hero or one of
-- the story's own generals (손견전's 손견 …), the stage goes to a special guest instead (좌자 390 / 선자 389, the same people in every story)
local campFixed=false
local function campFix()
if campFixed or not rawget(_G,"koCamp") or not (JY and JY.Person and JY.Person[1]) then return end
campFixed=true
local own={[1]=true}
for _,p in ipairs((koCamp.storyhire and koCamp.storyhire.STORY) or {}) do own[p]=true end
for st,w in pairs({[9]={"\135\089\134\084",390},[15]={"\130\075\130\071",389}}) do
local pick
for i=2,382 do if JY.Person[i][NAME]==w[1] and not own[i] then pick=i break end end
local ds=rawget(_G,"koDrinkStage")
if ds then ds[BOSS[st].id]=nil end
BOSS[st].id=pick or w[2]
if ds then ds[BOSS[st].id]=st end
end
end
koOn("title",function() campFix() return nil end)
local FACES={"\136\124\140\068","\133\100\131\091\130\082","\130\080\140\071","\139\117\129\094 \139\118\129\082"}

local function rec() return JY.Base[EV.."333"] or 0 end
-- ko 5.0: the 짝 맞추기 (사천성) record, kept apart from the 술 겨루기 one (事件1965 = stage + 1; see Game_Cycle below).
-- Global: jymain koStreakOK reads it too (a tavern gate of N = 술 겨루기 boss N beaten or 사천성 stage N cleared)
local LLK=EV.."1965"
function koLlkRec()
local v=JY.Base[LLK] or 0
if v==0 then return rec() end
return v-1
end
local function pname(id) return JY.Person[id][NAME] end
local function myQ(id)
local p=JY.Person[id]
return 50+p[WL]/4+p[TS]/4+p[LV]/3+(DRINKERS[p[NAME]] and 20 or 0)
end
local function oppQ(n) return 25+3.75*n+(BOSS[n] and 3 or 0)+(n==8 and 10 or 0) end
local function rnd() return 0.75+math.random()*0.5 end
-- 큰 사발: the receiver is cowed by a higher 무력 (x1.3 at most); 권주: talked into more by a higher 지력 (x1.6 at most)
local function mult(act,ow,oi,rw,ri)
local m
if act=="B" then m=1+(ow-rw)/100 if m>1.3 then m=1.3 end
else m=1+(oi-ri)/50 if m>1.6 then m=1.6 end end
if m<1 then m=1 end
return m
end
local function faceOf(v) local k=math.floor(v/25)+1 if k<1 then k=1 end if k>4 then k=4 end return FACES[k] end

-- shared with gate · free · record: the stage of each 연전 general (story id and tavern slot) and the condition text
koDrinkStage={[385]=4,[386]=8,[11]=9,[428]=9,[388]=10,[5]=11,[442]=11,[403]=12,[405]=13,[143]=15,[464]=15,[404]=16}
function koDrinkCond(n,short)-- short: without the record part (the 도감 shows the progress on its own line)
local b=BOSS[n]
local s="\131\072 \132\125\131\094\131\071 "..n.."\130\087\142\091 "..(b and pname(b.id) or "\129\067\130\095").." \129\071\131\071\131\071"
if short then return s.." \135\079\130\098 \130\114\130\115\131\123 "..n.."\130\070" end
return s.." (\131\071\133\108 "..math.min(rec(),n).."/"..n..")*  \135\079\130\098 \130\114\130\115\131\123 "..n.."\130\070 ("..math.min(koLlkRec(),n).."/"..n..")"
end

-- the n-th guest: a general who is not mine, of the given style, whose main stat is nearest 40+2.2n
local function pickGuest(n,used)
local style=(math.random(2)==1) and "B" or "T"
local want=40+2.2*n if want>99 then want=99 end
local boss={} for _,b in pairs(BOSS) do boss[b.id]=true end
local best,bd={},999
local ids={}
local KC=rawget(_G,"koCamp")
if KC and KC.recBook then for _,i in ipairs(KC.recBook) do ids[#ids+1]=i end-- 6.0 (11-01): a story's named generals (its own 도감 list)
else
for i=2,256 do ids[#ids+1]=i end-- the named generals (257~376 are 보병대·궁병대·상인… unit / townsfolk records)
for _,i in ipairs({377,378,379,380,383,384}) do ids[#ids+1]=i end-- 축융 장완 비위 제갈균 헌제 동승
end
for _,i in ipairs(ids) do
local p=JY.Person[i]
if p and not used[i] and not boss[i] and p[LORD]~=1 and (p[FACE] or 0)>0 and p[NAME]~="" and (p[WL] or 0)>0 then
local main,other=p[WL],p[ZL]
if style=="T" then main,other=p[ZL],p[WL] end
if main>=other then
local d=math.abs(main-want)
if d<bd-2 then best={i} bd=d elseif d<=bd+2 then best[#best+1]=i end
end
end
end
if #best==0 then return nil end
return best[math.random(#best)],style
end

function koDrink()
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
local cx=ox+384
local GOLD,PLATE,EDGE=M_Yellow,RGB(0,0,48),M_Silver
local function ctext(y,s,color,size) size=size or 16 DrawString(cx-#s*size/4,y,s,color,size) end
local function frame(x1,y1,x2,y2,col)
lib.DrawRect(x1,y1,x2,y1,col) lib.DrawRect(x1,y2,x2,y2,col) lib.DrawRect(x1,y1,x1,y2,col) lib.DrawRect(x2,y1,x2,y2,col)
end
local function plaque(y,s,size)
size=size or 24
local w=#s*size/4+24
koRecordClassicFrame(cx-w,y,w*2,size+16)

ctext(y+8,s,C_Name,size)
end
local function face(x,y,id)
lib.FillColor(x-4,y-4,x+68,y+84,M_Black)
frame(x-4,y-4,x+68,y+84,EDGE)
lib.PicLoadCache(2,JY.Person[id][FACE]*2,x,y,1)
end
-- intro
local function bossRow(y,keys)
local s=""
for _,k in ipairs(keys) do s=s..k.." "..pname(BOSS[k].id).."  " end
local x=cx-#s*4
for _,k in ipairs(keys) do
local t=k.." "..pname(BOSS[k].id)
DrawString(x,y,t,(rec()>=k) and C_Name or M_Silver,16)
x=x+(#t+2)*8
end
end
local RULES={
"\130\087\135\121\129\110 \137\120\129\083 \135\098\129\087\129\076\129\077. \135\098\129\111 \139\074\129\071 \137\113\133\102 \133\088\130\086\131\100 \133\072\131\098 \139\074\129\071 \130\105\130\102 \133\088\135\073\129\076\129\077",
"\129\108\131\071\129\094 100\129\071 \132\067\129\065 \136\096\133\101\134\076\129\076\129\077. \129\067\130\095\129\094 \137\113\133\102 \135\098\129\097\131\100, 12\130\087 \135\068\132\083\130\098 \131\110 \130\114\129\095\132\086",
"\131\110 \130\114\129\095: \138\101 \129\077 20. \131\095 \129\073\131\125\129\071 \137\069\131\109\129\065 \129\067\130\095\129\094 \131\071\131\111\129\102 \141\083\131\096 \132\108 \133\088\131\078\129\077",
"\135\098\130\075: \138\101 \129\077 8. \131\095 \130\067\131\125\129\071 \137\069\131\109\129\065 \129\067\130\095\129\094 \136\124\129\102 \132\124\130\083\129\094 \132\108 \133\088\131\078\129\077",
"\130\111\130\075: \133\088\130\086\130\067 \130\107\131\100 \131\095 \129\108\131\071 -12 (\133\066\130\066 \130\066\133\114\129\102\131\087 \139\110\130\077 3\134\075, \135\065\129\110\133\069 5\134\075)",
"\130\075\132\088 = \129\073\131\125\161\164\132\119\132\120\161\164\130\082\130\123 (\131\072\137\091\131\098 \132\108 \141\065). \130\095\133\113\130\098 \130\075\132\088\129\071 \131\110 \129\073\131\097\131\109\132\083!",
"\129\067\130\095 \129\108\131\071\130\098 \133\113\129\070\131\109\132\083\132\086 \131\115\129\104\129\076\129\077 (\130\067\131\125 85 \129\071\129\067\129\071\129\065 \202\238\133\120\132\083)",
"\129\071\131\071\129\065 \129\108\131\071\129\094 \133\065\131\109\132\083 \132\123\131\100 \129\066\131\097\129\125\161\164\130\111\130\075\161\164\129\070\142\126 \129\094\135\083\133\104 \129\097\131\118\130\104 \131\100\139\123\129\076\129\077",
}
local mode="intro"
local ib={
{x=cx-270,y=oy+390,w=160,h=28,s="\130\095\133\113 \131\100\130\106\131\071"},
{x=cx-80,y=oy+390,w=160,h=28,s="\135\118\135\111 \131\115\131\071"},
{x=cx+110,y=oy+390,w=160,h=28,s="\137\066\129\110\129\094\131\071"},
}
local function intro(hov)
koDrinkClassicBack()
if mode=="rules" then
plaque(oy+20,"\131\072 \132\125\131\094\131\071 \135\118\135\111")
koRecordClassicFrame(ox+56,oy+100,656,252)
for i,s in ipairs(RULES) do DrawString(ox+70,oy+80+i*30,s,M_White,16) end
return
end
-- the jars and banners behind the text
plaque(oy+40,"\131\072 \132\125\131\094\131\071",32)
ctext(oy+120,"\130\095\133\113 \129\073\131\097 \129\111 \130\088\129\071 \131\072\134\076 \135\089\138\105\131\082\129\123 \132\121\139\126\132\083 \130\075\132\088\129\083 \132\125\143\098\129\076\129\077",M_White)
ctext(oy+146,"\136\096\133\101\130\067\131\071 \130\066\129\089\130\067 \140\090 \130\088\129\083 \129\071\131\071\130\098\130\067\129\094 \133\066\130\066 \131\071\133\108\129\104\129\076\129\077",M_White)
ctext(oy+190,"\129\071 \132\121\139\126\131\080 \129\067\130\095\130\104 \129\071\131\071\129\065 \131\091 \129\073\131\097\129\071 \131\072\134\076\129\102 \131\118\133\111\129\076\129\077",M_Silver)
bossRow(oy+216,{4,8,9,10,11})
bossRow(oy+240,{12,13,15,16})
ctext(oy+264,"(\130\114\130\115\131\123\129\083 \131\091 \130\070\129\089\130\067 \141\090\129\068 \130\065\132\116\129\076\129\077)",M_Gray)
ctext(oy+292,"\136\122\131\100 \131\071\133\108 "..rec().."\130\088",C_Name,24)
ctext(oy+328,"\130\095\133\113\130\098 \130\075\132\088\129\071 \131\110 \129\073\131\097\131\109\132\083: \131\072\137\091, \137\069\131\098 \129\073\131\125\161\164\132\119\132\120\161\164\130\082\130\123",M_Silver)
end
while true do
mode="intro"
local r=koDrinkClassicWait(intro,ib)
if r==0 or r==3 then return end
if r==2 then mode="rules" koDrinkClassicWait(intro,{{x=cx-80,y=oy+400,w=160,h=28,s="\137\066\129\110\129\094\131\071"}}) end
if r==1 then break end
end
local mine={}
for i=1,JY.PersonNum-1 do if JY.Person[i][LORD]==1 and not (rawget(_G,"koViewEligible") and koViewSide() and i~=koViewBro() and not koViewEligible(i)) then mine[#mine+1]=i end end-- 삼형제 외전: 그 형제와 해금 장수만
if #mine==0 then return end
-- 10-13 (사용자 "\129\073\131\072 \130\095\130\125\129\102\131\087 \131\100\130\106\130\098 \131\117\139\110\134\123"): 대표 = face grid 5x3 with pages (the 무술 대회 picker's look), the biggest
-- 주량 first; the tooltip beside a face shows the 주량 and what makes it
table.sort(mine,function(a,b) local qa,qb=myQ(a),myQ(b) if qa~=qb then return qa>qb end return a<b end)
local function pickRep(roster)
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
koDrinkClassicBack()
koRecordClassicFrame(px,py,pw,ph)
DrawString(px+18,py+10,"\130\095\133\113 \131\100\130\106\131\071",C_Name,16)
DrawString(px+pw-18-#"\130\075\132\088 \131\110 \132\065\131\087"*8,py+10,"\130\075\132\088 \131\110 \132\065\131\087",M_Silver,16)
local hov=0
for k=1,count() do
local id=roster[(page-1)*per+k]
local x,y,x2,y2=cell(k)
local on=(kbd and sel==k) or (not kbd and MOUSE.IN(x,y,x2,y2))
if on then hov=k end
lib.FillColor(x,y,x+68,y+84,RGB(0,0,0))
DrawBox(x,y,x+68,y+84,on and M_White or M_Yellow,-1)
if on then for d=0,1 do frame(x+d,y+d,x+68-d,y+84-d,C_Name) end end
lib.PicLoadCache(2,JY.Person[id][FACE]*2,x+2,y+2,1)
local nm=pname(id)
DrawString(x+34-#nm*4,y+86,nm,on and C_Name or M_White,16)
end
local s=page.." / "..pages
DrawString(px+math.floor(pw/2)-#s*4,py+ph-29,s,M_Silver,16)
link(prevB,"\129\071\130\066",page>1)
link(nextB,"\129\077\130\077",page<pages)
if hov>0 then
local id=roster[(page-1)*per+hov]
local p=JY.Person[id]
local q=math.floor(myQ(id))
local w,h=300,(p[ZL]>=85) and 116 or 136
local x,y=cell(hov)
local tx=x+76
if tx+w>ox+764 then tx=x-8-w end
tx=math.max(4,tx)
local ty=math.min(y-6,py+ph-h-4)
koRecordClassicFrame(tx,ty,w,h)
DrawString(tx+12,ty+10,p[NAME],C_Name,16)
if DRINKERS[p[NAME]] then DrawString(tx+w-12-#"\131\072\137\091 +20"*8,ty+10,"\131\072\137\091 +20",RGB(120,220,120),16) end
DrawString(tx+12,ty+34,"\130\075\132\088",M_Silver,16)
DrawString(tx+56,ty+34,tostring(q),M_White,16)
local bx,bw=tx+92,w-104
DrawBox(bx-1,ty+37,bx+bw+1,ty+49,M_Silver,-1)
lib.FillColor(bx,ty+38,bx+bw,ty+48,M_Black)
lib.FillColor(bx,ty+38,bx+math.floor(bw*math.min(q,150)/150),ty+48,q>=120 and RGB(220,80,60) or (q>=100 and RGB(230,170,60) or RGB(120,170,220)))
lib.DrawRect(tx+10,ty+60,tx+w-10,ty+60,M_Silver)
DrawString(tx+12,ty+68,"\129\073\131\125 "..p[WL].."   \132\119\132\120 "..p[TS].."   \130\082\130\123 "..p[LV],M_White,16)
DrawString(tx+12,ty+90,"\130\067\131\125 "..p[ZL],M_White,16)
DrawString(tx+92,ty+90,p[ZL]>=85 and "\129\067\130\095 \129\108\131\071: \202\238\133\120\132\083 \131\115\129\082" or "\129\067\130\095 \129\108\131\071: \133\113\129\070\132\086 \131\115\129\082",p[ZL]>=85 and RGB(120,220,120) or M_Silver,16)
if p[ZL]<85 then DrawString(tx+12,ty+112,"\130\067\131\125 85 \129\071\129\067\129\071\129\065 \202\238\133\120\132\083 \131\115\129\104\129\076\129\077",RGB(150,150,150),16) end-- (술 겨루기 중 상대의 취기: 지력 85 미만은 표정으로만)
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
elseif k==1073741904 then
if (sel-1)%COLS==0 then if page>1 then page=page-1 sel=sel+COLS-1 end else sel=sel-1 end
elseif k==1073741903 then
if sel%COLS==0 or sel>=n then if page<pages then page=page+1 sel=sel-(sel-1)%COLS end else sel=sel+1 end
elseif k==1073741906 then if sel>COLS then sel=sel-COLS end
elseif k==1073741905 then if sel+COLS<=n then sel=sel+COLS end
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
if WarDrawStrBoxYesNo(pname(id).."  \130\075\132\088 "..math.floor(myQ(id)).."*\129\071 \129\073\131\097\129\083 \130\095\133\113\132\083 \131\095\131\115\139\103\129\076\129\089?",M_White,true) then return id end
koMouseReset()
end
if MOUSE.status=="CLICK" then MOUSE.status="IDLE" end
end
end
local me=pickRep(mine)
if not me or me==0 then return end
-- the run
local Q=myQ(me)
local MW,MI=JY.Person[me][WL],JY.Person[me][ZL]
local drunk,anju,spy=0,ANJU0,false
local used={[me]=true}
local best0=rec()
local n=0
local O,od,bowls,rage,wind,repay,boss,log,between
local function say(s) log[#log+1]=s if #log>5 then table.remove(log,1) end end
local function seeOpp() -- exact number for the opponent?
if spy then return true end
if boss==12 then return MI>=95 end
return MI>=85
end
local function drawBar(x,y,v,exact,label)
DrawString(x,y,label,M_Silver,16)
if exact then
lib.FillColor(x,y+22,x+160,y+36,RGB(30,26,36))
local w=math.floor(160*math.min(v,100)/100)
local col=(v<25) and RGB(110,190,110) or (v<50) and RGB(220,200,90) or (v<75) and RGB(230,140,60) or RGB(220,60,50)
if w>0 then lib.FillColor(x,y+22,x+w,y+36,col) end
frame(x,y+22,x+160,y+36,EDGE)
DrawString(x+168,y+20,tostring(math.floor(math.min(v,100))),M_White,16)
else
DrawString(x,y+22,"\133\113\129\070: "..faceOf(v),M_White,16)
end
end
local function ruleLine(s)-- a dark strip behind it: the lanterns and banners of the tavern sit right there
local w=#s*4+12
koRecordClassicFrame(cx-w,oy+48,w*2,28)
DrawString(cx-#s*4,oy+54,s,C_Name,16)
end
local function board(hov)
koDrinkClassicBack()
if between then plaque(oy+6,n.."\130\088 \129\116\129\117  \129\077\130\077\131\098 "..(n+1).."\130\087\142\091 \129\067\130\095") else plaque(oy+6,n.."\130\087\142\091 \129\067\130\095  "..O.name) end
if between then
local nb=BOSS[n+1]-- the next one is a boss: name and rule now, so the choice can count on it
if nb then ruleLine("\129\077\130\077: "..pname(nb.id).." - "..nb.rule) end
elseif boss then ruleLine(BOSS[boss].rule) end
-- me (left), opponent (right)
face(ox+150,oy+80,me)
DrawString(ox+182-#pname(me)*4,oy+168,pname(me),C_Name,16)
drawBar(ox+102,oy+192,drunk,boss~=16,"\129\108\131\071")
face(ox+554,oy+80,O.id)
DrawString(ox+586-#O.name*4,oy+168,O.name,M_White,16)
local v=od
if boss==12 and not seeOpp() then v=od-25 if v<0 then v=0 end end-- 진평 looks soberer than he is
drawBar(ox+506,oy+192,v,seeOpp(),"\129\108\131\071")
DrawString(cx-16,oy+110,"\130\095",M_Gray,32)
DrawString(ox+102,oy+246,"\130\111\130\075 "..anju.."\134\075",M_Silver,16)
if boss==8 then DrawString(ox+506,oy+246,"\131\110 \130\114\129\095 "..bowls.." / 18",M_Silver,16) end
-- log
koRecordClassicFrame(ox+90,oy+272,588,116)

for i,s in ipairs(log) do DrawString(ox+104,oy+260+i*21,s,(i==#log) and M_White or M_Silver,16) end
end
local function quit()
return WarDrawStrBoxYesNo("\133\066\130\066\129\083 \131\091\132\086\138\101\129\089\129\090?*\129\098\131\071\131\087 \131\091\132\086\130\091\129\065 \129\071\130\087 \129\067\130\095\129\102\129\081 \129\103 \131\117\131\109\132\083 \138\126\129\076\129\077.",M_White,true)
end
local function oppDrink(cup,m)
od=od+cup*m*100/O.Q*rnd()
if cup>=BIG then bowls=bowls+1 end
if boss==9 and not wind and od>=80 and od<100 then od=od-10 wind=true say(O.name..": \133\126\129\083 \137\066\131\106\129\077 (\129\108\131\071 -10)") end
if boss==8 then return bowls>=18 or od>=100 end
return od>=100
end
local function meDrink(cup,m)
local g=cup*m*100/Q*rnd()
drunk=drunk+g
return drunk>=100,g
end
local CUP={B="\131\110 \130\114\129\095\129\083",T="\135\098\130\075\130\104"}
local runEnd=false
local won
while not runEnd do
n=n+1
boss=BOSS[n] and n or nil
if boss then
local b=BOSS[n]
O={id=b.id,name=pname(b.id),W=JY.Person[b.id][WL],I=JY.Person[b.id][ZL],style=(JY.Person[b.id][WL]>=JY.Person[b.id][ZL]) and "B" or "T"}
if n==4 or n==8 or n==10 or n==11 or n==13 then O.style="B" end
else
local id,st=pickGuest(n,used)
if not id then id,st=2,"B" end
O={id=id,name=pname(id),W=JY.Person[id][WL],I=JY.Person[id][ZL],style=st}
end
used[O.id]=true
O.Q=oppQ(n)
od,bowls,rage,wind,repay=0,0,false,false,false
log={}
say(n.."\130\087\142\091 \129\067\130\095 "..O.name.." \133\125\131\097. \129\067\130\095\129\094 \137\113\133\102 \135\098\129\087\129\076\129\077")
won=nil
local r=0
while won==nil do
r=r+1
local final=r>LIMIT
if r==LIMIT+1 then say("\139\091\131\097: \129\071\129\100\130\094\131\104 \131\110 \130\114\129\095\132\086 \129\091\134\104\129\076\129\077") end
if r%2==1 then
-- the opponent offers
local act=final and "B" or O.style
local cup=(act=="B") and BIG or SMALL
local m=mult(act,O.W,O.I,MW,MI)
if rage then cup=2*BIG act="B" rage=false m=mult("B",O.W,O.I,MW,MI) end
if repay then cup=BIG*1.5 act="B" repay=false m=mult("B",O.W,O.I,MW,MI) end
if boss==15 and act=="T" and m<1.3 then m=1.3 end
if cup>BIG*1.6 then say(O.name..": \131\110 \130\114\129\095 \130\091 \134\075\130\104 \135\098\129\111\129\077") elseif cup>BIG then say(O.name..": \133\072\131\098 \130\114\129\095\129\083 1.5\134\099\132\083 \139\121\130\098\129\077") else say(O.name..": "..CUP[act].." \135\098\129\111\129\077") end
local k=koDrinkClassicWait(board,{{x=cx-90,y=oy+406,w=180,h=28,s="\133\072\129\110 \133\088\131\078\129\077"}})
if k==0 and quit() then won=false runEnd=true break end
if oppDrink(cup,1) then say(O.name.." \136\096\133\101\131\070\129\077!") won=true break end
local fell,g=meDrink(cup,m)
say(pname(me)..": \133\072\129\110 \133\088\138\086\129\077 (\129\108\131\071 +"..math.floor(g+0.5)..")")
if fell then say(pname(me).." \136\096\133\101\131\070\129\077...") won=false break end
else
-- my offer
local b={
{x=cx-270,y=oy+406,w=160,h=28,s="\131\110 \130\114\129\095"},
{x=cx-80,y=oy+406,w=160,h=28,s="\135\098\130\075",hide=final},
{x=cx+110,y=oy+406,w=160,h=28,s="\130\111\130\075 ("..anju..")",hide=final or anju<=0},
}
local k=koDrinkClassicWait(board,b)
if k==0 then
if quit() then won=false runEnd=true break end
r=r-1
elseif k==3 then
anju=anju-1 drunk=drunk-ANJU if drunk<0 then drunk=0 end
say(pname(me)..": \130\111\130\075\132\083 \133\126\129\083 \131\100\135\077\129\077 (\129\108\131\071 -"..ANJU..")")
elseif k==2 and boss==4 then
local fell,g=meDrink(SMALL,1)
od=od-10 if od<0 then od=0 end
say(O.name..": \131\072\138\084 \132\110\130\083\130\067\129\081 \129\074\131\098 \137\120\129\071\130\102\129\076! (\129\067\130\095 \129\108\131\071 -10)")
if fell then say(pname(me).." \136\096\133\101\131\070\129\077...") won=false break end
elseif k==1 or k==2 then
local act=(k==1) and "B" or "T"
if act=="T" and boss==11 then rage=true end
if act=="B" and boss==13 then repay=true end
local cup=(act=="B") and BIG or SMALL
local m=mult(act,MW,MI,O.W,O.I)
if act=="T" and boss==15 then m=1 end
if act=="B" and boss==10 then m=m*0.5 end
say(pname(me)..": "..CUP[act].." \135\098\129\111\129\077")
local fell,g=meDrink(cup,1)
if fell then say(pname(me).." \137\113\133\102 \136\096\133\101\131\070\129\077...") won=false break end
if oppDrink(cup,m) then say(O.name.." \136\096\133\101\131\070\129\077!") won=true break end
say(O.name..": \133\072\129\110 \133\088\138\086\129\077"..(rage and " (\131\123\129\071 \138\103\129\077!)" or ""))
end
end
end
if won==nil then won=false end
if not won then
runEnd=true
else
-- a win: the record, gold for a new best, the boss's line, then the halving and a choice
local got=0
if n>rec() and n<=CAP then
-- the first 술 겨루기 record on a save: 事件333 still holds the old shared 사천성 progress (or 0); pin it as the
-- 사천성 record first, so 사천성 does not jump ahead to this 술 겨루기 stage (and lose the early stages' gold)
if (JY.Base[LLK] or 0)==0 then JY.Base[LLK]=rec()+1 end
JY.Base[EV.."333"]=n
end
if n>best0 and n<=CAP then
got=200+20*n
koSetGold(koGold()+got)
if koRecGold then koRecGold(got) end
end
if boss then say(O.name..": "..BOSS[boss].win) end
if got>0 then say("\134\068 \131\071\133\108! \131\103 "..got.." \131\067\131\068") end
koDrinkClassicWait(board,{{x=cx-90,y=oy+406,w=180,h=28,s="\132\084\133\123"}})
if n>=CAP then
runEnd=true
else
drunk=drunk*0.5
spy=false
between=true
log={}
say(n.."\130\088\142\091 \129\116\129\117. \129\108\131\071\129\094 \133\065\131\109\132\083 \132\123\132\107\129\077 (\130\067\131\103 "..math.floor(drunk)..")")
say("\129\077\130\077 \129\067\130\095\130\104 \138\071\131\071 \130\066\129\102 \129\097\131\118\130\104 \131\100\130\106\131\111\129\090")
say("\129\066\131\097\129\125: \131\095 \129\108\131\071\130\104 "..SOUP.." \132\123\129\104\129\076\129\077")-- 10-13 (사용자 "\129\070\142\126\129\071 \129\160 \131\093\129\106\130\067 \130\090\130\106\134\121\129\077"): what each choice does
say("\130\111\130\075 +1: \130\111\130\075\130\104 \129\097\131\118 \132\108 \142\074\140\086\129\076\129\077 (\135\065\129\110\133\069 "..ANJUMAX.."\134\075)")
say("\129\070\142\126: \129\077\130\077 \129\067\130\095\131\080 \129\108\131\071\129\094 \133\113\129\070 \130\095\131\078 \202\238\133\120\132\083 \131\115\129\104\129\076\129\077")
local c={
{x=cx-270,y=oy+406,w=160,h=28,s="\129\066\131\097\129\125 (\129\108\131\071 -"..SOUP..")"},
{x=cx-80,y=oy+406,w=160,h=28,s="\130\111\130\075 +1 ("..anju.."/"..ANJUMAX..")",hide=anju>=ANJUMAX},
{x=cx+110,y=oy+406,w=160,h=28,s="\129\070\142\126 (\129\108\131\071 \131\115\131\071)"},
}
local k
repeat k=koDrinkClassicWait(board,c) until k>0
between=false
if k==1 then drunk=drunk-SOUP if drunk<0 then drunk=0 end
elseif k==2 then anju=anju+1
else spy=true end
end
end
end
-- the end
local wins=won and n or (n-1)
log={}
if wins>=CAP then say("\131\087\135\077 \130\088\129\083 \130\090\130\091 \132\095\132\107\129\077! \131\072\134\076\131\080 \130\066\129\069\129\071 \132\067\132\107\129\077")
else say(n.."\130\087\142\091 \129\067\130\095 "..O.name.."\129\102\129\081\131\087 \133\066\130\066\129\071 \139\091\138\103\129\077") end
say("\129\071\130\087 \133\066\130\066 "..wins.."\130\088   \136\122\131\100 \131\071\133\108 "..rec().."\130\088")
koDrinkClassicWait(board,{{x=cx-90,y=oy+406,w=180,h=28,s="\137\066\129\110\129\094\131\071"}})
end
function koDrinkCity()
koDrink()
DrawSMap()
if JY.Dark then Light() end
end

-- ---- registration: 무장 메뉴 > 술 겨루기
koAddon.personMenu[#koAddon.personMenu+1]={label="\131\072 \132\125\131\094\131\071",run=function() koDrinkCity() end}
-- ko 5.0: the 짝 맞추기 (사천성) run stays behind its hidden entrance (50 clicks on 유비's face, city screen top right) as a
-- gold source, but keeps its own record now: 事件1965 = stage + 1 (0 = never played: start from the old shared 事件333
-- record, so a save does not earn the early stages' gold twice). It no longer moves 事件333, which is the 술 겨루기 record
-- the tavern gates read. Same loop as jymain's Game_Cycle otherwise (lianliankan pays 200+20N on a stage's first clear).
function Game_Cycle()
for i=koLlkRec()+1,9999 do
PlayBGM(math.random(19))
if lianliankan(i+9) then
if i>koLlkRec() and i<=30 then JY.Base[LLK]=i+1 end
else
return
end
end
end
koAddon.carry[#koAddon.carry+1]={from=1965,to=1965}
