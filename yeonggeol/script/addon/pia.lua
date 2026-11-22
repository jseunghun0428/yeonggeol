-- ko 11-10 addon "pia": 피아 표시. 제보 「전투 지도에서 적군 아군 표시가 안 돼서 헷갈린다」(고유 조형이라 원작의 색 구분이 없음).
-- 유닛 발밑에 진영 색 타원 그림자를 깐다 (draw_overlay = 범위 표시 다음, 유닛 그리기 전이라 조형이 그 위에 선다).
--   하늘색 아군 · 회색 행동 끝난 아군 · 빨간색 적군 · 노란색 우군 (미니맵 색과 맞춤). 시안 4(발밑 타원), 사용자 「발밑 타원 괜찮다」.
-- 기능설정 「피아 표시」 켬/끔 (CC.koPiaMark, 처음 켬).
-- 빌드: 게임 폴더에서 perl 도구/free_hz.pl < 개발용/addon/pia_src.lua > script/addon/pia.lua
local CL={ally={90,200,255},foe={240,60,50},friend={245,215,60},done={150,150,150}}
local CACHE={}
local function cols(k)
local c=CACHE[k]
if not c then
local t=CL[k]
c={RGB(t[1],t[2],t[3]),RGB(math.floor(t[1]*0.55),math.floor(t[2]*0.55),math.floor(t[3]*0.55))}
CACHE[k]=c
end
return c[1],c[2]
end
local function kind(v)
if v.enemy then return "foe" elseif v.friend then return "friend" elseif not v.active then return "done" end
return "ally"
end
local function px(x,y,c) lib.FillColor(x,y,x+1,y+1,c) end
-- filled translucent ellipse with a darker 1-px rim
local function ellipse(cx,cy,rx,ry,k)
local fill,edge=cols(k)
local prev=nil
for dy=-ry,ry do
local h=math.floor(rx*math.sqrt(1-(dy/ry)^2)+0.5)
lib.Background(cx-h,cy+dy,cx+h,cy+dy+1,50,fill)
px(cx-h,cy+dy,edge) px(cx+h-1,cy+dy,edge)
if prev and math.abs(prev-h)>1 then
for x=math.min(prev,h),math.max(prev,h) do px(cx-x,cy+dy,edge) px(cx+x-1,cy+dy,edge) end
end
prev=h
end
local w=math.floor(rx*0.35)
lib.FillColor(cx-w,cy-ry,cx+w,cy-ry+1,edge)
lib.FillColor(cx-w,cy+ry,cx+w,cy+ry+1,edge)
end
koOn("draw_overlay",function(cx,cy)
if (CC.koPiaMark or 1)~=1 or JY.Status~=GAME_WMAP or not War or not War.Person then return end
local BW,BD=War.BoxWidth,War.BoxDepth
local rx,ry,oy=math.floor(BW*21/48+0.5),math.max(3,math.floor(BD*7/48+0.5)),math.floor(BD*7/48+0.5)
for _,v in pairs(War.Person) do
if v.live and (not v.hide) and between(v.x,War.CX,War.CX+War.MW-1) and between(v.y,War.CY,War.CY+War.MD-1) then
local l=cx+BW*(v.x-War.CX)
local b=cy+BD*(v.y-War.CY+1)
ellipse(l+math.floor(BW/2),b-oy,rx,ry,kind(v))
end
end
end)
koAddon.settings[#koAddon.settings+1]={key="koPiaMark",label="\137\088\129\110 \133\113\130\086",opts={{"\133\122",1},{"\133\117",0}},default=1}
