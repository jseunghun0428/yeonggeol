-- ko 5.1 (10-15, 사용자 "\131\097\129\113\132\075\134\076 \131\091\130\079 \130\114\132\118\129\083 \131\111\129\071\153\228 \193\142\132\108\129\102 \133\103\131\071\131\100 \130\086\129\074\129\088 \132\085 \129\077\130\086 \134\112\131\071"): addon "gesync"
--  장수편집(newgen 애드온 안)이 바꾼 그림은 data 의 hdgrp · wmap · smap 칸과 unique.lua 목록에만 있어서, 데이터 파일이 바뀌면
--  (휴대폰 APK 업데이트 = assets 를 덮어씀, PC 판 갈이) 사라지고 세이브 옮기기로도 따라가지 않았음. 신무장(세이브 폴더 newgen/NN/
--  의 원본 BMP 사본 + koNewGenSync)과 같은 방식으로:
--  · 사본 = 세이브 폴더 genedit/<표시>.kgs (표시 = CC.koGenEdit 의 f얼굴번호 · w장수 · c장수 · v장수_병종).
--      "KGS1" + 첫 칸 번호 u32 + 원래 그림 길이 u32 + 원래 그림(genedit/orig/<표시>.bin 그대로, v 는 없음) + 넣은 칸들(KOB1).
--  · 타이틀(그리고 장수편집 · 세이브 옮기기 화면에서 나올 때)마다 표시 하나씩:
--      칸 = 사본 → 그대로.  칸 ≠ 사본 → 칸이 원래 그림이거나 이 판에 원래 그림 보관이 없으면(데이터가 바뀜 / 다른 기기에서 옴)
--      사본을 다시 넣음, 아니면 게임 안에서 새로 바꾼 것이니 사본을 새로 씀.  사본 없음 → 지금 칸으로 만듦.
--      v(병종별 세트)는 unique.lua 의 koUniqueBz 에 자리가 없으면 wmap 끝에 새 자리를 잡아 넣음(같은 세트를 쓰던 병종은 같이).
--      w · c 는 unique.lua LIST · CITY 에 다시 적음.
--  · 세이브 옮기기(휴대폰)로 들어온 사본은 GameActivity 가 genedit/imported.txt 에 적어 둠 → 그 표시는 칸이 어떻든 사본을 넣음.
--    신무장도 newgen/imported.txt 의 번호는 그림을 다시 넣음(같은 번호의 휴대폰 신무장 그림이 남아 있어도).
--  · CC.koGenEdit 에 없는 사본은 지움(원래대로 한 것). 가져온 ko_settings 를 아직 합치지 않았으면(ko_settings_import.lua) 전부 미룸.
-- Source: 개발용/addon/gesync_src.lua (UTF-8); script/addon/gesync.lua is made from it by 개발용/도구/free_hz.pl.
if CONFIG.koPure or not (koHas("newgen") and koHas("unique")) then return end

local GS_DIR="genedit/"
local GN={f=1,w=50,c=4,v=50}

local function readAll(p) local f=io.open(p,"rb") if not f then return nil end local s=f:read("*a") f:close() return s end
local function writeAll(p,s) local f=io.open(p,"wb") if not f then return false end f:write(s) f:close() return true end
local function exists(p) local h=io.open(p,"rb") if h then h:close() return true end return false end
local function u16(s,o) return string.byte(s,o+1)+string.byte(s,o+2)*256 end
local function u32(s,o) return u16(s,o)+u16(s,o+2)*65536 end
local function le32(v) return string.char(v%256,math.floor(v/256)%256,math.floor(v/65536)%256,math.floor(v/16777216)%256) end
local function mkdir(p)   -- (newgen 과 같음: 있으면 그만, os.execute 는 PC 에서 cmd 를 띄워 느림)
	local probe=p.."/_ko_probe"
	local ph=io.open(probe,"wb") if ph then ph:close() os.remove(probe) return end
	if rawget(_G,"koTouch") and koTouch() then pcall(os.execute,'mkdir -p "'..p..'"')
	else pcall(os.execute,'mkdir "'..string.gsub(p,"/","\\")..'" >nul 2>&1') end
