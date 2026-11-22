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
if not MOUSE.HOLD(16,32,16+War.BoxWidth*War.MW-1,32+War.BoxDepth*War.MD-1) then return false end
local dx,dy=koEdgeDir(math.modf((px-16)/War.BoxWidth),math.modf((py-32)/War.BoxDepth))
local hx,hy=koEdgeDir(math.modf((MOUSE.hx-16)/War.BoxWidth),math.modf((MOUSE.hy-32)/War.BoxDepth))
if (dx==0 and dy==0) or (hx==0 and hy==0) then return false end
War.CX=War.CX+dx War.MX=War.MX+dx
War.CY=War.CY+dy War.MY=War.MY+dy
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
--ko: data\\save may be missing (empty folders are often dropped from archives). Spawning cmd from this exe takes ~5s,
--so create it in the background at start-up; copyfile() still has the blocking fallback
function koSaveDirPrepare()
if not CONFIG.Windows then return end--android: io.popen is unavailable; the save folder ships with the data
local f=io.open(CONFIG.Save.."ko_dir.chk","w")
if f then f:close() os.remove(CONFIG.Save.."ko_dir.chk") return end
CC.koMkdirPipe=io.popen('mkdir "'..string.sub(CONFIG.Save,1,-2)..'" >nul 2>&1')
end
--ko: X button while a message box / menu is waiting. In battle ask first (same prompt as the battle menu), elsewhere exit at once
function koExitAsk()
if JY.Status==GAME_WMAP or JY.Status==GAME_WMAP2 then
local sid=lib.SaveSur(0,0,CC.ScreenW,CC.ScreenH)
local r=WarDrawStrBoxYesNo('QRS TUXYZ?',M_White)
if r then os.exit() end
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
ReFresh(0)
koMouseReset()
return
end
os.exit()
end
function JY_Main()--Ö÷³ÌĞòÈë¿Ú
os.remove("debug.txt")--Çå³ıÒÔÇ°µÄdebugÊä³ö
xpcall(JY_Main_sub,myErrFun)--²¶»ñµ÷ÓÃ´íÎó
end

function JY_Main_sub()--ÕæÕıµÄÓÎÏ·Ö÷³ÌĞòÈë¿Ú
dofile(CONFIG.ScriptPath .. "jyconfig.lua") --¼ÓÔØÓÎÏ·ÉèÖÃÎÄ¼ş
dofile(CONFIG.ScriptPath .. "kdef.lua") --¼ÓÔØÓÎÏ·ÊÂ¼ş
dofile(CONFIG.CurrentPath.."script/addon/ext.lua")--ko 3.1: the í™•ì¥ screen (turns the addons back on; restart applies)
SetGlobalConst()
SetGlobal()
pcall(koSaveDirPrepare)
koSettingsRead()--ko 3.1: ë°°ì†Â·ë°°ìœ¨Â·ì—°ì¶œÂ·ëŒ€í™” from ko_settings.lua
CC.koEdgePic={[-3]={240,13,12},[-2]={241,12,12},[1]={242,12,13},[4]={243,12,12},[3]={244,13,12},[2]={245,12,12},[-1]={246,12,13},[-4]={247,12,12}}--ko: scroll arrows by dy*3+dx
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
lv=math.modf(lv/cnt)--µÃµ½ÎÒ·½ËùÓĞ²¿¶ÓµÄÆ½¾ùµÈ¼¶
return lv
end

function myErrFun(err)--´íÎó´¦Àí£¬´òÓ¡´íÎóĞÅÏ¢
lib.Debug(err)--Êä³ö´íÎóĞÅÏ¢
lib.Debug(debug.traceback())--Êä³öµ÷ÓÃ¶ÑÕ»ĞÅÏ¢
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
WarDrawStrBoxConfirm(string.format("caWLM! d%def gh",level-8),M_White,true)
GetMoney(100)--Ã¿¹ıÒ»¹Ø »ñµÃ100½ğ
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
fory=y1,y2-1,size do
local flag2=flag1
forx=x1,x2-1,size do
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
str=GenTalkString(str,36)
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
str=GenTalkString(str,36)
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
local x,y
local w,h=320,192
local size=16
x=16+576/2
y=32+432/2
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
if CC.Enhancement then
if id==JY.Person[pid]["ÎäÆ÷"] and JY.Person[pid]["ĞÕÃû"]==JY.Item[id]["×¨ÊôÌØ¼¼ÈË"] then
str=str.."*xqy{:"..JY.Skill[JY.Item[id]["×¨ÊôÌØ¼¼"]]["ËµÃ÷"]
elseif id==JY.Person[pid]["ÎäÆ÷"] and JY.Item[id]["ÌØ¼¼"]>0 then
str=str.."*xqy{:"..JY.Skill[JY.Item[id]["ÌØ¼¼"]]["ËµÃ÷"]
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

function DrawLieZhuan(name)--ÏÔÊ¾ÁĞ´«
 DrawStrStatus("|}~‚@‚A‚B - "..name,CC.LieZhuan[name])
end

function DrawStrStatus(str1,str2)--ÏÔÊ¾ÊôĞÔ
lib.GetKey()
local x,y
local w,h=320,128
local size=16
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
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
str=GenTalkString(str,36)
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
x=16+(576-0)/2
y=32+(432-0)/2
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
str=GenTalkString(str,36)
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
x=16+(576)/2
y=32+(432)/2
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
WaitKey()
lib.LoadSur(sid,0,0)
lib.FreeSur(sid)
ShowScreen()
end

function WarDrawStrBoxWaitKey(s,color,x,y)--ÏÔÊ¾×Ö·û´®²¢µÈ´ı»÷¼ü ÊÊÓÃÓÚÕ½¶·£¬»­Ãæ±£³ÖË¢ĞÂ
x=x or -1
y=y or -1
lib.GetKey()
local koT0Box=lib.GetTime()--ko 5.1.6: as the ìœ ê´‘íŒ box: not the button-up of the click before
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
local koKe=-1--ko 5.1.6 (ì œë³´: ìˆœì • ë ˆë²¨ì—… ì°½ì—ì„œ ì‘ë‹µ ì—†ìŒ): lib.GetMouse(1) does not poll the event queue, so Windows saw no message pumping; drain it as the ìœ ê´‘íŒ box does (3.0)
for koI=1,32 do
local koE=lib.GetKey(1)
if koE==0 then koExitAsk() end
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
lib.GetKey()
local koT0Box=lib.GetTime()--ko 5.1.6: as the ìœ ê´‘íŒ box: not the button-up of the click before
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
local koKe=-1--ko 5.1.6 (ì œë³´: ìˆœì • ë ˆë²¨ì—… ì°½ì—ì„œ ì‘ë‹µ ì—†ìŒ): lib.GetMouse(1) does not poll the event queue, so Windows saw no message pumping; drain it as the ìœ ê´‘íŒ box does (3.0)
for koI=1,32 do
local koE=lib.GetKey(1)
if koE==0 then koExitAsk() end
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
str=GenTalkString(str,36)
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
x=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=32+(432-h)/2
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
str=GenTalkString(str,36)
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
x=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x=16+(640-w)/2
else
x=(CC.ScreenW-w)/2
end
end
if y==-1 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y=32+(432-h)/2
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
local koT0=lib.GetTime() local koW=koAutoMs(n)--ko 3.1: ëŒ€í™” ìë™ ë„˜ê¹€
while true do
local eventtype,keypress,x,y=lib.GetMouse(1)
local koKe=lib.GetKey(1)
if koKe==0 then koExitAsk() end
if eventtype==1 or eventtype==3 or koKe==1 or koKe==3 then
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
function koSaveCompat(id)
local function size(p) local f=io.open(p,"rb") if not f then return -1 end local s=f:seek("end") f:close() return s end
if size(CC.R_GRPFilename[id])==size(CC.R_GRPFilename[0]) then return true end
WarDrawStrBoxConfirm("\132\065\129\070 \131\071\133\108\129\071 \129\110\130\096\129\076\129\077 (\130\071\130\072\130\070 \136\069\130\121). \131\087\132\083 \134\113\134\073\132\067\130\067 \130\107\129\075\129\076\129\077",M_White,true)
return false
end
function LoadRecord(id)-- ¶ÁÈ¡ÓÎÏ·½ø¶È
Dark()
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
Byte.loadfile(JY.Data_Person, CC.R_GRPFilename[id],idx[1],CC.PersonSize*JY.PersonNum)
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
Byte.loadfile(JY.Data_Scene,CC.R_GRPFilename[id],idx[3],CC.SceneSize*JY.SceneNum)
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
Byte.loadfile(JY.Data_Item,CC.R_GRPFilename[id],idx[4],CC.ItemSize*JY.ItemNum)
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
--ko item name/description are display text, not game state: always take them from newgame.grp so renamed items show the new name in old saves too
if id>0 then
local koItemBase=Byte.create(CC.ItemSize*JY.ItemNum)
Byte.loadfile(koItemBase,CC.R_GRPFilename[0],idx[4],CC.ItemSize*JY.ItemNum)
for i=0,JY.ItemNum-1 do
JY.Item[i]["Ãû³Æ"]=GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,"Ãû³Æ")
JY.Item[i]["ËµÃ÷"]=GetDataFromStruct(koItemBase,i*CC.ItemSize,CC.Item_S,"ËµÃ÷")
end
end
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
if CC.koMkdirPipe then pcall(function() CC.koMkdirPipe:close() end) CC.koMkdirPipe=nil destinationfile=io.open(destination,"wb") end--ko: wait for the start-up mkdir first
end
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
if id>=0 and id<=19 then
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
function ShowMenu(menuItem,numItem,numShow,x1,y1,x2,y2,isBox,isEsc,size,color,selectColor)--Í¨ÓÃ²Ëµ¥º¯Êı
if JY.Status==GAME_START then
lib.PicLoadCache(4,264*2,0,0,1)
if CC.koMenuHeader then DrawYJZBox2(-1,CC.koMenuHeader[1],CC.koMenuHeader[2],M_White) end--ko: header set by the caller, drawn after the title redraw
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
DrawString(384-48,366,"[ug",RGB(240,173,88),32)--ko: "origin" label under the title menu (title gold, a bit smaller)
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
w=96
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
w=104
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
if x1==-1 or x1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x1=16+(576-w)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
x1=16+(640-w)/2
else
x1=(CC.ScreenW-w)/2
end
end
if y1==-1 or y1==0 then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
y1=32+(432-h)/2
elseif JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL then
y1=16+(400-h)/2
else
y1=(CC.ScreenH-h)/2
end
end

local function redraw(flag)
if num~=0 then--ÔİÇÒÕâÑù¸Ä
if isBox==1 then
koFrame(0*2,80,256,x1,y1,w,16+24*num)
elseif isBox==2 then
koFrame(60*2,142,110,x1,y1,w,16+24*num)
elseif isBox==20 then
lib.SetClip(x1,y1,x1+w,y1+7+24*num)
lib.PicLoadCache(4,70*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+8+24*math.max(0,(num-3)),x1+w,y1+8+24*num+8)
lib.PicLoadCache(4,70*2,x1,y1+14+24*num-110,1)
lib.SetClip(0,0,0,0)
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
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
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
local drawColor=color--ÉèÖÃ²»Í¬µÄ»æÖÆÑÕÉ«
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
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),M_White)
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
if MOUSE.EXIT() then koExitAsk() end
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
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
if returnValue==0 then
PlayWavE(1)
end
lib.LoadSur(sid)
lib.FreeSur(sid)
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
newMenu[newNumItem]={menuItem[i][1],menuItem[i][2],menuItem[i][3],i}--ĞÂÊı×é¶àÁË[4],±£´æºÍÔ­Êı×éµÄ¶ÔÓ¦
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
w=96
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
w=104
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
lib.SetClip(x1,y1,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1,1)
lib.SetClip(0,0,0,0)
lib.SetClip(x1,y1+h-8,x1+w,y1+h)
lib.PicLoadCache(4,66*2,x1,y1-(384-h),1)
lib.SetClip(0,0,0,0)
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
local drawColor=color--ÉèÖÃ²»Í¬µÄ»æÖÆÑÕÉ«
local menustr=newMenu[i][1]
local koDx=0
if isBox==1 or isBox==2 or isBox==3 then
menustr,koDx=koCenter(menustr,w,x_off,size)
end
if i==current then
drawColor=selectColor
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
lib.DrawRect(x1+12,y1+12+20*(i-1),x1+91,y1+12+20*(i),M_White)
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
ReFresh(0.4)
local eventtype,keyPress,mx,my=getkey()
if MOUSE.EXIT() then koExitAsk() end
mx,my=MOUSE.x,MOUSE.y
if eventtype==3 and keyPress==3 then
if isEsc==1 then
wait=false
end
end
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
if returnValue==0 then
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
ReFresh()
WarCheckStatus()
local WEA={[0]="‚L‚M","‚L‚M","‚L‚M","‚N‚O","‚P","‚P","£¿"}
while JY.Status==GAME_WMAP and War.Turn<=War.MaxTurn do
--µÚX»ØºÏ X
WarDrawStrBoxDelay(string.format('d%dp %s',War.Turn,WEA[War.Weather]),M_White)
WarCheckStatus()
--ÎÒ¾ü²Ù×÷
if JY.Status==GAME_WMAP then
WarDrawStrBoxDelay('‚Q‚RG‚S‚T C‚U',M_White)
War.ControlStatus='select'
War.ControlEnable=true
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
	War.ControlStatus='AI'
	AI()
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
ShowScreen()--³¡¾°±äºÚÔÙ×ªÎª±äÁÁ
if t2-t1<frame_t then
lib.Delay(frame_t+t1-t2)
end
end

