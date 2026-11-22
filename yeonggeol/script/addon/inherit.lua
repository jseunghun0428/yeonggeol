local koNG=CC.koNG-- (a jymain local in 3.0; exported as CC.koNG)
-- ko 3.0: 회차 계승 선택. Shown after "예" on the next-cycle offer; every item the rules allow is on by default.
-- Returns {stat,skill,hire,wskill,item,gold}: booleans, except hire = 1 (술집에 해금: the hired
-- ones wait in the tavern at full price from the start of the next cycle) / 0 (none); or nil when cancelled (Esc), which takes the "아니오" path.
-- 도구·금 stay locked below 도전 3 / 5 (the lowest difficulty used this cycle, 无用3), as before.
koNG.tier=function()
local tier=(JY.Base["\206\222\211\195\051"] or 0)-1
if tier<0 then tier=0 end
return tier
end
koNG.choose=function()
local tier=koNG.tier()
local sel={stat=true,skill=true,hire=1,wskill=true,item=(tier>=3),gold=(tier>=5)}
local rows={
{"stat","\131\077\131\125\132\081\135\122 \131\064\133\085",0},-- 능력치와 경험
{"skill","\129\120\131\071\135\122 \130\115\130\094",0},-- 특기와 천부
{"hire","\131\072\134\076 \129\073\131\097",0},-- 술집 무장
{"wskill","\129\073\131\071 \129\120\131\071",0},-- 무기 특기
{"item","\129\068\130\119 \131\097\130\080",3},-- 도구 장비
{"gold","\131\103 \133\089\133\065",5},-- 금 절반
}
local size=16
local w,h=320,240
local x,y
if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+640/2
y=16+400/2
else
x=CC.ScreenW/2
y=CC.ScreenH/2
end
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+h-36
local y2=y1+24
local bx1,bx2,bx3=x+136,x+174,x+212
local ry0=y+64
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function button(bx,by,str,flag,dim)
local box_w=36
local box_h=18
local cx=bx
local cy=by-1
if flag then
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,128,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Black)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Black)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Gray)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Gray)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,dim and M_Gray or M_White,size)
else
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,192,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Gray)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Gray)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Black)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Black)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,dim and M_Gray or M_Silver,size)
end
end
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
lib.PicLoadCache(4,80*2,x,y,1)
do
local yy=y+92
while yy<y+h-120 do
lib.SetClip(x,yy,x+w,math.min(yy+60,y+h-120))
lib.PicLoadCache(4,80*2,x,yy-28,1)
yy=yy+60
end
end
lib.SetClip(x,y+h-120,x+w,y+h)
lib.PicLoadCache(4,80*2,x,y+h-128,1)
lib.SetClip()
DrawString(x+16,y+16,"\130\125\132\121 \132\084\129\116 \133\109\133\110",C_Name,size)-- 회차 계승 선택
DrawStr(x+16,y+40,"\131\065\131\096\133\072\129\083 \135\103\131\099\129\083 \131\100\130\106\131\111\129\090",M_Silver,size)-- 물려받을 항목을 고르세요
for r=1,#rows do
local row=rows[r]
local ry=ry0+(r-1)*20
local locked=(tier<row[3])
DrawStr(x+16,ry,row[2],locked and M_Gray or M_White,size)
if row[1]=="hire" then
button(bx1,ry,"\133\122",sel.hire==1,false)-- 켬 = 해금 (offered by the tavern at once, full price; 3.1: the "부하로 계승" choice is gone)
button(bx2,ry,"\133\117",sel.hire==0,false)-- 끔
else
button(bx1,ry,"\133\122",sel[row[1]] and not locked,locked)-- 켬
button(bx2,ry,"\133\117",locked or not sel[row[1]],locked)-- 끔
end
if locked then
DrawStr(x+220,ry,"\129\068\130\066 "..row[3].." \132\115\129\090",M_Gray,size)-- 도전 N 필요
end
end
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
ShowScreen()
end
local function finish(ret)
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
ShowScreen()
return ret
end
koMouseReset()
local current=0
while true do
redraw(current)
local e,k=koPollKey()
if e==1 and k==27 then
return finish(nil)
elseif e==1 and (k==13 or k==32) then
PlayWavE(0)
return finish(sel)
end
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
return finish(sel)
else
current=0
for r=1,#rows do
local row=rows[r]
local ry=ry0+(r-1)*20
if row[1]=="hire" then
if MOUSE.CLICK(bx1,ry,bx1+36,ry+16) then sel.hire=1 PlayWavE(0)
elseif MOUSE.CLICK(bx2,ry,bx2+36,ry+16) then sel.hire=0 PlayWavE(0) end
elseif tier>=row[3] then
if MOUSE.CLICK(bx1,ry,bx1+36,ry+16) then
sel[row[1]]=true
PlayWavE(0)
elseif MOUSE.CLICK(bx2,ry,bx2+36,ry+16) then
sel[row[1]]=false
PlayWavE(0)
end
end
end
end
end
end


-- ---- registration (ko 3.1 addon "inherit": 회차 계승 선택 창)
koOn("cycle_choose",function() return koNG.choose() end)
