-- ---- 확장 (기능설정 > 확장 > 열기): turn addons on or off from inside the game. The screen edits the true/false in
-- script/addon/addons.lua (comments kept); a change applies on the next launch, the current session keeps running as is.
-- Turning one off also turns off the addons that need it, turning one on also turns on the ones it needs
koExtInfo={-- name -> {label, needs} for the shipped addons (an unknown file shows its name and whatever koNeeds recorded)
base={"\131\071\131\077 \129\105\131\097","\134\099\133\123 \134\099\137\104 \131\084\132\104 \138\072\131\126\141\074 \130\125\132\121 \133\125"},-- 기능 확장 (the 유광판 base; [2] here is its description, not needs)
fight={"\130\066\132\101 \131\097\129\065"},                                 -- 전투 장면
preview={"\130\066\132\101 \134\119\129\117\131\115\131\071"},               -- 전투 미리보기
threat={"\130\110\137\071 \130\109\130\110"},                                -- 위협 범위
range={"\129\071\130\108 \130\074\130\112 \130\109\130\110 \133\113\130\086"}, -- 이동 공격 범위 표시
hotkey={"\130\066\132\101 \134\077\129\099\137\074"},                        -- 전투 단축키
cost={"\138\072\131\126\141\074 \131\115\129\067"},                          -- 코스트 보상
inherit={"\130\125\132\121 \132\084\129\116 \133\109\133\110 \134\103"},     -- 회차 계승 선택 창
record={"\131\071\133\108 \129\068\135\078"},                                -- 기록 도감
tourney={"\129\073\131\072 \130\095\130\125",{"record"}},                    -- 무술 대회
gate={"\131\072\134\076 \129\118\129\119",{"tourney","record"}},             -- 술집 조건
drink={"\131\072\134\076 \133\066\130\066",{"record"}},               -- 술집 연전 (4.0 later)
free={"\133\120\130\071 \130\066\132\101",{"record","tourney"}},             -- 자유 전투
bzshop={"\130\126\129\084 \132\087\134\073"},                                -- 병종 교환 (3.6: the label was missing)
dojo={"\133\066\129\073\131\097"},                                -- 연무장 (5.2.5)
bzbook={"\130\126\129\084 \129\068\135\078",{"record"}},                     -- 병종 도감 (3.6)
battlelog={"\130\066\132\101 \131\071\133\108"},
rewind={"\129\112 \132\067\135\078\131\071"},
gearcmp={"\131\097\130\080 \130\080\132\087"},
freeplus={"\131\107\130\066 \135\122\135\108\131\080 \130\086\131\120",{"free"}},
saveio={"\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071"},-- 4.0 (Android only)
unique={"\131\100\130\071 \129\118\136\069"},-- 4.0 unique battle sprites
achieve={"\129\073\131\097 \130\066\131\076",{"record"}},                                   -- 전투 기록 (3.6)
}
-- ko 3.6 later: one line on what each addon does, shown under the list for the row the mouse is on (two-column layout)
koExtDesc={
base="\134\099\133\123\161\164\134\099\137\104\161\164\131\084\132\104\161\164\138\072\131\126\141\074\161\164\130\125\132\121 \133\125 \130\071\130\072\130\070\131\080 \131\071\132\118 \131\071\131\077",
fight="\130\074\130\112\129\088 \132\085 \133\073\131\071\137\083 \132\071\131\098 \130\066\132\101 \131\097\129\065 \133\066\133\098",
preview="\130\074\130\112\161\164\130\117\130\118 \130\066\129\102 \129\107\129\067 \137\088\129\066\161\164\130\088\130\101\161\164\129\067\131\123 \133\113\130\086",
threat="\131\076 \130\094\130\095\131\080 \130\074\130\112\129\071 \139\102\130\098 \130\109\130\110\130\104 \134\082\129\066\131\087 \133\113\130\086",
range="\129\071\130\108\161\164\130\074\130\112\129\088 \129\113 \132\079\130\098 \135\066\129\083 \140\089 \129\067\133\120\132\083 \133\113\130\086",
hotkey="Enter\161\164Tab\161\164A\161\164E\161\164F\161\164V\161\164L \133\125 \130\066\132\101 \134\077\129\099\137\074",
cost="\133\098\129\103 \138\072\131\126\141\074 \129\100\129\111\129\123 \138\072\131\126\141\074 \131\115\129\067",
inherit="\129\077\130\077 \130\125\132\121\132\083 \132\124\134\114 \135\103\131\099\129\083 \131\100\130\106\130\098 \134\103",
record="\132\119\132\084\161\164\130\125\132\121 \129\071\131\125\161\164\129\073\131\097 \130\066\131\076\161\164\129\073\131\097 \129\068\135\078",
tourney="\129\073\131\097 \129\098\144\106\129\071 \132\125\131\094\130\098 \133\073\131\071\137\083 \137\083\129\072\137\113\141\074",
gate="\133\073\130\094 \131\072\134\076 \129\073\131\097\129\083 \129\073\131\072 \130\095\130\125 \131\123\131\076\131\109\132\083 \129\066\131\103",
drink="\130\095\133\113 \129\073\131\097\129\071 \131\072\134\076 \135\089\138\105\131\082\129\123 \132\121\139\126\132\083 \130\075\132\088\129\083 \132\125\131\094\130\098 \133\066\130\066",
free="\131\081\129\097\130\098 \130\066\131\097\161\164\130\082\130\123\161\164\132\075\131\123\131\109\132\083 \137\106\131\079\130\098 \133\120\130\071 \130\066\132\101",
bzshop="\131\103\129\083 \131\095\131\100 \130\094\129\097\131\080 \130\126\129\084\129\083 \131\085\139\100",
dojo="\131\103\129\083 \131\095\131\100 \135\068\139\110\129\103 \129\073\131\097\131\080 \130\082\130\123\129\083 \129\094\131\097 \137\069\131\098 \129\073\131\097(\132\071\129\081~-5, \131\100\130\104 \129\113 \132\079\130\077)\129\089\130\067 \131\105\130\079",
bzbook="\130\126\129\084\138\090 \131\077\131\125\161\164\130\074\130\112 \130\109\130\110\161\164\129\067\131\123\129\083 \131\115\130\098 \129\068\135\078",
battlelog="\130\066\132\101\131\080 \130\074\130\112\161\164\130\117\130\118 \134\064\129\123\130\104 \133\103\131\071\130\098 \131\071\133\108 \134\103",
rewind="\129\110\130\084 \129\112 \139\110\130\077 \129\067\130\124\132\083 \132\067\137\066\130\079 (\131\071\131\077 \132\123\161\164R \137\074)",
gearcmp="\129\068\130\119\130\104 \132\124\134\114 \132\085 \131\097\130\080\161\164\131\077\131\125\161\164\129\120\131\071 \130\116\129\064\130\104 \134\119\129\117 \137\119",
freeplus="\131\107\130\066 \134\068 \130\066\132\101 \138\101\129\123 \135\122\135\108\131\080 \130\086\131\120(8\129\103 \129\068\130\066\161\164\131\115\129\067)",
saveio="\130\111\133\119\132\083\129\071\133\119\130\070 \130\066\132\111: \133\102\131\097 \134\086\133\073 zip \131\095\131\115\131\095\131\071\161\164\129\094\136\107\129\091\131\071",
unique="\131\097\129\113\132\075\134\076\161\164\131\078\129\073\131\097\131\109\132\083 \131\091\130\079\129\083 \134\112\131\098 \131\097\129\113\130\098 \130\126\129\084\161\164\132\075\129\102 \129\067\129\101\130\097\129\071 \133\120\131\071\132\086\131\080 \130\066\132\101\161\164\129\068\130\086 \129\118\136\069\131\109\132\083 \131\118\134\091\129\077 \129\095\132\090\134\069\130\098 \131\081\134\071 \129\118\136\069",
achieve="\129\073\131\097 \130\066\131\076\161\164\133\088\135\101 \137\083\137\114 \133\125\134\080",
}
-- Shared by both bases: script/jymain.lua loads it through _core.lua, script/origin/jymain.lua (순정 mode: every addon
-- off, picked by config.lua) loads it directly and puts "확장" on its title menu. So only what both have is used here.
function koExtListPath()
return CONFIG.CurrentPath.."script/addon/addons.lua"
end
if not rawget(_G,"koAddon") then koAddon={loaded={},needs={},settings={}} end-- 순정 mode: nothing is loaded
-- 순정 mode has no koTourWait: the same loop as _core.lua's, minus the title art (its ui.grp has no entry 265)
if not rawget(_G,"koTourWait") then
function koTourWait(draw,btns)
koMouseReset()
local hov=0
while true do
JY.ReFreshTime=lib.GetTime()
draw(hov)
for i,b in ipairs(btns) do
local on=(hov==i) or b.sel
if b.hide then
elseif b.plain then
if hov==i then DrawBox(b.x-2,b.y-2,b.x+b.w+2,b.y+b.h+2,M_White) end
else
lib.Background(b.x,b.y,b.x+b.w,b.y+b.h,112,M_Black)
lib.DrawRect(b.x,b.y,b.x+b.w,b.y,on and M_White or M_Gray)
lib.DrawRect(b.x,b.y+b.h,b.x+b.w,b.y+b.h,on and M_White or M_Gray)
lib.DrawRect(b.x,b.y,b.x,b.y+b.h,on and M_White or M_Gray)
lib.DrawRect(b.x+b.w,b.y,b.x+b.w,b.y+b.h,on and M_White or M_Gray)
DrawString(b.x+b.w/2-#b.s*4,b.y+(b.h-16)/2,b.s,on and C_Name or M_White,16)
end
end
ShowScreen()
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then if rawget(_G,"koExit") then koExit() else os.exit() end end
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
end
function koExtBack()
if rawget(_G,"koTourBack") then koTourBack(265) return end
-- 순정 mode: the plain title art (ui.grp 264), dimmed
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
lib.PicLoadCache(4,264*2,ox,oy,1)
lib.Background(0,0,CC.ScreenW,CC.ScreenH,100,M_Black)
end
-- what name needs: its listed needs plus "base" (every addon runs on the 유광판 base; base itself needs nothing)
function koExtNeeds(name)
if name=="base" then return {} end
local t={}
local src=(koExtInfo[name] and koExtInfo[name][2]) or koAddon.needs[name] or {}
for _,n in ipairs(src) do t[#t+1]=n end
t[#t+1]="base"
return t
end
-- rewrite the true/false of each listed addon in addons.lua, everything else in the file untouched
function koExtSave(rows)
local path=koExtListPath()
local h=io.open(path,"r")
if not h then return false end
local s=h:read("*a") h:close()
for _,r in ipairs(rows) do
local n=0
s,n=string.gsub(s,'(%{%s*"'..r.name..'"%s*,%s*)%a+',"%1"..tostring(r.on))
if n==0 then s=string.gsub(s,"\n%}%s*$",'\n{"'..r.name..'",'..tostring(r.on)..'},\n}') end-- a row the file lost: append it
end
h=io.open(path,"w")
if not h then return false end
h:write(s) h:close()
return true
end
-- ko 4.0: the screen in the look of the 기능설정 box (user request): the box picture ui.grp 80 (320x128; 8px border,
-- inside a pattern repeating every 16 across and 32 down) tiled out to w x h, its own 확인 button (x 254..306,
-- y 92..116 of the picture; ui.grp 56 = pressed), and the settings window's bevelled option buttons
function koExtBox(x,y,w,h)
local P=80*2
local function part(dx,dy,dw,dh,sx,sy)-- source (sx,sy) of the picture at (dx,dy), clipped to dw x dh
lib.SetClip(dx,dy,dx+dw,dy+dh)
lib.PicLoadCache(4,P,dx-sx,dy-sy,1)
end
for ty=y+8,y+h-9,64 do
for tx=x+8,x+w-9,256 do part(tx,ty,math.min(256,x+w-8-tx),math.min(64,y+h-8-ty),8,8) end
end
for tx=x+8,x+w-9,256 do
local tw=math.min(256,x+w-8-tx)
part(tx,y,tw,8,8,0) part(tx,y+h-8,tw,8,8,120)
end
for ty=y+8,y+h-9,64 do
local th=math.min(64,y+h-8-ty)
part(x,ty,8,th,0,8) part(x+w-8,ty,8,th,312,8)
end
part(x,y,8,8,0,0) part(x+w-8,y,8,8,312,0) part(x,y+h-8,8,8,0,120) part(x+w-8,y+h-8,8,8,312,120)
lib.SetClip(0,0,0,0)
end
-- the settings window's option button: sel = pressed in (dark, white word), else raised (silver word); hot = mouse on it
function koExtBevel(b,sel,hot)
local x1,y1,x2,y2=b.x,b.y,b.x+b.w,b.y+b.h
local lt,rb=M_Gray,M_Black
if sel then lt,rb=M_Black,M_Gray end
lib.Background(x1+1,y1+1,x2,y2,sel and 128 or 192,M_Black)
lib.DrawRect(x1,y1,x2,y1,lt) lib.DrawRect(x1,y1,x1,y2,lt)
lib.DrawRect(x1,y2,x2,y2,rb) lib.DrawRect(x2,y1,x2,y2,rb)
DrawString(x1+b.w/2-#b.s*4,y1+math.floor((b.h-16)/2)+1,b.s,hot and C_Name or (sel and M_White or M_Silver),16)
end
-- koTourWait with those buttons (b.ok = the picture's 확인, drawn pushed while held)
function koExtWait(draw,btns)
koMouseReset()
local hov=0
while true do
JY.ReFreshTime=lib.GetTime()
draw(hov)
for i,b in ipairs(btns) do
if b.hide then
elseif b.ok then
lib.SetClip(b.x,b.y,b.x+52,b.y+24)
lib.PicLoadCache(4,80*2,b.x-254,b.y-92,1)
lib.SetClip(0,0,0,0)
if MOUSE.HOLD(b.x+1,b.y+1,b.x+51,b.y+23) then lib.PicLoadCache(4,56*2,b.x,b.y,1) end
else
koExtBevel(b,b.sel,hov==i)
end
end
ShowScreen()
local e,k=koPollKey()
if e==0 or MOUSE.EXIT() then if rawget(_G,"koExit") then koExit() else os.exit() end end
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
-- ko 5.0 (koExtAll): one switch for every addon instead of a 켬/끔 pair per row (user: "too complicated").
-- 켬 = every row of addons.lua true, 끔 = every row false (the original game); a mixed file shows neither pressed
function koExtScreen()
local rows={}
local ok,list=pcall(dofile,koExtListPath())-- the file as it is now (in 순정 mode nothing loaded it)
if not ok or type(list)~="table" then list={} end
for i,row in ipairs(list) do rows[i]={name=row[1],on=row[2] and true or false} end
local function state()
local n=0
for _,r in ipairs(rows) do if r.on then n=n+1 end end
if n==#rows then return true elseif n==0 then return false end
return nil
end
local W,H=520,236
local ox,oy=math.floor((CC.ScreenW-W)/2),math.floor((CC.ScreenH-H)/2)
local btns={{x=ox+W-66,y=oy+H-36,w=52,h=24,s="\129\105\129\106",ok=true}}-- index 1 = Enter/Space
btns[2]={x=ox+W/2-124,y=oy+132,w=112,h=26,s="\133\122",all=true}
btns[3]={x=ox+W/2+12,y=oy+132,w=112,h=26,s="\133\117",all=false}
local saved=true
local function pending()
local KC=rawget(_G,"koCamp")-- 6.0 stories: the addons a story switches off (koCamp.off) are not "pending"
for _,r in ipairs(rows) do if r.on~=(koAddon.loaded[r.name]==true) and not (KC and KC.off and KC.off[r.name]) then return true end end
return false
end
local function draw(hov)
koExtBack()
koExtBox(ox,oy,W,H)
DrawString(ox+16,oy+16,"\129\105\131\097",C_Name,16)
DrawString(ox+16,oy+48,"\130\071\130\072\130\070\129\102\131\087 \132\108\129\111 \131\071\131\077\129\083 \129\111\140\077\130\087\129\102 \137\097\134\069\131\118 \136\110 \129\113 \132\079\129\075\129\076\129\077.",M_White,16)
DrawString(ox+16,oy+68,"(\134\119\129\117\131\115\131\071\161\164\129\103\136\069\161\164\133\088\129\083\161\164\130\075\135\070\161\164\131\071\133\108\161\164\129\073\131\072 \130\095\130\125 \133\125)",M_Silver,16)
DrawString(ox+16,oy+88,"\136\097\129\065 \132\065\129\070(\131\081\129\074) \129\126\130\064\130\066\131\109\132\083 \129\078\130\093\140\106\129\076\129\077.",M_White,16)
local st=state()
btns[2].sel=(st==true) btns[3].sel=(st==false)
if st==nil then DrawString(ox+16,oy+170,"\130\067\131\103\131\098 \133\073\130\094\132\086 \137\097\136\107 \132\079\129\075\129\076\129\077.",M_Gray,16) end
if CONFIG.koPure then DrawString(ox+16,oy+170,"\130\067\131\103\131\098 \132\065\129\070(\131\081\129\074) \130\090\133\119\132\083 \129\078\130\093 \130\101\129\104\129\076\129\077.",M_Cyan,16) end
if not saved then DrawString(ox+16,oy+190,"addons.lua \130\104 \133\102\131\097\129\097\130\067 \136\102\129\080\129\075\129\076\129\077.",M_Red,16)
elseif pending() then DrawString(ox+16,oy+H-34,"\129\077\130\086 \130\086\129\074\129\097\129\065 \131\076\132\111\140\106\129\076\129\077.",M_Yellow,16) end
end
while true do
local r=koExtWait(draw,btns)
if r<=1 then
if saved and pending() and WarDrawStrBoxYesNo("\130\067\131\103 \129\077\130\086 \130\086\129\074\129\088\129\089\129\090?",M_White,true) then koRestart(draw) end
break
end
local b=btns[r]
if b.all~=nil then
for _,x in ipairs(rows) do x.on=b.all end
saved=koExtSave(rows)
end
end
koMouseReset()
end
-- restart the game: ko_sdl.dll starts a fresh copy when it sees ko_restart.txt (checked once per frame), then this one
-- exits. Without the dll (scale off) fall back to a shell "start" of the exe
function koRestart(draw)
if not CONFIG.Windows then koExit() end-- android: nothing can relaunch the app; quit and let the player reopen it
local path=CONFIG.CurrentPath.."ko_restart.txt"
-- launcher build (engine is "... \186\187\195\188.exe"): ko_sdl.dll's restart would start the engine directly, without
-- the launcher's SDL_DYNAMIC_API, so the new copy loses ko_sdl. Leave ko_restart.txt alone and start the launcher below
local launcher=io.open(CONFIG.CurrentPath.."\191\181\176\201\192\252\186\185\176\162\032\192\175\177\164\198\199\032\186\187\195\188\046\101\120\101","rb")
if launcher then launcher:close() else
local h=io.open(path,"w")
if h then h:write("1") h:close() end
end
for i=1,12 do
JY.ReFreshTime=lib.GetTime()
if draw then draw(0) end
ShowScreen()
lib.GetKey(1)
lib.Delay(30)
end
local left=io.open(path,"r")
if launcher or left then
if left then left:close() os.remove(path) end
-- 영걸전복각 유광판.exe (CP949 bytes: the shell wants the system code page)
local exe="\191\181\176\201\192\252\186\185\176\162\032\192\175\177\164\198\199\046\101\120\101"
pcall(os.execute,'start "" /D "'..string.sub(CONFIG.CurrentPath,1,-2)..'" "'..exe..'"')
end
if rawget(_G,"koExit") then koExit() else os.exit() end
end