function control()
local eventtype,keypress,x,y=getkey()
x,y=MOUSE.x,MOUSE.y
if eventtype==3 and keypress==3 then
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
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White) then
WarDelay(CC.WarDelay)
JY.Status=GAME_END
end
elseif War.ControlStatus=="select" and MOUSE.CLICK(16,8,79,23) then--ko: top-left button = same as right-click menu, dropped under the button
return -2
elseif War.ControlStatus=="select" and pid>0 and MOUSE.CLICK(611,32,653,63) then--ko: name box = unit status window (same as clicking the portrait)
PersonStatus(pid,"","",1)
elseif War.ControlStatus=="select" and MOUSE.CLICK(657,32,687,63) then--ko: our army list
koArmyList(false)
elseif War.ControlStatus=="select" and MOUSE.CLICK(689,32,719,63) then--ko: enemy army list
koArmyList(true)
elseif koEdgeScroll(x,y) then--ko: hold on the map border scrolls; corners scroll diagonally
elseif MOUSE.HOLD(War.MiniMapCX,War.MiniMapCY,War.MiniMapCX+War.Width*4,War.MiniMapCY+War.Depth*4) then
War.CX=limitX(math.modf((x-War.MiniMapCX)/4-War.MW/2)+1,1,War.Width-War.MW+1)
War.CY=limitX(math.modf((y-War.MiniMapCY)/4-War.MD/2)+1,1,War.Depth-War.MD+1)
elseif MOUSE.CLICK(616,81,680,161) then
PersonStatus(pid,"","",1)
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,294,678,313) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][1] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼1"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,294,714,313) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][2] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼2"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,294,740,313) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][3] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼3"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(644,314,678,333) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][4] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼4"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(680,314,714,333) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][5] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼5"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif CC.Enhancement and pid>0 and MOUSE.CLICK(716,314,740,333) then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][6] then
DrawSkillStatus(JY.Person[pid]["ÌØ¼¼6"])--ÏÔÊ¾¼¼ÄÜÊôĞÔ
end
elseif MOUSE.IN(16,32,16+War.BoxWidth*War.MW,32+War.BoxDepth*War.MD) and War.ControlStatus~="checkDX" then
local mx,my=math.modf((x-16)/War.BoxWidth),math.modf((y-32)/War.BoxDepth)
War.InMap=true
War.MX=mx+War.CX
War.MY=my+War.CY
War.CurID=GetWarMap(War.MX,War.MY,2)
if War.CurID>0 then
War.LastID=War.CurID
end
if MOUSE.CLICK(16+War.BoxWidth*mx+1,32+War.BoxDepth*my+1,16+War.BoxWidth*(mx+1)-1,32+War.BoxDepth*(my+1)-1) then
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
elseif event==-1 then
War.FunButtom=0
return ESCMenu()
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
War.DXpic=lib.SaveSur(16+War.BoxWidth*(War.MX-War.CX),32+War.BoxDepth*(War.MY-War.CY),16+War.BoxWidth*(War.MX-War.CX+1),32+War.BoxDepth*(War.MY-War.CY+1))
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
menux=16+War.BoxWidth*(mx-War.CX)-80
else
menux=16+War.BoxWidth*(mx-War.CX+1)
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
if CC.RWTS then
m[7][3]=1
m[8][3]=1
m[9][3]=1
m[10][3]=1
menu_num=menu_num+3
end
if (between(War.Person[scl].bz,4,6) or War.Person[scl].bz==22) and CC.Enhancement and WarCheckSkill(scl,44) then--ÂÒÉä
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
menuy=math.min(32+War.BoxDepth*(my-War.CY),CC.ScreenH-32-24*menu_num)
local r=WarShowMenu(m,#m,0,menux,menuy,0,0,1,1,16,M_White,M_White)
WarDelay(CC.WarDelay)
if r==1 then
WarSetAtkFW(War.SelID,War.Person[War.SelID].atkfw)
local eid=WarSelectAtk(false,11)
if eid>0 then
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
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
WarAtk(eid,scl,1)
WarResetStatus(scl)
if CC.Enhancement and WarCheckSkill(eid,106) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then--ko fix: gyeolsa(106) extra hit also on the bansal(102) counter
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end

if CC.Enhancement and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
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
--Òıµ¼¹¥»÷
local ydgj=0
if CC.Enhancement and WarCheckSkill(scl,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(scl,108) then
ydgj=1
end
if ydgj==1 and War.YD==0 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]<=0 then
War.YD=1
AI_Sub(scl,1)
end
elseif ydgj==2 then
local yd=eid
while yd~=0 do
if JY.Person[War.Person[yd].id]["±øÁ¦"]<=0 then
yd=AI_Sub(scl,1)
else
break
end
end
end
if CC.Enhancement and (JY.Person[pid]["ÎäÆ÷"]==59 or WarCheckSkill(scl,114)) then--Ó¢ĞÛÖ®½£ ´©´Ì¹¥»÷
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
WarAtk(eid,scl,1)
WarResetStatus(scl)
if CC.Enhancement and WarCheckSkill(eid,106) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then--ko fix: gyeolsa(106) extra hit also on the bansal(102) counter
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(scl,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,scl,1)
WarResetStatus(scl)
if smfj==1 and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
WarAtk(eid,scl,1)
WarResetStatus(scl)
end
if CC.Enhancement and (WarCheckSkill(scl,103) or JY.Item[JY.Person[scl]["ÎäÆ÷"]]["ÌØ¼¼"]==103) and JY.Person[War.Person[scl].id]["±øÁ¦"]>0 then
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
local bzmenu={}
for index=1,JY.BingzhongNum-1 do
 bzmenu[index]={fillblank(JY.Bingzhong[index]["Ãû³Æ"],11),nil,0}
if JY.Bingzhong[index]["ÓĞĞ§"]==1 then
 bzmenu[index][3]=1
end
end
local r=ShowMenu(bzmenu,JY.BingzhongNum-1,8,0,0,0,0,6,1,16,M_White,M_White)
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
wp[wpid]={fillblank(JY.Item[wpid]["Ãû³Æ"],11),nil,0}
if wpid<181 and JY.Item[wpid]["ÀàĞÍ"]>0 then
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
local tmp=JY.MenuPic.num
JY.MenuPic.num=0
while true do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
ReFresh()
local event,x,y=control()
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
menux=16+War.BoxWidth*(War.MX-War.CX)-136
else
menux=16+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=32+War.BoxWidth*(War.MY-War.CY)
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
menux=16+War.BoxWidth*(mx-War.CX)-104-menu_off
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off
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
menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-(16+8+20*math.min(n,8))-menu_off)
local r
if n==0 then
PlayWavE(2)
WarDrawStrBoxWaitKey("„P q „O‚b ‚u‚vG ‚aKLM.",M_White)
return 0
elseif n<=8 then
r=WarShowMenu(m,JY.MagicNum-1,0,menux,menuy,0,0,5,1,16,M_White,M_White)
else
r=WarShowMenu(m,JY.MagicNum-1,8,menux,menuy,0,0,6,1,16,M_White,M_White)
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

