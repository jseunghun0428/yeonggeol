-- ±º¿õ·Ï (11-03): º»Ã¼(¿µ°ÉÀüº¹°¢ À¯±¤ÆÇ º»Ã¼.exe)¸¦ ¹Ù·Î ½ÇÇàÇÏ¸é ·±Ã³(»ï±¹Áö ±º¿õ·Ï.exe)·Î ´Ù½Ã ¶ç¿ì°í ²ö´Ù.
-- ·±Ã³´Â SDL_DYNAMIC_API(ko_sdl.dll: ¹èÀ² µî)¸¦ ³Ö¾î º»Ã¼¸¦ ÄÑ¹Ç·Î ±× °ªÀÌ ¾øÀ¸¸é ·±Ã³ ¾øÀÌ ÄÒ °Í. KO_RELAUNCHED = ´Ù½Ã ¶ç¿î Ç¥½Ã(µÇÇ®ÀÌ ¸·±â).
-- ·±Ã³ ÆÄÀÏÀÌ ¿·¿¡ ¾øÀ¸¸é(ÈŞ´ëÆù ¡¤ ´Ù¸¥ Æú´õ¿¡¼­ ÄÔ) ¾Æ¹«°Íµµ ¾È ÇÔ. ÆÄÀÏ ÀÌ¸§Àº Windows ANSI(CP949) ¹ÙÀÌÆ®.
do
local g=os and os.getenv
if g and package and package.config and string.sub(package.config,1,1)=="\\" and not g("SDL_DYNAMIC_API") and not g("KO_RELAUNCHED") then
local L="\187\239\177\185\193\246 \177\186\191\245\183\207.exe"
local f=io.open(L,"rb")
if f then f:close() os.execute('set KO_RELAUNCHED=1&& start "" "'..L..'"') os.exit(0) end
end
end



-- ?Áã¿ï?
--˜¡?????£¬?Áã¿ï?ÀäÌµlua?®s
--??C?ˆÎ????èb?lua?ˆÎ™©ñæÀÇ???‘z??èb¡£lua??ƒ€?èb???Í«jyconst.lua™©

-- ko 6.0 (11-01): the globals as the engine gave them, before any script ran (koSoftRestart in campsel builds a fresh game from these)
if not koPristineG then
local s={}
for k,v in pairs(_G) do if type(v)=="table" and k~="_G" then local c={} for a,b in pairs(v) do c[a]=b end s[k]=c elseif k~="_G" then s[k]=v end end
koPristineG=s
end
CONFIG={};
CONFIG.Debug=0;         --¿Ê??—U??ŞI½ï¿Ú£¬=0?¿Ê? =1 ¿Ê?½ï¿ÚÍ«debug.txt?error.txt?????
CONFIG.Windows=true
local file = io.open(".\\config.lua");
if (file) then
CONFIG.Windows = true
CONFIG.CurrentPath =".\\"
CONFIG.DataPath=CONFIG.CurrentPath .. "data\\";
CONFIG.Save=CONFIG.DataPath .. "save\\";
CONFIG.PicturePath=CONFIG.CurrentPath .. "pic\\";
CONFIG.SoundPath=CONFIG.CurrentPath .. "sound\\";
CONFIG.ScriptPath=CONFIG.CurrentPath .. "script\\";
CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua";   --luaå¼?ˆÎ?
CONFIG.FontName=".\\font\\font.ttf";
CONFIG.FontName2=".\\font\\font2.ttf";
CONFIG.MusicVolume=50;            --ªèÁã??¶ ??¶ ?(0-128)
CONFIG.SoundVolume=50;            --ªèÁã??¶ ˜²?¶ ?(0-128)
else
CONFIG.Windows = false
CONFIG.CurrentPath = config.GetPath();
CONFIG.DataPath=CONFIG.CurrentPath.."data/";
CONFIG.Save=CONFIG.DataPath .. "save/";
CONFIG.PicturePath=CONFIG.CurrentPath.."pic/";
CONFIG.SoundPath=CONFIG.CurrentPath.."sound/";
CONFIG.ScriptPath=CONFIG.CurrentPath.."script/";
CONFIG.JYMain_Lua=CONFIG.ScriptPath .. "jymain.lua"; --luaå¼?ˆÎ?
CONFIG.FontName=CONFIG.CurrentPath.."font/font.ttf";
CONFIG.FontName2=CONFIG.CurrentPath.."font/font2.ttf";
CONFIG.MusicVolume=60;
CONFIG.SoundVolume=60;
end

