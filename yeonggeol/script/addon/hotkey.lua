-- ko 3.0: battle keyboard shortcuts, called from control() for every key event.
-- Returns what control() should hand back: 0 handled, -1 cancel/menu, -3 run 기능 menu item War.koKeyMenu,
-- nil = not a shortcut
-- move the mouse pointer (logical units): ko_sdl.dll picks the request up from ko_warp.txt on the next frame
function koWarpMouse(x,y)
local h=io.open(CONFIG.CurrentPath.."ko_warp.txt","w")
if h then h:write(math.floor(x).." "..math.floor(y)) h:close() end
MOUSE.x,MOUSE.y=math.floor(x),math.floor(y)
end
function koBattleKey(k)
-- arrows scroll the map in any state
local dx,dy=0,0
if k==1073741903 then dx=1 elseif k==1073741904 then dx=-1 elseif k==1073741905 then dy=1 elseif k==1073741906 then dy=-1 end
if dx~=0 or dy~=0 then
War.CX=limitX(War.CX+dx,1,math.max(1,War.Width-War.MW+1))
War.CY=limitX(War.CY+dy,1,math.max(1,War.Depth-War.MD+1))
return 0
end
-- ko 3.3: M shows / hides the wide layout's minimap (saved; hidden = clicks reach the map cells under it)
if k==109 then koMiniToggle() PlayWavE(0) return 0 end
if k==27 then return -1 end
if War.ControlStatus~="select" or not War.ControlEnable then return nil end
if k==13 or k==32 then War.koKeyMenu=1 return -3          -- 턴 종료 (asks, like the menu)
elseif k==118 then War.koKeyMenu=4 return -3               -- V 승리조건
elseif k==102 then War.koKeyMenu=5 return -3               -- F 기능설정
elseif k==97 then koArmyList(false) return 0               -- A 아군 목록
elseif k==101 then koArmyList(true) return 0               -- E 적군 목록
elseif k==9 then                                            -- Tab: scroll to the next own unit that can still act (no selecting)
if koNextIdle(true) then PlayWavE(0) else PlayWavE(2) end   -- ko 3.6: shared with the 미행동 bar button, cycles through them
return 0
end
return nil
end


