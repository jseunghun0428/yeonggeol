-- ko 3.0: threat range ("위협 범위"). While no unit is selected, hovering an enemy tints every cell it
-- could attack this turn: its reachable cells (War_CalMoveStep, the game's own path search with terrain
-- cost, blocking units and ZOC) plus the attack pattern (WarGetAtkFW) from each of them.
-- 3.1: with addon range on, the hover is gone (click the enemy instead) and the 전체 위협 is drawn as boxes:
-- every cell some enemy can strike this turn, all red (koRangeBoxAt).
koThreat={id=0,key="",cells={}}
function koThreatOn()
return (CC.koThreat or 1)==1
end

-- move = cells the enemy can reach (its own cell included), atk = cells it can strike from any of them; keyed y*W+x
function koThreatSets(eid)
local v=War.Person[eid]
local W,D=War.Width,War.Depth
-- War_CalMoveStep works in map layer 4, which holds the player's own move range: keep a copy and put it back
local base=W*D*3
local saved={}
for i=1,W*D do saved[i]=War.Map[base+i] end
local move,atk={},{}
local ok,err=pcall(function()
local steps=War_CalMoveStep(eid,v.movestep)
for j=0,v.movestep do
local s=steps[j]
if not s or s.num==0 then break end
for k=1,s.num do
move[s.y[k]*W+s.x[k]]=true
local arr=WarGetAtkFW(s.x[k],s.y[k],v.atkfw)
for n=1,arr.num do
local ax,ay=arr[n][1],arr[n][2]
if between(ax,1,W) and between(ay,1,D) then atk[ay*W+ax]=true end
end
end
end
end)
for i=1,W*D do War.Map[base+i]=saved[i] end
if not ok then lib.Debug("koThreatSets: "..tostring(err)) end
return move,atk
end
function koThreatCells(eid)-- 3.0 shape: the union
local move,atk=koThreatSets(eid)
for k in pairs(move) do atk[k]=true end
return atk
end

-- every enemy at once (the 위협 bar button / 기능 menu toggle); cached for half a second
koThreatAllCache={key="",move={},atk={}}
function koThreatAllSets()
local key=""
for i,v in pairs(War.Person) do
if v.enemy and v.live and not v.hide then key=key..i..":"..v.x..","..v.y..";" end
end
if koThreatAllCache.key==key and lib.GetTime()-(koThreatAllCache.t or 0)<=500 then return koThreatAllCache.move,koThreatAllCache.atk end
local move,atk={},{}
for i,v in pairs(War.Person) do
if v.enemy and v.live and not v.hide then
local m,a=koThreatSets(i)
for k in pairs(m) do move[k]=true end
for k in pairs(a) do atk[k]=true end
end
end
koThreatAllCache.key=key koThreatAllCache.t=lib.GetTime() koThreatAllCache.move=move koThreatAllCache.atk=atk
return move,atk
end
function koThreatAllCells()
local move,atk=koThreatAllSets()
local cells={}
for k in pairs(move) do cells[k]=true end
for k in pairs(atk) do cells[k]=true end
return cells
end
local function koThreatBoxes()
return koHas("range") and koRangeOn()
end
-- called from DrawWarMap between the range overlays and the units
local function koDrawThreatCells(cx,cy,cells,pic)
local W=War.Width
for x=War.CX,math.min(War.CX+War.MW,War.Width) do
for y=War.CY,math.min(War.CY+War.MD,War.Depth) do
if cells[y*W+x] then
lib.PicLoadCache(4,pic*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
end
end
end
end
-- 전체 위협 = every cell some enemy can strike this turn (the 3.0 union), all in red; the enemies' own cells stay clear
local function koDrawThreatBoxes(cx,cy,cells)
local W=War.Width
for x=War.CX,math.min(War.CX+War.MW,War.Width) do
for y=War.CY,math.min(War.CY+War.MD,War.Depth) do
if cells[y*W+x] then
local u=GetWarMap(x,y,2)
if not (u>0 and War.Person[u] and War.Person[u].enemy) then koRangeBoxAt(cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),"atk") end
end
end
end
end
function koDrawThreat(cx,cy)
if not koThreatOn() then return end
if War.ControlStatus~="select" or not War.ControlEnable then return end
if (JY.koInTalk or 0)>0 then return end-- 3.1: not under a battle conversation (DrawWarMap keeps running inside talk)
if (War.SelID or 0)>0 and koThreatBoxes() then return end-- 3.1: a clicked unit shows its own move/attack boxes (addon range) instead
if War.koThreatAll then
if koThreatBoxes() then koDrawThreatBoxes(cx,cy,koThreatAllCells()) else koDrawThreatCells(cx,cy,koThreatAllCells(),261) end
end
if koThreatBoxes() then return end-- 3.1: no hover range; click the enemy to see its move/attack boxes (addon range)
local eid=War.CurID
if not (eid and eid>0) then return end
local v=War.Person[eid]
if not (v and v.enemy and v.live and not v.hide) then return end
local key=eid..","..v.x..","..v.y..","..(v.movestep or 0)..","..(v.atkfw or 0)
if koThreat.key~=key or lib.GetTime()-(koThreat.t or 0)>500 then
koThreat.key=key
koThreat.t=lib.GetTime()
koThreat.cells=koThreatCells(eid)
end
koDrawThreatCells(cx,cy,koThreat.cells,War.koThreatAll and 262 or 261)
end