-- ko 3.1: ìˆœì •(ì˜¤ë¦¬ì§„) mode. When every addon in script/addon/addons.lua is off, run the ì˜¤ë¦¬ì§„ scripts (script/origin/,
-- with their own newgame/wmap/hdgrp/ui data in data/origin/) and keep their saves apart in data/save/origin/.
-- The í™•ì¥ screen (on the ì˜¤ë¦¬ì§„ title menu) turns addons back on; a restart applies it.
CONFIG.koPure=false
do
-- read the list as text (config.lua runs before the game's Lua state is fully set up, so no dofile here).
-- ìˆœì • when the "base" row (ê¸°ëŠ¥ í™•ì¥ = the ìœ ê´‘íŒ base) is off; an addons.lua without that row counts as ìˆœì • only when nothing is on
local f=io.open(CONFIG.ScriptPath.."addon/addons.lua","r")
if f then
local rows,on,base=0,0,nil
for line in f:lines() do
if string.find(line,'^%s*{%s*"base"%s*,%s*true') then base=true
elseif string.find(line,'^%s*{%s*"base"%s*,%s*false') then base=false
elseif string.find(line,'^%s*{%s*"[%w_]+"%s*,%s*true') then rows=rows+1 on=on+1
elseif string.find(line,'^%s*{%s*"[%w_]+"%s*,%s*false') then rows=rows+1 end
end
f:close()
if base~=nil then CONFIG.koPure=(base==false) else CONFIG.koPure=(rows>0 and on==0) end
end
end
if CONFIG.koPure then
CONFIG.ScriptPath=CONFIG.CurrentPath.."script/origin/"
CONFIG.JYMain_Lua=CONFIG.ScriptPath.."jymain.lua"
CONFIG.Save=CONFIG.DataPath.."save/origin/"
end

-- ko 6.0 (11-01): campaigns (ì›ì†Œì „ / ì†ê²¬ì „ / ë¬´ì œì „). ko_camp.txt (the title's story picker writes it) names one: its people and
-- battle maps are data/camp/<id>/, its scripts script/camp/<id>/ (camp.lua = the koCamp table), its saves and records data/save/<id>/.
CONFIG.koCamp=nil
if not CONFIG.koPure then
local f=io.open(CONFIG.CurrentPath.."ko_camp.txt","r")
local id=f and f:read("*l")
if f then f:close() end
id=id and string.match(id,"^%s*([%a_]+)")
local g=id and io.open(CONFIG.ScriptPath.."camp/"..id.."/camp.lua","r")
if g then
g:close()
local sep=CONFIG.Windows and "\\" or "/"
CONFIG.koCamp=id
CONFIG.koCampScript=CONFIG.ScriptPath.."camp/"..id.."/"
CONFIG.koCampData=CONFIG.DataPath.."camp"..sep..id..sep
CONFIG.Save=CONFIG.DataPath.."save"..sep..id..sep
end
end

CONFIG.Width2  = 768--992--1060;       -- Ì¤¹·•±½ü???
CONFIG.Height2 = 480--576--595;      -- Ì¤¹·•±½ü???
CONFIG.Width  = 768--1060;       -- Ì¤¹·•±½ü???
CONFIG.Height = 480--595;      -- Ì¤¹·•±½ü???

CONFIG.bpp  =16          -- ??çæâ±¸şª«ªî£¬Œ?˜¡16?Õ32¡£Í«???ñ{çæšš??Ìµ????ª«ªî£¬?ªèÁãŞZ˜²
                         -- ?ßB?8Øª«ªî¡£˜¡­‚?õ¶?£¬?ÀÛÙZÌµ16Øª«ªî¡£
 -- 24Ø¹à???—U£¬??Â“”?÷¶¿Ì
CONFIG.EnableSound=1     -- ½Ç???ªù¶     1 ?? 0 ??   ???Í«Ì¤¹·™©ŞZ???
CONFIG.MP3 = 1
CONFIG.FullScreen=1 -- ??çæ½Ç??? 1 ?? 0 ??
CONFIG.KeyRepeat=0       -- ½Ç?????Â·? 0 ???£¬Á¯Í«›É???çæ??Â·?£¬1??£¬?????½ÜÌÆçæ????Â·?
CONFIG.KeyRepeatDelay =300;   --?Œ???Â·???msèb
CONFIG.KeyRePeatInterval=30;  --Œ? tÂ·??èb

CONFIG.OSCharSet=0      -- ÷¶¿ÌÙµ?? 0 ?¾¹ 1 ?¾¹

     --¼¾•±??èb?£¬Œ?500-1000¡£??Í«debug.txt™©???¾ı"pic cache is full"£¬?Â¹¿¯?ÌÙ?
CONFIG.MAXCacheNum=800;
CONFIG.CleanMemory=0;         --????çæ½Ç???lua??¡£0 ??? 1 ??
CONFIG.LoadFullS=0;           --1 ‘z?S*¿ï?äü??? 0 Á¯äü?????£¬×TühS*ÌÆ4M?£¬‚Hœ¯?Â¹?ªš????
CONFIG.LoadMMapType=0;        --?äüå¼?•±¿ï?(5?002¿ï?)??Ö”  0 ??äü? 1 äü?å¼????Æõ 2 äü?å¼????Æõ??
                              --?Ö”2™ìÌµ??ëxªÙ£¬?½ÇÍ«°G??ªè?ªÏäü?çæ???£¬Í«å¼?›É?çæ??Œ¹¶
  --?Ö”1™ìÌµ????£¬äü?çæ??2ÀÇªÙ£¬Œ???ÌÆ????

CONFIG.PreLoadPicGrp=1;       --1 ¶É?äü¼¾•±¿ï?*.grp, 0 ?¶É?äü¡£¶É?äü?Â¹??›É???½ç??E??Æ½ç?¡£?™ìÌµ??

CONFIG.Operation = 1
CONFIG.Type= 1
CONFIG.XScale = 18 -- ¼¾•±???Œ?
CONFIG.YScale = 9 -- ¼¾•±???Œ?
CONFIG.MidSF2 = "";
CONFIG.MMapAddX=2;
CONFIG.MMapAddY=2;
CONFIG.SMapAddX=2;
CONFIG.SMapAddY=16;
CONFIG.WMapAddX=2;
CONFIG.WMapAddY=16;

--???ØÁã£¬-1˜¡??ØÁã
CONFIG.W=CONFIG.Width
CONFIG.H=CONFIG.Height
CONFIG.Zoom = 100
CONFIG.D1X = math.modf(CONFIG.W/8.5)  --ªÏ
CONFIG.D1Y = math.modf(CONFIG.H/2.4)
CONFIG.D2X = math.modf(CONFIG.W/4.2)  --ÌÁ
CONFIG.D2Y = math.modf(CONFIG.H/1.6)
CONFIG.D3X = math.modf(CONFIG.W/8.5) --¹¶
CONFIG.D3Y = math.modf(CONFIG.H/1.2)
CONFIG.D4X = 0; --­U
CONFIG.D4Y = math.modf(CONFIG.H/1.6)
CONFIG.C1X = math.modf(CONFIG.W/1.6) --S
CONFIG.C1Y = 0
CONFIG.C2X = math.modf(CONFIG.W/1.16) --H
CONFIG.C2Y = 0
CONFIG.AX = math.modf(CONFIG.W/1.82) --esc
CONFIG.AY = math.modf(CONFIG.H/1.2)
CONFIG.BX = math.modf(CONFIG.W/1.28) --??
CONFIG.BY = math.modf(CONFIG.H/1.16)