--ko ‚}„y „Tt
local koNG={}
koNG.ready=function()
if JY.Data_Base==nil or JY.Data_Person==nil then
return false
end
return true
end
koNG.cycle=function()
if not koNG.ready() then
return 1
end
if not CC.Enhancement then
return 1
end
local n=JY.Base["ÎŞÓÃ2"]
if n==nil or n<1 then
return 1
end
if n>20 then
return 20
end
return n
end
koNG.rcycle=function()--ko 5.0 (10-13, endless cycles): the real cycle number; koNG.cycle above stays the strength one (at most 20)
if not koNG.ready() or not CC.Enhancement then return 1 end
local n=JY.Base["ÎŞÓÃ2"]
if n==nil or n<1 then return 1 end
return n
end
koNG.cap=function()--ko 3.2: 100..145 up to cycle 10, then +10 a cycle to 200 (cycle 16)
local n=koNG.cycle()
local c=100+5*(n-1)
if n>=11 then c=150+10*(n-11) end
if c>200 then
c=200
end
return c
end
koNG.diff=function()
if not koNG.ready() then
return 0
end
if JY.Person[1]["ÃØ¼¼1"]==0 then
return 0
end
return JY.Person[1]["·ÜÕ½"]
end
koNG.maxdiff=function()--koDiff10 5.0 (10-13): all ten challenge levels from the first cycle (was 5, 10 from cycle 11)
return 10
end
koNG.ebonus=function(wid)--ko 5.0 (10-13): the enemy stat bonus is the diff addon's rules now (total, extra intelligence); the old 6~10 cap formula is gone
if not CC.Enhancement then return 0,0 end
local f=rawget(_G,"koDiffStatBonus")
if f then return f(wid) end
return 0,0
end
koNG.mark=function()
if not koNG.ready() then
return
end
local d=koNG.diff()+1
local m=JY.Base["ÎŞÓÃ3"]
if m==nil or m<1 or d<m then
JY.Base["ÎŞÓÃ3"]=d
end
end
koNG.warnLower=function(newd)--ko 4.0: lowering the difficulty below ë„ì „ 3 / 5 for the first time this cycle locks ë„êµ¬ ì¥ë¹„ / ê¸ˆ for the next cycle; ask first
if not CC.Enhancement or newd>=koNG.diff() then return true end
local m=JY.Base["\206\222\211\195\051"]
local cap=math.min((m~=nil and m>=1) and m-1 or 99,koNG.diff())--ko the record so far, or the level already set (not fought yet)
local what
if newd<3 and cap>=5 then what="\131\097\130\080\135\122 \131\103\129\083"
elseif newd<3 and cap>=3 then what="\131\097\130\080\130\104"
elseif newd<5 and cap>=5 then what=nil
else return true end
local s=what and ("\129\077\130\077 \130\125\132\121\129\102 \129\068\130\119 "..what) or "\129\077\130\077 \130\125\132\121\129\102 \131\103 \133\089\133\065\129\083"
return WarDrawStrBoxYesNo("\129\071 \130\113\129\071\129\068\132\083 \130\066\132\101\130\104 \129\097\129\065*"..s.."*\131\065\131\096\133\072\130\067 \136\102\129\087\129\076\129\077.*\131\085\131\086\134\121\129\075\129\076\129\089?",M_White,true)
end
koNG.label=function()
local c=koNG.rcycle()
if c>1 then
return c.."‚}„y "..koNG.modestr()
end
return koNG.modestr()
end
koNG.modestr=function()
if JY.Person[1]["ÃØ¼¼1"]==0 then
return "ƒs„w ‚Z…w"
end
return "D‚B "..JY.Person[1]["·ÜÕ½"]
end
koNG.cyclestr=function()
local c=koNG.rcycle()
if c<2 then
return ""
end
return c.."‚}„y"
end
koNG.selall=function() return {stat=true,skill=true,hire=1,wskill=true,item=true,gold=true} end--ko 3.1: everything carried (hire: 1 ìˆ ì§‘ í•´ê¸ˆ / 0; the "ë¶€í•˜ë¡œ ê³„ìŠ¹" choice is gone)
koNG.carried=function(i)--ko 4.0: a tavern record carried in from the last cycle (these flags are set only by koNG.reset), hired or not
if i>=511 and i<=530 then return JY.Person[i]["\205\183\207\241\180\250\186\197"]>0 and JY.Person[i]["\208\194\205\183\207\241\180\250\186\197"]==0 end--koNewGenCarry 5.0 (10-12): user generals 511~530 carry by the record itself
local e=(i>=421 and i<=510 and 1870+i-420) or ((i==407 or i==408) and 1969+i-407) or (i==409 and 1973) or koExtraEv[i]
return e~=nil and (JY.Base["\202\194\188\254"..e] or 0)>0
end
koNG.reset=function(sel)
sel=sel or koNG.selall()
local n=koNG.rcycle()+1--ko 5.0 (10-13): no cap at 20 any more
local tier=(JY.Base["ÎŞÓÃ3"] or 0)-1
if tier<0 then
tier=0
end
local keepitem=(tier>=3) and sel.item
local keepgold=(tier>=5) and sel.gold
local mode=JY.Base["ÓÎÏ·Ä£Ê½"]
local mj=JY.Person[1]["ÃØ¼¼1"]
local fz=JY.Person[1]["·ÜÕ½"]
local trainer=JY.Base["ÎŞÓÃ1"]
local sortie=JY.Base["ÎŞÓÃ4"] or 0
local kocost=JY.Base["ÎŞÓÃ5"] or 0 --ko cost level carries over to the next cycle
local llk=JY.Base["ÊÂ¼ş333"]
local kowin=JY.Base["ÊÂ¼ş1999"] or 0
local komk=JY.Base["ÊÂ¼ş1998"] or 0
local gold=koGold()
local S={}
local i,k,key,v
for i=1,JY.PersonNum-1 do
local t={}
t.wl=JY.Person[i]["ÎäÁ¦"]
t.zl=JY.Person[i]["ÖÇÁ¦"]
t.ts=JY.Person[i]["Í³ÂÊ"]
t.we=JY.Person[i]["ÎäÁ¦¾­Ñé"]
t.ze=JY.Person[i]["ÖÇÁ¦¾­Ñé"]
t.te=JY.Person[i]["Í³ÂÊ¾­Ñé"]
t.tf=JY.Person[i]["Ìì¸³"]
t.sk={}
for k=1,6 do
t.sk[k]=JY.Person[i]["ÌØ¼¼"..k]
end
if keepitem then
t.it={}
for k=1,8 do
t.it[k]=JY.Person[i]["µÀ¾ß"..k]
end
end
if ((i>=421 and i<=601) or i==407 or i==408 or i==409 or koExtraEv[i]~=nil or i==385 or i==386 or i==388 or i==403 or i==404 or i==405) and (JY.Person[i]["¾ıÖ÷"]==1 or koNG.carried(i)) and JY.Person[i]["Í·Ïñ´úºÅ"]>0 then --ko 407/408 (Liu Bang, Xiang Yu) are carried over like tavern mercenaries
t.hire={}
for key,v in pairs(CC.Person_S) do
t.hire[key]=JY.Person[i][key]
end
if not keepitem then--ko 4.0: tavern mercenaries lose their gear too unless item carry-over is on
t.hire["ÎäÆ÷"]=nil t.hire["·À¾ß"]=nil t.hire["¸¨Öú"]=nil
for k=1,8 do t.hire["µÀ¾ß"..k]=nil end
end
end
S[i]=t
end
local IT={}
for i=1,JY.ItemNum-1 do
IT[i]=JY.Item[i]["ÌØ¼¼"]
end
koHook("cycle_close",koNG.rcycle())--ko 3.1
local REC={}
for _,koR in ipairs(koAddon.carry) do for i=koR.from,koR.to do REC[i]=JY.Base["ÊÂ¼ş"..i] end end--ko 3.1: registered äº‹ä»¶ ranges
LoadRecord(0)
JY.Base["ÓÎÏ·Ä£Ê½"]=mode
if not SaveRecord(11) then return false end
LoadRecord(11)
os.remove(CC.R_GRPFilename[11])
for _,koR in ipairs(koAddon.carry) do for i=koR.from,koR.to do JY.Base["ÊÂ¼ş"..i]=REC[i] end end--ko 3.1
if sel.wskill then
for i=1,JY.ItemNum-1 do
JY.Item[i]["ÌØ¼¼"]=IT[i]
end
end
local hire=0
for i=1,JY.PersonNum-1 do
local t=S[i]
if t~=nil then
if t.hire~=nil and sel.hire~=0 and sel.hire~=false then
for key,v in pairs(t.hire) do
JY.Person[i][key]=v
end
JY.Person[i]["µÈ¼¶"]=1
JY.Person[i]["¾­Ñé"]=0
JY.Person[i]["ĞŞÁ¶"]=0
if sel.hire==1 then--ko 3.0: ìˆ ì§‘ì— í•´ê¸ˆë§Œ
JY.Person[i]["¾ıÖ÷"]=0
if i>=511 and i<=530 then JY.Person[i]["\208\194\205\183\207\241\180\250\186\197"]=0 elseif i>=421 and i<=510 then JY.Person[i]["ĞÂÍ·Ïñ´úºÅ"]=0 JY.Base["ÊÂ¼ş"..(1870+i-420)]=1 elseif i==407 or i==408 or i==409 then JY.Base["ÊÂ¼ş"..(i==409 and 1973 or 1969+i-407)]=1 elseif koExtraEv[i] then JY.Base["ÊÂ¼ş"..koExtraEv[i]]=1 end
else
hire=hire+1
end
end
if sel.stat then
JY.Person[i]["ÎäÁ¦"]=t.wl
JY.Person[i]["ÖÇÁ¦"]=t.zl
JY.Person[i]["Í³ÂÊ"]=t.ts
JY.Person[i]["ÎäÁ¦¾­Ñé"]=t.we
JY.Person[i]["ÖÇÁ¦¾­Ñé"]=t.ze
JY.Person[i]["Í³ÂÊ¾­Ñé"]=t.te
end
if sel.skill then
JY.Person[i]["Ìì¸³"]=t.tf
for k=1,6 do
JY.Person[i]["ÌØ¼¼"..k]=t.sk[k]
end
end
if t.it~=nil then
for k=1,8 do
JY.Person[i]["µÀ¾ß"..k]=t.it[k]
end
end
end
end
JY.Base["ÎŞÓÃ2"]=n
JY.Base["ÎŞÓÃ3"]=0
JY.Base["ÎŞÓÃ1"]=trainer
JY.Base["ÎŞÓÃ4"]=sortie
JY.Base["ÎŞÓÃ5"]=kocost
JY.Base["ÊÂ¼ş333"]=llk
JY.Base["ÊÂ¼ş1999"]=kowin
JY.Base["ÊÂ¼ş1998"]=komk
JY.Base["Îä½«ÊıÁ¿"]=JY.Base["Îä½«ÊıÁ¿"]+hire
if fz>koNG.maxdiff() then
fz=koNG.maxdiff()
end
if fz<1 then
fz=1
end
JY.Person[1]["ÃØ¼¼1"]=mj
JY.Person[1]["·ÜÕ½"]=fz
if keepgold then
local g=math.modf(gold/2)
koSetGold(g)--ko 3.0
end
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==1 then
ReSetAttrib(i,true)
end
GetPic(i)
end
JY.Base["ÕÂ½ÚÃû"]=""

JY.EventID=1
JY.Status=GAME_SMAP_AUTO
return true
end
koNG.offer=function()
local n=koNG.rcycle()
koNG.keepClear(n)--ko 5.0 (koNGPlus): keep this clear for ìƒˆ ê²Œì„+
local sel=nil--ko 3.0: íšŒì°¨ ê³„ìŠ¹ ì„ íƒ
if WarDrawStrBoxYesNo(n.."‚}„y‚h …X‡RKLM. M‚M ‚}„y‚h G‚SƒW a‚V†yKLY?",M_White,true) then--ko 3.1: an addon may show the per-item choice
if koAddon.hooks.cycle_choose then sel=koHook("cycle_choose") else sel=koNG.selall() end
end
if sel==nil then
JY.Base["ÕÂ½ÚÃû"]=n.."‚}„y TU"
DrawStrBoxCenter("…@GŒG„S ‰Bn†hLM. …@GŒGƒP ¡¸†D QR+¡¹„S ˆAdˆe M‚M ‚}„y‚h G‚S‡y q „OKLM.")
RemindSave()
JY.Status=GAME_START
return
end
if koNG.reset(sel)==false then JY.Status=GAME_START return end
DrawStrBoxCenter(koNG.rcycle().."‚}„y ‚VJ. ƒMƒ}„Q Co "..koNG.cap()..", …Vƒb „@S G‚S…HƒtKLM.")
JY.Base["ÕÂ½ÚÃû"]=koNG.rcycle().."‚}„y ‚VJ"
RemindSave(2)
end

--ko 5.0 (koNGPlus): ìƒˆ ê²Œì„+ on the title. The latest ì¢…íš¡ clear is kept in slot 18 (data/save/clear.sav, saved by koNG.offer at the
--ending; a higher or the same cycle replaces it, CC.koClearCycle remembers which). The title shows ìƒˆ ê²Œì„+ only when there is
--a clear: clear.sav, or a "N\130\125\132\121 \129\084\129\085" / "N\130\125\132\121 \134\108\130\075" save in slots 1..10 (clears made before this). Picking it starts cycle
--N+1 from the highest one (20 stays 20) through the same steps as the ending's offer: ë¬¼ë ¤ë°›ì„ í•­ëª© ì°½ -> koNG.reset -> ì„œì¥.
koNG.keepClear=function(n)
if (tonumber(CC.koClearCycle) or 0)>n and fileexist(CC.R_GRPFilename[18]) then return end
local K="\213\194\189\218\195\251"--JY.Base field: the section name shown in the save list
local old=JY.Base[K]
JY.Base[K]=n.."\130\125\132\121 \129\084\129\085"
SaveRecord(18)
JY.Base[K]=old
CC.koClearCycle=n
koSave()
end
--the clear ìƒˆ ê²Œì„+ would start from: slot id and its cycle, or nil when there is none
koNG.cycOf=function(s,tag)--the number just before tag (a plain find: hz bytes can look like pattern magic)
local i=string.find(s,tag,1,true)
if not i then return nil end
return tonumber(string.match(string.sub(s,1,i-1),"(%d+)$"))
end
koNG.plusSource=function()
local best,bn=nil,0
if fileexist(CC.R_GRPFilename[18]) then
local n=tonumber(CC.koClearCycle) or 0
if n<1 then n=koNG.cycOf(GetRecordInfo(18),"\130\125\132\121") or 1 end
best,bn=18,n
end
for id=1,10 do
if fileexist(CC.R_GRPFilename[id]) then
local s=GetRecordInfo(id)
local n=koNG.cycOf(s,"\130\125\132\121 \129\084\129\085") or koNG.cycOf(s,"\130\125\132\121 \134\108\130\075")
if n and n>bn then best,bn=id,n end
end
end
return best,bn
end
koNG.plus=function(id,n)
if not id then return end
local nx=n+1--ko 5.0 (10-13): endless
local q=(n.."\130\125\132\121 \134\070\129\117\130\083 \131\071\133\108\131\109\132\083 "..nx.."\130\125\132\121\130\104 \130\086\129\074\129\087\129\076\129\077. \132\084\133\123\129\088\129\089\129\090?")
if not WarDrawStrBoxYesNo(q,M_White,true) then return end
if not koSaveCompat(id) then return end
LoadRecord(id)
local sel=nil
if koAddon.hooks.cycle_choose then sel=koHook("cycle_choose") else sel=koNG.selall() end
if sel==nil then JY.Status=GAME_START return end
if koNG.reset(sel)==false then JY.Status=GAME_START return end
DrawStrBoxCenter(koNG.rcycle().."\130\125\132\121 \130\086\129\074. \131\077\131\125\132\081 \129\067\129\111 "..koNG.cap()..", \133\086\131\098 \132\064\129\083 \129\071\130\083\133\072\131\116\129\075\129\076\129\077.")
JY.Base["\213\194\189\218\195\251"]=koNG.rcycle().."\130\125\132\121 \130\086\129\074"
RemindSave(2)
end
function koAnimD(n)
return math.max(1,math.floor(n/(CC.koAnim or 1)))
end
function koAutoMs(n)
if War.koSkip then return 1 end--ko 3.1: enemy phase being skipped: their lines fly by
local a=CC.koAuto or 0
if a==1 then return 2000+n*80 elseif a==2 then return 1200+n*50 elseif a==3 then return 600+n*25 elseif a==4 then return 300+n*12 end--ko 5.2.5 (10-20): very fast
return -1
end
function koMouseReset()
if not CONFIG.Windows then--android: GetMouse() would eat a touch event; the mask logic is only for Windows
if MOUSE.status=='CLICK' then MOUSE.status='IDLE' end
MOUSE.koSwallow=nil MOUSE.koSwallowR=nil MOUSE.koRel=nil MOUSE.koSynR=nil
return
end
local koM=lib.GetMouse()
if MOUSE.status=='CLICK' or (MOUSE.status=='HOLD' and koM==0) then MOUSE.status='IDLE' end
MOUSE.koMask=koM MOUSE.koRel=nil MOUSE.koSynR=nil
if koM%2==0 then MOUSE.koSwallow=nil end
if math.floor(koM/4)%2==0 then MOUSE.koSwallowR=nil end
end
function koEdgeDir(mx,my)--ko: which scrollable border of the war map cell (mx,my) is on; -1/0/1 per axis
local dx,dy=0,0
if mx==0 and War.CX>1 then dx=-1 elseif mx==War.MW-1 and War.CX<War.Width-War.MW+1 then dx=1 end
if my==0 and War.CY>1 then dy=-1 elseif my==War.MD-1 and War.CY<War.Depth-War.MD+1 then dy=1 end
return dx,dy
end
function koEdgeScroll(px,py)--ko: holding the mouse on the map border scrolls one cell per frame; corners move both axes
if koTouch() then return false end--ko 5.0 touch: the phone drags the map instead (koMapDrag)
if koOverUI(MOUSE.hx,MOUSE.hy) then return false end--ko 3.0
if not MOUSE.HOLD(War.OX,War.OY,War.OX+War.BoxWidth*War.MW-1,War.OY+War.BoxDepth*War.MD-1) then return false end
local dx,dy=koEdgeDir(math.modf((px-War.OX)/War.BoxWidth),math.modf((py-War.OY)/War.BoxDepth))
local hx,hy=koEdgeDir(math.modf((MOUSE.hx-War.OX)/War.BoxWidth),math.modf((MOUSE.hy-War.OY)/War.BoxDepth))
if (dx==0 and dy==0) or (hx==0 and hy==0) then return false end
War.CX=War.CX+dx War.MX=War.MX+dx
War.CY=War.CY+dy War.MY=War.MY+dy
MOUSE.enableclick=false
return true
end
-- ko 5.0 touch: a finger pressed on the map and moved 20 px or more drags the view (the map follows the finger,
-- one cell per cell width); the lift that ends a drag is not a tap. Phone only (koTouch).
function koMapDrag(x,y)
if not koTouch() or MOUSE.status~='HOLD' then War.koDrag=nil return false end
local D=War.koDrag
if not D or D.hx~=MOUSE.hx or D.hy~=MOUSE.hy then
D={hx=MOUSE.hx,hy=MOUSE.hy}
if koOverUI(MOUSE.hx,MOUSE.hy) or not (between(MOUSE.hx,War.OX,War.OX+War.BoxWidth*War.MW-1) and between(MOUSE.hy,War.OY,War.OY+War.BoxDepth*War.MD-1)) then D.off=true end
War.koDrag=D
end
if D.off then return false end
if not D.on then
if math.abs(x-D.hx)<20 and math.abs(y-D.hy)<20 then return false end
D.on=true D.ax,D.ay=x,y D.cx,D.cy=War.CX,War.CY
MOUSE.koHoldT=nil-- no long press after a drag
War.CurID=0
end
local cx=limitX(D.cx-math.modf((x-D.ax)/War.BoxWidth),1,math.max(1,War.Width-War.MW+1))
local cy=limitX(D.cy-math.modf((y-D.ay)/War.BoxDepth),1,math.max(1,War.Depth-War.MD+1))
War.MX=War.MX+cx-War.CX War.MY=War.MY+cy-War.CY
War.CX,War.CY=cx,cy
MOUSE.enableclick=false
return true
end
function koPollKey()
local t0=JY.ReFreshTime or 0
local now=lib.GetTime()
if now-t0>CC.FrameNum*2 or now<t0 then t0=now end
while true do
local s0=MOUSE.status
local e,k,x,y=getkey()
if MOUSE.status~=s0 or e==0 or e==1 or e==3 then return e,k,x,y end
now=lib.GetTime()
if now-t0>=CC.FrameNum then return e,k,x,y end
lib.Delay(math.min(8,CC.FrameNum-(now-t0)))
end
end
-- ko 3.0: battle screen layout. CC.koWide=1 -> the map fills the window (16x10 cells at 0,0) and the frame is
-- replaced by floating panels; 0 -> the classic frame (12x9 cells at 16,32). War.OX/OY is the map origin.
function koWarLayout()
if (CC.koWide or 0)>=1 then War.OX=0 War.OY=0 War.MW=math.floor(CC.ScreenW/(War.BoxWidth or 48)) War.MD=math.floor(CC.ScreenH/(War.BoxDepth or 48)) else War.OX=16 War.OY=32 War.MW=math.floor((CC.ScreenW-192)/48) War.MD=math.floor((CC.ScreenH-48)/48) end
if War.Width and War.Width>0 then
War.CX=limitX(War.CX or 1,1,math.max(1,War.Width-War.MW+1))
War.CY=limitX(War.CY or 1,1,math.max(1,War.Depth-War.MD+1))
end
end
-- ko 11-06: frame layout size for the current map: 48 px cells, window ratio fixed at 768:528, only the cell count changes
function koFrameSize()
if not CONFIG.Windows then return 768,528 end--android: keep the 12x10 frame, big windows make the text too small
if (CC.koFrameFit or 0)~=1 then return 768,528 end--ko 11-06: the basic frame; koFrameFit=1 follows the map
local f=({[0]=1,1.5,2,3})[CC.koScale or 0] or 1
local ww,wh=CC.koWorkW or 1904,CC.koWorkH or 1000
if (CC.koScale or 0)==4 then f=1.5 ww,wh=CC.koScreenFullW or 1920,CC.koScreenFullH or 1080 end
local rows=math.max(10,math.min(War.Depth or 10,math.floor((wh/f-48)/48)))
local h=rows*48+48
local cols=math.floor((h*768/528-192)/48+0.5)
cols=math.max(12,math.min(cols,War.Width or cols,math.floor((ww/f-192)/48)))
return cols*48+192,h
end
function koFramePX() return CC.ScreenW-768 end
-- ko 11-06: the frame picture in pieces. The top bar grows in its two knot bands (the name box stays centred), the bottom bar in one band,
-- the side columns in rows 314..346
function koFrameDraw()
local dW,dH=CC.ScreenW-768,CC.ScreenH-480
local eL=math.floor(dW/2)
local eR=dW-eL
local function P(sx1,sy1,sx2,sy2,dx,dy)
lib.SetClip(dx,dy,dx+sx2-sx1,dy+sy2-sy1)
lib.PicLoadCache(4,205*2,dx-sx1,dy-sy1,1)
end
local function HT(sx1,sx2,sy1,sy2,dx,dy,w)
local n=sx2-sx1
while w>0 do local c=math.min(n,w) P(sx1,sy1,sx1+c,sy2,dx,dy) dx=dx+c w=w-c end
end
local function VT(sx1,sx2,sy1,sy2,dx,dy,h)
local n=sy2-sy1
while h>0 do local c=math.min(n,h) P(sx1,sy1,sx2,sy1+c,dx,dy) dy=dy+c h=h-c end
end
P(0,0,88,32,0,0) HT(88,144,0,32,88,0,56+eL)
P(144,0,586,32,144+eL,0) HT(586,626,0,32,586+eL,0,40+eR)
P(626,0,768,32,626+dW,0)
local by=464+dH
P(0,464,429,480,0,by) HT(429,473,464,480,429,by,44+dW) P(473,464,768,480,473+dW,by)
P(0,32,16,314,0,32) VT(0,16,314,346,0,314,32+dH) P(0,346,16,464,0,346+dH)
P(592,32,768,314,592+dW,32) VT(592,768,314,346,592+dW,314,32+dH) P(592,346,768,464,592+dW,346+dH)
lib.SetClip(0,0,0,0)
end
function koWide()
return (CC.koWide or 0)>=1
end
-- ko 3.0: "ë„“ê²Œ" = the wide layout on a 1152x720 base while a battle runs (24x15 cells). The window is
-- rebuilt at that size on entering the battle and back to 768x480 when it ends; every other screen keeps 768x480.
-- ko 3.0: "ë„“ê²Œ" base size for the current map: as many cells as fit on the screen at the chosen scale
-- (the scale the player picked is kept; the view grows to fill the screen). Caps: 24 across; 15 down, or 18
-- for narrow maps (20 or less across), or the whole map when it is 16 deep or less. Never less than 16x10.
-- Screen size comes from ko_screen.lua (written by ko_sdl.dll: work area minus window frame); 1080p if missing.
function koWarSize()
local f=({[0]=1,1.5,2,3})[CC.koScale or 0] or 1
local ww,wh=CC.koWorkW or 1904,CC.koWorkH or 1000
if (CC.koScale or 0)==4 then f=1.5 ww,wh=CC.koScreenFullW or 1920,CC.koScreenFullH or 1080 end
local fitw=math.floor(ww/(48*f))
local fith=math.floor(wh/(48*f))
local mw=math.min(War.Width or 24,24,fitw)
local cap=15
if (War.Width or 24)<=20 then cap=18 end
if (War.Depth or 24)<=16 then cap=16 end--a 16-deep map shows whole
local md=math.min(War.Depth or cap,cap,fith)
return math.max(768,mw*48),math.max(480,md*48)
end
function koWarRes(on)--koFrameBack 5.1 (10-13): the layout follows CC.koWide again
if CC.koWide==1 then CC.koWide=2 end--koFrameTwo 5.1: ã€Œì „ë©´ã€ is gone, an old saved 1 means ë„“ê²Œ
local w,h=768,480
if on then if (CC.koWide or 0)==2 then w,h=koWarSize() else w,h=koFrameSize() end end
if CC.ScreenW==w and CC.ScreenH==h then return end
CC.ScreenW,CC.ScreenH=w,h
Config()
PicCatchIni()
if War and War.BoxWidth then koWarLayout() end
end
function koSetWide(v)
CC.koWide=v--ko 5.1 (10-13): the battle screen row is back
koSave()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then koWarRes(true) koWarLayout() end
end
-- run fn with every drawing call shifted by (dx,dy). Used to move the status panel (drawn with fixed
-- coordinates) to the other side of the screen in the wide layout.
function koDrawShift(dx,dy,fn)
if dx==0 and dy==0 then return fn() end
local P,F,C,B,R,L,S=lib.PicLoadCache,lib.FillColor,lib.SetClip,lib.Background,lib.DrawRect,lib.LoadSur,lib.DrawStr
lib.PicLoadCache=function(g,i,x,y,...) return P(g,i,x+dx,y+dy,...) end
lib.FillColor=function(x1,y1,x2,y2,...) return F(x1+dx,y1+dy,x2+dx,y2+dy,...) end
lib.SetClip=function(x1,y1,x2,y2) if x1==nil or (x1==0 and y1==0 and x2==0 and y2==0) then return C(x1,y1,x2,y2) end return C(x1+dx,y1+dy,x2+dx,y2+dy) end
lib.Background=function(x1,y1,x2,y2,...) return B(x1+dx,y1+dy,x2+dx,y2+dy,...) end
lib.DrawRect=function(x1,y1,x2,y2,...) return R(x1+dx,y1+dy,x2+dx,y2+dy,...) end
lib.LoadSur=function(s,x,y,...) return L(s,x+dx,y+dy,...) end
lib.DrawStr=function(x,y,...) return S(x+dx,y+dy,...) end
local ok,err=pcall(fn)
lib.PicLoadCache,lib.FillColor,lib.SetClip,lib.Background,lib.DrawRect,lib.LoadSur,lib.DrawStr=P,F,C,B,R,L,S
if not ok then error(err,0) end
end
-- small translucent text button for the wide layout's top bar
-- ko 3.1: a registered wide-bar button under the mouse click runs and returns true
-- ko 3.6: registered bar button n spans x1..x2 (own width w, default 44; 6 px gaps from x=190). label may be a function
function koBarPos(n)
local x=190
for i=1,n-1 do x=x+(koAddon.barButtons[i].w or 44)+6 end
return x,x+(koAddon.barButtons[n].w or 44)
end
function koBarLabel(b)
if type(b.label)=="function" then return b.label() end
return b.label
end
-- ko 3.6: allies that can still act this turn (the same test the base uses to end the turn by itself)
function koIdleUnit(v)
return v and v.live and (not v.hide) and (not v.enemy) and (not v.friend) and v.active and (not v.troubled)
end
function koIdleCount()
local c=0
for i=1,War.PersonNum do if koIdleUnit(War.Person[i]) then c=c+1 end end
return c
end
-- centre the view on the next idle ally after the last one shown (Tab / the idle bar button); warp = move the pointer onto it
function koNextIdle(warp)
local n=War.PersonNum
local s=War.koIdleLast or War.LastID or 0
for j=1,n do
local i=(s+j-1)%n+1
local v=War.Person[i]
if koIdleUnit(v) then
War.koIdleLast=i
WarPersonCenter(i)
if warp and koWarpMouse then koWarpMouse(War.OX+War.BoxWidth*(v.x-War.CX)+War.BoxWidth/2,War.OY+War.BoxDepth*(v.y-War.CY)+War.BoxDepth/2) end
War.MX,War.MY=v.x,v.y
War.CurID=i
War.InMap=true
return true
end
end
return false
end

function koAddonBarClick()
for koI,koB in ipairs(koAddon.barButtons) do
if (not koB.show) or koB.show() then local koX1,koX2=koBarPos(koI) if MOUSE.CLICK(koX1,6,koX2,24) then if koB.run()~=false then PlayWavE(0) end return true end end
end
return false
end
function koBarButton(x1,y1,x2,y2,str)
-- hover: white border and yellow text; held down: a light fill (the same feel as the frame's ê¸°ëŠ¥ button)
local hot=MOUSE.x and between(MOUSE.x,x1,x2) and between(MOUSE.y,y1,y2)
lib.Background(x1,y1,x2,y2,160,M_Black)
if hot and MOUSE.status=='HOLD' then lib.Background(x1,y1,x2,y2,192,M_White) end
lib.DrawRect(x1,y1,x2,y2,hot and M_White or M_Gray)
DrawString(math.modf((x1+x2)/2-#str*4),y1+1,str,hot and M_Yellow or M_White,16)
end
-- which unit the status panel shows (same rule as DrawStatus); 0 = none
function koPanelID()
if koWide() then
-- wide layout: no status panel (the hover popup and right-click status window cover it)
return 0
end
if War.SelID>0 then return War.SelID elseif War.CurID>0 then return War.CurID elseif War.LastID>0 then return War.LastID end
return 0
end
-- ko 3.3: the wide layout's minimap hides (and clicks reach the map under it) while a move or a target is picked,
-- or all the time after M (CC.koMiniOff). The framed layout keeps it in the frame.
-- ko 3.6: minimap cell size: 2 px on the classic panel when 4 px would not fit its 160 px (map 59 has a 2 px picture)
koMiniSmall={[59]=158}
function koMiniS()
if koMiniSmall[War.MapID] and ((not koWide() and (War.Width*4>160 or War.Depth*4>120)) or (koWide() and (War.Width*4>CC.ScreenW*0.35 or War.Depth*4>CC.ScreenH*0.35))) then return 2 end--ko 3.6: tall maps too
return 4
end
function koMiniShown()
if not koWide() then return true end
if (CC.koMiniOff or 0)==1 then return false end
return War.ControlStatus~="move" and War.ControlStatus~="selectAtk"
end
-- ko 3.6: centre x of the battle name box on the wide top bar, pushed right past the registered bar buttons
function koWarNameCx()
local cx=math.floor(CC.ScreenW/2)-3
local nw=#(War.WarName or "")*4
local left=((#koAddon.barButtons>0) and select(2,koBarPos(#koAddon.barButtons)) or 184)+8
if cx-nw-10<left then cx=left+nw+10 end
return cx
end

-- ko 3.0: is (x,y) over one of the wide layout's floating panels? (top bar, status panel, minimap)
function koOverUI(x,y)
if not koWide() then return false end
local koCx=koWarNameCx()
if y<=26 and (x<=(#koAddon.barButtons>0 and select(2,koBarPos(#koAddon.barButtons))+6 or 190) or between(x,koCx-#War.WarName*4-10,koCx+#War.WarName*4+10)) then return true end
if y<=30 and x>=CC.ScreenW-34 then return true end
if koPanelID()>0 then
local px=War.koPX or 0
if between(x,600+px,768+px) and between(y,32,364) then return true end
end
if koMiniShown() and between(x,War.MiniMapCX-6,War.MiniMapCX+War.Width*koMiniS()+6) and between(y,War.MiniMapCY-6,War.MiniMapCY+War.Depth*koMiniS()+6) then return true end
return false
end
-- ko 3.6: pressing the minimap centres the view on that spot; keep holding and drag to move it (it keeps following
-- outside the minimap until the button is let go, and the release does not click the map)
function koMiniDrag(x,y)
if not koMiniShown() or MOUSE.status~='HOLD' then War.koMiniPress=nil return false end
local s=koMiniS()
local x1,y1=War.MiniMapCX,War.MiniMapCY
local x2,y2=x1+War.Width*s,y1+War.Depth*s
if not (between(MOUSE.hx,x1-6,x2+6) and between(MOUSE.hy,y1-6,y2+6)) then return false end
-- ko 3.6: held still for 0.6 s = the big map (koBigMap, hotkey addon); a new press starts a new timer
local P=War.koMiniPress
if not P then P={t=lib.GetTime(),hx=MOUSE.hx,hy=MOUSE.hy} War.koMiniPress=P end
if math.abs(x-P.hx)>4 or math.abs(y-P.hy)>4 then P.moved=true end
if not P.moved and not P.opened and lib.GetTime()-P.t>600 and rawget(_G,"koBigMap") then
P.opened=true
MOUSE.enableclick=false
koBigMap()
return true
end
x=limitX(x,x1,x2) y=limitX(y,y1,y2)
War.CX=limitX(math.modf((x-x1)/s-War.MW/2)+1,1,War.Width-War.MW+1)
War.CY=limitX(math.modf((y-y1)/s-War.MD/2)+1,1,War.Depth-War.MD+1)
MOUSE.enableclick=false
return true
end

-- ko 3.0: centre of the battle map area for a box of width w / height h (frame: koMapCenterX(w), koMapCenterY(h))
function koBoxChars()--ko 11-04: a text box stays inside the battle map frame (box width = 16 x chars + border + 30)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
return math.max(20,math.min(36,math.floor(((War.BoxWidth or 48)*(War.MW or 12)-30-2*CC.MenuBorderPixel)/16)))
end
return 36
end
function koMapCenterX(w)
return (War.OX or 16)+((War.BoxWidth or 48)*(War.MW or 12)-w)/2
end
function koMapCenterY(h)
return (War.OY or 32)+((War.BoxDepth or 48)*(War.MD or 9)-h)/2
end
-- ko 3.0: auto save when the player ends the turn (just before the enemy phase) into slot 7 (data\save\auto.sav)
function koAutoSaveOn()
return (CC.koAutoSave or 1)==1
end
function koAutoSave()
if not koAutoSaveOn() or koHook("autosave_block") then return end--ko 3.1
-- rotate: A2 -> A3, A1 -> A2, then write A1 (os.rename over an existing file fails on Windows, so remove first)
pcall(function()
os.remove(CC.R_GRPFilename[14])
if fileexist(CC.R_GRPFilename[13]) then os.rename(CC.R_GRPFilename[13],CC.R_GRPFilename[14]) end
if fileexist(CC.R_GRPFilename[12]) then os.rename(CC.R_GRPFilename[12],CC.R_GRPFilename[13]) end
end)
local ok,err=pcall(WarSave,12)
if not ok then lib.Debug("koAutoSave: "..tostring(err)) end
end
-- ko 3.0: gold up to 999,999. The save keeps it in three 16-bit fields: »Æ½ğ (0..65500) + ÎŞÓÃ6 (0..65500)
-- as before (so older saves read the same) + ÊÂ¼ş1996 x 65536 for what is above that
koGoldMax=999999
function koGold()
return (JY.Base["»Æ½ğ"] or 0)+(JY.Base["ÎŞÓÃ6"] or 0)+(JY.Base["ÊÂ¼ş1996"] or 0)*65536
end
function koSetGold(g)
g=limitX(math.floor(g),0,koGoldMax)
local hi=math.floor(g/65536)
local rem=g-hi*65536
JY.Base["ÊÂ¼ş1996"]=hi
JY.Base["»Æ½ğ"]=math.min(rem,65500)
JY.Base["ÎŞÓÃ6"]=rem-JY.Base["»Æ½ğ"]
end
koSharedKeys={}--ko 6.0 (11-01): records every story shares, kept in the shared ko_settings.lua (none now: newgen / genedit are per story, gesync owners.txt keeps the pictures apart)
function koSettingKeys()--ko 6.0 (11-03): the settings values are one set for every story (the menu moved to the main screen); records stay per story
local t={"FrameNum","koAnim","koAuto","koWide","koFrameFit"}
for _,r in ipairs(koAddon.settings) do if r.key then t[#t+1]=r.key end end
return t
end
function koSetLit(t,key,val)--replace CC.<key>=<string or number> in a ko_settings.lua text (the line is added when missing)
local lit=(type(val)=="string") and string.format("%q",val) or tostring(val)
local a,b=string.find(t,"CC%."..key.."=",1)
if not a then return t.."CC."..key.."="..lit.."\n" end
local i=b+1
if string.sub(t,i,i)=='"' then
local j=i+1
while j<=#t do local c=string.sub(t,j,j) if c=="\\" then j=j+2 elseif c=='"' then break else j=j+1 end end
return string.sub(t,1,b)..lit..string.sub(t,j+1)
end
local j=string.find(t,"\n",i,true) or (#t+1)
return string.sub(t,1,b)..lit..string.sub(t,j)
end
function koSettingsPath()--ko 6.0 campaigns: each story keeps its own ko_settings.lua (records keyed by person numbers) in its save folder
if CONFIG.koCamp then return CONFIG.Save.."ko_settings.lua" end
return CONFIG.CurrentPath.."ko_settings.lua"
end
function koSave()
local h=io.open(koSettingsPath(),"w")
if not h then return end
h:write('CC.koScale='..(CC.koScale or 0)..'\010CC.FrameNum='..CC.FrameNum..'\010CC.koAnim='..(CC.koAnim or 1)..'\010CC.koAuto='..(CC.koAuto or 0)..'\010CC.koWide='..(CC.koWide or 0)..'\010CC.koFrameFit='..(CC.koFrameFit or 0)..'\010'..koAddonSaveLines())--ko 3.1: the addon rows follow
h:close()
if CONFIG.koCamp then--ko 6.0 campaigns: ko_sdl.dll reads the window scale from the shared file
local r=io.open(CONFIG.CurrentPath.."ko_settings.lua","r")
local t=r and r:read("*a")
if r then r:close() end
if t then t=string.gsub(t,"CC%.koScale=%-?%d+","CC.koScale="..(CC.koScale or 0),1) for _,k in ipairs(koSharedKeys) do t=koSetLit(t,k,CC[k]) end for _,k in ipairs(koSettingKeys()) do if CC[k]~=nil then t=koSetLit(t,k,CC[k]) end end local w=io.open(CONFIG.CurrentPath.."ko_settings.lua","w") if w then w:write(t) w:close() end end--and the shared records
end
end
-- ko 3.0: the window scale (CC.koScale: 0 off, 1 = 1.5x, 2 = 2x, 4 = full screen) is applied by ko_sdl.dll
-- when the engine creates its window (it reads ko_settings.lua). So a change here just saves the value and
-- rebuilds the window through Config(), the same path the volume buttons use. Resizing the live window
-- instead would make the exe recompute its mouse mapping and clicks would land in the wrong place.
function koSetScale(v)
if not CONFIG.Windows then return end--android: no ko_sdl.dll, the phone scales the screen itself
CC.koScale=v
koSave()
local koInWar=(JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE)--ko 5.1 (10-21): the wide layout in a battle refits its cells to the new scale
if koInWar then if (CC.koWide or 0)==2 then CC.ScreenW,CC.ScreenH=koWarSize() else CC.ScreenW,CC.ScreenH=koFrameSize() end end
Config()
PicCatchIni()
if koInWar and War and War.BoxWidth then koWarLayout() end
end
function koExit()
os["exit"]()
end
function JY_Main()--Ö÷³ÌĞòÈë¿Ú
os.remove("debug.txt")--Çå³ıÒÔÇ°µÄdebugÊä³ö
xpcall(JY_Main_sub,myErrFun)--²¶»ñµ÷ÓÃ´íÎó
end

function JY_Main_sub()--ÕæÕıµÄÓÎÏ·Ö÷³ÌĞòÈë¿Ú
dofile(CONFIG.ScriptPath .. "jyconfig.lua") --¼ÓÔØÓÎÏ·ÉèÖÃÎÄ¼ş
dofile(CONFIG.ScriptPath .. "kdef.lua") --¼ÓÔØÓÎÏ·ÊÂ¼ş
pcall(dofile,CONFIG.ScriptPath .. "kocost.lua") --ko cost table
SetGlobalConst()
SetGlobal()
CC.koOffer=koNG.offer
CC.koNG=koNG
CC.koEdgePic={[-3]={240,13,12},[-2]={241,12,12},[1]={242,12,13},[4]={243,12,12},[3]={244,13,12},[2]={245,12,12},[-1]={246,12,13},[-4]={247,12,12}}--ko: scroll arrows by dy*3+dx
CC.koScale=0
CC.koAnim=1
CC.koAuto=0
CC.koWide=2--ko 5.0: wide fixed
CC.koAutoSave=1
for koI=6,10 do CC.R_GRPFilename[koI]=CONFIG.Save.."save"..(koI-1)..".sav" end--ko 3.0: slots 6..10
CC.R_GRPFilename[11]=CONFIG.Save.."temp.sav"--ko 3.0: the game's temporary slot (was 6 = save5.sav)
CC.R_GRPFilename[12]=CONFIG.Save.."auto.sav"--ko 3.0: auto save slot (shown as "A" in the load menus)
CC.R_GRPFilename[13]=CONFIG.Save.."auto2.sav"--ko 3.1: the two older auto saves (A2, A3)
CC.R_GRPFilename[14]=CONFIG.Save.."auto3.sav"
CC.R_GRPFilename[18]=CONFIG.Save.."clear.sav"--ko 5.0 (koNGPlus): the latest ì¢…íš¡ clear (15 exp, 16 rewind, 17 town)
--ko 3.1: addons (script\addon\addons.lua lists them; _core.lua holds the loader, hooks and registries)
dofile(CONFIG.ScriptPath.."addon/_core.lua")
koAddon.settings[1]={key="koAutoSave",label="\133\120\130\108 \133\102\131\097",opts={{"\133\122",1},{"\133\117",0}},default=1}--ko 3.1: the base's own row (ìë™ ì €ì¥ ì¼¬/ë”)
koAddon.settings[2]={key="koDuelPick",label="\133\073\131\071\137\083 \129\113\130\108\129\118\129\074",opts={{"\133\122",1},{"\133\117",0}},default=1}--ko 3.1: ì¼ê¸°í†  ìˆ˜ë™ì¡°ì‘ ì¼¬(ì¹´ë“œ ê³ ë¥´ê¸°)/ë”(ì›ì‘ v12846 ê·¸ëŒ€ë¡œ: í™”ë©´ ì—†ì´ ì •í•´ì§„ ìŠ¹ë¦¬). ë¬´ìˆ  ëŒ€íšŒëŠ” í•­ìƒ ì¼¬
for koK=1,3 do koAddon.saveKeys[#koAddon.saveKeys+1]={key="koParty"..koK,default=""} end--ko 3.6 later: the three ì¶œì§„ í¸ì„± presets ("pid,pid,...")
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koFav",default=""}--ko 5.1 (10-16): ì¶œì§„ í™”ë©´ â˜… ì¦ê²¨ì°¾ê¸° ("pid,pid,...", ko_settings.lua, shared by every save like ì¶œì§„ í¸ì„±)
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koClearCycle",default=0}--ko 5.0 (koNGPlus): the cycle kept in clear.sav
koAddon.settings[#koAddon.settings+1]={key="koEntrance",label="\133\125\131\097 \133\066\133\098",opts={{"\130\066\130\094",2},{"\129\120\138\090",1},{"\133\117",0}},default=2}--ko 3.6 later: tavern entrance scenes (koHeroEntrance)
koAddonLoad()
--ko 5.0 (koSetReset): ê¸°ëŠ¥ì„¤ì • ã€Œì„¤ì • ì´ˆê¸°í™”ã€ â€” the window's own values back to their first values: ë°°ì† 1ë°°, ë°°ìœ¨ ë„ê¸°, ì—°ì¶œ 1ë°°, ëŒ€í™” ìˆ˜ë™ and
--every registered row's default. Records kept in ko_settings.lua (ë¬´ìˆ  ëŒ€íšŒ Â· ììœ  ì „íˆ¬ Â· ì—…ì  Â· ì¶œì§„ í¸ì„± ...), saves, the clear,
--ìŒì•… Â· íš¨ê³¼ìŒ and the per-save rows (ëª¨ë“œ Â· ë‚œì´ë„ Â· ì êµ° ì¶œê²© Â· ì ì¥ ì¶œì§„ Â· ì½”ìŠ¤íŠ¸) stay as they are
koAddon.settings[#koAddon.settings+1]={label="\129\069\129\070 \131\124\131\071\129\064",opts={{"\129\078\130\093",1}},run=function()
if not WarDrawStrBoxYesNo("\131\071\131\077\129\069\129\070\129\083 \139\110\130\077 \137\093\131\109\132\083 \132\067\137\066\132\117\129\089\129\090?",M_White,true) then return end
CC.FrameNum=35 CC.koAnim=1 CC.koAuto=0
for _,r in ipairs(koAddon.settings) do if r.key and r.default~=nil then CC[r.key]=r.default end end
if rawget(_G,"koSettingsFold") then koSettingsFold() end
if (CC.koScale or 0)~=0 then koSetScale(0) else koSave() end
WarDrawStrBoxConfirm("\139\110\130\077 \137\093\131\109\132\083 \132\067\137\066\132\126\129\075\129\076\129\077. \133\102\131\097\129\123 \131\071\133\108\131\098 \131\091\130\095\132\083\129\104\129\076\129\077.",M_White,true)
end}
pcall(dofile,CONFIG.CurrentPath.."ko_settings.lua")
if CONFIG.koCamp then local koKeep={} for _,koS in ipairs(koSharedKeys) do koKeep[koS]=CC[koS] end for _,koS in ipairs(koSettingKeys()) do koKeep[koS]=CC[koS] end for _,koK in ipairs(koAddon.saveKeys) do CC[koK.key]=koK.default end pcall(dofile,koSettingsPath()) for koS,koV in pairs(koKeep) do CC[koS]=koV end end--ko 6.0 campaigns: options from the shared file, records from the story's own
if rawget(_G,"koSettingsFold") then koSettingsFold() end--ko 5.0: rows folded into í™•ì¥
pcall(dofile,CONFIG.CurrentPath.."ko_screen.lua") -- ko 3.0: usable screen size, written by ko_sdl.dll
if CC.koScale==3 then CC.koScale=4 end -- ko 3.0: the 3x button is gone (it never fit a 1080p screen), old files map to full screen
--½ûÖ¹·ÃÎÊÈ«³Ì±äÁ¿
setmetatable(_G,{ __newindex=function (_,n)
error("attempt read write to undeclared variable " .. n,2)
end,
__index=function (_,n)
error("attempt read read to undeclared variable " .. n,2)
end,
} )
lib.Debug("JY_Main start.")
math.randomseed(tostring(os.time()):reverse():sub(1, 6))--³õÊ¼»¯Ëæ»úÊı·¢ÉúÆ÷
lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRePeatInterval)--ÉèÖÃ¼üÅÌÖØ¸´ÂÊ
lib.GetKey()
YJZMain()
end

--»ñµÃÎÒ·½ËùÓĞ²¿¶ÓµÄÆ½¾ùµÈ¼¶
function pjlv()
local lv_t={}
local cz=0
local cnt
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==1 then
table.insert(lv_t,JY.Person[i]["µÈ¼¶"])
cz=cz+1
end
end
table.sort(lv_t,function(a,b)return b<a end)
--ko 3.2: over-slot picks can make the army larger than the map's own slots; average only the top
--        koSlotBase levels so that bringing cheap low-level bodies cannot drag the enemy level down
if CC.koSlotBase~=nil and CC.koSlotBase>0 and CC.koSlotBase<cz then cz=CC.koSlotBase end
for ii=1,cz do
table.insert(lv_t,1)
end
local lv=0
if cz<30 then
	cnt=math.modf(cz/3)
else
	cnt=10
end
for ii=1,cnt do
lv=lv+lv_t[ii]
end
lv=math.modf(lv/math.max(1,cnt))--µÃµ½ÎÒ·½ËùÓĞ²¿¶ÓµÄÆ½¾ùµÈ¼¶
return lv
end

function myErrFun(err)--´íÎó´¦Àí£¬´òÓ¡´íÎóĞÅÏ¢
lib.Debug(err)--Êä³ö´íÎóĞÅÏ¢
lib.Debug(debug.traceback())--Êä³öµ÷ÓÃ¶ÑÕ»ĞÅÏ¢
local h=io.open(CONFIG.CurrentPath.."error.txt","a")--ko 3.1: keep the error where the player (and an addon author) can read it
if h then h:write(os.date().."  "..tostring(err).."\n"..debug.traceback().."\n\n") h:close() end
end

function SetGlobal()--ÉèÖÃÓÎÏ·ÄÚ²¿Ê¹ÓÃµÄÈ«³Ì±äÁ¿
JY={}
JY.Status=GAME_START--ÓÎÏ·µ±Ç°×´Ì¬
--±£´æR¡ÁÊı¾İ
JY.Base={}--»ù±¾Êı¾İ
JY.PersonNum=0--ÈËÎï¸öÊı
JY.Person={}--ÈËÎïÊı¾İ
JY.BingzhongNum=0--ÈËÎï¸öÊı
JY.Bingzhong={}--ÈËÎïÊı¾İ
JY.SceneNum=0--³¡¾°¸öÊı
JY.Scene={}--³¡¾°Êı¾İ
JY.ItemNum=0--µÀ¾ß¸öÊı
JY.Item={}--µÀ¾ßÊı¾İ
JY.MagicNum=0--²ßÂÔ¸öÊı
JY.Magic={}--²ßÂÔÊı¾İ
JY.SkillNum=0--ÌØ¼¼¸öÊı
JY.Skill={}--ÌØ¼¼Êı¾İ
JY.SubScene=-1--µ±Ç°×Ó³¡¾°±àºÅ
JY.SubSceneX=0--×Ó³¡¾°ÏÔÊ¾Î»ÖÃÆ«ÒÆ£¬³¡¾°ÒÆ¶¯Ö¸ÁîÊ¹ÓÃ
JY.SubSceneY=0
JY.Darkness=0--=0 ÆÁÄ»Õı³£ÏÔÊ¾£¬=1 ²»ÏÔÊ¾£¬ÆÁÄ»È«ºÚ
JY.MmapMusic=-1--ÇĞ»»´óµØÍ¼ÒôÀÖ£¬·µ»ØÖ÷µØÍ¼Ê±£¬Èç¹ûÉèÖÃ£¬Ôò²¥·Å´ËÒôÀÖ
JY.CurrentBGM=-1--µ±Ç°²¥·ÅµÄÒôÀÖid£¬ÓÃÀ´ÔÚ¹Ø±ÕÒôÀÖÊ±±£´æÒôÀÖid£®
CC.koTitleBGM=1--ko 3.1: title BGM track (soundM01)
JY.EnableMusic=1--ÊÇ·ñ²¥·ÅÒôÀÖ 1 ²¥·Å£¬0 ²»²¥·Å
JY.EnableSound=1--ÊÇ·ñ²¥·ÅÒôĞ§ 1 ²¥·Å£¬0 ²»²¥·Å
JY.LLK_N=0
JY.Dark=true
JY.Smap={}
JY.Tid=0--SMAPÊ±£¬µ±Ç°Ñ¡ÔñµÄÈËÎï »ò ÕıÔÚËµ»°µÄÈËÎï
JY.EventID=1
JY.LoadedPic=0
JY.MenuPic={
num=0,
pic={},
x={},
y={},
}
JY.Death=0--ÓÃÓÚÕ½³¡ÊÂ¼ş-"µ±ÏûÃğXXÊ±´¥·¢"
JY.ReFreshTime=0
War={}
War.Person={}
TeamSelect={}--ÓÃÓÚ´¢´æÕ½¶·Ç°ÈËÎïÑ¡Ôñ
Person0={}
zlyz=70  	--ÖÇÁ¦ãĞÖµ
wlyz=70 	--ÎäÁ¦ãĞÖµ
rl_flag=0
koWar=false--ko: battle-in-progress win bookkeeping (see WarStart)
bonus_money=100	--ÌôÕ½Ä£Ê½Ã¿ÈË±£µ×½±½ğ
bonus_exp=30	--ÌôÕ½Ä£Ê½Ã¿ÈË±£µ×½±ÀøÊôĞÔ¾­Ñé
ptlv=1	--ÆÕÍ¨Ä£Ê½±ÈÔ­À´¶îÍâÌá¸ßµÄµÈ¼¶
gold_lv=20--ÌôÕ½ÄÑ¶ÈÃ¿Ôö¼ÓÒ»¼¶¶à½±ÀøµÄ½ğ
exp_lv=5	--ÌôÕ½ÄÑ¶ÈÃ¿Ôö¼ÓÒ»¼¶¶à½±ÀøµÄÊôĞÔ¾­Ñé

end

function CleanMemory()--ÇåÀíluaÄÚ´æ
if CONFIG.CleanMemory==1 then
collectgarbage("collect")
end
end

--Á¬Á¬¿´¹Ø¿¨ÉèÖÃ
--ko 4.0 later: a tavern streak gate of N = the drinking contest record (addon drink: the boss at stage N beaten); ko 5.0: or the lianliankan record (koLlkRec, addon drink) at N
function koStreakOK(n) local llk=rawget(_G,"koLlkRec") return (JY.Base["ÊÂ¼ş333"] or 0)>=n or (llk~=nil and llk()>=n) end
function Game_Cycle()
for i=JY.Base["ÊÂ¼ş333"]+1,9999,1 do
PlayBGM(math.random(19))
local llk=lianliankan(i+9)

if llk then
if i>JY.Base["ÊÂ¼ş333"] and i<=30 then
JY.Base["ÊÂ¼ş333"]=i
end
else
return
end
end
end

--Á¬Á¬¿´ÓÎÏ·
function lianliankan(level)
local B={}
local num
local headbox={}
local X_Num,Y_Num
local pic_w,pic_h
local x_off,y_off
local limit,start_time,now_time
local mid_point={
x={},
y={},
}
local select_a={
x=0,
y=0,
}
local select_b={
x=0,
y=0,
}
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,0,0,0)
lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],0)
pic_w,pic_h=lib.PicGetXY(0,0*2)
X_Num=math.modf(CC.ScreenW/pic_w)
Y_Num=math.modf(CC.ScreenH*15/16/pic_h)
if X_Num~=math.modf(X_Num/2)*2 and Y_Num~=math.modf(Y_Num/2)*2 then
if CC.ScreenW-pic_w*X_Num<CC.ScreenH*15/16-pic_h*Y_Num then
X_Num=X_Num-1
else
Y_Num=Y_Num-1
end
end
if X_Num<6 or Y_Num<4 then
WarDrawStrBoxConfirm("@A BCD EFG HI JKLM!",M_White,true)
return false
end
num=X_Num*Y_Num/2
limit=X_Num*Y_Num*(10+level)*100+5000
local function sample(st,rp)
--Ëæ»ú³éÑù£¬rp ÊÇ·ñ·Å»Ø
local n=#st
local r=-1
if n>1 then
n=math.random(n)
end
r=st[n]
if not rp then
table.remove(st,n)
end
return r
end
local t_head={}
for i=1,228 do
--Í¼Æ¬³Ø
table.insert(t_head,i)
end
for i=1,math.min(level,50) do
headbox[i]=sample(t_head)--¾ö¶¨±¾´ÎÊ¹ÓÃµÄÍ·Ïñ
end
t_head={}
for i=1,Y_Num*X_Num/2 do
local picid=sample(headbox,true)
table.insert(t_head,picid)
table.insert(t_head,picid)
end
X_Num=X_Num+2
Y_Num=Y_Num+2
for i=1,Y_Num do
B[i]={}
for j=1,X_Num do
if between(i,2,Y_Num-1) and between(j,2,X_Num-1) then
B[i][j]=sample(t_head)
else
B[i][j]=-1
end
end
end
x_off=math.modf((CC.ScreenW-pic_w*X_Num)/2)
y_off=math.modf(CC.ScreenH/16+(CC.ScreenH*15/16-pic_h*Y_Num)/2)
local function SHOW()
for y=1,Y_Num do
for x=1,X_Num do
if B[y][x]>-1 then
lib.PicLoadCache(0,B[y][x]*2,pic_w*(x-1)+x_off,pic_h*(y-1)+y_off,1)
end
end
end
if select_a.x~=0 and select_a.y~=0 then
DrawBox(pic_w*(select_a.x-1)+x_off,pic_h*(select_a.y-1)+y_off,pic_w*select_a.x+x_off,pic_h*select_a.y+y_off,M_White)
end
if select_b.x~=0 and select_b.y~=0 then
DrawBox(pic_w*(select_b.x-1)+x_off,pic_h*(select_b.y-1)+y_off,pic_w*select_b.x+x_off,pic_h*select_b.y+y_off,M_White)
end
end
local function DrawTime()
now_time=lib.GetTime()
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH/16,RGB(192,192,192))
DrawString(0,0,string.format("Level:%d",level-9),M_Black,16)
DrawBox(160,3,CC.ScreenW-4,CC.ScreenH/16-5,M_White)
DrawBox(160,3,160+(CC.ScreenW-164)*(start_time+limit-now_time)/limit,CC.ScreenH/16-5,M_White)
end
local function Delay(t)
for i=1,t,10 do
DrawTime()
lib.ShowSurface(0)
lib.Delay(10)
end
end
local function FIND()
local len_min=(X_Num+Y_Num)*2
for x=1,X_Num do
local flag=true
local step
if select_b.y>select_a.y then
step=1
elseif select_b.y==select_a.y then
step=0
else
step=-1
end
if step~=0 then
for y=select_a.y+step,select_b.y-step,step do
if B[y][x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_a.x>x then
step=1
elseif select_a.x==x then
step=0
else
step=-1
end
if step~=0 and x~=select_a.x then
for xx=x,select_a.x-step,step do
if B[select_a.y][xx]~=-1 then
flag=false
break
end
end
end
if flag then
if select_b.x>x then
step=1
elseif select_b.x==x then
step=0
else
step=-1
end
if step~=0 and x~=select_b.x then
for xx=x,select_b.x-step,step do
if B[select_b.y][xx]~=-1 then
flag=false
break
end
end
end
if flag then
local len=math.abs(x-select_a.x)+math.abs(x-select_b.x)+math.abs(select_a.y-select_a.y)
if len<len_min then
len_min=len
mid_point.x[1]=select_a.x
mid_point.y[1]=select_a.y
mid_point.x[2]=x
mid_point.y[2]=select_a.y
mid_point.x[3]=x
mid_point.y[3]=select_b.y
mid_point.x[4]=select_b.x
mid_point.y[4]=select_b.y
end
end
end
end
end
for y=1,Y_Num do
local flag=true
local step
if select_b.x>select_a.x then
step=1
elseif select_b.x==select_a.x then
step=0
else
step=-1
end
if step~=0 then
for x=select_a.x+step,select_b.x-step,step do
if B[y][x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_a.y>y then
step=1
elseif select_a.y==y then
step=0
else
step=-1
end
if step~=0 and y~=select_a.y then
for yy=y,select_a.y-step,step do
if B[yy][select_a.x]~=-1 then
flag=false
break
end
end
end
if flag then
if select_b.y>y then
step=1
elseif select_b.y==y then
step=0
else
step=-1
end
if step~=0 and y~=select_b.y then
for yy=y,select_b.y-step,step do
if B[yy][select_b.x]~=-1 then
flag=false
break
end
end
end
if flag then
local len=math.abs(y-select_a.y)+math.abs(y-select_b.y)+math.abs(select_a.x-select_a.x)
if len<len_min then
len_min=len
mid_point.x[1]=select_a.x
mid_point.y[1]=select_a.y
mid_point.x[2]=select_a.x
mid_point.y[2]=y
mid_point.x[3]=select_b.x
mid_point.y[3]=y
mid_point.x[4]=select_b.x
mid_point.y[4]=select_b.y
end
end
end
end
end
if len_min<(X_Num+Y_Num)*2 then
return true
else
return false
end
end
lib.FillColor(0,0,0,0,0)
start_time=lib.GetTime()
now_time=start_time
SHOW()
lib.ShowSurface(0)
lib.Delay(20)
while num>0 do
if (now_time-start_time)>limit then
WarDrawStrBoxConfirm("NOPKLM. QRS TUWLM.",M_White,true)
PicCatchIni()
return false
end
local eventtype,keypress,x,y=lib.GetKey(1)
if eventtype==3 and keypress==3 then
PlayWavE(1)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
PicCatchIni()
return false
end
end
if eventtype==3 and keypress==1 then--ko: a right-click that was answered "no" in the quit prompt must not select the tile under it
local X=1+math.modf((x-x_off)/pic_w)
local Y=1+math.modf((y-y_off)/pic_h)
if x-x_off>=0 and y-y_off>=0 and X>=1 and X<=X_Num and Y>=1 and Y<=Y_Num and B[Y][X]~=-1 then
if (select_a.x==0 or select_a.y==0) then
select_a.x=X
select_a.y=Y
PlayWavE(0)
elseif select_a.x==X and select_a.y==Y then
select_a.x=0
select_a.x=0
PlayWavE(1)
else
if (select_b.x==0 or select_b.y==0) then
select_b.x=X
select_b.y=Y
PlayWavE(0)
elseif select_b.x==X and select_b.y==Y then
select_b.x=0
select_b.x=0
PlayWavE(1)
else
WarDrawStrBoxConfirm("[]^ _`ab QRS TUWLM!",M_White,true)
PicCatchIni()
return false
end
end
end
if select_a.x~=0 and select_a.y~=0 and select_b.x~=0 and select_b.y~=0 then
lib.FillColor(0,0,0,0,0)
SHOW()
Delay(50)
if B[select_a.y][select_a.x]==B[select_b.y][select_b.x] and FIND(1,select_a.x,select_a.y,-1) then
B[select_a.y][select_a.x]=-1
B[select_b.y][select_b.x]=-1
num=num-1
for t=1,3 do
if mid_point.x[t]~=mid_point.x[t+1] or mid_point.y[t]~=mid_point.y[t+1] then
DrawBox(pic_w*mid_point.x[t]+x_off-pic_w/2,pic_h*mid_point.y[t]+y_off-pic_h/2,
pic_w*mid_point.x[t+1]+x_off-pic_w/2,pic_h*mid_point.y[t+1]+y_off-pic_h/2,M_White)
end
end
PlayWavE(11)
Delay(250)
else
PlayWavE(3)
Delay(400)
end
select_a.x=0
select_a.y=0
select_b.x=0
select_b.y=0
end
lib.FillColor(0,0,0,0,0)
SHOW()
Delay(10)
end
Delay(10)
end
local koLlkGold=(level-9<=30) and (200+20*(level-9)) or 100--ko 4.0: stage N (=level-9) pays 200+20N on its first clear (1~30), 100 after the record cap
WarDrawStrBoxConfirm(string.format("caWLM! \131\103 %d \131\067\131\068*d%def gh",koLlkGold,level-8),M_White,true)
GetMoney(koLlkGold)--Ã¿¹ıÒ»¹Ø »ñµÃ100½ğ
lib.ShowSurface(0)
lib.Delay(500)
return true
end

--»æÖÆÒ»¸ö´ø±³¾°µÄ°×É«·½¿ò£¬ËÄ½Ç°¼½ø
function DrawBox(x1,y1,x2,y2,color)--»æÖÆÒ»¸ö´ø±³¾°µÄ°×É«·½¿ò
local s=4
lib.Background(x1+4,y1,x2-4,y1+s,128)
lib.Background(x1+1,y1+1,x1+s,y1+s,128)
lib.Background(x2-s,y1+1,x2-1,y1+s,128)
lib.Background(x1,y1+4,x2,y2-4,128)
lib.Background(x1+1,y2-s,x1+s,y2-1,128)
lib.Background(x2-s,y2-s+1,x2-1,y2,128)
lib.Background(x1+4,y2-s,x2-4,y2,128)
local r,g,b=GetRGB(color)
local color2=RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2))
DrawBox_1(x1-1,y1-1,x2-1,y2-1,color2)
DrawBox_1(x1+1,y1-1,x2+1,y2-1,color2)
DrawBox_1(x1-1,y1+1,x2-1,y2+1,color2)
DrawBox_1(x1+1,y1+1,x2+1,y2+1,color2)
DrawBox_1(x1,y1,x2,y2,color)
end

--»æÖÆËÄ½Ç°¼½øµÄ·½¿ò
function DrawBox_1(x1,y1,x2,y2,color)--»æÖÆËÄ½Ç°¼½øµÄ·½¿ò
local s=4
lib.DrawRect(x1+s,y1,x2-s,y1,color)
lib.DrawRect(x1+s,y2,x2-s,y2,color)
lib.DrawRect(x1,y1+s,x1,y2-s,color)
lib.DrawRect(x2,y1+s,x2,y2-s,color)
lib.DrawRect(x1+2,y1+1,x1+s-1,y1+1,color)
lib.DrawRect(x1+1,y1+2,x1+1,y1+s-1,color)
lib.DrawRect(x2-s+1,y1+1,x2-2,y1+1,color)
lib.DrawRect(x2-1,y1+2,x2-1,y1+s-1,color)
lib.DrawRect(x1+2,y2-1,x1+s-1,y2-1,color)
lib.DrawRect(x1+1,y2-s+1,x1+1,y2-2,color)
lib.DrawRect(x2-s+1,y2-1,x2-2,y2-1,color)
lib.DrawRect(x2-1,y2-s+1,x2-1,y2-2,color)
end

--»æÖÆÒ»¸ö´ø±³¾°µÄ°×É«·½¿ò£¬ËÄ½Ç°¼½ø
function DrawBox(x1,y1,x2,y2,color,bjcolor)--»æÖÆÒ»¸ö´ø±³¾°µÄ°×É«·½¿ò
local s=4
bjcolor=bjcolor or 0
if bjcolor>=0 then
lib.Background(x1,y1+s,x1+s,y2-s,128,bjcolor)--ÒõÓ°£¬ËÄ½Ç¿Õ³ö
lib.Background(x1+s,y1,x2-s,y2,128,bjcolor)
lib.Background(x2-s,y1+s,x2,y2-s,128,bjcolor)
end
if color>=0 then
local r,g,b=GetRGB(color)
DrawBox_1(x1+1,y1,x2,y2,RGB(math.modf(r/2),math.modf(g/2),math.modf(b/2)))
DrawBox_1(x1,y1,x2-1,y2-1,color)
end
end

--ĞŞ¸ÄºóµÄdrawbox£¬±ß¿ò¼Ó´Ö
function DrawGameBox(x1,y1,x2,y2)
lib.PicLoadCache(4,260*2,x1,y1,1)
end

function WarFillColor(x1,y1,x2,y2,clarity,color,size)
color=color or M_Red
clarity=clarity or 128
size=size or 8
local flag1=true
for y=y1,y2-1,size do
local flag2=flag1
for x=x1,x2-1,size do
if flag2 then
lib.Background(x,y,x+size,y+size,clarity,color)
end
flag2=not flag2
end
flag1=not flag1
end
end

--ÏÔÊ¾ÒõÓ°×Ö·û´®
function koCenter(s,w,xo,sz)
local t=s
while true do
if string.sub(t,1,1)==" " then t=string.sub(t,2)
elseif string.sub(t,1,2)=="\161\161" then t=string.sub(t,3)
else break end
end
while string.len(t)>0 and string.sub(t,string.len(t),string.len(t))==" " do t=string.sub(t,1,string.len(t)-1) end
local tw=0
local ci=1
local cn=string.len(t)
while ci<=cn do
local cb=string.byte(t,ci)
if cb>=129 and cb<=254 and ci<cn then tw=tw+sz ci=ci+2 else tw=tw+sz/2 ci=ci+1 end
end
local dmin=6-xo-CC.MenuBorderPixel
local d=math.floor(6+(w-14-tw)/2)-xo-CC.MenuBorderPixel
if d<dmin then d=dmin end
return t,d
end
function DrawString(x,y,str,color,size)--ÏÔÊ¾ÒõÓ°×Ö·û´®
if CC.FontType==0 then
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
elseif CC.FontType==1 then
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
end

function DrawString2(x,y,str,color,size)--ÏÔÊ¾ÒõÓ°×Ö·û´®
lib.DrawStr(x-2,y,str,M_Black,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
lib.DrawStr(x+1,y,str,M_Black,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet,1)
DrawString(x,y,str,color,size)
end

--ÏÔÊ¾´ø¿òµÄ×Ö·û´®
--(x,y) ×ø±ê£¬Èç¹û¶¼Îª-1,ÔòÔÚÆÁÄ»ÖĞ¼äÏÔÊ¾
function DrawStrBox(x,y,str,color,size)--ÏÔÊ¾´ø¿òµÄ×Ö·û´®
local ll=#str
local w=size*ll/2+2*CC.MenuBorderPixel
local h=size+2*CC.MenuBorderPixel
if x==-1 then
x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2
end
DrawBox(x,y,x+w-1,y+h-1,M_White)
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel,str,color,size)
end

function DrawStrBox(x,y,str,color,size,bjcolor)--ÏÔÊ¾´ø¿òµÄ×Ö·û´®
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,koBoxChars())
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num
if x==-1 then
x=(CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size*num-2*CC.MenuBorderPixel)/2
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
DrawBox(x,y,x+w-1,y+h-1,M_White,bjcolor)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+size*(i-1),strarray[i],color,size)
end
end

function DrawStr(x,y,str,color,size)--ÏÔÊ¾×Ö·û´®,»á·ÖĞĞ
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,koBoxChars())
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
for i=1,num do
DrawString(x,y+size*(i-1),strarray[i],color,size)
end
end

--·Ö¸î×Ö·û´®
function Split(szFullString,szSeparator)
local nFindStartIndex=1
local nSplitIndex=1
local nSplitArray={}
while true do
local nFindLastIndex=string.find(szFullString, szSeparator, nFindStartIndex)
if not nFindLastIndex then
nSplitArray[nSplitIndex]=string.sub(szFullString, nFindStartIndex, string.len(szFullString))
break
end
nSplitArray[nSplitIndex]=string.sub(szFullString, nFindStartIndex, nFindLastIndex - 1)
nFindStartIndex=nFindLastIndex + string.len(szSeparator)
nSplitIndex=nSplitIndex + 1
end
return nSplitIndex,nSplitArray
end

--ÏÔÊ¾²¢Ñ¯ÎÊY/N£¬Èç¹ûµã»÷Y£¬Ôò·µ»Øtrue, NÔò·µ»Øfalse
--(x,y) ×ø±ê£¬Èç¹û¶¼Îª-1,ÔòÔÚÆÁÄ»ÖĞ¼äÏÔÊ¾
--¸ÄÎªÓÃ²Ëµ¥Ñ¯ÎÊÊÇ·ñ
function DrawStrBoxYesNo(x,y,str,color,size)--ÏÔÊ¾×Ö·û´®²¢Ñ¯ÎÊY/N
lib.GetKey()
local ll=#str
local w=size*ll/2+2*CC.MenuBorderPixel
local h=size+2*CC.MenuBorderPixel
if x==-1 then
x=(CC.ScreenW-size/2*ll-2*CC.MenuBorderPixel)/2
end
if y==-1 then
y=(CC.ScreenH-size-2*CC.MenuBorderPixel)/2
end
DrawStrBox(x,y,str,color,size)
local menu={{"k",nil,1},
{"nL[",nil,2}}
local r=ShowMenu(menu,2,0,x+w-4*size-2*CC.MenuBorderPixel,y+h+CC.MenuBorderPixel,0,0,1,0,size*0.8,M_Orange, M_White)
if r==1 then
return true
else
return false
end
end

function WarShowTarget(firstShow)--ÏÔÊ¾ÈÎÎñÄ¿±ê
-- notWar true notwar, false in war
lib.GetKey()
koWarEnsure()
local x,y
local w,h=320,192
local size=16
x=koMapCenterX(0)
y=koMapCenterY(0)
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+148
local y2=y1+24
local str=""
if firstShow then
PlayWavE(0)
str="do pq "..War.MaxTurn--ko: half-width digits
else
str="rs pq "..War.Turn.."/"..War.MaxTurn--ko: half-width digits
end
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
lib.PicLoadCache(4,81*2,x,y,1)
DrawString(x+16,y+16,War.WarName,M_White,size)
DrawString(x+240,y+16,"tuvw",M_White,size)
DrawStr(x+32,y+56,War.WarTarget,M_White,size)
DrawStr(x+24,y+152,str,M_White,size)
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
ReFresh(0)
end
koMouseReset()
local current=0
while true do
redraw(current)
koPollKey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
WarDelay(4)
return
else
current=0
end
end
end

function DrawItemStatus(id,pid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
local str=JY.Item[id]["ËµÃ÷"]
if CC.Enhancement then--ko 3.2: show the effect of every treasure; one not worn in any of the three slots is marked (when worn)
local p=JY.Person[pid]
local koLbl="xqy{"
local koExl="‚B„o xƒG"
if id~=p["ÎäÆ÷"] and id~=p["·À¾ß"] and id~=p["¸¨Öú"] then koLbl=koLbl.."(†W„o ‚V)" koExl=koExl.."(†W„o ‚V)" end
--ko 3.5: exclusive effect gets its own label; an effect the viewer already has as talent is marked
local koTf=p["Ìì¸³"]
local koTfSet=({[121]={[115]=true,[117]=true,[42]=true},[122]={[1]=true,[2]=true,[43]=true},[123]={},[124]={[101]=true,[17]=true,[18]=true},[125]={[115]=true,[51]=true,[52]=true},[126]={[117]=true,[51]=true},[127]={[20]=true,[51]=true},[128]={[109]=true,[51]=true},[129]={[113]=true,[52]=true},[131]={[20]=true}})[koTf]
local function koSame(sid) if sid==koTf or (koTfSet and koTfSet[sid]) then return "(G†w ‚s‚^„S ƒs‚G)" end return "" end
--ko 3.5: the box shows 4 lines a page; an effect that would straddle two pages starts on the next page
local function koCnt(s) local n=Split(GenTalkString(s,18),'*') return n end
local function koAdd(seg) local c=koCnt(str) local n=koCnt(seg) if n<=4 and (c%4)+n>4 then str=str..string.rep("*",4-c%4) end str=str.."*"..seg end
if JY.Item[id]["ÌØ¼¼"]>0 then
koAdd(koLbl..":"..JY.Skill[JY.Item[id]["ÌØ¼¼"]]["ËµÃ÷"]..koSame(JY.Item[id]["ÌØ¼¼"]))
end
if JY.Item[id]["×¨ÊôÌØ¼¼"]>0 and p["ĞÕÃû"]==JY.Item[id]["×¨ÊôÌØ¼¼ÈË"] then
koAdd(koExl..":"..JY.Skill[JY.Item[id]["×¨ÊôÌØ¼¼"]]["ËµÃ÷"]..koSame(JY.Item[id]["×¨ÊôÌØ¼¼"]))
end
end
DrawStrStatus(JY.Item[id]["Ãû³Æ"],str)
end

function DrawSkillStatus(id)--ÏÔÊ¾¼¼ÄÜÊôĞÔ
 DrawStrStatus(JY.Skill[id]["Ãû³Æ"],JY.Skill[id]["ËµÃ÷"])
end

function DrawBingZhongStatus(id)--ÏÔÊ¾±øÖÖÊôĞÔ
 DrawStrStatus(JY.Bingzhong[id]["Ãû³Æ"],JY.Bingzhong[id]["ËµÃ÷"])
end

function DrawLieZhuan(name,pid)--ÏÔÊ¾ÁĞ´«
 DrawStrStatus("|}~‚@‚A‚B - "..name,(pid and CC.LieZhuanPid and CC.LieZhuanPid[pid]) or CC.LieZhuan[name])
end

function DrawStrStatus(str1,str2)--ÏÔÊ¾ÊôĞÔ
lib.GetKey()
local x,y
local w,h=320,128
local size=16
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(0)
y=koMapCenterY(0)
notWar=false
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
notWar=true
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
notWar=true
end
x=x-w/2
y=y-h/2
local x1=x+254
local x2=x1+52
local y1=y+92
local y2=y1+24
--ko „v…ZG 4„{S „|ƒmA 4„{] ƒvB ƒsb ƒeM
local koLine={}
local koNum
koNum,koLine=Split(GenTalkString(str2,18),'*')
local koPage=1
local koPages=math.modf((koNum+3)/4)
if koPages<1 then koPages=1 end
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
lib.PicLoadCache(4,80*2,x,y,1)
DrawString(x+16,y+10,str1,C_Name,size)--oldy=16
for koI=1,4 do
local koK=(koPage-1)*4+koI
if koLine[koK]~=nil then
DrawString(x+16,y+28+size*(koI-1),koLine[koK],M_White,size)
end
end
if koPages>1 then
DrawString(x+16,y+94,koPage.."/"..koPages,C_Name,size)
end
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh(0)
end
end
koMouseReset()
local current=0
PlayWavE(0)
while true do
redraw(current)
koPollKey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
if koPage<koPages then
koPage=koPage+1
koMouseReset()
else
return
end
elseif MOUSE.ESC() then
return
else
current=0
end
end
end

function WarDrawStrBoxConfirm(str,color,notWar)--ÏÔÊ¾×Ö·û´®²¢Ñ¯ÎÊY/N
lib.GetKey()
local x,y
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,koBoxChars())
str=str.."* "
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(0)
y=koMapCenterY(0)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
end
local x4=x+w/2
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=y+h/2
local y1=y2-24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
if notWar then
DrawYJZBox(-1,-1,str,color,notWar)
else
DrawYJZBox(-1,-1,str,color)
end
if flag==2 then
lib.PicLoadCache(4,56*2,x3,y1,1)
else
lib.PicLoadCache(4,55*2,x3,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh(0)
end
end
koMouseReset()
local current=0
while true do
redraw(current)
koPollKey()
if MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
 current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return false
else
current=0
end
end
end

function WarDrawStrBoxYesNo(str,color,notWar)--ÏÔÊ¾×Ö·û´®²¢Ñ¯ÎÊY/N
lib.GetKey()
local x,y
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,koBoxChars())
str=str.."* "
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(0)
y=koMapCenterY(0)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640)/2
y=16+(400)/2
else
x=(CC.ScreenW)/2
y=(CC.ScreenH)/2
end
local x4=x+w/2
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=y+h/2
local y1=y2-24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
if not notWar then
DrawWarMap()
end
if notWar then
DrawYJZBox(-1,-1,str,color,notWar)
else
DrawYJZBox(-1,-1,str,color)
end
if flag==1 then
lib.PicLoadCache(4,52*2,x1,y1,1)
else
lib.PicLoadCache(4,51*2,x1,y1,1)
end
if flag==2 then
lib.PicLoadCache(4,54*2,x3,y1,1)
else
lib.PicLoadCache(4,53*2,x3,y1,1)
end
if notWar then
ShowScreen()
else
ReFresh(0)
end
end
koMouseReset()
local current=0
while true do
redraw(current)
koPollKey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return true
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return false
else
current=0
end
end
end

function DrawStrBoxWaitKey(s,color)--ÏÔÊ¾×Ö·û´®²¢µÈ´ı»÷¼ü
lib.GetKey()
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
DrawYJZBox(-1,-1,s,color,true)
ShowScreen()
 WaitKey(nil,#s/2)
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
ShowScreen()
end

function WarDrawStrBoxWaitKey(s,color,x,y)--ÏÔÊ¾×Ö·û´®²¢µÈ´ı»÷¼ü ÊÊÓÃÓÚÕ½¶·£¬»­Ãæ±£³ÖË¢ĞÂ
x=x or -1
y=y or -1
lib.GetKey()
local koT0Box=lib.GetTime()--ko 5.0: the button-up of the click that closed the previous box must not close this one (10-08)
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox(x,y,s,color)
local eventtype,keypress,x,y=lib.GetMouse(1)
local koN=0
while (eventtype==2 or eventtype==4) and koN<32 do
eventtype,keypress,x,y=lib.GetMouse(1)
koN=koN+1
end
local koKe=-1--ko 3.0: lib.GetMouse(1) does not poll the event queue; do it here (drain motion events) or the box never sees the click
for koI=1,32 do
local koE=lib.GetKey(1)
if koE==0 then koExit() end
if koE==1 or koE==3 then koKe=koE break end
if koE==-1 or koE==nil then break end
end
ReFresh()
if (eventtype==1 or eventtype==3 or koKe==1 or koKe==3) and lib.GetTime()-koT0Box>200 then
break
end
end
end

function WarDrawStrBoxDelay(s,color,x,y,n)--ÏÔÊ¾×Ö·û´®²¢µÈ´ı»÷¼ü ÊÊÓÃÓÚÕ½¶·£¬»­Ãæ±£³ÖË¢ĞÂ
x=x or -1
y=y or -1
n=n or 36
if War.koSkip then n=2 end--ko 3.1
lib.GetKey()
local koT0Box=lib.GetTime()--ko 5.0: the button-up of the click that closed the previous box must not close this one (10-08)
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox(x,y,s,color)
local eventtype,keypress,x,y=lib.GetMouse(1)
local koN=0
while (eventtype==2 or eventtype==4) and koN<32 do
eventtype,keypress,x,y=lib.GetMouse(1)
koN=koN+1
end
local koKe=-1--ko 3.0: lib.GetMouse(1) does not poll the event queue; do it here (drain motion events) or the box never sees the click
for koI=1,32 do
local koE=lib.GetKey(1)
if koE==0 then koExit() end
if koE==1 or koE==3 then koKe=koE break end
if koE==-1 or koE==nil then break end
end
ReFresh()
if (eventtype==1 or eventtype==3 or koKe==1 or koKe==3) and lib.GetTime()-koT0Box>200 then
break
end
end
end

function DrawYJZBox(x,y,str,color,notWar)--ÏÔÊ¾´ø¿òµÄ×Ö·û´®
notWar=notWar or false
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,koBoxChars())
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
if x==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(w)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=koMapCenterY(h)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y=16+(400-h)/2
else
y=(CC.ScreenH-h)/2
end
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+7,boxy+7,math.min(boxx+boxw-7,boxx+375),math.min(boxy+boxh-7,boxy+119))
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size)
end
end

function DrawYJZBox_sub(x,y,w,h)
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,50*2,boxx+boxw-382,boxy+boxh-126,1)
lib.SetClip(0,0,0,0)
end

function WarDrawStrBoxDelay2(s,color,x,y,n)--ÏÔÊ¾×Ö·û´®²¢µÈ´ı»÷¼ü ÊÊÓÃÓÚÕ½¶·£¬»­Ãæ±£³ÖË¢ĞÂ
x=x or -1
y=y or -1
n=n or 16
lib.GetKey()
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(x,y,s,color)
lib.GetKey()
ReFresh()
end
end

function DrawYJZBox2(x,y,str,color)--ÏÔÊ¾´ø¿òµÄ×Ö·û´®
local size=16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,koBoxChars())
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local w=size*maxlen/2+2*CC.MenuBorderPixel
local h=2*CC.MenuBorderPixel+size*num+6*(num-1)
 
if x==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(w)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=koMapCenterY(h)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y=16+(400-h)/2
else
y=(CC.ScreenH-h)/2
end
end
if x<0 then
x=CC.ScreenW-size/2*maxlen-2*CC.MenuBorderPixel+x
end
if y<0 then
y=CC.ScreenH-size*num-2*CC.MenuBorderPixel+y
end
local boxw,boxh
boxw=16*math.modf(w/16)+16+14
boxh=16*math.modf(h/16)+16+14
local boxx=x-(boxw-w)/2
local boxy=y-(boxh-h)/2
--382x126
--Left Top
lib.SetClip(boxx,boxy,boxx+boxw/2,boxy+boxh/2)
lib.PicLoadCache(4,60*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
--Left Bot
lib.SetClip(boxx,boxy+boxh/2,boxx+boxw/2,boxy+boxh)
lib.PicLoadCache(4,60*2,boxx,boxy+boxh-110,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+boxw/2,boxy,boxx+boxw,boxy+boxh/2)
lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy,1)
lib.SetClip(0,0,0,0)
--Right Bot
lib.SetClip(boxx+boxw/2,boxy+boxh/2,boxx+boxw,boxy+boxh)
lib.PicLoadCache(4,60*2,boxx+boxw-142,boxy+boxh-110,1)
lib.SetClip(0,0,0,0)
--Right Top
lib.SetClip(boxx+7,boxy+7,math.min(boxx+boxw-7,boxx+375),math.min(boxy+boxh-7,boxy+119))
lib.PicLoadCache(4,50*2,boxx,boxy,1)
lib.SetClip(0,0,0,0)
for i=1,num do
DrawString(x+CC.MenuBorderPixel,y+CC.MenuBorderPixel+(size+6)*(i-1),strarray[i],color,size)
end
end

function ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
if JY.Dark then
Light()
else
lib.ShowSurface(0)
end
end

function RGB(r,g,b)--ÉèÖÃÑÕÉ«RGB
return r*65536+g*256+b
end

function GetRGB(color)--·ÖÀëÑÕÉ«µÄRGB·ÖÁ¿
color=color%(65536*256)
local r=math.floor(color/65536)
color=color%65536
local g=math.floor(color/256)
local b=color%256
return r,g,b
end

--µÈ´ı¼üÅÌÊäÈë
function WaitKey(flag,n)--µÈ´ı¼üÅÌÊäÈë
local keyPress=-1
n=n or 20
local koT0=lib.GetTime() local koW=koAutoMs(n) local koT0Wait=koT0--ko 5.0: ignore the button-up of the click that closed the box before (10-09)
while true do
local eventtype,keypress,x,y=lib.GetMouse(1)
local koKe=lib.GetKey(1)
if koKe==0 then koExit() end
if (eventtype==1 or eventtype==3 or koKe==1 or koKe==3) and lib.GetTime()-koT0Wait>200 then
MOUSE.status='IDLE'
break
end
if koW>=0 and lib.GetTime()-koT0>=koW then MOUSE.status='IDLE' break end
lib.Delay(20)
end
lib.Delay(100)
return keyPress
end

--ko 3.1: ìˆœì •(ì˜¤ë¦¬ì§„) saves and ìœ ê´‘íŒ saves have different layouts (newgame.grp sizes); refuse the other kind with a note
--ko 6.0 (10-27): an older save's layout from (newgame size - save size): returns (person bytes short, item bytes short) or nil.
--   persons {now, 602, 502 (2.0)} x items {now, 250, 200}; the tables only grew at their ends, so the save holds the first rows of each.
function koSaveLayout(delta)
if delta==0 then return 0,0 end
if delta==nil or delta<0 then return nil end
local d=Byte.create(32)
Byte.loadfile(d,CC.R_IDXFilename[0],0,32)
local PN=math.floor((Byte.get32(d,4)-Byte.get32(d,0))/CC.PersonSize)
local IN=math.floor((Byte.get32(d,16)-Byte.get32(d,12))/CC.ItemSize)
for _,p in ipairs({PN,602,502}) do for _,i in ipairs({IN,900,250,200}) do
if p<=PN and i<=IN and (PN-p)*CC.PersonSize+(IN-i)*CC.ItemSize==delta then return (PN-p)*CC.PersonSize,(IN-i)*CC.ItemSize end
end end
return nil
end
function koSaveCompat(id)
local function size(p) local f=io.open(p,"rb") if not f then return -1 end local s=f:seek("end") f:close() return s end
local s=size(CC.R_GRPFilename[id]) if s==271138 or (s>0 and koSaveLayout(size(CC.R_GRPFilename[0])-s)~=nil) then return true end--ko 6.0 (10-27): any known person x item table size (koSaveLayout)--ko 5.1 storyhire (10-14): -200 persons = before the 802-person table--ko 5.0 (10-13): -50 items = before the books --ko 3.3: 271138 = early 2.0/1.0.2 layout, read by LoadRecord (kodelta)
WarDrawStrBoxConfirm("\130\071\130\072\130\070 \131\071\133\108\129\071 \129\110\130\096\129\076\129\077 (\132\065\129\070 \136\069\130\121). \131\087\132\083 \134\113\134\073\132\067\130\067 \130\107\129\075\129\076\129\077",M_White,true)
return false
end
-- Item 20 is the shared seal; rows 20-27 also supply the original promotion rules.
local PROMOTION_SEAL=20
local LAST_PROMOTION_ITEM=27
local PROMOTION_NAME="\129\106\129\113"
local PROMOTION_DESC="\130\126\129\084: 1 -> 2 / 2 -> 3"
local ITEM_NAME="\195\251\179\198"
local ITEM_DESC="\203\181\195\247"
local ITEM_PRICE="\188\219\214\181"
local PERSON_ITEM="\181\192\190\223"
local ITEM_REQUIRED_CLASS="\208\232\177\248\214\214"

function koPromotionItemId(item)
if type(item)=="number" and item>=PROMOTION_SEAL and item<=LAST_PROMOTION_ITEM then return PROMOTION_SEAL end
return item
end

function koIsPromotionItem(item)
return koPromotionItemId(item)==PROMOTION_SEAL
end

-- Replace all promotion entries with one seal at the position of the first.
function koPromotionStock(stock)
local result,hasSeal={},false
for _,item in ipairs(stock or {}) do
local mapped=koPromotionItemId(item)
if mapped~=PROMOTION_SEAL or not hasSeal then
result[#result+1]=mapped
if mapped==PROMOTION_SEAL then hasSeal=true end
end
end
return result
end

local function koSyncPromotionItems()
local seal=JY.Item[PROMOTION_SEAL]
seal[ITEM_NAME]=PROMOTION_NAME
seal[ITEM_DESC]=PROMOTION_DESC
seal[ITEM_PRICE]=50 -- the shop displays ten gold per price unit
-- The warehouse is stored in the last person records' item slots, too.
for pid=1,JY.PersonNum-1 do
local p=JY.Person[pid]
for slot=1,8 do
local key=PERSON_ITEM..slot
local item=p[key]
local mapped=koPromotionItemId(item)
if mapped~=item then p[key]=mapped end
end
end
end

function LoadRecord(id)-- ¶ÁÈ¡ÓÎÏ·½ø¶È
Dark()
koHook("record_load")--ko 3.1
local t1=lib.GetTime()
local data=Byte.create(4*8)
--¶ÁÈ¡savedata
Byte.loadfile(data,CC.SavedataFile,0,4*8)
CC.font=Byte.get16(data,0)
CC.MusicVolume=Byte.get16(data,2)
CC.SoundVolume=Byte.get16(data,4)
CC.zdby=Byte.get16(data,6)
CC.cldh=Byte.get16(data,8)
CC.MoveSpeed=Byte.get16(data,10)
Config()
PicCatchIni()
--¶ÁÈ¡R*.idxÎÄ¼ş
Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8)
local idx={}
idx[0]=100
for i=1,8 do
idx[i]=Byte.get32(data,4*(i-1))
end
--¶ÁÈ¡R*.grpÎÄ¼ş
--ko: a save written before the person table grew keeps the old layout (smaller file).
--    Base is unaffected; the person block is shorter and the scene/item blocks sit kodelta bytes earlier.
local kodelta=0
if id>0 then
local kof=io.open(CC.R_GRPFilename[id],"rb")
if kof then
local kosz=kof:seek("end")
kof:close()
if kosz~=nil and kosz>0 and kosz<idx[7] then
kodelta=idx[7]-kosz
end
end
end
local koItemShort=0--ko 5.0 (10-13): the item table grew 200 -> 250 (books): every older save has 200, the new slots come from newgame
if kodelta>0 then local koP,koI=koSaveLayout(kodelta) if koP then kodelta=koP koItemShort=koI end end--ko 6.0 (10-27): person rows short / item rows short, any known pair (was 200 -> 250 items only)
JY.Data_Base=Byte.create(idx[1]-idx[0])--»ù±¾Êı¾İ
Byte.loadfile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0])
--ÉèÖÃ·ÃÎÊ»ù±¾Êı¾İµÄ·½·¨£¬ÕâÑù¾Í¿ÉÒÔÓÃ·ÃÎÊ±íµÄ·½Ê½·ÃÎÊÁË£®¶ø²»ÓÃ°Ñ¶ş½øÖÆÊı¾İ×ª»¯Îª±í£®½ÚÔ¼¼ÓÔØÊ±¼äºÍ¿Õ¼ä
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Base,0,CC.Base_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Base,0,CC.Base_S,k,v)
end
}
setmetatable(JY.Base,meta_t)
if id>0 and JY.Base["ÓÎÏ·Ä£Ê½"]~=1 then JY.Base["ÓÎÏ·Ä£Ê½"]=1 end--ko 5.0: old classic save -> enhanced mode on load (10-07)
if JY.Base["ÓÎÏ·Ä£Ê½"]==1 then
CC.Enhancement=true
else
CC.Enhancement=false
end
if CC.Enhancement==false then
CC.Person_S["ÎäÁ¦"]={48,0,2,true}
CC.Person_S["ÖÇÁ¦"]={50,0,2,true}
CC.Person_S["Í³ÂÊ"]={52,0,2,true}
CC.Person_S["ÎäÁ¦¾­Ñé"]={54,0,2,true}
CC.Person_S["ÖÇÁ¦¾­Ñé"]={56,0,2,true}
CC.Person_S["Í³ÂÊ¾­Ñé"]={58,0,2,true}
else
CC.Person_S["ÎäÁ¦"]={48,0,2,true}
CC.Person_S["ÖÇÁ¦"]={50,0,2,true}
CC.Person_S["Í³ÂÊ"]={52,0,2,true}
CC.Person_S["ÎäÁ¦¾­Ñé"]={54,0,2,true}
CC.Person_S["ÖÇÁ¦¾­Ñé"]={56,0,2,true}
CC.Person_S["Í³ÂÊ¾­Ñé"]={58,0,2,true}
end
JY.PersonNum=math.floor((idx[2]-idx[1])/CC.PersonSize)--ÈËÎï /newgamesaveºÍÊµ¼Ê´æµµ »ìºÏ¶ÁÈ¡
JY.Data_Person_Base=Byte.create(CC.PersonSize*JY.PersonNum)
JY.Data_Person=Byte.create(CC.PersonSize*JY.PersonNum)
Byte.loadfile(JY.Data_Person_Base, CC.R_GRPFilename[0],idx[1],CC.PersonSize*JY.PersonNum)
if kodelta>0 then --ko old save: newgame fills the new tail slots, the save overwrites the slots it has
Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[0],idx[1],CC.PersonSize*JY.PersonNum)
Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum-kodelta)
else
Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
end
for i=0,JY.PersonNum-1 do
JY.Person[i]={}
if i<421 then
local meta_t={
__index=function(t,k)
return GetPersonData(i*CC.PersonSize,CC.Person_S,k)--421ÒÔÇ°µÄÈËÎï»ìºÏ¶ÁÈ¡£¬421ÒÔºóÎªĞÂÎä½«
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v)
end
}
setmetatable(JY.Person[i],meta_t)
else
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Person,i*CC.PersonSize,CC.Person_S,k,v)
end
}
setmetatable(JY.Person[i],meta_t)
end
end
if not rawget(_G,"koCamp") then--ko 6.0 campaigns: the person repairs below are for the Liu Bei story only
--ko 388 identity: name/class/innate are SAVE-resident, so refresh them from mod data on every load
if JY.PersonNum>388 then
if JY.Person[388]["ĞÕÃû"]~="\131\99\129\106" then --ko old save (hnc): convert class/innate once; keep trainer changes in new saves
JY.Person[388]["±øÖÖ"]=29
JY.Person[388]["Ìì¸³"]=120
end
JY.Person[388]["ĞÕÃû"]="\131\99\129\106"
JY.Person[388]["ÍâºÅ"]="d‡y„X¡¤ƒcj" --ko L-3: new alias (old joke alias removed)
--ko 407 ‚G„N¡¤408 ‡gƒO: old save has blank records; if portrait is 0 copy the whole newgame record
--ko 3.6 later: Sima Hui (382) was an unused record; an older save still has his old numbers: newgame's, until he joins
if JY.PersonNum>382 and (JY.Base["\202\194\188\2541962"] or 0)==0 and JY.Person[382]["\190\253\214\247"]~=1 then--ko 4.0: once per save (event 1962); a new cycle keeps him unhired in the tavern with carried stats
for _,kok in ipairs({"\206\228\193\166","\214\199\193\166","\205\179\194\202","\204\236\184\179","\177\248\214\214","\204\216\188\1881","\204\216\188\1882","\204\216\188\1883","\204\216\188\1884","\204\216\188\1885","\204\216\188\1886"}) do
JY.Person[382][kok]=GetDataFromStruct(JY.Data_Person_Base,382*CC.PersonSize,CC.Person_S,kok)
end
end
if JY.PersonNum>382 then JY.Base["\202\194\188\2541962"]=1 end--ko 4.0: Sima Hui old-save fix done
for _,kopid in ipairs({407,408,409,389,390,410,411,412,413,414,415,418}) do
if JY.PersonNum>kopid and JY.Person[kopid]["Í·Ïñ´úºÅ"]==0 then
for kok,_ in pairs(CC.Person_S) do
JY.Person[kopid][kok]=GetDataFromStruct(JY.Data_Person_Base,kopid*CC.PersonSize,CC.Person_S,kok)
end
end
end
end
--ko exclusive classes are fixed (koFixedBZ): put 388/407/408 back in case an older save had changed them
if JY.PersonNum>408 then
JY.Person[388]["±øÖÖ"]=29
JY.Person[407]["±øÖÖ"]=31
JY.Person[408]["±øÖÖ"]=30
end
if JY.PersonNum>409 then--ko 3.6: 409 Demon Zhuge Liang keeps class 32
JY.Person[409]["±øÖÖ"]=32
end
if JY.PersonNum>413 then--ko 3.6: the new tavern generals' own classes
JY.Person[389]["±øÖÖ"]=35 JY.Person[390]["±øÖÖ"]=35 JY.Person[410]["±øÖÖ"]=33 JY.Person[411]["±øÖÖ"]=34 JY.Person[412]["±øÖÖ"]=34
end
if JY.PersonNum>415 then--ko 3.6 later: Huang Yueying keeps her class (ê¸°ê´€ì‚¬)
JY.Person[415]["\177\248\214\214"]=37
if JY.PersonNum>418 then JY.Person[418]["\177\248\214\214"]=39 end--ko 11-06: Yu Ji (sword dancer)
end
if JY.PersonNum>382 then--ko 3.6 later: Sima Hui is a ì„ ì¸ (fixed class, with Zuo Ci and Xianzi)
JY.Person[382]["\177\248\214\214"]=35
end
if JY.PersonNum>390 then--ko 4.0 later: Sima Hui takes Zuo Ci's old portrait 202, Zuo Ci gets the new one 1243
JY.Person[382]["\205\183\207\241\180\250\186\197"]=202
JY.Person[390]["\205\183\207\241\180\250\186\197"]=1243
end
if JY.PersonNum>414 then--ko 3.6: To-in keeps the clay-doll class
JY.Person[414]["±øÖÖ"]=36
end
--ko 3.2: hired tavern slots kept the alternate portrait; put the original one back, once, by name
if JY.PersonNum>421 then
local konm={}
for koi=1,420 do
local kof=JY.Person[koi]["Í·Ïñ´úºÅ"]
if kof>0 and konm[JY.Person[koi]["ĞÕÃû"]]==nil then
konm[JY.Person[koi]["ĞÕÃû"]]=kof
end
end
for koi=421,math.min(JY.PersonNum-1,601) do--ko 5.1 storyhire
local kof=JY.Person[koi]["Í·Ïñ´úºÅ"]
if kof>0 and kof<1000 then
local koo=konm[JY.Person[koi]["ĞÕÃû"]]
if koo~=nil and koo~=kof then
JY.Person[koi]["Í·Ïñ´úºÅ"]=koo
end
end
end
end
end--ko 6.0 campaigns
JY.BingzhongNum=math.floor((idx[3]-idx[2])/CC.BingzhongSize)--±øÖÖ /¶ÁÈ¡newgamesave
JY.Data_Bingzhong=Byte.create(CC.BingzhongSize*JY.BingzhongNum)
Byte.loadfile(JY.Data_Bingzhong,CC.R_GRPFilename[0],idx[2],CC.BingzhongSize*JY.BingzhongNum)
for i=0,JY.BingzhongNum-1 do
JY.Bingzhong[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Bingzhong,i*CC.BingzhongSize,CC.Bingzhong_S,k,v)
end
}
setmetatable(JY.Bingzhong[i],meta_t)
end
JY.SceneNum=math.floor((idx[4]-idx[3])/CC.SceneSize)--³¡¾°
JY.Data_Scene=Byte.create(CC.SceneSize*JY.SceneNum)
Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3]-kodelta,CC.SceneSize*JY.SceneNum)
for i=0,JY.SceneNum-1 do
JY.Scene[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Scene,i*CC.SceneSize,CC.Scene_S,k,v)
end
}
setmetatable(JY.Scene[i],meta_t)
end
JY.ItemNum=math.floor((idx[5]-idx[4])/CC.ItemSize)--µÀ¾ß /¶ÁÈ¡newgamesave
JY.Data_Item=Byte.create(CC.ItemSize*JY.ItemNum)
Byte.loadfile(JY.Data_Item,CC.R_GRPFilename[id],idx[4]-kodelta,CC.ItemSize*JY.ItemNum-koItemShort)--ko 5.0 (10-13): an older save fills 0..199 (the type-0 fill below adds the new ones)
for i=0,JY.ItemNum-1 do
JY.Item[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Item,i*CC.ItemSize,CC.Item_S,k,v)
end
}
setmetatable(JY.Item[i],meta_t)
end
--ko item table is save-resident: fill "reserved" slots (type 0) that newgame.grp has since turned into real items (157~160 Liu Bang/Xiang Yu gear, 161 Mok-in's arm)
if id>0 then
local koItemBase=Byte.create(CC.ItemSize*JY.ItemNum)
Byte.loadfile(koItemBase,CC.R_GRPFilename[0],idx[4],CC.ItemSize*JY.ItemNum)
for i=1,JY.ItemNum-1 do
if JY.Item[i]["ÀàĞÍ"]==0 and GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,"ÀàĞÍ")~=0 then
for kok,_ in pairs(CC.Item_S) do
JY.Item[i][kok]=GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,kok)
end
end
end
--ko item name/description are display text, not game state: always take them from newgame.grp so renamed items show the new name in old saves too
for i=0,JY.ItemNum-1 do
JY.Item[i]["Ãû³Æ"]=GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,"Ãû³Æ")
CC.koItemSk0=CC.koItemSk0 or {} CC.koItemSk0[i]=GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,"ÌØ¼¼")--ko 5.0: the new game's item skill (tiangong erase)
JY.Item[i]["ËµÃ÷"]=GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,"ËµÃ÷")
end
end
--ko 161 (Mok-in exclusive weapon) for saves made before it existed: hand it over once (event 1997) when nobody holds it
if id>0 and JY.PersonNum>388 and (JY.Base["ÊÂ¼ş1997"] or 0)==0 then
local koHave=false
for i=1,JY.PersonNum-1 do
for n=1,8 do
if JY.Person[i]["µÀ¾ß"..n]==161 then
koHave=true
end
end
end
if not koHave then
for n=1,8 do
if JY.Person[388]["µÀ¾ß"..n]==0 then
JY.Person[388]["µÀ¾ß"..n]=161
break
end
end
end
JY.Base["ÊÂ¼ş1997"]=1
end
--ko 3.6: the new generals' exclusive treasures (162~168) for saves made before them: once (event 1980), into the owner's bag when nobody holds it
if id>0 and (JY.Base["\202\194\188\2541980"] or 0)==0 then
for _,koT in ipairs({{162,409},{163,410},{164,411},{165,412},{166,390},{167,389},{168,413}}) do
if JY.PersonNum>koT[2] and JY.ItemNum>koT[1] then
local koHave=false
for i=1,JY.PersonNum-1 do
local q=JY.Person[i]
if q["\206\228\198\247"]==koT[1] or q["\183\192\190\223"]==koT[1] or q["\184\168\214\250"]==koT[1] then koHave=true end
for n=1,8 do if q["\181\192\190\223"..n]==koT[1] then koHave=true end end
end
if not koHave then
for n=1,8 do
if JY.Person[koT[2]]["\181\192\190\223"..n]==0 then
JY.Person[koT[2]]["\181\192\190\223"..n]=koT[1]
break
end
end
end
end
end
JY.Base["\202\194\188\2541980"]=1
end
--ko 3.6: the new generals' exclusive treasures (169, To-in) for saves made before them: once (event 1982), into the owner's bag when nobody holds it
if id>0 and (JY.Base["\202\194\188\2541982"] or 0)==0 then
for _,koT in ipairs({{169,414}}) do
if JY.PersonNum>koT[2] and JY.ItemNum>koT[1] then
local koHave=false
for i=1,JY.PersonNum-1 do
local q=JY.Person[i]
if q["\206\228\198\247"]==koT[1] or q["\183\192\190\223"]==koT[1] or q["\184\168\214\250"]==koT[1] then koHave=true end
for n=1,8 do if q["\181\192\190\223"..n]==koT[1] then koHave=true end end
end
if not koHave then
for n=1,8 do
if JY.Person[koT[2]]["\181\192\190\223"..n]==0 then
JY.Person[koT[2]]["\181\192\190\223"..n]=koT[1]
break
end
end
end
end
end
JY.Base["\202\194\188\2541982"]=1
end
--ko 3.6 later: the exclusive treasures (175 Sima Hui, 176 Huang Yueying) for saves made before them: once (event 1961), into the owner's bag when nobody holds it
if id>0 and (JY.Base["\202\194\188\2541961"] or 0)==0 then
for _,koT in ipairs({{175,382},{176,415}}) do
if JY.PersonNum>koT[2] and JY.ItemNum>koT[1] then
local koHave=false
for i=1,JY.PersonNum-1 do
local q=JY.Person[i]
if q["\206\228\198\247"]==koT[1] or q["\183\192\190\223"]==koT[1] or q["\184\168\214\250"]==koT[1] then koHave=true end
for n=1,8 do if q["\181\192\190\223"..n]==koT[1] then koHave=true end end
end
if not koHave then
for n=1,8 do
if JY.Person[koT[2]]["\181\192\190\223"..n]==0 then
JY.Person[koT[2]]["\181\192\190\223"..n]=koT[1]
break
end
end
end
end
end
JY.Base["\202\194\188\2541961"]=1
end
--ko koOldCopy3 (5.1.9, 10-16): 181~195 are unused old copies of treasures (same name, no bonus, no skill). The story data gave most Wei/Wu
--ko   generals two as dummy gear (184+195 / 181+191); 4.0~5.1.8 turned them real for every record (enemies fought with them, Xiahou Lan
--ko   brought them along). Now nobody holds them: a copy is dropped from every record on each load (newgame too), and on a record not ours
--ko   the real one standing where its newgame record has the copy is dropped too (and an equipped real one it no longer holds).
--ko   Real ones our generals already hold stay.
do
local koReal={[181]=4,[182]=5,[183]=10,[184]=11,[185]=12,[186]=13,[187]=14,[188]=15,[189]=16,[190]=58,[191]=59,[192]=60,[193]=61,[194]=62,[195]=63}
local koIsReal={} for _,r in pairs(koReal) do koIsReal[r]=true end
local koPS=CC.PersonSize
local koN0=(id>0) and math.min(JY.PersonNum,math.floor((idx[2]-idx[1])/koPS)) or 0
local koB
if koN0>0 then koB=Byte.create(koPS*koN0) Byte.loadfile(koB,CC.R_GRPFilename[0],idx[1],koPS*koN0) end
local koK={"\181\192\190\2231","\181\192\190\2232","\181\192\190\2233","\181\192\190\2234","\181\192\190\2235","\181\192\190\2236","\181\192\190\2237","\181\192\190\2238"}
for i=1,JY.PersonNum-1 do
local q=JY.Person[i]
local ours=q["\190\253\214\247"]==1
local koHas={}
for _,k in ipairs(koK) do
local v=q[k]
if koReal[v] then q[k]=0
elseif (not ours) and i<koN0 and koReal[GetDataFromStruct(koB,i*koPS,CC.Person_S,k)]==v then q[k]=0
end
koHas[q[k]]=true
end
for _,k in ipairs({"\206\228\198\247","\183\192\190\223","\184\168\214\250"}) do local v=q[k] if koReal[v] or ((not ours) and koIsReal[v] and not koHas[v]) then q[k]=0 end end
end
end
--ko koChochok (5.1.9, 10-16): Jiao Chu is light cavalry since the 10-11 sprite classes (no water strategy), so ìˆ˜ê³„ (11) -> ê°•ê¸° (25), ê°•ê¶ (24) -> í–¥ë„ (118), í™”ê³„ (12) -> ë³´ë³µ (19) â€” newgame, saves and tavern copies
for koI=1,JY.PersonNum-1 do local koP=JY.Person[koI] if koP["\208\213\195\251"]=="\131\124\135\123" then for koS=1,6 do local koV=({[11]=25,[24]=118,[12]=19})[koP["\204\216\188\188"..koS]] if koV then koP["\204\216\188\188"..koS]=koV end end end end
--ko 5.0: Guan Yu / Zhang Fei innate skill: their starting weapons give the same skill, so 105 -> 108 and 107 -> 113 (saves too)
if id>0 then for _,koG in ipairs({{2,105,108},{3,107,113}}) do if JY.PersonNum>koG[1] and JY.Person[koG[1]]["Ìì¸³"]==koG[2] then JY.Person[koG[1]]["Ìì¸³"]=koG[3] end end end

JY.MagicNum=math.floor((idx[6]-idx[5])/CC.MagicSize)--²ßÂÔ /¶ÁÈ¡newgamesave
JY.Data_Magic=Byte.create(CC.MagicSize*JY.MagicNum)
Byte.loadfile(JY.Data_Magic,CC.R_GRPFilename[0],idx[5],CC.MagicSize*JY.MagicNum)
for i=0,JY.MagicNum-1 do
JY.Magic[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Magic,i*CC.MagicSize,CC.Magic_S,k,v)
end
}
setmetatable(JY.Magic[i],meta_t)
end
JY.SkillNum=math.floor((idx[7]-idx[6])/CC.SkillSize)--ÌØ¼¼ /¶ÁÈ¡newgamesave
JY.Data_Skill=Byte.create(CC.SkillSize*JY.SkillNum)
Byte.loadfile(JY.Data_Skill,CC.R_GRPFilename[0],idx[6],CC.SkillSize*JY.SkillNum)
for i=0,JY.SkillNum-1 do
JY.Skill[i]={}
local meta_t={
__index=function(t,k)
return GetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k)
end,
__newindex=function(t,k,v)
SetDataFromStruct(JY.Data_Skill,i*CC.SkillSize,CC.Skill_S,k,v)
end
}
setmetatable(JY.Skill[i],meta_t)
end
koSyncPromotionItems()
collectgarbage()
lib.Debug(string.format("Loadrecord%d time=%d",id,lib.GetTime()-t1))
JY.Smap={}
for i=1,JY.SceneNum-1 do
if JY.Scene[i]["ÈËÎï"]>0 then
AddPerson(JY.Scene[i]["ÈËÎï"],JY.Scene[i]["×ø±êX"],JY.Scene[i]["×ø±êY"],JY.Scene[i]["·½Ïò"])
end
end
JY.SubScene=JY.Base["µ±Ç°³¡¾°"]
JY.EventID=JY.Base["µ±Ç°ÊÂ¼ş"]
JY.CurrentBGM=JY.Base["µ±Ç°ÒôÀÖ"]
JY.LLK_N=0
if CC.font==1 then
CC.FontName=CONFIG.FontName2
else
CC.FontName=CONFIG.FontName
end
if id>0 then
if koWar then--ko: loaded while a battle was running (retreat reload, or the in-battle load menu)
if JY.Base["Õ½³¡´æµµ"]==1 then
koWar.base=JY.Base["ÊÂ¼ş1999"] or 0
else
koWar.abort=true
end
end
if ((JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_START) and JY.Base["Õ½³¡´æµµ"]==0) then
DrawSMap()
end
JY.Status=JY.Base["µ±Ç°×´Ì¬"]
if JY.Base["Õ½³¡´æµµ"]==1 then
 WarLoad(id)
end
if JY.CurrentBGM>=0 then
PlayBGM(JY.CurrentBGM)
end
Light()
end
end

function fileexist(filename)--¼ì²âÎÄ¼şÊÇ·ñ´æÔÚ
local inp=io.open(filename,"rb")
if inp==nil then
return false
end
inp:close()
return true
end

--ko …fƒa ‚n„Q(data\save)^ ‚aƒmA „VƒRƒd, ƒ[†GD „P q ‚aƒmA false ‚h ‰Bƒ`ƒeM
--ko (ƒQ„vƒb ‚AƒGf NOB nil G‚SD ƒ[‚_„S ‰lƒW †D QRS †u‚j‚b „A…y QRG ŒMƒF‚M)
function copyfile(source,destination)
local sourcefile=io.open(source,"rb")
if sourcefile==nil then
return false
end
local destinationfile=io.open(destination,"wb")
if destinationfile==nil then
if CONFIG.Windows then pcall(os.execute,'mkdir "'..string.sub(CONFIG.Save,1,-2)..'" >nul 2>&1') else pcall(os.execute,'mkdir -p "'..string.sub(CONFIG.Save,1,-2)..'"') end--ko: android has no >nul
destinationfile=io.open(destination,"wb")
end
if destinationfile==nil then
sourcefile:close()
return false
end
destinationfile:write(sourcefile:read("*a"))
sourcefile:close()
destinationfile:close()
return true
end

-- Ğ´ÓÎÏ·½ø¶È
-- id=0 ĞÂ½ø¶È£¬=1/2/3 ½ø¶È
--ko …fƒa †V…IS „P q ‚aS „U(‚n„Q ‚a‚M¡¤FƒG ‚B„o ‚n„Q …}) ‚oƒ_†gS I‡SM
local function koSaveFail()
WarDrawStrBoxConfirm("…fƒa †V…IS „VƒR q ‚aKLM.*QRS ƒUŒm @A …}*„P q „O‚b ‡Eƒm„S ‹ZŒI ‡D*M‚V N‚]B ‚KƒoZ.",M_White,JY.Status~=GAME_WMAP)
end
function SaveRecord(id)-- Ğ´ÓÎÏ·½ø¶È
koHook("record_save")--ko 3.1
local t1=lib.GetTime()
if JY.Status==GAME_WMAP then
JY.Base["Õ½³¡´æµµ"]=1
else
JY.Base["Õ½³¡´æµµ"]=0
end
JY.Base["Ê±¼ä"]=string.sub(os.date("%m/%d/%y %X"),0,14)
JY.Base["µ±Ç°×´Ì¬"]=JY.Status
JY.Base["µ±Ç°ÊÂ¼ş"]=JY.EventID
JY.Base["µ±Ç°³¡¾°"]=JY.SubScene
JY.Base["µ±Ç°ÒôÀÖ"]=JY.CurrentBGM
for i=1,JY.SceneNum-1 do
JY.Scene[i]["ÈËÎï"]=0
JY.Scene[i]["×ø±êX"]=0
JY.Scene[i]["×ø±êY"]=0
JY.Scene[i]["·½Ïò"]=0
end
local n=#JY.Smap
for i=1,math.min(n,JY.SceneNum-1) do
JY.Scene[i]["ÈËÎï"]=JY.Smap[i][1]
JY.Scene[i]["×ø±êX"]=JY.Smap[i][2]
JY.Scene[i]["×ø±êY"]=JY.Smap[i][3]
JY.Scene[i]["·½Ïò"]=JY.Smap[i][4]
end
local data=Byte.create(4*8)
--¶ÁÈ¡savedata
Byte.set16(data,0,CC.font)
Byte.set16(data,2,CC.MusicVolume)
Byte.set16(data,4,CC.SoundVolume)
Byte.set16(data,6,CC.zdby)
Byte.set16(data,8,CC.cldh)
Byte.set16(data,10,CC.MoveSpeed)
Byte.savefile(data,CC.SavedataFile,0,4*8)
--¶ÁÈ¡R*.idxÎÄ¼ş
Byte.loadfile(data,CC.R_IDXFilename[0],0,4*8)
local idx={}
idx[0]=100
for i=1,8 do
idx[i]=Byte.get32(data,4*(i-1))
end
--Ğ´R*.grpÎÄ¼ş
if not copyfile(CC.R_GRPFilename[0],CC.R_GRPFilename[id]) then
lib.Debug("SaveRecord fail: "..CC.R_GRPFilename[id])
koSaveFail()
return false
end
Byte.savefile(JY.Data_Base,CC.R_GRPFilename[id],idx[0],idx[1]-idx[0])
Byte.savefile(JY.Data_Person,CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
Byte.savefile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum)
Byte.savefile(JY.Data_Item,CC.R_GRPFilename[id],idx[4],CC.ItemSize*JY.ItemNum)
lib.Debug(string.format("SaveRecord time=%d",lib.GetTime()-t1))
return true
end

function GetDataFromStruct(data,offset,t_struct,key)--´ÓÊı¾İµÄ½á¹¹ÖĞ·­ÒëÊı¾İ£¬ÓÃÀ´È¡Êı¾İ
local t=t_struct[key]
local r
if t[2]==0 then
if t[3]==1 then
r=Byte.get8(data,t[1]+offset)
else
r=Byte.get16(data,t[1]+offset)
end
elseif t[2]==1 then
r=Byte.getu16(data,t[1]+offset)
elseif t[2]==2 then
if CC.SrcCharSet==1 then
r=lib.CharSet(Byte.getstr(data,t[1]+offset,t[3]),0)
else
r=Byte.getstr(data,t[1]+offset,t[3])
end
end
return r
end

function SetDataFromStruct(data,offset,t_struct,key,v)--´ÓÊı¾İµÄ½á¹¹ÖĞ·­ÒëÊı¾İ£¬±£´æÊı¾İ
local t=t_struct[key]
if t[2]==0 then
if t[3]==1 then
Byte.set8(data,t[1]+offset,v)
else
Byte.set16(data,t[1]+offset,v)
end
elseif t[2]==1 then
Byte.setu16(data,t[1]+offset,v)
elseif t[2]==2 then
local s
if CC.SrcCharSet==1 then
s=lib.CharSet(v,1)
else
s=v
end
Byte.setstr(data,t[1]+offset,t[3],s)
end
end

function GetPersonData(offset,t_struct,key)
if t_struct[key][4] then
return GetDataFromStruct(JY.Data_Person,offset,t_struct,key)
else
return GetDataFromStruct(JY.Data_Person_Base,offset,t_struct,key)
end
end

function between(v,Min,Max)
if Min>Max then
Min,Max=Max,Min
end
if v>=Min and v<=Max then
return true
end
return false
end

function Light()--³¡¾°±äÁÁ
if JY.Dark then
JY.Dark=false
lib.ShowSlow(CC.FrameNum,0)
lib.GetKey()
end
end

function Dark()--³¡¾°±äºÚ
if not JY.Dark then
JY.Dark=true
lib.ShowSlow(CC.FrameNum,1)
lib.GetKey()
end
end

--²¥·ÅMP3
function PlayBGM(id)
id=id or 0
JY.CurrentBGM=id
if JY.EnableMusic==0 then
return 
end
if id>=0 and id<=35 then
lib.PlayMIDI(string.format(CC.BGMFile,id))
end
end

function StopBGM()
JY.CurrentBGM=-1
lib.PlayMIDI("")
end

--²¥·ÅÒôĞ§e**
function PlayWavE(id)--²¥·ÅÒôĞ§e**
if JY.EnableSound==0 then
return 
end
if id>=0 then
lib.PlayWAV(string.format(CC.EFile,id))
end
end

--²úÉú¶Ô»°ÏÔÊ¾ĞèÒªµÄ×Ö·û´®£¬¼´Ã¿¸ôn¸öÖĞÎÄ×Ö·û¼ÓÒ»¸öĞÇºÅ
function GenTalkString(str,n)--²úÉú¶Ô»°ÏÔÊ¾ĞèÒªµÄ×Ö·û´®
local tmpstr=""
local num=0
for s in string.gmatch(str .. "*","(.-)%*") do--È¥µô¶Ô»°ÖĞµÄËùÓĞ*. ×Ö·û´®Î²²¿¼ÓÒ»¸öĞÇºÅ£¬±ÜÃâÎŞ·¨Æ¥Åä
tmpstr=tmpstr .. s
end
local newstr=""
while #tmpstr>0 do
num=num+1
local w=0
while w<#tmpstr do
local v=string.byte(tmpstr,w+1)--µ±Ç°×Ö·ûµÄÖµ
if v>=128 then
w=w+2
else
w=w+1
end
if w >=2*n-1 then--ÎªÁË±ÜÃâ¿ç¶ÎÖĞÎÄ×Ö·û
break
end
end
if w<#tmpstr then
if w==2*n-1 and string.byte(tmpstr,w+1)<128 then
newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*"
tmpstr=string.sub(tmpstr,w+2,-1)
else
local koC=w
local koS=0
if string.byte(tmpstr,koC+1)==32 then
koS=1
else
local koK=koC
while koK>1 do
if string.byte(tmpstr,koK)==32 then break end
koK=koK-1
end
if koK>1 and koK*5>=koC*3 then koC=koK-1 koS=1 end
end
newstr=newstr .. string.sub(tmpstr,1,koC) .. "*"
tmpstr=string.sub(tmpstr,koC+1+koS,-1)
end
else
newstr=newstr .. tmpstr
break
end
end
return newstr,num
end

--ko …m…n†g ŒG/‡f‚_‚h ƒQa‚b „^ƒG„S G‚S ŒEb ƒ[uƒG ‚no DƒO†w
--o cS v‚Eƒm„S ƒv„IM. v‚E = {…x‚h ‚VJ, …x‚h ‹[, ƒ[‚O ‹^S ‚n„Q}
--ƒ[‚OƒsM CƒmA ‹I‡D ‚[ v‚Eƒm„S, †rA ‹Iv‚E + ^‡S…h …A‚D + ^v‚Eƒm„S …^‡SM
local function koSeg(p,len,ilen,ins,t)
if len<=ilen then
local half=math.modf(len/2)
t[1]={p,p+half,p}
t[2]={p+half,p+len,p+len-ilen}
return 2
end
local step=math.modf((ilen-2*ins)/2)*2
if step<2 then step=2 end
local n=1
local L=p+ilen-ins
local R=p+len-ilen+ins
t[1]={p,L,p}
for k=1,60 do
if L>=R then break end
local q=p+k*step
local b=q+ilen-ins
if b>R then b=R end
if b>L then
n=n+1
t[n]={L,b,q}
L=b
end
end
n=n+1
t[n]={R,p+len,p+len-ilen}
return n
end
--ko ŒG ƒ[‚O(iw x ih)S (x1,y1) ‚^ƒh w x h „^ƒG„S ƒ[ƒjM. ‚ZƒWu ƒa‚yƒb ƒ[‚_„S ‚[ƒd ^ƒa…xu‡z ^‡S…h„V …A‚D
local function koFrame(pic,iw,ih,x1,y1,w,h,ins)
ins=ins or 12
local hx={}
local vy={}
local nx=koSeg(x1,w,iw,ins,hx)
local ny=koSeg(y1,h,ih,ins,vy)
for i=1,nx do
for j=1,ny do
if hx[i][2]>hx[i][1] and vy[j][2]>vy[j][1] then
lib.SetClip(hx[i][1],vy[j][1],hx[i][2],vy[j][2])
lib.PicLoadCache(4,pic,hx[i][3],vy[j][3],1)
lib.SetClip(0,0,0,0)
end
end
end
end
--ko …m…n ‡f‚_(e‹J 2px ^ƒa…xu + 6px ‚KƒG ƒ[‚O, [‡M‹J ^ƒa…xu ‚a‚M)‚h ƒQa‚b „cƒm„S ƒXƒjM
local function koBarW(pic,iw,bx,bw,by)
if bw<=iw then
lib.SetClip(bx,by,bx+bw,by+22)
lib.PicLoadCache(4,pic,bx,by,1)
lib.SetClip(0,0,0,0)
return
end
local step=math.modf((iw-4)/6)*6
if step<6 then step=6 end
local L=bx+iw-2
local R=bx+bw-iw+2
lib.SetClip(bx,by,L,by+22)
lib.PicLoadCache(4,pic,bx,by,1)
lib.SetClip(0,0,0,0)
for k=1,60 do
if L>=R then break end
local p=bx+k*step
local b=p+iw-2
if b>R then b=R end
if b>L then
lib.SetClip(L,by,b,by+22)
lib.PicLoadCache(4,pic,p,by,1)
lib.SetClip(0,0,0,0)
L=b
end
end
lib.SetClip(bx+bw-iw+2,by,bx+bw,by+22)
lib.PicLoadCache(4,pic,bx+bw-iw,by,1)
lib.SetClip(0,0,0,0)
end
--ko ‡gƒc t…x^ ŒGƒsM †rA ŒG „cS 6px †M‚n„S ˆ_‰oM
--(6px †M‚n‚f…E ‡f‚_‡z ‚nn†G ^ƒa…xu ƒ[‚OG ƒW„S ŠG‚bM)
local function koMenuW(menu,n,w,size)
local need=0
for i=1,n do
local t=menu[i][1]
while true do
if string.sub(t,1,1)==" " then t=string.sub(t,2)
elseif string.sub(t,1,2)=="\161\161" then t=string.sub(t,3)
else break end
end
while string.len(t)>0 and string.sub(t,string.len(t),string.len(t))==" " do t=string.sub(t,1,string.len(t)-1) end
local tw=0
local ci=1
local cn=string.len(t)
while ci<=cn do
local cb=string.byte(t,ci)
if cb>=129 and cb<=254 and ci<cn then tw=tw+size ci=ci+2 else tw=tw+size/2 ci=ci+1 end
end
if tw>need then need=tw end
end
need=need+18
if need>w then
w=w+math.modf((need-w+5)/6)*6
end
if w>CC.ScreenW-48 then w=CC.ScreenW-48 end
return w
end
-- ko 5.0: dedicated camp chronicle background for in-game save prompts.
function koSaveBack()
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
lib.PicLoadCache(4,272*2,ox,oy,1)
end
function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--Í¨ÓÃ²Ëµ¥º¯Êı
if isBox==20 and rawget(_G,"koRemindSave") then
koSaveBack()
elseif JY.Status==GAME_START then
koTitleStill()--ko 6.0 campaigns (11-01): the current story's logo, not the old title picture
local mstr="|}‚C ~‚@‚B ‚D‚E‚F"
local msize=50
--ko title image
mstr="v"..JY.Base["µµ°¸°æ±¾"]
--ko title image
local msize=40
mstr="‚G‚H‚F"
--ko title image
local msize=15
mstr="dJ: ‚I‚J‚K"
--ko title image
end
local w=0
local h=0--±ß¿òµÄ¿í¸ß
local i=0
local num=0--Êµ¼ÊµÄÏÔÊ¾²Ëµ¥Ïî
local newNumItem=0--ÄÜ¹»ÏÔÊ¾µÄ×Ü²Ëµ¥ÏîÊı
size=size or CC.Fontbig
size=16
color=color or M_Orange
selectColor=selectColor or M_White
lib.GetKey()
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local newMenu={}-- ¶¨ÒåĞÂµÄÊı×é£¬ÒÔ±£´æËùÓĞÄÜÏÔÊ¾µÄ²Ëµ¥Ïî
--¼ÆËãÄÜ¹»ÏÔÊ¾µÄ×Ü²Ëµ¥ÏîÊı
for i=1,numItem do
if menuItem[i][3]>0 then
newNumItem=newNumItem+1
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i,1}--ĞÂÊı×é¶àÁË[4],±£´æºÍÔ­Êı×éµÄ¶ÔÓ¦
--ĞÂÊı×é¶àÁË[5], ´ú±í¶ÔÆë 123 ×óÖĞÓÒ
if string.sub(menuItem[i][1],1,1)=="@" then
newMenu[newNumItem][1]=string.sub(menuItem[i][1],2)
newMenu[newNumItem][5]=2
end
end
end
--¼ÆËãÊµ¼ÊÏÔÊ¾µÄ²Ëµ¥ÏîÊı
if numShow==0 or numShow > newNumItem then
num=newNumItem
else
num=numShow
end
--¼ÆËã±ß¿òÊµ¼Ê¿í¸ß
local maxlength=0
if x2==0 and y2==0 then
for i=1,newNumItem do
if string.len(newMenu[i][1])>maxlength then
maxlength=string.len(newMenu[i][1])
end
end
w=size*maxlength/2+2*CC.MenuBorderPixel--°´ÕÕ°ë¸öºº×Ö¼ÆËã¿í¶È£¬Ò»±ßÁô4¸öÏóËØ
h=(size+CC.RowPixel)*num+CC.MenuBorderPixel--×ÖÖ®¼äÁô4¸öÏóËØ£¬ÉÏÃæÔÙÁô4¸öÏóËØ
else
w=x2-x1
h=y2-y1
num=math.min(num,(math.modf(h/(size+CC.RowPixel))))
end
local start=1--ÏÔÊ¾µÄµÚÒ»Ïî
local current=0--µ±Ç°Ñ¡ÔñÏî
for i=1,newNumItem do
if newMenu[i][3]==2 then
current=i
break
end
end
if current > num then
start=1+current-num
end

if JY.Menu_keep then
start=JY.Menu_start
current=JY.Menu_current
end
local keyPress=-1
local returnValue=0
local x_off,y_off,row_off,h_off=0,0,0,0
if isBox==1 then
x_off=3
y_off=7
row_off=4
h_off=8
w=80
h=16+24*num
elseif isBox==2 then --¿ªÊ¼²Ëµ¥ÓÃ
x_off=4
y_off=6
row_off=4
h_off=8
w=144
h=16+24*num
elseif isBox==20 then--2µÄ¼Ó¿í°æ±¾£¬´æµµ¶ÁµµÓÃ
x_off=4
y_off=6
row_off=4
h_off=8
w=420
h=16+24*num
elseif isBox==3 then--baseon 2£¬µ÷Õû¿í¶È
x_off=4
y_off=6
row_off=4
h_off=8
w=math.max(96,size*maxlength/2+2*(x_off+CC.MenuBorderPixel)+6)--ko 3.0: fit the longest row
h=16+24*num
elseif isBox==4 then
x_off=11
y_off=9
row_off=0
h_off=12
w=112
h=16+8+20*num
elseif isBox==5 then--²ßÂÔ<=8ÓÃ
x_off=4
y_off=9
row_off=0
h_off=12
w=math.max(104,size*maxlength/2+2*(x_off+CC.MenuBorderPixel)+14)--ko 3.0: fit the longest row
h=16+8+20*num
elseif isBox==6 then--²ßÂÔ>8ÓÃ
x_off=4
y_off=9
row_off=0
h_off=12
w=120-20
h=16+8+20*num
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
if isBox==1 or isBox==2 or isBox==3 then
w=koMenuW(newMenu,newNumItem,w,size)
end
local menuHeight=h
local pagination=menuItem.koPagination
local footerHeight=44
if pagination then
w=160
h=16+24*pagination.rows+footerHeight
end
if x1==-1 or x1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x1=koMapCenterX(w)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x1=16+(640-w)/2
else
x1=(CC.ScreenW-w)/2
end
end
if y1==-1 or y1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y1=koMapCenterY(h)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y1=16+(400-h)/2
else
y1=(CC.ScreenH-h)/2
end
end

local pageButtons
local pageDelta
if pagination then
local buttonWidth=math.floor((w-20)/2)
local buttonY=y1+h-footerHeight-8
pageButtons={
 {x=x1+6,y=buttonY,w=buttonWidth,label="\129\071\130\066",delta=-1,enabled=pagination.page>1},
 {x=x1+w-8-buttonWidth,y=buttonY,w=buttonWidth,label="\129\077\130\077",delta=1,enabled=pagination.page<pagination.count},
}
end

local function redraw(flag)
-- ko 5.0: keep the title GIF alive behind the save list after LoadSur restores its snapshot.
if isBox==20 and rawget(_G,"koRemindSave") then koSaveBack()
elseif JY.Status==GAME_START and isBox==20 then koTitleAnimDraw() end--ko 5.0: not behind the after-battle save list (10-10)
if num~=0 then--ÔİÇÒÕâÑù¸Ä
if isBox==1 then
koFrame(0*2,80,256,x1,y1,w,16+24*num)
elseif isBox==2 then
koFrame(60*2,142,110,x1,y1,w,16+24*num)
elseif isBox==20 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,70*2,x1,y1,1)
lib.SetClip(0,0,0,0)
do--ko 3.0: rows 5.. up to the last three come from the picture's second row band
local yy=y1+8+24*4
local yend=y1+8+24*math.max(0,num-3)
while yy<yend do
lib.SetClip(x1,yy,x1+w,math.min(yy+24,yend))
lib.PicLoadCache(4,70*2,x1,yy-32,1)
yy=yy+24
end
lib.SetClip(0,0,0,0)
end
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,70*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
elseif isBox==3 then
koFrame(63*2,96,184,x1,y1,w,h)
elseif isBox==4 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==5 then
koFrame(66*2,104,384,x1,y1,w,h)--ko 3.0: stretched to w
elseif isBox==6 then
lib.SetClip(x1,y1,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-32,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
local nn=newNumItem-num
local nn_row=120
lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1)
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
end
for i=start,start+num-1 do
local drawColor=menuItem[newMenu[i][4]][6] or color
local menustr=newMenu[i][1]
local dx=0
if newMenu[i][5]==2 then
dx=size*(maxlength-string.len(menustr))/2/2
end
if isBox==1 or isBox==2 or isBox==3 then
menustr,dx=koCenter(menustr,w,x_off,size)
end
if i==current then
drawColor=selectColor
end
if isBox==1 then
if i==current then
koBarW(2*2,66,x1+6,w-14,y1+9+24*(i-1))
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
koBarW(1*2,66,x1+6,w-14,y1+9+24*(i-1))
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==2 then
if i==current then
koBarW(62*2,130,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
koBarW(61*2,130,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==20 then
if i==current then
lib.PicLoadCache(4,72*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
lib.PicLoadCache(4,71*2,x1+6,y1+8+24*(i-1),1)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==3 then
if i==current then
koBarW(65*2,82,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+dx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
koBarW(64*2,82,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==4 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==5 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+w-13,y1+12+20*(i-start+1),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
elseif isBox==6 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),M_White)
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
else
DrawString(x1+dx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),menustr,drawColor,size)
end
end
if pageButtons then
for _,button in ipairs(pageButtons) do
local highlighted=button.enabled and MOUSE.IN(button.x,button.y,button.x+button.w,button.y+22)
koBarW((highlighted and 65 or 64)*2,82,button.x,button.w,button.y)
DrawString(button.x+(button.w-#button.label*8)/2,button.y+3,button.label,button.enabled and color or M_Gray,size)
end
local pageText=string.format("(%d/%d)",pagination.page,pagination.count)
DrawString(x1+(w-#pageText*8)/2,pageButtons[1].y+25,pageText,color,size)
end
if flag then
lib.Background(x1,y1,x1+w,y1+h,128)
end
end
koMouseReset()
local wait=true
while wait do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid)
redraw()
ReFresh(0.4)
local eventtype,keyPress,mx,my=getkey()
if MOUSE.EXIT() then koExit() end
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
if JY.koMenuClose and MOUSE.CLICK(JY.koMenuClose[1],JY.koMenuClose[2],JY.koMenuClose[3],JY.koMenuClose[4]) then--ko: the button that opened this menu closes it again
wait=false
end
if wait and pageButtons then
for _,button in ipairs(pageButtons) do
if button.enabled and MOUSE.CLICK(button.x,button.y,button.x+button.w,button.y+22) then
pageDelta=button.delta
wait=false
PlayWavE(0)
break
end
end
end
if wait and mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+menuHeight-h_off then
current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off))
if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
local sel=limitX(start+current,1,newNumItem)
current=0
PlayWavE(0)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid)
redraw()
ReFresh(CC.OpearteSpeed/2)
if newMenu[sel][2]==nil then
returnValue=newMenu[sel][4]
wait=false
else
redraw()
JY.MenuPic.num=JY.MenuPic.num+1
JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h)
JY.MenuPic.x[JY.MenuPic.num]=x1
JY.MenuPic.y[JY.MenuPic.num]=y1
local r=newMenu[sel][2](newMenu[sel][4])--µ÷ÓÃ²Ëµ¥º¯Êı
lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num])
JY.MenuPic.num=JY.MenuPic.num-1
if r==1 then
returnValue=newMenu[sel][4]
wait=false
end
end
elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
else
current=0
end
elseif isBox==6 then
local nn=newNumItem-num
local nn_row=120
local nn_x=x1+99
local nn_y=y1+24+nn_row*start/nn
if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
nn_y=MOUSE.y-8
MOUSE.enableclick=false
start=1+math.modf((nn_y-y1-24)*nn/nn_row)
start=limitX(start,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
start=limitX(start-1,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
start=limitX(start+1,1,nn+1)
end
current=0
else
current=0
end
end
if returnValue==0 and not pageDelta then
PlayWavE(1)
end
if not JY.koMenuKeep then lib.LoadSur(sid) end--ko 5.0: the load list keeps itself drawn behind its confirm box
lib.FreeSur(sid)
if JY.Status==GAME_START and isBox==20 and not rawget(_G,"koRemindSave") then koTitleAnimRelease() end
if pageDelta then return 0,pageDelta end
return returnValue
end

function WarShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--Í¨ÓÃ²Ëµ¥º¯Êı
local w=0
local h=0--±ß¿òµÄ¿í¸ß
local i=0
local num=0--Êµ¼ÊµÄÏÔÊ¾²Ëµ¥Ïî
local newNumItem=0--ÄÜ¹»ÏÔÊ¾µÄ×Ü²Ëµ¥ÏîÊı
size=size or CC.Fontbig
size=16
color=color or M_Orange
selectColor=selectColor or M_White
lib.GetKey()
local newMenu={}-- ¶¨ÒåĞÂµÄÊı×é£¬ÒÔ±£´æËùÓĞÄÜÏÔÊ¾µÄ²Ëµ¥Ïî
--¼ÆËãÄÜ¹»ÏÔÊ¾µÄ×Ü²Ëµ¥ÏîÊı
for i=1,numItem do
if menuItem[i][3]>0 then
newNumItem=newNumItem+1
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i,koColor=menuItem[i].koColor}--ĞÂÊı×é¶àÁË[4],±£´æºÍÔ­Êı×éµÄ¶ÔÓ¦
end
end
--¼ÆËãÊµ¼ÊÏÔÊ¾µÄ²Ëµ¥ÏîÊı
if numShow==0 or numShow > newNumItem then
num=newNumItem
else
num=numShow
end
--¼ÆËã±ß¿òÊµ¼Ê¿í¸ß
local maxlength=0
if x2==0 and y2==0 then
for i=1,newNumItem do
if string.len(newMenu[i][1])>maxlength then
maxlength=string.len(newMenu[i][1])
end
end
w=size*maxlength/2+2*CC.MenuBorderPixel--°´ÕÕ°ë¸öºº×Ö¼ÆËã¿í¶È£¬Ò»±ßÁô4¸öÏóËØ
h=(size+CC.RowPixel)*num+CC.MenuBorderPixel--×ÖÖ®¼äÁô4¸öÏóËØ£¬ÉÏÃæÔÙÁô4¸öÏóËØ
else
w=x2-x1
h=y2-y1
num=math.min(num,(math.modf(h/(size+CC.RowPixel))))
end
local start=1--ÏÔÊ¾µÄµÚÒ»Ïî
local current=0--µ±Ç°Ñ¡ÔñÏî
for i=1,newNumItem do
if newMenu[i][3]==2 then
current=i
break
end
end
if current > num then
start=1+current-num
end
if JY.Menu_keep then
start=JY.Menu_start
current=JY.Menu_current
end
local keyPress=-1
local returnValue=0
local x_off,y_off,row_off,h_off=0,0,0,0
if isBox==1 then
x_off=3
y_off=7
row_off=4
h_off=8
w=80
h=16+24*num
elseif isBox==2 then
x_off=4
y_off=6
row_off=4
h_off=8
w=144
h=16+24*num
elseif isBox==3 then--baseon 2£¬µ÷Õû¿í¶È
x_off=4
y_off=6
row_off=4
h_off=8
w=math.max(96,size*maxlength/2+2*(x_off+CC.MenuBorderPixel)+6)--ko 3.0: fit the longest row
h=16+24*num
elseif isBox==4 then
x_off=11
y_off=9
row_off=0
h_off=12
w=112
h=16+8+20*num
elseif isBox==5 then--²ßÂÔ<=8ÓÃ
x_off=4
y_off=9
row_off=0
h_off=12
w=math.max(104,size*maxlength/2+2*(x_off+CC.MenuBorderPixel)+14)--ko 3.0: fit the longest row
h=16+8+20*num
elseif isBox==6 then--²ßÂÔ>8ÓÃ
x_off=4
y_off=9
row_off=0
h_off=12
w=120-20
h=16+8+20*num
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
if isBox==1 or isBox==2 or isBox==3 then
w=koMenuW(newMenu,newNumItem,w,size)
end
if x1==-1 then
x1=(CC.ScreenW-w)/2
end
if y1==-1 then
y1=(CC.ScreenH-h)/2
end
local function redraw(flag)
if num~=0 then--ÔİÇÒÕâÑù¸Ä
if isBox==1 then
koFrame(0*2,80,256,x1,y1,w,16+24*num)
elseif isBox==2 then
koFrame(60*2,142,110,x1,y1,w,16+24*num)
elseif isBox==3 then
koFrame(63*2,96,184,x1,y1,w,16+24*num)
elseif isBox==4 then
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,59*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
elseif isBox==5 then
koFrame(66*2,104,384,x1,y1,w,h)--ko 3.0: stretched to w
elseif isBox==6 then
lib.SetClip(x1,y1,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-32,x1+w+20,y1+h)
lib.PicLoadCache(4,67*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
local nn=newNumItem-num
local nn_row=120
lib.PicLoadCache(4,68*2,x1+98,y1+24+nn_row*(start-1)/nn,1)
elseif isBox==9 then
DrawBox(x1,y1,x1+w,y1+h,M_White)
end
end
for i=start,start+num-1 do
local drawColor=(newMenu[i].koColor or color)--ÉèÖÃ²»Í¬µÄ»æÖÆÑÕÉ«
local menustr=newMenu[i][1]
local koDx=0
if isBox==1 or isBox==2 or isBox==3 then
menustr,koDx=koCenter(menustr,w,x_off,size)
end
if i==current then
drawColor=(newMenu[i].koColor or selectColor)--ko 4.0: koColor (strategies short of MP in red)
end
if isBox==1 then
if i==current then
koBarW(2*2,66,x1+6,w-14,y1+9+24*(i-1))
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
koBarW(1*2,66,x1+6,w-14,y1+9+24*(i-1))
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==2 then
if i==current then
koBarW(62*2,130,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
koBarW(61*2,130,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==3 then
if i==current then
koBarW(65*2,82,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,1+y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
koBarW(64*2,82,x1+6,w-14,y1+8+24*(i-1))
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==4 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+99,y1+12+20*(i),M_White)
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==5 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+w-13,y1+12+20*(i-start+1),M_White)
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
elseif isBox==6 then
if i==current then
lib.DrawRect(x1+12,y1+12+20*(i-start),x1+91,y1+12+20*(i-start+1),M_White)
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
else
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
else
DrawString(x1+koDx+x_off+CC.MenuBorderPixel,y1+y_off+CC.MenuBorderPixel+(i-start)*(size+row_off+CC.RowPixel),
menustr,drawColor,size)
end
end
if flag then
lib.Background(x1,y1,x1+w,y1+h,128)
end
end
koMouseReset()
local wait=true
while wait do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
redraw()
if JY.koMenuTabs then JY.koMenuTabs.draw() end--ko 3.6: strategy tabs
ReFresh(0.4)
local eventtype,keyPress,mx,my=getkey()
if MOUSE.EXIT() then koExit() end
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
if JY.koMenuTabs and not JY.koMenuTabs.sel then local koT=JY.koMenuTabs.hit() if koT then JY.koMenuTabs.sel=koT PlayWavE(0) wait=false end end--ko 3.6: strategy tabs
if JY.koMenuClose and MOUSE.CLICK(JY.koMenuClose[1],JY.koMenuClose[2],JY.koMenuClose[3],JY.koMenuClose[4]) then--ko: the button that opened this menu closes it again
wait=false
end
if mx>x1+6 and mx<x1+w-6 and my>y1+h_off and my<y1+h-h_off then
current=math.modf((my-y1-h_off)/(size+CC.RowPixel+row_off))
if MOUSE.HOLD(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
elseif MOUSE.CLICK(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
local sel=limitX(start+current,1,newNumItem)
current=0
PlayWavE(0)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
redraw()
ReFresh(CC.OpearteSpeed)
if newMenu[sel][2]==nil then
returnValue=newMenu[sel][4]
wait=false
else
redraw()
JY.MenuPic.num=JY.MenuPic.num+1
JY.MenuPic.pic[JY.MenuPic.num]=lib.SaveSur(x1,y1,x1+w,y1+h)
JY.MenuPic.x[JY.MenuPic.num]=x1
JY.MenuPic.y[JY.MenuPic.num]=y1
local r=newMenu[sel][2](newMenu[sel][4])--µ÷ÓÃ²Ëµ¥º¯Êı
lib.FreeSur(JY.MenuPic.pic[JY.MenuPic.num])
JY.MenuPic.num=JY.MenuPic.num-1
if r==1 then
returnValue=newMenu[sel][4]
wait=false
end
end
elseif between(isBox,4,6) and MOUSE.IN(x1+7,y1+h_off+(size+CC.RowPixel+row_off)*current,x1+w-7,y1+h_off+(size+CC.RowPixel+row_off)*(current+1)) then
current=limitX(start+current,1,newNumItem)
else
current=0
end
elseif isBox==6 then
local nn=newNumItem-num
local nn_row=120
local nn_x=x1+99
local nn_y=y1+24+nn_row*start/nn
if MOUSE.HOLD(nn_x,y1+24,nn_x+12,y1+24+136) then
nn_y=MOUSE.y-8
MOUSE.enableclick=false
start=1+math.modf((nn_y-y1-24)*nn/nn_row)
start=limitX(start,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+9,nn_x+16,y1+24) then
start=limitX(start-1,1,nn+1)
elseif MOUSE.CLICK(nn_x,y1+161,nn_x+16,y1+176) then
start=limitX(start+1,1,nn+1)
end
current=0
else
current=0
end
end
if returnValue==0 and not (JY.koMenuTabs and JY.koMenuTabs.sel) then
PlayWavE(1)
end
return returnValue
end

function SRPG()
if CC.Enhancement then
for i=1,JY.PersonNum-1 do
if JY.Person[i]["ĞŞÁ¶"]==1 then
JY.Person[i]["ĞŞÁ¶"]=0
end
end
end
local step=4
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
Light()
koHook("war_begin")--ko 3.1
ReFresh()
WarCheckStatus()
local WEA={[0]="‚L‚M","‚L‚M","‚L‚M","‚N‚O","‚P","‚P","£¿"}
while JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn do
--µÚX»ØºÏ X
WarDrawStrBoxDelay(string.format('d%dp %s',War.Turn,WEA[War.Weather]),M_White)
WarCheckStatus()
koHook("turn_ready")--ko 5.0 (10-13): this turn's events are over, our phase is next (trial first strike)
--ÎÒ¾ü²Ù×÷
if JY.Status==GAME_WMAP then
WarDrawStrBoxDelay('‚Q‚RG‚S‚T C‚U',M_White)
War.ControlStatus='select'
War.ControlEnable=true
koHook("player_phase")--ko 3.6 later: our phase begins (rewind addon saves the turn here)
end
if rl_flag==1 then
	rl_flag=0
end
while JY.Status==GAME_WMAP do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
if CC.XYXS then
DrawString(8,CC.ScreenH-24,string.format("%d,%d",War.MX,War.MY),M_White,16)
end
ReFresh()
if opn() then
break
end
end
--AIĞĞ¶¯
if rl_flag==0 then
	if JY.Status==GAME_WMAP then
	koAutoSave()--ko 3.0: the player's turn is over, save before the enemy phase
	War.ControlStatus='AI'
	War.koSkip=false--ko 3.1: Space during the enemy phase sets it (the lib.GetKey wrapper asks the ai_key hook)
	if (CC.koSkipAI or 0)==1 then War.koSkip=true War.koSkipKeep=true end--ko 3.3 hotfix 5: CC.koSkipAI (enemy phase presentation skip setting): skipped from the start, the lines still shown
	War.koAI=true--ko 3.1: the enemy phase (ControlStatus changes inside WarMagic/WarAtk, so a flag of its own)
	War.koAIStart=lib.GetTime()--ko 3.1: presses in the first half second are ignored (a held í„´ ì¢…ë£Œ Space repeating into the phase)
	AI()
	War.koAI=false
	War.koSkip=false
	War.koSkipKeep=false
	end
	War.Turn=War.Turn+1--»ØºÏ+1

	

		if JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn then
			--Weather
			local wea=math.random(6)-1
			if War.Weather<wea then
				War.Weather=War.Weather+1
			elseif War.Weather>wea then
				War.Weather=War.Weather-1
			end
			if War.Weather==0 then
				War.Weather=5
			elseif War.Weather==5 then
				War.Weather=0
			end
--È«¾ü¿É²Ù×÷
			for i,v in pairs(War.Person) do
				if v.live then
					v.active=true
					WarResetStatus(i)
				end
			end
--»Ö¸´
			WarRest()
		end
	end
end
if JY.Status==GAME_WMAP and War.Turn>War.MaxTurn then
if koWar then koWar.lost=true end--ko: turn limit = defeat for the win counter
if War.Leader1==1 then
WarLastWords(GetWarID(1))
WarAction(18,GetWarID(1))
end
JY.Status=GAME_WARLOSE
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
end
koHook("war_end")--ko 3.1
Dark()
end

function ReFresh(n)
n=n or 1
local frame_t=CC.FrameNum*n
local t1,t2
t1=JY.ReFreshTime
t2=lib.GetTime()
if CC.FPS or CC.Debug==1 then
lib.FillColor(4,4,72,20,0)
if t2-t1<frame_t then
lib.DrawStr(4,4,string.format("FPS=%d",30),M_White,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
else
lib.DrawStr(4,4,string.format("FPS=%d",1050/(t2-t1)),M_White,16,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
end
if War.koSkip and not koSkipDue() then return end--ko 3.1: skipping the enemy phase: present only every 100 ms, never wait
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
if t2-t1<frame_t and not War.koSkip then
lib.Delay(frame_t+t1-t2)
end
end

-- ko 4.0 touch (android): a phone has no hover. koTouch() = the touch rules; koTouchForce lets the PC harness try them.
-- 1) picking a target: the first tap only aims (the preview shows), a second tap on the same target confirms
-- 2) the last tapped unit keeps its mini window (the tap that closes a message box would move the pointer away)
-- 3) holding a finger still on a unit for 0.5 s = its status window (same as the right click)
function koTouch()
return (not CONFIG.Windows) or rawget(_G,"koTouchForce")==true
end
function koTouchLong()
if not koTouch() or War.ControlStatus~="select" or MOUSE.status~='HOLD' or not MOUSE.koHoldT then return false end
if lib.GetTime()-MOUSE.koHoldT<500 or math.abs(MOUSE.x-MOUSE.hx)>12 or math.abs(MOUSE.y-MOUSE.hy)>12 then return false end
local x,y=MOUSE.x,MOUSE.y
if koOverUI(x,y) or not MOUSE.IN(War.OX,War.OY,War.OX+War.BoxWidth*War.MW,War.OY+War.BoxDepth*War.MD) then return false end
local tx=math.modf((x-War.OX)/War.BoxWidth)+War.CX
local ty=math.modf((y-War.OY)/War.BoxDepth)+War.CY
local uid=GetWarMap(tx,ty,2)
if not (uid>0 and War.Person[uid] and War.Person[uid].live and (not War.Person[uid].hide)) then return false end
MOUSE.status='IDLE'-- the lift that follows is not a click
MOUSE.koHoldT=nil
PlayWavE(0)
PersonStatus(War.Person[uid].id,"","",1)
koMouseReset()
return true
end
function koTouchPin()
local id=War.koPin
local v=id and War.Person[id]
if v and v.live and (not v.hide) and between(v.x,War.CX,War.CX+War.MW-1) and between(v.y,War.CY,War.CY+War.MD-1) then return id end
return 0
end
function koTouchAim(event)
if not koTouch() then return event end
if event==-1 then War.koAim=nil return event end
if event~=2 then return event end
local eid=GetWarMap(War.MX,War.MY,2)
local a=War.Person[War.SelID]
if GetWarMap(War.MX,War.MY,4)>0 and eid>0 and War.Person[eid] and a and ((War.Person[eid].enemy==a.enemy)==(War.koSelFriend==true)) then
local k=War.MX*1000+War.MY
if War.koAim==k then War.koAim=nil return 2 end
War.koAim=k
return 1-- hover: the effect area and the preview
end
War.koAim=nil
return event-- not a target: the original handling (its message)
end
function koTouchAimHint()
if not koTouch() or War.koAim==nil or War.koAim~=War.MX*1000+War.MY then return end
local s="\129\111 \130\087 \132\108 \134\117\130\106\129\065 \134\064\129\070"
local cx=War.OX+math.floor(War.BoxWidth*War.MW/2)
local y=War.OY+War.BoxDepth*War.MD-40
lib.Background(cx-#s*5-12,y-6,cx+#s*5+12,y+26,90)
DrawString(cx-#s*5,y,s,M_Yellow,20)
end

function control()
local eventtype,keypress,x,y=getkey()
x,y=MOUSE.x,MOUSE.y
if eventtype==1 then--ko 3.0: keyboard shortcuts
local kr=koHook("battle_key",keypress)--ko 3.1
if kr then return kr,x,y end
end
local px=0--ko 3.0: status panel offset in the wide layout
if koWide() and koPanelID()>0 then px=War.koPX or 0 elseif not koWide() then px=koFramePX() end
if eventtype==3 and keypress==3 then
-- ko 3.0 wide layout: right-click on a unit = its status window (the panel only shows on hover)
if koWide() and War.ControlStatus=="select" and (not koOverUI(x,y)) and MOUSE.IN(War.OX,War.OY,War.OX+War.BoxWidth*War.MW,War.OY+War.BoxDepth*War.MD) then
local tx=math.modf((x-War.OX)/War.BoxWidth)+War.CX
local ty=math.modf((y-War.OY)/War.BoxDepth)+War.CY
local uid=GetWarMap(tx,ty,2)
if uid>0 and War.Person[uid] and War.Person[uid].live and (not War.Person[uid].hide) then
MOUSE.status='IDLE'
PersonStatus(War.Person[uid].id,"","",1)
koMouseReset()
return 0,x,y
end
end
return -1
end
local pid=0
if War.SelID>0 then
pid=War.Person[War.SelID].id
elseif War.CurID>0 then
pid=War.Person[War.CurID].id
elseif War.LastID>0 then
pid=War.Person[War.LastID].id
end
if koTouchLong() then return 0,x,y end--ko 4.0 touch: long press on a unit
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White) then
WarDelay(CC.WarDelay)
JY.Status=GAME_END
koExit()--ko êµ°ì›…ë¡ (11-03): quit now; GAME_END alone let a story event run on past the battle (ì‚¬ìš©ì ã€Œì „íˆ¬ ì¤‘ x ë¡œ ë„ë©´ ë³´ë¬¼ì„ ë°›ìŒã€)
end
elseif War.ControlStatus=="select" and MOUSE.CLICK(16,8,79,23) then--ko: top-left button = same as right-click menu, dropped under the button
return -2
elseif koWide() and War.ControlStatus=="select" and MOUSE.CLICK(90,6,134,24) then--ko 3.0: wide top bar, our army list
koArmyList(false)
elseif koWide() and War.ControlStatus=="select" and MOUSE.CLICK(140,6,184,24) then--ko 3.0: wide top bar, enemy army list
koArmyList(true)
elseif koWide() and War.ControlStatus=="select" and koAddonBarClick() then--ko 3.1: registered bar buttons
elseif (not koWide()) and War.ControlStatus=="select" and pid>0 and MOUSE.CLICK(611+px,32,653+px,63) then--ko: leader box = unit status window (same as clicking the portrait)
PersonStatus(pid,"","",1)
elseif (not koWide()) and War.ControlStatus=="select" and MOUSE.CLICK(657+px,32,687+px,63) then--ko: our army list
koArmyList(false)
elseif (not koWide()) and War.ControlStatus=="select" and MOUSE.CLICK(689+px,32,719+px,63) then--ko: enemy army list
koArmyList(true)
elseif koMiniDrag(x,y) then--ko 3.6: minimap press / drag moves the view
elseif koMapDrag(x,y) then--ko 5.0 touch: finger drag moves the view
elseif koOverUI(x,y) then--ko 3.0: clicks on the floating panels never reach the map
War.InMap=false
elseif koEdgeScroll(x,y) then--ko: hold on the map border scrolls; corners scroll diagonally
elseif (not koWide()) and MOUSE.CLICK(616+px,81,680+px,161) then
PersonStatus(pid,"","",1)
elseif (not koWide()) and CC.Enhancement and pid>0 and MOUSE.CLICK(644+px,294,678+px,313) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][1] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼1"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif (not koWide()) and CC.Enhancement and pid>0 and MOUSE.CLICK(680+px,294,714+px,313) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][2] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼2"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif (not koWide()) and CC.Enhancement and pid>0 and MOUSE.CLICK(716+px,294,740+px,313) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][3] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼3"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif (not koWide()) and CC.Enhancement and pid>0 and MOUSE.CLICK(644+px,314,678+px,333) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][4] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼4"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif (not koWide()) and CC.Enhancement and pid>0 and MOUSE.CLICK(680+px,314,714+px,333) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][5] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼5"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif (not koWide()) and CC.Enhancement and pid>0 and MOUSE.CLICK(716+px,314,740+px,333) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][6] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼6"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif MOUSE.IN(War.OX,War.OY,War.OX+War.BoxWidth*War.MW,War.OY+War.BoxDepth*War.MD) and War.ControlStatus~="checkDX" then
local mx,my=math.modf((x-War.OX)/War.BoxWidth),math.modf((y-War.OY)/War.BoxDepth)
War.InMap=true
War.MX=mx+War.CX
War.MY=my+War.CY
War.CurID=GetWarMap(War.MX,War.MY,2)
if War.CurID>0 then
War.LastID=War.CurID
end
if MOUSE.CLICK(War.OX+War.BoxWidth*mx+1,War.OY+War.BoxDepth*my+1,War.OX+War.BoxWidth*(mx+1)-1,War.OY+War.BoxDepth*(my+1)-1) then
if koTouch() then War.koPin=(War.CurID>0) and War.CurID or nil end--ko 4.0 touch: pinned mini window
return 2,x,y
else
return 1,x,y
end
else
War.InMap=false
end
return 0,x,y
end

function BoxBack()
if War.SelID>0 then
War.MX=War.Person[War.SelID].x
War.MY=War.Person[War.SelID].y
local x,y
x=War.MX-math.modf(War.MW/2)
y=War.MY-math.modf(War.MD/2)
x=limitX(x,1,War.Width-War.MW+1)
y=limitX(y,1,War.Depth-War.MD+1)
if War.CX<x and War.MX>War.CX+War.MW-4 then
for i=War.CX,x do
War.CX=i
WarDelay()
end
elseif War.CX>x and War.MX<War.CX+3 then
for i=War.CX,x,-1 do
War.CX=i
WarDelay()
end
end
if War.CY<y and War.MY>War.CY+War.MD-4 then
for i=War.CY,y do
War.CY=i
WarDelay()
end
elseif War.CY>y and War.MY<War.CY+3 then
for i=War.CY,y,-1 do
War.CY=i
WarDelay()
end
end
War.InMap=true
War.CurID=War.SelID
--War.CurID=0
WarDelay(CC.WarDelay)
end
end

function opn()
if War.ControlStatus=="select" and (War.koAutoAll or War.koAutoOff) then local koR=koAutoAllTurn() if koR~=false then return koR end end--ko 3.3: full delegation
local event,x,y=control()
if War.ControlStatus=="select" then
if x and between(x,16,79) and between(y,8,23) then
if MOUSE.status=='HOLD' then
War.FunButtom=2
else
War.FunButtom=1
end
else
War.FunButtom=0
end
if event==-2 then
War.FunButtom=0
return ESCMenu(16,32)
elseif event==-3 then--ko 3.0: shortcut key = one menu item
War.FunButtom=0
return ESCMenu(nil,nil,War.koKeyMenu)
elseif event==-1 then
War.FunButtom=0
War.koMenuAtMouse=true--ko 3.0: open the menu at the pointer
local koRows=10+#koAddon.warMenu--ko 5.0: real row count (9 + addon rows + Debug) and a wider box, so it is not cut at the right/bottom edge (10-10)
local koMW,koMH=130,16+24*koRows
local koMX,koMY=MOUSE.x-8,MOUSE.y-8
if koMY+koMH>CC.ScreenH then koMY=MOUSE.y+8-koMH end--ko 5.0: no room below: open upward from the pointer
if koMX+koMW>CC.ScreenW then koMX=MOUSE.x+8-koMW end--ko 5.0: no room on the right: open to the left
return ESCMenu(limitX(koMX,0,CC.ScreenW-koMW),limitX(koMY,0,CC.ScreenH-koMH))
elseif event==2 then
if War.CurID>0 then--Ñ¡ÔñÈË
if not War.Person[War.CurID].active and CC.WXXD==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('‚X‚YS ‚Z‚[ N‚]PKLM.',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].enemy and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('n‚T ‚^‚_^ n‚`LM.',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].friend and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('vJX q ‚a‚b ‚^‚_hLM.',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
elseif War.Person[War.CurID].troubled and CC.KZAI==false then
PlayWavE(2)
JY.ReFreshTime=lib.GetTime()
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
DrawWarMap()
ReFresh()
WarDrawStrBoxWaitKey('‚c‚d ‚eG‚f ‚C‚g‚h ‚i‚j‚C ‚kKLM.',M_White)
CleanWarMap(4,1)
CleanWarMap(10,0)
War.SelID=0
else
PlayWavE(0)
War.SelID=War.CurID
CleanWarMap(4,0)
CleanWarMap(10,0)
War_CalMoveStep(War.CurID,War.Person[War.CurID].movestep)
War_CalAtkFW(War.CurID)
War.ControlStatus="move"
end
elseif War.InMap then--·ÇÈË£¬µ«ÊÇÔÚµØÍ¼·¶Î§ÄÚ
PlayWavE(0)
War.DXpic=lib.SaveSur(War.OX+War.BoxWidth*(War.MX-War.CX),War.OY+War.BoxDepth*(War.MY-War.CY),War.OX+War.BoxWidth*(War.MX-War.CX+1),War.OY+War.BoxDepth*(War.MY-War.CY+1))
koMouseReset()
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
WarCheckDX()
ReFresh(0)
local eventtype,keypress=koPollKey()
if (eventtype==3 and keypress==3) or eventtype==1 or MOUSE.CLICK() then
break
end
end
PlayWavE(1)
lib.FreeSur(War.DXpic)
end
end
elseif War.ControlStatus=="checkDX" then
if event==2 or event==-1 then
PlayWavE(1)
lib.FreeSur(War.DXpic)
War.ControlStatus="select"
end
elseif War.ControlStatus=="move" then
if event==2 then
if not War.InMap then--²»ÔÚµØÍ¼·¶Î§ÄÚ
elseif War.Person[War.SelID].enemy and CC.KZAI==false then
--²»ÊÇÎÒ¾ü²¿¶Ó£®
PlayWavE(2)
WarDrawStrBoxWaitKey('n‚T ‚^‚_^ n‚`LM.',M_White)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
elseif War.Person[War.SelID].friend and CC.KZAI==false then
--²»ÄÜ²Ù×÷µÄ²¿¶Ó£®
PlayWavE(2)
WarDrawStrBoxWaitKey('vJX q ‚a‚b ‚^‚_hLM.',M_White)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
elseif GetWarMap(War.MX,War.MY,4)==0 or (GetWarMap(War.MX,War.MY,2)>0 and GetWarMap(War.MX,War.MY,2)~=War.SelID) then
--²»ÊÇÔÚÒÆ¶¯·¶Î§Àï£®
PlayWavE(2)
WarDrawStrBoxWaitKey('G‚l ‚m‚n ‚oG n‚`LM.',M_White)
else
CleanWarMap(10,0)
PlayWavE(0)
War.OldX=War.Person[War.SelID].x
War.OldY=War.Person[War.SelID].y
War_MovePerson(War.MX,War.MY)
War.ControlStatus="actionMenu"
CleanWarMap(4,1)
end
elseif event==-1 then
PlayWavE(1)
War.SelID=0
War.ControlStatus="select"
CleanWarMap(4,1)
CleanWarMap(10,0)
end
elseif War.ControlStatus=="actionMenu" then
local scl=War.SelID
local pid=War.Person[scl].id
BoxBack()
local menux,menuy=0,0
local mx=War.Person[War.SelID].x
local my=War.Person[War.SelID].y
if mx-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(mx-War.CX)-80
else
menux=War.OX+War.BoxWidth*(mx-War.CX+1)
end
local m={
{"¡¡‚J‚p",nil,1},
{"¡¡‚q‚r",nil,0},
{"¡¡‚s‚t",nil,0},
{"¡¡‚u‚v",WarMagicMenu,1},
{"¡¡D‚w",WarItemMenu,1},
{"¡¡‚_ƒG",nil,1},
{"‚R‚{EF",nil,0},
{"C‚|‚}‚D",nil,0},
{"‚~T‚tƒ@",nil,0},
{"ƒAƒBƒCƒD",nil,0},
}
local menu_num=4
local koFR=rawget(_G,"koFormMenuRow") and koFormMenuRow(scl) if koFR then m[11]=m[6] m[6]=koFR menu_num=menu_num+1 end--ko 5.0: formation row above wait (r 6/11 swapped back after the menu)
if CC.RWTS then
m[7][3]=1
m[8][3]=1
m[9][3]=1
m[10][3]=1
menu_num=menu_num+3
end
if (between(War.Person[scl].bz,4,6) or War.Person[scl].bz==22 or War.Person[scl].bz==33) and CC.Enhancement and WarCheckSkill(scl,44) then--ÂÒÉä
m[2][1]="¡¡"..JY.Skill[44]["Ãû³Æ"]
m[2][3]=1
menu_num=menu_num+1
end
if not (between(War.Person[scl].bz,4,6) or between(War.Person[scl].bz,21,22)) and CC.Enhancement and WarCheckSkill(scl,48) then--ÂÒÎè
m[2][1]="¡¡"..JY.Skill[48]["Ãû³Æ"]
if m[2][3]==0 then
menu_num=menu_num+1
end
m[2][3]=1
end
if CC.Enhancement and WarCheckSkill(scl,5) then--Ìì±ä
m[3][3]=1
menu_num=menu_num+1
end
menuy=math.min(War.OY+War.BoxDepth*(my-War.CY),CC.ScreenH-32-24*menu_num)
local r=WarShowMenu(m,#m,0,menux,menuy,0,0,1,1,16,M_White,M_White)
if koFR then if r==6 then r=11 elseif r==11 then r=6 end end--ko 5.0
WarDelay(CC.WarDelay)
if r==1 then
WarSetAtkFW(War.SelID,War.Person[War.SelID].atkfw)
War.koAtkSel=true--ko 3.0: preview popup while picking the target
local eid=WarSelectAtk(false,11)
War.koAtkSel=false
if eid>0 and rawget(_G,"koGuardSwap") then eid=koGuardSwap(scl,eid) end--ko 5.0 tank: a guard takes the hit (10-11)
if eid>0 then
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) and not WarCheckSkill(scl,105) then--ko 3.2: 105 also stops the 117 pre-emptive counter
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["¿É·´»÷"]==1 and JY.Bingzhong[War.Person[scl].bz]["±»·´»÷"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
xsgj=true
elseif WarCheckSkill(eid,42) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==42 then --·´»÷(ÌØ¼¼)
xsgj=true
end
end
end
end
if xsgj then
--¼ì²éÊÇ·ñÔÚ¹¥»÷·¶Î§ÄÚ
xsgj=false
local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,xs_arrary.num do
if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==scl then
xsgj=true
break
end
end
end
end
if xsgj then
--·´»÷¸ÅÂÊ£½ÎÒ¾üÎä½«ÎäÁ¦¡Â150
if CC.Enhancement and WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
--ko 3.2: the 102 counter now runs the 106 extra hit and the target's 103 riposte, like the other branches
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end

if CC.Enhancement and not WarCheckSkill(eid,105) and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)-(rawget(_G,"koFormCounter") and koFormCounter(eid) or 0)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
end
end
if JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid)
WarResetStatus(eid)
end
--»ìÂÒ¹¥»÷
if CC.Enhancement and WarCheckSkill(scl,116) then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
War.Person[eid].troubled=true
War.Person[eid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["ĞÕÃû"].."G(^) ‚c‚df ƒEƒFM!",M_White)
end
end
if JY.Status==GAME_WMAP and CC.Enhancement and WarCheckSkill(scl,130) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then--koFenzhan 6.0: fenzhan - every other foe in range takes one hit, kill or not (10-31)
local koFJ=WarGetAtkFW(War.Person[scl].x,War.Person[scl].y,War.Person[scl].atkfw)
local koFL={}
for n=1,koFJ.num do
if between(koFJ[n][1],1,War.Width) and between(koFJ[n][2],1,War.Depth) then
local e2=GetWarMap(koFJ[n][1],koFJ[n][2],2)
if e2>0 and e2~=eid and War.Person[e2] and War.Person[e2].live and (not War.Person[e2].hide) and War.Person[e2].enemy~=War.Person[scl].enemy and JY.Person[War.Person[e2].id]["±øÁ¦"]>0 then koFL[#koFL+1]=e2 end
end
end
for _,e2 in ipairs(koFL) do
if JY.Status~=GAME_WMAP or JY.Person[War.Person[scl].id]["±øÁ¦"]<=0 then break end
if War.Person[e2].live and JY.Person[War.Person[e2].id]["±øÁ¦"]>0 then
WarAtk(scl,e2)
WarResetStatus(e2)
end
end
end
--Òıµ¼¹¥»÷
local ydgj=0
if CC.Enhancement and WarCheckSkill(scl,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(scl,108) then
ydgj=1
end
if JY.Status~=GAME_WMAP then ydgj=0 end--koFollowStop 5.0: the battle already ended (10-10)
if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]<=0 then
War.YD=1
local koCE=War.ControlEnable--ko: AI_Sub leaves ControlEnable=false; keep the player's hover panel alive
AI_Sub(scl,1)
War.ControlEnable=koCE
end
elseif ydgj==2 then
local yd=eid
local koCE=War.ControlEnable--ko: same for the chain attack
while yd~=0 do
if JY.Person[War.Person[yd].id]["±øÁ¦"]<=0 then
yd=AI_Sub(scl,1)
else
break
end
end
War.ControlEnable=koCE
end
if JY.Status==GAME_WMAP and CC.Enhancement and (JY.Person[pid]["ÎäÆ÷"]==59 or WarCheckSkill(scl,114)) then--koFollowStop--Ó¢ĞÛÖ®½£ ´©´Ì¹¥»÷
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0
if dx>0 and dy==0 then--ÏÈÈ·¶¨±»¹¥»÷ÕßÔÚ¹¥»÷Õß×ó±ß·½Ïò
if GetWarMap(xx-1,yy,2)>0 then--È»ºóÈ·ÈÏÊÇ±»¹¥»÷Õß×ó±ßÄÇÒ»¸ñµÄ¶ÔÏó
eid2=GetWarMap(xx-1,yy,2)--»ñÈ¡ÕâÒ»¸ñµÄÈËÎïid±àºÅ
if War.Person[eid].enemy==War.Person[eid2].enemy then--×îºóÈ·¶¨¸ÃÈËÎïÓë±»¹¥»÷ÕßÍ¬ÕóÓª
WarAtk(scl,eid2)--¹¥»÷
WarResetStatus(eid2)
end
end
end
if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then--ÓÒ
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then--ÉÏ
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then--ÏÂ
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then--×óÉÏ
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then--ÓÒÉÏ
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then--×óÏÂ
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then--ÓÒÏÂ
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(scl,eid2)
WarResetStatus(eid2)
end
end
end
--·´»÷
local fsfj=false--×°±¸ÇàÁúÙÈÔÂµ¶µÄÈË²»ÊÇ¹ØÓğÊ±·âÉ±·´»÷
if CC.Enhancement and WarCheckSkill(scl,105) then --or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==105) then
fsfj=true
end
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
--Ö»ÓĞÔô±ø£¨É½Ôô¡¢¶ñÔô¡¢ÒåÔô£©ºÍÎäÊõ¼ÒÄÜ·´»÷µĞ¾üµÄÎïÀí¹¥»÷¡£
--¹¥»÷·½±øÖÖÎªÆï±ø¡¢Ôô±ø¡¢ÃÍÊŞ±øÍÅ¡¢ÎäÊõ¼Ò¡¢ÒìÃñ×åÊ±£¬²Å¿ÉÄÜ²úÉú·´»÷¡£
--¹¥»÷·½±øÖÖÎª²½±ø¡¢¹­±ø¡¢¾üÀÖ¶Ó¡¢ÑıÊõÊ¦¡¢ÔËÊä¶ÓÊ±£¬²»¿ÉÄÜ·¢Éú·´»÷¡£
--¹¥»÷·½ÎªĞÂÔö±øÖÖÊ±£¬¶¼¿ÉÒÔ²úÉú·´»÷
local fj_flag=false
if JY.Bingzhong[War.Person[eid].bz]["¿É·´»÷"]==1 and JY.Bingzhong[War.Person[scl].bz]["±»·´»÷"]==1 then
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
fj_flag=true
elseif CC.Enhancement and (WarCheckSkill(eid,42) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==42) then --·´»÷(ÌØ¼¼)
fj_flag=true
end
if fj_flag then
--¼ì²éÊÇ·ñÔÚ¹¥»÷·¶Î§ÄÚ
fj_flag=false
local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,fj_arrary.num do
if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==scl then
fj_flag=true
break
end
end
end
end
if fj_flag then
--·´»÷¸ÅÂÊ£½ÎÒ¾üÎä½«ÎäÁ¦¡Â150
if CC.Enhancement and WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
--ko 3.2: the 102 counter now runs the 106 extra hit and the target's 103 riposte, like the other branches
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(scl,103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)-(rawget(_G,"koFormCounter") and koFormCounter(eid) or 0)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
end
end
end
if War.Person[scl].live then
War.Person[scl].active=false
War.Person[scl].action=0
end
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
elseif r==2 then
local skillid=44
if m[2][1]=="¡¡"..JY.Skill[48]["Ãû³Æ"] then
skillid=48
end
WarSetAtkFW(scl,War.Person[scl].atkfw)
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo(string.format("%sG(^) ƒGƒH ¡º%s¡»S(‚h) ƒILM. ƒJƒKKLY?",JY.Person[pid]["ĞÕÃû"],JY.Skill[skillid]["Ãû³Æ"]),M_White) then
CleanWarMap(4,1)
local atkarray=WarGetAtkFW(War.Person[scl].x,War.Person[scl].y,War.Person[scl].atkfw)
local eidarray={}
local eidnum=0
for i=1,atkarray.num do
local ex=atkarray[i][1]
local ey=atkarray[i][2]
if between(ex,1,War.Width) and between(ey,1,War.Depth) then
local eid=GetWarMap(ex,ey,2)
if eid>0 then
if War.Person[scl].enemy~=War.Person[eid].enemy then
if (not War.Person[eid].hide) and War.Person[eid].live then
eidnum=eidnum+1
eidarray[eidnum]=eid
end
end
end
end
end
if eidnum==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey('‚J‚p ‚m‚n ‚of ƒL‚TG ‚aKLM.',M_White)
else
local n=math.random(2)
if skillid==44 then--ÂÒÉä
n=n+math.modf(eidnum/2)+math.random(3)-math.random(4)
elseif skillid==48 then--ÂÒÎè
n=n+eidnum-1+math.random(3)-math.random(4)
end
n=limitX(n,2,JY.Skill[skillid]["²ÎÊı1"])
for t=1,n do
local eid,index
if eidnum==0 then
break
elseif eidnum==1 then
index=1
else
index=math.random(eidnum)
end
eid=eidarray[index]
if War.Person[eid].live and War.Person[scl].live and (not War.Person[scl].troubled) then
if skillid==44 then--ÂÒÉä
WarAtk(scl,eid,2)
elseif skillid==48 then--ÂÒÎè
WarAtk(scl,eid,3)
end
WarResetStatus(eid)
end
if not War.Person[eid].live then
table.remove(eidarray,index)
eidnum=eidnum-1
end
end
if War.Person[scl].live then
War.Person[scl].active=false
War.Person[scl].action=0
end
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
else
CleanWarMap(4,1)
end
elseif r==3 then
WarDelay(CC.WarDelay)
if WarDrawStrBoxYesNo(JY.Person[pid]["ĞÕÃû"].."G(^) ƒGƒH ¡º‚s‚t¡»S ƒILM. ƒJƒKKLY?",M_White) then
local wzmenu={
{"¡¡ ‚L‚M",nil,1},
{"¡¡ ‚N‚O",nil,1},
{"¡¡ ‚P",nil,1},
}
if between(War.Weather,0,2) then
wzmenu[1][3]=0
elseif between(War.Weather,4,5) then
wzmenu[3][3]=0
else
wzmenu[2][3]=0
end
local r=ShowMenu(wzmenu,3,0,0,0,0,0,1,1,16,M_White,M_White)
if r>0 then
local str1={"‚BƒMaƒN ƒN‚YG‚Vb!*ƒOuƒP ƒGƒQS ƒR‚S ƒSƒT‚h ƒUƒV‚S ‚KmƒW!",
"aƒXf ƒOuƒP mƒQS ‚BaƒYL,*‚^ƒZ ƒ[ ƒ]S Gƒ^‚S ‚K‚V‚S,*ƒU‚f‚b ƒSƒT‚h ƒ_ƒ` ‚KmƒW.",
"ƒSƒT^ ‚taƒG ‚VJPM.*‚B ƒa‚~ƒb ‚Kƒcaƒd,*‚]‚lS ƒe‚Pa‚f.",
"ƒGƒOd‚h ƒe‚PoM.*‚Z‚[ Fƒfa‚f, ‚Cƒg‚^ƒh ƒGƒOd‚h ƒiƒjM.",
"aƒXG‚Vb! G ƒkƒlS ƒRƒmmƒW!*ƒn‚P‚h ƒ_ƒ` ƒoCf ƒbƒp‚h ƒqƒrmƒW!"}
local str2={"‚Z‚[ ƒsƒt‚b^?*GƒuG ƒvƒP ‚PƒHGM!*ƒwm qƒxƒP ƒ{{M.",
"ƒ{‚JGM!*GƒuG ƒ|jƒP ƒMƒ},*ƒSƒT‚h Mƒ~u‚b ƒN‚Po „@GM!",
"n‚K „Av„BQ g‚]„C‚S,*‚Z‚[^ „D‚f„EoM!",
"ƒn‚P^ „Fq„GG „HngM.",
"aa! ƒn‚PM!*aƒXG „IS „JM,*aƒXG ƒOu „KGM."}
if r==3 then
talk(pid,str1[math.random(5)])
else
talk(pid,str1[math.random(3)])
end
if math.random(100)<JY.Person[pid]["ÖÇÁ¦2"] then
if r==1 then
War.Weather=math.random(3)-1
elseif r==2 then
War.Weather=3
else
War.Weather=math.random(2)+3
end
PlayWavE(11)
WarDrawStrBoxWaitKey('ƒ{‚JPM.',M_White)
if r==3 then
talk(pid,str2[math.random(5)])
else
talk(pid,str2[math.random(3)])
end
else
PlayWavE(2)
WarDrawStrBoxWaitKey('NOPM.',M_White)
end
WarAddExp(scl,8)
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
return CheckActive()
end
end
elseif r==4 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==5 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==6 then
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==7 then
local djb={}
for i=1,99 do
djb[i]=i
end
local lv=LvMenu(djb)
if lv>0 then
JY.Person[pid]["µÈ¼¶"]=lv
end
elseif r==8 then
JY.Person[pid]["±øÁ¦"]=JY.Person[pid]["×î´ó±øÁ¦"]
JY.Person[pid]["Ê¿Æø"]=100
JY.Person[pid]["²ßÂÔ"]=JY.Person[pid]["×î´ó²ßÂÔ"]
elseif r==9 then
local bz=War.Person[scl].bz
local kofix=koFixedBZ(pid)
if kofix then
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒb(‚b) ‚B„o ‚~TG‚f ƒU†N q ‚aKLM.",M_White)
end
local bzmenu={}
for index=1,JY.BingzhongNum-1 do
 bzmenu[index]={fillblank(JY.Bingzhong[index]["Ãû³Æ"],11),nil,0}
if JY.Bingzhong[index]["ÓĞĞ§"]==1 and koBZAllowed(index,War.Person[scl].id) then --ko exclusive classes
 bzmenu[index][3]=1
end
end
local r=0
if not kofix then
r=ShowMenu(bzmenu,JY.BingzhongNum-1,8,0,0,0,0,6,1,16,M_White,M_White)
end
if r>0 then
bz=r
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Bingzhong[bz]["Ãû³Æ"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Bingzhong[bz]["ËµÃ÷"],18),M_White,size)
if talkYesNo(War.Person[War.SelID].id,"‚B„L: "..JY.Bingzhong[bz]["Ãû³Æ"].."*ƒJƒKKLY?") then
WarBingZhongUp(War.SelID,bz)
end
end
elseif r==10 then
local wp={}
for wpid=1,JY.ItemNum-1 do
wp[wpid]={fillblank(JY.Item[wpid]["Ãû³Æ"],13),nil,0}
if wpid<181 and koPromotionItemId(wpid)==wpid and JY.Item[wpid]["ÀàĞÍ"]>0 then
wp[wpid][3]=1
end
end
local rr=ShowMenu(wp,#wp,8,0,0,0,0,6,1,16,M_White,M_White)
if rr>0 then
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Item[rr]["Ãû³Æ"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Item[rr]["ËµÃ÷"],18),M_White,size)
if talkYesNo(War.Person[War.SelID].id,"ƒCƒD: "..JY.Item[rr]["Ãû³Æ"].."*ƒJƒKKLY?") then
for i=1,8 do
if JY.Person[War.Person[War.SelID].id]["µÀ¾ß"..i]==0 then
JY.Person[War.Person[War.SelID].id]["µÀ¾ß"..i]=rr
break
end
if i==8 and JY.Person[War.Person[War.SelID].id]["µÀ¾ß"..i]>0 then
WarDrawStrBoxWaitKey('D‚w^ ^ƒD „MKLM',M_White)
end
end
end
end
elseif r==11 and rawget(_G,"koFormPick") and koFormPick(scl,menux,menuy) then--ko 5.0: ì§„í˜• changed: the unit's action ends (as ëŒ€ê¸°)
War.Person[scl].active=false
War.Person[scl].action=0
WarResetStatus(scl)
War.SelID=scl
WarCheckStatus()
War.LastID=scl
War.CurID=0
War.SelID=0
War.ControlStatus="select"
WarDelay(CC.WarDelay)
return CheckActive()
elseif r==0 then
CleanWarMap(4,1)
CleanWarMap(10,0)
SetWarMap(War.Person[scl].x,War.Person[scl].y,2,0)
SetWarMap(War.OldX,War.OldY,2,War.SelID)
War.Person[scl].x=War.OldX
War.Person[scl].y=War.OldY
BoxBack()
ReSetAttrib(pid,false)
War.SelID=0
War.ControlStatus="select"
end
else--Òì³£¿ØÖÆ×´Ì¬»Ø¸´
War.ControlStatus="select"
end
return false
end

function WarSelectAtk(flag,fw)
--flag true: select us or friend
--flag fasle: select enemy
flag=flag or false
fw=fw or 0
War.ControlStatus="selectAtk"
War.koSelFriend=flag--ko 3.1 addon range: friendly target pick = blue boxes
War.koAim=nil--ko 4.0 touch
local tmp=JY.MenuPic.num
JY.MenuPic.num=0
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
koTouchAimHint()--ko 4.0 touch
ReFresh()
local event,x,y=control()
event=koTouchAim(event)--ko 4.0 touch: first tap aims, second confirms
if JY.Status~=GAME_WMAP then--ko 3.1: the close button (control â†’ ì¢…ë£Œ í™•ì¸ â†’ GAME_END) used to leave this loop spinning
CleanWarMap(4,1)
CleanWarMap(10,0)
JY.MenuPic.num=tmp
War.ControlStatus="actionMenu"
return 0
end
if event==1 then
CleanWarMap(10,0)
if GetWarMap(War.MX,War.MY,4)>0 and fw>0 then
local array=WarGetAtkFW(War.MX,War.MY,fw)
for i=1,array.num do
local mx,my=array[i][1],array[i][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
if flag then
SetWarMap(mx,my,10,2)
else
SetWarMap(mx,my,10,1)
end
end
end
end
elseif event==2 then
--if not War.InMap then--µØÍ¼·¶Î§Íâ
if GetWarMap(War.MX,War.MY,4)>0 then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then--and eid~=War.SelID then
if flag then--select us or friend
if War.Person[eid].enemy==War.Person[War.SelID].enemy then
PlayWavE(0)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
return eid
else
PlayWavE(2)
WarDrawStrBoxWaitKey('ƒL ‚^‚_hLM.',M_White)
end
else--select enemy
if War.Person[eid].enemy~=War.Person[War.SelID].enemy then
PlayWavE(0)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
return eid
else
PlayWavE(2)
WarDrawStrBoxWaitKey('n‚Tƒb ‚J‚pX q ‚aKLM.',M_White)
end
end
else
PlayWavE(2)
--WarDrawStrBoxWaitKey('Ã»ÓĞµĞÈË£®',M_White)
end
else
PlayWavE(2)
if flag then
WarDrawStrBoxWaitKey('‚m‚n ‚oG n‚`LM.',M_White)
else
WarDrawStrBoxWaitKey('‚J‚p ‚m‚n ‚oG n‚`LM.',M_White)
end
end
elseif event==-1 then
PlayWavE(1)
CleanWarMap(4,1)
CleanWarMap(10,0)
BoxBack()
JY.MenuPic.num=tmp
War.ControlStatus="actionMenu"
return 0
end
end
JY.MenuPic.num=tmp
end

function WarCheckDX()
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(War.MX-War.CX)-136
else
menux=War.OX+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=War.OY+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=War.OY+War.BoxWidth*(War.MY-War.CY)
end
lib.Background(menux,menuy,menux+136,menuy+86,160)
menux=menux+8
menuy=menuy+8
lib.LoadSur(War.DXpic,menux,menuy)
DrawGameBox(menux,menuy,menux+War.BoxWidth,menuy+War.BoxDepth,M_White,-1)
DrawString(menux+56,menuy+8,"„N‚S y{",M_White,16)
local T={[0]="£°£¥","£²£°£¥","£³£°£¥","£­£¥","£°£¥","£­£¥","£°£¥","£µ£¥",
"£µ£¥","£­£¥","£­£¥","£°£¥","£­£¥","£³£°£¥","£±£°£¥","£°£¥",
"£°£¥","£­£¥","£­£¥","£­£¥",}
DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],M_White,16)
--É­ÁÖ 20 É½µØ 30 ´å×¯ 5
--²İÔ­ 5 Â¹Õ¯ 30 ±øÓª 10
-- 00 Æ½Ô­ 01 É­ÁÖ 02 É½µØ 03 ºÓÁ÷ 04 ÇÅÁº 05 ³ÇÇ½ 06 ³Ç³Ø 07 ²İÔ­
-- 08 ´å×¯ 09 ĞüÑÂ 0A ³ÇÃÅ 0B »ÄµØ 0C Õ¤À¸ 0D Â¹íÎ 0E ±øÓª 0F Á¸²Ö
-- 10 ±¦Îï¿â 11 ·¿Éá 12 »ğÑæ 13 ×ÇÁ÷
DrawString(menux,menuy+56,War.DX[dx],M_White,16)
if dx==8 or dx==13 or dx==14 then
DrawString(menux+56,menuy+56,"‚}‚D „O‚M",M_White,16)
end
--´å×¯¡¢Â¹íÎ¿ÉÒÔ»Ö¸´Ê¿ÆøºÍ±øÁ¦£®±øÓª¿ÉÒÔ»Ö¸´±øÁ¦£¬µ«²»ÄÜ»Ö¸´Ê¿Æø£®
--Óñçô¿ÉÒÔ»Ö¸´±øÁ¦ºÍÊ¿Æø£¬Ô®¾ü±¨¸æ¿ÉÒÔ»Ö¸´±øÁ¦£¬ÉâÃüÊé¿ÉÒÔ»Ö¸´Ê¿Æø£®
--µØĞÎºÍ±¦ÎïµÄ»Ö¸´ÄÜÁ¦²»ÄÜµş¼Ó£¬Ò²¾ÍÊÇËµ£¬´¦ÓÚ´å×¯µØĞÎÉÏÔÙ³ÖÓĞ»Ö¸´ĞÔ±¦Îï£¬ÓëÃ»ÓĞ³ÖÓĞ»Ö¸´ĞÔ±¦ÎïĞ§¹ûÏàÍ¬£®µ«Èç¹ûµØĞÎÖ»ÄÜ»Ö¸´±øÁ¦£¨Èç±øÓª£©£¬µ«±¦Îï¿ÉÒÔ»Ö¸´±øÁ¦£¬ÕâÖÖÇé¿öÏÂ£¬±øÁ¦Ê¿Æø¶¼ÄÜµÃµ½×Ô¶¯»Ö¸´£®
end

function fillblank(s,num)
local len=num-string.len(s)
if len<=0 then
local kt=string.sub(s,1,num)
local ki=1
while ki<=string.len(kt) do
local kb=string.byte(kt,ki)
if kb>=129 and kb<=254 then
if ki==string.len(kt) then kt=string.sub(kt,1,ki-1) break end
ki=ki+2
else ki=ki+1 end
end
return kt
else
local left,right
left=math.modf(len/2)
right=len-left
return string.format(string.format("%%%ds%%s%%%ds",left,right),"",s,"")
end
end

--Ê¹ÓÃ²ßÂÔ
--ko 3.6: strategy menu tabs. With more than 8 strategies a header [<] name [>] sits over the list
--  (all / fire / water / rock / poison+thunder / confusion+restraint / morale+troops+healing); a click on an arrow (or the name)
--  steps through the groups that have strategies and refilters the list, the last tab is kept per general for the battle. WarShowMenu draws and hit-tests JY.koMenuTabs
koMagicTabs={
{"\130\066\133\114",nil},--all
{"\129\064\132\084",{[1]=true}},--fire
{"\129\113\132\084",{[2]=true}},--water
{"\132\089\132\090",{[3]=true}},--rock
{"\132\096\161\164\132\098",{[9]=true,[10]=true}},--poison / thunder
{"\132\087\130\100",{[4]=true,[5]=true}},--confusion / restraint
{"\130\125\130\068",{[6]=true,[7]=true,[8]=true}},--morale / troops / healing
}
function koMagicTabMenu(m,n,pid,menux,menuy)
local function plain() return WarShowMenu(m,JY.MagicNum-1,8,menux,menuy,0,0,6,1,16,M_White,M_White) end
if not CC.Enhancement then return plain() end
local T=koMagicTabs
local KT="\192\224\208\205"
local cnt={n}
for t=2,#T do
cnt[t]=0
for i=1,JY.MagicNum-1 do
if m[i][3]>0 and T[t][2][JY.Magic[i][KT]] then cnt[t]=cnt[t]+1 end
end
end
local tabs={}
for t=1,#T do if cnt[t]>0 then tabs[#tabs+1]=t end end
if #tabs<=2 then return plain() end
War.koMagicTab=War.koMagicTab or {}
local cur=War.koMagicTab[pid] or 1
if (cnt[cur] or 0)==0 then cur=1 end
-- the header: [<] name [>] as wide as the list, above it (near the top the list moves down under it)
local SW=120
local sx=limitX(menux,0,CC.ScreenW-SW)
local sy=menuy-24
if sy<28 then sy=math.max(menuy,28) menuy=sy+24 end--no room under the battle top bar (y 0~27): the list moves down a row
local rL={sx,sy,sx+22,sy+22}
local rR={sx+SW-22,sy,sx+SW,sy+22}
local rC={sx+24,sy,sx+SW-24,sy+22}
local function step(d)--next / previous tab that has strategies, wrapping around
local k=1
for i,t in ipairs(tabs) do if t==cur then k=i end end
return tabs[(k-1+d)%#tabs+1]
end
local function arrow(r,d)
lib.FillColor(r[1],r[2],r[3],r[4],MOUSE.IN(r[1],r[2],r[3],r[4]) and RGB(110,84,40) or RGB(48,40,32))
lib.DrawRect(r[1],r[2],r[3],r[4],M_Gray)
local cx,cy=r[1]+11,r[2]+11
for i=0,5 do--a small triangle, one column at a time
local x=(d<0) and (cx-3+i) or (cx+3-i)
lib.FillColor(x,cy-i,x+1,cy+i+1,M_White)
end
end
while true do
local mm={}
local nn=0
for i=1,JY.MagicNum-1 do
local ok=m[i][3]>0 and (cur==1 or T[cur][2][JY.Magic[i][KT]]==true)
mm[i]={m[i][1],m[i][2],ok and 1 or 0,koColor=m[i].koColor}
if ok then nn=nn+1 end
end
local k=1
for i,t in ipairs(tabs) do if t==cur then k=i end end
JY.koMenuTabs={
draw=function()
arrow(rL,-1)
arrow(rR,1)
lib.FillColor(rC[1],rC[2],rC[3],rC[4],RGB(150,110,40))
lib.DrawRect(rC[1],rC[2],rC[3],rC[4],M_White)
local s=T[cur][1]
DrawString(rC[1]+math.modf((rC[3]-rC[1]-#s*8)/2),sy+1,s,M_Yellow,16)
local dx=rC[1]+math.modf((rC[3]-rC[1]-#tabs*6+2)/2)--one dot per tab, the current one bright
for i=1,#tabs do lib.FillColor(dx+(i-1)*6,sy+17,dx+(i-1)*6+4,sy+21,i==k and M_White or RGB(60,40,16)) end
end,
hit=function()
if MOUSE.CLICK(rL[1],rL[2],rL[3],rL[4]) then return step(-1) end
if MOUSE.CLICK(rR[1],rR[2],rR[3],rR[4]) then return step(1) end
if MOUSE.CLICK(rC[1],rC[2],rC[3],rC[4]) then return step(1) end
return nil
end}
local r
if nn<=8 then
r=WarShowMenu(mm,JY.MagicNum-1,0,menux,menuy,0,0,5,1,16,M_White,M_White)
else
r=WarShowMenu(mm,JY.MagicNum-1,8,menux,menuy,0,0,6,1,16,M_White,M_White)
end
local hit=JY.koMenuTabs.sel
JY.koMenuTabs=nil
War.koMagicTab[pid]=hit or cur
if not hit then return r end
cur=hit
end
end

function WarMagicMenu()
local id=War.SelID
local pid=War.Person[id].id
local bz=JY.Person[pid]["±øÖÖ"]
local lv=JY.Person[pid]["µÈ¼¶"]
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(mx-War.CX)-104-menu_off
else
menux=War.OX+War.BoxWidth*(mx-War.CX+1)+menu_off
end
local m={}
local n=0
local eid=0
local eid2=0
local eid3=0
local eid4=0
for i=1,JY.MagicNum-1 do
if id>0 and CC.Enhancement and WarCheckSkill(id,101) then -- mimic: adjacent units, bounds-checked (ko fix)
local nb={{mx-1,my},{mx+1,my},{mx,my-1},{mx,my+1}}
local ne={0,0,0,0}
for d=1,4 do
local nx,ny=nb[d][1],nb[d][2]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
local nw=GetWarMap(nx,ny,2)
if nw>0 and War.Person[nw]~=nil then ne[d]=nw end
end
end
eid,eid2,eid3,eid4=ne[1],ne[2],ne[3],ne[4]
end
if WarHaveMagic(id,i) or eid>0 and WarHaveMagic(eid,i) or eid2>0 and WarHaveMagic(eid2,i) or eid3>0 and WarHaveMagic(eid3,i) or eid4>0 and WarHaveMagic(eid4,i) then
n=n+1
if CC.Enhancement and (JY.Person[pid]["ÎäÆ÷"]==12 or WarCheckSkill(id,112)) then--ÆßĞÇ½£ ²ßÂÔÖµÏûºÄ¼õ°ë
m[i]={fillblank(JY.Magic[i]["Ãû³Æ"],8)..string.format("% 2d",math.modf(JY.Magic[i]["ÏûºÄ"]/2)),nil,1}
else
m[i]={fillblank(JY.Magic[i]["Ãû³Æ"],8)..string.format("% 2d",JY.Magic[i]["ÏûºÄ"]),nil,1}
end
else
m[i]={"",nil,0}
end
end
for i=1,JY.MagicNum-1 do if m[i][3]>0 then local c=JY.Magic[i]["ÏûºÄ"] if CC.Enhancement and (JY.Person[pid]["ÎäÆ÷"]==12 or WarCheckSkill(id,112)) then c=math.modf(c/2) end if JY.Person[pid]["²ßÂÔ"]<c then m[i].koColor=M_Red end end end--ko 4.0: short of MP = red (all modes; halving only in Enhancement like the real check)
menuy=math.min(War.OY+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-(16+8+20*math.min(n,8))-menu_off)
local r
if n==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey("„P q „O‚b ‚u‚vG ‚aKLM.",M_White)
return 0
elseif n<=8 then
r=WarShowMenu(m,JY.MagicNum-1,0,menux,menuy,0,0,5,1,16,M_White,M_White)
else
r=koMagicTabMenu(m,n,pid,menux,menuy)--ko 3.6: strategy tabs
end
if r>0 then
local clxh=JY.Magic[r]["ÏûºÄ"]
if CC.Enhancement and (JY.Person[pid]["ÎäÆ÷"]==12 or WarCheckSkill(id,112)) then--ÆßĞÇ½£ ²ßÂÔÖµÏûºÄ¼õ°ë
clxh=math.modf(clxh/2)
end
if JY.Person[pid]["²ßÂÔ"]<clxh then
PlayWavE(2)
WarDrawStrBoxWaitKey("‚u‚v„Q^ ‚^„RWLM.",M_White)
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
if WarMagicMenu_sub(id,r,false) then
if CC.Enhancement and (JY.Person[pid]["ÎäÆ÷"]==12 or WarCheckSkill(id,112)) then--ÆßĞÇ½£ ²ßÂÔÖµÏûºÄ¼õ°ë
JY.Person[pid]["²ßÂÔ"]=JY.Person[pid]["²ßÂÔ"]-math.modf(JY.Magic[r]["ÏûºÄ"]/2)
else
JY.Person[pid]["²ßÂÔ"]=JY.Person[pid]["²ßÂÔ"]-JY.Magic[r]["ÏûºÄ"]
end
JY.MenuPic.num=MenuPicNum
return 1
end
JY.MenuPic.num=MenuPicNum
end
end
return 0
end

function WarMagicMenu_sub(id,r,ItemFlag)--ko 3.1: expose the chosen ì±…ëµ to addons while its target is being picked
War.koMagicSel={mid=r,item=ItemFlag or false,wid=id}
local koRet=koWarMagicMenu_sub(id,r,ItemFlag)
War.koMagicSel=nil
return koRet
end
function koWarMagicMenu_sub(id,r,ItemFlag)
local kind=JY.Magic[r]["ÀàĞÍ"]
if kind==1 then--»ğÏµ
if between(War.Weather,4,5) then
WarDrawStrBoxConfirm("‚P [‚b ƒSf‚b @‚JS „P q ‚aKLM.",M_White)
else
WarDrawStrBoxDelay("@‚Jƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
koWarMagic2(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("ƒLG |‚O, ƒ|ƒQ, ƒwƒQ, ƒ{‚Cf*„OS „U„V „P q „OKLM.*(‚Cu xƒG^ „OƒmA ‚SƒZƒWƒv)",M_White)
end
end
end
elseif kind==2 then--Ë®Ïµ
WarDrawStrBoxDelay("q‚Jƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
koWarMagic2(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("ƒLG „W„X, ƒwƒQf*„OS „U„V „P q „OKLM.*(‚Cu xƒG^ „OƒmA ‚SƒZƒWƒv)",M_White)
end
end
elseif kind==3 then--ÂäÊ¯Ïµ
WarDrawStrBoxDelay("„Y„Zƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
koWarMagic2(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("ƒLG „[‚C, ‚UI‚Cf*„OS „U„V „P q „OKLM.*(‚Cu xƒG^ „OƒmA ‚SƒZƒWƒv)",M_White)
end
end
elseif kind==4 then--¼ÙÇé±¨Ïµ
WarDrawStrBoxDelay("ƒLS ‚c‚df ƒE„]ƒjM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
koWarMagic2(id,eid,r,ItemFlag)
return true
end
elseif kind==5 then--Ç£ÖÆÏµ
WarDrawStrBoxDelay("ƒLƒP ‚rƒG‚h „^Q „_‚bM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
koWarMagic2(id,eid,r,ItemFlag)
return true
end
elseif kind==6 then--¼¤ÀøÏµ
WarDrawStrBoxDelay("‚rƒG„Q‚h ‚}‚DoM.",M_White)
--»Ö¸´·¶Î§ÄÚµÄÊ¿ÆøÖµ²¿¶Ó£®
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
koWarMagic2(id,eid,r,ItemFlag)
return true
end
elseif kind==7 then--Ô®ÖúÏµ
WarDrawStrBoxDelay("‚~ƒ}S ‚}‚DoM.",M_White)
--»Ö¸´·¶Î§ÄÚµÄ±øÁ¦²¿¶Ó
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
koWarMagic2(id,eid,r,ItemFlag)
return true
end
elseif kind==8 then--¿´»¤Ïµ
WarDrawStrBoxDelay("‚~ƒ}{ ‚rƒG„Q‚h ‚}‚DoM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
koWarMagic2(id,eid,r,ItemFlag)
return true
end
elseif kind==9 then--¶¾Ïµ
WarDrawStrBoxDelay("„`ƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
koWarMagic2(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("„a q ‚a‚b []„S „P q ‚aKLM.",M_White)
end
end
elseif kind==10 then--ÂäÀ×Ïµ
if between(War.Weather,3,5) then
WarDrawStrBoxDelay("„Y„b„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
koWarMagic2(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("‚Lƒb ƒSf‚b „Y„b‚h „P q ‚aKLM.",M_White)
end
end
else
WarDrawStrBoxConfirm("‚Lƒb ƒSf‚b „Y„b‚h „P q ‚aKLM.",M_White)
end
elseif kind==11 then--Õ¨µ¯
WarDrawStrBoxDelay("„c„dƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay("„c„dS „e„foM.",M_White)
koWarMagic2(id,eid,r,ItemFlag)
return true
else
WarDrawStrBoxConfirm("„a q ‚a‚b []„S „P q ‚aKLM.",M_White)
end
end
end
return false
end

function WarMagicHitRatio(wid,eid,mid)
if between(JY.Magic[mid]["ÀàĞÍ"],6,8) then
return 1
end
local p1=JY.Person[War.Person[wid].id]
local p2=JY.Person[War.Person[eid].id]
local a=p1["ÖÇÁ¦2"]*p1["µÈ¼¶"]/100+p1["ÖÇÁ¦2"]
local b=(p2["ÖÇÁ¦2"]*p2["µÈ¼¶"]/100+p2["ÖÇÁ¦2"])/4
if CC.Enhancement then
if JY.Magic[mid]["ÀàĞÍ"]==2 and (WarCheckSkill(eid,3) or WarCheckSkill(eid,23)) then--Ë®Éñ/ÌÙ¼×
a=1
b=2
end
if JY.Magic[mid]["ÀàĞÍ"]==1 and WarCheckSkill(eid,4) then--»ğÉñ
a=1
b=2
end
if JY.Magic[mid]["ÀàĞÍ"]==4 and (WarCheckSkill(eid,20) or JY.Item[p2["ÎäÆ÷"]]["ÌØ¼¼"]==20) then--³Á×Å
a=1
b=2
end
local koK=JY.Magic[mid]["ÀàĞÍ"]--ko 3.2: 37 blocks every attack strategy outright, like 3/4/23 do for water/fire
if (between(koK,1,3) or between(koK,9,10)) and WarCheckSkill(eid,37) then
a=1
b=2
end
if WarCheckSkill(wid,17) then--ÉñËã
a=a*2
end
if WarCheckSkill(eid,18) then--Ê¶ÆÆ
b=b*2
end
end
if JY.Magic[mid]["ÀàĞÍ"]==4 then
b=b*2
end
if p2["±øÖÖ"]==13 or p2["±øÖÖ"]==16 or p2["±øÖÖ"]==19 then
b=b*1.5
end
local v=1-b/a
v=limitX(v,0,1)
return v
end

--²ßÂÔÊ¹ÓÃĞ§¹û
--ko n‚T ‚u‚vƒm„S ƒL ‚^‚_‚h ˆ`…e„]ƒj ‚}q(ÊÂ¼ş1998). ‚G„N …}„o vwf MM
local function koMagicKill(wid,id)
local c=War.Person[wid]
local t=War.Person[id]
if c and t and t.live and t.enemy and (not c.enemy) and (not c.friend) and JY.Person[t.id]["±øÁ¦"]<=0 then
JY.Base["ÊÂ¼ş1998"]=math.min((JY.Base["ÊÂ¼ş1998"] or 0)+1,9999)
koHook("magic_kill",wid)--ko 3.1
end
end

function WarMagic(wid,eid,mid,ItemFlag)
War.ControlStatus="actionMenu"
ItemFlag=ItemFlag or false
local mx=War.Person[eid].x
local my=War.Person[eid].y
local d1,d2=WarAutoD(wid,eid)
local atkarray=WarGetAtkFW(mx,my,JY.Magic[mid]["Ğ§¹û·¶Î§"])
local hp_cnt,sq_cnt,trb_cnt
War.Person[wid].action=2
War.Person[wid].frame=0
War.Person[wid].d=d1
WarDelay(4)
PlayWavE(8)
WarDelay(8)
PlayWavE(39)
WarDelay(12)
War.Person[wid].action=0
local fsjyxz=1 --·¨Êõ¾­ÑéĞŞÕı
for i=atkarray.num,1,-1 do
	local x,y=atkarray[i][1],atkarray[i][2]
	local id=GetWarMap(x,y,2)
	if id>0 and War.Person[id].live and (not War.Person[id].hide) then
		if War.Person[id].enemy==War.Person[eid].enemy then
		else
			table.remove(atkarray,i)
			atkarray.num=atkarray.num-1
		end
	else
		table.remove(atkarray,i)
		atkarray.num=atkarray.num-1
	end
end
for i=1,atkarray.num do
	local x,y=atkarray[i][1],atkarray[i][2]
	local id=GetWarMap(x,y,2)
	if id>0 and War.Person[id].live and (not War.Person[id].hide) then--table.removeºó±ØÈ»Îªtrue
		if War.Person[id].enemy==War.Person[eid].enemy then--table.removeºó±ØÈ»Îªtrue
			local id1=War.Person[wid].id
			local id2=War.Person[id].id
			local hitratio=WarMagicHitRatio(wid,id,mid)
			if ItemFlag then
				hitratio=1
			end
			local hurt,sq_hurt,jy,jy2=WarMagicHurt(wid,id,mid,ItemFlag)
			d1,d2=WarAutoD(wid,id)
			if between(JY.Magic[mid]["ÀàĞÍ"],6,8) then				
				if JY.Magic[mid]["ÀàĞÍ"]==6 then
--»ù±¾Ê¿Æø»Ö¸´Öµ£½²ßÂÔ»ù±¾ÍşÁ¦£«²¹¸ø·½µÈ¼¶¡Â10
--Ê¿Æø»Ö¸´Ëæ»úĞŞÕıÖµÊÇÒ»¸öËæ»úÕûÊı£¬ÔÚ0µ½£¨»ù±¾Ê¿Æø»Ö¸´Öµ¡Â10£­1£©Ö®¼ä¡£
--²¹¸øĞ§¹û£½»ù±¾Ê¿Æø»Ö¸´Öµ£«Ê¿Æø»Ö¸´Ëæ»úĞŞÕıÖµ
					if ItemFlag then
						sq_hurt=JY.Magic[mid]["Ğ§¹û"]
					else
						sq_hurt=JY.Magic[mid]["Ğ§¹û"]+JY.Person[id1]["µÈ¼¶"]/10
					end
					sq_hurt=math.modf(sq_hurt*(1+math.random()/10)*((koDemon(wid) and not ItemFlag) and 1.5 or 1)*((koTwinOn(wid) and not ItemFlag) and 1.3 or 1))
					sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["Ê¿Æø"])
					hurt=-1
					if atkarray.num==1 then
						WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."ƒP ‚rƒG„Q^ ƒi„gM.",M_White)
					end
				elseif JY.Magic[mid]["ÀàĞÍ"]==7 then
--»ù±¾±øÁ¦»Ö¸´Öµ£½²ßÂÔ»ù±¾ÍşÁ¦£«²¹¸ø·½ÖÇÁ¦¡Á²¹¸ø·½µÈ¼¶¡Â20
--±øÁ¦»Ö¸´Ëæ»úĞŞÕıÖµÊÇÒ»¸öËæ»úÕûÊı£¬ÔÚ0µ½£¨»ù±¾±øÁ¦»Ö¸´Öµ¡Â10£­1£©Ö®¼ä¡£
--²¹¸øĞ§¹û£½»ù±¾±øÁ¦»Ö¸´Öµ£«±øÁ¦»Ö¸´Ëæ»úĞŞÕıÖµ
					
					if ItemFlag then
						hurt=JY.Magic[mid]["Ğ§¹û"]
					else
						hurt=JY.Magic[mid]["Ğ§¹û"]+JY.Person[id1]["ÖÇÁ¦2"]*JY.Person[id1]["µÈ¼¶"]/20
						if CC.Enhancement then
							if WarCheckSkill(id,41) then--ko 3.2: each target's own 41 --²¹¸ø
								hurt=math.modf(hurt*(100+JY.Skill[41]["²ÎÊı1"])/100)
							end
						end
					end
					hurt=math.modf(hurt*(1+math.random()/10)*((koDemon(wid) and not ItemFlag) and 1.5 or 1)*((koTwinOn(wid) and not ItemFlag) and 1.3 or 1))
					hurt=limitX(hurt,0,JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])
					do local koH=rawget(_G,"koHealCut") if koH then hurt=koH(hurt,id) end end--ko 5.0 (10-13): trial ã€Œì•„êµ° íšŒë³µã€
					sq_hurt=-1
					if atkarray.num==1 then
						WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."ƒP ‚~ƒ}G ƒi„gM.",M_White)
					end
				elseif JY.Magic[mid]["ÀàĞÍ"]==8 then
					local hp={600,1200,1800}
					local sp={30,40,50}
					if ItemFlag then
						hurt=hp[JY.Magic[mid]["Ğ§¹û"]]
						sq_hurt=sp[JY.Magic[mid]["Ğ§¹û"]]
					else
						hurt=hp[JY.Magic[mid]["Ğ§¹û"]]+JY.Person[id1]["ÖÇÁ¦2"]*JY.Person[id1]["µÈ¼¶"]/20
						sq_hurt=sp[JY.Magic[mid]["Ğ§¹û"]]+JY.Person[id1]["µÈ¼¶"]/10
						if CC.Enhancement then
							if WarCheckSkill(id,41) then--ko 3.2: each target's own 41 --²¹¸ø
								hurt=math.modf(hurt*(100+JY.Skill[41]["²ÎÊı1"])/100)
							end
						end
					end
					hurt=math.modf(hurt*(1+math.random()/10)*((koDemon(wid) and not ItemFlag) and 1.5 or 1)*((koTwinOn(wid) and not ItemFlag) and 1.3 or 1))
					hurt=limitX(hurt,0,JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])
					do local koH=rawget(_G,"koHealCut") if koH then hurt=koH(hurt,id) end end--ko 5.0 (10-13): trial ã€Œì•„êµ° íšŒë³µã€
					sq_hurt=math.modf(sq_hurt*(1+math.random()/10)*((koDemon(wid) and not ItemFlag) and 1.5 or 1)*((koTwinOn(wid) and not ItemFlag) and 1.3 or 1))
					sq_hurt=limitX(sq_hurt,0,War.Person[id].sq_limited-JY.Person[id2]["Ê¿Æø"])
					if atkarray.num==1 then
						WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."ƒP ‚~ƒ}{ ‚rƒG„Q^ ƒi„gM.",M_White)
					end
				end
				PlayMagic(mid,x,y,id1)
				if hurt>=0 then
					War.Person[id].hurt=hurt
					WarDelay(8)
					War.Person[id].hurt=-1
				end
				if sq_hurt>=0 then
					War.Person[id].hurt=sq_hurt
					WarDelay(8)
					War.Person[id].hurt=-1
				end
				local t=16
				t=math.min(16,(math.modf(math.max( 2,math.abs(hurt)/50,math.abs(sq_hurt)))))
				local oldbl=JY.Person[id2]["±øÁ¦"]
				local oldsq=JY.Person[id2]["Ê¿Æø"]
				for ii=0,t do
					if hurt>0 then
						JY.Person[id2]["±øÁ¦"]=oldbl+hurt*ii/t					
					end
					if sq_hurt>0 then
						JY.Person[id2]["Ê¿Æø"]=oldsq+sq_hurt*ii/t			
					end					
					JY.ReFreshTime=lib.GetTime()
					DrawWarMap()
					DrawStatusMini(id)
					lib.GetKey()
					ReFresh()					
				end
				if JY.Person[id2]["±øÁ¦"]>oldbl then
					JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]+fsjyxz
					if JY.Person[id1]["ÖÇÁ¦¾­Ñé"]>=200 then
        						JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]-200
        						local MenuPicNum=JY.MenuPic.num
        						JY.MenuPic.num=0
       						local oldaction=War.Person[wid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
       						War.Person[wid].action=0
        						for t=1,2 do
            							War.Person[wid].d=3
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=2
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=4
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=1
            							WarDelay(koAnimD(3))
        						end
        						PlayWavE(12)
        						War.Person[wid].action=6
        						for i=0,256,8*CC.koAnim do
            							War.Person[wid].effect=i
            						WarDelay(1)
        						end
        						for i=240,0,-8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
       						end
        						WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
        						ReSetAttrib(id1,false)
        						War.Person[wid].action=oldaction
        						JY.MenuPic.num=MenuPicNum
        						for n=1,8 do
            							if JY.Person[id1]["µÀ¾ß"..n]==0 then
                							JY.Person[id1]["µÀ¾ß"..n]=72
                							break
            							end
       				 		end
    					end		
				end	
				if JY.Person[id2]["Ê¿Æø"]~=oldsq then
					JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]+fsjyxz
					if JY.Person[id1]["ÖÇÁ¦¾­Ñé"]>=200 then
        						JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]-200
        						local MenuPicNum=JY.MenuPic.num
        						JY.MenuPic.num=0
        						local oldaction=War.Person[wid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
        						War.Person[wid].action=0
        						for t=1,2 do
            							War.Person[wid].d=3
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=2
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=4
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=1
            							WarDelay(koAnimD(3))
        						end
        						PlayWavE(12)
        						War.Person[wid].action=6
        						for i=0,256,8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
        						end
        						for i=240,0,-8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
        						end
        						WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
        						ReSetAttrib(id1,false)
        						War.Person[wid].action=oldaction
        						JY.MenuPic.num=MenuPicNum
        						for n=1,8 do
            							if JY.Person[id1]["µÀ¾ß"..n]==0 then
                							JY.Person[id1]["µÀ¾ß"..n]=72
                							break
            							end
        						end
    					end
				end
					
				JY.ReFreshTime=lib.GetTime()
				ReFresh(CC.OpearteSpeed*4)
				WarDelay(4)
				if JY.Magic[mid]["ÀàĞÍ"]==6 or JY.Magic[mid]["ÀàĞÍ"]==8 then
					WarTroubleShooting(id)
				end
				if CC.Enhancement and JY.Magic[mid]["ÀàĞÍ"]==8 and (War.Person[id].poison or 0)>0 then--ko 3.5: nursing magic cures poison
					War.Person[id].poison=0
					WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."ƒP „`G ‹E„~M!",M_White)
				end
				if i==atkarray.num then
					if atkarray.num>1 then
						if JY.Magic[mid]["ÀàĞÍ"]==6 then
							if War.Person[id].enemy then
								WarDrawStrBoxDelay("ƒL‚TƒP ‚rƒG„Q^ ‚}‚D„C„kM.",M_White)
							else
								WarDrawStrBoxDelay("n‚TƒP ‚rƒG„Q^ ‚}‚D„C„kM.",M_White)
							end
						elseif JY.Magic[mid]["ÀàĞÍ"]==7 then
							if War.Person[id].enemy then
								WarDrawStrBoxDelay("ƒL‚TƒP ‚~ƒ}G ‚}‚D„C„kM.",M_White)
							else
								WarDrawStrBoxDelay("n‚TƒP ‚~ƒ}G ‚}‚D„C„kM.",M_White)
							end
						elseif JY.Magic[mid]["ÀàĞÍ"]==8 then
							if War.Person[id].enemy then
								WarDrawStrBoxDelay("ƒL‚TƒP ‚~ƒ}{ ‚rƒG„Q^ ‚}‚D„C„kM.",M_White)
							else
								WarDrawStrBoxDelay("n‚TƒP ‚~ƒ}{ ‚rƒG„Q^ ‚}‚D„C„kM.",M_White)
							end
						end
					end
					jy=8
					if CC.Enhancement then
						jy=JY.Magic[mid]["ÏûºÄ"]
					end
					
					if (JY.Person[id1]["±øÖÖ"]==13 or JY.Person[id1]["±øÖÖ"]==19) and (not CC.Enhancement) then
						jy=math.modf(jy*2)
					end
					if not (War.Person[wid].enemy or ItemFlag) then
						WarAddExp(wid,jy)						
					end
				end
				ReSetAttrib(id1,false)
				ReSetAttrib(id2,false)
				koMagicKill(wid,id)
				WarResetStatus(id)				
			elseif JY.Magic[mid]["ÀàĞÍ"]==4 then--¼ÙÇé±¨Ïµ
				jy=8
				if CC.Enhancement then
					jy=JY.Magic[mid]["ÏûºÄ"]
				end
				if math.random()<hitratio then
					War.Person[id].action=4
					War.Person[id].frame=0
					War.Person[id].d=d2
					PlayMagic(mid,x,y,id1)
					War.Person[id].hurt=-1
					if War.Person[id].troubled then
						WarDelay(2)
						WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."G(^) „l„m ‚c‚df ƒEƒFM!",M_White)
					else
						War.Person[id].troubled=true
						War.Person[id].action=7
						WarDelay(2)
						WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."G(^) ‚c‚df ƒEƒFM!",M_White)
					end
					JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]+fsjyxz
					if JY.Person[id1]["ÖÇÁ¦¾­Ñé"]>=200 then
        						JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]-200
        						local MenuPicNum=JY.MenuPic.num
        						JY.MenuPic.num=0
        						local oldaction=War.Person[wid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
        						War.Person[wid].action=0
        						for t=1,2 do
            							War.Person[wid].d=3
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=2
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=4
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=1
            							WarDelay(koAnimD(3))
        						end
        						PlayWavE(12)
        						War.Person[wid].action=6
        						for i=0,256,8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
        						end
        						for i=240,0,-8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
        						end
        						WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
        						ReSetAttrib(id1,false)
        						War.Person[wid].action=oldaction
        						JY.MenuPic.num=MenuPicNum
        						for n=1,8 do
            							if JY.Person[id1]["µÀ¾ß"..n]==0 then
                							JY.Person[id1]["µÀ¾ß"..n]=72
                							break
            							end
        						end
    					end
				else
					War.Person[id].action=3
					War.Person[id].frame=0
					War.Person[id].d=d2
					PlayMagic(mid,x,y,id1)
					PlayWavE(81)
					WarDelay(8)
					War.Person[id].hurt=-1
					WarDrawStrBoxDelay(JY.Person[id1]["ĞÕÃû"].."ƒP „T‚vG NOPM!",M_White)
				end
				if i==atkarray.num then
					if not (War.Person[wid].enemy or ItemFlag) then
						WarAddExp(wid,jy)
					end
				end
				ReSetAttrib(id1,false)
				ReSetAttrib(id2,false)
				koMagicKill(wid,id)
				WarResetStatus(id)
			elseif JY.Magic[mid]["ÀàĞÍ"]==5 then--Ç£ÖÆÏµ
				jy=8
				if CC.Enhancement then
					jy=JY.Magic[mid]["ÏûºÄ"]
				end
				if math.random()<hitratio then
					hurt=0
--Ê¿ÆøËğÉË£½²ßÂÔ»ù±¾Ê¿ÆøËğÉË£«¹¥»÷·½µÈ¼¶¡Â10£­·ÀÓù·½µÈ¼¶¡Â10
					if ItemFlag then
						sq_hurt=math.modf(JY.Magic[mid]["Ğ§¹û"]-JY.Person[id2]["µÈ¼¶"]/10)
					else
						sq_hurt=math.modf(JY.Magic[mid]["Ğ§¹û"]+JY.Person[id1]["µÈ¼¶"]/10-JY.Person[id2]["µÈ¼¶"]/10)
					end
					sq_hurt=limitX(sq_hurt,0,JY.Person[id2]["Ê¿Æø"])
					War.Person[id].action=4
					War.Person[id].frame=0
					War.Person[id].d=d2
					WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."ƒP ‚rƒG„Q^ „n‚SƒFM.",M_White)
					PlayMagic(mid,x,y,id1)
					War.Person[id].hurt=sq_hurt
					WarDelay(8)
					War.Person[id].hurt=-1
					local t=16
					t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
					local oldbl=JY.Person[id2]["±øÁ¦"]
					local oldsq=JY.Person[id2]["Ê¿Æø"]
					for i=1,t do
						JY.Person[id2]["±øÁ¦"]=oldbl-hurt*i/t
						JY.Person[id2]["Ê¿Æø"]=oldsq-sq_hurt*i/t
						JY.ReFreshTime=lib.GetTime()
						DrawWarMap()
						DrawStatusMini(eid)
						lib.GetKey()
						ReFresh()
					end
					if JY.Person[id2]["Ê¿Æø"]~=oldsq then
					JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]+fsjyxz
					if JY.Person[id1]["ÖÇÁ¦¾­Ñé"]>=200 then
        						JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]-200
        						local MenuPicNum=JY.MenuPic.num
        						JY.MenuPic.num=0
        						local oldaction=War.Person[wid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
        						War.Person[wid].action=0
        						for t=1,2 do
            							War.Person[wid].d=3
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=2
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=4
            							WarDelay(koAnimD(3))
            							War.Person[wid].d=1
            							WarDelay(koAnimD(3))
        						end
        						PlayWavE(12)
        						War.Person[wid].action=6
        						for i=0,256,8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
        						end
        						for i=240,0,-8*CC.koAnim do
            							War.Person[wid].effect=i
            							WarDelay(1)
        						end
        						WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
        						ReSetAttrib(id1,false)
        						War.Person[wid].action=oldaction
        						JY.MenuPic.num=MenuPicNum
        						for n=1,8 do
            							if JY.Person[id1]["µÀ¾ß"..n]==0 then
                							JY.Person[id1]["µÀ¾ß"..n]=72
                							break
            							end
        						end
    					end
				end
					JY.ReFreshTime=lib.GetTime()
					ReFresh(CC.OpearteSpeed*4)
					WarDelay(4)
					WarGetTrouble(id)
				else
					War.Person[id].action=3
					War.Person[id].frame=0
					War.Person[id].d=d2
					PlayMagic(mid,x,y,id1)
					War.Person[id].hurt=0
					PlayWavE(81)
					WarDelay(8)
					War.Person[id].hurt=-1
					WarDrawStrBoxDelay(JY.Person[id1]["ĞÕÃû"].."ƒP „T‚vG NOPM!",M_White)
				end
				if i==atkarray.num then
					if not (War.Person[wid].enemy or ItemFlag) then
						WarAddExp(wid,jy)
					end
				end
				ReSetAttrib(id1,false)
				ReSetAttrib(id2,false)
				koMagicKill(wid,id)
				WarResetStatus(id)
			elseif WarMagicCheck(wid,id,mid) then
				if math.random()<hitratio then
					War.Person[id].action=4
					War.Person[id].frame=0
					War.Person[id].d=d2
					PlayMagic(mid,x,y,id1)
					War.Person[id].hurt=hurt
					WarDelay(8)
					War.Person[id].hurt=-1
					local t=16
					t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
					local oldbl=JY.Person[id2]["±øÁ¦"]
					local oldsq=JY.Person[id2]["Ê¿Æø"]
					for i=1,t do
						JY.Person[id2]["±øÁ¦"]=oldbl-hurt*i/t
						JY.Person[id2]["Ê¿Æø"]=oldsq-sq_hurt*i/t
						JY.ReFreshTime=lib.GetTime()
						DrawWarMap()
						DrawStatusMini(id)
						lib.GetKey()
						ReFresh()
					end
					JY.ReFreshTime=lib.GetTime()
					ReFresh(CC.OpearteSpeed*4)
					WarDelay(4)
					WarGetTrouble(id)
					if CC.Enhancement then
						if JY.Magic[mid]["ÀàĞÍ"]==3 then--ÂäÊ¯Ïµ
							if WarCheckSkill(wid,15) then--ÂäÉ³
								if math.random(100)<=JY.Skill[15]["²ÎÊı1"] then
									if JY.Person[id2]["±øÁ¦"]>0 then
										if not War.Person[id].troubled then
											War.Person[id].troubled=true
											War.Person[id].action=7
											WarDelay(2)
											WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."G(^) ‚c‚df ƒEƒFM!",M_White)
										end
									end
								end
							end
						end
if JY.Magic[mid]["ÀàĞÍ"]==9 and hurt>0 and JY.Person[id2]["±øÁ¦"]>0 and koPoisonMag[mid] then--ko 3.5: poison magic
local koPM=koPoisonMag[mid]
if math.random(100)<=koPM.rate then
if (War.Person[id].poison or 0)<koPM.turns then War.Person[id].poison=koPM.turns end
WarDrawStrBoxDelay(JY.Person[id2]["ĞÕÃû"].."G(^) „`f ‚@„~M!",M_White)
end
end
					end
					if not (War.Person[wid].enemy) then
						WarAddExp(wid,jy)
						if CC.Enhancement then
							local id1=War.Person[wid].id
							if JY.Person[id1]["ÖÇÁ¦"]<=koNG.cap() and (not War.Person[wid].enemy) then
								JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]+2
								if JY.Person[id1]["ÖÇÁ¦¾­Ñé"]>=200 then
									JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]-200
									local MenuPicNum=JY.MenuPic.num
									JY.MenuPic.num=0
									local oldaction=War.Person[wid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
									War.Person[wid].action=0
									for t=1,2 do
										War.Person[wid].d=3
										WarDelay(koAnimD(3))
										War.Person[wid].d=2
										WarDelay(koAnimD(3))
										War.Person[wid].d=4
										WarDelay(koAnimD(3))
										War.Person[wid].d=1
										WarDelay(koAnimD(3))
									end
									PlayWavE(12)
									War.Person[wid].action=6
									for i=0,256,8*CC.koAnim do
										War.Person[wid].effect=i
										WarDelay(1)
									end
									for i=240,0,-8*CC.koAnim do
										War.Person[wid].effect=i
										WarDelay(1)
									end
									WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
									ReSetAttrib(id1,false)
									War.Person[wid].action=oldaction
									JY.MenuPic.num=MenuPicNum
									for n=1,8 do
										if JY.Person[id1]["µÀ¾ß"..n]==0 then
											JY.Person[id1]["µÀ¾ß"..n]=72
											break
										end
									end
								end
							end
						end
					end
					ReSetAttrib(id1,false)
					ReSetAttrib(id2,false)
					koMagicKill(wid,id)
					WarResetStatus(id)
				else
					War.Person[id].action=3
					War.Person[id].frame=0
					War.Person[id].d=d2
					PlayMagic(mid,x,y,id1)
					  War.Person[id].hurt=0
					PlayWavE(81)
					WarDelay(8)
					War.Person[id].hurt=-1
					if not (War.Person[wid].enemy) then
						WarAddExp(wid,jy2)
						local id1=War.Person[wid].id
						if CC.Enhancement and JY.Person[id1]["ÖÇÁ¦"]<=koNG.cap() and (not War.Person[wid].enemy) then
							JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]+1
							if JY.Person[id1]["ÖÇÁ¦¾­Ñé"]>=200 then
								JY.Person[id1]["ÖÇÁ¦¾­Ñé"]=JY.Person[id1]["ÖÇÁ¦¾­Ñé"]-200
								local MenuPicNum=JY.MenuPic.num
								JY.MenuPic.num=0
								local oldaction=War.Person[wid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
								War.Person[wid].action=0
								for t=1,2 do
									War.Person[wid].d=3
									WarDelay(koAnimD(3))
									War.Person[wid].d=2
									WarDelay(koAnimD(3))
									War.Person[wid].d=4
									WarDelay(koAnimD(3))
									War.Person[wid].d=1
									WarDelay(koAnimD(3))
								end
								PlayWavE(12)
								War.Person[wid].action=6
								for i=0,256,8*CC.koAnim do
									War.Person[wid].effect=i
									WarDelay(1)
								end
								for i=240,0,-8*CC.koAnim do
									War.Person[wid].effect=i
									WarDelay(1)
								end
								WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
								ReSetAttrib(id1,false)
								War.Person[wid].action=oldaction
								JY.MenuPic.num=MenuPicNum
								for n=1,8 do
									if JY.Person[id1]["µÀ¾ß"..n]==0 then
										JY.Person[id1]["µÀ¾ß"..n]=72
										break
									end
								end
							end
						end
					end
					ReSetAttrib(id1,false)
					ReSetAttrib(id2,false)
					koMagicKill(wid,id)
					WarResetStatus(id)
					WarDrawStrBoxDelay(JY.Person[id1]["ĞÕÃû"].."ƒP „T‚uG NOPM!",M_White)
				end
			end
		end
	end
end
WarResetStatus(wid)
end

function PlayMagic(mid,x,y,pid)
if CC.cldh==0 then
return
end
if War.koSkip then return end--ko 3.1: enemy phase being skipped
local eft=JY.Magic[mid]["¶¯»­"]
local pic_w,pic_h=lib.PicGetXY(0,eft*2)
local frame=pic_h/pic_w
if eft==241 then
frame=7
elseif eft==242 then
frame=13
elseif eft==243 then
frame=13
end
pic_h=pic_h/frame
local str=JY.Person[pid]["ĞÕÃû"]..'ƒP ‚u‚v'
local sx,sy
sx=War.OX+War.BoxWidth*(x-War.CX+0.5)-pic_w/2
sy=War.OY+War.BoxDepth*(y-War.CY+1)-pic_h
PlayWavE(JY.Magic[mid]["ÒôĞ§"])
local rpt=2
if between(JY.Magic[mid]["ÀàĞÍ"],4,8) then
rpt=1
end
for i=1,frame do
for n=1,rpt do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
lib.SetClip(sx,sy,sx+pic_w,sy+pic_h)
lib.PicLoadCache(0,eft*2,sx,sy-pic_h*(i-1),1)
lib.SetClip(0,0,0,0)
lib.GetKey()
ReFresh()
end
end
end

koStratBZ={[16]=true,[26]=true}--ko 5.0: strategist classes (yaoshushi, moushi)
function koStratClass(wid) local v=War.Person[wid] return CC.Enhancement and v and koStratBZ[JY.Person[v.id]["\177\248\214\214"]]==true end
function WarMagicCheck(wid,eid,mid)
local kind=JY.Magic[mid]["ÀàĞÍ"]
local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if between(kind,4,8) or kind==9 or kind==11 then
return true
end
if kind==1 and between(War.Weather,4,5) then
return false
end
if kind==10 and between(War.Weather,3,5) then
return true
end
if CC.Enhancement then
if WarCheckSkill(wid,46) then--µØÀí
return true
end
end
if kind==1 and (dx==8 or dx==13 or dx==14 or dx==17) and koStratClass(wid) then--ko 5.0: strategists burn wooden strongholds
return true
end
if kind==1 and (dx==0 or dx==1 or dx==6 or dx==7) then
return true
end
if kind==2 and (dx==0 or dx==4) then
return true
end
if kind==3 and (dx==2 or dx==11) then
return true
end
return false
end

koPoisonMag={[41]={turns=3,rate=75},[42]={turns=2,rate=50}}--ko 3.5: poison magic (id -> turns, chance %)

--²ßÂÔÉËº¦
function WarMagicHurt(wid,eid,mid,ItemFlag)
ItemFlag=ItemFlag or false
local id1=War.Person[wid].id
local id2=War.Person[eid].id
local p1=JY.Person[id1]
local p2=JY.Person[id2]
local hurt=JY.Magic[mid]["Ğ§¹û"]
if ItemFlag then
hurt=hurt-(p2["ÖÇÁ¦2"]*p2["µÈ¼¶"]/40+p2["ÖÇÁ¦2"])
else
hurt=hurt+(p1["ÖÇÁ¦2"]*p1["µÈ¼¶"]/40+p1["ÖÇÁ¦2"])*2-(p2["ÖÇÁ¦2"]*p2["µÈ¼¶"]/40+p2["ÖÇÁ¦2"])
end
if p2["±øÖÖ"]==13 or p2["±øÖÖ"]==16 or p2["±øÖÖ"]==19 then
hurt=hurt/2
end

--Èç¹û±»·ÀÓù·½ÔÚÊ÷ÁÖÖĞ£¬ÇÒ²ßÂÔÊÇ½¹ÈÈÏµ²ßÂÔ
--²ßÂÔ¹¥»÷É±ÉË£½²ßÂÔ¹¥»÷É±ÉË£«²ßÂÔ¹¥»÷É±ÉË¡Â4
--Èç¹ûµ±Ç°ÌìÆøÊÇÓêÌì£¬ÇÒ²ßÂÔÊÇäöÎĞÏµ²ßÂÔ
--²ßÂÔ¹¥»÷É±ÉË£½²ßÂÔ¹¥»÷É±ÉË£«²ßÂÔ¹¥»÷É±ÉË¡Â4

local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if JY.Magic[mid]["ÀàĞÍ"]==1 and dx==1 then
hurt=hurt*1.25
end
if JY.Magic[mid]["ÀàĞÍ"]==2 and between(War.Weather,4,5) then
hurt=hurt*1.25
end
if JY.Magic[mid]["ÀàĞÍ"]==10 and between(War.Weather,4,5) then
hurt=hurt*1.1
end
local item_atk=0
if p1["ÎäÆ÷"]>0 then
item_atk=item_atk+JY.Item[p1["ÎäÆ÷"]]["²ßÂÔ¹¥»÷"]
end
if p1["·À¾ß"]>0 then
item_atk=item_atk+JY.Item[p1["·À¾ß"]]["²ßÂÔ¹¥»÷"]
end
if p1["¸¨Öú"]>0 then
item_atk=item_atk+JY.Item[p1["¸¨Öú"]]["²ßÂÔ¹¥»÷"]
end
if item_atk~=0 then
hurt=hurt*(100+item_atk)/100
end

local ensw=0	--ÎÒ·½»ğÉñË®ÉñÊÇ·ñ»á±»ÒÔÏÂ¼¼ÄÜÇ¿»¯µÄ¿ª¹Ø£¬1ÊÇ»á 0ÊÇ²»»á
if not ItemFlag and koStratClass(wid) and (between(JY.Magic[mid]["\192\224\208\205"],1,3) or between(JY.Magic[mid]["\192\224\208\205"],9,10)) then hurt=hurt*1.2 end--ko 5.0: strategist +20%

if CC.Enhancement then
if JY.Magic[mid]["ÀàĞÍ"]==1 and (WarCheckSkill(wid,12) or JY.Item[p1["ÎäÆ÷"]]["ÌØ¼¼"]==12) then--»ğ¼Æ
	if mid~=39 or p1["¾ıÖ÷"]~=1 or ensw==1 then
		hurt=hurt*(100+JY.Skill[12]["²ÎÊı1"])/100
	end
end
if JY.Magic[mid]["ÀàĞÍ"]==2 and (WarCheckSkill(wid,11) or JY.Item[p1["ÎäÆ÷"]]["ÌØ¼¼"]==11) then--Ë®¼Æ
	if mid~=40 or p1["¾ıÖ÷"]~=1 or ensw==1 then
		hurt=hurt*(100+JY.Skill[11]["²ÎÊı1"])/100
	end
end
if JY.Magic[mid]["ÀàĞÍ"]==3 and (WarCheckSkill(wid,14) or JY.Item[p1["ÎäÆ÷"]]["ÌØ¼¼"]==14) then--ÂäÊ¯	
		hurt=hurt*(100+JY.Skill[14]["²ÎÊı1"])/100
end
if JY.Magic[mid]["ÀàĞÍ"]==3 and (WarCheckSkill(wid,21) or JY.Item[p1["ÎäÆ÷"]]["ÌØ¼¼"]==21) then --·ü±ø	
		hurt=hurt*(100+JY.Skill[21]["²ÎÊı1"])/100
end
if (between(JY.Magic[mid]["ÀàĞÍ"],1,3) or between(JY.Magic[mid]["ÀàĞÍ"],9,10)) and WarCheckSkill(wid,39) then--¶¾¼Æ
	if ((mid~=39 and mid~=40) or p1["¾ıÖ÷"]~=1 or ensw==1) then
		hurt=hurt*(100+JY.Skill[39]["²ÎÊı1"])/100
	end
end
if (between(JY.Magic[mid]["ÀàĞÍ"],1,3) or between(JY.Magic[mid]["ÀàĞÍ"],9,10)) and WarCheckSkill(wid,50) then--ÉîÄ±
	if ((mid~=39 and mid~=40) or p1["¾ıÖ÷"]~=1 or ensw==1) then
		hurt=hurt*(100+JY.Skill[50]["²ÎÊı1"])/100
	end
end
if (between(JY.Magic[mid]["ÀàĞÍ"],1,3) or between(JY.Magic[mid]["ÀàĞÍ"],9,10)) and koDemon(wid) and not ItemFlag then--ko 3.6: talent 123 (not from a tool)
	hurt=hurt*1.5
end
if JY.Magic[mid]["ÀàĞÍ"]==1 and WarCheckSkill(eid,13) then--Ãğ»ğ
hurt=hurt*(100-JY.Skill[13]["²ÎÊı1"])/100
end
if JY.Magic[mid]["ÀàĞÍ"]==1 and WarCheckSkill(eid,4) then--»ğÉñ
hurt=1
end
if JY.Magic[mid]["ÀàĞÍ"]==2 and WarCheckSkill(eid,3) then--Ë®Éñ
hurt=1
end
if (between(JY.Magic[mid]["ÀàĞÍ"],1,3) or between(JY.Magic[mid]["ÀàĞÍ"],9,10)) then
if WarCheckSkill(eid,16) then--Ã÷¾µ
hurt=hurt*(100-JY.Skill[16]["²ÎÊı1"])/100
end
if WarCheckSkill(eid,37) then--»¢ÊÓ
hurt=hurt*(100-JY.Skill[37]["²ÎÊı1"])/100
end
end
if WarCheckSkill(eid,23) then--ÌÙ¼×
if JY.Magic[mid]["ÀàĞÍ"]==1 then
hurt=hurt*(100+JY.Skill[23]["²ÎÊı2"])/100
end
if JY.Magic[mid]["ÀàĞÍ"]==2 then
hurt=1
end
end
end
hurt=math.modf(hurt*(1+math.random()/50))
if hurt<1 then
hurt=1
end
-- Èç¹û¹¥»÷ÉËº¦´óÓÚ·ÀÓù·½±øÁ¦£¬Ôò¹¥»÷ÉËº¦=·ÀÓù·½±øÁ¦
if hurt>p2["±øÁ¦"] then
hurt=p2["±øÁ¦"]
end
--Ê¿Æø½µ·ù£½¹¥»÷ÉËº¦¡Â£¨·ÀÓù·½µÈ¼¶£«5£©¡Â3
local sq_hurt=math.modf(hurt/(p2["µÈ¼¶"]+5)/3)
if sq_hurt==0 then
if hurt>0 then
sq_hurt=1
else
sq_hurt=0
end
end
sq_hurt=limitX(sq_hurt,0,p2["Ê¿Æø"])
--¾­ÑéÖµ»ñµÃ
local jy=0
local jy2=0--²ßÂÔÊ§°ÜÊ±µÄ¾­Ñé
--µĞ¾ü²¿¶Ó²»ÄÜ»ñµÃ¾­ÑéÖµ£®
if p1["µÈ¼¶"]<99 and (not War.Person[wid].enemy) then--and (not War.Person[wid].friend) then
--¾­ÑéÖµÓÉÁ½²¿·Ö¹¹³É£º»ù±¾¾­ÑéÖµºÍ½±Àø¾­ÑéÖµ£®
local part1,part2=0,0
--µ±¹¥»÷·½µÈ¼¶µÍÓÚµÈÓÚ·ÀÓù·½µÈ¼¶Ê±£º
if p1["µÈ¼¶"]<=p2["µÈ¼¶"] then
--»ù±¾¾­ÑéÖµ£½£¨·ÀÓù·½µÈ¼¶£­¹¥»÷·½µÈ¼¶£«3£©¡Á2
part1=(p2["µÈ¼¶"]-p1["µÈ¼¶"]+3)*2
--Èç¹û»ù±¾¾­ÑéÖµ´óÓÚ16£¬Ôò»ù±¾¾­ÑéÖµ£½16£®
if part1>16 then
part1=16
end
--Ìá¸ß»ñÈ¡¾­Ñé
if CC.Enhancement then
part1=(p2["µÈ¼¶"]-p1["µÈ¼¶"]+5)*2
if part1>24 then
part1=24
end
end
--µ±¹¥»÷·½µÈ¼¶¸ßÓÚ·ÀÓù·½µÈ¼¶Ê±£º
else
--»ù±¾¾­ÑéÖµ£½4
part1=4
if CC.Enhancement then
part1=8--Ìá¸ß»ñÈ¡¾­Ñé
end
end
--Èç¹ûÉ±ËÀµĞÈË£¬¿ÉÒÔ»ñµÃ½±Àø¾­ÑéÖµ£º
if hurt==p2["±øÁ¦"] then
--Èç¹ûÉ±ËÀµĞ¾üÖ÷½«
if War.Person[eid].leader then
--½±Àø¾­ÑéÖµ£½48
part2=48
--Èç¹ûÉ±ËÀµÄ²»ÊÇµĞ¾üÖ÷½«£¬ÇÒµĞ¾üµÈ¼¶¸ßÓÚÎÒ¾ü
elseif p2["µÈ¼¶"]>p1["µÈ¼¶"] then
--½±Àø¾­ÑéÖµ£½32
part2=32
--Èç¹ûÉ±ËÀµÄ²»ÊÇµĞ¾üÖ÷½«£¬ÇÒµĞ¾üµÈ¼¶µÍÓÚµÈÓÚÎÒ¾ü
else
--½±Àø¾­ÑéÖµ£½64¡Â£¨¹¥»÷·½µÈ¼¶£­·ÀÓù·½µÈ¼¶£«2£©
part2=math.modf(64/(p1["µÈ¼¶"]-p2["µÈ¼¶"]+2))
--Ìá¸ß»ñÈ¡¾­Ñé
if CC.Enhancement then
part2=32-(p1["µÈ¼¶"]-p2["µÈ¼¶"])*4
part2=limitX(part2,8,48)
end
end
end
--×îÖÕ»ñµÃµÄ¾­ÑéÖµ£½»ù±¾¾­ÑéÖµ£«½±Àø¾­ÑéÖµ£®
jy=part1+part2
jy2=part1
end
if JY.Magic[mid]["ÀàĞÍ"]==11 then
hurt=limitX((math.random(15)+90)*15,0,p2["±øÁ¦"])
sq_hurt=limitX(math.random(10)+30,0,p2["Ê¿Æø"])
jy=0
jy2=0
end
return hurt,sq_hurt,jy,jy2
end

function WarItemMenu()
local id=War.SelID
local pid=War.Person[id].id
if JY.Person[pid]["µÀ¾ß1"]==0 then
WarDrawStrBoxWaitKey("D‚w^ ‚aKLM!",M_White)
return
end
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(mx-War.CX)-80-menu_off
else
menux=War.OX+War.BoxWidth*(mx-War.CX+1)+menu_off
end
menuy=math.min(War.OY+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-112-menu_off)
local m={
{"¡¡‚r„o",WarItemMenu_sub,1},
{"¡¡w„pƒG",WarItemMenu_sub,1},
{"¡¡„quƒG",WarItemMenu_sub,1},
{"¡¡ƒsƒG",WarItemMenu_sub,1},
}
local r=WarShowMenu(m,4,0,menux,menuy,menux+80,menuy+112,1,1,16,M_White,M_White)
if r>0 then
return 1
else
return 0
end
end

function WarItemMenu_sub(kind)
local id=War.SelID
local pid=War.Person[id].id
local menux,menuy=0,0
local menu_off=16
local mx=War.Person[id].x
local my=War.Person[id].y
if mx-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(mx-War.CX)-80-menu_off*2
else
menux=War.OX+War.BoxWidth*(mx-War.CX+1)+menu_off*2
end
menuy=math.min(12+War.BoxDepth*(my-War.CY)+menu_off*2,CC.ScreenH-16-132-menu_off*2)
local m={}
for i=1,8 do
local itemid=JY.Person[pid]["µÀ¾ß"..i]
if itemid>0 then
if kind==1 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],13),Item_Use,1}
elseif kind==2 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],13),Item_Send,1}
elseif kind==3 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],13),Item_Scrap,1}
elseif kind==4 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],13),Item_Check,1}
else
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],13),nil,1}
end
else
m[i]={"",nil,0}
end
end
local r=WarShowMenu(m,8,0,menux,menuy,0,0,4,1,16,M_White,M_White)
if r>0 then
return 1
else
return 0
end
end

--Ê¹ÓÃµÀ¾ß
function Item_Use(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["µÀ¾ß"..i]
local kind=JY.Item[itemid]["ÀàĞÍ"]
if between(kind,1,2) then
local mid=JY.Item[itemid]["Ğ§¹û"]
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
if WarMagicMenu_sub(id,mid,true) then
JY.MenuPic.num=MenuPicNum
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
JY.MenuPic.num=MenuPicNum
elseif kind==3 then
if koFixedBZ(pid) then
PlayWavE(2)
WarDrawStrBoxDelay("‚B„o ‚~TG‚f ƒU†N q ‚aKLM.",M_White)
return 0
end
local rule=JY.Item[itemid]
if koIsPromotionItem(itemid) then
rule=nil
local current=JY.Person[pid]["±øÖÖ"]
for source=PROMOTION_SEAL,LAST_PROMOTION_ITEM do
local candidate=JY.Item[source]
if candidate[ITEM_REQUIRED_CLASS]==current then rule=candidate break end
end
if not rule then
PlayWavE(2)
WarDrawStrBoxDelay(PROMOTION_NAME..": \131\105\132\117 \129\113 \130\097\129\075\129\076\129\077.",M_White)
return 0
end
end
if not WarDrawStrBoxYesNo(string.format('‚^‚_‚h %s(ƒm)„S ƒU„rLM.',JY.Bingzhong[rule["Ğ§¹û"]]["Ãû³Æ"]),M_White) then
return 0
elseif rule["Ğè±øÖÖ"]>0 and JY.Person[pid]["±øÖÖ"]~=rule["Ğè±øÖÖ"] then
PlayWavE(2)
WarDrawStrBoxDelay("„sZ: "..JY.Bingzhong[rule["Ğè±øÖÖ"]]["Ãû³Æ"].."£®",M_White)
return 0
elseif JY.Person[pid]["µÈ¼¶"]<rule["ĞèµÈ¼¶"] then
PlayWavE(2)
WarDrawStrBoxDelay("‚R‚{G ‚^„RWLM.",M_White)
return 0
else
local target=rule["Ğ§¹û"]
WarBingZhongUp(War.SelID,target)
if koIsPromotionItem(itemid) and JY.Person[pid]["±øÖÖ"]~=target then return 0 end
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
elseif kind==8 then--ÎäÁ¦ÖÖ
if not WarDrawStrBoxYesNo('Iƒ}„Q‚h ƒi„tLM.',M_White) then
return 0
elseif JY.Person[pid]["ÎäÁ¦"]>=koNG.cap() then
PlayWavE(2)
WarDrawStrBoxDelay("ƒi„u q ‚aKLM.",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--Ê¹ÓÃÎïÆ·¶¯×÷
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(koAnimD(3))
War.Person[War.SelID].d=2
WarDelay(koAnimD(3))
War.Person[War.SelID].d=4
WarDelay(koAnimD(3))
War.Person[War.SelID].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["ÎäÁ¦"]=JY.Person[pid]["ÎäÁ¦"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒP ƒG„v Iƒ} ¡ú "..JY.Person[pid]["ÎäÁ¦"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["µÀ¾ß"..i]=0
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
elseif kind==9 then--ÖÇÁ¦ÖÖ
if not WarDrawStrBoxYesNo('‚Cƒ}„Q‚h ƒi„tLM.',M_White) then
return 0
elseif JY.Person[pid]["ÖÇÁ¦"]>=koNG.cap() then
PlayWavE(2)
WarDrawStrBoxDelay("ƒi„u q ‚aKLM.",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--Ê¹ÓÃÎïÆ·¶¯×÷
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(koAnimD(3))
War.Person[War.SelID].d=2
WarDelay(koAnimD(3))
War.Person[War.SelID].d=4
WarDelay(koAnimD(3))
War.Person[War.SelID].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["ÖÇÁ¦"]=JY.Person[pid]["ÖÇÁ¦"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒP ƒG„v ‚Cƒ} ¡ú "..JY.Person[pid]["ÖÇÁ¦"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["µÀ¾ß"..i]=0
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
elseif kind==10 then--Í³ÂÊÖÖ
if not WarDrawStrBoxYesNo('„w„x„Q‚h ƒi„tLM.',M_White) then
return 0
elseif JY.Person[pid]["Í³ÂÊ"]>=koNG.cap() then
PlayWavE(2)
WarDrawStrBoxDelay("ƒi„u q ‚aKLM.",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--Ê¹ÓÃÎïÆ·¶¯×÷
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(koAnimD(3))
War.Person[War.SelID].d=2
WarDelay(koAnimD(3))
War.Person[War.SelID].d=4
WarDelay(koAnimD(3))
War.Person[War.SelID].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["Í³ÂÊ"]=JY.Person[pid]["Í³ÂÊ"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒP ƒG„v „w„x ¡ú "..JY.Person[pid]["Í³ÂÊ"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["µÀ¾ß"..i]=0
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
elseif kind==14 then--ko 5.0 (10-13): book of formation, read in the city
PlayWavE(2)
WarDrawStrBoxDelay("\130\126\136\070\131\087\130\098 \129\068\130\086\129\102\131\087 \129\073\131\097 \134\077\133\099\131\080 \161\184\130\126\131\087 \143\070\131\071\161\185\132\083 \143\070\129\075\129\076\129\077.",M_White)
return 0
elseif kind==13 then--¾­ÑéÖÖ
if not WarDrawStrBoxYesNo(JY.Person[pid]["ĞÕÃû"]..'‚R‚{S ƒi„tLM.',M_White) then
return 0
elseif JY.Person[pid]["µÈ¼¶"]>=99 then
PlayWavE(2)
WarDrawStrBoxDelay("ƒi„u q ‚aKLM.",M_White)
return 0
else
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[War.SelID].action
--Ê¹ÓÃÎïÆ·¶¯×÷
War.Person[War.SelID].action=0
War.Person[War.SelID].d=1
WarDelay(2)
PlayWavE(41)
War.Person[War.SelID].action=6
WarDelay(16)
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[War.SelID].action=0
for t=1,2 do
War.Person[War.SelID].d=3
WarDelay(koAnimD(3))
War.Person[War.SelID].d=2
WarDelay(koAnimD(3))
War.Person[War.SelID].d=4
WarDelay(koAnimD(3))
War.Person[War.SelID].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[War.SelID].action=6
for i=0,256,8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
for i=240,0,-8*CC.koAnim do
War.Person[War.SelID].effect=i
WarDelay(1)
end
JY.Person[pid]["µÈ¼¶"]=JY.Person[pid]["µÈ¼¶"]+1
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒP ‚R‚{ ¡ú "..JY.Person[pid]["µÈ¼¶"],M_White)
ReSetAttrib(pid,false)
War.Person[War.SelID].action=oldaction
JY.MenuPic.num=MenuPicNum
JY.Person[pid]["µÀ¾ß"..i]=0
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
else
PlayWavE(2)
WarDrawStrBoxDelay("„P q „O‚b D‚w^ ‚aKLM.",M_White)
return 0
end
end

--½»³öÁË£®
function Item_Send(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["µÀ¾ß"..i]
WarSetAtkFW(War.SelID,21)
local eid=WarSelectAtk(true,11)
if eid>0 then
local EID=War.Person[eid].id
if JY.Person[EID]["µÀ¾ß8"]>0 then
PlayWavE(2)
WarDrawStrBoxDelay("m‚CƒBG ^ƒD „yƒW „l „{ q ‚aKLM.",M_White)
return 0
else
for n=1,8 do
if JY.Person[EID]["µÀ¾ß"..n]==0 then
JY.Person[EID]["µÀ¾ß"..n]=itemid
break
end
end
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
WarDrawStrBoxWaitKey("„|„}‚K„kM: "..JY.Item[itemid]["Ãû³Æ"].."£®",M_White)
ReSetAttrib(pid,false)
ReSetAttrib(EID,false)
return 1
end
else
return 0
end
end

function Item_Scrap(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["µÀ¾ß"..i]
WarDrawStrBoxWaitKey("„q„~M: "..JY.Item[itemid]["Ãû³Æ"].."£®",M_White)
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
ReSetAttrib(id,false)
return 1
end

function Item_Check(i)
local id=War.SelID
local pid=War.Person[id].id
local itemid=JY.Person[pid]["µÀ¾ß"..i]
 DrawItemStatus(itemid,pid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
return 0
end

function WarAutoD(id1,id2)
local x1,y1=War.Person[id1].x,War.Person[id1].y
local x2,y2=War.Person[id2].x,War.Person[id2].y
local dx=math.abs(x1-x2)
local dy=math.abs(y1-y2)
if dx==0 and dy==0 then
return War.Person[id1].d,War.Person[id1].d
end
if dy>dx then
if y1>y2 then
return 2,1
else
return 1,2
end
else
if x1>x2 then
return 3,4
else
return 4,3
end
end
end

-- BZSuper(bz1,bz2)
-- ·µ»Ø±øÖÖ¿ËÖÆ¹ØÏµ
-- true ¿ËÖÆ false ²»±»¿ËÖÆ
koBZAll={[30]=true,[31]=true,[32]=true}--ko 3.4: classes 30 and 31 win over every class (even between the two)
function BZSuper(bz1,bz2)
if koBZAll[bz1] or koBZAll[bz2] then return (koBZAll[bz1]==true) and not koBZAll[bz2] end--ko 3.4
for i=1,9 do
if JY.Bingzhong[bz1]["¿ËÖÆ"..i]==bz2 then
return true--bz1 ¿ËÖÆ bz2
end
end
return false--²»±»¿ËÖÆ
end

function koSiegePct(pid,eid)--ko 5.0: siege (skill 32) vs a target on castle floor, gate, fort, barracks, house
if not (CC.Enhancement and WarCheckSkill(pid,32)) then return 0 end
local d=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
if d==6 or d==10 or d==13 or d==14 or d==17 then return JY.Skill[32]["²ÎÊı1"] end
return 0
end
function WarAtkHurt(pid,eid,flag)
flag=flag or 0
local id1=War.Person[pid].id
local id2=War.Person[eid].id
local p1=JY.Person[id1]
local p2=JY.Person[id2]
--¹¥»÷·ÀÓù
local atk=p1["¹¥»÷"]
local def=p2["·ÀÓù"]
--·ÀÓùĞŞÕı£¬±øÖÖ¿ËÖÆ
--ÎäÆ÷ÌØĞ§ºÍÈËÎïÌØ¼¼Ğ§¹ûÓÅÏÈÓÚ±øÖÖÏà¿Ë
if CC.koBZOff then--ko 3.4: the preview asks for the damage without the class matchup
elseif CC.Enhancement and (p1["ÎäÆ÷"]==10 or WarCheckSkill(pid,110)) then--±øÖÖ¿ËÖÆ ×°±¸ÒĞÌì½£ºó±Ø¿ËÖÆ
def=def*3/4
elseif CC.Enhancement and (p2["ÎäÆ÷"]==11 or WarCheckSkill(eid,111) or JY.Item[p2["ÎäÆ÷"]]["ÌØ¼¼"]==111) then--±øÖÖ±»¿ËÖÆ ×°±¸ÇàâG½£ºó²»±»¿ËÖÆ
def=def*5/4

elseif BZSuper(p1["±øÖÖ"],p2["±øÖÖ"]) then--±øÖÖ¿ËÖÆ
def=def*3/4
elseif BZSuper(p2["±øÖÖ"],p1["±øÖÖ"]) then--±øÖÖ±»¿ËÖÆ
def=def*5/4
end
--µØĞÎÉ±ÉËĞŞÕı
local T={
[0]=0,20,30,0,0,--É­ÁÖ¡¡20¡¡É½µØ¡¡30
0,0,5,5,0,--´å×¯¡¡ 5 ²İÔ­¡¡ 5
0,0,0,30,10,--Â¹Õ¯¡¡30¡¡±øÓª¡¡10
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0
}
local dx=GetWarMap(War.Person[eid].x,War.Person[eid].y,1)
local koSiege=koSiegePct(pid,eid)--ko 5.0: siege
--»ù±¾ÎïÀíÉ±ÉË£½£¨¹¥»÷·½¹¥»÷Á¦£­·ÀÓùÁ¦ĞŞÕıÖµ¡Â2£©¡Á£¨100£­µØĞÎÉ±ÉËĞŞÕı£©¡Â100
local hurt=(atk-def/2)
if CC.Enhancement then
	if (WarCheckSkill(pid,118) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==118) then
		hurt=hurt*limitX(100+War.Person[pid].atk_buff+koSiege-War.Person[eid].def_buff+T[dx],10,200)/100
	else
		hurt=hurt*limitX(100+War.Person[pid].atk_buff+koSiege-War.Person[eid].def_buff,10,200)/100
	end
	if WarCheckSkill(eid,23) then--ÌÙ¼×
		hurt=hurt*(100-JY.Skill[23]["²ÎÊı1"])/100
	end
	if WarCheckSkill(eid,47) then--Çã¹ú
		hurt=hurt*(100-JY.Skill[47]["²ÎÊı1"])/100
	end
else
	hurt=hurt*(100-T[dx])/100
end
if koStratClass(eid) then hurt=hurt*0.85 end--ko 5.0: strategists take 15% less physical damage
if flag==1 and not (CC.Enhancement and WarCheckSkill(pid,107)) then--counter? 107(hoegyeok): no damage halving (ko fix)
hurt=hurt/2
elseif flag==2 or flag==3 then--ÂÒÉä/ÂÒÎè ÉËº¦Í³Ò»ÉèÖÃÎªÕı³£ÉËº¦µÄ40%
hurt=hurt*0.4
end
hurt=math.modf(hurt)
if rawget(_G,"koVaryHurt") then hurt=koVaryHurt(hurt) end--ko 5.0: damage spread (dmgvary)
if CC.Enhancement then
if WarCheckSkill(eid,43) then--ÀÇ¹Ë
if hurt>p2["×î´ó±øÁ¦"]/5 then
hurt=p2["×î´ó±øÁ¦"]/5
end
end
end
if CC.Enhancement and WarCheckSkill(eid,104) then--¹ØÓğ ÇàÁúÙÈÔÂµ¶ ±»¹¥»÷Ê±±Ø¶¨¸ñµ²
if hurt>p2["×î´ó±øÁ¦"]/5 then
hurt=p2["×î´ó±øÁ¦"]/5
end
end
local koCrit=false--ko 3.2: 115 always shows as a critical hit
if CC.Enhancement and (p1["ÎäÆ÷"]==60 or WarCheckSkill(pid,115)) then--°ÔÍõÖ®½£ ¹¥»÷Ê±±Ø¶¨±©»÷
if WarCheckSkill(eid,23) or WarCheckSkill(eid,43) or WarCheckSkill(eid,47) or WarCheckSkill(eid,104) then--ÓµÓĞ ÌÙ¼× ÀÇ¹Ë Çã¹ú ÌØ¼¼Ê±ÃâÒßÌØĞ§
WarDrawStrBoxDelay('„Q‚X…@ y{^ _‚la‚C ‚kƒtM',M_White)
else
if hurt<p2["±øÁ¦"]*0.4 then
hurt=p2["±øÁ¦"]*0.4
end
koCrit=true
end
end
if hurt<atk/20 then
hurt=math.modf(atk/20)
end
--Èç¹û¹¥»÷ÉËº¦<=0£¬Ôò¹¥»÷ÉËº¦=1£®
if hurt<1 then
hurt=1
end
local flag2=0
if hurt>=p2["×î´ó±øÁ¦"]*0.4 then
flag2=2--±©»÷
elseif hurt>=p2["±øÁ¦"]+p2["×î´ó±øÁ¦"]/5 then
flag2=2--±©»÷
elseif hurt<=p2["×î´ó±øÁ¦"]/5 then
flag2=1--¸ñµ²
end
if koCrit then flag2=2 end--ko 3.2: 115
-- Èç¹û¹¥»÷ÉËº¦´óÓÚ·ÀÓù·½±øÁ¦£¬Ôò¹¥»÷ÉËº¦=·ÀÓù·½±øÁ¦
if hurt>p2["±øÁ¦"] then
hurt=p2["±øÁ¦"]
end
--Ê¿Æø½µ·ù£½¹¥»÷ÉËº¦¡Â£¨·ÀÓù·½µÈ¼¶£«5£©¡Â3
local sq_hurt=math.modf(hurt/(p2["µÈ¼¶"]+5)/3)
if sq_hurt==0 then
if hurt>0 then
sq_hurt=1
else
sq_hurt=0
end
end
if CC.Enhancement and (p1["ÎäÆ÷"]==14 or WarCheckSkill(pid,113)) then--Èı¼âµ¶ ¹¥»÷Ê±¶îÍâ¼õÉÙµĞ·½Ê¿Æø
sq_hurt=sq_hurt+10
end
sq_hurt=limitX(sq_hurt,0,p2["Ê¿Æø"])
--¾­ÑéÖµ»ñµÃ
local jy=0
--µĞ¾ü²¿¶Ó²»ÄÜ»ñµÃ¾­ÑéÖµ£®
if p1["µÈ¼¶"]<99 and (not War.Person[pid].enemy) then--and (not War.Person[pid].friend) then
--¾­ÑéÖµÓÉÁ½²¿·Ö¹¹³É£º»ù±¾¾­ÑéÖµºÍ½±Àø¾­ÑéÖµ£®
local part1,part2=0,0
--µ±¹¥»÷·½µÈ¼¶µÍÓÚµÈÓÚ·ÀÓù·½µÈ¼¶Ê±£º
if p1["µÈ¼¶"]<=p2["µÈ¼¶"] then
--»ù±¾¾­ÑéÖµ£½£¨·ÀÓù·½µÈ¼¶£­¹¥»÷·½µÈ¼¶£«3£©¡Á2
 part1=(p2["µÈ¼¶"]-p1["µÈ¼¶"]+3)*2
--Èç¹û»ù±¾¾­ÑéÖµ´óÓÚ16£¬Ôò»ù±¾¾­ÑéÖµ£½16£®
if part1>16 then
part1=16
end
--Ìá¸ß»ñÈ¡¾­Ñé
if CC.Enhancement then
part1=(p2["µÈ¼¶"]-p1["µÈ¼¶"]+5)*2
if part1>24 then
part1=24
end
end
--µ±¹¥»÷·½µÈ¼¶¸ßÓÚ·ÀÓù·½µÈ¼¶Ê±£º
else
--»ù±¾¾­ÑéÖµ£½4
part1=4
if CC.Enhancement then
part1=8--Ìá¸ß»ñÈ¡¾­Ñé
end
end
--Èç¹ûÉ±ËÀµĞÈË£¬¿ÉÒÔ»ñµÃ½±Àø¾­ÑéÖµ£º
if hurt==p2["±øÁ¦"] then
--Èç¹ûÉ±ËÀµĞ¾üÖ÷½«
if War.Person[eid].leader then
--½±Àø¾­ÑéÖµ£½48
part2=48
--Èç¹ûÉ±ËÀµÄ²»ÊÇµĞ¾üÖ÷½«£¬ÇÒµĞ¾üµÈ¼¶¸ßÓÚÎÒ¾ü
elseif p2["µÈ¼¶"]>p1["µÈ¼¶"] then
--½±Àø¾­ÑéÖµ£½32
part2=32
--Èç¹ûÉ±ËÀµÄ²»ÊÇµĞ¾üÖ÷½«£¬ÇÒµĞ¾üµÈ¼¶µÍÓÚµÈÓÚÎÒ¾ü
else
--½±Àø¾­ÑéÖµ£½64¡Â£¨¹¥»÷·½µÈ¼¶£­·ÀÓù·½µÈ¼¶£«2£©
part2=math.modf(64/(p1["µÈ¼¶"]-p2["µÈ¼¶"]+2))
--Ìá¸ß»ñÈ¡¾­Ñé
if CC.Enhancement then
part2=32-(p1["µÈ¼¶"]-p2["µÈ¼¶"])*4
part2=limitX(part2,8,48)
end
end
end
--×îÖÕ»ñµÃµÄ¾­ÑéÖµ£½»ù±¾¾­ÑéÖµ£«½±Àø¾­ÑéÖµ£®
jy=part1+part2
end
return hurt,sq_hurt,jy,flag2
end

function WarAtk(pid,eid,flag)
flag=flag or 0
if JY.Status~=GAME_WMAP then return end--koAtkAfterWar 5.0: an event already ended the battle (10-10)
War.koLastAtk=pid War.koLastDef=eid--ko 3.0: ê¸°ë¡
local koCEatk=War.ControlEnable--ko 4.0: a local, like WarCheckStatus (koCEev); the shared War.ControlEnableOld is kept written for old readers
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
rawset(_G,"koVaryRoll",true)--ko 5.0: dmgvary rolls only for the real hit
local koVaryOk,hurt,sq_hurt,jy,flag2=pcall(WarAtkHurt,pid,eid,flag)
rawset(_G,"koVaryRoll",nil)
if not koVaryOk then error(hurt,0) end
--flag2 0 ÆÕÍ¨ 1¸ñµ² 2±©»÷
local id1=War.Person[pid].id
local id2=War.Person[eid].id
local str
if flag==1 then
str=JY.Person[id1]["ĞÕÃû"]..'ƒP …A‚p'
elseif flag==2 then
str=JY.Person[id1]["ĞÕÃû"]..'ƒP ‚q‚r'
elseif flag==3 then
str=JY.Person[id1]["ĞÕÃû"]..'ƒP …B‚p'
else
str=JY.Person[id1]["ĞÕÃû"]..'ƒP ‚J‚p'
end
local n=math.max(1,math.floor(CC.OpearteSpeed/(CC.koAnim or 1)))--ko 11-11: the koAnim setting shortens the blow too (on a device slower than the FrameNum frame, FrameNum alone changes nothing)
local d1,d2=WarAutoD(pid,eid)
War.Person[pid].d=d1
WarDelay()
if flag2==2 then
PlayWavE(6)
WarAtkWords(pid)
end
if koHook("war_atk_scene",pid,eid,hurt,sq_hurt,flag2,str) then--ko 3.1: an addon drew the attack (and applied the troop change)
War.Person[pid].d=d1
War.Person[eid].d=d2
War.Person[eid].hurt=-1
else
War.Person[pid].action=2
War.Person[pid].frame=0
WarDelay()
PlayWavE(War.Person[pid].atkwav)
for i=1,n*2 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
for i=0,3 do
War.Person[pid].frame=i
if i==0 and flag2==2 then
PlayWavE(33)
for t=8,192,8*CC.koAnim do
JY.ReFreshTime=lib.GetTime()
War.Person[pid].effect=t
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].hurt=hurt
War.Person[eid].frame=0
War.Person[eid].d=d2
if War.Person[eid].troubled then
PlayWavE(35)
elseif flag2==1 then
War.Person[eid].action=3
PlayWavE(30)
elseif flag2==2 then
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(36)
else
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(35)
end
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
end
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
end
War.Person[eid].effect=0
for i=1,n*2 do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[eid].hurt=-1
--µĞ¾ü±øÁ¦¼õÉÙ ÏÔÊ¾
local t=16
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/50,math.abs(sq_hurt)))))
t=math.max(1,math.floor(t/(CC.koAnim or 1)))--ko 11-11: troop count-down frames / koAnim
local oldbl=JY.Person[id2]["±øÁ¦"]
local oldsq=JY.Person[id2]["Ê¿Æø"]
for i=0,t do
JY.ReFreshTime=lib.GetTime()
JY.Person[id2]["±øÁ¦"]=oldbl-hurt*i/t
JY.Person[id2]["Ê¿Æø"]=oldsq-sq_hurt*i/t
DrawWarMap()
DrawStatusMini(eid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4/(CC.koAnim or 1))
WarDelay(koAnimD(4))
end--ko 3.0 fight scene
WarGetTrouble(eid)
if CC.Enhancement and hurt>0 and WarCheckSkill(pid,120) then War.Person[eid].poison=3 end
--¹¥ĞÄ ÏÔÊ¾
if CC.Enhancement then
if WarCheckSkill(pid,33) or (War.Person[pid].id==3 and koStoryEv()>488 and not GetFlag(38)) then--¹¥ĞÄ öÃIÖ®Õ½ÈôÅÓÍ³Î´ËÀ£¬ÕÅ·É±Ø´¥·¢¸ÃÌØĞ§
if hurt>0 and JY.Person[id1]["±øÁ¦"]<JY.Person[id1]["×î´ó±øÁ¦"] then
local t=16
hurt=math.modf(hurt*JY.Skill[33]["²ÎÊı1"]/100)
hurt=limitX(hurt,1,JY.Person[id1]["×î´ó±øÁ¦"]-JY.Person[id1]["±øÁ¦"])
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/25))))
t=math.max(1,math.floor(t/(CC.koAnim or 1)))
local oldbl=JY.Person[id1]["±øÁ¦"]
for i=0,t do
JY.ReFreshTime=lib.GetTime()
JY.Person[id1]["±øÁ¦"]=oldbl+hurt*i/t
DrawWarMap()
DrawStatusMini(pid)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4/(CC.koAnim or 1))
WarDelay(koAnimD(4))
end
end
end
local flag3=flag2
if flag2==0 then flag3=2 end
if flag2==1 then flag3=1 end
if flag2==2 then flag3=3 end
if CC.Enhancement then
if JY.Person[id2]["Í³ÂÊ"]<=koNG.cap() and (not War.Person[eid].enemy) then
JY.Person[id2]["Í³ÂÊ¾­Ñé"]=JY.Person[id2]["Í³ÂÊ¾­Ñé"]+flag3
if JY.Person[id2]["Í³ÂÊ¾­Ñé"]>=200 then
JY.Person[id2]["Í³ÂÊ¾­Ñé"]=JY.Person[id2]["Í³ÂÊ¾­Ñé"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[eid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[eid].action=0
for t=1,2 do
War.Person[eid].d=3
WarDelay(koAnimD(3))
War.Person[eid].d=2
WarDelay(koAnimD(3))
War.Person[eid].d=4
WarDelay(koAnimD(3))
War.Person[eid].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[eid].action=6
for i=0,256,8*CC.koAnim do
War.Person[eid].effect=i
WarDelay(1)
end
for i=240,0,-8*CC.koAnim do
War.Person[eid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id2]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h „icB„jM",M_White)
ReSetAttrib(id2,false)
War.Person[eid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id2]["µÀ¾ß"..n]==0 then
JY.Person[id2]["µÀ¾ß"..n]=73
break
end
end
end
end
end
--¾­ÑéÒÔ¼°Éı¼¶
WarAddExp(pid,jy)
if CC.Enhancement then
if JY.Person[id1]["ÎäÁ¦"]<=koNG.cap() and (not War.Person[pid].enemy) then
JY.Person[id1]["ÎäÁ¦¾­Ñé"]=JY.Person[id1]["ÎäÁ¦¾­Ñé"]+flag3
if JY.Person[id1]["ÎäÁ¦¾­Ñé"]>=200 then
JY.Person[id1]["ÎäÁ¦¾­Ñé"]=JY.Person[id1]["ÎäÁ¦¾­Ñé"]-200
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local oldaction=War.Person[pid].action
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[pid].action=0
for t=1,2 do
War.Person[pid].d=3
WarDelay(koAnimD(3))
War.Person[pid].d=2
WarDelay(koAnimD(3))
War.Person[pid].d=4
WarDelay(koAnimD(3))
War.Person[pid].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[pid].action=6
for i=0,256,8*CC.koAnim do
War.Person[pid].effect=i
WarDelay(1)
end
for i=240,0,-8*CC.koAnim do
War.Person[pid].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[id1]["ĞÕÃû"].."G(^) Iƒ}ƒP ƒT„h aƒv‚h „icB„jM",M_White)
ReSetAttrib(id1,false)
War.Person[pid].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[id1]["µÀ¾ß"..n]==0 then
JY.Person[id1]["µÀ¾ß"..n]=71
break
end
end
end
end
end
if War.Person[pid].active then
War.Person[pid].action=1
else
War.Person[pid].action=0
end
if War.Person[eid].active then
War.Person[eid].action=1
else
War.Person[eid].action=0
end
ReSetAttrib(id1,false)
ReSetAttrib(id2,false)
War.Person[pid].frame=-1
War.Person[eid].frame=-1
War.ControlEnable=koCEatk
if CC.Enhancement then
if War.Person[pid].bz==27 and flag==0 then--ÎèÅ®¿ÉÁ¬»÷
if JY.Person[id2]["±øÁ¦"]>0 then
WarAtk(pid,eid,3)
end
end
end
end

--WarAction(kind,id1,id2)
-- Õ½³¡ÉÏÏÔÊ¾¸÷ÖÖ¶¯×÷ idÒ»°ãÎªÈËÎïid
-- kind: 0.×ªÏò id1ÈËÎïid, id2 ·½Ïòid 1234ÏÂÉÏ×óÓÒ
-- 1.×Ô¶¯×ªÏò
-- 3.¹¥»÷|ÎŞ 4.¹¥»÷|±»»÷ÖĞ 5.¹¥»÷|·ÀÓù 6.¹¥»÷|¹¥»÷
-- 7.±©»÷|ÎŞ 8.±©»÷|±»»÷ÖĞ 9.±©»÷|·ÀÓù 10.±©»÷|±©»÷
-- 11.Ë«»÷|ÎŞ 12.
-- 15.·ÀÓù 16.³·ÍË(º¬·ÀÓù) 17.°ÜÍË 18.ËÀÍö
-- 19.´­Æø
function WarAction(kind,id1,id2)
if JY.Status~=GAME_WMAP and JY.Status~=GAME_WARWIN and JY.Status~=GAME_WARLOSE then
return
end
local controlstatus=War.ControlEnable
War.ControlEnable=false
War.InMap=false
id1=id1 or 1
id2=id2 or id1
local source=koStoryBattleSource and koStoryBattleSource(id1) or id1
local pid=GetWarID(source)
local eid=GetWarID(id2==id1 and source or id2)
local n=CC.OpearteSpeed
WarPersonCenter(pid)
if (not War.Person[pid].live) or War.Person[pid].hide then
elseif kind==0 then
if between(id2,1,4) then
War.Person[pid].action=0
War.Person[pid].frame=0
WarDelay(n)
if War.Person[pid].d~=id2 then
War.Person[pid].d=id2
PlayWavE(6)
WarDelay(n*2)
end
end
elseif kind==1 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
WarAction(0,id2,d2)
elseif kind==2 then
elseif kind==3 then
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
PlayWavE(7)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==4 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(35)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==5 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
for t=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
ReFresh()
end
lib.GetKey()
for i=0,3 do
War.Person[pid].frame=i
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].action=3
PlayWavE(30)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==6 then
WarAction(1,id1,id2)
War.Person[pid].action=2
War.Person[eid].action=2
for i=0,3 do
War.Person[pid].frame=i
War.Person[eid].frame=i
if i==3 then
PlayWavE(30)
WarDelay(n)
end
WarDelay(n)
end
WarDelay(n*2)
elseif kind==7 then
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8*CC.koAnim do
War.Person[pid].effect=t
WarDelay(1)
end
War.Person[pid].effect=0
end
if i==3 then
PlayWavE(7)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==8 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
--War.Person[pid].d=d1
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8*CC.koAnim do
War.Person[pid].effect=t
WarDelay(1)
end
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].effect=240
War.Person[eid].action=4
PlayWavE(36)
WarDelay(n)
end
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==9 then
local d1,d2=WarAutoD(pid,eid)
WarAction(0,id1,d1)
War.Person[pid].action=2
War.Person[pid].frame=0
PlayWavE(War.Person[pid].atkwav)
WarDelay(n)
lib.GetKey()
for i=0,3 do
War.Person[pid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8*CC.koAnim do
War.Person[pid].effect=t
WarDelay(1)
end
lib.GetKey()
War.Person[pid].effect=0
end
if i==3 then
War.Person[eid].frame=0
War.Person[eid].d=d2
War.Person[eid].action=3
War.Person[eid].effect=256
PlayWavE(31)
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n)
end
War.Person[eid].effect=0
WarDelay(n*2)
lib.GetKey()
elseif kind==10 then
WarAction(1,id1,id2)
War.Person[pid].action=2
War.Person[eid].action=2
for i=0,3 do
War.Person[pid].frame=i
War.Person[eid].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8*CC.koAnim do
War.Person[pid].effect=t
War.Person[eid].effect=t
WarDelay(1)
end
lib.GetKey()
War.Person[pid].effect=0
War.Person[eid].effect=0
end
if i==3 then
War.Person[pid].effect=192
War.Person[eid].effect=192
PlayWavE(31)
WarDelay(n)
end
WarDelay(n)
end
War.Person[pid].effect=0
War.Person[eid].effect=0
WarDelay(n*2)
elseif kind==11 then
elseif kind==12 then
elseif kind==13 then
elseif kind==14 then
elseif kind==15 then
War.Person[pid].action=3
War.Person[pid].frame=0
WarDelay(n*2)
elseif kind==16 then
War.Person[pid].action=0
War.Person[pid].frame=0
WarDelay(n)
War.Person[pid].d=1
PlayWavE(6)
WarDelay(n*2)
War.Person[pid].action=3
War.Person[pid].frame=0
WarDelay(n*2)
PlayWavE(17)
for t=0,-256,-8 do
War.Person[pid].effect=t
WarDelay(1)
end
WarDelay(n*2)
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*4)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==17 then
War.Person[pid].action=5
WarDelay(n)
for i=1,5 do
War.Person[pid].frame=0
if War.Person[pid].action==9 then
War.Person[pid].action=5
PlayWavE(16)
else
War.Person[pid].action=9
end
WarDelay(n)
end
War.Person[pid].frame=-1
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*2)
WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["ĞÕÃû"].."G(^) …C…DPM!",M_White)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==18 then
War.Person[pid].frame=0
War.Person[pid].action=5
for i=1,6 do
if War.Person[pid].action==9 then
War.Person[pid].action=5
else
War.Person[pid].action=9
end
WarDelay(n-1)
lib.GetKey()
end
for i=1,16 do
if War.Person[pid].action==9 then
War.Person[pid].action=5
else
War.Person[pid].action=9
end
WarDelay(n-2)
lib.GetKey()
end
PlayWavE(22)
War.Person[pid].action=5
for i=128,256,12 do
War.Person[pid].effect=i
WarDelay(n)
end
WarDelay(n*2)
War.Person[pid].frame=-1
War.Person[pid].action=9
War.Person[pid].live=false
SetWarMap(War.Person[pid].x,War.Person[pid].y,2,0)
WarDelay(n*4)
WarDrawStrBoxDelay(JY.Person[War.Person[pid].id]["ĞÕÃû"].."G(^) ‚B‚rPM!",M_White)
if War.Person[pid].enemy then
War.EnemyNum=War.EnemyNum-1
end
elseif kind==19 then
War.Person[pid].action=5
War.Person[pid].frame=0
for i=0,5 do
War.Person[pid].frame=1-War.Person[pid].frame
WarDelay(n*2)
end
WarDelay(n*2)
end
WarResetStatus(pid)
WarResetStatus(eid)
War.ControlEnable=controlstatus
end

-- WarLastWords(wid)
-- Õ½³¡ÈËÎïÒÅÑÔ
function WarLastWords(wid)
local wp=War.Person[wid]
local name=JY.Person[wp.id]["ĞÕÃû"]
if true then--not wp.enemy then
if type(CC.LastWords[name])=='string' then
if wp.id==1 then
PlayBGM(4)
end
if CC.zdby==0 or wp.id==1 then
talk( wp.id,CC.LastWords[name])
end
end
end
end

-- Õ½³¡ÈËÎï±©»÷Ì¨´Ê
function WarAtkWords(wid)
local wp=War.Person[wid]
local name=JY.Person[wp.id]["ĞÕÃû"]
if CC.zdby==0 then--not wp.enemy then
if type(CC.AtkWords[name])=='string' then
talk( wp.id,CC.AtkWords[name])
else
local str={
"ƒO[[[¡­¡­!", "ann¡­¡­!", "…Enn¡­¡­!", "a…F¡­¡­!", "ƒm[[[¡­¡­!",
"…G‚S‚fn¡­¡­!", "…Hn‚f¡­¡­!", "ƒ_ …I‚pS …Hn‚f!!", "…G‚S‚f¡­¡­!", "…G‚S…J!!!",
"Z…K¡­¡­!", "…E„h¡­¡­!", "ƒm‚M‚M¡­¡­!", "ƒOƒOƒO¡­¡­!", "…C…C…C¡­¡­!",
"ƒm‚M!?", "…M!!", "ƒm‚M‚M!", "‚E[B‚f!!", "GM!!",
"¡­¡­¡­¡­¡­", "¡­¡­¡­¡­!", "…Hn …R ƒe‚Pƒv B‚f!!", "…GS ƒe‚Pƒv B‚f!", "…Hn…J!!"
}
local n=math.random(40)
if type(str[n])=='string' then
talk( wp.id,str[n])
end
end
end
end

-- ÓÃÓÚ¸÷ÖÖĞĞ¶¯ºó£¬Ê¹Õ½³¡ÈËÎï¶¯×÷»Ø¸´Ä¬ÈÏ×´Ì¬
function WarResetStatus(wid)
if between(wid,1,War.PersonNum) then
local v=War.Person[wid]
local koWasDef=(War.koLastDef==wid)--ko 3.0: ê¸°ë¡ (the target's first reset after the attack)
if koWasDef then War.koLastDef=nil end
v.frame=-1
if v.live then
local id=v.id
if JY.Person[id]["±øÁ¦"]<=0 then
if v.action~=9 then
if v.enemy and koWasDef then koHook("unit_down",wid,War.koLastAtk) end--ko 3.1
v.action=5
WarDelay(4)
JY.Death=id
DoEvent(JY.EventID)
JY.Death=0
local koWarOver=(JY.Status~=GAME_WMAP)--ko 5.0: the death event ended the battle: no last words over the next scene (10-10)
if v.action~=9 and not koWarOver then
WarLastWords(wid)
if id==1 then
WarAction(18,id)
else
WarAction(17,id)
end
end
end
elseif v.troubled then
v.action=7
elseif JY.Person[id]["±øÁ¦"]/JY.Person[id]["×î´ó±øÁ¦"]<=0.30 then
v.action=5
elseif v.active then
v.action=1
else
v.action=0
end
if v.ai==6 then
if v.x==v.ai_dx and v.y==v.ai_dy then
v.ai=4
end
end
if CC.Enhancement then
ReSetAttrib(id,false) 
end
end
end
ReSetAllBuff()
end

--»ñµÃ¾­ÑéÖµ
function WarAddExp(id,Exp)
if Exp<=0 then
return
end
local pid=War.Person[id].id
if JY.Person[pid]["µÈ¼¶"]>=99 then
return
end
local oldExp=JY.Person[pid]["¾­Ñé"]
local lvupflag=false
local Exp2=0
if oldExp+Exp>100 then
Exp2=oldExp+Exp-100
Exp=Exp-Exp2
end
for i=0,Exp do
JY.Person[pid]["¾­Ñé"]=oldExp+i
for t=1,(i%CC.koAnim==0 and 1 or 0) do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id,true)
lib.GetKey()
ReFresh()
end
if JY.Person[pid]["¾­Ñé"]==100 then
lvupflag=true
WarLvUp(id)
JY.Person[pid]["¾­Ñé"]=0
oldExp=0
end
end
if Exp2>0 then
for i=0,Exp2 do
JY.Person[pid]["¾­Ñé"]=0+i
for t=1,(i%CC.koAnim==0 and 1 or 0) do
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawStatusMini(id,true)
lib.GetKey()
ReFresh()
end
end
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*3)
WarDelay(4)
if lvupflag then
JY.Person[pid]["¾­Ñé"]=oldExp+Exp2
else
JY.Person[pid]["¾­Ñé"]=oldExp+Exp
end
end

function WarAddExp2(id,Exp)--¾­ÑéÒÔ¼°Éı¼¶£¬µ«ÊÇÎŞÈÎºÎÏÔÊ¾
end

function WarLvUp(id)--Éı¼¶£¬ÒÔ¼°¶¯»­
if id==0 then
return
end
War.SelID=id
BoxBack()
local pid=War.Person[id].id
War.Person[id].action=0
for t=1,2 do
War.Person[id].d=3
WarDelay(koAnimD(3))
War.Person[id].d=2
WarDelay(koAnimD(3))
War.Person[id].d=4
WarDelay(koAnimD(3))
War.Person[id].d=1
WarDelay(koAnimD(3))
end
PlayWavE(11)
War.Person[id].action=6
WarDelay(koAnimD(16))
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒP ‚R‚{G ƒi„gM!",M_White)
local magic={}
for mid=1,JY.MagicNum-1 do
magic[mid]=false
if WarHaveMagic(id,mid) then
magic[mid]=true
end
end
JY.Person[pid]["µÈ¼¶"]=limitX(JY.Person[pid]["µÈ¼¶"]+1,1,99)
ReSetAttrib(pid,false)
WarResetStatus(id)
WarDelay(4)
--ÌáÊ¾¼¼ÄÜ²ßÂÔÏ°µÃ
if CC.Enhancement==true then
for i=1,6 do
if JY.Person[pid]["µÈ¼¶"]==CC.SkillExp[JY.Person[pid]["³É³¤"]][i] then
PlayWavE(11)
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) ƒGƒHS …S…TM: "..JY.Skill[JY.Person[pid]["ÌØ¼¼"..i]]["Ãû³Æ"].."£¡",M_White)
break
end
end
end
local str=""
for mid=1,JY.MagicNum-1 do
if not magic[mid] then
if WarHaveMagic(id,mid) then
if str=="" then
str=JY.Magic[mid]["Ãû³Æ"]
else
str=str..", "..JY.Magic[mid]["Ãû³Æ"]
end
end
end
end
if #str>0 then
PlayWavE(11)
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) ‚u‚vS …S…TM: "..str.."£¡",M_White)
end
War.LastID=War.SelID
War.SelID=0
end

function WarBingZhongUp(id,bzid)--±øÖÖ±ä¸ü£¬¶¯»­
if id==0 then
return
end
local MenuPicNum=JY.MenuPic.num
JY.MenuPic.num=0
local pid=War.Person[id].id
local oldaction=War.Person[id].action
--Ê¹ÓÃÎïÆ·¶¯×÷
War.Person[id].action=0
War.Person[id].d=1
WarDelay(2)
PlayWavE(41)
War.Person[id].action=6
WarDelay(16)
--×ªÈ¦£¬Éı¼¶¶¯×÷
War.Person[id].action=0
for t=1,2 do
War.Person[id].d=3
WarDelay(koAnimD(3))
War.Person[id].d=2
WarDelay(koAnimD(3))
War.Person[id].d=4
WarDelay(koAnimD(3))
War.Person[id].d=1
WarDelay(koAnimD(3))
end
PlayWavE(12)
War.Person[id].action=6
for i=0,256,8*CC.koAnim do
War.Person[id].effect=i
WarDelay(1)
end
JY.Person[pid]["±øÖÖ"]=bzid
War.Person[id].bz=bzid
War.Person[id].movewav=JY.Bingzhong[bzid]["ÒôĞ§"]--ÒÆ¶¯ÒôĞ§
War.Person[id].atkwav=JY.Bingzhong[bzid]["¹¥»÷ÒôĞ§"]--¹¥»÷ÒôĞ§
War.Person[id].movestep=JY.Bingzhong[bzid]["ÒÆ¶¯"]--ÒÆ¶¯·¶Î§
War.Person[id].movespeed=JY.Bingzhong[bzid]["ÒÆ¶¯ËÙ¶È"]--ÒÆ¶¯ËÙ¶È
War.Person[id].atkfw=JY.Bingzhong[bzid]["¹¥»÷·¶Î§"]--¹¥»÷·¶Î§
War.Person[id].pic=WarGetPic(id)
for i=240,0,-8*CC.koAnim do
War.Person[id].effect=i
WarDelay(1)
end
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."ƒP ‚~T ¡ú "..JY.Bingzhong[bzid]["Ãû³Æ"].."!",M_White)
ReSetAttrib(pid,false)
War.Person[id].action=oldaction
JY.MenuPic.num=MenuPicNum
for n=1,8 do
if JY.Person[pid]["µÀ¾ß"..n]==0 then
JY.Person[pid]["µÀ¾ß"..n]=173
WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) ƒ@…UƒP ƒT„hS …V„kM",M_White)
break
end
end
end

function limitX(x,minv,maxv)--ÏŞÖÆxµÄ·¶Î§
if x<minv then
x=minv
elseif x>maxv then
x=maxv
end
return x
end
function SetWarConst()
War.DX={[0]="ƒwƒQ","|‚O","„[‚C","a‚s","„W„X",
"ƒ{…W","ƒ{‚C","ƒ|ƒQ","…XS","…Y…W",
"ƒ{…Z","‚UI‚C","…[…@u","ƒ{…^","‚~~",
"‚T„Xƒd","ƒsƒAƒd","^…_","@…`","…a]"}
-- 00 Æ½Ô­ 01 É­ÁÖ 02 É½µØ 03 ºÓÁ÷ 04 ÇÅÁº 05 ³ÇÇ½ 06 ³Ç³Ø 07 ²İÔ­
-- 08 ´å×¯ 09 ĞüÑÂ 0A ³ÇÃÅ 0B »ÄµØ 0C Õ¤À¸ 0D Â¹íÎ 0E ±øÓª 0F Á¸²Ö
-- 10 ±¦Îï¿â 11 ·¿Éá 12 »ğÑæ 13 ×ÇÁ÷
War.Width=64--µØÍ¼³ß´ç
War.Depth=64
War.OX=16 War.OY=32
War.MW=12--old game 13
War.MD=9--old game 11
koWarLayout()--ko 3.0
War.BoxWidth=48--µØÍ¼·½¸ñ³ß´ç
War.BoxDepth=48
War.CX=1--×óÉÏ½Ç·½¸ñÎ»ÖÃ
War.CY=1
War.MX=1--·½¸ñËùÔÚÎ»ÖÃ
War.MY=1
War.OldX=0--¼ÇÂ¼ÈËÎïÒÆ¶¯Ç°×ø±ê
War.OldY=0
War.InMap=false--±ê¼ÇÊó±êÊÇ·ñÔÚµØÍ¼·¶Î§ÄÚ
War.OldMX=-1--¼ÇÂ¼MXMYfor Êó±ê²Ù×÷ ÒÆ¶¯´°¿ÚÓÃ
War.OldMY=-1
War.DXpic=0--¼ÇÂ¼µ±Ç°µØĞÎÍ¼Æ¬
War.FrameT=0
War.Frame=0
War.MoveScreenFrame=0
War.ControlStatus="select"
War.PersonNum=0
War.Weather=math.random(6)-1
War.Turn=1--µ±Ç°»ØºÏ
War.MaxTurn=30--×î´ó»ØºÏ
War.Leader1=-1
War.Leader2=-1
War.CurID=0
War.SelID=0
War.LastID=0--¾ÍÊÇCurID£¬µ±ÒÆ¶¯µ½·ÇÈËÎïÊ±£¬±£³ÖÉÏÒ»¸öÈËÎïID
War.EnemyNum=0
War.FunButtom=0--µ±Ç°Ëù´¦ÓÚµÄ°´Å¥
War.ControlEnableOld=true
War.ControlEnable=true
War.YD=0
end

-- ÏÔÊ¾Õ½³¡µØÍ¼
function DrawWarMap()
koWarEnsure()
War.CX=limitX(War.CX,1,math.max(1,War.Width-War.MW+1))--ko 3.0
War.CY=limitX(War.CY,1,math.max(1,War.Depth-War.MD+1))
local x,y=War.CX,War.CY
lib.FillColor(0,0,0,0,0)
local x0,y0=x,y
local cx,cy=War.OX,War.OY
x0=limitX(x0,0,War.Width)
y0=limitX(y0,0,War.Depth)
local xoff=x-math.modf(x)
local yoff=y-math.modf(y)
lib.SetClip(cx,cy,cx+War.BoxWidth*War.MW,cy+War.BoxDepth*War.MD)
lib.PicLoadCache(0,(rawget(_G,"koNightPic") and koNightPic(War.MapID) or War.MapID)*2,cx-War.BoxWidth*(x-1),cy-War.BoxDepth*(y-1),1)
lib.SetClip(0,0,0,0)
for i=x,x+War.MW-1 do
for j=y,y+War.MD-1 do
local v=GetWarMap(i,j,1)
if v==18 then
lib.PicLoadCache(4,(250+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1)
elseif v==19 then
lib.PicLoadCache(4,(252+War.Frame%2)*2,cx+War.BoxWidth*(i-x),cy+War.BoxDepth*(j-y),1)
end
end
end
for x=War.CX,math.min(War.CX+War.MW,War.Width) do
for y=War.CY,math.min(War.CY+War.MD,War.Depth) do
if koHook("draw_range_cell",x,y,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY))==nil and GetWarMap(x,y,4)==0 then--ko 3.1 addon range; ²»¿ÉÒÆ¶¯
lib.Background(cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),cx+War.BoxWidth*(x-War.CX+1),cy+War.BoxDepth*(y-War.CY+1),128)
end
if GetWarMap(x,y,10)==1 then--¹¥»÷·¶Î§
lib.PicLoadCache(4,261*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
elseif GetWarMap(x,y,10)==2 then--ÖÎÁÆ·¶Î§
lib.PicLoadCache(4,262*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
end
end
end
koHook("draw_overlay",cx,cy)--ko 3.1: overlays between the range marks and the units
if War.InMap then
DrawGameBox(cx+War.BoxWidth*(War.MX-War.CX),cy+War.BoxDepth*(War.MY-War.CY),cx+War.BoxWidth*(War.MX-War.CX+1),cy+War.BoxDepth*(War.MY-War.CY+1),M_White,-1)
end
local size=48
local size2=64
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if between(v.x,x,x+War.MW-1) and between(v.y,y,y+War.MD-1) then--limit XY
local frame
if v.frame>=0 then
frame=v.frame
else
frame=War.Frame
end
local left=cx+War.BoxWidth*(v.x-x)
local top=cy+War.BoxDepth*(v.y-y)
--0¾²Ö¹ 1ÒÆ¶¯ 2¹¥»÷ 3·ÀÓù 4±»¹¥»÷ 5´­Æø 7»ìÂÒ 9²»´æÔÚ
--v.action=7 ²âÊÔ»ìÂÒÍ¼Æ¬ÓÃ
if v.action==0 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1)
if not v.active then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+4,128)
end
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+16+v.d-1)*2,left,top,1+2,256+v.effect)
end
elseif v.action==1 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+frame%2+(v.d-1)*4)*2,left,top,1+2,256+v.effect)
end
elseif v.action==2 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1)
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2+8,v.effect) 
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+30+frame+4*(v.d-1))*2,left+(size-size2)/2,top+(size-size2)/2,1+2,256+v.effect) 
end
elseif v.action==3 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1)
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+22+(v.d-1))*2,left,top,1+2,256+v.effect)
end
elseif v.action==4 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+26+(v.d-1)%2)*2,left,top,1+2,256+v.effect)
end
elseif v.action==5 then
if v.effect==0 then
if v.active then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1)
else
lib.PicLoadCache(1,(v.pic+20)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+20)*2,left,top,1+2+4,128)
end
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+20+frame%2)*2,left,top,1+2,256+v.effect)
end
elseif v.action==6 then
if v.effect==0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1)
elseif v.effect>0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1)
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2+8,v.effect)
elseif v.effect<0 then
lib.PicLoadCache(1,(v.pic+28)*2,left,top,1+2,256+v.effect)
end
elseif v.action==7 then--»ìÂÒ
local hlpic=5010
if v.enemy then
hlpic=5012
elseif v.friend then
hlpic=5014
else
hlpic=5010
end
lib.PicLoadCache(1,(hlpic+frame%2)*2,left,top,1)
end
if (v.poison or 0)>0 then lib.PicLoadCache(1,(5016+frame%2)*2,left,top,1) end
if v.hurt>=0 then
DrawString(left+size/2-#(v.hurt.."")*5,top,v.hurt,M_White,20)
end
end
end
end
koHook("draw_units_over")--ko 3.4: marks drawn over the units (preview: class matchup)
if War.InMap and not koTouch() then--ko 5.0 touch: no edge scrolling on the phone
local edx,edy=koEdgeDir(War.MX-War.CX,War.MY-War.CY)--ko: scroll arrow, diagonals at the corners
if edx~=0 or edy~=0 then
local pic=CC.koEdgePic[edy*3+edx]
lib.PicLoadCache(4,pic[1]*2,War.OX+War.BoxWidth*(War.MX-War.CX)+pic[2],War.OY+War.BoxDepth*(War.MY-War.CY)+pic[3],1)
end
end
if War.ControlStatus=="select" then
if War.ControlEnable then
local koId=War.CurID--ko 3.1: the pointer inside the last mini window keeps that window (so its íŠ¹ê¸° boxes can be hovered)
if War.koMini and War.Person[War.koMini.id] and War.Person[War.koMini.id].live and MOUSE.IN(War.koMini.x1,War.koMini.y1,War.koMini.x2,War.koMini.y2) and (War.CurID==0 or War.CurID==War.koMini.id) then koId=War.koMini.id end--ko 3.3: another unit under the pointer wins
if koId==0 and koTouch() then koId=koTouchPin() end--ko 4.0 touch: the last tapped unit keeps its window
if koId>0 and koWide() then--ko 5.1 (10-16): the í‹€ panel already shows the unit under the pointer
DrawStatusMini(koId)
if War.koMiniTip then koSkillTipTable(War.koMiniTip.pid,War.koMiniTip.x,War.koMiniTip.y,0) end
if War.koMiniForm and War.koMiniForm.wid==koId and rawget(_G,"koFormTip") and MOUSE.IN(War.koMiniForm.x1,War.koMiniForm.y1,War.koMiniForm.x2,War.koMiniForm.y2) then koFormTip(koId) end--ko 5.1: formation tooltip
if War.koMiniLink and War.koMiniLink.wid==koId and MOUSE.IN(War.koMiniLink.x1,War.koMiniLink.y1,War.koMiniLink.x2,War.koMiniLink.y2) then koLinkTip(War.koMiniLink.list) end--ko 5.1 (10-15): link tooltip
else War.koMini=nil end
end
elseif War.ControlStatus=="selectAtk" then
if War.ControlEnable then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then
if not koHook("hover_atk",War.SelID,eid) then--ko 3.1: an addon may draw its own popup
DrawStatusMini(eid)
end
end
end
elseif War.ControlStatus=="checkDX" then
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(War.MX-War.CX)-136
else
menux=War.OX+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=War.OY+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=War.OY+War.BoxWidth*(War.MY-War.CY)
end
lib.Background(menux,menuy,menux+136,menuy+86,160)
menux=menux+8
menuy=menuy+8
lib.LoadSur(War.DXpic,menux,menuy)
DrawString(menux+56,menuy+8,"„N‚S y{",M_White,16)
local T={[0]="£°£¥","£²£°£¥","£³£°£¥","£­£¥","£°£¥","£­£¥","£°£¥","£µ£¥",
"£µ£¥","£­£¥","£­£¥","£°£¥","£­£¥","£³£°£¥","£±£°£¥","£°£¥",
"£°£¥","£­£¥","£­£¥","£­£¥",}
DrawString(menux+88-#T[dx]*4,menuy+32,T[dx],M_White,16)
--É­ÁÖ 20 É½µØ 30 ´å×¯ 5
--²İÔ­ 5 Â¹Õ¯ 30 ±øÓª 10
-- 00 Æ½Ô­ 01 É­ÁÖ 02 É½µØ 03 ºÓÁ÷ 04 ÇÅÁº 05 ³ÇÇ½ 06 ³Ç³Ø 07 ²İÔ­
-- 08 ´å×¯ 09 ĞüÑÂ 0A ³ÇÃÅ 0B »ÄµØ 0C Õ¤À¸ 0D Â¹íÎ 0E ±øÓª 0F Á¸²Ö
-- 10 ±¦Îï¿â 11 ·¿Éá 12 »ğÑæ 13 ×ÇÁ÷
DrawString(menux,menuy+56,War.DX[dx],M_White,16)
if dx==8 or dx==13 or dx==14 then
DrawString(menux+56,menuy+56,"‚}‚D „O‚M",M_White,16)
end
--´å×¯¡¢Â¹íÎ¿ÉÒÔ»Ö¸´Ê¿ÆøºÍ±øÁ¦£®±øÓª¿ÉÒÔ»Ö¸´±øÁ¦£¬µ«²»ÄÜ»Ö¸´Ê¿Æø£®
--Óñçô¿ÉÒÔ»Ö¸´±øÁ¦ºÍÊ¿Æø£¬Ô®¾ü±¨¸æ¿ÉÒÔ»Ö¸´±øÁ¦£¬ÉâÃüÊé¿ÉÒÔ»Ö¸´Ê¿Æø£®
--µØĞÎºÍ±¦ÎïµÄ»Ö¸´ÄÜÁ¦²»ÄÜµş¼Ó£¬Ò²¾ÍÊÇËµ£¬´¦ÓÚ´å×¯µØĞÎÉÏÔÙ³ÖÓĞ»Ö¸´ĞÔ±¦Îï£¬ÓëÃ»ÓĞ³ÖÓĞ»Ö¸´ĞÔ±¦ÎïĞ§¹ûÏàÍ¬£®µ«Èç¹ûµØĞÎÖ»ÄÜ»Ö¸´±øÁ¦£¨Èç±øÓª£©£¬µ«±¦Îï¿ÉÒÔ»Ö¸´±øÁ¦£¬ÕâÖÖÇé¿öÏÂ£¬±øÁ¦Ê¿Æø¶¼ÄÜµÃµ½×Ô¶¯»Ö¸´£®
end
local koW=koWide()
local koPid=koPanelID()
if koW then
-- ko 3.0 wide layout: no frame. Top bar buttons, name and weather float over the map
koBarButton(14,6,80,24,"ƒGƒM")
if War.ControlStatus=="select" then
koBarButton(90,6,134,24,"n‚T")
koBarButton(140,6,184,24,"ƒL‚T")
for koI,koB in ipairs(koAddon.barButtons) do--ko 3.1: registered bar buttons (50 px apart from x=190)
if (not koB.show) or koB.show() then local koX1,koX2=koBarPos(koI) koBarButton(koX1,6,koX2,24,koBarLabel(koB)) end
end
end
local koNw=#War.WarName*4
local koCx=koWarNameCx()
lib.Background(koCx-koNw-10,6,koCx+koNw+10,24,160,M_Black)
lib.DrawRect(koCx-koNw-10,6,koCx+koNw+10,24,M_Gray)
-- the status panel sits at the right (x 600..768) unless the shown unit is on the right half, then at the left
if not War.koListOpen then
War.koPX=CC.ScreenW-768
if koPid>0 and War.Person[koPid] and (War.Person[koPid].x-War.CX)>=War.MW/2 then War.koPX=-600 end
end
else
koFrameDraw()--ko 11-06: frame follows the map
end
DrawString((koW and koWarNameCx() or 381+math.floor(koFramePX()/2))-#War.WarName*16/2/2,8,War.WarName,M_White,16)
if koW and War.Turn and War.MaxTurn then local koTurnBox=War.Turn.."/"..War.MaxTurn.."p" local koTx=koWarNameCx()+#War.WarName*4+16 lib.Background(koTx,6,koTx+#koTurnBox*8+12,24,160,M_Black) lib.DrawRect(koTx,6,koTx+#koTurnBox*8+12,24,M_Gray) DrawString(koTx+6,8,koTurnBox,M_White,16) end--ko 5.0: turn counter next to the battle name (10-09)
local koWx,koWy=724+koFramePX(),35
if koW then koWx,koWy=CC.ScreenW-28,4 lib.Background(koWx-4,koWy-2,koWx+26,koWy+24,160,M_Black) end
if War.Weather<3 then
lib.PicLoadCache(4,190*2,koWx,koWy,1)
elseif War.Weather>3 then
lib.PicLoadCache(4,192*2,koWx,koWy,1)
else
lib.PicLoadCache(4,191*2,koWx,koWy,1)
end
if War.ControlStatus=="select" and not koW then--ko 3.0: the wide bar draws its own hover look
if War.FunButtom==1 then
lib.PicLoadCache(4,57*2,15,7,1)
elseif War.FunButtom==2 then
lib.PicLoadCache(4,58*2,15,7,1)
end
end
if koW then
if koPid>0 then
local px=War.koPX or 0
lib.Background(600+px,32,768+px,364,176,M_Black)
lib.DrawRect(600+px,32,767+px,363,M_Gray)
-- DrawStatus prefers SelID, so point it at the panel's unit while drawing
local koS,koL=War.SelID,War.LastID
War.SelID,War.LastID=koPid,0
local koOk,koErr=pcall(koDrawShift,px,0,DrawStatus)
War.SelID,War.LastID=koS,koL
if not koOk then error(koErr,0) end
end
War.MiniMapCX=math.min(CC.ScreenW-88-War.Width*koMiniS()/2,CC.ScreenW-10-War.Width*koMiniS())--ko 3.6: wide maps keep the minimap on screen
War.MiniMapCY=math.min(CC.ScreenH-69-War.Depth*koMiniS()/2,CC.ScreenH-10-War.Depth*koMiniS())
if koMiniShown() then--ko 3.3
lib.Background(War.MiniMapCX-6,War.MiniMapCY-6,War.MiniMapCX+War.Width*koMiniS()+6,War.MiniMapCY+War.Depth*koMiniS()+6,176,M_Black)
lib.DrawRect(War.MiniMapCX-6,War.MiniMapCY-6,War.MiniMapCX+War.Width*koMiniS()+5,War.MiniMapCY+War.Depth*koMiniS()+5,M_Gray)
end
else
War.koPanelSkill=nil
local koFP=koFramePX()
koDrawShift(koFP,0,DrawStatus)
if War.koPanelSkill then War.koPanelSkill[2]=War.koPanelSkill[2]+koFP end
for _,koR in ipairs({War.koPanelForm or false,War.koPanelLink or false}) do if koR then koR.x1=koR.x1+koFP koR.x2=koR.x2+koFP end end
War.MiniMapCX=680+koFP-War.Width*koMiniS()/2 War.MiniMapCY=CC.ScreenH-69-War.Depth*koMiniS()/2--ko 3.6
end
if koMiniShown() then--ko 3.3
local koMs=koMiniS()--ko 3.6
lib.PicLoadCache(0,(koMs==2 and koMiniSmall[War.MapID] or (rawget(_G,"koNightPic") and koNightMini(War.MapID)) or 100+War.MapID)*2,War.MiniMapCX,War.MiniMapCY,1)
for i=1,War.Width do
for j=1,War.Depth do
if GetWarMap(i,j,9)~=0 then
local x=War.MiniMapCX+(i-1)*koMs
local y=War.MiniMapCY+(j-1)*koMs
lib.FillColor(x,y,x+koMs,y+koMs,M_DarkOrchid)
end
end
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
local color=M_Blue
if v.enemy then
color=M_Red
elseif v.friend then
color=M_DarkOrange
end
local x=War.MiniMapCX+(v.x-1)*koMs
local y=War.MiniMapCY+(v.y-1)*koMs
lib.FillColor(x,y,x+koMs,y+koMs,color)
if not (v.enemy or v.friend or v.active) then--ko 3.6: allies that already acted: a light grey cell
lib.FillColor(x,y,x+koMs,y+koMs,RGB(205,205,205))
end
end
end
lib.DrawRect(War.MiniMapCX+(War.CX-1)*koMs,War.MiniMapCY+(War.CY-1)*koMs,War.MiniMapCX+(War.CX+War.MW-1)*koMs,War.MiniMapCY+(War.CY+War.MD-1)*koMs,M_Yellow)
end
if not koW then--ko 5.2.7: the frame panel's tooltips (íŠ¹ê¸°Â·ì§„í˜•Â·ì—°ê³„) last, so the minimap and the frame no longer cover them
if War.koPanelSkill then koSkillTipTable(War.koPanelSkill[1],War.koPanelSkill[2],War.koPanelSkill[3],0) end
if War.ControlStatus=="select" and War.ControlEnable then koPanelTips() end
end
for i=1,JY.MenuPic.num do
lib.LoadSur(JY.MenuPic.pic[i],JY.MenuPic.x[i],JY.MenuPic.y[i])
end
War.FrameT=War.FrameT+1
if War.FrameT>=32 then
War.FrameT=0
end
War.Frame=math.modf(War.FrameT/8)
end

-- ko 5.1 (10-16): tooltips of the í‹€ panel's ì§„í˜• and ì—°ê³„ rows (DrawStatus sets the rectangles)
function koPanelTips()
local f,l=War.koPanelForm,War.koPanelLink
if f and rawget(_G,"koFormTip") and War.Person[f.wid] and MOUSE.IN(f.x1,f.y1,f.x2,f.y2) then koFormTip(f.wid) end
if l and MOUSE.IN(l.x1,l.y1,l.x2,l.y2) then koLinkTip(l.list) end
end
function DrawStatusMini(id,flag)
flag=flag or false
local pid=War.Person[id].id
local x,y=War.Person[id].x,War.Person[id].y
local bz=JY.Person[pid]["±øÖÖ"]
local menux,menuy
if x-War.CX>math.modf(War.MW/2) then
menux=War.OX+War.BoxWidth*(x-War.CX)-180
else
menux=War.OX+War.BoxWidth*(x-War.CX+1)
end
if y-War.CY>math.modf(War.MD/2) then
menuy=War.OY+War.BoxWidth*(y-War.CY)-72
else
menuy=War.OY+War.BoxWidth*(y-War.CY)
end
local koH=(CC.Enhancement and 168 or 120)+((rawget(_G,"koFormLine") and koFormLine(War.Person[id])) and 20 or 0)--ko 3.1: two rows of íŠ¹ê¸° boxes under the terrain row (rows end at +164)
local koLL=koMiniLinks(id) if koLL then koH=koH+20 end if rawget(_G,"koAwakeRowH") then koH=koH+koAwakeRowH(pid) end--ko 5.1 (10-15): one more row for the links
menuy=limitX(menuy,War.OY or 0,math.max(War.OY or 0,((War.OY or 0)+(War.BoxDepth or 48)*(War.MD or 9))-koH))--ko 10-14: inside the map (frame mode: above the bottom bar)-- the taller window must stay on screen
menux=limitX(menux,War.OX or 0,math.max(War.OX or 0,((War.OX or 0)+(War.BoxWidth or 48)*(War.MW or 12))-180))--ko 10-14: inside the map across too
lib.Background(menux,menuy,menux+180,menuy+koH,160)
War.koMini={id=id,x1=menux,y1=menuy,x2=menux+180,y2=menuy+koH}--ko 3.1: DrawWarMap keeps the window while the pointer is inside
menux=menux+2
menuy=menuy+2
local color=M_Cyan
local str="n‚T"
if War.Person[id].enemy then
color=M_Red
str="ƒL‚T"
elseif War.Person[id].friend then
color=M_DarkOrange
str="ƒO‚T"
end
if War.Person[id].troubled then
end
DrawString(menux,menuy,JY.Person[pid]["ĞÕÃû"],(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,color) or color),16)
DrawString(menux+((#JY.Person[pid]["ĞÕÃû"]>8) and (#JY.Person[pid]["ĞÕÃû"]*8+8) or 64),menuy,JY.Bingzhong[bz]["Ãû³Æ"].."¡¡Lv"..JY.Person[pid]["µÈ¼¶"],M_White,16)
local len=120
local T={
100*JY.Person[pid]["±øÁ¦"]/JY.Person[pid]["×î´ó±øÁ¦"],
math.min(100*JY.Person[pid]["Ê¿Æø"]/War.Person[id].sq_limited,100),
math.min(100*JY.Person[pid]["²ßÂÔ"]/math.max(JY.Person[pid]["×î´ó²ßÂÔ"],1),100),
100*JY.Person[pid]["¾­Ñé"]/100,
}
local n=4--ko 3.0: strategy points and experience rows added
for i=1,n do
local color
if T[i]<30 then
color=210
elseif T[i]<70 then
color=211
else
color=212
end
lib.FillColor(menux+48,menuy+4+i*20,menux+48+len,menuy+4+10+i*20,M_Black)
local xd=menux+48+math.max(1,math.floor(len*T[i]/100))
if T[i]>0 then
lib.SetClip(menux+48,menuy+4+i*20,xd,menuy+4+10+i*20)
lib.PicLoadCache(4,color*2,menux+48,menuy+4+i*20,1)
end
lib.SetClip(0,0,0,0)
end
menuy=menuy+20
DrawString(menux,menuy,string.format("‚~ƒ}¡¡¡¡ %4d/%d",JY.Person[pid]["±øÁ¦"],JY.Person[pid]["×î´ó±øÁ¦"]),M_White,16)
menuy=menuy+20
DrawString(menux,menuy,string.format("‚rƒG¡¡¡¡ %4d/%d",JY.Person[pid]["Ê¿Æø"],War.Person[id].sq_limited),M_White,16)
menuy=menuy+20
DrawString(menux,menuy,string.format("‚u‚v¡¡¡¡ %4d/%d",JY.Person[pid]["²ßÂÔ"],JY.Person[pid]["×î´ó²ßÂÔ"]),M_White,16)--ko 3.0
menuy=menuy+20
DrawString(menux,menuy,string.format("ƒ@…U¡¡¡¡ %4d/100",JY.Person[pid]["¾­Ñé"]),M_White,16)
menuy=menuy+20
do
local T={[0]="","£«£²£°£¥","£«£³£°£¥","","","","","£«£µ£¥",
"£«£µ£¥","","","","","£«£³£°£¥","£«£±£°£¥","",
"","","","",}
local dx=GetWarMap(x,y,1)
if CC.Enhancement then--ko 3.3 hotfix 5: terrain + the battle buffs (skills and terrain, what WarAtkHurt uses), as the frame layout's side panel
local koWp=War.Person[id]
DrawString(menux,menuy,War.DX[dx],M_White,16)
local koX=menux+56
for koI=1,2 do
local koV=((koI==1) and koWp.atk_buff or koWp.def_buff) or 0
local koS=((koI==1) and "\130\074" or "\132\078")..string.format("%+d%%",koV)
DrawString(koX,menuy,koS,(koV>0 and M_Lime) or (koV<0 and M_Red) or M_Gray,16)
koX=koX+#koS*8+8
end
else
DrawString(menux,menuy,string.format("%s",str,War),color,16)
DrawString(menux+64,menuy,string.format("%s %s",War.DX[dx],T[dx]),M_White,16)
end
local koFL=rawget(_G,"koFormLine") and koFormLine(War.Person[id])--ko 5.0: ì§„í˜•, a row of its own
War.koMiniForm=nil--ko 5.1: the formation row rectangle (hover: koFormTip)
if koFL then menuy=menuy+20 DrawString(menux,menuy,"\129\103\136\069",M_White,16) DrawString(menux+56,menuy,koFL,C_Name,16) War.koMiniForm={wid=id,x1=menux,y1=menuy,x2=menux+176,y2=menuy+20} end
War.koMiniLink=nil--ko 5.1 (10-15): the link row (hover: koLinkTip)
if koLL then menuy=menuy+20 DrawString(menux,menuy,"\133\066\132\084",M_White,16) DrawString(menux+56,menuy,koMiniLinkText(koLL),C_Name,16) War.koMiniLink={wid=id,list=koLL,x1=menux,y1=menuy,x2=menux+176,y2=menuy+20} end

end
if CC.Enhancement then--ko 3.1: íŠ¹ê¸° boxes (hover for the effect)
menuy=menuy+20
DrawString(menux,menuy+2,"\129\120\131\071",M_White,16)-- íŠ¹ê¸°
DrawSkillTable(pid,menux+40,menuy,0)
War.koMiniTip={pid=pid,x=menux+40,y=menuy}
end
end

--¾É·ç¸ñ
function DrawStatus()
local id
if War.SelID>0 then
id=War.SelID
elseif War.CurID>0 then
id=War.CurID
elseif War.LastID>0 then
id=War.LastID
else
return
end
local pid=War.Person[id].id
local p=JY.Person[pid]
local x=805
local y=140
local size=16
local len=100
local T={
{"‚~ ƒ}","‚rƒG„Q","‚J‚pƒ}","„N‚Sƒ}","‚u‚v„Q","ƒ@…U„Q"},
{100*p["±øÁ¦"]/p["×î´ó±øÁ¦"],p["Ê¿Æø"],math.min(p["¹¥»÷"]/20,100),math.min(p["·ÀÓù"]/20,100),100*p["²ßÂÔ"]/p["×î´ó²ßÂÔ"],p["¾­Ñé"]},
{p["±øÁ¦"].."/"..p["×î´ó±øÁ¦"],""..p["Ê¿Æø"],""..p["¹¥»÷"],""..p["·ÀÓù"],p["²ßÂÔ"].."/"..p["×î´ó²ßÂÔ"],""..p["¾­Ñé"]},
}
local x_off=x-785
DrawString(785+x_off,78,p["ĞÕÃû"].."¡¡"..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"],(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White),size)
DrawString(900+x_off,78,"‚R‚{"..p["µÈ¼¶"],M_White,size)
DrawString(820+x_off,105,p["ÎäÁ¦"],M_White,size)
DrawString(875+x_off,105,p["ÖÇÁ¦"],M_White,size)
DrawString(930+x_off,105,p["Í³ÂÊ"],M_White,size)
for i=1,6 do
DrawString(x,y,T[1][i],M_White,size)
local color
if T[2][i]<30 then
color=210
elseif T[2][i]<70 then
color=211
else
color=212
end
lib.FillColor(x+64,y+3,x+64+len,y+3+10,M_Black)
lib.SetClip(x+64,y+3,x+64+math.max(1,len*T[2][i]/100),y+3+10)
lib.PicLoadCache(4,color*2,x+64,y+3,1)
lib.SetClip(0,0,0,0)
DrawString(x+64+len/2-size*#T[3][i]/4,y,T[3][i],M_White,size)
y=y+size+12
end
end

--ĞÂ·ç¸ñ
function DrawStatus()
local id
if War.SelID>0 then
id=War.SelID
elseif War.CurID>0 then
id=War.CurID
elseif War.LastID>0 then
id=War.LastID
else
return
end
local wp=War.Person[id]
local pid=War.Person[id].id
local p=JY.Person[pid]
local x=801-48*4
local y=188--ko 5.1 (10-16): bar rows 16 apart, so the ì§„í˜• and ì—°ê³„ rows fit at the bottom (the í‹€ has no hover mini window)
local size=16
local len=90
local T={
{"‚~ ƒ}","‚rƒG„Q","‚J‚pƒ}","„N‚Sƒ}","‚u‚v„Q","ƒ@…U„Q"},
{math.min(100*p["±øÁ¦"]/p["×î´ó±øÁ¦"],100),math.min(p["Ê¿Æø"],100),math.min(p["¹¥»÷"]/20,100),math.min(p["·ÀÓù"]/20,100),math.min(100*p["²ßÂÔ"]/math.max(p["×î´ó²ßÂÔ"],1),100),p["¾­Ñé"]},
{p["±øÁ¦"].."/"..p["×î´ó±øÁ¦"],""..p["Ê¿Æø"],""..p["¹¥»÷"],""..p["·ÀÓù"],p["²ßÂÔ"].."/"..p["×î´ó²ßÂÔ"],""..p["¾­Ñé"]},
}
local x_off=x-785
for koI,koB in pairs({[3]=wp.atk_buff,[4]=wp.def_buff}) do if koB~=0 then local koS=T[3][koI]..string.format(" %+d%%",koB) if #koS>11 then koS=T[3][koI]..string.format("%+d%%",koB) end if #koS<=11 then T[3][koI]=koS end end end--ko 5.1 (10-16): ê³µ/ë°© buffs on the bars (11 characters fit the 90 px bar; longer: no space, then the number alone)
lib.PicLoadCache(4,230*2,800-48*4,73,1)
lib.PicLoadCache(2,p["Í·Ïñ´úºÅ"]*2,808-48*4,81,1)
lib.PicLoadCache(4,227*2,884-48*4,79,1)
lib.PicLoadCache(4,228*2,884-48*4,109,1)
lib.PicLoadCache(4,229*2,884-48*4,139,1)
DrawString(x,171,p["ĞÕÃû"].."¡¡"..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"].."Lv"..p["µÈ¼¶"],(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White),size)
for i,v in pairs({"ÎäÁ¦2","ÖÇÁ¦2","Í³ÂÊ2"}) do
local zbdy=54
if not War.Person[id].enemy then
zbdy=46
end
if CC.Enhancement==false then
zbdy=54
end
DrawString2(916-48*4,zbdy+i*30,string.format("%d",p[v]),M_White,size)
end
if CC.Enhancement then
if not War.Person[id].enemy then
local wljy=p["ÎäÁ¦¾­Ñé"]
--if p["ÎäÁ¦"]==100 then wljy=200 end
local str=string.format("%d",math.modf(wljy/2)).."£¥"
if wljy==200 then str="MAX"end DrawString2(916-49*4,60+30,str,M_White,16)
local zljy=p["ÖÇÁ¦¾­Ñé"]
--if p["ÖÇÁ¦"]==100 then zljy=200 end
str=string.format("%d",math.modf(zljy/2)).."£¥"
if zljy==200 then str="MAX"end DrawString2(916-49*4,60+60,str,M_White,16)
local tljy=p["Í³ÂÊ¾­Ñé"]
--if p["Í³ÂÊ"]==100 then tljy=200 end
str=string.format("%d",math.modf(tljy/2)).."£¥"
if tljy==200 then str="MAX"end DrawString2(916-49*4,60+90,str,M_White,16)
end
end
for i=1,6 do
DrawString(x,y,T[1][i],M_White,size)
local color
if T[2][i]<30 then
color=210
elseif T[2][i]<70 then
color=211
else
color=212
end
lib.FillColor(x+52,y+3,x+52+len,y+3+10,M_Black)
if T[2][i]>1 then
lib.SetClip(x+52,y+3,x+52+math.max(1,len*T[2][i]/100),y+3+10)
lib.PicLoadCache(4,color*2,x+52,y+3,1)
end
lib.SetClip(0,0,0,0)
DrawString2(x+52+len/2-size*#T[3][i]/4,y,T[3][i],M_White,size)
y=y+size
end
local leader=0
local forcename=""
leader=p["¾ıÖ÷"]--Ä¬ÈÏ¾ÍÊÇ×Ô¼ºµÄ¾ıÖ÷
if leader==0 then--µ±Ã»ÓĞÉè¶¨Ê±
if wp.enemy then--µĞÈË ¾ÍÓÃµĞÈËÖ÷Ë§µÄ¾ıÖ÷
leader=JY.Person[War.Leader2]["¾ıÖ÷"]
end
end
if leader>0 then
forcename=JY.Person[leader]["ĞÕÃû"]
else
if wp.enemy then
forcename="ƒL‚T"
elseif wp.friend then
forcename="ƒO‚T"
else
forcename="n‚T"
end
end
--ko: the box shows the displayed unit, not its lord. 3-char names get a smaller font to stay inside the 43px box
if not War.koListOpen then--ko: the army list draws the faction name in this box instead
local koNm=p["ĞÕÃû"]
local koSz=16
if #koNm*8>42 then koSz=14 end
DrawString(632-#koNm*koSz/4,40+(16-koSz)/2,koNm,M_White,koSz)
end
if CC.Enhancement then
DrawString(x,y,"ƒGƒH",M_White,size)
DrawSkillTable(pid,x+34,y)
if koWide() then koSkillTipTable(pid,x+34,y,0) else War.koPanelSkill={pid,x+34,y} end--ko 3.1: tooltip (5.2.7: the frame panel's is drawn by DrawWarMap after the minimap)
y=y+42+(rawget(_G,"koAwakeRowH") and koAwakeRowH(pid) or 0)
--ko 5.1 (10-16): ì§„í˜• and ì—°ê³„ rows (hover: koPanelTips)
War.koPanelForm=nil War.koPanelLink=nil
local koFL=rawget(_G,"koFormLine") and koFormLine(wp)
if koFL then DrawString(x,y+1,"\129\103\136\069",M_White,14) DrawString(x+32,y+1,koFL,C_Name,14) War.koPanelForm={wid=id,x1=x,y1=y,x2=x+143,y2=y+15} end
y=y+15
local koLL=koMiniLinks(id)
if koLL then DrawString(x,y+1,"\133\066\132\084",M_White,14) DrawString(x+32,y+1,koMiniLinkText(koLL),C_Name,14) War.koPanelLink={list=koLL,x1=x,y1=y,x2=x+143,y2=y+15} end
y=y+15
end
if CC.AIXS then
x=300
y=CC.ScreenH-size
if wp.ai==0 then
DrawString(x,y,"AI: q‚l …b‚p",M_White,size)
elseif wp.ai==1 then
DrawString(x,y,"AI: ƒM‚l …b‚p",M_White,size)
elseif wp.ai==2 then
DrawString(x,y,"AI: r‚n„Q ‚rq",M_White,size)
elseif wp.ai==3 then
DrawString(x,y,"AI: ‚J‚p "..JY.Person[wp.aitarget]["ĞÕÃû"],M_White,size)
elseif wp.ai==4 then
DrawString(x,y,"AI: ‚J‚p "..wp.ai_dx..","..wp.ai_dy,M_White,size)
elseif wp.ai==5 then
DrawString(x,y,"AI: …cT "..JY.Person[wp.aitarget]["ĞÕÃû"],M_White,size)
elseif wp.ai==6 then
DrawString(x,y,"AI: G‚l "..wp.ai_dx..","..wp.ai_dy,M_White,size)
else
DrawString(x,y,"AI: ƒG…@ "..wp.aitarget.." "..wp.ai_dx..","..wp.ai_dy,M_White,size)
end
end
end

-- ko 3.1: íŠ¹ê¸° tooltip. Over one of the six skill boxes (the DrawSkillTable layout) the skill's name and effect are drawn
-- beside the pointer; a box the unit has not reached yet says at which level it comes. Used by the ì •ë³´ì°½ (PersonStatus),
-- the í‹€ battle panel (DrawStatus) and the mini status window, which stays up while the pointer is inside it for this
--ko 5.1 (10-15): the links a unit has now for the mini window, {{name,what},...} or nil (bond addon: every link; without it the base koLinkOnPid row)
function koMiniLinks(id)
if not CC.Enhancement or not War.Person[id] then return nil end
local pid=War.Person[id].id
local t={}
if rawget(_G,"koBondRows") then
local seen={}
for _,r in ipairs(koBondRows(pid)) do if not seen[r.name] then seen[r.name]=true t[#t+1]={r.name,r.what} end end
elseif rawget(_G,"koLinkOnPid") then
local r=koLinkOnPid(pid)
if r then t[1]={r[4],r[5]} end
end
return (#t>0) and t or nil
end
-- the row text (120 px = 15 bytes): every name joined by a middle dot if it fits, else one name + " +N"
function koMiniLinkText(list)
local all=list[1][1]
for k=2,#list do all=all.."\161\164"..list[k][1] end
if #all<=15 then return all end
local more=" +"..(#list-1)
for _,l in ipairs(list) do if #l[1]+#more<=15 then return l[1]..more end end
return list[1][1]
end
-- hovered link row: every link and what it gives, same look as the skill tooltip
function koLinkTip(list)
local head="\133\066\132\084"
local w=#head*8
for _,l in ipairs(list) do w=math.max(w,(#l[1]+2+#l[2])*8) end
w=w+24
local h=46+#list*20
local x,y=MOUSE.x+16,MOUSE.y+16
if x+w>CC.ScreenW then x=MOUSE.x-16-w end
if y+h>CC.ScreenH then y=MOUSE.y-16-h end
x=limitX(x,0,math.max(0,CC.ScreenW-w)) y=limitX(y,0,math.max(0,CC.ScreenH-h))
lib.SetClip(0,0,0,0)
koRecordClassicFrame(x,y,w,h)
lib.DrawRect(x+12,y+31,x+w-12,y+31,M_Silver)
DrawString(x+12,y+10,head,C_Name,16)
for i,l in ipairs(list) do
DrawString(x+12,y+18+i*20,l[1],M_Lime,16)
DrawString(x+12+#l[1]*8,y+18+i*20,": "..l[2],M_White,16)
end
end

function koSkillTipBox(sid,locked,lv)
local name,desc
if locked then
name="\163\191\163\191"-- ï¼Ÿï¼Ÿ
desc="\130\082\130\123 "..lv.." \129\071\129\067\129\102\131\087 \129\075\131\068"-- ë ˆë²¨ N ì´ìƒì—ì„œ ìŠµë“
else
if sid==nil or sid<=0 or JY.Skill[sid]==nil then return end
name=JY.Skill[sid]["\195\251\179\198"] desc=JY.Skill[sid]["\203\181\195\247"]-- åç§° è¯´æ˜
end
local num,lines=Split(GenTalkString(desc,17),'*')
local w,h=304,44+num*20
local x,y=MOUSE.x+16,MOUSE.y+16
if x+w>CC.ScreenW then x=MOUSE.x-16-w end
if y+h>CC.ScreenH then y=MOUSE.y-16-h end
x=limitX(x,0,math.max(0,CC.ScreenW-w)) y=limitX(y,0,math.max(0,CC.ScreenH-h))
lib.SetClip(0,0,0,0)
koRecordClassicFrame(x,y,w,h)
lib.DrawRect(x+12,y+31,x+w-12,y+31,M_Silver)
DrawString(x+12,y+10,name,C_Name,16)
for i=1,num do if lines[i] and lines[i]~="" then DrawString(x+12,y+38+(i-1)*20,lines[i],M_White,16) end end
end
function koSkillTipTable(pid,x,y,flag)
local p=JY.Person[pid]
for i=1,6 do
local cx=x+36*((i-1)%3)
local cy=y+20*math.modf((i-1)/3)
if MOUSE.IN(cx,cy,cx+36,cy+20) then
local need=CC.SkillExp[p["\179\201\179\164"]][i]-- æˆé•¿
local learned=p["\181\200\188\182"]>=need or flag==2-- ç­‰çº§
koSkillTipBox(p["\204\216\188\188"..i],not learned,need)-- ç‰¹æŠ€
return true
end
end
return false
end
function DrawSkillTable(pid,x,y,flag)
flag=flag or 0
local p=JY.Person[pid]
local cx,cy
local box_w=36
local box_h=20
for i=1,6 do
local cx=x+box_w*((i-1)%3)
local cy=y+box_h*math.modf((i-1)/3)
lib.DrawRect(cx,cy,cx+box_w,cy,M_White)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_White)
lib.DrawRect(cx,cy,cx,cy+box_h,M_White)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_White)
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,240,M_Blue)
if p["µÈ¼¶"]>=CC.SkillExp[p["³É³¤"]][i] or flag==2 then
DrawString(cx+2,cy+2,JY.Skill[p["ÌØ¼¼"..i]]["Ãû³Æ"],M_White,16)
else
DrawString(cx+2,cy+2,"£¿£¿",M_Gray,16)
end
end
end

function CleanWarMap(lv,v)
for x=1,War.Width do
for y=1,War.Depth do
SetWarMap(x,y,lv,v)
end
end
end

function GetWarMap(x,y,lv)
if x>0 and x<=War.Width and y>0 and y<=War.Depth then
if lv==1 then
if War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==1 then
return 18
elseif War.Map[War.Width*War.Depth*(9-1)+War.Width*(y-1)+x]==2 then
return 19
else
return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]
end
else
return War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]
end
else
lib.Debug(string.format("error!GetWarMapx=%d,y=%d,width=%d,depth=%d",x,y,War.Width,War.Depth))
return 0
end
end

function SetWarMap(x,y,lv,v)
if x>0 and x<=War.Width and y>0 and y<=War.Depth then
War.Map[War.Width*War.Depth*(lv-1)+War.Width*(y-1)+x]=v
return 1
else
lib.Debug(string.format("error!SetWarMapx=%d,y=%d,v=%d,width=%d,depth=%d",x,y,v,War.Width,War.Depth))
return 0
end
end

function filelength(filename)--µÃµ½ÎÄ¼ş³¤¶È
local inp=io.open(filename,"rb")
if inp==nil then
return -1
end
local l=inp:seek("end")
inp:close()
return l
end

function LoadWarMap(id)
local len=filelength(CC.MapFile)
local data=Byte.create(len)
Byte.loadfile(data,CC.MapFile,0,len)
local map_num=58
local idx1,idx2,idx3,idx4=Byte.get8(data,16+256+12*id+8),Byte.get8(data,16+256+12*id+9),Byte.get8(data,16+256+12*id+10),Byte.get8(data,16+256+12*id+11)
if idx1<0 then
idx1=idx1+256
end
if idx2<0 then
idx2=idx2+256
end
if idx3<0 then
idx3=idx3+256
end
if idx4<0 then
idx4=idx4+256
end
local idx=idx4+256*idx3+256^2*idx2+256^3*idx1
War.Width=Byte.get8(data,idx)/2
War.Depth=Byte.get8(data,idx+1)/2
War.MiniMapCX=680-War.Width*2
War.MiniMapCY=411-War.Depth*2
War.Map={}
CleanWarMap(1,0)--µØĞÎ
CleanWarMap(2,0)--wid
CleanWarMap(3,0)--
CleanWarMap(4,1)--Ñ¡Ôñ·¶Î§
CleanWarMap(5,-1)--¹¥»÷¼ÛÖµ
CleanWarMap(6,-1)--²ßÂÔ¼ÛÖµ
CleanWarMap(7,0)--Ñ¡ÔñµÄ²ßÂÔ
CleanWarMap(8,0)--AIÇ¿»¯ÓÃ£¬ÎÒ¾üµÄ¹¥»÷·¶Î§
CleanWarMap(9,0)--Ë®»ğ¿ØÖÆ
CleanWarMap(10,0)--¹¥»÷·¶Î§£¬ÏÔÊ¾ÓÃ
 idx=idx+2+4*War.Width*War.Depth
for i=1,War.Width*War.Depth do
local v=Byte.get8(data,idx+(i-1))
if v<0 or v>19 then
lib.Debug(string.format("!!Error, MapID=%d,idx=%d,v=%d",id,i,v))
v=0
end
War.Map[i]=v--Byte.get8(data,idx+(i-1))
end
end

-- WarSearchMove(id,x,y)
-- Ñ°ÕÒÒÆ¶¯µ½x,yµÄ×î½üÂ·¾¶
-- flag,ÎªtrueÊ±ÎŞÊÓµĞÈËÀ¹Â·
function WarSearchMove(id,x,y,flag)
flag=flag or false
local stepmax=256
CleanWarMap(4,0)--µÚ4²ã×ø±êÓÃÀ´ÉèÖÃÒÆ¶¯£¬ÏÈ¶¼ÉèÎª0
local steparray={}--ÓÃÊı×é±£´æµÚn²½µÄ×ø±ê£®
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--¸ù¾İµÚ0²½µÄ×ø±êÕÒ³öµÚ1²½£¬È»ºó¼ÌĞøÕÒ
WarSearchMove_sub(steparray,i,id,flag)
if steparray[i+1].num==0 then
break
end
end
return
end

function WarSearchMove_sub(steparray,step,id,flag)--ÉèÖÃÏÂÒ»²½¿ÉÒÆ¶¯µÄ×ø±ê
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["±øÖÖ"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--µ±Ç°²½ÊıµÄÏàÁÚ¸ñ
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["µØĞÎ"..dx]
if CC.Enhancement and (WarCheckSkill(id,118) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
if CheckZOC(id,nx,ny) then
steparray[step1].m[num]=steparray[step].m[i]-elyd-JY.Bingzhong[bz]["ÒÆ¶¯"]
else
steparray[step1].m[num]=steparray[step].m[i]-elyd
end
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
end
end
end
end
end
steparray[step1].num=num
end

-- WarSearchBZ(id)
-- Ñ°ÕÒ×î½üÎÒ·½Ö¸¶¨±øÖÖ
function WarSearchBZ(id,bzid)
local stepmax=256
CleanWarMap(4,0)--µÚ4²ã×ø±êÓÃÀ´ÉèÖÃÒÆ¶¯£¬ÏÈ¶¼ÉèÎª0£¬
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--ÓÃÊı×é±£´æµÚn²½µÄ×ø±ê£®
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--¸ù¾İµÚ0²½µÄ×ø±êÕÒ³öµÚ1²½£¬È»ºó¼ÌĞøÕÒ
local eid=WarSearchBZ_sub(steparray,i,id,bzid,true)
if eid>0 then
return eid
end
if steparray[i+1].num==0 then
break
end
end
return 0
end

function WarSearchBZ_sub(steparray,step,id,bzid,flag)--ÉèÖÃÏÂÒ»²½¿ÉÒÆ¶¯µÄ×ø±ê
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["±øÖÖ"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--µ±Ç°²½ÊıµÄÏàÁÚ¸ñ
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["µØĞÎ"..dx]
if CC.Enhancement and (WarCheckSkill(id,118) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
 steparray[step1].x[num]=nx
 steparray[step1].y[num]=ny
 steparray[step1].m[num]=steparray[step].m[i]-elyd
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy==War.Person[eid].enemy then
-- ÓĞÈË »î×Å ·Ç·ü±ø 
if bzid==War.Person[eid].bz and JY.Person[War.Person[eid].id]["²ßÂÔ"]>=6 then
return eid
end
end
end
end
end
end
end
steparray[step1].num=num
return 0
end

-- WarSearchEnemy(id)
-- Ñ°ÕÒ×î½üµĞÈË
function WarSearchEnemy(id)
local stepmax=256
CleanWarMap(4,0)--µÚ4²ã×ø±êÓÃÀ´ÉèÖÃÒÆ¶¯£¬ÏÈ¶¼ÉèÎª0£¬
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--ÓÃÊı×é±£´æµÚn²½µÄ×ø±ê£®
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end
SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
local eidbk=0
for i=0,stepmax-1 do--¸ù¾İµÚ0²½µÄ×ø±êÕÒ³öµÚ1²½£¬È»ºó¼ÌĞøÕÒ
local eid=WarSearchEnemy_sub(steparray,i,id,true)
if eid>0 then
return eid
end
if eidbk==0 and eid<0 then
eidbk=-eid
end
if steparray[i+1].num==0 then
break
end
end
return eidbk
end

function WarSearchEnemy_sub(steparray,step,id,flag)--ÉèÖÃÏÂÒ»²½¿ÉÒÆ¶¯µÄ×ø±ê
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["±øÖÖ"]
local eidbk=0
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--µ±Ç°²½ÊıµÄÏàÁÚ¸ñ
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["µØĞÎ"..dx]
if CC.Enhancement and (WarCheckSkill(id,118) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
steparray[step1].m[num]=steparray[step].m[i]-elyd
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
-- ÓĞÈË »î×Å ·Ç·ü±ø µĞÈË 
--ÔÚÒÑ¾­ËÑÑ°¹ıµÄ×ø±êÀï£¬´æÔÚ¿ÉÒÔ¹¥»÷µÄ×ø±ê
local array=WarGetAtkFW(nx,ny,War.Person[id].atkfw)
for n=1,array.num do
if between(array[n][1],1,War.Width) and between(array[n][2],1,War.Depth) then
if GetWarMap(array[n][1],array[n][2],4)>0 and GetWarMap(array[n][1],array[n][2],2)==0 then
return eid
end
end
end
eidbk=-eid
end
end
end
end
end
end
steparray[step1].num=num
return 0
end

-- War_CalAtkFW(wid)
-- ÏÔÊ¾widµÄ¹¥»÷·¶Î§
function War_CalAtkFW(wid)
local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,War.Person[wid].atkfw)
for i=1,array.num do
local mx,my=array[i][1],array[i][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
SetWarMap(mx,my,10,1)
end
end
end

--¼ÆËã¿ÉÒÆ¶¯²½Êı
--id Õ½¶·ÈËid£¬
--stepmax ×î´ó²½Êı£¬
--flag=0 ÒÆ¶¯£¬ÎïÆ·²»ÄÜÈÆ¹ı£¬1 Îä¹¦£¬ÓÃ¶¾Ò½ÁÆµÈ£¬²»¿¼ÂÇµ²Â·£®
function War_CalMoveStep(id,stepmax,flag)--¼ÆËã¿ÉÒÆ¶¯²½Êı
CleanWarMap(4,0)--µÚ4²ã×ø±êÓÃÀ´ÉèÖÃÒÆ¶¯£¬ÏÈ¶¼ÉèÎª0£¬
local x=War.Person[id].x
local y=War.Person[id].y
local steparray={}--ÓÃÊı×é±£´æµÚn²½µÄ×ø±ê£®
for i=0,stepmax do
steparray[i]={}
steparray[i].num=0
steparray[i].x={}
steparray[i].y={}
steparray[i].m={}
end

SetWarMap(x,y,4,stepmax+1)
steparray[0].num=1
steparray[0].x[1]=x
steparray[0].y[1]=y
steparray[0].m[1]=stepmax
for i=0,stepmax-1 do--¸ù¾İµÚ0²½µÄ×ø±êÕÒ³öµÚ1²½£¬È»ºó¼ÌĞøÕÒ
War_FindNextStep(steparray,i,id,flag)
if steparray[i+1].num==0 then
break
end
end
return steparray
end

function War_FindNextStep(steparray,step,id,flag)--ÉèÖÃÏÂÒ»²½¿ÉÒÆ¶¯µÄ×ø±ê
local num=0
local step1=step+1
local pid=War.Person[id].id
local bz=JY.Person[pid]["±øÖÖ"]
for i=1,steparray[step].num do
if steparray[step].m[i]>0 then
local x=steparray[step].x[i]
local y=steparray[step].y[i]
for d=1,4 do--µ±Ç°²½ÊıµÄÏàÁÚ¸ñ
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local v=GetWarMap(nx,ny,4)
local dx=GetWarMap(nx,ny,1)
local elyd=JY.Bingzhong[bz]["µØĞÎ"..dx]
if CC.Enhancement and (WarCheckSkill(id,118) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==118) then
elyd=1
end
if v==0 and steparray[step].m[i]>=elyd and War_CanMoveXY(nx,ny,id,flag) then
num=num+1
steparray[step1].x[num]=nx
steparray[step1].y[num]=ny
if (not flag) and CheckZOC(id,nx,ny) then
steparray[step1].m[num]=0
else
steparray[step1].m[num]=steparray[step].m[i]-elyd
end
SetWarMap(nx,ny,4,steparray[step1].m[num]+1)
end
end
end
end
end
steparray[step1].num=num
end

function CheckZOC(id,x,y)
if CC.Enhancement then
if WarCheckSkill(id,34) then--Ç¿ĞĞ
return false
end
end
for d=1,4 do--µ±Ç°²½ÊıµÄÏàÁÚ¸ñ
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if nx>0 and nx<=War.Width and ny>0 and ny<=War.Depth then
local eid=GetWarMap(nx,ny,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[id].enemy~=War.Person[eid].enemy then
return true
end
end
end
return false
end

function War_CanMoveXY(x,y,pid,flag)--×ø±êÊÇ·ñ¿ÉÒÔÍ¨¹ı£¬ÅĞ¶ÏÒÆ¶¯Ê±Ê¹ÓÃ
local id1=War.Person[pid].id
local bz=JY.Person[id1]["±øÖÖ"]
local dx=GetWarMap(x,y,1)
if JY.Bingzhong[bz]["µØĞÎ"..dx]==0 then
return false
end
local eid=GetWarMap(x,y,2)
if eid>0 and (not flag) and War.Person[eid].live and (not War.Person[eid].hide) and War.Person[pid].enemy~=War.Person[eid].enemy then
return false
end
return true
end

function WarCanExistXY(x,y,pid)--×ø±êÊÇ·ñ¿ÉÒÔÍ¨¹ı
local id1=War.Person[pid].id
local bz=JY.Person[id1]["±øÖÖ"]
local dx=GetWarMap(x,y,1)
if JY.Bingzhong[bz]["µØĞÎ"..dx]==0 then
return false
end
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
return false
end
return true
end

function War_MovePerson(x,y,flag)--ÒÆ¶¯ÈËÎïµ½Î»ÖÃx,y
local koCEmv=War.ControlEnable--ko 4.0: a local (see koCEatk)
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
flag=flag or 0
local movenum=GetWarMap(x,y,4)
local dx,dy=x,y
local movetable={}-- ¼ÇÂ¼Ã¿²½ÒÆ¶¯
local mx,my=War.Person[War.SelID].x,War.Person[War.SelID].y
local dm=GetWarMap(mx,my,4)
local start=dm
local str=JY.Person[War.Person[War.SelID].id]["ĞÕÃû"]..'ƒP G‚l'
for i=1,dm do
if mx==x and my==y then
start=i-1
break
end
movetable[i]={}
movetable[i].x=x
movetable[i].y=y
local fx,fy
for d=1,4 do
local nx,ny=x-CC.DirectX[d],y-CC.DirectY[d]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
local v=GetWarMap(nx,ny,4)
if v>movenum then
movenum=v
fx,fy=nx,ny
movetable[i].direct=d
end
end
end
x,y=fx,fy
end
--8ÊÇ±ê×¼ËÙ¶È£¬6Æ«¿ì£¬4ºÜ¿ì,3¼«¿ì£¬12Âı,16
local step=War.Person[War.SelID].movespeed
if CC.MoveSpeed==1 then
step=1
end
SetWarMap(War.Person[War.SelID].x,War.Person[War.SelID].y,2,0)
SetWarMap(dx,dy,2,War.SelID)
War.ControlEnable=false
War.InMap=false
War.Person[War.SelID].action=1
local sframe=0
for i=start,1,-1 do
War.Person[War.SelID].d=movetable[i].direct
local cx=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]
local cy=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]
if War.SelID>0 then
if not between(War.CX,cx-War.MW+1,cx-1) then
War.CX=limitX(War.CX,cx-War.MW+3,cx-3)
War.CX=limitX(War.CX,1,War.Width-War.MW+1)
end
if not between(War.CY,cy-War.MD+1,cy-1) then
War.CY=limitX(War.CY,cy-War.MD+2,cy-2)
War.CY=limitX(War.CY,1,War.Depth-War.MD+1)
end
end
for t=1,step do
War.Person[War.SelID].x=War.Person[War.SelID].x+CC.DirectX[movetable[i].direct]/step
War.Person[War.SelID].y=War.Person[War.SelID].y+CC.DirectY[movetable[i].direct]/step
lib.GetKey(1)
War.Person[War.SelID].frame=math.modf(sframe/4)%2
if sframe==0 then
PlayWavE(War.Person[War.SelID].movewav)
end
if sframe==7 then
sframe=0
else
sframe=sframe+1
end
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
DrawYJZBox2(-256,64,str,M_White)
ReFresh()
end
War.Person[War.SelID].x=cx
War.Person[War.SelID].y=cy
end
if War.Person[War.SelID].active then
War.Person[War.SelID].action=1
else
War.Person[War.SelID].action=0
end
War.Person[War.SelID].frame=-1
War.Person[War.SelID].x=dx
War.Person[War.SelID].y=dy
BoxBack()
local pid=War.Person[War.SelID].id
ReSetAttrib(pid,false)
ReSetAllBuff()
War.CurID=0
War.ControlEnable=koCEmv
end

--ko class 30 (Xiang Yu) equips like class 9, class 31 (Liu Bang, mounted lord) like class 3 (sword line)

local koEquipAlias={[30]=9,[31]=3,[32]=16,[33]=4,[34]=27,[35]=16,[36]=29,[37]=4,[39]=27}
--ko 388 Mok-in / 407 Liu Bang / 408 Xiang Yu keep their exclusive class: no class change via trainer, battle debug menu or class-change items
--ko 3.6: the Qiao sisters - Da Qiao (411) and Xiao Qiao (412) next to each other: strategy cost halved (as skill 112), aid strategies x1.3
function koTwinOn(wid)
if not (CC.Enhancement and JY.Status==GAME_WMAP and War and War.Person) then return false end
local v=War.Person[wid]
if v==nil or (not v.live) or v.hide then return false end
local o=(v.id==411 and 412) or (v.id==412 and 411) or nil
if o==nil then return false end
for _,u in pairs(War.Person) do
if u.id==o and u.live and (not u.hide) and u.enemy==v.enemy and math.abs(u.x-v.x)+math.abs(u.y-v.y)==1 then return true end
end
return false
end
function koTwinOnPid(pid)
if (pid~=411 and pid~=412) or not (CC.Enhancement and JY.Status==GAME_WMAP and War and War.Person) then return false end
for i,u in pairs(War.Person) do
if u.id==pid then return koTwinOn(i) end
end
return false
end
--ko 3.6 later: more pairs that help each other side by side (up/down/left/right, same side, both standing), like the
--  Qiao sisters: {a, b, skills both get (koHasSkill), name, what}. The ì´êµ row is only for the tag (its effect is koTwinOn).
koLinkPairs={
{389,390,{[17]=true,[46]=true},"\133\109\129\106 \133\066\132\084","\131\078\132\091\161\164\130\067\129\117"},
{410,1,{[42]=true,[19]=true},"\130\073\130\108 \133\066\132\084","\133\065\130\112\161\164\131\115\130\068"},
{411,412,{},"\129\071\132\087 \133\066\132\084","\134\102\131\096\161\164\130\125\130\068 x1.3"},
{382,126,{[17]=true,[35]=true},"\129\113\131\064 \133\066\132\084","\131\078\132\091\161\164\134\101\133\098"},
{382,133,{[17]=true,[35]=true},"\129\113\131\064 \133\066\132\084","\131\078\132\091\161\164\134\101\133\098"},
{415,126,{[2]=true,[46]=true},"\135\122\135\108 \130\094\130\094","\129\113\129\075\161\164\130\067\129\117"},
{415,388,{[30]=true,[26]=true},"\131\071\129\101 \133\066\132\084","\129\073\134\096\161\164\133\100\134\094"},
{415,414,{[30]=true,[26]=true},"\131\071\129\101 \133\066\132\084","\129\073\134\096\161\164\133\100\134\094"},
}
koLinkIdx={[389]=true,[390]=true,[410]=true,[1]=true,[411]=true,[412]=true,[382]=true,[126]=true,[133]=true,[415]=true,[388]=true,[414]=true}
-- the pair row pid is linked by now (nil if none)
function koLinkOnPid(pid)
if not koLinkIdx[pid] or not (CC.Enhancement and JY.Status==GAME_WMAP and War and War.Person) then return nil end
local me=nil
for _,u in pairs(War.Person) do if u.id==pid then me=u break end end
if me==nil or (not me.live) or me.hide then return nil end
for _,row in ipairs(koLinkPairs) do
local o=(row[1]==pid and row[2]) or (row[2]==pid and row[1]) or nil
if o then
for _,u in pairs(War.Person) do
if u.id==o and u.live and (not u.hide) and u.enemy==me.enemy and u.friend==me.friend and math.abs(u.x-me.x)+math.abs(u.y-me.y)==1 then return row end
end
end
end
return nil
end
function koLinkSkill(pid,skillid)
if not koLinkIdx[pid] then return false end
local row=koLinkOnPid(pid)
return row~=nil and row[3][skillid]==true
end
--ko 3.6: entrance scenes for the special generals hired at the tavern: 388 Mok-in, 414 To-in, 408 Xiang Yu, 407 Liu Bang (3.6 later: + the six new, Sima Hui, Huang Yueying, Chen Ping, Diaochan, Hu Di, Lu Bu, Lu Zhishen, Wu Song; the rest get a short generic scene)
--  (409 Demon Zhuge Liang keeps koDemonEntrance). The screen darkens, coloured flashes with sounds, the portrait with a caption,
--  a short exchange that changes with who is already in the army, then the usual "joined" message follows.
--  Sounds: 24 cavalry, 52 fire god, 56/57 rockfall, 68 lightning, 72 confusion, 73 poison, 75/76 encouragement, 83 heal
--  (built on call: the M_* colours come from jyconfig.lua, which is loaded after this file)
local function koHeroScenes() return {
[388]={caption="\131\071\129\101 \131\099\129\106 \131\071\130\108",frame=M_Lime,flash={{73,M_Green},{34,M_White},{73,M_Green}},lines=function(has)
local t={
{388,"\161\249\161\247\161\241\161\243\161\194\161\239\161\245\161\173\161\173",0},
{1,"\131\118\129\073 \129\106\136\069\129\071 \131\126\131\126\132\083*\136\108\132\076\129\071\129\077\129\076\161\173\161\173!",1},
}
if has(126) then
t[#t+1]={126,"\129\100\129\094 \131\071\129\101\131\072\132\083 \132\086\136\101 \131\099\129\106\129\104\129\076\129\077.*\137\079\129\102 \132\096\129\083 \129\095\130\102 \130\091\132\107\131\109\129\076*\129\072\129\073 \129\094\129\089\129\071 \129\094\130\067 \133\088\135\073\130\086\129\091.",1}
end
if has(414) then
t[#t+1]={414,"\161\173\161\173\131\118\129\073\161\173\161\173 \129\106\136\069\161\173\161\173*\161\173\161\173\132\071\131\098\161\173\161\173 \136\117\161\173\161\173",1}
end
t[#t+1]={388,"\161\245\161\243\161\239! \161\173\161\173\161\249\161\247\161\241!",0}
return t
end},
[414]={caption="\129\142\129\106\136\069 \131\071\130\108",frame=M_SandyBrown,flash={{56,M_Sienna},{57,M_Sienna},{72,M_Purple}},lines=function(has)
local t={
{414,"\161\173\161\173\130\075\129\106\161\173\161\173 \130\097\129\077\161\173\161\173*\161\173\161\173\130\088\130\089\161\173\161\173 \130\097\129\077\161\173\161\173",0},
{1,"\133\088\135\101\131\123\129\102\131\087 \137\106\141\102\138\066*\129\142\129\106\136\069\129\123 \137\064 \142\093\131\116\130\119\131\096\161\173\161\173",1},
}
if has(388) then
t[#t+1]={388,"\161\249\161\247\161\173\161\173?",1}
end
if has(409) then
t[#t+1]={409,"\131\095 \131\123\129\071 \129\073\129\072\139\084 \132\085*\139\101\130\083\129\103 \129\106\136\069 \129\097\131\118\132\083\130\084.*\129\077\130\086 \131\095 \142\080\129\102\131\087 \137\106\132\069\130\102.",1}
t[#t+1]={414,"\161\173\161\173\130\075\129\106\131\080\161\173\161\173 \130\094\138\075\161\173\161\173*\161\173\161\173\130\105\135\077\129\077\161\173\161\173",0}
else
if has(126) then
t[#t+1]={126,"\130\075\129\106\129\083 \140\079\131\100 \139\088\129\068\130\098*\129\106\136\069\129\106 \135\075\129\087\129\076\129\077.*\129\071\129\100 \131\079\129\117 \130\088\129\083 \130\105\130\106\134\121\130\067\129\090.",1}
end
t[#t+1]={414,"\161\173\161\173\134\068\161\173\161\173 \130\075\129\106\161\173\161\173*\161\173\161\173\130\088\130\089\161\173\161\173 \130\105\135\077\129\077\161\173\161\173",0}
end
return t
end},
[408]={caption="\131\087\131\124\129\079\135\101 \130\073\130\079",frame=M_Red,flash={{24,M_DarkRed},{68,M_White},{52,M_Red}},lines=function(has)
local t={
{408,"\132\064\131\098 \132\091\129\083 \144\102\131\100*\131\071\131\111\130\098 \130\115\129\097\130\104 \129\124\137\109\129\077!*\131\095\129\094 \131\087\131\124\129\079\135\101 \135\103\131\079\129\077!",0},
{1,"\161\173\161\173\129\071 \135\110\137\082\130\113 \131\071\131\111\130\098\161\173\161\173!",1},
}
if has(407) then
t[#t+1]={407,"\135\109\135\109, \135\103\131\076 \129\110\129\076\138\109.*\129\071\130\087\137\096 \129\111\132\075\129\071 \132\067\130\098\130\119\137\113.",1}
t[#t+1]={408,"\130\071\132\078\161\173\161\173! \129\066\129\097\131\080 \131\081\129\111\131\098*\138\107\130\067 \130\107\131\116\129\077.*\135\109\131\118 \129\071\130\087\137\096 \134\103\139\091\129\083 \131\118\130\100\138\087 \129\097\130\067.",0}
else
t[#t+1]={408,"\132\112\129\094 \129\111\129\078\131\080 \133\067\129\107\130\102 \129\080\134\115\138\109.*\132\112 \137\106\136\108, \129\071 \129\079\135\101\129\071*\142\080\129\102\131\087 \130\067\137\097\131\115\134\121\129\077.",0}
end
return t
end},
[407]={caption="\129\111\131\100\129\118 \130\073\130\079",frame=M_Yellow,flash={{75,M_Orange},{76,M_White},{83,M_Yellow}},lines=function(has)
local t={
{407,"\131\110 \131\085\134\118\129\071 \133\073\131\100 \130\119\138\075\129\071 \131\083\129\110\129\091\135\077\129\077!*\135\109\135\109, \131\095 \133\067\135\089\129\071*\129\071\129\117\129\068 \142\113\130\119\137\113.",0},
{1,"\131\087, \129\069\133\088\161\173\161\173*\131\100\130\085\129\100 \138\068\129\097\161\173\161\173!?",1},
{407,"\129\111\129\078\129\083 \129\077\130\086 \133\073\131\109\137\109\129\077 \129\080\134\115\138\109?*\138\111\129\077, \129\071 \129\088\129\110\130\080\129\094*\132\064\129\083 \131\115\130\124\133\088.",0},
}
if has(408) then
t[#t+1]={408,"\161\173\161\173\130\071\132\078.*\135\079 \132\112 \140\078\129\123 \129\111 \129\103\129\126\129\071\130\102\129\076.",1}
t[#t+1]={407,"\135\109\135\109, \129\071\130\087\137\096 \137\106\131\079\130\067 \136\124\133\120\131\086\131\118,*\135\103\131\076.",0}
end
return t
end},
--ko 3.6 later: the other special tavern generals
[410]={caption="\130\073\130\108\131\080 \134\088\129\090\138\115",frame=M_Red,flash={{24,M_DarkRed},{75,M_Orange}},lines=function(has)
local t={{410,"\130\073\130\108\131\080 \135\089\129\067\134\089\129\071\129\102\129\090.*\136\100\129\123 \139\070\129\083 \137\072\138\095 \131\082\131\100*\135\105\131\078 \142\080\129\102 \131\087\134\121\130\083\129\090!",0}}
if has(411) or has(412) then t[#t+1]={has(411) and 411 or 412,"\129\067\134\089 \129\110\129\094\131\084!*\129\098\131\071\131\087 \132\086\131\118\129\077\129\076*\133\065\129\094\132\069\129\090.",1} end
t[#t+1]={1,"\143\093\143\093\129\111 \129\110\129\094\131\084\132\083\130\084.*\138\085 \130\094\133\097\129\097\129\091.",1}
return t
end},
[411]={caption="\130\073\130\108 \129\071\132\087 \130\095\132\087",frame=M_Cyan,flash={{83,M_Cyan},{76,M_White}},lines=function(has)
local t={{411,"\130\095\132\087\130\102 \129\097\133\111\129\076\129\077.*\130\094\133\094\144\084\131\109\132\083 \129\098\133\101\135\076\131\080*\132\064\129\083 \135\107\136\113\129\110 \133\119\132\117\129\081\129\090.",0}}
if has(412) then
t[#t+1]={412,"\136\065\129\076! \133\119\131\090\130\083*\137\072\138\095 \137\106\131\079\129\081 \139\107\132\112\129\090!",1}
t[#t+1]={411,"\131\118\130\100\138\087 \131\087\129\065*\131\079\129\117 \132\064\129\071 \132\108 \142\085\129\103\134\077\129\077.",0}
end
return t
end},
[412]={caption="\130\073\130\108 \129\071\132\087 \129\109\132\087",frame=M_Orange,flash={{52,M_Red},{76,M_White}},lines=function(has)
local t={{412,"\129\109\132\087\129\107\129\090!*\133\100\134\114\139\110\134\123 \132\093\134\069\135\083 \144\084,*\131\115\129\098 \133\119\132\117\129\081\129\090.",0}}
if has(411) then
t[#t+1]={411,"\130\108\129\096\129\110, \130\083\131\087 \129\091\135\096.*\129\071\129\100 \138\101\129\071 \137\072\138\095\130\119\131\118.",1}
end
return t
end},
[389]={caption="\137\082\129\097\131\080 \133\109\133\120",frame=M_White,flash={{68,M_White},{34,M_Cyan}},lines=function(has)
local t={{389,"\132\091\129\102\131\087 \131\095\131\096\134\091 \133\109\133\120\129\090.*\129\071 \139\070\139\091\131\109\132\083 \131\111\129\067\129\083*\130\086\133\085\129\066 \131\115\131\096 \129\097\129\091.",0}}
if has(390) then t[#t+1]={390,"\135\109\135\109, \133\109\133\120\132\083\130\084.*\138\101\129\071 \131\118\130\100\138\087 \131\087\129\065*\133\109\131\072\129\071 \132\108\132\109 \137\075\130\083\130\067\130\067.",1} end
return t
end},
[390]={caption="\133\109\129\106 \133\112\133\120 \130\073\130\079",frame=M_Silver,flash={{68,M_White},{72,M_Purple}},lines=function(has)
local t={
{390,"\133\105\129\068\130\098 \133\112\133\120\130\102 \129\097\129\091.*\130\115\129\097\131\080 \131\071\135\083\129\071*\129\071\135\069\131\109\132\083 \130\090\129\071\130\098\130\119\131\096.",0},
{1,"\131\078\133\109\138\095\131\087 \131\079\129\117\130\104*\129\068\135\122\130\075\130\086\129\077\129\076\161\173\161\173",1},
}
if has(389) then t[#t+1]={389,"\129\068\130\114\138\105,*\137\113\133\102 \135\122 \132\079\132\107\129\109.",1} end
return t
end},
[413]={caption="\133\103\132\086\131\080 \133\125\134\104\135\101",frame=M_Orange,flash={{24,M_DarkRed},{52,M_Red}},lines=function(has)
return {
{413,"\129\091\129\123\129\125\131\080 \135\101 \131\105\137\066\140\065!*\133\125\134\104\129\083 \130\091\135\077 \129\071 \136\117\137\096*\139\070\129\068 \129\064\134\106\129\068 \130\111 \141\075\137\111\129\077!",0},
{1,"\130\095\134\077\129\111 \131\071\131\111\132\083\130\084\161\173\161\173*\133\100\132\086\131\098 \129\118\134\100\129\097\130\086\129\091.",1},
}
end},
[382]={caption="\129\113\131\064 \133\109\129\096 \132\078\133\090",frame=M_Cyan,flash={{83,M_Cyan},{76,M_White}},lines=function(has)
local t={{382,"\138\111\130\119\131\118, \138\111\129\110.*\135\122\135\108\131\080 \137\079\129\103\129\083 \132\124\131\098 \129\071\129\094*\132\079\129\077 \129\097\129\098 \135\122 \131\115\131\116\132\112.",0}}
if has(126) then
t[#t+1]={126,"\131\126\129\116\138\105!*\130\083\138\083 \129\071\135\069\129\089\130\067\161\173\161\173",1}
t[#t+1]={382,"\135\109\135\109, \130\074\130\088\129\110.*\132\112 \130\075\130\084\129\083 \129\068\131\079\130\102\131\100*\138\082\131\098\129\071\129\068 \131\118\138\088\130\067.",0}
end
if has(133) then t[#t+1]={133,"\129\113\131\064 \133\109\129\096\138\105\129\089\130\067 \129\091\130\086\129\076*\130\091\131\096\133\091 \131\117\129\071 \130\097\130\084\129\090.",1} end
if not has(126) and not has(133) then t[#t+1]={1,"\129\113\131\064 \133\109\129\096\138\095\131\087 \136\106\138\087\161\173\161\173*\129\126\130\072\129\071\129\091.",1} end
return t
end},
[415]={caption="\135\122\135\108\131\080 \129\110\131\095",frame=M_Yellow,flash={{34,M_White},{83,M_Yellow}},lines=function(has)
local t={{415,"\130\085\135\099\129\126\129\071\130\102 \129\087\129\076\129\077.*\131\099\131\079\130\071\133\088\135\122 \133\066\131\089\130\104*\129\094\136\107\138\088\130\083\129\090.",0}}
if has(126) then
t[#t+1]={126,"\130\094\129\106!*\129\071\135\069\129\089\130\067 \129\091\130\086\129\077\129\076\161\173\161\173",1}
t[#t+1]={415,"\135\105\131\078 \130\099\133\120 \131\100\129\096\129\097\129\081*\138\101 \129\113\130\098 \130\097\130\067\129\090.*\129\100 \131\071\129\101\129\068 \132\080 \132\086\129\088 \134\069\129\107\129\090.",0}
else
t[#t+1]={1,"\130\074\130\088\131\080 \130\094\129\106\138\095\131\087\161\173\161\173*\136\101\136\101\129\097\129\091.",1}
end
if has(388) then
t[#t+1]={388,"\161\249\161\247\161\241\161\173\161\173!",1}
t[#t+1]={415,"\130\083\138\099, \131\099\129\106\129\071*\129\098\131\071\131\087\129\068 \138\085 \136\108\132\076\129\071\132\112\129\090.",0}
end
return t
end},
[403]={caption="\129\111\131\080 \130\117\130\114 \129\103\131\119",frame=M_Yellow,flash={{75,M_Orange},{83,M_Yellow}},lines=function(has)
local t={{403,"\129\111\131\080 \130\117\130\114 \129\103\131\119\129\071\129\091.*\129\098\144\093 \130\087\131\080 \131\071\130\117\131\109\132\083*\131\100\129\118\130\104 \129\068\138\088\130\067\129\090.",0}}
if has(407) then
t[#t+1]={407,"\129\103\131\119\129\071 \129\110\129\076\138\109!*\129\072\129\068 \138\088\130\119\131\118.",1}
t[#t+1]={403,"\138\068\129\097,*\129\077\130\086 \130\117\130\118\129\083 \131\085\132\081\134\121\131\118\129\071\129\077.",0}
else
t[#t+1]={1,"\129\111 \131\100\129\118\131\080 \130\117\130\114\138\095\131\087\161\173\161\173",1}
end
return t
end},
[404]={caption="\131\064\129\125\130\067\140\089 \131\124\133\109",frame=M_Red,flash={{76,M_White},{83,M_Red}},lines=function(has)
local t={{404,"\131\124\133\109\129\071\130\102 \129\097\133\111\129\076\129\077.*\129\071 \129\111 \136\117, \130\115\129\097\130\104 \130\110\129\066*\136\096\129\071\134\114 \131\085\130\102\133\111\129\076\129\077.",0}}
if has(442) then t[#t+1]={442,"\131\124\133\109\161\173\161\173!*\129\077\130\086 \132\086\138\103\130\119\131\118.",1} end
return t
end},
[405]={caption="\130\073\134\113\131\080 \137\071\136\079",frame=M_Orange,flash={{24,M_DarkRed},{75,M_Orange}},lines=function(has)
return {
{405,"\134\113\131\076\129\071\129\091.*\130\073\134\113\130\104 \139\088\137\066\138\066 \136\117,*\129\071\129\100 \129\111 \133\120\129\117 \138\069\129\110 \131\115\134\121\129\109.",0},
{1,"\138\085 \135\122 \130\075\132\107\129\109.*\137\072\138\095 \137\106\140\124\130\086\129\077.",1},
}
end},
[442]={caption="\130\080\131\097 \129\098\134\097",frame=M_Red,flash={{24,M_DarkRed},{68,M_White},{24,M_Red}},lines=function(has)
local t={
{442,"\129\106\130\101\129\098\134\097 \133\088\130\101\131\076\137\083!*\130\115\129\097\129\073\134\096 \129\098\134\097\129\094*\129\098\131\071 \132\079\129\077!",0},
{1,"\129\098\134\097\129\094\161\173\161\173*\131\079\129\117 \132\075\131\109\132\083\161\173\161\173!?",1},
}
if has(3) then
t[#t+1]={3,"\129\071 \131\111 \131\123\131\084 \129\084\140\078!*\140\099\133\088\130\077 \141\075\131\071\132\086*\129\066 \137\125\130\102!",1}
t[#t+1]={442,"\133\077, \131\100\129\117\132\073 \131\097\130\080\132\083\130\084.*\129\071\130\087\137\096 \133\125\129\083 \138\069\132\125 \130\075\133\088.",0}
end
if has(404) then t[#t+1]={404,"\135\087\133\109 \138\105\161\173\161\173",1} end
return t
end},
[385]={caption="\129\064\129\064\129\067 \131\089\130\067\134\100",frame=M_Orange,flash={{56,M_Sienna},{24,M_DarkRed}},lines=function(has)
local t={{385,"\129\064\129\064\129\067 \131\089\130\067\134\100\129\071\129\077!*\133\109\131\097 \129\111 \133\120\131\094\132\083*\130\090\129\118\129\117 \132\080\130\083 \130\075\133\088!",0}}
if has(386) then t[#t+1]={386,"\136\069\138\105,*\129\098\131\071\131\087\129\068 \137\072\138\095\132\083\130\084\129\090!",1} end
return t
end},
[386]={caption="\130\093\133\120 \129\073\135\112",frame=M_Orange,flash={{56,M_Sienna},{24,M_DarkRed}},lines=function(has)
local t={{386,"\131\064\134\111\130\073\131\080 \134\113\135\124\129\071\130\104*\144\089\130\075\141\075\131\109\132\083 \132\085\131\096\139\081\131\098*\129\073\135\112\129\071\129\091!",0}}
if has(385) then t[#t+1]={385,"\129\110\131\079 \138\088\130\119\131\118!*\132\071\129\071 \129\111\131\085\140\109 \129\097\133\120!",1} end
return t
end},
} end
-- every other tavern hire (setting \133\125\131\097 \133\066\133\098 = \130\066\130\094): its nickname as the caption, its own battle line (or a plain
-- greeting), one flash
local function koHeroGeneric(cid)
local p=JY.Person[cid]
local nick=p["\205\226\186\197"] or ""
local name=p["\208\213\195\251"] or ""
local line=CC.AtkWords and CC.AtkWords[name]
if line==nil or line=="" then line=name.."\129\071\129\091.*\132\064\129\083 \131\115\130\124\133\101 \138\088\129\109!" end
return {caption=(nick~="" and nick or "\134\068 \131\097\129\113 \129\087\129\093"),frame=M_Yellow,flash={{75,M_Yellow}},quick=true,lines=function(has)
return {{cid,line,0},{1,"\138\085 \135\122 \130\075\132\107\129\109.*\137\072\138\095 \137\106\140\124\130\086\129\077.",1}}
end}
end
function koHeroEntrance(cid)
if not CC.Enhancement then return end
local lv=CC.koEntrance or 2
if lv==0 then return end
local KCs=rawget(_G,"koCamp")--ko 6.0 (11-03): a story's own entrance scenes, script/camp/<id>/entrance_camp.lua (built from camp_src/<id>/entrance_camp_src.lua), read once into koCamp.koScenes
if KCs and KCs.koScenes==nil then local ok,t=pcall(dofile,CONFIG.koCampScript.."entrance_camp.lua") KCs.koScenes=(ok and type(t)=="table") and t or false if not ok then lib.Debug("entrance_camp.lua: "..tostring(t)) end end
local koCS=KCs and KCs.koScenes and KCs.koScenes[cid] or nil
local sc=koCS or ((not (KCs and cid<=382)) and (koHeroScenes()[cid] or (rawget(_G,"koHeroSceneExtra") and koHeroSceneExtra(cid))) or nil)--ko 6.0 stories: base scenes for 1~382 are base-story people--koHeroSceneExtra 5.0 (10-11)
if not sc then
if lv<2 or cid==409 then return end
sc=koHeroGeneric(cid)
end
local W,H=CC.ScreenW,CC.ScreenH
local base=lib.SaveSur(0,0,W,H)
local function frame(alpha,color,extra)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(base,0,0)
lib.Background(0,0,W,H,alpha,color or M_Black)
if extra then extra() end
ReFresh()
lib.GetKey()
end
local face=JY.Person[cid]["\205\183\207\241\180\250\186\197"]
local fx,fy=math.floor(W/2)-32,math.floor(H/2)-72
local function portrait()
lib.DrawRect(fx-3,fy-3,fx+67,fy+83,sc.frame)
lib.PicLoadCache(2,face*2,fx,fy,1)
DrawString(math.floor(W/2)-#sc.caption*4,fy+92,sc.caption,sc.frame,16)
end
for a=240,100,-10 do frame(a) lib.Delay(30) end
for _,f in ipairs(sc.flash) do
PlayWavE(f[1])
frame(150,f[2]) lib.Delay(60)
frame(60,M_White) lib.Delay(40)
frame(100) lib.Delay(260)
end
for a=100,70,-6 do frame(a,M_Black,portrait) lib.Delay(40) end
frame(70,M_Black,portrait)
local dark=lib.SaveSur(0,0,W,H)
local function has(pid) return JY.PersonNum>pid and pid~=cid and JY.Person[pid]["\190\253\214\247"]==1 and not (KCs and not koCS and pid<=382) end--ko 6.0 (11-03): a base scene (383+) in a story: its 1~382 are other people there
for _,l in ipairs(sc.lines(has)) do
lib.LoadSur(dark,0,0)
talk_sub(l[1]==1 and ((rawget(_G,"koViewSide") and koViewSide() and koViewBro()>0) and koViewBro() or 1) or l[1],l[2],true,l[3])--ko 5.0 (view): the brother speaks Liu Bei's line in a side act
end
lib.FreeSur(dark)
for a=70,250,15 do frame(math.min(a,255)) lib.Delay(30) end
lib.LoadSur(base,0,0)
ReFresh()
lib.FreeSur(base)
end
--ko 3.6: Demon Zhuge Liang (409) joins at the tavern: the screen darkens, red lightning twice, his portrait over the dark,
--  a short exchange (Liu Bei, and Zhuge Liang when he is in the army), then the screen comes back and the usual message follows
function koDemonEntrance()
do local KCd=rawget(_G,"koCamp") if KCd then if KCd.koScenes==nil then local ok,t=pcall(dofile,CONFIG.koCampScript.."entrance_camp.lua") KCd.koScenes=(ok and type(t)=="table") and t or false end if KCd.koScenes and KCd.koScenes[409] then return end end end--ko 6.0 (11-03): a story with its own 409 scene plays it in koHeroEntrance (entrance_camp.lua)
if not CC.Enhancement then return end
local W,H=CC.ScreenW,CC.ScreenH
local base=lib.SaveSur(0,0,W,H)
local function frame(alpha,color,extra)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(base,0,0)
lib.Background(0,0,W,H,alpha,color or M_Black)
if extra then extra() end
ReFresh()
lib.GetKey()
end
local face=JY.Person[409]["\205\183\207\241\180\250\186\197"]
local fx,fy=math.floor(W/2)-32,math.floor(H/2)-72
local function portrait()
lib.DrawRect(fx-3,fy-3,fx+67,fy+83,M_Red)
lib.PicLoadCache(2,face*2,fx,fy,1)
local s="\133\088\135\101 \130\073\130\079"
DrawString(math.floor(W/2)-#s*4,fy+92,s,M_Red,16)
end
for a=240,100,-10 do frame(a) lib.Delay(30) end
for k=1,2 do
PlayWavE(68)
frame(150,M_Red) lib.Delay(60)
frame(60,M_White) lib.Delay(40)
frame(100) lib.Delay(260)
end
PlayWavE(52)
for a=100,70,-6 do frame(a,M_Black,portrait) lib.Delay(40) end
frame(70,M_Black,portrait)
local dark=lib.SaveSur(0,0,W,H)
local function say(pid,s,flag)
lib.LoadSur(dark,0,0)
talk_sub(pid,s,true,flag)
end
say(409,"\161\173\161\173\134\082\131\123\131\080 \136\086\129\071 \131\118\130\104 \133\100\133\101\132\106\130\098\129\094.",0)
say(1,"\130\074\130\088\161\173\161\173? \129\110\129\076, \131\091 \132\073\143\123\131\098\161\173\161\173*\131\091\130\095\130\098 \134\117\130\119\129\090?",1)
if JY.PersonNum>126 and JY.Person[126]["\190\253\214\247"]==1 then
say(126,"\130\115\130\088\129\083 \134\069\133\106\133\101 \132\067\134\106\129\110\130\113*\135\079 \129\097\131\118\131\080 \131\118\161\173\161\173*\130\075\130\074, \129\094\139\083\129\071 \131\115\130\067 \133\088\135\073\130\086\129\091.",1)
end
say(409,"\133\067\133\067\133\067\161\173\161\173 \135\122\135\108\131\098*\129\091\131\097\131\081\129\102\131\087 \133\071\132\107\129\077.*\133\103\131\098 \131\117\131\098 \130\115\129\097\130\104 \133\100\130\114\130\104 \133\088\135\101\138\070.",0)
say(409,"\130\071\130\080\129\098, \131\091\130\095\131\080 \130\095\131\080\129\102*\129\071 \132\064\129\083 \140\102\131\096\130\075\133\088.*\129\077\132\086 \133\088\135\101\131\098 \134\114\131\082\129\098\130\067\130\067 \130\107\130\098\129\077.",0)
lib.FreeSur(dark)
for a=70,250,15 do frame(math.min(a,255)) lib.Delay(30) end
lib.LoadSur(base,0,0)
ReFresh()
lib.FreeSur(base)
end
--ko 3.6: talent 123 (Demon King): every strategy twice in a row and x1.5
function koDemon(wid)
local v=War.Person[wid]
return CC.Enhancement and v~=nil and JY.Person[v.id]["Ìì¸³"]==123
end
function koWarMagic2(id,eid,r,ItemFlag)
WarMagic(id,eid,r,ItemFlag)
if ItemFlag or r==45 or not koDemon(id) then return end
local e=War.Person[eid]
if e and e.live and (not e.hide) then
WarMagic(id,eid,r,ItemFlag)
end
end
--ko 3.6: tavern generals with their own records: {person, story gate (shown once JY.EventID passes it), cycle record}
koExtraHire={{411,382,1977},{412,382,1978},{410,461,1976},{390,592,1975},{389,592,1974},{413,592,1979},{414,592,1981,"demon"},{382,0,1988,{"tower",8,126,133}},{415,0,1989,{"tower",5,388}}}
koExtraEv={}
for _,koX in ipairs(koExtraHire) do koExtraEv[koX[1]]=koX[3] end
--ko 3.6: the fourth field of a koExtraHire row: nil = none, a person id = that general is in the army,
--  "demon" = the free battle's demon challenge has been won (koFreeDemonCleared, free addon; without it: 409 in the army)
function koSO(p) local f=rawget(_G,"koStoryOurs") return (f~=nil and f(p)) and true or false end--ko 5.1 storyhire (10-14): kdef join scenes: is this story general ours already?
function koExtraReq(koX)
local r=koX[4]
if r==nil then return true end
if type(r)=="table" then--ko 3.6 later: {"tower", ì§„, generals that must be in the army...} = ì™€ë£¡ì˜ ì‹œë ¨ best (freeplus) + those generals
if r[1]=="tower" and ((rawget(_G,"koCamp") and ((rawget(_G,"koTourWins") and koTourWins()) or 0)) or (CC.koTowerBest or 0))<r[2] then return false end--ko 6.0 stories: no tower there, tournament wins instead
for k=3,#r do if JY.Person[r[k]]["\190\253\214\247"]~=1 then return false end end
return true
end
if r=="demon" then
local f=rawget(_G,"koFreeDemonCleared")
if f then return f() end
r=409
end
return JY.Person[r]["¾ıÖ÷"]==1
end
--ko 3.6: exclusive classes and who may use them (a class can now belong to more than one general)
koBZOwner={[29]={388},[30]={408},[31]={407},[32]={409},[33]={410},[34]={411,412},[35]={389,390,382},[36]={414},[37]={415}}
function koBZAllowed(bz,pid)
local o=koBZOwner[bz]
if o==nil then return true end
for _,v in ipairs(o) do if v==pid then return true end end
return false
end
function koFixedBZ(pid)
return pid==388 or pid==407 or pid==408 or pid==409 or pid==389 or pid==390 or pid==410 or pid==411 or pid==412 or pid==414 or pid==415 or pid==382
end
function ReSetAttrib(id,flag)
local p=JY.Person[id]
local wid=GetWarID(id)
local bid=p["±øÖÖ"]
local b=JY.Bingzhong[bid]
p["×î´ó±øÁ¦"]=b["»ù´¡±øÁ¦"]+b["±øÁ¦Ôö³¤"]*(p["µÈ¼¶"]-1)
if CC.Enhancement then
if CheckSkill(id,6) then--ĞÛÊ¦
p["×î´ó±øÁ¦"]=b["»ù´¡±øÁ¦"]+JY.Skill[6]["²ÎÊı1"]+(b["±øÁ¦Ôö³¤"]+JY.Skill[6]["²ÎÊı2"])*(p["µÈ¼¶"]-1)
end
end
if wid>0 and CC.Enhancement then
if CheckSkill(id,45) then--°ÔÆø
local koFw=JY.Bingzhong[p["±øÖÖ"]]["¹¥»÷·¶Î§"]--ko 3.2: shape 17 (20 cells) would shrink these four classes
if not (koFw==5 or koFw==6 or koFw==8 or koFw==9 or koFw==24 or koFw==10 or koFw==23 or koFw==26) then
War.Person[wid].atkfw=JY.Skill[45]["²ÎÊı1"]
end
end
end
--Get Weapon
local weapon1=0
local weapon2=0
local weapon3=0
for i=1,8 do
local item=p["µÀ¾ß"..i]
if item>0 then
local canuse=false
if JY.Item[item]["Ğè±øÖÖ1"]==0 then
canuse=true
else
for n=1,7 do
if JY.Item[item]["Ğè±øÖÖ"..n]==p["±øÖÖ"] or (koEquipAlias[p["±øÖÖ"]] and JY.Item[item]["Ğè±øÖÖ"..n]==koEquipAlias[p["±øÖÖ"]]) then
canuse=true
break
end
end
end
if p["µÈ¼¶"]<JY.Item[item]["ĞèµÈ¼¶"] then
canuse=false
end
if canuse then
if JY.Item[item]["×°±¸Î»"]==1 then
if weapon1==0 or JY.Item[item]["ÓÅÏÈ¼¶"]>JY.Item[weapon1]["ÓÅÏÈ¼¶"] then
weapon1=item
end
elseif JY.Item[item]["×°±¸Î»"]==2 then
if weapon2==0 or JY.Item[item]["ÓÅÏÈ¼¶"]>JY.Item[weapon2]["ÓÅÏÈ¼¶"] then
weapon2=item
end
elseif JY.Item[item]["×°±¸Î»"]==3 then
if weapon3==0 or JY.Item[item]["ÓÅÏÈ¼¶"]>JY.Item[weapon3]["ÓÅÏÈ¼¶"] then
weapon3=item
end
end
end
end
end
p["ÎäÆ÷"]=weapon1
p["·À¾ß"]=weapon2
p["¸¨Öú"]=weapon3
--¼ÆËãÎäÆ÷¼Ó³ÉºóµÄÊôĞÔ
local p_wuli=p["ÎäÁ¦"]
local p_tongshuai=p["Í³ÂÊ"]
local p_zhili=p["ÖÇÁ¦"]
local koEB,koEBz=0,0
if wid>0 and War.Person[wid]~=nil and War.Person[wid].enemy then
koEB,koEBz=koNG.ebonus(wid)
end
p_wuli=p_wuli+koEB
p_tongshuai=p_tongshuai+koEB
p_zhili=p_zhili+koEB+koEBz
local atk,def,mov=0,0,0
mov=b["ÒÆ¶¯"]
if weapon1>0 then
p_wuli=p_wuli+JY.Item[weapon1]["ÎäÁ¦"]
p_zhili=p_zhili+JY.Item[weapon1]["ÖÇÁ¦"]
p_tongshuai=p_tongshuai+JY.Item[weapon1]["Í³ÂÊ"]
atk=atk+JY.Item[weapon1]["¹¥»÷"]
def=def+JY.Item[weapon1]["·ÀÓù"]
mov=mov+JY.Item[weapon1]["ÒÆ¶¯"]
end
if weapon2>0 then
p_wuli=p_wuli+JY.Item[weapon2]["ÎäÁ¦"]
p_zhili=p_zhili+JY.Item[weapon2]["ÖÇÁ¦"]
p_tongshuai=p_tongshuai+JY.Item[weapon2]["Í³ÂÊ"]
atk=atk+JY.Item[weapon2]["¹¥»÷"]
def=def+JY.Item[weapon2]["·ÀÓù"]
mov=mov+JY.Item[weapon2]["ÒÆ¶¯"]
end
if weapon3>0 then
p_wuli=p_wuli+JY.Item[weapon3]["ÎäÁ¦"]
p_zhili=p_zhili+JY.Item[weapon3]["ÖÇÁ¦"]
p_tongshuai=p_tongshuai+JY.Item[weapon3]["Í³ÂÊ"]
atk=atk+JY.Item[weapon3]["¹¥»÷"]
def=def+JY.Item[weapon3]["·ÀÓù"]
mov=mov+JY.Item[weapon3]["ÒÆ¶¯"]
end
p["ÎäÁ¦2"]=p_wuli
p["ÖÇÁ¦2"]=p_zhili
p["Í³ÂÊ2"]=p_tongshuai
p["×î´ó²ßÂÔ"]=math.modf(p_zhili*(p["µÈ¼¶"]+10)/40)+b["²ßÂÔ³É³¤"]*p["µÈ¼¶"]
p["²ßÂÔ"]=limitX(p["²ßÂÔ"],0,p["×î´ó²ßÂÔ"])


if wid>0 then
	War.Person[wid].sq_limited=100
else
	p["Ê¿Æø"]=100
end
if CC.Enhancement then
	if CheckSkill(id,7) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==7 then --Íş·ç
		if wid>0 then
			War.Person[wid].sq_limited=JY.Skill[7]["²ÎÊı1"]
			
		else
			p["Ê¿Æø"]=JY.Skill[7]["²ÎÊı1"]
		end
	else
		if wid>0 then
			if p["Ê¿Æø"]>War.Person[wid].sq_limited then
				p["Ê¿Æø"]=War.Person[wid].sq_limited
			end
		end			
	end
end
if wid>0 and flag then
	p["Ê¿Æø"]=War.Person[wid].sq_limited
end
if CC.Enhancement and wid>0 then
	if CheckSkill(id,31) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==31 then--¾«±ø
		if p["Ê¿Æø"]<JY.Skill[31]["²ÎÊı1"] then
			p["Ê¿Æø"]=math.min(War.Person[wid].sq_limited,JY.Skill[31]["²ÎÊı1"])
		end
	end
end

--£¨£¨4000¡Â£¨140£­ÎäÁ¦£©£«±øÖÖ»ù±¾¹¥»÷Á¦¡Á2£«Ê¿Æø£©¡Á£¨µÈ¼¶£«10£©¡Â10£©¡Á£¨100£«±¦Îï¹¥»÷¼Ó³É£©¡Â100
local koAwA,koAwD=0,0 if rawget(_G,"koAwakeAD") then koAwA,koAwD=koAwakeAD(id) end
p["¹¥»÷"]=math.modf(((4000/math.max(140-p_wuli,30))*(p["µÈ¼¶"]+10)/10+(b["¹¥»÷"]+koAwA+p["Ê¿Æø"])*(p["µÈ¼¶"]+10)/10)*(100+atk)/100)
p["·ÀÓù"]=math.modf(((4000/math.max(140-p_tongshuai,30))*(p["µÈ¼¶"]+10)/10+(b["·ÀÓù"]+koAwD+p["Ê¿Æø"])*(p["µÈ¼¶"]+10)/10)*(100+def)/100)
local koOw=p["ÎäÁ¦"]+koEB-100
local koOt=p["Í³ÂÊ"]+koEB-100
if koOw>0 then
p["¹¥»÷"]=math.modf(p["¹¥»÷"]*(200+koOw)/200)--ko 3.2: +0.5% a point over 100
end
if koOt>0 then
p["·ÀÓù"]=math.modf(p["·ÀÓù"]*(200+koOt)/200)
end
if CC.Enhancement then
if CheckSkill(id,30) then--ÎŞË«
p["¹¥»÷"]=p["¹¥»÷"]+JY.Skill[30]["²ÎÊı1"]*p["µÈ¼¶"]
p["·ÀÓù"]=p["·ÀÓù"]+JY.Skill[30]["²ÎÊı1"]*p["µÈ¼¶"]
else--ÓĞÎŞË«£¬Ôò²»¿¼ÂÇÓÂÎäºÍ¼áÈÍ
if CheckSkill(id,8) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==8 then--ÓÂÎä
p["¹¥»÷"]=p["¹¥»÷"]+JY.Skill[8]["²ÎÊı1"]*p["µÈ¼¶"]
end
if CheckSkill(id,9) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==9 then--¼áÈÍ
p["·ÀÓù"]=p["·ÀÓù"]+JY.Skill[9]["²ÎÊı1"]*p["µÈ¼¶"]
end
end
if JY.Bingzhong[p["±øÖÖ"]]["Ô¶³Ì"]>0 and (CheckSkill(id,24) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==24) then--Ç¿¹­
p["¹¥»÷"]=p["¹¥»÷"]+JY.Skill[24]["²ÎÊı1"]*p["µÈ¼¶"]
p["·ÀÓù"]=p["·ÀÓù"]+JY.Skill[24]["²ÎÊı1"]*p["µÈ¼¶"]
end
if JY.Bingzhong[p["±øÖÖ"]]["ÆïÂí"]>0 and (CheckSkill(id,25) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==25) then--Ç¿Æï
p["¹¥»÷"]=p["¹¥»÷"]+JY.Skill[25]["²ÎÊı1"]*p["µÈ¼¶"]
p["·ÀÓù"]=p["·ÀÓù"]+JY.Skill[25]["²ÎÊı1"]*p["µÈ¼¶"]
end
if CheckSkill(id,10) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==10 then--ËÙ¹¥
mov=mov+JY.Skill[10]["²ÎÊı1"]
end
end
if rawget(_G,"koAwakeMove") then mov=mov+koAwakeMove(id) end
p["ÒÆ¶¯"]=mov
if wid>0 then
War.Person[wid].movestep=mov
end
if flag then
p["±øÁ¦"]=p["×î´ó±øÁ¦"]
p["²ßÂÔ"]=p["×î´ó²ßÂÔ"]
else
p["±øÁ¦"]=limitX(p["±øÁ¦"],0,p["×î´ó±øÁ¦"])
end
--Buff
if wid>0 then
ReSetBuff(wid)
end
end

function ReSetAllBuff()
for wid,wp in pairs(War.Person) do
if wp.live and (not wp.hide) then
ReSetBuff(wid)
end
end
end

function ReSetBuff(wid)
if wid>0 and CC.Enhancement then
local pid=War.Person[wid].id
local p=JY.Person[pid]
War.Person[wid].atk_buff=0
War.Person[wid].def_buff=0
--µØĞÎ
local T={[0]=0,20,30,0,0,--É­ÁÖ¡¡20¡¡É½µØ¡¡30
0,0,5,5,0,--´å×¯¡¡ 5 ²İÔ­¡¡ 5
0,0,0,30,10,--Â¹Õ¯¡¡30¡¡±øÓª¡¡10
0,0,0,0,0,
0,0,0,0,0,
0,0,0,0,0}
local dx=GetWarMap(War.Person[wid].x,War.Person[wid].y,1)
War.Person[wid].def_buff=War.Person[wid].def_buff+T[dx]
--±³Ë®
if WarCheckSkill(wid,28) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[28]["²ÎÊı2"]*math.modf(100*(p["×î´ó±øÁ¦"]-p["±øÁ¦"])/p["×î´ó±øÁ¦"]/JY.Skill[28]["²ÎÊı1"])
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[28]["²ÎÊı2"]*math.modf(100*(p["×î´ó±øÁ¦"]-p["±øÁ¦"])/p["×î´ó±øÁ¦"]/JY.Skill[28]["²ÎÊı1"])
end
do--ko 5.0: 26 27 stack with 28
--ÃÍÕß
if WarCheckSkill(wid,27) or JY.Item[p["ÎäÆ÷"]]["ÌØ¼¼"]==27 then
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[27]["²ÎÊı2"]*math.modf(100*(p["×î´ó±øÁ¦"]-p["±øÁ¦"])/p["×î´ó±øÁ¦"]/JY.Skill[27]["²ÎÊı1"])
end
--²»Çü
if WarCheckSkill(wid,26) then
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[26]["²ÎÊı2"]*math.modf(100*(p["×î´ó±øÁ¦"]-p["±øÁ¦"])/p["×î´ó±øÁ¦"]/JY.Skill[26]["²ÎÊı1"])
end
end
 
--·ü±ø
if War.Person[wid].was_hide then
	if WarCheckSkill(wid,21) then
		War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[21]["²ÎÊı1"]
		War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[21]["²ÎÊı1"]
	end
end
if WarCheckSkill(wid,21) then--ko 5.0: also castle ground (cells 6 13 14 17: castle floor, fort, barracks, house)
	if dx==1 or dx==2 or dx==6 or dx==13 or dx==14 or dx==17 then
		War.Person[wid].atk_buff=War.Person[wid].atk_buff+20
	end
end	
--½÷É÷
if WarCheckSkill(wid,29) then
War.Person[wid].atk_buff=War.Person[wid].atk_buff-JY.Skill[29]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[29]["²ÎÊı2"]
end
--³ÇÕ½
if WarCheckSkill(wid,32) then
-- 00 Æ½Ô­ 01 É­ÁÖ 02 É½µØ 03 ºÓÁ÷ 04 ÇÅÁº 05 ³ÇÇ½ 06 ³Ç³Ø 07 ²İÔ­
-- 08 ´å×¯ 09 ĞüÑÂ 0A ³ÇÃÅ 0B »ÄµØ 0C Õ¤À¸ 0D Â¹íÎ 0E ±øÓª 0F Á¸²Ö
-- 10 ±¦Îï¿â 11 ·¿Éá 12 »ğÑæ 13 ×ÇÁ÷
if false then--ko 5.0: siege moved to WarAtkHurt (the target's cell)
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[32]["²ÎÊı1"]
end
end
--Áúµ¨
if WarCheckSkill(wid,49) then
local value=0
local array=WarGetAtkFW(War.Person[wid].x,War.Person[wid].y,2)
for i=1,4 do
local eid=GetWarMap(array[i][1],array[i][2],2)
if eid>0 then
if War.Person[wid].enemy~=War.Person[eid].enemy then
value=value+JY.Skill[49]["²ÎÊı1"]
end
end
end
for i=5,8 do
local eid=GetWarMap(array[i][1],array[i][2],2)
if eid>0 then
if War.Person[wid].enemy~=War.Person[eid].enemy then
value=value+JY.Skill[49]["²ÎÊı2"]
end
end
end
War.Person[wid].atk_buff=War.Person[wid].atk_buff+value
War.Person[wid].def_buff=War.Person[wid].def_buff+value
end
--²¼ÕóÀà
local bz_flag=true
--[[
--°ËÕó
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["²ÎÊı1"]
end
else
if CheckSkill(War.Leader1,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["²ÎÊı1"]
end
end
end
if bz_flag then
if WarCheckSkill(wid,38) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[38]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[38]["²ÎÊı1"]
end
end
--ÎºÎä
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["²ÎÊı1"]
end
else
if CheckSkill(War.Leader1,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["²ÎÊı1"]
end
end
end
if bz_flag then
if WarCheckSkill(wid,37) then
bz_flag=false
War.Person[wid].atk_buff=War.Person[wid].atk_buff+JY.Skill[37]["²ÎÊı1"]
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[37]["²ÎÊı1"]
end
end
]]--
--²¼Õó
if bz_flag then
if War.Person[wid].enemy then
if CheckSkill(War.Leader2,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["²ÎÊı1"]
end
else
if CheckSkill(War.Leader1,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["²ÎÊı1"]
end
end
end
if bz_flag then
if CC.Enhancement and WarCheckSkill(wid,36) then
bz_flag=false
War.Person[wid].def_buff=War.Person[wid].def_buff+JY.Skill[36]["²ÎÊı1"]
end
end
War.Person[wid].atk_buff=limitX(War.Person[wid].atk_buff,-50,95)
War.Person[wid].def_buff=limitX(War.Person[wid].def_buff,-50,95)
end
end

--ĞĞ¶¯Ë³ĞòµÄÅĞ¶¨ÒÔ×Ô¶¯²¹¸øºóµÄÊı¾İÎª×¼£®
--×îÓÅÏÈĞĞ¶¯µÄÊÇ´¦ÓÚ»Ö¸´ĞÔµØĞÎ£¨´å×¯¡¢±øÓª¡¢Â¹íÎ£©ÖĞµÄ²¿¶Ó£¬ÈôÓĞÊıÖ»²¿¶Ó´¦ÓÚ»Ö¸´ĞÔµØĞÎÉÏ£¬ÔòÒÔÆäÔÚÆÁÄ»ÓÒÉÏ·½µÄµĞ¾üÁĞ±íÖĞµÄË³ĞòÅÅÁĞ£®
--µÚ¶şÓÅÏÈĞĞ¶¯µÄÊÇ±øÁ¦Ğ¡ÓÚ×î´ó±øÁ¦µÄ40£¥»òÊ¿ÆøµÍÓÚ40µÄ²¿¶Ó£¬ÈôÓÒÊıÖ»²¿ÃÅ´¦ÓÚ¸ÃÇéĞÎÏÂ£¬ÔòÒÔÆäÔÚÆÁÄ»ÓÒÉÏ·½µÄµĞ¾üÁĞ±íÖĞµÄË³Ğò½øĞĞÅÅÁĞ£®
--×îºóÓàÏÂµÄ²¿¶Ó°´ÆÁÄ»ÓÒÉÏ·½µÄµĞ¾üÁĞ±íÖĞµÄË³Ğò½øĞĞÅÅÁĞ£®
function AI()
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
--ÓÑ¾ü
local flag=true
--×îÓÅÏÈĞĞ¶¯µÄ
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (dx==8 or dx==13 or dx==14) then
War.ControlEnable=false
War.InMap=false
if flag then
--ÓÑ¾ü×´¿ö
WarDrawStrBoxDelay('ƒO‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
--µÚ¶şÓÅÏÈĞĞ¶¯µÄ
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active and (JY.Person[v.id]["±øÁ¦"]/JY.Person[v.id]["×î´ó±øÁ¦"]<=0.4 or JY.Person[v.id]["Ê¿Æø"]<=40) then
War.ControlEnable=false
War.InMap=false
if flag then
--ÓÑ¾ü×´¿ö
WarDrawStrBoxDelay('ƒO‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
--ÓàÏÂµÄ²¿¶Ó
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and v.friend and v.active then
War.ControlEnable=false
War.InMap=false
if flag then
--ÓÑ¾ü×´¿ö
WarDrawStrBoxDelay('ƒO‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
--µĞ¾ü
WarGetAramyAtkFW()
flag=true
--×îÓÅÏÈĞĞ¶¯µÄ
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (v.bz==13 or v.bz==19) then
War.ControlEnable=false
War.InMap=false
if flag then
--µĞ¾ü×´¿ö
WarDrawStrBoxDelay('ƒL‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (dx==8 or dx==13 or dx==14) then
War.ControlEnable=false
War.InMap=false
if flag then
--µĞ¾ü×´¿ö
WarDrawStrBoxDelay('ƒL‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
--µÚ¶şÓÅÏÈĞĞ¶¯µÄ
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active and (JY.Person[v.id]["±øÁ¦"]/JY.Person[v.id]["×î´ó±øÁ¦"]<=0.4 or JY.Person[v.id]["Ê¿Æø"]<=40) then
War.ControlEnable=false
War.InMap=false
if flag then
--µĞ¾ü×´¿ö
WarDrawStrBoxDelay('ƒL‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
--ÓàÏÂµÄ²¿¶Ó
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
if v.live and (not v.hide) and (not v.troubled) and v.enemy and v.active then
War.ControlEnable=false
War.InMap=false
if flag then
--µĞ¾ü×´¿ö
WarDrawStrBoxDelay('ƒL‚T C‚U',M_White)
flag=false
end
AI_Sub(i)
end
end
War.ControlEnable=War.ControlEnableOld
end

function WarGetAramyAtkFW()
CleanWarMap(8,0)
for i,v in pairs(War.Person) do
if not v.enemy then
if not v.hide then
if v.live then
local len=1
if v.atkfw==2 or v.atkfw==3 or v.atkfw==8 then
len=2
elseif v.atkfw==4 or v.atkfw==9 or v.atkfw==23 then
len=3
elseif v.atkfw==5 or v.atkfw==10 then
len=4
elseif v.atkfw==24 then
len=5
elseif v.atkfw==25 then
len=2
elseif v.atkfw==26 then
len=4
end
CleanWarMap(5,-1)
local steparray=War_CalMoveStep(i,v.movestep+len)
for j=0,v.movestep+len do
for k=1,steparray[j].num do
local mx,my=steparray[j].x[k],steparray[j].y[k]
SetWarMap(mx,my,8,GetWarMap(mx,my,8)+1)
end
end
end
end
end
end
CleanWarMap(5,-1)
end

function WarGetAramyAtkFW()
CleanWarMap(8,0)
for i,v in pairs(War.Person) do
if not v.enemy then
if not v.hide then
if v.live then
local array=WarGetAtkFW(v.x,v.y,2)
for j=1,array.num do
local mx,my=array[j][1],array[j][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
local n=2
if j>4 then
n=1
end
local ov=GetWarMap(mx,my,8)
if n>ov then
SetWarMap(mx,my,8,n)
end
end
end
end
end
end
end
end

function AI_Sub(id,flag)
--AIÀàĞÍ£½00 ±»¶¯³ö»÷ĞÍ£¬²¿¶ÓÔÚÔ­µØ²»ÒÆ¶¯£¬µ«Èç¹ûÓĞµĞÈË½øÈëÆäÒÆ¶¯ºó»¹ÄÜ¹¥»÷µ½µÄµØ·½£¬²¿¶Ó½«ÒÆ¶¯²¢½øĞĞ¹¥»÷£®
--AIÀàĞÍ£½01 Ö÷¶¯³ö»÷ĞÍ£¬²¿¶Ó»áÖ÷¶¯ÒÆ¶¯²¢¹¥»÷
--AIÀàĞÍ£½02 ¼áÊØÔ­µØĞÍ£¬²¿¶ÓÔÚÔ­µØ²»ÒÆ¶¯£¬¼´Ê¹ÊÜµ½¹¥»÷Ò²ÊÇÈç´Ë£¬µ«Èç¹ûÓĞÈË½øÈëÆä¹¥»÷·¶Î§£¬²¿¶Ó½«·¢Æğ¹¥»÷£®
--AIÀàĞÍ£½03 ×·»÷Ö¸¶¨Ä¿±ê
--AIÀàĞÍ£½04 ÒÆ¶¯µ½Ä¿µÄ£¬¹¥»÷
--AIÀàĞÍ£½05 ÏòÄ¿±êÎŞ¹¥»÷ÒÆ¶¯
--AIÀàĞÍ£½06 ÒÆ¶¯µ½Ä³µã²»¹¥»÷
--[[
00=(X,Y) ÒÆ¶¯/n ÒÆ¶¯£º
ÈôÒÆ¶¯·¶Î§+¹¥»÷·¶Î§ÄÚÓĞÎÒ¾ü¾ÍÑ¡ÔñĞĞ¶¯¼ÛÖµ×î¸ßµÄ¶¯×÷£¬·ñÔò£º
1¡¢µ±³ğÈË´úÂëÎªn=FFÊ±£¬³¯×Å(X,Y)×ø±êÒÆ¶¯¡£
2¡¢µ±³ğÈË´úÂëÎªn=FFÊ±£¬ÇÒµ½´ïÁË(X,Y)×ø±ê£¬ÔòAI±äÎª03=(X,Y) ´ıÃü¡£
3¡¢µ±³ğÈË´úÂëÎªn=00~2CÇÒ³ğÈË»¹ÔÚ³¡Ê±£¬³¯×ÅÕ½³¡nºÅÈËÎïÒÆ¶¯¡£
4¡¢Èô³ğÈË´úÂëÎªn=00~2CÇÒ³ğÈËÏûÊ§£¬ÔòAI±äÎª01=¹¥»÷×î½üµĞ¡£

01=¹¥»÷×î½üµĞ£º
ÈôÒÆ¶¯·¶Î§+¹¥»÷·¶Î§ÄÚÓĞÎÒ¾ü¾ÍÑ¡ÔñĞĞ¶¯¼ÛÖµ×î¸ßµÄ¶¯×÷£¬·ñÔòÏò×î½üµÄÎÒ¾üÒÆ¶¯¡£

02=(X,Y) ²»¶¯/n ²»¶¯£º
ÎŞÂÛ¹¥»÷·¶Î§ÄÚÊÇ·ñÓĞÎÒ¾ü¶¼»áÑ¡ÔñĞĞ¶¯¼ÛÖµ×î¸ßµÄ¶¯×÷£¬µ«ÊÇ²»»áÒÆ¶¯¡£
X,Y,n¶¼ÎŞÒâÒå¡££¨²»È·¶¨£©

03=(X,Y) ´ıÃü/n ´ıÃü£º
ÈôÒÆ¶¯·¶Î§+¹¥»÷·¶Î§ÄÚÓĞÎÒ¾ü¾ÍÑ¡ÔñĞĞ¶¯¼ÛÖµ×î¸ßµÄ¶¯×÷£¬·ñÔò²»»áÒÆ¶¯¡£
X,Y,n¶¼ÎŞÒâÒå¡££¨²»È·¶¨£©

04=(X,Y) ÎŞ¹¥»÷ÒÆ¶¯/n ÎŞ¹¥»÷ÒÆ¶¯£º
Ö»»á³¯×ÅÄ¿±ê×ø±ê(X,Y)ÒÆ¶¯£¨Èô³ğÈË´úÂëÎªFF£©»òÕ½³¡nºÅÈËÎïÒÆ¶¯£¬²»»á¹¥»÷»òÊ¹ÓÃ²ßÂÔ¡£
1¡¢µ±³ğÈË´úÂëÎªn=FFÊ±£¬ÇÒµ½´ïÁË(X,Y)×ø±ê£¬ÔòAI±äÎª03=(X,Y) ´ıÃü¡£
2¡¢Èô³ğÈË´úÂëÎªn=00~2CÇÒ³ğÈËÏûÊ§£¬ÔòAI±äÎª01=¹¥»÷×î½üµĞ¡£

07=¼üÈë
ÈôÎÒ·½AI¡Ù07£¬ÔòÎªÓÑ¾ü¡£
]]-- 
WarPersonCenter(id)
--ÓÅÏÈ ËÑÑ°ÒÆ¶¯·¶Î§ÄÚ£¬ÓĞ¹¥»÷¾ÍÒÆ¶¯µ½¸½½ü£®Ã»ÓĞ¿É¹¥»÷µÄ£¬¾Í¿¼ÂÇÒÆ¶¯
local did=0
War.SelID=id
local wp=War.Person[id]
local id1=wp.id
--XXXµÄÒÆ¶¯
CleanWarMap(5,-1)
CleanWarMap(6,-1)
CleanWarMap(7,-1)
local dx,dy=wp.x,wp.y
local dv=0
if JY.Base["µĞ¾ü³ö»÷"]==1 then
if wp.ai==0 or wp.ai==2 then
if not wp.friend then
wp.ai=1
end
end
end
local ccai=0
if flag~=nil then
ccai=wp.ai
wp.ai=2
end
--AI¸ù¾İÊµ¼ÊÇé¿ö×Ô¶¯µ÷Õû
--AIÀàĞÍ£½03 ×·»÷Ö¸¶¨Ä¿±ê µ±×·»÷Ä¿±êÏûÊ§Ê±--¡µÖ÷¶¯³ö»÷
if wp.ai==3 then
local eid=GetWarID(wp.aitarget)
if not (eid>0 and War.Person[eid].live) then
 wp.ai=1
end
end
if wp.ai~=2 then--³ıÁË ¼áÊØÔ­µØĞÍ ÒÔÍâ£¬ÆäËûµÄaiÀàĞÍ¶¼ĞèÒª¿¼ÂÇÒÆ¶¯
local steparray=War_CalMoveStep(id,wp.movestep)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
if GetWarMap(mx,my,2)==0 or (mx==wp.x and my==wp.y) then
local v=WarGetMoveValue(id,mx,my)
if v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
--Èç¹û²¿¶ÓµÄ±øÁ¦²»×ã£¨¼´±øÁ¦Ğ¡ÓÚ×î´ó±øÁ¦µÄ40£¥»òÊ¿ÆøĞ¡ÓÚ40£¬ÏÂÍ¬£©£®
if dv<50 then
if JY.Person[id1]["±øÁ¦"]/JY.Person[id1]["×î´ó±øÁ¦"]<=0.4 then
local eid=WarSearchBZ(id,19)
if eid>0 then
did=eid
 dv=0
 WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif JY.Person[id1]["Ê¿Æø"]<=40 then
local eid=WarSearchBZ(id,13)
if eid>0 then
did=eid
dv=0
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
end
end
if dv>0 then--ÒÆ¶¯·¶Î§ÓĞÄ¿±ê
if dx~=wp.x or dy~=wp.y then--ĞèÒªÒÆ¶¯
War_CalMoveStep(id,wp.movestep)
BoxBack()
War_MovePerson(dx,dy)
War.ControlEnable=false
War.InMap=false
end
else--Ò»´ÎÒÆ¶¯·¶Î§ÄÚÎŞÄ¿±ê
if wp.ai==1 then--¿¼ÂÇÒÆ¶¯µ½×î½üµĞÈË
local eid=WarSearchEnemy(id)
if eid>0 then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
v=v-ddv
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif wp.ai==3 or wp.ai==5 then
local eid=GetWarID(wp.aitarget)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)
if GetWarMap(wp.x,wp.y,4)==0 then
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y,true)--Èç¹ûÕÒ²»µ½Â·¾¶£¬ÔòÎŞÊÓµĞÈËÀ¹Â·£¬ÔÙÕÒÒ»´Î
end
if GetWarMap(wp.x,wp.y,4)==0 then
local koTid=eid--ko 3.3
eid=WarSearchEnemy(id)
if eid>0 then
did=eid
WarSearchMove(id,War.Person[eid].x,War.Person[eid].y)--Èç¹ûÕÒ²»µ½Â·¾¶£¬ÔòÒÆ¶¯µ½×î½üµĞÈË
else--ko 3.3: nobody reachable at all: head for the target (was War.Person[0] -> crash)
eid=koTid
CleanWarMap(4,0)
end
end
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-War.Person[eid].x),math.abs(my-War.Person[eid].y))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
v=v-ddv
end
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
elseif wp.ai==4 or wp.ai==6 then
WarSearchMove(id,wp.ai_dx,wp.ai_dy)
if GetWarMap(wp.x,wp.y,4)==0 then
WarSearchMove(id,wp.ai_dx,wp.ai_dy,true)--Èç¹ûÕÒ²»µ½Â·¾¶£¬ÔòÎŞÊÓµĞÈËÀ¹Â·£¬ÔÙÕÒÒ»´Î
end
for i=0,wp.movestep do
for j=1,steparray[i].num do
local mx,my=steparray[i].x[j],steparray[i].y[j]
local v=GetWarMap(mx,my,4)
v=v+1-math.max(math.abs(mx-wp.ai_dx),math.abs(my-wp.ai_dy))/100
if wp.enemy then
local ddv=GetWarMap(mx,my,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
v=v-ddv
end
end
if (GetWarMap(mx,my,2)==0 or i==0) and v>dv then
dv=v
dx,dy=mx,my
end
end
end
end
if dx~=wp.x or dy~=wp.y then
War_CalMoveStep(id,wp.movestep)
BoxBack()
War_MovePerson(dx,dy)
War.ControlEnable=false
War.InMap=false
end
end
end
CleanWarMap(4,1)
--XXXµÄ¹¥»÷
local eid=0
dv=0
if wp.ai==5 or wp.ai==6 then
else
local atkarray=WarGetAtkFW(dx,dy,War.Person[id].atkfw)
for i=1,atkarray.num do
if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
local v=WarGetAtkValue(id,atkarray[i][1],atkarray[i][2])
if v>dv then
dv=v
eid=GetWarMap(atkarray[i][1],atkarray[i][2],2)
end
end
end
local mv,magicx,magicy=WarGetMagicValue(id,dx,dy)
if mv>0 then
--²ßÂÔÏµ²¿¶Ó£¬Èç¹ûÎïÀí¹¥»÷¼ÛÖµµÍÓÚ100£¬ÔòÎª0£¨new£©
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
if dv<100 then
dv=0
end
end
end
if mv>dv and flag==nil then
local mid=GetWarMap(magicx,magicy,7)
eid=GetWarMap(magicx,magicy,2)
did=eid
BoxBack()
WarDrawStrBoxDelay(string.format("%sG(^) %sƒP „T‚vS dM.",JY.Person[id1]["ĞÕÃû"],JY.Magic[mid]["Ãû³Æ"]),M_White)
koWarMagic2(id,eid,mid)--ko 3.6 QA: talent 123 casts twice on delegated turns too
if CC.Enhancement and WarCheckSkill(id,119) then
local koK=JY.Magic[mid]["ÀàĞÍ"]--ko 3.2: 119 for the AI as for the player: kinds 1,2,3,9,10, and only while the target stands
if (between(koK,1,3) or koK==9 or koK==10) and JY.Magic[mid]["Ğ§¹û·¶Î§"]==11 and JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,mid)
end
end
if CC.Enhancement and WarCheckSkill(id,112) then--ÆßĞÇ½£ ²ßÂÔÖµÏûºÄ¼õ°ë
JY.Person[id1]["²ßÂÔ"]=JY.Person[id1]["²ßÂÔ"]-math.modf(JY.Magic[mid]["ÏûºÄ"]/2)
else
JY.Person[id1]["²ßÂÔ"]=JY.Person[id1]["²ßÂÔ"]-JY.Magic[mid]["ÏûºÄ"]
end
JY.Person[id1]["²ßÂÔ"]=limitX(JY.Person[id1]["²ßÂÔ"],0,JY.Person[id1]["×î´ó²ßÂÔ"])
else
if eid>0 then
if rawget(_G,"koGuardSwap") then eid=koGuardSwap(id,eid) end--ko 5.0 tank: guard (10-11)
did=eid
BoxBack()
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) and not WarCheckSkill(id,105) then--ko 3.2: 105 also stops the 117 pre-emptive counter
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["¿É·´»÷"]==1 and JY.Bingzhong[War.Person[id].bz]["±»·´»÷"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,102) then--ko 3.2: 102 also enables the 117 pre-emptive counter here, as it does when the player attacks
xsgj=true
elseif WarCheckSkill(eid,42) then --or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==42 then--·´»÷(ÌØ¼¼)
xsgj=true
end
end
end
end
if xsgj then
--¼ì²éÊÇ·ñÔÚ¹¥»÷·¶Î§ÄÚ
xsgj=false
local xs_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,xs_arrary.num do
if between(xs_arrary[n][1],1,War.Width) and between(xs_arrary[n][2],1,War.Depth) then
if GetWarMap(xs_arrary[n][1],xs_arrary[n][2],2)==id then
xsgj=true
break
end
end
end
end

if xsgj then
--·´»÷¸ÅÂÊ£½ÎÒ¾üÎä½«ÎäÁ¦¡Â150
if CC.Enhancement and WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
--ko 3.2: the 102 counter now runs the 106 extra hit and the target's 103 riposte, like the other branches
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)-(rawget(_G,"koFormCounter") and koFormCounter(eid) or 0)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
end
end
if JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid)
WarResetStatus(eid)
end
--»ìÂÒ¹¥»÷
if CC.Enhancement and WarCheckSkill(id,116) then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
War.Person[eid].troubled=true
War.Person[eid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[War.Person[eid].id]["ĞÕÃû"].."G(^) ‚c‚df ƒEƒFM!",M_White)
end
end
if JY.Status==GAME_WMAP and CC.Enhancement and WarCheckSkill(id,130) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then--koFenzhan 6.0: fenzhan - every other foe in range takes one hit, kill or not (10-31)
local koFJ=WarGetAtkFW(War.Person[id].x,War.Person[id].y,War.Person[id].atkfw)
local koFL={}
for n=1,koFJ.num do
if between(koFJ[n][1],1,War.Width) and between(koFJ[n][2],1,War.Depth) then
local e2=GetWarMap(koFJ[n][1],koFJ[n][2],2)
if e2>0 and e2~=eid and War.Person[e2] and War.Person[e2].live and (not War.Person[e2].hide) and War.Person[e2].enemy~=War.Person[id].enemy and JY.Person[War.Person[e2].id]["±øÁ¦"]>0 then koFL[#koFL+1]=e2 end
end
end
for _,e2 in ipairs(koFL) do
if JY.Status~=GAME_WMAP or JY.Person[War.Person[id].id]["±øÁ¦"]<=0 then break end
if War.Person[e2].live and JY.Person[War.Person[e2].id]["±øÁ¦"]>0 then
WarAtk(id,e2)
WarResetStatus(e2)
end
end
end
--Òıµ¼¹¥»÷
local ydgj=0
if CC.Enhancement and WarCheckSkill(id,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(id,108) then
ydgj=1
end
if JY.Status~=GAME_WMAP then ydgj=0 end--koFollowStop 5.0: the battle already ended (10-10)
if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]<=0 then
War.YD=1
AI_Sub(id,1)
end
elseif ydgj==2 then
local yd=eid
while yd~=0 do
if JY.Person[War.Person[yd].id]["±øÁ¦"]<=0 then
yd=AI_Sub(id,1)
did=yd
else
break
end
end
end
if CC.Enhancement and WarCheckSkill(id,114) then--Ó¢ĞÛÖ®½£ ´©´Ì¹¥»÷
local mx=War.Person[id].x
local my=War.Person[id].y
local xx=War.Person[eid].x
local yy=War.Person[eid].y
local dx=mx-xx
local dy=my-yy
local eid2=0
if dx>0 and dy==0 then--ÏÈÈ·¶¨±»¹¥»÷ÕßÔÚ¹¥»÷Õß×ó±ß·½Ïò
if GetWarMap(xx-1,yy,2)>0 then--È»ºóÈ·ÈÏÊÇ±»¹¥»÷Õß×ó±ßÄÇÒ»¸ñµÄ¶ÔÏó
eid2=GetWarMap(xx-1,yy,2)--»ñÈ¡ÕâÒ»¸ñµÄÈËÎïid±àºÅ
if War.Person[eid].enemy==War.Person[eid2].enemy then--×îºóÈ·¶¨Óë±»¹¥»÷ÕßÍ¬ÕóÓª
WarAtk(id,eid2)--¹¥»÷
WarResetStatus(eid2)
end
end
end
if dx<0 and dy==0 and GetWarMap(xx+1,yy,2)>0 then--ÓÒ
eid2=GetWarMap(xx+1,yy,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy>0 and GetWarMap(xx,yy-1,2)>0 then--ÉÏ
eid2=GetWarMap(xx,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx==0 and dy<0 and GetWarMap(xx,yy+1,2)>0 then--ÏÂ
eid2=GetWarMap(xx,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy>0 and GetWarMap(xx-1,yy-1,2)>0 and dx==dy then--×óÉÏ
eid2=GetWarMap(xx-1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy>0 and GetWarMap(xx+1,yy-1,2)>0 and dx==-(dy) then--ÓÒÉÏ
eid2=GetWarMap(xx+1,yy-1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx>0 and dy<0 and GetWarMap(xx-1,yy+1,2)>0 and -(dx)==dy then--×óÏÂ
eid2=GetWarMap(xx-1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
if dx<0 and dy<0 and GetWarMap(xx+1,yy+1,2)>0 and dx==dy then--ÓÒÏÂ
eid2=GetWarMap(xx+1,yy+1,2)
if War.Person[eid].enemy==War.Person[eid2].enemy then
WarAtk(id,eid2)
WarResetStatus(eid2)
end
end
end
--·´»÷
local fsfj=false--×°±¸ÇàÁúÙÈÔÂµ¶µÄÈË²»ÊÇ¹ØÓğÊ±·âÉ±·´»÷
if CC.Enhancement and WarCheckSkill(id,105) then
fsfj=true
end
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 and (not War.Person[eid].troubled) and fsfj==false and xsgj==false then
--Ö»ÓĞÔô±ø£¨É½Ôô¡¢¶ñÔô¡¢ÒåÔô£©ºÍÎäÊõ¼ÒÄÜ·´»÷µĞ¾üµÄÎïÀí¹¥»÷¡£
--¹¥»÷·½±øÖÖÎªÆï±ø¡¢Ôô±ø¡¢ÃÍÊŞ±øÍÅ¡¢ÎäÊõ¼Ò¡¢ÒìÃñ×åÊ±£¬²Å¿ÉÄÜ²úÉú·´»÷¡£
--¹¥»÷·½±øÖÖÎª²½±ø¡¢¹­±ø¡¢¾üÀÖ¶Ó¡¢ÑıÊõÊ¦¡¢ÔËÊä¶ÓÊ±£¬²»¿ÉÄÜ·¢Éú·´»÷¡£
--¹¥»÷·½ÎªĞÂÔö±øÖÖÊ±£¬¶¼¿ÉÒÔ²úÉú·´»÷
local fj_flag=false
if JY.Bingzhong[War.Person[eid].bz]["¿É·´»÷"]==1 and JY.Bingzhong[War.Person[id].bz]["±»·´»÷"]==1 then
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
fj_flag=true
elseif CC.Enhancement and WarCheckSkill(eid,42) then --or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==42) then--·´»÷(ÌØ¼¼)
fj_flag=true
end
if fj_flag then
--¼ì²éÊÇ·ñÔÚ¹¥»÷·¶Î§ÄÚ
fj_flag=false
local fj_arrary=WarGetAtkFW(War.Person[eid].x,War.Person[eid].y,War.Person[eid].atkfw)
for n=1,fj_arrary.num do
if between(fj_arrary[n][1],1,War.Width) and between(fj_arrary[n][2],1,War.Depth) then
if GetWarMap(fj_arrary[n][1],fj_arrary[n][2],2)==id then
fj_flag=true
break
end
end
end
end
if fj_flag then
--·´»÷¸ÅÂÊ£½ÎÒ¾üÎä½«ÎäÁ¦¡Â150
if CC.Enhancement and WarCheckSkill(eid,102) then--Áõ±¸×°±¸´ÆĞÛË«½£ ±»¹¥»÷Ê±±Ø¶¨·´»÷
--ko 3.2: the 102 counter now runs the 106 extra hit and the target's 103 riposte, like the other branches
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)-(rawget(_G,"koFormCounter") and koFormCounter(eid) or 0)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and not WarCheckSkill(eid,105) and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
end
end
end
end
end
War.ControlEnable=false
War.InMap=false
end
wp.active=false
wp.action=0
WarResetStatus(id)
WarCheckStatus()
War.LastID=War.SelID
War.SelID=0
WarDelay(CC.WarDelay)
War.YD=0
if flag~=nil then
wp.ai=ccai
end
return did
end

--Èç¹û²¿¶ÓµÄ±øÁ¦²»×ã£¨¼´±øÁ¦Ğ¡ÓÚ×î´ó±øÁ¦µÄ40£¥»òÊ¿ÆøĞ¡ÓÚ40£¬ÏÂÍ¬£©£¬ÔòÕ½³¡ÉÏ´æÔÚ¿É»Ö¸´µØĞÎµÄ×ø±ê£¬ĞĞ¶¯¼ÛÖµ¼Ó50£®
--»ù±¾Öµ£½»ù±¾ÎïÀí¹¥»÷É±ÉË£«¹¥»÷·½µ±Ç°±øÁ¦¡Â6
--ÎïÀí¹¥»÷µÄĞĞ¶¯¼ÛÖµ£½»ù±¾Öµ¡Â16£®
--Èç¹û¹¥»÷µÄÊÇ³ğÈË£¬»ù±¾Öµ£½»ù±¾Öµ£«30
--µ±²¿¶Ó´¦ÓÚÓĞ·ÀÓù¼Ó³ÉµÄµØĞÎÊ±£¬ĞĞ¶¯¼ÛÖµ£½ĞĞ¶¯¼ÛÖµ£«·ÀÓù¼Ó³É¡Â5
function WarGetMoveValue(pid,x,y)
local id1=War.Person[pid].id
local wp=War.Person[pid]
local atkarray=WarGetAtkFW(x,y,War.Person[pid].atkfw)
local dv=0
if wp.ai==5 or wp.ai==6 then
dv=0
else
for i=1,atkarray.num do
if atkarray[i][1]>0 and atkarray[i][1]<=War.Width and atkarray[i][2]>0 and atkarray[i][2]<=War.Depth then
local v=WarGetAtkValue(pid,atkarray[i][1],atkarray[i][2])
if v>0 then--Ô¶¾à¹¥»÷¶îÍâ¸½¼Ó
if i<=4 then
elseif i<=8 then
v=v+2
elseif i<=16 then
v=v+3
elseif i<=24 then
v=v+4
end
end
if v>dv then
dv=v
end
end
end
local mv=WarGetMagicValue(pid,x,y)
--²ßÂÔÏµ²¿¶Ó£¬Èç¹ûÎïÀí¹¥»÷¼ÛÖµµÍÓÚ100£¬ÔòÎª0£¨new£©
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
if dv<100 then
dv=0
end
end
if mv>dv then
dv=mv
end
end
local dx=GetWarMap(x,y,1)
if dv>0 then
--µ±²¿¶Ó´¦ÓÚÓĞ·ÀÓù¼Ó³ÉµÄµØĞÎÊ±£¬ĞĞ¶¯¼ÛÖµ£½ĞĞ¶¯¼ÛÖµ£«·ÀÓù¼Ó³É¡Â5--2.5
if dx==1 then--¿É»Ö¸´µØĞÎ ¶îÍâ+5£¨×Ô¼ºĞÂÔöµÄ£©
dv=dv+8
elseif dx==2 then
dv=dv+10
elseif dx==7 then
dv=dv+2
elseif dx==8 then
dv=dv+2+5
elseif dx==13 then
dv=dv+12+5
elseif dx==14 then
dv=dv+4+5
end
--¸ù¾İAIÔÙ¸½¼Ó
if wp.ai==3 or wp.ai==5 then
local eid=GetWarID(wp.aitarget)
if eid>0 then
local tx,ty=War.Person[eid].x,War.Person[eid].y
dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y))
end
elseif wp.ai==4 or wp.ai==6 then
local tx,ty=wp.ai_dx,wp.ai_dy
dv=dv+5*(wp.movestep-math.abs(tx-x)-math.abs(ty-y))
end
end
--Èç¹û²¿¶ÓµÄ±øÁ¦²»×ã£¨¼´±øÁ¦Ğ¡ÓÚ×î´ó±øÁ¦µÄ40£¥»òÊ¿ÆøĞ¡ÓÚ40£¬ÏÂÍ¬£©£¬ÔòÕ½³¡ÉÏ´æÔÚ¿É»Ö¸´µØĞÎµÄ×ø±ê£¬ĞĞ¶¯¼ÛÖµ¼Ó50£®
if JY.Person[id1]["±øÁ¦"]/JY.Person[id1]["×î´ó±øÁ¦"]<=0.4 or JY.Person[id1]["Ê¿Æø"]<=40 then
if dx==8 or dx==13 or dx==14 then
dv=dv+50
end
end
--ĞÂÔöµÄ£¬mp²»×ãÊ±£¬¿¿½ü¾üÀÖ¶Ó
for d=1,4 do
local sid=0
local nx,ny=x+CC.DirectX[d],y+CC.DirectY[d]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
sid=GetWarMap(nx,ny,2)
if sid>0 and sid~=pid then
if War.Person[sid].enemy==wp.enemy and War.Person[sid].bz==13 then
if JY.Person[id1]["²ßÂÔ"]/JY.Person[id1]["×î´ó²ßÂÔ"]<=0.4 then
dv=dv+10
break
end
end
end
end
end
if wp.enemy then
local ddv=GetWarMap(x,y,8)
if wp.bz==13 or wp.bz==16 or wp.bz==19 then
dv=dv-ddv
end
end
return dv
end

function HaveMagic(pid,mid)
local bz=JY.Person[pid]["±øÖÖ"]
local lv=JY.Person[pid]["µÈ¼¶"]
if CC.Enhancement and bz==32 and mid>=1 and mid<=46 and mid~=45 then return true end--ko 3.6: the Demon King class knows every strategy
if JY.Status~=GAME_WMAP then
if between(mid,1,36) then
if between(JY.Bingzhong[bz]["²ßÂÔ"..mid],1,lv) then
return true
end
end
else
local eid=0
local eid2=0
local eid3=0
local eid4=0
local id=War.SelID
local mx,my=0,0
if id>0 then mx=War.Person[id].x my=War.Person[id].y end
if id>0 and CC.Enhancement and WarCheckSkill(id,101) then -- mimic: adjacent units, bounds-checked (ko fix)
local nb={{mx-1,my},{mx+1,my},{mx,my-1},{mx,my+1}}
local ne={0,0,0,0}
for d=1,4 do
local nx,ny=nb[d][1],nb[d][2]
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
local nw=GetWarMap(nx,ny,2)
if nw>0 and War.Person[nw]~=nil then ne[d]=nw end
end
end
eid,eid2,eid3,eid4=ne[1],ne[2],ne[3],ne[4]
end
if between(mid,1,36) then
if between(JY.Bingzhong[bz]["²ßÂÔ"..mid],1,lv) then
return true
end
if eid>0 and between(JY.Bingzhong[JY.Person[War.Person[eid].id]["±øÖÖ"]]["²ßÂÔ"..mid],1,lv) then
return true
elseif eid2>0 and between(JY.Bingzhong[JY.Person[War.Person[eid2].id]["±øÖÖ"]]["²ßÂÔ"..mid],1,lv) then
return true
elseif eid3>0 and between(JY.Bingzhong[JY.Person[War.Person[eid3].id]["±øÖÖ"]]["²ßÂÔ"..mid],1,lv) then
return true
elseif eid4>0 and between(JY.Bingzhong[JY.Person[War.Person[eid4].id]["±øÖÖ"]]["²ßÂÔ"..mid],1,lv) then
return true
end
end
end
if CC.Enhancement then
if mid==37 then
if CheckSkill(pid,1) then
if lv>=JY.Skill[1]["²ÎÊı1"] then
return true
end
end
elseif mid==38 then
if CheckSkill(pid,1) then
if lv>=JY.Skill[1]["²ÎÊı2"] then
return true
end
end
elseif mid==39 then
if CheckSkill(pid,4) then
if lv>=JY.Skill[4]["²ÎÊı1"] then
return true
end
end
elseif mid==40 then
if CheckSkill(pid,3) then
if lv>=JY.Skill[3]["²ÎÊı1"] then
return true
end
end
elseif mid==41 then
if CheckSkill(pid,39) then
if lv>=JY.Skill[39]["²ÎÊı2"] then
return true
end
end
elseif mid==42 then
if CheckSkill(pid,39) then
if lv>=JY.Skill[39]["²ÎÊı3"] then
return true
end
end
elseif mid==43 then
if CheckSkill(pid,40) or CheckSkill(pid,5) then
if lv>=JY.Skill[40]["²ÎÊı1"] then
return true
end
end
elseif mid==44 then
if CheckSkill(pid,40) or CheckSkill(pid,5) then
if lv>=JY.Skill[40]["²ÎÊı2"] then
return true
end
end
elseif mid==46 then
if CheckSkill(pid,38) then
if lv>=JY.Skill[38]["²ÎÊı2"] then
return true
end
end
end
end
return false
end

function WarHaveMagic(wid,mid)
local pid=War.Person[wid].id
return HaveMagic(pid,mid)
end

function WarGetMagicValue(pid,x,y)
local dv=0
local dx,dy
local bz=War.Person[pid].bz
local id1=War.Person[pid].id
local lv=JY.Person[id1]["µÈ¼¶"]
local ox,oy=War.Person[pid].x,War.Person[pid].y
War.Person[pid].x,War.Person[pid].y=x,y
SetWarMap(ox,oy,2,0)
SetWarMap(x,y,2,pid)
for mid=1,JY.MagicNum-1 do
if WarHaveMagic(pid,mid) then
if JY.Person[id1]["²ßÂÔ"]>=JY.Magic[mid]["ÏûºÄ"] then--mp enough?
if true then--dx?
local kind=JY.Magic[mid]["ÀàĞÍ"]
local fw=JY.Magic[mid]["Ê©Õ¹·¶Î§"]
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local mx,my=array[j][1],array[j][2]
if between(mx,1,War.Width) and between(my,1,War.Depth) then
local eid=GetWarMap(mx,my,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(pid,eid,mid) then--check dx
if ((between(kind,1,5) or between(kind,9,10)) and War.Person[pid].enemy~=War.Person[eid].enemy) or (between(kind,6,8) and War.Person[pid].enemy==War.Person[eid].enemy) then
local v,select_magic=WarGetMagicValue_sub(pid,mx,my)
if v>dv and mid==select_magic then
dv=v
dx,dy=mx,my
end
end
end
end
end
end
end
end
end
end
War.Person[pid].x,War.Person[pid].y=ox,oy
SetWarMap(x,y,2,0)
SetWarMap(ox,oy,2,pid)
return dv,dx,dy
end

function WarGetMagicValue_sub(pid,x,y)
local id1,id2
id1=War.Person[pid].id
local bz=War.Person[pid].bz
local lv=JY.Person[id1]["µÈ¼¶"]
local oid=GetWarMap(x,y,2)
local dv=GetWarMap(x,y,6)
local select_magic=GetWarMap(x,y,7)
local hp={600,1200,1800}
local sp={30,40,50}
if dv==-1 then
dv=0
local v=0
for mid=1,JY.MagicNum-1 do
if WarHaveMagic(pid,mid) then
if JY.Person[id1]["²ßÂÔ"]>=JY.Magic[mid]["ÏûºÄ"] then--mp enough?
if oid>0 and War.Person[oid].live and (not War.Person[oid].hide) then
if WarMagicCheck(pid,oid,mid) then--µØĞÎ£¬ÌìÆø
local kind=JY.Magic[mid]["ÀàĞÍ"]
local power=JY.Magic[mid]["Ğ§¹û"]
local fw=JY.Magic[mid]["Ğ§¹û·¶Î§"]
if between(kind,1,3) or between(kind,9,10) then--»ğË®Ê¯/¶¾À×
 v=0
if War.Person[pid].enemy~=War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy and WarMagicCheck(pid,eid,mid) then
local hurt=WarMagicHurt(pid,eid,mid)
if hurt>=JY.Person[War.Person[eid].id]["±øÁ¦"] then
hurt=hurt*10
end
if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
v=v+hurt
else
v=v+hurt/4
end
end
end
end
end
end
elseif kind==4 then--¼ÙÇé±¨
v=0
--Èç¹ûµĞÈËÒÑ»ìÂÒ£¬¼ÓÈ¨Öµ£½0
--Ëæ»úÖµ£½£¨0¡«299£©µÄËæ»úÊı
--¸ù¾İ¼ÙÇé±¨Ïµ²ßÂÔÈ«·ÖÎöÖĞµÄËã·¨¼ÆËã²ßÂÔÊÇ·ñ³É¹¦£¬Èç¹û¼ÆËã½á¹ûÊÇ²ßÂÔ³É¹¦£¬¼ÓÈ¨Öµ£½Ëæ»úÊı£«300¡£
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) and (not War.Person[eid].troubled) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
v=math.random(300)-1
if math.random()<WarMagicHitRatio(pid,eid,mid) then
v=v+300
end
end
end
elseif kind==5 then--Ç£ÖÆ
v=0
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
if math.random()<WarMagicHitRatio(pid,eid,mid)+0.2 then
id2=War.Person[eid].id
--»ù±¾Öµ£½²ßÂÔ»ù±¾ÍşÁ¦£«Ê¹ÓÃÕßµÈ¼¶¡Â10£­±»Ç£ÖÆÕßµÈ¼¶¡Â10
--Ëæ»úÖµ£½1¡«10µÄËæ»úÊı
--¼ÓÈ¨Öµ£½»ù±¾Öµ¡ÁËæ»úÊı
v=power+lv/10-JY.Person[id2]["µÈ¼¶"]/10
v=limitX(v,0,JY.Person[id2]["Ê¿Æø"])
local add=math.random(10)
v=math.modf(v*add)
end
end
end
elseif kind==6 then--¼¤Àø
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
--»ù±¾Öµ£½²ßÂÔ»ù±¾ÍşÁ¦£«Ê¹ÓÃÕßµÈ¼¶¡Â10
--Ëæ»úÖµ£½0¡«£¨»ù±¾Öµ¡Â10£­1£©Ö®¼äµÄËæ»úÊı
--¼¤ÀøÖµ£½»ù±¾Öµ£«Ëæ»úÖµ
local sv=power+lv/10
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,War.Person[eid].sq_limited-JY.Person[id2]["Ê¿Æø"])
if sv<10 then
sv=0
end
if JY.Person[id2]["Ê¿Æø"]<40 then
sv=sv*20
end
v=v+sv
end
end
end
end
end
elseif kind==7 then--Ô®Öú
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
if between(dx,1,War.Width) and between(dy,1,War.Depth) then
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
--²ßÂÔ»ù±¾ÍşÁ¦£«Ê¹ÓÃÕßÖÇÁ¦¡ÁÊ¹ÓÃÕßµÈ¼¶¡Â20
--Ëæ»úÖµ£½0¡«£¨»ù±¾Öµ¡Â10£­1£©Ö®¼äµÄËæ»úÊı
--²¹¸øÖµ£½»ù±¾Öµ£«Ëæ»úÖµ
local sv=power+JY.Person[id1]["ÖÇÁ¦2"]*lv/20
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])
if sv<JY.Person[id2]["×î´ó±øÁ¦"]/10 then
sv=0
end
v=v+sv
end
end
end
end
end
if v/JY.Magic[mid]["ÏûºÄ"]<50 then
v=0
end
elseif kind==8 then--¿´»¤
v=0
if War.Person[pid].enemy==War.Person[oid].enemy then
local array=WarGetAtkFW(x,y,fw)
for j=1,array.num do
local dx,dy=array[j][1],array[j][2]
local eid=GetWarMap(dx,dy,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy==War.Person[eid].enemy then
id2=War.Person[eid].id
local sv=hp[power]+JY.Person[id1]["ÖÇÁ¦2"]*lv/20
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])
if sv<JY.Person[id2]["×î´ó±øÁ¦"]/10 then
sv=0
end
v=v+sv
sv=sp[power]+lv/10
sv=math.modf(sv*(1+math.random()/10))
sv=limitX(sv,0,War.Person[eid].sq_limited-JY.Person[id2]["Ê¿Æø"])
if sv<10 then
sv=0
end
if JY.Person[id2]["Ê¿Æø"]<40 then
sv=sv*20
end
v=v+sv
if v<400 then
v=0
end
end
end
end
end
end
end
v=math.modf(v/(JY.Magic[mid]["ÏûºÄ"]+12))
if v>dv then
dv=v
select_magic=mid
end
end
end
end
end
SetWarMap(x,y,6,dv)
SetWarMap(x,y,7,select_magic)
end
return dv,select_magic
end

function WarGetAtkValue(pid,x,y)
local id1,id2
id1=War.Person[pid].id
local bz=War.Person[pid].bz
local v=GetWarMap(x,y,5)
if v==-1 then
v=0
local eid=GetWarMap(x,y,2)
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if War.Person[pid].enemy~=War.Person[eid].enemy then
id2=War.Person[eid].id
v=WarAtkHurt(pid,eid,0)
if v>=JY.Person[id2]["±øÁ¦"] then--Ò»»÷±ØÉ±¶îÍâ¸½¼Ó
v=v+1600
elseif JY.Person[id2]["±øÁ¦"]<JY.Person[id2]["×î´ó±øÁ¦"]/2 then--µĞ¾ü¾üÁ¦µÍÊ±°´±øÁ¦¸½¼Ó
v=v+math.modf((JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])/6)
end
--ĞĞ¶¯¼ÛÖµ£½»ù±¾Öµ¡Â16£®
v=math.modf(v/16)
--Èç¹û¹¥»÷µÄÊÇ³ğÈË£¬ĞĞ¶¯¼ÛÖµ£½ĞĞ¶¯¼ÛÖµ£«30
if id2==War.Person[pid].aitarget then
v=v+30
end
--Èç¹û¹¥»÷µÄÊÇÖ÷½«£¬ĞĞ¶¯¼ÛÖµ=ĞĞ¶¯¼ÛÖµ+?
if War.Person[eid].leader then
v=v+16
end
end
end
SetWarMap(x,y,5,v)
end
return v
end

function WarGetAtkFW(x,y,fw)
local atkarray={}
if fw==1 then--¶Ì±ø
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
atkarray.num=4
elseif fw==2 then--³¤±ø
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==3 then--¹­±ø
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=8
elseif fw==4 then--åó±ø
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=16
elseif fw==5 then--Á¬åó±ø
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
--4
table.insert(atkarray,{x+2,y+2})
table.insert(atkarray,{x+2,y-2})
table.insert(atkarray,{x-2,y+2})
table.insert(atkarray,{x-2,y-2})
table.insert(atkarray,{x,y+3})
table.insert(atkarray,{x,y-3})
table.insert(atkarray,{x+3,y})
table.insert(atkarray,{x-3,y})
atkarray.num=24
elseif fw==6 then--Í¶Ê¯³µ
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x,y+3})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x+3,y})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x,y-3})
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x-3,y})
table.insert(atkarray,{x-2,y+1})
table.insert(atkarray,{x-1,y-2})
--4
table.insert(atkarray,{x,y+4})
table.insert(atkarray,{x+1,y+3})
table.insert(atkarray,{x+2,y+2})
table.insert(atkarray,{x+3,y+1})
table.insert(atkarray,{x+4,y})
table.insert(atkarray,{x+3,y-1})
table.insert(atkarray,{x+2,y-2})
table.insert(atkarray,{x+1,y-3})
table.insert(atkarray,{x,y-4})
table.insert(atkarray,{x-1,y-3})
table.insert(atkarray,{x-2,y-2})
table.insert(atkarray,{x-3,y-1})
table.insert(atkarray,{x-4,y})
table.insert(atkarray,{x-3,y+1})
table.insert(atkarray,{x-2,y+2})
table.insert(atkarray,{x-1,y+3})
atkarray.num=36
elseif fw==7 then--Í»Æï±ø
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=12
elseif fw==8 then--Ã××Ö
for i=1,2 do
table.insert(atkarray,{x-i,y})
table.insert(atkarray,{x+i,y})
table.insert(atkarray,{x,y-i})
table.insert(atkarray,{x,y+i})
table.insert(atkarray,{x-i,y-i})
table.insert(atkarray,{x+i,y-i})
table.insert(atkarray,{x-i,y+i})
table.insert(atkarray,{x+i,y+i})
end
atkarray.num=16
elseif fw==9 or fw==10 then--ko 3.1: every cell within 3 (24) or 4 (40) steps, a diamond - the hangaoje / xichu bawang classes
local kn=(fw==9) and 3 or 4
for dx=-kn,kn do for dy=-kn,kn do
if (dx~=0 or dy~=0) and math.abs(dx)+math.abs(dy)<=kn then table.insert(atkarray,{x+dx,y+dy}) end
end end
atkarray.num=(fw==9) and 24 or 40
elseif fw==24 then--ko 3.6: Demon King - every cell within 5 steps (60)
for dx=-5,5 do for dy=-5,5 do
if (dx~=0 or dy~=0) and math.abs(dx)+math.abs(dy)<=5 then table.insert(atkarray,{x+dx,y+dy}) end
end end
atkarray.num=60
elseif fw==25 then--ko 3.6: Gungyohui - every cell within 2 steps (12): blades next to her, the bow two cells out
for dx=-2,2 do for dy=-2,2 do
if (dx~=0 or dy~=0) and math.abs(dx)+math.abs(dy)<=2 then table.insert(atkarray,{x+dx,y+dy}) end
end end
atkarray.num=12
elseif fw==11 then--Ô­µØ-- 11~20 ²ßÂÔ×¨ÓÃ
table.insert(atkarray,{x,y})
atkarray.num=1
elseif fw==12 then--Îå¸ñ
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
atkarray.num=5
elseif fw==13 then--°Ë¸ñ
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==14 then--¾Å¸ñ
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=9
elseif fw==15 then--Ê®¶ş¸ñ
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=12
elseif fw==16 then--Ê®Èı¸ñ
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
atkarray.num=13
elseif fw==17 then--¶şÊ®¸ñ
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=20
elseif fw==18 then--¶şÊ®Ò»¸ñ
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--1
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
--2
table.insert(atkarray,{x,y+2})
table.insert(atkarray,{x,y-2})
table.insert(atkarray,{x+2,y})
table.insert(atkarray,{x-2,y})
--3
table.insert(atkarray,{x-1,y+2})
table.insert(atkarray,{x-1,y-2})
table.insert(atkarray,{x+2,y-1})
table.insert(atkarray,{x-2,y-1})
table.insert(atkarray,{x+1,y+2})
table.insert(atkarray,{x+1,y-2})
table.insert(atkarray,{x+2,y+1})
table.insert(atkarray,{x-2,y+1})
atkarray.num=21
elseif fw==19 then
atkarray.num=0
elseif fw==20 then
atkarray.num=0
elseif fw==21 then--Ñ¡ÔñÎÒ·½£¬¸½½ü8¸ñ
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=8
elseif fw==22 then--Ñ¡ÔñÎÒ·½£¬¸½½ü9¸ñ
table.insert(atkarray,{x,y})
--1
table.insert(atkarray,{x,y+1})
table.insert(atkarray,{x,y-1})
table.insert(atkarray,{x+1,y})
table.insert(atkarray,{x-1,y})
--2
table.insert(atkarray,{x+1,y+1})
table.insert(atkarray,{x+1,y-1})
table.insert(atkarray,{x-1,y+1})
table.insert(atkarray,{x-1,y-1})
atkarray.num=9
elseif fw==23 then--ko 3.3: mokin (wooden puppet) - the 8 around + 2nd and 3rd cells straight out (16)
for d=-1,1 do for e=-1,1 do if d~=0 or e~=0 then table.insert(atkarray,{x+d,y+e}) end end end
for i=2,3 do
table.insert(atkarray,{x,y+i}) table.insert(atkarray,{x,y-i}) table.insert(atkarray,{x+i,y}) table.insert(atkarray,{x-i,y})
end
atkarray.num=16
elseif fw==26 then--ko 3.6: To-in (clay doll) - the 8 around + the 2nd cell in all 8 directions (16)
for d=-1,1 do for e=-1,1 do if d~=0 or e~=0 then table.insert(atkarray,{x+d,y+e}) table.insert(atkarray,{x+2*d,y+2*e}) end end end
atkarray.num=16
else
atkarray.num=0
end
return atkarray
end

function WarSetAtkFW(id,fw)
local mx=War.Person[id].x
local my=War.Person[id].y
local atkarray=WarGetAtkFW(mx,my,fw)
CleanWarMap(4,0)
for i=1,atkarray.num do
if between(atkarray[i][1],1,War.Width) and between(atkarray[i][2],1,War.Depth) then
SetWarMap(atkarray[i][1],atkarray[i][2],4,1)
end
end
end

function CheckActive()
--ÎÒ·½È«²¿ĞĞ¶¯Íê±Ï?
if JY.Status~=GAME_WMAP then--µ±ÓÎÏ·×´Ì¬¸Ä±äÊ±£¬Ö±½Ó½áÊøÎÒ·½²Ù×÷
return true
end
for i,v in pairs(War.Person) do
if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and v.active and (not v.troubled) then--ÈÎÒâÒ»ÈË¿ÉĞĞ¶¯£¬Ôò·µ»Ø
return false
end
end
War.ControlStatus='DrawStrBoxYesorNo'
if WarDrawStrBoxYesNo("‚Zˆe ‚^‚_ƒP ‚X‚YS …X†RYZ?",M_White) then
return true
else
return false
end
end

--ko †uƒL ‚B„e tu ‚}q(ÊÂ¼ş1999). ‚G„N¡¤‡gƒO …}„o vwf MM
function koWinCount() --ko global: kdef.lua calls it at escape/turn-limit battle endings
JY.Base["ÊÂ¼ş1999"]=math.min((JY.Base["ÊÂ¼ş1999"] or 0)+1,9999)
end

function WarCheckStatus()
if JY.Status==GAME_WMAP then
--µĞ·½Ê§°Ü£¿
local enum=0
for i,v in pairs(War.Person) do
if v.enemy then
if v.live then--and (not v.hide) then
 enum=enum+1
end
end
if v.leader and (not v.live) then
if v.enemy then
JY.Status=GAME_WARWIN
koWinCount()
break
else
JY.Status=GAME_WARLOSE
if koWar then koWar.lost=true end--ko: not a win even if the event lets the story go on
break
end
end
end
if enum==0 and JY.Status==GAME_WMAP then
JY.Status=GAME_WARWIN
koWinCount()
end
--ko 4.0 (koCEev): keep the flag in a local. War_MovePerson / WarAtk inside an event (WarMoveTo, WarAction) save it
-- through the same War.ControlEnableOld, so after a mid-turn event (í—ˆì°½II: í™©ì¶©Â·ì—„ì•ˆ open the gate) it came back
-- false and the move range, the mini panel and the hotkeys stayed off until the next turn (user report)
local koCEev=War.ControlEnable
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
War.ControlEnable=koCEev
end
end

--WarDelay(n)
-- ÑÓÊ±£¬²¢Ë¢ĞÂÕ½³¡
-- nÄ¬ÈÏÎª1
function WarDelay(n)
 n=n or 1
if War.koSkip then--ko 3.1: enemy phase being skipped: pump the keys, present at most every 100 ms
koWarPump()
if koSkipDue() then JY.ReFreshTime=lib.GetTime() DrawWarMap(War.CX,War.CY) ShowScreen() end
return
end
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
koWarPump()--ko 3.1: was lib.GetKey(); during the enemy phase the keys are looked at
ReFresh()
end
end
-- ko 3.1: the enemy phase never polls the queue for input; drain it here and let the "ai_key" hook (hotkey: Space) turn on the skip.
-- The wrapper's mouse swallow flags are put back so a click during the enemy phase does not eat the player's next click
-- ko 3.1: while skipping, one presented frame per 100 ms is enough (the "ì  í„´ ê±´ë„ˆë›°ëŠ” ì¤‘" note stays visible)
function koSkipDue()
local now=lib.GetTime()
if now-(War.koSkipShown or 0)>=100 then War.koSkipShown=now return true end
return false
end
function koWarPump()
lib.GetKey()-- the wrapper looks for the skip key during the enemy phase (War.koAI)
end

function WarPersonCenter(id)
if id<1 or id>War.PersonNum then
return false
end
if War.Person[id].live==false then
return false
end
War.SelID=id
BoxBack()
--WarDelay(CC.WarDelay)
War.LastID=War.SelID
War.SelID=0
return true
end

function WarRest()
--ÈËÎï´¦ÓÚ»Ö¸´ĞÔµØĞÎ»ò³ÖÓĞ»Ö¸´ĞÔ±¦Îï£¬¿ÉÒÔ´¥·¢×Ô¶¯»Ö¸´£®
--´å×¯¡¢Â¹íÎ¿ÉÒÔ»Ö¸´Ê¿ÆøºÍ±øÁ¦£®±øÓª¿ÉÒÔ»Ö¸´±øÁ¦£¬µ«²»ÄÜ»Ö¸´Ê¿Æø£®
--Óñçô¿ÉÒÔ»Ö¸´±øÁ¦ºÍÊ¿Æø£¬Ô®¾ü±¨¸æ¿ÉÒÔ»Ö¸´±øÁ¦£¬ÉâÃüÊé¿ÉÒÔ»Ö¸´Ê¿Æø£®
--µØĞÎºÍ±¦ÎïµÄ»Ö¸´ÄÜÁ¦²»ÄÜµş¼Ó
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if CC.Enhancement and (v.poison or 0)>0 then
local pmx=JY.Person[v.id]["×î´ó±øÁ¦"]
local pcur=JY.Person[v.id]["±øÁ¦"]
local pdm=math.modf(pmx*10/100)
if pdm<1 then pdm=1 end
if pcur-pdm<1 then pdm=pcur-1 end
if pdm>0 then
JY.Person[v.id]["±øÁ¦"]=pcur-pdm
v.hurt=pdm
WarPersonCenter(i)
PlayWavE(17)
WarDelay(CC.WarDelay*6)
v.hurt=-1
end
v.poison=v.poison-1
end
local hp,sp=0,0
local hp_times=0
local sp_times=0
local hp_item_flag=false
local sp_item_flag=false
local hp_skill_flag=false
local sp_skill_flag=false
for index=1,8 do
local tid=JY.Person[v.id]["µÀ¾ß"..index]
if JY.Item[tid]["ÀàĞÍ"]==7 then
if JY.Item[tid]["Ğ§¹û"]==1 then
hp_item_flag=true
elseif JY.Item[tid]["Ğ§¹û"]==2 then
sp_item_flag=true
elseif JY.Item[tid]["Ğ§¹û"]==3 then
hp_item_flag=true
sp_item_flag=true
end
end
end
if CC.Enhancement then
if WarCheckSkill(i,22) then--ÖÎÁÆ
hp_skill_flag=(hp_skill_flag or 0)+1
end
if WarCheckSkill(i,2) or JY.Item[JY.Person[War.Person[i].id]["ÎäÆ÷"]]["ÌØ¼¼"]==2 then--ÊÕÊ°
	hp_skill_flag=(hp_skill_flag or 0)+1
	sp_skill_flag=(sp_skill_flag or 0)+1
end
if WarCheckSkill(i,20) or JY.Item[JY.Person[War.Person[i].id]["ÎäÆ÷"]]["ÌØ¼¼"]==20 then--³Á×Å
sp_skill_flag=(sp_skill_flag or 0)+1
end
end
local dx=GetWarMap(v.x,v.y,1)
--08 ´å×¯ 0D Â¹íÎ 0E ±øÓª
if dx==8 or dx==13 then
hp_times=hp_times+1
sp_times=sp_times+1
elseif dx==14 then
hp_times=hp_times+1
end
if hp_item_flag then
hp_times=hp_times+1
end
if sp_item_flag then
sp_times=sp_times+1
end
if hp_skill_flag then
hp_times=hp_times+hp_skill_flag--ko 5.0: one per skill
end
if sp_skill_flag then
sp_times=sp_times+sp_skill_flag--ko 5.0: one per skill
end
if hp_times>0 then
--±øÁ¦µÄ×Ô¶¯»Ö¸´Á¿£½150£«£¨0¡«10Ö®¼äµÄËæ»úÊı£©¡Á10
hp=150+(math.random(11)-1)*10
--ĞŞ¸ÄÎª×ÔÉí±øÁ¦µÄ10%-20%
if CC.Enhancement then
hp=math.max(150+(math.random(11)-1)*10,math.modf(JY.Person[v.id]["×î´ó±øÁ¦"]/1000*(math.modf(JY.Person[v.id]["Í³ÂÊ2"]/10)+1+math.random(10)))*10)
end
--µ±±øÁ¦»Ö¸´ºóÀë×î´ó±øÁ¦µÄ²î¾à²»×ã10Ê±£¬ÏµÍ³½«×Ô¶¯²¹Âú¸Ã²î¾à
hp=hp*hp_times
if JY.Person[v.id]["×î´ó±øÁ¦"]-JY.Person[v.id]["±øÁ¦"]-hp<9 then
hp=JY.Person[v.id]["×î´ó±øÁ¦"]-JY.Person[v.id]["±øÁ¦"]
end
end
do local koH=rawget(_G,"koHealCut") if koH and hp>0 then hp=koH(hp,i) end end--ko 5.0 (10-13): trial ã€Œì•„êµ° íšŒë³µã€
if sp_times>0 then
--Ê¿ÆøµÄ×Ô¶¯»Ö¸´Á¿£½Í³ÓùÁ¦¡Â10£«£¨1¡«5Ö®¼äµÄËæ»úÊı£©
sp=math.modf(JY.Person[v.id]["Í³ÂÊ2"]/10)+math.random(5)
--Óë±øÁ¦»Ö¸´Ïà·Â£¬Ê¿Æø»Ö¸´ºó³¬¹ı90Ê±£¬ÏµÍ³½«×Ô¶¯²»ÂúÊ¿Æø
sp=sp*sp_times
if v.sq_limited-JY.Person[v.id]["Ê¿Æø"]-sp<9 then
sp=v.sq_limited-JY.Person[v.id]["Ê¿Æø"]
end
end
if hp>0 or sp>0 then
War.MX=v.x
War.MY=v.y
War.CX=War.MX-math.modf(War.MW/2)
War.CY=War.MY-math.modf(War.MD/2)
War.CX=limitX(War.CX,1,War.Width-War.MW+1)
War.CY=limitX(War.CY,1,War.Depth-War.MD+1)
WarDelay(16)
local tmax=16
tmax=math.min(16,(math.modf(math.max(2,math.abs(hp)/50,math.abs(sp)))))
local oldbl=JY.Person[v.id]["±øÁ¦"]
local oldsq=JY.Person[v.id]["Ê¿Æø"]
for t=0,tmax do
JY.ReFreshTime=lib.GetTime()
JY.Person[v.id]["±øÁ¦"]=oldbl+hp*t/tmax
JY.Person[v.id]["Ê¿Æø"]=oldsq+sp*t/tmax
DrawWarMap()
DrawStatusMini(i)
lib.GetKey()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
end
--²ßÂÔÖµµÄ×Ô¶¯»Ö¸´£®
--²¿¶ÓÎ»ÓÚ¾üÀÖ¶ÓÅÔ±ß¿ÉÒÔ×Ô¶¯»Ö¸´²ßÂÔÖµ£¬»Ö¸´Á¿£½Ã¿¾üÀÖ¶Ó£¨µÈ¼¶¡Â10£©µã£®
if v.bz==13 then
for d=1,4 do
local x,y=v.x+CC.DirectX[d],v.y+CC.DirectY[d]
if between(x,1,War.Width) and between(y,1,War.Depth) then
local eid=GetWarMap(x,y,2)
if eid>0 then
if (not War.Person[eid].hide) and War.Person[eid].live then
local pid=War.Person[eid].id
JY.Person[pid]["²ßÂÔ"]=limitX(JY.Person[pid]["²ßÂÔ"]+math.modf(1+JY.Person[v.id]["µÈ¼¶"]/10),0,JY.Person[pid]["×î´ó²ßÂÔ"])
end
end
end
end
end
if CC.Enhancement then
if WarCheckSkill(i,35) then--°Ù³ö
JY.Person[v.id]["²ßÂÔ"]=limitX(JY.Person[v.id]["²ßÂÔ"]+math.modf(1+JY.Person[v.id]["µÈ¼¶"]*JY.Skill[35]["²ÎÊı1"]/100),0,JY.Person[v.id]["×î´ó²ßÂÔ"])
end
end
--×Ô¶¯»½ĞÑ£®
--Ã¿»ØºÏÏµÍ³½«ÊÔÍ¼»½ĞÑ»ìÂÒÖĞµÄ²¿¶Ó£¬»ìÂÒÖĞ²¿¶Ó»Ö¸´Õı³£×´Ì¬µÄËã·¨ÈçÏÂ£º
--»Ö¸´Òò×Ó£½0¡«99µÄËæ»úÊı£¬Èç¹û»Ö¸´Òò×ÓĞ¡ÓÚ£¨Í³ÓùÁ¦£«Ê¿Æø£©¡Â3£¬ÄÇÃ´²¿¶Ó±»»½ĞÑ£®ÓÉ´Ë¿´³ö£¬Í³ÓùÔ½¸ß£¬Ê¿ÆøÔ½¸ß£¬Ô½ÈİÒ×´Ó»ìÂÒÖĞËÕĞÑ£®
--×¢Òâ£º×Ô¶¯»½ĞÑµÄÅĞ¶¨ÊÇÔÙ×Ô¶¯»Ö¸´ºó½øĞĞµÄ£¬Òò´ËÊÇÒÔ»Ö¸´ºóµÄÊ¿ÆøÎª×¼£®
WarTroubleShooting(i)
WarResetStatus(i)
end
end
end

function ESCMenu(kx,ky,r0)--ko: kx,ky = menu position (the top-left button drops it under itself; right-click keeps 64,64)
PlayWavE(0)
local menu={
{"pTU",nil,1},
{"‚B‚T‚nR",nil,1},
{"\130\066\133\114\130\110\129\082",nil,1},--ko 3.3: full delegation (every turn until Esc / right click)
{"‚B‚T…C…D",nil,0},
{"tuvw",nil,1},
{"ƒGƒMEF",nil,1},
{"¡¡…d…e[ƒG",nil,1},
{"¡¡…fƒa",nil,1},
{"QRTU",nil,1},
{"¡¡Debug ",nil,0},
}
local koDbg=table.remove(menu)--ko 3.1: registered rows go before Debug
for _,koM in ipairs(koAddon.warMenu) do
local lab=koM.label if type(lab)=="function" then lab=lab() end
menu[#menu+1]={lab,nil,((not koM.enabled) or koM.enabled()) and 1 or 0}
end
menu[#menu+1]=koDbg
local file=io.open(CONFIG.CurrentPath .. "Menu.debug")
if(file) then
menu[10+#koAddon.warMenu][3]=0
end
if JY.Person[1]["ÃØ¼¼1"]==1 then
	menu[4][3]=1
	--koSaveAnyDiff 5.0 (10-13): load/save at any difficulty (was blocked at challenge +4 and up)
end
if kx and not War.koMenuAtMouse then JY.koMenuClose={16,8,79,23} end--ko: opened from the top-left button: clicking it again closes the menu
War.koMenuAtMouse=nil
local koOrder={1,2,3,4,5}--ko 5.0: display order of the menu rows (10-10), mapped back to the original row numbers below
local koSys={}
for koI,koM in ipairs(koAddon.warMenu) do if koM.group=="system" then koSys[#koSys+1]=9+koI else koOrder[#koOrder+1]=9+koI end end
koOrder[#koOrder+1]=8 koOrder[#koOrder+1]=7 -- save and load together
for _,koK in ipairs(koSys) do koOrder[#koOrder+1]=koK end -- this battle from the start
koOrder[#koOrder+1]=6 -- settings, then exit (10-10 user order)
koOrder[#koOrder+1]=9 koOrder[#koOrder+1]=#menu
local koShown={} for koI,koK in ipairs(koOrder) do koShown[koI]=menu[koK] end
local r=r0 or WarShowMenu(koShown,#koShown,0,kx or 64,ky or 64,0,0,1,1,16,M_White,M_White)--ko 3.0: r0 = shortcut key
if not r0 and r and r>0 then r=koOrder[r] end
if not r0 then if r==3 then r=-3 elseif r>3 then r=r-1 end end--ko 3.3: row 3 is new, the others keep their old numbers
JY.koMenuClose=nil
WarDelay(CC.WarDelay)
if r==1 then
local koIdle=koIdleCount()--ko 3.6: how many allies have not acted
if koIdle>0 then return WarDrawStrBoxYesNo("\129\110\132\076 \130\093\130\108\129\097\130\067 \130\107\131\098 \130\094\130\095: "..koIdle.."*".."‚Zˆe ‚^‚_ƒP ‚X‚YS …X†RYZ?",M_White) end
return WarDrawStrBoxYesNo("‚Zˆe ‚^‚_ƒP ‚X‚YS …X†RYZ?",M_White)
elseif r==2 then
if WarDrawStrBoxYesNo("…gƒb ‚^‚_ƒP G‚W p ‚X‚YS ‚nRXYZ?",M_White) then
for i,v in pairs(War.Person) do
if JY.Status~=GAME_WMAP then
return
end
local dx=GetWarMap(v.x,v.y,1)
if v.live and (not v.hide) and (not v.troubled) and (not v.enemy) and (not v.friend) and v.active then
War.ControlEnable=false
War.InMap=false
AI_Sub(i)
end
end
return true
end
elseif r==-3 then--ko 3.3
return koAutoAllStart()
elseif r==3 then --È«¾ü³·ÍË
	if koHook("war_retreat") then--ko 3.1: an addon handled ì „êµ° í‡´ê°
	elseif fileexist(CC.R_GRPFilename[11]) then
		WarIni2() --Çå³ıµ±Ç°Õ½³¡ÉÏËùÓĞµĞ¾ü
		War.SelID=0--Çå³ı¹â±êÖ¸ÏòµÄÈËÎïid
		War.CurID=0--Çå³ıµ±Ç°ĞĞ¶¯ÈËid
		War.LastID=0--Çå³ıÉÏÒ»¸ö±»¹â±êÖ¸ÏòµÄÈËÎïid
		
		NextEvent(JY.Base["È«¾ü³·ÍË"])--ÖØĞÂÖ´ĞĞ±¾´ÎÕ½³¡ÊÂ¼ş
		rl_flag=1					
		LoadRecord(11)
		War.ControlStatus='select'
		return true
	else		
		talk(369,"‚Bƒa ƒ|ƒG …hGƒh^ ‚aKLM. g~fƒW M‚V …b‚~aƒoZ.")
		
	end
elseif r==4 then
WarShowTarget()--ÏÔÊ¾ÈÎÎñÄ¿±ê
elseif r==5 then
SettingMenu()--¹¦ÄÜÉè¶¨
elseif r==6 then--ÔØÈë
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
{" 6. ",nil,1},
{" 7. ",nil,1},
{" 8. ",nil,1},
{" 9. ",nil,1},
{"10. ",nil,1},
}
for id=1,10 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
for koA=1,3 do--ko 3.1: the three auto saves, newest first
menu2[10+koA]={"A"..koA..". ",nil,1}
if not fileexist(CC.R_GRPFilename[11+koA]) then menu2[10+koA][1]=menu2[10+koA][1].."…i …j…k" else menu2[10+koA][1]=menu2[10+koA][1]..GetRecordInfo(11+koA) end
end
local koBg=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH) local koLd=false--ko 5.0: No / an empty slot goes back to the list (10-07)
while true do
lib.LoadSur(koBg,0,0)
DrawYJZBox2(-1,40,"…d…eƒi ƒG…lS …m…naƒoZ",M_White)--ko 3.0: above the 10/11-row menu
JY.koMenuKeep=true
local s2=ShowMenu(menu2,13,0,0,0,0,0,20,1,16,M_White,M_White)
JY.koMenuKeep=nil
local koAgain=false
if between(s2,1,13) then
if string.sub(menu2[s2][1],5)~="…i …j…k" then
if WarDrawStrBoxYesNo(s2>=11 and "\133\120\130\108 \133\102\131\097 \131\071\133\108\129\083 \133\100\133\101\133\111\129\076\129\077. \131\074\131\075\129\075\129\076\129\089?" or string.format("ƒZƒ~„^ƒP %d‚W ƒG…lS …d…e…oLM. ƒJƒKKLY?",koSlotNo(s2)),M_White) then
koLd=true lib.FreeSur(koBg) koBg=nil--ko: free the saved screen BEFORE LoadRecord (its Config remakes the screen; freeing after corrupted drawing)
if koSaveCompat(s2>=11 and s2+1 or s2) then LoadRecord(s2>=11 and s2+1 or s2) if JY.Status~=GAME_WMAP then rawset(_G,"koNoWarSave",true) end end--ko 5.0: loaded a non-battle save from the battle menu
else koAgain=true end
else
WarDrawStrBoxConfirm("…hGƒh^ ‚aKLM",M_White,true) koAgain=true
end
end
if not koAgain then break end
end
if koBg then lib.LoadSur(koBg,0,0) lib.FreeSur(koBg) end
elseif r==7 then--´¢´æ
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
{" 6. ",nil,1},
{" 7. ",nil,1},
{" 8. ",nil,1},
{" 9. ",nil,1},
{"10. ",nil,1},
}
for id=1,10 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,40,"‚SƒZf …fƒaXYZ?",M_White)--ko 3.0: above the 10/11-row menu
local s2=ShowMenu(menu2,10,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,10) then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚Wf …fƒaWLM. ƒJƒKKLY?",koSlotNo(s2)),M_White) then
WarSave(s2)
end
end
elseif r==8 then
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
WarDelay(CC.WarDelay)
JY.Status=GAME_END
koExit()--ko êµ°ì›…ë¡ (11-03): quit now; GAME_END alone let a story event run on past the battle (ì‚¬ìš©ì ã€Œì „íˆ¬ ì¤‘ x ë¡œ ë„ë©´ ë³´ë¬¼ì„ ë°›ìŒã€)
end
elseif r>=9 and r<=8+#koAddon.warMenu then--ko 3.1: registered rows
koAddon.warMenu[r-8].run()
elseif r==9+#koAddon.warMenu then
local menu2={
{" AI ƒsƒG",nil,1},
{"…p…qƒsƒG",nil,1},
{"jƒAFƒs",nil,1},
{"pƒ|ƒG@",nil,1},
{"‚B…rvJ",nil,1},
{"Io‚]‚l",nil,1},
{"ƒSƒT‚tƒ@",nil,1},
}
local s=WarShowMenu(menu2,#menu2,0,300,128,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if s==1 then--AI²é¿´
if CC.AIXS==false then
CC.AIXS=true
WarDrawStrBoxWaitKey('AI ‚]‚l „Nƒl …q‚V‚h …sKLM.',M_White)
elseif CC.AIXS==true then
CC.AIXS=false
WarDrawStrBoxWaitKey('AI ‚]‚l „Nƒl …q‚V‚h …tKLM.',M_White)
end
elseif s==2 then--×ø±ê²é¿´
if CC.XYXS==false then
CC.XYXS=true
WarDrawStrBoxWaitKey('…p…q …q‚V‚h …sKLM.',M_White)
elseif CC.XYXS==true then
CC.XYXS=false
WarDrawStrBoxWaitKey('…p…q …q‚V‚h …tKLM.',M_White)
end
elseif s==3 then--ÈËÎïµ÷ÊÔ
if CC.RWTS==false then
CC.RWTS=true
WarDrawStrBoxWaitKey('jƒA ƒZ„qƒ[‚h …sKLM.',M_White)
elseif CC.RWTS then
CC.RWTS=false
WarDrawStrBoxWaitKey('jƒA ƒZ„qƒ[‚h …tKLM.',M_White)
end
elseif s==4 then--»ØºÏÖØÖÃ
local hhs={}
for hhxh=1,War.MaxTurn do
hhs[hhxh]={fillblank("d"..hhxh.."p",11),nil,1}
end
local hh=ShowMenu(hhs,#hhs,8,0,0,0,0,6,1,16,M_White,M_White)
if hh>0 then
War.Turn=hh
WarDrawStrBoxWaitKey('p q EF: '..hh,M_White)
end
elseif s==5 then--¿ØÖÆÈ«Ìå
if CC.KZAI==false then
CC.KZAI=true
WarDrawStrBoxWaitKey('ƒO‚T{ ƒL‚TS vJX q „OKLM.',M_White)
elseif CC.KZAI==true then
CC.KZAI=false
WarDrawStrBoxWaitKey('ƒO‚T¡¤ƒL‚T vJ ƒGƒMS …tKLM.',M_White)
end
elseif s==6 then--ÎŞÏŞĞĞ¶¯
if CC.WXXD==false then
CC.WXXD=true
WarDrawStrBoxWaitKey('Io ‚]‚l ƒGƒMS …sKLM.',M_White)
elseif CC.WXXD==true then
CC.WXXD=false
WarDrawStrBoxWaitKey('Io ‚]‚l ƒGƒMS …tKLM.',M_White)
end
elseif s==7 then
local tqmenu={
{"¡¡ ‚L‚M",nil,1},
{"¡¡ ‚N‚O",nil,1},
{"¡¡ ‚P",nil,1},
}
local tq=ShowMenu(tqmenu,#tqmenu,0,0,0,0,0,1,1,16,M_White,M_White)
if tq==1 then
War.Weather=math.random(3)-1
WarDrawStrBoxWaitKey('‚Cƒgƒb ‚L‚MhLM.',M_White)
elseif tq==2 then
War.Weather=3
WarDrawStrBoxWaitKey('‚Cƒgƒb ‚N‚OhLM.',M_White)
elseif tq==3 then
War.Weather=math.random(2)+3
WarDrawStrBoxWaitKey('‚Cƒgƒb ‚PhLM.',M_White)
end
end
end
return false
end

--ko 5.0 (koDiffPick): the ë„ì „ difficulty list (+1..+N) drawn over the settings window, right of the +N button.
--It was ShowMenu, which repaints the title art / map behind it, so the settings window seemed to close (user report).
--Drawn through the window's own redraw (koSetOverlay, called just before it shows the screen), so nothing flickers.
--Click a row = pick; right click, Esc or a click outside = keep the old value (returns 0). Up / Down / Enter work too.
--ko 5.0 (koSetP1): ê¸°ëŠ¥ì„¤ì • page 1 as a list of rows (user: "\133\073\129\101\131\123 \132\079\129\081, \133\106\130\102\129\071\133\119\129\094 \138\111\131\098 \129\119 \133\106\130\102\129\071\133\119\132\083"). Groups, top to bottom:
--  ì†Œë¦¬ (ìŒì•… Â· íš¨ê³¼ìŒ: sliders) / í™”ë©´ Â· ì†ë„ (ë°°ì† Â· ë°°ìœ¨ Â· ì—°ì¶œ Â· ëŒ€í™”) / ì´ ì„¸ì´ë¸Œ (ëª¨ë“œ Â· ì½”ìŠ¤íŠ¸ Â· ì êµ° ì¶œê²© Â· ì ì¥ ì¶œì§„, in a city only:
--  at the title they would only edit the blank record a new game throws away) / ì „íˆ¬ ì¤‘ (ì´ë™ ê°€ì† Â· ì±…ëµ ì—°ì¶œ Â· ì „íˆ¬ ëŒ€ì‚¬, in a battle).
--Rows that do not apply are left out and the rest move up (no gaps); a thin line between groups. Choices read the "on" one first.
--The slider (koSlideDraw / koSlideClick) is shared with the ê²½í—˜ì¹˜ row on page 2 (exprate).
--Volume: koSoundApply only (Config() also rebuilt the game window, which flashed on every slider step â€” user report).
do--koSetP1 helpers: locals kept inside this block (the main chunk is near Lua's local limit)
local function koSetBtn(bx,by,bw,str,sel)--the window's bevel button (the same look as SettingMenu's own), bw wide
local cy=by-1
if sel then
lib.Background(bx+1,cy+1,bx+bw,cy+18,128,M_Black)
lib.DrawRect(bx,cy,bx+bw,cy,M_Black) lib.DrawRect(bx,cy,bx,cy+18,M_Black)
lib.DrawRect(bx,cy+18,bx+bw,cy+18,M_Gray) lib.DrawRect(bx+bw,cy,bx+bw,cy+18,M_Gray)
else
lib.Background(bx+1,cy+1,bx+bw,cy+18,192,M_Black)
lib.DrawRect(bx,cy,bx+bw,cy,M_Gray) lib.DrawRect(bx,cy,bx,cy+18,M_Gray)
lib.DrawRect(bx,cy+18,bx+bw,cy+18,M_Black) lib.DrawRect(bx+bw,cy,bx+bw,cy+18,M_Black)
end
DrawString(bx+math.floor(bw/2)-#str*4,cy+1,str,sel and M_White or M_Silver,16)
end
--a row's button width: 36, or wider for a long word
function koSetBtnW(opts) local w=36 for _,o in ipairs(opts) do w=math.max(w,#o[1]*8+6) end return w end
--slider geometry from the control column x0 to the window's inner right edge xr: â—€ at x0, the bar B1..B2, â–¶ at R, the value after R
function koSlideGeo(x0,xr) local R=xr-60 return x0,x0+22,R-6,R end
local function tri(bx,by,dir,hot)
lib.Background(bx+1,by+1,bx+16,by+18,192,M_Black)
lib.DrawRect(bx,by,bx+16,by,M_Gray) lib.DrawRect(bx,by,bx,by+18,M_Gray)
lib.DrawRect(bx,by+18,bx+16,by+18,M_Black) lib.DrawRect(bx+16,by,bx+16,by+18,M_Black)
local c=hot and C_Name or M_Silver
local cx,cy=bx+8,by+9
for i=0,4 do local lx=cx-dir*(2-i) lib.DrawRect(lx,cy-(4-i),lx,cy+(4-i),c) end--dir -1 left, 1 right (the font has no â—€ â–¶)
end
--v in MIN..MAX; mark = a small tick at that value (nil = none); txt = the value's word; plain = the value drawn white (else yellow)
function koSlideDraw(x0,xr,ry,v,MIN,MAX,mark,txt,plain)
local L,B1,B2,R=koSlideGeo(x0,xr)
local function xOf(u) return B1+math.floor((u-MIN)*(B2-B1)/(MAX-MIN)+0.5) end
tri(L,ry-1,-1,MOUSE.IN(L,ry-1,L+16,ry+17))
tri(R,ry-1,1,MOUSE.IN(R,ry-1,R+16,ry+17))
local ty=ry+6
lib.Background(B1,ty,B2,ty+5,96,M_Black)
lib.DrawRect(B1,ty,B2,ty,M_Gray) lib.DrawRect(B1,ty+5,B2,ty+5,M_Black)
local kx=xOf(v)
if kx>B1+1 then lib.FillColor(B1+1,ty+1,kx,ty+5,C_Name) end
if mark then local mx=xOf(mark) lib.DrawRect(mx,ty-3,mx,ty-1,M_Silver) lib.DrawRect(mx,ty+6,mx,ty+8,M_Silver) end
lib.FillColor(kx-2,ry,kx+3,ry+16,M_White)
lib.DrawRect(kx-3,ry-1,kx+3,ry-1,M_Gray) lib.DrawRect(kx-3,ry+16,kx+3,ry+16,M_Black)
lib.DrawRect(kx-3,ry-1,kx-3,ry+16,M_Gray) lib.DrawRect(kx+3,ry-1,kx+3,ry+16,M_Black)
DrawString(R+24,ry,txt,plain and M_White or C_Name,16)
end
--returns the new value (the same when nothing was pressed); â—€ â–¶ one step with a click sound, the bar = press or drag
function koSlideClick(x0,xr,ry,v,MIN,MAX,STEP)
local L,B1,B2,R=koSlideGeo(x0,xr)
local nv=v
if MOUSE.CLICK(L,ry-1,L+16,ry+17) then nv=v-STEP PlayWavE(0)
elseif MOUSE.CLICK(R,ry-1,R+16,ry+17) then nv=v+STEP PlayWavE(0)
elseif MOUSE.HOLD(B1-6,ry-3,B2+6,ry+19) or MOUSE.CLICK(B1-6,ry-3,B2+6,ry+19) then
nv=MIN+math.floor((MOUSE.x-B1)*(MAX-MIN)/(B2-B1)/STEP+0.5)*STEP
end
return limitX(nv,MIN,MAX)
end
local K_MJ,K_DIF,K_COST,K_SORT,K_ENEMY="\195\216\188\188\049","\183\220\213\189","\206\222\211\195\053","\206\222\211\195\052","\181\208\190\252\179\246\187\247"
local function vol(v) return v==0 and "\133\117" or tostring(v) end
function koP1Rows(notWar)
local R={}
local function add(g,r) r.g=g R[#R+1]=r end
add(1,{label="\130\077\133\118",slide={0,5,1},get=function() return limitX(math.floor((CC.MusicVolume or 0)/20),0,5) end,set=function(v) CC.MusicVolume=20*v koSoundApply() end,txt=vol})
add(1,{label="\129\121\129\123\130\077",slide={0,5,1},get=function() return limitX(math.floor((CC.SoundVolume or 0)/10),0,5) end,set=function(v) CC.SoundVolume=10*v koSoundApply() end,txt=vol})
add(2,{label="\134\099\133\123",opts={{"1\134\099",35},{"1.5",23},{"2\134\099",17},{"3\134\099",12},{"5\134\099",7}},get=function() return CC.FrameNum end,set=function(v) CC.FrameNum=v koSave() end})
if CONFIG.Windows then add(2,{label="\134\099\137\104",opts={{"\136\097\131\071",0},{"1.5",1},{"2",2},{"\130\066\133\114",4}},get=function() return CC.koScale end,set=function(v) koSetScale(v) end}) end--android: the device scales the screen itself
add(2,{label="\130\066\132\101 \129\064\129\065",opts=CONFIG.Windows and {{"\140\071",0},{"\140\071 \138\071\144\084",1},{"\136\095\129\081",2}} or {{"\140\071",0},{"\136\095\129\081",2}},get=function() if (CC.koWide or 2)~=0 then return 2 end return (CC.koFrameFit==1 and CONFIG.Windows) and 1 or 0 end,set=function(v) CC.koFrameFit=(v==1) and 1 or 0 koSetWide(v==2 and 2 or 0) rawset(_G,"koSetRePlace",true) end})--ko 5.1 (10-13): ì „íˆ¬ í™”ë©´ í‹€ / ì „ë©´ / ë„“ê²Œ
add(2,{label="\133\066\133\098",opts={{"1\134\099",1},{"2\134\099",2},{"4\134\099",4}},get=function() return CC.koAnim end,set=function(v) CC.koAnim=v koSave() end})
add(2,{label="\130\095\129\064",opts={{"\129\113\130\108",0},{"\134\115\130\079",1},{"\131\115\132\119",2},{"\131\069\138\075",3},{"\135\071\131\079",4}},get=function() return CC.koAuto or 0 end,set=function(v) CC.koAuto=v koSave() end})
if notWar and JY.Status~=GAME_START then
add(3,{label="\130\090\133\119",mode=true})
if CC.Enhancement then add(3,{label="\138\072\131\126\141\074",opts={{"\130\097\130\077",0},{"\129\098\130\071",1},{"\131\115\132\119",2},{"\135\110\130\112",3}},get=function() local c=JY.Base[K_COST] or 0 if c<0 or c>3 then c=0 end return c end,set=function(v) JY.Base[K_COST]=v end}) end
--koTrialHook 5.0 (10-13): ã€Œì êµ° ì¶œê²©ã€Â·ã€Œì ì¥ ì¶œì§„ã€ are 21+ cycle trials now (trial addon sets JY.Base[K_ENEMY] and [K_SORT])
elseif not notWar then
add(4,{label="\129\071\130\108 \129\094\133\123",opts={{"\133\122",1},{"\133\117",0}},get=function() return CC.MoveSpeed==1 and 1 or 0 end,set=function(v) CC.MoveSpeed=v end})
add(4,{label="\130\117\130\118 \133\066\133\098",opts={{"\133\122",1},{"\133\117",0}},get=function() return CC.cldh==1 and 1 or 0 end,set=function(v) CC.cldh=v end})
add(4,{label="\130\066\132\101 \130\095\130\114",opts={{"\133\122",0},{"\133\117",1}},get=function() return CC.zdby==0 and 0 or 1 end,set=function(v) CC.zdby=v end})
end
local yy,g=40,nil
for _,r in ipairs(R) do if g and r.g~=g then r.sep=true yy=yy+8 end g=r.g r.dy=yy yy=yy+20 end
return R
end
local function C0(x) return x+96 end
function koP1Draw(x,y,notWar,size)
DrawString(x+16,y+16,"\131\071\131\077\129\069\129\070",C_Name,size)
for _,r in ipairs(koP1Rows(notWar)) do
local ry=y+r.dy
if r.sep then lib.DrawRect(x+16,ry-6,x+304,ry-6,M_DimGray) end
DrawStr(x+16,ry,r.label,M_White,size)
if r.slide then
local v=r.get() koSlideDraw(C0(x),x+304,ry,v,r.slide[1],r.slide[2],nil,r.txt(v),true)
elseif r.mode then
local mj=JY.Person[1][K_MJ]
koSetBtn(C0(x),ry,36,"\131\115\132\119",mj==0) koSetBtn(C0(x)+38,ry,36,"\129\068\130\066",mj~=0)
if mj==0 then ptlv=limitX(math.modf(pjlv()/10),0,3) koSetBtn(C0(x)+76,ry,36,"+"..ptlv,false)
else koSetBtn(C0(x)+76,ry,36,"+"..JY.Person[1][K_DIF],true) end
else
local bw,v=koSetBtnW(r.opts),r.get()
for j,o in ipairs(r.opts) do koSetBtn(C0(x)+(j-1)*(bw+2),ry,bw,o[1],v==o[2]) end
end
end
end
function koP1Click(x,y,notWar,redraw)
for _,r in ipairs(koP1Rows(notWar)) do
local ry=y+r.dy
if r.slide then
local v=r.get() local nv=koSlideClick(C0(x),x+304,ry,v,r.slide[1],r.slide[2],r.slide[3])
if nv~=v then r.set(nv) return end
elseif r.mode then
local c=C0(x)
if MOUSE.CLICK(c,ry-1,c+36,ry+17) then
if koNG.warnLower(0) then JY.Person[1][K_MJ]=0 end ptlv=limitX(math.modf(pjlv()/10),0,3) PlayWavE(0) return
elseif MOUSE.CLICK(c+38,ry-1,c+74,ry+17) or (JY.Person[1][K_MJ]~=0 and MOUSE.CLICK(c+76,ry-1,c+112,ry+17)) then
if JY.Person[1][K_MJ]==0 then if koNG.warnLower(JY.Person[1][K_DIF]) then JY.Person[1][K_MJ]=1 end PlayWavE(0)
else
rawset(_G,"koDiffAt",{c+114,ry-2})
local t=koDiffPick(x,y,redraw)
rawset(_G,"koDiffAt",nil)
if t>0 and koNG.warnLower(t) then JY.Person[1][K_DIF]=t end
end
return
end
else
local bw=koSetBtnW(r.opts)
for j,o in ipairs(r.opts) do
local bx=C0(x)+(j-1)*(bw+2)
if MOUSE.CLICK(bx,ry-1,bx+bw,ry+17) then r.set(o[2]) PlayWavE(0) return end
end
end
end
end
end--koSetP1
function koDiffPick(x,y,redraw)
local K="\183\220\213\189"--JY.Person[1] field: the ë„ì „ difficulty
local N=koNG.maxdiff()
local cur=JY.Person[1][K] or 1
local rh,bw=18,44
local bx,by=x+80+4*38+4,y+78
if rawget(_G,"koDiffAt") then bx,by=koDiffAt[1],koDiffAt[2] end--ko 5.0 (koSetP1): next to the +N button
local bh=rh*N+6
if by+bh>CC.ScreenH-4 then by=CC.ScreenH-4-bh end
local function row(i) local ry=by+3+(i-1)*rh return bx+3,ry,bx+bw-3,ry+rh-1 end
local hov=cur
rawset(_G,"koSetOverlay",function()
lib.Background(bx+1,by+1,bx+bw,by+bh,48,M_Black)
lib.DrawRect(bx,by,bx+bw,by,M_Gray) lib.DrawRect(bx,by,bx,by+bh,M_Gray)
lib.DrawRect(bx,by+bh,bx+bw,by+bh,M_Black) lib.DrawRect(bx+bw,by,bx+bw,by+bh,M_Black)
for i=1,N do
local a,b,c,d=row(i)
local s="+"..i
if i==hov then lib.Background(a,b,c,d,128,M_Black) lib.DrawRect(a,b,c,b,M_Black) lib.DrawRect(a,d,c,d,M_Gray) end
if i==cur then lib.DrawRect(a+2,b+8,a+5,b+8,M_White) lib.DrawRect(a+3,b+7,a+3,b+9,M_White) end--a small mark on the current one
DrawString(bx+math.floor(bw/2)-#s*4+3,b+1,s,i==hov and C_Name or (i==cur and M_White or M_Silver),16)
end
do local koF=rawget(_G,"koDiffInfoDraw") if koF then koF(hov,bx,by,bw,bh) end end--ko 5.0 (10-13): what the highlighted level does (diff addon)
end)
local pick=0
koMouseReset()
while true do
redraw(0)
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then rawset(_G,"koSetOverlay",nil) koExit() end
for i=1,N do local a,b,c,d=row(i) if MOUSE.IN(a,b,c,d) then hov=i end end
if e==1 and k==27 then break end
if e==1 and (k==13 or k==32) then pick=hov break end
if e==1 and k==1073741906 and hov>1 then hov=hov-1 end
if e==1 and k==1073741905 and hov<N then hov=hov+1 end
if MOUSE.ESC() then break end
local hit=false
for i=1,N do local a,b,c,d=row(i) if MOUSE.CLICK(a,b,c,d) then pick=i hit=true break end end
if hit then break end
if MOUSE.CLICK() then break end--a click anywhere else
end
rawset(_G,"koSetOverlay",nil)
koMouseReset()
if pick>0 then PlayWavE(0) end
return pick
end
function SettingMenu() --¹¦ÄÜÉè¶¨
local x,y,w,h
local size=16
local sig
w=320
local koRows=koSettingRows()--ko 3.1: the registered rows shown here
h=128+128+20+24--ko 3.6 later (koSetPages): one box of the original size; page 1 = the game's rows, pages 2.. = the registered rows, 11 a page (arrows at the top)
local koPage=1
local koPages=1+math.max(1,math.ceil(#koRows/11))
local koPgHold=false--ko 3.6 later: the page button held down (drawn pressed, like í™•ì¸)
local notWar=true
local x1,x2,y1,y2
local function koPlace()--ko 3.2: placed again when the battle layout changes while the box is open
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(0)
y=koMapCenterY(0)
notWar=false
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-0)/2
y=16+(400-0)/2
notWar=true
else
x=(CC.ScreenW-0)/2
y=(CC.ScreenH-0)/2
notWar=true
end
x=x-w/2
y=y-h/2
x1=x+254
x2=x1+52
y1=y+h-36
y2=y1+24
end
koPlace()
local function button(bx,by,str,flag,koBW)
local box_w=koBW or 36
local box_h=18
local cx=bx
local cy=by-1
if flag then--selected
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,128,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Black)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Black)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Gray)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Gray)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_White,size)
else
lib.Background(cx+1,cy+1,cx+box_w,cy+box_h,192,M_Black)
lib.DrawRect(cx,cy,cx+box_w,cy,M_Gray)
lib.DrawRect(cx,cy,cx,cy+box_h,M_Gray)
lib.DrawRect(cx,cy+box_h,cx+box_w,cy+box_h,M_Black)
lib.DrawRect(cx+box_w,cy,cx+box_w,cy+box_h,M_Black)
DrawString(cx+box_w/2-size*#str/4,cy+1,str,M_Silver,size)
end
end
local function redraw(flag)
local T={[0]="…u","£±","£²","£³","£´","£µ"}
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
DrawSMap()
elseif JY.Status==GAME_START then
-- ko 3.0: on the title screen the window is rebuilt by the scale/volume buttons (Config()), which wipes
-- the screen. Put the title art back before drawing the dialog, as the other states redraw their map.
if rawget(_G,"koSettingBg") then koSettingBg() else--ko 6.0 (11-03): opened from the main screen (campsel), its grid
koTitleStill() end--ko 6.0 campaigns (11-01): the current story's logo, not the old title picture
end
lib.PicLoadCache(4,80*2,x,y,1)
do--ko 3.0: the box middle tiled from rows 28..88 of the picture (its OK button sits below row 92)
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
if koPage==1 then koP1Draw(x,y,notWar,size) end--ko 5.0 (koSetP1)
if koPage>1 then--ko 3.1: registered rows (3.6 later: on their own pages)
DrawString(x+16,y+16,"\131\071\131\077\129\069\129\070",C_Name,size)
for koI,koR in ipairs(koRows) do
local koK=koI-(koPage-2)*11
if koK>=1 and koK<=11 then
local ry=y+20+20*koK+(koR.koGap or 0)--ko 5.0 (koSetP1)
if koR.koSep then lib.DrawRect(x+16,ry-6,x+304,ry-6,M_DimGray) end
DrawStr(x+16,ry,koR.label,M_White,size)
local koW=koSettingOptW(koR) for koJ,koO in ipairs(koR.opts) do button(x+136+(koJ-1)*(koW+2),ry,koO[1],(not koR.run) and CC[koR.key]==koO[2],koW) end if koR.draw then koR.draw(x,ry) end--ko 5.0 (koRowDraw)
end
end
end
do--ko 3.6 later (koSetPageBtn): n/N and one button at the top right - ë‹¤ìŒ ìª½, and on the last page back to the first
--koSetPageBtn2: no n/N (user request), the button alone
--koSetPageBtn3: the page button looks like í™•ì¸ (the box picture's own button, cut out and put at the bottom left), its
--  word painted over with the button's text-free left strip, then ë‹¤ìŒ / ì´ì „ / ì²˜ìŒ
--koSetPageBtn5: back to the plain box of the first version (the í™•ì¸ look blurred the word), at the bottom left;
--  held down it is drawn pushed in (the bevel swapped, the word one pixel down-right)
local lab=(koPage<koPages) and "\129\077\130\077 \139\074" or ((koPages==2) and "\129\071\130\066 \139\074" or "\137\112 \139\074")
local bx,by,bw=x+14,y+h-34,70
local lt,rb=M_Gray,M_Black
if koPgHold then lt,rb=M_Black,M_Gray end
lib.Background(bx+1,by+1,bx+bw,by+19,koPgHold and 128 or 192,M_Black)
lib.DrawRect(bx,by,bx+bw,by,lt) lib.DrawRect(bx,by,bx,by+19,lt)
lib.DrawRect(bx,by+19,bx+bw,by+19,rb) lib.DrawRect(bx+bw,by,bx+bw,by+19,rb)
local d=koPgHold and 1 or 0
DrawString(bx+bw/2-#lab*4+d,by+2+d,lab,MOUSE.IN(bx,by,bx+bw,by+19) and C_Name or M_White,size)
end
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
do local koOv=rawget(_G,"koSetOverlay") if koOv then koOv() end end--ko 5.0 (koDiffPick): something drawn over the window
if notWar then
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
else
ReFresh(0)
end
end
koMouseReset()
local current=0
while true do
redraw(current)
local koE,koKey=koPollKey()
local koAddonRowClick=false--ko 3.1: registered ê¸°ëŠ¥ì„¤ì • rows
for koI,koR in ipairs(koRows) do
local koK=koI-(koPage-2)*11
local ry=y+20+20*koK+(koR.koGap or 0)--ko 5.0 (koSetP1)
local koW=koSettingOptW(koR) for koJ,koO in ipairs(koR.opts) do
if koPage>1 and koK>=1 and koK<=11 and MOUSE.CLICK(x+136+(koJ-1)*(koW+2),ry,x+136+(koJ-1)*(koW+2)+koW,ry+16) then
if koR.run then PlayWavE(0) koAddonRowClick=true koR.run(koO[2])--ko 3.1: an action row (í™•ì¥)
else
CC[koR.key]=koO[2] koSave() PlayWavE(0) koAddonRowClick=true
if koR.onchange then koR.onchange(koO[2]) end
end
end
end
if koR.click and koPage>1 and koK>=1 and koK<=11 and koR.click(x,ry) then koSave() koAddonRowClick=true end--ko 5.0 (koRowDraw)
end
koPgHold=MOUSE.HOLD(x+14,y+h-34,x+84,y+h-15)
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
if notWar then
lib.Delay(100)
else
WarDelay(4)
end
return
else
current=0
if koE==1 and koKey==1073741904 then--Left key: the page before
PlayWavE(0) koPage=(koPage>1) and koPage-1 or koPages
elseif MOUSE.CLICK(x+14,y+h-34,x+84,y+h-15) or (koE==1 and koKey==1073741903) then--the page button / Right key: the next page, from the last back to the first
PlayWavE(0) koPage=(koPage<koPages) and koPage+1 or 1
elseif koPage==1 then
koP1Click(x,y,notWar,redraw)--ko 5.0 (koSetP1)
if rawget(_G,"koSetRePlace") then rawset(_G,"koSetRePlace",nil) koPlace() end--ko 5.1: the battle screen size changed
end--koPage==1
end
end
end

function WarGetPic(id)
--[[
0 ¶Ì±ø
1 ¶Ì±ø
2 ³¤±ø
3 Õ½³µ
4 ¹­±ø
5 åó±ø
6 Í¶Ê¯³µ
7 ÇáÆï±ø
8 ÖØÆï±ø
9 ½üÎÀ¶Ó
10 É½Ôô
11 ¶ñÔô
12 ÒåÔô
13 ¾üÀÖ¶Ó
14 ÃÍÊŞ±øÍÅ
15 ÎäÊõ¼Ò
16 ÑıÊõÊ¦
17 ÒìÃñ×å
18 ÃñÖÚ
19 ÔËÊä¶Ó
5020 5070 5120 ²Ü²Ù(Ô­°æ)
5170 5220 5270 ÏÄºîª(Ô­°æ)
5320 5370 5420 ÕÅÁÉ(Ô­°æ)
5470 5520 5570 õõ²õ(Ô­°æ)
5620 5670 5720 Ë¾ÂíÜ²(Ô­°æ)
5770 Áõ±¸(Ô­°æ£¬½ø½×)
5820 Öî¸ğ(Öî¸ğ½í)
5870 ÖÜè¤(Ô­°æ)
5920 Â½Ñ·(Ô­°æ)
5970 6020 6070 µäÎ¤(Ô­°æ)
6120 6170 6220 ĞíñÒ(Ô­°æ)
6270 ×£ÈÚ(Ô­°æ)
6320 Áõ±¸(Ô­°æ)
6370 6420 ¹ØÓğ(Ô­°æ)
6470 6520 ÕÅ·É(Ô­°æ)
6570 ÕÔÔÆ(Ô­°æ)
6620 Ï×µÛ(Ô­°æ)
6670 ÂÀ²¼(Ô­°æ)
6720 ½ªÎ¬ ÆïÂí
6770 6820 ÕÔÔÆ ÆïÂí
6870 ÁÎ»¯ ²½ĞĞ
6920 7420 Áõ±¸ ²½ĞĞ
6970 ÅÓÍ³(ÎŞË«)
7020 ¾¸³ğ
7070 ÖÜè¤(Èı¹úÖ¾)
7120 ¹ØÓğ ÆïÂí
7170 ÕÅ·É ÆïÂí
7220 ÎäËÉ(Ë®ä°)
7270 ÂÀ²¼ ÆïÂí
7320 ÕÅÁÉ? ²½ĞĞ
7370 ½£¿Í
7470 Ë¾ÂíÜ² ²½ĞĞ
7520 Å®½£¿Í
7570 ½£ÏÉ
7620 ÂÀ²¼ ²½ĞĞ
7670 Â³ÖÇÉî(Ë®ä°)
7720 Â½Ñ·(Èı¹úÖ¾)
7770 Ëï¼á ÆïÂí
7820 Ğì»Î ÆïÂí
7870 Ë«µ¶¡¤Å®
7920 ÖÜ²Ö ²½ĞĞ
7970 ÄĞ¡¤Ç¹¡¤Ë«êª¡¤°×¡¤ÆïÂí
8020 µäÎ¤ ÆïÂí
8070 8120 ¼ÍÁé ÆïÂí
8170 8220 ÑÕÁ¼ ÎÄ³ó ÆïÂí
8270 ÀîÃ÷ ÃÍÊŞ
8320 ĞíñÒ ÆïÂí
8370 8420 Ì«Ê·´È ÆïÂí
8470 ÕÔÔÆ(½Ö»ú) ÆïÂí
8520 Ë«ÉÈ¡¤Å® ²½ĞĞ
8570 ÎºÑÓ ÆïÂí
8620 ²ÜÈÊ ²½ĞĞ
8670 ¶­×¿ ²½ĞĞ
8720 ¶ÎÓş
8770 »Æ¸Ç
8820 »ÆÖÒ ¹­
8870 »ÆÖÒ ÆïÂí
8920 Âí³¬
8970 Âíá· ²½ĞĞ
9020 ÕÅÈÎ ¹­
9070 ÖÜÌ© ²½ĞĞ
9120 ×ÓÁú ²½ĞĞ
9170 ¸ßË³ Ñµ»¢
9220 É³Ä¦¿Â ÌÙ¼×
9270 Öî¸ğ ÂÚ½í
9320 Öî¸ğ Ã±×Ó
9820 ²Ü²Ùsan10·ç¸ñ ÆïÂí
9870 µ¥µ¶ÄĞ ²½ĞĞ À¶
9920 µË°¬ ÆïÂí
9970 10020 10070 10120 ¹ØÆ½ÆïÂí1-4
10170 10220 ÂíÚÕ ²½ĞĞ
10270 Ë«±ŞÄĞ
10320 ±¸Äï£¬²½ĞĞ
10370 ²½½«£¬½££¬°×
10420 ²½½«£¬½£¶Ü£¬À¶
10470 ²½½«£¬Ç¹£¬À¶
10520 ¹«Ëïè¶£¬°×Âí
10570 ¹ÃÄï£¬µ¥µ¶
10620 ¹ØĞË£¬²½
10670 ¹ØĞË£¬ÆïÂí
10720 ½£¿Í£¬»Æ
10770 Àîµä£¬ÆïÂí
10820 Àîµä£¬²½ĞĞ
10870 ÂíÚÕ£¬ÑıÊõÊ¦
10920 - 11320 Ç¹±ø
11370 É³Ä¦¿Â£¬²½ĞĞ
11420 É³Ä¦¿Â£¬ÆïÂí
11470 ÕÅ°ú£¬ÆïÂí
11520 - 11670 ÕÅÁÉs10£¬ÆïÂí lv3,moveºÍlv2Ò»Ñù£¬Ô­±¾µ¼³öµÄÓÎÏ·Àï¾ÍÓĞÎÊÌâ
11670 ÕÔÔÆ£¬ÀÏÄê
11720 ËïÈ¨£¬Ëï²ß£¬Ëï¼á£¬Ô­°æ
11770 Ô¬ÉÜ£¬Ô­°æ
]]--
local pid=War.Person[id].id
return GetPic(pid,War.Person[id].enemy,War.Person[id].friend)
end

function GetBZPic(pid,enemy,friend)
local pic=20
local bz=JY.Person[pid]["±øÖÖ"]
local lv=1
if JY.Person[pid]["µÈ¼¶"]<20 then
lv=1
elseif JY.Person[pid]["µÈ¼¶"]<40 then
lv=2
else
lv=3
end
pic=JY.Bingzhong[bz]["ÌùÍ¼"..lv]
if enemy then
return pic+JY.Bingzhong[bz]["µĞ¾üÆ«ÒÆ"]
elseif friend then
return pic+JY.Bingzhong[bz]["ÓÑ¾üÆ«ÒÆ"]
else
return pic+JY.Bingzhong[bz]["ÎÒ¾üÆ«ÒÆ"]
end 
end

function GetPic(pid,enemy,friend)
--[[
if bz>12 then
 bz=12+(bz-13)*3+lv
end
-- 1 4 7 10 13 16 19 22 25 28 31 34 37 40
-- ²½±ø ¹­±ø Æï±ø Ôô±ø ÀÖ¶Ó ÃÍÊŞ ÎäÊõ¼Ò ÑıÊõÊ¦ Òì×å ÃñÖÚ ÊäËÍ Õ½³µ Í¶Ê¯³µ Í»Æï±ø
local T1={[0]=20,20,170,320, 920,1070,1220, 470,620,770, 1370,1520,1670, 3620,3620,3620, 3170,3170,3170, 1820,1970,2120, 2720,2870,3020, 3320,3320,3320, 3570,3570,3570, 3770,3770,3770, 3920,4070,4220, 4370,4520,4670, 9370,9520,9670,}--µĞ¾ü ºì
local T2={[0]=70,70,220,370, 970,1120,1270, 520,670,820, 1420,1570,1720, 3670,3670,3670, 3220,3220,3220, 1870,2020,2170, 2770,2920,3070, 3370,3370,3370, 3570,3570,3570, 3820,3820,3820, 3970,4120,4270, 4420,4570,4720, 9420,9570,9720,}--ÓÑ¾ü »Æ
local T3={[0]=120,120,270,420, 1020,1170,1320, 570,720,870, 1470,1620,1770, 3720,3720,3720, 3270,3270,3270, 1920,2070,2220, 2820,2970,3120, 3420,3420,3420, 3570,3570,3570, 3870,3870,3870, 4020,4170,4320, 4470,4620,4770, 9470,9620,9770,}--ÎÒ¾ü À¶
 
if enemy then
JY.Person[pid]["Õ½¶·¶¯×÷"]=T1[bz] or 20
elseif friend then
JY.Person[pid]["Õ½¶·¶¯×÷"]=T2[bz] or 70
else
JY.Person[pid]["Õ½¶·¶¯×÷"]=T3[bz] or 120
end 
 ]]--
local bz=JY.Person[pid]["±øÖÖ"]
local lv=1
if bz==3 or bz==6 or bz==9 or bz==12 then
lv=3
elseif bz==2 or bz==5 or bz==8 or bz==11 then
lv=2
elseif bz==1 or bz==4 or bz==7 or bz==10 then
lv=1
elseif JY.Person[pid]["µÈ¼¶"]<20 then
lv=1
elseif JY.Person[pid]["µÈ¼¶"]<40 then
lv=2
else
lv=3
end
JY.Person[pid]["Õ½¶·¶¯×÷"]=GetBZPic(pid,enemy,friend)
local id=(rawget(_G,"koWujeIdentity") and koWujeIdentity(pid)) or JY.Person[pid]["´úºÅ"]
if id==1 then--Áõ±¸
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6320
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12120
else
JY.Person[pid]["Õ½¶·¶¯×÷"]=12170
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==27 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10320
else--²½ĞĞ
if lv<3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6920
else
JY.Person[pid]["Õ½¶·¶¯×÷"]=7420
end
end
elseif id==2 or id==373 then--¹ØÓğ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6370
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6420
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7120
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=11870
end
elseif id==3 or id==374 then--ÕÅ·É
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6470
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6520
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7170
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=12570
end
elseif id==4 then--¶­×¿
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8670
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==5 then--ÂÀ²¼
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6670
elseif lv==2 or lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12220
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7620
end
elseif id==6 then--»ªĞÛ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=11970
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==9 then--²Ü²Ù
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5020
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5070
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5120
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==10 then--Ô¬ÉÜ
JY.Person[pid]["Õ½¶·¶¯×÷"]=11770
elseif id==11 then--Ëï¼á
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=7770
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==13 then--¹«Ëïè¶
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=10520
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==15 then--»Æ¸Ç
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=8770
end
elseif id==17 then--ÏÄºîª
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5170
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5220
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5270
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==18 then--ÏÄºîÔ¨
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if true or bz==22 then
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12320
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12370
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12420
else
end
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==19 then--²ÜÈÊ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=8620
end
elseif id==30 then--¹ØĞË
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==3 and JY.Person[pid]["µÈ¼¶"]>=60 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10670
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=10620
end
elseif id==31 then--ÂíÚÕ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==16 then--ÑıÊõÊ¦
JY.Person[pid]["Õ½¶·¶¯×÷"]=10870
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10170
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10170
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10220
end
end
elseif id==34 then--ÁÎ»¯
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=6870
end
elseif id==35 then--É³Ä¦¿Â
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=11420
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=11370--9220
end
elseif id==44 then--ÕÅ°ú
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==3 and JY.Person[pid]["µÈ¼¶"]>=60 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=11470
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==52 then--ÑÕÁ¼
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8170
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==53 then--ÎÄ³ó
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8220
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==54 then--ÕÔÔÆ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6570
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6770
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6820
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=9120
end
elseif id==68 then--ĞíñÒ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8320
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6120
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6170
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6220
else
end
end
elseif id==70 then--¼ÍÁé
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8070
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8120
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8120
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==73 then--¸ßË³
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==14 then--Ñµ»¢Ò»°ãÎŞÌØÊâĞÎÏó
JY.Person[pid]["Õ½¶·¶¯×÷"]=9170
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==79 then--Ğì»Î
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=7820
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==80 then--ÕÅÁÉ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5320
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5370
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5420
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7320
end
elseif id==83 then--¼òÓº
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±ø
if lv>1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12070
end
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==103 then--ÕÅàA
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if true or bz==22 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=12520
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==116 then--Àîµä
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=10820
end
elseif id==126 then--Öî¸ğÁÁ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
if between(JY.Person[pid]["µÈ¼¶"],1,39) then
JY.Person[pid]["Õ½¶·¶¯×÷"]=9270
elseif between(JY.Person[pid]["µÈ¼¶"],40,59) then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5820
elseif between(JY.Person[pid]["µÈ¼¶"],60,9999) then
JY.Person[pid]["Õ½¶·¶¯×÷"]=9320
else
end
end
elseif id==127 then--ÎºÑÓ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8570
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==128 then--¹ØÆ½
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=9970
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10070
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=10120
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==129 then--ÏÄºîÀ¼
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=9870
end
elseif id==133 then--ÅÓÍ³
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=6970
end
elseif id==142 then--ËïÈ¨
JY.Person[pid]["Õ½¶·¶¯×÷"]=11720
elseif id==143 then--ÖÜè¤
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7070
end
elseif id==150 then--Ì«Ê·´È
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8370
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8420
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8420
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==151 then--Â½Ñ·
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7720
end
elseif id==155 then--ÖÜ²Ö
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7920
end
elseif id==163 then--ÖÜÌ©
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=9070
end
elseif id==170 then--»ÆÖÒ
if between(bz,7,9) then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8870
elseif bz==22 then--¹­Æï
JY.Person[pid]["Õ½¶·¶¯×÷"]=12020
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
JY.Person[pid]["Õ½¶·¶¯×÷"]=8820
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==190 then--Âí³¬
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8920
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==196 then--ÕÅÈÎ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
JY.Person[pid]["Õ½¶·¶¯×÷"]=9020
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==204 then--Âíá·
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=8970
end
elseif id==214 then--Ë¾ÂíÜ²
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5620
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5670
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5720
else
end
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7470
end
elseif id==216 then--ÅÓµÂ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=10770
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==244 then--½ªÎ¬
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=6720
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
end
elseif id==376 then--ÀîÃ÷
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==14 then--Ñµ»¢Ò»°ãÎŞÌØÊâĞÎÏó
JY.Person[pid]["Õ½¶·¶¯×÷"]=8270
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=10570
end
elseif id==377 then--×£ÈÚ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=6270
end
elseif id==383 then--Ï×µÛ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=6620
end
elseif id==385 then--Â³ÖÇÉî
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7670
end
elseif id==386 then--ÎäËÉ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7220
end
elseif id==387 then--µäÎ¤
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
JY.Person[pid]["Õ½¶·¶¯×÷"]=8020
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5970
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5970
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6020
else
end
end
elseif id==388 then--¾¸³ğ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7020
elseif id==389 then--ÏÉ×Ó
JY.Person[pid]["Õ½¶·¶¯×÷"]=7520
elseif id==390 then--½£ÏÉ
JY.Person[pid]["Õ½¶·¶¯×÷"]=7570
elseif id==-391 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7620
elseif id==-392 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7120
elseif id==-393 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7170
elseif id==-394 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8470
elseif id==-395 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8570
elseif id==-396 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8020
elseif id==-397 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5420
elseif id==-398 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=6220
elseif id==404 then--õõ²õ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
if lv==1 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5470
elseif lv==2 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5520
elseif lv==3 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5570
else
end
end
elseif id==405 then--ºúµÑ
if between(bz,7,9) or bz==20 or bz==22 then--ÆïÂí
elseif bz>=4 and bz<=6 then--¹­±øÒ»°ãÎŞÌØÊâĞÎÏó
elseif bz==21 then--Í¶Ê¯³µÒ»°ãÎŞÌØÊâĞÎÏó
else--²½ĞĞ
JY.Person[pid]["Õ½¶·¶¯×÷"]=8720
end
elseif id==406 then--bttt
JY.Person[pid]["Õ½¶·¶¯×÷"]=12270
elseif id==410 then--ko 3.6: Sun Shangxiang (twin blades)
JY.Person[pid]["Õ½¶·¶¯×÷"]=7870
elseif id==411 then--ko 3.6: Da Qiao (twin fans)
JY.Person[pid]["Õ½¶·¶¯×÷"]=8520
elseif id==412 then--ko 3.6: Xiao Qiao (the twin-fan set recoloured)
JY.Person[pid]["Õ½¶·¶¯×÷"]=12770
elseif id==413 then--ko 3.6: Wutugu (rattan armour)
JY.Person[pid]["Õ½¶·¶¯×÷"]=9220
elseif id==382 then--ko 3.6 later: Sima Hui (Zuo Ci's sage set, robe in brown)
JY.Person[pid]["\213\189\182\183\182\175\215\247"]=12920
elseif id==415 then--ko 3.6 later: Huang Yueying (the twin-fan set in gold)
JY.Person[pid]["\213\189\182\183\182\175\215\247"]=12870
elseif id==414 then--ko 3.6: To-in (clay doll)
JY.Person[pid]["Õ½¶·¶¯×÷"]=12820
end
return JY.Person[pid]["Õ½¶·¶¯×÷"]
end

function koTourRoster()--ko 3.0: the 152-general roster, shared by the title and the city tournaments
do local KC=rawget(_G,"koCamp") if KC and KC.recBook then local T={} for _,p in ipairs(KC.recBook) do T[#T+1]=p end return T end end--ko 6.0 (11-01): a story's own book (koCamp.recBook), not base-story numbers
local T={ 5,3,387,2,54,68,
190,385,17,170,98,
150,216,386,390,44,127,389,35,
53,79,148,6,11,
18,80,103,244,4,
30,201,52,163,196,388,
15,142,202,155,122,
149,204,171,377,167,
212,19,128,151,109,
34,178,236,1,9,104,
143,165,174,254,20,
102,218,61,106,191,
129,141,166,205,252,
116,13,200,46,70,88,113,
210,376,14,168,211,
213,217,243,81,162,
208,209,248,241,31,
91,105,240,47,82,
117,221,48,144,45,
51,63,87,136,378,
10,73,146,76,380,
38,188,133,214,50,
57,112,126,83,65,
77,94,64,69,62,
145,84,251,7,379,
253,114,239,402,403,
404,405,382,--ko 5.0 (10-13): 406 bttt (a test entry with an ad picture for a face) dropped
}
return T
end
function FightMenu()
if koHook("title_fight",koTourRoster()) then return end--ko 3.1: an addon (ë¬´ìˆ  ëŒ€íšŒ) takes the row
local T=koTourRoster()
local id1=FightSelectMenu(T)
if id1==0 then
return
end
for i,v in pairs(T) do
if id1==v then
 table.remove(T,i)
break
end
end
local id2=FightSelectMenu(T)
if id2==0 then
return
end
local s={0,1,2,4,6}
fight(id1,id2,s[math.random(5)])
end

function FightSelectMenu(T)
local num_perpage=12
local page=1
local total_num=#T
local maxpage=math.modf(total_num/(num_perpage-2))
if total_num>(num_perpage-2)*maxpage then
maxpage=maxpage+1
end
local t={}
while true do
for i=2,num_perpage-1 do
t[i]=0
end
t[1]=-1
t[num_perpage]=-2
for i=2,num_perpage-1 do
local idx=(num_perpage-2)*(page-1)+(i-1)
if idx<=total_num then
t[i]=T[idx]
end
end
local m={}
m[1]={" G‚B …|G‚C",nil,1}
m[num_perpage]={" M‚M …|G‚C",nil,1}
for i=2,num_perpage-1 do
if t[i]>0 then
local str=JY.Person[t[i]]["ĞÕÃû"]
if #str==6 then
str=" "..str
elseif #str==4 then
str="¡¡"..str
elseif #str==3 then
str="¡¡ "..str
elseif #str==2 then
str="¡¡ "..str
end
m[i]={str,nil,1}
else
m[i]={"",nil,0}
end
end
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
DrawSMap()
else
lib.FillColor(0,0,0,0)
end
local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,M_White,M_White)
if r==1 then
if page>1 then
page=page-1
end
elseif r==num_perpage then
if page<maxpage then
page=page+1
end
elseif r==0 then
return 0
else
local id=t[r]
local bz=JY.Person[id]["±øÖÖ"]
if WarDrawStrBoxYesNo(string.format('%s %d‚R‚{ %s Iƒ} %d*ijXYZ?',JY.Person[id]["ĞÕÃû"],JY.Person[id]["µÈ¼¶"],JY.Bingzhong[bz]["Ãû³Æ"],JY.Person[id]["ÎäÁ¦"]),M_White,true) then
return t[r]
end
end
end
end

function LvMenu(T)
local num_perpage=12
local page=1
local total_num=#T
local maxpage=math.modf(total_num/(num_perpage-2))
if total_num>(num_perpage-2)*maxpage then
maxpage=maxpage+1
end
local t={}
while true do
for i=2,num_perpage-1 do
t[i]=0
end
t[1]=-1
t[num_perpage]=-2
for i=2,num_perpage-1 do
local idx=(num_perpage-2)*(page-1)+(i-1)
if idx<=total_num then
t[i]=T[idx]
end
end
local m={}
m[1]={" G‚B …|G‚C",nil,1}
m[num_perpage]={" M‚M …|G‚C",nil,1}
for i=2,num_perpage-1 do
if t[i]>0 then
local str=t[i]
m[i]={"¡¡ "..str,nil,1}
else
m[i]={"",nil,0}
end
end
local r=ShowMenu(m,num_perpage,0,0,0,0,0,1,1,16,M_White,M_White)
if r==1 then
if page>1 then
page=page-1
end
elseif r==num_perpage then
if page<maxpage then
page=page+1
end
elseif r==0 then
return 0
else
return t[r]
end
end
end

--Ô­S.lua
-- ko 3.1 (2026-09-22): the settings screen's music/SFX rows only stored CC.MusicVolume/CC.SoundVolume; the engine kept
-- playing at config.lua's 50/50 because nothing passed them on (lib.LoadSoundConfig was never called). Config() applies them now.
-- Windows: the exe's LoadSoundConfig ends with BASS_SetVolume, which in the real BASS moves the *Windows master volume*, so it is
-- only called when the proxy bass.dll (bass_real.dll beside it) is in place; the proxy turns it into the BGM stream volume.
-- Android: the engine applies it directly (music volume at once, SFX volume on the next effect).
function koSoundApply()
if CC.koSoundProxy==nil then CC.koSoundProxy=(not CONFIG.Windows) or fileexist(CONFIG.CurrentPath.."bass_real.dll") end
if CC.koSoundProxy then lib.LoadSoundConfig(CC.MusicVolume or 50,CC.SoundVolume or 50) end
end

function Config()
if rawget(_G,"koSoftBoot") then koSoundApply() return end--ko 6.0 (11-01): story switch in the same run: the window is already there (rebuilding it looked like a restart)
lib.LoadConfig(CC.ScreenW,CC.ScreenH)
koSoundApply()
end

function SystemMenu()
PlayWavE(0)
local menu={
{" QR TU",nil,1},
{"¡¡ …d…e[ƒG",nil,1},
{"¡¡ …fƒa",nil,1},
{" ƒGƒM EF",nil,1},
{"¡¡ y{‚M ",nil,0},
}
local koSnd=table.remove(menu)--ko 3.1: registered rows before the hidden íš¨ê³¼ìŒ row
for _,koM in ipairs(koAddon.cityMenu) do menu[#menu+1]={"\161\161 "..koM.label,nil,1} end
menu[#menu+1]=koSnd

DrawYJZBox(32,32,"ƒGƒM",M_White,true)
local r=ShowMenu(menu,5+#koAddon.cityMenu,0,0,0,0,0,3,1,16,M_White,M_White)
lib.Delay(100)
if r==1 then
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
end
elseif r==2 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
{" 6. ",nil,1},
{" 7. ",nil,1},
{" 8. ",nil,1},
{" 9. ",nil,1},
{"10. ",nil,1},
}
for id=1,10 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
for koA=1,3 do--ko 3.1: the three auto saves, newest first
menu2[10+koA]={"A"..koA..". ",nil,1}
if not fileexist(CC.R_GRPFilename[11+koA]) then menu2[10+koA][1]=menu2[10+koA][1].."…i …j…k" else menu2[10+koA][1]=menu2[10+koA][1]..GetRecordInfo(11+koA) end
end
local koBg=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH) local koLd=false--ko 5.0: No / an empty slot goes back to the list (10-07)
while true do
lib.LoadSur(koBg,0,0)
DrawYJZBox2(-1,40,"…d…eƒi ƒG…lS …m…naƒoZ",M_White)--ko 3.0: above the 10/11-row menu
JY.koMenuKeep=true
local s2=ShowMenu(menu2,13,0,0,0,0,0,20,1,16,M_White,M_White)
JY.koMenuKeep=nil
local koAgain=false
if between(s2,1,13) then
if string.sub(menu2[s2][1],5)~="…i …j…k" then
if WarDrawStrBoxYesNo(s2>=11 and "\133\120\130\108 \133\102\131\097 \131\071\133\108\129\083 \133\100\133\101\133\111\129\076\129\077. \131\074\131\075\129\075\129\076\129\089?" or string.format("ƒZƒ~„^ƒP %d‚W ƒG…lS …d…e…oLM. ƒJƒKKLY?",koSlotNo(s2)),M_White,true) then
koLd=true lib.FreeSur(koBg) koBg=nil--ko: free the saved screen BEFORE LoadRecord (its Config remakes the screen; freeing after corrupted drawing)
if koSaveCompat(s2>=11 and s2+1 or s2) then LoadRecord(s2>=11 and s2+1 or s2) end
else koAgain=true end
else
WarDrawStrBoxConfirm("…hGƒh^ ‚aKLM",M_White,true) koAgain=true
end
end
if not koAgain then break end
end
if koBg then lib.LoadSur(koBg,0,0) lib.FreeSur(koBg) end
elseif r==3 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
{" 6. ",nil,1},
{" 7. ",nil,1},
{" 8. ",nil,1},
{" 9. ",nil,1},
{"10. ",nil,1},
}
for id=1,10 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,40,"‚SƒZf …fƒaXYZ?",M_White)--ko 3.0: above the 10/11-row menu
local s2=ShowMenu(menu2,10,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,10) then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚Wf …fƒaWLM. ƒJƒKKLY?",koSlotNo(s2)),M_White,true) then
SaveRecord(s2)
end
end
elseif r==4 then
SettingMenu()--¹¦ÄÜÉè¶¨
elseif r>=5 and r<=4+#koAddon.cityMenu then--ko 3.1: registered rows
koAddon.cityMenu[r-4].run()
elseif r==5+#koAddon.cityMenu then
end
return false
end

function koSlotNo(s) return ((CC.koSlotPage or 1)-1)*10+s end--ko 5.2.6 (saveslots): the record number shown for row s of the current 10-slot page
function GetRecordInfo(id)
local offset=CC.Base_S["ÕÂ½ÚÃû"][1]+100
local len=CC.Base_S["ÕÂ½ÚÃû"][3]+CC.Base_S["Ê±¼ä"][3]
local data=Byte.create(8*len)
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
local SectionName,SaveTime
SectionName=Byte.getstr(data,0,28)
SaveTime=Byte.getstr(data,28,14)
offset=CC.Base_S["Õ½³¡´æµµ"][1]+100
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
if Byte.get16(data,0)==1 then
offset=CC.Base_S["Õ½³¡Ãû³Æ"][1]+100
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
SectionName=Byte.getstr(data,0,28)
offset=100+136
Byte.loadfile(data,CC.R_GRPFilename[id],offset,len)
local turn=Byte.get8(data,8)
local maxturn=Byte.get8(data,9)
SectionName=string.gsub(SectionName,"¡¡ ","¡¡")
do--koRecTurn 5.0: always show the turn; names longer than 25 bytes are cut on a character boundary (10-10)
local koN=SectionName local koI=1 local koC="" while koI<=#koN do local koW=(string.byte(koN,koI)>=128) and 2 or 1 if #koC+koW>25 then break end koC=koC..string.sub(koN,koI,koI+koW-1) koI=koI+koW end SectionName=koC
SectionName=string.format(string.format("%%s%%%ds",25-string.len(SectionName)),SectionName,"")..string.format("d%02dp",turn,maxturn)
end
end
if CC.SrcCharSet==1 then
SectionName=lib.CharSet(SectionName,0)
end
if string.len(SectionName)<31 then
SectionName=string.format(string.format("%%s%%%ds",31-string.len(SectionName)),SectionName,"")
end
return SectionName..SaveTime
end

function SetSceneID(id,BGMID)
JY.SubScene=id
Dark()
if BGMID~=nil then
PlayBGM(BGMID)
end
DrawSMap()
Light()
end

--ko ‚P‹h ‚X‚Y(J‚RGH): ‚CD @A ƒOA a†M „o ƒ[‚OS b…e ‚W †u‚jA ‚A‚O
local koDragonN=0
local function koTrainerOn()
	return JY.Base["ÎŞÓÃ1"]==1
end
local function koPickPerson(msg)
	local pm={}
	local cnt=0
	for i=1,JY.PersonNum-1 do
		if JY.Person[i]["¾ıÖ÷"]==1 then
			pm[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),nil,1}
			cnt=cnt+1
		else
			pm[i]={"",nil,0}
		end
	end
	talk(369,msg)
	local r
	if cnt<=10 then
		r=ShowMenu(pm,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
	else
		r=ShowMenu(pm,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
	end
	if r<=0 then
		return 0
	end
	return r
end
local function koPickList(msg,items)
	talk(369,msg)
	local n=#items
	local r
	if n<=8 then
		r=ShowMenu(items,n,0,0,156,0,0,3,1,16,M_White,M_White)
	else
		r=ShowMenu(items,n,8,0,156,0,0,6,1,16,M_White,M_White)
	end
	if r<=0 then
		return 0
	end
	return r
end
local function koTrainerGold()
	while true do
		local m={
			{fillblank("+1000",11),nil,1},
			{fillblank("+10000",11),nil,1},
			{fillblank("ˆz‚_",11),nil,1},
			{fillblank("0ƒm„S",11),nil,1},
		}
		local r=koPickList("rs ‚Uƒg "..(koGold()).."*vF „NˆFS …m…naƒoZ.",m)
		if r<=0 then
			return
		end
		if r==1 then
			GetMoney(1000)
		elseif r==2 then
			GetMoney(10000)
		elseif r==3 then
			koSetGold(koGoldMax)--ko 3.0
		else
			koSetGold(0)
		end
		PlayWavE(12)
	end
end
local koAttrs={
	{"µÈ¼¶","‚R‚{",1,99},
	{"ÎäÁ¦","Iƒ}",1,0}, --ko 0 = koNG.cap()
	{"ÖÇÁ¦","‚Cƒ}",1,0}, --ko 0 = koNG.cap()
	{"Í³ÂÊ","„w„x",1,0}, --ko 0 = koNG.cap()
	{"Ê¿Æø","‚rƒG",0,100},
}
local function koTrainerAttr()
	local pid=koPickPerson("ƒMƒ}„Q‚h ƒU†N IƒaS …m…naƒoZ.")
	if pid<=0 then
		return
	end
	local p=JY.Person[pid]
	while true do
		local am={}
		for i,v in ipairs(koAttrs) do
			am[i]={fillblank(v[2].." "..p[v[1]],11),nil,1}
		end
		local a=koPickList(p["ĞÕÃû"].."*ƒU†N ‡gƒcS …m…naƒoZ.",am)
		if a<=0 then
			return
		end
		local attr,label,lo,hi=koAttrs[a][1],koAttrs[a][2],koAttrs[a][3],koAttrs[a][4]
		if hi==0 then hi=koNG.cap() end
		if not CC.Person_S[attr][4] then
			PlayWavE(2)
			talk(369,label.."ƒb(‚b) …fƒa„C‚C ‚k‚b EFG‚f ƒU†N q ‚aKLM.")
		else
			local om={
				{fillblank("+1",11),nil,1},
				{fillblank("+5",11),nil,1},
				{fillblank("+10",11),nil,1},
				{fillblank("-1",11),nil,1},
				{fillblank("-10",11),nil,1},
				{fillblank("ˆz‚_",11),nil,1},
			}
			local d={1,5,10,-1,-10,0}
			local o=koPickList(p["ĞÕÃû"].." "..label.." "..p[attr].."*Œv…Xƒv ƒU†NYZ?",om)
			if o>0 then
				local old=p[attr]
				local new
				if o==6 then
					new=hi
				else
					new=limitX(old+d[o],lo,hi)
				end
				p[attr]=new
				if attr=="µÈ¼¶" then
					p["¾­Ñé"]=0
				end
				ReSetAttrib(pid,true)
				if p["±øÁ¦"]>p["×î´ó±øÁ¦"] then
					p["±øÁ¦"]=p["×î´ó±øÁ¦"]
				end
				if p["²ßÂÔ"]>p["×î´ó²ßÂÔ"] then
					p["²ßÂÔ"]=p["×î´ó²ßÂÔ"]
				end
				PlayWavE(12)
				talk(369,p["ĞÕÃû"].."ƒP "..label.." "..old.." ¡ú "..new)
			end
		end
	end
end
local function koTrainerSkill()
	local pid=koPickPerson("xƒG‚h ƒU†N IƒaS …m…naƒoZ.")
	if pid<=0 then
		return
	end
	local p=JY.Person[pid]
	local sm={{fillblank("(‚a‚M)",11),nil,1}}
	local sid={0}
	for i=1,JY.SkillNum-1 do
		local nm=JY.Skill[i]["Ãû³Æ"]
		if nm~="" and nm~="ƒs]" then
			sm[#sm+1]={fillblank(nm,11),nil,1}
			sid[#sid+1]=i
		end
	end
	while true do
		local slots={}
		slots[1]={fillblank("‚s‚^:"..JY.Skill[p["Ìì¸³"]]["Ãû³Æ"],12),nil,1}
		for i=1,6 do
			slots[i+1]={fillblank("xƒG"..i..":"..JY.Skill[p["ÌØ¼¼"..i]]["Ãû³Æ"],12),nil,1}
		end
		local s=koPickList(p["ĞÕÃû"].."*ƒU†N ‡BS …m…naƒoZ.",slots)
		if s<=0 then
			return
		end
		local key
		if s==1 then
			key="Ìì¸³"
		else
			key="ÌØ¼¼"..(s-1)
		end
		local k=koPickList("†D xƒG‚h …m…naƒoZ.",sm)
		if k>0 then
			p[key]=sid[k]
			ReSetAttrib(pid,true)
			PlayWavE(12)
		end
	end
end
local function koTrainerItem()
	local pid=koPickPerson("D‚w‚h ‚C†PX IƒaS …m…naƒoZ.")
	if pid<=0 then
		return
	end
	local p=JY.Person[pid]
	local im={{fillblank("(‚PƒOƒG)",11),nil,1}}
	local iid={0}
	for i=1,math.min(JY.ItemNum-1,180) do--ko koTrainerItem: 181~195 are unused old copies (no bonus, no skill), hidden like the battle item menu
		local nm=JY.Item[i]["Ãû³Æ"]
		if koPromotionItemId(i)==i and nm~="" and nm~="ƒs]" then
			im[#im+1]={fillblank(nm,13),nil,1}
			iid[#iid+1]=i
		end
	end
	while true do
		local slots={}
		for n=1,8 do
			local it=p["µÀ¾ß"..n]
			if it>0 then
				slots[n]={fillblank(n..":"..JY.Item[it]["Ãû³Æ"],13),nil,1}
			else
				slots[n]={fillblank(n..":(…i ‡B)",12),nil,1}
			end
		end
		local s=koPickList(p["ĞÕÃû"].."*D‚w ‡BS …m…naƒoZ.",slots)
		if s<=0 then
			return
		end
		local k=koPickList("‚C†PX D‚w‚h …m…naƒoZ.",im)
		if k>0 then
			p["µÀ¾ß"..s]=iid[k]
			ReSetAttrib(pid,true)
			PlayWavE(11)
		end
	end
end
local function koTrainerBZ()
	local pid=koPickPerson("‚~TS ƒU†N IƒaS …m…naƒoZ.")
	if pid<=0 then
		return
	end
	local p=JY.Person[pid]
	if koFixedBZ(pid) then
		talk(369,p["ĞÕÃû"].."ƒb(‚b) ‚B„o ‚~TG‚f ƒU†N q ‚aKLM.")
		return
	end
	local bm={}
	local bid={}
	for i=1,JY.BingzhongNum-1 do
		local nm=JY.Bingzhong[i]["Ãû³Æ"]
		if nm~="" and JY.Bingzhong[i]["ÓĞĞ§"]>0 and koBZAllowed(i,pid) then --ko exclusive classes: wooden puppet / Xiang Yu / Liu Bang only
			bm[#bm+1]={fillblank(nm,11),nil,1}
			bid[#bid+1]=i
		end
	end
	local k=koPickList(p["ĞÕÃû"].." rs ‚~T: "..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"].."*†D ‚~TS …m…naƒoZ.",bm)
	if k>0 then
		ModifyBZ(pid,bid[k])
		ReSetAttrib(pid,true)
		if p["±øÁ¦"]>p["×î´ó±øÁ¦"] then
			p["±øÁ¦"]=p["×î´ó±øÁ¦"]
		end
		if p["²ßÂÔ"]>p["×î´ó²ßÂÔ"] then
			p["²ßÂÔ"]=p["×î´ó²ßÂÔ"]
		end
		PlayWavE(12)
		talk(369,p["ĞÕÃû"].."ƒP ‚~TG "..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"].."(ƒm)„S ‚tƒ@„C„kKLM.")
	end
end
local function koTrainerHeal()
	local cnt=0
	for i=1,JY.PersonNum-1 do
		local p=JY.Person[i]
		if p["¾ıÖ÷"]==1 then
			p["±øÁ¦"]=p["×î´ó±øÁ¦"]
			p["²ßÂÔ"]=p["×î´ó²ßÂÔ"]
			cnt=cnt+1
		end
	end
	PlayWavE(12)
	talk(369,"n‚T "..cnt.."‚XƒP ‚~ƒ}{ ‚u‚vS ‚Z‚[ ‚}‚DPKLM.")
end
local function koTrainer()
	while true do
		DrawSMap()
		local menu={
			{"‚Uƒg vF",nil,1},
			{"ƒMƒ}„Q vF",nil,1},
			{"xƒG EF",nil,1},
			{"D‚w ‚C†P",nil,1},
			{"‚~T ‚tƒ@",nil,1},
			{"‚B‚T ‚}‚D",nil,1},
			{"‚X‚Y …~ƒGƒG",nil,1},
		}
		DrawYJZBox(32,32,"‚P‹h ‚X‚Y",M_White,true)
		local r=ShowMenu(menu,#menu,0,546,244,0,0,4,1,16,M_White,M_White)
		if r<=0 then
			return
		elseif r==1 then
			koTrainerGold()
		elseif r==2 then
			koTrainerAttr()
		elseif r==3 then
			koTrainerSkill()
		elseif r==4 then
			koTrainerItem()
		elseif r==5 then
			koTrainerBZ()
		elseif r==6 then
			koTrainerHeal()
		elseif r==7 then
			if WarDrawStrBoxYesNo("‚P‹h ‚X‚YS M‚V …~†rYZ?*„o ƒ[‚OS M‚V †u‚jA ‚A q „OKLM.",M_White,true) then
				JY.Base["ÎŞÓÃ1"]=0
				return
			end
		end
	end
end
local koDragonMsg,koDragonMsgT
local function koDragonSay(s)
	koDragonMsg=s
	koDragonMsgT=lib.GetTime()+2500
	PlayWavE(11)
end
local koDragonBusy=false
local function koDragonDrain()
	local t=lib.GetTime()
	while lib.GetTime()-t<500 do
		local m=lib.GetMouse()
		if m-math.floor(m/2)*2==0 then break end
		lib.GetKey()
		lib.Delay(8)
	end
	lib.GetKey()
	MOUSE.status='IDLE'
	MOUSE.koMask=lib.GetMouse()
	MOUSE.koSwallow=nil MOUSE.koSwallowR=nil MOUSE.koRel=nil MOUSE.koSynR=nil
end
local function koDragonClick()
	if koTrainerOn() then
		PlayWavE(0)
		koTrainer()
		return
	end
	local need=CC.koDragonClicks or 10
	koDragonN=koDragonN+1
	if koDragonN>=need then
		if koDragonBusy then return end
		koDragonBusy=true
		koDragonN=0
		PlayWavE(11)
		koDragonDrain()
		if WarDrawStrBoxYesNo("„oG „IS „JKLM.*Iƒa †gf '‚P‹h ‚X‚Y'G …c^ŒjLM.*QR ˆRˆEG Z‹T q „OKLM. ƒJƒKKLY?",M_White,true) then
			JY.Base["ÎŞÓÃ1"]=1
			PlayWavE(12)
			talk(369,"‚P‹h ‚X‚YG ‚A„~KLM.*Iƒa †gGƒv „o ƒ[‚OS S…e ƒR‚S‡y q „OKLM.*…fƒaaA ƒ[‚_„S ‚G‚CŒjLM.")
		end
		koDragonBusy=false
	elseif koDragonN==math.floor(need/5) then
		koDragonSay("„oG ‹dŒG†E„~M.")
	elseif koDragonN==math.floor(need/2) then
		koDragonSay("„oƒP „IŒM‹EG „nƒjM.")
	elseif koDragonN==math.floor(need*4/5) then
		koDragonSay("„oƒP …~mu^ †E†R‚SgM.")
	else
		PlayWavE(0)
	end
end
--ko ‚P‹h ‚X‚Y ‹[
function SMapEvent()
JY.ReFreshTime=lib.GetTime()
DrawSMap()
JY.Tid=0
local eventtype,keypress,x,y=getkey()
if MOUSE.HOLD(673,321,710,366) then
lib.PicLoadCache(4,220*2,673,321,1)
elseif MOUSE.HOLD(713,321,750,366) then
lib.PicLoadCache(4,221*2,713,321,1)
elseif MOUSE.HOLD(673,369,710,414) then
lib.PicLoadCache(4,222*2,673,369,1)
elseif MOUSE.HOLD(713,369,750,414) then
lib.PicLoadCache(4,223*2,713,369,1)
end
if MOUSE.CLICK(673,321,710,366) then
PlayWavE(0)
if CC.Enhancement==false then
WarDrawStrBoxConfirm("‚Cƒgƒb …}„oX IƒaG ‚aKLM.",M_White,true)
else
if not (rawget(_G,"koTavernButton") and koTavernButton()) then HirePerson() end--ko 5.0: town taverns
end
elseif MOUSE.CLICK(713,321,750,366) then
PlayWavE(0)
Person_Menu()
elseif MOUSE.CLICK(673,369,710,414) then
Shop()
elseif MOUSE.CLICK(713,369,750,414) then
SystemMenu()
elseif MOUSE.CLICK(704,420,766,478) then
koDragonClick()
elseif MOUSE.CLICK(680,24,742,102) then
JY.LLK_N=JY.LLK_N+1
if JY.LLK_N>49 then
PlayWavE(0)
if WarDrawStrBoxYesNo("\130\114\130\115\131\123\129\083 \129\097\130\086\134\121\129\075\129\076\129\089?",M_White,true) then--ko 5.0: ì‚¬ì²œì„±ì„ í•˜ì‹œê² ìŠµë‹ˆê¹Œ? (was the hidden-command warning)
Game_Cycle()--ko 5.0: the lianliankan run in both modes (the non-Enhancement 9999 gold + level 99 cheat is gone)
else
JY.LLK_N=50
end
end
end
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
end
end
if MOUSE.IN(16,16,16+640,16+400) then
for i,v in pairs(JY.Smap) do
local px,py=27+18*v[2],19+18*v[3]-32
--if math.abs(x-px)<20 and math.abs(y-py)<28 then
if MOUSE.CLICK(px-20,py-28,px+20,py+28) then
JY.Tid=v[1]
 DoEvent(JY.EventID)
if JY.Tid==-1 then
JY.Tid=0
return
end
JY.Tid=0
break
elseif MOUSE.IN(px-20,py-28,px+20,py+28) then
JY.Tid=v[1]
end
end
end
if eventtype==3 and keypress==3 then
SystemMenu()
end
if JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
ReFresh()
end
end

function DrawSMap()
lib.FillColor(0,0,0,0,0)
if JY.SubScene>=0 then
lib.PicLoadCache(5,JY.SubScene*2,16,16,1)--21,21
local len=18
local dx,dy=27,19
if CC.Debug==1 then
for i=1,20 do
lib.Background(0,dy+len*i,CC.ScreenW,dy+len*i+1,128,M_White)
DrawString(42,dy+len*i,i,M_White,16)
DrawString(dx+len*i*2,24,i*2+1,M_White,16)
lib.Background(dx+len*i*2,0,dx+len*i*2+1,CC.ScreenH,128,M_White)
end
end
for i,v in pairs(JY.Smap) do
local x,y=dx+len*v[2]-24,dy+len*v[3]-64
lib.SetClip(x,y,x+48,y+64)
if v[5]==0 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["ĞÎÏó"]*4+v[4])*2,x,y-0*64,1)
elseif v[5]==1 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["ĞÎÏó"]*4+v[4])*2,x,y-1*64,1)
elseif v[5]==2 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["ĞÎÏó"]*4+v[4])*2,x,y-0*64,1)
elseif v[5]==3 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["ĞÎÏó"]*4+v[4])*2,x,y-2*64,1)
elseif v[5]==4 then
lib.PicLoadCache(5,(200+JY.Person[v[1]]["ĞÎÏó"]*4+v[4])*2,x,y-0*64,1)
end
if v[5]>=1 then
v[5]=v[5]+1
if v[5]==5 then
v[5]=1
end
end
lib.SetClip(0,0,0,0)
end
for i,v in pairs(JY.Smap) do
if v[5]==0 then
if JY.Tid==v[1] then
local x,y=dx+len*v[2]-24,dy+len*v[3]-64
if v[4]==1 or v[4]==2 then
lib.PicLoadCache(4,232*2,x-8,y-8,1)
else
lib.PicLoadCache(4,231*2,x+32,y-8,1)
end
end
end
end
end
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
end

local function koLabel(x,y,str,color,size)
lib.DrawStr(x,y,str,color,size,CC.FontName,CC.SrcCharSet,CC.OSCharSet)
end
function DrawGameStatus()
local koMe=((rawget(_G,"koViewSide") and koViewSide() and koViewBro()>0) and koViewBro() or 1)--ko 5.0 (view): the brother of a side act
if koMe~=1 or string.find(CC.koGenEdit or "",",f"..JY.Person[koMe]["Í·Ïñ´úºÅ"]..",",1,true) then lib.PicLoadCache(2,JY.Person[koMe]["Í·Ïñ´úºÅ"]*2,680,24,1) end
koLabel(680,142,"ƒg",M_Navy,16)
koLabel(680,182,"‚R‚{",M_Navy,16)
koLabel(680,222,"Iƒa",M_Navy,16)
koLabel(680,262,"rs‚n„Q",M_Navy,16)
DrawString(740-#(""..(koGold()))*16/2, 160,(koGold()),M_White,16)
DrawString(740-#(""..JY.Person[koMe]["µÈ¼¶"])*16/2,200,JY.Person[koMe]["µÈ¼¶"],M_White,16)
DrawString(740-#(""..JY.Base["Îä½«ÊıÁ¿"])*16/2, 240,JY.Base["Îä½«ÊıÁ¿"],M_White,16)
DrawString(740-#JY.Base["ÏÖÔÚµØ"]*16/2, 280,JY.Base["ÏÖÔÚµØ"],M_White,16)
-- Extend the panel without copying any part of the title lettering.
-- Fill uses an even offset so the original two-pixel texture stays aligned.
lib.SetClip(480,424,531,472)
lib.PicLoadCache(4,201*2,36,0,1)
-- Only the actual box edge (source x494..504) moves; the logo stays in the base frame.
lib.SetClip(531,424,541,472)
lib.PicLoadCache(4,201*2,37,0,1)
lib.SetClip(0,0,0,0)
local str_mode=koNG.modestr()
local str_x=318-string.len(str_mode)*16/2
lib.SetClip(18+6,434,str_x-8,458)
DrawString(18+6,434+6,JY.Base["ÕÂ½ÚÃû"],M_White,16)
lib.SetClip(str_x,434,318,458)
DrawString(str_x,434+6,str_mode,M_White,16)
local str_cyc=koNG.cyclestr()
local cyc_x=531
if string.len(str_cyc)>0 and not (koDragonMsg and lib.GetTime()<koDragonMsgT) then
cyc_x=523-string.len(str_cyc)*16/2
lib.SetClip(cyc_x,434,523,458)
DrawString(cyc_x,434+6,str_cyc,M_White,16)
end
lib.SetClip(330+6,434,cyc_x-8,458)
if koDragonMsg and lib.GetTime()<koDragonMsgT then
DrawString(330+6,434+6,koDragonMsg,M_White,16)
elseif JY.Tid>0 then
DrawString(330+6,434+6,(rawget(_G,"koTidNick") and koTidNick(JY.Tid)) or JY.Person[JY.Tid]["ĞÕÃû"],M_White,16)--koTidNick 5.0 (10-10)
end
lib.SetClip()
end

function MovePerson(...)
local arg={}
for i,v in pairs({...}) do
arg[i]=v
end
local n=math.modf(#arg/3)
for i=0,n-1 do
local id=arg[i*3+1]
for ii,v in pairs(JY.Smap) do
if v[1]==id then
arg[i*3+1]=ii
v[5]=1
end
end
end
while true do
local flag=true
for i=0,n-1 do
local id=arg[i*3+1]
local d=arg[i*3+3]
JY.Smap[id][4]=d
if arg[i*3+2]>0 then
flag=false
JY.Smap[id][2]=JY.Smap[id][2]+CC.DX[d]*0.2
JY.Smap[id][3]=JY.Smap[id][3]+CC.DY[d]*0.2
arg[i*3+2]=arg[i*3+2]-0.2
else
JY.Smap[id][5]=0
end
end
JY.ReFreshTime=lib.GetTime()
DrawSMap()
lib.GetKey()
ReFresh(1.25)
if flag then
break
end
end
for i,v in pairs(JY.Smap) do
 v[5]=0
end
DrawSMap()
lib.GetKey()
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
lib.Delay(50)
SortPerson()
end

function SortPerson()
local n=#JY.Smap
for i=1,n-1 do
for j=i+1,n do
if JY.Smap[i][3]>JY.Smap[j][3] then
JY.Smap[i],JY.Smap[j]=JY.Smap[j],JY.Smap[i]
end
end
end
end

function DoEvent(id)
if type(Event[id])=='function' then
Event[id]()
else
lib.Debug("Error!! eid="..id.."¡¡type="..type(Event[id]))
if id==9800 then WarDrawStrBoxConfirm("\133\120\130\071 \130\066\132\101 \130\101 \133\102\131\097\129\111 \131\071\133\108\129\104\129\076\129\077. \133\120\130\071 \130\066\132\101 \131\071\131\077\129\071 \140\077\136\107 \132\079\129\075\129\076\129\077.*\129\105\131\097\129\102\131\087 \133\120\130\071 \130\066\132\101\130\104 \137\097\131\100 \129\077\130\086 \129\078\130\093\129\066 \130\075\131\111\129\090",M_White,true) end--ko 3.1: ììœ  ì „íˆ¬ ì¤‘ ì €ì¥í•œ ê¸°ë¡ì…ë‹ˆë‹¤. ììœ  ì „íˆ¬ ê¸°ëŠ¥ì´ êº¼ì ¸ ìˆìŠµë‹ˆë‹¤. í™•ì¥ì—ì„œ ììœ  ì „íˆ¬ë¥¼ ì¼œê³  ë‹¤ì‹œ ì‹¤í–‰í•´ ì£¼ì„¸ìš”
JY.Status=GAME_START
end
if id>9999 then
koExit()
end
if id~=JY.EventID then
return true
else
return false
end
end

function NextEvent(id)
if id==nil then
JY.EventID=JY.EventID+1
else
JY.EventID=id
end
end

function PicCatchIni()
koTitleAnimReady=false koTitleStillReady=false
lib.PicLoadFile(CC.MMAPPicFile[1],CC.MMAPPicFile[2],0)
lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1)
lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2)
--3²»ÄÜÊ¹ÓÃ
lib.PicLoadFile(CC.UIPicFile[1],CC.UIPicFile[2],4)
lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5)
lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200)
end

function Password()
local f=0
local T3={"a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"}
local str=""
if filelength( CONFIG.PicturePath..
CC.PASCODE[29]..CC.PASCODE[8]..CC.PASCODE[5]..CC.PASCODE[14]..CC.PASCODE[50]..CC.PASCODE[53]..
CC.PASCODE[4]..CC.PASCODE[5]..CC.PASCODE[2]..CC.PASCODE[21]..CC.PASCODE[7])==13 then--".\\ChenX.debug")==13 then
CC.Debug=0
return
end
while true do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(4,83*2,0,0,1)
if f==0 then
lib.FillColor(40,14,49,16)
end
f=1-f
ReFresh()
local key=lib.GetMouse()
if key==1 or key==3 then
break
end
end
Dark()
end

function ScreenTest()
while true do
local e,k,x,y=lib.GetMouse(1)
lib.FillColor(0,0,0,0,M_White)
if e==2 or e==3 then
lib.DrawRect(x-64,y,x+64,y,0)
lib.DrawRect(x,y-64,x,y+64,0)
end
DrawString(64,64,x..','..y,M_Orange,24)
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
lib.Delay(25)
end
end

function YJZMain()
local saveflag=false--Õ½ºóÌáÊ¾±£´æ±ê¼Ç
JY.Status=GAME_START--ÓÎÏ·µ±Ç°×´Ì¬
PicCatchIni()
--Password() --ko: startup notice screen removed (was skipped by pic/ChenX.debug key file)
LoadRecord(0)
do local koSB=rawget(_G,"koSoftBoot") if koSB then JY.CurrentBGM=koSB.bgm or -1 rawset(_G,"koSoftBoot",nil) end end--ko 6.0 (11-01): story switch: the title music plays on
for i=1,JY.PersonNum-1 do
GetPic(i)
end
while true do
if JY.Status==GAME_START then
if JY.CurrentBGM~=CC.koTitleBGM then PlayBGM(CC.koTitleBGM) end--ko 3.1: title BGM (was StopBGM)
YJZMain_sub()
if JY.Status~=GAME_START and (JY.CurrentBGM==CC.koTitleBGM or JY.CurrentBGM<0) then StopBGM() end--ko 3.1: leaving the title: unless the game or save started its own tune, silence as before
elseif JY.Status==GAME_SMAP_AUTO then
if saveflag then
Dark()
saveflag=false
lib.FillColor(0,0,0,0,0)
if rawget(_G,"koNoWarSave") then DrawSMap() Light() elseif not CC.koReplay then RemindSave(2) end rawset(_G,"koNoWarSave",nil)--ko 5.0: no post-battle prompt after loading a non-battle save in battle--ko: no save prompt after a replay-mode battle
end
DoEvent(JY.EventID)
elseif JY.Status==GAME_SMAP_MANUAL then
SMapEvent()
elseif JY.Status==GAME_MMAP then
elseif JY.Status==GAME_WMAP then
Dark()
saveflag=true
koWarRes(true)--ko 3.0
WarStart()
koWarRes(false)
elseif JY.Status==GAME_WMAP2 then--Á¬ĞøÕ½¶·
JY.Status=GAME_WMAP
DoEvent(JY.EventID)
elseif JY.Status==GAME_WARWIN then
JY.Status=GAME_SMAP_AUTO
elseif JY.Status==GAME_WARLOSE then
JY.Status=GAME_START
elseif JY.Status==GAME_DEAD then
elseif JY.Status==GAME_END then
Dark()
lib.Delay(1000)
koExit()
end
end
end

--ko 3.6 later: the title menu in the look of the new title picture (ui.grp 264 = ê°œë°œìš©/íƒ€ì´í‹€ ë¡œê³ /title_bg.png): two columns of
--  dark buttons with a gold edge in the band y 222..376, the chosen one filled gold. Mouse (hover picks, click takes),
--  arrows move, Enter/Space take. Rows with [3]==0 are left out; returns the menu row number as ShowMenu did.
--  A test that swaps ShowMenu out (the zz_ harness) keeps getting its title menu through ShowMenu.
-- ko 5.0: approved blossom GIF, 240 frames at 100 ms (24-second loop).
-- Slot 14 is dedicated to title animation; menu exits release its cached surfaces.
koTitleAnimReady=false
koTitleStillReady=false--ko 6.0 campaigns: slot 14 holds the idle logo (koTitleStill)
local koTitleAnimStart=0
local koTitleAnimN=240--ko 6.0 campaigns (11-01): frames in the loaded title animation (idx size / 4, 100 ms each)
function koTitleAnimDraw()
if not koTitleAnimReady then
local idx,grp=(CONFIG.koCampData or CONFIG.DataPath).."title_petals.idx",(CONFIG.koCampData or CONFIG.DataPath).."title_petals.grp"--ko 6.0 campaigns: each story its own logo
local fi=io.open(idx,"rb")
local fg=io.open(grp,"rb")
local available=fi and fg
if fi then koTitleAnimN=math.max(1,math.floor((fi:seek("end") or 960)/4)) fi:close() end
if fg then fg:close() end
if not available then lib.PicLoadCache(4,264*2,0,0,1) return end
lib.PicLoadFile(idx,grp,14)
koTitleAnimStart=lib.GetTime()
koTitleAnimReady=true
end
local elapsed=lib.GetTime()-koTitleAnimStart
if elapsed<0 then koTitleAnimStart=lib.GetTime() elapsed=0 end
local frame=math.floor((elapsed%(koTitleAnimN*100))/100)
lib.PicLoadCache(14,frame*2,0,0,1)
end
function koTitleStill()--ko 6.0 campaigns (11-01): first frame of the current story's title logo (slot 14), drawn before the animation runs
if not koTitleAnimReady and not koTitleStillReady then
local dir=CONFIG.koCampData or CONFIG.DataPath
local f=io.open(dir.."title_petals_idle.grp","rb")
if not f then lib.PicLoadCache(4,264*2,0,0,1) return end
f:close()
lib.PicLoadFile(dir.."title_petals_idle.idx",dir.."title_petals_idle.grp",14)
koTitleStillReady=true
end
lib.PicLoadCache(14,0,0,0,1)
end
function koTitleAnimRelease()
if koTitleAnimReady then
lib.PicLoadFile((CONFIG.koCampData or CONFIG.DataPath).."title_petals_idle.idx",(CONFIG.koCampData or CONFIG.DataPath).."title_petals_idle.grp",14)
koTitleAnimReady=false
end
end
local koRealShowMenu=ShowMenu
function koTitleMenu(menu,n,...)
if ShowMenu~=koRealShowMenu and ShowMenu~=rawget(_G,"koSlotShowMenu") then return ShowMenu(menu,n,...) end--ko 5.2.8 (10-26): the saveslots wrapper counts as the real one
local items={}
for i=1,n do
local m=menu[i]
if m and m[3]~=0 then
local s=m[1] or ""
while string.sub(s,1,2)=="\161\161" do s=string.sub(s,3) end
s=string.gsub(s,"^%s+","")
items[#items+1]={i,s}
end
end
--koTitleMenu3 (5.0): the game's own pieces (frame 60, bars 61 / 62) in one column under the logo;
--the extra modes (ë¬´ìˆ  ëŒ€íšŒ Â· registered rows Â· ì¤„ê±°ë¦¬ ë³´ê¸°) sit behind ã€Œë‹¤ë¥¸ ëª¨ë“œã€, with ã€ŒëŒì•„ê°€ê¸°ã€ (or ESC) back
local main,sub,grp={},{},{}
local koGrps,koGOrd={},{}--ko 6.0 (10-29): several title groups (genedit/newgen, the two books): one first-list row per group label
for k,it in ipairs(items) do
local koR=koAddon.titleMenu[it[1]-5]--ko 5.0 (10-13): addon rows with a group (newgen, genedit) share one first-list row that opens them
if koR and koR.group then local koG=koGrps[koR.group] if not koG then koG={} koGrps[koR.group]=koG koGOrd[#koGOrd+1]=koR.group main[#main+1]={-100-#koGOrd,koR.group} end koG[#koG+1]=it
elseif it[1]<=3 or k==#items or (koR and koR.main) then main[#main+1]=it else sub[#sub+1]=it end
end
if #sub>0 then table.insert(main,3,{-1,"\129\077\135\077 \130\090\133\119"}) sub[#sub+1]={-2,"\137\066\129\110\129\094\131\071"} end
for _,koG in pairs(koGrps) do koG[#koG+1]={-2,"\137\066\129\110\129\094\131\071"} end
if rawget(_G,"koTitlePlus") then table.insert(main,2,{-3,"\134\068 \129\081\129\082+"}) end--ko 5.0 (koNGPlus): only after a ì¢…íš¡ clear
local backRow=1--ko 5.0 (10-13): the first-list row a sub list was opened from
local list=main
local BW=180
local FW=14+BW
local x0=math.floor((768-FW)/2)
local FH,y0
local function layout() FH=16+24*#list y0=math.min(220,400-FH) end--ko 5.0 (10-13): 7 rows clear the logo
layout()
local function rect(k)
local bx,by=x0+6,y0+8+24*(k-1)
return bx,by,bx+BW,by+22
end
local sel=1
local koKbd,koMX,koMY=false,MOUSE.x,MOUSE.y--ko 5.0: the cursor shows only after an arrow key (until the mouse moves)
koMouseReset()
local function pick(k)
PlayWavE(0)
local v=list[k][1]
if v==-1 or v<=-100 then backRow=k list=(v==-1 and sub or koGrps[koGOrd[-100-v]]) sel=1 layout() koMouseReset() return nil end
if v==-2 then list=main sel=backRow layout() koMouseReset() return nil end
return v
end
while true do
JY.ReFreshTime=lib.GetTime()
if MOUSE.x~=koMX or MOUSE.y~=koMY then koKbd=false koMX,koMY=MOUSE.x,MOUSE.y end
koTitleAnimDraw()
for k,it in ipairs(list) do
local a,b,c,d=rect(k)
if not koKbd and MOUSE.IN(a,b,c,d) then sel=k end--ko 5.0: not over an arrow-key choice
end
koFrame(60*2,142,110,x0,y0,FW,FH)
for k,it in ipairs(list) do
local a,b,c,d=rect(k)
local on=(koKbd and k==sel) or MOUSE.HOLD(a,b,c,d)--ko 5.0: pressed look only while pressed
koBarW(on and 62*2 or 61*2,130,a,BW,b)
DrawString(a+math.floor((BW-#it[2]*8)/2),b+3+(on and 1 or 0),it[2],M_White,16)
end
ShowScreen()
local e,key=koPollKey()
if e==0 or MOUSE.EXIT() then koTitleAnimRelease() koExit() end
local r
if e==1 then
if key>=1073741903 and key<=1073741906 then koKbd=true end
if key==13 or key==32 then r=pick(sel) if r then koTitleAnimRelease() return r end
elseif key==27 and list~=main then PlayWavE(0) list=main sel=backRow layout()
elseif key==1073741906 or key==1073741904 then if sel>1 then sel=sel-1 PlayWavE(0) end
elseif key==1073741905 or key==1073741903 then if sel<#list then sel=sel+1 PlayWavE(0) end
end
end
for k,it in ipairs(list) do
local a,b,c,d=rect(k)
if MOUSE.CLICK(a,b,c,d) then r=pick(k) if r then koTitleAnimRelease() return r end break end
end
end
end
function YJZMain_sub()
CC.koReplay=nil
koHook("title")--ko 3.1
-- ko 2.0: black title screen fix. Coming back to the title after Dark() (battle lost, duel mode, replay end),
-- ShowMenu drew the title art and menu while the screen was still faded out and the fade-in inside its first
-- ReFresh left the surface black (or tinted). At startup LoadRecord(0)->Config() recreated the window in between,
-- which hid the problem. Draw the title art and fade in first, then let ShowMenu redraw it normally.
if JY.Dark then
koTitleStill()--ko 6.0 campaigns (11-01): the current story's logo, not the old title picture
Light()
end
local menu={
{"¡¡ †D QR",nil,1},
{"¡¡¡¡…fƒa …d…e[ƒG",nil,1},
{"¡¡¡¡ƒGƒM EF",nil,1},
{"¡¡¡¡‚Bƒa sr",nil,1},
{"¡¡¡¡IƒH ‚_‚}",nil,1},
{"¡¡„{†Eu ƒsƒG",nil,1},
{"¡¡¡¡QR TU",nil,1},
}
menu[4][3]=0--ko 3.1: ì „ì¥ ì¬í˜„ removed, ììœ  ì „íˆ¬ replaces it
menu[5][3]=1--ko 2.0: ì¼ê¸°í†  ë³µì›ìœ¼ë¡œ ë¬´ìˆ  ëŒ€íšŒ ë©”ë‰´ ë‹¤ì‹œ í‘œì‹œ
if rawget(_G,"koMainSettings") then menu[3][3]=0 end--ko 6.0 (11-03): the settings row lives on the main screen (campsel)
local koTail={table.remove(menu),table.remove(menu)}
koTail[2][3]=0--ko 6.0 (11-03): the story replay row removed--ko 3.1: registered rows before ì¤„ê±°ë¦¬ ë³´ê¸° / ê²Œì„ ì¢…ë£Œ
for _,koM in ipairs(koAddon.titleMenu) do menu[#menu+1]={"\161\161\161\161"..koM.label,nil,1} end
menu[#menu+1]=koTail[2] menu[#menu+1]=koTail[1]
lib.FillColor(0,0,0,0)
lib.Delay(200)
local koPlusId,koPlusN=koNG.plusSource() rawset(_G,"koTitlePlus",koPlusId~=nil)--ko 5.0 (koNGPlus)
local s=koTitleMenu(menu,7+#koAddon.titleMenu,0,0,0,0,0,2,0,16,M_White,M_White)--ko 3.6 later: the new title look (was ShowMenu)
if s==-3 then koNG.plus(koPlusId,koPlusN) return end--ko 5.0 (koNGPlus)
if s==1 then
LoadRecord(0)
JY.Base["ÕÂ½ÚÃû"]=""
local menux={
{"¡¡¡¡†F†G‚y ‚Z…w",nil,1},
{"¡¡¡¡T†H ‚Z…w",nil,1},
}
local ss=2--ko 5.0: no classic mode (10-07) - a new game is always the enhanced (jonghoeng) mode
if ss==1 then
JY.Base["ÓÎÏ·Ä£Ê½"]=0
if not SaveRecord(11) then return end
LoadRecord(11)-- ¶ÁÈ¡ÓÎÏ·½ø¶È
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
elseif ss==2 then
JY.Base["ÓÎÏ·Ä£Ê½"]=1
if not SaveRecord(11) then return end
LoadRecord(11)-- ¶ÁÈ¡ÓÎÏ·½ø¶È
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
JY.Person[1]["µÈ¼¶"]=3
JY.Person[2]["µÈ¼¶"]=3
JY.Person[3]["µÈ¼¶"]=3
end
for i=1,JY.PersonNum-1 do
GetPic(i)
end
JY.Status=GAME_SMAP_AUTO--ÓÎÏ·µ±Ç°×´Ì¬
JY.EventID=1
elseif s==2 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
{" 6. ",nil,1},
{" 7. ",nil,1},
{" 8. ",nil,1},
{" 9. ",nil,1},
{"10. ",nil,1},
}
for id=1,10 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
for koA=1,3 do--ko 3.1: the three auto saves, newest first
menu2[10+koA]={"A"..koA..". ",nil,1}
if not fileexist(CC.R_GRPFilename[11+koA]) then menu2[10+koA][1]=menu2[10+koA][1].."…i …j…k" else menu2[10+koA][1]=menu2[10+koA][1]..GetRecordInfo(11+koA) end
end
local koBg=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH) local koLd=false--ko 5.0: No / an empty slot goes back to the list (10-07)
while true do
lib.LoadSur(koBg,0,0)
DrawYJZBox2(-1,40,"…d…eƒi ƒG…lS …m…naƒoZ",M_White)--ko 3.0: above the 10/11-row menu
JY.koMenuKeep=true
local s2=ShowMenu(menu2,13,0,0,0,0,0,20,1,16,M_White,M_White)
JY.koMenuKeep=nil
local koAgain=false
if between(s2,1,13) then
if string.sub(menu2[s2][1],5)~="…i …j…k" then
if WarDrawStrBoxYesNo(s2>=11 and "\133\120\130\108 \133\102\131\097 \131\071\133\108\129\083 \133\100\133\101\133\111\129\076\129\077. \131\074\131\075\129\075\129\076\129\089?" or string.format("ƒZƒ~„^ƒP %d‚W ƒG…lS …d…e…oLM. ƒJƒKKLY?",koSlotNo(s2)),M_White,true) then
koLd=true lib.FreeSur(koBg) koBg=nil--ko: free the saved screen BEFORE LoadRecord (its Config remakes the screen; freeing after corrupted drawing)
if koSaveCompat(s2>=11 and s2+1 or s2) then LoadRecord(s2>=11 and s2+1 or s2) end
else koAgain=true end
else
WarDrawStrBoxConfirm("…hGƒh^ ‚aKLM",M_White,true) koAgain=true
end
end
if not koAgain then break end
end
if koBg then lib.LoadSur(koBg,0,0) lib.FreeSur(koBg) end
elseif s==3 then
SettingMenu()--¹¦ÄÜÉè¶¨
elseif s==4 then
LoadRecord(0)
for i=1,JY.PersonNum-1 do
GetPic(i)
end
JY.Status=GAME_SMAP_AUTO--ÓÎÏ·µ±Ç°×´Ì¬

--µ÷ÊÔ
JY.Base["ÓÎÏ·Ä£Ê½"]=1
CC.Enhancement=true
JY.EventID=700
CC.koReplay=true--ko: title "replay" mode, skip save prompts
JY.Base["ÕÂ½ÚÃû"]="…~„}g e…Z mO ‚B„e"--ko: replay-mode chapter label
JY.Base["ÊÂ¼ş333"]=30
JY.Person[1]["µÈ¼¶"]=99
JY.Person[2]["µÈ¼¶"]=99
JY.Person[3]["µÈ¼¶"]=99
koSetGold(10000)--ko 3.0
elseif s==5 then
PlayBGM(18)
FightMenu()
elseif s>=6 and s<=5+#koAddon.titleMenu then--ko 3.1: registered rows
koAddon.titleMenu[s-5].run()
elseif s==6+#koAddon.titleMenu then
lib.PicLoadFile(CC.EFT[1],CC.EFT[2],6)
PlayBGM(2)
local cx,cy=(CC.ScreenW-640)/2,(CC.ScreenH-480)/2
for picid=0,1236 do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(6,picid*2,cx,cy,1)
ReFresh(8)
local eventtype=lib.GetMouse(1)
local koKe=lib.GetKey(1)
if koKe==0 then koExit() end
if eventtype==1 or eventtype==3 or koKe==1 or koKe==3 then
Dark()
lib.Delay(1000)
break
end
end
PicCatchIni()
elseif s==7+#koAddon.titleMenu then
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
end
end
end

function DrawStrBoxCenter(str,color)--ÏÔÊ¾´ø¿òµÄ×Ö·û´®
color=color or M_White
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
WarDrawStrBoxWaitKey(str,color,-1,-1)
else
DrawStrBoxWaitKey(str,color)
end
end

function GenTalkString(str,n)--²úÉú¶Ô»°ÏÔÊ¾ĞèÒªµÄ×Ö·û´®
local tmpstr=str
local num=0
local newstr=""
while #tmpstr>0 do
num=num+1
local w=0
while w<#tmpstr do
local v=string.byte(tmpstr,w+1)--µ±Ç°×Ö·ûµÄÖµ
if v==42 then
break
elseif v>=128 then
w=w+2
else
w=w+1
end
if w >=2*n-1 then--ÎªÁË±ÜÃâ¿ç¶ÎÖĞÎÄ×Ö·û
break
end
end
if w<#tmpstr then
if string.byte(tmpstr,w+1)==42 then
newstr=newstr .. string.sub(tmpstr,1,w+1)
tmpstr=string.sub(tmpstr,w+2,-1)
elseif w==2*n-1 and string.byte(tmpstr,w+1)<128 then
newstr=newstr .. string.sub(tmpstr,1,w+1) .. "*"
tmpstr=string.sub(tmpstr,w+2,-1)
else
local koC=w
local koS=0
if string.byte(tmpstr,koC+1)==32 then
koS=1
else
local koK=koC
while koK>1 do
if string.byte(tmpstr,koK)==32 then break end
koK=koK-1
end
if koK>1 and koK*5>=koC*3 then koC=koK-1 koS=1 end
end
newstr=newstr .. string.sub(tmpstr,1,koC) .. "*"
tmpstr=string.sub(tmpstr,koC+1+koS,-1)
end
else
newstr=newstr .. tmpstr
break
end
end
if string.sub(newstr,-1)=="*" then newstr=string.sub(newstr,1,-2) end--ko 5.0 koTrailStar: a line that ends exactly at the box edge left a trailing * = an empty talk page (10-08)
return newstr,num
end

function DrawMulitStrBox(str,color,size)--ÏÔÊ¾¶àĞĞ¾çÇé
local x,y=145,250
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x,y=113,298
if koWide() then x,y=math.floor(koMapCenterX(382)),math.floor(koMapCenterY(126)) end--ko 5.0: centred on the wide battle screen (10-10)
end
local sid=lib.SaveSur(x,y,x+382,y+126)
color=color or M_White
size=size or 16
local strarray={}
local num,maxlen
maxlen=0
str=GenTalkString(str,21)
num,strarray=Split(str,'*')
for i=1,num do
local len=#strarray[i]
if len>maxlen then
maxlen=len
end
end
if maxlen==0 then
return
end
local koPP=5
local koPG=1
while koPG<=num do
lib.PicLoadCache(4,50*2,x,y,1)
for i=koPG,math.min(koPG+koPP-1,num) do
DrawString(x+CC.MenuBorderPixel*3,y+CC.MenuBorderPixel*3+(size+4)*(i-koPG),strarray[i],color,size)
end
if koPG+koPP<=num then
ShowScreen()
WaitKey(nil,60)
end
koPG=koPG+koPP
end
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
WaitKey(nil,60)
lib.LoadSur(sid,x,y)
lib.FreeSur(sid)
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
end

--ÉèÖÃÊÂ¼ş
--eid ÊÂ¼şid
--flag ÊÂ¼ş×´Ì¬
function SetFlag(eid,flag)
JY.Base["ÊÂ¼ş"..eid]=flag
end

--¼ì²éÊÂ¼ş
--eid ÊÂ¼şid
-->0·µ»ØÕæ£¬·ñÔò·µ»Ø¼Ù
function koStoryEv()--ko 5.0 (view): story event number while a side act (710~) runs = flag 402, else JY.EventID
local v=JY.Base["ÊÂ¼ş402"]
if v and v>0 then return v end
return JY.EventID
end

function GetFlag(eid)
if JY.Base["ÊÂ¼ş"..eid]>0 then
return true
else
return false
end
end

--ĞŞ¸ÄÎä½«AI
--pid Îä½«id
--ai 
function WarModifyAI(pid,ai,p1,p2)
pid=pid+1--ĞŞÕı
local wid=GetWarID(pid)
if wid>0 then
War.Person[wid].ai=ai
if ai==3 or ai==5 then
War.Person[wid].aitarget=p1+1
elseif ai==4 or ai==6 then
War.Person[wid].ai_dx=p1+1
War.Person[wid].ai_dy=p2+1
end
end
end

--ĞŞ¸ÄÎä½«ÕóÓª
--pid Îä½«id
--fid ÕóÓªid£¬Ä¬ÈÏÎª1
function ModifyForce(pid,fid)
if pid==nil then
return
end
fid=fid or 1
--ĞŞ¸ÄÎä½«ÊıÁ¿Í³¼Æ
if JY.Person[pid]["¾ıÖ÷"]==1 and fid~=1 then
JY.Base["Îä½«ÊıÁ¿"]=JY.Base["Îä½«ÊıÁ¿"]-1
end
if JY.Person[pid]["¾ıÖ÷"]~=1 and fid==1 then
JY.Base["Îä½«ÊıÁ¿"]=JY.Base["Îä½«ÊıÁ¿"]+1
end
--Èç¹û¼ÓÈëÎÒ·½£¬¶îÍâÈ·ÈÏµÈ¼¶
if fid==1 then
JY.Person[pid]["µÈ¼¶"]=limitX(JY.Person[pid]["µÈ¼¶"],1,99)
if CC.Enhancement then
if JY.Status~=GAME_WMAP then
local dtlv=pjlv()
if JY.Person[pid]["µÈ¼¶"]<dtlv then--ĞÂ¼ÓÈëµÄÎä½«Èç¹ûµÈ¼¶µÍÓÚÎÒ·½Æ½¾ùµÈ¼¶£¬ÔòÌáÉıµ½ÎÒ·½Æ½¾ùµÈ¼¶
JY.Person[pid]["µÈ¼¶"]=dtlv
end
end
end
end
JY.Person[pid]["¾ıÖ÷"]=fid
if fid==1 then for _,k in ipairs({"\181\192\190\2231","\181\192\190\2232","\181\192\190\2233","\181\192\190\2234","\181\192\190\2235","\181\192\190\2236","\181\192\190\2237","\181\192\190\2238","\206\228\198\247","\183\192\190\223","\184\168\214\250"}) do local v=JY.Person[pid][k] if v>=181 and v<=195 then JY.Person[pid][k]=0 end end end--ko koOldCopy2: the enemy's dummy gear (old copies) does not come along
local picid=GetPic(pid)
if fid==1 and type(War.Person)=="table" then--Õ½¶·Ê±Èç¹û¾ıÖ÷¸ÄÎªÁõ±¸£¬»¹ĞèÒª¶îÍâĞŞ¸ÄÕ½¶·²¿·ÖÊôĞÔ
for i,v in pairs(War.Person) do
if v.id==pid then
v.enemy=false
v.friend=false
v.pic=WarGetPic(i)
v.ai=1
break
end
end
end
end

--ĞŞ¸ÄÎä½«±øÖÖ
--pid Îä½«id
--bzid ±øÖÖid£¬Ä¬ÈÏÎª1
function ModifyBZ(pid,bzid)
if pid==nil then
return
end
bzid=bzid or 1
JY.Person[pid]["±øÖÖ"]=bzid
end

--ÏÔÊ¾¹ı³¡Í¼Æ¬£¨´ø±ß¿ò£©£¬´øµ­Èëµ­³öĞ§¹û
--flag 0.ÎŞĞ§¹û 1.µ­Èë 2.µ­³ö
function LoadPic(id,flag)
local w,h=238,158
local x=16+640/2-w/2
local y=16+64
flag=flag or 0
if between(id,3,33) then
DrawSMap()
local sid=lib.SaveSur(x,y,x+w,y+h)
if flag==0 then
lib.PicLoadCache(4,id*2,x,y,1)
elseif flag==1 then--µ­Èë
for i=0,256,4 do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,x,y)
lib.PicLoadCache(4,id*2,x,y,1+2,i)
lib.GetKey()
ReFresh()
end
elseif flag==2 then--µ­³ö
for i=0,256,4 do
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,x,y)
lib.PicLoadCache(4,id*2,x,y,1+2,256-i)
lib.GetKey()
ReFresh()
end
end
lib.FreeSur(sid)
end
for i=1,CC.OpearteSpeed*2 do
JY.ReFreshTime=lib.GetTime()
lib.GetKey()
ReFresh()
end
end

-- ko 11-06: a battle that shows lines before the main loop enters it (GAME_WMAP2 events) gets its window size first
function koWarEnsure()
if JY.Status==GAME_WMAP and War and (War.Width or 0)>0 and War.BoxWidth then koWarRes(true) end
end
-- ko 11-06: where a battle line box goes in a big window: centred on the map, the upper / lower spots moved in with the map height
function koTalkOff(i,mx)
if not (JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE) or not War or not War.BoxDepth then return 0,0 end
local extra=math.max(0,War.BoxDepth*(War.MD or 9)-432)
local dx=math.max(0,math.floor(koMapCenterX(384))-mx)
if i%2==0 then return dx,math.floor(extra/4) end
return dx,math.floor(extra*3/4)
end
function koTalkPlace(xy)
for i=0,3 do
local t=xy[i]
local dx,dy=koTalkOff(i,t.mx)
t.headx=t.headx+dx t.talkx=t.talkx+dx t.mx=t.mx+dx
t.heady=t.heady+dy t.talky=t.talky+dy t.my=t.my+dy
end
local v=War and War.koTalkWid and War.Person[War.koTalkWid]
if not (v and v.live and not v.hide) then return end
local BW,BD=War.BoxWidth or 48,War.BoxDepth or 48
local sx,sy=War.OX+(v.x-War.CX)*BW,War.OY+(v.y-War.CY)*BD
local mw,mh=BW*War.MW,BD*War.MD
if sx<War.OX or sy<War.OY or sx>=War.OX+mw or sy>=War.OY+mh then return end
local mx=limitX(math.floor(sx+BW/2-192),War.OX+16,War.OX+mw-400)
local my
if sy+BD/2<War.OY+mh/2 then my=sy+BD+24 else my=sy-104 end
my=limitX(my,math.max(War.OY+16,40),War.OY+mh-96)
for i=0,3 do local t=xy[i] t.mx=mx t.my=my t.headx=mx t.heady=my t.talkx=mx+80 t.talky=my+20 end
end
function talk(...)
koWarEnsure()
local arg={}
for i,v in pairs({...}) do
arg[i]=v
end
local n=math.modf(#arg/2)
local f=0
for i=0,n-1 do
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
WarPersonCenter(GetWarID(arg[i*2+1]))
f=2
end
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
else
JY.Tid=arg[i*2+1]
DrawSMap()
end
if f==2 then War.koTalkWid=GetWarID(arg[i*2+1]) end
talk_sub(arg[i*2+1],arg[i*2+2],true,i%2+f)
if f==2 then War.koTalkWid=nil end
JY.ReFreshTime=lib.GetTime()
ReFresh()
end
JY.Tid=0
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
else
DrawSMap()
end
end

function talkYesNo(id,s)
local x4=512
local x3=x4-52
local x2=x4-56
local x1=x3-56
local y2=140
local y1=y2-24
do local koDx,koDy=koTalkOff(0,144) x1,x2,x3,x4=x1+koDx,x2+koDx,x3+koDx,x4+koDx y1,y2=y1+koDy,y2+koDy end
JY.Tid=id
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
else
end
talk_sub(id,s)
JY.Tid=0
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
if flag==1 then
lib.PicLoadCache(4,52*2,x1,y1,1)
else
lib.PicLoadCache(4,51*2,x1,y1,1)
end
if flag==2 then
lib.PicLoadCache(4,54*2,x3,y1,1)
else
lib.PicLoadCache(4,53*2,x3,y1,1)
end
ReFresh(0)
end
koMouseReset()
local current=0
while true do
redraw(current)
koPollKey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=1
elseif MOUSE.HOLD(x3+1,y1+1,x4-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
lib.FreeSur(sid)
return true
elseif MOUSE.CLICK(x3+1,y1+1,x4-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
lib.Delay(100)
lib.FreeSur(sid)
return false
else
current=0
end
end
end

function talk_sub(id,s,pause,flag)
local talkxnum=19--¶Ô»°Ò»ĞĞ×ÖÊı
local talkynum=3--¶Ô»°ĞĞÊı
pause=pause or false
flag=flag or 0
--ÏÔÊ¾Í·ÏñºÍ¶Ô»°µÄ×ø±ê
local mx,my=140,100
local xy={ [0]={headx=144,heady=60,
talkx=224,talky=80,
mx=144,my=60},
{headx=144,heady=292,
talkx=224,talky=312,
mx=144,my=292},
{headx=112,heady=76,
talkx=192,talky=96,
mx=112,my=76},
{headx=112,heady=340,
talkx=192,talky=360,
mx=112,my=340}, }
koTalkPlace(xy)
s=GenTalkString(s,talkxnum)
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval)
end
local size=16
local headid=JY.Person[id]["Í·Ïñ´úºÅ"]
local startp=1
local endp
local dy=0
local sid
local koPC=0 local koT0=0 local koW=-1
while true do
if dy==0 then
JY.ReFreshTime=lib.GetTime()
DrawYJZBox_sub(xy[flag].mx,xy[flag].my,384,80)
lib.PicLoadCache(2,headid*2,xy[flag].headx,xy[flag].heady,1)
DrawString(xy[flag].talkx,xy[flag].heady,JY.Person[id]["ĞÕÃû"],C_Name,size)
end
endp=string.find(s,"*",startp)
if endp==nil then
DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp),M_White,size)
koPC=koPC+#string.sub(s,startp)/2
ReFresh()
if pause then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15)
end
koT0=lib.GetTime() koW=koAutoMs(koPC) koPC=0
while true do
local eventtype=lib.GetMouse(1)
local koKe=lib.GetKey(1)
if koKe==0 then koExit() end
if koTalkHeld() and lib.GetTime()-koT0>=60 then--ko 5.1 (10-16): ì™¼ìª½ ë‹¨ì¶”Â·ì†ê°€ë½Â·Ctrl ì„ ëˆ„ë¥´ê³  ìˆìœ¼ë©´ ëŒ€ì‚¬ê°€ ë¹¨ë¦¬ ë„˜ì–´ê°
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
if (eventtype==1 or eventtype==3 or koKe==1 or koKe==3) and lib.GetTime()-koT0>200 then--koT0Talk 5.0: not the button-up of the click before (10-10)
lib.Delay(100)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
if koW>=0 and lib.GetTime()-koT0>=koW then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15)
end
ReFresh()
end
end
break
else
DrawString(xy[flag].talkx, xy[flag].talky + dy * (size+4),string.sub(s,startp,endp-1),M_White,size)
koPC=koPC+#string.sub(s,startp,endp-1)/2
end
dy=dy+1
startp=endp+1
if dy>=talkynum then
ReFresh()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
sid=lib.SaveSur(xy[flag].mx-15,xy[flag].my-15,xy[flag].mx+414-15,xy[flag].my+110-15)
end
koT0=lib.GetTime() koW=koAutoMs(koPC) koPC=0
while true do
local eventtype=lib.GetMouse(1)
local koKe=lib.GetKey(1)
if koKe==0 then koExit() end
if koTalkHeld() and lib.GetTime()-koT0>=60 then--ko 5.1 (10-16): ì™¼ìª½ ë‹¨ì¶”Â·ì†ê°€ë½Â·Ctrl ì„ ëˆ„ë¥´ê³  ìˆìœ¼ë©´ ëŒ€ì‚¬ê°€ ë¹¨ë¦¬ ë„˜ì–´ê°
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
if (eventtype==1 or eventtype==3 or koKe==1 or koKe==3) and lib.GetTime()-koT0>200 then--koT0Talk 5.0: not the button-up of the click before (10-10)
lib.Delay(100)
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
if koW>=0 and lib.GetTime()-koT0>=koW then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
lib.FreeSur(sid)
end
break
end
JY.ReFreshTime=lib.GetTime()
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
DrawWarMap()
lib.LoadSur(sid,xy[flag].mx-15,xy[flag].my-15)
end
ReFresh()
end
dy=0
end
end
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(CONFIG.KeyRepeatDelay,CONFIG.KeyRepeatInterval)
end
end

--ko 5.1 (10-16): ëŒ€í™” ë¹¨ë¦¬ ë„˜ê¸°ê¸°. ì™¼ìª½ ë‹¨ì¶”(í°ì€ ì†ê°€ë½) ë˜ëŠ” Ctrl ì„ 0.35ì´ˆ ë„˜ê²Œ ëˆ„ë¥´ê³  ìˆëŠ” ë™ì•ˆ true.
-- ì§§ì€ í´ë¦­ì€ ì˜ˆì „ì²˜ëŸ¼ í•œ ì¥ë§Œ ë„˜ê¸´ë‹¤. Ctrl ì€ ì—”ì§„ì— í‚¤ ìƒíƒœë¥¼ ë¬»ëŠ” í•¨ìˆ˜ê°€ ì—†ì–´ lib.GetKey ê°ì‹¸ê¸°ì—ì„œ ëˆ„ë¦„/ë—Œìœ¼ë¡œ ê¸°ì–µí•¨.
function koTalkHeld()
local on
if CONFIG.Windows then local b=lib.GetMouse() or 0 on=(b%2==1) else on=MOUSE.koFingerDown==true end--ko 5.1 (10-16 fix): on android lib.GetMouse() is the event type (-1 when idle, and -1%2==1 read as held, so talks ran by themselves); the finger is tracked from press/release events instead
on=on or MOUSE.koCtrl==true
if not on then MOUSE.koTalkHoldT=nil return false end
local now=lib.GetTime()
MOUSE.koTalkHoldT=MOUSE.koTalkHoldT or now
return now-MOUSE.koTalkHoldT>=350
end
function AddPerson(id,x,y,d)
table.insert(JY.Smap,{id,x,y,d,0})
end

function DecPerson(id)
for i,v in pairs(JY.Smap) do
if v[1]==id then
table.remove(JY.Smap,i)
break
end
end
end

--ko seed use (town): use seeds from person menu to raise stats
local function koSeedUse()
local personmenu={}
local personnum=0
for i=1,JY.PersonNum-1 do
	if JY.Person[i]["¾ıÖ÷"]==1 then
		personmenu[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),nil,1}
		personnum=personnum+1
	else
		personmenu[i]={"",nil,0}
	end
end
local function isSeed(iid)
	if iid<=0 then
		return false
	end
	local k=JY.Item[iid]["ÀàĞÍ"]
	return k==8 or k==9 or k==10 or (k==13 and JY.Item[iid]["×°±¸Î»"]==0)
end
while true do
	talk(369,"ƒT„hS ‚r„oX IƒaS …m…naƒoZ.")
	local r
	if personnum<=10 then
		r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
	else
		r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
	end
	if r<=0 then
		return
	end
	local p=JY.Person[r]
	while true do
		local seedmenu={}
		local cnt=0
		for n=1,8 do
			local iid=p["µÀ¾ß"..n]
			if isSeed(iid) then
				seedmenu[n]={fillblank(JY.Item[iid]["Ãû³Æ"],13),nil,1}
				cnt=cnt+1
			else
				seedmenu[n]={"",nil,0}
			end
		end
		if cnt==0 then
			PlayWavE(2)
			talk(369,p["ĞÕÃû"].."ƒb(‚b) ƒT„hS ^‚Cƒd „O‚C ‚kKLM.")
			break
		end
		talk(369,p["ĞÕÃû"].."  Iƒ} "..p["ÎäÁ¦"].." ‚Cƒ} "..p["ÖÇÁ¦"].." „w„x "..p["Í³ÂÊ"].." ‚R‚{ "..p["µÈ¼¶"].."*‚r„oX ƒT„hS …m…naƒoZ.")
		local s=ShowMenu(seedmenu,8,8,0,156,0,0,3,1,16,M_White,M_White)
		if s<=0 then
			break
		end
		local k=JY.Item[p["µÀ¾ß"..s]]["ÀàĞÍ"]
		local attr,label,cap
		if k==8 then
			attr,label,cap="ÎäÁ¦","Iƒ}",koNG.cap()
		elseif k==9 then
			attr,label,cap="ÖÇÁ¦","‚Cƒ}",koNG.cap()
		elseif k==10 then
			attr,label,cap="Í³ÂÊ","„w„x",koNG.cap()
		else
			attr,label,cap="µÈ¼¶","‚R‚{",99
		end
		local old=p[attr]
		if k~=13 and not CC.Person_S[attr][4] then
			PlayWavE(2)
			talk(369,"Iƒ}¡¤‚Cƒ}¡¤„w„xG …fƒa„C‚C ‚k‚b EFG‚f G ƒT„hS ‚r„oX q ‚aKLM.")
		elseif old>=cap then
			PlayWavE(2)
			talk(369,label.."G(^) G†w ˆz‚_‚f „l ƒi„u q ‚aKLM.")
		elseif WarDrawStrBoxYesNo(p["ĞÕÃû"].."ƒP "..label.." "..old.." ¡ú "..(old+1)..". ‚r„oXYZ?",M_White,true) then
			p[attr]=old+1
			for n=s,7 do
				p["µÀ¾ß"..n]=p["µÀ¾ß"..(n+1)]
			end
			p["µÀ¾ß8"]=0
			ReSetAttrib(r,true)
			PlayWavE(12)
			talk(369,p["ĞÕÃû"].."ƒP "..label.." "..old.." ¡ú "..p[attr])
		end
	end
end
end


function Person_Menu()
local menu={
{" Iƒa Fƒs",nil,1},
{" D‚w „W†I",nil,1},
{" ƒT„h Fƒx",nil,1},
{" †J‚s†K‚X",nil,1},
{" ‚s‚J†KƒA",nil,1},
{" †L†M qƒx",nil,1},
{" ƒT„h ‚r„o",nil,1},
}
for _,koM in ipairs(koAddon.personMenu) do menu[#menu+1]={" "..koM.label,nil,(koM.show==nil or koM.show()) and 1 or 0} end--ko 3.1: registered rows
local koTrainerRow=0
if JY.Base["ÎŞÓÃ1"]==1 then
koTrainerRow=#menu+1
menu[koTrainerRow]={" ‚P‹h ‚X‚Y",nil,1}
end
DrawYJZBox(32,32,"Iƒa",M_White,true)
 
local r=ShowMenu(menu,#menu,0,546,math.min(244,472-(24+20*#menu)),0,0,4,1,16,M_White,M_White)--ko 5.0 (10-13): moved up so every row stays on the screen (11 rows ran off the bottom)
if r==1 then
	PersonStatus_Menu(1)
elseif r==2 then
	ExchangeItem(1)
elseif r==3 then
	if WarDrawStrBoxYesNo('ƒT„hS FƒxXYZ?',M_White,true) then	
		Dark()			
		tlzz()
	end
elseif r==4 then	
		ntgm()
elseif r==5 then	
		tgkw()		
		
elseif r==6 then
		qtxl()
elseif r==7 then
		koSeedUse2()--ko 3.3: seeds of the whole army, several at once
elseif r>=8 and r<=7+#koAddon.personMenu then--ko 3.1: registered rows
		koAddon.personMenu[r-7].run()
elseif koTrainerRow>0 and r==koTrainerRow then
		koTrainer()
	--if CC.Enhancement==false then
	--	Maidan(1)
	--else
	--	Maidan2(1)
	--end
	
end
end

function test()
end


--ko 4.0 later: ì—­ì²œê°œëª… ë“±ê¸‰ ê¸°ì¤€ ì™„í™” = íšŒì°¨ ë¶€ë¶„ (2íšŒì°¨ +5, 3íšŒì°¨ +10, 4íšŒì°¨ë¶€í„° +15) + ë‚œì´ë„ ë¶€ë¶„.
--  ë‚œì´ë„ ë¶€ë¶„ = ì  ëŠ¥ë ¥ì¹˜ ë³´ì •(koNG.ebonus ì‹)ì„ ì§€ë‚œ íšŒì°¨ì—ì„œ ì“´ ê°€ì¥ ë‚®ì€ ë‚œì´ë„ë¡œ ê³„ì‚°, 5 ë‹¨ìœ„ë¡œ ë²„ë¦¼.
--  ì§€ë‚œ íšŒì°¨ì˜ ê°’ì€ íšŒì°¨ ì´ë ¥ ì¹¸(äº‹ä»¶ 1120+(n-1)*4 = ê·¸ íšŒì°¨ì˜ æ— ç”¨3, record addon ì´ ì ê³  ë‹¤ìŒ íšŒì°¨ë¡œ ë„˜ê¹€)ì—ì„œ ì½ìœ¼ë¯€ë¡œ
--  íšŒì°¨ ë„ì¤‘ì— ë‚œì´ë„ë¥¼ ë°”ê¿”ë„ ì´ë²ˆ íšŒì°¨ì˜ ì™„í™”ëŠ” ë³€í•˜ì§€ ì•ŠëŠ”ë‹¤.
function koNtgmShift()
local n=koNG.rcycle()
local c=math.min(15,5*(n-1))
local t=0
if n>=2 then t=JY.Base["\202\194\188\254"..(1120+((n-2)%20)*4)] or 0 end
local dd=0
if t-1>5 then dd=math.floor(math.floor((koNG.cap()-100)*(t-1-5)/5)/5)*5 end
return c+dd,c,dd,t
end
function ntgm()

for i=0,JY.PersonNum-1 do
	Person0[i]={}	
	--if i<421 then
	--	local meta_t={
	--	__index=function(t,k)
	--	return GetPersonData(i*CC.PersonSize,CC.Person_S,k)--421ÒÔÇ°µÄÈËÎï»ìºÏ¶ÁÈ¡£¬421ÒÔºóÎªĞÂÎä½«
	--	end,
	--	__newindex=function(t,k,v)
	--	SetDataFromStruct(JY.Data_Person_Base,i*CC.PersonSize,CC.Person_S,k,v)
	--	end
	--	}
	--	setmetatable(Person0[i],meta_t)		
	--else
		local meta_t={
		__index=function(t,k)
		return GetDataFromStruct(JY.Data_Person_Base,i*CC.PersonSize,CC.Person_S,k)
		end,
		__newindex=function(t,k,v)
		SetDataFromStruct(JY.Data_Person_Base,i*CC.PersonSize,CC.Person_S,k,v)
		end
		}
		setmetatable(Person0[i],meta_t)
	--end
end
	
local oskid,nskid,maxattr,base_cost,final_cost,base_rate
local personmenu={}
local personnum=0
local skmenu={}
local tj1menu={}
local tj2menu={}
local tj3menu={}
local tj4menu={}
local tj5menu={}
local tj6menu={}
local tj7menu={}

for i=1,JY.PersonNum-1 do		
	if JY.Person[i]["¾ıÖ÷"]==1 then
		personmenu[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),nil,1}
		personnum=personnum+1		
	else
		personmenu[i]={"",nil,0}
	end
end
local r
talk(369,"‚s‚^¡¤xƒG‚h ƒU†N IƒaS …m…naƒoZ.")
if personnum<=10 then
	r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
	r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r<=0 then
	return
end
talk(369,"ƒU†N ƒG†O ‚s‚^ƒv xƒG‚h …m…naƒoZ")
skmenu[1]={fillblank("‚s‚^: "..JY.Skill[JY.Person[r]["Ìì¸³"]]["Ãû³Æ"],10),nil,1}
for i=1,6 do
	skmenu[i+1]={fillblank("xƒG"..i..":"..JY.Skill[JY.Person[r]["ÌØ¼¼"..i]]["Ãû³Æ"],10),nil,1}
end
oskid=ShowMenu(skmenu,7,0,0,156,0,0,3,1,16,M_White,M_White)
if oskid<=0 then
	return
end

if (Person0[JY.Person[r]["´úºÅ"]]["ÎäÁ¦"]>=Person0[JY.Person[r]["´úºÅ"]]["ÖÇÁ¦"]) and (Person0[JY.Person[r]["´úºÅ"]]["ÎäÁ¦"]>=Person0[JY.Person[r]["´úºÅ"]]["Í³ÂÊ"]) then
	maxattr=Person0[JY.Person[r]["´úºÅ"]]["ÎäÁ¦"]	
elseif Person0[JY.Person[r]["´úºÅ"]]["ÖÇÁ¦"]>=Person0[JY.Person[r]["´úºÅ"]]["Í³ÂÊ"] then
	maxattr=Person0[JY.Person[r]["´úºÅ"]]["ÖÇÁ¦"]	
else
	maxattr=Person0[JY.Person[r]["´úºÅ"]]["Í³ÂÊ"]	
end


if r<=0 then
	return
end

local koSh,koShC,koShD,koShT=koNtgmShift()
if koSh>0 then
local ds="\131\071\133\108 \130\097\130\077"
if koShT==1 then ds="\131\115\132\119" elseif koShT>1 then ds="\129\068\130\066 "..(koShT-1) end
talk(369,"\129\071\130\087 \130\125\132\121 \133\125\134\080 \129\100\129\111 \134\108\129\064 +"..koSh.."*\130\125\132\121 +"..koShC..", \130\067\130\113 \130\125\132\121 \136\122\133\102 \130\113\129\071\129\068 "..ds.." +"..koShD)
end
base_cost=maxattr*100	--Ò»ĞÇ¼¼µÄ»ù±¾ÊÕ·Ñ
base_rate=0.15		--ÌØ¼¼Ã¿Ìá¸ßÒ»ĞÇÔö¼ÓµÄ·ÑÓÃ

talk(369,"†D ƒGƒH …}†PS …m…naƒoZ")
local sktypemenu={
{fillblank("…Iƒ{ƒG",11),nil,1},
{fillblank("Gƒ{ƒG",11),nil,0},
{fillblank("|ƒ{ƒG",11),nil,0},
{fillblank("‚rƒ{ƒG",11),nil,0},
{fillblank("[ƒ{ƒG",11),nil,0},
{fillblank("†Qƒ{ƒG",11),nil,0},
{fillblank("†Rƒ{ƒG",11),nil,0},
}

for i=1,6 do
	if maxattr<=99-i*5+koSh then
		sktypemenu[i+1][3]=1
	end
end
local sktype=ShowMenu(sktypemenu,7,0,0,140,0,0,3,1,16,M_White,M_White)
if sktype<=0 then
	return
end
final_cost=base_cost*(1+(sktype-1)*base_rate)
if sktype==1 then	
	if koGold()<final_cost then
		talk(369,"…Iƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")	
		for i=1,41 do
			tj1menu[i]={"",nil,0}
		end
		tj1menu[7]={fillblank("‚n†S",11),nil,1}	
		tj1menu[9]={fillblank("†Tj",11),nil,1}
		tj1menu[13]={fillblank("†U@",11),nil,1}
		tj1menu[14]={fillblank("„Y„Z",11),nil,1}
		tj1menu[18]={fillblank("‚y†V",11),nil,1}
		tj1menu[21]={fillblank("‚D‚~",11),nil,1}
		tj1menu[22]={fillblank("„QU",11),nil,1}		
		tj1menu[41]={fillblank("ƒs†P",11),nil,1}
		nskid=ShowMenu(tj1menu,41,8,0,110,0,0,3,1,16,M_White,M_White)
	end
elseif sktype==2 then	
	if koGold()<final_cost then
		talk(369,"Gƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")		
		for i=1,118 do
			tj2menu[i]={"",nil,0}
		end		
		tj2menu[8]={fillblank("„oI",11),nil,1}
		tj2menu[11]={fillblank("q„T",11),nil,1}	
		tj2menu[12]={fillblank("@„T",11),nil,1}		
		tj2menu[19]={fillblank("ƒs‚D",11),nil,1}
		tj2menu[20]={fillblank("ƒl†W",11),nil,1}
		tj2menu[24]={fillblank("‚I†X",11),nil,1}
		tj2menu[25]={fillblank("‚IƒG",11),nil,1}
		tj2menu[118]={fillblank("†YD",11),nil,1}
					
		nskid=ShowMenu(tj2menu,118,8,0,110,0,0,3,1,16,M_White,M_White)
	end
elseif sktype==3 then	
	if koGold()<final_cost then
		talk(369,"|ƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")		
		for i=1,118 do
			tj3menu[i]={"",nil,0}
		end		
		tj3menu[2]={fillblank("qK",11),nil,1}		
		tj3menu[10]={fillblank("…{‚J",11),nil,1}		
		tj3menu[29]={fillblank("†ZƒN",11),nil,1}
		tj3menu[31]={fillblank("F‚~",11),nil,1}		
		tj3menu[42]={fillblank("…A‚p",11),nil,1}
		tj3menu[103]={fillblank("†@‚B",11),nil,1}
		tj3menu[105]={fillblank("†VƒL",11),nil,1}
		tj3menu[111]={fillblank("†[ƒd",11),nil,1}
					
		nskid=ShowMenu(tj3menu,111,8,0,110,0,0,3,1,16,M_White,M_White)
	end
elseif sktype==4 then	
	if koGold()<final_cost then
		talk(369,"‚rƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")		
		for i=1,113 do
			tj4menu[i]={"",nil,0}
		end		
		tj4menu[6]={fillblank("†]‚r",11),nil,1}	
		tj4menu[26]={fillblank("…d†^",11),nil,1}	
		tj4menu[27]={fillblank("†_…x",11),nil,1}	
		tj4menu[30]={fillblank("I†`",11),nil,1}	
		tj4menu[34]={fillblank("‚I‚]",11),nil,1}
		tj4menu[36]={fillblank("†ag",11),nil,1}		
		tj4menu[107]={fillblank("‚}‚p",11),nil,1}		
		tj4menu[113]={fillblank("g†b",11),nil,1}
				
		nskid=ShowMenu(tj4menu,113,8,0,110,0,0,3,1,16,M_White,M_White)
	end
elseif sktype==5 then	
	if koGold()<final_cost then
		talk(369,"[ƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")		
		for i=1,117 do
			tj5menu[i]={"",nil,0}
		end		
		tj5menu[16]={fillblank("‚Xƒ@",11),nil,1}
		tj5menu[17]={fillblank("ƒN„[",11),nil,1}
		tj5menu[28]={fillblank("†cq",11),nil,1}				
		tj5menu[33]={fillblank("‚J†d",11),nil,1}
		tj5menu[35]={fillblank("†e…b",11),nil,1}
		tj5menu[44]={fillblank("‚q‚r",11),nil,1}		
		tj5menu[112]={fillblank("†fƒ`",11),nil,1}	
		tj5menu[117]={fillblank("†g‚J",11),nil,1}			
		nskid=ShowMenu(tj5menu,117,8,0,110,0,0,3,1,16,M_White,M_White)
	end
elseif sktype==6 then	
	if koGold()<final_cost then
		talk(369,"†Qƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")		
		for i=1,106 do
			tj6menu[i]={"",nil,0}
		end		
		tj6menu[15]={fillblank("„Y‚r",11),nil,1}
		tj6menu[23]={fillblank("…}†h",11),nil,1}	
		tj6menu[32]={fillblank("ƒ{‚B",11),nil,1}		
		tj6menu[48]={fillblank("‚qI",11),nil,1}
		tj6menu[49]={fillblank("„o†i",11),nil,1}
		tj6menu[50]={fillblank("†d‚Z",11),nil,1}
		tj6menu[102]={fillblank("…A†j",11),nil,1}
		tj6menu[106]={fillblank("†@‚r",11),nil,1}
					
		nskid=ShowMenu(tj6menu,106,8,0,110,0,0,3,1,16,M_White,M_White)
	end
else	
	if koGold()<final_cost then
		talk(369,"†Rƒ{ƒG ‚P„o "..final_cost.."ƒg")
		return
	else
		talk(369,"G‚W ‚P„o "..final_cost.."ƒg")		
		for i=1,119 do
			tj7menu[i]={"",nil,0}
		end		
		tj7menu[3]={fillblank("qƒN",11),nil,1}
		tj7menu[4]={fillblank("@ƒN",11),nil,1}			
		tj7menu[39]={fillblank("„`„T",11),nil,1}
		tj7menu[45]={fillblank("OƒG",11),nil,1}		
		tj7menu[46]={fillblank("‚Cu",11),nil,1}		
		tj7menu[108]={fillblank("jD",11),nil,1}
		tj7menu[110]={fillblank("†Vg",11),nil,1}		
		tj7menu[119]={fillblank("‚C†k",11),nil,1}			
		nskid=ShowMenu(tj7menu,119,8,0,110,0,0,3,1,16,M_White,M_White)
	end		
end

if nskid<=0 then
	return
end
if WarDrawStrBoxYesNo("‚P„o "..final_cost.."ƒgƒm„S "..skmenu[oskid][1].." ¡ú "..JY.Skill[nskid]["Ãû³Æ"]..". ƒJƒKKLY?",M_White,true) then
	if oskid==1 then
		JY.Person[r]["Ìì¸³"]=nskid
		UseMoney(final_cost)
	else
		JY.Person[r]["ÌØ¼¼"..(oskid-1)]=nskid
		UseMoney(final_cost)
	end	
	talk(369,"ƒGƒH ‚tƒ@G †lU„C„kKLM.")
end

end



function tgkw()

local r,iid,zzid,fixtype,itype,base_cost,final_cost,return_gold
local icnt=0
local wash_flag=0
local personmenu={}
local personnum=0
local imenu={}
local itypemenu={}
local fixmenu={}
local tjid={}
local tj1menu={}
local tj2menu={}


for i=1,JY.PersonNum-1 do		
	if JY.Person[i]["¾ıÖ÷"]==1 then
		personmenu[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),nil,1}
		personnum=personnum+1		
	else
		personmenu[i]={"",nil,0}
	end
end
talk(369,"ƒa‚P‚h ‚C†m IƒaS …m…naƒoZ")
if personnum<=10 then
	r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
	r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end

if r<=0 then
	return
end
talk(369,"‚KvX ƒa‚P‚h …m…naƒoZ")
for i=1,8 do
	if JY.Person[r]["µÀ¾ß"..i]>0 then
		imenu[i]={fillblank(JY.Item[JY.Person[r]["µÀ¾ß"..i]]["Ãû³Æ"],13),nil,1}
		icnt=icnt+1
	else
		imenu[i]={"",nil,0}
	end
end
if icnt==0 then
	talk(369,"G jƒAƒb m‚CƒBG ‚aKLM.")
	return
end
iid=ShowMenu(imenu,8,8,0,156,0,0,6,1,16,M_White,M_White)
if iid<=0 then
	return
end


base_cost=6000	--»¢ÁÒ¼¼·ÑÓÃ
local koIid=(rawget(_G,"koItemBaseId") or function(x) return x end)(JY.Person[r]["µÀ¾ß"..iid])--ko 5.0: also armour / shields (type 12) and books / horses without a skill of their own (types 5 / 6)
local koTy=JY.Item[koIid]["ÀàĞÍ"]
if not between(koIid,147,151) and (between(koIid,74,139) or koTy==12 or ((koTy==5 or koTy==6) and ((CC.koItemSk0 or {})[koIid] or 0)==0)) then--ko 5.1 (10-21): shields (147~151, guard) are not engraved
	talk(369,"J†nS …m…naƒoZ")
	fixmenu={
		{fillblank("v‚E †DƒGƒG",11),nil,1},
		{fillblank("…Z†o ‚CƒOƒG",11),nil,1},	
		}	
	fixtype=ShowMenu(fixmenu,2,0,0,156,0,0,3,1,16,M_White,M_White)
	if fixtype==0 then
		return
	end
	if fixtype==1 then
		talk(369,"†D„} †pS xƒG‚h …m…naƒoZ")	
		itypemenu={
		{fillblank("†q‚AƒG",11),nil,1},
		{fillblank("„i†oƒG",11),nil,1},	
		}
		itype=ShowMenu(itypemenu,2,0,0,156,0,0,3,1,16,M_White,M_White)
		if itype<=0 then
			return
		end
		if itype==1 then	
			final_cost=base_cost
			if koGold()<final_cost then
				talk(369,"†q‚AƒG ‚P„o "..final_cost.."ƒg")
				return
			else
				talk(369,"G‚W ‚Kv ‚P„o "..final_cost.."ƒg")	
				for i=1,25 do
					tj1menu[i]={"",nil,0}
				end
				tj1menu[7]={fillblank("‚n†S",11),nil,1}	
				tj1menu[11]={fillblank("q„T",11),nil,1}							
				tj1menu[14]={fillblank("„Y„Z",11),nil,1}
				tj1menu[20]={fillblank("ƒl†W",11),nil,1}
				tj1menu[21]={fillblank("‚D‚~",11),nil,1}
				tj1menu[24]={fillblank("‚I†X",11),nil,1}
				tj1menu[25]={fillblank("‚IƒG",11),nil,1}
					
					
				zzid=ShowMenu(tj1menu,25,7,0,100,0,0,3,1,16,M_White,M_White)
			end
		else
			final_cost=base_cost*1.5
			if koGold()<final_cost then
				talk(369,"„i†oƒG ‚P„o "..final_cost.."ƒg")
				return
			else
				talk(369,"G‚W ‚Kv ‚P„o "..final_cost.."ƒg")		
				for i=1,118 do
					tj2menu[i]={"",nil,0}
				end
				tj2menu[2]={fillblank("qK",11),nil,1}		
				tj2menu[8]={fillblank("„oI",11),nil,1}
				tj2menu[10]={fillblank("…{‚J",11),nil,1}					
				tj2menu[12]={fillblank("@„T",11),nil,1}
				tj2menu[19]={fillblank("ƒs‚D",11),nil,1}
				tj2menu[42]={fillblank("…A‚p",11),nil,1}			
				tj2menu[118]={fillblank("†YD",11),nil,1}
				zzid=ShowMenu(tj2menu,118,7,0,100,0,0,3,1,16,M_White,M_White)
			end
		end
		if zzid<=0 then
			return
		end
		if WarDrawStrBoxYesNo("‚P„o "..final_cost.."ƒgƒm„S xƒG "..JY.Skill[zzid]["Ãû³Æ"].." †DƒGƒG ¡ú "..JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["Ãû³Æ"]..". ƒJƒKKLY?",M_White,true) then
			if not koEngraveSet(r,iid,zzid) then return end--ko 11-15: the engraved one becomes its own copy (engrave addon)		
			UseMoney(final_cost)	
			talk(369,"ƒGƒH ‚tƒ@G †lU„C„kKLM.")
		end
	else
		if JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]==0 then
			talk(369,"‚C…[ xƒG^ ‚aKLM")
			return
		elseif JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]==((CC.koItemSk0 or {})[JY.Person[r]["µÀ¾ß"..iid]] or 0) then--ko 5.0: no refund for a skill it came with
			talk(369,"ƒQ†G ŒE‚S „OŠB xƒG‚b ‚C…[ q ‚aKLM")
			return
		else
			tjid={7,11,14,20,21,24,25}
			for i=1,7 do
				if JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]==tjid[i] then
					return_gold=base_cost*0.95
					if WarDrawStrBoxYesNo("xƒG d†E: "..JY.Skill[JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]]["Ãû³Æ"]..", ‚P„oƒP 95£¥ †I†P "..return_gold.."ƒg.",M_White,true) then
						talk(369,"d†E †lU: "..JY.Skill[JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]]["Ãû³Æ"])
						koEngraveErase(r,iid)--ko 11-15: a copy goes back to the shared item				
						GetMoney(return_gold)
						wash_flag=1					
						break
					end			
					
				end
			end
			if wash_flag==0 then
				return_gold=base_cost*1.5*0.95				
				if WarDrawStrBoxYesNo("xƒG d†E: "..JY.Skill[JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]]["Ãû³Æ"]..", ‚P„oƒP 95£¥ †I†P "..return_gold.."ƒg.",M_White,true) then
					talk(369,"d†E †lU: "..JY.Skill[JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]]["Ãû³Æ"])
					koEngraveErase(r,iid)--ko 11-15: a copy goes back to the shared item
					GetMoney(return_gold)
					wash_flag=1					
				end
			end
		end
	end
						
else
	talk(369,"G ƒAƒBf‚b †D†r q ‚aKLM")
	return
end


end

function PersonStatus_Menu(fid)
local menu={}
local n=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==fid then
menu[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),PersonStatus,1,nil,nil,(rawget(_G,"koAwakeIs") and koAwakeIs(i)) and M_Yellow or nil}
n=n+1
else
menu[i]={"",nil,0}
end
end
DrawYJZBox(32,32,"Iƒa Fƒs",M_White,true)
if n<=8 then
ShowMenu(menu,JY.PersonNum-1,8,546,224,0,0,5,1,16,M_White,M_White)
else
ShowMenu(menu,JY.PersonNum-1,8,530,224,0,0,6,1,16,M_White,M_White)
end
end

--Îä½«ÊôĞÔ½çÃæ
function PersonStatus(pid,x,y,flag)
flag=flag or 0
if type(x)=='number' and type(y)=='number' then
else
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=koMapCenterX(456)
y=koMapCenterY(276)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-456)/2
y=16+(400-276)/2
else
x=(CC.ScreenW-456)/2
y=(CC.ScreenH-276)/2
end
end
local p=JY.Person[pid]
local close=false
rawset(_G,"koTfPage",1)--ko 5.0 (10-12): talent pages
if flag==0 then
DrawSMap()
DrawYJZBox(32,32,"Iƒa Fƒs",M_White,true)
end
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.LoadSur(sid,0,0)
PersonStatus_sub(pid,x,y,flag)
if close then
lib.PicLoadCache(4,56*2,x+384,y+16,1)
else
lib.PicLoadCache(4,55*2,x+384,y+16,1)
end
ReFresh()
end
while true do
redraw()
local eventtype,keypress,mx,my=getkey()
if eventtype==3 and keypress==3 then
PlayWavE(1)
lib.Delay(20)
break
end
if MOUSE.HOLD(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
close=true
elseif MOUSE.CLICK(x+384+1,y+16+1,x+384+52-1,y+16+24-1) then
PlayWavE(0)
close=false
redraw()
lib.Delay(20)
break
else
close=false
end
if (rawget(_G,"koTfPages") or 1)>1 and MOUSE.CLICK(x+180,y+48,x+448,y+120) then--ko 5.0 (10-12): talent pages
PlayWavE(0)
local koNP,koPg=rawget(_G,"koTfPages"),rawget(_G,"koTfPage") or 1
if MOUSE.x and MOUSE.x>=x+398 and MOUSE.x<x+412 and MOUSE.y and MOUSE.y<y+76 then koPg=koPg-1 else koPg=koPg+1 end
if koPg<1 then koPg=koNP elseif koPg>koNP then koPg=1 end
rawset(_G,"koTfPage",koPg)
end
for i=1,8 do
local iid=JY.Person[pid]["µÀ¾ß"..i]
if iid>0 then
if MOUSE.CLICK(x+340,y+112+koAwakeDY(pid)+i*16,x+340+#JY.Item[iid]["Ãû³Æ"]*16/2,y+112+koAwakeDY(pid)+(i+1)*16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
end
end
end
if rawget(_G,"koStatusSlotsHit") then
koStatusSlotsHit(pid,x,y+koAwakeDY(pid))
else
for i,v in pairs({"ÎäÆ÷","·À¾ß","¸¨Öú"}) do
local iid=JY.Person[pid][v]
if iid>0 then
if MOUSE.CLICK(x+184+16*4,y+183+i*21,x+184+16*4+#JY.Item[iid]["Ãû³Æ"]*16/2,y+183+i*21+16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
end
end
end
end
if MOUSE.CLICK(x+24,y+24,x+24+64,y+24+80) then
local name=p["ĞÕÃû"]
if type((CC.LieZhuanPid or {})[pid] or CC.LieZhuan[name])=='string' then--ko 3.6: by number first (two people named the same)
DrawLieZhuan(name,pid)--ÏÔÊ¾ÁĞ´«
end
end
if MOUSE.CLICK(x+111,y+55,x+111+48,y+55+48) then
local bzkz="*Cƒ{:"
for i=1,9 do
if JY.Bingzhong[p["±øÖÖ"]]["¿ËÖÆ"..i]>0 then
bzkz=bzkz..JY.Bingzhong[JY.Bingzhong[p["±øÖÖ"]]["¿ËÖÆ"..i]]["Ãû³Æ"].." "
end
if i==9 and bzkz=="*Cƒ{:" then
bzkz=""
end
end
DrawStrStatus("|}~‚@ ‚~T - "..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"],JY.Bingzhong[p["±øÖÖ"]]["ËµÃ÷"]..bzkz)
end
if CC.Enhancement then
local box_w=36
local box_h=20
for i=1,6 do
local cx=x+56+box_w*((i-1)%3)
local cy=y+220+koAwakeDY(pid)+box_h*math.modf((i-1)/3)
if MOUSE.CLICK(cx+1,cy+1,cx+box_w,cy+box_h) then
if p["µÈ¼¶"]>=CC.SkillExp[p["³É³¤"]][i] or flag==2 then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼"..i])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
end
end
end
end
lib.FreeSur(sid)
end

function koAwakeDY(pid) return rawget(_G,"koAwakeDown") and koAwakeDown(pid) or 0 end
function PersonStatus_sub(pid,x,y,flag)
flag=flag or 0
x=x or 208
y=y or 72
ReSetAttrib(pid,false)
JY.Person[pid]["Õ½¶·¶¯×÷"]=GetPic(pid,false,false)
lib.PicLoadCache(4,85*2,x,y,1) if rawget(_G,"koAwakeWindow") then koAwakeWindow(pid,x,y) end
local p=JY.Person[pid]
local b=JY.Bingzhong[p["±øÖÖ"]]
DrawString(x+135-#p["ĞÕÃû"]*16/4,y+20,p["ĞÕÃû"],(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White),16)
DrawString(x+184,y+20,p["µÈ¼¶"].."‚R‚{".."£¨"..p["¾­Ñé"].."£¥£© "..b["Ãû³Æ"],M_White,16)
lib.Background(x+184-4,y+48,x+184+16*16+4,y+120,192)
lib.SetClip(x+180,y+48,x+448,y+120)
if CC.Enhancement then
local koTL,koTA=Split(GenTalkString("‚s‚^: "..JY.Skill[p["Ìì¸³"]]["Ãû³Æ"].."*"..JY.Skill[p["Ìì¸³"]]["ËµÃ÷"]..((rawget(_G,"koAwakeTfText") and koAwakeTfText(pid)) or ""),16),'*') if koTL>1 and koTA[koTL]=="" then koTL=koTL-1 end local koNP=math.max(1,math.ceil((koTL-1)/3)) local koPg=limitX(rawget(_G,"koTfPage") or 1,1,koNP) rawset(_G,"koTfPage",koPg) rawset(_G,"koTfPages",koNP)--ko 5.0 (10-12): talent text in pages (title + 3 lines)
local koSh={koTA[1]} for koK=(koPg-1)*3+2,math.min(koTL,koPg*3+1) do koSh[#koSh+1]=koTA[koK] end
DrawStr(x+184,y+48+8,table.concat(koSh,"*"),M_White,16)
if koNP>1 then DrawString(x+400,y+48+8,"<"..koPg.."/"..koNP..">",M_Yellow,16) end
else
DrawStr(x+184,y+48+8,GenTalkString(b["ËµÃ÷"],16),M_White,16)
end
lib.SetClip(0,0,0,0)
lib.PicLoadCache(2,p["Í·Ïñ´úºÅ"]*2,x+24,y+24,1) if rawget(_G,"koAwakeFrame") then koAwakeFrame(pid,x+17,y+17) end
lib.PicLoadCache(1,(p["Õ½¶·¶¯×÷"]+19)*2,x+111,y+55,1) y=y+koAwakeDY(pid)
DrawString(x+184,y+120,"‚~ ƒ}¡¡¡¡"..p["×î´ó±øÁ¦"],M_White,16)
DrawString(x+184,y+141,"‚J‚pƒ}¡¡ "..p["¹¥»÷"],M_White,16)
DrawString(x+184,y+162,"„N‚Sƒ}¡¡ "..p["·ÀÓù"],M_White,16)
DrawString(x+184,y+183,"G‚lƒ}",M_White,16)
if b["ÒÆ¶¯"]==p["ÒÆ¶¯"] then
DrawString(x+184+16*4,y+183,"¡¡"..b["ÒÆ¶¯"],M_White,16)
else
DrawString(x+184+16*4,y+183,string.format("%d(%+d)",p["ÒÆ¶¯"],p["ÒÆ¶¯"]-b["ÒÆ¶¯"]),M_White,16)
end
if rawget(_G,"koAwakeStatus") then koAwakeStatus(pid,x,y) end
if rawget(_G,"koStatusSlotsDraw") then
koStatusSlotsDraw(pid,x,y)
else
DrawString(x+184,y+204,"I ƒG",M_White,16)
DrawString(x+184,y+225,"„N ‚w",M_White,16)
DrawString(x+184,y+246,"ƒs v",M_White,16)
if p["ÎäÆ÷"]>0 then
DrawString(x+184+16*4,y+204,JY.Item[p["ÎäÆ÷"]]["Ãû³Æ"],M_White,16)
end
if p["·À¾ß"]>0 then
DrawString(x+184+16*4,y+225,JY.Item[p["·À¾ß"]]["Ãû³Æ"],M_White,16)
end
if p["¸¨Öú"]>0 then
DrawString(x+184+16*4,y+246,JY.Item[p["¸¨Öú"]]["Ãû³Æ"],M_White,16)
end
end
local len=100
local kolen=koNG.cap()
if kolen<100 then
kolen=100
end
if CC.Enhancement then
for i,v in pairs({"ÎäÁ¦","ÖÇÁ¦","Í³ÂÊ"}) do
local v1=p[v..'2']
local v2=p[v]
local color
if v1<30 then
color=210
elseif v1<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+87+i*32,x+44+len,y+87+10+i*32,M_Black)
lib.SetClip(x+44,y+87+i*32,x+44+math.max(1,math.min(len,len*v1/kolen)),y+87+10+i*32)
lib.PicLoadCache(4,color*2,x+44,y+87+i*32,1)
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",v1)
DrawString2(x+44+60-16*#str/4,y+87-3+i*32,str,M_White,16)
if v1~=v2 then
str=string.format("(%+d)",v1-v2)
DrawString2(x+48+104,y+89-3+i*32,str,M_White,12)
end
end
else
for i,v in pairs({"ÎäÁ¦","ÖÇÁ¦","Í³ÂÊ"}) do
local v1=p[v..'2']
local v2=p[v]
local color
if v1<30 then
color=210
elseif v1<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+95+i*32,x+44+len,y+95+10+i*32,M_Black)
lib.SetClip(x+44,y+95+i*32,x+44+math.max(1,math.min(len,len*v1/kolen)),y+95+10+i*32)
lib.PicLoadCache(4,color*2,x+44,y+95+i*32,1)
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",v1)
DrawString2(x+44+60-16*#str/4,y+95-3+i*32,str,M_White,16)
if v1~=v2 then
str=string.format("(%+d)",v1-v2)
DrawString2(x+48+104,y+97-3+i*32,str,M_White,12)
end
end
end
if CC.Enhancement then
local wljy=p["ÎäÁ¦¾­Ñé"]
local zljy=p["ÖÇÁ¦¾­Ñé"]
local tljy=p["Í³ÂÊ¾­Ñé"]
--if p["ÎäÁ¦"]==100 then
--wljy=200
--elseif p["ÖÇÁ¦"]==100 then
--zljy=200
--elseif p["Í³ÂÊ"]==100 then
--tljy=200
--end
local color
if wljy<30 then
color=210
elseif wljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+32,x+44+len,y+103+10+32,M_Black)
if wljy>1 then
lib.SetClip(x+44,y+103+32,x+44+math.max(1,len*wljy/200),y+103+10+32)
lib.PicLoadCache(4,color*2,x+44,y+103+32,1)
end
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",math.modf(wljy/2)).."£¥"
if wljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+32,str,M_White,16)
if zljy<30 then
color=210
elseif zljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+2*32,x+44+len,y+103+10+2*32,M_Black)
if zljy>1 then
lib.SetClip(x+44,y+103+2*32,x+44+math.max(1,len*zljy/200),y+103+10+2*32)
lib.PicLoadCache(4,color*2,x+44,y+103+2*32,1)
end
lib.SetClip(0,0,0,0)
local str
str=string.format("%d",math.modf(zljy/2)).."£¥"
if zljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+2*32,str,M_White,16)
if tljy<30 then
color=210
elseif tljy<70 then
color=211
else
color=212
end
lib.FillColor(x+44,y+103+3*32,x+44+len,y+103+10+3*32,M_Black)
if tljy>1 then
lib.SetClip(x+44,y+103+3*32,x+44+math.max(1,len*tljy/200),y+103+10+3*32)
lib.PicLoadCache(4,color*2,x+44,y+103+3*32,1)
end
lib.SetClip(0,0,0,0)
local str
 str=string.format("%d",math.modf(tljy/2)).."£¥"
if tljy==200 then str="MAX"end DrawString2(x+44+60-16*#str/4,y+103-3+3*32,str,M_White,16)
end
if CC.Enhancement then
DrawString(x+16,y+220,"ƒGƒH",M_White,16)
DrawSkillTable(pid,x+56,y+220,flag)
koSkillTipTable(pid,x+56,y+220,flag)--ko 3.1: tooltip
end
--µÀ¾ß
for i=1,8 do
local tid=p["µÀ¾ß"..i]
if tid>0 then
DrawString(x+340,y+112+i*16,JY.Item[tid]["Ãû³Æ"],M_White,16)
else
if i==1 then
DrawString(x+340,y+112+i*16,"m‚CƒB ‚a‚M",M_White,16)
end
break
end
end
end

-- ExchangeItem(fid)
-- ½»»»µÀ¾ß
-- fid,¾ıÖ÷id Ò»°ãÓ¦¸ÃÊÇ1£¬Áõ±¸
-- flag, ±ê¼Ç£¬£¬Ä¬ÈÏÎªfalse£¬Èç¹ûÎªtrue£¬»áÓĞ¶îÍâÌáÊ¾¡°½»»»µÀ¾ßÂğ£¿¡±

local koRosterClass="\177\248\214\214"
local koRosterName="\208\213\195\251"
local koRosterClassName="\195\251\179\198"
local koRosterSortNames={
 [0]="\132\065\131\087","\129\071\138\075","\129\073\131\125","\130\067\131\125",
 "\132\119\132\120","\130\082\130\123","\138\072\131\126\141\074","\130\126\129\084"
}
local koRosterSortOptions={0,1,2,3,4,5,7}
local koRosterCostSortOptions={0,1,2,3,4,5,6,7}

local function koRosterClassLabel(id)
 return id==0 and "\130\066\133\114" or JY.Bingzhong[id][koRosterClassName]
end

local function koRosterClasses(ids)
 local classes,seen={0},{}
 for _,pid in ipairs(ids) do
  local id=JY.Person[pid][koRosterClass]
  if id>0 and not seen[id] and JY.Bingzhong[id] then
   classes[#classes+1]=id
   seen[id]=true
  end
 end
 table.sort(classes)
 return classes
end

local function koRosterPicker(values,label,current)
 local pageSize=5
 local pageCount=math.ceil(#values/pageSize)
 local page=1
 for i,value in ipairs(values) do
  if value==current then
   page=math.ceil(i/pageSize)
   break
  end
 end
 while pageCount>0 do
  local first=(page-1)*pageSize+1
  local last=math.min(first+pageSize-1,#values)
  local menu={}
  for i=first,last do
   local value=values[i]
   menu[#menu+1]={label(value),nil,value==current and 2 or 1}
  end

  -- Keep the page data with the rows so menu wrappers forward it too.
  menu.koPagination={page=page,count=pageCount,rows=pageSize}
  local row,delta=ShowMenu(menu,#menu,0,0,0,0,0,3,1,16,M_White,C_Name)
  if delta then
   page=page+delta
  else
   return row>0 and values[first+row-1] or nil
  end
 end
end

local function koRosterPickSort(current,costAvailable)
 local values=costAvailable and koRosterCostSortOptions or koRosterSortOptions
 return koRosterPicker(values,function(key) return koRosterSortNames[key] end,current)
end

local function koRosterSort(view,sort,cost)
 if sort==0 then return end
 local key={}
 for _,index in ipairs(view) do
  local person=JY.Person[TeamSelect.id[index]]
  if sort==1 then key[index]=koNameKey(person[koRosterName])
  elseif sort==2 then key[index]=-person["\206\228\193\166"]
  elseif sort==3 then key[index]=-person["\214\199\193\166"]
  elseif sort==4 then key[index]=-person["\205\179\194\202"]
  elseif sort==5 then key[index]=-person["\181\200\188\182"]
  elseif sort==6 then key[index]=-(cost[index] or 0)
  else key[index]=person[koRosterClass]*1000+index end
 end
 table.sort(view,function(a,b)
  if key[a]~=key[b] then return key[a]<key[b] end
  return a<b
 end)
end

local function koRosterDrawButton(button,label)
 local x,w=button.x,button.w
 lib.Background(x,390,x+w,408,160,M_Black)
 lib.DrawRect(x,390,x+w,390,M_Gray)
 lib.DrawRect(x,408,x+w,408,M_Gray)
 lib.DrawRect(x,390,x,408,M_Gray)
 lib.DrawRect(x+w,390,x+w,408,M_Gray)
 DrawString(x+w/2-#label*4,391,label,M_White,16)
end

function ExchangeItem(fid,flag)
fid=fid or 1
flag=flag or false
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=1
local current=1
local status=1--1Ñ¡ÔñµÚÒ»¸öÈË 2Ñ¡ÔñµÀ¾ß 3 Ñ¡ÔñµÚ¶ş¸öÈË
local iid=0--Ñ¡ÖĞµÄitemÎ»ÖÃ
TeamSelect={id={},status={}}
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==fid then
ReSetAttrib(i,true)
JY.Person[i]["Õ½¶·¶¯×÷"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
TeamSelect.status[num]=0--0Î´Ñ¡Ôñ 1Ñ¡Ôñ(¿ÉÈ¡Ïû) 2Ñ¡Ôñ(²»¿ÉÈ¡Ïû)
end
end
maxpage=math.modf((num-1)/6)+1
--ko 3.1: ì •ë ¬Â·ë³‘ì¢… í•„í„° (the ì¶œì§„ í™”ë©´'s view, without ì½”ìŠ¤íŠ¸ / ì„ íƒë§Œ)
local koSortK,koFilt=0,0
local koBzList=koRosterClasses(TeamSelect.id)
local view={}
local function koBuildView()
view={}
for k=1,num do
if koFilt==0 or JY.Person[TeamSelect.id[k]]["±øÖÖ"]==koFilt then view[#view+1]=k end
end
koRosterSort(view,koSortK)
maxpage=math.max(1,math.modf((#view-1)/6)+1)
if page>maxpage then page=maxpage end
end
koBuildView()
local koBtn={{x=26,w=118},{x=150,w=118}}
local function koDrawBar()
koRosterDrawButton(koBtn[1],"\129\070\131\102:"..koRosterSortNames[koSortK])
koRosterDrawButton(koBtn[2],"\130\126\129\084:"..koRosterClassLabel(koFilt))
end
--------------------------------
-- ¶¨Òå×ø±êĞÅÏ¢
--------------------------------
local xy={
x1={},--×óÉÏ½Ç(±ß¿òÄÚ£¬Êµ¼Ê²¿¶ÓÍ¼±êÏÔÊ¾Î»ÖÃ)
y1={},
x2={},--±øÁ¦
y2={},
x3={},--ĞÕÃû
y3={},
x4={},--ÓÒÏÂ½Ç
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--µ±Ç°°´Å¥
--------------------------------
--redraw()
--ÄÚ²¿º¯Êı£¬ÖØ»æ
--frame ÓÃÓÚ¿ØÖÆ¶¯»­ÏÔÊ¾
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="‚a‚M","‚J‚p„o","‚}‚D„o","‚t†I„o","ƒsƒA","‚~ƒW","‚X…X","‚}‚D„o","ƒT„h","ƒT„h","ƒT„h","IƒG","„N‚S‚w","…X„y","\130\126\136\070\131\087",}--ko 5.0 (10-13): [14] book
local titlestr="‚S†s IƒaƒP D‚w‚h „W†IXYZ? …m…naƒoZ."
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,(CC.koTavernPick and "\134\117\130\119\135\122 \129\071\133\069\131\071\129\066 \133\082\129\089\129\090? \133\109\133\110\129\097\131\111\129\090." or titlestr),M_White,16)--ko 5.0: town tavern talk
koDrawBar()--ko 3.1
for i=1,6 do
local idx=view[num_per_page*(page-1)+i]--ko 3.1: through the view
if idx==nil then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["ĞÕÃû"]
local hp=string.format("% 5d",JY.Person[pid]["×î´ó±øÁ¦"])
local lv=string.format("% 5d",JY.Person[pid]["µÈ¼¶"])
local picid
if TeamSelect.status[idx]==0 then--Î´Ñ¡ÔñÊ±£¬Îª+19
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+19
if not (rawget(_G,"koFormCardName") and koFormCardName(i,pid,xy.x1[i],xy.y1[i],xy.x3[i],xy.y3[i],(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White))) then DrawString(xy.x3[i]-4*#name,xy.y3[i],name,(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White),16) end--ko 5.0: name | formation (exchange screen)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+12+frame
if not (rawget(_G,"koFormCardName") and koFormCardName(i,pid,xy.x1[i],xy.y1[i],xy.x3[i],xy.y3[i],M_DarkOrange)) then DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16) end--ko 5.0: name | formation (exchange screen)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
koFavCardStar(i,pid,xy.x1[i],xy.y1[i])--ko 5.1: â˜… corner (also on the ë„êµ¬ êµí™˜ and ìˆ ì§‘ cards)
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
--Ñ¡ÖĞÈËÎï
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["Í·Ïñ´úºÅ"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["ĞÕÃû"],136,JY.Person[cid]["ĞÕÃû"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["±øÖÖ"]]["Ãû³Æ"],24,JY.Bingzhong[JY.Person[cid]["±øÖÖ"]]["Ãû³Æ"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["µÈ¼¶"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["Í³ÂÊ"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["ÎäÁ¦"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["ÖÇÁ¦"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--µÀ¾ß
for i=1,8 do
local tid=JY.Person[cid]["µÀ¾ß"..i]
local color=M_White
if TeamSelect.status[current]==1 and i==iid then
color=M_DarkOrange
end
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["Ãû³Æ"],color,16)
DrawString(562,176+i*18,"£¯"..((JY.Item[tid]["ÀàĞÍ"]==12 and JY.Item[tid]["×°±¸Î»"]==3) and "ƒsv" or (JY.Item[tid]["ÀàĞÍ"]==13 and JY.Item[tid]["×°±¸Î»"]==0) and "ƒT„h" or kind[JY.Item[tid]["ÀàĞÍ"]]),color,16)
else
if i==1 then
DrawString(466,176+i*18,"m‚CƒBG ‚aKLM.",M_White,16)
end
break
end
end
koHook("exchange_draw",{status=status,current=current,iid=iid,view=view,page=page,xy=xy,ids=TeamSelect.id})--ko 3.6 later: gear compare (gearcmp addon)
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
Dark()
redraw()
Light()
if flag then
if not WarDrawStrBoxYesNo('D‚w‚h „W†IXYZ?',M_White,true) then
redraw()
return
end
end
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local eventtype,keypress=getkey()
bottom=0
if eventtype==1 and (keypress==1073741899 or keypress==1073741904) then--ko 3.1: PageUp / Left
PlayWavE(0) page=limitX(page-1,1,maxpage)
elseif eventtype==1 and (keypress==1073741902 or keypress==1073741903) then--ko 3.1: PageDown / Right
PlayWavE(0) page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(koBtn[1].x,390,koBtn[1].x+koBtn[1].w,408) then--ko 3.1: sort key
PlayWavE(0)
local selected=koRosterPickSort(koSortK,false)
if selected~=nil and selected~=koSortK then
koSortK=selected
page=1
koBuildView()
end
elseif MOUSE.CLICK(koBtn[2].x,390,koBtn[2].x+koBtn[2].w,408) then--ko 3.1: class filter
PlayWavE(0)
local selected=koRosterPicker(koBzList,koRosterClassLabel,koFilt)
if selected~=nil and selected~=koFilt then
koFilt=selected
page=1
koBuildView()
end
elseif MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
Dark()
lib.Delay(1000)
koExit()
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) and status==1 then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("¡¡ƒJƒKKLY?¡¡",M_White,true) then
redraw()
if not flag then
Dark()
DrawSMap()
Light()
end
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
elseif eventtype==4 and keypress==3 then
if status==2 then
PlayWavE(1)
TeamSelect.status[current]=0
titlestr="‚S†s IƒaƒP D‚w‚h „W†IXYZ? …m…naƒoZ."
iid=0
status=1
elseif status==3 then
PlayWavE(1)
titlestr="„W†IX D‚w‚h …m…naƒoZ."
iid=0
status=2
end
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=view[num_per_page*(page-1)+i]--ko 3.1: through the view
if idx~=nil then
if status==1 then
current=idx
cid=TeamSelect.id[idx]
if JY.Person[cid]["µÀ¾ß1"]==0 then
PlayWavE(2)
titlestr=JY.Person[cid]["ĞÕÃû"].."ƒb(‚b) ^g ƒuG ‚aKLM."
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="‚S†s IƒaƒP D‚w‚h „W†IXYZ? …m…naƒoZ."
else
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="„W†IX D‚w‚h …m…naƒoZ."
status=2
end
elseif status==2 then
if TeamSelect.status[idx]==1 then
PlayWavE(1)
TeamSelect.status[idx]=0
titlestr="‚S†s IƒaƒP D‚w‚h „W†IXYZ? …m…naƒoZ."
status=1
else
PlayWavE(2)
end
elseif status==3 then
local odx=current
current=idx
cid=TeamSelect.id[idx]
local oid=TeamSelect.id[odx]
local item=JY.Person[oid]["µÀ¾ß"..iid]
if idx==odx then
--Ê²Ã´¶¼²»×ö
PlayWavE(2)
elseif JY.Person[cid]["µÀ¾ß8"]>0 then
PlayWavE(2)
titlestr=JY.Person[cid]["ĞÕÃû"].."ƒb(‚b) „l GC D‚w‚h ‚C†t q ‚aKLM."
for n=1,20 do
redraw()
lib.GetKey()
end
current=odx
titlestr=JY.Item[item]["Ãû³Æ"].."S(‚h) †u‚wfQ „{YZ?"
else
PlayWavE(0)
redraw()
local koN=koGiveAsk(oid,cid,iid)--ko 3.3: 1 or all of the same item
if koN>0 then
koGiveItems(oid,cid,iid,koN)
titlestr="‚S†s IƒaƒP D‚w‚h „W†IXYZ? …m…naƒoZ."
TeamSelect.status[odx]=0
iid=0
status=1
else
titlestr=JY.Item[item]["Ãû³Æ"].."S(‚h) †u‚wfQ „{YZ?"
current=odx
end
end
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
 cid=TeamSelect.id[current]
local item=JY.Person[cid]["µÀ¾ß"..i]
if item>0 then
if status==1 then
PlayWavE(0)
DrawItemStatus(item,cid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
elseif status==2 then
PlayWavE(0)
iid=i
titlestr=JY.Item[item]["Ãû³Æ"].."S(‚h) †u‚wfQ „{YZ?"
status=3
elseif status==3 then
if iid==i then
PlayWavE(1)
titlestr="„W†IX D‚w‚h …m…naƒoZ."
iid=0
status=2
else
PlayWavE(2)
end
end
end
break
end
end
end
end
end

--ko ‚G„N(407)¡¤‡gƒO(408) …}„o vw. „p ^‚C‚h ‚Z‚[ …^„E…E ƒH†Lf ƒv†[M
local function koHasItem(itemid)
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==1 then
for n=1,8 do
if JY.Person[i]["µÀ¾ß"..n]==itemid then
return true
end
end
end
end
return false
end
function koUnlockCamp(pid,diff3)--ko 6.0 (11-01): the three hidden lords in a story (koCamp). Liu Bang / Xiang Yu keep the base-story conditions;
--only the king milestone, chapter 4 and the five named heroes are that story's own (S below). The demon: conditions every story can meet
local S={yuanshao={king=239,kingText="3\131\097 \129\111\130\101 \138\119\138\120\130\066",ch4=311,five={13,14,37,19,36},fiveText="\130\111\132\088 \161\164 \133\090\133\099 \161\164 \131\097\129\087 \161\164 \131\100\134\118 \161\164 \129\125\131\080",sage=34,sageText="\130\066\134\083"},sunjian={king=421,kingText="\129\1003\131\097 \129\126\134\093\131\080 \136\124\132\083",ch4=439,five={3,81,54,236,221},fiveText="\135\089\130\117 \161\164 \130\124\130\114\133\120 \161\164 \135\078\135\125 \161\164 \130\075\130\124 \161\164 \130\085\134\075",sage=126,sageText="\130\075\130\071"},wuje={king=330,kingText="3\131\097 \130\110\129\103\129\064\129\097",ch4=347,five={4,217,21,18,16},fiveText="\129\097\133\067\135\093 \161\164 \129\097\133\067\133\066 \161\164 \135\109\133\102 \161\164 \131\097\129\085 \161\164 \131\087\130\085",sage=63,sageText="\132\065\132\109"}}
local K=S[CONFIG.koCamp] or {}
local c={}
local LV,ZL,WL,LORD="\181\200\188\182","\214\199\193\166","\206\228\193\166","\190\253\214\247"
local function army(f) local n=0 for i=1,JY.PersonNum-1 do local q=JY.Person[i] if q[LORD]==1 and f(q,i) then n=n+1 end end return n end
local m=JY.Base["\202\194\188\2541998"] or 0
local w=JY.Base["\202\194\188\2541999"] or 0
local tw=(rawget(_G,"koTourWins") and koTourWins()) or 0
if pid==409 then
local h=0 for _,k in ipairs({407,408}) do if JY.PersonNum>k and JY.Person[k][LORD]==1 then h=h+1 end end
local lv=(K.sage and JY.Person[K.sage][LV]) or 0
c[1]={lv>=60,string.format((K.sageText or "?").." \130\082\130\123 60 \129\071\129\067 (%d/60)",math.min(lv,60))}
c[2]={m>=100,string.format("\130\117\130\118\131\109\132\083 \131\076 \130\094\130\095 \130\112\134\086 100\130\125 (%d/100)",math.min(m,100))}
c[3]={tw>=3,string.format("\129\073\131\072 \130\095\130\125 \131\079\129\116 3\130\125 (%d/3)",math.min(tw,3))}
c[4]={h>=2,string.format("\130\071\132\078 \161\164 \135\103\131\079 \138\101 \129\077 \133\125\132\111 (%d/2)",h)}
elseif pid==408 then
local n=0 for _,k in ipairs(K.five or {}) do if (JY.Person[k][LV] or 0)>=45 then n=n+1 end end
c[1]={koHasItem(60),"\129\079\135\101\130\067\136\086\129\083 \130\067\134\109 \129\073\131\097\129\071 \132\079\129\077"}
c[2]={w>=70,string.format("\130\066\132\101 \129\116\129\117 70\130\125 (%d/70)",math.min(w,70))}
c[3]={diff3 and koStoryEv()>=(K.ch4 or koEvScale(592)),"\129\068\130\066 \130\113\129\071\129\068 3 \129\071\129\067\131\109\132\083 \129\1004\131\097 \129\068\136\071"}
c[4]={n>=5,string.format((K.fiveText or "?").." \130\082\130\123 45 (%d/5)",n)}
else
local n=army(function(q,i) return i~=407 and q[ZL]>=90 end)
c[1]={koHasItem(9),"\133\095\134\068\130\104 \130\067\134\109 \129\073\131\097\129\071 \132\079\129\077"}
c[2]={m>=50,string.format("\130\117\130\118\131\109\132\083 \131\076 \130\094\130\095 \130\112\134\086 50\130\125 (%d/50)",math.min(m,50))}
c[3]={diff3 and koStoryEv()>=(K.king or koEvScale(567)),"\129\068\130\066 \130\113\129\071\129\068 3 \129\071\129\067\131\109\132\083 "..(K.kingText or "?").." \129\068\136\071"}
c[4]={n>=5,string.format("\130\067\131\125 90 \129\071\129\067\129\106 \129\110\130\084 5\130\088 (%d/5)",math.min(n,5))}
end
local ok=true
for i=1,4 do if not c[i][1] then ok=false end end
return ok,c
end
function koUnlock(pid)--ko 3.0: global, the ë„ê° uses it too
local c={}
local diff3=(JY.Base["ÎŞÓÃ3"] or 0)>=4
if rawget(_G,"koCamp") then return koUnlockCamp(pid,diff3) end--ko 6.0 stories
if pid==409 then--ko 3.6: Demon Zhuge Liang
local m=JY.Base["ÊÂ¼ş1998"] or 0
local lv=JY.Person[126]["µÈ¼¶"] or 0
local h=0
for _,k in ipairs({407,408}) do
if JY.PersonNum>k and JY.Person[k]["¾ıÖ÷"]==1 then
h=h+1
end
end
c[1]={koHasItem(12),"\134\082\131\123\136\086\129\083 \130\067\134\109 \129\073\131\097\129\071 \132\079\129\077"}
c[2]={m>=100,string.format("\130\117\130\118\131\109\132\083 \131\076 \130\094\130\095 \130\112\134\086 100\130\125 (%d/100)",math.min(m,100))}
c[3]={lv>=60,string.format("\129\100\135\121\132\088 \130\082\130\123 60 \129\071\129\067 (%d/60)",math.min(lv,60))}
c[4]={h>=2,string.format("\131\072\134\076\131\080 \133\126\131\098 \129\073\131\097 \130\091 \130\088 \133\125\132\111 (%d/2)",h)}
elseif pid==408 then
local n=0
for _,k in ipairs({2,3,54,190,170}) do
if JY.Person[k]["µÈ¼¶"]>=45 then
n=n+1
end
end
local w=JY.Base["ÊÂ¼ş1999"] or 0
c[1]={koHasItem(60),"O‡e‚CˆVS ‚C†m IƒaG „OM"}
c[2]={w>=70,string.format("‚B„e tu 70‚} (%d/70)",math.min(w,70))}
c[3]={diff3 and koStoryEv()>=592,"D‚B ‚qGD 3 GCƒm„S d4ƒa DˆG"}
c[4]={n>=5,string.format("eƒO¡¤ƒa‚P¡¤v‡S¡¤…Xƒ|¡¤‚U‡t ‚R‚{ 45 (%d/5)",n)}
else
local n=0
for i=1,JY.PersonNum-1 do
if i~=407 and JY.Person[i]["¾ıÖ÷"]==1 and JY.Person[i]["ÖÇÁ¦"]>=90 then
n=n+1
end
end
local m=JY.Base["ÊÂ¼ş1998"] or 0
c[1]={koHasItem(9),"…_†D‚h ‚C†m IƒaG „OM"}
c[2]={m>=50,string.format("‚u‚vƒm„S ƒL ‚^‚_ ‚p†V 50‚} (%d/50)",math.min(m,50))}
c[3]={diff3 and koStoryEv()>=567,"D‚B ‚qGD 3 GCƒm„S o‚e‡e Œa‚n"}
c[4]={n>=5,string.format("‚Cƒ} 90 GCj n‚T 5‚X (%d/5)",math.min(n,5))}
end
local ok=true
for i=1,4 do
if not c[i][1] then
ok=false
end
end
return ok,c
end
function koUnlockText(pid)--ko 3.0: global, the ë„ê° uses it too
local ok,c=koUnlock(pid)
local s=(pid==409) and "\133\088\135\101\129\083 \141\090\133\091 \132\112 \129\094\130\067 \129\118\129\119" or (pid==408) and "O‡eS ŠGGX „p ^‚C vw" or "‚s‚XS …HS „p ^‚C vw"
for i=1,4 do
s=s.."*"..(c[i][1] and "O " or "X ")..c[i][2]
end
if ok then
s=s.."*vwS ‚Z‚[ …^fKLM."
else
s=s.."*‚Z‚[ …^ƒOA …}„oX q „OKLM."
end
return s
end

-- ÕĞÀ¿Îä½«
function koHireTables()--ko 3.0: ê¸°ë¡ (the same tables and gates as HirePerson)
local db={ "G†f","G‚G","@†]","‚l…a",
"Fƒs","o‡i","‚U†K","‡Y†T",
"}ƒP","‚J‡Y‡Z",
"ƒW~","G‚E","‡j‚r",
"eB","‚|‚r…x",
"‡m‚r","‡eB","‡s†_","vƒ{","ƒd„A","g†X","b†a",
"„AƒOƒ@","‚o„X","…Z…c","g‚O","‡m‚G","‡WƒG","†d†c","‡jD","‚B†S","…fq",
"g…}","ƒG‚Y",
"…X…}",
"‡e‚n","‡w‡c","‚GƒG","‚GT",
"‡N…n","ƒam","d‡y†Z","ƒY†f","‚K‚G",
"…Aƒa","b‡~",
"ƒaˆC","‚K‚|","†Q‡Y",
"ƒa‡p",
"ƒaR",
"†oq",
"‡sm",
"a…C‡]","‡j^","^…C","„N‡V","a…C…B","ƒW‚U","‚B‚n","‡m…f","‚r…XƒP","vv",--ko A: core Wei, 2nd cycle
"G‚B","„V‡T","v‡_","v‚P","…Z‡x","…vg","‚G‡u","„A‚G","„A„m",171,"vj","v†g","vg","F„m","ƒaW",--ko B: Wei, ch4 gates (171 = Niu Jin by index)
"„y‚K","‚K‚Y","‡Y‡b","G‚}","†o‚}","ƒWC","‡Y†I",--ko C: story gates
"ƒQƒH","ƒQm","‚G…q","‚J‡X","ƒa„S"} --ko D: retired lords
local db2={ 23,66,23,66,
382,592,382,9999,--ko Han Dang 592 (5.0: 4ì¥ start, town taverns need time to win him over)
226,226,
144,144,144,
103,103,
176,176,176,176,176,226,9999,
513,348,348,324,324,324,324,324,348,348,
279,279,
568,
424,424,461,461,
513,513,592,592,9999,
592,592,
592,592,592,
513,
568,
568,
592,
9999,9999,9999,9999,9999,9999,9999,9999,9999,9999,--ko A (cycle>=2, Cao Cao cycle>=3)
592,592,592,592,592,592,592,592,592,592,592,592,592,592,592,--ko B (5.0: all from 4ì¥ start)
226,279,324,513,513,592,592,--ko C
226,348,382,513,568} --ko D
local db3={
[4]=385,
[8]=386,
[12]=403,
[16]=404,
[20]=405,
[24]=388,
}
if koStreakOK(9) then
db2[8]=382--Ëï¼á
end
if koStreakOK(11) then
db2[22]=226--ÂÀ²¼
end
if koStreakOK(15) then
db2[44]=513--ÖÜè¤
end
--ko core Wei generals open from the 2nd cycle (Cao Cao from the 3rd); all after Xuchang II
if koNG.cycle()>=2 then
for kk=54,62 do
db2[kk]=592
end
end
if koNG.cycle()>=3 then
db2[63]=592
end
return db,db2,db3
end
--ko 6.0 (11-01): a 6.0 story (koCamp) reads the 6.0 tavern lists by name from its own people. koEvScale stretches a story event
--number of the 6.0 base story (it ends at 668) to the running story's length (koCamp.evMax); 9999 stays "never".
function koHireFromEv()--ko 11-07: hiring opens at the story's real chapter 1
local KC=rawget(_G,"koCamp")
if KC and KC.ch1Ev then return KC.ch1Ev end
return koEvScale(23)
end
function koEvScale(e)
local KC=rawget(_G,"koCamp")
if not KC or not KC.evMax or e>=9999 then return e end
return math.max(1,math.floor(e*KC.evMax/668+0.5))
end
function koHireLv()--tavern level base: the base story = its five heroes as before, a story = the army average
if rawget(_G,"koCamp") then return pjlv() end
return math.modf((JY.Person[1]["µÈ¼¶"]+JY.Person[2]["µÈ¼¶"]+JY.Person[3]["µÈ¼¶"]+JY.Person[54]["µÈ¼¶"]+JY.Person[126]["µÈ¼¶"])/6)-5
end
koCampExtraDone=false
function koCampTavern(db,db2)--leave out the hero, the army and the story generals (they join through the story) and numbered rows
local NAME,LORD="\208\213\195\251","\190\253\214\247"
local own={}
own[JY.Person[1][NAME]]=true
for idx=1,math.min(JY.PersonNum-1,420) do if JY.Person[idx][LORD]==1 then own[JY.Person[idx][NAME]]=true end end
local sh=koCamp.storyhire
for _,pid in ipairs((sh and sh.STORY) or {}) do if JY.Person[pid] then own[JY.Person[pid][NAME]]=true end end
for i,v in ipairs(db) do
if type(v)=="number" or own[v] or (type(rawget(_G,"koCampTavernSkip"))=="table" and koCampTavernSkip[v]) then db2[i]=9999 elseif (db2[i] or 9999)<9999 then db2[i]=koEvScale(db2[i]) end
end
if not koCampExtraDone then--the special tavern rows: 382 and below are story people here; a name the story has is a duplicate
koCampExtraDone=true
local keep={}
for _,x in ipairs(koExtraHire) do
local p=JY.Person[x[1]]
local dup=(x[1]<=382) or not p
if not dup then for idx=1,382 do if JY.Person[idx][NAME]==p[NAME] then dup=true break end end end
if not dup then if (x[2] or 0)>0 then x[2]=koEvScale(x[2]) end keep[#keep+1]=x end
end
koExtraHire=keep
end
end
function HirePerson()
local num=0
koHook("tavern_open")--ko 3.1
local koBlock=(koStoryEv()<koHireFromEv())--ko 3.2: no hiring before chapter 1 (the two prologue battles have a fixed roster)
local page=1
local maxpage=1
local num_per_page=6
local personnum=1
local current=1
TeamSelect={id={},status={}}
--ÉèÖÃĞÂÎä½«ÊôĞÔ
local db={ "G†f","G‚G","@†]","‚l…a",
"Fƒs","o‡i","‚U†K","‡Y†T",
"}ƒP","‚J‡Y‡Z",
"ƒW~","G‚E","‡j‚r",
"eB","‚|‚r…x",
"‡m‚r","‡eB","‡s†_","vƒ{","ƒd„A","g†X","b†a",
"„AƒOƒ@","‚o„X","…Z…c","g‚O","‡m‚G","‡WƒG","†d†c","‡jD","‚B†S","…fq",
"g…}","ƒG‚Y",
"…X…}",
"‡e‚n","‡w‡c","‚GƒG","‚GT",
"‡N…n","ƒam","d‡y†Z","ƒY†f","‚K‚G",
"…Aƒa","b‡~",
"ƒaˆC","‚K‚|","†Q‡Y",
"ƒa‡p",
"ƒaR",
"†oq",
"‡sm",
"a…C‡]","‡j^","^…C","„N‡V","a…C…B","ƒW‚U","‚B‚n","‡m…f","‚r…XƒP","vv",--ko A: core Wei, 2nd cycle
"G‚B","„V‡T","v‡_","v‚P","…Z‡x","…vg","‚G‡u","„A‚G","„A„m",171,"vj","v†g","vg","F„m","ƒaW",--ko B: Wei, ch4 gates (171 = Niu Jin by index)
"„y‚K","‚K‚Y","‡Y‡b","G‚}","†o‚}","ƒWC","‡Y†I",--ko C: story gates
"ƒQƒH","ƒQm","‚G…q","‚J‡X","ƒa„S"} --ko D: retired lords
local db2={ 23,66,23,66,
382,592,382,9999,--ko Han Dang 592 (5.0: 4ì¥ start, town taverns need time to win him over)
226,226,
144,144,144,
103,103,
176,176,176,176,176,226,9999,
513,348,348,324,324,324,324,324,348,348,
279,279,
568,
424,424,461,461,
513,513,592,592,9999,
592,592,
592,592,592,
513,
568,
568,
592,
9999,9999,9999,9999,9999,9999,9999,9999,9999,9999,--ko A (cycle>=2, Cao Cao cycle>=3)
592,592,592,592,592,592,592,592,592,592,592,592,592,592,592,--ko B (5.0: all from 4ì¥ start)
226,279,324,513,513,592,592,--ko C
226,348,382,513,568} --ko D
local db3={
[4]=385,
[8]=386,
[12]=403,
[16]=404,
[20]=405,
[24]=388,
}
if koStreakOK(9) then
db2[8]=382--Ëï¼á
end
if koStreakOK(11) then
db2[22]=226--ÂÀ²¼
end
if koStreakOK(15) then
db2[44]=513--ÖÜè¤
end
--ko core Wei generals open from the 2nd cycle (Cao Cao from the 3rd); all after Xuchang II
if koNG.cycle()>=2 then
for kk=54,62 do
db2[kk]=592
end
end
if koNG.cycle()>=3 then
db2[63]=592
end
if rawget(_G,"koCamp") then koCampTavern(db,db2) end--ko 6.0 stories: own side out, story timing
for i,v in pairs(db) do
local p1=JY.Person[420+i]
if p1["¾ıÖ÷"]==0 then
local kokeep=(JY.Base["ÊÂ¼ş"..(1870+i)] or 0)>0--ko 3.0: ìˆ ì§‘ í•´ê¸ˆ ê³„ìŠ¹ (record carried from the last cycle)
local p2=JY.Person[420]
if not kokeep then
if type(v)=="number" then --ko: a db entry may be a person index, for names shared by two records (171 Niu Jin vs 63 Yu Jin)
p2=JY.Person[v]
else
for idx=1,JY.PersonNum-1 do
if JY.Person[idx]["ĞÕÃû"]==v then
p2=JY.Person[idx]
break
end
end
end
for idx,par in pairs({"´úºÅ","ĞÕÃû","ÍâºÅ","ĞÔ±ğ","ÎäÁ¦","ÖÇÁ¦","Í³ÂÊ","Ìì¸³","±øÖÖ","±©»÷","Á¬»÷","»ØÂí","ÃØ¼¼1","°µÆ÷","·ÜÕ½","¼±¾È","µ×Á¦","Å­·¢","Íş·ç","²»Çü","Ç¿ÔË","Ò»»÷","ÌØ¼¼1","ÌØ¼¼2","ÌØ¼¼3","ÌØ¼¼4","ÌØ¼¼5","ÌØ¼¼6"}) do
p1[par]=p2[par]
end
p1["³É³¤"]=10
end--ko 3.0
p1["µÈ¼¶"]=koHireLv()
p1["µÈ¼¶"]=limitX(p1["µÈ¼¶"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if p1["µÈ¼¶"]<dtlv then
p1["µÈ¼¶"]=dtlv
end
end
if not kokeep then--ko 3.0
p1["Í·Ïñ´úºÅ"]=p2["Í·Ïñ´úºÅ"]--ko 3.2: keep the original portrait (the alternate set no longer replaces it)
p1["ĞÂÍ·Ïñ´úºÅ"]=db2[i]--ÓÃÕâ¸öÀ´¿¨ ¶àÉÙ¶àÉÙ¹ØÖ®ºó²ÅÄÜ¼ÓÈë
end
end
end
for i=421,math.min(JY.PersonNum-1,(rawget(_G,"koCamp") and 530) or 601) do--ko 6.0 stories: 531+ are story people there; ko 5.1 storyhire: 602+ are system records (parking, reinforcements, storehouse)
if JY.Person[i]["Í·Ïñ´úºÅ"]>0 and JY.Person[i]["ĞÂÍ·Ïñ´úºÅ"]<koStoryEv() then
ReSetAttrib(i,true)
JY.Person[i]["Õ½¶·¶¯×÷"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
if JY.Person[i]["¾ıÖ÷"]==1 then
TeamSelect.status[num]=1--0Î´Ñ¡Ôñ 1Ñ¡Ôñ
elseif koHook("tavern_slot_lock",i) then--ko 3.1: an addon keeps this tavern slot locked
TeamSelect.status[num]=2
else
TeamSelect.status[num]=0
end
end
end
for i,v in pairs(db3) do
local koShow,koLock=koHook("tavern_show",v,i),koHook("tavern_lock",v,i)--ko 3.1: db3 gates (default: ì—°ì „ >= i, no lock)
if koShow==nil then koShow=koStreakOK(i) end
if koLock==nil then koLock=false end
if koShow and koLock and JY.Person[v]["¾ıÖ÷"]~=1 then
num=num+1
TeamSelect.id[num]=v
TeamSelect.status[num]=2
elseif koShow then
ReSetAttrib(v,true)
JY.Person[v]["Õ½¶·¶¯×÷"]=GetPic(v,false,false)
num=num+1
TeamSelect.id[num]=v
if JY.Person[v]["¾ıÖ÷"]==1 then
TeamSelect.status[num]=1--0Î´Ñ¡Ôñ 1Ñ¡Ôñ
else
JY.Person[v]["³É³¤"]=10
JY.Person[v]["µÈ¼¶"]=koHireLv()
JY.Person[v]["µÈ¼¶"]=limitX(JY.Person[v]["µÈ¼¶"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if JY.Person[v]["µÈ¼¶"]<dtlv then
JY.Person[v]["µÈ¼¶"]=dtlv
end
end
TeamSelect.status[num]=0
end
end
end
for _,koX in ipairs(koExtraHire) do--ko 3.6: new tavern generals (own records, story gate or last cycle's hire)
local v=koX[1]
if JY.PersonNum>v and JY.Person[v]["Í·Ïñ´úºÅ"]>0 and (JY.Person[v]["¾ıÖ÷"]==1 or (koStoryEv()>koX[2] and koExtraReq(koX)) or ((JY.Base["ÊÂ¼ş"..koX[3]] or 0)>0 and ((not koX[5]) or koStoryEv()>koX[2]))) then--koCarryGate 5.0 (10-11)
ReSetAttrib(v,true)
JY.Person[v]["Õ½¶·¶¯×÷"]=GetPic(v,false,false)
num=num+1
TeamSelect.id[num]=v
if JY.Person[v]["¾ıÖ÷"]==1 then
TeamSelect.status[num]=1
else
JY.Person[v]["³É³¤"]=10
JY.Person[v]["µÈ¼¶"]=koHireLv()
JY.Person[v]["µÈ¼¶"]=limitX(JY.Person[v]["µÈ¼¶"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if JY.Person[v]["µÈ¼¶"]<dtlv then
JY.Person[v]["µÈ¼¶"]=dtlv
end
end
TeamSelect.status[num]=0
end
end
end
--ko ‚G„N(407)¡¤‡gƒO(408): „p vwS M …^ƒOA …}„o …Cƒs, nLA £¿£¿£¿ „S„V ƒsjM(status 2)
for _,v in ipairs({407,408,409}) do--ko 6.0: in a story their conditions come from koUnlockCamp
if JY.PersonNum>v then
local ok=koUnlock(v) or (JY.Base["ÊÂ¼ş"..(v==409 and 1973 or 1969+v-407)] or 0)>0--ko 3.0: ìˆ ì§‘ í•´ê¸ˆ ê³„ìŠ¹
if ok or JY.Person[v]["¾ıÖ÷"]==1 then
ReSetAttrib(v,true)
JY.Person[v]["Õ½¶·¶¯×÷"]=GetPic(v,false,false)
num=num+1
TeamSelect.id[num]=v
if JY.Person[v]["¾ıÖ÷"]==1 then
TeamSelect.status[num]=1
else
JY.Person[v]["³É³¤"]=10
JY.Person[v]["µÈ¼¶"]=koHireLv()
JY.Person[v]["µÈ¼¶"]=limitX(JY.Person[v]["µÈ¼¶"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if JY.Person[v]["µÈ¼¶"]<dtlv then
JY.Person[v]["µÈ¼¶"]=dtlv
end
end
TeamSelect.status[num]=0
end
else
num=num+1
TeamSelect.id[num]=v
TeamSelect.status[num]=2
end
end
end
for _,koV in ipairs(koHook("tavern_more") or {}) do num=num+1 TeamSelect.id[num]=koV TeamSelect.status[num]=0 end--ko 5.1 storyhire (10-14): story generals offered from the 2nd cycle
do--ko 3.0: drop the locked (???) entries
local id,st,n={},{},0
local koTT=CC.koTavernTown--ko 5.0: town taverns (a town's inn: only the generals staying there)
local koStay=rawget(_G,"koTavernStay")
for k=1,num do if TeamSelect.status[k]==0 and (koTT==nil or (koStay and koStay(JY.Person[TeamSelect.id[k]]["ĞÕÃû"])==koTT)) then n=n+1 id[n]=TeamSelect.id[k] st[n]=TeamSelect.status[k] end end
TeamSelect.id=id TeamSelect.status=st num=n
end
if num==0 then
WarDrawStrBoxConfirm(CC.koTavernTown and "‚Cƒg G ‚K‡Ff ŠcI‚b ‚r†vG ‚aKLM." or "‚Cƒgƒb …}„oX IƒaG ‚aKLM.",M_White,true)
return
end
local koSortK,koFilt=0,0
local koBzList=koRosterClasses(TeamSelect.id)
local koBtn={{x=26,w=118},{x=150,w=118}}
local view={}
local function koBuildView()
view={}
for index,pid in ipairs(TeamSelect.id) do
if koFilt==0 or JY.Person[pid][koRosterClass]==koFilt then view[#view+1]=index end
end
koRosterSort(view,koSortK)
maxpage=math.max(1,math.ceil(#view/num_per_page))
current=view[1]
end
koBuildView()
--------------------------------
-- ¶¨Òå×ø±êĞÅÏ¢
--------------------------------
local xy={
x1={},--×óÉÏ½Ç(±ß¿òÄÚ£¬Êµ¼Ê²¿¶ÓÍ¼±êÏÔÊ¾Î»ÖÃ)
y1={},
x2={},--±øÁ¦
y2={},
x3={},--ĞÕÃû
y3={},
x4={},--ÓÒÏÂ½Ç
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--µ±Ç°°´Å¥
local function GetPersonValue(pid)
--¼ÆËãÕĞÀ¿¼Û¸ñ
local p=JY.Person[pid]
local v=40000/(120-math.min(p["ÎäÁ¦"],119))+40000/(120-math.min(p["ÖÇÁ¦"],119))+40000/(120-math.min(p["Í³ÂÊ"],119))
if p["±øÖÖ"]==14 then
v=v+200
elseif p["±øÖÖ"]==15 then
v=v+300
elseif p["±øÖÖ"]==16 then
v=v+1000
elseif p["±øÖÖ"]==17 then
v=v+400
elseif p["±øÖÖ"]>=20 then
v=v+800
end
if koCost~=nil and koCostOf~=nil then --ko: hire price = stat base + cost tier, so cost 10 (Cao Cao, Lu Bu, Xiang Yu) lands near 20000 gold
v=100*math.modf(v/100)
v=limitX(v,500,10000)
v=math.modf(v/2)
local kotier={[1]=0,[2]=300,[3]=700,[4]=1200,[5]=2000,[6]=3000,[7]=4500,[8]=7000,[9]=11000,[10]=18000}
local kot=kotier[koCostOf(pid)] or 0
if ({[385]=1,[386]=1,[388]=1,[403]=1,[404]=1,[405]=1,[428]=1,[442]=1,[464]=1})[pid] then --ko: puzzle-streak reward generals (incl. Sun Jian/Lu Bu/Zhou Yu copies) pay half the tier
kot=math.modf(kot/2)
end
local koK=(pid>=421 and pid<=510 and 1870+pid-420)--koCarryCap 5.0 (10-11): 1870+slot-420 only up to slot 510 (511+ would hit 1961~1999 / no flag 2000+) or ((pid==407 or pid==408) and 1969+pid-407) or (pid==409 and 1973) or koExtraEv[pid]--ko 5.0: carried tavern generals (unlocked in an earlier cycle) cost half from cycle 2
if koK and (JY.Base["ÊÂ¼ş"..koK] or 0)>0 and type(CC.koNG)=="table" and CC.koNG.cycle and CC.koNG.cycle()>1 then return math.modf((v+kot)/2) end
return v+kot
end
if p["ĞÕÃû"]=="I‡p" then
v=v+1000
end
if p["ĞÕÃû"]=="‚|‚r…x" then
v=v+1000
end
if p["ĞÕÃû"]=="ƒY‚C†d" then
v=v+2000
end
if p["ĞÕÃû"]=="ƒ|…m" then
v=v+1500
end
if p["ĞÕÃû"]=="gƒw" then
v=v+2500
end
if p["ĞÕÃû"]=="†qƒL" then
v=v+3000
end
if p["ĞÕÃû"]=="‚G„N" then
v=v+3000
end
if p["ĞÕÃû"]=="‡gƒO" then
v=v+4000
end
if p["ĞÕÃû"]=="hnc" or p["ĞÕÃû"]=="\131\99\129\106" then
v=v+3000
end
if p["ĞÕÃû"]=="b†a" then
v=v+4000
end
if p["ĞÕÃû"]=="‚K‚G" then
v=v+2500
end
v=100*math.modf(v/100)
v=limitX(v,500,10000)
v=math.modf(v/2)--½µµÍÕĞÀ¿¼Û¸ñ
return v
end
--------------------------------
--redraw()
-- ÄÚ²¿º¯Êı£¬ÖØ»æ
-- frame ÓÃÓÚ¿ØÖÆ¶¯»­ÏÔÊ¾
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="‚a‚M","‚J‚p„o","‚}‚D„o","‚t†I„o","ƒsƒA","‚~ƒW","‚X…X","‚}‚D„o","ƒT„h","ƒT„h","ƒT„h","IƒG","„N‚S‚w","…X„y","\130\126\136\070\131\087",}--ko 5.0 (10-13): [14] book
local titlestr=(koBlock and "1\131\097\129\102 \131\082\130\083\129\094\129\065 \133\125\132\111\129\088 \129\113 \132\079\129\075\129\076\129\077." or "‚S†s IƒaS …}„oXYZ? …m…naƒoZ.")
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,(CC.koTavernPick and "\134\117\130\119\135\122 \129\071\133\069\131\071\129\066 \133\082\129\089\129\090? \133\109\133\110\129\097\131\111\129\090." or titlestr),M_White,16)--ko 5.0: town tavern talk
koRosterDrawButton(koBtn[1],"\129\070\131\102:"..koRosterSortNames[koSortK])
koRosterDrawButton(koBtn[2],"\130\126\129\084:"..koRosterClassLabel(koFilt))
for i=1,6 do
local idx=view[num_per_page*(page-1)+i]
if not idx then break end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["ĞÕÃû"]
local hp=string.format("% 5d",JY.Person[pid]["×î´ó±øÁ¦"])
local lv=string.format("% 5d",JY.Person[pid]["µÈ¼¶"])
local picid
if TeamSelect.status[idx]==2 then--ko locked
name="£¿£¿£¿" hp="    ?" lv="    ?"
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,64)
DrawString(xy.x1[i]+16,xy.y1[i]+16,"£¿",M_White,16)
elseif TeamSelect.status[idx]==0 then--Î´Ñ¡ÔñÊ±£¬Îª+19
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,(koBlock and M_Gray or M_White),16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
if CC.koTavernPick and rawget(_G,"koTavernCard") then koTavernCard(pid,xy.x1[i],xy.y1[i]) end--ko 5.0: town tavern talk (affinity on the card)
else
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
koFavCardStar(i,pid,xy.x1[i],xy.y1[i])--ko 5.1: â˜… corner (also on the ë„êµ¬ êµí™˜ and ìˆ ì§‘ cards)
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
--Ñ¡ÖĞÈËÎï
cid=TeamSelect.id[current]
local kolock=(TeamSelect.status[current]==2)--ko ‡dŒI ‡gƒcƒb F…r‚h …~ŒIM
lib.PicLoadCache(2,(kolock and 1239 or JY.Person[cid]["Í·Ïñ´úºÅ"])*2,464,32,1)
local koname=kolock and "£¿£¿£¿" or JY.Person[cid]["ĞÕÃû"]
local kobzn=kolock and "£¿£¿£¿" or JY.Bingzhong[JY.Person[cid]["±øÖÖ"]]["Ãû³Æ"]
DrawString(489-3*#koname,136,koname,M_White,16)
DrawString(584-4*#kobzn,24,kobzn,M_White,16)
local function kov(x) if kolock then return "    ?" end return string.format("% 5d",x) end
DrawString(585,48,kov(JY.Person[cid]["µÈ¼¶"]),M_White,16)
DrawString(585,80,kov(JY.Person[cid]["Í³ÂÊ"]),M_White,16)
DrawString(585,112,kov(JY.Person[cid]["ÎäÁ¦"]),M_White,16)
DrawString(585,144,kov(JY.Person[cid]["ÖÇÁ¦"]),M_White,16)
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--µÀ¾ß
if kolock then
DrawString(466,194,"vwƒb ƒ[‚OS S…e ij",M_White,16)
end
for i=1,(kolock and 0 or 8) do
local tid=JY.Person[cid]["µÀ¾ß"..i]
local color=M_White
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["Ãû³Æ"],color,16)
DrawString(562,176+i*18,"£¯"..((JY.Item[tid]["ÀàĞÍ"]==12 and JY.Item[tid]["×°±¸Î»"]==3) and "ƒsv" or (JY.Item[tid]["ÀàĞÍ"]==13 and JY.Item[tid]["×°±¸Î»"]==0) and "ƒT„h" or kind[JY.Item[tid]["ÀàĞÍ"]]),color,16)
else
if i==1 then
DrawString(466,176+i*18,"m‚CƒBG ‚aKLM.",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
Dark()
redraw()
Light()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local eventtype,keypress=getkey()
bottom=0
if MOUSE.CLICK(koBtn[1].x,390,koBtn[1].x+koBtn[1].w,408) then
PlayWavE(0)
local selected=koRosterPickSort(koSortK,false)
if selected~=nil and selected~=koSortK then
koSortK=selected
page=1
koBuildView()
end
elseif MOUSE.CLICK(koBtn[2].x,390,koBtn[2].x+koBtn[2].w,408) then
PlayWavE(0)
local selected=koRosterPicker(koBzList,koRosterClassLabel,koFilt)
if selected~=nil and selected~=koFilt then
koFilt=selected
page=1
koBuildView()
end
elseif MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
Dark()
lib.Delay(1000)
koExit()
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("¡¡ƒJƒKKLY?¡¡",M_White,true) then
redraw()
Dark()
DrawSMap()
Light()
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
if TeamSelect.status[current]==2 then
talk(369,koHook("tavern_lock_text",cid) or koUnlockText(cid))
else
PersonStatus(cid,"","",1)
end
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=view[num_per_page*(page-1)+i]
if idx then
current=idx
cid=TeamSelect.id[idx]
if TeamSelect.status[idx]==2 then--ko locked: show conditions
PlayWavE(0)
redraw()
talk(369,koHook("tavern_lock_text",cid) or koUnlockText(cid))
elseif TeamSelect.status[idx]==0 and koBlock then--ko 3.2: locked until chapter 1
PlayWavE(2)
redraw()
WarDrawStrBoxConfirm("\129\110\132\076\131\098 \133\125\132\111\129\088 \129\113 \130\097\129\075\129\076\129\077.*1\131\097\129\102 \131\082\130\083\129\094\129\065 \133\125\132\111\129\088 \129\113 \132\079\129\075\129\076\129\077.*\131\087\131\097 \130\066\132\101\130\098 \133\098\130\066 \129\073\131\097\129\071 \131\100\129\070\129\104\129\076\129\077.",M_White,true)
elseif TeamSelect.status[idx]==0 and CC.koTavernPick then--ko 5.0: town tavern talk: the town addon meets him in the ì£¼ì 
PlayWavE(0)
CC.koTavernPick={pid=cid,price=GetPersonValue(cid)}
redraw()
Dark()
DrawSMap()
Light()
return
elseif TeamSelect.status[idx]==0 then
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="…}„o: "..JY.Person[cid]["ĞÕÃû"].."£®"
redraw()
PersonStatus(cid,"","",2)
redraw()
local v=GetPersonValue(cid)
if WarDrawStrBoxYesNo("‚P„o "..v.."ƒg, …}„o: "..JY.Person[cid]["ĞÕÃû"]..". ƒJƒKKLY?",M_White,true) then
redraw()
if v>koGold() then
PlayWavE(2)
TeamSelect.status[idx]=0
titlestr="‚UƒgG ‚^„RWLM."
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="‚S†s IƒaS …}„oXYZ? …m…naƒoZ."
else
UseMoney(v)
TeamSelect.status[idx]=1
ModifyForce(cid,1)
if koStoryMarkTavernHire then koStoryMarkTavernHire(cid) end
if cid==409 and (CC.koEntrance or 2)>0 then koDemonEntrance() end--ko 3.6: Demon Zhuge Liang's entrance
koHeroEntrance(cid)--ko 3.6: Mok-in / To-in / Xiang Yu / Liu Bang entrances
PlayWavE(11)
DrawStrBoxCenter(JY.Person[cid]["ĞÕÃû"].."G(^) ‚^a^ „C„kM.")
end
else
TeamSelect.status[idx]=0
titlestr="‚S†s IƒaS …}„oXYZ? …m…naƒoZ."
end
else
PlayWavE(2)
titlestr=JY.Person[cid]["ĞÕÃû"].."ƒb(‚b) G†w ‚^ahLM."
for n=1,20 do
redraw()
lib.GetKey()
end
titlestr="‚S†s IƒaS …}„oXYZ? …m…naƒoZ."
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
cid=TeamSelect.id[current]
local item=JY.Person[cid]["µÀ¾ß"..i]
if item>0 and TeamSelect.status[current]~=2 then --ko locked entry: hide item info
PlayWavE(0)
DrawItemStatus(item,cid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
end
break
end
end
end
end
end

-- ¾­µäÄ£Ê½Á·Îä³¡
function Maidan(fid)
fid=fid or 1
local m_pid={}
local m_eid={}
local num_pid,num_eid=0,0
local lv_max=math.modf((JY.Person[1]["µÈ¼¶"]+JY.Person[2]["µÈ¼¶"]+JY.Person[3]["µÈ¼¶"]+JY.Person[54]["µÈ¼¶"]+JY.Person[126]["µÈ¼¶"])/6)-5
lv_max=limitX(lv_max,1,99)
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==fid then
if JY.Person[i]["µÈ¼¶"]<lv_max then
num_pid=num_pid+1
m_pid[num_pid]=i
end
else
num_eid=num_eid+1
m_eid[num_eid]=i
end
end
if num_pid>0 and num_eid>10 then
talk(369,"†u^ Ik‚h †x†yKLY?")
local pid=FightSelectMenu(m_pid)
if pid<=0 then
talk(369,"ƒ[†{, M‚Mf M‚V G…EƒGa‚CZ.")
return
end
local eid=m_eid[math.random(num_eid)]
talk(369,"ƒ[†{, ‚VJW‚VM.")
local magic={}
for mid=1,JY.MagicNum-1 do
 magic[mid]=false
if HaveMagic(pid,mid) then
magic[mid]=true
end
end
local s={0,1,2,4,6}
if fight(pid,eid,s[math.random(5)])==1 then
talk(369,"†|†}a‚TZ!")
PlayWavE(11)
LvUp(pid)
JY.Person[pid]["¾­Ñé"]=0
DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."ƒP ‚R‚{G ƒi„gM!")
else
talk(369,"†~ƒm„S n‡@‚TZ.")
DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‡Aƒb ƒ@…US …V„kM.")
JY.Person[pid]["¾­Ñé"]=JY.Person[pid]["¾­Ñé"]+30
if JY.Person[pid]["¾­Ñé"]>=100 then
PlayWavE(11)
LvUp(pid)
JY.Person[pid]["¾­Ñé"]=0
DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."ƒP ‚R‚{G ƒi„gM!")
end
end
else
talk(369,"Ik‚h †xS ‚r†vG ‚aKLM.")
end
end

-- ×İºáÄ£Ê½Á·Îä³¡
function Maidan2(fid)
fid=fid or 1
local m_pid={}
local m_eid={}
local num_pid,num_eid=0,0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["ĞŞÁ¶"]==0 then
if JY.Person[i]["¾ıÖ÷"]==fid then
num_pid=num_pid+1
m_pid[num_pid]=i
else
num_eid=num_eid+1
m_eid[num_eid]=i
end
end
end
if num_pid>0 and num_eid>10 then
talk(369,"†u^ Ik‚h †x†yKLY?")
local pid=FightSelectMenu(m_pid)
if pid<=0 then
talk(369,"ƒ[†{, M‚Mf M‚V G…EƒGa‚CZ.")
return
end
local dj_flag=0
for n=1,8 do
	if JY.Person[pid]["µÀ¾ß"..n]==0 then
                	dj_flag=1
                	break
            	end
end
if dj_flag==0 then
	talk(369,"G jƒAƒb m‚CƒBG ^ƒD „MKLM. o ‡BS ‚PƒOƒd M‚V qƒxaƒoZ.")
	return
end
local eid=m_eid[math.random(num_eid)]
talk(369,"ƒ[†{, ‚VJW‚VM.")
local magic={}
for mid=1,JY.MagicNum-1 do
 magic[mid]=false
if HaveMagic(pid,mid) then
magic[mid]=true
end
end
local s={0,1,2,4,6}
if fight(pid,eid,s[math.random(5)])==1 then
--talk(369,"Õæ¾«²Ê£¡")
--PlayWavE(11)
JY.Person[pid]["ĞŞÁ¶"]=1
local exped=math.random(2)
local sljy=10	--Ê¤Àû¾­Ñé£¨ÍÆ¼ö5-10Ö®¼ä£©
if (JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["ÎäÁ¦"] and JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÖÇÁ¦"]>=zlyz) or  (JY.Person[pid]["±øÖÖ"]==13 or JY.Person[pid]["±øÖÖ"]==16 or JY.Person[pid]["±øÖÖ"]==19 or JY.Person[pid]["±øÖÖ"]==26) then
	if JY.Person[pid]["ÖÇÁ¦"]<=koNG.cap() then
		JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]+sljy
		DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‚Cƒ} ƒ@…US …V„kM "..sljy)
		if JY.Person[pid]["ÖÇÁ¦¾­Ñé"]>=200 then
			JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=72
                				break
            				end
			end
		end
	elseif JY.Person[pid]["Í³ÂÊ"]<=koNG.cap() then
		JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+sljy
		DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) „w„x ƒ@…US …V„kM "..sljy)
		if JY.Person[pid]["Í³ÂÊ¾­Ñé"]>=200 then
			JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=73
                				break
            				end
			end
		end
	end
else
	if (JY.Person[pid]["ÎäÁ¦"]>=wlyz  and JY.Person[pid]["ÎäÁ¦"]>=JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÎäÁ¦"]<=koNG.cap()) or JY.Person[pid]["Í³ÂÊ"]>=koNG.cap()  or JY.Person[pid]["´úºÅ"]==2 then
		JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]+sljy
		DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) Iƒ} ƒ@…US …V„kM "..sljy)
		if JY.Person[pid]["ÎäÁ¦¾­Ñé"]>=200 then
			JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) Iƒ}ƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=71
                				break
            				end
			end
		end
	elseif JY.Person[pid]["Í³ÂÊ"]<=koNG.cap() then
		JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+sljy
		DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) „w„x ƒ@…US …V„kM "..sljy)
		if JY.Person[pid]["Í³ÂÊ¾­Ñé"]>=200 then
			JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=73
                				break
            				end
			end
		end
	end
end
else
talk(369,"†~ƒm„S n‡@‚TZ.")
JY.Person[pid]["ĞŞÁ¶"]=1
local exped=math.random(2)
if JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["ÎäÁ¦"] and JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÖÇÁ¦"]>=70 then
	if JY.Person[pid]["ÖÇÁ¦"]<=koNG.cap() then
		JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]+2
		DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‡C…yƒP ‚Cƒ} ƒ@…US …V„kM.")
		if JY.Person[pid]["ÖÇÁ¦¾­Ñé"]>=200 then
			JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=72
                				break
            				end
			end
		end
	elseif JY.Person[pid]["Í³ÂÊ"]<=koNG.cap() then
		JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+2
		DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‡C…yƒP „w„x ƒ@…US …V„kM.")
		if JY.Person[pid]["Í³ÂÊ¾­Ñé"]>=200 then
			JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=73
                				break
            				end
			end
		end
	end
else
if JY.Person[pid]["ÎäÁ¦"]>=80  and JY.Person[pid]["ÎäÁ¦"]<=koNG.cap() then
	JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]+2
	DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‡C…yƒP Iƒ} ƒ@…US …V„kM.")
	if JY.Person[pid]["ÎäÁ¦¾­Ñé"]>=200 then
		JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]-200
		PlayWavE(12)
		WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) Iƒ}ƒP ƒT„h aƒv‚h …V„kM",M_White)
		for n=1,8 do
			if JY.Person[pid]["µÀ¾ß"..n]==0 then
                			JY.Person[pid]["µÀ¾ß"..n]=71
                			break
            			end
		end
	end
elseif JY.Person[pid]["Í³ÂÊ"]<=koNG.cap() then
	JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+2
	DrawStrBoxCenter(JY.Person[pid]["ĞÕÃû"].."G(^) ‡C…yƒP „w„x ƒ@…US …V„kM.")
	if JY.Person[pid]["Í³ÂÊ¾­Ñé"]>=200 then
		JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]-200
		PlayWavE(12)
		WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h …V„kM",M_White)
		for n=1,8 do
			if JY.Person[pid]["µÀ¾ß"..n]==0 then
                			JY.Person[pid]["µÀ¾ß"..n]=73
                			break
            			end
		end
	end
end
end
end
else
talk(369,"Ik‚h †xS ‚r†vG ‚aKLM.")
end
end

function qtxl()
local xljy=10	--ĞŞÁ¶¾­Ñé£¨ÍÆ¼ö5-10Ö®¼ä£©
local wlg_cnt=0
local zlg_cnt=0
local tsg_cnt=0
local xl_cnt=0
local full_cnt=0
local fullmenu={}
local mymenu={}
local pid,empty_flag
local full_id

for i=1,JY.PersonNum-1 do
	fullmenu[i]={"",nil,0}	
	if JY.Person[i]["ĞŞÁ¶"]==0 and JY.Person[i]["¾ıÖ÷"]==1 then
		pid=i		
		if (JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["ÎäÁ¦"] and JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÖÇÁ¦"]>=zlyz) or  (JY.Person[pid]["±øÖÖ"]==13 or JY.Person[pid]["±øÖÖ"]==16 or JY.Person[pid]["±øÖÖ"]==19 or JY.Person[pid]["±øÖÖ"]==26) then
			if JY.Person[pid]["ÖÇÁ¦¾­Ñé"]+xljy<200 then
				JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]+xljy
				JY.Person[pid]["ĞŞÁ¶"]=1
				xl_cnt=xl_cnt+1
			else
				empty_flag=0
				for n=1,8 do
					if JY.Person[pid]["µÀ¾ß"..n]==0 then
						JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]+xljy-200		
						JY.Person[pid]["µÀ¾ß"..n]=72
						zlg_cnt=zlg_cnt+1
						JY.Person[pid]["ĞŞÁ¶"]=1
						xl_cnt=xl_cnt+1
                					empty_flag=1
                					break
            					end
				end
				if empty_flag==0 then				
					fullmenu[i]={fillblank(JY.Person[pid]["ĞÕÃû"],11),nil,1}
					full_cnt=full_cnt+1
				end		
			end
		elseif JY.Person[pid]["ÎäÁ¦"]>=wlyz  and JY.Person[pid]["ÎäÁ¦"]>=JY.Person[pid]["Í³ÂÊ"] then
			if JY.Person[pid]["ÎäÁ¦¾­Ñé"]+xljy<200 then
				JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]+xljy
				JY.Person[pid]["ĞŞÁ¶"]=1
				xl_cnt=xl_cnt+1
			else
				empty_flag=0
				for n=1,8 do
					if JY.Person[pid]["µÀ¾ß"..n]==0 then
						JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]+xljy-200		
						JY.Person[pid]["µÀ¾ß"..n]=71
						wlg_cnt=wlg_cnt+1
						JY.Person[pid]["ĞŞÁ¶"]=1
						xl_cnt=xl_cnt+1
                					empty_flag=1
                					break
            					end
				end
				if empty_flag==0 then					
					fullmenu[i]={fillblank(JY.Person[pid]["ĞÕÃû"],11),nil,1}
					full_cnt=full_cnt+1
				end		
			end
		else
			if JY.Person[pid]["Í³ÂÊ¾­Ñé"]+xljy<200 then
				JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+xljy
				JY.Person[pid]["ĞŞÁ¶"]=1
				xl_cnt=xl_cnt+1
			else
				empty_flag=0
				for n=1,8 do
					if JY.Person[pid]["µÀ¾ß"..n]==0 then
						JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+xljy-200		
						JY.Person[pid]["µÀ¾ß"..n]=73
						tsg_cnt=tsg_cnt+1
						JY.Person[pid]["ĞŞÁ¶"]=1
						xl_cnt=xl_cnt+1
                					empty_flag=1
                					break
            					end
				end
				if empty_flag==0 then								
					fullmenu[i]={fillblank(JY.Person[pid]["ĞÕÃû"],11),nil,1}
					full_cnt=full_cnt+1					
				end		
			end
		end
	end
end

if full_cnt>0 then
	talk(369,"qƒx ƒ{‚J "..xl_cnt.."‚X, Iƒ}ƒP ƒT„h "..wlg_cnt.."†K, ‚Cƒ}ƒP ƒT„h "..zlg_cnt.."†K, „w„xƒP ƒT„h "..tsg_cnt.."†K. M‚M "..full_cnt.."‚X IƒaƒP m‚CƒBS Fuo ‡D M‚V ‚VD: ")
	ShowMenu(fullmenu,JY.PersonNum-1,0,0,156,0,0,6,1,16,M_White,M_White)
else
	talk(369,xl_cnt.."‚X Iƒa ‚BƒQ qƒx ƒ{‚J, Iƒ}ƒP ƒT„h "..wlg_cnt.."†K, ‚Cƒ}ƒP ƒT„h "..zlg_cnt.."†K, „w„xƒP ƒT„h "..tsg_cnt.."†K.")
end
end


function tlzz()	
local zljy=0
local wljy=0
local tsjy=0
local zlz_cnt=0
local wlz_cnt=0
local tsz_cnt=0
for i=1,JY.PersonNum-1 do
	if JY.Person[i]["¾ıÖ÷"]==1 or JY.Person[i]["ĞÕÃû"]=="‚G‚P" then
		zljy=zljy+JY.Person[i]["ÖÇÁ¦¾­Ñé"]
		wljy=wljy+JY.Person[i]["ÎäÁ¦¾­Ñé"]
		tsjy=tsjy+JY.Person[i]["Í³ÂÊ¾­Ñé"]
	end
end
for i=1,JY.PersonNum-1 do
	if wljy>=200 then
		if  JY.Person[i]["¾ıÖ÷"]==1 then
			for n=1,6 do
				if JY.Person[i]["µÀ¾ß"..n]==0 and wljy>=200 then
         					JY.Person[i]["µÀ¾ß"..n]=71
					wljy=wljy-200  
					wlz_cnt=wlz_cnt+1			          		
           				end
			end		
		end
	else
		break		
	end		
end
for i=1,JY.PersonNum-1 do	
	if JY.Person[i]["¾ıÖ÷"]==1 then
		JY.Person[i]["ÎäÁ¦¾­Ñé"]=0
	end	
end
JY.Person[1]["ÎäÁ¦¾­Ñé"]=wljy

for i=1,JY.PersonNum-1 do
	if zljy>=200 then
		if  JY.Person[i]["¾ıÖ÷"]==1 then
			for n=1,6 do
				if JY.Person[i]["µÀ¾ß"..n]==0 and zljy>=200 then
         					JY.Person[i]["µÀ¾ß"..n]=72
					zljy=zljy-200  
					zlz_cnt=zlz_cnt+1			          		
           				end
			end		
		end
	else
		break		
	end		
end
for i=1,JY.PersonNum-1 do	
	if JY.Person[i]["¾ıÖ÷"]==1 then
		JY.Person[i]["ÖÇÁ¦¾­Ñé"]=0		
	end	
end
JY.Person[1]["ÖÇÁ¦¾­Ñé"]=zljy

for i=1,JY.PersonNum-1 do
	if tsjy>=200 then
		if  JY.Person[i]["¾ıÖ÷"]==1 then
			for n=1,6 do
				if JY.Person[i]["µÀ¾ß"..n]==0 and tsjy>=200 then
         					JY.Person[i]["µÀ¾ß"..n]=73
					tsjy=tsjy-200  
					tsz_cnt=tsz_cnt+1			          		
           				end
			end		
		end
	else
		break		
	end		
end
for i=1,JY.PersonNum-1 do	
	if JY.Person[i]["¾ıÖ÷"]==1 then
		JY.Person[i]["Í³ÂÊ¾­Ñé"]=0		
	end	
end
JY.Person[1]["Í³ÂÊ¾­Ñé"]=tsjy
DrawStrBoxCenter("Iƒ}ƒP ƒT„h "..wlz_cnt.."†K, ‚Cƒ}ƒP ƒT„h "..zlz_cnt.."†K, „w„xƒP ƒT„h "..tsz_cnt.."†K, Fu^ „sZ")

end

function koShopP(iid)--ko 5.0 (10-13): the buying price (x10 gold) with the trial ã€Œìƒì  ê°€ê²©ã€
local p=JY.Item[iid]["¼ÛÖµ"]
local f=rawget(_G,"koTrialShopPct")
if f then p=math.floor(p*(100+f())/100) end
return p
end
function Shop()
local sid=JY.Base["D‚wC"]
if sid<=0 then
PlayWavE(2)
WarDrawStrBoxConfirm("G‡Ef‚b D‚w‡FG ‚aKLM.",M_White,true)
return
end
local shopitem={
[1]={71,72,73,41,28,31},--ãáË®¹ØÖ®Õ½Ç°,³ÂÁô
[2]={71,72,73,28,31,44},--»¢ÀÎ¹ØÖ®Õ½ºó,±±Æ½
[3]={28,31,53,41,38,35},--ĞÅ¶¼³ÇÖ®Õ½ºó,ĞÅ¶¼
[4]={28,31,53},--¹ã´¨Ö®Õ½ºó,¹ã´¨
--±±º£Ö®Õ½Ç°,±±Æ½/ĞÅ¶¼
[5]={28,31,53,41,38,35,34},--±±º£Ö®Õ½ºó,±±Æ½/ĞÅ¶¼/±±º£,ÕâÀïÖ»ÁĞÁË±±º£µÄ
[6]={28,31,53,50,47},--ĞìÖİIÖ®Õ½ºó,±±Æ½/ĞÅ¶¼/±±º£/ĞìÖİ/ÏÂÚü£¬ÕâÀïÖ»ÁĞµÄĞìÖİµÄ
--ÏÂÚüµÄ 31,32,50,47,34
[7]={20,22,24,26,41,38,35},--Ğ¡Åæ
[8]={20,22,24,26,28,29,31,53},--Ğí²ıI
[9]={31,32,50,47,34},--ÏÂÚü
[10]={20,22,24,26,29,31,32,53},--Úş
[11]={41,38,39,35,44},--°×Âí
[12]={41,42,38,39,35,36},--ÈêÄÏ
[13]={20,22,24,26,29,32,53,34},--ÏåÑôI
[14]={42,39,36,44,45},--½­ÏÄI
--[15]={29,32,54,50,51,47},--½­ÁêI
[15]={21,23,25,27,29,32,54,50,51,47},--½­ÁêI,¿¼ÂÇµ½ÓÎÏ·Êµ¼Ê,Ö÷ÒªÔÚ½­Áê,¶ø²»ÔÙÏåÑôII,½«ÏåÑôIIµÄ²¿·ÖµÀ¾ßÒ²¼Ó½øÀ´
[16]={42,39,36,44,45,20,22,24},--½­ÏÄII
[17]={50,51,47,48,38,39},--³¤É³
[18]={21,23,25,27,29,42,39,36,34},--ÏåÑôII
[19]={21,23,25,27,29,30,32,54},--³É¶¼I
[20]={29,32,54,42,20,22,24,34},--¸¢
[21]={21,23,25,27,29,30,32,33},--³É¶¼II
[22]={42,39,36,29,32,54,48,51},--Î÷Áê
[23]={42,39,40,36,37,48,51,52},--½­ÁêII
[24]={21,23,25,27,43,30,33,55},--ÏåÑôIII
[25]={30,33,55,43,40,37,45,46},--Íğ
[26]={30,33,55,49,20,22,24,26},--Ğí²ıII
--[[
¸÷µØËùÄÜ¹ºÂòµÀ¾ß£º
³ÂÁô£º½¹ÈÈÊé£¬¾Æ£¬¶¹¡£
±±Æ½£º¾Æ£¬¶¹£¬Å¨ÎíÊé¡£
ĞÅ¶¼£º¾Æ£¬¶¹£¬ÉËÒ©£¬½¹ÈÈÊé£¬äöÎĞÊé£¬ÂäÊ¯Êé¡£
¹ã´¨£º¾Æ£¬¶¹£¬ÉËÒ©¡£
±±º££º¾Æ£¬¶¹£¬ÉËÒ©£¬½¹ÈÈÊé£¬äöÎĞÊé£¬ÂäÊ¯Êé£¬Õ¨µ¯¡£
ĞìÖİ£º¾Æ£¬¶¹£¬ÉËÒ©£¬Æ½ÆøÊé£¬Ô®¶ÓÊé¡£
ÏÂÚü£º¶¹£¬Âó£¬Æ½ÆøÊé£¬Ô®¶ÓÊé£¬Õ¨µ¯¡£
Ğ¡Åæ£º³¤Ç¹£¬Á¬åó£¬Âíîø£¬ÎŞÀµ¾«Éñ£¬½¹ÈÈÊé£¬äöÎĞÊé£¬ÂäÊ¯Êé¡£
Ğí²ıI£º³¤Ç¹£¬Á¬åó£¬Âíîø£¬ÎŞÀµ¾«Éñ£¬¾Æ£¬ÌØ¼¶¾Æ£¬¶¹£¬ÉËÒ©¡£
Ğí²ıII£ºÀÏ¾Æ£¬Ã×£¬²è£¬Ô®¾üÊé£¬³¤Ç¹£¬Á¬åó£¬Âíîø£¬ÎŞÀµ¾«Éñ¡£ µÚËÄÊ®°Ë¹Ø£¬Ğí²ıIIÖ®Õ½ºó
Úş£º³¤Ç¹£¬Á¬åó£¬Âíîø£¬ÎŞÀµ¾«Éñ£¬ÌØ¼¶¾Æ£¬¶¹£¬Âó£¬ÉËÒ©¡£
°×Âí£º½¹ÈÈÊé£¬äöÎĞÊé£¬×ÇÁ÷Êé£¬ÂäÊ¯Êé£¬Å¨ÎíÊé¡£
ÈêÄÏ£º½¹ÈÈÊé£¬»ğÁúÊé£¬äöÎĞÊé£¬×ÇÁ÷Êé£¬ÂäÊ¯Êé£¬É½±ÀÊé¡£
ÏåÑôI£º³¤Ç¹£¬Á¬åó£¬Âíîø£¬ÎŞÀµ¾«Éñ£¬ÌØ¼¶¾Æ£¬Âó£¬ÉËÒ©£¬Õ¨µ¯¡£
ÏåÑôII£º²½±ø³µ£¬·¢Ê¯³µ£¬½üÎÀîø£¬ÏÀÒå¾«Éñ£¬»ğÁúÊé£¬×ÇÁ÷Êé£¬É½±ÀÊé£¬Õ¨µ¯¡£ µÚ¶şÊ®Áù¹Ø£¬½­ÁêÖ®Õ½ºó
ÏåÑôIII£º²½±ø³µ£¬·¢Ê¯³µ£¬½üÎÀîø£¬ÏÀÒå¾«Éñ£¬ÃÍ»ğÊé£¬ÀÏ¾Æ£¬Ã×£¬²è¡£ µÚËÄÊ®¶ş¹Ø£¬ÏåÑôIIÖ®Õ½ºó
½­ÏÄI£º»ğÁúÊé£¬×ÇÁ÷Êé£¬É½±ÀÊé£¬Å¨ÎíÊé£¬À×ÕóÓêÊé¡£
½­ÏÄII£º»ğÁúÊé£¬×ÇÁ÷Êé£¬É½±ÀÊé£¬Å¨ÎíÊé£¬À×ÕóÓêÊé£¬³¤Ç¹£¬Á¬åó£¬Âíîø¡£ µÚ¶şÊ®Îå¹Ø£¬³¤ÚæÆÂÖ®Õ½ºó
½­ÁêI£ºÌØ¼¶¾Æ£¬Âó£¬ÖĞÒ©£¬Æ½ÆøÊé£¬»îÆøÊé£¬Ô®¶ÓÊé¡£
½­ÁêII£º»ğÁúÊé£¬×ÇÁ÷Êé£¬º£Ğ¥Êé£¬É½±ÀÊé£¬É½ºéÊé£¬Ô®²¿Êé£¬»îÆøÊé£¬ÓÂÆøÊé¡£ µÚÈıÊ®¾Å¹Ø£¬ÂóÖ®Õ½ºó
³¤É³£ºÆ½ÆøÊé£¬»îÆøÊé£¬Ô®¶ÓÊé£¬Ô®²¿Êé£¬äöÎĞÊé£¬×ÇÁ÷Êé¡£
¸¢£ºÌØ¼¶¾Æ£¬Âó£¬ÖĞÒ©£¬»ğÁúÊé£¬³¤Ç¹£¬Á¬åó£¬Âíîø£¬Õ¨µ¯¡£
³É¶¼I£º²½±ø³µ£¬·¢Ê¯³µ£¬½üÎÀîø£¬ÏÀÒå¾«Éñ£¬ÌØ¼¶¾Æ£¬ÀÏ¾Æ£¬Âó£¬ÖĞÒ©¡£
³É¶¼II£º²½±ø³µ£¬·¢Ê¯³µ£¬½üÎÀîø£¬ÏÀÒå¾«Éñ£¬ÌØ¼¶¾Æ£¬ÀÏ¾Æ£¬Âó£¬Ã×¡£ µÚÈıÊ®¾Å¹Ø£¬ÂóÖ®Õ½ºó
Î÷Áê£º»ğÁúÊé£¬×ÇÁ÷Êé£¬É½±ÀÊé£¬ÌØ¼¶¾Æ£¬Âó£¬ÖĞÒ©£¬Ô®²¿Êé£¬»îÆøÊé¡£
Íğ£ºÀÏ¾Æ£¬Ã×£¬²è£¬ÃÍ»ğÊé£¬º£Ğ¥Êé£¬É½ºéÊé£¬À×ÕóÓêÊé£¬ºÀÓêÊé¡£
]]--
 }
local shopitem2={--ÎäÆ÷µê
[1]={74,80,89,140,147},--ãáË®¹ØÖ®Õ½Ç°,³ÂÁô
[2]={74,75,80,89,99,140,141,147},--»¢ÀÎ¹ØÖ®Õ½ºó,±±Æ½
[3]={80,81,85,89,95,117,120,141,148},--ĞÅ¶¼³ÇÖ®Õ½ºó,ĞÅ¶¼
[4]={75,90,141,148},--¹ã´¨Ö®Õ½ºó,¹ã´¨
--±±º£Ö®Õ½Ç°,±±Æ½/ĞÅ¶¼
[5]={80,81,85,89,95,117,120,141,148},--±±º£Ö®Õ½ºó,±±Æ½/ĞÅ¶¼/±±º£,ÕâÀïÖ»ÁĞÁËĞÅ¶¼µÄ
[6]={90,96,120,125,126,131,142,148},--ĞìÖİIÖ®Õ½ºó,±±Æ½/ĞÅ¶¼/±±º£/ĞìÖİ/ÏÂÚü£¬ÕâÀïÖ»ÁĞµÄĞìÖİµÄ
--ÏÂÚüµÄ 31,32,50,47,34
[7]={81,85,100,117,135,142,152},--Ğ¡Åæ
[8]={86,90,101,104,105,117,135,142,152,148},--Ğí²ıI
[9]={86,90,101,105,142,152,148},--ÏÂÚü,ÆäÊµÃ»ÓĞ£¬Ëæ±ã±à¼¸¸ö
[10]={76,82,91,102,106,118,136,131,130},--Úş
[11]={140,141,142,147,148},--°×Âí,ÆäÊµÃ»ÓĞ£¬Ëæ±ã±à¼¸¸ö
[12]={76,82,91,102,106,142},--ÈêÄÏ,ÆäÊµÃ»ÓĞ£¬Ëæ±ã±à¼¸¸ö
[13]={91,97,127,131,141,143,152,149,150},--ÏåÑôI
[14]={76,82,86,106,109,110,118,121,123},--½­ÏÄI
[15]={103,107,111,114,132,133,142,144,153},--½­ÁêI
[16]={76,82,86,106,109,110,118,121,123},--½­ÏÄII
[17]={76,82,86,103,107,110},--³¤É³,ÆäÊµÃ»ÓĞ£¬Ëæ±ã±à¼¸¸ö
[18]={71,72,73,77,90,92,96,97,128},--ÏåÑôII
[19]={78,83,87,111,115,128,145,153,150},--³É¶¼I
[20]={92,97,102,106,139},--¸¢,ÆäÊµÃ»ÓĞ£¬Ëæ±ã±à¼¸¸ö
[21]={78,83,87,111,115,128,145,153,150},--³É¶¼II
[22]={78,83,87,92,97,102,106,111,115,139},--Î÷Áê,ÆäÊµÃ»ÓĞ£¬Ëæ±ã±à¼¸¸ö
[23]={93,97,103,108,112,137,119,122,129},--½­ÁêII
[24]={84,88,98,116,124,138,134,146,151},--ÏåÑôIII
[25]={84,88,98,103,108},--Íğ
[26]={79,94,113,139,132,154},--Ğí²ıII
}
local shopid=1--1µÀ¾ß 2ÎäÆ÷
local buysellmenu={
{"¡¡D‚w ‚wh ",nil,1},
{"¡¡IƒG ‚wh ",nil,1},
{"¡¡ƒT„h „W†I ",nil,1},
{"¡¡¡¡‚F‡G ",nil,1},

}
if rawget(_G,"koWujeStock") then
 local stock=koWujeStock()
 if stock then sid=1 shopitem={[1]=stock} shopitem2={[1]={}} buysellmenu[2][3]=0 buysellmenu[3][3]=0 end
end
for id,stock in pairs(shopitem) do shopitem[id]=koPromotionStock(stock) end
for id,stock in pairs(shopitem2) do shopitem2[id]=koPromotionStock(stock) end
local itemmenu={}
local itemnum=0
local personmenu={}
local personnum=0
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==1 then
personmenu[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),nil,1}
personnum=personnum+1
else
personmenu[i]={"",nil,0}
end
end
PlayWavE(0)
local status="SelectBuySell"
local iid,pid
local function showbuysellmenu()
talk_sub(375,"I‡H …IG‡ILY?")
--Ìí¼ÓµÀ¾ßÎİÑ¡Ôñ
sid=JY.Base["D‚wC"]
if sid>1 then
local dm={"g]","‡kƒw","ƒND","‚H‚s","‚a‚M","ƒW‚K","mO","‡m†gI","‚a‚M","†n","‚a‚M","‚a‚M","†o†oI","‚IaI","‚ISI","‚IaII","‚a‚M","†o†oII","ƒ{DI","‚a‚M","ƒ{DII","‚a‚M","‚ISII","†o†oIII","†l","‡m†gII"}
local n={}
for i=1,sid do
if dm[i]=="‚a‚M" then
n[i]={fillblank(dm[i],11),nil,0}
else
n[i]={fillblank(dm[i],11),nil,1}
end
end
local s=ShowMenu(n,#n,8,0,200,0,0,6,1,16,M_White,M_White)
if s>0 then
sid=s
end
end
local r=ShowMenu(buysellmenu,4,0,0,156,0,0,3,1,16,M_White,M_White)
if r==1 then
status="SelectItem"
shopid=1
itemmenu={}
itemnum=0
for i,v in ipairs(shopitem[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["Ãû³Æ"],13),nil,1}
end
elseif r==2 then
status="SelectItem"
shopid=2
itemmenu={}
itemnum=0
for i,v in ipairs(shopitem2[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["Ãû³Æ"],13),nil,1}
end
elseif r==3 then
status="SelectPersonExchange"
elseif r==4 then 
status="SelectPersonSell"
else
status="Exit"
PlayWavE(1)
end
end
local function showitemmenu()
talk_sub(375,"I‡JS ‚r‚V†yKLY?")
local r=ShowMenu(itemmenu,itemnum,0,0,156,0,0,3,1,16,M_White,M_White)
if r>0 then
if shopid==1 then
iid=shopitem[sid][r]
elseif shopid==2 then
iid=shopitem2[sid][r]
else
iid=1
end
local x=145
local y=CC.ScreenH/2
local size=16
lib.PicLoadCache(4,50*2,x,y,1)
DrawString(x+16,y+16,JY.Item[iid]["Ãû³Æ"],C_Name,size)
DrawStr(x+16,y+36,GenTalkString(JY.Item[iid]["ËµÃ÷"],18),M_White,size)
if talkYesNo(375,JY.Item[iid]["Ãû³Æ"].."‚Uƒg "..koShopP(iid).."0,*ƒJƒKKLY?") then
--Èç¹û»Æ½ğ²»¹»
if koShopP(iid)*10>koGold() then
DrawSMap()
PlayWavE(2)
talk(375,"‚UƒgG ‚^„RaƒN ‡KWLM.")
status="SelectItem"
else
status="SelectPerson"
end
end
else
status="SelectBuySell"
PlayWavE(1)
end
end
local function showpersonnum()
talk_sub(375,JY.Item[iid]["Ãû³Æ"].."S(‚h) †u^ …H†yKLY?")
local r
if personnum<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
pid=r
if JY.Person[pid]["µÀ¾ß8"]>0 then
PlayWavE(2)
if talkYesNo(375,"ƒ[‡Lƒb „l GC*ƒAwS ‚C†t q ‚aKLM. M‡M ‡Lƒb ‚S„nYZ?") then
status="SelectPerson"
else
status="SelectItem"
end
else
PersonStatus_sub(pid,108,156)
if koShopBuy(pid,iid) then--ko 3.3: count + one confirm
DrawSMap()
DrawYJZBox(32,32,"D‚w ‡G‡G",M_White,true)
if talkYesNo(375,"‡N‚rWLM. „l¡­¡­ ‚r‚V†yKLY?") then
status="SelectItem"
else
status="SelectBuySell"
end
else
status="SelectPerson"
end
end
else
status="SelectItem"
PlayWavE(1)
end
end
local function showpersonnumsell()
talk_sub(375,"†u‚wƒP ƒAwS †V‚V†yKLY?")
local r
if personnum<=10 then
r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
pid=r
status="SelectItemSell"
else
status="SelectBuySell"
PlayWavE(1)
end
end
local function showitemmenusell()
if JY.Person[pid]["µÀ¾ß1"]==0 then
	PlayWavE(2)
	talk(375,"†VN „Vo ƒAwG ‚aKLM.")
	status="SelectPersonSell"
else
	local sellmenu={}
	for i=1,8 do
		iid=JY.Person[pid]["µÀ¾ß"..i]
		if iid>0 then
			sellmenu[i]={fillblank(JY.Item[iid]["Ãû³Æ"],13),nil,1}
		else
			sellmenu[i]={"",nil,0}
		end
	end
	talk_sub(375,"I‡JS †V‚V†yKLY?")
	local rr=ShowMenu(sellmenu,8,0,0,156,0,0,3,1,16,M_White,M_White)
	local sellprice
	if rr>0 then
		iid=JY.Person[pid]["µÀ¾ß"..rr]
		if (JY.Item[iid]["×¨ÊôÌØ¼¼"] or 0)>0 then PlayWavE(2) talk(375,"\130\066\132\111 \131\115\131\065\131\098 \137\079 \129\113 \130\097\129\075\129\076\129\077. \130\066\132\111 \131\097\129\113\132\086 \132\080 \129\113 \132\079\130\098 \131\115\131\065\129\104\129\076\129\077.") status="SelectItemSell" return end--ko 11-13 (cafe): no selling exclusive treasures
		if (iid==71 or iid==72 or iid==73) then
			sellprice=5*math.modf(JY.Item[iid]["¼ÛÖµ"]*0.75)
		else
			sellprice=10*math.modf(JY.Item[iid]["¼ÛÖµ"]*0.75)
		end
		if talkYesNo(375,"‚_ƒg "..sellprice.."‚Uƒgf ‡Gh: "..JY.Item[iid]["Ãû³Æ"]..", ƒJƒKKLY?") then
			for i=rr,7 do
				JY.Person[pid]["µÀ¾ß"..i]=JY.Person[pid]["µÀ¾ß"..(i+1)]
			end
			JY.Person[pid]["µÀ¾ß8"]=0
			GetMoney(sellprice)
			DrawSMap()
			DrawYJZBox(32,32,"D‚w ‡G‡G",M_White,true)
			if talkYesNo(375,"‡N‚rWLM. „l¡­¡­ †V‚V†yKLY?") then
				status="SelectPersonSell"--?
				status="SelectItemSell"--?
			else
				status="SelectBuySell"
			end
		else
			status="SelectItemSell"
		end
	else
		status="SelectPersonSell"
		PlayWavE(1)
	end
end
end

local function showpersonnumexchange()
talk_sub(375,"†u‚wƒP ƒT„hS „W†Ia‚V†yKLY?")
local r
if personnum<=10 then
	r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
	r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end
if r>0 then
	pid=r
	status="SelectSeedExchange"
else
	status="SelectBuySell"
	PlayWavE(1)
end
end

local function exchangeseed()
local exchangemenu={}
local seedmenu={}
local newseed=0
local ex_str=""
local seed_cnt=0

for i=1,8 do
	iid=JY.Person[pid]["µÀ¾ß"..i]
	if (iid==71 or iid==72 or iid==73 or iid==173) then
		exchangemenu[i]={fillblank(JY.Item[iid]["Ãû³Æ"],13),nil,1}
		seed_cnt=seed_cnt+1
	else
		exchangemenu[i]={"",nil,0}
	end
		
end
	if seed_cnt==0 then
		talk(375,"„W†IX ƒT„hG ‚aKLM.")
		status="SelectPersonExchange"
else
	
	talk_sub(375,"‚S†s ƒT„hS „W†Ia‚V†yKLY?")
	local rr=ShowMenu(exchangemenu,8,8,0,156,0,0,3,1,16,M_White,M_White)
	for i=1,73 do
		seedmenu[i]={"",nil,0}
	end
	if rr>0 then
		iid=JY.Person[pid]["µÀ¾ß"..rr]		
		if iid==71 then
			seedmenu[72]={fillblank(JY.Item[72]["Ãû³Æ"],13),nil,1}
			seedmenu[73]={fillblank(JY.Item[73]["Ãû³Æ"],13),nil,1}
		elseif iid==72 then
			seedmenu[71]={fillblank(JY.Item[71]["Ãû³Æ"],13),nil,1}
			seedmenu[73]={fillblank(JY.Item[73]["Ãû³Æ"],13),nil,1}
		elseif iid==73 then
			seedmenu[71]={fillblank(JY.Item[71]["Ãû³Æ"],13),nil,1}
			seedmenu[72]={fillblank(JY.Item[72]["Ãû³Æ"],13),nil,1}
		elseif iid==173 then--ko 3.3: experience seed -> stat seed (one way)
			seedmenu[71]={fillblank(JY.Item[71]["Ãû³Æ"],13),nil,1}
			seedmenu[72]={fillblank(JY.Item[72]["Ãû³Æ"],13),nil,1}
			seedmenu[73]={fillblank(JY.Item[73]["Ãû³Æ"],13),nil,1}
		else
			talk(375,"G D‚w‚b „W†IX q ‚aKLM")
			return
		end
		talk_sub(375,"‚S†s ƒT„hƒm„S ƒUƒV‚V†yKLY?")
		newseed=ShowMenu(seedmenu,73,(iid==173) and 3 or 2,0,156,0,0,3,1,16,M_White,M_White)
		if newseed>0 then
			if koGold()<125 then
				talk(375,"ƒT„h „W†I ‚P„o 125ƒgG ‚^„RWLM")
				return
			else				
				ex_str="125ƒgƒm„S "..JY.Item[iid]["Ãû³Æ"].." ¡ú "..JY.Item[newseed]["Ãû³Æ"]..". ƒU†NYZ?"
				if WarDrawStrBoxYesNo(ex_str,M_White,true) then
					JY.Person[pid]["µÀ¾ß"..rr]=JY.Item[newseed]["´úºÅ"]
					UseMoney(125)
					DrawSMap()
					DrawYJZBox(32,32,"ƒT„h „W†I",M_White,true)
				else
					return
				end	
			end
			if talkYesNo(375,"‡N‚rWLM. ƒT„hS „l „W†Ia‚V†yKLY?") then
				status="SelectPersonExchange"--?
				status="SelectSeedExchange"--?
			else
				status="SelectBuySell"
			end
		else
			status="SelectSeedExchange"
		end
	else
		status="SelectPersonExchange"
		PlayWavE(1)
	end
end
end

talk(375,"…f‚b CjhLM.")
while true do
JY.Tid=375
DrawSMap()
DrawYJZBox(32,32,"D‚w ‡G‡G",M_White,true)
if status=="SelectBuySell" then
showbuysellmenu()
elseif status=="SelectItem" then
showitemmenu()
elseif status=="SelectPerson" then
showpersonnum()
elseif status=="SelectPersonSell" then
showpersonnumsell()
elseif status=="SelectItemSell" then
showitemmenusell()
elseif status=="SelectPersonExchange" then
showpersonnumexchange()
elseif status=="SelectSeedExchange" then
exchangeseed()
else
talk(375,"‡O [‡I‚V[.")
break
end
end
end

function WarIni()
if JY.Status==GAME_SMAP_MANUAL and (koGold())>=980000 then
	talk(375,"‚Uƒg ƒs‚G„XG Co 999999f ^‡PKLM. ‚SƒW ‚r„oaƒoZ.")
end
War={}
SetWarConst()
War.Person={}
War.PersonNum=0
Drama={}

end

--ÓÃÓÚÁ¬Õ½£¬ÆäÊµ¾ÍÊÇ°ÑµĞ¾üÉ¾µô
function WarIni2()
for i=War.PersonNum,1,-1 do
if War.Person[i].enemy then
table.remove(War.Person,i)
War.PersonNum=War.PersonNum-1
end
end
end



--Ñ¡ÔñÎÒ¾ü
--fid,¾ıÖ÷id Ò»°ãÓ¦¸ÃÊÇ1£¬Áõ±¸
--team,ÎÒ¾ü²ÎÕ½ÈËÔ±ÅäÖÃÊı¾İ,idÎª-1Ê±¿ÉÑ¡Ôñ,·ñÔòÎªÇ¿ÖÆ³öÕ½
--ko cost: JY.Person index -> cost 1..10. Falls back to koCost.derive() when the table has no entry.
function koCostOf(pid)
if koCost==nil then return 0 end
local original=koStoryOriginalPerson and koStoryOriginalPerson(pid) or pid
local c=koCost.fixed[original]
if c~=nil then return c end
local p=JY.Person[pid]
local sk={}
for i=1,6 do sk[i]=p["ÌØ¼¼"..i] end
local b=JY.Bingzhong[p["±øÖÖ"]]
return koCost.derive({
wl=p["ÎäÁ¦"],zl=p["ÖÇÁ¦"],ts=p["Í³ÂÊ"],grow=p["³É³¤"],tf=p["Ìì¸³"],sk=sk,
bz={atk=b["¹¥»÷"],def=b["·ÀÓù"],mov=b["ÒÆ¶¯"],rng=b["¹¥»÷·¶Î§"],hp=b["»ù´¡±øÁ¦"],hpg=b["±øÁ¦Ôö³¤"]},
})
end

--ko 5.1 (10-16): ì¶œì§„ í™”ë©´ â˜… ì¦ê²¨ì°¾ê¸°. The set lives in CC.koFav; the parsed table is kept until the string changes.
koFavC={s=nil,t={}}
function koFavHas(pid)
if koStoryOriginalPerson then pid=koStoryOriginalPerson(pid) end
local s=CC.koFav or ""
if s~=koFavC.s then
koFavC.t={}
for id in string.gmatch(s,"%d+") do koFavC.t[tonumber(id)]=true end
koFavC.s=s
end
return koFavC.t[pid]==true
end
function koFavToggle(pid)
if koStoryOriginalPerson then pid=koStoryOriginalPerson(pid) end
if not pid or pid<=0 then return end
koFavHas(pid)
koFavC.t[pid]=(not koFavC.t[pid]) or nil
local t={}
for id in pairs(koFavC.t) do t[#t+1]=id end
table.sort(t)
CC.koFav=table.concat(t,",")
koFavC.s=CC.koFav
koSave()
end
-- the â˜… corner of each card (top right of the picture). On the sortie screen every card shows it (lit = ì¦ê²¨ì°¾ê¸°,
-- dim = not) and a click there toggles him; the ë„êµ¬ êµí™˜ / ìˆ ì§‘ cards only show the lit ones.
-- koFavC.st = the last sortie-screen frame (set in SelectTerm's redraw), koFavC.cells = the corners drawn there
koFavC.cells={}
function koFavCardStar(i,pid,x,y)
local on=koFavHas(pid)
local sortie=koFavC.st~=nil and lib.GetTime()-koFavC.st<300
if i==1 then koFavC.cells={} end
if not on and not sortie then return end
local hov=sortie and MOUSE.IN(x+20,y,x+48,y+28)
lib.Background(x+28,y+2,x+46,y+19,160,M_Black)
DrawString(x+29,y+2,"\161\239",on and M_Yellow or (hov and M_White or M_Gray),16)
if sortie then koFavC.cells[i]={pid,x+20,y,x+48,y+28,lib.GetTime()} end--(the hit box: the top right of the 48px picture, bigger than the star for fingers)
end
-- true when this frame's click hit a â˜… corner; koFavC.hit = that general
function koFavCardHit()
local now=lib.GetTime()
for _,c in pairs(koFavC.cells) do
if now-c[6]<500 and MOUSE.CLICK(c[2],c[3],c[4],c[5]) then koFavC.hit=c[1] return true end
end
return false
end
function SelectTerm(fid,team)
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=0
local maxpersonnum=0
local current=1
local koLv,koBudget,koSpent=0,0,0
local koC={}
for j=1,30 do
local idx=(j-1)*7
if team[idx+1]==-1 then
personnum=personnum+1
end
if team[idx+7]==nil then
break
end
maxpersonnum=j
end
if personnum==0 then
SelectTerm_sub(fid,team)
return
else
ExchangeItem(fid,true)
end
TeamSelect={id={},status={}}
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==fid then
ReSetAttrib(i,true)
JY.Person[i]["Õ½¶·¶¯×÷"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
TeamSelect.status[num]=0--0Î´Ñ¡Ôñ 1Ñ¡Ôñ(¿ÉÈ¡Ïû) 2Ñ¡Ôñ(²»¿ÉÈ¡Ïû)
for j=1,maxpersonnum do
local idx=(j-1)*7
local fixed=team[idx+1]+1
if koStoryBattleAlly then fixed=koStoryBattleAlly(fixed) end
if fixed==i then
TeamSelect.status[num]=2
break
end
end
end
end
maxpage=math.modf((num-1)/6)+1
if CC.Enhancement and koCost~=nil then
koLv=JY.Base["ÎŞÓÃ5"] or 0
if koLv<1 or koLv>3 then koLv=0 end
end
if koLv>0 then
for n=1,num do koC[n]=koCostOf(TeamSelect.id[n]) end
local koSel={}
for n=1,num do if TeamSelect.status[n]~=2 then table.insert(koSel,koC[n]) end end
koBudget=koCost.budget(personnum,koLv,koSel)
end
--ko 3.2: over-slot picks. Past the map own free slots the cost rises 1,2,3,3,... (capped at koCost.over).
local koOverC=(koCost and koCost.over) or 3
local koBase=personnum
local koFixed=0
for k=1,num do if TeamSelect.status[k]==2 then koFixed=koFixed+1 end end--ko 3.2: my own generals already in the team
local koExtraMax=30-maxpersonnum
if koExtraMax<0 then koExtraMax=0 end
local function koAdd() if koLv>0 and personnum<=0 then local k=1-personnum if k>koOverC then k=koOverC end return k end return 0 end
local function koDel() if koLv>0 and personnum<0 then local k=-personnum if k>koOverC then k=koOverC end return k end return 0 end
--ko 3.2: the 'remaining' field = how many more I can still take. It used to stick at 0 once the
--        slots were full, so in cost mode it counts what the leftover budget still affords.
local function koLeft()
if koLv<=0 then return (personnum>0) and personnum or 0 end
local cnt={}
for c=1,10 do cnt[c]=0 end
for k=1,num do
if TeamSelect.status[k]==0 then
local c=koC[k] or 1
if c<1 then c=1 end
if c>10 then c=10 end
cnt[c]=cnt[c]+1
end
end
local n,sum,p=0,koSpent,personnum
for c=1,10 do
while cnt[c]>0 do
local add=0
if p<=0 then
if p<=-koExtraMax then return n end
add=1-p
if add>koOverC then add=koOverC end
end
if sum+c+add>koBudget then return n end
sum=sum+c+add p=p-1 n=n+1 cnt[c]=cnt[c]-1
end
end
return n
end
--ko 3.1: ì •ë ¬Â·í•„í„°. view = TeamSelect indices in the order shown; page/maxpage run over it
local koFavOnly,koTitleKeep=false,nil--ko 5.1: the 3rd button cycles ì„ íƒ â†’ ì„ íƒë§Œ â†’ â˜…ë§Œ â†’ off
local koSortK,koFilt,koSelOnly=0,0,false-- sort 0 ìˆœì„œ 1 ì´ë¦„ 2 ë¬´ë ¥ 3 ì§€ë ¥ 4 í†µì†” 5 ë ˆë²¨ 6 ì½”ìŠ¤íŠ¸ 7 ë³‘ì¢…; filter 0 ì „ì²´ or a ë³‘ì¢… id
local koBzList=koRosterClasses(TeamSelect.id)
local view={}
local vnum=0
local function koBuildView()
view={}
for k=1,num do
local p=JY.Person[TeamSelect.id[k]]
local ok=(koFilt==0 or p["±øÖÖ"]==koFilt) and ((not koSelOnly) or TeamSelect.status[k]~=0) and ((not koFavOnly) or koFavHas(TeamSelect.id[k]))
if ok then view[#view+1]=k end
end
koRosterSort(view,koSortK,koC)
vnum=#view
maxpage=math.max(1,math.modf((vnum-1)/6)+1)
if page>maxpage then page=maxpage end
end
koBuildView()
-- the button row in the band under the page row (y 390..408): [ì •ë ¬ X] [ë³‘ì¢… Y] [ì„ íƒ]
local koBtn={{x=26,w=96},{x=128,w=112},{x=246,w=52}}--ko 4.0 (koBtnParty): narrower, so [í¸ì„±] joins the row inside the left panel
local function koDrawBar()
local lab={
"\129\070\131\102:"..koRosterSortNames[koSortK],-- ì •ë ¬:X (ìˆœì„œ = as listed)
"\130\126\129\084:"..koRosterClassLabel(koFilt),-- ë³‘ì¢…:ì „ì²´/Y
"\133\109\133\110",-- ì„ íƒ
}
for i,b in ipairs(koBtn) do
local on=(i==3 and (koSelOnly or koFavOnly)) if i==3 and koFavOnly then lab[3]="\161\239\132\086" end--ko 5.1
lib.Background(b.x,390,b.x+b.w,408,on and 96 or 160,M_Black)
lib.DrawRect(b.x,390,b.x+b.w,390,on and M_White or M_Gray) lib.DrawRect(b.x,408,b.x+b.w,408,on and M_White or M_Gray)
lib.DrawRect(b.x,390,b.x,408,on and M_White or M_Gray) lib.DrawRect(b.x+b.w,390,b.x+b.w,408,on and M_White or M_Gray)
DrawString(b.x+b.w/2-#lab[i]*4,391,lab[i],on and C_Name or M_White,16)
end
lib.Background(304,390,356,408,160,M_Black) lib.DrawRect(304,390,356,390,M_Gray) lib.DrawRect(304,408,356,408,M_Gray) lib.DrawRect(304,390,304,408,M_Gray) lib.DrawRect(356,390,356,408,M_Gray) DrawString(314,391,"\132\075\131\123",MOUSE.IN(304,390,356,408) and C_Name or M_White,16)--ko 3.6 later: í¸ì„± ì €ì¥/ë¶ˆëŸ¬ì˜¤ê¸°
if koLv>0 then lib.Background(360,390,442,408,160,M_Black) DrawString(362,391,"\133\098\130\066 "..(koFixed+koBase-personnum).."/"..(koFixed+koBase),(personnum<0) and M_Cyan or M_White,16) end--ko 3.2: my generals deployed / how many I may send
end
--------------------------------
-- ¶¨Òå×ø±êĞÅÏ¢
--------------------------------
local xy={
x1={},--×óÉÏ½Ç(±ß¿òÄÚ£¬Êµ¼Ê²¿¶ÓÍ¼±êÏÔÊ¾Î»ÖÃ)
y1={},
x2={},--±øÁ¦
y2={},
x3={},--ĞÕÃû
y3={},
x4={},--ÓÒÏÂ½Ç
y4={},
}
xy.x1={56,232,56,232,56,232}
xy.y1={64,64,154,154,244,244}
for i=1,6 do
xy.x1[i]=xy.x1[i]+16
xy.y1[i]=xy.y1[i]+16
end
for i=1,6 do
xy.x2[i]=xy.x1[i]+104
xy.y2[i]=xy.y1[i]+17
xy.x3[i]=xy.x1[i]+104
xy.y3[i]=xy.y1[i]+41
xy.x4[i]=xy.x1[i]+143
xy.y4[i]=xy.y1[i]+63
end
local bottom=0--µ±Ç°°´Å¥
--------------------------------
--redraw()
-- ÄÚ²¿º¯Êı£¬ÖØ»æ
-- frame ÓÃÓÚ¿ØÖÆ¶¯»­ÏÔÊ¾
--------------------------------
local cid=0
local subframe,frame=0,0
local kind={[0]="‚a‚M","‚J‚p„o","‚}‚D„o","‚t†I„o","ƒsƒA","‚~ƒW","‚X…X","‚}‚D„o","ƒT„h","ƒT„h","ƒT„h","IƒG","„N‚S‚w","…X„y","\130\126\136\070\131\087",}--ko 5.0 (10-13): [14] book
local str_mode
str_mode=koNG.label()
local titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?"
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
local kots=koNG.label()
local kotx=436-string.len(kots)*16/2
lib.SetClip(26,22,kotx-8,54)
DrawString(26,31,(CC.koTavernPick and "\134\117\130\119\135\122 \129\071\133\069\131\071\129\066 \133\082\129\089\129\090? \133\109\133\110\129\097\131\111\129\090." or titlestr),M_White,16)--ko 5.0: town tavern talk
lib.SetClip(kotx,22,436,54)
DrawString(kotx,31,kots,M_White,16)
lib.SetClip()
koDrawBar()--ko 3.1
for i=1,6 do
local idx=view[num_per_page*(page-1)+i]--ko 3.1: through the view
if idx==nil then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["ĞÕÃû"]
local hp=string.format("% 5d",JY.Person[pid]["×î´ó±øÁ¦"])
local lv=string.format("% 5d",JY.Person[pid]["µÈ¼¶"])
local picid
if TeamSelect.status[idx]==0 then--Î´Ñ¡ÔñÊ±£¬Îª+19
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+19
if not (rawget(_G,"koFormCardName") and koFormCardName(i,pid,xy.x1[i],xy.y1[i],xy.x3[i],xy.y3[i],(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White))) then DrawString(xy.x3[i]-4*#name,xy.y3[i],name,(rawget(_G,"koAwakeNameColor") and koAwakeNameColor(pid,M_White) or M_White),16) end--ko 5.0: name | formation
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+12+frame
if not (rawget(_G,"koFormCardName") and koFormCardName(i,pid,xy.x1[i],xy.y1[i],xy.x3[i],xy.y3[i],M_DarkOrange)) then DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16) end--ko 5.0: name | formation
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
if koLv>0 then
local kc=(koC[idx] or 0)+((TeamSelect.status[idx]==0) and koAdd() or 0)--ko 3.2
local kcol=M_White
if TeamSelect.status[idx]==2 then
kcol=M_Gray
elseif TeamSelect.status[idx]==0 and koSpent+kc>koBudget then
kcol=M_Red
elseif TeamSelect.status[idx]==0 and koAdd()>0 then
kcol=M_Cyan--ko 3.2
end
lib.Background(xy.x1[i]+2,xy.y1[i]+2,xy.x1[i]+22,xy.y1[i]+19,160,M_Black)
DrawString(xy.x1[i]+5,xy.y1[i]+2,string.format("%d",kc),kcol,16)
end
koFavCardStar(i,pid,xy.x1[i],xy.y1[i])--ko 5.1: â˜… corner (also on the ë„êµ¬ êµí™˜ and ìˆ ì§‘ cards)
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
DrawString(252,359,string.format("% 4d",koLeft()),(koLv>0 and personnum<=0) and M_Cyan or M_White,16)--ko 3.2
if koLv>0 then
DrawString(376,350,"\138\072\131\126\141\074",M_White,16)
DrawString(380,366,string.format("%d/%d",koSpent,koBudget),(koSpent>koBudget) and M_Red or M_White,16)
end
--Ñ¡ÖĞÈËÎï
cid=TeamSelect.id[current]
lib.PicLoadCache(2,JY.Person[cid]["Í·Ïñ´úºÅ"]*2,464,32,1)
DrawString(489-3*#JY.Person[cid]["ĞÕÃû"],136,JY.Person[cid]["ĞÕÃû"],M_White,16)
DrawString(584-4*#JY.Bingzhong[JY.Person[cid]["±øÖÖ"]]["Ãû³Æ"],24,JY.Bingzhong[JY.Person[cid]["±øÖÖ"]]["Ãû³Æ"],M_White,16)
DrawString(585,48,string.format("% 5d",JY.Person[cid]["µÈ¼¶"]),M_White,16)
DrawString(585,80,string.format("% 5d",JY.Person[cid]["Í³ÂÊ"]),M_White,16)
DrawString(585,112,string.format("% 5d",JY.Person[cid]["ÎäÁ¦"]),M_White,16)
DrawString(585,144,string.format("% 5d",JY.Person[cid]["ÖÇÁ¦"]),M_White,16)
koFavC.st=lib.GetTime()--ko 5.1: the sortie screen is up (its cards show the â˜… switch)
if rawget(_G,"koFormSortieDraw") then koFormSortieDraw(cid) end--ko 5.0: formation
if bottom==1 then
lib.PicLoadCache(4,224*2,173,351,1)
elseif bottom==2 then
lib.PicLoadCache(4,225*2,173,367,1)
elseif bottom==3 then
lib.PicLoadCache(4,226*2,317,351,1)
end
--µÀ¾ß
for i=1,8 do
local tid=JY.Person[cid]["µÀ¾ß"..i]
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["Ãû³Æ"],M_White,16)
DrawString(562,176+i*18,"£¯"..((JY.Item[tid]["ÀàĞÍ"]==12 and JY.Item[tid]["×°±¸Î»"]==3) and "ƒsv" or (JY.Item[tid]["ÀàĞÍ"]==13 and JY.Item[tid]["×°±¸Î»"]==0) and "ƒT„h" or kind[JY.Item[tid]["ÀàĞÍ"]]),M_White,16)
else
if i==1 then
DrawString(466,176+i*18,"m‚CƒBG ‚aKLM.",M_White,16)
end
break
end
end
ReFresh()
subframe=subframe+1
if subframe==8 then
frame=1-frame
subframe=0
end
end
--ko 3.6 later: ì¶œì§„ í¸ì„± 1~3. Saving keeps the generals picked now (not the ones the story sends anyway); loading drops
--  the current picks and picks the saved ones in order, with the same slot / cost checks as a click (who is missing,
--  already fixed or over the budget is skipped). Kept in ko_settings.lua (CC.koParty1..3), shared by every save.
local function koPartyList(k)
local t={}
for id in string.gmatch(CC["koParty"..k] or "","%d+") do t[#t+1]=tonumber(id) end
return t
end
local function koPartyText(k)
local t=koPartyList(k)
if #t==0 then return "\130\080\130\083 \132\079\130\077" end
local s=""
for i=1,math.min(3,#t) do if JY.Person[t[i]] then s=s..JY.Person[t[i]]["\208\213\195\251"].." " end end
if #t>3 then s=s.."\131\107 "..(#t-3).."\130\088" else s=s.."("..#t.."\130\088)" end
return s
end
local function koPartyLoad(list)
for k=1,num do
if TeamSelect.status[k]==1 then
TeamSelect.status[k]=0
koSpent=koSpent-(koC[k] or 0)-koDel()
personnum=personnum+1
end
end
local got,skip=0,0
for _,pid in ipairs(list) do
local idx=nil
for k=1,num do if TeamSelect.id[k]==pid then idx=k break end end
if idx and TeamSelect.status[idx]==0 then
if personnum<=0 and (koLv<=0 or personnum<=-koExtraMax) then
skip=skip+1
elseif koLv>0 and koSpent+(koC[idx] or 0)+koAdd()>koBudget then
skip=skip+1
else
TeamSelect.status[idx]=1
koSpent=koSpent+(koC[idx] or 0)+koAdd()
personnum=personnum-1
got=got+1
end
elseif not idx then
skip=skip+1
end
end
koBuildView()
return got,skip
end
local function koPartyMenu()
local m={}
for k=1,3 do m[k]={"\132\075\131\123 "..k..": "..koPartyText(k),nil,1} end
local s=ShowMenu(m,3,0,0,0,0,0,20,1,16,M_White,M_White)
if not between(s,1,3) then return end
local list=koPartyList(s)
local m2={{"\133\100\133\101\129\091\131\071",nil,(#list>0) and 1 or 0},{"\130\067\131\103 \131\100\135\077 \129\073\131\097\131\109\132\083 \133\102\131\097",nil,1}}
local a=ShowMenu(m2,2,0,0,0,0,0,20,1,16,M_White,M_White)
if a==1 then
local got,skip=koPartyLoad(list)
titlestr="\132\075\131\123 "..s.."\129\083 \133\100\133\101\138\088\129\075\129\076\129\077: "..got.."\130\088"..((skip>0) and (" (\136\102 \131\100\135\077 \129\073\131\097 "..skip.."\130\088)") or "")
elseif a==2 then
local t={}
for k=1,num do if TeamSelect.status[k]==1 then t[#t+1]=TeamSelect.id[k] end end
if #t==0 then titlestr="\131\100\135\077 \129\073\131\097\129\071 \130\097\130\083 \133\102\131\097\129\097\130\067 \130\107\131\116\129\075\129\076\129\077" return end
CC["koParty"..s]=table.concat(t,",")
koSave()
titlestr="\132\075\131\123 "..s.."\129\102 "..#t.."\130\088\129\083 \133\102\131\097\129\080\129\075\129\076\129\077"
end
end
redraw()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
local koE,koK=getkey()
bottom=0
if koE==1 and (koK==1073741899 or koK==1073741904) then--ko 3.1: PageUp / Left
PlayWavE(0) page=limitX(page-1,1,maxpage)
elseif koE==1 and (koK==1073741902 or koK==1073741903) then--ko 3.1: PageDown / Right
PlayWavE(0) page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(koBtn[1].x,390,koBtn[1].x+koBtn[1].w,408) then--ko 3.1: sort key
PlayWavE(0)
local selected=koRosterPickSort(koSortK,koLv>0)
if selected~=nil and selected~=koSortK then
koSortK=selected
page=1
koBuildView()
end
elseif MOUSE.CLICK(koBtn[2].x,390,koBtn[2].x+koBtn[2].w,408) then--ko 3.1: class filter
PlayWavE(0)
local selected=koRosterPicker(koBzList,koRosterClassLabel,koFilt)
if selected~=nil and selected~=koFilt then
koFilt=selected
page=1
koBuildView()
end
elseif MOUSE.CLICK(koBtn[3].x,390,koBtn[3].x+koBtn[3].w,408) then--ko 3.1: selected only
PlayWavE(0)
if koSelOnly then koSelOnly=false koFavOnly=true elseif koFavOnly then koFavOnly=false else koSelOnly=true end--ko 5.1: ì„ íƒë§Œ â†’ â˜…ë§Œ â†’ ì „ì²´
koBuildView() page=1
if koFavOnly and vnum==0 then
koTitleKeep=koTitleKeep or titlestr
titlestr="\136\066\132\125\139\113\131\071\129\111 \129\073\131\097\129\071 \130\097\129\075\129\076\129\077."
elseif koTitleKeep then
titlestr=koTitleKeep koTitleKeep=nil
end
elseif MOUSE.CLICK(304,390,356,408) then--ko 3.6 later: í¸ì„±
PlayWavE(0) koPartyMenu()
elseif MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[11])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
Dark()
lib.Delay(1000)
koExit()
end
elseif MOUSE.HOLD(174,352,204,366) then--page up
bottom=1
elseif MOUSE.HOLD(174,368,204,382) then--page down
bottom=2
elseif MOUSE.HOLD(319,353,362,380) then--close
bottom=3
elseif MOUSE.CLICK(174,352,204,366) then--page up
PlayWavE(0)
page=limitX(page-1,1,maxpage)
elseif MOUSE.CLICK(174,368,204,382) then--page down
PlayWavE(0)
page=limitX(page+1,1,maxpage)
elseif MOUSE.CLICK(319,353,362,380) then--close
PlayWavE(0)
for i=1,CC.OpearteSpeed do
redraw()
end
if WarDrawStrBoxYesNo("„Kƒ{S …X‡RKLM. ƒJƒKKLY?",M_White,true) then
local m,n=1,1
for i=1,30 do
local idx=(i-1)*7
if team[idx+1]==-1 then
m=i
break
end
end
--ko 3.2: over-slot picks get a new team entry on a free tile near the deploy cluster
local koSeeds,koTaken={},{}
for i=1,maxpersonnum do
local idx=(i-1)*7
if team[idx+2]~=nil then
local sx,sy=team[idx+2]+1,team[idx+3]+1
koSeeds[#koSeeds+1]={sx,sy}
koTaken[sy*1000+sx]=true
end
end
for n=1,num do
if TeamSelect.status[n]==1 then
if m<=maxpersonnum then
team[(m-1)*7+1]=TeamSelect.id[n]-1
m=m+1
while m<=maxpersonnum and team[(m-1)*7+1]~=-1 do m=m+1 end--ko 4.0: never over the fixed rows (story allies: Hagu Wei troops, Taishi Ci, Zhao Yun); extra picks go after the table
elseif koCost~=nil and koCost.spot~=nil then
local sx,sy=koCost.spot(JY.Person[TeamSelect.id[n]]["±øÖÖ"],koTaken,koSeeds)
if sx~=nil then
local kb=(m-1)*7
team[kb+1]=TeamSelect.id[n]-1
team[kb+2]=sx-1
team[kb+3]=sy-1
team[kb+4]=team[4] or 0
team[kb+5]=0
team[kb+6]=-1
team[kb+7]=0
koTaken[sy*1000+sx]=true
koSeeds[#koSeeds+1]={sx,sy}
m=m+1
end
end
end
end
CC.koSlotBase=maxpersonnum--ko 3.2: cap the enemy-level average at the map own slots
SelectTerm_sub(fid,team)
Dark()
return
end
elseif koFavCardHit() then--ko 5.1: the â˜… corner of a card toggles ì¦ê²¨ì°¾ê¸° (the card itself is not picked)
PlayWavE(0) koFavToggle(koFavC.hit)
if koFavOnly then koBuildView() page=math.min(page,maxpage) end
elseif rawget(_G,"koFormSortieHit") and koFormSortieHit(cid) then--ko 5.0: formation
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=view[num_per_page*(page-1)+i]--ko 3.1: through the view
if idx~=nil then
 current=idx
if TeamSelect.status[idx]==0 then
	if personnum<=0 and (koLv<=0 or personnum<=-koExtraMax) then
		PlayWavE(2)
		titlestr="„l GC †~‚BX q ‚aKLM."
		for n=1,20 do
			redraw()
		lib.GetKey()
		end
		titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?"
	else
		cid=TeamSelect.id[current]
		--ko 3.1: the two-empty-item-slots rule of the fuke sortie screen is gone (a full bag never blocks anything else)
		if koLv>0 and koSpent+(koC[idx] or 0)+koAdd()>koBudget then
			PlayWavE(2)
			titlestr="\133\103\131\098 \138\072\131\126\141\074\129\094 \130\094\132\082\129\087\129\076\129\077."
			for n=1,20 do
				redraw()
				lib.GetKey()
			end
			titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?"
		else
			PlayWavE(0)
			TeamSelect.status[idx]=1
			koSpent=koSpent+(koC[idx] or 0)+koAdd()
			personnum=personnum-1
		end
	end
elseif TeamSelect.status[idx]==1 then
	PlayWavE(1)
	TeamSelect.status[idx]=0
	koSpent=koSpent-(koC[idx] or 0)-koDel()
	personnum=personnum+1
	if koSelOnly then koBuildView() end--ko 3.1
else
	PlayWavE(2)
	titlestr="ƒ[ Iƒaƒb BdX q ‚aKLM."
	for n=1,20 do
		redraw()
		lib.GetKey()
	end
	titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?"
end
end
break
end
end
for i=1,8 do
if MOUSE.CLICK(466,176+i*18,626,176+16+i*18) then
cid=TeamSelect.id[current]
local item=JY.Person[cid]["µÀ¾ß"..i]
if item>0 then
PlayWavE(0)
DrawItemStatus(item,cid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
end
break
end
end
end
end
end

--Ñ¡ÔñÎÒ¾ü£¬Á¬Ğø³öÕ½Ê±Ê¹ÓÃ
--fid,¾ıÖ÷id Ò»°ãÓ¦¸ÃÊÇ1£¬Áõ±¸
--team,ÎÒ¾ü²ÎÕ½ÈËÔ±ÅäÖÃÊı¾İ,idÎª-1Ê±¿ÉÑ¡Ôñ,·ñÔòÎªÇ¿ÖÆ³öÕ½
function SelectTerm2(fid,team)
JY.Base["ÊÂ¼ş1995"]=0 JY.Base["ÊÂ¼ş1994"]=0--ko 3.0
local num=0
JY.Base["ÊÂ¼ş1995"]=(koLv>0) and koBudget or 0--ko 3.0: cost reward bookkeeping
JY.Base["ÊÂ¼ş1994"]=(koLv>0) and koSpent or 0
local m,n=1,1
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==fid then
num=num+1
end
end
for i=1,20 do
local idx=(i-1)*7
if team[idx+1]==-1 then
m=i
break
end
end
for n=1,num do
if TeamSelect.status[n]==1 then
team[(m-1)*7+1]=TeamSelect.id[n]-1
m=m+1
end
end
for i=1,20 do
local idx=(i-1)*7
if team[idx+7]==nil then
break
end
if team[idx+1]>=0 and (team[idx+6]==-1 or GetFlag(team[idx+6])) then
--¶îÍâ+1ÓÃÓÚĞŞ¸´yjzÊı¾İºÍ¸´¿ÌÊı¾İµÄ²»Ò»ÖÂ
team[idx+1]=team[idx+1]+1
team[idx+2]=team[idx+2]+1
team[idx+3]=team[idx+3]+1
local wid=GetWarID(team[idx+1])
War.Person[wid].x=team[idx+2]
War.Person[wid].y=team[idx+3]
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=team[idx+4]
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if team[idx+7]>0 then
War.Person[War.PersonNum].hide=true
elseif War.Person[wid].live then
SetWarMap(team[idx+2],team[idx+3],2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end
end

--Ñ¡ÔñÎÒ¾ü£¬Á¬Ğø³öÕ½Ê±Ê¹ÓÃ
--fid,¾ıÖ÷id Ò»°ãÓ¦¸ÃÊÇ1£¬Áõ±¸
--team,ÎÒ¾ü²ÎÕ½ÈËÔ±ÅäÖÃÊı¾İ,ĞŞ¸ÄºóµÄ°æ±¾
function SelectTerm2(fid,team)
--ko 3.2: the army can outnumber the table (over-slot picks); seed a spot search with the table's coordinates
local koSeeds,koTaken={},{}
for i=1,30 do
local idx=(i-1)*7
if team[idx+7]==nil then
break
end
local sx,sy=team[idx+2]+1,team[idx+3]+1
koSeeds[#koSeeds+1]={sx,sy}
koTaken[sy*1000+sx]=true
end
for wid=1,War.PersonNum do
local idx=(wid-1)*7
local px,py,pd
if team[idx+7]~=nil then
px=team[idx+2]+1 py=team[idx+3]+1 pd=team[idx+4]
elseif koCost~=nil and koCost.spot~=nil and #koSeeds>0 then
local sx,sy=koCost.spot(JY.Person[War.Person[wid].id]["±øÖÖ"],koTaken,koSeeds)
if sx~=nil then
px=sx py=sy pd=team[4] or 0
koTaken[sy*1000+sx]=true
koSeeds[#koSeeds+1]={sx,sy}
end
end
if px~=nil then
War.Person[wid].x=px
War.Person[wid].y=py
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=pd
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if War.Person[wid].live then
SetWarMap(px,py,2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end
end

--Ñ¡ÔñÎÒ¾ü
--T,ÎÒ¾ü²ÎÕ½ÈËÔ±ÅäÖÃÊı¾İ
function SelectTerm_sub(fid,T)
if fid==1 and koStoryBattleAlly then
for idx=0,#T-7,7 do
if T[idx+1]>=0 then T[idx+1]=koStoryBattleAlly(T[idx+1]+1)-1 end
end
end
JY.Base["ÊÂ¼ş1995"]=0 JY.Base["ÊÂ¼ş1994"]=0--ko 3.0: cost reward bookkeeping (no free selection = no reward)
for i=1,30 do
local idx=(i-1)*7
if T[idx+7]==nil then
break
end
if T[idx+1]>=0 and (T[idx+6]==-1 or GetFlag(T[idx+6])) then
--¶îÍâ+1ÓÃÓÚĞŞ¸´yjzÊı¾İºÍ¸´¿ÌÊı¾İµÄ²»Ò»ÖÂ
T[idx+1]=T[idx+1]+1
T[idx+2]=T[idx+2]+1
T[idx+3]=T[idx+3]+1
War.PersonNum=War.PersonNum+1
table.insert(War.Person, {
id=T[idx+1],--ÈËÎïID
x=T[idx+2],--×ø±êX
y=T[idx+3],--×ø±êY
--pic=JY.Person[T[idx+1]]["Õ½¶·¶¯×÷"],--ĞÎÏóID
action=1,--¶¯×÷ 0¾²Ö¹£¬1×ßÂ·...
effect=0,--¸ßÁÁÏÔÊ¾
hurt=-1,--ÏÔÊ¾ÉËº¦ÊıÖµ
bz=JY.Person[T[idx+1]]["±øÖÖ"],
movewav=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["ÒôĞ§"],--ÒÆ¶¯ÒôĞ§
atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["¹¥»÷ÒôĞ§"],--¹¥»÷ÒôĞ§
movestep=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["ÒÆ¶¯"],--ÒÆ¶¯·¶Î§
movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["ÒÆ¶¯ËÙ¶È"],--ÒÆ¶¯ËÙ¶È
atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["¹¥»÷·¶Î§"],--¹¥»÷·¶Î§
sq_limited=100,
atk_buff=0,
def_buff=0,
frame=-1,--ÏÔÊ¾Ö¡Êı
d=T[idx+4],--·½Ïò
active=true,--¿É·ñĞĞ¶¯
enemy=false,--µĞ¾üÎÒ¾ü
friend=false,--ÓÑ¾ü£¿
ai=1,--AIÀàĞÍ
live=true,--´æ»î
hide=false,--·ü±ø
was_hide=false,--·ü±ø
troubled=false,--»ìÂÒ
leader=false,
})
if War.Leader1==T[idx+1] then
War.Person[War.PersonNum].leader=true
end
if JY.Person[T[idx+1]]["¾ıÖ÷"]~=fid then
War.Person[War.PersonNum].friend=true
end
if T[idx+7]>0 then
War.Person[War.PersonNum].hide=true
War.Person[War.PersonNum].was_hide=true
else
SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum)
end
ReSetAttrib(T[idx+1],true)
War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum)
end
end
if CC.Enhancement then
local lv_t={}
local cz=0
for i=1,War.PersonNum do
if JY.Person[War.Person[i].id]["¾ıÖ÷"]==1 then
table.insert(lv_t,JY.Person[War.Person[i].id]["µÈ¼¶"])
cz=cz+1
end
end
table.sort(lv_t,function(a,b)return b<a end)
for ii=1,cz do
table.insert(lv_t,1)
end
local lv=0
for ii=1,cz do
lv=lv+lv_t[ii]
end
lv=math.modf(lv/cz)--µÃµ½ÎÒ¾üÆ½¾ùµÈ¼¶
if lv>=0 then
else--Èç¹û»ñÈ¡ÎÒ·½³öÕ½ÈËÔ±Æ½¾ùµÈ¼¶Ê§°Ü£¬ÄÇ¾ÍÖ»ÓĞÒ»ÖÖ¿ÉÄÜ£¬¾ÍÊÇÁ¬Õ½
lv=pjlv()--ËùÒÔÕâÀïÖ»ÄÜ»ñÈ¡ÎÒ·½È«¾üµÄÆ½¾ùµÈ¼¶
end
CC.lv=lv
JY.Base["ÎÒ¾üµÈ¼¶"]=CC.lv --°ÑµÈ¼¶Ğ´Èërµµ£¬ÒÔ±ãµ÷ÓÃ
end
CC.koSlotBase=nil--ko 3.2



end

--Ñ¡ÔñµĞ¾ü
function SelectEnemy(T)
if koStoryPrepareEnemy then
for idx=0,#T-11,11 do
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
koStoryPrepareEnemy(T[idx+1]+1)
end
end
end
JY.Base["È«¾ü³·ÍË"]=JY.EventID
koNG.mark()
local lvoffset=0
if CC.Enhancement then
local elv_sum=1
local num=0
for i=1,99 do
local idx=(i-1)*11
if T[idx+11]==nil then
break
end
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
elv_sum=elv_sum+T[idx+6]
num=num+1
end
end
local elv=math.modf(elv_sum/num)--Êµ¼ÊµĞ¾üÆ½¾ùµÈ¼¶
if CC.lv==nil then
CC.lv=JY.Base["ÎÒ¾üµÈ¼¶"]
end
lvoffset=math.modf(limitX(CC.lv-elv+elv/10,0,99))--µÃµ½ÎÒ¾üÆ½¾ùµÈ¼¶ºÍµĞ¾üÆ½¾ùµÈ¼¶µÄ²îÖµ
end
for i=1,99 do
local idx=(i-1)*11
if T[idx+11]==nil then
break
end
if T[idx+1]>=0 and (T[idx+10]==-1 or GetFlag(T[idx+10])) then
--¶îÍâ+1ÓÃÓÚĞŞ¸´yjzÊı¾İºÍ¸´¿ÌÊı¾İµÄ²»Ò»ÖÂ
T[idx+1]=T[idx+1]+1
T[idx+2]=T[idx+2]+1
T[idx+3]=T[idx+3]+1
JY.Person[T[idx+1]]["µÈ¼¶"]=T[idx+6]+lvoffset
JY.Person[T[idx+1]]["±øÖÖ"]=T[idx+7]
War.PersonNum=War.PersonNum+1
War.EnemyNum=War.EnemyNum+1
table.insert(War.Person, {
id=T[idx+1],--ÈËÎïID
x=T[idx+2],--×ø±êX
y=T[idx+3],--×ø±êY
action=1,--¶¯×÷ 0¾²Ö¹£¬1×ßÂ·...
effect=0,--¸ßÁÁÏÔÊ¾
hurt=-1,--ÏÔÊ¾ÉËº¦ÊıÖµ
bz=JY.Person[T[idx+1]]["±øÖÖ"],
movewav=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["ÒôĞ§"],--ÒÆ¶¯ÒôĞ§
atkwav=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["¹¥»÷ÒôĞ§"],--¹¥»÷ÒôĞ§
movestep=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["ÒÆ¶¯"],--ÒÆ¶¯·¶Î§
movespeed=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["ÒÆ¶¯ËÙ¶È"],--ÒÆ¶¯ËÙ¶È
atkfw=JY.Bingzhong[JY.Person[T[idx+1]]["±øÖÖ"]]["¹¥»÷·¶Î§"],--¹¥»÷·¶Î§
sq_limited=100,
atk_buff=0,
def_buff=0,
frame=-1,--ÏÔÊ¾Ö¡Êı
d=T[idx+4],--·½Ïò
active=true,--¿É·ñĞĞ¶¯
enemy=true,--µĞ¾üÎÒ¾ü
friend=false,--ÓÑ¾ü£¿
ai=T[idx+5],--AIÀàĞÍ
aitarget=T[idx+8]+1,
ai_dx=T[idx+8]+1,
ai_dy=T[idx+9]+1,
live=true,--´æ»î
hide=false,--·ü±ø
was_hide=false,--·ü±ø
troubled=false,--»ìÂÒ
leader=false,
})
if War.Leader2==T[idx+1] then
War.Person[War.PersonNum].leader=true
end
if T[idx+11]>0 then
War.Person[War.PersonNum].hide=true
War.Person[War.PersonNum].was_hide=true
else
SetWarMap(T[idx+2],T[idx+3],2,War.PersonNum)
end
ReSetAttrib(T[idx+1],true)
War.Person[War.PersonNum].pic=WarGetPic(War.PersonNum)
end
end
War.CX=limitX(War.Person[1].x-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(War.Person[1].y-math.modf(War.MD/2),1,War.Depth-War.MD+1)
--ÉèÖÃ×İºáÄ£Ê½ÏÂµÄÓÑ¾üºÍµĞ¾üµÈ¼¶

if CC.Enhancement then
	for i=1,War.PersonNum do
		if JY.Person[War.Person[i].id]["¾ıÖ÷"]~=1 then
			if War.Person[i].friend and not CC.koFree and (CC.lv or 0)>JY.Person[War.Person[i].id]["µÈ¼¶"] then JY.Person[War.Person[i].id]["µÈ¼¶"]=math.min(CC.lv,99) end--ko 11-15: allied AI units (friend) are brought up to the deployed army average like the enemy (cafe: ìš°êµ° ë ˆë²¨); the fixlv "original" option sets CC.lv 0 here = no change
			if JY.Person[War.Person[i].id]["µÈ¼¶"]<lvoffset-4 then
				JY.Person[War.Person[i].id]["µÈ¼¶"]=JY.Person[War.Person[i].id]["µÈ¼¶"]+lvoffset			
			end
			if JY.Person[1]["ÃØ¼¼1"]==0 then
				if War.Person[i].enemy then
					ptlv=limitX(math.modf(pjlv()/10),0,3)			
					JY.Person[War.Person[i].id]["µÈ¼¶"]=JY.Person[War.Person[i].id]["µÈ¼¶"]+ptlv
				end
			else
				if War.Person[i].enemy then
					JY.Person[War.Person[i].id]["µÈ¼¶"]=JY.Person[War.Person[i].id]["µÈ¼¶"]+JY.Person[1]["·ÜÕ½"]
				end
			end
			if War.Person[i].enemy then --×İºáÄ£Ê½ÏÂ£¬µĞ¾ü°´ÕÕµÈ¼¶×Ô¶¯Éı¼¶±øÖÖ
				if JY.Person[War.Person[i].id]["µÈ¼¶"]>=15 then
					if JY.Person[War.Person[i].id]["±øÖÖ"]==1 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=2
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==4 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=5
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==7 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=8
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==10 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=11
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==23 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=24
					end
				end
				if JY.Person[War.Person[i].id]["µÈ¼¶"]>=30 then
					if JY.Person[War.Person[i].id]["±øÖÖ"]==2 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=3
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==5 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=6
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==8 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=9
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==11 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=12
					elseif JY.Person[War.Person[i].id]["±øÖÖ"]==24 then
						JY.Person[War.Person[i].id]["±øÖÖ"]=25
					end
				end
			end
		end
		local id=i
		local bzid=JY.Person[War.Person[id].id]["±øÖÖ"]
		War.Person[id].bz=bzid
		War.Person[id].movewav=JY.Bingzhong[bzid]["ÒôĞ§"]--ÒÆ¶¯ÒôĞ§
		War.Person[id].atkwav=JY.Bingzhong[bzid]["¹¥»÷ÒôĞ§"]--¹¥»÷ÒôĞ§
		War.Person[id].movestep=JY.Bingzhong[bzid]["ÒÆ¶¯"]--ÒÆ¶¯·¶Î§
		War.Person[id].movespeed=JY.Bingzhong[bzid]["ÒÆ¶¯ËÙ¶È"]--ÒÆ¶¯ËÙ¶È
		War.Person[id].atkfw=JY.Bingzhong[bzid]["¹¥»÷·¶Î§"]--¹¥»÷·¶Î§
		War.Person[id].pic=WarGetPic(id)
		ReSetAttrib(War.Person[i].id,true)--ÖØĞÂ¼ÆËãÕ½³¡ÊôĞÔ£¿
--		if JY.Person[1]["ÃØ¼¼1"]==1 then
--			WarSave(6)
--		end
	end
end
koDeployHidden()
end

--ko sortie option: deploy every hidden ENEMY at battle start (Enhancement mode only)
function koDeployHidden()
if not CC.Enhancement then return end
if (JY.Base["ÎŞÓÃ4"] or 0)<=0 then return end
--ko sortie: keep ambushers that sit within 3 tiles of a deployed ally hidden,
--            so a battle cannot open with the party already surrounded
for wid=1,War.PersonNum do
local v=War.Person[wid]
if v.enemy and v.live and v.hide then
local md=999
for j=1,War.PersonNum do
local a=War.Person[j]
if (not a.enemy) and a.live and (not a.hide) then
local d=math.max(math.abs(v.x-a.x),math.abs(v.y-a.y))
if d<md then md=d end
end
end
if md>3 then
local nx,ny=WarGetExistXY(v.x,v.y,wid)
if WarCanExistXY(nx,ny,wid) then
v.x=nx
v.y=ny
v.hide=false
SetWarMap(nx,ny,2,wid)
end
end
end
end
end

function DefineWarMap(id,warname,wartarget,maxturn,leader1,leader2)
War.MapID=id
War.WarName=warname
War.WarTarget=wartarget
War.MaxTurn=maxturn
War.Leader1=leader1+1
War.Leader2=leader2+1
LoadWarMap(War.MapID)
end

function WarStart()
JY.SubScene=-1
--ko: most battles are ended by the event script itself (duel won, named enemy routed, spot reached ...)
--    without passing WarCheckStatus/koWinCount, so count here: any battle that ends with the story going on
--    and whose counter did not move during the battle is one more win. Excluded: defeat (turn limit / leader
--    lost, even when the story continues), game over, title replay mode, loading a non-battle save mid-battle.
koWar={base=JY.Base["ÊÂ¼ş1999"] or 0,lost=false,abort=false}
SRPG()
local kw=koWar
koWar=false
if kw and not kw.lost and not kw.abort and not CC.koReplay
 and JY.Status~=GAME_WMAP and JY.Status~=GAME_WMAP2 and JY.Status~=GAME_WARLOSE
 and JY.Status~=GAME_START and JY.Status~=GAME_DEAD and JY.Status~=GAME_END
 and JY.EventID~=999--ko 3.3: event 999 = game over
 and (JY.Base["ÊÂ¼ş1999"] or 0)==kw.base then
koWinCount()
end
if kw and not kw.lost and not kw.abort and not CC.koReplay and JY.Status~=GAME_WMAP and JY.Status~=GAME_WARLOSE and JY.Status~=GAME_START and JY.Status~=GAME_DEAD and JY.EventID~=999 and JY.Status~=GAME_END and (JY.Base["ÊÂ¼ş1999"] or 0)>kw.base then koHook("war_won") end--ko 3.3
end

--±£´æÕ½³¡
function WarSave(id)
Byte.set8(JY.Data_Base,136,War.MapID)
Byte.set8(JY.Data_Base,137,War.Width)
Byte.set8(JY.Data_Base,138,War.Depth)
Byte.set8(JY.Data_Base,139,War.CX)
Byte.set8(JY.Data_Base,140,War.CY)
Byte.set16(JY.Data_Base,141,War.PersonNum)
Byte.set8(JY.Data_Base,143,War.Weather)
Byte.set8(JY.Data_Base,144,War.Turn)
Byte.set8(JY.Data_Base,145,War.MaxTurn)
Byte.set16(JY.Data_Base,146,War.Leader1)
Byte.set16(JY.Data_Base,148,War.Leader2)
Byte.set8(JY.Data_Base,150,War.EnemyNum)
JY.Base["Õ½³¡Ãû³Æ"]=War.WarName
JY.Base["Õ½³¡Ä¿±ê"]=War.WarTarget
local offset=152
for i=1,War.PersonNum do
Byte.set16(JY.Data_Base,offset,War.Person[i].id)
Byte.set8(JY.Data_Base,offset+2,War.Person[i].x)
Byte.set8(JY.Data_Base,offset+3,War.Person[i].y)
Byte.set8(JY.Data_Base,offset+4,War.Person[i].d)
Byte.set8(JY.Data_Base,offset+5,War.Person[i].ai)
Byte.set16(JY.Data_Base,offset+6,War.Person[i].aitarget)
Byte.set8(JY.Data_Base,offset+8,War.Person[i].ai_dx)
Byte.set8(JY.Data_Base,offset+9,War.Person[i].ai_dy)
local v=0
if War.Person[i].enemy then
v=v+1
end
if War.Person[i].friend then
v=v+2
end
if War.Person[i].active then
v=v+4
end
if War.Person[i].live then
v=v+8
end
if War.Person[i].hide then
v=v+16
end
if War.Person[i].was_hide then
v=v+32
end
if War.Person[i].troubled then
v=v+64
end
Byte.set8(JY.Data_Base,offset+10,v)
Byte.set8(JY.Data_Base,3151+i,War.Person[i].poison or 0)
offset=offset+11
end
--Map
offset=1152
for i=1,War.Width*War.Depth do
local v=War.Map[i]+32*War.Map[War.Width*War.Depth*(9-1)+i]
 Byte.set8(JY.Data_Base,offset+i,v)
end
--Save
SaveRecord(id)
end

--¶ÁÈ¡Õ½³¡
function WarLoad(id)
WarIni()
--War basic informaction
War.MapID=Byte.get8(JY.Data_Base,136)
War.Width=Byte.get8(JY.Data_Base,137)
War.Depth=Byte.get8(JY.Data_Base,138)
War.CX=Byte.get8(JY.Data_Base,139)
War.CY=Byte.get8(JY.Data_Base,140)
War.PersonNum=Byte.get16(JY.Data_Base,141)
War.Weather=Byte.get8(JY.Data_Base,143)
War.Turn=Byte.get8(JY.Data_Base,144)
War.MaxTurn=Byte.get8(JY.Data_Base,145)
War.Leader1=Byte.get16(JY.Data_Base,146)
War.Leader2=Byte.get16(JY.Data_Base,148)
War.EnemyNum=Byte.get8(JY.Data_Base,150)
War.WarName=JY.Base["Õ½³¡Ãû³Æ"]
War.WarTarget=JY.Base["Õ½³¡Ä¿±ê"]
--Map
War.MiniMapCX=680-War.Width*2
War.MiniMapCY=411-War.Depth*2
War.Map={}
CleanWarMap(1,0)--µØĞÎ
CleanWarMap(2,0)--wid
CleanWarMap(3,0)--
CleanWarMap(4,1)--Ñ¡Ôñ·¶Î§
CleanWarMap(5,-1)--¹¥»÷¼ÛÖµ
CleanWarMap(6,-1)--²ßÂÔ¼ÛÖµ
CleanWarMap(7,0)--Ñ¡ÔñµÄ²ßÂÔ
CleanWarMap(8,0)--AIÇ¿»¯ÓÃ£¬ÎÒ¾üµÄ¹¥»÷·¶Î§
CleanWarMap(9,0)--Ë®»ğ¿ØÖÆ
CleanWarMap(10,0)--¹¥»÷·¶Î§£¬ÏÔÊ¾ÓÃ
local offset=1152
for i=1,War.Width*War.Depth do
local v=Byte.get8(JY.Data_Base,offset+i)
local v1=v%32
local v2=math.modf(v/32)
War.Map[i]=v1
War.Map[War.Width*War.Depth*(9-1)+i]=v2
end
--War.Person
offset=152
for i=1,War.PersonNum do
War.Person[i]={}
War.Person[i].id=Byte.get16(JY.Data_Base,offset)
War.Person[i].x=Byte.get8(JY.Data_Base,offset+2)
War.Person[i].y=Byte.get8(JY.Data_Base,offset+3)
War.Person[i].d=Byte.get8(JY.Data_Base,offset+4)
War.Person[i].ai=Byte.get8(JY.Data_Base,offset+5)
War.Person[i].aitarget=Byte.get16(JY.Data_Base,offset+6)
War.Person[i].ai_dx=Byte.get8(JY.Data_Base,offset+8)
War.Person[i].ai_dy=Byte.get8(JY.Data_Base,offset+9)
War.Person[i].poison=Byte.get8(JY.Data_Base,3151+i)
local v=Byte.get8(JY.Data_Base,offset+10)
if v%2==1 then
War.Person[i].enemy=true
else
War.Person[i].enemy=false
end
if (math.modf(v/2))%2==1 then
War.Person[i].friend=true
else
War.Person[i].friend=false
end
if (math.modf(v/4))%2==1 then
War.Person[i].active=true
else
War.Person[i].active=false
end
if (math.modf(v/8))%2==1 then
War.Person[i].live=true
else
War.Person[i].live=false
end
if (math.modf(v/16))%2==1 then
War.Person[i].hide=true
else
War.Person[i].hide=false
end
if (math.modf(v/32))%2==1 then
War.Person[i].was_hide=true
else
War.Person[i].was_hide=false
end
if (math.modf(v/64))%2==1 then
War.Person[i].troubled=true
else
War.Person[i].troubled=false
end
local pid=War.Person[i].id
War.Person[i].action=1--¶¯×÷ 0¾²Ö¹£¬1×ßÂ·...
War.Person[i].effect=0--¸ßÁÁÏÔÊ¾
War.Person[i].hurt=-1--ÏÔÊ¾ÉËº¦ÊıÖµ
War.Person[i].bz=JY.Person[pid]["±øÖÖ"]
War.Person[i].movewav=JY.Bingzhong[JY.Person[pid]["±øÖÖ"]]["ÒôĞ§"]--ÒÆ¶¯ÒôĞ§
War.Person[i].atkwav=JY.Bingzhong[JY.Person[pid]["±øÖÖ"]]["¹¥»÷ÒôĞ§"]--¹¥»÷ÒôĞ§
War.Person[i].movestep=JY.Bingzhong[JY.Person[pid]["±øÖÖ"]]["ÒÆ¶¯"]--ÒÆ¶¯·¶Î§
War.Person[i].movespeed=JY.Bingzhong[JY.Person[pid]["±øÖÖ"]]["ÒÆ¶¯ËÙ¶È"]--ÒÆ¶¯ËÙ¶È
War.Person[i].atkfw=JY.Bingzhong[JY.Person[pid]["±øÖÖ"]]["¹¥»÷·¶Î§"]--¹¥»÷·¶Î§
War.Person[i].sq_limited=100
War.Person[i].atk_buff=0
War.Person[i].def_buff=0
War.Person[i].frame=-1--ÏÔÊ¾Ö¡Êı
if pid==War.Leader1 or pid==War.Leader2 then
War.Person[i].leader=true
else
War.Person[i].leader=false
end
if War.Person[i].live and (not War.Person[i].hide) then
SetWarMap(War.Person[i].x,War.Person[i].y,2,i)
end
ReSetAttrib(pid,false)
War.Person[i].pic=WarGetPic(i)
WarResetStatus(i)
offset=offset+11
end
end

--ÌáÊ¾ÊÇ·ñ±£´æ
--flag, Ä¬ÈÏÎª1 1Õ½Ç°ÌáÊ¾ 2Õ½ºóÌáÊ¾
function RemindSave(flag)
flag=flag or 1
if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_START--½ö½öÊÇÎªÁË·½±ã×Ô¶¯¼ÆËã×ø±ê
end

	if WarDrawStrBoxYesNo("‚Cƒg …fƒaXYZ?",M_White,true) then
		local menu2={
		{" 1. ",nil,1},
		{" 2. ",nil,1},
		{" 3. ",nil,1},
		{" 4. ",nil,1},
		{" 5. ",nil,1},
		{" 6. ",nil,1},
		{" 7. ",nil,1},
		{" 8. ",nil,1},
		{" 9. ",nil,1},
		{"10. ",nil,1},
		}
		for id=1,10 do
			if not fileexist(CC.R_GRPFilename[id]) then
				menu2[id][1]=menu2[id][1].."…i …j…k"
			else
				menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
			end
		end
		while true do--koSaveAsk 5.0: "no" on the slot question goes back to the list (10-10)
		DrawYJZBox2(-1,40,"‚SƒZf …fƒaXYZ?",M_White)--ko 3.0: above the 10/11-row menu
		local s2=ShowMenu(menu2,10,0,0,0,0,0,20,1,16,M_White,M_White)
		if not between(s2,1,10) then break end
			if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚Wf …fƒaWLM. ƒJƒKKLY?",koSlotNo(s2)),M_White,true) then
				if flag==2 then
					JY.Status=GAME_SMAP_AUTO--ÓëÇ°Ãæ¶ÔÓ¦£¬¸Ä»ØÀ´
				end
			SaveRecord(s2)
			break
			end
		end
	end

if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_SMAP_AUTO--ÓëÇ°Ãæ¶ÔÓ¦£¬¸Ä»ØÀ´
end
end
local koRawRemindSave=RemindSave--ko 5.0: mark the save prompt so the save list does not paint the title behind it (10-10)
function RemindSave(...)
rawset(_G,"koRemindSave",true)
local r={pcall(koRawRemindSave,...)}
rawset(_G,"koRemindSave",nil)
if not r[1] then error(r[2],0) end
return (table.unpack or unpack)(r,2)
end

--µÈ¼¶ÉÏÉı
--pid ÈËÎïid, n Ä¬ÈÏÎª1
function koStoryScenarioLevelUp(pid,...)
if not (koStoryKeepsTraining and koStoryKeepsTraining(pid)) then return LvUp(pid,...) end
end

function LvUp(pid,n)
pid=pid or 0
n=n or 1
if pid>0 then
JY.Person[pid]["µÈ¼¶"]=limitX(JY.Person[pid]["µÈ¼¶"]+n,1,99)
end
end

--²âÊÔµ½´ïÕ½³¡×ø±ê
--pid ÈËÎïid, -1Ê±ÎªÈÎÒâÎÒ·½Îä½«
function WarCheckLocation(pid,y,x)
--pid=-1´ú±íÈÎÒâÎÒ·½ÎÒ½«
pid=pid+1--ĞŞÕı
x=x+1
y=y+1
if War.SelID==0 then
return false
end
local v=War.Person[War.SelID]
if v.live and (not v.hide) and ((pid==0 and (not v.enemy) and (not v.friend)) or (koStoryBattleSource and koStoryBattleSource(pid) or pid)==v.id) and x==v.x and y==v.y then
return true
end
return false
end

--²âÊÔµ½´ïÕ½³¡×ø±êµÃµ½ÎïÆ·
--x,y ×ø±ê, item ÎïÆ·id, event ¼ì²éÊÂ¼şid
function WarLocationItem(y,x,item,event)
if War.SelID==0 then
return false
end
if JY.Person[War.Person[War.SelID].id]["µÀ¾ß8"]>0 then
return false
end
x=x+1
y=y+1
if (not GetFlag(event)) then
local v=War.Person[War.SelID]
if v.live and (not v.hide) and (not v.enemy) and (not v.friend) and x==v.x and y==v.y then
WarGetItem(War.SelID,item)
SetFlag(event,1)
end
end
end

--²âÊÔµ½´ïÕ½³¡×ø±ê
--pid ÈËÎïid, -1Ê±ÎªÈÎÒâÎÒ·½Îä½«
function WarCheckArea(pid,y1,x1,y2,x2)
--pid=-1´ú±íÈÎÒâÎÒ·½ÎÒ½«
pid=pid+1--ĞŞÕı
x1=x1+1
y1=y1+1
x2=x2+1
y2=y2+1
if War.SelID==0 then
return false
end
local v=War.Person[War.SelID]
if v.live and (not v.hide) and ((pid==0 and (not v.enemy)) or pid==v.id) and between(v.x,x1,x2) and between(v.y,y1,y2) then
return true
end
return false
end

function GetWarID(pid)
for i,v in pairs(War.Person) do
if pid==v.id then
return i
end
end
local ally=koStoryBattleAlly and koStoryBattleAlly(pid) or pid
if ally~=pid then
for i,v in pairs(War.Person) do
if ally==v.id then return i end
end
end
return 0
end

function WarMeet(pid1,pid2)
local id1,id2=0,0
if War.SelID==0 then
return false
end
if pid1==-1 then--²»ÏŞ¶¨ÌØµãÈËÎï
if War.Person[War.SelID].enemy then--±ØĞë²»ÎªµĞ¾ü
return false
else
id1=War.SelID
pid1=War.Person[War.SelID].id
end
elseif War.Person[War.SelID].id==(koStoryBattleSource and koStoryBattleSource(pid1) or pid1) then--Ö¸¶¨ÈËÎï ±ØĞëÎªµ±Ç°ĞĞ¶¯ÈËÎï
id1=War.SelID
pid1=War.Person[id1].id
else
return false
end
id2=GetWarID(pid2)
if id1>0 and id2>0 and
War.Person[id1].live and War.Person[id2].live and 
(not War.Person[id1].hide) and (not War.Person[id2].hide) and 
JY.Person[pid1]["±øÁ¦"]>0 and JY.Person[pid2]["±øÁ¦"]>0 then
if math.abs(War.Person[id1].x-War.Person[id2].x)+math.abs(War.Person[id1].y-War.Person[id2].y)==1 then
return true
end
end
return false
end

-- ÈËÎïÒÆ¶¯µ½Ö¸¶¨×ø±ê
-- pid ÈËÎïid
function WarMoveTo(pid,x,y)
x=x+1
y=y+1
local wid=GetWarID(pid)
if wid>0 then
War.SelID=wid
War_CalMoveStep(wid,256,true)
x,y=WarGetExistXY(x,y,wid)
War_MovePerson(x,y)
CleanWarMap(4,1)
War.LastID=War.SelID
War.SelID=0
end
end

-- ·ü±ø³öÏÖ
-- pid ÈËÎïid
function WarShowArmy(pid)
pid=pid+1--ĞŞÕıid
local wid=GetWarID(pid)
if wid>0 then
if (not War.Person[wid].hide) or (not War.Person[wid].live) then
return
end
local x,y=War.Person[wid].x,War.Person[wid].y
if WarCanExistXY(x,y,wid) then
War.Person[wid].hide=false
WarPersonCenter(wid)
SetWarMap(x,y,2,wid)
PlayWavE(15)
WarDelay(4)
return
end
local DX={0,0,-1,1}
local DY={1,-1,0,0}
local dx={1,-1,1,-1,}
local dy={-1,1,1,-1}
for n=1,8 do
for d=1,4 do
for i=1,n do
local nx=x+DX[d]*n+dx[d]*i
local ny=y+DY[d]*n+dy[d]*i
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
if WarCanExistXY(nx,ny,wid) then
War.Person[wid].x=nx
War.Person[wid].y=ny
War.Person[wid].hide=false
WarPersonCenter(wid)
SetWarMap(nx,ny,2,wid)
PlayWavE(15)
WarDelay(4)
return
end
end
end
end
end
end
end

--Ñ°ÕÒ×î½üµÄ¿ÉÒÔ³öÏÖµÄµØµã
--x,yÄ¿±êµØµã
--widÕ½³¡ÈËÎïid
function WarGetExistXY(x,y,wid)
local DX={0,0,-1,1}
local DY={1,-1,0,0}
local dx={1,-1,1,-1,}
local dy={-1,1,1,-1}
if WarCanExistXY(x,y,wid) then
return x,y
end
for n=1,8 do
for d=1,4 do
for i=1,n do
local nx=x+DX[d]*n+dx[d]*i
local ny=y+DY[d]*n+dy[d]*i
if between(nx,1,War.Width) and between(ny,1,War.Depth) then
if WarCanExistXY(nx,ny,wid) then
return nx,ny
end
end
end
end
end
return War.Person[wid].x,War.Person[wid].y
end

--»ñµÃ»Æ½ğ
--money »Æ½ğÊıÁ¿,Îª¸ºÊıÊ±Ê§È¥»Æ½ğ£¬ÎŞÌáÊ¾
function GetMoney(money)
koSetGold(koGold()+money)--ko 3.0
koHook("gold_gain",money)--ko 3.1

bonus_moneyexp_8()

end

function UseMoney(money)
koSetGold(koGold()-money)--ko 3.0
end

function bonus_moneyexp_8()
local live_cnt=0
local deduce_gold,total_gold,total_exp

if JY.Status==8 and JY.Person[1]["ÃØ¼¼1"]==1 then	
	for i,v in pairs(War.Person) do
		if v.live and (not v.hide) then
			if (not v.enemy) and (not v.friend) then
				live_cnt=live_cnt+1				
				win_exp(v.id)
			end
		end
	end	
	local gd=math.min(JY.Person[1]["·ÜÕ½"],5)
	total_gold=(bonus_money+gold_lv*(gd-1))*live_cnt
	if gd>3 then
		deduce_gold=(gd-3)*gold_lv/2
		total_gold=total_gold-deduce_gold*live_cnt
	end	
	total_exp=(bonus_exp+exp_lv*(JY.Person[1]["·ÜÕ½"]-1))*live_cnt
	koSetGold(koGold()+total_gold)--ko 3.0
	koHook("gold_gain",total_gold)--ko 3.1
	
	WarDrawStrBoxConfirm("D‚B ‚qGD "..JY.Person[1]["·ÜÕ½"].." …c^ ƒsC "..live_cnt.."‚X ‡T "..total_gold.."ƒg ‡U "..total_exp.." ƒMƒ}„Q ƒ@…U",M_White)		
	koHook("battle_won_bonus")--ko 3.1
	os.remove(CC.R_GRPFilename[11])	
end
end

function bonus_moneyexp_4()
local live_cnt=0
local deduce_gold,total_gold,total_exp
if JY.Status==4 and JY.Person[1]["ÃØ¼¼1"]==1 then
	for i,v in pairs(War.Person) do
		if v.live and (not v.hide) then
			if (not v.enemy) and (not v.friend) then
				live_cnt=live_cnt+1				
				win_exp(v.id)
			end
		end
	end
	local gd=math.min(JY.Person[1]["·ÜÕ½"],5)
	total_gold=(bonus_money+gold_lv*(gd-1))*live_cnt
	if gd>3 then
		deduce_gold=(gd-3)*gold_lv/2
		total_gold=total_gold-deduce_gold*live_cnt
	end
	total_exp=(bonus_exp+exp_lv*(JY.Person[1]["·ÜÕ½"]-1))*live_cnt
	GetMoney(total_gold)
	WarDrawStrBoxConfirm("D‚B ‚qGD "..JY.Person[1]["·ÜÕ½"].." …c^ ƒsC "..live_cnt.."‚X ‡T "..total_gold.."ƒg ‡U "..total_exp.." ƒMƒ}„Q ƒ@…U",M_White)
	koHook("battle_won_bonus")--ko 3.1
	os.remove(CC.R_GRPFilename[11])
end
end

function win_exp(pid)
if (JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["ÎäÁ¦"] and JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÖÇÁ¦"]>=zlyz) or  (JY.Person[pid]["±øÖÖ"]==13 or JY.Person[pid]["±øÖÖ"]==16 or JY.Person[pid]["±øÖÖ"]==19 or JY.Person[pid]["±øÖÖ"]==26) then
	if JY.Person[pid]["ÖÇÁ¦"]<=koNG.cap() then
		JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]+bonus_exp	
		if JY.Person[pid]["ÖÇÁ¦¾­Ñé"]>=200 then
			JY.Person[pid]["ÖÇÁ¦¾­Ñé"]=JY.Person[pid]["ÖÇÁ¦¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) ‚Cƒ}ƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=72
                				break
            				end
			end
		end
	elseif JY.Person[pid]["Í³ÂÊ"]<=koNG.cap() then
		JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+bonus_exp		
		if JY.Person[pid]["Í³ÂÊ¾­Ñé"]>=200 then
			JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=73
                				break
            				end
			end
		end
	end
else
	if JY.Person[pid]["ÎäÁ¦"]>=wlyz  and JY.Person[pid]["ÎäÁ¦"]>=JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÎäÁ¦"]<=koNG.cap() then
		JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]+bonus_exp		
		if JY.Person[pid]["ÎäÁ¦¾­Ñé"]>=200 then
			JY.Person[pid]["ÎäÁ¦¾­Ñé"]=JY.Person[pid]["ÎäÁ¦¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) Iƒ}ƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=71
                				break
            				end
			end
		end
	elseif JY.Person[pid]["Í³ÂÊ"]<=koNG.cap() then
		JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]+bonus_exp		
		if JY.Person[pid]["Í³ÂÊ¾­Ñé"]>=200 then
			JY.Person[pid]["Í³ÂÊ¾­Ñé"]=JY.Person[pid]["Í³ÂÊ¾­Ñé"]-200
			PlayWavE(12)
			WarDrawStrBoxWaitKey(JY.Person[pid]["ĞÕÃû"].."G(^) „w„xƒP ƒT„h aƒv‚h …V„kM",M_White)
			for n=1,8 do
				if JY.Person[pid]["µÀ¾ß"..n]==0 then
                				JY.Person[pid]["µÀ¾ß"..n]=73
                				break
            				end
			end
		end
	end
end
end

function change_mode()
local modemenu={}
local nextmode
modemenu[1]={fillblank("ƒs„w ‚Z…w",11),nil,1}
for i=1,koNG.maxdiff() do
	modemenu[i+1]={fillblank("D‚B ‚qGD "..i,13),nil,1}
end
if false then
	::modelist::	
	nextmode=ShowMenu(modemenu,koNG.maxdiff()+1,math.min(koNG.maxdiff()+1,8),0,156,0,0,3,1,16,M_White,M_White)
	if nextmode==0 then
		goto modelist
	elseif nextmode==1 then
		if WarDrawStrBoxYesNo("M‚M ‚B„e‚h ƒs„w ‚Z…w„S g‚]XYZ?",M_White,true) then		
			JY.Person[1]["ÃØ¼¼1"]=0
		else 
			goto modelist
		end
	else
		if WarDrawStrBoxYesNo("M‚M ‚B„e‚h D‚B ‚qGD„S g‚]: "..(nextmode-1)..". ƒJƒKKLY?",M_White,true) then		
			JY.Person[1]["ÃØ¼¼1"]=1
			JY.Person[1]["·ÜÕ½"]=nextmode-1
		else
			goto modelist
		end
	end
end
end

--»ñµÃµÀ¾ß
--pid ÈËÎïid
function GetItem(pid,item)
item=koPromotionItemId(item)
for i=1,8 do
if JY.Person[pid]["µÀ¾ß"..i]==0 then
JY.Person[pid]["µÀ¾ß"..i]=item
PlayWavE(11)
DrawStrBoxWaitKey("ƒCƒD: "..JY.Item[item]["Ãû³Æ"].."£®",M_White)
return true
end
end
return false
end

--»ñµÃµÀ¾ß
--wid ÈËÎïwid
function WarGetItem(wid,item)
item=koPromotionItemId(item)
local pid=War.Person[wid].id
for i=1,8 do
if JY.Person[pid]["µÀ¾ß"..i]==0 then
JY.Person[pid]["µÀ¾ß"..i]=item
PlayWavE(11)
WarDrawStrBoxWaitKey("ƒCƒD: "..JY.Item[item]["Ãû³Æ"].."£®",M_White)
ReSetAttrib(pid,false)
return true
end
end
return false
end

--Ê§È¥µÀ¾ß
--wid ÈËÎïwid
function WarLoseItem(wid,item)
item=koPromotionItemId(item)
local pid=War.Person[wid].id
for i=1,8 do
if JY.Person[pid]["µÀ¾ß"..i]==0 then
JY.Person[pid]["µÀ¾ß"..i]=item
PlayWavE(11)
WarDrawStrBoxWaitKey("ƒCƒD: "..JY.Item[item]["Ãû³Æ"].."£®",M_White)
ReSetAttrib(pid,false)
return true
end
end
return false
end

--²Ğ´æ²¿¶ÓµÃµ½50µã¾­ÑéÖµ£®
--Exp ¾­ÑéÖµ,ÎŞÓÃ
function WarGetExp(Exp)
Exp=50
PlayWavE(0)
lib.GetKey()
local x,y
local w=288
local h=80
x=koMapCenterX(w)
y=koMapCenterY(0)-h/2
local x1=x+205
local y1=y+36
local x2=x1+52
local y2=y1+24
local function redraw(flag)
JY.ReFreshTime=lib.GetTime()
DrawWarMap()
lib.PicLoadCache(4,84*2,x,y,1)
if flag==2 then
lib.PicLoadCache(4,56*2,x1,y1,1)
else
lib.PicLoadCache(4,55*2,x1,y1,1)
end
ReFresh()
end
local current=0
while true do
redraw(current)
getkey()
if MOUSE.HOLD(x1+1,y1+1,x2-1,y2-1) then
current=2
elseif MOUSE.CLICK(x1+1,y1+1,x2-1,y2-1) then
current=0
PlayWavE(0)
redraw(current)
WarDelay(4)
break
else
current=0
end
end
for i,v in pairs(War.Person) do
	if v.live and (not v.hide) then
		if (not v.enemy) and (not v.friend) then
			local pid=v.id
			if JY.Person[pid]["µÈ¼¶"]<99 then
				JY.Person[pid]["¾­Ñé"]=JY.Person[pid]["¾­Ñé"]+Exp
				if JY.Person[pid]["¾­Ñé"]>=100 then
					JY.Person[pid]["¾­Ñé"]=JY.Person[pid]["¾­Ñé"]-100
					WarLvUp(i)
				end
			end
		end
	end
end
end

--ÅĞ¶ÏÊÇ·ñ½øÈë»ìÂÒ×´Ì¬
--wid war_id
--4.·ÀÓù·½ÊÇ·ñ»áÏİÈë»ìÂÒ
--Èç¹ûÇ£ÖÆºó£¬·ÀÓù·½µÄÊ¿ÆøÏÂ½µµ½30ÒÔÏÂ£¬Ôò°´ÒÔÏÂËã·¨ÅĞ¶ÏÊÇ·ñ»áÏİÈë»ìÂÒ¡£
--¼ÆËã³öÒ»¸ö0£­4Ö®¼äµÄËæ»úÊı£¬Èç¹ûËæ»úÊıĞ¡ÓÚ3£¬Ôò·ÀÓù·½²¿¶ÓÏİÈë»ìÂÒ¡£
--¡ºËµÃ÷¡»·ÀÓù·½ÓĞ60£¥µÄ¿ÉÄÜĞÔÏİÈë»ìÂÒ¡£
function WarGetTrouble(wid)
local pid=War.Person[wid].id
if JY.Person[pid]["Ê¿Æø"]<30 and JY.Person[pid]["±øÁ¦"]>0 then
if math.random(5)-1<3 then
if War.Person[wid].troubled then
WarDrawStrBoxDelay(JY.Person[pid]["ĞÕÃû"].."G(^) „l„m ‚c‚df ƒEƒFM!",M_White)
else
War.Person[wid].troubled=true
War.Person[wid].action=7
WarDelay(2)
WarDrawStrBoxDelay(JY.Person[pid]["ĞÕÃû"].."G(^) ‚c‚df ƒEƒFM!",M_White)
end
end
end
end

--»½ĞÑ»ìÂÒÖĞµÄ²¿¶Ó
--wid war_id
--»Ö¸´Òò×Ó£½0¡«99µÄËæ»úÊı£¬Èç¹û»Ö¸´Òò×ÓĞ¡ÓÚ£¨Í³ÓùÁ¦£«Ê¿Æø£©¡Â3£¬ÄÇÃ´²¿¶Ó±»»½ĞÑ£®ÓÉ´Ë¿´³ö£¬Í³ÓùÔ½¸ß£¬Ê¿ÆøÔ½¸ß£¬Ô½ÈİÒ×´Ó»ìÂÒÖĞËÕĞÑ£®
function WarTroubleShooting(wid)
local pid=War.Person[wid].id
if War.Person[wid].troubled then
local flag=false
if math.random(100)-1<(JY.Person[pid]["Í³ÂÊ"]+JY.Person[pid]["Ê¿Æø"])/3 then
flag=true
end
if CC.Enhancement then
if WarCheckSkill(wid,20) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==20 then--³Á×Å
flag=true

end
end
if flag then
WarPersonCenter(wid)
War.Person[wid].troubled=false
WarDrawStrBoxDelay(JY.Person[pid]["ĞÕÃû"].."G(^) ‚c‚dfƒW ‚}‚DPM!",M_White)
end
end
end

--±øÁ¦Ê¿Æø¼õ°ë
--id 1ÎÒ¾ü 2µĞ¾ü
--kind 1±øÁ¦ 2Ê¿Æø
function WarEnemyWeak(id,kind)
for i,v in pairs(War.Person) do
if v.live and (not v.hide) then
if (id==1 and (not v.enemy)) or (id==2 and v.enemy) then
local pid=v.id
if kind==1 then
JY.Person[pid]["±øÁ¦"]=limitX(JY.Person[pid]["±øÁ¦"]/2,1,JY.Person[pid]["×î´ó±øÁ¦"])
elseif kind==2 then
JY.Person[pid]["Ê¿Æø"]=limitX(JY.Person[pid]["Ê¿Æø"]/2,1,v.sq_limited)
ReSetAttrib(pid,false)
WarGetTrouble(i)
end
end
end
end
end

--Ë®»ğ¿ØÖÆ
--x,y×ø±ê,ÊäÈëÎªdos°æ×ø±ê£¬Êµ¼ÊĞèÒª+1ĞŞÕı
--kind 1·Å»ğ 2·ÅË® 3È¡Ïû·ÅË®
function WarFireWater(x,y,kind)
x=x+1
y=y+1
if kind==3 then
SetWarMap(x,y,9,0)
else
if GetWarMap(x,y,2)==0 then
SetWarMap(x,y,9,kind)
end
if kind==1 then
elseif kind==2 then
end
end
War.CX=limitX(x-math.modf(War.MW/2),1,War.Width-War.MW+1)
War.CY=limitX(y-math.modf(War.MD/2),1,War.Depth-War.MD+1)
WarDelay(CC.WarDelay)
end

--¼ì²éÊÇ·ñ¾ßÓĞÄ³Ïî¼¼ÄÜ
--wid ÈËÎïÕ½¶·±àºÅ
--skillid ¼¼ÄÜ±àºÅ
--ko composite innate talents: 121 Bawang = 115 + 117, 122 Cheonmyeong = 1 (virtue magic) + 2 (regen) + 43 (always block)
--ko ƒa‚P xƒG‚b IƒGŠF nL‚f „N‚S‚w¡¤ƒsvfƒWD Fƒd, ‚B„o xƒG‚b m‚G…x GŠKG ŠGS „U„V ‰agM
local koTalentSet={[121]={[115]=true,[117]=true,[42]=true},[122]={[1]=true,[2]=true,[43]=true},[123]={},[124]={[101]=true,[17]=true,[18]=true},[125]={[115]=true,[51]=true,[52]=true},[126]={[117]=true,[51]=true},[127]={[20]=true,[51]=true},[128]={[109]=true,[51]=true},[129]={[113]=true,[52]=true},[131]={[20]=true}}
local koEquipKeys={"ÎäÆ÷","·À¾ß","¸¨Öú"}
local function koHasSkill(pid,skillid)
local p=JY.Person[pid]
local koAS=rawget(_G,"koAwakeSk") if koAS then koAS=koAS[pid] if koAS and koAS[skillid] and p["\190\253\214\247"]==1 then return true end end
if skillid==112 and koTwinOnPid(pid) then return true end--ko 3.6: the Qiao sisters side by side
if koLinkIdx[pid] and koLinkSkill(pid,skillid) then return true end--ko 3.6 later: ì„ ì¸ ì—°ê³„ / ê°•ë™ ì—°ê³„
local tf=p["Ìì¸³"]
if tf==skillid then
return true
end
if koTalentSet[tf] and koTalentSet[tf][skillid] then
return true
end
for _,key in ipairs(koEquipKeys) do
local it=p[key]
if it and it>0 then
local item=JY.Item[it]
if item["ÌØ¼¼"]==skillid then
return true
end
if item["×¨ÊôÌØ¼¼"]==skillid and item["×¨ÊôÌØ¼¼ÈË"]==p["ĞÕÃû"] then
return true
end
end
end
for i=1,6 do
if p["ÌØ¼¼"..i]==skillid then
if p["µÈ¼¶"]>=CC.SkillExp[p["³É³¤"]][i] then
return true
end
end
end
return false
end

function WarCheckSkill(wid,skillid)
return koHasSkill(War.Person[wid].id,skillid)
end

function CheckSkill(pid,skillid)
if pid<=0 then
return false
end
return koHasSkill(pid,skillid)
end

--åŸfight.lua
--ko 2.0: ì¼ê¸°í†  ë³µì›. ì›ë³¸ ë³µê°íŒ(LLK_R1 build 42310) script/fight.lua ë¥¼ unluac ë¡œ ë””ì»´íŒŒì¼í•´ ì´ì‹.
--    Â· í™”ë©´ì€ ì›ë³¸ì˜ 992x576 ì „ìš© í•´ìƒë„ ëŒ€ì‹  ìœ ê´‘íŒì˜ 768x480 ê·¸ëŒ€ë¡œ ì‚¬ìš© (í”„ë ˆì„ ui 412, ì¢Œí‘œëŠ” ì¤‘ì‹¬ 496â†’384 ë¡œ ì´ë™)
--    Â· ëŒ€ì‚¬ëŠ” í•œê¸€í™”, ìƒ‰ìƒ ìƒìˆ˜ C_WHITEâ†’M_White, ì—°ì¶œ ë£¨í”„ì— CC.koAnim(ì—°ì¶œ ë°°ì†) ë°˜ì˜
--    Â· ë°˜í™˜ê°’: 1 = id1 ìŠ¹, 2 = id2 ìŠ¹ (kdef.lua ì˜ if fight(a,b)==1 ë¶„ê¸°ì™€ í˜¸í™˜)
koDuelPlayer=0-- ko 3.1: the general the player controls in a title duel (the tourney sets it); 0 = decide by å›ä¸» or army
function fight(id1,id2,sid)
if koStoryBattleSource and War and War.Person then id1=koStoryBattleSource(id1) end
if (CC.koDuelPick or 1)==0 and koDuelPlayer==0 then--ko 3.1: ìë™ = ì›ì‘(v12846) ê·¸ëŒ€ë¡œ: ì¼ê¸°í†  í™”ë©´ ì—†ì´ ì™¼ìª½ ìŠ¹
for koT=1,10 do JY.ReFreshTime=lib.GetTime() ReFresh() lib.GetKey() end
return 1
end
if JY.Status==GAME_START then
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
Dark()
elseif JY.Status==GAME_WMAP then
Dark()
elseif JY.Status==GAME_DEAD then
Dark()
elseif JY.Status==GAME_END then
Dark()
end
if sid==nil then
if JY.Status==GAME_WMAP then
local wid=GetWarID(id2)
sid=GetWarMap(War.Person[wid].x,War.Person[wid].y,1)
else
local s={0,1,2,4,6}
sid=s[math.random(5)]
end
end
local r=fight_sub(id1,id2,sid)
koHook("duel_end",r==1)--ko 3.1
Dark()
if JY.Status==GAME_START then
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL or JY.Status==GAME_MMAP then
DrawSMap()
Light()
elseif JY.Status==GAME_WMAP then
DrawWarMap()
Light()
elseif JY.Status==GAME_DEAD then
elseif JY.Status==GAME_END then
end
return r
end

function fight_sub(id1,id2,sid)
local n=2
local ID={id1,id2}
local p1,p2=JY.Person[id1],JY.Person[id2]
local fightname=fillblank(p1["ĞÕÃû"],12).." ‚_ "..fillblank(p2["ĞÕÃû"],12)
local card={[1]={},[2]={}}
local card_num={}
local str={
[1]={--ë“±ì¥ (ì™¸í˜¸ ë’¤ì— ë¶™ìŒ)
"*C‚_ ƒaq‚b GŠKS eŠWƒd …G‚S‚f!",
"*GŠKS eŠWƒd M‚V ‰jƒO…x!",
"*ŠGƒb„K ƒaq, GŠKS …g†r ‹|^?",
"*ƒ_ ‹Fƒb I‚XƒP ƒcƒb ƒq‚C ‚k‚bM!",
"*†u^ ‡NŠW ŠGƒW†y†sŠm!",
"*‡NŠW ƒvfQ D‚Ba‚b …x^ „OML?",
"*ƒc…~G n‡P‚C ‚kƒb …x‚b ƒv‡z‚f!",
"*[ƒX …A…w‚V ƒLƒaS ƒq‚S ‚JS ƒoƒO†yM!",
"*ˆuGƒv ‹D ‹E‚S …RY!",
"*ƒ_^ oƒUŒm ‚g…f‚S ‚K…X!",
},
[2]={--ì¼ë°˜ ê³µê²©
"…Ennn…F!!!",
"G …I‚pS …Hn‚f!",
"‰XX q „O†y†sŠm!",
"v†dB‚f!",
"…G‚S‚f!!!",
"G FDA ‡t‡LaM!",
"„p ƒcS ^ˆk^†yM!",
"„l‚b ‰}‚K‚C ‚k‚bM!",
"‚E[B‚f!",
"…G‚S!",
},
[3]={--í•„ì‚´ê¸°
"G …I‚p, ‹N‹NŠW ‰}‚f!",
"‡z‚f!*ƒ_ …{D‚h ‚i‚fƒi q „OMA!",
"ƒv‚h @ƒvQ P‚wƒv!*G ƒGƒHS …Hn ‰}‚f!",
"G FD Nƒ}GŠm?*ƒ[†GƒW‚b ‚o „C‚C!",
"‡z‚f!*H‚fA G ƒGƒHS „P „VaM!",
"n„L ‹[ƒv‚C ‚kƒtM! M‚V!",
"aaaa!*‚Zˆe ƒe‚P‚b G o q‚h ‚no ƒuG„kM!",
"......*…G‚S‚f!",
"ƒOu †L‚o ‚P‚BƒP ƒGƒHS ŠTƒsn‚f!",
"G ƒGƒHƒb*n„L ƒWl‚C„V*H‚h ˆ`…e„]uƒG‰` ‡t‡LaM!",
},
[4]={--í”¼ê²©
"…M!",
"n„h!",
"{…B o q „O‚T",
"Fˆ| ‚_†MaM!",
"‡n‰R‚q „@GM!",
"ƒE‡M …{DM!",
"G ˆQ„Z,*‡wƒAj^?",
"`‚E‚CD ˆfPM......",
"n„L ‹T q‚b ‚aM...",
"‡f‚C ˆfP†M ˆ|j^?",
},
[5]={--ë°©ì–´ ì„±ê³µ
"ƒ[ FDŠm!",
"‚n…UPM!",
"o„V ‚W‚C‚j‚ja‚T!",
"s…yG M „n‚Sg ‚Z†oG‚T",
"GƒuD ƒGƒHGŠm?",
"„l †suQ X q‚b ‚aƒv?",
"…y‚C…e…[ ŠFGM",
"G‚W‰` ƒ_^ …A‚pGM!",
"ƒ[ ƒGƒHƒb n„L …SŠW‚CD ˆfP‚T!",
"M‚V! M‚V!*nI ‡N‚ED ‚aM!",
},
[6]={--íŒ¨ë°°
"ƒ_^ ‚CML...",
"bƒGƒW …GS q‚b ‚aM...",
"‚S[ƒW G‹@ …IG!",
"ƒ[‡z ‰jƒO‚C ˆ|ƒt‚S…E PM...",
"G ˆQ„Zƒb HI I†bM!",
"bƒGƒW OX „{ƒb Œ{„gM...",
"aƒXG ƒv‚h „qu‚b^!",
"„QŒTGM!",
"GCaM?*„@G... „@G ƒEˆkƒv…yM?",
"M‚V‚b gS „Qƒd ƒLS †R q ‚a‚wƒv!",
},
[7]={--ìŠ¹ë¦¬
"ƒLƒaS ˆ`…e„]„~M!",
"aaaa!*„l ‹R‹S …R …x „O‚b^!",
"o „N †EuD ‚o „C‚T!",
"Fˆ| ‚VƒQaM!",
"†I†qa‚f!",
"Gd IƒW‡S „{ „aƒt†y‚C!",
"G‚@„S G‹HMƒd?*n„L ‚^„Ro…h!",
"G‹HM",
"GƒuG …A†J…xƒP ˆ|„SM!",
"HI ‡CaM!",
},
}
card_num[1]=5+p1["Íş·ç"]
card_num[2]=5+p2["Íş·ç"]
local hpmax={math.floor((150+p1["µÈ¼¶"])*0.4),math.floor((150+p2["µÈ¼¶"])*0.4)}--ko 3.1: 40% (the rounds are hand-picked now)
local hp={hpmax[1],hpmax[2]}
local mp={40,40}--ko 3.1: was 20 (35 for the stronger): techniques from the first rounds
if p1["ÎäÁ¦"]>p2["ÎäÁ¦"] then
mp[1]=55
elseif p1["ÎäÁ¦"]<p2["ÎäÁ¦"] then
mp[2]=55
end
local atk={math.max(math.modf(p1["ÎäÁ¦"]/10)-1,2),math.max(math.modf(p2["ÎäÁ¦"]/10)-1,2)}
if atk[1]-atk[2]>7 then--ko 3.1: the ë¬´ë ¥ gap counts a little more (was 5)
atk[2]=atk[1]-7
elseif atk[2]-atk[1]>7 then
atk[1]=atk[2]-7
end
local atk_offset=8/math.max(atk[1],atk[2])
atk[1]=math.modf(atk[1]*atk_offset)
atk[2]=math.modf(atk[2]*atk_offset)
atk[1]=atk[1]+math.modf(p1["·ÜÕ½"]/8)-p2["·ÜÕ½"]%8
atk[2]=atk[2]+math.modf(p2["·ÜÕ½"]/8)-p1["·ÜÕ½"]%8
if p1["Ê¿Æø"]<80 then atk[1]=atk[1]-1 end
if p1["Ê¿Æø"]<30 then atk[1]=atk[1]-1 end
if p2["Ê¿Æø"]<80 then atk[2]=atk[2]-1 end
if p2["Ê¿Æø"]<30 then atk[2]=atk[2]-1 end
if atk[1]<2 then atk[1]=2 end
if atk[2]<2 then atk[2]=2 end
if JY.Status==GAME_WMAP then
atk[1]=atk[1]+1
end
--ko í™”ë©´ ë°°ì¹˜ (ì›ë³¸ 992x576 â†’ 768x480, ê°€ë¡œ ì¤‘ì‹¬ 496â†’384)
local SW=768--ko 3.0: the duel is laid out for 768x480; on a bigger screen it is a centred box
local koOX,koOY=math.floor((CC.ScreenW-SW)/2),math.floor((CC.ScreenH-480)/2)
local CX=math.modf(SW/2)
local size=96
local size2=128
local sy=330
local LX=CX-300--ì™¼ìª½ ì´ˆìƒ ë°•ìŠ¤ x (ì›ë³¸ 196)
local RX=CX+232--ì˜¤ë¥¸ìª½ ì´ˆìƒ ë°•ìŠ¤ x (ì›ë³¸ 728)
local ka=CC.koAnim or 1
local s={}
s[1]={
d=0,
x=CX-240,
pic=p1["Õ½¶·¶¯×÷"],
action=9,
frame=0,
effect=0,
mpadd=6+4*p1["Å­·¢"]+p1["ÓÂÃÍ"]/2+math.max(0,p1["Ê¿Æø"]/10-8),
luck=math.min(15,p1["ÓÂÃÍ"]+p1["Àä¾²"]*3+5*p1["Ç¿ÔË"])+5*p1["Ç¿ÔË"],--ko 3.1: half the luck
movewav=JY.Bingzhong[p1["±øÖÖ"]]["ÒôĞ§"],
atkbuff=JY.Bingzhong[p1["±øÖÖ"]]["¹¥»÷"]/2,
defbuff=JY.Bingzhong[p1["±øÖÖ"]]["·ÀÓù"]/2,
ym=p1["ÓÂÃÍ"],
lj=p1["Àä¾²"],
lv=p1["µÈ¼¶"],
losser=false,
dl=p1["µ×Á¦"],
jj=p1["¼±¾È"],
bq=p1["²»Çü"],
txt="",
}
s[2]={
d=0,
x=CX+144,
pic=p2["Õ½¶·¶¯×÷"],
action=9,
frame=0,
effect=0,
mpadd=6+4*p2["Å­·¢"]+p2["ÓÂÃÍ"]/2+math.max(0,p2["Ê¿Æø"]/10-8),
luck=math.min(15,p2["ÓÂÃÍ"]+p2["Àä¾²"]*3+5*p2["Ç¿ÔË"])+5*p2["Ç¿ÔË"],
movewav=JY.Bingzhong[p2["±øÖÖ"]]["ÒôĞ§"],
atkbuff=JY.Bingzhong[p2["±øÖÖ"]]["¹¥»÷"]/2,
defbuff=JY.Bingzhong[p2["±øÖÖ"]]["·ÀÓù"]/2,
ym=p2["ÓÂÃÍ"],
lj=p2["Àä¾²"],
lv=p2["µÈ¼¶"],
dz=math.random(math.modf(p2["Ê¿Æø"]/2+1),p2["Ê¿Æø"]+3),
losser=false,
dl=p2["µ×Á¦"],
jj=p2["¼±¾È"],
bq=p2["²»Çü"],
txt="",
}
s[1].ym=limitX(s[1].ym,0,math.modf(p1["Ê¿Æø"]/14))
s[1].lj=limitX(s[1].lj,0,math.modf(p1["Ê¿Æø"]/14))
s[2].ym=limitX(s[2].ym,0,math.modf(p2["Ê¿Æø"]/14))
s[2].lj=limitX(s[2].lj,0,math.modf(p2["Ê¿Æø"]/14))
local pic1=0
local pic2=10
-- 00 å¹³åŸ 01 æ£®æ— 02 å±±åœ° 03 æ²³æµ 04 æ¡¥æ¢ 05 åŸå¢™ 06 åŸæ±  07 è‰åŸ
-- 08 æ‘åº„ 09 æ‚¬å´– 0A åŸé—¨ 0B è’åœ° 0C æ …æ  0D é¹¿ç ¦ 0E å…µè¥ 0F ç²®ä»“
if sid==0 or sid==7 then
pic1=4
pic2=12
elseif sid==2 or sid==11 then
pic1=0
pic2=13
elseif sid==1 then
pic1=3
pic2=12
elseif sid==4 then
pic1=1
pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
pic1=2
pic2=10
end
local function admp(i,v)
v=math.modf(v)
mp[i]=limitX(mp[i]+v,0,100)
end
local function dechp(i,v,flag)
flag=flag or false
if math.random(100)<s[3-i].atkbuff then
v=v+1
end
if math.random(100)<s[i].defbuff then
v=v-1
end
v=math.modf(v)
if v<1 then
v=1
end
if flag and s[i].bq>0 then
v=0
end
hp[i]=hp[i]-v
if hp[i]<0 then
hp[i]=0
end
admp(i,1+v/2)
end
-- ko 3.1 ì¼ê¸°í†  ê°œì„ : the human side picks its three cards (pick = the hand on screen while choosing), the round's values
-- are shown (reveal), and both sides' ê¸°ë ¥ bars are drawn. Names of the card combinations (card_value kinds).
-- Spliced into fight_sub before show_raw by patch_ì¼ê¸°í† ì¹´ë“œ.pl
local pick=nil
local reveal=nil
local KIND={[0]="\129\087\132\084",[1]="\130\073\133\064",[2]="3\133\066\130\112",[3]="\132\115\134\106 \130\073\133\064",[4]="5\133\066\130\112",[5]="\130\125\133\088",[6]="\130\073\133\064 \137\066\129\103",[7]="\132\087\132\121 \133\066\130\112",[8]="\130\080\131\071",[9]="\134\088\136\112\131\071",[99]="\133\073\130\112"}-- í•©ê³„ ê°•íƒ€ 3ì—°ê²© í•„ì‚´ ê°•íƒ€ 5ì—°ê²© íšŒë§ˆ ê°•íƒ€ ëŒì§„ êµì°¨ ì—°ê²© ë¹„ê¸° ê¶ê·¹ê¸° ì¼ê²©
local HAND_Y,CARD_W,CARD_H,CARD_GAP=436,36,32,6
local function hand_x(id,i) return CX-110-math.floor(card_num[id]*(CARD_W+CARD_GAP)/2)+(i-1)*(CARD_W+CARD_GAP) end-- the hand sits left of centre, the buttons right
local function draw_mp()
-- ê¸°ë ¥ (0..100) under the ì²´ë ¥ bar, my side left / theirs right like the ì²´ë ¥ bar
-- ì²´ë ¥ bar: redrawn here 18 px tall (the base's 12 px one at 192..204 is painted over), label in the middle, values at the ends
lib.FillColor(CX-303,158,CX+300,176,M_Black)
lib.FillColor(CX-math.modf(300*hp[1]/hpmax[1]),158,CX,176,M_Red)
lib.FillColor(CX,158,CX+math.modf(300*hp[2]/hpmax[2]),176,M_Blue)
DrawBox(CX-303,158,CX+300,176,M_White)
DrawString(CX-3-16,159,"\133\114\131\125",M_White,16)-- ì²´ë ¥
DrawString(CX-296,159,hp[1].."/"..hpmax[1],M_White,16)
local h2=hp[2].."/"..hpmax[2] DrawString(CX+294-#h2*8,159,h2,M_White,16)
-- ê¸°ë ¥ bar, the same shape, under it
lib.FillColor(CX-303,180,CX+300,198,M_Black)
lib.FillColor(CX-math.modf(300*mp[1]/100),180,CX,198,M_DarkOrange)
lib.FillColor(CX,180,CX+math.modf(300*mp[2]/100),198,M_DarkOrange)
DrawBox(CX-303,180,CX+300,198,M_Gray)
DrawString(CX-3-16,181,"\131\071\131\125",M_White,16)-- ê¸°ë ¥
DrawString(CX-296,181,tostring(math.floor(mp[1])),M_White,16)
local s2=tostring(math.floor(mp[2])) DrawString(CX+294-#s2*8,181,s2,M_White,16)
if reveal then
-- ì¹´ë“œ ê°’  ì´ë¦„ 21 : 15 ì´ë¦„  (the higher one attacks this round)
local n1,n2=JY.Person[ID[1]]["\208\213\195\251"],JY.Person[ID[2]]["\208\213\195\251"]-- å§“å
local c1,c2=(reveal[1]>=reveal[2]) and C_Name or M_White,(reveal[2]>=reveal[1]) and C_Name or M_White
local s1,s2=n1.." "..reveal[1],reveal[2].." "..n2
DrawString(CX-3-12-#s1*8,202,s1,c1,16)
DrawString(CX-3-4,202,":",M_White,16)
DrawString(CX-3+12,202,s2,c2,16)
local lb="\143\085\133\119 \137\093"-- ì¹´ë“œ ê°’
DrawString(CX-3-12-#s1*8-12-#lb*8,202,lb,M_Gray,16)
end
end
local function draw_hand()
local id=pick.id
local p=JY.Person[ID[id]]
-- what this general can combine: í­ê²©N ì—°ê²©N íšŒë§ˆ ë¹„ê¸°
-- æš´å‡»/è¿å‡» are bit masks: 1 = 1ë‹¨, 2 = 2ë‹¨, 4 = 3ë‹¨ (so 3 = 1ë‹¨ê³¼ 2ë‹¨, not 3ë‹¨)
-- one line: the prompt on the left, what the three picked cards make on the right (the combos are in the ê·œì¹™ table)
local n=0
for _,v in pairs(pick.sel) do if v then n=n+1 end end
lib.Background(CX-303,HAND_Y-20,CX+300,HAND_Y+CARD_H+4,112,M_Black)
DrawString(CX-297,HAND_Y-18,"\143\085\133\119 3\131\097\129\083 \131\100\130\106\131\111\129\090",M_Silver,16)-- ì¹´ë“œ 3ì¥ì„ ê³ ë¥´ì„¸ìš”
if pick.preview then DrawString(CX+297-#pick.preview*8,HAND_Y-18,pick.preview,C_Name,16) end-- "ê°•íƒ€ 33" (card_pick fills it: card_value is defined after this)
for i=1,card_num[id] do
local x=hand_x(id,i)
local on=pick.sel[i]
lib.Background(x,HAND_Y,x+CARD_W,HAND_Y+CARD_H,on and 40 or 200,on and M_Blue or M_Black)
DrawBox(x,HAND_Y,x+CARD_W,HAND_Y+CARD_H,(pick.hov==i or on) and M_White or M_Gray)
local s=tostring(card[id][i])
DrawString(x+CARD_W/2-#s*4,HAND_Y+8,s,on and C_Name or M_White,16)
end
-- ê²°ì • / ìë™ / ê·œì¹™ (56 px each, 8 apart, from CX+108)
local bx=CX+108
local function btn(k,s,c) local x=bx+(k-1)*64 lib.Background(x,HAND_Y+2,x+56,HAND_Y+30,112,M_Black) DrawBox(x,HAND_Y+2,x+56,HAND_Y+30,c) DrawString(x+28-#s*4,HAND_Y+8,s,c,16) end
btn(1,"\134\064\129\070",(n==3) and M_White or M_Gray)-- ê²°ì •
btn(2,"\133\120\130\108",M_White)-- ìë™
btn(3,"\135\118\135\111",M_White)-- ê·œì¹™
end
-- the ê·œì¹™ overlay: how a round works and every combination, with this general's ability (white = can use, gray = cannot)
local function draw_help()
local p=JY.Person[ID[pick.id]]
local bj,lj,hm,bq,wl=p["\177\169\187\247"],p["\193\172\187\247"],p["\187\216\194\237"],p["\195\216\188\188\049"],p["\206\228\193\166"]-- æš´å‡» è¿å‡» å›é©¬ ç§˜æŠ€1 æ­¦åŠ›
local x1,y1,x2,y2=CX-3-280,40,CX-3+280,352
lib.Background(x1,y1,x2,y2,40,M_Black)
DrawBox(x1,y1,x2,y2,M_White)
local y=y1+8
local function line(s,c) DrawString(x1+12,y,s,c or M_White,16) y=y+18 end
line("\133\073\131\071\137\083 \135\118\135\111",C_Name)-- ì¼ê¸°í†  ê·œì¹™
line("\131\111 \131\097\131\080 \137\093\129\071 \131\110 \139\074\129\071 \130\074\130\112. \132\121\129\071\129\094 1 \129\071\129\097\129\065 \138\071\130\094\143\125\131\108")-- ì„¸ ì¥ì˜ ê°’ì´ í° ìª½ì´ ê³µê²©. ì°¨ì´ê°€ 1 ì´í•˜ë©´ ë§ë¶€ë”ªì¹¨
line("\131\071\131\072\131\098 \131\071\131\125\129\083 \138\091. \138\071\131\109\129\065 \131\071\131\125\129\071 \134\126, \135\071 \130\102\135\083\133\119 \131\071\131\125 \130\125\130\068")-- ê¸°ìˆ ì€ ê¸°ë ¥ì„ ì”€. ë§ìœ¼ë©´ ê¸°ë ¥ì´ ì°¸, ë§¤ ë¼ìš´ë“œ ê¸°ë ¥ íšŒë³µ
line("\130\102\135\083\133\119\133\088\129\077 \136\090 3\131\097\129\123 \129\094\131\097 \137\105\131\098 1\131\097\129\071 \131\069\130\067\131\100 4\131\097\129\083 \134\068\132\083 \133\072\130\077")-- ë¼ìš´ë“œë§ˆë‹¤ ë‚¸ 3ì¥ê³¼ ê°€ì¥ ë‚®ì€ 1ì¥ì´ ë¹ ì§€ê³  4ì¥ì„ ìƒˆë¡œ ë°›ìŒ
y=y+6
-- header: ì¹´ë“œ / ì¡°í•© / ê°’ / í•„ìš” ê¸°ë ¥ / ì´ ë¬´ì¥
DrawString(x1+12,y,"\143\085\133\119",M_Gray,16) DrawString(x1+190,y,"\129\118\129\087",M_Gray,16) DrawString(x1+320,y,"\137\093",M_Gray,16) DrawString(x1+380,y,"\132\115\129\090 \131\071\131\125",M_Gray,16) DrawString(x1+490,y,"\129\094\131\077",M_Gray,16)
y=y+20
local off=math.max(wl/2-41,0)
local rows={
{"\132\071\131\098 \129\113 3\131\097",KIND[1],30+off,40,bj%2==1,"\132\099\130\112 1"},-- ê°™ì€ ìˆ˜ 3ì¥ / ê°•íƒ€ / í­ê²© 1
{"2 + \132\071\131\098 \129\113 2\131\097(6\129\071\129\067)",KIND[3],40+off,45,math.floor(bj/2)%2==1,"\132\099\130\112 2"},-- 2 + ê°™ì€ ìˆ˜ 2ì¥(6 ì´ìƒ) / í•„ì‚´ ê°•íƒ€ / í­ê²© 2
{"1 5 9",KIND[6],55+off,55,bj>=4,"\132\099\130\112 3"},-- ê°•íƒ€ ëŒì§„ / í­ê²© 3
{"\133\066\133\123 3\131\097",KIND[2],30+off,40,lj%2==1,"\133\066\130\112 1"},-- ì—°ì† 3ì¥ / 3ì—°ê²© / ì—°ê²© 1
{"3 + \133\066\133\123 2\131\097(7\134\119\132\086)",KIND[4],40+off,45,math.floor(lj/2)%2==1,"\133\066\130\112 2"},-- 3 + ì—°ì† 2ì¥(7 ë¯¸ë§Œ) / 5ì—°ê²© / ì—°ê²© 2
{"3 7 8",KIND[7],55+off,55,lj>=4,"\133\066\130\112 3"},-- êµì°¨ ì—°ê²© / ì—°ê²© 3
{"5 x 7",KIND[5],50+off,50,hm>0,"\130\125\133\088"},-- íšŒë§ˆ
{"1 1 1",KIND[8],60+off,60,bq>0,"\130\080\131\071"},-- ë¹„ê¸°
{"4 4 4",KIND[9],65,99,wl>=100,"\129\073\131\125 100"},-- ê¶ê·¹ê¸° / ë¬´ë ¥ 100
}
for _,r in ipairs(rows) do
local c=r[5] and M_White or M_Gray
DrawString(x1+12,y,r[1],c,16) DrawString(x1+190,y,r[2],c,16) DrawString(x1+320,y,tostring(math.floor(r[3])),c,16) DrawString(x1+380,y,tostring(r[4]),c,16)
DrawString(x1+498,y,r[5] and "\161\240" or "\161\193",r[5] and C_Name or M_Gray,16)-- â—‹ / Ã—
y=y+18
end
y=y+4
line("\129\118\129\087\129\071 \130\097\131\109\129\065 \131\111 \131\097\131\080 \129\087\132\084 (3~27)",M_Silver)-- ì¡°í•©ì´ ì—†ìœ¼ë©´ ì„¸ ì¥ì˜ í•©ê³„ (3~27)
line("\129\110\129\073 \137\074\131\118 \133\088\131\079\131\126\132\083 \137\066\129\110\135\078",M_Gray)-- ì•„ë¬´ í‚¤ë‚˜ ë§ˆìš°ìŠ¤ë¡œ ëŒì•„ê°
end

local function show_raw()
getkey()
lib.SetClip(0,0,768,480)--ko 3.0: nothing outside the box
lib.FillColor(0,0,768,480,M_Black)
lib.PicLoadCache(1,pic2*2,0,310,1)
lib.PicLoadCache(1,pic1*2,-68,190,1)
lib.SetClip(0,0,0,0)
--ì™¼ìª½(id1)
DrawBox(LX,40,LX+68,124,M_White)
lib.PicLoadCache(2,p1["Í·Ïñ´úºÅ"]*2,LX+2,42,1)
if s[1].losser then
lib.Background(LX+2,76,LX+66,156,106)
end
DrawBox(LX,129,LX+68,151,M_White)
DrawBox(LX+70,129,LX+138,151,M_White)
DrawString(LX+34-#p1["ĞÕÃû"]*4,132,p1["ĞÕÃû"],M_White,16)
DrawString(LX+72,132,string.format("Iƒ} %3d",p1["ÎäÁ¦"]),M_White,16)
DrawStrBox(LX+82,40,s[1].txt,M_White,16)
--ì˜¤ë¥¸ìª½(id2)
DrawBox(RX,40,RX+68,124,M_White)
lib.PicLoadCache(2,p2["Í·Ïñ´úºÅ"]*2,RX+2,42,1)
if s[2].losser then
lib.Background(RX+2,76,RX+66,156,106)
end
DrawBox(RX,129,RX+68,151,M_White)
DrawBox(RX-70,129,RX-2,151,M_White)
DrawString(RX+34-#p2["ĞÕÃû"]*4,132,p2["ĞÕÃû"],M_White,16)
DrawString(RX-68,132,string.format("Iƒ} %3d",p2["ÎäÁ¦"]),M_White,16)
DrawStrBox(-(SW-(RX-10)),40,s[2].txt,M_White,16)--ìŒìˆ˜ x: ì˜¤ë¥¸ìª½ ë ê¸°ì¤€
--ì²´ë ¥ ë°”
lib.FillColor(CX-math.modf(300*hp[1]/hpmax[1]),158,CX,176,M_Red)
lib.FillColor(CX,158,CX+math.modf(300*hp[2]/hpmax[2]),176,M_Blue)
DrawBox(CX-303,158,CX+300,176,M_White)
for i=1,2 do
if s[i].action==0 then
lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+16+s[i].d)*2,s[i].x,sy,11,s[i].effect)
end
elseif s[i].action==1 then
lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,sy,11,s[i].effect)
end
elseif s[i].action==2 then
lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,sy+(size-size2)/2,11,s[i].effect)
end
elseif s[i].action==3 then
lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+22+s[i].d)*2,s[i].x,sy,11,s[i].effect)
end
elseif s[i].action==4 then
lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+26+s[i].d%2)*2,s[i].x,sy,11,s[i].effect)
end
elseif s[i].action==5 then
lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+20+s[i].frame)*2,s[i].x,sy,11,s[i].effect)
end
elseif s[i].action==6 then
lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,1)
if s[i].effect>0 then
lib.PicLoadCache(11,(s[i].pic+28)*2,s[i].x,sy,11,s[i].effect)
end
end
end
lib.PicLoadCache(4,412,0,0,1)--768x480 í”„ë ˆì„ (ì›ë³¸ì€ 404 = 992x576)
DrawString(CX-3-#fightname*4,8,fightname,M_White,16)
draw_mp()--ko 3.1
if pick then draw_hand() if pick.help then draw_help() end end
end
-- ko 3.0: on a bigger screen draw the (dimmed) battle map behind and the duel shifted into the middle. DrawStrBox
-- aligns to CC.ScreenW, so it sees 768 while the box is drawn
local function show()
if koOX==0 and koOY==0 then show_raw() return end
if JY.Status==GAME_WMAP then DrawWarMap() else lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black) end
lib.Background(0,0,CC.ScreenW,CC.ScreenH,128)
local sw=CC.ScreenW
CC.ScreenW=SW
local ok,err=pcall(koDrawShift,koOX,koOY,show_raw)
CC.ScreenW=sw
if not ok then error(err,0) end
end
local function turn(id,d)
if s[id].d==d then
return
end
s[id].action=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
if s[id].d~=0 then
s[id].d=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
s[id].d=d
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(6)
ReFresh(2)
end
local function move(id,dx)
local flag=1
s[id].action=1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local step=12
if dx<s[id].x then
step=-12
end
for i=s[id].x,dx,step do
s[id].x=i
s[id].frame=s[id].frame+1
if s[id].frame>=2 then
s[id].frame=0
end
JY.ReFreshTime=lib.GetTime()
show()
if flag==1 then
PlayWavE(s[id].movewav)
flag=4
else
flag=flag-1
end
ReFresh(3)
lib.GetKey()
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh(2)
end
local function move2(dx1,dx2)
local count=1
local step1,step2=12,12
if dx1<s[1].x then
step1=-12
turn(1,2)
else
turn(1,3)
end
if dx2<s[2].x then
step2=-12
turn(2,2)
else
turn(2,3)
end
s[1].action=1
s[2].action=1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
while true do
local flag=true
if s[1].x~=dx1 then
flag=false
s[1].x=s[1].x+step1
s[1].frame=s[1].frame+1
if s[1].frame>=2 then
s[1].frame=0
end
else
s[1].action=0
end
if s[2].x~=dx2 then
flag=false
s[2].x=s[2].x+step2
s[2].frame=s[2].frame+1
if s[2].frame>=2 then
s[2].frame=0
end
else
s[2].action=0
end
JY.ReFreshTime=lib.GetTime()
show()
if count==1 then
if s[1].action==1 then
PlayWavE(s[1].movewav)
end
if s[2].action==1 then
PlayWavE(s[2].movewav)
end
count=4
else
count=count-1
end
ReFresh(4)
lib.GetKey()
if flag then
break
end
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
local function reset_all()
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
s[1].effect=0
s[2].effect=0
end
--ë§ë¶€ë”ªì¹¨ (ì–‘ìª½ ì¹´ë“œ ê°’ì´ ë¹„ìŠ·í•  ë•Œ)
local function atk_p(id,gd)
local n=3
local flag=false
s[id].action=2
s[3-id].action=2
if math.random(gd)>50 then
flag=true
PlayWavE(6)
s[1].txt=str[2][math.random(10)]
s[2].txt=str[2][math.random(10)]
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
end
for i=0,3 do
s[id].frame=i
s[3-id].frame=i
if flag and i==0 then
PlayWavE(33)
for t=8,192,8*ka do
s[id].effect=t
s[3-id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[1].effect=0
s[2].effect=0
end
if i==3 then
if flag then
PlayWavE(31)
s[1].txt=str[5][math.random(10)]
s[2].txt=str[5][math.random(10)]
else
PlayWavE(30)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if flag then
if s[3-id].x>s[id].x then
s[3-id].x=s[3-id].x+24
s[id].x=s[id].x-24
else
s[3-id].x=s[3-id].x-24
s[id].x=s[id].x+24
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--ì¼ê²© (ä¸€å‡» íŠ¹ê¸°: ê°œì „ ì§í›„ / ê´€ìš° ì „ìš© ì¹´ë“œ)
local function atk_ms(id,gd)
local n=3
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(10)]
if ID[id]==2 then
s[id].txt=str[3][math.random(10)].."*ˆH†q†~!"
end
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=24,240,6*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if s[3-id].x>s[id].x then
s[id].x=s[3-id].x-size
else
s[id].x=s[3-id].x+size
end
if gd>math.random(100) then
s[3-id].txt=str[5][math.random(10)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,20+atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(10)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,300+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag then
s[id].x=s[3-id].x-size
s[3-id].x=s[3-id].x+size
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
end
elseif flag then
s[id].x=s[3-id].x+size
s[3-id].x=s[3-id].x-size
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--ì•”ê¸° (æš—å™¨ íŠ¹ê¸°: ê°œì „ ì§í›„ í™”ì‚´)
local function atk_aq(id,gd)
local n=3
s[id].action=2
local flag1,flag2=0,false
if math.random(5)==1 then
flag1=1
end
if ID[id]==170 then--í™©ì¶©
if flag1==0 and math.random(4)==1 then
flag1=1
end
gd=gd/2
end
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(6)
s[id].txt="ŠIŠIŠI*G @†jS ‰XX q „O†y†sŠm!"
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
if flag1==1 then
PlayWavE(33)
for t=8,192,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
end
s[id].effect=0
PlayWavE(37)
end
if i==3 then
if gd>math.random(100) then
flag2=true
s[3-id].action=3
PlayWavE(30+flag1)
dechp(3-id,atk[id]*(1+flag1),true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag2=false
s[3-id].action=4
PlayWavE(35+flag1)
dechp(3-id,(atk[id]+10)*(1+flag1))
atk[3-id]=atk[3-id]-1
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if flag2 then
s[3-id].txt="‰xs‚K„S‚T!"
else
s[3-id].txt="‚P‚AaM!"
card_num[3-id]=card_num[3-id]-1
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
reset_all()
end
local function atk_dz(id)
local n=3
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
PlayWavE(7)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
reset_all()
end
--ì €ë ¥ (åº•åŠ›: ì²´ë ¥ 1/3 ì´í•˜ì—ì„œ ë°œë™)
local function atk_dl(id)
s[id].txt="Œf‚SKS!!*„pŒNS ‡yn „qu†yM!!!"
atk_dz(id)
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
s[id].action=2
for t=1,3 do
for i=0,3 do
s[id].frame=i
if i==3 then
PlayWavE(7)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
end
end
--ì‘ê¸‰ (æ€¥æ•‘: ì²´ë ¥ 1/2 ì´í•˜ì—ì„œ ì½©ì„ ë¨¹ê³  íšŒë³µ)
local function atk_jj(id)
s[id].txt="…C~ ‚_†Ma‚T~"
PlayWavE(8)
s[id].action=5
for i=1,10 do
s[id].frame=i%2
if i==5 then
PlayWavE(8)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(8)
end
s[id].txt="M‚]ŠW ‰PG …gƒtM*Œv‡M aƒv K…x."
PlayWavE(41)
for t=8,255,8 do
s[id].effect=t
hp[id]=hp[id]+1
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
lib.GetKey()
end
s[id].action=0
s[id].frame=0
s[id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(6)
reset_all()
end
--0: ì¼ë°˜ ê³µê²©
local function atk_s0(id,gd)
local n=3
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
if gd>math.random(100) then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,atk[id]/2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(35)
dechp(3-id,atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
reset_all()
end
--1: ê°•íƒ€ (í­ê²© 1ë‹¨)
local function atk_s1(id,gd)
local n=3
s[id].action=2
local m=24
s[id].txt=str[2][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,192,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
end
if i==3 then
if gd>math.random(100) then
s[3-id].txt=str[5][math.random(10)]
m=12
s[3-id].action=3
PlayWavE(31)
s[3-id].effect=192
dechp(3-id,1+atk[id]/2,true)
else
s[3-id].txt=str[4][math.random(10)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,5+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
s[3-id].x=s[3-id].x+m
else
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
reset_all()
end
--2: 3ì—°ê²© (ì—°ê²© 1ë‹¨)
local function atk_s2(id,gd)
local n=3
local flag=true
s[id].txt=str[2][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,96,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
s[id].action=2
for t=1,3 do
for i=0,3 do
s[id].frame=i
if i==3 then
if flag and math.random(100)<gd+t*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,1,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,1+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if t==1 then
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
end
end
if flag then
s[3-id].txt=str[5][math.random(10)]
else
s[3-id].txt=str[4][math.random(10)]
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*2)
reset_all()
end
--3: í•„ì‚´ ê°•íƒ€ (í­ê²© 2ë‹¨)
local function atk_s3(id,gd)
local n=3
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=24,240,6*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if gd>math.random(100) then
s[3-id].txt=str[5][math.random(10)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,2+atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(10)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,15+atk[id]*2.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag or s[3-id].x>SW-size*3 then
s[3-id].x=s[3-id].x+size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
end
elseif flag or s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--4: 5ì—°ê²© (ì—°ê²© 2ë‹¨)
local function atk_s4(id,gd)
local n=3
local flag=true
s[id].txt=str[3][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,128,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].action=2
for t=1,5 do
for i=0,3 do
s[id].frame=i
if i==3 then
if flag and math.random(100)<gd+t*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,1,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,2+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
if t%2==0 then
JY.ReFreshTime=lib.GetTime()
ReFresh(1)
end
end
end
if flag then
s[3-id].txt=str[5][math.random(10)]
else
s[3-id].txt=str[4][math.random(10)]
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--5: íšŒë§ˆ (å›é©¬: ìŠ¤ì³ ì§€ë‚˜ê°€ ë’¤ì—ì„œ ì¼ê²©)
local function atk_s5(id,gd)
local n=3
local m=size/2
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==3 then
if gd>math.random(100) then
flag=true
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(35)
dechp(3-id,2+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if s[id].x<s[3-id].x then
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
turn(id,2)
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
turn(id,3)
end
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,240,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].effect=0
end
if i==3 then
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
if flag and math.random(100)<gd+10 then
s[3-id].txt=str[5][math.random(10)]
m=size/4
s[3-id].action=3
PlayWavE(31)
s[3-id].effect=192
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
dechp(3-id,2+atk[id]/2,true)
else
s[3-id].txt=str[4][math.random(10)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,15+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if s[id].x<size then
m=size
end
s[3-id].x=s[3-id].x+m
else
if s[id].x>SW-size*2 then
m=size
end
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--6: ê°•íƒ€ + ëŒì§„ ì¶”ê²© (í­ê²© 3ë‹¨)
local function atk_s6(id,gd)
local n=3
local m=36
s[id].action=2
local flag=false
s[id].txt=str[3][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=8,240,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if gd>math.random(100) then
flag=true
m=24
s[3-id].action=3
PlayWavE(31)
dechp(3-id,atk[id]-2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].action=4
PlayWavE(36)
dechp(3-id,5+atk[id]*1.5)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
if s[3-id].x>s[id].x then
if s[id].x<SW-size*3 then
s[3-id].x=s[3-id].x+m
end
elseif s[id].x>size*2 then
s[3-id].x=s[3-id].x-m
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
s[id].action=2
for i=0,3 do
s[id].frame=i
if i==3 then
if s[3-id].x>s[id].x then
s[id].x=s[3-id].x-size
else
s[id].x=s[3-id].x+size
end
PlayWavE(s[id].movewav)
if flag and math.random(100)<gd-10 then
s[3-id].txt=str[5][math.random(10)]
s[3-id].action=3
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
PlayWavE(31)
s[3-id].effect=192
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
dechp(3-id,atk[id],true)
else
s[3-id].txt=str[4][math.random(10)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,20+atk[id]*2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
s[3-id].effect=0
if s[id].x<s[3-id].x then
if s[3-id].x>SW-size*3 then
s[3-id].x=s[3-id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[3-id].x=s[3-id].x+size/4
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
elseif s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[3-id].x=s[3-id].x-size/4
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--7: êµì°¨ ì—°ê²© (ì—°ê²© 3ë‹¨: ìŠ¤ì³ ì§€ë‚˜ê°€ë©° 6~7ì—°íƒ€)
local function atk_s7(id,gd)
local n=3
local m=24
local lianji=6
local flag=true
if s[id].x<s[3-id].x then
if s[id].x<size*2 then
lianji=7
end
elseif s[id].x>SW-size*3 then
lianji=7
end
s[id].action=2
s[id].txt=str[3][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,192,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
for count=1,lianji do
for i=0,3 do
s[id].frame=i
if i==3 then
if s[id].x>s[3-id].x then
s[3-id].d=3
else
s[3-id].d=2
end
if flag and math.random(100)<gd+count*7 then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,3+atk[id]/2)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
end
if s[id].x<s[3-id].x then
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].d=2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].d=3
end
end
if flag then
s[3-id].txt=str[5][math.random(10)]
else
s[3-id].txt=str[4][math.random(10)]
end
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
--8: ë¹„ê¸° (ç§˜æŠ€: 7ì—°íƒ€ í›„ ëŒ€ì¼ê²©) / 9: ë¬´ë ¥100 ê¶ê·¹ê¸°
local function atk_s8(id,gd)
local n=3
local flag=true
s[id].txt=str[3][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
PlayWavE(39)
for t=8,128,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
s[id].action=2
for t=1,7 do
for i=0,3 do
s[id].frame=i
if i==3 then
if gd>math.random(100) then
s[3-id].action=3
PlayWavE(30)
dechp(3-id,2,true)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
flag=false
s[3-id].action=4
PlayWavE(35)
dechp(3-id,4)
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(1)
end
end
for i=0,3 do
s[id].frame=i
if i==0 then
PlayWavE(33)
for t=128,248,8*ka do
s[id].effect=t
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
if i==3 then
if flag and gd>math.random(100) then
s[3-id].txt=str[5][math.random(10)]
flag=true
s[3-id].action=3
PlayWavE(31)
dechp(3-id,atk[id],true)
s[3-id].effect=208
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
else
s[3-id].txt=str[4][math.random(10)]
s[3-id].action=4
PlayWavE(36)
dechp(3-id,40+atk[id])
end
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
end
if s[3-id].x>s[id].x then
if flag or s[3-id].x>SW-size*3 then
s[3-id].x=s[3-id].x+size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x+size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x+size/2
end
elseif flag or s[3-id].x<size*2 then
s[3-id].x=s[3-id].x-size/2
else
s[id].x=s[3-id].x
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(s[id].movewav)
ReFresh()
s[id].x=s[id].x-size/2
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
s[id].x=s[id].x-size/2
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n)
s[3-id].effect=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(n*3)
reset_all()
end
local function win(id)
local eid=3-id
s[eid].txt=str[6][math.random(10)]
PlayWavE(38)
s[eid].action=5
for i=1,4 do
if s[eid].action==9 then
s[eid].action=5
else
s[eid].action=9
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(3)
end
for i=16,128,16 do
s[eid].effect=i
if s[eid].action==9 then
s[eid].action=5
else
s[eid].action=9
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(4)
end
PlayWavE(22)
s[eid].losser=true
s[eid].action=5
for i=128,256,16 do
s[eid].effect=i
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
JY.ReFreshTime=lib.GetTime()
ReFresh(4)
s[eid].action=9
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(20)
s[id].action=0
s[id].d=0
s[id].txt=str[7][math.random(10)]
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
s[id].action=6
JY.ReFreshTime=lib.GetTime()
show()
PlayWavE(8)
ReFresh(12)
PlayWavE(5)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
local wname=JY.Person[ID[id]]["ĞÕÃû"]
if hp[id]==hpmax[id] then
wname=wname.." †lt"
else
wname=wname.." t"
end
DrawString(math.floor(CC.ScreenW/2)-#wname*12,210,wname,M_White,48)--koDuelWinShift 5.0: centred on the screen (drawn outside show()) (10-10)
for t=1,10 do
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
end
end
-- ko 3.1: cards come from a shuffled deck (1..9 twice per side) instead of independent rolls, so the hand is never starved of a number
local deck={[1]={},[2]={}}
local function draw_card(id)
if #deck[id]==0 then
for v=1,9 do deck[id][#deck[id]+1]=v deck[id][#deck[id]+1]=v end
for i=#deck[id],2,-1 do local j=math.random(i) deck[id][i],deck[id][j]=deck[id][j],deck[id][i] end
end
return table.remove(deck[id])
end
-- the human side: the tourney's pick (koDuelPlayer), my army in battle, my roster in the story; never on the title otherwise
local function is_human(i)
if koDuelPlayer==ID[i] then return true end-- the tourney: always hand-picked, whatever the setting
if (CC.koDuelPick or 1)~=1 then return false end
local pid=ID[i]
if koDuelPlayer==pid then return true end
if JY.Status==GAME_WMAP then local w=GetWarID(pid) if w>0 and War.Person[w] then return (not War.Person[w].enemy) and (not War.Person[w].friend) end end
if JY.Status==GAME_START then return false end
return JY.Person[pid]["\190\253\214\247"]==1-- å›ä¸»
end
--ì¹´ë“œ (í–‰ë™ ì„ íƒ) AI
local function card_ini(idx)
card[idx]={}
for i=1,card_num[idx] do
card[idx][i]=draw_card(idx)
end
end
local function card_sort(idx)
for i=1,card_num[idx]-1 do
for j=i+1,card_num[idx] do
if card[idx][i]>card[idx][j] then
card[idx][i],card[idx][j]=card[idx][j],card[idx][i]
end
end
end
end
local function card_value(id,n1,n2,n3)
local pid=ID[id]
local p=JY.Person[pid]
local wl=p["ÎäÁ¦"]
local offset=math.max(wl/2-41,0)
if wl>=100 and mp[id]>=99 and n1==4 and n2==4 and n3==4 then
return 65,9
end
if p["ÃØ¼¼1"]>0 and mp[id]>=60 and n1==1 and n2==1 and n3==1 then
return 60+offset,8
end
if (p["Á¬»÷"]==4 or p["Á¬»÷"]==5 or p["Á¬»÷"]==6 or p["Á¬»÷"]==7) and mp[id]>=55 and n1==3 and n2==7 and n3==8 then
return 55+offset,7
end
if (p["±©»÷"]==4 or p["±©»÷"]==5 or p["±©»÷"]==6 or p["±©»÷"]==7) and mp[id]>=55 and n1==1 and n2==5 and n3==9 then
return 55+offset,6
end
if p["»ØÂí"]>0 and mp[id]>=50 and n1==5 and n3==7 then
return 50+offset,5
end
if mp[id]>=40 and n1==2 and n2==5 and (n3==8 or n3==9) then
if pid==54 then--ì¡°ìš´
return 45+offset,7
elseif pid==190 then--ë§ˆì´ˆ
return 45+offset,5
elseif pid==2 then--ê´€ìš°
return 45+offset,99
elseif pid==3 then--ì¥ë¹„
return 45+offset,6
elseif pid==5 then
return 45+offset,8
end
end
if (p["Á¬»÷"]==2 or p["Á¬»÷"]==3 or p["Á¬»÷"]==6 or p["Á¬»÷"]==7) and mp[id]>=45 and n1==3 and n3<7 and n2+1==n3 then
return 40+offset,4
end
if (p["±©»÷"]==2 or p["±©»÷"]==3 or p["±©»÷"]==6 or p["±©»÷"]==7) and mp[id]>=45 and n1==2 and n2>5 and n2==n3 then
return 40+offset,3
end
if (p["Á¬»÷"]==1 or p["Á¬»÷"]==3 or p["Á¬»÷"]==5 or p["Á¬»÷"]==7) and mp[id]>=40 and n1+1==n2 and n2+1==n3 then
return 30+offset,2
end
if (p["±©»÷"]==1 or p["±©»÷"]==3 or p["±©»÷"]==5 or p["±©»÷"]==7) and mp[id]>=40 and n1==n2 and n2==n3 then
return 30+offset,1
end
return n1+n2+n3,0
end
local function card_remove(id,t1,t2,t3)
for i=1,card_num[id] do
if card[id][i]==t1 then
table.remove(card[id],i)
break
end
end
for i=1,card_num[id]-1 do
if card[id][i]==t2 then
table.remove(card[id],i)
break
end
end
for i=1,card_num[id]-2 do
if card[id][i]==t3 then
table.remove(card[id],i)
break
end
end
table.remove(card[id],1)
for i=card_num[id]-3,card_num[id] do
card[id][i]=draw_card(id)
end
end
local function card_ai(id)
local t1,t2,t3
local vmax=0
local kind
card_sort(id)
for i=1,card_num[id]-2 do
for j=i+1,card_num[id]-1 do
for k=j+1,card_num[id] do
local v1,v2=card_value(id,card[id][i],card[id][j],card[id][k])
if vmax<v1 then
vmax=v1
kind=v2
t1,t2,t3=card[id][i],card[id][j],card[id][k]
end
end
end
end
card_remove(id,t1,t2,t3)
return vmax,kind
end
-- ko 3.1: the human side's turn: the hand is shown (draw_hand via show_raw), three cards are picked by click or the digit
-- keys, ê²°ì • (Enter/Space) plays them, ìë™ (A) leaves it to card_ai. Returns like card_ai
local function card_pick(id)
card_sort(id)
pick={id=id,sel={},hov=0}
koMouseReset()
local function count() local n=0 for _,v in pairs(pick.sel) do if v then n=n+1 end end return n end
local bx=CX+108
local function bhit(k) local x=bx+(k-1)*64+koOX return MOUSE.CLICK(x,HAND_Y+2+koOY,x+56,HAND_Y+30+koOY) end
while true do
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then koExit() end
-- the ê·œì¹™ overlay swallows the next key or click
if pick.help then
if e==1 or MOUSE.CLICK(0,0,CC.ScreenW,CC.ScreenH) then pick.help=nil PlayWavE(1) end
else
pick.hov=0
for i=1,card_num[id] do
local x=hand_x(id,i)+koOX
local y=HAND_Y+koOY
if MOUSE.IN(x,y,x+CARD_W,y+CARD_H) then pick.hov=i end
if MOUSE.CLICK(x,y,x+CARD_W,y+CARD_H) then
if pick.sel[i] then pick.sel[i]=nil PlayWavE(1) elseif count()<3 then pick.sel[i]=true PlayWavE(0) end
end
end
if e==1 and k>=49 and k<=57 then-- a digit: the first unpicked card of that number
for i=1,card_num[id] do if card[id][i]==k-48 and not pick.sel[i] and count()<3 then pick.sel[i]=true PlayWavE(0) break end end
end
-- the combination the three picked cards make
pick.preview=nil
if count()==3 then
local t={}
for i,v in pairs(pick.sel) do if v then t[#t+1]=card[id][i] end end
table.sort(t)
local v,kk=card_value(id,t[1],t[2],t[3])
pick.preview=(KIND[kk] or KIND[0]).." "..v
end
local ok=(e==1 and (k==13 or k==32)) or bhit(1)
if ok and count()==3 then break end
if (e==1 and k==97) or bhit(2) then pick=nil PlayWavE(0) return card_ai(id) end
if (e==1 and (k==114 or k==104 or k==47)) or bhit(3) then pick.help=true PlayWavE(0) end-- R / H / ? = ê·œì¹™
end
end
PlayWavE(0)
local t={}
for i,v in pairs(pick.sel) do if v then t[#t+1]=card[id][i] end end
table.sort(t)
pick=nil
local v,kd=card_value(id,t[1],t[2],t[3])
card_remove(id,t[1],t[2],t[3])
return v,kd
end
card_ini(1)
card_ini(2)
local action_v={}
local action_k={}
local function automove()
local cx=CX-48
local cur=1
if math.abs(s[1].x-cx)<math.abs(s[2].x-cx) then
cur=2
end
if math.abs(s[cur].x-s[3-cur].x)>size then
if s[cur].x>s[3-cur].x then
move(cur,s[3-cur].x+size)
else
move(cur,s[3-cur].x-size)
end
end
end
local function arrive(id)
s[id].action=0
PlayWavE(5)
for i=256,0,-4*ka do
s[id].effect=i
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
end
end
--ë“±ì¥
show()
Light()
PlayWavE(4)
arrive(1)
s[1].txt=p1["ÍâºÅ"].." bƒG „OM!"..str[1][math.random(10)]
s[1].d=3
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
arrive(2)
s[2].txt="ƒv‚b "..p2["ÍâºÅ"].."GM."
s[2].d=2
PlayWavE(6)
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(25)
--ê°œì „ íŠ¹ê¸°: ì¼ê²© / ì•”ê¸°
local msflag=false
for i=1,2 do
local pid=ID[i]
local eid=ID[3-i]
if JY.Person[pid]["Ò»»÷"]>0 and JY.Person[pid]["ÎäÁ¦"]-JY.Person[eid]["ÎäÁ¦"]>=5 and math.random(100)<=25 then
atk_ms(i,JY.Person[eid]["ÎäÁ¦"]-65)
mp[i]=0
msflag=true
if hp[1]==0 then
win(2)
return 2
end
if hp[2]==0 then
win(1)
return 1
end
break
end
end
if not msflag then
for i=1,2 do
local pid=ID[i]
local eid=ID[3-i]
if JY.Person[pid]["°µÆ÷"]>0 and math.random(10)<=5 then
atk_aq(i,JY.Person[eid]["ÎäÁ¦"]-30)
break
end
end
move2(CX-96,CX)
else
automove()
end
--ë³¸ ì „íˆ¬ ë£¨í”„
while true do
local cur=1
for i=1,2 do
if is_human(i) then action_v[i],action_k[i]=card_pick(i) else action_v[i],action_k[i]=card_ai(i) end--ko 3.1
end
reveal={action_v[1],action_v[2]}
automove()
if math.abs(action_v[1]-action_v[2])<=1 then
atk_p(1,action_v[1]+action_v[2])
else
if action_v[1]>action_v[2] then
cur=1
else
cur=2
end
automove()
local gd=s[3-cur].luck+20*action_v[3-cur]/action_v[cur]
if action_k[cur]==0 then
atk_s0(cur,gd)
elseif action_k[cur]==1 then
atk_s1(cur,gd)
elseif action_k[cur]==2 then
atk_s2(cur,gd)
elseif action_k[cur]==3 then
atk_s3(cur,gd)
elseif action_k[cur]==4 then
atk_s4(cur,gd)
elseif action_k[cur]==5 then
atk_s5(cur,gd)
elseif action_k[cur]==6 then
atk_s6(cur,gd)
elseif action_k[cur]==7 then
atk_s7(cur,gd)
elseif action_k[cur]==8 then
atk_s8(cur,gd)
elseif action_k[cur]==9 then
atk_s8(cur,5)
elseif action_k[cur]==99 then
atk_ms(cur,JY.Person[ID[3-cur]]["ÎäÁ¦"]-60)
else
atk_s0(cur,gd)
end
if action_k[cur]~=0 then
admp(cur,-math.modf(action_v[cur]/10)*8)
end
end
if hp[1]==0 then
win(2)
return 2
elseif hp[2]==0 then
win(1)
return 1
end
if s[1].x>s[2].x then
turn(1,2)
turn(2,3)
else
turn(1,3)
turn(2,2)
end
if hp[3-cur]<hpmax[3-cur]/2 and s[3-cur].jj>0 and math.random(100)<=20 then
s[3-cur].jj=0
atk_jj(3-cur)
end
if hp[3-cur]<hpmax[3-cur]/3 and s[3-cur].dl>0 and math.random(100)<=30 then
s[3-cur].dl=0
atk_dl(3-cur)
card_num[3-cur]=card_num[3-cur]+1
card[3-cur][card_num[3-cur]]=draw_card(3-cur)
admp(3-cur,100)
end
JY.ReFreshTime=lib.GetTime()
show()
for i=1,2 do
admp(i,s[i].mpadd)
end
ReFresh(4)
end
end

function war(id1,id2,sid)
local n=2
local ID={id1,id2}
local p1,p2=JY.Person[id1],JY.Person[id2]
local bzpic1,bzpic2
local s={}
bzpic1=GetBZPic(id1,false,false)
bzpic2=GetBZPic(id2,true,false)
for i=0,100 do
s[i]={
d=3,--0123 ÏÂÉÏ×óÓÒ
x=142+32*math.modf(i/9),
y=300+18*(i%9),
pic=bzpic1,
action=0,--0¾²Ö¹ 1ÒÆ¶¯ 2¹¥»÷ 3·ÀÓù 4±»¹¥»÷ 5´­Æø 9²»´æÔÚ
frame=0,
effect=0,
movewav=JY.Bingzhong[p1["±øÖÖ"]]["ÒôĞ§"],
txt="",
leader=false,
}
end
local sy=270
local pic1=0
local pic2=10
-- 00 Æ½Ô­ 01 É­ÁÖ 02 É½µØ 03 ºÓÁ÷ 04 ÇÅÁº 05 ³ÇÇ½ 06 ³Ç³Ø 07 ²İÔ­
-- 08 ´å×¯ 09 ĞüÑÂ 0A ³ÇÃÅ 0B »ÄµØ 0C Õ¤À¸ 0D Â¹íÎ 0E ±øÓª 0F Á¸²Ö
-- 10 ±¦Îï¿â 11 ·¿Éá 12 »ğÑæ 13 ×ÇÁ÷
if sid==0 or sid==7 then
pic1=4
pic2=12
elseif sid==2 or sid==11 then
pic1=0
pic2=13
elseif sid==1 then
pic1=3
pic2=12
elseif sid==4 then
pic1=1
pic2=11
elseif sid==6 or sid==8 or sid==13 or sid==14 or sid==15 or sid==16 then
pic1=2
pic2=10
end
local test_n=88
local array=WarFormation(1,test_n)
for i=1,test_n do
s[i].x=200+array.x[i]
s[i].y=350+array.y[i]
s[i].pic=bzpic1
s[i].leader=false
end
s[array.leader].leader=true
s[array.leader].pic=p1["Õ½¶·¶¯×÷"]
s[array.leader].y=s[array.leader].y-16
local function show()
local piccacheid=12
local size=60
local size2=80
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(1,pic2*2,0,310,1)
lib.PicLoadCache(1,pic1*2,-68,190,1)
for i=1,test_n do
if s[i].leader then
piccacheid=12
size=60
size2=80
else
piccacheid=1
size=48
size2=64
end
if s[i].action==0 then
lib.PicLoadCache(piccacheid,(s[i].pic+16+s[i].d)*2,s[i].x,s[i].y,1)
elseif s[i].action==1 then
lib.PicLoadCache(piccacheid,(s[i].pic+s[i].frame+s[i].d*4)*2,s[i].x,s[i].y,1)
elseif s[i].action==2 then
lib.PicLoadCache(piccacheid,(s[i].pic+30+s[i].frame+s[i].d*4)*2,s[i].x+(size-size2)/2,s[i].y+(size-size2)/2,1)
elseif s[i].action==3 then
lib.PicLoadCache(piccacheid,(s[i].pic+22+s[i].d)*2,s[i].x,s[i].y,1)
elseif s[i].action==4 then
lib.PicLoadCache(piccacheid,(s[i].pic+26+s[i].d%2)*2,s[i].x,s[i].y,1)
elseif s[i].action==5 then
lib.PicLoadCache(piccacheid,(s[i].pic+20+s[i].frame)*2,s[i].x,s[i].y,1)
elseif s[i].action==6 then
lib.PicLoadCache(piccacheid,(s[i].pic+28)*2,s[i].x,s[i].y,1)
end
end
lib.PicLoadCache(2,230*2,0,0,1)
end
local function move(dx)
local flag=1
for id=0,100 do
s[id].action=1
end
JY.ReFreshTime=lib.GetTime()
show()
ReFresh()
local step=18
if dx<s[0].x then
step=-step
end
for i=s[0].x,dx,step do
for id=0,100 do
s[id].x=s[id].x+step
s[id].frame=s[id].frame+1
if s[id].frame>=2 then
s[id].frame=0
end
end
JY.ReFreshTime=lib.GetTime()
show()
if flag==1 then
PlayWavE(s[0].movewav)
flag=4
else
flag=flag-1
end
ReFresh(2)
lib.GetKey()
end
s[1].action=0
s[2].action=0
s[1].frame=0
s[2].frame=0
JY.ReFreshTime=lib.GetTime()
show()
ReFresh(2)
end
move(600)
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
WaitKey()
end

function WarFormation(kind,n)
local array={}
array.x={}
array.y={}
array.leader=1
if kind==1 then
--Ô²Õó
--1 8 16 24 32
local T={1,8,16,24,32,40,48}
local T2={1,9,25,49,81,121,169}
local lv=1
local len=0
if n>49 then
lv=5
len=40
elseif n>25 then
lv=4
len=40
elseif n>9 then
lv=3
len=48
elseif n>1 then
lv=2
len=54
end
T[2]=math.modf(T[2]*n/T2[lv])
T[3]=math.modf(T[3]*n/T2[lv])
T[4]=math.modf(T[4]*n/T2[lv])
T[5]=math.modf(T[5]*n/T2[lv])
if lv==2 then
 T[2]=n-T[1]
elseif lv==3 then
T[3]=n-T[2]-T[1]
elseif lv==4 then
T[4]=n-T[3]-T[2]-T[1]
elseif lv==5 then
T[5]=n-T[4]-T[3]-T[2]-T[1]
end
local num=1
array.x[1]=0
array.y[1]=0
array.leader=1
num=2
for i=2,lv do
for t=1,T[i] do
array.x[num]=math.modf(len*(i-1)*math.cos(2*math.pi*t/T[i]))
array.y[num]=math.modf(len*0.6*(i-1)*math.sin(2*math.pi*t/T[i]))
num=num+1
end
end
elseif kind==2 then
--·½Õó
local lv=1
local len=0
array.leader=1
if n>81 then
lv=10
len=32
array.leader=5
elseif n>64 then
lv=9
len=36
array.leader=5
elseif n>49 then
lv=8
len=40
array.leader=4
elseif n>36 then
lv=7
len=44
array.leader=4
elseif n>25 then
lv=6
len=48
array.leader=3
elseif n>16 then
lv=5
len=52
array.leader=3
elseif n>9 then
lv=4
len=56
array.leader=2
elseif n>4 then
lv=3
len=60
array.leader=2
elseif n>1 then
lv=2
len=64
end
for num=1,n do
local x=math.modf((num-1)/lv)
local y=(num-1)%lv
array.x[num]=math.modf(len*((lv-1)/2-x))
array.y[num]=math.modf(len*0.6*(y-(lv-1)/2))
end
end
--·æÊ¸
--ÑãĞĞ
--×¶ĞÎ
--ÓãÀö
--³¤Éß
local theat=math.pi/24
for i=1,n do
array.x[i]=array.x[i]*(1+array.y[i]/100*math.tan(theat))
end
for i=1,n-1 do
for j=i+1,n do
if array.y[i]>array.y[j] or (array.y[i]==array.y[j] and array.x[i]>array.x[j]) then
array.x[i],array.x[j]=array.x[j],array.x[i]
array.y[i],array.y[j]=array.y[j],array.y[i]
if i==array.leader then
array.leader=j
elseif j==array.leader then
array.leader=i
end
end
end
end
return array
end

--Ô­mouse.lua
MOUSE={
x=0,
y=0,
hx=0,
hy=0,
rx=0,
ry=0,
status='IDLE',
Holdtime=0;--ÓÃÓÚ¼ÆËã³¤°´
enableclick=true;
EXIT=function()
if MOUSE.status=='EXIT' then
MOUSE.status='IDLE';
return true;
end
return false;
end,
ESC=function()
if MOUSE.status=='ESC' then
MOUSE.status='IDLE';
return true;
end
return false;
end,
IN=function(x1,y1,x2,y2)
if MOUSE.status=='IDLE' or MOUSE.status=='HOLD' or MOUSE.status=='CLICK' or MOUSE.status=='ESC'then
if between(MOUSE.x,x1,x2) and
between(MOUSE.y,y1,y2) then
return true;
end
end
return false;
end,
HOLD=function(x1,y1,x2,y2,t)
t=t or 0;
if MOUSE.status=='HOLD' then
if between(MOUSE.x,x1,x2) and
between(MOUSE.y,y1,y2) and
between(MOUSE.hx,x1,x2) and
between(MOUSE.hy,y1,y2) then
return true;
end
end
return false;
end,
CLICK=function(x1,y1,x2,y2)
if MOUSE.status=='CLICK' then
if x1==nil then
MOUSE.status='IDLE';
return true;
end
local t=CC.MouseClickType or 0
local s=CC.MouseClickSlack or 8
local rin=between(MOUSE.rx,x1,x2) and between(MOUSE.ry,y1,y2)
local hin
if t==0 then hin=between(MOUSE.hx,x1-s,x2+s) and between(MOUSE.hy,y1-s,y2+s)
else hin=between(MOUSE.hx,x1,x2) and between(MOUSE.hy,y1,y2) end
if (t==0 and rin and hin) or (t==1 and hin) or (t==2 and rin) then
MOUSE.status='IDLE';
return true;
end
end
return false;
end,
}
function getkey()
if CONFIG.Windows then
return getkey_pc();
else
return getkey_sp();
end
end

-- ko: message boxes and other direct lib.GetKey(1)/lib.GetMouse(1) readers consume a press without
-- removing the queued events. Remember it, so getkey_pc drops that press/release instead of turning it
-- into a click on the next screen. lib.GetMouse(1) returns (button mask 1 left 4 right, x, y) without dequeuing.
local koRawGetKey,koRawGetMouse=lib.GetKey,lib.GetMouse
-- ko 3.0: modifier, lock and IME keys by themselves are dropped (SDL keycodes: L/R Ctrl Shift Alt Win 1073742048..55,
-- CapsLock 1073741881, ScrollLock 1073741895, NumLock 1073741907, í•œ\/ì˜ 1073741968, í•œì 1073741969)
local koModKey={[1073742048]=1,[1073742049]=1,[1073742050]=1,[1073742051]=1,[1073742052]=1,[1073742053]=1,[1073742054]=1,[1073742055]=1,
[1073741881]=1,[1073741895]=1,[1073741907]=1,[1073741968]=1,[1073741969]=1}
lib.GetKey=function(a)
local W=rawget(_G,"War")
local ai=(W and (W.koAI or W.koAutoRun) and lib.GetTime()-(W.koAIStart or 0)>500)
if a==nil then
if ai then--ko 3.1: the enemy phase flushes the queue here; look for the skip key (ai_key hook) while draining
local s,sr=MOUSE.koSwallow,MOUSE.koSwallowR
for i=1,64 do
local e,k=koRawGetKey(1)
if e==-1 or e==nil then break end
if e==4 then MOUSE.koFingerDown=nil end--ko 5.1 (10-16 fix)
if W and W.koAutoAll and ((e==1 and k==27) or (e==3 and k==3)) then W.koAutoAll=false W.koAutoOff=true end--ko 3.3

if e==1 and (not W.koSkip) and koHook("ai_key",k) then W.koSkip=true end
if e==3 and (not W.koSkip) and (not W.koInTalk) and (not CONFIG.Windows) then W.koSkip=true end--android: a tap skips the enemy phase (only while nothing waits for it)
end
MOUSE.koSwallow,MOUSE.koSwallowR=s,sr
return
end
local e,k,x,y=koRawGetKey()
if (not CONFIG.Windows) and e then if e==3 and k==1 then MOUSE.koFingerDown=true elseif e==4 or (e==3 and k==3) then MOUSE.koFingerDown=nil end end--ko 5.1 (10-16 fix2): android lib.GetKey() also dequeues one event; a finger-up eaten by the scene loops (lib.GetKey() between talks) left koFingerDown stuck, so talks ran by themselves after a few
return e,k,x,y
end
local e,k,x,y=koRawGetKey(a)
if e==1 and (k==1073742048 or k==1073742052) then MOUSE.koCtrl=true elseif e==2 and (k==1073742048 or k==1073742052) then MOUSE.koCtrl=nil elseif (e==1 or e==3) and MOUSE.koCtrl then MOUSE.koCtrl=nil end--ko 5.1 (10-16): Ctrl held (talk fast-forward); another key or a click clears it (a lost key-up)
if e==3 and k==1 then MOUSE.koFingerDown=true elseif e==4 or (e==3 and k==3) then MOUSE.koFingerDown=nil end--ko 5.1 (10-16 fix): finger/left button held (android talk fast-forward)
if e==1 and koModKey[k] then e,k=-1,-1 end
if e==3 then if k==1 then MOUSE.koSwallow=true elseif k==3 then MOUSE.koSwallowR=true end end
if W and W.koAutoAll and ((e==1 and k==27) or (e==3 and k==3)) then W.koAutoAll=false W.koAutoOff=true end--ko 3.3

if e==1 and ai and (not W.koSkip) and koHook("ai_key",k) then W.koSkip=true end--ko 3.1: any poll during the enemy phase
return e,k,x,y
end
lib.GetMouse=function(a)
if a==nil then local b,x,y,z=koRawGetMouse() if (not CONFIG.Windows) and b then if b==3 and x==1 then MOUSE.koFingerDown=true elseif b==4 or (b==3 and x==3) then MOUSE.koFingerDown=nil end end return b,x,y,z end--ko 5.1 (10-16 fix2)
local b,x,y,z=koRawGetMouse(a)
if (not CONFIG.Windows) and b then if b==3 and x==1 then MOUSE.koFingerDown=true elseif b==4 or (b==3 and x==3) then MOUSE.koFingerDown=nil end end--ko 5.1 (10-16 fix): android returns events here too
if b and b%2==1 then MOUSE.koSwallow=true end
if b and math.floor(b/4)%2==1 then MOUSE.koSwallowR=true end
return b,x,y,z
end

function getkey_pc()
local koSw,koSwR=MOUSE.koSwallow,MOUSE.koSwallowR
local eventtype,keypress,x,y=lib.GetKey(1);
local koN=0
local koUpX,koUpY
while (eventtype==2 or eventtype==4) and koN<32 do
if eventtype==4 and keypress==1 and MOUSE.status~='HOLD' then koUpX,koUpY=x,y end
eventtype,keypress,x,y=lib.GetKey(1)
koN=koN+1
end
MOUSE.koSwallow,MOUSE.koSwallowR=koSw,koSwR
-- ko: MOUSE.koMask = button mask seen at the previous poll (1 left, 2 middle, 4 right)
local koPrev=MOUSE.koMask or 0
local koPrevL=(koPrev%2==1)
local koPrevR=(math.floor(koPrev/4)%2==1)
local koRel=MOUSE.koRel
MOUSE.koRel=nil
if eventtype==0 then
MOUSE.status='EXIT';
elseif eventtype==3 then
if keypress==1 then
if koSw then
-- ko: this press was already consumed by a message box; drop it (its release is dropped below)
eventtype,keypress=-1,-1
else
MOUSE.status='HOLD';
MOUSE.x,MOUSE.y=x,y;
MOUSE.hx,MOUSE.hy=x,y;
if not koPrevL then MOUSE.koMask=koPrev+1 end
end
elseif keypress==3 then
if koSwR or (koPrevR and MOUSE.koSynR) then
-- ko: consumed elsewhere, or already reported from the button mask at the previous poll
MOUSE.koSynR=nil
eventtype,keypress=-1,-1
else
MOUSE.status='ESC';
if not koPrevR then MOUSE.koMask=koPrev+4 end
end
end
else
local mask;
mask,x,y=lib.GetMouse();
MOUSE.x,MOUSE.y=x,y;
MOUSE.koMask=mask
local koL=(mask%2==1)
local koR=(math.floor(mask/4)%2==1)
if koL and not koPrevL and MOUSE.status~='HOLD' and not koSw then
-- ko: the press event was hidden behind later motion events (lib.GetKey only returns the last one).
-- Rebuild it from the button mask; the release then becomes CLICK through the normal path.
MOUSE.status='HOLD';
MOUSE.hx,MOUSE.hy=x,y;
eventtype,keypress=3,1
elseif koUpX and MOUSE.status~='HOLD' and not koRel and not koSw then
-- ko: press and release arrived within one poll, so lib.GetKey only delivered the release.
-- Recreate the press here; the next poll turns it into CLICK through the normal path.
MOUSE.status='HOLD';
MOUSE.x,MOUSE.y=koUpX,koUpY;
MOUSE.hx,MOUSE.hy=koUpX,koUpY;
elseif not koL then
if MOUSE.status=='HOLD' then
if MOUSE.enableclick then
MOUSE.status='CLICK';
MOUSE.rx,MOUSE.ry=x,y;
else
MOUSE.enableclick=true;
MOUSE.status='IDLE';
end
MOUSE.koRel=true
end
MOUSE.koSwallow=nil
end
if koR and not koPrevR and not koSwR then
-- ko: right press hidden behind motion events
MOUSE.status='ESC';
MOUSE.koSynR=true
eventtype,keypress=3,3
elseif not koR then
MOUSE.koSynR=nil
MOUSE.koSwallowR=nil
end
end
return eventtype,keypress,x,y;
end

function getkey_sp()
local eventtype,keypress,x,y=lib.GetMouse(1);
if eventtype==0 then
MOUSE.status='EXIT';
elseif eventtype==2 then
MOUSE.x,MOUSE.y=x,y;
elseif eventtype==3 then
if keypress==1 then
MOUSE.status='HOLD';
MOUSE.x,MOUSE.y=x,y;
MOUSE.hx,MOUSE.hy=x,y;
MOUSE.koHoldT=lib.GetTime()--ko 4.0 touch: long press
elseif keypress==3 then
MOUSE.status='ESC';
end
elseif eventtype==4 then
if keypress==1 then
if MOUSE.status=='HOLD' then
if MOUSE.enableclick then
MOUSE.status='CLICK';
MOUSE.x,MOUSE.y=x,y;
MOUSE.rx,MOUSE.ry=x,y;
else
MOUSE.enableclick=true;
MOUSE.status='IDLE';
MOUSE.x,MOUSE.y=x,y;
end
end
else
MOUSE.status='IDLE';
MOUSE.x,MOUSE.y=x,y;
end
end
return eventtype,keypress,x,y;
end

-- ko: unit list for the top-right panel buttons (657..687 = our side, 689..719 = enemy side).
-- Drawn inside the status panel (607..752 x 72..356) like the original game: name, troop bar, cur/max.
-- Hover highlights a row, click scrolls the map to that unit; the two buttons switch sides while open;
-- right-click, a key, or a click elsewhere closes it. Scroll arrows/thumb use the frame of picture 67.
function koArmyList(enemy)
War.koListOpen=true
koArmyList_sub(enemy)
War.koListOpen=nil
end
function koArmyList_sub(enemy)
local side=enemy
local koPx=0
if koWide() then koPx=War.koPX or 0 else koPx=koFramePX() end
local X1,Y1,X2,Y2=607+koPx,72,753+koPx,357
local rowh=24
local rows=11
local top=Y1+6
local scx=X2-19
local size=16
local function build()
local ids,n={},0
for i=1,War.PersonNum do
local v=War.Person[i]
if v and v.live and (not v.hide) and ((v.enemy==true)==side) then
n=n+1
ids[n]=i
end
end
return ids,n
end
local ids,n=build()
if n==0 then
PlayWavE(2)
return
end
PlayWavE(0)
War.CurID=0
local start=1
local cur=0
local dn=top+rows*rowh-17
local trk0=top+18
local trk1=dn-2-16
local rx=X2-4
-- faction name for the name box: lord of the listed units + "gun", like the original ("Yuan Shao's army");
-- falls back to the enemy commander, then to plain "our side"/"enemy side"
local function label()
local lead=0
if n>0 then
lead=JY.Person[War.Person[ids[1]].id]["¾ıÖ÷"] or 0
end
if lead==0 and side and War.Leader2 and War.Leader2>0 and JY.Person[War.Leader2] then
lead=JY.Person[War.Leader2]["¾ıÖ÷"] or 0
if lead==0 then lead=War.Leader2 end
end
if lead>0 and JY.Person[lead] then
return JY.Person[lead]["ĞÕÃû"].."‚T"
end
if side then return "ƒL‚T" end
return "n‚T"
end

local function draw()
DrawWarMap()
if koWide() then lib.Background(600+koPx,32,768+koPx,364,176,M_Black) lib.DrawRect(600+koPx,32,767+koPx,363,M_Gray) else
lib.FillColor(X1,Y1,X2,Y2,M_Black)
end
local lab=label()
local lsz=16
if #lab*8>42 then lsz=14 end
DrawString(632+koPx-#lab*lsz/4,40+(16-lsz)/2,lab,M_White,lsz)
local shown=math.min(rows,n)
rx=X2-4
if n>rows then rx=scx-2 end
for r=0,shown-1 do
local i=start+r
if i>n then break end
local wid=ids[i]
local p=JY.Person[War.Person[wid].id]
local y=top+r*rowh
if i==cur then
lib.DrawRect(X1+1,y,rx+2,y+rowh-2,M_White)
end
local s=p["±øÁ¦"].."/"..p["×î´ó±øÁ¦"]
local nx=rx-#s*8
lib.SetClip(X1+4,y,nx-2,y+size+2)
DrawString(X1+4,y,p["ĞÕÃû"],M_White,size)
lib.SetClip(0,0,0,0)
DrawString2(nx,y,s,M_White,size)
local bx=X1+4
local blen=rx-bx
local ratio=math.min(100*p["±øÁ¦"]/math.max(p["×î´ó±øÁ¦"],1),100)
local color=212
if ratio<30 then color=210 elseif ratio<70 then color=211 end
lib.FillColor(bx,y+17,bx+blen,y+22,M_DarkSlateGray)
if ratio>1 then
lib.SetClip(bx,y+17,bx+math.max(1,math.modf(blen*ratio/100)),y+22)
lib.PicLoadCache(4,color*2,bx,y+15,1)
lib.SetClip(0,0,0,0)
end
end
if n>rows then
lib.SetClip(scx,top,scx+17,top+17)
lib.PicLoadCache(4,67*2,scx-96,top-8,1)
lib.SetClip(0,0,0,0)
lib.SetClip(scx,dn,scx+17,dn+17)
lib.PicLoadCache(4,67*2,scx-96,dn-360,1)
lib.SetClip(0,0,0,0)
lib.DrawRect(scx+2,trk0,scx+14,trk1+16,M_DimGray)
local ty=trk0+math.modf((trk1-trk0)*(start-1)/(n-rows))
lib.PicLoadCache(4,68*2,scx+2,ty,1)
end
end
koMouseReset()
while true do
JY.ReFreshTime=lib.GetTime()
draw()
ReFresh(0.4)
local e,k=getkey()
if MOUSE.EXIT() then
if koExit then koExit() else koExitAsk() end
end
local mx,my=MOUSE.x,MOUSE.y
if (e==3 and k==3) or e==1 then
break
end
local nn=math.max(n-rows,0)
cur=0
local shown=math.min(rows,n)
if between(mx,X1,rx) and shown>0 and between(my,top,top+shown*rowh-1) then
local r=math.modf((my-top)/rowh)
local i=start+r
if i<=n then
cur=i
if MOUSE.CLICK(X1,top+r*rowh,rx,top+(r+1)*rowh-1) then
PlayWavE(0)
WarPersonCenter(ids[i])
return
end
end
elseif nn>0 and MOUSE.CLICK(scx,top,scx+17,top+17) then
start=limitX(start-1,1,nn+1)
elseif nn>0 and MOUSE.CLICK(scx,dn,scx+17,dn+17) then
start=limitX(start+1,1,nn+1)
elseif nn>0 and MOUSE.HOLD(scx,trk0,scx+17,trk1+16) then
MOUSE.enableclick=false
start=limitX(1+math.modf((my-8-trk0)*nn/(trk1-trk0)+0.5),1,nn+1)
elseif (koWide() and MOUSE.CLICK(90,6,134,24)) or ((not koWide()) and MOUSE.CLICK(657+koPx,32,687+koPx,63)) then
if side then
side=false
ids,n=build()
start=1
end
elseif (koWide() and MOUSE.CLICK(140,6,184,24)) or ((not koWide()) and MOUSE.CLICK(689+koPx,32,719+koPx,63)) then
if not side then
side=true
ids,n=build()
start=1
end
elseif MOUSE.CLICK() then
break
end
end
PlayWavE(1)
end

-- ko 3.1: JY.koInTalk > 0 while a dialogue box (talk_sub) or a narration box (DrawMulitStrBox) is up. DrawWarMap keeps
-- running inside those, so overlays such as the threat range check it and stay off (the flag was asked for after the
-- range showed through a battle conversation)
do
local rawTalk=talk_sub
talk_sub=function(...)
JY.koInTalk=(JY.koInTalk or 0)+1
local a,b,c=rawTalk(...)
JY.koInTalk=JY.koInTalk-1
return a,b,c
end
local rawBox=DrawMulitStrBox
DrawMulitStrBox=function(...)
JY.koInTalk=(JY.koInTalk or 0)+1
local a,b,c=rawBox(...)
JY.koInTalk=JY.koInTalk-1
return a,b,c
end
end
