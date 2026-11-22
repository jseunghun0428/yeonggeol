-- ko 5.2.6 (10-20, 카페 건의 「세이브 칸이 부족하다」 → 사용자 「100칸으로」): 저장·불러오기 기록 100칸 (10칸씩 10쪽)
-- (UTF-8 원본: 개발용/addon/saveslots_src.lua -> 도구/free_hz.pl -> script/addon/saveslots.lua)
--
-- jymain 의 기록 목록 여섯 곳(전투·도시 메뉴의 불러오기/저장, 타이틀 불러오기, 전투 뒤 「지금 저장할까요?」)은 모두
-- ShowMenu(menu2,10|13,...,isBox 20) 으로 " 1. "~"10. " 줄(+ 불러오기는 A1~A3 자동 저장)을 보여 주고, 고른 번호 s2 를
-- 그대로 기록 칸 번호(CC.R_GRPFilename[s2])로 쓴다. 그래서 목록 아래에 쪽 줄을 하나 붙이고, 쪽을 넘기면 칸 1~10 의 파일 이름을
-- 그 쪽 파일(save0~save99.sav)로 바꿔 끼운다. 고른 뒤에도 그 쪽이 그대로 남아 SaveRecord/LoadRecord/WarSave 가 그 파일을 쓴다.
-- 기록 옆 파일(.blog 전투 기록, .wtg 되감기, .town 마을)은 다들 CC.R_GRPFilename[id] 의 이름에서 만들므로 저절로 따라간다.
-- 칸 번호 11~18(임시·자동·원정·되감기·마을·클리어)은 그대로. 메시지의 번호는 jymain koSlotNo(s2) (쪽 반영).
local PAGES=10
local NAME="\195\251\179\198"
CC.koSlotPage=CC.koSlotPage or 1
function koSlotMap(p)
p=limitX(math.floor(p or 1),1,PAGES)
CC.koSlotPage=p
for k=1,10 do CC.R_GRPFilename[k]=CONFIG.Save.."save"..((p-1)*10+k-1)..".sav" end
end
koSlotMap(CC.koSlotPage)
-- a save list from jymain: isBox 20, rows " 1. "…"10. " (10 rows, or 13 with A1~A3)
local function isSlotList(m,n,isBox)
if isBox~=20 or type(m)~="table" or (n~=10 and n~=13) then return false end
local a,b=m[1] and m[1][1],m[10] and m[10][1]
return type(a)=="string" and type(b)=="string" and string.sub(a,1,4)==" 1. " and string.sub(b,1,4)=="10. "
end
local function head(n)-- 4 bytes, as the callers cut the row at byte 5 to test for 빈 슬롯
if n<10 then return " "..n..". " elseif n<100 then return n..". " end
return n.."."
end
local function navText(p)
return "\161\251 \139\073 \139\074       "..p.." / "..PAGES.." \139\074       \129\077\130\077 \139\074 \161\250"
end
local raw=ShowMenu
function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)
if not isSlotList(menuItem,numItem,isBox) then
return raw(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)
end
local p=CC.koSlotPage or 1
while true do
koSlotMap(p)
for k=1,10 do
local id=k
menuItem[k][1]=head((p-1)*10+k)..(fileexist(CC.R_GRPFilename[id]) and GetRecordInfo(id) or "\133\105 \133\106\133\107")
end
local m={}
for k=1,numItem do m[k]=menuItem[k] end
m[numItem+1]={navText(p),nil,1}
-- the list one row longer: in the city frame keep it inside the 400-high frame, under the title box
local yy=y1
if (yy==0 or yy==-1) and (JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL) then
local h=16+24*(numItem+1)
yy=math.max(16+(400-h)/2,math.min(70,416-h))
end
if MOUSE then MOUSE.rx,MOUSE.ry=-1,-1 end-- a click inside this list leaves its x here; -1 = chosen by the keyboard
local r=raw(m,numItem+1,numShow,x1,yy,x2,y2,isBox,isEsc,size,color,selectColor)
if r~=numItem+1 then return r end
-- the 쪽 row: its left third goes back, the rest (and Enter from the keyboard) goes on; both wrap
local back=false
if MOUSE and MOUSE.rx and MOUSE.rx>=0 then
local w=420
local cx=nil
if x1 and x1>0 then cx=x1 end
if not cx then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then cx=koMapCenterX(w)
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then cx=16+(640-w)/2
else cx=(CC.ScreenW-w)/2 end
end
back=MOUSE.rx<cx+w/3
end
if back then p=p-1 else p=p+1 end
if p<1 then p=PAGES elseif p>PAGES then p=1 end
end
end
rawset(_G,"koSlotShowMenu",ShowMenu)-- 10-26: jymain koTitleMenu treats this wrapper as the real ShowMenu (else the title list falls back flat, 「다른 모드」 unfolded)
