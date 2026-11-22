-- ko 3.1 addon core: loader, hooks and the registries the base jymain.lua reads.
-- Loaded by JY_Main_sub right after kdef.lua / kocost.lua, before the settings file. An addon is a plain Lua file in
-- script/addon/ listed in addons.lua; it registers handlers with koOn(name,fn) and rows/items/keys in the registries.
-- Everything it defines as a global (functions, tables) is available to the base at run time.
koAddon={
list={},           -- addons.lua rows in order: {name, enabled}
loaded={},         -- name -> true once its file ran
hooks={},          -- hook name -> {fn,...} (called in registration order)
settings={},       -- 기능설정 rows: {key=, label=, opts={{label,value},...}, default=, onchange=fn|nil}
saveKeys={},       -- ko_settings.lua fields: {key=, default=}
titleMenu={},      -- title menu rows before 줄거리 보기: {label=, run=fn}
cityMenu={},       -- city 기능 menu rows before the hidden 효과음 row: {label=, run=fn}
warMenu={},        -- battle 기능 menu rows before Debug: {label=fn|string, enabled=fn|nil, run=fn}
personMenu={},     -- 무장 menu rows after 씨앗 사용: {label=, run=fn}
barButtons={},     -- wide top bar buttons after 위협's slot: {label=, show=fn|nil, run=fn}
carry={},          -- 事件 fields carried into the next cycle: {from=, to=}
needs={},          -- addon name -> the names its koNeeds(...) asked for (filled while loading)
}
function koOn(name,fn)
local t=koAddon.hooks[name]
if not t then t={} koAddon.hooks[name]=t end
t[#t+1]=fn
end
-- run every handler; the first non-nil result is returned (handlers after it still run)
function koHook(name,...)
local t=koAddon.hooks[name]
if not t then return nil end
local r=nil
for _,fn in ipairs(t) do
local v=fn(...)
if v~=nil and r==nil then r=v end
end
return r
end
function koHas(name)
return koAddon.loaded[name]==true
end
-- addon file head: if not koNeeds("record","tourney") then return end
function koNeeds(...)
if koAddon.current then koAddon.needs[koAddon.current]={...} end-- remembered for the 확장 screen (cascade on/off)
for _,n in ipairs({...}) do
if not koAddon.loaded[n] then
lib.Debug("addon: "..tostring(koAddon.current).." needs "..n.." (not loaded)")
local h=io.open(CONFIG.CurrentPath.."error.txt","a")-- the player can see why a feature is missing
if h then h:write(os.date().."  addon "..tostring(koAddon.current).." needs "..n.." (not loaded)\n") h:close() end
return false
end
end
return true
end
function koAddonLog(s)
lib.Debug("addon: "..tostring(s))
end
function koAddonLoad()
if CONFIG.koCamp then--ko 6.0 campaigns: the story's own table (koCamp, camp.lua) comes before every addon
local okC,errC=pcall(dofile,CONFIG.koCampScript.."camp.lua")
if not okC then koAddonLog("camp.lua failed: "..tostring(errC)) local h=io.open(CONFIG.CurrentPath.."error.txt","a") if h then h:write(os.date().."  camp.lua failed: "..tostring(errC).."\n") h:close() end end
end
local KC=rawget(_G,"koCamp")
if KC and CC.LieZhuanPid then for k in pairs(CC.LieZhuanPid) do if k<=382 then CC.LieZhuanPid[k]=nil end end end--ko 6.0 stories: base-story bios by number (383+ are the same people everywhere)
local ok,list=pcall(dofile,CONFIG.ScriptPath.."addon/addons.lua")
if not ok or type(list)~="table" then koAddonLog("addons.lua missing or broken: "..tostring(list)) return end
koAddon.list=list
for _,row in ipairs(list) do
local name,on=row[1],row[2]
if on and KC and KC.off and KC.off[name] then on=false end--ko 6.0 campaigns: Liu Bei story addons stay off
if on then
koAddon.current=name
local ok2,err=pcall(dofile,CONFIG.ScriptPath.."addon/"..name..".lua")
if ok2 then koAddon.loaded[name]=true koAddonLog(name.." loaded")
else
koAddonLog(name.." failed: "..tostring(err))
local h=io.open(CONFIG.CurrentPath.."error.txt","a")-- an addon that fails to load is worth knowing about
if h then h:write(os.date().."  addon "..name.." failed: "..tostring(err).."\n") h:close() end
end
koAddon.current=nil
end
end
for _,name in ipairs((KC and KC.addons) or {}) do--ko 6.0 campaigns: the story's own addons, from script/camp/<id>/, last
koAddon.current=name
local ok2,err=pcall(dofile,CONFIG.koCampScript..name..".lua")
if ok2 then koAddon.loaded[name]=true koAddonLog(name.." loaded")
else
koAddonLog(name.." failed: "..tostring(err))
local h=io.open(CONFIG.CurrentPath.."error.txt","a")
if h then h:write(os.date().."  addon "..name.." failed: "..tostring(err).."\n") h:close() end
end
koAddon.current=nil
end
-- registry defaults come before ko_settings.lua is read
for _,s in ipairs(koAddon.settings) do if s.key and CC[s.key]==nil then CC[s.key]=s.default end end
for _,s in ipairs(koAddon.saveKeys) do if CC[s.key]==nil then CC[s.key]=s.default end end
koExtRegister()-- the 확장 row comes last
koHook("loaded")
end
-- the extra lines koSave writes (each addon's settings rows and saveKeys). Strings are quoted (%q) so a text value
-- such as the 자유 전투 record survives the round trip through ko_settings.lua
function koAddonSaveLines()
local s=""
local seen={}
local function val(r)
local v=CC[r.key]
if v==nil then v=r.default end
if type(v)=="string" then return string.format("%q",v) end
return tostring(v)
end
for _,r in ipairs(koAddon.settings) do
if r.key and not seen[r.key] then seen[r.key]=true s=s.."CC."..r.key.."="..val(r).."\010" end
end
for _,r in ipairs(koAddon.saveKeys) do
if not seen[r.key] then seen[r.key]=true s=s.."CC."..r.key.."="..val(r).."\010" end
end
return s
end

-- ---- shared screen helpers (moved out of the 3.0 tourney module: record, free and tourney use them)
-- one screen: draw(hov) paints it, btns = {{x=,y=,w=,h=,s=label},...}; returns the button index (Enter/Space = 1,
-- Esc / right click = 0)
function koTourWait(draw,btns,overlay)
koMouseReset()
local hov=0
while true do
JY.ReFreshTime=lib.GetTime()
draw(hov)
for i,b in ipairs(btns) do
local on=(hov==i) or b.sel-- b.sel: shown as the selected tab; b.plain: an invisible hot area (hover frame only)
if b.hide then-- not shown, not clickable
elseif b.draw then b.draw(b,on,hov==i)
elseif b.plain then
if hov==i then-- 3.6 later: an outline only (DrawBox shaded the text under it grey)
local x1,y1,x2,y2=b.x-2,b.y-2,b.x+b.w+2,b.y+b.h+2
lib.DrawRect(x1,y1,x2,y1,M_White) lib.DrawRect(x1,y2,x2,y2,M_White) lib.DrawRect(x1,y1,x1,y2,M_White) lib.DrawRect(x2,y1,x2,y2,M_White)
lib.DrawRect(x1+1,y1+1,x2-1,y1+1,C_Name) lib.DrawRect(x1+1,y2-1,x2-1,y2-1,C_Name) lib.DrawRect(x1+1,y1+1,x1+1,y2-1,C_Name) lib.DrawRect(x2-1,y1+1,x2-1,y2-1,C_Name)
end
else
lib.Background(b.x,b.y,b.x+b.w,b.y+b.h,112,M_Black)
lib.DrawRect(b.x,b.y,b.x+b.w,b.y,on and M_White or M_Gray)
lib.DrawRect(b.x,b.y+b.h,b.x+b.w,b.y+b.h,on and M_White or M_Gray)
lib.DrawRect(b.x,b.y,b.x,b.y+b.h,on and M_White or M_Gray)
lib.DrawRect(b.x+b.w,b.y,b.x+b.w,b.y+b.h,on and M_White or M_Gray)
DrawString(b.x+b.w/2-#b.s*4,b.y+(b.h-16)/2,b.s,on and C_Name or M_White,16)
end
end
if overlay then overlay(hov) end
ShowScreen()
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then koExit() end
if e==1 then
if k==27 then return 0 end
if k==13 or k==32 then PlayWavE(0) return 1 end
end
if MOUSE.ESC() then return 0 end
hov=0
for i,b in ipairs(btns) do
if (not b.hide) and MOUSE.CLICK(b.x,b.y,b.x+b.w,b.y+b.h) then PlayWavE(0) return i end
if MOUSE.IN(b.x,b.y,b.x+b.w,b.y+b.h) then hov=i end
end
end
end
-- 3.6 later: pixel backgrounds (ui.grp 266 tourney, 267 free, 268 record, 269 wolyong, 270 battle log panel; drawn by
-- dev/title logo/dot-bg ps1, already dimmed so no Background pass). pic = the entry; none = 266. Shown in the city too.
function koTourBack(pic)
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
lib.PicLoadCache(4,(pic or 266)*2,ox,oy,1)
koBrightText=true
end
-- 3.6 later: grey text is hard to read over the pixel backgrounds. From koTourBack (or koBrightText=true) up to the next
-- ShowScreen, DrawString draws the greys lighter
koBrightText=false
local KO_BRIGHT={[M_Gray]=RGB(210,210,210),[M_DimGray]=RGB(180,180,180),[M_Silver]=RGB(234,234,234)}
local koRawDrawString=DrawString
function DrawString(x,y,s,color,size,...)
if koBrightText and color and KO_BRIGHT[color] then color=KO_BRIGHT[color] end
return koRawDrawString(x,y,s,color,size,...)
end
local koRawShowScreen=ShowScreen
function ShowScreen(...)
koBrightText=false
return koRawShowScreen(...)
end
function koTourBackOld()
-- the title art with its lettering painted out (ui.grp entry 265, made by 도구/타이틀_글자지우기.ps1 + grpadd.pl); in the city a plain panel
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
if JY.Status~=GAME_START then return end
lib.PicLoadCache(4,265*2,ox,oy,1)
-- lib.Background alpha = how much of the picture stays (128 = half); 200 turned out to be a no-op
lib.Background(0,0,CC.ScreenW,CC.ScreenH,100,M_Black)
end
function koTourney(T)
koTourneySub(T,false)
Dark()-- the title loop redraws the art and fades in
end
-- 무장 메뉴 > 무술 대회: one of my generals against seven from the roster; 참가비 500, 우승 상금 3000. Wins (事件1971) and
-- semifinal entries (事件1972) gate 여포·호적·목인·진평 in the tavern
koTourFee=500
koTourPrize=5000--ko 5.0: 3000 -> 5000 (player feedback; still once per story battle won)
function koTourneyCity(T)
koTourneySub(T,true)
DrawSMap()
if JY.Dark then Light() end
end
function koTourneySub(T,ingame)
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
local cx=ox+384
local NAME="\208\213\195\251"-- 姓名
local WL="\206\228\193\166"-- 武力
local function ctext(y,s,color,size)
size=size or 16
DrawString(cx-#s*size/4,y,s,color,size)
end
-- entry screen
local wins=CC.koTourWin or 0
local streak=CC.koTourStreak or 0
local last=CC.koTourLast or 0
if ingame then wins=koRec(1971) streak=koRec(1972) end-- in the city: 우승 / 4강 진출 from the save
local lastname="\130\097\130\077"-- 없음
if last>0 and last<JY.PersonNum and JY.Person[last] then lastname=JY.Person[last][NAME] end
local btns={
{x=cx-270,y=oy+330,w=160,h=28,s="\129\073\131\097 \131\100\130\106\131\071"},-- 무장 고르기
{x=cx-80,y=oy+330,w=160,h=28,s="\129\073\129\074\130\110 \129\073\131\097",hide=ingame},-- 무작위 무장 (title only)
{x=cx+110,y=oy+330,w=160,h=28,s="\137\066\129\110\129\094\131\071"},-- 돌아가기
}
local function intro(hov)
koTourBack()
ctext(oy+96,"\129\073\131\072 \130\095\130\125",C_Name,32)-- 무술 대회
ctext(oy+164,"\129\073\131\097 \129\098\144\106\129\071 \132\125\131\094\130\098 \137\083\129\072\137\113\141\074",M_White)-- 무장 여덟이 겨루는 토너먼트
ctext(oy+190,"\131\111 \130\087 \129\071\132\125 \131\079\129\116\129\097\131\111\129\090",M_White)-- 세 번 이겨 우승하세요
if ingame then
ctext(oy+250,"\131\079\129\116 "..wins.."\130\125   4\130\073 \129\103\133\098 "..streak.."\130\125",M_Silver)-- 우승 N회  4강 진출 N회
ctext(oy+276,"\134\126\129\094\130\080 "..koTourFee.."\131\103   \131\079\129\116 \129\067\131\103 "..koTourPrize.."\131\103",M_Silver)-- 참가비 N금  우승 상금 N금
else
ctext(oy+250,"\131\079\129\116 "..wins.."\130\125   \133\066\129\116 "..streak.."   \136\122\134\090 \131\079\129\116 "..lastname,M_Silver)-- 우승 N회 연승 N 최근 우승 X
end
end
local r=koTourWait(intro,btns)
if r==0 or r==3 or (ingame and r==2) then return end
local me=0
if ingame then
if koGold()<koTourFee then WarDrawStrBoxConfirm("\131\103\129\071 \130\090\133\120\140\101\129\076\129\077",M_White,true) return end-- 금이 모자랍니다
local mine={}
for i=1,JY.PersonNum-1 do if JY.Person[i]["\190\253\214\247"]==1 then mine[#mine+1]=i end end
if #mine==0 then WarDrawStrBoxConfirm("\131\095\131\115\137\077 \129\073\131\097\129\071 \130\097\129\075\129\076\129\077",M_White,true) return end-- 내보낼 무장이 없습니다
me=FightSelectMenu(mine)
if me==0 then return end
koSetGold(koGold()-koTourFee)
elseif r==1 then
me=FightSelectMenu(T)
if me==0 then return end
else
me=T[math.random(#T)]
end
-- the field: me + 7 others, shuffled into the bracket
local pool={}
for _,v in pairs(T) do if v~=me and JY.Person[v]["\190\253\214\247"]~=1 then pool[#pool+1]=v end end-- never my own generals
local P={}
for i=1,7 do P[i]=table.remove(pool,math.random(#pool)) end
P[8]=me
for i=8,2,-1 do local j=math.random(i) P[i],P[j]=P[j],P[i] end
-- R[1]=8 entrants, R[2]=4, R[3]=2, R[4]={champion}; lost[id]=true once beaten
local R={P,{},{},{}}
local lost={}
local msg=""
local sub=""
local function bracket(hov)
koTourBack()
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
local go={{x=cx-90,y=oy+436,w=180,h=26,s=""}}
local function pause(label)
go[1].s=label
if JY.Dark then bracket(0) Light() end
koTourWait(bracket,go)
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
pause(NEXT)
local s={0,1,2,4,6}
local res=fight(a,b,s[math.random(5)])
local w=(res==1) and a or b
R[rd+1][(mine+1)/2]=w
lost[(w==a) and b or a]=true
if w==me then
if rd==1 and ingame then koRecAdd(1972) end-- 4강 진출
if rd==3 then
if ingame then
koRecAdd(1971)
koSetGold(koGold()+koTourPrize) koRecGold(koTourPrize)
msg=JY.Person[me][NAME].." \131\079\129\116  \131\079\129\116 \129\067\131\103 "..koTourPrize.."\131\103"-- X 우승  우승 상금 N금
sub=""
else
CC.koTourWin=wins+1
CC.koTourStreak=streak+1
CC.koTourLast=me
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
pause(CONT)
end
end
if not alive then
msg="\131\079\129\116\133\120  "..JY.Person[R[4][1]][NAME]-- 우승자 X
sub=""
pause(CONT)
end
end


-- ---- name sort key in 가나다 order (the hz codes map to unicode through hzmb.dat; cached in CC.koHzU / CC.koNK). Used by the 출진 화면 and the 도감
function koNameKey(nm)
CC.koNK=CC.koNK or {}
local k=CC.koNK[nm]
if k then return k end
if CC.koHzU==nil then
CC.koHzU={}
local h=io.open(CONFIG.CurrentPath.."hzmb.dat","rb")
if h then
local d=h:read("*a") h:close()
for i=1,#d-5,6 do
local key=string.byte(d,i)*256+string.byte(d,i+1)
if CC.koHzU[key]==nil then CC.koHzU[key]=string.byte(d,i+4)+string.byte(d,i+5)*256 end
end
end
end
k=""
local i=1
while i<=#nm do
local a=string.byte(nm,i)
if a>=128 and i<#nm then
k=k..string.format("%05d",CC.koHzU[a*256+string.byte(nm,i+1)] or 0) i=i+2
else
k=k..string.format("%05d",a) i=i+1
end
end
CC.koNK[nm]=k
return k
end

-- the 기능설정 rows to show now: a row with show=fn is listed only while show() is true
-- ko 5.0 (koSetFold): rows folded into 확장 (on = these values, off = the addon is not there at all); not listed in
-- 기능설정 and fixed after ko_settings.lua is read, so an old file that had one off gets the value back
koSetFold={koAutoSave=1,koPreview=1,koThreat=1,koRangeMark=1,koFormation=1,koBattleSum=1}
function koSettingsFold() for k,v in pairs(koSetFold) do CC[k]=v end end
-- ko 5.0 (koSetOrder): page 2 in a fixed order (convenience rows, then 확장 · 설정 초기화 after a thin line: koSep / koGap)
koSetOrder={koDuelPick=1,koFight=2,koEntrance=3,koAITag=4,koSkipAI=5,koExpRate=6}
-- 11-06: option button width of a row: wider for the whole row when a word does not fit 36 (three letters)
function koSettingOptW(r) for _,o in ipairs(r.opts) do if #o[1]>4 then return 52 end end return 36 end
function koSettingRows()
local t={}
for i,r in ipairs(koAddon.settings) do if ((not r.show) or r.show()) and not (r.key and koSetFold[r.key]~=nil) then t[#t+1]=r r.koIdx=i end end
local function rank(r) if r.run then return 900+r.koIdx end return (r.key and koSetOrder[r.key] or 100)*10+r.koIdx/1000 end
table.sort(t,function(a,b) return rank(a)<rank(b) end)
local seen=false
for _,r in ipairs(t) do r.koSep=nil r.koGap=nil if r.run then if not seen then r.koSep=true seen=true end r.koGap=6 end end
return t
end
function koExtRegister()
-- title screen only (asked for: no mid-game toggling, and the screen then has one background to draw)
koAddon.settings[#koAddon.settings+1]={label="\129\105\131\097",opts={{"\130\065\131\071",1}},run=function() koExtScreen() end,show=function() return JY.Status==GAME_START end}-- 확장: 열기
end
dofile(CONFIG.CurrentPath.."script/addon/ext.lua")-- the 확장 screen (shared with the 순정 base)
