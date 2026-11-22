-- ---- ko 3.1 addon "range": 이동·공격 범위 표시 (조조전식). Instead of darkening everything outside the range,
-- the cells themselves are tinted: own unit picked to move = purple boxes; enemy clicked = khaki
-- boxes; both with the attack range from the standing spot as red boxes on top (3.3); any target picking (공격, 책략, 도구, 아군 대상) = red boxes. The base calls koHook("draw_range_cell",x,y,px,py) for every visible cell before its
-- own darkening; a non-nil result skips that. threat.lua draws the 전체 위협 in the same boxes (koRangeBoxAt).
-- 기능설정 row 범위 표시: 색 / 원작 (CC.koRangeMark 1/0; 0 = the old darkening).
local function RGBc(r,g,b) return RGB(r,g,b) end
local C_MOVE,C_EMOVE,C_ATK=RGBc(130,60,255),RGBc(220,205,120),M_Red-- own move purple, enemy move khaki, every target pick (attack, magic, item) red

function koRangeOn()
return (CC.koRangeMark or 1)==1
end

-- Layer 4 is "1 everywhere" after CleanWarMap(4,1) (= no range shown) and the game keeps drawing a frame or two in
-- that state before ControlStatus changes (BoxBack after a right-click in WarSelectAtk, message boxes...): remember
-- the last CleanWarMap(4,v) so those frames paint nothing. War_CalMoveStep / WarSetAtkFW start with CleanWarMap(4,0).
do
local raw=CleanWarMap
CleanWarMap=function(lv,v)
if lv==4 then War.koRangeCleared=(v~=0) end
return raw(lv,v)
end
end

-- what the layer-4 range on the map means right now (nil = nothing to paint)
local function koRangeKind()
if War.koRangeCleared or War.koAI or (JY.koInTalk or 0)>0 or not War.ControlEnable then return nil end
local st=War.ControlStatus
if st=="selectAtk" then return "atk" end-- 공격·책략·도구·아군 대상 모두 빨강 (사용자 지정)
local sel=War.SelID or 0
if (st=="move" or st=="select") and sel>0 then
local v=War.Person[sel]
if not v or GetWarMap(v.x,v.y,4)<=1 then return nil end-- a unit's own cell holds movestep+1 while its move range is on the map
if v.enemy then return "emove" end
return "move"
end
return nil
end

local function koRangeBox(px,py,color)
local W,H=War.BoxWidth,War.BoxDepth
lib.Background(px+1,py+1,px+W-1,py+H-1,112,color)
lib.DrawRect(px,py,px+W-1,py+H-1,color)
lib.DrawRect(px+1,py+1,px+W-2,py+H-2,color)
end
-- for other addons (threat.lua): kind = "move" / "emove" / "atk"
function koRangeBoxAt(px,py,kind)
koRangeBox(px,py,(kind=="emove") and C_EMOVE or (kind=="move") and C_MOVE or C_ATK)
end

-- 3.3: the standing-spot attack range, 조조전식 glowing red frame (dark red rim, bright red, orange inner line);
-- the cell keeps whatever is under it (move box or plain terrain).
local C_A1,C_A2,C_A3=RGBc(150,0,0),RGBc(235,40,10),RGBc(255,150,60)
function koAtkFrame(px,py)
local W,H=War.BoxWidth,War.BoxDepth
lib.DrawRect(px,py,px+W-1,py+H-1,C_A1)
lib.DrawRect(px+1,py+1,px+W-2,py+H-2,C_A2)
lib.DrawRect(px+2,py+2,px+W-3,py+H-3,C_A2)
lib.DrawRect(px+3,py+3,px+W-4,py+H-4,C_A3)
end

koOn("draw_range_cell",function(x,y,px,py)
if not koRangeOn() then return nil end
local k=koRangeKind()
if k==nil then return true end-- with the boxes on, the map is never darkened (not while a unit walks its path either)
-- 3.3: the base's attack range from the standing spot (War_CalAtkFW, layer 10 = 1) is drawn as red boxes on top of
-- the move boxes (조조전식, own and enemy units alike). It is moved to 3, which the base does not paint (1 = pic 261,
-- 2 = pic 262); CleanWarMap(10,0) still clears it.
local atk=false
if k=="move" or k=="emove" then
local l10=GetWarMap(x,y,10)
if l10==1 then SetWarMap(x,y,10,3) l10=3 end
atk=(l10==3)
end
local v=War.Person[War.SelID]
local own=(k~="atk") and v and x==v.x and y==v.y-- the unit's own cell stays clear
local inmove=GetWarMap(x,y,4)>0
if inmove then
if k=="atk" then koRangeBox(px,py,C_ATK)
elseif not own then koRangeBox(px,py,(k=="emove") and C_EMOVE or C_MOVE) end
end
if atk and not own then koAtkFrame(px,py) end
return true
end)

-- ---- registration
koAddon.settings[#koAddon.settings+1]={key="koRangeMark",label="\130\109\130\110 \133\113\130\086",opts={{"\140\089",1},{"\131\081\129\074",0}},default=1}-- 범위 표시: 색 / 원작