-- ---- registration (ko 3.1 addon "hotkey": 전투 단축키)
koOn("battle_key",function(k) return koBattleKey(k) end)
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koMiniOff",default=0}-- ko 3.3: M (minimap hidden)
-- ko 3.3 hotfix: the same toggle as a wide top bar button "지도", for the phone (no M key there)
function koMiniToggle()
CC.koMiniOff=((CC.koMiniOff or 0)==1) and 0 or 1
koSave()
end
koAddon.barButtons[#koAddon.barButtons+1]={label="\130\067\129\068",run=function() koMiniToggle() end}-- 지도
-- ko 3.6: "미행동 N" = how many allies can still act; a click centres the next one (the same as Tab, the pointer stays on the button)
koAddon.barButtons[#koAddon.barButtons+1]={w=76,label=function() return "\134\119\130\093\130\108 "..koIdleCount() end,
run=function() if koNextIdle(false) then return true end PlayWavE(2) return false end}
-- ko 3.1: Space during the enemy phase skips its presentation (the base's koWarPump asks; War.koSkip stays on until the phase ends)
koOn("ai_key",function(k) if k==32 and not War.koInTalk then return true end return nil end)
-- ko 3.3 hotfix 5: 적 턴 연출 생략 (setting CC.koSkipAI). The base starts every enemy phase with War.koSkip on and
-- War.koSkipKeep marking it; the lines (talk_sub, WaitKey) are then shown the normal way, and Space pressed to page
-- through them is not taken as the skip key (War.koInTalk)
local function koKeepTalk(f)
return function(...)
if War and War.koSkipKeep and War.koSkip and not War.koInTalk then
War.koSkip=false War.koInTalk=true
local r=table.pack(f(...))
War.koSkip=true War.koInTalk=false
return table.unpack(r,1,r.n)
end
return f(...)
end
end
local koTalkWrapped=false
koOn("title",function()-- addons load before the base defines talk_sub / WaitKey
if koTalkWrapped then return end
koTalkWrapped=true
talk_sub=koKeepTalk(talk_sub)
WaitKey=koKeepTalk(WaitKey)
WarDrawStrBoxWaitKey=koKeepTalk(WarDrawStrBoxWaitKey)-- the battle notices that wait for a key
end)
koAddon.settings[#koAddon.settings+1]={key="koSkipAI",label="\131\076 \129\112 \133\066\133\098",opts={{"\131\115\131\071",0},{"\129\096\130\118",1}},default=0}-- 적 턴 연출: 보기 / 생략
koOn("draw_overlay",function()
if War.koSkip and War.koAI then
local s="\131\076 \129\112 \129\119\129\072\136\099\130\098 \130\101"-- 적 턴 건너뛰는 중
local x=math.floor(CC.ScreenW/2-#s*4)
lib.Background(x-8,32,x+#s*8+8,52,96,M_Black)
DrawString(x,34,s,M_Yellow,16)
end
end)

-- ko 3.6: 큰 지도 (a long press on the minimap, see koMiniDrag). The battle map itself, shrunk to 16 px a cell once
-- (data/mbig.grp, made from mmap.grp by 개발용/도구/big_grp.ps1), is opened in picture slot 12 at the scale that fits the
-- screen; without it the minimap pictures (data/mmini.grp, 개발용/도구/mini_grp.pl) are used. On it: 회복 지형 marks
-- (마을·녹채·병영, green), hidden tools "?" (the spots the battle's event script checks with WarLocationItem, while their
-- flag is not set yet), units (our side blue, acted grey, enemy red, 우군 orange), and under the pointer the unit name or
-- the terrain name. A click on the map moves the view there and closes; Esc, a right click or a click outside closes
do
local rawLocItem=WarLocationItem
WarLocationItem=function(y,x,item,event,...)
if type(War)=="table" and event then
War.koItemSpots=War.koItemSpots or {}
War.koItemSpots[event]={x=x+1,y=y+1}
end
return rawLocItem(y,x,item,event,...)
end
end
-- the hidden tool spots written in kdef.lua for this event (uncommented WarLocationItem(y,x,tool,flag) lines of its
-- [id]=function block), read once per event, so they show before the event script has run in this session.
-- t.intro = the block shows the battle target (the battle's opening event; its in-battle script is the next event)
function koKdefSpots(eid)
CC.koKdefSpots=CC.koKdefSpots or {}
if CC.koKdefSpots[eid] then return CC.koKdefSpots[eid] end
local t={}
local h=io.open(CONFIG.ScriptPath..((rawget(_G,"koCamp") and koCamp.storyFile) or "kdef.lua"),"rb")
if h then
local cur=nil
for line in h:lines() do
local n=line:match("^%s*%[(%d+)%]=function")
if n then cur=tonumber(n) end
if cur==eid and line:match("^%s*WarShowTarget%(") then t.intro=true end
if cur==eid then
local y,x,it,ev=line:match("^%s*WarLocationItem%((%d+),(%d+),(%d+),(%d+)%)")
if y then t[#t+1]={x=tonumber(x)+1,y=tonumber(y)+1,ev=tonumber(ev)} end
end
end
h:close()
end
CC.koKdefSpots[eid]=t
return t
end
function koBigMap()
if JY.Status~=GAME_WMAP or not War.Width then return end
local W,D=War.Width,War.Depth
local s=math.max(4,math.min(16,math.floor((CC.ScreenW-80)/W),math.floor((CC.ScreenH-140)/D)))
local big=fileexist((CONFIG.koCampData or CONFIG.DataPath).."mbig.grp")
local pct=big and math.floor(s*100/16) or s*25
local key=(big and "b" or "m")..pct
if CC.koBigPic~=key then-- open the picture file again only when the scale changes
if big then lib.PicLoadFile((CONFIG.koCampData or CONFIG.DataPath).."mbig.idx",(CONFIG.koCampData or CONFIG.DataPath).."mbig.grp",12,pct)
else lib.PicLoadFile((CONFIG.koCampData or CONFIG.DataPath).."mmini.idx",(CONFIG.koCampData or CONFIG.DataPath).."mmini.grp",12,pct) end
CC.koBigPic=key
end
local pic=(rawget(_G,"koNightPic") and (big and koNightPic(War.MapID) or koNightMini(War.MapID))) or (big and War.MapID or (100+War.MapID))
local mw,mh=W*s,D*s
local X=math.floor((CC.ScreenW-mw)/2)
local Y=math.floor((CC.ScreenH-mh)/2)
local NAME="\208\213\195\251"
local title="\130\066\133\114 \130\067\129\068"-- 전체 지도
local hint="\134\117\135\077 \135\069\131\109\132\083 \129\071\130\108  /  Esc: \131\118\129\094\131\071"-- 누른 곳으로 이동 / Esc: 나가기
local LREC="\130\125\130\068 \130\067\136\069"-- 회복 지형
local LITEM="\133\126\132\125\129\103 \129\068\130\119"-- 숨겨진 도구
local GREEN=RGB(90,230,90)
local spots={}
local seen={}
local ks=koKdefSpots(JY.EventID or 0)
if #ks==0 and ks.intro then ks=koKdefSpots((JY.EventID or 0)+1) end-- a battle saved on its opening event: its script is the next one
for _,p in ipairs(ks) do
if not GetFlag(p.ev) then spots[#spots+1]=p seen[p.ev]=true end
end
for ev,p in pairs(War.koItemSpots or {}) do
if not seen[ev] and not GetFlag(ev) then spots[#spots+1]=p end
end
local function itemAt(cx,cy)
for _,p in ipairs(spots) do if p.x==cx and p.y==cy then return true end end
return false
end
local function cellAt(mx,my)
if mx<X or my<Y or mx>=X+mw or my>=Y+mh then return nil end
return math.floor((mx-X)/s)+1,math.floor((my-Y)/s)+1
end
local function tip(cx,cy,str,c)
local tx=math.min(X+cx*s+4,CC.ScreenW-#str*8-12)
local ty=math.max(Y+(cy-1)*s-22,0)
lib.FillColor(tx,ty,tx+#str*8+8,ty+20,RGB(24,20,16))
lib.DrawRect(tx,ty,tx+#str*8+8,ty+20,M_Gray)
DrawString(tx+4,ty+2,str,c,16)
end
local function draw()
DrawWarMap()
lib.Background(0,0,CC.ScreenW,CC.ScreenH,128,M_Black)
-- the frame is at least as wide as the title and the hint together (a small map would crowd them)
local fw=math.max(mw,#title*8+#hint*8+24)
local fx=X+math.floor((mw-fw)/2)
lib.FillColor(fx-10,Y-36,fx+fw+10,Y+mh+34,RGB(18,18,26))
lib.DrawRect(fx-10,Y-36,fx+fw+10,Y+mh+34,M_Gray)
DrawString(fx,Y-28,title,M_Yellow,16)
DrawString(fx+fw-#hint*8,Y-28,hint,M_Gray,16)
lib.PicLoadCache(12,pic*2,X,Y,1)
-- 회복 지형: a green frame around the cell
for i=1,W do
for j=1,D do
local dx=GetWarMap(i,j,1)
if dx==8 or dx==13 or dx==14 then
local x,y=X+(i-1)*s,Y+(j-1)*s
lib.DrawRect(x+1,y+1,x+s-2,y+s-2,GREEN)
lib.DrawRect(x+2,y+2,x+s-3,y+s-3,GREEN)
end
end
end
-- hidden tools
for _,p in ipairs(spots) do
local x,y=X+(p.x-1)*s,Y+(p.y-1)*s
lib.FillColor(x+1,y+1,x+s-1,y+s-1,RGB(60,45,10))
lib.DrawRect(x+1,y+1,x+s-2,y+s-2,M_Yellow)
if s>=12 then DrawString(x+math.floor((s-8)/2),y+math.floor((s-16)/2),"?",M_Yellow,16) end
end
-- units
local m=(s>=12) and 3 or 1
for i=1,War.PersonNum do
local v=War.Person[i]
if v and v.live and not v.hide then
local c=RGB(40,90,255)
if v.enemy then c=RGB(230,40,40) elseif v.friend then c=RGB(255,140,20) elseif not v.active then c=RGB(205,205,205) end
local x,y=X+(v.x-1)*s,Y+(v.y-1)*s
lib.FillColor(x+m,y+m,x+s-m,y+s-m,c)
lib.DrawRect(x+m,y+m,x+s-m-1,y+s-m-1,M_Black)
end
end
-- legend under the map
local ly=Y+mh+10
lib.DrawRect(fx,ly+3,fx+11,ly+14,GREEN)
DrawString(fx+18,ly,LREC,GREEN,16)
local lx=fx+18+#LREC*8+24
lib.FillColor(lx,ly+2,lx+14,ly+16,RGB(60,45,10)) lib.DrawRect(lx,ly+2,lx+14,ly+16,M_Yellow)
DrawString(lx+4,ly,"?",M_Yellow,16)
DrawString(lx+22,ly,LITEM,M_Yellow,16)
-- pointer
local cx,cy=cellAt(MOUSE.x or -1,MOUSE.y or -1)
if cx then
lib.DrawRect(X+(cx-1)*s,Y+(cy-1)*s,X+cx*s-1,Y+cy*s-1,M_White)
local id=GetWarMap(cx,cy,2)
local v=id>0 and War.Person[id]
if v and v.live and not v.hide then
tip(cx,cy,JY.Person[v.id][NAME],v.enemy and RGB(255,150,135) or (v.friend and RGB(255,200,120) or RGB(130,180,255)))
elseif itemAt(cx,cy) then
tip(cx,cy,LITEM,M_Yellow)
else
local dx=GetWarMap(cx,cy,1)
local nm=War.DX and War.DX[dx]
if nm then tip(cx,cy,nm,(dx==8 or dx==13 or dx==14) and GREEN or M_White) end
end
end
end
PlayWavE(0)
while true do
JY.ReFreshTime=lib.GetTime()
draw()
ReFresh(0.4)
local e,k=getkey()
if MOUSE.EXIT() then
if koExit then koExit() else koExitAsk() end
end
if (e==3 and k==3) or (e==1 and k==27) then PlayWavE(1) break end
if MOUSE.CLICK(X,Y,X+mw-1,Y+mh-1) then
local cx,cy=cellAt(MOUSE.rx or MOUSE.x,MOUSE.ry or MOUSE.y)
if cx then
War.CX=limitX(cx-math.floor(War.MW/2),1,math.max(1,War.Width-War.MW+1))
War.CY=limitX(cy-math.floor(War.MD/2),1,math.max(1,War.Depth-War.MD+1))
end
PlayWavE(0)
break
elseif MOUSE.CLICK() then
PlayWavE(1)
break
end
end
koMouseReset()
end