-- ---- registration (ko 3.1 addon "threat": 위협 범위, single + all)
koAddon.settings[#koAddon.settings+1]={key="koThreat",label="\130\110\137\071 \130\109\130\110",opts={{"\133\122",1},{"\133\117",0}},default=1}
koOn("draw_overlay",function(cx,cy) koDrawThreat(cx,cy) end)
local function koThreatToggle() War.koThreatAll=not War.koThreatAll end
koAddon.barButtons[#koAddon.barButtons+1]={label="\130\110\137\071",show=koThreatOn,run=koThreatToggle}
koAddon.warMenu[#koAddon.warMenu+1]={label=function() return War.koThreatAll and "\130\066\133\114 \130\110\137\071 \133\126\141\091" or "\130\066\133\114 \130\110\137\071 \133\113\130\086" end,enabled=koThreatOn,run=koThreatToggle}
koOn("battle_key",function(k)-- T
if k==116 and War.ControlStatus=="select" and War.ControlEnable then
if koThreatOn() then koThreatToggle() PlayWavE(0) end
return 0
end
return nil
end)

-- ko 3.6: 적 성향 (기능설정, default 끔). Under the hover status popup of an enemy (or allied 우군) unit, one line says how
-- its AI moves this turn (War.Person[].ai, the base's AI_Sub types): 0 대기 (moves only when someone comes within reach),
-- 1 적극, 2 고수 (never moves, strikes what comes in range), 3 추격 <target>, 4 목표 지점으로 진군 (attacks on the way),
-- 5 <target> 쪽으로 진군, 6 목표 지점으로 이동 (no attack). A 대기/고수 unit that has been provoked turns 적극 by itself,
-- and the tag follows. Source: 개발용/addon/ai_tag_src.lua, converted by free_hz.pl and appended to script/addon/threat.lua
local AITAG_NAME="\208\213\195\251"-- 姓名
function koAITagText(v)
local t=v.ai or 1
local who=""
if (t==3 or t==5) and v.aitarget and v.aitarget>0 and JY.Person[v.aitarget] then who=JY.Person[v.aitarget][AITAG_NAME] or "" end
if t==0 then return "\130\095\131\071 (\129\094\129\089\129\071 \129\091\129\065 \130\074\130\112)"
elseif t==1 then return "\131\076\136\112 (\129\077\129\094\135\122 \130\074\130\112)"
elseif t==2 then return "\131\100\129\113 (\129\100\133\120\129\117 \132\078\130\083)"
elseif t==3 then return "\133\099\130\112: "..who
elseif t==4 then return "\130\067\135\070\131\109\132\083 \129\103\130\084"
elseif t==5 then return who.." \139\074\131\109\132\083 \129\103\130\084"
elseif t==6 then return "\130\067\135\070\131\109\132\083 \129\071\130\108 (\130\074\130\112 \130\111 \137\072)"
end
return nil
end
-- drawn right after the popup itself (DrawStatusMini sets War.koMini), so the unit sprites stay under it
local function koAITagDraw(id)
if (CC.koAITag or 0)~=1 or JY.Status~=GAME_WMAP or not War.koMini or War.koMini.id~=id or (JY.koInTalk or 0)>0 then return end
local v=War.Person[War.koMini.id]
if not v or not v.live or v.hide or not (v.enemy or v.friend) then return end
local s=koAITagText(v)
if not s then return end
s="\130\093\130\108: "..s
local x1,y1,y2=War.koMini.x1,War.koMini.y1,War.koMini.y2
local w=#s*8+24
local x=math.min(x1,((War.OX or 0)+(War.BoxWidth or 48)*(War.MW or 12))-w-2)-- 10-14: inside the map
local y=y2+2
if y+28>((War.OY or 0)+(War.BoxDepth or 48)*(War.MD or 9)) then y=y1-30 end
lib.FillColor(x,y,x+w,y+22,RGB(24,20,16))
lib.DrawRect(x,y,x+w,y+22,M_Gray)
DrawString(x+8,y+3,s,v.enemy and RGB(255,190,120) or RGB(255,210,150),16)
end
local rawMiniAI=DrawStatusMini
DrawStatusMini=function(id,...)
local a,b,c=rawMiniAI(id,...)
pcall(koAITagDraw,id)
return a,b,c
end
koAddon.settings[#koAddon.settings+1]={key="koAITag",label="\131\076 \131\123\134\089",opts={{"\131\115\131\071",1},{"\133\117",0}},default=0}
-- ko 3.6 later: 연계 tag. Under the hover status popup of one of ours standing next to its partner (koLinkPairs in the base:
-- 선인 연계 좌자·선자, 강동 연계 손상향·유비, 이교 연계 대교·소교), one line names the link and what it gives.
-- Source: 개발용/addon/link_tag_src.lua, converted by free_hz.pl and appended to script/addon/threat.lua (after ai_tag)
local function koLinkTagDraw(id)
if JY.Status~=GAME_WMAP or not War.koMini or War.koMini.id~=id or (JY.koInTalk or 0)>0 or not rawget(_G,"koLinkOnPid") then return end
local v=War.Person[War.koMini.id]
if not v or not v.live or v.hide then return end
local row=koLinkOnPid(v.id)
if not row then return end
local s=row[4]..": "..row[5]
local x1,y1,y2=War.koMini.x1,War.koMini.y1,War.koMini.y2
local w=#s*8+24
local x=math.min(x1,((War.OX or 0)+(War.BoxWidth or 48)*(War.MW or 12))-w-2)-- 10-14: inside the map
local y=y2+2
if y+28>((War.OY or 0)+(War.BoxDepth or 48)*(War.MD or 9)) then y=y1-30 end
koRecordClassicFrame(x,y,w,28)
DrawString(x+12,y+6,s,C_Name,16)
end
local rawMiniLink=DrawStatusMini
DrawStatusMini=function(id,...)
local a,b,c=rawMiniLink(id,...)
-- pcall(koLinkTagDraw,id) -- 5.1 (10-15): the links are a row inside the mini window now (jymain koMiniLinks), no tag box under it
return a,b,c
end
