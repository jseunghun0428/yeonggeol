-- ko 5.0: 경험치 배율 (기능설정 "\131\064\133\085\132\081": 50%~300% slider in 10% steps, ◀ ▶ for one step; player feedback "\130\082\130\123\129\071 \129\072\129\073 \142\087\129\117 \129\091\135\077\129\077", 200% asked later).
-- Every battle exp gain (attack, counter, 책략, item use) goes through WarAddExp; it is scaled here (at least 1 when there was
-- any). The MVP bonus, 출전 성장 and seeds are not battle exp and stay as they are. Loaded after free (which redefines
-- WarAddExp for the revived dolls), so this wraps the final one.
-- The base WarAddExp levels up once per call and only carries an overflow below 100, so a scaled gain is passed in pieces
-- that never take the bar past 199 (200%: a big gain now and then two level-ups, as it should).
-- Source: 개발용/addon/exprate_src.lua (UTF-8); script/addon/exprate.lua is made from it by 개발용/도구/free_hz.pl.
local oldAdd=WarAddExp
local EXP,LV="\190\173\209\233","\181\200\188\182"-- JY.Person fields 经验 / 等级
function WarAddExp(id,Exp,...)
local r=CC.koExpRate or 100
if r~=100 and type(Exp)=="number" and Exp>0 then Exp=math.max(1,math.floor(Exp*r/100+0.5)) end
local p=War.Person[id] and JY.Person[War.Person[id].id]
if not (p and type(Exp)=="number") then return oldAdd(id,Exp,...) end
local n=0
while Exp>0 and n<8 do
n=n+1
local take=math.min(Exp,math.max(1,199-(p[EXP] or 0)))
if p[LV]>=99 then take=Exp end
Exp=Exp-take
oldAdd(id,take,...)
if p[LV]>=99 then break end
end
end
-- the 기능설정 row: a slider, 50%~300% in 10% steps with a mark at 100% — jymain's shared koSlideDraw / koSlideClick (the same look as
-- 음악 · 효과음 on page 1), from the page-2 button column x+136 to the window's inner edge x+304 (jymain koRowDraw: row.draw / row.click)
local MIN,MAX,STEP=50,300,10
local function cur() local v=tonumber(CC.koExpRate) or 100 return limitX(math.floor(v/STEP+0.5)*STEP,MIN,MAX) end
koAddon.settings[#koAddon.settings+1]={key="koExpRate",label="\131\064\133\085\132\081",opts={},default=100,
draw=function(x,ry) local v=cur() koSlideDraw(x+136,x+304,ry,v,MIN,MAX,100,v.."%",v==100) end,
click=function(x,ry)
local v=cur() local nv=koSlideClick(x+136,x+304,ry,v,MIN,MAX,STEP)
if nv~=v or CC.koExpRate~=v then CC.koExpRate=nv return true end
return false
end}
