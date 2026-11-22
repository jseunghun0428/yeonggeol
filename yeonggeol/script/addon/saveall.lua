-- 11-11 사용자 「저장 파일 옮기기를 메인으로 옮기고 네 모드 전체를 한 번에」 (addon "saveall", PC): 메인 화면 「저장 옮기기」.
--  공용 기록(무장 도감 · 보물 도감 · 장수편집 · 신무장)과 이야기별 기록이 따로 움직여 어긋나지 않게, 네 이야기의 세이브 · 기록을 한 zip 으로.
--  zip: mode.txt("all") + save/<세이브 폴더 기준 경로>(영걸전 = data/save/ 바로 아래 · origin/, 이야기 = wuje/ · sunjian/ · yuanshao/)
--       + ko_settings_root.lua(게임 폴더 ko_settings.lua = 영걸전 기록 · 공용 기록 · 화면 설정).
--  세이브 칸: save0~99 · auto~auto3 · temp · exp · rewind · clear · town_battle 의 .sav · .blog · .wtg · .rws, 이야기 옆 파일 .sav.wu|ys|sj.lua,
--  ko_records.lua, 이야기 ko_settings.lua, 공용 그림(genedit/*.kgs · list · shared, newgen/NN/…, newgen_registry.txt).
--  가져오기: 지금 것 전부를 save_backup/<시각>.zip 에 먼저(5개까지), 파일을 그 자리에 복사(.sav 만 오고 .blog · .wtg 가 안 오면 옛 것은 지움),
--  게임 폴더 ko_settings.lua 는 화면 설정은 두고 기록(koAddon.saveKeys)만 바꿈, 그림은 imported.txt 로 gesync 가 다시 넣게 한 뒤
--  같은 실행 안에서 다시 띄움(koSoftRestart) — 모든 기록을 새로 읽게. 이야기 하나짜리 옛 zip(mode.txt = 이야기 id)은 그 이야기 폴더로.
--  11-13: 휴대폰도 같은 화면 · 같은 zip (사용자 제보 「PC 와 모바일 저장이 호환이 안 됨」). ko_zip.txt 요청을 PC 는 ko_sdl.dll 이,
--  휴대폰은 lib.KoSaveIO("zip") → GameActivity.java koZip 이 같은 규칙으로 처리(내보내기 · 가져오기 = 시스템 파일 창). 옛 이야기별 zip(saveio)도 가져옴:
--  zip 맨 위 ko_settings.lua(옛 saveio · 휴대폰 zip 의 기록)는 영걸전이면 게임 폴더 ko_settings.lua, 이야기면 data/save/<이야기>/ko_settings.lua 에 기록만 합침.
--  빌드: perl 개발용/도구/free_hz.pl < 개발용/addon/saveall_src.lua > script/addon/saveall.lua (게임 폴더에서)
if CONFIG.koPure then return end
local PHONE=not CONFIG.Windows
if PHONE and type(lib.KoSaveIO)~="function" then return end   -- 엔진이 옛 판: 이야기별 saveio 그대로
local MODES={{"yeonggeol",""},{"wuje","wuje/"},{"sunjian","sunjian/"},{"yuanshao","yuanshao/"}}
local ROOT="data/save/"
local function readAll(p) local h=io.open(p,"rb") if not h then return nil end local s=h:read("*a") h:close() return s end
local function writeAll(p,s) local h=io.open(p,"wb") if not h then return false end h:write(s) h:close() return true end
local function exists(p) local h=io.open(p,"rb") if h then h:close() return true end return false end
local function zipAsk(req)
	local ZREQ,ZOUT=CONFIG.CurrentPath.."ko_zip.txt",CONFIG.CurrentPath.."ko_zip_out.txt"
	os.remove(ZOUT)
	if not writeAll(ZREQ,req) then return nil end
	if PHONE and not lib.KoSaveIO("zip") then os.remove(ZREQ) return nil end   -- 휴대폰: GameActivity 가 ko_zip.txt 를 읽고 지움
	local frames=0
	while true do
		JY.ReFreshTime=lib.GetTime()
		ShowScreen()
		local s=readAll(ZOUT)
		if s then os.remove(ZOUT) return s end
		frames=frames+1
		if frames>40 and exists(ZREQ) then os.remove(ZREQ) return nil end
		koPollKey()
		lib.Delay(30)
	end
end
local BASES={"auto","auto2","auto3","temp","exp","rewind","clear","town_battle"} for i=0,99 do BASES[#BASES+1]="save"..i end
local EXTS={"sav","blog","wtg","rws"}
local SIDES={"wu","ys","sj"}
local IMGS={"face.bmp","MOV.bmp","SPC.bmp","ATK.bmp","1.bmp","2.bmp"}
-- 세이브 폴더 기준 경로(예 "wuje/save0.sav") 목록
local function modeFiles(sub)
	local t={}
	local dirs={sub} if sub=="" then dirs[2]="origin/" end
	for _,d in ipairs(dirs) do
		for _,b in ipairs(BASES) do
			for _,e in ipairs(EXTS) do local r=d..b.."."..e if exists(CONFIG.CurrentPath..ROOT..r) then t[#t+1]=r end end
			for _,x in ipairs(SIDES) do local r=d..b..".sav."..x..".lua" if exists(CONFIG.CurrentPath..ROOT..r) then t[#t+1]=r end end
		end
	end
	for _,n in ipairs({"ko_records.lua","ko_settings.lua"}) do if sub~="" and exists(CONFIG.CurrentPath..ROOT..sub..n) then t[#t+1]=sub..n end end
	if sub=="" then
		if exists(CONFIG.CurrentPath..ROOT.."ko_records.lua") then t[#t+1]="ko_records.lua" end
		if exists(CONFIG.CurrentPath..ROOT.."newgen_registry.txt") then t[#t+1]="newgen_registry.txt" end
		for _,n in ipairs({"list.txt","shared.txt"}) do if exists(CONFIG.CurrentPath..ROOT.."genedit/"..n) then t[#t+1]="genedit/"..n end end
		local seen={}
		for w in string.gmatch((readAll(CONFIG.CurrentPath..ROOT.."genedit/list.txt") or "")..","..(CC.koGenEdit or ""),"[^,\r\n]+") do
			if not seen[w] and string.match(w,"^[fwcv][%d_]+$") then seen[w]=true local r="genedit/"..w..".kgs" if exists(CONFIG.CurrentPath..ROOT..r) then t[#t+1]=r end end
		end
		for id=1,20 do
			local d=string.format("newgen/%02d/",id)
			for _,n in ipairs(IMGS) do if exists(CONFIG.CurrentPath..ROOT..d..n) then t[#t+1]=d..n end end
			for bz=0,45 do for _,n in ipairs({"MOV.bmp","SPC.bmp","ATK.bmp"}) do local r=d.."b"..bz.."/"..n if exists(CONFIG.CurrentPath..ROOT..r) then t[#t+1]=r end end end
		end
	end
	return t
end
local function allEntries()
	local L,n={},0
	for _,m in ipairs(MODES) do for _,r in ipairs(modeFiles(m[2])) do L[#L+1]="save/"..r.."|"..ROOT..r if string.match(r,"%.sav$") then n=n+1 end end end
	if exists(CONFIG.CurrentPath.."ko_settings.lua") then L[#L+1]="ko_settings_root.lua|ko_settings.lua" end
	writeAll(CONFIG.CurrentPath.."ko_zip_mode.txt","all")
	L[#L+1]="mode.txt|ko_zip_mode.txt"
	return L,n
end
local function backup()
	local L=allEntries()
	local st=os.date("%Y%m%d_%H%M%S")
	zipAsk("zipto save_backup/"..st..".zip\n"..table.concat(L,"\n"))
	local idx=CONFIG.CurrentPath.."save_backup/list.txt"
	local kept={} for l in string.gmatch(readAll(idx) or "","[^\r\n]+") do kept[#kept+1]=l end
	kept[#kept+1]=st
	while #kept>5 do os.remove(CONFIG.CurrentPath.."save_backup/"..table.remove(kept,1)..".zip") end
	writeAll(idx,table.concat(kept,"\n").."\n")
end
local function box(t) WarDrawStrBoxConfirm(t,M_White,true) end
local function doExport()
	local L,n=allEntries()
	local tz=rawget(_G,"koSaveAllTestZip")   -- (시험: 저장 창 없이)
	local s=zipAsk((tz and ("zipto "..tz) or ("export\n"..[[군웅록_저장_]]..os.date("%Y%m%d_%H%M")..".zip")).."\n"..table.concat(L,"\n"))
	os.remove(CONFIG.CurrentPath.."ko_zip_mode.txt")
	if not s then box("ko_sdl.dll \129\071 \140\094 \130\070\129\071\130\102 \131\095\131\115\137\077 \129\113 \130\097\129\075\129\076\129\077") return end
	local a=string.match(s,"^(%-?%d+)")
	if a=="1" then box("\131\095\131\115\132\106\129\075\129\076\129\077*\132\112 \129\071\133\069\131\071 \131\111\129\071\153\228 "..n.."\134\075\135\122 \131\071\133\108 \161\164 \131\097\129\113\132\075\134\076 \161\164 \131\078\129\073\131\097 \161\164 \129\068\135\078") elseif a~="0" then box("\131\095\131\115\131\095\130\067 \136\102\129\080\129\075\129\076\129\077") end
end
-- 게임 폴더 ko_settings.lua: 화면 설정은 그대로, 기록(koAddon.saveKeys)만 가져온 값으로
local function mergeRoot(src,p)
	local env={CC={}}
	local f=load(src,"root","t",env)
	if not f or not pcall(f) then return end
	p=p or CONFIG.CurrentPath.."ko_settings.lua"
	local t=readAll(p) or ""
	for _,k in ipairs(koAddon.saveKeys) do local v=env.CC[k.key] if v~=nil and type(v)==type(k.default) then t=koSetLit(t,k.key,v) end end
	writeAll(p,t)
	return env.CC
end
local function doImport()
	local s=zipAsk("import\n"..(rawget(_G,"koSaveAllTestImport") or ""))
	if not s then box("ko_sdl.dll \129\071 \140\094 \130\070\129\071\130\102 \129\094\136\107\131\105 \129\113 \130\097\129\075\129\076\129\077") return end
	local got={} for l in string.gmatch(s,"[^\r\n]+") do got[#got+1]=l end
	if got[1]=="0" then return end
	-- 11-13 휴대폰: 조형 팩 zip 은 GameActivity 가 바로 넣고 "#pack ok pack <\140\118\134\094> <\130\066\132\101> <\129\068\130\086>" 줄로 알림(옛 세이브 옮기기와 같음)
	local packed=false
	for i=#got,2,-1 do
		local a,b,c=string.match(got[i],"^#pack ok pack (%d+) (%d+) (%d+)")
		if a then packed=true end
		if a then box("\129\118\136\069\129\083 \134\112\132\107\129\075\129\076\129\077 (\140\118\134\094 "..a.." \161\164 \130\066\132\101 "..b.."\130\088 \161\164 \129\068\130\086 "..c.."\130\088)*\129\081\129\082\129\083 \134\108\130\066\138\087 \136\097\131\100 \129\077\130\086 \137\097\129\065 \134\068 \130\090\129\075\129\071 \131\118\133\111\129\076\129\077") end
		if string.sub(got[i],1,1)=="#" then table.remove(got,i) end
	end
	local IM=CONFIG.CurrentPath.."ko_import/"
	local mode=string.gsub(readAll(IM.."mode.txt") or "yeonggeol","%s","")
	local sub=""   -- 이야기 하나짜리 옛 zip: 그 이야기 폴더로
	if mode~="all" then for _,m in ipairs(MODES) do if m[1]==mode then sub=m[2] end end end
	local ops,written,n={}, {},0
	for i=2,#got do
		local nm=got[i]
		local r=string.match(nm,"^save/(.+)$")
		if r and not string.find(r,"%.%.") then
			local dest=ROOT..((mode=="all") and "" or sub)..r
			if mode~="all" and r=="ko_settings.lua" and sub=="" then dest=nil end   -- 영걸전 옛 zip 의 기록은 아래 mergeRoot
			if dest then
				if string.match(dest,"newgen/%d%d/") and not written[string.match(dest,"^(.*newgen/%d%d)/")] then local d=string.match(dest,"^(.*newgen/%d%d)/") written[d]=true ops[#ops+1]="r "..d end
				ops[#ops+1]="c ko_import/"..nm.."|"..dest
				written[dest]=true
				if string.match(dest,"%.sav$") then n=n+1 end
			end
		end
	end
	if n==0 and not exists(IM.."ko_settings_root.lua") and not exists(IM.."save/ko_settings.lua") and not exists(IM.."ko_settings.lua") then zipAsk("files\nr ko_import") if not packed then box("\131\111\129\071\153\228 \134\086\133\073\129\071 \130\097\130\098 zip \129\104\129\076\129\077") end return end
	if not rawget(_G,"koSaveAllTestImport") and not WarDrawStrBoxYesNo("\129\094\136\107\131\105\129\089\129\090?*\130\067\131\103 \131\111\129\071\153\228\135\122 \131\071\133\108\131\098 save_backup \193\142\132\108\129\102 \134\101\134\110\129\111 \135\068 \131\085\136\149\129\076\129\077*\129\094\136\107\129\091\129\065 \129\081\129\082\129\083 \129\077\130\086 \133\100\133\101\133\111\129\076\129\077",M_White,true) then zipAsk("files\nr ko_import") return end
	backup()
	for dest,_ in pairs(written) do
		local stem=string.match(dest,"^(.*)%.sav$")
		if stem then for _,side in ipairs({".blog",".wtg",".rws"}) do if not written[stem..side] then ops[#ops+1]="d "..stem..side end end end
	end
	ops[#ops+1]="r ko_import"
	local oldSet=(mode~="all") and readAll(IM.."ko_settings.lua") or nil   -- 11-13: 옛 이야기별 zip(saveio · 휴대폰)은 기록이 zip 맨 위 ko_settings.lua
	local rootSrc=readAll(IM.."ko_settings_root.lua") or ((mode~="all" and sub=="") and (readAll(IM.."save/ko_settings.lua") or oldSet)) or nil
	zipAsk("files\n"..table.concat(ops,"\n"))
	local rc=rootSrc and mergeRoot(rootSrc)
	if oldSet and sub~="" then mergeRoot(oldSet,CONFIG.CurrentPath..ROOT..sub.."ko_settings.lua") end   -- 이야기 기록(자유 전투 · 마왕 토벌 기록 등)
	-- 공용 그림은 다음 타이틀에서 사본대로 다시 넣게 (gesync)
	local tags={} for t in string.gmatch((rc and rc.koGenEdit) or "","[^,]+") do tags[#tags+1]=t end
	if #tags>0 then local o=readAll(CONFIG.CurrentPath..ROOT.."genedit/imported.txt") or "" writeAll(CONFIG.CurrentPath..ROOT.."genedit/imported.txt",o..table.concat(tags,"\n").."\n") end
	local ids={} for id=1,20 do if written[ROOT..string.format("newgen/%02d",id)] then ids[#ids+1]=string.format("%02d",id) end end
	if #ids>0 then local o=readAll(CONFIG.CurrentPath..ROOT.."newgen/imported.txt") or "" writeAll(CONFIG.CurrentPath..ROOT.."newgen/imported.txt",o..table.concat(ids,"\n").."\n") end
	if rawget(_G,"koSaveAllTestImport") then rawset(_G,"koSaveAllResult",{n=n,root=rootSrc~=nil}) return end
	box("\129\094\136\107\138\088\129\075\129\076\129\077 (\131\111\129\071\153\228 "..n.."\134\075)*\129\081\129\082\129\083 \129\077\130\086 \133\100\133\101\133\111\129\076\129\077")
	if type(rawget(_G,"koSoftRestart"))~="function" or not koSoftRestart() then box("\129\081\129\082\129\083 \133\116\129\077\129\094 \129\077\130\086 \137\097 \130\075\131\111\129\090") koExit() end
end
function koSaveAllScreen()
	local c=0
	local Ask=rawget(_G,"koAsk3")
	local r=WarDrawStrBoxYesNo
	-- 내보내기 · 가져오기 · 취소 (newgen 의 ask3 를 빌림, 없으면 예/아니오 두 번)
	if type(rawget(_G,"koGenAsk3"))=="function" then c=koGenAsk3({"\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071","\132\112 \129\071\133\069\131\071 \131\111\129\071\153\228 \161\164 \131\071\133\108 \161\164 \131\097\129\113\132\075\134\076 \161\164 \131\078\129\073\131\097 \161\164 \129\068\135\078\129\083 \129\111 \130\087\129\102"},"\131\095\131\115\131\095\131\071","\129\094\136\107\129\091\131\071","\129\108\129\109")
	else c=WarDrawStrBoxYesNo("\131\095\131\115\137\077\129\089\129\090?*(\129\110\129\076\129\091 = \129\094\136\107\129\091\131\071)",M_White,true) and 1 or 2 end
	if c==1 then doExport() elseif c==2 then doImport() end
end
koSaveAllExportT,koSaveAllImportT=doExport,doImport   -- (시험)
-- PC · 휴대폰(11-13): 이야기별 타이틀 「저장 파일 옮기기」 는 없앰 (메인 화면에서 네 이야기 한 번에)
do
	local L=koAddon.titleMenu or {}
	for i=#L,1,-1 do if L[i].label=="\133\102\131\097 \134\086\133\073 \139\090\131\071\131\071" then table.remove(L,i) end end
end
