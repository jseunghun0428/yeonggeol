-- ko 3.6: 병종 도감 (addon "bzbook", a tab on the record screen after 무장 도감; needs record).
-- The tab lists every usable class with its numbers; a row opens the class page: the attack range drawn cell by cell,
-- the description, the numbers, 상성 (won / lost, from the game's own BZSuper), the strategies it learns with their
-- levels, and who may use it (exclusive classes: koBZOwner; a general not yet in the 도감 shows as ？？？).
-- Source: 개발용/addon/bzbook_src.lua (UTF-8); script/addon/bzbook.lua is made from it by 개발용/도구/free_hz.pl.
if not koNeeds("record") then return end
local BN="\195\251\179\198"-- 名称
local BD="\203\181\195\247"-- 说明
local BA="\185\165\187\247"-- 攻击
local BF="\183\192\211\249"-- 防御
local BMV="\210\198\182\175"-- 移动
local BR="\185\165\187\247\183\182\206\167"-- 攻击范围
local BHP="\187\249\180\161\177\248\193\166"-- 基础兵力
local BHG="\177\248\193\166\212\246\179\164"-- 兵力增长
local BMG="\178\223\194\212\179\201\179\164"-- 策略成长
local BV="\211\208\208\167"-- 有效
local BFAR="\212\182\179\204"-- 远程
local BHORSE="\198\239\194\237"-- 骑马
local BM="\178\223\194\212"-- 策略N
local MN="\195\251\179\198"-- 名称 (strategy)
local PN="\208\213\195\251"-- 姓名

local function koBZList()
local t={}
for i=1,JY.BingzhongNum-1 do
local b=JY.Bingzhong[i]
if b and b[BN]~="" and (b[BV] or 0)>0 then t[#t+1]=i end
end
return t
end
local function koBZCells(fw)
local a=WarGetAtkFW(20,20,fw)
local out={}
for i=1,a.num do out[#out+1]={a[i][1]-20,a[i][2]-20} end
return out
end
-- strategies 1..36 the class learns, by level; nil = every strategy (마왕)
local function koBZMagics(bz)
if bz==32 then return nil end
local out={}
for m=1,36 do
local lv=JY.Bingzhong[bz][BM..m] or 0
if lv>0 then out[#out+1]={m,lv} end
end
table.sort(out,function(a,b) if a[2]~=b[2] then return a[2]<b[2] end return a[1]<b[1] end)
return out
end
local function koBZOwners(bz)
local o=rawget(_G,"koBZOwner") and koBZOwner[bz]
if not o then return nil end
local s={}
for _,pid in ipairs(o) do
if type(koRecUnlocked)=="function" and not koRecUnlocked(pid) then s[#s+1]="\163\191\163\191\163\191" else s[#s+1]=JY.Person[pid][PN] end
end
return table.concat(s,"\161\164")
end
local function koBZSup(bz)
local win,lose={},{}
for _,o in ipairs(koBZList()) do
if o~=bz then
if BZSuper(bz,o) then win[#win+1]=JY.Bingzhong[o][BN] end
if BZSuper(o,bz) then lose[#lose+1]=JY.Bingzhong[o][BN] end
end
end
return win,lose
end
-- wrapped text: returns the next y
local function koBZText(x,y,s,w,color)
local _,lines=Split(GenTalkString(s,w),"*")
for _,l in ipairs(lines) do DrawString(x,y,l,color or M_White,16) y=y+20 end
return y
end

-- the class page; k = position in list; prev / next walk the list
function koBZPage(list,k)
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
while true do
local bz=list[k]
local b=JY.Bingzhong[bz]
local cells=koBZCells(b[BR])
local mg=koBZMagics(bz)
local win,lose=koBZSup(bz)
local own=koBZOwners(bz)
local tags={}
if (b[BFAR] or 0)>0 then tags[#tags+1]="\131\081\134\069\129\117(\130\073\134\088)" end
if (b[BHORSE] or 0)>0 then tags[#tags+1]="\131\071\133\088(\130\073\131\071)" end
local btns={
{x=ox+660,y=oy+12,w=92,h=26,s="\137\066\129\110\129\094\131\071"},
{x=ox+460,y=oy+12,w=92,h=26,s="\129\071\130\066"},
{x=ox+560,y=oy+12,w=92,h=26,s="\129\077\130\077"},
}
local function draw(hov)
if rawget(_G,"koTourBack") then-- 4.0: the record screen's study picture and framed board (was plain black)
koTourBack(268)
lib.Background(ox+10,oy+52,ox+758,oy+470,100,M_Black)
local function fr(a,c,d,e,col) lib.DrawRect(a,c,d,c,col) lib.DrawRect(a,e,d,e,col) lib.DrawRect(a,c,a,e,col) lib.DrawRect(d,c,d,e,col) end
fr(ox+10,oy+52,ox+758,oy+470,RGB(176,136,60)) fr(ox+12,oy+54,ox+756,oy+468,RGB(80,60,30))
else
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
end
lib.DrawRect(ox+8,oy+48,ox+760,oy+48,M_Gray)
DrawString(ox+24,oy+14,b[BN],C_Name,24)
DrawString(ox+24+#b[BN]*12+16,oy+20,k.."/"..#list,M_Gray,16)
DrawString(ox+24,oy+58,own and ("\130\066\132\111 \130\126\129\084: "..own) or "\130\074\132\111 \130\126\129\084",own and M_Yellow or M_Silver,16)
if #tags>0 then local s=table.concat(tags," \161\164 ") DrawString(ox+752-#s*8,oy+58,s,M_Cyan,16) end
-- the attack range, 11 x 11 cells around the unit
local C=13
local gx,gy=ox+24,oy+86
lib.FillColor(gx,gy,gx+11*C,gy+11*C,RGB(24,28,40))
for _,c in ipairs(cells) do
if math.abs(c[1])<=5 and math.abs(c[2])<=5 then
local x,y=gx+(c[1]+5)*C,gy+(c[2]+5)*C
lib.FillColor(x+1,y+1,x+C,y+C,RGB(210,60,40))
end
end
lib.FillColor(gx+5*C+1,gy+5*C+1,gx+6*C,gy+6*C,RGB(70,120,230))
for i=0,11 do
lib.DrawRect(gx+i*C,gy,gx+i*C,gy+11*C,RGB(60,64,80))
lib.DrawRect(gx,gy+i*C,gx+11*C,gy+i*C,RGB(60,64,80))
end
DrawString(gx,gy+11*C+6,(#cells>0) and ("\130\074\130\112 \130\109\130\110 "..#cells.."\135\066") or "\130\074\130\112 \136\102 \137\072",M_White,16)
local y=gy+11*C+36
local function row(label,v) DrawString(ox+24,y,label,M_Silver,16) DrawString(ox+170-#tostring(v)*8,y,tostring(v),M_White,16) y=y+20 end
row("\130\074\130\112",b[BA]) row("\132\078\130\083",b[BF]) row("\129\071\130\108",b[BMV])
row("\130\126\131\125",b[BHP].."+"..b[BHG]) row("\130\117\130\118\132\081 \131\123\131\097",b[BMG])
-- right column
local X=ox+204
local W=34
y=oy+86
y=koBZText(X,y,b[BD],W,M_White)+8
DrawString(X,y,"\129\067\131\123 \131\079\130\110",M_Lime,16) y=y+20
y=koBZText(X+8,y,(#win>0) and table.concat(win," ") or "\130\097\130\077",W-1,M_White)+6
DrawString(X,y,"\129\067\131\123 \130\065\131\111",M_Red,16) y=y+20
y=koBZText(X+8,y,(#lose>0) and table.concat(lose," ") or "\130\097\130\077",W-1,M_White)+6
DrawString(X,y,"\130\117\130\118 (\129\075\131\068 \130\082\130\123)",M_Yellow,16) y=y+20
if mg==nil then
y=koBZText(X+8,y,"\129\081\129\082\131\080 \130\090\136\101 \130\117\130\118\129\083 \130\082\130\123 1\130\094\131\104 (\132\099\132\100 \129\100\131\107)",W-1,M_White)
elseif #mg==0 then
y=koBZText(X+8,y,"\130\097\130\077",W-1,M_Gray)
else
local p={}
for _,m in ipairs(mg) do p[#p+1]=JY.Magic[m[1]][MN]..m[2] end
y=koBZText(X+8,y,table.concat(p," "),W-1,M_White)
end
end
local r=koTourWait(draw,btns)
if r==0 or r==1 then return end
if r==2 then k=(k>1) and k-1 or #list end
if r==3 then k=(k<#list) and k+1 or 1 end
end
end

-- ---- registration: right after 무장 도감 (before the tabs other addons add)
if rawget(_G,"koRecTabs") then
local PER=12
table.insert(koRecTabs,1,{label="\130\126\129\084 \129\068\135\078",per=PER,
n=function() return #koBZList() end,
draw=function(page,c)
local list=koBZList()
local y0=c.oy+60
local function hd(x,s,right) if right then c.rtext(x,y0,s,M_Gray) else c.txt(x,y0,s,M_Gray) end end
hd(c.ox+24,"\130\126\129\084") hd(c.ox+196,"\130\074\130\112",true) hd(c.ox+256,"\132\078\130\083",true) hd(c.ox+316,"\129\071\130\108",true)
hd(c.ox+386,"\130\109\130\110",true) hd(c.ox+476,"\130\126\131\125",true) hd(c.ox+546,"\130\117\130\118",true) hd(c.ox+572,"\136\096\130\098 \129\073\131\097")
lib.DrawRect(c.ox+16,y0+20,c.ox+752,y0+20,RGB(112,91,57))
for k=1,PER do
local i=(page-1)*PER+k
local bz=list[i]
if not bz then break end
local b=JY.Bingzhong[bz]
local y=y0+30+(k-1)*27
if k%2==0 then lib.Background(c.ox+24,y-2,c.ox+744,y+21,190,RGB(46,35,24)) end
local own=koBZOwners(bz)
local mg=koBZMagics(bz)
c.txt(c.ox+24,y,b[BN],own and M_Yellow or M_White)
c.rtext(c.ox+196,y,tostring(b[BA])) c.rtext(c.ox+256,y,tostring(b[BF])) c.rtext(c.ox+316,y,tostring(b[BMV]))
local nc=#koBZCells(b[BR]) c.rtext(c.ox+386,y,(nc>0) and (nc.."\135\066") or "\130\097\130\077")
c.rtext(c.ox+476,y,b[BHP].."+"..b[BHG])
c.rtext(c.ox+546,y,(mg==nil) and "\130\066\130\094" or tostring(#mg))
c.txt(c.ox+572,y,own or "\130\074\132\111",own and M_Yellow or M_Gray)
end
c.txt(c.ox+24,c.oy+418,"\132\123\129\083 \134\117\130\106\129\065 \130\074\130\112 \130\109\130\110\161\164\129\067\131\123\161\164\130\117\130\118\129\083 \133\120\131\111\138\087 \139\098\129\076\129\077",M_Gray)
end,
btns=function(page,c)
local out={}
local list=koBZList()
for k=1,PER do
local i=(page-1)*PER+k
if not list[i] then break end
out[#out+1]={x=c.ox+16,y=c.oy+60+28+(k-1)*27,w=736,h=25,s="",plain=true,bzk=i}
end
return out
end,
click=function(btn) koBZPage(koBZList(),btn.bzk) end})
end