end
local function dataPath(n) return CONFIG.DataPath..n end
local function gBase(k) return dataPath((k=="f" and "hdgrp") or (k=="c" and "smap") or "wmap") end

-- grp 의 칸 i 부터 n 칸 (빈 칸 = "", 파일 끝 너머도 ""), 파일이 없으면 nil
local function grpGet(base,i,n)
	local f=io.open(base..".idx","rb") if not f then return nil end
	local cnt=math.floor(f:seek("end")/4)
	local e={}
	local lo=math.max(0,i-1)
	f:seek("set",lo*4)
	local s=f:read(math.max(0,math.min(cnt,i+n)-lo)*4) or ""
	f:close()
	for k=lo,math.min(cnt,i+n)-1 do e[k]=u32(s,(k-lo)*4) end
	local g=io.open(base..".grp","rb") if not g then return nil end
	local out={}
	for k=1,n do
		local c=i+k-1
		local a=(c==0) and 0 or e[c-1]
		local b=e[c]
		if a and b and b>a then g:seek("set",a) out[k]=g:read(b-a) or "" else out[k]="" end
	end
	g:close()
	return out
end
local function idxCount(base) local f=io.open(base..".idx","rb") if not f then return 0 end local n=math.floor(f:seek("end")/4) f:close() return n end
-- (newgen 의 grpPut 과 같음) 칸 바꿔 쓰기, 끝 너머 칸은 빈 칸을 채워 붙임
-- 10-25: grp 를 통째로 읽지 않고 1MB 씩 임시 파일로 옮겨 만든 뒤 덮어씀 (32비트 PC 본체가 큰 wmap 에서 메모리가 모자라 꺼지던 것)
local function grpPut(base,ch)
	local idx=readAll(base..".idx")
	local g=io.open(base..".grp","rb")
	if not idx or not g then if g then g:close() end return false end
	local n=math.floor(#idx/4) local e={}
	for i=0,n-1 do e[i]=u32(idx,i*4) end
	idx=nil
	local maxk=-1 for k,_ in pairs(ch) do if k>maxk then maxk=k end end
	if maxk>=n then for i=n,maxk do e[i]=(n>0) and e[n-1] or 0 end n=maxk+1 end
	local keys={} for k,_ in pairs(ch) do if k>=0 and k<n then keys[#keys+1]=k end end
	table.sort(keys)
	local tmp=base..".grp.ko_new"
	local o=io.open(tmp,"wb")
	if not o then g:close() return false end
	local okc=true
	local function copy(from,to,src,dst)
		src:seek("set",from)
		local left=to-from
		while left>0 do
			local s=src:read(math.min(left,1048576))
			if not s or #s==0 then okc=false break end
			if not dst:write(s) then okc=false break end
			left=left-#s
		end
	end
	local pos,delta,ne,ki=0,0,{},1
	for i=0,n-1 do
		local s=(i==0) and 0 or e[i-1]
		if keys[ki]==i then
			copy(pos,s,g,o) o:write(ch[i]) pos=e[i]
			delta=delta+#ch[i]-(e[i]-s) ki=ki+1
		end
		ne[i]=e[i]+delta
	end
	local total=g:seek("end")
	if total>pos then copy(pos,total,g,o) end
	g:close() o:close()
	if not okc then os.remove(tmp) return false end
	local t=io.open(tmp,"rb")
	local w=io.open(base..".grp","wb")
	if not (t and w) then if t then t:close() end if w then w:close() end os.remove(tmp) return false end
	copy(0,total+delta,t,w)
	t:close() w:close()
	os.remove(tmp)
	if not okc then return false end
	local ib={} for i=0,n-1 do ib[#ib+1]=le32(ne[i]) end
	return writeAll(base..".idx",table.concat(ib))
end
-- KOB1 (newgen 의 packCells 와 같은 꼴)
local function packCells(cells)
	local h={"KOB1",string.char(0),string.char(#cells%256,math.floor(#cells/256))}
	for _,c in ipairs(cells) do h[#h+1]=le32(#c) end
	for _,c in ipairs(cells) do h[#h+1]=c end
	return table.concat(h)
end
local function unpackCells(s)
	if not s or string.sub(s,1,4)~="KOB1" or #s<7 then return nil end
	local n=u16(s,5) local L={} local p=8+n*4
	for k=1,n do local v=u32(s,7+(k-1)*4) L[k]=string.sub(s,p,p+v-1) p=p+v end
	return L
end
local function same(a,b)
	if not a or not b or #a~=#b then return false end
	for k=1,#a do if a[k]~=b[k] then return false end end
	return true
end
local function blank(c) for k=1,#c do if c[k]~="" then return false end end return true end

-- 11-11: 장수편집 공용 — 사본 · list · imported 는 공용 폴더(newgen koGenShare.dir(), data/save/genedit/), 공용 전이면 모드 세이브 폴더 그대로
local function GSD() local K=rawget(_G,"koGenShare") if K and K.on() then return K.dir() end return CONFIG.Save..GS_DIR end
local function copyPath(tag) return GSD()..tag..".kgs" end
local function origPath(tag) return CONFIG.CurrentPath.."genedit/orig/"..tag..".bin" end
local function readCopy(tag)
	local s=readAll(copyPath(tag))
	if not s or string.sub(s,1,4)~="KGS1" or #s<12 then return nil end
	local at,ol=u32(s,4),u32(s,8)
	local orig=string.sub(s,13,12+ol)
	local cells=unpackCells(string.sub(s,13+ol))
	if not cells then return nil end
	return {at=at,orig=orig,cells=cells}
end
local function writeCopy(tag,at,orig,cells)
	mkdir(string.sub(GSD(),1,-2))
	orig=orig or ""
	return writeAll(copyPath(tag),"KGS1"..le32(at)..le32(#orig)..orig..packCells(cells))
end

-- unique.lua 의 LIST · CITY · BZ 칸 (newgen 의 listWrite · bzWrite 와 같은 꼴: LIST · CITY 는 있던 순서 그대로, 421 이상은 파일에 있던 것만)
local function uniqueWrite(lists,bz)
	local path=CONFIG.ScriptPath.."addon/unique.lua"
	local s=readAll(path) if not s then return false end
	local nl=string.find(s,"\r\n",1,true) and "\r\n" or "\n"
	local function put(b,e,out)
		local i1=string.find(s,b,1,true) local i2=string.find(s,e,1,true)
		if not (i1 and i2 and i2>i1) then return false end
		s=string.sub(s,1,i1+#b-1)..nl..table.concat(out,nl)..((#out>0) and nl or "")..string.sub(s,i2)
		return true
	end
	local function list(tbl,b,e)
		local i1=string.find(s,b,1,true) local i2=string.find(s,e,1,true)
		if not (i1 and i2 and i2>i1) then return false end
		local seen,out={},{}
		for x in string.gmatch(string.sub(s,i1+#b,i2-1),"%[(%d+)%]=true") do local pid=tonumber(x) if tbl[pid] and not seen[pid] then seen[pid]=true out[#out+1]="["..pid.."]=true," end end
		local add={} for pid,v in pairs(tbl) do if v and not seen[pid] and type(pid)=="number" and pid<=420 then add[#add+1]=pid end end
		table.sort(add)
		for _,pid in ipairs(add) do out[#out+1]="["..pid.."]=true," end
		return put(b,e,out)
	end
	if lists then
		if not (list(koUniqueWar,"--LIST BEGIN","--LIST END") and list(koUniqueCity,"--CITY BEGIN","--CITY END")) then return false end
	end
	if bz then
		local out={}
		if koUniqueBz.free and #koUniqueBz.free>0 then out[#out+1]="free={"..table.concat(koUniqueBz.free,",").."}," end
		local pids={} for pid,_ in pairs(koUniqueBz) do if type(pid)=="number" then pids[#pids+1]=pid end end table.sort(pids)
		for _,pid in ipairs(pids) do
			local t,ks,parts=koUniqueBz[pid],{},{}
			for b2,_ in pairs(t) do ks[#ks+1]=b2 end table.sort(ks)
			for _,b2 in ipairs(ks) do parts[#parts+1]="["..b2.."]="..t[b2] end
			if #parts>0 then out[#out+1]="["..pid.."]={"..table.concat(parts,",").."}," end
		end
		if not put("--BZ BEGIN","--BZ END",out) then return false end
	end
	return writeAll(path,s)
end

-- 들어온 목록 파일 (한 줄에 하나), 읽고 지움
local function takeList(path)
	local s=readAll(path) if not s then return {} end
	os.remove(path)
	local t={} for w in string.gmatch(s,"[^\r\n]+") do t[w]=true end
	return t
end

local function parse(tag)
	local x=string.match(tag,"^f(%d+)$") if x then return "f",tonumber(x) end
	x=string.match(tag,"^w(%d+)$") if x then return "w",tonumber(x) end
	x=string.match(tag,"^c(%d+)$") if x then return "c",tonumber(x) end
	local p,b=string.match(tag,"^v(%d+)_(%d+)$") if p then return "v",tonumber(p),tonumber(b) end
	return nil
end
local function fixedAt(k,a) if k=="f" then return a elseif k=="w" then return 20000+a*50 else return 200+(300+a)*4 end end

-- 6.0 (11-01, 사용자 「신무장 등록 · 장수편집은 이야기마다 따로 — 이야기마다 개성 있게」): 등록부(CC.koNewGen) · 편집 표시(CC.koGenEdit) ·
-- 능력치는 이야기마다 그 이야기의 ko_settings 에 있고, 그림은 모두 같은 data 의 hdgrp · wmap · smap 칸에 들어감.
-- 그래서 칸마다 「지금 어느 이야기 그림이 들어 있나」를 게임 폴더 genedit/owners.txt (한 줄 = 표시<TAB>이야기)에 적어 두고, 시작할 때:
--  · 이 이야기의 표시인데 주인이 다른 이야기 → 이 이야기 사본을 다시 넣음 (게임 안에서 바꾼 것으로 보지 않음)
--  · 다른 이야기만의 표시 → 그 칸을 원래 그림(genedit/orig)으로 되돌림. 전투 · 평상 조형은 원래 칸이 비었으면 이번 실행 동안 고유 조형 표시를
--    끔(unique.lua 파일은 그대로 — 주인 이야기가 다시 켬), 병종 세트(v)는 이번 실행 동안 목록에서만 뺌. 그 이야기로 돌아가면 그쪽 사본이 다시 들어감
--  · 신무장 그림(표시 n<번호>, 칸 = 신무장 번호)은 이 이야기 등록부에 있고 주인이 다르면 이 이야기 세이브 폴더 사본으로 다시 넣음
local MODE=CONFIG.koCamp or "yeonggeol"
local OWN_FILE=CONFIG.CurrentPath.."genedit/owners.txt"
local extraForced={}
local function ownersRead()
	local t={}
	for l in string.gmatch(readAll(OWN_FILE) or "","[^\r\n]+") do local tag,m=string.match(l,"^(%S+)\t(%S+)$") if tag then t[tag]=m end end
	return t
end
local function ownersWrite(t)
	local L={} for tag,m in pairs(t) do L[#L+1]=tag.."\t"..m end table.sort(L)
	mkdir(CONFIG.CurrentPath.."genedit")
	writeAll(OWN_FILE,table.concat(L,"\n")..((#L>0) and "\n" or ""))
end
-- 다른 이야기만 바꾼 칸을 원래대로 (주인 기록은 남김: 이 이야기로 올 때마다 다시 확인)
local function foreignRestore(O,mine)
	local re={f=false,w=false,c=false}
	local Q={}
	for tag,m in pairs(O) do
		if m~=MODE and not mine[tag] then pcall(function()
			local k,a,b=parse(tag)
			if not k then return end
			if k=="v" then
				if koUniqueBz[a] then koUniqueBz[a][b]=nil end
				return
			end
			local orig=unpackCells(readAll(origPath(tag)))
			if not orig then return end
			local base,at=gBase(k),fixedAt(k,a)
			local cur=grpGet(base,at,GN[k])
			if cur and not same(cur,orig) then Q[base]=Q[base] or {} for i,c in ipairs(orig) do Q[base][at+i-1]=c end re[k]=true end
			if k=="w" and blank(orig) then koUniqueWar[a]=nil end
			if k=="c" and blank(orig) then koUniqueCity[a]=nil end
		end) end
	end
	for b,ch in pairs(Q) do grpPut(b,ch) end
	rawset(_G,"koUniqueKey",nil)
	if re.f then lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2) end
	if re.w then lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1) lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200) end
	if re.c then lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5) if rawget(_G,"koTownFigReset") then koTownFigReset() end end
end

function koGenEditSync()
	if not (rawget(_G,"koUniqueWar") and rawget(_G,"koUniqueCity") and rawget(_G,"koUniqueBz")) then return end
	local forced=takeList(GSD().."imported.txt")
	for t,_ in pairs(extraForced) do forced[t]=true end
	extraForced={}
	local tags={} for t in string.gmatch(CC.koGenEdit or "","[^,]+") do if parse(t) then tags[#tags+1]=t end end
	table.sort(tags)
	local has={} for _,t in ipairs(tags) do has[t]=true end
	local re={f=false,w=false,c=false}
	local listDirty,bzDirty=false,false
	local remap={}   -- 사본에 적힌 병종 세트 자리 -> 새 자리 (같이 쓰던 병종은 같은 자리로)
	local Q,qtop={},0   -- 넣을 칸을 모아 grp 마다 한 번에 씀 (wmap 은 28MB 라 표시마다 다시 쓰면 휴대폰에서 느림)
	local function putCells(base,at,cells) Q[base]=Q[base] or {} for k,c in ipairs(cells) do Q[base][at+k-1]=c end if base==gBase("v") then qtop=math.max(qtop,at+#cells) end return true end
	local function newBase()
		local n=idxCount(gBase("v"))
		n=math.max(n,qtop)
		for k,t in pairs(koUniqueBz) do if type(k)=="number" then for _,v in pairs(t) do n=math.max(n,v+50) end end end
		local pa=rawget(_G,"koGenPrivAll") if pa then for _,v in pairs(pa()) do n=math.max(n,20000+(v+1)*50) end end   -- 11-08: 따로 받은 조형 칸(newgen) 뒤로
		if n+50>1000000 then return nil end
		return n
	end
	for _,tag in ipairs(tags) do pcall(function()
		local k,a,b=parse(tag)
		local cp=readCopy(tag)
		local force=forced[tag] and cp
		local base=gBase(k)
		if k=="v" then
			local t=koUniqueBz[a]
			local at=t and t[b]
			if at and not force then
				local cur=grpGet(base,at,GN.v)
				if cur and not blank(cur) then
					if not (cp and cp.at==at and same(cur,cp.cells)) then writeCopy(tag,at,"",cur) end
				elseif cp and putCells(base,at,cp.cells) then re.w=true end
				return
			end
			if not cp then return end
			local nb=remap[cp.at]
			if not nb then
				nb=newBase()
				if not (nb and putCells(base,nb,cp.cells)) then return end
				remap[cp.at]=nb re.w=true
			end
			koUniqueBz[a]=koUniqueBz[a] or {}
			koUniqueBz[a][b]=nb bzDirty=true
			writeCopy(tag,nb,"",cp.cells)
			return
		end
		local at=fixedAt(k,a)
		local cur=grpGet(base,at,GN[k])
		if not cur then return end
		local ogs=readAll(origPath(tag))
		local orig=unpackCells(ogs)
		if cp and (force or not same(cur,cp.cells)) then
			if force or not ogs or same(cur,orig) then   -- 데이터가 바뀌었거나 다른 기기에서 옴
				if putCells(base,at,cp.cells) then re[k]=true end
				if not ogs and cp.orig~="" then mkdir(CONFIG.CurrentPath.."genedit/orig") writeAll(origPath(tag),cp.orig) end
			else   -- 게임 안에서 새로 바꿈
				writeCopy(tag,at,ogs,cur)
			end
		elseif not cp and not (orig and same(cur,orig)) then
			writeCopy(tag,at,ogs,cur)
		end
		if k=="w" and not koUniqueWar[a] then koUniqueWar[a]=true listDirty=true end
		if k=="c" and not koUniqueCity[a] then koUniqueCity[a]=true listDirty=true end
	end) end
	for b,ch in pairs(Q) do grpPut(b,ch) end
	if listDirty or bzDirty then pcall(uniqueWrite,listDirty,bzDirty) rawset(_G,"koUniqueKey",nil) end
	-- 원래대로 한 표시의 사본은 지움 (list.txt = 지난번에 사본이 있던 표시)
	do
		local idx=readAll(GSD().."list.txt")
		if idx then for w in string.gmatch(idx,"[^\r\n]+") do if not has[w] then os.remove(copyPath(w)) end end end
	end
	local L={} for _,t in ipairs(tags) do if exists(copyPath(t)) then L[#L+1]=t end end
	if #L>0 or exists(GSD().."list.txt") then mkdir(string.sub(GSD(),1,-2)) writeAll(GSD().."list.txt",table.concat(L,"\n")..((#L>0) and "\n" or "")) end
	if re.f then lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2) end
	if re.w then lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1) lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200) end
	if re.c then lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5) if rawget(_G,"koTownFigReset") then koTownFigReset() end end
end

-- 세이브 옮기기로 들어온 신무장: 번호가 적힌 것은 칸이 차 있어도 세이브 폴더 사본으로 다시 넣음 (병종 세트는 자리를 비워 koNewGenSync 가 새로 잡게)
local function newgenImported(extra)
	local K=rawget(_G,"koGenShare")
	local got=takeList(((K and K.ngOn()) and K.root() or CONFIG.Save).."newgen/imported.txt")   -- 11-11: 신무장 공용이면 영걸전 세이브 폴더
	for _,id in ipairs(extra or {}) do got[tostring(id)]=true end-- 6.0: this story's newgen whose pictures another story holds now
	local any=false
	for w,_ in pairs(got) do
		local id=tonumber(w)
		if id and id>=1 and id<=20 and type(koNewGenImport)=="function" and type(koNewGenSaveDir)=="function" then
			local slot=(type(koNewGenSlot)=="function") and koNewGenSlot(id) or 510+id
			koUniqueBz[slot]=nil
			pcall(koNewGenImport,id,koNewGenSaveDir(id))
			any=true
		end
	end
	if any then
		pcall(uniqueWrite,false,true)
		if type(koNewGenSync)=="function" then pcall(koNewGenSync) end
		rawset(_G,"koUniqueKey",nil)
		lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2)
		lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1) lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200)
		lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5) if rawget(_G,"koTownFigReset") then koTownFigReset() end
	end
end

-- 가져온 ko_settings 를 아직 안 합쳤으면 (세이브 옮기기 화면이 합침) 다음 번으로 미룸: 표시 목록 · 신무장 등록부가 그 안에 있음
-- 10-17 카페 제보 「업데이트하니 장수편집으로 바꾼 얼굴은 원래대로, 조형은 빈칸」: 표시 목록(CC.koGenEdit)·능력치(CC.koGenStat)는
--  ko_settings.lua 에만 있어서 새 판을 덮어 풀면(zip 의 기본 ko_settings) 비고, 그러면 위 동기화가 「원래대로 한 것」으로 보고 세이브 폴더
--  사본까지 지웠음.
--  · 이번 실행의 첫 동기화(타이틀)에서 CC.koGenEdit 가 비었는데 list.txt 에 사본이 남아 있으면 = 설정 파일이 바뀐 것 → list.txt 로 되살림
--    (게임 안에서 전부 원래대로 하면 화면에서 나올 때 동기화가 사본과 list.txt 를 비우므로 다음 실행에 되살아나지 않음)
--  · 능력치는 세이브 폴더 genedit/stat.txt 에 늘 같이 적고, 첫 동기화에서 CC.koGenStat 가 비었으면 거기서 되살림
local firstRun=true
local function settingsGuard()
	local first=firstRun firstRun=false
	local changed=false
	if first and (CC.koGenEdit or "")=="" then
		local t={}
		for w in string.gmatch(readAll(GSD().."list.txt") or "","[^\r\n]+") do if parse(w) and exists(copyPath(w)) then t[#t+1]=w end end
		if #t>0 then CC.koGenEdit=","..table.concat(t,",").."," changed=true end
	end
	local sp=GSD().."stat.txt"
	local KSon=rawget(_G,"koGenShare") and koGenShare.on()
	if first and (CC.koGenStat or "")=="" and not KSon then
		local s=readAll(sp)
		local b=s and string.sub(s,1,6)=="KGST1\n" and string.gsub(string.sub(s,7),"[\r\n]","")
		if b and b~="" then CC.koGenStat=b changed=true end
	end
	if not KSon and ((CC.koGenStat or "")~="" or exists(sp)) then mkdir(string.sub(GSD(),1,-2)) writeAll(sp,"KGST1\n"..(CC.koGenStat or "")) end
	if changed and rawget(_G,"koSave") then pcall(koSave) end
end
koGenEditSettingsGuard=settingsGuard
-- 6.0: 주인 기록 맞추기 (위 owners.txt 설명). 앞 = 다시 넣을 것 고르기 · 남의 칸 되돌리기, 뒤 = 이 이야기 것을 주인으로 적기
local function ownerPrep()
	local O=ownersRead()
	local reg={}
	if type(koNewGenList)=="function" then for id,_ in pairs(koNewGenList()) do reg[id]=true end end
	local ng={}
	for id,_ in pairs(reg) do local t="n"..id if O[t]~=MODE then ng[#ng+1]=id end O[t]=MODE end
	for t,m in pairs(O) do local id=tonumber(string.match(t,"^n(%d+)$") or "") if id and m==MODE and not reg[id] then O[t]=nil end end
	local mine={} for t in string.gmatch(CC.koGenEdit or "","[^,]+") do if parse(t) then mine[t]=true end end
	if rawget(_G,"koGenShare") and koGenShare.on() then   -- 11-11: 장수편집 그림은 모든 모드 공용 → 주인 기록 · 남의 칸 되돌리기는 신무장 그림(n)만
		for t,_ in pairs(O) do if not string.match(t,"^n%d+$") then O[t]=nil end end
		if koGenShare.ngOn() then for t,_ in pairs(O) do O[t]=nil end return O,{},{} end   -- 신무장도 공용이면 주인 기록 없음(그림은 번호마다 한 벌)
		return O,{},ng
	end
	for t,_ in pairs(mine) do if O[t] and O[t]~=MODE and parse(t)~="v" then extraForced[t]=true end end
	foreignRestore(O,mine)
	return O,mine,ng
end
local function ownerFinish(O,mine)
	if rawget(_G,"koGenShare") and koGenShare.on() then for t,_ in pairs(O) do if koGenShare.ngOn() or not string.match(t,"^n%d+$") then O[t]=nil end end ownersWrite(O) return end
	for t,_ in pairs(mine) do if exists(copyPath(t)) or parse(t)=="v" then O[t]=MODE end end
	for t,m in pairs(O) do if m==MODE and parse(t) and not mine[t] then O[t]=nil end end
	ownersWrite(O)
end
local function runAll()
	if exists(CONFIG.CurrentPath.."ko_settings_import.lua") then return end
	if rawget(_G,"koGenShare") then pcall(koGenShare.pull) end   -- 11-11: 공용 기록을 이 모드 번호로 먼저 풂(처음이면 네 모드 합치기)
	pcall(settingsGuard)
	local ok,O,mine,ng=pcall(ownerPrep)
	pcall(newgenImported,ok and ng or nil) pcall(koGenEditSync)
	if ok then pcall(ownerFinish,O,mine) end
end
-- 타이틀: newgen 의 시작 동기화(koNewGenSync)보다 먼저 (병종 세트 자리를 먼저 잡도록)
koAddon.hooks.title=koAddon.hooks.title or {}
table.insert(koAddon.hooks.title,1,function() runAll() return nil end)
-- 장수편집 · 세이브 옮기기 화면에서 나올 때도 (타이틀 메뉴 단추는 전역 함수를 그때 찾아 부름)
if type(koGenEditScreen)=="function" then
	local f=koGenEditScreen
	koGenEditScreen=function(...) local r={f(...)} runAll() return table.unpack(r) end
end
if type(koSaveIOScreen)=="function" then
	local f=koSaveIOScreen
	koSaveIOScreen=function(...) local r={f(...)} runAll() return table.unpack(r) end
end
