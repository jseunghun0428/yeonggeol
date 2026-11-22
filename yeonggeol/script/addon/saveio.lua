-- ko 4.0: 세이브 옮기기 (addon "saveio", Android only). The title menu row opens a screen with 내보내기 / 가져오기:
-- the engine (lib.KoSaveIO, jy_engine.c) asks GameActivity for the system file picker, which does the file work
-- (one zip out; a zip or loose save files in, current saves backed up first) and writes its outcome to
-- ko_saveio.txt in the game folder, polled here. An imported ko_settings.lua is left as ko_settings_import.lua:
-- only the machine-wide records (koAddon.saveKeys: tourney, free battle, trial, achievements, party presets) are
-- taken from it, so the phone keeps its own screen settings. 5.1 (10-15): on Windows too (see the PC part below).
-- Source: 개발용/addon/saveio_src.lua (UTF-8); script/addon/saveio.lua is made from it by 개발용/도구/free_hz.pl.
if not CONFIG.Windows and type(lib.KoSaveIO)~="function" then return end
local STATUS=CONFIG.CurrentPath.."ko_saveio.txt"
local IMPORT=CONFIG.CurrentPath.."ko_settings_import.lua"
local function readStatus()
local h=io.open(STATUS,"r")
if not h then return nil end
local s=h:read("*a") h:close()
return s
end
-- the records of an imported settings file -> CC (typed like their defaults), then saved; returns how many
local function mergeSettings()
local h=io.open(IMPORT,"r")
if not h then return 0 end
local src=h:read("*a") h:close()
os.remove(IMPORT)
local env={CC={}}
local chunk=load(src,"import","t",env)
if not chunk or not pcall(chunk) then return 0 end
local n=0
for _,s in ipairs(koAddon.saveKeys) do
local v=env.CC[s.key]
if v~=nil and type(v)==type(s.default) then CC[s.key]=v n=n+1 end
end
if n>0 then koSave() end
return n
end
local function words(s) local t={} for w in string.gmatch(s or "","%S+") do t[#t+1]=w end return t end

-- ko 5.1 (10-15, 사용자 "PC \129\102\129\068 \131\095\131\115\131\095\131\071\161\164\129\094\136\107\129\091\131\071"): on Windows the same screen does the work here, with ko_sdl.dll
-- (ko_zip.txt -> ko_zip_out.txt) for the Save / Open dialogs, writing and reading zips and copying into folders the Lua side
-- cannot make. Same rules as GameActivity.java: save0~9 · auto~auto3 (.sav .blog .wtg, origin/ too), newgen/NN/.. pictures,
-- genedit/<tag>.kgs (gesync), ko_settings.lua -> ko_settings_import.lua; the current files go first into
-- save_backup/<time>.zip (newest 5 kept). A 조형 팩 zip is left to the 조형 교체기 on the PC.
local PC=CONFIG.Windows
local SD=(string.gsub(string.sub(CONFIG.Save,#CONFIG.CurrentPath+1),"\\","/"))   -- CONFIG.Save, with '/' (6.0 stories: data/save/<id>/; addons never run in pure mode)
local CAMP=CONFIG.koCamp or "yeonggeol"-- ko 6.0 (11-01): whose files these are (mode.txt in the zip)
local CAMPNAME={yeonggeol="\129\126\130\064\130\066",yuanshao="\131\081\129\109\130\066",sunjian="\135\089\134\084\130\066",wuje="\129\073\129\100\130\066"}
local CAMPFILE={yeonggeol=[[영걸전]],yuanshao=[[원소전]],sunjian=[[손견전]],wuje=[[무제전]]}-- zip name (UTF-8)
local SIDES={"wu","ys","sj"}-- a story's own state next to each save: <save>.sav.<x>.lua
local ZREQ,ZOUT=CONFIG.CurrentPath.."ko_zip.txt",CONFIG.CurrentPath.."ko_zip_out.txt"
local function readAll(p) local h=io.open(p,"rb") if not h then return nil end local s=h:read("*a") h:close() return s end
local function exists(p) local h=io.open(p,"rb") if h then h:close() return true end return false end
local function lines(s) local t={} for l in string.gmatch(s or "","[^\r\n]+") do t[#t+1]=l end return t end
-- one request to ko_sdl.dll, drawing the screen until it is answered; nil = an old ko_sdl.dll (nobody took the request)
local function zipAsk(req,draw)
	os.remove(ZOUT)
	local h=io.open(ZREQ,"wb") if not h then return nil end
	h:write(req) h:close()
	local frames=0
	while true do
		JY.ReFreshTime=lib.GetTime()
		if draw then draw(0) end
		ShowScreen()
		local s=readAll(ZOUT)
		if s then os.remove(ZOUT) return s end
		frames=frames+1
		if frames>40 and exists(ZREQ) then os.remove(ZREQ) return nil end
		koPollKey()
		lib.Delay(30)
	end
end
local SAVE_BASES={"auto","auto2","auto3"} for i=0,99 do SAVE_BASES[#SAVE_BASES+1]="save"..i end
local SAVE_EXT={"sav","blog","wtg"}
local function isSaveName(b)
	local stem,ext=string.match(b,"^(.-)%.(%a+)$")
	if not stem then return false end
	local okExt,okStem=false,false
	for _,e in ipairs(SAVE_EXT) do if e==ext then okExt=true end end
	for _,s in ipairs(SAVE_BASES) do if s==stem then okStem=true end end
	if not (okExt and okStem) then for _,x in ipairs(SIDES) do local st=string.match(b,"^(.-)%.sav%."..x.."%.lua$") if st then for _,s in ipairs(SAVE_BASES) do if s==st then return true end end end end end-- ko 6.0 stories
	return okExt and okStem
end
local function saveFiles()
	local t={}
	for _,dir in ipairs({"","origin/"}) do for _,b in ipairs(SAVE_BASES) do for _,e in ipairs(SAVE_EXT) do
		local r=dir..b.."."..e if exists(SD..r) then t[#t+1]=r end
	end end end
	for _,b in ipairs(SAVE_BASES) do for _,x in ipairs(SIDES) do local r=b..".sav."..x..".lua" if exists(SD..r) then t[#t+1]=r end end end-- ko 6.0 stories
	return t
end
local IMGS={"face.bmp","MOV.bmp","SPC.bmp","ATK.bmp","1.bmp","2.bmp"}
local function pictureFiles()
	local t={}
	for id=1,20 do
		local d=string.format("newgen/%02d/",id)
		for _,n in ipairs(IMGS) do if exists(SD..d..n) then t[#t+1]=d..n end end
		for bz=0,45 do for _,n in ipairs({"MOV.bmp","SPC.bmp","ATK.bmp"}) do local r=d.."b"..bz.."/"..n if exists(SD..r) then t[#t+1]=r end end end
	end
	local seen={}
	for w in string.gmatch((readAll(SD.."genedit/list.txt") or "")..","..(CC.koGenEdit or ""),"[^,\r\n]+") do
		if not seen[w] and string.match(w,"^[fwcv][%d_]+$") then seen[w]=true local r="genedit/"..w..".kgs" if exists(SD..r) then t[#t+1]=r end end
	end
	return t
end
-- (GameActivity.pictureRel) the place under data/save for a newgen / genedit file, or nil
local function pictureRel(rel)
	local l=string.lower(rel)
	local id,b,pic=string.match(l,"^newgen/(%d%d)/(b%d%d?/)(%w+)%.bmp$")
	if not id then id,pic=string.match(l,"^newgen/(%d%d)/(%w+)%.bmp$") b="" end
	if id then
		if pic=="mov" or pic=="spc" or pic=="atk" then pic=string.upper(pic)
		elseif not (pic=="face" or pic=="1" or pic=="2") then return nil end
		return "newgen/"..id.."/"..b..pic..".bmp"
	end
	local tag=string.match(l,"^genedit/([fwc]%d+)%.kgs$") or string.match(l,"^genedit/(v%d+_%d+)%.kgs$")
	if tag then return "genedit/"..tag..".kgs" end
	return nil
end
local function pictureOf(path)
	local l=string.lower(path)
	if string.find(l,"origin/",1,true) then return nil end
	local at
	for _,seg in ipairs({"newgen/","genedit/"}) do
		local i=0
		while true do
			local j=string.find(l,seg,i+1,true)
			if not j then break end
			if (j==1 or string.sub(l,j-1,j-1)=="/") and (not at or j>at) then at=j end
			i=j
		end
	end
	return at and pictureRel(string.sub(path,at)) or nil
end
local function currentFiles()   -- "<zip entry>|<file>" for everything an export (or the backup) holds
	local L={}
	for _,r in ipairs(saveFiles()) do L[#L+1]="save/"..r.."|"..SD..r end
	for _,r in ipairs(pictureFiles()) do L[#L+1]="save/"..r.."|"..SD..r end
	local ks=CONFIG.koCamp and SD.."ko_settings.lua" or "ko_settings.lua"-- ko 6.0 stories: that story's own records
	if exists(CONFIG.CurrentPath..ks) then L[#L+1]="ko_settings.lua|"..ks end
	do local h=io.open(CONFIG.CurrentPath.."ko_zip_mode.txt","wb") if h then h:write(CAMP) h:close() L[#L+1]="mode.txt|ko_zip_mode.txt" end end
	return L
end
local function backup(draw)
	local L=currentFiles()
	if #L==0 then return end
	local st=os.date("%Y%m%d_%H%M%S")
	zipAsk("zipto save_backup/"..st..".zip\n"..table.concat(L,"\n"),draw)
	local idx=CONFIG.CurrentPath.."save_backup/list.txt"
	local kept=lines(readAll(idx))
	kept[#kept+1]=st
	while #kept>5 do os.remove(CONFIG.CurrentPath.."save_backup/"..table.remove(kept,1)..".zip") end
	local h=io.open(idx,"wb") if h then h:write(table.concat(kept,"\n").."\n") h:close() end
end
local function pcExport(draw)
	local L=currentFiles()
	local rm=CONFIG.CurrentPath.."ko_zip_readme.txt"
	local h=io.open(rm,"wb")
	if h then   -- (long strings stay UTF-8: free_hz.pl turns only "..." into font codes)
		h:write([[삼국지 영걸전 복각 유광판 세이브 (]]..os.date("%Y-%m-%d %H:%M")..")\r\n"..[[
휴대폰: 타이틀 메뉴 "\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071" > 가져오기 에서 이 zip 을 고르세요.
PC: 타이틀 메뉴 "\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071" > 가져오기 에서 이 zip 을 고르세요.
    (손으로 넣을 때는 save 폴더 안의 것을 게임 폴더의 data\save 에 그대로 넣습니다. origin · newgen · genedit 폴더도)
신무장 · 장수편집 그림은 가져온 뒤 타이틀로 돌아오면 들어갑니다.
]])
		h:close()
		L[#L+1]=[[읽어보기.txt]].."|ko_zip_readme.txt"
	end
	local head=rawget(_G,"koSaveIOTestZip") and ("zipto "..rawget(_G,"koSaveIOTestZip")) or ("export\n"..(CAMPFILE[CAMP] or [[영걸전]])..[[_저장_]]..os.date("%Y%m%d_%H%M")..".zip")   -- (tests: no dialog)
	local s=zipAsk(head.."\n"..table.concat(L,"\n"),draw)
	os.remove(rm)
	if not s then return "error olddll" end
	local w=words(s)
	if w[1]=="1" then return "ok export "..math.max(0,(tonumber(w[2]) or 1)-(h and 1 or 0)) end
	if w[1]=="0" then return "cancel" end
	return "error "..(w[2] or "write")
end
local function pcImport(draw)
	local s=zipAsk("import\n"..(rawget(_G,"koSaveIOTestImport") or ""),draw)   -- (tests: these files instead of the dialog)
	if not s then return "error olddll" end
	local got=lines(s)
	if got[1]=="0" then return "cancel" end
	if got[1]~="1" then return "error unzip" end
	local names,seen={},{}
	for i=2,#got do if not seen[got[i]] then seen[got[i]]=true names[#names+1]=got[i] end end
	for _,nm in ipairs(names) do
		if string.lower(string.match(nm,"[^/]*$"))=="johyeong.txt" then zipAsk("files\nr ko_import",draw) return "error pack" end
	end
	local zmode="yeonggeol"-- ko 6.0 (11-01): a zip without mode.txt is from before the stories (yeonggeol)
	for _,nm in ipairs(names) do if string.lower(string.match(nm,"[^/]*$"))=="mode.txt" then local h=io.open(CONFIG.CurrentPath.."ko_import/"..nm,"rb") if h then zmode=string.match(h:read("*a") or "","[%w_]+") or zmode h:close() end end end
	if zmode~=CAMP then zipAsk("files\nr ko_import",draw) return "error mode "..zmode end
	local ops,written,ng,ge={},{},{},{}
	local n,set,skip=0,false,0
	for _,nm in ipairs(names) do
		local base=string.lower(string.match(nm,"[^/]*$"))
		local pic=pictureOf(nm)
		if pic then
			if string.sub(pic,1,7)=="newgen/" then   -- that general's folder is emptied before its first picture
				local id=string.sub(pic,8,9)
				if not ng[id] then ng[id]=true ng[#ng+1]=id ops[#ops+1]="r "..SD.."newgen/"..id end
			else
				local tag=string.sub(pic,9,-5)
				if not ge[tag] then ge[tag]=true ge[#ge+1]=tag end
			end
			ops[#ops+1]="c ko_import/"..nm.."|"..SD..pic
			n=n+1
		elseif isSaveName(base) then
			local dest=SD..(string.find(string.lower(nm),"origin/",1,true) and "origin/" or "")..base
			ops[#ops+1]="c ko_import/"..nm.."|"..dest
			written[dest]=true
			n=n+1
		elseif base=="mode.txt" then
		elseif base=="ko_settings.lua" then
			ops[#ops+1]="c ko_import/"..nm.."|ko_settings_import.lua"
			set=true
		else skip=skip+1 end
	end
	if #ops>0 then backup(draw) end
	-- a save taken without its battle log / battle goals: the old ones of that slot belong to another game
	for dest,_ in pairs(written) do
		local stem=string.match(dest,"^(.*)%.sav$")
		if stem then for _,side in ipairs({".blog",".wtg",".sav.wu.lua",".sav.ys.lua",".sav.sj.lua"}) do if not written[stem..side] then ops[#ops+1]="d "..stem..side end end end
	end
	ops[#ops+1]="r ko_import"
	zipAsk("files\n"..table.concat(ops,"\n"),draw)
	-- for gesync at the next title: these go in even over this PC's own picture in that cell
	local function append(p,list) if #list==0 then return end local h=io.open(p,"ab") if h then h:write(table.concat(list,"\n").."\n") h:close() end end
	append(CONFIG.CurrentPath..SD.."newgen/imported.txt",ng)
	append(CONFIG.CurrentPath..SD.."genedit/imported.txt",ge)
	return "ok import "..n.." "..(set and 1 or 0).." "..skip
end
koSaveIOPC={export=pcExport,import=pcImport}   -- (tests)
function koSaveIOScreen()
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
local cx=ox+384
local function ctext(y,s,color,size) size=size or 16 DrawString(ox+40,y,s,color or M_White,size) end
local msg,msg2,mcol="","",M_White
local busy=false
local btns={
{x=cx-280,y=oy+380,w=170,h=30,s="\131\095\131\115\131\095\131\071"},
{x=cx-85,y=oy+380,w=170,h=30,s="\129\094\136\107\129\091\131\071"},
{x=cx+110,y=oy+380,w=170,h=30,s="\137\066\129\110\129\094\131\071"},
}
for _,b in ipairs(btns) do
b.draw=function(b,on,hover)
koRecordClassicBar(b.x,b.y+4,b.w,on or hover)
DrawString(b.x+b.w/2-#b.s*4,b.y+7,b.s,M_White,16)
end
end
local function draw(hov)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
koRecordClassicFrame(ox,oy,768,480)
lib.FillColor(ox+24,oy+84,ox+744,oy+146,RGB(0,0,48))
lib.FillColor(ox+24,oy+156,ox+744,oy+260,RGB(0,0,48))
lib.DrawRect(ox+24,oy+74,ox+744,oy+74,M_Silver)
lib.DrawRect(ox+24,oy+366,ox+744,oy+366,M_Silver)
ctext(oy+40,"\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071",C_Name,24)
ctext(oy+100,"\131\095\131\115\131\095\131\071: \133\102\131\097 \134\086\133\073 100\135\066\161\164\133\120\130\108 \133\102\131\097\161\164\130\066\132\101 \131\071\133\108\129\123 \129\071 \131\071\131\071\131\080 \131\071\133\108\129\083",M_White)
ctext(oy+124,"zip \134\086\133\073 \129\097\131\118\132\083 \131\081\129\097\130\098 \135\069(\129\077\135\083\132\083\133\119\161\164\134\070\130\102\131\079\133\119 \133\125)\129\102 \133\102\131\097\129\087\129\076\129\077",M_White)
if PC then ctext(oy+164,"\129\094\136\107\129\091\131\071: \130\120\130\095\193\138\129\071\131\118 PC \129\102\131\087 \131\095\131\115\136\090 zip, \133\102\131\097 \134\086\133\073(save0.sav \133\125)\129\083 \134\112\129\075\129\076\129\077",M_White)
else ctext(oy+164,"\129\094\136\107\129\091\131\071: \131\091 zip \129\071\131\118 PC \131\080 \133\102\131\097 \134\086\133\073(save0.sav \133\125)\129\083 \134\112\129\075\129\076\129\077",M_White) end
ctext(oy+188,"\132\071\131\098 \135\066\131\098 \129\143\130\083\136\096\134\066, \130\067\131\103 \133\102\131\097 \134\086\133\073\131\098 \137\113\133\102 save_backup \129\102 \131\115\129\101\129\087\129\076\129\077",M_Silver)
ctext(oy+212,"\131\071\131\071 \131\071\133\108\131\098 \129\071 \131\071\131\071\131\080 \129\064\129\065 \129\069\129\070\129\083 \131\091\130\095\132\083 \130\091\131\100 \131\071\133\108\132\086 \129\087\138\126\129\076\129\077",M_Silver)
if PC then ctext(oy+236,"\131\078\129\073\131\097 \161\164 \131\097\129\113\132\075\134\076 \131\091\130\079\129\068 \137\072\138\095 \139\090\140\086\129\076\129\077 (\129\118\136\069 \205\131\131\098 \129\118\136\069 \132\087\133\114\131\071\132\083)",M_Silver)
else ctext(oy+236,"\131\078\129\073\131\097 \161\164 \131\097\129\113\132\075\134\076 \131\091\130\079\129\068 \137\072\138\095 \139\090\131\071\134\066, \129\118\136\069 \205\131 zip \129\068 \134\112\129\083 \129\113 \132\079\129\075\129\076\129\077",M_Silver) end
if busy then ctext(oy+280,"\134\086\133\073 \133\109\133\110 \134\103\129\102\131\087 \131\100\130\106\131\111\129\090\161\173",C_Name)
else
ctext(oy+270,msg,mcol)
if msg2~="" then ctext(oy+296,msg2,M_Silver) end
end
end
local function run(mode)
if PC then
busy=true
local ok,r=pcall(mode=="export" and pcExport or pcImport,draw)
busy=false
if not ok then lib.Debug("saveio pc: "..tostring(r)) return "error script" end
return r
end
os.remove(STATUS)
-- ko 6.0 (11-03): in a story the phone side gets its id ("export wuje"): GameActivity moves data/save/<id>/ and that
-- story's ko_settings.lua, puts mode.txt in the zip and refuses another story's zip ("error mode <id>"), like the PC part
if not lib.KoSaveIO(CONFIG.koCamp and (mode.." "..CAMP) or mode) then return "error nocall" end
local t0=lib.GetTime()
busy=true
while true do
JY.ReFreshTime=lib.GetTime()
draw(0)
ShowScreen()
local s=readStatus()
if s and s~="wait" then busy=false os.remove(STATUS) return s end
if not s and lib.GetTime()-t0>5000 then busy=false return "error nostatus" end
koPollKey()
lib.Delay(50)
end
end
while true do
local r=koTourWait(draw,btns)
if r==0 or r==3 then return end
local mode=(r==1) and "export" or "import"
local w=words(run(mode))
msg2=""
if w[1]=="ok" and w[2]=="export" then
msg,mcol="\131\095\131\115\132\106\129\075\129\076\129\077 (\134\086\133\073 "..(w[3] or "0").."\134\075)",C_Name
elseif w[1]=="ok" and w[2]=="import" then
local n,set,skip=tonumber(w[3]) or 0,w[4]=="1",tonumber(w[5]) or 0
local rec=set and mergeSettings() or 0
if n==0 and rec==0 then
msg,mcol="\129\094\136\107\134\091 \133\102\131\097 \134\086\133\073\129\071 \130\097\129\075\129\076\129\077",M_Yellow
msg2="\133\102\131\097 \134\086\133\073(save0.sav \133\125)\129\071\131\118 \131\095\131\115\131\095\131\071\132\083 \132\086\136\101 zip \129\083 \140\065\130\102 \130\075\131\111\129\090"
else
msg,mcol="\129\094\136\107\138\088\129\075\129\076\129\077 (\133\102\131\097 \134\086\133\073 "..n.."\134\075"..((rec>0) and (", \131\071\131\071 \131\071\133\108 "..rec.."\135\103\131\099") or "")..")",C_Name
msg2=(skip>0) and ("\133\102\131\097 \134\086\133\073\129\071 \129\110\134\109 \131\117 "..skip.."\134\075\130\098 \129\119\129\072\136\099\132\107\129\075\129\076\129\077") or "\133\100\133\101\129\091\131\071 \131\099\133\108\129\102\131\087 \131\085\132\083 \131\100\130\104 \129\113 \132\079\129\075\129\076\129\077"
end
elseif w[1]=="ok" and w[2]=="pack" then
-- 4.0: a johyeong pack (PC tool) went in: faces / unique battle / unique city, then saves picked along with it
local saves=tonumber(w[6]) or 0
msg,mcol="\129\118\136\069\129\083 \134\112\132\107\129\075\129\076\129\077 (\140\118\134\094 "..(w[3] or "0").." \161\164 \130\066\132\101 "..(w[4] or "0").."\130\088 \161\164 \129\068\130\086 "..(w[5] or "0").."\130\088)",C_Name
msg2="\129\081\129\082\129\083 \134\108\130\066\138\087 \136\097\131\100 \129\077\130\086 \137\097\129\065 \134\068 \130\090\129\075\129\071 \131\118\133\111\129\076\129\077"..((saves>0) and (" (\133\102\131\097 \134\086\133\073 "..saves.."\134\075\129\068 \137\072\138\095 \134\112\132\107\129\075\129\076\129\077)") or "")
elseif w[1]=="cancel" then
msg,mcol="\129\108\129\109\129\080\129\075\129\076\129\077",M_Silver
elseif w[1]=="error" and w[2]=="pack" then
msg,mcol="\129\118\136\069 \205\131\129\104\129\076\129\077",M_Yellow
msg2="PC \129\102\131\087\130\098 \129\118\136\069 \132\087\133\114\131\071\131\080 [\129\118\136\069 \205\131 \129\094\136\107\129\091\131\071] \132\083 \134\112\130\083 \130\075\131\111\129\090"
elseif w[1]=="error" and w[2]=="mode" then
msg,mcol=(CAMPNAME[w[3]] or w[3] or "?").."\131\080 \133\102\131\097 \134\086\133\073\129\104\129\076\129\077",M_Yellow
msg2="\130\067\131\103\131\098 "..CAMPNAME[CAMP].." \133\102\131\097 \134\086\133\073\132\086 \134\112\129\083 \129\113 \132\079\129\075\129\076\129\077 (\129\253\129\106 \129\064\129\065\129\102\131\087 \129\071\133\069\131\071\130\104 \131\100\135\077 \135\068 \129\094\136\107\129\091\131\071)"
elseif w[1]=="error" and w[2]=="campphone" then
msg,mcol="\130\120\130\095\193\138\129\102\131\087\130\098 \129\110\132\076 \129\126\130\064\130\066 \133\102\131\097 \134\086\133\073\132\086 \139\090\134\114 \129\113 \132\079\129\075\129\076\129\077",M_Yellow
msg2="\129\077\135\077 \129\071\133\069\131\071\131\080 \133\102\131\097 \134\086\133\073 \139\090\131\071\131\071\130\098 \129\077\130\077 \130\070\129\102\131\087 \134\112\134\121\129\075\129\076\129\077"
elseif w[1]=="error" and w[2]=="olddll" then
msg,mcol="ko_sdl.dll \129\071 \140\094 \130\070\129\104\129\076\129\077",M_Yellow
msg2="\129\081\129\082 \193\142\132\108\131\080 ko_sdl.dll \129\083 \134\068 \130\070\131\109\132\083 \131\085\143\097 \130\075\131\111\129\090"
else
msg,mcol="\139\110\129\117\129\097\130\067 \136\102\129\080\129\075\129\076\129\077 ("..table.concat(w," ",2)..")",M_Yellow
end
end
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071",main=true,run=function() koSaveIOScreen() end}   -- 10-15: on the first list, not under 다른 모드
