-- ko 3.6 later: 장비 비교 (addon "gearcmp"). In the 도구 교환 screen (ExchangeItem), once an item is picked to hand over,
-- pointing at another general shows what the move changes for both: the gear that ends up worn (무기·방구·보조),
-- 공격·방어·무력·지력·통솔·이동·책략치·병력, and the skills gained or lost (an item's own 특기 and the 전용 특기 it gives
-- its owner). The numbers come from the game's own ReSetAttrib run on a trial copy of the two bags; everything is put back.
-- Hook exchange_draw (patch_장비비교_훅): called every frame of the screen with its state.
-- Source: 개발용/addon/gearcmp_src.lua (UTF-8); script/addon/gearcmp.lua is made from it by 개발용/도구/free_hz.pl.
local function K(...) return string.char(...) end
local ITEM=K(181,192,190,223)-- 道具
local GEAR={K(206,228,198,247),K(183,192,190,223),K(184,168,214,250)}-- 武器 防具 辅助
local GEARN={"\129\073\131\071","\132\078\130\083\130\119","\131\115\129\118"}
local NAME=K(195,251,179,198)-- 名称
local PNAME=K(208,213,195,251)-- 姓名
local STATS={
{K(185,165,187,247),"\130\074\130\112"},{K(183,192,211,249),"\132\078\130\083"},
{K(206,228,193,166).."2","\129\073\131\125"},{K(214,199,193,166).."2","\130\067\131\125"},{K(205,179,194,202).."2","\132\119\132\120"},
{K(210,198,182,175),"\129\071\130\108"},{K(215,238,180,243,178,223,194,212),"\130\117\130\118\132\081"},{K(215,238,180,243,177,248,193,166),"\130\126\131\125"},
}
-- every field ReSetAttrib may write (all stored in the save's record), plus the bag
local KEEP={K(206,228,198,247),K(183,192,190,223),K(184,168,214,250),K(206,228,193,166).."2",K(214,199,193,166).."2",K(205,179,194,202).."2",
K(215,238,180,243,178,223,194,212),K(178,223,194,212),K(202,191,198,248),K(185,165,187,247),K(183,192,211,249),K(210,198,182,175),
K(177,248,193,166),K(215,238,180,243,177,248,193,166)}
for i=1,8 do KEEP[#KEEP+1]=ITEM..i end
local MAXSKILL=130-- 6.0 (10-31): include 130 fenzhan
local function skills(pid)
local t={}
for s=1,MAXSKILL do if JY.Skill[s] and CheckSkill(pid,s) then t[s]=true end end
return t
end
-- the general's state after its bag is changed by edit(p): {gear={3 ids}, stat={...}, sk=set}
local function trial(pid,edit)
local p=JY.Person[pid]
local snap={}
for _,k in ipairs(KEEP) do snap[k]=p[k] end
local r={}
local ok,err=pcall(function()
if edit then edit(p) end
ReSetAttrib(pid,true)
r.gear={p[GEAR[1]],p[GEAR[2]],p[GEAR[3]]}
r.stat={}
for i,s in ipairs(STATS) do r.stat[i]=p[s[1]] end
r.sk=skills(pid)
end)
for _,k in ipairs(KEEP) do p[k]=snap[k] end
if not ok then lib.Debug("gearcmp: "..tostring(err)) return nil end
return r
end
local function giveTo(item) return function(p) for i=1,8 do if p[ITEM..i]==0 then p[ITEM..i]=item return end end end end
local function takeFrom(slot) return function(p) for i=slot,7 do p[ITEM..i]=p[ITEM..(i+1)] end p[ITEM.."8"]=0 end end
local function itemName(id) if id and id>0 and JY.Item[id] then return JY.Item[id][NAME] end return "\130\097\130\077" end
-- lines for one general: {{text,color},...}
local UP,DOWN,GRAY=RGB(120,225,120),RGB(255,120,120),M_Gray
local function describe(pid,a,b,item)
local out={}
local head=JY.Person[pid][PNAME]
local parts={}
for g=1,3 do
if a.gear[g]~=b.gear[g] then parts[#parts+1]=GEARN[g].." "..itemName(a.gear[g]).." > "..itemName(b.gear[g]) end
end
out[#out+1]={head..((#parts==0) and "  (\134\087\132\111 \131\097\130\080 \131\091\130\095\132\083)" or ""),C_Name}
for _,s in ipairs(parts) do out[#out+1]={" "..s,M_White} end
local nums={}
for i,s in ipairs(STATS) do
local d=(b.stat[i] or 0)-(a.stat[i] or 0)
if d~=0 then nums[#nums+1]={s[2]..((d>0) and "+" or "")..d,(d>0) and UP or DOWN} end
end
-- two or three numbers a line
local line,col,n="",nil,0
for _,x in ipairs(nums) do
line=line.." "..x[1] n=n+1
col=col or x[2]
if col~=x[2] then col=M_White end
if n==3 then out[#out+1]={line,col} line,col,n="",nil,0 end
end
if n>0 then out[#out+1]={line,col} end
for s=1,MAXSKILL do
if b.sk[s] and not a.sk[s] then out[#out+1]={" \129\120\131\071 "..JY.Skill[s][NAME].." \133\086\130\077",UP}
elseif a.sk[s] and not b.sk[s] then out[#out+1]={" \129\120\131\071 "..JY.Skill[s][NAME].." \140\079\130\077",DOWN} end
end
if #nums==0 and #parts==0 then
local slot=JY.Item[item] and JY.Item[item][K(215,176,177,184,206,187)] or 0-- 装备位
if slot and slot>0 and b.gear[slot]~=item then out[#out+1]={" \131\097\134\087\132\067\130\067 \130\107\130\077 (\130\126\129\084\161\164\130\082\130\123 \129\118\129\119 \135\079\130\098 \132\108 \138\111\131\098 \131\097\130\080)",GRAY}
else out[#out+1]={" \131\077\131\125 \130\116\129\064 \130\097\130\077",GRAY} end
end
return out
end
local cache={}
local function compare(src,slot,dst)
local key=src.."/"..slot.."/"..dst
if cache.key==key then return cache.lines end
local item=JY.Person[src][ITEM..slot]
local lines={}
if item and item>0 then
local a1,b1=trial(dst,nil),trial(dst,giveTo(item))
local a2,b2=trial(src,nil),trial(src,takeFrom(slot))
if a1 and b1 and a2 and b2 then
lines[#lines+1]={itemName(item).."\129\083(\130\104) \129\119\132\112\129\065",M_Yellow}
for _,l in ipairs(describe(dst,a1,b1,item)) do lines[#lines+1]=l end
for _,l in ipairs(describe(src,a2,b2,item)) do lines[#lines+1]=l end
end
end
cache.key=key cache.lines=lines
return lines
end
koOn("exchange_draw",function(s)
if s.status~=3 or (s.iid or 0)<=0 then cache.key=nil return nil end
local src=s.ids[s.current]
local dst=nil
for i=1,6 do
local idx=s.view[6*(s.page-1)+i]
if idx and MOUSE.IN(s.xy.x1[i],s.xy.y1[i],s.xy.x4[i],s.xy.y4[i]) then dst=s.ids[idx] break end
end
if not dst or not src or dst==src then return nil end
local lines=compare(src,s.iid,dst)
if #lines==0 then return nil end
local w=0
for _,l in ipairs(lines) do w=math.max(w,#l[1]*8) end
w=w+24
local h=#lines*20+24
local x=MOUSE.x+16
local y=MOUSE.y+12
if x+w>CC.ScreenW-4 then x=MOUSE.x-w-8 end
if x<4 then x=4 end
if y+h>CC.ScreenH-4 then y=CC.ScreenH-4-h end
koRecordClassicFrame(x,y,w,h)
for i,l in ipairs(lines) do DrawString(x+12,y+12+(i-1)*20,l[1],l[2],16) end
return nil
end)