function WarMagicMenu_sub(id,r,ItemFlag)
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
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("ƒLG |‚O, ƒ|ƒQ, ƒwƒQ, ƒ{‚Cf*„OS „U„V „P q „OKLM.",M_White)
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
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("ƒLG „W„X, ƒwƒQf*„OS „U„V „P q „OKLM.",M_White)
end
end
elseif kind==3 then--ÂäÊ¯Ïµ
WarDrawStrBoxDelay("„Y„Zƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
WarMagic(id,eid,r,ItemFlag)
if CC.Enhancement and WarCheckSkill(id,119) and JY.Magic[r]["Ğ§¹û·¶Î§"]==11 then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 then
WarMagic(id,eid,r,ItemFlag)
end
end
return true
else
WarDrawStrBoxConfirm("ƒLG „[‚C, ‚UI‚Cf*„OS „U„V „P q „OKLM.",M_White)
end
end
elseif kind==4 then--¼ÙÇé±¨Ïµ
WarDrawStrBoxDelay("ƒLS ‚c‚df ƒE„]ƒjM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==5 then--Ç£ÖÆÏµ
WarDrawStrBoxDelay("ƒLƒP ‚rƒG‚h „^Q „_‚bM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==6 then--¼¤ÀøÏµ
WarDrawStrBoxDelay("‚rƒG„Q‚h ‚}‚DoM.",M_White)
--»Ö¸´·¶Î§ÄÚµÄÊ¿ÆøÖµ²¿¶Ó£®
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==7 then--Ô®ÖúÏµ
WarDrawStrBoxDelay("‚~ƒ}S ‚}‚DoM.",M_White)
--»Ö¸´·¶Î§ÄÚµÄ±øÁ¦²¿¶Ó
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==8 then--¿´»¤Ïµ
WarDrawStrBoxDelay("‚~ƒ}{ ‚rƒG„Q‚h ‚}‚DoM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(true,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
WarMagic(id,eid,r,ItemFlag)
return true
end
elseif kind==9 then--¶¾Ïµ
WarDrawStrBoxDelay("„`ƒm„S ƒLS ‚J‚poM.",M_White)
WarSetAtkFW(id,JY.Magic[r]["Ê©Õ¹·¶Î§"])
local eid=WarSelectAtk(false,JY.Magic[r]["Ğ§¹û·¶Î§"])
if eid>0 and War.Person[eid].live and (not War.Person[eid].hide) then
if WarMagicCheck(id,eid,r) then
WarDrawStrBoxDelay(JY.Magic[r]["Ãû³Æ"].."ƒP „T‚v",M_White)
WarMagic(id,eid,r,ItemFlag)
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
WarMagic(id,eid,r,ItemFlag)
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
WarMagic(id,eid,r,ItemFlag)
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
					sq_hurt=math.modf(sq_hurt*(1+math.random()/10))
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
							if WarCheckSkill(eid,41) then--²¹¸ø
								hurt=math.modf(hurt*(100+JY.Skill[41]["²ÎÊı1"])/100)
							end
						end
					end
					hurt=math.modf(hurt*(1+math.random()/10))
					hurt=limitX(hurt,0,JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])
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
							if WarCheckSkill(eid,41) then--²¹¸ø
								hurt=math.modf(hurt*(100+JY.Skill[41]["²ÎÊı1"])/100)
							end
						end
					end
					hurt=math.modf(hurt*(1+math.random()/10))
					hurt=limitX(hurt,0,JY.Person[id2]["×î´ó±øÁ¦"]-JY.Person[id2]["±øÁ¦"])
					sq_hurt=math.modf(sq_hurt*(1+math.random()/10))
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
					end
					if not (War.Person[wid].enemy) then
						WarAddExp(wid,jy)
						if CC.Enhancement then
							local id1=War.Person[wid].id
							if JY.Person[id1]["ÖÇÁ¦"]<=100 and (not War.Person[wid].enemy) then
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
						if CC.Enhancement and JY.Person[id1]["ÖÇÁ¦"]<=100 and (not War.Person[wid].enemy) then
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
sx=16+War.BoxWidth*(x-War.CX+0.5)-pic_w/2
sy=32+War.BoxDepth*(y-War.CY+1)-pic_h
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
menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off
end
menuy=math.min(32+War.BoxDepth*(my-War.CY)+menu_off,CC.ScreenH-16-112-menu_off)
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
menux=16+War.BoxWidth*(mx-War.CX)-80-menu_off*2
else
menux=16+War.BoxWidth*(mx-War.CX+1)+menu_off*2
end
menuy=math.min(12+War.BoxDepth*(my-War.CY)+menu_off*2,CC.ScreenH-16-132-menu_off*2)
local m={}
for i=1,8 do
local itemid=JY.Person[pid]["µÀ¾ß"..i]
if itemid>0 then
if kind==1 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],11),Item_Use,1}
elseif kind==2 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],11),Item_Send,1}
elseif kind==3 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],11),Item_Scrap,1}
elseif kind==4 then
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],11),Item_Check,1}
else
m[i]={fillblank(JY.Item[itemid]["Ãû³Æ"],11),nil,1}
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
if not WarDrawStrBoxYesNo(string.format('‚^‚_‚h %s(ƒm)„S ƒU„rLM.',JY.Bingzhong[JY.Item[itemid]["Ğ§¹û"]]["Ãû³Æ"]),M_White) then
return 0
elseif JY.Item[itemid]["Ğè±øÖÖ"]>0 and JY.Person[pid]["±øÖÖ"]~=JY.Item[itemid]["Ğè±øÖÖ"] then
PlayWavE(2)
WarDrawStrBoxDelay("„sZ: "..JY.Bingzhong[JY.Item[itemid]["Ğè±øÖÖ"]]["Ãû³Æ"].."£®",M_White)
return 0
elseif JY.Person[pid]["µÈ¼¶"]<JY.Item[itemid]["ĞèµÈ¼¶"] then
PlayWavE(2)
WarDrawStrBoxDelay("‚R‚{G ‚^„RWLM.",M_White)
return 0
else
WarBingZhongUp(War.SelID,JY.Item[itemid]["Ğ§¹û"])
for n=i,7 do
JY.Person[pid]["µÀ¾ß"..n]=JY.Person[pid]["µÀ¾ß"..(n+1)]
end
JY.Person[pid]["µÀ¾ß8"]=0
return 1
end
elseif kind==8 then--ÎäÁ¦ÖÖ
if not WarDrawStrBoxYesNo('Iƒ}„Q‚h ƒi„tLM.',M_White) then
return 0
elseif JY.Person[pid]["ÎäÁ¦"]>=100 then
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
elseif JY.Person[pid]["ÖÇÁ¦"]>=100 then
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
elseif JY.Person[pid]["Í³ÂÊ"]>=100 then
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
function BZSuper(bz1,bz2)
for i=1,9 do
if JY.Bingzhong[bz1]["¿ËÖÆ"..i]==bz2 then
return true--bz1 ¿ËÖÆ bz2
end
end
return false--²»±»¿ËÖÆ
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
if CC.Enhancement and (p1["ÎäÆ÷"]==10 or WarCheckSkill(pid,110)) then--±øÖÖ¿ËÖÆ ×°±¸ÒĞÌì½£ºó±Ø¿ËÖÆ
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
--»ù±¾ÎïÀíÉ±ÉË£½£¨¹¥»÷·½¹¥»÷Á¦£­·ÀÓùÁ¦ĞŞÕıÖµ¡Â2£©¡Á£¨100£­µØĞÎÉ±ÉËĞŞÕı£©¡Â100
local hurt=(atk-def/2)
if CC.Enhancement then
	if (WarCheckSkill(pid,118) or JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==118) then
		hurt=hurt*limitX(100+War.Person[pid].atk_buff-War.Person[eid].def_buff+T[dx],10,200)/100
	else
		hurt=hurt*limitX(100+War.Person[pid].atk_buff-War.Person[eid].def_buff,10,200)/100
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
if flag==1 and not (CC.Enhancement and WarCheckSkill(pid,107)) then--·´»÷£¿--ko fix: hoegyeok(107) keeps full counter damage
hurt=hurt/2
elseif flag==2 or flag==3 then--ÂÒÉä/ÂÒÎè ÉËº¦Í³Ò»ÉèÖÃÎªÕı³£ÉËº¦µÄ40%
hurt=hurt*0.4
end
hurt=math.modf(hurt)
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
if CC.Enhancement and (p1["ÎäÆ÷"]==60 or WarCheckSkill(pid,115)) then--°ÔÍõÖ®½£ ¹¥»÷Ê±±Ø¶¨±©»÷
if WarCheckSkill(eid,23) or WarCheckSkill(eid,43) or WarCheckSkill(eid,47) then--ÓµÓĞ ÌÙ¼× ÀÇ¹Ë Çã¹ú ÌØ¼¼Ê±ÃâÒßÌØĞ§
WarDrawStrBoxDelay('„Q‚X…@ y{^ _‚la‚C ‚kƒtM',M_White)
else
if hurt<p2["±øÁ¦"]*0.4 then
hurt=p2["±øÁ¦"]*0.4
end
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
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
local hurt,sq_hurt,jy,flag2=WarAtkHurt(pid,eid,flag)
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
local n=CC.OpearteSpeed
local d1,d2=WarAutoD(pid,eid)
War.Person[pid].d=d1
WarDelay()
if flag2==2 then
PlayWavE(6)
WarAtkWords(pid)
end
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
for t=8,192,8 do
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
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
WarGetTrouble(eid)
--¹¥ĞÄ ÏÔÊ¾
if CC.Enhancement then
if WarCheckSkill(pid,33) or (War.Person[pid].id==3 and JY.EventID>488 and not GetFlag(38)) then--¹¥ĞÄ öÃIÖ®Õ½ÈôÅÓÍ³Î´ËÀ£¬ÕÅ·É±Ø´¥·¢¸ÃÌØĞ§
if hurt>0 and JY.Person[id1]["±øÁ¦"]<JY.Person[id1]["×î´ó±øÁ¦"] then
local t=16
hurt=math.modf(hurt*JY.Skill[33]["²ÎÊı1"]/100)
hurt=limitX(hurt,1,JY.Person[id1]["×î´ó±øÁ¦"]-JY.Person[id1]["±øÁ¦"])
t=math.min(16,(math.modf(math.max(2,math.abs(hurt)/25))))
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
ReFresh(CC.OpearteSpeed*4)
WarDelay(4)
end
end
end
local flag3=flag2
if flag2==0 then flag3=2 end
if flag2==1 then flag3=1 end
if flag2==2 then flag3=3 end
if CC.Enhancement then
if JY.Person[id2]["Í³ÂÊ"]<=100 and (not War.Person[eid].enemy) then
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
if JY.Person[id1]["ÎäÁ¦"]<=100 and (not War.Person[pid].enemy) then
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
War.ControlEnable=War.ControlEnableOld
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
local pid=GetWarID(id1)
local eid=GetWarID(id2)
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
for t=8,192,8 do
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
for t=8,192,8 do
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
for t=8,192,8 do
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
for t=8,192,8 do
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
"Z…K¡­¡­!", "…L…@¡­¡­!", "ƒm‚M‚M¡­¡­!", "ƒOƒOƒO¡­¡­!", "…C…C…C¡­¡­!",
"ƒm‚M!?", "…M!!", "ƒm‚M‚M!", "…N…O‚wƒv!!", "nG…P!!",
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
v.frame=-1
if v.live then
local id=v.id
if JY.Person[id]["±øÁ¦"]<=0 then
if v.action~=9 then
v.action=5
WarDelay(4)
JY.Death=id
DoEvent(JY.EventID)
JY.Death=0
if v.action~=9 then
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
WarDelay(koAnimD(16))
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
War.MW=12--old game 13
War.MD=9--old game 11
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
local x,y=War.CX,War.CY
lib.FillColor(0,0,0,0,0)
local x0,y0=x,y
local cx,cy=16,32
x0=limitX(x0,0,War.Width)
y0=limitX(y0,0,War.Depth)
local xoff=x-math.modf(x)
local yoff=y-math.modf(y)
lib.SetClip(cx,cy,cx+War.BoxWidth*War.MW,cy+War.BoxDepth*War.MD)
lib.PicLoadCache(0,War.MapID*2,cx-War.BoxWidth*(x-1),cy-War.BoxDepth*(y-1),1)
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
if GetWarMap(x,y,4)==0 then--²»¿ÉÒÆ¶¯
lib.Background(cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),cx+War.BoxWidth*(x-War.CX+1),cy+War.BoxDepth*(y-War.CY+1),128)
end
if GetWarMap(x,y,10)==1 then--¹¥»÷·¶Î§
lib.PicLoadCache(4,261*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
elseif GetWarMap(x,y,10)==2 then--ÖÎÁÆ·¶Î§
lib.PicLoadCache(4,262*2,cx+War.BoxWidth*(x-War.CX),cy+War.BoxDepth*(y-War.CY),1)
end
end
end
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
if v.hurt>=0 then
DrawString(left+size/2-#(v.hurt.."")*5,top,v.hurt,M_White,20)
end
end
end
end
if War.InMap then
local edx,edy=koEdgeDir(War.MX-War.CX,War.MY-War.CY)--ko: scroll arrow, diagonals at the corners
if edx~=0 or edy~=0 then
local pic=CC.koEdgePic[edy*3+edx]
lib.PicLoadCache(4,pic[1]*2,16+War.BoxWidth*(War.MX-War.CX)+pic[2],32+War.BoxDepth*(War.MY-War.CY)+pic[3],1)
end
end
if War.ControlStatus=="select" then
if War.ControlEnable and War.CurID>0 then
DrawStatusMini(War.CurID)
end
elseif War.ControlStatus=="selectAtk" then
if War.ControlEnable then
local eid=GetWarMap(War.MX,War.MY,2)
if eid>0 then
DrawStatusMini(eid)
end
end
elseif War.ControlStatus=="checkDX" then
local menux,menuy
local dx=GetWarMap(War.MX,War.MY,1)
if War.MX-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(War.MX-War.CX)-136
else
menux=16+War.BoxWidth*(War.MX-War.CX+1)
end
if War.MY-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(War.MY-War.CY)-40
else
menuy=32+War.BoxWidth*(War.MY-War.CY)
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
if CC.Enhancement then
lib.PicLoadCache(4,205*2,0,0,1)
else
lib.PicLoadCache(4,205*2,0,0,1)
end
DrawString(381-#War.WarName*16/2/2,8,War.WarName,M_White,16)
if War.Weather<3 then--Çç
lib.PicLoadCache(4,190*2,724,35,1)
elseif War.Weather>3 then--Óê
lib.PicLoadCache(4,192*2,724,35,1)
else--ÔÆ
lib.PicLoadCache(4,191*2,724,35,1)
end
if War.ControlStatus=="select" then
if War.FunButtom==1 then
lib.PicLoadCache(4,57*2,15,7,1)
elseif War.FunButtom==2 then
lib.PicLoadCache(4,58*2,15,7,1)
end
end
DrawStatus()
lib.PicLoadCache(0,200+War.MapID*2,War.MiniMapCX,War.MiniMapCY,1)
for i=1,War.Width do
for j=1,War.Depth do
if GetWarMap(i,j,9)~=0 then
local x=War.MiniMapCX+(i-1)*4
local y=War.MiniMapCY+(j-1)*4
lib.FillColor(x,y,x+4,y+4,M_DarkOrchid)
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
local x=War.MiniMapCX+(v.x-1)*4
local y=War.MiniMapCY+(v.y-1)*4
lib.FillColor(x,y,x+4,y+4,color)
end
end
lib.DrawRect(War.MiniMapCX+(War.CX-1)*4,War.MiniMapCY+(War.CY-1)*4,War.MiniMapCX+(War.CX+War.MW-1)*4,War.MiniMapCY+(War.CY+War.MD-1)*4,M_Yellow)
for i=1,JY.MenuPic.num do
lib.LoadSur(JY.MenuPic.pic[i],JY.MenuPic.x[i],JY.MenuPic.y[i])
end
War.FrameT=War.FrameT+1
if War.FrameT>=32 then
War.FrameT=0
end
War.Frame=math.modf(War.FrameT/8)
end

function DrawStatusMini(id,flag)
flag=flag or false
local pid=War.Person[id].id
local x,y=War.Person[id].x,War.Person[id].y
local bz=JY.Person[pid]["±øÖÖ"]
local menux,menuy
if x-War.CX>math.modf(War.MW/2) then
menux=16+War.BoxWidth*(x-War.CX)-180
else
menux=16+War.BoxWidth*(x-War.CX+1)
end
if y-War.CY>math.modf(War.MD/2) then
menuy=32+War.BoxWidth*(y-War.CY)-32
else
menuy=32+War.BoxWidth*(y-War.CY)
end
lib.Background(menux,menuy,menux+180,menuy+80,160)
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
DrawString(menux,menuy,JY.Person[pid]["ĞÕÃû"],color,16)
DrawString(menux+64,menuy,JY.Bingzhong[bz]["Ãû³Æ"].."¡¡Lv"..JY.Person[pid]["µÈ¼¶"],M_White,16)
local len=120
local T={
100*JY.Person[pid]["±øÁ¦"]/JY.Person[pid]["×î´ó±øÁ¦"],
math.min(100*JY.Person[pid]["Ê¿Æø"]/War.Person[id].sq_limited,100),
100*JY.Person[pid]["¾­Ñé"]/100,
}
local n=2
if flag then
n=3
end
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
if flag then
DrawString(menux,menuy,string.format("ƒ@…U¡¡¡¡ %4d/100",JY.Person[pid]["¾­Ñé"]),M_White,16)
else
local T={[0]="","£«£²£°£¥","£«£³£°£¥","","","","","£«£µ£¥",
"£«£µ£¥","","","","","£«£³£°£¥","£«£±£°£¥","",
"","","","",}
local dx=GetWarMap(x,y,1)
DrawString(menux,menuy,string.format("%s",str,War),color,16)
DrawString(menux+64,menuy,string.format("%s %s",War.DX[dx],T[dx]),M_White,16)

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
DrawString(785+x_off,78,p["ĞÕÃû"].."¡¡"..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"],M_White,size)
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
local y=190
local size=16
local len=90
local T={
{"‚~ ƒ}","‚rƒG„Q","‚J‚pƒ}","„N‚Sƒ}","‚u‚v„Q","ƒ@…U„Q"},
{math.min(100*p["±øÁ¦"]/p["×î´ó±øÁ¦"],100),math.min(p["Ê¿Æø"],100),math.min(p["¹¥»÷"]/20,100),math.min(p["·ÀÓù"]/20,100),math.min(100*p["²ßÂÔ"]/math.max(p["×î´ó²ßÂÔ"],1),100),p["¾­Ñé"]},
{p["±øÁ¦"].."/"..p["×î´ó±øÁ¦"],""..p["Ê¿Æø"],""..p["¹¥»÷"],""..p["·ÀÓù"],p["²ßÂÔ"].."/"..p["×î´ó²ßÂÔ"],""..p["¾­Ñé"]},
}
local x_off=x-785
lib.PicLoadCache(4,230*2,800-48*4,73,1)
lib.PicLoadCache(2,p["Í·Ïñ´úºÅ"]*2,808-48*4,81,1)
lib.PicLoadCache(4,227*2,884-48*4,79,1)
lib.PicLoadCache(4,228*2,884-48*4,109,1)
lib.PicLoadCache(4,229*2,884-48*4,139,1)
DrawString(x,y-size-3,p["ĞÕÃû"].."¡¡"..JY.Bingzhong[p["±øÖÖ"]]["Ãû³Æ"].."Lv"..p["µÈ¼¶"],M_White,size)
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
y=y+size+2
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
y=y+42
DrawString(x,y,string.format("‚J %+03d£¥ „N %+03d£¥",wp.atk_buff,wp.def_buff),M_White,size)
y=y+20
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
War.ControlEnable=War.ControlEnableOld
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
War.Person[wid].atkfw=JY.Skill[45]["²ÎÊı1"]
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
if JY.Item[item]["Ğè±øÖÖ"..n]==p["±øÖÖ"] then
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
p["¹¥»÷"]=math.modf(((4000/math.max(140-p_wuli,30))*(p["µÈ¼¶"]+10)/10+(b["¹¥»÷"]+p["Ê¿Æø"])*(p["µÈ¼¶"]+10)/10)*(100+atk)/100)
p["·ÀÓù"]=math.modf(((4000/math.max(140-p_tongshuai,30))*(p["µÈ¼¶"]+10)/10+(b["·ÀÓù"]+p["Ê¿Æø"])*(p["µÈ¼¶"]+10)/10)*(100+def)/100)
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
else
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
if WarCheckSkill(wid,21) then
	if dx==1 or dx==2 then
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
if dx==6 or dx==13 or dx==14 then
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
if v.atkfw==2 or v.atkfw==3 then
len=2
elseif v.atkfw==4 then
len=3
elseif v.atkfw==5 then
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
WarMagic(id,eid,mid)
if CC.Enhancement and WarCheckSkill(id,119) then
if (JY.Magic[mid]["ÀàĞÍ"]==1 or JY.Magic[mid]["ÀàĞÍ"]==2 or JY.Magic[mid]["ÀàĞÍ"]==3) and JY.Magic[mid]["Ğ§¹û·¶Î§"]==11 then
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
did=eid
BoxBack()
local xsgj=false
if CC.Enhancement and WarCheckSkill(eid,117) then
if JY.Person[War.Person[eid].id]["±øÁ¦"]>0 and (not War.Person[eid].troubled) then
if JY.Bingzhong[War.Person[eid].bz]["¿É·´»÷"]==1 and JY.Bingzhong[War.Person[id].bz]["±»·´»÷"]==1 then
xsgj=true
elseif CC.Enhancement then
if WarCheckSkill(eid,42) then --or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==42 then--·´»÷(ÌØ¼¼)
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
WarAtk(eid,id,1)
WarResetStatus(id)
if CC.Enhancement and WarCheckSkill(eid,106) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then--ko fix: gyeolsa(106) extra hit also on the bansal(102) counter
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
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
--Òıµ¼¹¥»÷
local ydgj=0
if CC.Enhancement and WarCheckSkill(id,109) then
ydgj=2
elseif CC.Enhancement and WarCheckSkill(id,108) then
ydgj=1
end
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
WarAtk(eid,id,1)
WarResetStatus(id)
if CC.Enhancement and WarCheckSkill(eid,106) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then--ko fix: gyeolsa(106) extra hit also on the bansal(102) counter
WarAtk(eid,id,1)
WarResetStatus(id)
end
elseif CC.Enhancement and (WarCheckSkill(eid,19) or JY.Item[JY.Person[eid]["ÎäÆ÷"]]["ÌØ¼¼"]==19) then--±¨¸´
if math.random(100)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(id,eid,1)
WarResetStatus(eid)
end
end
else
if math.random(150)<=JY.Person[War.Person[eid].id]["ÎäÁ¦2"] then
--ÕÉ°ËÉßÃ¬
local smfj=0
if CC.Enhancement and WarCheckSkill(eid,106) then
smfj=1
end
--ko fix: counter always passes flag=1; hoegyeok(107) is exempted from the halving inside WarAtkHurt
WarAtk(eid,id,1)
WarResetStatus(id)
if smfj==1 and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
WarAtk(eid,id,1)
WarResetStatus(id)
end
if CC.Enhancement and WarCheckSkill(id,103) and JY.Person[War.Person[id].id]["±øÁ¦"]>0 then
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
sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["Ê¿Æø"])
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
sv=limitX(sv,0,War.Person[oid].sq_limited-JY.Person[id2]["Ê¿Æø"])
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
break
else
JY.Status=GAME_WARLOSE
break
end
end
end
if enum==0 and JY.Status==GAME_WMAP then
JY.Status=GAME_WARWIN
end
War.ControlEnableOld=War.ControlEnable
War.ControlEnable=false
War.InMap=false
if DoEvent(JY.EventID) then
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN then
DoEvent(JY.EventID)
end
end
War.ControlEnable=War.ControlEnableOld
end
end

--WarDelay(n)
-- ÑÓÊ±£¬²¢Ë¢ĞÂÕ½³¡
-- nÄ¬ÈÏÎª1
function WarDelay(n)
 n=n or 1
for i=1,n do
JY.ReFreshTime=lib.GetTime()
DrawWarMap(War.CX,War.CY)
lib.GetKey()
ReFresh()
end
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
hp_skill_flag=true
end
if WarCheckSkill(i,2) or JY.Item[JY.Person[War.Person[i].id]["ÎäÆ÷"]]["ÌØ¼¼"]==2 then--ÊÕÊ°
	hp_skill_flag=true
	sp_skill_flag=true
end
if WarCheckSkill(i,20) or JY.Item[JY.Person[War.Person[i].id]["ÎäÆ÷"]]["ÌØ¼¼"]==20 then--³Á×Å
sp_skill_flag=true
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
hp_times=hp_times+1
end
if sp_skill_flag then
sp_times=sp_times+1
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

function ESCMenu(kx,ky)--ko: kx,ky = menu position (the top-left button drops it under itself; right-click keeps 64,64)
PlayWavE(0)
local menu={
{"pTU",nil,1},
{"‚B‚T‚nR",nil,1},
{"‚B‚T…C…D",nil,0},
{"tuvw",nil,1},
{"ƒGƒMEF",nil,1},
{"¡¡…d…e[ƒG",nil,1},
{"¡¡…fƒa",nil,1},
{"QRTU",nil,1},
{"¡¡Debug ",nil,0},
}
local file=io.open(CONFIG.CurrentPath .. "Menu.debug")
if(file) then
menu[9][3]=0
end
if JY.Person[1]["ÃØ¼¼1"]==1 then
	menu[3][3]=1
	menu[6][3]=0
	menu[7][3]=0
end
if kx then JY.koMenuClose={16,8,79,23} end--ko: opened from the top-left button: clicking it again closes the menu
local r=WarShowMenu(menu,#menu,0,kx or 64,ky or 64,0,0,1,1,16,M_White,M_White)
JY.koMenuClose=nil
WarDelay(CC.WarDelay)
if r==1 then
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
elseif r==3 then --È«¾ü³·ÍË
	if fileexist(CC.R_GRPFilename[6]) then
		WarIni2() --Çå³ıµ±Ç°Õ½³¡ÉÏËùÓĞµĞ¾ü
		War.SelID=0--Çå³ı¹â±êÖ¸ÏòµÄÈËÎïid
		War.CurID=0--Çå³ıµ±Ç°ĞĞ¶¯ÈËid
		War.LastID=0--Çå³ıÉÏÒ»¸ö±»¹â±êÖ¸ÏòµÄÈËÎïid
		
		NextEvent(JY.Base["È«¾ü³·ÍË"])--ÖØĞÂÖ´ĞĞ±¾´ÎÕ½³¡ÊÂ¼ş
		rl_flag=1					
		LoadRecord(6)
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
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,136,"…d…eƒi ƒG…lS …m…naƒoZ",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="…i …j…k" then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚W ƒG…lS …d…e…oLM. ƒJƒKKLY?",s2),M_White) then
if koSaveCompat(s2) then LoadRecord(s2) end
end
else
WarDrawStrBoxConfirm("…hGƒh^ ‚aKLM",M_White,true)
end
end
elseif r==7 then--´¢´æ
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,136,"‚SƒZf …fƒaXYZ?",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚Wf …fƒaWLM. ƒJƒKKLY?",s2),M_White) then
WarSave(s2)
end
end
elseif r==8 then
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
WarDelay(CC.WarDelay)
JY.Status=GAME_END
end
elseif r==9 then
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

--ko 3.1: ë°°ì†Â·ë°°ìœ¨Â·ì—°ì¶œÂ·ëŒ€í™” (ìˆœì • mode), shared with the ìœ ê´‘íŒ in ko_settings.lua. Only these four lines are touched
function koAnimD(n)
return math.max(1,math.floor(n/(CC.koAnim or 1)))
end
function koAutoMs(n)
local a=CC.koAuto or 0
if a==1 then return 2000+n*80 elseif a==2 then return 1200+n*50 elseif a==3 then return 600+n*25 end
return -1
end
function koSettingsRead()
CC.koScale=0 CC.koAnim=1 CC.koAuto=0
local h=io.open(CONFIG.CurrentPath.."ko_settings.lua","r")
if not h then return end
local s=h:read("*a") h:close()
local v
v=tonumber(string.match(s,"CC%.koScale=(%d+)")) if v then CC.koScale=v end
v=tonumber(string.match(s,"CC%.FrameNum=(%d+)")) if v then CC.FrameNum=v end
v=tonumber(string.match(s,"CC%.koAnim=(%d+)")) if v then CC.koAnim=v end
v=tonumber(string.match(s,"CC%.koAuto=(%d+)")) if v then CC.koAuto=v end
end
function koSettingsWrite()
local p=CONFIG.CurrentPath.."ko_settings.lua"
local h=io.open(p,"r")
local s=h and h:read("*a") or ""
if h then h:close() end
for _,kv in ipairs({{"koScale",CC.koScale or 0},{"FrameNum",CC.FrameNum},{"koAnim",CC.koAnim or 1},{"koAuto",CC.koAuto or 0}}) do
local n
s,n=string.gsub(s,"CC%."..kv[1].."=%d+","CC."..kv[1].."="..kv[2])
if n==0 then s="CC."..kv[1].."="..kv[2].."\n"..s end
end
h=io.open(p,"w")
if h then h:write(s) h:close() end
end
function koSetScale(v)
if not CONFIG.Windows then return end--android: no ko_sdl.dll, the phone scales the screen itself
CC.koScale=v
koSettingsWrite()
Config()
PicCatchIni()
end
function SettingMenu() --¹¦ÄÜÉè¶¨
local x,y,w,h
local size=16
local sig
w=320
h=128+128+20--ko 3.1: room for ë°°ì†Â·ë°°ìœ¨Â·ì—°ì¶œÂ·ëŒ€í™”
local notWar=true
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x=16+(576-0)/2
y=32+(432-0)/2
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
local y1=y+92+128+20
local y2=y1+24
local function button(bx,by,str,flag)
local box_w=36
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
else
end
lib.PicLoadCache(4,80*2,x,y,1)
do--ko 3.1: the box middle tiled from rows 28..88 of the picture (its OK button sits below row 92)
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
DrawStr(x+16,y+160,"\134\099\133\123",M_White,size)--ko 3.1: ë°°ì† (1ë°° = 35, the ìœ ê´‘íŒ baseline; the ìˆœì • default 40 shows as 1ë°°)
local koSpd={35,23,17,12}
local koLab={"\049\134\099","\049\046\053\134\099","\050\134\099","\051\134\099"}
for koI=1,4 do
button(x+80+(koI-1)*38,y+160,koLab[koI],CC.FrameNum==koSpd[koI] or (koI==1 and CC.FrameNum>35))
end
DrawStr(x+16,y+180,"\134\099\137\104",M_White,size)-- ë°°ìœ¨
if CONFIG.Windows then
local koLab2={"\136\097\131\071","1.5","2","\130\066\133\114"}
local koVal2={0,1,2,4}
for koJ=1,4 do
button(x+80+(koJ-1)*38,y+180,koLab2[koJ],(CC.koScale or 0)==koVal2[koJ])
end
else button(x+80,y+180,"\133\120\130\108",true) end--android: the device scales the screen itself; nothing to pick
DrawStr(x+16,y+200,"\133\066\133\098",M_White,size)-- ì—°ì¶œ
local koLab3={"1\134\099","2\134\099","4\134\099"}
local koVal3={1,2,4}
for koK=1,3 do
button(x+80+(koK-1)*38,y+200,koLab3[koK],(CC.koAnim or 1)==koVal3[koK])
end
DrawStr(x+16,y+220,"\130\095\129\064",M_White,size)-- ëŒ€í™”
local koLab4={"\129\113\130\108","\134\115\130\079","\131\115\132\119","\131\069\138\075"}
for koL=1,4 do
button(x+80+(koL-1)*38,y+220,koLab4[koL],(CC.koAuto or 0)==koL-1)
end
DrawString(x+16,y+16,"ƒGƒMEF",C_Name,size)
DrawStr(x+16,y+40,"‚M…v",M_White,size)
for i,v in pairs(T) do
if math.modf(CC.MusicVolume/20)==i then
button(x+80+i*38,y+40,v,true)
else
button(x+80+i*38,y+40,v,false)
end
end
DrawStr(x+16,y+60,"y{‚M",M_White,size)
for i,v in pairs(T) do
if math.modf(CC.SoundVolume/10)==i then
button(x+80+i*38,y+60,v,true)
else
button(x+80+i*38,y+60,v,false)
end
end
DrawStr(x+16,y+80,"‚Z…w",M_White,size)

if notWar then	
	if JY.Person[1]["ÃØ¼¼1"]==0 then
		ptlv=limitX(math.modf(pjlv()/10),0,3)
		button(x+80+1*38,y+80,"ƒs„w",true)
		button(x+80+2*38,y+80,"D‚B",false)
		button(x+80,y+80,"+"..ptlv,false)		
	else
		button(x+80+1*38,y+80,"ƒs„w",false)
		button(x+80+2*38,y+80,"D‚B",true)
		button(x+80+3*38,y+80,"+"..JY.Person[1]["·ÜÕ½"],true)
	end
end
if notWar then
--ko font row removed (Korean build uses one font)
DrawStr(x+16,y+120,"ƒL‚T …b‚p",M_White,size)
if JY.Base["µĞ¾ü³ö»÷"]>0 then
button(x+80+1*38,y+120,"…z",true)
button(x+80+2*38,y+120,"…u",false)
else
button(x+80+1*38,y+120,"…z",false)
button(x+80+2*38,y+120,"…u",true)
end
else
DrawStr(x+16,y+100,"G‚l ^…{",M_White,size)
if CC.MoveSpeed==1 then
button(x+80+1*38,y+100,"…z",true)
button(x+80+2*38,y+100,"…u",false)
else
button(x+80+1*38,y+100,"…z",false)
button(x+80+2*38,y+100,"…u",true)
end
DrawStr(x+16,y+120,"‚u‚v …B…b",M_White,size)
if CC.cldh==1 then
button(x+80+1*38,y+120,"…z",true)
button(x+80+2*38,y+120,"…u",false)
else
button(x+80+1*38,y+120,"…z",false)
button(x+80+2*38,y+120,"…u",true)
end
DrawStr(x+16,y+140,"‚B„e ‚_‚r",M_White,size)
if CC.zdby==0 then
button(x+80+1*38,y+140,"…z",true)
button(x+80+2*38,y+140,"…u",false)
else
button(x+80+1*38,y+140,"…z",false)
button(x+80+2*38,y+140,"…u",true)
end
end
if flag==1 then
lib.PicLoadCache(4,56*2,x1,y1,1)
end
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
return
else
current=0
for i=0,5 do
if MOUSE.CLICK(x+80+i*38,y+40,x+80+i*38+36,y+40+16) then
CC.MusicVolume=20*i
Config()
PicCatchIni()
PlayWavE(0)
break
elseif MOUSE.CLICK(x+80+i*38,y+60,x+80+i*38+36,y+60+16) then
CC.SoundVolume=10*i
Config()
PicCatchIni()
PlayWavE(0)
break
end
end
do--ko 3.1: ë°°ì†Â·ë°°ìœ¨Â·ì—°ì¶œÂ·ëŒ€í™” buttons
local koSpd={35,23,17,12}
for koI=1,4 do if MOUSE.CLICK(x+80+(koI-1)*38,y+160,x+80+(koI-1)*38+36,y+160+16) then CC.FrameNum=koSpd[koI] koSettingsWrite() PlayWavE(0) end end
for koJ=1,4 do if MOUSE.CLICK(x+80+(koJ-1)*38,y+180,x+80+(koJ-1)*38+36,y+180+16) then koSetScale(({0,1,2,4})[koJ]) PlayWavE(0) end end
for koK=1,3 do if MOUSE.CLICK(x+80+(koK-1)*38,y+200,x+80+(koK-1)*38+36,y+200+16) then CC.koAnim=({1,2,4})[koK] koSettingsWrite() PlayWavE(0) end end
for koL=1,4 do if MOUSE.CLICK(x+80+(koL-1)*38,y+220,x+80+(koL-1)*38+36,y+220+16) then CC.koAuto=koL-1 koSettingsWrite() PlayWavE(0) end end
end
local tzlv
local tzlvmenu={}
for i=1,5 do
	tzlvmenu[i]={fillblank("+"..i,11),nil,1}
end
if MOUSE.CLICK(x+80+1*38,y+80,x+80+1*38+36,y+80+16) and notWar then
	ptlv=limitX(math.modf(pjlv()/10),0,3)
	JY.Person[1]["ÃØ¼¼1"]=0
	button(x+80,y+80,"+"..ptlv,false)	
	PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+80,x+80+2*38+36,y+80+16) and notWar then
	if JY.Person[1]["ÃØ¼¼1"]==0 then
		JY.Person[1]["ÃØ¼¼1"]=1
		button(x+80+3*38,y+80,"+"..JY.Person[1]["·ÜÕ½"],true)
	else
		tzlv=ShowMenu(tzlvmenu,5,5,0,156,0,0,5,1,16,M_White,M_White)
		if tzlv<=0 then
			return
		else
			JY.Person[1]["·ÜÕ½"]=tzlv
			button(x+80+3*38,y+80,"+"..JY.Person[1]["·ÜÕ½"],true)			
		end
	end
	PlayWavE(0)
elseif MOUSE.CLICK(x+80+3*38,y+80,x+80+3*38+36,y+80+16) and notWar then
	if JY.Person[1]["ÃØ¼¼1"]==1 then
		tzlv=ShowMenu(tzlvmenu,5,5,0,156,0,0,5,1,16,M_White,M_White)
		if tzlv<=0 then
			return
		else
			JY.Person[1]["·ÜÕ½"]=tzlv
			button(x+80+3*38,y+80,"+"..JY.Person[1]["·ÜÕ½"],true)			
		end
	end
elseif MOUSE.CLICK(x+80+1*38,y+100,x+80+1*38+36,y+100+16) then
	if notWar then
	--ko font row removed
else
	CC.MoveSpeed=1
end
if not notWar then PlayWavE(0) end
elseif MOUSE.CLICK(x+80+2*38,y+100,x+80+2*38+36,y+100+16) then
if notWar then
--ko font row removed
else
CC.MoveSpeed=0
end
if not notWar then PlayWavE(0) end
elseif MOUSE.CLICK(x+80+1*38,y+120,x+80+1*38+36,y+120+16) then
if notWar then
JY.Base["µĞ¾ü³ö»÷"]=1
else
CC.cldh=1
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+120,x+80+2*38+36,y+120+16) then
if notWar then
JY.Base["µĞ¾ü³ö»÷"]=0
else
CC.cldh=0
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+1*38,y+140,x+80+1*38+36,y+140+16) then
if notWar then
else
CC.zdby=0
end
PlayWavE(0)
elseif MOUSE.CLICK(x+80+2*38,y+140,x+80+2*38+36,y+140+16) then
if notWar then
else
CC.zdby=1
end
PlayWavE(0)
end
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
local id=JY.Person[pid]["´úºÅ"]
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
elseif id==391 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7620
elseif id==392 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7120
elseif id==393 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=7170
elseif id==394 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8470
elseif id==395 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8570
elseif id==396 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=8020
elseif id==397 then
JY.Person[pid]["Õ½¶·¶¯×÷"]=5420
elseif id==398 then
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
end
return JY.Person[pid]["Õ½¶·¶¯×÷"]
end

function FightMenu()
local T={ 5,3,387,2,54,68,
190,385,17,170,98,
391,392,393,394,395,396,397,398,
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
404,405,382,406,
}
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

DrawYJZBox(32,32,"ƒGƒM",M_White,true)
local r=ShowMenu(menu,5,0,0,0,0,0,3,1,16,M_White,M_White)
lib.Delay(100)
if r==1 then
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
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
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"…d…eƒi ƒG…lS …m…naƒoZ",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="…i …j…k" then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚W ƒG…lS …d…e…oLM. ƒJƒKKLY?",s2),M_White,true) then
if koSaveCompat(s2) then LoadRecord(s2) end
end
else
WarDrawStrBoxConfirm("…hGƒh^ ‚aKLM",M_White,true)
end
end
elseif r==3 then
local menu2={
{" 1. ",nil,1},
{" 2. ",nil,1},
{" 3. ",nil,1},
{" 4. ",nil,1},
{" 5. ",nil,1},
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
DrawYJZBox2(-1,104,"‚SƒZf …fƒaXYZ?",M_White)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
if between(s2,1,5) then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚Wf …fƒaWLM. ƒJƒKKLY?",s2),M_White,true) then
SaveRecord(s2)
end
end
elseif r==4 then
SettingMenu()--¹¦ÄÜÉè¶¨
elseif r==5 then
end
return false
end

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
if string.len(SectionName)<22 then
SectionName=string.format(string.format("%%s%%%ds",22-string.len(SectionName)),SectionName,"")..string.format("d%02dp",turn,maxturn)
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
HirePerson()
end
elseif MOUSE.CLICK(713,321,750,366) then
PlayWavE(0)
Person_Menu()
elseif MOUSE.CLICK(673,369,710,414) then
Shop()
elseif MOUSE.CLICK(713,369,750,414) then
SystemMenu()
elseif MOUSE.CLICK(680,24,742,102) then
JY.LLK_N=JY.LLK_N+1
if JY.LLK_N>49 then
PlayWavE(0)
if WarDrawStrBoxYesNo("…~„}g ‚X‚Y ‚Z…whLM.*N‚] †@{f ‚S†A ‚uRD ‚C‚C ‚kƒm†B,*Gf ‚_o …ZƒPfD †Ca‚C ‚kKLM. ƒJƒKKLY?",M_White,true) then--¿ÉÒÔ½øÈëÃüÁî¼üÈëÒ°£é×´Ì¬Âğ£¿
local mj=0
if CC.Enhancement==false then
mj=1
end
if mj==1 then
JY.Base["»Æ½ğ"]=9999
JY.Person[1]["µÈ¼¶"]=99
JY.LLK_N=0
elseif mj==0 then
Game_Cycle()
end
else
JY.LLK_N=50
end
end
end
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
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

function DrawGameStatus()
DrawString(680,142,"ƒg",M_Navy,16)
DrawString(680,182,"‚R‚{",M_Navy,16)
DrawString(680,222,"Iƒa",M_Navy,16)
DrawString(680,262,"rs‚C",M_Navy,16)
DrawString(740-#(""..(JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]))*16/2, 160,(JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]),M_White,16)
DrawString(740-#(""..JY.Person[1]["µÈ¼¶"])*16/2,200,JY.Person[1]["µÈ¼¶"],M_White,16)
DrawString(740-#(""..JY.Base["Îä½«ÊıÁ¿"])*16/2, 240,JY.Base["Îä½«ÊıÁ¿"],M_White,16)
DrawString(740-#JY.Base["ÏÖÔÚµØ"]*16/2, 280,JY.Base["ÏÖÔÚµØ"],M_White,16)
local str_mode
if JY.Person[1]["ÃØ¼¼1"]==0 then
	str_mode="ƒs„w ‚Z…w"
else
	str_mode="D‚B ‚qGD "..JY.Person[1]["·ÜÕ½"]
end
local str_len=string.len(JY.Base["ÕÂ½ÚÃû"])+10
local str_space=""
for i=1,(38-str_len-1) do
	str_space=str_space.." "
end
DrawString(18+6,434+6,JY.Base["ÕÂ½ÚÃû"]..str_space..str_mode,M_White,16)
if JY.Tid>0 then
DrawString(330+6,434+6,JY.Person[JY.Tid]["ĞÕÃû"],M_White,16)
end
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
JY.Status=GAME_START
end
if id>9999 then
os.exit()
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
Password()
LoadRecord(0)
for i=1,JY.PersonNum-1 do
GetPic(i)
end
while true do
if JY.Status==GAME_START then
StopBGM()
YJZMain_sub()
elseif JY.Status==GAME_SMAP_AUTO then
if saveflag then
Dark()
saveflag=false
lib.FillColor(0,0,0,0,0)
if not CC.koReplay then RemindSave(2) else Light() end--ko: no save prompt after a replay-mode battle (Light: RemindSave used to undo Dark() via its prompt; without it the title menu came up on a black screen)
end
DoEvent(JY.EventID)
elseif JY.Status==GAME_SMAP_MANUAL then
SMapEvent()
elseif JY.Status==GAME_MMAP then
elseif JY.Status==GAME_WMAP then
Dark()
saveflag=true
WarStart()
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
os.exit()
end
end
end

function YJZMain_sub()
CC.koReplay=nil
-- ko 2.0: black title screen fix. Coming back to the title after Dark() (battle lost, duel mode, replay end),
-- ShowMenu drew the title art and menu while the screen was still faded out and the fade-in inside its first
-- ReFresh left the surface black (or tinted). At startup LoadRecord(0)->Config() recreated the window in between,
-- which hid the problem. Draw the title art and fade in first, then let ShowMenu redraw it normally.
if JY.Dark then
lib.PicLoadCache(4,264*2,0,0,1)
Light()
end
local menu={
{"¡¡ †D QR ‚VJ",nil,1},
{"¡¡¡¡…fƒa …d…e[ƒG",nil,1},
{"¡¡¡¡ƒGƒM EF",nil,1},
{"¡¡¡¡‚Bƒa sr",nil,1},
{"¡¡¡¡IƒH ‚_‚}",nil,1},
{"¡¡¡¡iƒa",nil,1},--ko 3.1: í™•ì¥
{"¡¡„{†Eu ƒsƒG",nil,1},
{"¡¡¡¡QR TU",nil,1},
}
menu[4][3]=0--ko 3.1: ì „ì¥ ì¬í˜„ removed, ììœ  ì „íˆ¬ replaces it
menu[5][3]=0--ko 3.1: ìˆœì • mode keeps the duel-mode row hidden as the original did
lib.FillColor(0,0,0,0)
Light()--ko: a battle ends with Dark(); without this the title came up on a black screen when nothing else faded back in (replay win/loss)
lib.Delay(200)
local s=ShowMenu(menu,8,0,0,0,0,0,2,0,16,M_White,M_White)
if s==1 then
LoadRecord(0)
JY.Base["ÕÂ½ÚÃû"]=""
local menux={
{"¡¡¡¡†F†G‚y ‚Z…w",nil,1},
{"¡¡¡¡T†H ‚Z…w",nil,1},
}
local ss=ShowMenu(menux,2,0,0,0,0,0,2,0,16,M_White,M_White)
if ss==1 then
JY.Base["ÓÎÏ·Ä£Ê½"]=0
if not SaveRecord(6) then return end
LoadRecord(6)-- ¶ÁÈ¡ÓÎÏ·½ø¶È
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
elseif ss==2 then
JY.Base["ÓÎÏ·Ä£Ê½"]=1
if not SaveRecord(6) then return end
LoadRecord(6)-- ¶ÁÈ¡ÓÎÏ·½ø¶È
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
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
}
for id=1,5 do
if not fileexist(CC.R_GRPFilename[id]) then
menu2[id][1]=menu2[id][1].."…i …j…k"
else
menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
end
end
CC.koMenuHeader={128,"…d…eƒi ƒG…lS …m…naƒoZ"}--ko: drawn inside ShowMenu (title redraw used to erase it)
local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
CC.koMenuHeader=nil
if between(s2,1,5) then
if string.sub(menu2[s2][1],5)~="…i …j…k" then
if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚W ƒG…lS …d…e…oLM. ƒJƒKKLY?",s2),M_White,true) then
if koSaveCompat(s2) then LoadRecord(s2) end
end
else
WarDrawStrBoxConfirm("…hGƒh^ ‚aKLM",M_White,true)
end
end
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
JY.Person[5]["¾ıÖ÷"]=5--ko: replay: Lu Bu leads his own force (the enemy tab showed his old lord, Dong Zhuo)
JY.Base["ÊÂ¼ş333"]=30
JY.Person[1]["µÈ¼¶"]=99
JY.Person[2]["µÈ¼¶"]=99
JY.Person[3]["µÈ¼¶"]=99
JY.Base["»Æ½ğ"]=10000
elseif s==5 then
PlayBGM(18)
FightMenu()
elseif s==6 then--ko 3.1: í™•ì¥
koExtScreen()
Dark()
elseif s==7 then
lib.PicLoadFile(CC.EFT[1],CC.EFT[2],6)
PlayBGM(2)
local cx,cy=(CC.ScreenW-640)/2,(CC.ScreenH-480)/2
for picid=0,1236 do
JY.ReFreshTime=lib.GetTime()
lib.PicLoadCache(6,picid*2,cx,cy,1)
ReFresh(8)
local eventtype=lib.GetMouse(1)
local koKe=lib.GetKey(1)
if koKe==0 then koExitAsk() end
if eventtype==1 or eventtype==3 or koKe==1 or koKe==3 then
Dark()
lib.Delay(1000)
break
end
end
PicCatchIni()
elseif s==8 then
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
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
return newstr,num
end

function DrawMulitStrBox(str,color,size)--ÏÔÊ¾¶àĞĞ¾çÇé
local x,y=145,250
if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
x,y=113,298
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

function talk(...)
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
talk_sub(arg[i*2+1],arg[i*2+2],true,i%2+f)
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
s=GenTalkString(s,talkxnum)
if CONFIG.KeyRepeat==0 then
lib.EnableKeyRepeat(0,CONFIG.KeyRepeatInterval)
end
local size=16
local headid=JY.Person[id]["Í·Ïñ´úºÅ"]
local startp=1
local endp
local dy=0
local koPC=0 local koT0=0 local koW=-1--ko 3.1: ëŒ€í™” ìë™ ë„˜ê¹€ (ê¸€ì ìˆ˜ë¡œ ì‹œê°„ì„ ì •í•¨)
local sid
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
if koKe==0 then koExitAsk() end
if eventtype==1 or eventtype==3 or koKe==1 or koKe==3 then
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
if koKe==0 then koExitAsk() end
if eventtype==1 or eventtype==3 or koKe==1 or koKe==3 then
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

function Person_Menu()
local menu={
{" Iƒa Fƒs",nil,1},
{" D‚w „W†I",nil,1},
{" ƒT„h Fƒx",nil,1},
{" †J‚s†K‚X",nil,1},
{" ‚s‚J†KƒA",nil,1},
{" †L†M qƒx",nil,1},
}
DrawYJZBox(32,32,"Iƒa",M_White,true)
 
local r=ShowMenu(menu,6,0,546,264,0,0,4,1,16,M_White,M_White)
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
	--if CC.Enhancement==false then
	--	Maidan(1)
	--else
	--	Maidan2(1)
	--end
	
end
end

function test()
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
	if maxattr<=99-i*5 then
		sktypemenu[i+1][3]=1
	end
end
local sktype=ShowMenu(sktypemenu,7,0,0,140,0,0,3,1,16,M_White,M_White)
if sktype<=0 then
	return
end
final_cost=base_cost*(1+(sktype-1)*base_rate)
if sktype==1 then	
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
	if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
talk(369,"IƒG‚h ‚C†m IƒaS …m…naƒoZ")
if personnum<=10 then
	r=ShowMenu(personmenu,JY.PersonNum-1,10,0,156,0,0,5,1,16,M_White,M_White)
else
	r=ShowMenu(personmenu,JY.PersonNum-1,8,0,156,0,0,6,1,16,M_White,M_White)
end

if r<=0 then
	return
end
talk(369,"‚KvX IƒG‚h …m…naƒoZ")
for i=1,8 do
	if JY.Person[r]["µÀ¾ß"..i]>0 then
		imenu[i]={fillblank(JY.Item[JY.Person[r]["µÀ¾ß"..i]]["Ãû³Æ"],11),nil,1}
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
if between(JY.Person[r]["µÀ¾ß"..iid],74,139)  then
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
			if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
			if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<final_cost then
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
			JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]=zzid		
			UseMoney(final_cost)	
			talk(369,"ƒGƒH ‚tƒ@G †lU„C„kKLM.")
		end
	else
		if JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]==0 then
			talk(369,"‚C…[ xƒG^ ‚aKLM")
			return
		else
			tjid={7,11,14,20,21,24,25}
			for i=1,7 do
				if JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]==tjid[i] then
					return_gold=base_cost*0.95
					if WarDrawStrBoxYesNo("xƒG d†E: "..JY.Skill[JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]]["Ãû³Æ"]..", ‚P„oƒP 95£¥ †I†P "..return_gold.."ƒg.",M_White,true) then
						talk(369,"d†E †lU: "..JY.Skill[JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]]["Ãû³Æ"])
						JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]=0				
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
					JY.Item[JY.Person[r]["µÀ¾ß"..iid]]["ÌØ¼¼"]=0
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
menu[i]={fillblank(JY.Person[i]["ĞÕÃû"],11),PersonStatus,1}
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
x=16+(576-456)/2
y=32+(432-276)/2
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
for i=1,8 do
local iid=JY.Person[pid]["µÀ¾ß"..i]
if iid>0 then
if MOUSE.CLICK(x+340,y+112+i*16,x+340+#JY.Item[iid]["Ãû³Æ"]*16/2,y+112+(i+1)*16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
end
end
end
for i,v in pairs({"ÎäÆ÷","·À¾ß","¸¨Öú"}) do
local iid=JY.Person[pid][v]
if iid>0 then
if MOUSE.CLICK(x+184+16*4,y+183+i*21,x+184+16*4+#JY.Item[iid]["Ãû³Æ"]*16/2,y+183+i*21+16) then
PlayWavE(0)
DrawItemStatus(iid,pid)--ÏÔÊ¾ÎïÆ·ÊôĞÔ
end
end
end
if MOUSE.CLICK(x+24,y+24,x+24+64,y+24+80) then
local name=p["ĞÕÃû"]
if type(CC.LieZhuan[name])=='string' then
DrawLieZhuan(name)--ÏÔÊ¾ÁĞ´«
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
local cy=y+220+box_h*math.modf((i-1)/3)
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

function PersonStatus_sub(pid,x,y,flag)
flag=flag or 0
x=x or 208
y=y or 72
ReSetAttrib(pid,false)
JY.Person[pid]["Õ½¶·¶¯×÷"]=GetPic(pid,false,false)
lib.PicLoadCache(4,85*2,x,y,1)
local p=JY.Person[pid]
local b=JY.Bingzhong[p["±øÖÖ"]]
DrawString(x+135-#p["ĞÕÃû"]*16/4,y+20,p["ĞÕÃû"],M_White,16)
DrawString(x+184,y+20,p["µÈ¼¶"].."‚R‚{".."£¨"..p["¾­Ñé"].."£¥£© "..b["Ãû³Æ"],M_White,16)
lib.Background(x+184-4,y+48,x+184+16*16+4,y+120,192)
lib.SetClip(x+180,y+48,x+448,y+120)
if CC.Enhancement then
DrawStr(x+184,y+48+8,GenTalkString("‚s‚^: "..JY.Skill[p["Ìì¸³"]]["Ãû³Æ"].."*"..JY.Skill[p["Ìì¸³"]]["ËµÃ÷"],16),M_White,16)
else
DrawStr(x+184,y+48+8,GenTalkString(b["ËµÃ÷"],16),M_White,16)
end
lib.SetClip(0,0,0,0)
lib.PicLoadCache(2,p["Í·Ïñ´úºÅ"]*2,x+24,y+24,1)
lib.PicLoadCache(1,(p["Õ½¶·¶¯×÷"]+19)*2,x+111,y+55,1)
DrawString(x+184,y+120,"‚~ ƒ}¡¡¡¡"..p["×î´ó±øÁ¦"],M_White,16)
DrawString(x+184,y+141,"‚J‚pƒ}¡¡ "..p["¹¥»÷"],M_White,16)
DrawString(x+184,y+162,"„N‚Sƒ}¡¡ "..p["·ÀÓù"],M_White,16)
DrawString(x+184,y+183,"G‚lƒ}",M_White,16)
if b["ÒÆ¶¯"]==p["ÒÆ¶¯"] then
DrawString(x+184+16*4,y+183,"¡¡"..b["ÒÆ¶¯"],M_White,16)
else
DrawString(x+184+16*4,y+183,string.format("%d(%+d)",p["ÒÆ¶¯"],p["ÒÆ¶¯"]-b["ÒÆ¶¯"]),M_White,16)
end
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
local len=100
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
lib.SetClip(x+44,y+87+i*32,x+44+math.max(1,len*v1/100),y+87+10+i*32)
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
lib.SetClip(x+44,y+95+i*32,x+44+math.max(1,len*v1/100),y+95+10+i*32)
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
local kind={[0]="‚a‚M","‚J‚p„o","‚}‚D„o","‚t†I„o","ƒsƒA","‚~ƒW","‚X…X","‚}‚D„o","ƒT„h","ƒT„h","ƒT„h","ÎäÆ÷","·À¾ß","…X„y","‚a‚M",}
local titlestr="‚S†s IƒaƒP D‚w‚h „W†IXYZ? …m…naƒoZ."
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["ĞÕÃû"]
local hp=string.format("% 5d",JY.Person[pid]["×î´ó±øÁ¦"])
local lv=string.format("% 5d",JY.Person[pid]["µÈ¼¶"])
local picid
if TeamSelect.status[idx]==0 then--Î´Ñ¡ÔñÊ±£¬Îª+19
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
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
DrawString(562,176+i*18,"£¯"..kind[JY.Item[tid]["ÀàĞÍ"]],color,16)
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
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
Dark()
lib.Delay(1000)
os.exit()--ko fix: the selection loop ignores JY.Status, so leave here
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
local idx=num_per_page*(page-1)+i
if idx<=num then
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
if WarDrawStrBoxYesNo("…H‚b ‚r†v: "..JY.Person[cid]["ĞÕÃû"]..". ƒJƒKKLY?",M_White,true) then
for n=iid,7 do
JY.Person[oid]["µÀ¾ß"..n]=JY.Person[oid]["µÀ¾ß"..(n+1)]
end
JY.Person[oid]["µÀ¾ß8"]=0
for n=1,8 do
if JY.Person[cid]["µÀ¾ß"..n]==0 then
JY.Person[cid]["µÀ¾ß"..n]=item
break
end
end
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

-- ÕĞÀ¿Îä½«
function HirePerson()
local num=0
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
"‡sm"}
local db2={ 23,66,23,66,
382,382,382,9999,
226,226,
144,144,144,
103,103,
176,176,176,176,176,226,9999,
513,348,348,324,324,324,324,324,348,348,
279,279,
568,
424,424,461,461,
513,513,592,592,9999,
630,630,
630,630,655,
513,
568,
568,
655}
local db3={
[4]=385,
[8]=386,
[12]=403,
[16]=404,
--[20]=405,
--[24]=388,
}
if JY.Base["ÊÂ¼ş333"]>=9 then
db2[8]=382--Ëï¼á
end
if JY.Base["ÊÂ¼ş333"]>=11 then
db2[22]=226--ÂÀ²¼
end
if JY.Base["ÊÂ¼ş333"]>=15 then
db2[44]=513--ÖÜè¤
end
for i,v in pairs(db) do
local p1=JY.Person[420+i]
if p1["¾ıÖ÷"]==0 then
local p2=JY.Person[420]
for idx=1,JY.PersonNum-1 do
if JY.Person[idx]["ĞÕÃû"]==v then
p2=JY.Person[idx]
break
end
end
for idx,par in pairs({"´úºÅ","ĞÕÃû","ÍâºÅ","ĞÔ±ğ","ÎäÁ¦","ÖÇÁ¦","Í³ÂÊ","Ìì¸³","±øÖÖ","±©»÷","Á¬»÷","»ØÂí","ÃØ¼¼1","°µÆ÷","·ÜÕ½","¼±¾È","µ×Á¦","Å­·¢","Íş·ç","²»Çü","Ç¿ÔË","Ò»»÷","ÌØ¼¼1","ÌØ¼¼2","ÌØ¼¼3","ÌØ¼¼4","ÌØ¼¼5","ÌØ¼¼6"}) do
p1[par]=p2[par]
end
p1["³É³¤"]=10
p1["µÈ¼¶"]=math.modf((JY.Person[1]["µÈ¼¶"]+JY.Person[2]["µÈ¼¶"]+JY.Person[3]["µÈ¼¶"]+JY.Person[54]["µÈ¼¶"]+JY.Person[126]["µÈ¼¶"])/6)-5
p1["µÈ¼¶"]=limitX(p1["µÈ¼¶"],1,99)
if CC.Enhancement then
local dtlv=pjlv()
if p1["µÈ¼¶"]<dtlv then
p1["µÈ¼¶"]=dtlv
end
end
if p2["ĞÂÍ·Ïñ´úºÅ"]>0 then
p1["Í·Ïñ´úºÅ"]=p2["ĞÂÍ·Ïñ´úºÅ"]
else
p1["Í·Ïñ´úºÅ"]=p2["Í·Ïñ´úºÅ"]
end
p1["ĞÂÍ·Ïñ´úºÅ"]=db2[i]--ÓÃÕâ¸öÀ´¿¨ ¶àÉÙ¶àÉÙ¹ØÖ®ºó²ÅÄÜ¼ÓÈë
end
end
for i=421,JY.PersonNum-1 do
if JY.Person[i]["Í·Ïñ´úºÅ"]>0 and JY.Person[i]["ĞÂÍ·Ïñ´úºÅ"]<JY.EventID then
ReSetAttrib(i,true)
JY.Person[i]["Õ½¶·¶¯×÷"]=GetPic(i,false,false)
num=num+1
TeamSelect.id[num]=i
if JY.Person[i]["¾ıÖ÷"]==1 then
TeamSelect.status[num]=1--0Î´Ñ¡Ôñ 1Ñ¡Ôñ
else
TeamSelect.status[num]=0
end
end
end
for i,v in pairs(db3) do
if JY.Base["ÊÂ¼ş333"]>=i then
ReSetAttrib(v,true)
JY.Person[v]["Õ½¶·¶¯×÷"]=GetPic(v,false,false)
num=num+1
TeamSelect.id[num]=v
if JY.Person[v]["¾ıÖ÷"]==1 then
TeamSelect.status[num]=1--0Î´Ñ¡Ôñ 1Ñ¡Ôñ
else
JY.Person[v]["³É³¤"]=10
JY.Person[v]["µÈ¼¶"]=math.modf((JY.Person[1]["µÈ¼¶"]+JY.Person[2]["µÈ¼¶"]+JY.Person[3]["µÈ¼¶"]+JY.Person[54]["µÈ¼¶"]+JY.Person[126]["µÈ¼¶"])/6)-5
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
if num==0 then
WarDrawStrBoxConfirm("‚Cƒgƒb …}„oX IƒaG ‚aKLM.",M_White,true)
return
end
 maxpage=math.modf((num-1)/6)+1
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
local v=40000/(120-p["ÎäÁ¦"])+40000/(120-p["ÖÇÁ¦"])+40000/(120-p["Í³ÂÊ"])
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
if p["ĞÕÃû"]=="hnc" then
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
local kind={[0]="‚a‚M","‚J‚p„o","‚}‚D„o","‚t†I„o","ƒsƒA","‚~ƒW","‚X…X","‚}‚D„o","ƒT„h","ƒT„h","ƒT„h","ÎäÆ÷","·À¾ß","…X„y","‚a‚M",}
local titlestr="‚S†s IƒaS …}„oXYZ? …m…naƒoZ."
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["ĞÕÃû"]
local hp=string.format("% 5d",JY.Person[pid]["×î´ó±øÁ¦"])
local lv=string.format("% 5d",JY.Person[pid]["µÈ¼¶"])
local picid
if TeamSelect.status[idx]==0 then--Î´Ñ¡ÔñÊ±£¬Îª+19
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
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
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["Ãû³Æ"],color,16)
DrawString(562,176+i*18,"£¯"..kind[JY.Item[tid]["ÀàĞÍ"]],color,16)
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
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
Dark()
lib.Delay(1000)
os.exit()--ko fix: the selection loop ignores JY.Status, so leave here
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
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
current=idx
cid=TeamSelect.id[idx]
if TeamSelect.status[idx]==0 then
PlayWavE(0)
TeamSelect.status[idx]=1
titlestr="…}„o: "..JY.Person[cid]["ĞÕÃû"].."£®"
redraw()
PersonStatus(cid,"","",2)
redraw()
local v=GetPersonValue(cid)
if WarDrawStrBoxYesNo("‚P„o "..v.."ƒg, …}„o: "..JY.Person[cid]["ĞÕÃû"]..". ƒJƒKKLY?",M_White,true) then
redraw()
if v>JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"] then
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
	if JY.Person[pid]["ÖÇÁ¦"]<=100 then
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
	elseif JY.Person[pid]["Í³ÂÊ"]<=100 then
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
	if (JY.Person[pid]["ÎäÁ¦"]>=wlyz  and JY.Person[pid]["ÎäÁ¦"]>=JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÎäÁ¦"]<=100) or JY.Person[pid]["Í³ÂÊ"]==100  or JY.Person[pid]["´úºÅ"]==2 then
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
	elseif JY.Person[pid]["Í³ÂÊ"]<=100 then
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
	if JY.Person[pid]["ÖÇÁ¦"]<=100 then
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
	elseif JY.Person[pid]["Í³ÂÊ"]<=100 then
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
if JY.Person[pid]["ÎäÁ¦"]>=80  and JY.Person[pid]["ÎäÁ¦"]<=100 then
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
elseif JY.Person[pid]["Í³ÂÊ"]<=100 then
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
for i,v in pairs(shopitem[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["Ãû³Æ"],11),nil,1}
end
elseif r==2 then
status="SelectItem"
shopid=2
itemmenu={}
itemnum=0
for i,v in pairs(shopitem2[sid]) do
itemnum=itemnum+1
itemmenu[itemnum]={fillblank(JY.Item[v]["Ãû³Æ"],11),nil,1}
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
if talkYesNo(375,JY.Item[iid]["Ãû³Æ"].."‚Uƒg "..JY.Item[iid]["¼ÛÖµ"].."0,*ƒJƒKKLY?") then
--Èç¹û»Æ½ğ²»¹»
if JY.Item[iid]["¼ÛÖµ"]*10>JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"] then
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
if talkYesNo(375,"w„p‚KƒG ¡ú "..JY.Person[pid]["ĞÕÃû"]..". ƒJƒKKLY?") then
UseMoney(10*JY.Item[iid]["¼ÛÖµ"])
for i=1,8 do
if JY.Person[pid]["µÀ¾ß"..i]==0 then
JY.Person[pid]["µÀ¾ß"..i]=iid
break
end
end
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
			sellmenu[i]={fillblank(JY.Item[iid]["Ãû³Æ"],11),nil,1}
		else
			sellmenu[i]={"",nil,0}
		end
	end
	talk_sub(375,"I‡JS †V‚V†yKLY?")
	local rr=ShowMenu(sellmenu,8,0,0,156,0,0,3,1,16,M_White,M_White)
	local sellprice
	if rr>0 then
		iid=JY.Person[pid]["µÀ¾ß"..rr]
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
	if (iid==71 or iid==72 or iid==73) then
		exchangemenu[i]={fillblank(JY.Item[iid]["Ãû³Æ"],11),nil,1}
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
			seedmenu[72]={fillblank(JY.Item[72]["Ãû³Æ"],11),nil,1}
			seedmenu[73]={fillblank(JY.Item[73]["Ãû³Æ"],11),nil,1}
		elseif iid==72 then
			seedmenu[71]={fillblank(JY.Item[71]["Ãû³Æ"],11),nil,1}
			seedmenu[73]={fillblank(JY.Item[73]["Ãû³Æ"],11),nil,1}
		elseif iid==73 then
			seedmenu[71]={fillblank(JY.Item[71]["Ãû³Æ"],11),nil,1}
			seedmenu[72]={fillblank(JY.Item[72]["Ãû³Æ"],11),nil,1}
		else
			talk(375,"G D‚w‚b „W†IX q ‚aKLM")
			return
		end
		talk_sub(375,"‚S†s ƒT„hƒm„S ƒUƒV‚V†yKLY?")
		newseed=ShowMenu(seedmenu,73,2,0,156,0,0,3,1,16,M_White,M_White)
		if newseed>0 then
			if JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"]<125 then
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
if JY.Status==GAME_SMAP_MANUAL and (JY.Base["»Æ½ğ"]+JY.Base["ÎŞÓÃ6"])>=120000 then
	talk(375,"‚Uƒg ƒs‚G„XG Co 131000f ^‡PKLM. ‚SƒW ‚r„oaƒoZ.")
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
function SelectTerm(fid,team)
local num=0
local page=1
local maxpage=1
local num_per_page=6
local personnum=0
local maxpersonnum=0
local current=1
for j=1,20 do
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
if team[idx+1]+1==i then
TeamSelect.status[num]=2
break
end
end
end
end
maxpage=math.modf((num-1)/6)+1
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
local kind={[0]="‚a‚M","‚J‚p„o","‚}‚D„o","‚t†I„o","ƒsƒA","‚~ƒW","‚X…X","‚}‚D„o","ƒT„h","ƒT„h","ƒT„h","ÎäÆ÷","·À¾ß","…X„y","‚a‚M",}
local str_mode
if JY.Person[1]["ÃØ¼¼1"]==0 then
	str_mode="ƒs„w ‚Z…w"
else
	str_mode="D‚B ‚qGD "..JY.Person[1]["·ÜÕ½"]
end
local titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?".."            "..str_mode
local function redraw()
JY.ReFreshTime=lib.GetTime()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(4,201*2,0,0,1)
DrawGameStatus()
lib.PicLoadCache(4,203*2,16,16,1)
DrawString(26,31,titlestr,M_White,16)
for i=1,6 do
local idx=num_per_page*(page-1)+i
if idx>num then
break
end
local pid=TeamSelect.id[idx]
local name=JY.Person[pid]["ĞÕÃû"]
local hp=string.format("% 5d",JY.Person[pid]["×î´ó±øÁ¦"])
local lv=string.format("% 5d",JY.Person[pid]["µÈ¼¶"])
local picid
if TeamSelect.status[idx]==0 then--Î´Ñ¡ÔñÊ±£¬Îª+19
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+19
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_White,16)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
else
picid=JY.Person[pid]["Õ½¶·¶¯×÷"]+12+frame
DrawString(xy.x3[i]-4*#name,xy.y3[i],name,M_DarkOrange,16)
lib.Background(xy.x1[i],xy.y1[i],xy.x1[i]+48,xy.y1[i]+48,128)
lib.PicLoadCache(1,picid*2,xy.x1[i],xy.y1[i],1)
end
DrawString(xy.x2[i],xy.y2[i],hp,M_White,16)
DrawString(xy.x1[i]+4,xy.y1[i]+48,lv,M_White,16)
end
DrawString(110,359,string.format("% 4d",page),M_White,16)
DrawString(142,359,string.format("% 4d",maxpage),M_White,16)
DrawString(252,359,string.format("% 4d",personnum),M_White,16)
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
if tid>0 then
DrawString(466,176+i*18,JY.Item[tid]["Ãû³Æ"],M_White,16)
DrawString(562,176+i*18,"£¯"..kind[JY.Item[tid]["ÀàĞÍ"]],M_White,16)
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
redraw()
while JY.Status==GAME_SMAP_AUTO or JY.Status==GAME_SMAP_MANUAL do
redraw()
getkey()
bottom=0
if MOUSE.EXIT() then
PlayWavE(0)
if WarDrawStrBoxYesNo('QRS TUXYZ?',M_White,true) then
os.remove(CC.R_GRPFilename[6])--É¾³ıÁÙÊ±´æµµ
lib.Delay(100)
JY.Status=GAME_END
Dark()
lib.Delay(1000)
os.exit()--ko fix: the selection loop ignores JY.Status, so leave here
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
SelectTerm_sub(fid,team)
Dark()
return
end
elseif MOUSE.CLICK(464,32,464+64,32+80) then--head
PlayWavE(0)
PersonStatus(cid,"","",1)
else
for i=1,6 do
if MOUSE.CLICK(xy.x1[i],xy.y1[i],xy.x4[i],xy.y4[i]) then
local idx=num_per_page*(page-1)+i
if idx<=num then
 current=idx
if TeamSelect.status[idx]==0 then
	if personnum<=0 then
		PlayWavE(2)
		titlestr="„l GC †~‚BX q ‚aKLM."
		for n=1,20 do
			redraw()
		lib.GetKey()
		end
		titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?".."            "..str_mode
	else
		cid=TeamSelect.id[current]
		local cnt=0
		for i=1,8 do			
			if JY.Person[cid]["µÀ¾ß"..i]==0 then
				cnt=cnt+1
			end
		end
		if cnt<2 and CC.Enhancement then
			PlayWavE(2)
			titlestr="IƒaƒP D‚w‡BS ‚[ ‡B ‚P‡S ‡D …m…naƒoZ"
			for n=1,20 do
				redraw()
				lib.GetKey()
			end
			titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?".."            "..str_mode		
		
		else
			PlayWavE(0)
			TeamSelect.status[idx]=1
			personnum=personnum-1
		end
	end
elseif TeamSelect.status[idx]==1 then
	PlayWavE(1)
	TeamSelect.status[idx]=0
	personnum=personnum+1
else
	PlayWavE(2)
	titlestr="ƒ[ Iƒaƒb BdX q ‚aKLM."
	for n=1,20 do
		redraw()
		lib.GetKey()
	end
	titlestr="‚S†s IƒaS ‚B„ef †~^‚V‡QYZ?".."            "..str_mode
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
local num=0
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
for wid=1,War.PersonNum do
local idx=(wid-1)*7
if team[idx+7]==nil then
break
end
War.Person[wid].x=team[idx+2]+1
War.Person[wid].y=team[idx+3]+1
War.Person[wid].ai=1
War.Person[wid].frame=-1
War.Person[wid].d=team[idx+4]
War.Person[wid].active=true
if not War.Person[wid].troubled then
War.Person[wid].action=1
end
if War.Person[wid].live then
SetWarMap(team[idx+2]+1,team[idx+3]+1,2,wid)
end
War.Person[wid].pic=WarGetPic(wid)
end
end

--Ñ¡ÔñÎÒ¾ü
--T,ÎÒ¾ü²ÎÕ½ÈËÔ±ÅäÖÃÊı¾İ
function SelectTerm_sub(fid,T)
for i=1,20 do
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



end

--Ñ¡ÔñµĞ¾ü
function SelectEnemy(T)
JY.Base["È«¾ü³·ÍË"]=JY.EventID
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
SRPG()
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
		}
		for id=1,5 do
			if not fileexist(CC.R_GRPFilename[id]) then
				menu2[id][1]=menu2[id][1].."…i …j…k"
			else
				menu2[id][1]=menu2[id][1]..GetRecordInfo(id)
			end
		end
		DrawYJZBox2(-1,104,"‚SƒZf …fƒaXYZ?",M_White)
		local s2=ShowMenu(menu2,5,0,0,0,0,0,20,1,16,M_White,M_White)
		if between(s2,1,5) then
			if WarDrawStrBoxYesNo(string.format("ƒZƒ~„^ƒP %d‚Wf …fƒaWLM. ƒJƒKKLY?",s2),M_White,true) then
				if flag==2 then
					JY.Status=GAME_SMAP_AUTO--ÓëÇ°Ãæ¶ÔÓ¦£¬¸Ä»ØÀ´
				end
			SaveRecord(s2)
			end
		end
	end

if flag==1 then
DrawSMap()
elseif flag==2 then
JY.Status=GAME_SMAP_AUTO--ÓëÇ°Ãæ¶ÔÓ¦£¬¸Ä»ØÀ´
end
end

--µÈ¼¶ÉÏÉı
--pid ÈËÎïid, n Ä¬ÈÏÎª1
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
if v.live and (not v.hide) and ((pid==0 and (not v.enemy) and (not v.friend)) or pid==v.id) and x==v.x and y==v.y then
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
elseif War.Person[War.SelID].id==pid1 then--Ö¸¶¨ÈËÎï ±ØĞëÎªµ±Ç°ĞĞ¶¯ÈËÎï
id1=War.SelID
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
if JY.Base["»Æ½ğ"]+money>65500 then
	JY.Base["ÎŞÓÃ6"]=limitX(JY.Base["ÎŞÓÃ6"]+(JY.Base["»Æ½ğ"]+money-65500),0,65500)
	JY.Base["»Æ½ğ"]=65500
else	
	JY.Base["»Æ½ğ"]=limitX(JY.Base["»Æ½ğ"]+money,0,65500)
end

bonus_moneyexp_8()

end

function UseMoney(money)
local deduct=0
if money>JY.Base["ÎŞÓÃ6"] then
	deduct=money-JY.Base["ÎŞÓÃ6"]
	JY.Base["ÎŞÓÃ6"]=0
	JY.Base["»Æ½ğ"]=JY.Base["»Æ½ğ"]-deduct
else
	JY.Base["ÎŞÓÃ6"]=JY.Base["ÎŞÓÃ6"]-money
end
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
	total_gold=(bonus_money+gold_lv*(JY.Person[1]["·ÜÕ½"]-1))*live_cnt
	if JY.Person[1]["·ÜÕ½"]>3 then
		deduce_gold=(JY.Person[1]["·ÜÕ½"]-3)*gold_lv/2
		total_gold=total_gold-deduce_gold*live_cnt
	end	
	total_exp=(bonus_exp+exp_lv*(JY.Person[1]["·ÜÕ½"]-1))*live_cnt
	if JY.Base["»Æ½ğ"]+total_gold>65500 then
		JY.Base["ÎŞÓÃ6"]=limitX(JY.Base["ÎŞÓÃ6"]+(JY.Base["»Æ½ğ"]+total_gold-65500),0,65500)
		JY.Base["»Æ½ğ"]=65500
	else	
		JY.Base["»Æ½ğ"]=limitX(JY.Base["»Æ½ğ"]+total_gold,0,65500)
	end
	
	WarDrawStrBoxConfirm("D‚B ‚qGD "..JY.Person[1]["·ÜÕ½"].." …c^ ƒsC "..live_cnt.."‚X ‡T "..total_gold.."ƒg ‡U "..total_exp.." ƒMƒ}„Q ƒ@…U",M_White)		
	os.remove(CC.R_GRPFilename[6])	
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
	total_gold=(bonus_money+gold_lv*(JY.Person[1]["·ÜÕ½"]-1))*live_cnt
	if JY.Person[1]["·ÜÕ½"]>3 then
		deduce_gold=(JY.Person[1]["·ÜÕ½"]-3)*gold_lv/2
		total_gold=total_gold-deduce_gold*live_cnt
	end
	total_exp=(bonus_exp+exp_lv*(JY.Person[1]["·ÜÕ½"]-1))*live_cnt
	GetMoney(total_gold)
	WarDrawStrBoxConfirm("D‚B ‚qGD "..JY.Person[1]["·ÜÕ½"].." …c^ ƒsC "..live_cnt.."‚X ‡T "..total_gold.."ƒg ‡U "..total_exp.." ƒMƒ}„Q ƒ@…U",M_White)
	os.remove(CC.R_GRPFilename[6])
end
end

function win_exp(pid)
if (JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["ÎäÁ¦"] and JY.Person[pid]["ÖÇÁ¦"]>JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÖÇÁ¦"]>=zlyz) or  (JY.Person[pid]["±øÖÖ"]==13 or JY.Person[pid]["±øÖÖ"]==16 or JY.Person[pid]["±øÖÖ"]==19 or JY.Person[pid]["±øÖÖ"]==26) then
	if JY.Person[pid]["ÖÇÁ¦"]<=100 then
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
	elseif JY.Person[pid]["Í³ÂÊ"]<=100 then
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
	if JY.Person[pid]["ÎäÁ¦"]>=wlyz  and JY.Person[pid]["ÎäÁ¦"]>=JY.Person[pid]["Í³ÂÊ"] and JY.Person[pid]["ÎäÁ¦"]<=100 then
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
	elseif JY.Person[pid]["Í³ÂÊ"]<=100 then
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
for i=1,5 do
	modemenu[i+1]={fillblank("D‚B ‚qGD "..i,13),nil,1}
end
if WarDrawStrBoxYesNo("M‚M ‚B„eƒP QR ‚Z…w‚h M‚V ƒd‚j‚V†yKLY?",M_White,true) then
	::modelist::	
	nextmode=ShowMenu(modemenu,6,6,0,156,0,0,3,1,16,M_White,M_White)
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
x=16+576/2-w/2
y=32+432/2-h/2
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
function WarCheckSkill(wid,skillid)
local pid=War.Person[wid].id
if JY.Person[pid]["Ìì¸³"]==skillid then
return true
end
if JY.Person[pid]["ĞÕÃû"]==JY.Item[JY.Person[pid]["ÎäÆ÷"]]["×¨ÊôÌØ¼¼ÈË"] and JY.Item[JY.Person[pid]["ÎäÆ÷"]]["×¨ÊôÌØ¼¼"]==skillid then
return true
end
if JY.Item[JY.Person[pid]["ÎäÆ÷"]]["ÌØ¼¼"]==skillid then
return true
end
for i=1,6 do
if JY.Person[pid]["ÌØ¼¼"..i]==skillid then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][i] then
return true
end
end
end
return false
end

function CheckSkill(pid,skillid)
if pid<=0 then
return false
end
if JY.Person[pid]["Ìì¸³"]==skillid then
return true
end
for i=1,6 do
if JY.Person[pid]["ÌØ¼¼"..i]==skillid then
if JY.Person[pid]["µÈ¼¶"]>=CC.SkillExp[JY.Person[pid]["³É³¤"]][i] then
return true
end
end
end
return false
end

--åŸfight.lua
--ko 2.0: ì¼ê¸°í†  ë³µì›. ì›ë³¸ ë³µê°íŒ(LLK_R1 build 42310) script/fight.lua ë¥¼ unluac ë¡œ ë””ì»´íŒŒì¼í•´ ì´ì‹.
--    Â· í™”ë©´ì€ ì›ë³¸ì˜ 992x576 ì „ìš© í•´ìƒë„ ëŒ€ì‹  ìœ ê´‘íŒì˜ 768x480 ê·¸ëŒ€ë¡œ ì‚¬ìš© (í”„ë ˆì„ ui 412, ì¢Œí‘œëŠ” ì¤‘ì‹¬ 496â†’384 ë¡œ ì´ë™)
--    Â· ëŒ€ì‚¬ëŠ” í•œê¸€í™”, ìƒ‰ìƒ ìƒìˆ˜ C_WHITEâ†’M_White, ì—°ì¶œ ë£¨í”„ì— CC.koAnim(ì—°ì¶œ ë°°ì†) ë°˜ì˜
--    Â· ë°˜í™˜ê°’: 1 = id1 ìŠ¹, 2 = id2 ìŠ¹ (kdef.lua ì˜ if fight(a,b)==1 ë¶„ê¸°ì™€ í˜¸í™˜)
function fight(id1,id2,sid)
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
local hpmax={150+p1["µÈ¼¶"],150+p2["µÈ¼¶"]}
local hp={150+p1["µÈ¼¶"],150+p2["µÈ¼¶"]}
local mp={20,20}
if p1["ÎäÁ¦"]>p2["ÎäÁ¦"] then
mp[1]=35
elseif p1["ÎäÁ¦"]<p2["ÎäÁ¦"] then
mp[2]=35
end
local atk={math.max(math.modf(p1["ÎäÁ¦"]/10)-1,2),math.max(math.modf(p2["ÎäÁ¦"]/10)-1,2)}
if atk[1]-atk[2]>5 then
atk[2]=atk[1]-5
elseif atk[2]-atk[1]>5 then
atk[1]=atk[2]-5
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
local SW=CC.ScreenW or 768
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
luck=math.min(30,p1["ÓÂÃÍ"]+p1["Àä¾²"]*3+10*p1["Ç¿ÔË"])+10*p1["Ç¿ÔË"],
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
luck=math.min(30,p2["ÓÂÃÍ"]+p2["Àä¾²"]*3+10*p2["Ç¿ÔË"])+10*p2["Ç¿ÔË"],
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
local function show()
getkey()
lib.FillColor(0,0,0,0,0)
lib.PicLoadCache(1,pic2*2,0,310,1)
lib.PicLoadCache(1,pic1*2,-68,190,1)
--ì™¼ìª½(id1)
DrawBox(LX,74,LX+68,158,M_White)
lib.PicLoadCache(2,p1["Í·Ïñ´úºÅ"]*2,LX+2,76,1)
if s[1].losser then
lib.Background(LX+2,76,LX+66,156,106)
end
DrawBox(LX,163,LX+68,185,M_White)
DrawBox(LX+70,163,LX+138,185,M_White)
DrawString(LX+34-#p1["ĞÕÃû"]*4,166,p1["ĞÕÃû"],M_White,16)
DrawString(LX+72,166,string.format("Iƒ} %3d",p1["ÎäÁ¦"]),M_White,16)
DrawStrBox(LX+82,74,s[1].txt,M_White,16)
--ì˜¤ë¥¸ìª½(id2)
DrawBox(RX,74,RX+68,158,M_White)
lib.PicLoadCache(2,p2["Í·Ïñ´úºÅ"]*2,RX+2,76,1)
if s[2].losser then
lib.Background(RX+2,76,RX+66,156,106)
end
DrawBox(RX,163,RX+68,185,M_White)
DrawBox(RX-70,163,RX-2,185,M_White)
DrawString(RX+34-#p2["ĞÕÃû"]*4,166,p2["ĞÕÃû"],M_White,16)
DrawString(RX-68,166,string.format("Iƒ} %3d",p2["ÎäÁ¦"]),M_White,16)
DrawStrBox(-(SW-(RX-10)),74,s[2].txt,M_White,16)--ìŒìˆ˜ x: ì˜¤ë¥¸ìª½ ë ê¸°ì¤€
--ì²´ë ¥ ë°”
lib.FillColor(CX-math.modf(300*hp[1]/hpmax[1]),192,CX,204,M_Red)
lib.FillColor(CX,192,CX+math.modf(300*hp[2]/hpmax[2]),204,M_Blue)
DrawBox(CX-303,192,CX+300,204,M_White)
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
DrawString(CX-#wname*12,210,wname,M_White,48)
for t=1,10 do
JY.ReFreshTime=lib.GetTime()
ReFresh()
lib.GetKey()
end
end
--ì¹´ë“œ (í–‰ë™ ì„ íƒ) AI
local function card_ini(idx)
card[idx]={}
for i=1,card_num[idx] do
card[idx][i]=math.random(9)
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
card[id][i]=math.random(9)
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
action_v[i],action_k[i]=card_ai(i)
end
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
card[3-cur][card_num[3-cur]]=math.random(9)
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
fornum=1,n do
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
lib.GetKey=function(a)
if a==nil then return koRawGetKey() end
local e,k,x,y=koRawGetKey(a)
if e==3 then if k==1 then MOUSE.koSwallow=true elseif k==3 then MOUSE.koSwallowR=true end end
return e,k,x,y
end
lib.GetMouse=function(a)
if a==nil then return koRawGetMouse() end
local b,x,y,z=koRawGetMouse(a)
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
local X1,Y1,X2,Y2=607,72,753,357
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
lib.FillColor(X1,Y1,X2,Y2,M_Black)
local lab=label()
local lsz=16
if #lab*8>42 then lsz=14 end
DrawString(632-#lab*lsz/4,40+(16-lsz)/2,lab,M_White,lsz)
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
elseif MOUSE.CLICK(657,32,687,63) then
if side then
side=false
ids,n=build()
start=1
end
elseif MOUSE.CLICK(689,32,719,63) then
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
