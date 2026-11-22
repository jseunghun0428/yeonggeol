-- Original game artwork for officer registration, editing and connected dialogs.
function koOfficerBack(pic)
if pic~=298 then return koTourBack(pic) end
local ox,oy=math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2)
lib.SetClip(0,0,0,0)
lib.FillColor(0,0,CC.ScreenW,CC.ScreenH,M_Black)
koRecordClassicFrame(ox,oy,768,480)
koBrightText=true
end
function koOfficerButton(b,on,hover)
local yy=b.y+math.floor((b.h-22)/2)
koRecordClassicBar(b.x,yy,b.w,on or hover)
DrawString(math.floor(b.x+b.w/2-#b.s*4),yy+3,b.s,(on or hover or b.primary) and C_Name or M_White,16)
end
function koOfficerWait(draw,buttons,overlay)
for _,b in ipairs(buttons) do
if not b.plain and not b.draw then b.draw=koOfficerButton end
end
return koTourWait(draw,buttons,overlay)
end
-- ko 5.0 newgen (2026-10-12, 추가 작업 체크리스트 3번): 사용자가 만드는 신무장 (최대 20명).
--  · 등록부는 기기 공용 설정(ko_settings.lua 의 CC.koNewGen) — 타이틀 메뉴 「신무장 등록」에서 만들고 고치고 지움.
--  · 신무장 k(1~20) = 인물 칸 510+k (511~530). 세이브를 불러올 때마다 등록부 → 그 칸에 씀.
--    이미 고용했거나(君主 1) 지난 회차에서 데려온(얼굴 있음·新头像代号 0) 칸은 세이브 값 그대로.
--  · 술집: 제1장부터(新头像代号 23), 연고 마을 근처 주점 주인 목록 (town koTavernStay 가 koNewGenHome 을 물음), 호감 대화 없음.
--    레벨은 다른 술집 무장처럼 그때 우리 편 평균에 맞추고 병종은 레벨대로 승급(koTavernPromote).
--  · 계승: jymain koNG.carried / reset 이 511~530 은 「얼굴 있음·新头像代号 0」 으로 판단 (patch_신무장.pl).
-- Build (game folder): perl "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/\129\068\130\119/free_hz.pl" < "../\129\126\130\064\130\066\130\068\130\069 \130\071\130\072\130\070 5.0 \134\075\129\095\132\111/\134\075\129\095\132\111/addon/newgen_src.lua" > script/addon/newgen.lua
local NG_MAX,NG_BASE,NG_UNLOCK,NG_TEMPLATE=20,510,(rawget(_G,"koCamp") and koCamp.ngUnlock) or 23,220
local FACE_SIL,FACE_BASE=230,230   -- hdgrp: 230 = 실루엣(기본 얼굴), 230+번호 = 넣은 얼굴 (229~299 는 원래 빈 칸)
koNewGenMax=NG_MAX
local P={NAME="\208\213\195\251",FACE="\205\183\207\241\180\250\186\197",UNLOCK="\208\194\205\183\207\241\180\250\186\197",
LORD="\190\253\214\247",SEX="\208\212\177\240",LV="\181\200\188\182",BZ="\177\248\214\214",WL="\206\228\193\166",ZL="\214\199\193\166",
TS="\205\179\194\202",TF="\204\236\184\179",SK="\204\216\188\188",FIG="\208\206\207\243",ID="\180\250\186\197",NICK="\205\226\186\197",
GROW="\179\201\179\164",EXP="\190\173\209\233",BL="\177\248\193\166",MBL="\215\238\180\243\177\248\193\166",CL="\178\223\194\212",
MCL="\215\238\180\243\178\223\194\212",SQ="\202\191\198\248",ITEM="\181\192\190\223",WEAPON="\206\228\198\247",ARMOR="\183\192\190\223",
AUX="\184\168\214\250",TRAIN="\208\222\193\182",WLE="\206\228\193\166\190\173\209\233",ZLE="\214\199\193\166\190\173\209\233",TSE="\205\179\194\202\190\173\209\233",
WL2="\206\228\193\166\050",ZL2="\214\199\193\166\050",TS2="\205\179\194\202\050"}
koNewGenP=P
koNewGenFaceSil,koNewGenFaceBase=FACE_SIL,FACE_BASE
local uniqueSync   -- (defined with the picture code below)
local GRID={}      -- 10-13: the battle-sprite class grid and the 신무장 class sets (filled in by the 장수편집 code below)

if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koNewGen",default=""} end

-- ---- 등록부: "\132\115\133\119,\132\115\133\119,...|..." 한 줄. 이름·연고는 hz 바이트의 16진수
-- 1 번호 2 이름 3 성별(0 남 1 여) 4 얼굴(0 실루엣, 1 넣은 그림) 5 병종 6 무력 7 지력 8 통솔 9 천부 10~15 특기1~6 16 연고 17 전투조형(0/1) 18 평상조형(0/1) 19 형상
-- 20 병종별 전투 조형 (10-13: 병종 번호 비트, 2^병종)
local F={"id","name","sex","face","bz","wl","zl","ts","tf","s1","s2","s3","s4","s5","s6","home","war","city","fig","wb","mode","aw"}   -- 11-11: 21 출현 모드 (0 모든 모드 1 영걸전 2 무제전 3 손견전 4 원소전) · 11-21: 22 각성 특기 (무장 각성 때, 0 없음)
local function hex(s) return (string.gsub(s or "",".",function(c) return string.format("%02X",string.byte(c)) end)) end
local function unhex(h) return (string.gsub(h or "","%x%x",function(x) return string.char(tonumber(x,16)) end)) end
koNewGenHex,koNewGenUnhex=hex,unhex
function koNewGenList()
	local L={}
	for e in string.gmatch(CC.koNewGen or "","[^|]+") do
		local t,k={},0
		for v in string.gmatch(e..",","([^,]*),") do k=k+1 t[F[k] or ("x"..k)]=v end
		local g={}
		for _,f in ipairs(F) do
			if f=="name" or f=="home" then g[f]=unhex(t[f]) else g[f]=tonumber(t[f] or "") or 0 end
		end
		if g.id>=1 and g.id<=NG_MAX and #g.name>0 then L[g.id]=g end
	end
	return L
end
function koNewGenSave(L)
	local out={}
	for id=1,NG_MAX do
		local g=L[id]
		if g then
			g.id=id
			local t={}
			for _,f in ipairs(F) do
				if f=="name" or f=="home" then t[#t+1]=hex(g[f]) else t[#t+1]=tostring(math.floor(tonumber(g[f]) or 0)) end
			end
			out[#out+1]=table.concat(t,",")
		end
	end
	CC.koNewGen=table.concat(out,"|")
	if rawget(_G,"koSave") then pcall(koSave) end
	if rawget(_G,"koNewGenBackup") then pcall(koNewGenBackup) end   -- 10-17: 세이브 폴더 사본 (아래)
end
function koNewGenSlot(id) return NG_BASE+id end

-- ---- 세이브에 쓰기
-- 그림 칸이 실제로 차 있나 (등록부만 옮겨 온 기기: 없으면 실루엣·기본 조형)
local function has(base,i) local f=rawget(_G,"koNewGenGrpLen") return f and f(CONFIG.DataPath..base,i)>0 end
local function kept(p) return p[P.LORD]==1 or (p[P.FACE]>0 and p[P.UNLOCK]==0) end
local function write(slot,g,id)
	local p=JY.Person[slot]
	local t=JY.Person[NG_TEMPLATE]
	for k,_ in pairs(CC.Person_S) do p[k]=t[k] end
	p[P.ID]=slot p[P.NAME]=g.name p[P.NICK]="" p[P.SEX]=g.sex p[P.FACE]=(g.face>0 and has("hdgrp",FACE_BASE+id)) and (FACE_BASE+id) or ((g.sex==1) and 229 or FACE_SIL) p[P.UNLOCK]=NG_UNLOCK p[P.LORD]=0
	p[P.LV]=1 p[P.EXP]=0 p[P.TRAIN]=0 p[P.GROW]=10
	p[P.BZ]=g.bz p[P.WL]=g.wl p[P.ZL]=g.zl p[P.TS]=g.ts p[P.WLE]=0 p[P.ZLE]=0 p[P.TSE]=0
	p[P.TF]=g.tf
	for k=1,6 do p[P.SK..k]=g["s"..k] end
	if g.fig>0 then p[P.FIG]=g.fig end
	p[P.WEAPON]=0 p[P.ARMOR]=0 p[P.AUX]=0
	for k=1,8 do p[P.ITEM..k]=0 end
	pcall(ReSetAttrib,slot,true)
	p[P.BL]=p[P.MBL] p[P.CL]=p[P.MCL] p[P.SQ]=100
end
function koNewGenFill()
	if not (JY and JY.Person and (JY.PersonNum or 0)>NG_BASE+NG_MAX) then return end
	local L=koNewGenList()
	do local K=rawget(_G,"koGenShare") local cur=K and K.MCODE[K.MODE] or 1   -- 11-11: 이 모드에 나오는 신무장만 (출현 모드 0 = 모든 모드)
		for id,g in pairs(L) do if (g.mode or 0)~=0 and g.mode~=cur then L[id]=nil end end end
	for id=1,NG_MAX do
		local slot=NG_BASE+id
		local p=JY.Person[slot]
		if p[P.FACE]==FACE_SIL or p[P.FACE]==229 then p[P.FACE]=(p[P.SEX]==1) and 229 or FACE_SIL end
		if not kept(p) then
			if L[id] then write(slot,L[id],id) else p[P.FACE]=0 p[P.NAME]="" end
		end
	end
	uniqueSync(L)
end
do
	local lr=LoadRecord
	function LoadRecord(...)
		local r=lr(...)
		if rawget(_G,"koNewGenRebuild") then pcall(koNewGenRebuild) end   -- 10-17: 등록부가 날아간 판 (아래)
		pcall(koNewGenFill)
		if rawget(_G,"koGenStatApply") then pcall(koGenStatApply) end   -- 10-15: 장수편집 능력치 (아래)
		return r
	end
end

-- ---- 연고 (town koTavernStay): 아직 데려오지 않은 신무장은 등록부의 연고, 데려온 무장은 이름으로 찾음
function koNewGenHome(name)
	if not name or name=="" then return nil end
	for _,g in pairs(koNewGenList()) do
		if g.name==name and g.home~="" then return g.home end
	end
	return nil
end

-- ---- 술집에 나올 때 레벨을 우리 편에 맞추고 병종 승급 (다른 술집 무장과 같은 식, HirePerson 의 복사 부분)
koOn("tavern_slot_lock",function(i)
	if i and i>NG_BASE and i<=NG_BASE+NG_MAX then
		local p=JY.Person[i]
		if p and p[P.LORD]~=1 and p[P.FACE]>0 then
			local lv=math.modf((JY.Person[1][P.LV]+JY.Person[2][P.LV]+JY.Person[3][P.LV]+JY.Person[54][P.LV]+JY.Person[126][P.LV])/6)-5
			lv=limitX(lv,1,99)
			if CC.Enhancement and rawget(_G,"pjlv") then local d=pjlv() if lv<d then lv=d end end
			p[P.LV]=lv
			if rawget(_G,"koTavernPromote") then pcall(koTavernPromote,i) end
			pcall(ReSetAttrib,i,true)
		end
	end
	return nil
end)

-- ==== 그림 넣기 (얼굴·전투 조형·평상 조형) ====
-- 게임 폴더 newgen/NN/ (NN = 01~20) 의 BMP 를 게임 안에서 PNG 로 바꿔 hdgrp·wmap·smap 에 넣고 그림을 다시 읽음.
--  face.bmp (64x80, 다른 크기는 맞춰 줄임) → hdgrp 230+번호
--  MOV.bmp 48x528 · SPC.bmp 48x240 · ATK.bmp 64x768 (코에이식 시트, 왕식 폴더 형식) → wmap 20000+칸*50 의 50칸 (조형 교체기와 같은 배치)
--  1.bmp(전면) · 2.bmp(후면) 48x(64의 배수, 보통 1280) 의 맨 위 192줄 → smap 200+(300+칸)*4 의 4방향 (아래·위·왼·오른)
--  넣은 BMP 는 세이브 폴더 newgen/NN/ 에도 복사 (판 갈이로 그림 파일이 바뀌어도 시작할 때 다시 넣음).
local band,bor,bxor,rshift,lshift=bit32.band,bit32.bor,bit32.bxor,bit32.rshift,bit32.lshift
local function readAll(path) local f=io.open(path,"rb") if not f then return nil end local s=f:read("*a") f:close() return s end
local function writeAll(path,s) local f=io.open(path,"wb") if not f then return false end f:write(s) f:close() return true end
local function u16(s,o) return string.byte(s,o+1)+string.byte(s,o+2)*256 end
local function u32(s,o) return u16(s,o)+u16(s,o+2)*65536 end
local function s32(s,o) local v=u32(s,o) if v>=2147483648 then v=v-4294967296 end return v end
-- BMP: 8·24·32비트 (팔레트 그림 포함), 위아래 어느 쪽 저장이든. 돌려줌: {w,h,px(x,y) → r,g,b}
local function bmpLoad(path)
	local s=readAll(path)
	if not s or #s<54 or string.sub(s,1,2)~="BM" then return nil end
	local off,hs,w,h,bpp=u32(s,10),u32(s,14),s32(s,18),s32(s,22),u16(s,28)
	local top=h<0 if top then h=-h end
	if not (bpp==8 or bpp==24 or bpp==32 or bpp==4) then return nil end
	local pal={}
	if bpp<=8 then local n=u32(s,46) if n==0 then n=2^bpp end for i=0,n-1 do local o=14+hs+i*4 pal[i]={string.byte(s,o+3),string.byte(s,o+2),string.byte(s,o+1)} end end
	local rs=math.floor((bpp*w+31)/32)*4
	local ua=false
	if bpp==32 then for i=off+4,math.min(#s,off+rs*h),4 do if string.byte(s,i)~=0 then ua=true break end end end
	local function px(x,y)
		local o=off+((top and y) or (h-1-y))*rs
		if bpp==8 then local c=pal[string.byte(s,o+x+1)] or {0,0,0} return c[1],c[2],c[3]
		elseif bpp==4 then local b=string.byte(s,o+math.floor(x/2)+1) local i=(x%2==0) and math.floor(b/16) or b%16 local c=pal[i] or {0,0,0} return c[1],c[2],c[3]
		else local k=o+x*(bpp/8) return string.byte(s,k+3),string.byte(s,k+2),string.byte(s,k+1),(ua and string.byte(s,k+4)) or 255 end
	end
	return {w=w,h=h,px=px}
end
-- PNG (RGBA, zlib 무압축 블록)
local CRC={}
for i=0,255 do local c=i for _=1,8 do if band(c,1)==1 then c=bxor(0xEDB88320,rshift(c,1)) else c=rshift(c,1) end end CRC[i]=c end
local function crc32(s) local c=0xFFFFFFFF for i=1,#s do c=bxor(CRC[band(bxor(c,string.byte(s,i)),255)],rshift(c,8)) end return bxor(c,0xFFFFFFFF) end
local function be32(v) return string.char(band(rshift(v,24),255),band(rshift(v,16),255),band(rshift(v,8),255),band(v,255)) end
local function chunk(t,d) return be32(#d)..t..d..be32(crc32(t..d)) end
local function pngEncode(w,h,rows)-- rows[y] = RGBA string of w*4 bytes
	local raw={} for y=1,h do raw[#raw+1]="\0"..rows[y] end
	raw=table.concat(raw)
	local a,b=1,0 for i=1,#raw do a=(a+string.byte(raw,i))%65521 b=(b+a)%65521 end
	local z={"\120\1"} local p=1
	while p<=#raw do local n=math.min(65535,#raw-p+1) local last=(p+n>#raw) and 1 or 0
		z[#z+1]=string.char(last,n%256,math.floor(n/256),255-n%256,255-math.floor(n/256))..string.sub(raw,p,p+n-1) p=p+n end
	z[#z+1]=be32(b*65536+a)
	return "\137PNG\r\n\26\n"..chunk("IHDR",be32(w)..be32(h).."\8\6\0\0\0")..chunk("IDAT",table.concat(z))..chunk("IEND","")
end
-- 한 칸: 시트의 (sx,sy) 에서 size 만큼, flip = 좌우 뒤집기. 투명 = (0,0) 색·자홍색
local function cell(b,sx,sy,cw,ch,flip,ow,oh)
	ow,oh=ow or cw,oh or ch
	local kr,kg,kb=b.px(0,0)
	local rows={}
	for y=0,oh-1 do
		local r={}
		for x=0,ow-1 do
			local fx=math.floor(x*cw/ow) local fy=math.floor(y*ch/oh)
			if flip then fx=cw-1-fx end
			local R,G,B,A=b.px(sx+fx,sy+fy)
			if (A and A<128) or (R==kr and G==kg and B==kb) or (R>230 and G<20 and B>230) then r[#r+1]="\0\0\0\0" else r[#r+1]=string.char(R,G,B,255) end
		end
		rows[y+1]=table.concat(r)
	end
	return pngEncode(ow,oh,rows)
end
-- grp 의 몇 칸을 바꿈 (ch[번호]=PNG 또는 "" 빈 칸). 칸 수는 그대로
-- 10-25 (카페 제보 「PC 에서 전투 조형 넣다 85% 에서 튕김」): 예전엔 wmap.grp(28MB+)를 통째 문자열로 읽고 이어 붙여 다시 써서
--  32비트 PC 본체가 큰 연속 메모리를 몇 번씩 잡다 모자라면 꺼졌다(휴대폰은 64비트라 괜찮음). 이제 옛 grp 를 1MB 씩 옮겨 임시 파일에
--  새 grp 를 만들고, 다 되면 그것을 다시 1MB 씩 원래 파일에 덮어씀(실행 중인 엔진이 파일을 열고 있어 이름 바꾸기는 안 됨).
local GRP_BLOCK=1048576
local function grpPut(base,ch)
	local idx=readAll(base..".idx")
	local g=io.open(base..".grp","rb")
	if not idx or not g then if g then g:close() end return false,"no "..base end
	local n=math.floor(#idx/4) local e={}
	for i=0,n-1 do e[i]=u32(idx,i*4) end
	idx=nil
	local maxk=-1 for k,_ in pairs(ch) do if k>maxk then maxk=k end end-- 10-13: cells past the end are appended (empty ones in between)
	if maxk>=n then for i=n,maxk do e[i]=(n>0) and e[n-1] or 0 end n=maxk+1 end
	local keys={} for k,_ in pairs(ch) do if k>=0 and k<n then keys[#keys+1]=k end end
	table.sort(keys)
	local tmp=base..".grp.ko_new"
	local o=io.open(tmp,"wb")
	if not o then g:close() return false,"write "..base end
	local okc=true
	local function copy(from,to,src,dst)   -- bytes [from,to) of src → dst, a block at a time
		src:seek("set",from)
		local left=to-from
		while left>0 do
			local s=src:read(math.min(left,GRP_BLOCK))
			if not s or #s==0 then okc=false break end
			if not dst:write(s) then okc=false break end
			left=left-#s
		end
	end
	local pos,delta,ki=0,0,1
	local ne={}
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
	local newLen=total+delta
	if not okc then os.remove(tmp) return false,"write "..base end
	-- the new grp is complete: copy it over the old one
	local t=io.open(tmp,"rb")
	local w=io.open(base..".grp","wb")
	if not (t and w) then if t then t:close() end if w then w:close() end os.remove(tmp) return false,"write "..base end
	copy(0,newLen,t,w)
	t:close() w:close()
	os.remove(tmp)
	if not okc then return false,"write "..base end
	local ib={} for i=0,n-1 do local v=ne[i] ib[#ib+1]=string.char(v%256,math.floor(v/256)%256,math.floor(v/65536)%256,math.floor(v/16777216)%256) end
	if not writeAll(base..".idx",table.concat(ib)) then return false,"write "..base end
	return true
end
local function grpLen(base,i)
	local f=io.open(base..".idx","rb") if not f then return 0 end
	f:seek("set",(i-1)*4) local a=f:read(4) local b=f:read(4) f:close()
	if not b then return 0 end
	if i==0 then return u32(a,0) end
	return u32(b,0)-u32(a,0)
end
koNewGenGrpLen=grpLen
local function dataPath(n) return CONFIG.DataPath..n end
local function reload(which)
	if which.face then lib.PicLoadFile(CC.HeadPicFile[1],CC.HeadPicFile[2],2) end
	if which.war then lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],1) lib.PicLoadFile(CC.WMAPPicFile[1],CC.WMAPPicFile[2],11,200) end
	if which.city then lib.PicLoadFile(CC.SMAPPicFile[1],CC.SMAPPicFile[2],5) if rawget(_G,"koTownFigReset") then koTownFigReset() end end
end
local function folder(id) return string.format("newgen/%02d/",id) end
koNewGenFolder=folder
-- 넣기: dir 에 있는 것만. 돌려줌 {face=bool,war=bool,city=bool}, 오류 글
local function importTo(T,dir,which,prog)   -- T = {face=hdgrp 칸, war=wmap 첫 칸(50칸), city=smap 첫 칸(4칸)}, which = {face=,war=,city=} 만 (없으면 다), prog(비율,글) = 진행 표시
	local got,err={},{}
	local want=function(k) return which==nil or which[k] end
	local function has(n) local h=io.open(dir..n,"rb") if h then h:close() return true end return false end
	local ntot,nst=1,0
	if want("face") and has("face.bmp") then ntot=ntot+2 end
	if want("war") and has("MOV.bmp") then ntot=ntot+39 end
	if want("city") and has("1.bmp") then ntot=ntot+6 end
	local function tick(t) nst=nst+1 if prog then pcall(prog,math.min(1,nst/ntot),t) end end
	local f=want("face") and bmpLoad(dir.."face.bmp")
	if f then
		tick("\140\118\134\094 \131\085\131\086\130\098 \130\101")
		local pic=cell(f,0,0,f.w,f.h,false,64,80)
		tick("\140\118\134\094 \134\086\133\073\129\102 \136\096\130\098 \130\101")
		local ok,e=grpPut(dataPath("hdgrp"),{[T.face]=pic})
		if ok then got.face=true else err[#err+1]=e end
	end
	local mov,spc,atk if want("war") then mov,spc,atk=bmpLoad(dir.."MOV.bmp"),bmpLoad(dir.."SPC.bmp"),bmpLoad(dir.."ATK.bmp") end
	if mov or spc or atk then
		if mov and spc and atk and mov.w==48 and mov.h==528 and spc.w==48 and spc.h==240 and atk.w==64 and atk.h==768 then
			local B=T.war local c={}
			for k=0,49 do c[B+k]="" end
			local nc=0
			local function cc(k,pic) c[B+k]=pic nc=nc+1 tick("\130\066\132\101 \129\118\136\069 "..nc.."/37") end
			local function m(k,fr,fl) cc(k,cell(mov,0,fr*48,48,48,fl)) end
			local function s(k,fr,fl) cc(k,cell(spc,0,fr*48,48,48,fl)) end
			m(0,0) m(1,1) m(4,2) m(5,3) m(8,4) m(9,5) m(12,4,true) m(13,5,true) m(16,6) m(17,7) m(18,8) m(19,8,true) m(20,9) m(21,10)
			s(22,0) s(23,1) s(24,2) s(25,2,true) s(26,3) s(27,3,true) s(28,4)
			for d=0,2 do for fr=0,3 do cc(30+4*d+fr,cell(atk,0,(4*d+fr)*64,64,64,false)) end end
			for fr=0,3 do cc(42+fr,cell(atk,0,(8+fr)*64,64,64,true)) end
			tick("\129\118\136\069 \134\086\133\073\129\102 \136\096\130\098 \130\101")
			local ok,e=grpPut(dataPath("wmap"),c)
			tick("\129\118\136\069 \134\086\133\073\129\102 \136\096\130\098 \130\101")
			if ok then got.war=true else err[#err+1]=e end
		else err[#err+1]="\130\066\132\101 \129\118\136\069\131\098 MOV(48x528)\161\164SPC(48x240)\161\164ATK(64x768) \131\111 \131\097\129\071 \129\077 \132\079\130\083\133\069 \129\087\129\076\129\077" end
	end
	local fr,bk if want("city") then fr,bk=bmpLoad(dir.."1.bmp"),bmpLoad(dir.."2.bmp") end
	if fr or bk then
		if fr and bk and fr.w==48 and bk.w==48 and fr.h>=192 and bk.h>=192 then
			local E=T.city
			local P={} local fl={{bk,false},{fr,false},{bk,true},{fr,true}}
			for d=0,3 do P[E+d]=cell(fl[d+1][1],0,0,48,192,fl[d+1][2]) tick("\131\119\129\067 \129\118\136\069 "..(d+1).."/4") end
			tick("\131\119\129\067 \129\118\136\069 \134\086\133\073\129\102 \136\096\130\098 \130\101")
			local ok,e=grpPut(dataPath("smap"),P)
			if ok then got.city=true else err[#err+1]=e end
		else err[#err+1]="\131\119\129\067 \129\118\136\069\131\098 1.bmp(\130\066\129\065)\161\1642.bmp(\133\067\129\065) \130\091 \131\097(\129\094\132\083 48)\129\071 \129\077 \132\079\130\083\133\069 \129\087\129\076\129\077" end
	end
	tick("\131\091\130\079 \129\077\130\086 \143\070\130\098 \130\101")
	reload(got)
	return got,err
end
local function ngT(id) local slot=NG_BASE+id return {face=FACE_BASE+id,war=20000+slot*50,city=200+(300+slot)*4} end
function koNewGenImport(id,dir,which,prog) return importTo(ngT(id),dir,which,prog) end
-- 그림 지우기 (얼굴을 실루엣으로 되돌리거나 신무장을 지울 때)
function koNewGenClearImages(id,which)
	local slot=NG_BASE+id
	if which.face then grpPut(dataPath("hdgrp"),{[FACE_BASE+id]=""}) end
	if which.war then local B=20000+slot*50 local c={} for k=0,49 do c[B+k]="" end grpPut(dataPath("wmap"),c) end
	if which.city then local E=200+(300+slot)*4 grpPut(dataPath("smap"),{[E]="",[E+1]="",[E+2]="",[E+3]=""}) end
	reload(which)
end
-- 세이브 폴더 사본: newgen/NN/ (판 갈이로 data 의 그림 파일이 바뀌면 시작할 때 다시 넣음)
local IMGS={"face.bmp","MOV.bmp","SPC.bmp","ATK.bmp","1.bmp","2.bmp"}
local function mkdir(p)
	local probe=p.."/_ko_probe"   -- 이미 있으면 그만 (os.execute 는 cmd 를 띄워 몇 초 걸림, 10-12 사용자 「로딩이 한참」)
	local ph=io.open(probe,"wb") if ph then ph:close() os.remove(probe) return end
	if rawget(_G,"koTouch") and koTouch() then pcall(os.execute,'mkdir -p "'..p..'"')
	else pcall(os.execute,'mkdir "'..string.gsub(p,"/","\\")..'" >nul 2>&1') end
end
function koNewGenSaveDir(id) local K=rawget(_G,"koGenShare") return ((K and K.ngOn()) and K.root() or CONFIG.Save)..folder(id) end   -- 11-11: 공용이면 영걸전 세이브 폴더
function koNewGenKeepCopy(id,dir,got)
	local to=koNewGenSaveDir(id)
	mkdir(string.sub(to,1,-2))
	for _,n in ipairs(IMGS) do
		local part=(n=="face.bmp" and got.face) or ((n=="1.bmp" or n=="2.bmp") and got.city) or ((n=="MOV.bmp" or n=="SPC.bmp" or n=="ATK.bmp") and got.war)
		if part then local s=readAll(dir..n) if s then writeAll(to..n,s) end end
	end
end

-- 파일 선택 창 (10-12 사용자): PC = 윈도우 기본 「열기」 창. ko_sdl.dll(게임 안 SDL 대리 DLL)이 ko_pick.txt 를 보면 다음 화면
--  갱신 때 게임 창을 주인으로 띄움 (전체 화면 뒤에 숨지 않음, PowerShell 안 씀). 고른 경로는 ko_pick_out.txt (ANSI, 한 줄에 하나,
--  빈 파일 = 취소). 옛 ko_sdl.dll 이라 신호를 안 가져가면 nil. 돌려줌: 경로 목록 (취소 = 빈 목록)
local function exists(p) local h=io.open(p,"rb") if h then h:close() return true end return false end
function koNewGenPickFiles(kind,id)   -- kind = "face" | "war" | "city" (얼굴은 ko_sdl 이 64x80 으로 맞춤), id = 그 신무장 폴더를 ko_sdl 이 만들어 둠
	local phone=not CONFIG.Windows
	if phone and not lib.KoPick then return nil end   -- 5.0 APK: GameActivity.koPick answers the same files (ko_pick_out.txt)
	local trig,out=CONFIG.CurrentPath.."ko_pick.txt",CONFIG.CurrentPath.."ko_pick_out.txt"
	os.remove(out)
	local req=(kind or "war").."\n"
	if type(id)=="table" then for _,d in ipairs(id) do req=req..d.."\n" end   -- 장수편집: 만들 폴더 목록
	elseif id then
		local function rel(p) local c=CONFIG.CurrentPath if string.sub(p,1,#c)==c then return string.sub(p,#c+1) end return nil end
		local sv=rel(CONFIG.Save)
		local d=string.sub(folder(id),1,-2)
		req=req.."newgen\n"..d.."\n"
		if sv then req=req..sv.."newgen\n"..sv..d.."\n" end
	end
	if not writeAll(trig,req) then return nil end
	if phone then
		if not lib.KoPick() then os.remove(trig) return nil end
		while not exists(out) do ShowScreen() lib.GetKey() lib.Delay(50) end   -- the picker is its own screen: wait for its answer (cancel = empty)
	else
	local taken=false
	for _=1,40 do
		ShowScreen()   -- ko_sdl 은 화면을 내보낼 때 신호를 봄 (창이 떠 있는 동안 여기서 멈춤)
		if not exists(trig) then taken=true break end
		lib.Delay(25)
	end
	if not taken then os.remove(trig) return nil end
	for _=1,40 do if exists(out) then break end ShowScreen() lib.Delay(25) end
	end
	local s=readAll(out) or ""
	os.remove(out)
	local L={} for line in string.gmatch(s,"[^\r\n]+") do local p,o=string.match(line,"^(.-)|(.*)$") if p then L[#L+1]={p=p,name=o} end end
	koMouseReset()
	return L
end
-- 이름 입력 창 (10-12 사용자): PC = ko_sdl.dll 의 입력 상자 (윈도우 한글 입력기 그대로, 최대 7글자). ko_input.txt 에 지금 이름(UTF-8)
--  을 넣으면 다음 화면 갱신 때 뜨고, ko_input_out.txt 에 "1\n\129\071\138\075" 또는 "0". 돌려줌: 게임 글꼴 코드의 이름 / nil(취소) /
--  false(이 기기에서 못 씀 → 음절판) / "", 없는 글자 목록(글꼴에 없는 글자가 있을 때)
local U2H=nil
local function u2h()
	if U2H then return U2H end
	U2H={}
	local h=io.open(CONFIG.CurrentPath.."hzmb.dat","rb")
	if h then local d=h:read("*a") h:close()
		for i=1,#d-5,6 do local u=string.byte(d,i+4)+string.byte(d,i+5)*256 if U2H[u]==nil then U2H[u]=string.sub(d,i,i+1) end end end
	return U2H
end
local function utf8enc(u)
	if u<128 then return string.char(u) elseif u<2048 then return string.char(192+math.floor(u/64),128+u%64) end
	return string.char(224+math.floor(u/4096),128+math.floor(u/64)%64,128+u%64)
end
local function hz2utf8(s)
	if not CC.koHzU then koNameKey("") end
	local o,i={},1
	while i<=#s do local a=string.byte(s,i)
		if a>=128 and i<#s then local u=CC.koHzU and CC.koHzU[a*256+string.byte(s,i+1)] if u then o[#o+1]=utf8enc(u) end i=i+2
		else o[#o+1]=string.char(a) i=i+1 end end
	return table.concat(o)
end
local function utf8chars(s)
	local L,i={},1
	while i<=#s do local a=string.byte(s,i)
		if a<128 then L[#L+1]=a i=i+1
		elseif a<224 then L[#L+1]=(a-192)*64+(string.byte(s,i+1) or 128)-128 i=i+2
		elseif a<240 then L[#L+1]=(a-224)*4096+((string.byte(s,i+1) or 128)-128)*64+(string.byte(s,i+2) or 128)-128 i=i+3
		else L[#L+1]=63 i=i+4 end end
	return L
end
function koNewGenInputName(cur)
	local phone=not CONFIG.Windows
	if phone and not lib.KoInput then return false end   -- 10-13 (사용자 "\130\111\133\119\132\083\129\071\133\119\129\102\131\087 \137\074\131\115\133\119\132\083"): APK = GameActivity.koInput, the same files
	local trig,out=CONFIG.CurrentPath.."ko_input.txt",CONFIG.CurrentPath.."ko_input_out.txt"
	os.remove(out)
	if not writeAll(trig,hz2utf8(cur or "")) then return false end
	if phone then
		if not lib.KoInput() then os.remove(trig) return false end
		while not exists(out) do ShowScreen() lib.GetKey() lib.Delay(50) end   -- the phone's input box stays until 확인 / 취소 / back
	else
		local taken=false
		for _=1,40 do ShowScreen() if not exists(trig) then taken=true break end lib.Delay(25) end
		if not taken then os.remove(trig) return false end
		for _=1,40 do if exists(out) then break end ShowScreen() lib.Delay(25) end
	end
	local s=readAll(out) or "0"
	os.remove(out)
	koMouseReset()
	if string.sub(s,1,1)~="1" then return nil end
	local M=u2h()
	local nm,bad={},{}
	for _,u in ipairs(utf8chars(string.sub(s,3))) do
		if u>=32 and u<127 then nm[#nm+1]=string.char(u)
		elseif u==0x3000 or u==0x20 then nm[#nm+1]=" "
		elseif M[u] then nm[#nm+1]=M[u]
		else bad[#bad+1]=utf8enc(u) end
	end
	if #bad>0 then return "",bad end
	local r=""
	for _,c in ipairs(nm) do if #r+#c<=14 then r=r..c end end   -- 이름 칸 14바이트 (한글 7자)
	r=string.gsub(r,"^%s+","") r=string.gsub(r,"%s+$","")
	return r
end

-- 고른 파일 → newgen/NN/ 에 정해진 이름으로 (k = "face" | "war" | "city"). 돌려줌: true 또는 false,까닭
function koNewGenSortKind(id,k,paths)   -- id = 신무장 번호, 또는 폴더 경로 (장수편집 · putFlow)
	local dir=(type(id)=="string") and id or (CONFIG.CurrentPath..folder(id))
	mkdir(string.sub(dir,1,-2))
	local function put(from,to) local s=readAll(from) return s~=nil and writeAll(dir..to,s) end
	local B={}
	for _,x in ipairs(paths) do local b=bmpLoad(x.p) if b then B[#B+1]={p=x.p,name=x.name,b=b} end end
	if #B==0 then return false,"\131\091\130\079\129\083 \143\070\130\067 \136\102\129\080\129\075\129\076\129\077 (BMP\161\164PNG\161\164JPG)" end
	if k=="face" then
		return put(B[1].p,"face.bmp") or false,"\130\068\130\114\129\097\130\067 \136\102\129\080\129\075\129\076\129\077"
	elseif k=="war" then
		local got={}
		for _,x in ipairs(B) do
			local w,h=x.b.w,x.b.h
			if w==48 and h==528 then got.MOV=x.p elseif w==48 and h==240 then got.SPC=x.p elseif w==64 and h==768 then got.ATK=x.p end
		end
		local miss={}
		for _,n in ipairs({"MOV","SPC","ATK"}) do if not got[n] then miss[#miss+1]=n end end
		if #miss>0 then return false,table.concat(miss,"\161\164").." \129\094 \130\097\129\075\129\076\129\077" end
		for _,n in ipairs({"MOV","SPC","ATK"}) do if not put(got[n],n..".bmp") then return false,"\130\068\130\114\129\097\130\067 \136\102\129\080\129\075\129\076\129\077" end end
		return true
	else
		local S={}
		for _,x in ipairs(B) do if x.b.w==48 and x.b.h>=192 and x.b.h%64==0 then S[#S+1]=x end end
		if #S<2 then return false,"\129\094\132\083 48 \130\086\141\074 \130\091 \131\097(\130\066\129\065\161\164\133\067\129\065)\129\071 \132\115\129\090\129\087\129\076\129\077" end
		local fr,bk=nil,nil   -- 이름 끝 1 = 전면, 2 = 후면 (r형상 「가후1·가후2」), 아니면 그림 칸이 많은 쪽이 전면 (선택 창은 순서를 바꿈)
		for _,x in ipairs(S) do
			local stem=string.lower(string.match(x.name or "","([^\\/]+)$") or "")
			stem=string.gsub(stem,"%.[^%.]*$","")
			if string.find(stem,"1$") and not fr then fr=x.p elseif string.find(stem,"2$") and not bk then bk=x.p end
		end
		if not (fr and bk) and #S>=2 then
			local function used(x) local b=x.b local n=0 local kr,kg,kb=b.px(0,0)
				for k=0,math.floor(b.h/64)-1 do local any=false
					for y=k*64,k*64+63,2 do for xx=0,47,2 do local R,G,B,A=b.px(xx,y) if not ((A and A<128) or (R==kr and G==kg and B==kb) or (R>230 and G<20 and B>230)) then any=true break end end if any then break end end
					if any then n=n+1 end end
				return n end
			local a,c=S[1],S[2]
			if used(c)>used(a) then a,c=c,a end
			if not fr and not bk then fr,bk=a.p,c.p elseif not fr then fr=(a.p~=bk) and a.p or c.p else bk=(c.p~=fr) and c.p or a.p end
		end
		for _,x in ipairs(S) do local p=x.p if p~=fr and p~=bk then if not fr then fr=p elseif not bk then bk=p end end end
		if not (put(fr,"1.bmp") and put(bk,"2.bmp")) then return false,"\130\068\130\114\129\097\130\067 \136\102\129\080\129\075\129\076\129\077" end
		return true
	end
end

-- 고유 조형 목록(unique) 에 넣은 칸만
uniqueSync=function(L)
	for id=1,NG_MAX do
		local slot=NG_BASE+id
		local g=L[id]
		if rawget(_G,"koUniqueWar") then koUniqueWar[slot]=(g and g.war==1 and has("wmap",20000+slot*50)) or nil end
		if rawget(_G,"koUniqueCity") then koUniqueCity[slot]=(g and g.city==1 and has("smap",200+(300+slot)*4)) or nil end
	end
end
koNewGenUniqueSync=function() uniqueSync(koNewGenList()) end
-- 시작할 때: 등록부에 그림이 있다는데 그림 파일 칸이 비었으면 세이브 폴더 사본에서 다시 넣음
function koNewGenSync()
	local L=koNewGenList()
	for id,g in pairs(L) do
		local slot=NG_BASE+id
		local need=(g.face==1 and grpLen(dataPath("hdgrp"),FACE_BASE+id)==0)
			or (g.war==1 and grpLen(dataPath("wmap"),20000+slot*50)==0)
			or (g.city==1 and grpLen(dataPath("smap"),200+(300+slot)*4)==0)
		if need then pcall(koNewGenImport,id,koNewGenSaveDir(id)) end
	end
	if GRID.ngSync then pcall(GRID.ngSync,L) end   -- 10-13: the class sets (병종별 전투 조형)
	uniqueSync(L)
end
-- 10-17 카페 제보 「업데이트하니 신무장 등록 목록이 비고 조형이 사라짐, 게임 안에는 있음」: 등록부는 기기 공용 설정(ko_settings.lua)
--  에만 있어서 새 판을 덮어 풀면(zip 의 기본 ko_settings) 비고, 그림 다시 넣기·고유 조형 목록도 등록부만 봐서 같이 사라졌음.
--  · 등록부를 고칠 때마다 세이브 폴더 newgen_registry.txt 에도 적음 (세이브 폴더는 판 갈이 때 옮겨 오는 곳)
--  · 시작할 때 등록부가 비었으면 그 사본에서 되살림
--  · 사본도 없으면(이 고침 전 판) 세이브를 불러올 때 세이브 안의 신무장 기록(데려온 무장)과 세이브 폴더 그림 사본으로 다시 만듦
local REG_FILE,REG_TAG="newgen_registry.txt","KONG1\n"
local function regDir() local K=rawget(_G,"koGenShare") return (K and K.ngOn()) and K.root() or CONFIG.Save end   -- 11-11
function koNewGenBackup() writeAll(regDir()..REG_FILE,REG_TAG..(CC.koNewGen or "")) end
local function regRestore()
	if (CC.koNewGen or "")~="" then return end
	local s=readAll(regDir()..REG_FILE)
	local body=s and string.sub(s,1,#REG_TAG)==REG_TAG and string.gsub(string.sub(s,#REG_TAG+1),"[\r\n]","")
	if body and body~="" then CC.koNewGen=body if rawget(_G,"koSave") then pcall(koSave) end end
end
koNewGenRegRestore=regRestore
local synced=false
koOn("title",function() if not synced then synced=true pcall(regRestore) pcall(koNewGenSync) end return nil end)

-- ==== 타이틀 메뉴 「신무장 등록」 ====
local SKN="\195\251\179\198"   -- 名称
local SKD="\203\181\195\247"   -- 说明
local OFFICER_BACK_PIC=298
local STAT_MAX,STAT_SUM,STAT_MIN,STAR_BUDGET=100,300,1,24   -- (10-15 사용자: 하나 100 · 합계 300 — 10-12 의 합계 240 · 하나 95 에서)
-- 고를 수 있는 병종 (10-12 사용자: 숨겨진 장수 전용만 빼고 다 — 나무인형 29·서초패왕 30·한고제 31·마왕 32·흙인형 36, 마차 38·예비 39~ 제외).
--  3단 계열(단병·궁병·경기병·산적·창병)은 1단만: 술집에 나올 때 레벨대로 승급
local CLASSES={1,4,7,23,22,10,20,21,14,15,17,13,16,19,26,27,28,33,34,35,37}   -- (10-12 사용자: 민중 18 뺌)
local STARS={
{7,9,13,14,18,21,22,41},{8,11,12,19,20,24,25,118},{2,10,29,31,42,103,105,111},{6,26,27,30,34,36,107,113},
{16,17,28,33,35,44,112,117},{15,23,32,48,49,50,102,106},{3,4,39,45,46,108,110,119}}
local STAR_OF={} for s,l in ipairs(STARS) do for _,k in ipairs(l) do STAR_OF[k]=s end end
local REGIONS={"\129\097\135\107","\130\108","\130\101\131\081","\136\069\130\075","\133\083\130\075"}
-- 10-17: 등록부도 그 사본도 없을 때 세이브의 신무장 기록으로 다시 만들기 (위 regRestore 설명). 연고는 모르니 편집 화면 기본값(첫 마을),
--  병종은 그 계열 1단, 능력은 하나 100·합계 300 안으로. 한 번 만들면 사본이 생겨 다시 하지 않음
function koNewGenRebuild()
	if (CC.koNewGen or "")~="" or readAll(regDir()..REG_FILE) then return end
	if not (JY and JY.Person and (JY.PersonNum or 0)>NG_BASE+NG_MAX) then return end
	local R=rawget(_G,"koTownRegions") and koTownRegions() or {}
	local town="" for _,rn in ipairs(REGIONS) do if R[rn] and R[rn][1] then town=R[rn][1] break end end
	local L={}
	for id=1,NG_MAX do
		local p=JY.Person[NG_BASE+id]
		if (p[P.NAME] or "")~="" and kept(p) then
			local dir=koNewGenSaveDir(id)
			local bz=p[P.BZ] or 1
			if bz>=1 and bz<=12 then bz=bz-(bz-1)%3 elseif bz>=23 and bz<=25 then bz=23 end
			local st={}
			for i,k in ipairs({"WL","ZL","TS"}) do st[i]=math.max(STAT_MIN,math.min(STAT_MAX,p[P[k]] or 50)) end
			while st[1]+st[2]+st[3]>STAT_SUM do local m=1 for i=2,3 do if st[i]>st[m] then m=i end end st[m]=st[m]-1 end
			local g={id=id,name=p[P.NAME],sex=p[P.SEX] or 0,bz=bz,wl=st[1],zl=st[2],ts=st[3],tf=p[P.TF] or 0,home=town,fig=p[P.FIG] or 0,wb=0,
				face=(exists(dir.."face.bmp") or p[P.FACE]==FACE_BASE+id) and 1 or 0,
				war=(exists(dir.."MOV.bmp") or has("wmap",20000+(NG_BASE+id)*50)) and 1 or 0,
				city=(exists(dir.."1.bmp") or has("smap",200+(300+NG_BASE+id)*4)) and 1 or 0}
			for k=1,6 do g["s"..k]=p[P.SK..k] or 0 end
			for b=0,45 do if exists(dir.."b"..b.."/MOV.bmp") then g.wb=g.wb+2^b end end   -- 병종별 전투 조형 사본
			L[id]=g
		end
	end
	if next(L) then koNewGenSave(L) pcall(koNewGenSync) end
end
local function oxy() return math.floor((CC.ScreenW-768)/2),math.floor((CC.ScreenH-480)/2) end
local function ctext(cx,y,s,c,size) size=size or 16 DrawString(cx-#s*size/4,y,s,c or M_White,size) end
local function panel(x1,y1,x2,y2) koRecordClassicFrame(x1,y1,x2-x1,y2-y1) end
local function msg(lines)
	local ox,oy=oxy()
	koOfficerWait(function() koOfficerBack(OFFICER_BACK_PIC) panel(ox+84,oy+150,ox+684,oy+330)
		for i,s in ipairs(lines) do ctext(ox+384,oy+168+(i-1)*24,s,i==1 and C_Name or M_White) end end,
		{{x=ox+324,y=oy+290,w=120,h=28,s="\129\105\129\106"}})
end
local function ask(lines,yes,no)
	local ox,oy=oxy()
	local r=koOfficerWait(function() koOfficerBack(OFFICER_BACK_PIC) panel(ox+84,oy+150,ox+684,oy+330)
		for i,s in ipairs(lines) do ctext(ox+384,oy+168+(i-1)*24,s,i==1 and C_Name or M_White) end end,
		{{x=ox+224,y=oy+290,w=140,h=28,s=yes},{x=ox+404,y=oy+290,w=140,h=28,s=no}})
	return r==1
end
local function ask3(lines,b1,b2,b3)
	local ox,oy=oxy()
	return koOfficerWait(function() koOfficerBack(OFFICER_BACK_PIC) panel(ox+84,oy+150,ox+684,oy+330)
		for i,s in ipairs(lines) do ctext(ox+384,oy+168+(i-1)*24,s,i==1 and C_Name or M_White) end end,
		{{x=ox+144,y=oy+290,w=150,h=28,s=b1},{x=ox+309,y=oy+290,w=150,h=28,s=b2},{x=ox+474,y=oy+290,w=150,h=28,s=b3}})
end
local function skName(k) if not k or k<=0 then return "\130\097\130\077" end return JY.Skill[k][SKN] end

-- ---- 10-15 (사용자) 능력치 = 막대(끌기) + 오른쪽 입력칸 — 신무장 등록 · 장수편집 같은 꼴
--  한 줄 = 이름(X) · 막대(X+SL_X, 폭 SL_W) · 입력칸(X+BOX_X, BOX_W x 24), 줄 사이 30. 막대는 koOfficerWait 의 overlay 에서
--  누른 채 끌기(누른 곳이 막대 줄이면 손 뗌은 클릭이 아님), 입력칸은 단추(act="statin") → statEntry (키보드 숫자 · 휴대폰은 숫자판).
local STAT_ROWS={{f="wl",s="\129\073\131\125"},{f="zl",s="\130\067\131\125"},{f="ts",s="\132\119\132\120"}}
local SL_X,SL_W,BOX_X,BOX_W=48,366,432,52
local function slX(X,v) return X+SL_X+math.floor((limitX(v,STAT_MIN,STAT_MAX)-STAT_MIN)*SL_W/(STAT_MAX-STAT_MIN)+0.5) end
local function slV(X,mx) return limitX(STAT_MIN+math.floor((mx-X-SL_X)*(STAT_MAX-STAT_MIN)/SL_W+0.5),STAT_MIN,STAT_MAX) end
local function statHot(X,Y)   -- 지금 끌고 있는 줄 (없으면 nil)
	if MOUSE.status~='HOLD' then return nil end
	for i=1,#STAT_ROWS do local y=Y+(i-1)*30
		if between(MOUSE.hx,X+SL_X-8,X+SL_X+SL_W+8) and between(MOUSE.hy,y,y+24) then return i end end
end
local function statRows(X,Y,get)
	local hot=statHot(X,Y)
	for i,r in ipairs(STAT_ROWS) do
		local y=Y+(i-1)*30
		local x1,x2,xv=X+SL_X,X+SL_X+SL_W,slX(X,get(r.f))
		DrawString(X,y+4,r.s,M_White,16)
		lib.FillColor(x1,y+9,x2,y+16,RGB(16,16,40))
		if xv>x1 then lib.FillColor(x1,y+9,xv,y+16,(hot==i) and C_Name or RGB(176,136,56)) end
		lib.DrawRect(x1,y+8,x2,y+8,M_Gray) lib.DrawRect(x1,y+17,x2,y+17,M_Gray)
		lib.DrawRect(x1,y+8,x1,y+17,M_Gray) lib.DrawRect(x2,y+8,x2,y+17,M_Gray)
		lib.FillColor(xv-5,y+2,xv+5,y+22,(hot==i) and C_Name or RGB(200,160,72))   -- 손잡이 (단추 그림은 12px 폭에서 색이 들쭉날쭉)
		lib.DrawRect(xv-5,y+2,xv+5,y+2,M_White) lib.DrawRect(xv-5,y+22,xv+5,y+22,M_Gray)
		lib.DrawRect(xv-5,y+2,xv-5,y+22,M_White) lib.DrawRect(xv+5,y+2,xv+5,y+22,M_Gray)
	end
end
local function statBoxDraw(b,txt,on,focus)
	koRecordClassicFrame(b.x,b.y,b.w,b.h)
	local tx=b.x+b.w-8-#txt*8
	DrawString(tx,b.y+4,txt,(focus or on) and C_Name or M_White,16)
	if focus and math.floor(lib.GetTime()/400)%2==0 then lib.FillColor(b.x+b.w-7,b.y+4,b.x+b.w-6,b.y+20,C_Name) end
end
local function statBoxes(B,X,Y,get)   -- 입력칸 단추 셋
	for i,r in ipairs(STAT_ROWS) do
		B({x=X+BOX_X,y=Y+(i-1)*30,w=BOX_W,h=24,s="",act="statin",f=r.f,
			draw=function(b,on) statBoxDraw(b,tostring(get(b.f)),on,false) end})
	end
end
local function statDrag(X,Y,get,set)   -- overlay: 끄는 동안 값 바꾸기
	local i=statHot(X,Y)
	if not i then return nil end
	local f=STAT_ROWS[i].f
	local v=slV(X,MOUSE.x)
	if v~=get(f) then set(f,v) end
	MOUSE.enableclick=false
	return i
end
local KP_KEY={[1073741922]=0} for d=1,9 do KP_KEY[1073741912+d]=d end   -- SDL 숫자판 1~9 · 0
local function statEntry(draw,btns,box,cur)   -- 입력칸에 숫자 넣기: Enter · 바깥 누르기 = 확정, Esc · 오른쪽 = 취소
	local txt,fresh=tostring(cur),true
	local pad
	if koTouch() then   -- 휴대폰: 입력칸 아래 숫자판
		pad={}
		local px,py=box.x+box.w-122,box.y+30
		for i,s in ipairs({"1","2","3","4","5","6","7","8","9","\130\067\136\108","0","\129\105\129\106"}) do
			local c,rw=(i-1)%3,math.floor((i-1)/3)
			pad[i]={x=px+c*41,y=py+rw*32,w=40,h=30,s=s}
		end
		pad.x,pad.y=px-8,py-8
	end
	koMouseReset()
	while true do
		JY.ReFreshTime=lib.GetTime()
		draw(0)
		for _,b in ipairs(btns) do if b~=box and not b.hide and b.draw then b.draw(b,false,false) end end
		statBoxDraw(box,txt,true,true)
		if pad then
			koRecordClassicFrame(pad.x,pad.y,3*41+15,4*32+14)
			for _,b in ipairs(pad) do koOfficerButton(b,false,MOUSE.IN(b.x,b.y,b.x+b.w,b.y+b.h)) end
		end
		ShowScreen()
		local e,k=koPollKey()
		if e==0 or MOUSE.EXIT() then koExit() end
		local add,done
		if e==1 then
			if k>=48 and k<=57 then add=k-48 elseif KP_KEY[k] then add=KP_KEY[k]
			elseif k==8 or k==127 then txt=string.sub(txt,1,-2) fresh=false
			elseif k==13 or k==1073741912 then done=true
			elseif k==27 then return nil end
		end
		if MOUSE.ESC() then return nil end
		if pad then
			for i,b in ipairs(pad) do
				if MOUSE.CLICK(b.x,b.y,b.x+b.w,b.y+b.h) then PlayWavE(0)
					if i==10 then txt=string.sub(txt,1,-2) fresh=false elseif i==11 then add=0 elseif i==12 then done=true else add=i end
				end
			end
		end
		if MOUSE.CLICK(box.x,box.y,box.x+box.w,box.y+box.h) then end   -- 칸을 다시 누름: 그대로
		if MOUSE.CLICK() then done=true end   -- 바깥을 누름: 확정
		if add then
			if fresh then txt="" fresh=false end
			if #txt<3 then txt=tostring(tonumber(txt..add)) end
		end
		if done then local v=tonumber(txt) if not v then return nil end return limitX(v,STAT_MIN,STAT_MAX) end
	end
end
-- 술집 고용 비용 (10-12 사용자: 등록 화면에 표시). jymain HirePerson 안의 local GetPersonValue 와 같은 식 (koCost 있는 5.0 쪽):
--  능력 기본값(무력·지력·통솔) 을 100 단위로 내려 500~10000 으로 묶고 반으로 + 코스트 등급 가산금. 술집에서 레벨대로 승급하면 코스트가 바뀔 수 있어 「약」
local KOTIER={[1]=0,[2]=300,[3]=700,[4]=1200,[5]=2000,[6]=3000,[7]=4500,[8]=7000,[9]=11000,[10]=18000}
local function hirePrice(slot)
	local p=JY.Person[slot]
	local v=40000/(120-math.min(p[P.WL],119))+40000/(120-math.min(p[P.ZL],119))+40000/(120-math.min(p[P.TS],119))
	v=100*math.floor(v/100) v=math.max(500,math.min(10000,v)) v=math.floor(v/2)
	return v+(KOTIER[rawget(_G,"koCostOf") and koCostOf(slot) or 0] or 0)
end
local function stars(g) local n=STAR_OF[g.tf] or 0 for k=1,6 do n=n+(STAR_OF[g["s"..k]] or 0) end return n end
local function nameTaken(nm,id)
	for i=1,420 do if JY.Person[i] and JY.Person[i][P.NAME]==nm then return true end end
	for k,g in pairs(koNewGenList()) do if k~=id and g.name==nm then return true end end
	return false
end

-- 이름 음절판: 글꼴(hzmb.dat)에 있는 한글만, 초성별. 최대 7글자
local SYL=nil
local CHO={"\129\094","\129\089","\131\118","\129\077","\130\105","\130\102","\133\088","\131\085","\131\069","\130\114","\137\106","\129\110","\133\120","\138\097","\132\121","\143\085","\133\064","\134\086","\129\097"}   -- (글꼴에 낱자 자음이 없어 대표 글자)
local function syllables()
	if SYL then return SYL end
	SYL={} for i=1,19 do SYL[i]={} end
	local h=io.open(CONFIG.CurrentPath.."hzmb.dat","rb")
	if h then
		local d=h:read("*a") h:close()
		local seen={}
		for i=1,#d-5,6 do
			local u=string.byte(d,i+4)+string.byte(d,i+5)*256
			if u>=0xAC00 and u<=0xD7A3 and not seen[u] then seen[u]=true
				local c=math.floor((u-0xAC00)/588)+1
				table.insert(SYL[c],{u=u,s=string.sub(d,i,i+1)})
			end
		end
		for i=1,19 do table.sort(SYL[i],function(a,b) return a.u<b.u end) end
	end
	return SYL
end
local function namePad(cur)
	local ox,oy=oxy()
	local S=syllables()
	local tab,page,nm=1,1,cur or ""
	while true do
		local list=S[tab] or {}
		local per=84 local np=math.max(1,math.ceil(#list/per)) page=math.min(page,np)
		local btns={}
		for i=1,19 do btns[#btns+1]={x=ox+14+(i-1)*39,y=oy+92,w=36,h=26,s=CHO[i],sel=(i==tab),tab=i} end
		for k=1,per do local it=list[(page-1)*per+k] if it then
			local c,r=(k-1)%14,math.floor((k-1)/14)
			btns[#btns+1]={x=ox+20+c*52,y=oy+130+r*36,w=48,h=32,s=it.s,syl=it.s} end end
		btns[#btns+1]={x=ox+20,y=oy+352,w=60,h=26,s="<",pg=-1}
		btns[#btns+1]={x=ox+88,y=oy+352,w=60,h=26,s=">",pg=1}
		btns[#btns+1]={x=ox+300,y=oy+432,w=140,h=28,s="\129\111 \142\116\133\120 \130\067\131\079\131\071",del=1}
		btns[#btns+1]={x=ox+448,y=oy+432,w=96,h=28,s="\130\090\130\091 \130\067\131\079\131\071",del=2}
		btns[#btns+1]={x=ox+552,y=oy+432,w=96,h=28,s="\129\105\129\106",ok=true}
		btns[#btns+1]={x=ox+656,y=oy+432,w=96,h=28,s="\129\108\129\109",cancel=true}
		local r=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+18,"\129\071\138\075 \129\070\129\097\131\071",C_Name,24)
			ctext(ox+384,oy+52,"\136\122\130\095 7\142\116\133\120",M_Silver)
			panel(ox+20,oy+428,ox+290,oy+462) DrawString(ox+32,oy+436,nm=="" and "(\129\071\138\075 \130\097\130\077)" or nm,nm=="" and M_Gray or C_Name,16)
			DrawString(ox+160,oy+356,page.."/"..np,M_White,16)
		end,btns)
		local b=btns[r]
		if r==0 or (b and b.cancel) then return nil end
		if b then
			if b.tab then tab,page=b.tab,1
			elseif b.pg then page=((page-1+b.pg)%np)+1
			elseif b.syl then if #nm<14 then nm=nm..b.syl end
			elseif b.del==1 then nm=string.sub(nm,1,math.max(0,#nm-2))
			elseif b.del==2 then nm=""
			elseif b.ok then return nm end
		end
	end
end

-- 특기 고르기: 역천개명 1~7성. left = 남은 별 (지금 칸에 고른 것은 돌려받은 뒤), used = 다른 칸에 이미 고른 것
local function skillPick(title,cur,left,used)
	local ox,oy=oxy()
	local tab=STAR_OF[cur] or 1
	while true do
		local btns={}
		for s=1,7 do btns[#btns+1]={x=ox+40+(s-1)*98,y=oy+86,w=90,h=26,s=s.."\131\123",sel=(s==tab),tab=s} end
		for k,id in ipairs(STARS[tab]) do
			local c,r=(k-1)%4,math.floor((k-1)/4)
			local bad=(tab>left) or (used[id] and id~=cur)
			btns[#btns+1]={x=ox+40+c*174,y=oy+132+r*40,w=164,h=32,s=skName(id)..((bad and "  \161\193") or ""),pick=id,bad=bad,sel=(id==cur)}
		end
		btns[#btns+1]={x=ox+40,y=oy+220,w=164,h=32,s="\130\097\130\077",pick=0}
		btns[#btns+1]={x=ox+640,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",cancel=true}
		local r=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+18,title,C_Name,24)
			ctext(ox+384,oy+54,"\132\080 \129\113 \132\079\130\098 \138\090 "..left.." \161\164 \161\193 = \138\090 \130\094\132\082 \135\079\130\098 \129\077\135\077 \135\066\129\102 \129\071\134\119 \131\100\138\075",M_Silver)
		end,btns,function(hov)
			local b=btns[hov] local id=b and b.pick
			if id and id>0 then panel(ox+40,oy+272,ox+728,oy+400)
				DrawString(ox+52,oy+282,skName(id).."  "..STAR_OF[id].."\131\123",C_Name,16)
				DrawStr(ox+52,oy+306,GenTalkString(JY.Skill[id][SKD],40),M_White,16) end
		end)
		local b=btns[r]
		if r==0 or (b and b.cancel) then return nil end
		if b then
			if b.tab then tab=b.tab
			elseif b.pick then if b.bad then msg({"\131\100\130\104 \129\113 \130\097\129\075\129\076\129\077","\138\090\129\071 \130\090\133\120\130\102\134\069\131\118 \129\077\135\077 \135\066\129\102 \129\071\134\119 \131\100\135\077 \129\120\131\071\129\104\129\076\129\077"}) else return b.pick end end
		end
	end
end

-- 조형 미리보기 (움직임): 전투 = 아래 걷기 2칸 ×3 → 아래 공격 4칸, 평상 = 정면 걷기 3칸
local function drawAnim(slot,g,x,y)
	local t=math.floor(lib.GetTime()/180)
	local cls=rawget(_G,"koUniqueBz") and koUniqueBz[slot] and koUniqueBz[slot][g.bz]   -- 10-13: his class set first
	local base=cls or ((g.war==1) and (20000+slot*50)) or (GetPic(slot,false,true) or 0)
	local seq={0,1,0,1,0,1,30,31,32,33,33}
	local k=seq[t%#seq+1]
	lib.PicLoadCache(1,(base+k)*2,x,y,1)
	local fig=(g.city==1) and (300+slot) or JY.Person[slot][P.FIG]
	local fr=({0,1,0,2})[t%4+1]
	lib.SetClip(x+70,y,x+70+48,y+64)
	lib.PicLoadCache(5,(200+fig*4+1)*2,x+70,y-fr*64,1)
	lib.SetClip(0,0,0,0)
end

local BZD="\203\181\195\247"   -- 说明 (of a class)
local function classPick(cur)
	local ox,oy=oxy()
	while true do
		local btns={}
		for k,id in ipairs(CLASSES) do local c,r=(k-1)%4,math.floor((k-1)/4)
			btns[#btns+1]={x=ox+40+c*174,y=oy+80+r*36,w=164,h=30,s=JY.Bingzhong[id][SKN],pick=id,sel=(id==cur)} end
		btns[#btns+1]={x=ox+640,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",cancel=true}
		local r=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+18,"\130\126\129\084 \131\100\130\106\131\071",C_Name,24)
			ctext(ox+384,oy+52,"\134\077\130\126\161\164\134\088\130\126\161\164\131\064\131\071\130\126\161\164\132\091\131\076\161\164\134\103\130\126\131\098 \131\072\134\076\129\102 \131\118\131\105 \132\085 \130\082\130\123\130\095\132\083 \129\116\134\080\129\087\129\076\129\077",M_Silver)
		end,btns,function(hov)
			local b=btns[hov] local id=b and b.pick
			if id then local B=JY.Bingzhong[id] panel(ox+40,oy+312,ox+728,oy+420)
				DrawString(ox+52,oy+322,B[SKN].."   \130\074\130\112 "..B["\185\165\187\247"].."  \132\078\130\083 "..B["\183\192\211\249"].."  \129\071\130\108 "..B["\210\198\182\175"],C_Name,16)
				DrawStr(ox+52,oy+346,GenTalkString(B[BZD],34),M_White,16)
				-- 공격 범위 (병종 도감과 같은 그림: 11x11 칸, 파랑 = 부대, 빨강 = 닿는 칸)
				local C=9 local gx,gy=ox+616,oy+316
				lib.FillColor(gx,gy,gx+11*C,gy+11*C,RGB(24,28,40))
				local a=WarGetAtkFW(20,20,B["\185\165\187\247\183\182\206\167"])   -- 攻击范围
				for i=1,(a and a.num or 0) do local cx,cy=a[i][1]-20,a[i][2]-20
					if math.abs(cx)<=5 and math.abs(cy)<=5 then local x,y=gx+(cx+5)*C,gy+(cy+5)*C lib.FillColor(x+1,y+1,x+C,y+C,RGB(210,60,40)) end end
				lib.FillColor(gx+5*C+1,gy+5*C+1,gx+6*C,gy+6*C,RGB(70,120,230))
				for i=0,11 do lib.DrawRect(gx+i*C,gy,gx+i*C,gy+11*C,RGB(60,64,80)) lib.DrawRect(gx,gy+i*C,gx+11*C,gy+i*C,RGB(60,64,80)) end
			end
		end)
		local b=btns[r]
		if r==0 or (b and b.cancel) then return nil end
		if b and b.pick then return b.pick end
	end
end

-- 연고 지도: 그림의 도시 표지에 기존 마을 이름과 선택 기능을 연결한다.
local ORIGIN_MAP_PIC=273
local ORIGIN_LABEL_FIRST=274
local ORIGIN_MAP_POS={
    {{499,112,38},{524,80,42},{599,63,44},{484,151,44},{584,122,44}},
    {{688,133,44},{636,187,44},{543,187,44},{606,227,44},{421,180,44}},
    {{458,221,44},{397,244,38},{525,250,44}},
    {{436,316,44},{458,283,44},{360,329,44},{550,328,44},{458,371,44},{371,382,56},{300,387,44}},
    {{87,324,44},{134,289,38},{161,261,38},{228,334,44}},
}
local function townPick(cur)
    local ox,oy=oxy()
    local R=rawget(_G,"koTownRegions") and koTownRegions() or {}
    local seen,btns={},{}
    local function cityDraw(b,on,hover)
        local dark=RGB(0,0,48)
        local edge=C_Name
        lib.FillColor(b.x+9,b.y,b.x+b.w,b.y+b.h,on and C_Name or dark)
        lib.FillColor(b.x,b.y+7,b.x+6,b.y+13,C_Name)
        lib.DrawRect(b.x+9,b.y,b.x+b.w,b.y,edge)
        lib.DrawRect(b.x+9,b.y+b.h,b.x+b.w,b.y+b.h,edge)
        lib.DrawRect(b.x+9,b.y,b.x+9,b.y+b.h,edge)
        lib.DrawRect(b.x+b.w,b.y,b.x+b.w,b.y+b.h,edge)
        local tx=b.x+10+(b.w-10-#b.s*8)/2
        if on then
            -- Plain antialiased glyph pictures bypass the engine's mandatory shadow.
            lib.PicLoadCache(4,b.labelPic*2,tx,b.y+2,1)
        else
            DrawString(tx,b.y+2,b.s,C_Name,16)
        end
    end
    local labelIndex=0
    for ri,rn in ipairs(REGIONS) do local c=0
        for _,t in ipairs(R[rn] or {}) do if not seen[t] then
            seen[t]=true c=c+1 labelIndex=labelIndex+1
            local p=ORIGIN_MAP_POS[ri][c]
            btns[#btns+1]={x=ox+p[1],y=oy+p[2]-10,w=p[3]+10,h=20,s=t,pick=t,region=rn,labelPic=ORIGIN_LABEL_FIRST+labelIndex-1,sel=(t==cur),draw=cityDraw}
        end end
    end
    -- Enter retains the current origin, matching the highlighted map marker.
    for i,b in ipairs(btns) do if b.sel then btns[1],btns[i]=btns[i],btns[1] break end end
    btns[#btns+1]={x=ox+670,y=oy+434,w=76,h=26,s="\137\066\129\110\129\094\131\071",cancel=true,plain=true}
    local r=koOfficerWait(function(hov)
        koOfficerBack(ORIGIN_MAP_PIC)
        local b=btns[hov]
        lib.Background(ox+18,oy+434,ox+650,oy+464,190,M_Black)
        if b and b.pick then
            DrawString(ox+28,oy+441,b.pick.." ("..b.region..")",C_Name,16)
        elseif cur and cur~="" then
            DrawString(ox+28,oy+441,"\133\066\131\100: "..cur,C_Name,16)
        end
        DrawString(ox+230,oy+441,"\129\1001\131\097\130\094\131\104 \133\066\131\100\135\122 \129\071\137\121 \130\067\134\074\131\080 \130\065\131\106 \130\075\135\070\129\102 \131\118\133\111\129\076\129\077",M_Silver,16)
    end,btns)
    local b=btns[r]
    if b and b.pick then return b.pick end
    return nil
end
local function blank()
	return {name="",sex=0,face=0,bz=1,wl=50,zl=50,ts=50,tf=0,s1=0,s2=0,s3=0,s4=0,s5=0,s6=0,home="",war=0,city=0,fig=0,aw=0}
end
local function copy(g) local c={} for k,v in pairs(g) do c[k]=v end return c end
local function regionOf(home)
	local R=rawget(_G,"koTownRegions") and koTownRegions() or {}
	for ri,rn in ipairs(REGIONS) do for ti,t in ipairs(R[rn] or {}) do if t==home then return ri,ti end end end
	return 1,1
end

-- 그림 넣기 한 번 (신무장 등록 · 장수편집 공용): 파일 고르기 → dir 에 정해진 이름으로 나누기 → before(prog) → T 칸에 넣기
--  → 평상 조형은 앞뒤 확인 → after(got,prog) → 다 넣었다는 알림. 돌려줌: got (실패·취소 = nil)
-- 10-25: an error while putting pictures shows a message (and ko_newgen_err.txt) instead of closing the game
local function safeImport(...)
	local ok,a,b=pcall(importTo,...)
	if ok then return a,b end
	local f=io.open(CONFIG.CurrentPath.."ko_newgen_err.txt","ab") if f then f:write(os.date("%Y-%m-%d %H:%M:%S ")..tostring(a)..string.char(13,10)) f:close() end
	collectgarbage("collect")
	return {},{tostring(a)}
end
local PUT_NAME={face="\140\118\134\094",war="\130\066\132\101 \129\118\136\069",city="\131\119\129\067 \129\118\136\069"}
local PUT_HOW={face="BMP \129\111 \131\097 (64x80 \129\071 \132\097\138\071\130\077)",war="MOV\161\164SPC\161\164ATK \131\111 \131\097 (48x528\161\16448x240\161\16464x768)",city="\130\066\129\065\161\164\133\067\129\065 \130\091 \131\097 (\129\094\132\083 48, \129\071\138\075 \139\091 1\161\1642)"}
local function putFlow(k,pickArg,dir,T,before,after)
	local ox,oy=oxy()
	local paths=koNewGenPickFiles(k,pickArg)
	if paths==nil then msg({"\129\071 \131\071\131\071\129\102\131\087\130\098 \134\086\133\073 \133\109\133\110 \134\103\129\083 \129\110\132\076 \132\080 \129\113 \130\097\129\075\129\076\129\077"}) return nil end
	if #paths==0 then return nil end
	local function prog(fr,t)   -- 진행 막대 (불투명 상자를 다시 그려 앞 글씨가 비치지 않게)
		koRecordClassicFrame(ox+184,oy+190,400,100)
		lib.DrawRect(ox+184,oy+190,ox+584,oy+190,M_Gray) lib.DrawRect(ox+184,oy+290,ox+584,oy+290,M_Gray) lib.DrawRect(ox+184,oy+190,ox+184,oy+290,M_Gray) lib.DrawRect(ox+584,oy+190,ox+584,oy+290,M_Gray)
		ctext(ox+384,oy+204,PUT_NAME[k].." \134\112\130\098 \130\101",C_Name)
		lib.FillColor(ox+204,oy+234,ox+564,oy+254,RGB(40,40,40))
		lib.FillColor(ox+204,oy+234,ox+204+math.floor(360*fr),oy+254,RGB(210,170,60))
		ctext(ox+384,oy+262,t.."  "..math.floor(fr*100).."%",M_White)
		ShowScreen()
		lib.GetKey()   -- (창 이벤트를 비워 「응답 없음」이 안 되게)
	end
	prog(0,"\131\100\135\077 \131\091\130\079 \131\118\134\117\130\098 \130\101")
	local ok,e=koNewGenSortKind(dir,k,paths)
	if not ok then msg({PUT_NAME[k].."\129\083 \134\112\130\067 \136\102\129\080\129\075\129\076\129\077",e,PUT_HOW[k]}) return nil end
	if before and not before(prog) then msg({PUT_NAME[k].."\129\083 \134\112\130\067 \136\102\129\080\129\075\129\076\129\077","\131\081\134\071 \131\091\130\079\129\083 \131\115\129\101\129\097\130\067 \136\102\129\080\129\075\129\076\129\077"}) return nil end
	local got,err=safeImport(T,dir,{[k]=true},function(fr,t) prog(0.05+fr*0.85,t) end)
	while got[k] and k=="city" do   -- 정면·뒷면 확인 (선택 창은 순서를 바꾸고, 그림 칸 수로도 못 가리는 시트가 있음)
		local E=T.city
		local c=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC) panel(ox+164,oy+110,ox+604,oy+370)
			ctext(ox+384,oy+126,"\131\119\129\067 \129\118\136\069 \139\073\135\068 \129\105\129\106",C_Name,24)
			local fr=({0,1,0,2})[math.floor(lib.GetTime()/220)%4+1]
			for i,d in ipairs({1,0}) do local x=ox+254+(i-1)*170
				lib.SetClip(x,oy+176,x+48,oy+240) lib.PicLoadCache(5,(E+d)*2,x,oy+176-fr*64,1) lib.SetClip(0,0,0,0)
				ctext(x+24,oy+248,(i==1) and "\129\070\129\065" or "\143\094\129\065",C_Name) ctext(x+24,oy+268,(i==1) and "(\129\110\134\071\132\083 \130\064\129\083 \132\085)" or "(\130\110\132\083 \130\064\129\083 \132\085)",M_Silver) end
			ctext(ox+384,oy+298,"\129\070\129\065\129\102 \140\118\134\094\129\071 \131\115\129\071\129\065 \138\071\129\075\129\076\129\077",M_Silver)
		end,{{x=ox+224,y=oy+326,w=150,h=28,s="\138\071\129\075\129\076\129\077"},{x=ox+394,y=oy+326,w=150,h=28,s="\139\073\135\068 \131\085\131\086\131\071"}})
		if c~=2 then break end
		local a,b2=readAll(dir.."1.bmp"),readAll(dir.."2.bmp")
		if not (a and b2) then break end
		writeAll(dir.."1.bmp",b2) writeAll(dir.."2.bmp",a)
		got,err=safeImport(T,dir,{city=true},function(fr,t) prog(0.05+fr*0.85,t) end)
	end
	if got[k] then
		if after then after(got,prog) end
		prog(1,"\129\077 \134\112\132\107\129\075\129\076\129\077")
		msg({PUT_NAME[k].."\129\083 \134\112\132\107\129\075\129\076\129\077"})
		return got
	end
	local M={PUT_NAME[k].."\129\083 \134\112\130\067 \136\102\129\080\129\075\129\076\129\077"} for _,x in ipairs(err) do M[#M+1]=x end M[#M+1]=PUT_HOW[k] msg(M)
	return nil
end

local function edit(id,orig)
	local ox,oy=oxy()
	local slot=NG_BASE+id
	local g=copy(orig or blank())
	local R=rawget(_G,"koTownRegions") and koTownRegions() or {}
	local TOWNS,TREG={},{}   -- 연고 = 마을 하나 (10-12 사용자: 지역·마을을 따로 고르면 이웃을 고르는 것처럼 보임)
	for _,rn in ipairs(REGIONS) do for _,t in ipairs(R[rn] or {}) do if not TREG[t] then TOWNS[#TOWNS+1]=t TREG[t]=rn end end end
	local ti=1 for i,t in ipairs(TOWNS) do if t==g.home then ti=i end end
	if g.home=="" then g.home=TOWNS[1] or "" end
	if orig==nil then local K=rawget(_G,"koGenShare") g.mode=K and K.MCODE[K.MODE] or 0 end   -- 11-11: 새 무장 = 지금 모드
	local dirty=(orig==nil)
	while true do
		write(slot,g,id)
		local left=STAR_BUDGET-stars(g)
		local btns={}
		local function B(t) btns[#btns+1]=t return t end
		local X,Y=ox+250,oy+60
		B({x=X+370,y=Y,w=114,h=24,s="\129\071\138\075 \130\116\131\064",act="name"})
		B({x=X+370,y=Y+30,w=114,h=24,s="\131\123\138\090 \130\116\131\064",act="sex"})
		B({x=X+70,y=Y+60,w=414,h=24,s=JY.Bingzhong[g.bz][SKN],act="bzpick"})
		local function sget(f) return g[f] end
		statBoxes(B,X,Y+90,sget)   -- 10-15: 능력치 입력칸 (막대는 그리기 · overlay)
		B({x=X+70,y=Y+186,w=180,h=24,s=skName(g.tf),act="skill",f="tf"})
		B({x=X+304,y=Y+186,w=180,h=24,s=skName(g.aw),act="skill",f="aw"})   -- 11-21: 각성 특기 (별 안 씀, 무장 각성 때 얻음)
		for k=1,6 do local c,r=(k-1)%3,math.floor((k-1)/3)
			B({x=X+c*164,y=Y+240+r*28,w=156,h=24,s=k.."  "..skName(g["s"..k]),act="skill",f="s"..k}) end
		B({x=X+70,y=Y+306,w=414,h=24,s=g.home.."  ("..(TREG[g.home] or "")..")",act="townpick"})
		B({x=X+70,y=Y+336,w=414,h=24,s=koGenShare.mname(g.mode or 0),act="modepick"})   -- 11-11: 출현 모드
		B({x=ox+28,y=oy+236,w=130,h=26,s="\140\118\134\094 \134\112\131\071",act="put",k="face"})
		B({x=ox+28,y=oy+268,w=130,h=26,s="\130\066\132\101 \129\118\136\069 \134\112\131\071",act="put",k="war"})
		B({x=ox+28,y=oy+300,w=130,h=26,s="\131\119\129\067 \129\118\136\069 \134\112\131\071",act="put",k="city"})
		B({x=ox+164,y=oy+236,w=62,h=26,s="\131\124\131\071\129\064",act="reset",k="face"})   -- 10-13 (사용자): 잘못 넣었을 때 되돌리기
		B({x=ox+164,y=oy+268,w=62,h=26,s="\131\124\131\071\129\064",act="reset",k="war"})
		B({x=ox+164,y=oy+300,w=62,h=26,s="\131\124\131\071\129\064",act="reset",k="city"})
		B({x=ox+502,y=oy+432,w=110,h=28,s="\133\102\131\097",act="save",primary=true})
		if orig then B({x=ox+28,y=oy+432,w=110,h=28,s="\129\073\131\097 \156\250\129\100",act="del"}) end
		B({x=ox+624,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",act="back"})
		local function drawScr()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+14,"\131\078\129\073\131\097 \133\125\133\108 \161\164 "..id.."\130\087",C_Name,24)
			lib.PicLoadCache(2,JY.Person[slot][P.FACE]*2,ox+28,oy+62,1)
			drawAnim(slot,g,ox+100,oy+70)
			DrawString(ox+28,oy+150,(g.face==1 and "\140\118\134\094: \134\112\131\098 \131\091\130\079" or "\140\118\134\094: \129\078\131\094\129\204"),M_Silver,16)
			local nb=GRID.wbCount and GRID.wbCount(g) or 0
			DrawString(ox+28,oy+172,"\130\066\132\101: "..(((g.war==1 or nb>0) and ((g.war==1 and "\130\074\132\119" or "")..((g.war==1 and nb>0) and " \161\164 " or "")..((nb>0) and ("\130\126\129\084 "..nb.."\134\075") or ""))) or "\130\126\129\084 \131\071\132\118"),M_Silver,16)
			DrawString(ox+28,oy+194,(g.city==1 and "\131\119\129\067: \134\112\131\098 \131\091\130\079" or "\131\119\129\067: \131\071\132\118"),M_Silver,16)
			DrawString(ox+28,oy+360,"\138\072\131\126\141\074 "..tostring(rawget(_G,"koCostOf") and koCostOf(slot) or "?"),M_White,16)
			DrawString(ox+28,oy+384,"\131\100\132\111 \130\080\132\111 \135\067 "..hirePrice(slot).."\131\103",M_White,16)
			DrawString(X,Y+4,"\129\071\138\075  "..(g.name=="" and "(\130\097\130\077)" or g.name),g.name=="" and M_Gray or C_Name,16)
			DrawString(X,Y+34,"\131\123\138\090  "..(g.sex==1 and "\129\098" or "\133\103"),M_White,16)
			DrawString(X,Y+64,"\130\126\129\084",M_White,16)
			statRows(X,Y+90,sget)
			DrawString(X,Y+190,"\130\115\130\094",M_White,16)
			DrawString(X+262,Y+190,"\130\069\131\123",M_Yellow,16)
			DrawString(X,Y+218,"\129\120\131\071   \138\090 "..stars(g).."/"..STAR_BUDGET.." (\133\103\130\077 "..left..")",left<0 and M_Red or M_White,16)
			DrawString(X,Y+310,"\133\066\131\100",M_White,16)
			DrawString(X,Y+340,"\133\098\129\114",M_White,16)
		end
		local r=koOfficerWait(drawScr,btns,function()
			statDrag(X,Y+90,sget,function(f,v) g[f]=v dirty=true write(slot,g,id) end)
		end)
		local b=btns[r]
		if r==0 then b={act="back"} end
		if b then
			local a=b.act
			if a=="name" then
				local n,bad=koNewGenInputName(g.name)   -- PC: 입력 창 (한글 입력기), 못 쓰면 음절판
				if n==false then n=namePad(g.name) end
				if bad then msg({"\129\081\129\082 \142\116\140\066\129\102 \130\097\130\098 \142\116\133\120\129\094 "..#bad.."\133\120 \132\079\129\075\129\076\129\077","\129\111\142\116\161\164\129\126\133\090\161\164\202\238\133\120\132\083 \130\067\130\083 \130\075\131\111\129\090"}) n=nil end
				if n then
					if n=="" then msg({"\129\071\138\075\129\071 \130\080\132\107\129\075\129\076\129\077"}) elseif nameTaken(n,id) then msg({"\129\071\134\119 \132\079\130\098 \129\071\138\075\129\104\129\076\129\077","\129\077\135\077 \129\073\131\097\129\123 \132\071\131\098 \129\071\138\075\131\098 \132\080 \129\113 \130\097\129\075\129\076\129\077"}) else g.name=n dirty=true end end
			elseif a=="sex" then g.sex=1-g.sex dirty=true
			elseif a=="bzpick" then local c=classPick(g.bz) if c then g.bz=c dirty=true end
			elseif a=="statin" then
				local v=statEntry(drawScr,btns,b,g[b.f])
				if v and v~=g[b.f] then g[b.f]=v dirty=true end
			elseif a=="skill" then
				local used={} if g.tf>0 then used[g.tf]=true end for k=1,6 do if g["s"..k]>0 then used[g["s"..k]]=true end end
				if (g.aw or 0)>0 then used[g.aw]=true end
				local cur=g[b.f] or 0
				local k
				if b.f=="aw" then   -- 11-21: 각성 특기는 별을 안 씀 (모든 별 고를 수 있음), 천부 · 특기와 겹치지 않게
					k=skillPick("\130\069\131\123 \129\120\131\071 \131\100\130\106\131\071 (\129\073\131\097 \130\069\131\123 \132\085 \133\086\130\077)",cur,7,used)
				else
					k=skillPick(b.f=="tf" and "\130\115\130\094 \131\100\130\106\131\071" or ("\129\120\131\071 "..string.sub(b.f,2).." \131\100\130\106\131\071"),cur,left+(STAR_OF[cur] or 0),used)
				end
				if k then g[b.f]=k dirty=true end
			elseif a=="townpick" then local t=townPick(g.home) if t then g.home=t dirty=true end
			elseif a=="modepick" then   -- 11-11: 출현 모드 (모든 모드 → 영걸전 → 무제전 → 손견전 → 원소전 차례로)
				local Lm=koGenShare.MLIST local k=1 for i,e in ipairs(Lm) do if e[1]==(g.mode or 0) then k=i end end
				g.mode=Lm[k%#Lm+1][1] dirty=true
			elseif a=="put" or a=="reset" then
				local k=b.k
				local NAME={face="\140\118\134\094",war="\130\066\132\101 \129\118\136\069",city="\131\119\129\067 \129\118\136\069"}
				-- the old one-set flow (얼굴 · 평상 · 전투 공통)
				local function one()
					local go=true
					if g[k]==1 then
						local c=ask3({"\129\071\134\119 \134\112\131\098 "..NAME[k]..((k=="war") and " (\130\074\132\119)" or "").."\129\071 \132\079\129\075\129\076\129\077"},"\134\068\132\083 \131\100\130\106\131\071","\131\071\132\118\131\109\132\083","\129\108\129\109")
						if c==2 then koNewGenClearImages(id,{[k]=true}) g[k]=0 dirty=true end
						go=(c==1)
					end
					if go then
						local dir=CONFIG.CurrentPath..folder(id)
						local got=putFlow(k,id,dir,ngT(id),nil,function(got,prog)
							prog(0.95,"\133\102\131\097 \193\142\132\108\129\102 \130\114\132\118 \133\103\131\071\130\098 \130\101")
							koNewGenKeepCopy(id,dir,got)
						end)
						if got then g[k]=1 dirty=true end
					end
				end
				if a=="reset" then   -- 10-13 (사용자): 넣은 그림을 모두 기본으로
					local any=(g[k]==1) or (k=="war" and GRID.wbCount and GRID.wbCount(g)>0)
					if not any then msg({"\134\112\131\098 "..NAME[k].."\129\071 \130\097\129\075\129\076\129\077"})
					elseif ask({NAME[k].."\129\083 \131\071\132\118 \131\091\130\079\131\109\132\083 \132\067\137\066\132\117\129\089\129\090?",(k=="war") and "\130\074\132\119 \131\091\130\079\129\123 \130\126\129\084\138\090 \131\091\130\079\129\083 \130\090\130\091 \130\067\140\124\129\076\129\077" or nil},"\131\124\131\071\129\064","\129\108\129\109") then
						if g[k]==1 then koNewGenClearImages(id,{[k]=true}) g[k]=0 end
						if k=="war" and GRID.ngClearAll then GRID.ngClearAll(id,g) end
						dirty=true
						msg({NAME[k].."\129\083 \131\071\132\118 \131\091\130\079\131\109\132\083 \132\067\137\066\132\126\129\075\129\076\129\077"})
					end
				elseif k=="war" and GRID.war then   -- 10-13: the class grid (its 공통 button = the one-set flow)
					if rawget(_G,"koUniqueWar") then koUniqueWar[slot]=(g.war==1) or nil end
					GRID.war(slot,function() one() if rawget(_G,"koUniqueWar") then koUniqueWar[slot]=(g.war==1) or nil end end,{
						isOn=function(bz) return GRID.wbHas(g,bz) end,
						commonOn=function() return g.war==1 end,
						put=function(list,keep) local got=GRID.ngPut(id,g,list,keep) if got then dirty=true end return got end,
						restore=function(bz) GRID.ngRestore(id,g,bz) dirty=true end})
				else one() end
			elseif a=="save" then
				if g.name=="" then msg({"\129\071\138\075\129\083 \129\070\129\066 \130\075\131\111\129\090"})
				elseif left<0 then msg({"\129\120\131\071 \138\090\129\071 \129\072\129\073 \135\065\129\075\129\076\129\077","\138\090 "..stars(g).."/"..STAR_BUDGET})
				else local L=koNewGenList() L[id]=g koNewGenSave(L) uniqueSync(L) msg({"\133\102\131\097\129\080\129\075\129\076\129\077",g.name..": "..koGenShare.mname(g.mode or 0).." \129\1001\131\097\130\094\131\104 "..g.home.." \134\090\139\110 \130\075\135\070\129\102 \131\118\133\111\129\076\129\077"}) return true end
			elseif a=="del" then
				if ask({orig.name.." \129\083(\130\104) \130\067\133\091\129\089\129\090?","\129\071\134\119 \133\104\131\096\133\121 \129\073\131\097\131\098 \131\091 \133\102\131\097 \131\071\133\108\129\102 \131\091\130\095\132\083 \133\103\129\075\129\076\129\077"},"\130\067\131\079\131\071","\129\108\129\109") then
					koNewGenClearImages(id,{face=orig.face==1,war=orig.war==1,city=orig.city==1})
					if GRID.ngClearAll then GRID.ngClearAll(id,g) end   -- 10-13: his class sets too
					local L=koNewGenList() L[id]=nil koNewGenSave(L) uniqueSync(L) return true end
			elseif a=="back" then
				if not dirty or ask({"\133\102\131\097\129\097\130\067 \130\107\131\100 \131\118\135\121\129\089\129\090?"},"\131\118\129\094\131\071","\132\084\133\123 \131\100\132\081\131\071") then return false end
			end
		end
	end
end

function koNewGenScreen()
	LoadRecord(0)
	local ox,oy=oxy()
	while true do
		local L=koNewGenList()
		local btns={}
		for id=1,NG_MAX do
			local c,r=math.floor((id-1)/10),(id-1)%10
			local g=L[id]
			btns[#btns+1]={x=ox+40+c*350,y=oy+84+r*32,w=338,h=28,id=id,
				s=(g and (id..".  "..g.name.."  "..JY.Bingzhong[g.bz][SKN].."  "..g.home.."  ["..koGenShare.mname(g.mode or 0).."]")) or (id..".  \134\068 \129\073\131\097 \132\086\131\082\131\071")}
		end
		btns[#btns+1]={x=ox+640,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",back=true}
		btns[#btns+1]={x=ox+40,y=oy+432,w=110,h=28,s="\131\095\131\115\131\095\131\071",pexp=true}   -- 11-11: zip 으로 공유
		btns[#btns+1]={x=ox+156,y=oy+432,w=110,h=28,s="\129\094\136\107\129\091\131\071",pimp=true}
		local n=0 for _ in pairs(L) do n=n+1 end
		local r=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+16,"\131\078\129\073\131\097 \133\125\133\108",C_Name,32)
			ctext(ox+384,oy+56,"\133\125\133\108 "..n.."/"..NG_MAX.."\130\088 \161\164 \133\105 \135\066\129\083 \134\117\130\106\129\065 \134\068 \129\073\131\097\129\083 \132\086\143\120\129\076\129\077",M_Silver)
		end,btns)
		local b=btns[r]
		if r==0 or (b and b.back) then break end
		if b and b.pexp then koGenPackExport("newgen")   -- (FC 는 이 함수보다 뒤에 만드는 local 이라 전역 이름으로)
		elseif b and b.pimp then koGenPackImport() LoadRecord(0)
		elseif b and b.id then edit(b.id,L[b.id]) end
	end
	LoadRecord(0)
end
-- 11-11 사용자 「모드별 장수편집 · 신무장 등록은 제거」: 메인 화면 「장수 관리」(koGenManageMenu)에서만

-- ==== 타이틀 메뉴 「장수편집」 (10-12 사용자): 기존 장수(1~420)의 얼굴 · 전투 조형 · 평상 조형을 그림 파일로 바꿈 ====
--  · 얼굴 = hdgrp 의 그 장수 얼굴 번호 칸 (같은 번호를 쓰는 장수도 같이 바뀜 — 술집 사본은 원래 장수와 같은 번호라 같이 바뀌는 게 맞음).
--  · 전투 = wmap 20000+장수*50 의 50칸 + koUniqueWar, 평상 = smap 200+(300+장수)*4 의 4칸 + koUniqueCity. 두 목록은 조형 교체기와 같은
--    unique.lua 의 LIST / CITY 칸을 다시 써서 남김 (교체기에서도 「바꾼 장수」로 보이고 조형 팩 내보내기에 들어감). 421 이상 칸은 새로 넣지 않음.
--  · 「원래대로」 = 처음 바꾸기 직전 그림 (genedit/orig/ 의 f얼굴번호 · w장수 · c장수 .bin, 그때 목록에 있었는지도). 성삼국 조형도 그대로 돌아옴.
--  · 바꾼 표시 = ko_settings 의 CC.koGenEdit (",f12,w7,c27,"). 전투 조형을 바꾼 장수는 spriteclass(성삼국 조형 병종 맞춤 · 단계 조형)에서 뺌.
--  · 그림 고르기 · 나누기 · 넣기 · 앞뒤 확인은 신무장과 같은 putFlow (작업 폴더 genedit/work/).
local GE_DIR="genedit/"
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koGenEdit",default=""} end
-- ---- 11-11 사용자 「장수편집은 모든 모드가 함께 쓰게 (메인 화면으로), 기존 기록은 영걸전 우선」: 공용 저장
--  · 그림 표시 CC.koGenEdit · 원래 얼굴 CC.koGenFaceOld = 공용(koSharedKeys, 게임 폴더 ko_settings.lua). 그림 칸 번호(얼굴 · 조형 · 따로 받은 칸)는 원래 한 벌.
--  · 번호로 적던 능력치 · 따로 받은 조형 칸 · 따로 받은 얼굴 칸은 통합 명단(genedit_roster.lua, 도구/장수편집_명단.py) 키로 공용
--    CC.koGenStatAll ",\137\074:\129\073:\130\067:\132\119," · CC.koGenSlotAll ",\137\074:\135\066," · CC.koGenFaceAll ",\137\074:\131\081\134\071:\134\068," (키 = 영걸전 번호, 이야기 전용은 "\129\071\133\069\131\071@\130\087\134\113",
--    명단에 없는 칸은 "\130\090\133\119#\130\087\134\113"). 모드마다 시작할 때 그 모드 번호로 풀어 옛 이름(CC.koGenStat · koGenSlot · koGenFace)에 넣고(pull),
--    koSave 때 되돌려 넣음(push) — 나머지 장수편집 코드는 그대로 옛 이름을 씀.
--  · 처음 한 번(CC.koGenShared~=1): 네 모드 ko_settings 의 기록을 영걸전 → 무제전 → 손견전 → 원소전 순으로 합침(먼저 있는 키 우선),
--    이야기 세이브 폴더의 그림 사본(genedit/*.kgs)은 공용 폴더(data/save/genedit/)에 없을 때만 옮기고, 모든 표시를 gesync imported.txt 에 적어
--    사본 그대로 다시 넣게 함(그림 칸에는 마지막에 켠 모드 그림이 들어 있을 수 있음).
--  · 공용 사본 genedit/shared.txt = 위 다섯 값(ko_settings 를 새 판으로 덮어써도 되살림, gesync settingsGuard 와 같은 까닭).
do
local KS={}
rawset(_G,"koGenShare",KS)
pcall(dofile,CONFIG.ScriptPath.."addon/genedit_roster.lua")
KS.MODES={"yeonggeol","wuje","sunjian","yuanshao"}
KS.MODE=CONFIG.koCamp or "yeonggeol"
KS.ALLK={"koGenEdit","koGenFaceOld","koGenStatAll","koGenSlotAll","koGenFaceAll","koGenShared"}
KS.NGK={"koNewGen","koNewGenShared"}   -- 11-11 신무장 공용
KS.LOC={koGenStat="koGenStatAll",koGenSlot="koGenSlotAll",koGenFace="koGenFaceAll"}
if type(koAddon)=="table" and koAddon.saveKeys then
	for _,k in ipairs({"koGenStatAll","koGenSlotAll","koGenFaceAll"}) do koAddon.saveKeys[#koAddon.saveKeys+1]={key=k,default=""} end
	koAddon.saveKeys[#koAddon.saveKeys+1]={key="koGenShared",default=0}
	koAddon.saveKeys[#koAddon.saveKeys+1]={key="koNewGenShared",default=0}
end
if type(rawget(_G,"koSharedKeys"))=="table" then for _,k in ipairs(KS.ALLK) do table.insert(koSharedKeys,k) end for _,k in ipairs(KS.NGK) do table.insert(koSharedKeys,k) end end
function KS.root() if CONFIG.koCamp then return string.sub(CONFIG.Save,1,#CONFIG.Save-#CONFIG.koCamp-1) end return CONFIG.Save end
function KS.dir() return KS.root().."genedit/" end
KS.COL={yeonggeol=3,wuje=4,sunjian=5,yuanshao=6}
KS.k2p,KS.p2k={},{}
for _,m in ipairs(KS.MODES) do KS.k2p[m]={} KS.p2k[m]={} end
for _,r in ipairs(rawget(_G,"koGenRoster") or {}) do
	local key=(type(r[1])=="number") and tostring(r[1]) or (string.gsub(r[1],":","@"))
	for m,c in pairs(KS.COL) do local p=r[c] if p and p>0 then KS.k2p[m][key]=p KS.p2k[m][p]=key end end
end
function KS.keyOf(m,pid)
	local k=KS.p2k[m][pid] if k then return k end
	if m==KS.MODE and JY and JY.Person and JY.Person[pid] then   -- 명단 밖 칸(따로 받은 칸의 대표번호 등): 이 모드에서 이름 · 조형 번호가 같은 명단 칸
		local f=rawget(_G,"koWujeIdentity") local nm=JY.Person[pid][P.NAME] local id=f and f(pid) or pid
		for q,key in pairs(KS.p2k[m]) do if JY.Person[q] and JY.Person[q][P.NAME]==nm and ((f and f(q)) or q)==id then return key end end
	end
	return m.."#"..pid
end
function KS.pidOf(m,key)
	local p=KS.k2p[m][key] if p then return p end
	local mm,pp=string.match(key,"^(%a+)#(%d+)$") if mm==m then return tonumber(pp) end
	return nil
end
function KS.entries(s) local t={} for e in string.gmatch(s or "","[^,]+") do local a,b=string.match(e,"^([^:]+):(.+)$") if a then t[#t+1]={a,b} end end return t end
function KS.join(t) return (#t>0) and (","..table.concat(t,",")..",") or "" end
function KS.toLocal(all,m) local t={} for _,e in ipairs(KS.entries(all)) do local p=KS.pidOf(m,e[1]) if p then t[#t+1]=p..":"..e[2] end end return KS.join(t) end
function KS.toAll(all,loc,m)
	local t,seen={},{}
	for _,e in ipairs(KS.entries(loc)) do local p=tonumber(e[1]) if p then local k=KS.keyOf(m,p) if not seen[k] then seen[k]=true t[#t+1]=k..":"..e[2] end end end
	for _,e in ipairs(KS.entries(all)) do if not KS.pidOf(m,e[1]) and not seen[e[1]] then seen[e[1]]=true t[#t+1]=e[1]..":"..e[2] end end
	return KS.join(t)
end
function KS.settingsFile(m) if m=="yeonggeol" then return CONFIG.CurrentPath.."ko_settings.lua" end return KS.root()..m.."/ko_settings.lua" end
function KS.readSettings(m)
	local s=readAll(KS.settingsFile(m)) if not s then return {} end
	local env={CC={}}
	local fn=load(s,"ko_settings","t",env)
	if fn then pcall(fn) end
	return env.CC
end
function KS.backup()
	local L={"KGSH1"} for _,k in ipairs(KS.ALLK) do L[#L+1]=k.."="..tostring(CC[k] or "") end
	mkdir(string.sub(KS.dir(),1,-2)) writeAll(KS.dir().."shared.txt",table.concat(L,"\n").."\n")
end
function KS.restore()
	if (CC.koGenShared or 0)==1 then return end
	local s=readAll(KS.dir().."shared.txt")
	if not s or string.sub(s,1,5)~="KGSH1" then return end
	for k,v in string.gmatch(s,"(koGen%a+)=([^\r\n]*)") do if k=="koGenShared" then CC[k]=tonumber(v) or 0 else CC[k]=v end end
end
function KS.migrate()
	local tags,tagSeen,old,oldSeen={},{},{},{}
	local A={koGenStatAll={},koGenSlotAll={},koGenFaceAll={}} local Aseen={koGenStatAll={},koGenSlotAll={},koGenFaceAll={}}
	local R=KS.root()
	local imp={}
	for _,m in ipairs(KS.MODES) do
		local c=KS.readSettings(m)
		if KS.dbg then KS.dbg(m,KS.settingsFile(m),c.koGenEdit,c.koGenStat) end
		for t in string.gmatch(c.koGenEdit or "","[^,]+") do if not tagSeen[t] then tagSeen[t]=true tags[#tags+1]=t end end
		for v,o in string.gmatch(c.koGenFaceOld or "","(%d+):(%d+)") do if not oldSeen[v] then oldSeen[v]=true old[#old+1]=v..":"..o end end
		for l,a in pairs(KS.LOC) do
			for _,e in ipairs(KS.entries(c[l])) do local p=tonumber(e[1]) if p then local k=KS.keyOf(m,p) if not Aseen[a][k] then Aseen[a][k]=true table.insert(A[a],k..":"..e[2]) end end end
		end
		if m~="yeonggeol" then
			for t in string.gmatch(readAll(R..m.."/genedit/list.txt") or "","[^\r\n]+") do
				local src=readAll(R..m.."/genedit/"..t..".kgs")
				if src and not readAll(KS.dir()..t..".kgs") then mkdir(string.sub(KS.dir(),1,-2)) writeAll(KS.dir()..t..".kgs",src) end
			end
		end
	end
	for _,t in ipairs(tags) do imp[#imp+1]=t end
	CC.koGenEdit=KS.join(tags) CC.koGenFaceOld=KS.join(old)
	for a,t in pairs(A) do CC[a]=KS.join(t) end
	CC.koGenShared=1
	if #imp>0 then mkdir(string.sub(KS.dir(),1,-2)) local o=readAll(KS.dir().."imported.txt") or "" writeAll(KS.dir().."imported.txt",o..table.concat(imp,"\n").."\n") end
	KS.migrated=true
end
KS.MCODE={yeonggeol=1,wuje=2,sunjian=3,yuanshao=4}
KS.MLIST={{0,"\130\090\136\101 \130\090\133\119"},{1,"\129\126\130\064\130\066"},{2,"\129\073\129\100\130\066"},{3,"\135\089\134\084\130\066"},{4,"\131\081\129\109\130\066"}}
function KS.mname(c) for _,e in ipairs(KS.MLIST) do if e[1]==c then return e[2] end end return "\130\090\136\101 \130\090\133\119" end
-- 11-11 신무장 공용: 등록부 CC.koNewGen 도 공용(koSharedKeys), 그림 사본 · 등록부 사본 = 영걸전 세이브 폴더. 처음 한 번(CC.koNewGenShared~=1)
--  네 모드 등록부를 영걸전 → 무제전 → 손견전 → 원소전 순으로 합침: 번호가 비면 그대로, 겹치면 빈 번호로 옮기고 그림 사본(newgen/NN/ · b병종/)도 옮김.
--  출현 모드 = 원래 모드. 모든 번호를 공용 newgen/imported.txt 에 적어 gesync 가 사본으로 그림을 다시 넣게 함. 20명 넘으면 넘는 무장은 빠짐(드묾).
function KS.ngOn() return (CC.koNewGenShared or 0)==1 end
function KS.cp(a,b) if a==b then return end local s=readAll(a) if s then writeAll(b,s) end end
function KS.ngCopy(src,dst)
	if src==dst then return end
	mkdir(string.sub(dst,1,-2))
	for _,n in ipairs(IMGS) do KS.cp(src..n,dst..n) end
	for b=0,45 do if readAll(src.."b"..b.."/MOV.bmp") then mkdir(dst.."b"..b) for _,n in ipairs({"MOV.bmp","SPC.bmp","ATK.bmp"}) do KS.cp(src.."b"..b.."/"..n,dst.."b"..b.."/"..n) end end end
end
function KS.ngMigrate()
	local merged,used,imp={},{},{}
	local R=KS.root()
	for mi,m in ipairs(KS.MODES) do
		local c=KS.readSettings(m)
		local saved=CC.koNewGen
		CC.koNewGen=c.koNewGen or ""
		local L=koNewGenList()
		CC.koNewGen=saved
		for id=1,NG_MAX do local g=L[id] if g then
			local nid=id
			if used[nid] then nid=nil for k=1,NG_MAX do if not used[k] then nid=k break end end end
			if nid then
				used[nid]=true g.id=nid
				if (g.mode or 0)==0 then g.mode=mi end
				merged[nid]=g imp[#imp+1]=tostring(nid)
				KS.ngCopy(R..((m=="yeonggeol") and "" or (m.."/"))..folder(id),R..folder(nid))
			end
		end end
	end
	CC.koNewGenShared=1
	koNewGenSave(merged)
	if #imp>0 then mkdir(R.."newgen") local o=readAll(R.."newgen/imported.txt") or "" writeAll(R.."newgen/imported.txt",o..table.concat(imp,string.char(10))..string.char(10)) end
end
-- 11-11 사용자 「도감도 메인 화면으로」: 보물 도감 기록 CC.koBogam(목록 순서 한 글자 0~3, 1 원본 · 2 ★)도 공용(bogam 애드온이 koSharedKeys 에 넣음).
--  처음 한 번 네 모드 기록을 글자마다 합침(본 것은 어느 모드든 본 것). 여기서 하는 까닭 = 위 합치기들과 같음(이야기 파일이 덮이기 전)
function KS.bogamMigrate()
	local t={}
	for _,m in ipairs(KS.MODES) do
		local s=KS.readSettings(m).koBogam or ""
		for i=1,#s do
			local v,o=tonumber(string.sub(s,i,i)) or 0,t[i] or 0
			t[i]=(((v%2==1) or (o%2==1)) and 1 or 0)+(((v>=2) or (o>=2)) and 2 or 0)
		end
	end
	local out={} for i=1,#t do out[i]=tostring(t[i] or 0) end
	CC.koBogam=table.concat(out)
	CC.koBogamShared=1
end
function KS.pull()
	-- 11-11: recsave 의 기록 사본 맞추기(koRecSync)는 모드별로 푼 값(koGenStat 등)을 옛 사본으로 되돌리고 곧 koSave 함 → 그 사이엔 공용 기록에
	--  되돌려 넣지 않고(push 멈춤), 끝나면 공용 기록에서 다시 풂. 공용 기록이 늘 기준
	if not KS.rsWrapped and type(rawget(_G,"koRecSync"))=="function" then
		KS.rsWrapped=true
		local raw=koRecSync
		koRecSync=function(...)
			local was=KS.pulled KS.pulled=false
			local r=table.pack(pcall(raw,...))
			KS.pulled=was
			if was then for l,a in pairs(KS.LOC) do CC[l]=KS.toLocal(CC[a],KS.MODE) end if rawget(_G,"koSave") then pcall(koSave) end end
			if not r[1] then error(r[2],0) end
			return table.unpack(r,2,r.n)
		end
	end
	KS.restore()
	if (CC.koGenShared or 0)~=1 then pcall(KS.migrate) end
	if (CC.koNewGenShared or 0)~=1 then pcall(KS.ngMigrate) KS.migrated=true end
	if (CC.koBogamShared or 0)~=1 and rawget(_G,"koBogamList") then pcall(KS.bogamMigrate) KS.migrated=true end
	for l,a in pairs(KS.LOC) do CC[l]=KS.toLocal(CC[a],KS.MODE) end
	KS.pulled=true
	if KS.migrated then KS.migrated=nil if rawget(_G,"koSave") then pcall(koSave) end end
end
function KS.push()
	if not KS.pulled then return end
	for l,a in pairs(KS.LOC) do CC[a]=KS.toAll(CC[a],CC[l],KS.MODE) end
	pcall(KS.backup)
end
function KS.on() return (CC.koGenShared or 0)==1 end
-- 처음 합치기는 설정 파일을 읽은 바로 뒤(jymain 이 그 자리에서 koSettingsFold 를 부름)에: 이야기 모드는 공용 키(그림 표시)를 게임 폴더 값으로
-- 덮어쓰고, 타이틀의 recsave 가 곧 koSave 로 이야기 파일까지 덮어써서 그 뒤엔 이야기 쪽 옛 표시를 읽을 수 없음
if type(rawget(_G,"koSettingsFold"))=="function" then
	local rawFold=koSettingsFold
	koSettingsFold=function(...) pcall(KS.pull) return rawFold(...) end
end
if type(rawget(_G,"koSave"))=="function" then
	local rawSave=koSave
	koSave=function(...) pcall(KS.push) return rawSave(...) end
end
end
local function geHas(tag) return string.find(CC.koGenEdit or "",","..tag..",",1,true)~=nil end
local GE_CHANGED,GE_ORDER={},{}-- 6.0 (11-02): picture tags changed by the current action (shareAsk below)
local function geSet(tag,on)
	if GE_CHANGED[tag]==nil then GE_ORDER[#GE_ORDER+1]=tag end
	GE_CHANGED[tag]=on and true or false
	local s=CC.koGenEdit or "" if s=="" then s="," end
	s=string.gsub(s,","..tag..",",",")
	if on then s=s..tag.."," end
	if s=="," then s="" end
	CC.koGenEdit=s
	if rawget(_G,"koSave") then pcall(koSave) end
end
-- grp 의 칸 i 부터 n 칸 (빈 칸 = "")
local function grpGet(base,i,n)
	local f=io.open(base..".idx","rb") if not f then return nil end
	f:seek("set",math.max(0,(i-1)*4))
	local need=(i==0) and n or (n+1)
	local s=f:read(need*4) or "" f:close()
	if #s<need*4 then   -- 11-08: 파일 끝 너머 칸 = 빈 칸 (따로 받은 조형 칸은 wmap · smap 끝 너머에 있음)
		s=string.sub(s,1,#s-(#s%4))
		if #s<4 then local o={} for k=1,n do o[k]="" end return o end
		local last=string.sub(s,#s-3,#s)
		while #s<need*4 do s=s..last end
	end
	local e={}
	if i==0 then e[0]=0 for k=1,n do e[k]=u32(s,(k-1)*4) end else for k=0,n do e[k]=u32(s,k*4) end end
	local g=io.open(base..".grp","rb") if not g then return nil end
	local out={}
	for k=1,n do local len=e[k]-e[k-1] if len>0 then g:seek("set",e[k-1]) out[k]=g:read(len) or "" else out[k]="" end end
	g:close()
	return out
end
local function le32(v) return string.char(v%256,math.floor(v/256)%256,math.floor(v/65536)%256,math.floor(v/16777216)%256) end
local function packCells(was,cells)
	local h={"KOB1",string.char(was and 1 or 0),string.char(#cells%256,math.floor(#cells/256))}
	for _,c in ipairs(cells) do h[#h+1]=le32(#c) end
	for _,c in ipairs(cells) do h[#h+1]=c end
	return table.concat(h)
end
local function unpackCells(s)
	if not s or string.sub(s,1,4)~="KOB1" then return nil end
	local n=u16(s,5) local L={} local p=8+n*4
	for k=1,n do local v=u32(s,7+(k-1)*4) L[k]=string.sub(s,p,p+v-1) p=p+v end
	return string.byte(s,5)==1,L
end
local GE_N={face=1,war=50,city=4}
-- 6.0 (11-01, 사용자 「이야기 모드에서도 전투·평상 조형 편집」): 이야기 모드의 무장은 영걸전에도 있는 사람이면 그 영걸전 번호의 조형 칸을
-- 빌려 씀(koWujeIdentity — unique.lua 가 그 번호로 그림). 그래서 조형 칸 · 표시(w · c · v) · 고유 조형 목록은 SP(번호) 로, 얼굴 · 병종 미리보기는
-- 그 이야기 번호 그대로. 같은 칸을 영걸전과 이야기가 따로 바꾸면 gesync 의 칸 주인(genedit/owners.txt)이 켤 때마다 그 이야기 그림으로 맞춤
-- 11-06: 같은 사람의 딸린 칸 -> 주 칸 (이야기별). 무제전 관우, 손견전 손권 · 주태 · 관우(2번은 대지도 표시용)
local SAME_SLOT={wuje={[66]=382,[152]=31},sunjian={[381]=8,[382]=236,[2]=14}}
local function SPbase(pid) if CONFIG.koCamp then local f=rawget(_G,"koWujeIdentity") local id=f and f(pid) if id then return id end end return pid end
-- 11-08 (사용자 제보 「원소전 손책 조형을 코삼 손책으로 바꾸니 국의도 바뀜」): 이야기에서 이름이 다른 무장들이 같은 영걸전 번호의 조형 칸을
--  빌려 쓰면(원소전 국의 36 · 손책 154 → 61, 이야기마다 160~180명) 그 칸을 바꾸는 순간 모두 바뀌었음. 그런 「섞인 칸」의 무장은 전투 · 평상 조형을
--  바꿀 때 자기 칸을 따로 받음: 칸 번호 803 이상(wmap 20000+칸*50 · smap 200+(300+칸)*4, 파일 끝 너머 = 병종 세트와 같은 끝 자리 잡기),
--  이야기마다 CC.koGenSlot ",\130\095\133\113\130\087\134\113:\135\066," (+ 세이브 폴더 genedit/slots.txt). 대표번호 = 같은 칸 · 같은 이름(SAME_SLOT 는 주 칸)의 맨 앞 번호.
--  안 바꾼 무장은 원래처럼 빌린 칸을 그대로 보고, 바꾼 무장만 자기 칸(unique · spriteclass · town 이 koGenPrivSlot 으로 찾음).
--  고치기 전에 섞인 칸 자체를 바꾼 것(예 w61)은 그 칸 무장 누구의 「초기화」로든 되돌림(legacy).
local PRIV_MIN=803
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koGenSlot",default=""} end
local function slotMain(pid) return (SAME_SLOT[CONFIG.koCamp or ""] or {})[pid] or pid end
local PRIV={}
local function privInfo()
	local camp=CONFIG.koCamp
	if not camp then return nil end
	if PRIV.camp==camp and PRIV.n==JY.PersonNum then return PRIV end
	local f=rawget(_G,"koWujeIdentity")
	if not f or not JY.Person or (JY.PersonNum or 0)<2 then return nil end
	local town=rawget(_G,"koWujeTownNPC")
	local rep,cnt,key,mixed={},{},{},{}
	for pid=1,JY.PersonNum-1 do
		local m=slotMain(pid)
		local id=JY.Person[pid] and JY.Person[m] and not (town and town[pid]) and f(m)
		local nm=id and JY.Person[m][P.NAME]
		if nm and nm~="" then
			rep[id]=rep[id] or {}
			if not rep[id][nm] then rep[id][nm]=m cnt[id]=(cnt[id] or 0)+1 end
			key[pid]={id=id,k=rep[id][nm]}
		end
	end
	for id,c in pairs(cnt) do if c>=2 then mixed[id]=true end end
	PRIV={camp=camp,n=JY.PersonNum,key=key,mixed=mixed}
	return PRIV
end
local PM_S,PM_T=nil,{}
local function privMap()
	local s=CC.koGenSlot or ""
	if s~=PM_S then PM_S=s PM_T={} for a,b in string.gmatch(s,"(%d+):(%d+)") do PM_T[tonumber(a)]=tonumber(b) end end
	return PM_T
end
local function privKey(pid) local I=privInfo() local e=I and I.key[pid] if e and I.mixed[e.id] then return e.k end return nil end
-- 11-11 공용화: 다른 모드에서 따로 받은 칸도(공용 기록을 이 모드 번호로 푼 것) — 영걸전 · 섞이지 않은 칸의 이야기 무장도 그 칸을 봄
function koGenPrivSlot(pid)
	if (CC.koGenSlot or "")=="" then return nil end
	local k=CONFIG.koCamp and privKey(pid)
	local t=privMap()
	return (k and t[k]) or t[slotMain(pid)] or nil
end
function koGenPrivAll() return privMap() end
local function slotsFile() return CONFIG.Save.."genedit/slots.txt" end
koOn("title",function()
	if CONFIG.koCamp and (CC.koGenSlot or "")=="" and not koGenShare.on() then
		local s=readAll(slotsFile())
		if s and string.find(s,"%d+:%d+") then CC.koGenSlot=string.gsub(s,"%s","") if rawget(_G,"koSave") then pcall(koSave) end end
	end
	return nil
end)
local FORCE_SP=nil
-- 11-08 (사용자 「얼굴도 따로」): 이름 다른 무장끼리 같은 얼굴 번호를 쓰면(원소전 손책 · 국의 1128, 무제전 위연 · 장홍 1007, 영걸전 양수 · 주령 1043 …)
--  얼굴을 넣을 때 그 무장(같은 이름 · 같은 얼굴인 사본까지)만 새 얼굴 칸(hdgrp 20000 이상)을 받음. 기록의 얼굴 번호는 그대로 두고(이야기는 시작 ·
--  불러오기마다 PERSON 표로 다시 씀) 읽을 때 바꿔 보임: GetDataFromStruct 감싸기, CC.koGenFace ",\130\095\133\113\130\087\134\113:\131\081\134\071 \140\118\134\094:\134\068 \140\118\134\094,"(모드별) +
--  세이브 폴더 genedit/faces.txt. 「초기화」하면 짝을 빼고 CC.koGenFaceOld ",\134\068 \140\118\134\094:\131\081\134\071 \140\118\134\094," 로 남김(그 번호가 저장된 사본도 원래 얼굴로).
local FC={}
FC.FACE_PRIV_MIN=20000
if type(koAddon)=="table" and koAddon.saveKeys then
	koAddon.saveKeys[#koAddon.saveKeys+1]={key="koGenFace",default=""}
	koAddon.saveKeys[#koAddon.saveKeys+1]={key="koGenFaceOld",default=""}
end
FC.FM_S,FC.FM_T,FC.FO_S,FC.FO_T=nil,{},nil,{}
function FC.faceMap()
	local s=CC.koGenFace or ""
	if s~=FC.FM_S then FC.FM_S=s FC.FM_T={} for r,o,v in string.gmatch(s,"(%d+):(%d+):(%d+)") do o=tonumber(o) FC.FM_T[o]=FC.FM_T[o] or {} table.insert(FC.FM_T[o],{rep=tonumber(r),priv=tonumber(v)}) end end
	return FC.FM_T
end
function FC.faceOld()
	local s=CC.koGenFaceOld or ""
	if s~=FC.FO_S then FC.FO_S=s FC.FO_T={} for v,o in string.gmatch(s,"(%d+):(%d+)") do FC.FO_T[tonumber(v)]=tonumber(o) end end
	return FC.FO_T
end
FC.rawGDS=GetDataFromStruct
do
	local FK,NK,R=P.FACE,P.NAME,FC.rawGDS
	function GetDataFromStruct(data,offset,t_struct,key)
		local v=R(data,offset,t_struct,key)
		if key==FK and t_struct==CC.Person_S and data==JY.Data_Person then
			if (CC.koGenFace or "")~="" then
				local L=FC.faceMap()[v]
				if L then
					local nm=R(data,offset,t_struct,NK)
					for _,e in ipairs(L) do if R(data,e.rep*CC.PersonSize,t_struct,NK)==nm then return e.priv end end
				end
			end
			if (CC.koGenFaceOld or "")~="" then local x=FC.faceOld()[v] if x then return x end end
		end
		return v
	end
end
function FC.rawFace(q) return FC.rawGDS(JY.Data_Person,q*CC.PersonSize,CC.Person_S,P.FACE) end
function FC.rawName(q) return FC.rawGDS(JY.Data_Person,q*CC.PersonSize,CC.Person_S,P.NAME) end
function FC.facePriv(pid) local v=JY.Person[pid][P.FACE] return v>=FC.FACE_PRIV_MIN and v~=FC.rawFace(pid) and v or nil end
-- 얼굴 번호 f 를 이름 다른 사람이 같이 쓰나 (지금 모드의 기록 1~끝), 이 사람과 같은 이름 · 같은 얼굴의 맨 앞 번호
function FC.faceMixed(pid)
	local f=FC.rawFace(pid) local nm=FC.rawName(pid)
	if not f or f<=0 or nm=="" then return false end
	local other,rep=false,nil
	for q=1,(JY.PersonNum or 1)-1 do
		if FC.rawFace(q)==f then local n=FC.rawName(q) if n~="" then if n~=nm then other=true elseif not rep then rep=q end end end
	end
	return other,rep or pid
end
function FC.slotsFace() return CONFIG.Save.."genedit/faces.txt" end
function FC.faceSave()
	if rawget(_G,"koSave") then pcall(koSave) end
	mkdir(string.sub(CONFIG.Save.."genedit/",1,-2)) writeAll(FC.slotsFace(),(CC.koGenFace or "").."\n"..(CC.koGenFaceOld or "").."\n")
end
koOn("title",function()
	if (CC.koGenFace or "")=="" and (CC.koGenFaceOld or "")=="" and not koGenShare.on() then
		local s=readAll(FC.slotsFace())
		if s then local a,b=string.match(s,"^([^\r\n]*)\r?\n?([^\r\n]*)")
			if (a or "")~="" or (b or "")~="" then CC.koGenFace=a or "" CC.koGenFaceOld=b or "" if rawget(_G,"koSave") then pcall(koSave) end end end
	end
	return nil
end)
FC.FORCE_FACE=nil
function FC.faceOf(pid) return FC.FORCE_FACE or JY.Person[pid][P.FACE] end
-- 새 얼굴 칸 번호 (넣기가 끝나면 faceMapAdd)
function FC.faceNext()
	local n=math.floor(#(readAll(CONFIG.DataPath.."hdgrp.idx") or "")/4)
	n=math.max(n,FC.FACE_PRIV_MIN)
	for _,L in pairs(FC.faceMap()) do for _,e in ipairs(L) do n=math.max(n,e.priv+1) end end
	for v,_ in pairs(FC.faceOld()) do n=math.max(n,v+1) end
	return n
end
local function SP(pid)
	if FORCE_SP then return FORCE_SP end
	local k=CONFIG.koCamp and privKey(pid)
	local own=privMap()[slotMain(pid)]   -- 11-11 공용화: 다른 모드에서 따로 받은 칸
	if k then return privMap()[k] or own or -pid end   -- 아직 따로 받기 전 = 없는 칸 (읽기만, 넣기 전에 privAlloc)
	if own then return own end
	return SPbase(pid)
end
local function privAlloc(pid)
	local k=CONFIG.koCamp and privKey(pid)
	if not k then return true end
	local t=privMap()
	if t[k] or t[slotMain(pid)] then return true end
	local n=math.floor(#(readAll(CONFIG.DataPath.."wmap.idx") or "")/4)
	if rawget(_G,"koUniqueBz") then for key,v in pairs(koUniqueBz) do if type(key)=="number" then for _,b in pairs(v) do n=math.max(n,b+50) end end end end
	for _,v in pairs(t) do n=math.max(n,20000+(v+1)*50) end
	local id=math.max(PRIV_MIN,math.ceil((n-20000)/50))
	if 20000+id*50+50>1000000 then msg({"\130\066\132\101 \129\118\136\069 \135\066\129\071 \129\094\131\068 \132\077\129\075\129\076\129\077"}) return false end
	local s=CC.koGenSlot or "" if s=="" then s="," end
	CC.koGenSlot=s..k..":"..id..","
	if rawget(_G,"koSave") then pcall(koSave) end
	mkdir(string.sub(CONFIG.Save.."genedit/",1,-2)) writeAll(slotsFile(),CC.koGenSlot)
	return true
end
-- 고치기 전에 섞인 칸(빌린 영걸전 번호) 자체에 넣은 그림의 표시 ("w" / "c" / 병종 번호)
local function legacyTags(pid,k)
	if k=="face" then   -- 11-08: 자기 얼굴 칸을 받기 전에 같이 쓰던 얼굴 번호에 넣은 그림
		local raw=FC.rawFace(pid)
		if FC.facePriv(pid) and geHas("f"..raw) then return {"f"} end
		return {}
	end
	if not (CONFIG.koCamp and privKey(pid)) then return {} end
	local g=SPbase(pid) local L={}
	if k=="war" then
		if geHas("w"..g) then L[#L+1]="w" end
		for bz in string.gmatch(CC.koGenEdit or "",",v"..g.."_(%d+)") do L[#L+1]=tonumber(bz) end
		for bz in string.gmatch(CC.koGenEdit or "","^v"..g.."_(%d+)") do L[#L+1]=tonumber(bz) end
	elseif k=="city" then if geHas("c"..g) then L[#L+1]="c" end end
	return L
end
local function geT(pid) local s=SP(pid) return {face=FC.faceOf(pid),war=20000+s*50,city=200+(300+s)*4} end
local function geTag(k,pid) if k=="face" then return "f"..FC.faceOf(pid) end return ((k=="war") and "w" or "c")..SP(pid) end
local function geBase(k) return dataPath((k=="face" and "hdgrp") or (k=="war" and "wmap") or "smap") end
local function geFile(k,pid) return CONFIG.CurrentPath..GE_DIR.."orig/"..geTag(k,pid)..".bin" end
-- 성삼국 조형 병종 맞춤에서 빼기 / 되돌리기 (spriteclass 의 koSpriteKind)
local KSAVE={}
local function kindOff(pid) local K=rawget(_G,"koSpriteKind") if K and K[pid] then KSAVE[pid]=K[pid] K[pid]=nil end rawset(_G,"koUniqueKey",nil) end
local function kindBack(pid) local K=rawget(_G,"koSpriteKind") if K and KSAVE[pid] then K[pid]=KSAVE[pid] KSAVE[pid]=nil end rawset(_G,"koUniqueKey",nil) end
koOn("title",function() for pid in string.gmatch(CC.koGenEdit or "","w(%d+)") do kindOff(tonumber(pid)) end for pid in string.gmatch(CC.koGenEdit or "","v(%d+)_") do kindOff(tonumber(pid)) end return nil end)
-- unique.lua 의 LIST / CITY 칸 다시 쓰기 (있던 순서 그대로, 빠진 것 지우고 새 것은 끝에. 421 이상은 파일에 있던 것만)
local function listWrite()
	local path=CONFIG.ScriptPath.."addon/unique.lua"
	local s=readAll(path) if not s then return false end
	local function block(tbl,b,e)
		local i1=string.find(s,b,1,true) local i2=string.find(s,e,1,true)
		if not (i1 and i2 and i2>i1) then return false end
		local mid=string.sub(s,i1+#b,i2-1)
		local nl=string.find(mid,"\r\n",1,true) and "\r\n" or "\n"
		local seen,out={},{}
		for x in string.gmatch(mid,"%[(%d+)%]=true") do local pid=tonumber(x) if tbl[pid] and not seen[pid] then seen[pid]=true out[#out+1]="["..pid.."]=true," end end
		local add={} for pid,v in pairs(tbl) do if v and not seen[pid] and pid<=420 then add[#add+1]=pid end end
		table.sort(add)
		for _,pid in ipairs(add) do out[#out+1]="["..pid.."]=true," end
		s=string.sub(s,1,i1+#b-1)..nl..table.concat(out,nl)..((#out>0) and nl or "")..string.sub(s,i2)
		return true
	end
	if not (block(koUniqueWar,"--LIST BEGIN","--LIST END") and block(koUniqueCity,"--CITY BEGIN","--CITY END")) then return false end
	return writeAll(path,s)
end
local function geBackup(k,pid)   -- 처음 바꿀 때만 지금 그림을 보관
	local file=geFile(k,pid)
	if exists(file) then return true end
	local cells=grpGet(geBase(k),geT(pid)[k],GE_N[k])
	if not cells then return false end
	local was=(k=="war" and koUniqueWar[SP(pid)]) or (k=="city" and koUniqueCity[SP(pid)]) or false
	mkdir(CONFIG.CurrentPath..GE_DIR.."orig")
	return writeAll(file,packCells(was,cells))
end
local function geRestore(k,pid)
	local was,cells=unpackCells(readAll(geFile(k,pid)))
	if cells then
		local ch={} local b=geT(pid)[k]
		for i,c in ipairs(cells) do ch[b+i-1]=c end
		grpPut(geBase(k),ch)
	end
	if k=="war" then if cells and not was then koUniqueWar[SP(pid)]=nil end kindBack(SP(pid)) listWrite()
	elseif k=="city" then if cells and not was then koUniqueCity[SP(pid)]=nil end listWrite() end
	os.remove(geFile(k,pid))
	geSet(geTag(k,pid),false)
	if k=="face" and not FC.FORCE_FACE then   -- 11-08: 자기 얼굴 칸이면 짝을 빼고 옛 번호 → 원래 얼굴로 남김
		local v=FC.facePriv(pid)
		if v then
			local raw=FC.rawFace(pid)
			local s=CC.koGenFace or ""
			s=string.gsub(s,",%d+:%d+:"..v..",",",")
			if s=="," then s="" end
			CC.koGenFace=s
			local o=CC.koGenFaceOld or "" if o=="" then o="," end
			CC.koGenFaceOld=o..v..":"..raw..","
			FC.faceSave()
		end
	end
	reload({[k]=true})
end
local function gePut(k,pid)
	if k~="face" and not privAlloc(pid) then return nil end
	local newFace=nil
	if k=="face" and not FC.facePriv(pid) then
		local mixed,rep=FC.faceMixed(pid)
		if mixed then newFace={rep=rep,raw=FC.rawFace(pid),n=FC.faceNext()} FC.FORCE_FACE=newFace.n end
	end
	local dir=CONFIG.CurrentPath..GE_DIR.."work/"
	local ok,r=pcall(putFlow,k,{"genedit","genedit/work","genedit/orig"},dir,geT(pid),
		function(prog) prog(0.03,"\131\081\134\071 \131\091\130\079 \131\115\129\101\129\097\130\098 \130\101") return geBackup(k,pid) end,
		function(got,prog)
			prog(0.95,"\131\099\133\108\129\102 \131\076\130\098 \130\101")
			if k=="war" then koUniqueWar[SP(pid)]=true kindOff(SP(pid)) listWrite()
			elseif k=="city" then koUniqueCity[SP(pid)]=true listWrite() end
			geSet(geTag(k,pid),true)
			if newFace then
				local s=CC.koGenFace or "" if s=="" then s="," end
				CC.koGenFace=s..newFace.rep..":"..newFace.raw..":"..newFace.n..","
				FC.faceSave()
			end
		end)
	FC.FORCE_FACE=nil
	if not ok then error(r,0) end
	return r
end
-- ---- 10-13 (사용자 "\130\126\129\084\138\090\132\083 \131\076\132\111\136\089 \129\118\136\069\129\083 \131\097\129\113\132\075\134\076 \129\064\129\065\131\080 \136\108\132\076\129\071\130\098 \129\118\136\069\139\110\134\123 \130\112\133\120\132\083 \131\118\130\065\129\097\131\100 \134\069\131\071\131\087 \131\085\131\086\131\071"):
--  「전투 조형 넣기」 = 병종마다 지금 이 장수에게 보이는 전투 조형(움직이는 그림) 격자. 칸을 누르면 그 병종 그림만 넣기 · 원래대로.
--  같은 그림을 쓰던 병종이 있으면 같이 바꿀지 물음(한 세트를 같이 씀). 「공통」 = 병종 그림이 없는 모든 병종(기존 고유 조형).
--  unique.lua koUniqueBz[번호][병종] = wmap 첫 칸(50칸), koUniqueBz.free = 아무 병종도 안 쓰는 세트(다시 씀).
--  새 세트는 wmap 끝에 붙임(1,000,000 칸까지 — 65535 를 넘는 번호는 unique.lua 가 장수 기록 옆에 따로 둠). 표시 = CC.koGenEdit 의 "v<\130\087\134\113>_<\130\126\129\084>". 원작에 없던 칸이라 보관할 원래 그림이 없음.
local BZ_LIST={1,2,3,23,24,25,4,5,6,7,8,9,22,20,17,10,11,12,15,27,28,14,13,16,26,19,21}
local SPRK="\213\189\182\183\182\175\215\247"-- 战斗形象
local function bzName(bz) local b=JY.Bingzhong[bz] return (b and b["\195\251\179\198"]) or tostring(bz) end
local function bzTag(pid,bz) return "v"..SP(pid).."_"..bz end
local function famAny(pid) return string.find(CC.koGenEdit or "",",v"..SP(pid).."_",1,true)~=nil end
local function bzOn(pid,bz) local t=rawget(_G,"koUniqueBz") and koUniqueBz[SP(pid)] return t~=nil and t[bz]~=nil end
local function bzWrite()
	local path=CONFIG.ScriptPath.."addon/unique.lua"
	local s=readAll(path) if not s then return false end
	local b,e="--BZ BEGIN","--BZ END"
	local i1=string.find(s,b,1,true) local i2=string.find(s,e,1,true)
	if not (i1 and i2 and i2>i1) then return false end
	local nl=string.find(s,"\r\n",1,true) and "\r\n" or "\n"
	local out={}
	if koUniqueBz.free and #koUniqueBz.free>0 then out[#out+1]="free={"..table.concat(koUniqueBz.free,",").."}," end
	local pids={} for pid,_ in pairs(koUniqueBz) do if type(pid)=="number" then pids[#pids+1]=pid end end table.sort(pids)
	for _,pid in ipairs(pids) do
		local t,ks,parts=koUniqueBz[pid],{},{}
		for bz,_ in pairs(t) do ks[#ks+1]=bz end table.sort(ks)
		for _,bz in ipairs(ks) do parts[#parts+1]="["..bz.."]="..t[bz] end
		if #parts>0 then out[#out+1]="["..pid.."]={"..table.concat(parts,",").."}," end
	end
	s=string.sub(s,1,i1+#b-1)..nl..table.concat(out,nl)..((#out>0) and nl or "")..string.sub(s,i2)
	return writeAll(path,s)
end
local function bzAlloc()
	local free=koUniqueBz.free
	if free and #free>0 then return table.remove(free,1),true end
	local n=math.floor(#(readAll(geBase("war")..".idx") or "")/4)
	for k,t in pairs(koUniqueBz) do for _,v in pairs(t) do n=math.max(n,v+50) end end
	for _,v in pairs(koGenPrivAll()) do n=math.max(n,20000+(v+1)*50) end   -- 11-08: 따로 받은 조형 칸 뒤로
	if n+50>1000000 then return nil end   -- 10-13: past 65535 is fine (unique.lua keeps big sprite numbers beside the 2-byte record field; engine tried at 600000)
	return n,false
end
local function bzRelease(base)   -- a set nobody's class uses any more goes to the free list
	for k,t in pairs(koUniqueBz) do if type(k)=="number" then for _,v in pairs(t) do if v==base then return end end end end
	koUniqueBz.free=koUniqueBz.free or {}
	table.insert(koUniqueBz.free,base)
end
-- the battle sprite this person shows as class bz (GetPic with the class lent for a moment)
local function picAs(pid,bz)
	local p=JY.Person[pid]
	local ob,os=p[P.BZ],p[SPRK]
	p[P.BZ]=bz
	local ok,r=pcall(GetPic,pid,false,true)
	p[P.BZ]=ob p[SPRK]=os
	return ok and r or 0
end
-- put one picked set for the classes in list (base = a set they share already: written over in place)
local function bzPut(pid,list,base)
	if not rawget(_G,"koUniqueBz") then msg({"\131\100\130\071 \129\118\136\069 \140\105\133\119\134\091(unique)\129\071 \140\077\136\107 \132\079\129\075\129\076\129\077"}) return nil end
	if not privAlloc(pid) then return nil end
	local fromFree=false
	if not base then base,fromFree=bzAlloc() end
	if not base then msg({"\130\066\132\101 \129\118\136\069 \135\066\129\071 \129\094\131\068 \132\077\129\075\129\076\129\077","\130\126\129\084 \129\118\136\069\129\083 \132\108 \134\112\129\083 \129\113 \130\097\129\075\129\076\129\077"}) return nil end
	local dir=CONFIG.CurrentPath..GE_DIR.."work/"
	local got=putFlow("war",{"genedit","genedit/work","genedit/orig"},dir,{war=base},
		function(prog) return true end,
		function(got,prog)
			prog(0.95,"\131\099\133\108\129\102 \131\076\130\098 \130\101")
			local sp=SP(pid)
			koUniqueBz[sp]=koUniqueBz[sp] or {}
			local olds={}
			for _,bz in ipairs(list) do local old=koUniqueBz[sp][bz] if old and old~=base then olds[#olds+1]=old end koUniqueBz[sp][bz]=base geSet(bzTag(pid,bz),true) end
			for _,o in ipairs(olds) do bzRelease(o) end
			bzWrite() kindOff(sp)
		end)
	if not got and fromFree then table.insert(koUniqueBz.free,1,base) end
	return got
end
local function bzRestore(pid,bz)
	local t=koUniqueBz[SP(pid)]
	local old=t and t[bz]
	if t then t[bz]=nil if next(t)==nil then koUniqueBz[SP(pid)]=nil end end
	if old then bzRelease(old) end
	bzWrite()
	geSet(bzTag(pid,bz),false)
	if not (famAny(pid) or geHas(geTag("war",pid))) then kindBack(SP(pid)) end
	reload({war=true})
end
-- the 전투 line of the edit screen
local function famLine(pid)
	local L={}
	if geHas(geTag("war",pid)) then L[#L+1]="\130\074\132\119" end
	local n=0 for _,bz in ipairs(BZ_LIST) do if bzOn(pid,bz) then n=n+1 end end
	if n>0 then L[#L+1]="\130\126\129\084 "..n.."\134\075" end
	return L
end
-- the grid: every class with the sprite this person shows as it (animated), click = put / back for that class
local function warGrid(pid,commonFlow,ops)
	ops=ops or {}
	local isOn=ops.isOn or function(bz) return bzOn(pid,bz) end
	local commonOn=ops.commonOn or function() return geHas(geTag("war",pid)) end
	local doPut=ops.put or function(list,keep) return bzPut(pid,list,keep) end
	local doRestore=ops.restore or function(bz) bzRestore(pid,bz) end
	local ox,oy=oxy()
	local COLS,CW,CH=9,82,104
	while true do
		local p=JY.Person[pid]
		local cur=p[P.BZ]
		local base={} for _,bz in ipairs(BZ_LIST) do base[bz]=picAs(pid,bz) end
		local btns={}
		for i,bz in ipairs(BZ_LIST) do
			local c,r=(i-1)%COLS,math.floor((i-1)/COLS)
			btns[i]={x=ox+16+c*CW,y=oy+64+r*(CH+8),w=CW-6,h=CH,s="",plain=true,bz=bz}
		end
		btns[#btns+1]={x=ox+16,y=oy+432,w=240,h=28,s=commonOn() and "\130\074\132\119 (\130\090\136\101 \130\126\129\084) \161\164 \131\085\139\100" or "\130\074\132\119 (\130\090\136\101 \130\126\129\084)",common=true}
		btns[#btns+1]={x=ox+640,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",back=true}
		local r=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+12,p[P.NAME].." \161\164 \130\066\132\101 \129\118\136\069",C_Name,24)
			ctext(ox+384,oy+42,"\130\126\129\084 \135\066\129\083 \134\117\130\106\129\065 \131\091 \130\126\129\084 \131\091\130\079\132\086 \131\085\132\114\129\076\129\077 \161\164 \131\103\140\089 = \131\085\137\091 \131\091\130\079 \161\164 \143\087 \129\071\138\075 = \130\067\131\103 \130\126\129\084",M_Silver)
			local t=math.floor(lib.GetTime()/180)
			local seq={0,1,0,1,0,1,30,31,32,33,33}
			local fr=seq[t%#seq+1]
			for i,bz in ipairs(BZ_LIST) do
				local b=btns[i]
				local on=isOn(bz)
				koRecordClassicFrame(b.x,b.y,b.w,b.h)
				local col=(on and C_Name) or ((bz==cur) and M_White) or M_Gray
				lib.DrawRect(b.x,b.y,b.x+b.w,b.y,col) lib.DrawRect(b.x,b.y+b.h,b.x+b.w,b.y+b.h,col) lib.DrawRect(b.x,b.y,b.x,b.y+b.h,col) lib.DrawRect(b.x+b.w,b.y,b.x+b.w,b.y+b.h,col)
				if base[bz] and base[bz]>0 then
					lib.SetClip(b.x+1,b.y+1,b.x+b.w-1,b.y+80)
					lib.PicLoadCache(1,(base[bz]+fr)*2,b.x+math.floor((b.w-48)/2),b.y+14,1)
					lib.SetClip(0,0,0,0)
				end
				local nm=bzName(bz)
				DrawString(b.x+math.floor(b.w/2)-#nm*4,b.y+b.h-22,nm,col==M_Gray and M_Silver or col,16)
			end
			DrawString(ox+270,oy+438,"\130\074\132\119 = \130\126\129\084 \131\091\130\079\129\071 \130\097\130\098 \130\090\136\101 \130\126\129\084",M_Silver,16)
		end,btns)
		local b=btns[r]
		if r==0 or (b and b.back) then return end
		if b and b.common then commonFlow()
		elseif b and b.bz then
			local bz=b.bz
			local go,list,keep=true,{bz},nil
			if isOn(bz) then
				local c=ask3({bzName(bz).." \130\066\132\101 \129\118\136\069\129\083 \129\071\134\119 \131\085\135\245\129\075\129\076\129\077"},"\134\068\132\083 \131\100\130\106\131\071","\131\081\134\071\130\095\132\083","\129\108\129\109")
				if c==2 then doRestore(bz) msg({bzName(bz).." \130\066\132\101 \129\118\136\069\129\083 \131\081\134\071\130\095\132\083 \132\067\137\066\132\126\129\075\129\076\129\077"}) end
				go=(c==1)
			end
			if go then
				-- the other classes that show the same picture now: together (one shared set) or this class alone
				local same={}
				for _,b2 in ipairs(BZ_LIST) do if b2~=bz and base[b2]==base[bz] then same[#same+1]=b2 end end
				if #same>0 then
					local names={} for i=1,math.min(5,#same) do names[i]=bzName(same[i]) end
					local c=ask3({"\132\071\131\098 \131\091\130\079\129\083 \136\096\130\098 \130\126\129\084\129\071 "..#same.."\134\075 \132\079\129\075\129\076\129\077",table.concat(names,", ")..((#same>5) and " \131\107" or "")},"\132\071\129\071 \131\085\131\086\131\071","\129\071 \130\126\129\084\132\086","\129\108\129\109")
					if c==1 then for _,b2 in ipairs(same) do list[#list+1]=b2 end
						if isOn(bz) and koUniqueBz[SP(pid)] then keep=koUniqueBz[SP(pid)][bz] end   -- they share his own set already: written over in place
					elseif c~=2 then go=false end
				end
			end
			if go then doPut(list,keep) end
		end
	end
end
-- ---- 10-13 (사용자 "\131\078\129\073\131\097 \133\125\133\108\129\068 \132\071\131\098 \132\078\130\121\131\109\132\083"): 신무장의 병종별 전투 조형. 등록부 g.wb = 병종 비트(2^병종), 그림 사본은
--  newgen/NN/b<병종>/ 와 세이브 폴더 같은 자리(판 갈이로 data 가 바뀌면 시작할 때 다시 넣음, GRID.ngSync), 칸 번호는 unique.lua koUniqueBz[칸].
local function wbHas(g,bz) return math.floor((tonumber(g.wb) or 0)/2^bz)%2==1 end
local function wbSet(g,bz,on) if wbHas(g,bz)~=on then g.wb=(tonumber(g.wb) or 0)+(on and 1 or -1)*2^bz end end
local function wbCount(g) local n=0 for bz=0,45 do if wbHas(g,bz) then n=n+1 end end return n end
local function ngBzRel(id,bz) return folder(id).."b"..bz.."/" end
local WAR_IMGS={"MOV.bmp","SPC.bmp","ATK.bmp"}
GRID.war,GRID.wbHas,GRID.wbCount=warGrid,wbHas,wbCount
function GRID.ngPut(id,g,list,keep)
	if not rawget(_G,"koUniqueBz") then msg({"\131\100\130\071 \129\118\136\069 \140\105\133\119\134\091(unique)\129\071 \140\077\136\107 \132\079\129\075\129\076\129\077"}) return nil end
	local slot=NG_BASE+id
	local base,fromFree=keep,false
	if not base then base,fromFree=bzAlloc() end
	if not base then msg({"\130\066\132\101 \129\118\136\069 \135\066\129\071 \129\094\131\068 \132\077\129\075\129\076\129\077","\130\126\129\084 \129\118\136\069\129\083 \132\108 \134\112\129\083 \129\113 \130\097\129\075\129\076\129\077"}) return nil end
	local rel=ngBzRel(id,list[1])
	local dir=CONFIG.CurrentPath..rel
	local got=putFlow("war",{"newgen",string.sub(folder(id),1,-2),string.sub(rel,1,-2)},dir,{war=base},nil,function(got,prog)
		prog(0.95,"\133\102\131\097 \193\142\132\108\129\102 \130\114\132\118 \133\103\131\071\130\098 \130\101")
		koUniqueBz[slot]=koUniqueBz[slot] or {}
		local olds={}
		local sv=koNewGenSaveDir(id)
		mkdir(string.sub(sv,1,-2))
		for _,bz in ipairs(list) do
			local old=koUniqueBz[slot][bz] if old and old~=base then olds[#olds+1]=old end
			koUniqueBz[slot][bz]=base wbSet(g,bz,true)
			local d1,d2=CONFIG.CurrentPath..ngBzRel(id,bz),sv.."b"..bz.."/"
			mkdir(string.sub(d1,1,-2)) mkdir(string.sub(d2,1,-2))
			for _,n in ipairs(WAR_IMGS) do local s=readAll(dir..n) if s then if d1~=dir then writeAll(d1..n,s) end writeAll(d2..n,s) end end
		end
		for _,o in ipairs(olds) do bzRelease(o) end
		bzWrite()
	end)
	if not got and fromFree then table.insert(koUniqueBz.free,1,base) end
	return got
end
function GRID.ngRestore(id,g,bz)
	local slot=NG_BASE+id
	local t=rawget(_G,"koUniqueBz") and koUniqueBz[slot]
	local old=t and t[bz]
	if t then t[bz]=nil if next(t)==nil then koUniqueBz[slot]=nil end end
	if old then bzRelease(old) end
	wbSet(g,bz,false)
	bzWrite()
	reload({war=true})
end
function GRID.ngClearAll(id,g)
	for bz=0,45 do if wbHas(g,bz) then GRID.ngRestore(id,g,bz) end end
	local slot=NG_BASE+id
	if rawget(_G,"koUniqueBz") and koUniqueBz[slot] then   -- (a set the 등록부 no longer knows)
		for bz,v in pairs(koUniqueBz[slot]) do bzRelease(v) end
		koUniqueBz[slot]=nil bzWrite() reload({war=true})
	end
end
-- at the start: every class set the 등록부 has, put back from the save-folder copy when its cells are missing / empty
function GRID.ngSync(L)
	if not rawget(_G,"koUniqueBz") then return end
	local changed=false
	for id,g in pairs(L) do
		local slot=NG_BASE+id
		for bz=0,45 do if wbHas(g,bz) then
			local t=koUniqueBz[slot]
			local b=t and t[bz]
			if not b or grpLen(dataPath("wmap"),b)==0 then
				local src=koNewGenSaveDir(id).."b"..bz.."/"
				if not exists(src.."MOV.bmp") then src=CONFIG.CurrentPath..ngBzRel(id,bz) end
				local base=b or bzAlloc()
				if base then
					local got=importTo({war=base},src,{war=true})
					if got and got.war then koUniqueBz[slot]=koUniqueBz[slot] or {} koUniqueBz[slot][bz]=base changed=true end
				end
			end
		end end
	end
	if changed then bzWrite() end
end
local function faceShare(pid)
	local f=JY.Person[pid][P.FACE] local L={}
	local mine=FC.facePriv(pid) or FC.faceMixed(pid)   -- 11-08: 이름 다른 사람과 같이 쓰면 이 무장(같은 이름 사본)만 바뀜
	local nm=JY.Person[pid][P.NAME]
	for i=1,math.min(420,(JY.PersonNum or 1)-1) do local q=JY.Person[i]
		if i~=pid and q and q[P.FACE]==f and q[P.NAME]~="" and not (mine and q[P.NAME]~=nm) then L[#L+1]=q[P.NAME] end end
	return L
end
local function shareText(L)
	local t={} for i=1,math.min(4,#L) do t[i]=L[i] end
	return table.concat(t,", ")..((#L>4) and (" \131\107 "..(#L-4).."\130\088") or "")
end
local function geAnim(pid,x,y)
	local t=math.floor(lib.GetTime()/180)
	local base=GetPic(pid,false,true) or 0
	local seq={0,1,0,1,0,1,30,31,32,33,33}
	lib.PicLoadCache(1,(base+seq[t%#seq+1])*2,x,y,1)
	local sp=SP(pid)
	local fig=(sp>0 and koUniqueCity[sp]) and (300+sp) or nil
	if not fig and sp<0 then local b=SPbase(pid) fig=koUniqueCity[b] and (300+b) or nil end   -- 따로 받기 전 = 빌린 칸 그대로
	fig=fig or JY.Person[pid][P.FIG]
	local fr=({0,1,0,2})[t%4+1]
	lib.SetClip(x+70,y,x+70+48,y+64)
	lib.PicLoadCache(5,(200+fig*4+1)*2,x+70,y-fr*64,1)
	lib.SetClip(0,0,0,0)
end
-- ---- 10-15 (사용자) 장수편집 능력치: ko_settings 의 CC.koGenStat ",\130\087\134\113:\129\073\131\125:\130\067\131\125:\132\119\132\120,..." (모든 저장 기록 공용).
--  LoadRecord 뒤에(위 감싸기) 편집 차이를 더하고 ReSetAttrib (아래 koGenStatApply 설명). 원래 값 = 편집 안 한 값(GS_ORIG). 원래 값과 같아지면 목록에서 뺌.
if type(koAddon)=="table" and koAddon.saveKeys then koAddon.saveKeys[#koAddon.saveKeys+1]={key="koGenStat",default=""} end
local SF={wl=P.WL,zl=P.ZL,ts=P.TS}
local GS_ORIG={}
local function gsList()
	local L={}
	for pid,a,b,c in string.gmatch(CC.koGenStat or "","(%d+):(%d+):(%d+):(%d+)") do
		L[tonumber(pid)]={wl=tonumber(a),zl=tonumber(b),ts=tonumber(c)} end
	return L
end
local function gsSave(L)
	local t={}
	for pid=1,JY.PersonNum or 1000 do local s=L[pid] if s then t[#t+1]=pid..":"..s.wl..":"..s.zl..":"..s.ts end end
	CC.koGenStat=(#t>0) and (","..table.concat(t,",")..",") or ""
	if rawget(_G,"koSave") then pcall(koSave) end
end
-- 10-19 (제보 「씨앗 먹은 수치가 저장·불러오기 하면 초기화」): 무력·지력·통솔은 실은 세이브에 들어간다(LoadRecord 가 넷째를 true 로 바꿈).
--  예전엔 불러올 때마다 편집값으로 통째 덮어써서 씨앗·훈련으로 오른 몫이 날아갔다. 이제 편집은 「처음 값을 바꾸는 것」:
--  최종 = 편집값 + (편집 안 한 값 - newgame 값). 더해 둔 차이(편집값 - newgame 값)는 그 무장 기록의 勇猛·冷静 세이브 칸
--  (오프셋 60·62, 엔진은 늘 newgame 에서 읽음 — achieve 의 暗器·一击 와 같은 수법)에 적어 두고, 다음에 불러올 때 그만큼 빼서
--  편집 안 한 값을 되찾는다. 60 = GS_TAG*256 + 무력 차이+128, 62 = (지력 차이+128)*256 + 통솔 차이+128. 편집을 지우면 차이도 뺀다.
local GS_TAG,GS_O1,GS_O2=0x5A,60,62
local function gsMark(o)
	local m1=Byte.getu16(JY.Data_Person,o+GS_O1)
	if math.floor(m1/256)~=GS_TAG then return nil end
	local m2=Byte.getu16(JY.Data_Person,o+GS_O2)
	return {wl=m1%256-128,zl=math.floor(m2/256)-128,ts=m2%256-128}
end
local function gsSetMark(o,d)
	if d then
		Byte.setu16(JY.Data_Person,o+GS_O1,GS_TAG*256+d.wl+128)
		Byte.setu16(JY.Data_Person,o+GS_O2,(d.zl+128)*256+d.ts+128)
	else
		for _,k in ipairs({GS_O1,GS_O2}) do Byte.set16(JY.Data_Person,o+k,Byte.get16(JY.Data_Person_Base,o+k)) end
	end
end
function koGenStatApply()
	if not (JY and JY.Person and JY.Data_Person and JY.Data_Person_Base) then return end
	local L=gsList()
	local N=JY.PersonNum or 0
	local hi=STAT_MAX
	pcall(function() hi=math.max(STAT_MAX,CC.koNG.cap()) end)
	local pids={}
	for pid=1,math.min(420,N-1) do pids[pid]=true end   -- 장수편집 = 1~420; 편집을 지운 무장의 차이도 빼야 해서 다 본다
	for pid in pairs(L) do if pid>=1 and pid<N then pids[pid]=true end end
	for pid in pairs(pids) do
		local s,o=L[pid],pid*CC.PersonSize
		local d=gsMark(o)
		if s or d then
			local p=JY.Person[pid]
			local nat,base={},{}
			for f,k in pairs(SF) do base[f]=GetDataFromStruct(JY.Data_Person_Base,o,CC.Person_S,k) end
			if not d then   -- 표시 없는 옛 세이브: 예전 방식으로 편집값이 덮여 있던 것(값 = 편집값 + 그 뒤 성장)인지, 안 덮인 것(newgame 값 + 성장)인지.
				-- 성장은 음수가 아니므로 둘 중 성장이 다 0 이상이고 더 작은 쪽으로 본다
				local ok1,ok2,g1,g2=true,true,0,0
				for f,k in pairs(SF) do
					local a,b=p[k]-s[f],p[k]-base[f]
					if a<0 then ok1=false end if b<0 then ok2=false end
					g1=g1+a g2=g2+b
				end
				local applied=ok1 and (not ok2 or g1<=g2)
				d={}
				for f in pairs(SF) do d[f]=applied and (s[f]-base[f]) or 0 end
			end
			for f,k in pairs(SF) do nat[f]=p[k]-d[f] end
			GS_ORIG[pid]=nat
			if s then
				local nd={}
				for f,k in pairs(SF) do
					local v=limitX(s[f]+nat[f]-base[f],STAT_MIN,math.max(hi,s[f]))
					p[k]=v nd[f]=limitX(v-nat[f],-128,127) p[k]=nat[f]+nd[f]
				end
				gsSetMark(o,nd)
			else
				for f,k in pairs(SF) do p[k]=nat[f] end
				gsSetMark(o,nil)
			end
			pcall(ReSetAttrib,pid,false)
		end
	end
end
local function gsGet(pid,f) return JY.Person[pid][SF[f]] end
local function gsSet(pid,f,v)
	local p=JY.Person[pid]
	if not GS_ORIG[pid] then GS_ORIG[pid]={wl=p[P.WL],zl=p[P.ZL],ts=p[P.TS]} end
	p[SF[f]]=v
end
local function gsChanged(pid)
	local o,p=GS_ORIG[pid],JY.Person[pid]
	return o~=nil and (o.wl~=p[P.WL] or o.zl~=p[P.ZL] or o.ts~=p[P.TS])
end
-- 11-06: 번호 · 이름이 같아도 인물을 확정 못 한 칸: 다른 이야기와 능력치를 주고받지 않음 (문서/이야기 같은 이름 칸 대조)
local STAT_SKIP={wuje={[274]=true},sunjian={[24]=true,[108]=true,[222]=true,[232]=true}}-- 손견전 마충: 182 = 촉(곽준 · 강유와 함께 적), 232 = 오(강하, 소비의 심복)
-- 11-06: 이야기 전체에서 안 쓰는 칸: 장수편집 목록에 안 나옴 (번호는 대본 자료가 고정이라 칸 자체는 둠)
local NOT_IN_GAME={wuje={[60]=true,[61]=true,[111]=true,[159]=true,[184]=true,[274]=true},sunjian={[222]=true,[24]=true,[107]=true,[108]=true,[129]=true,[135]=true,[202]=true,[225]=true,[241]=true},yuanshao={[250]=true}}
local function gsExtras(pid)
	local t={}
	for e,m in pairs(SAME_SLOT[CONFIG.koCamp or ""] or {}) do if m==pid then t[#t+1]=e end end
	return t
end
local function gsCommit(pid)
	local L=gsList()
	local p=JY.Person[pid]
	local now=gsChanged(pid) and {wl=p[P.WL],zl=p[P.ZL],ts=p[P.TS]} or nil
	local was=L[pid]
	if (was==nil)~=(now==nil) or (now and (was.wl~=now.wl or was.zl~=now.zl or was.ts~=now.ts)) then
		L[pid]=now
		for _,e in ipairs(gsExtras(pid)) do L[e]=now end
		gsSave(L) GE_CHANGED.stat=true
	end
end

-- 6.0 (11-02, 사용자 「장수편집 때 다른 모드에도 있으면 같이 적용하겠냐고 묻고 예면 같이」): 그림을 바꾸거나 되돌린 뒤, 같은 무장
-- (= 같은 영걸전 번호 SP 의 조형 · 같은 얼굴 칸을 쓰는 사람)이 다른 이야기에도 있으면 묻고, 예면 그 이야기에도 같은 편집을 적음:
-- 이 이야기의 사본(세이브 폴더 genedit/<표시>.kgs)을 그 이야기 세이브 폴더로 복사하고 그 이야기 기록(ko_settings · recsave 사본)의
-- koGenEdit 에 표시를 넣음(되돌리기는 빼고 사본을 지움). 그림은 그 이야기를 켤 때 gesync 칸 주인 맞추기가 넣음.
-- 11-06 (사용자 「장수편집 자체를 묻게」): 능력치도 함께. 그 이야기의 같은 무장 칸(storyPids) koGenStat 에 같은 값, 되돌리면 뺌 (GE_CHANGED.stat)
-- 이야기마다 그 이야기 무장이 쓰는 영걸전 번호 = script/camp/<id>/wuje_campaign.lua 의 PERSON 표 둘째 칸(koWujeIdentity 와 같음)
local STORY_ORDER={"yeonggeol","wuje","sunjian","yuanshao"}-- 11-03 메인 화면 칸 순서와 같게
local STORY_NAME={yeonggeol="\129\126\130\064\130\066",yuanshao="\131\081\129\109\130\066",sunjian="\135\089\134\084\130\066",wuje="\129\073\129\100\130\066"}
local NATIVES={}
local function storyHas(m,n)
	if m=="yeonggeol" then return n>=1 and n<=420 end
	if not NATIVES[m] then
		local t,vis={},{}
		local body=string.match(readAll(CONFIG.ScriptPath.."camp/"..m.."/wuje_campaign.lua") or "","local PERSON=(%b{})") or ""
		for a,b in string.gmatch(body,"{(%d+),(%d+),%d+,%d+}") do vis[tonumber(a)]=tonumber(b) end
		for _,v in pairs(vis) do t[v]=true end
		NATIVES[m]=t
	end
	return NATIVES[m][n]==true
end
-- 11-08: 이야기 m 의 사람 목록 {번호, 이름, 조형 칸(영걸전 번호), 얼굴} (영걸전 = 1~420, 이야기 = PERSON 표 + 그 이야기 newgame 이름)
local ROSTER={}
local function storyRoster(m)
	if ROSTER[m] then return ROSTER[m] end
	local data=readAll(CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp") or ""
	local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	local R={}
	if #ix>=4 then
		local b1,b2,b3,b4=string.byte(ix,1,4)
		local base=b1+b2*256+b3*65536+b4*16777216
		local fo,fl=CC.Person_S[P.NAME][1],CC.Person_S[P.NAME][3]
		local fa=CC.Person_S[P.FACE][1]
		local function nm(q) local at=base+q*CC.PersonSize+fo return string.match(string.sub(data,at+1,at+fl),"^[^%z]*") or "" end
		if m=="yeonggeol" then
			for q=1,420 do local at=base+q*CC.PersonSize+fa local a,b=string.byte(data,at+1,at+2) R[#R+1]={q,nm(q),q,(a or 0)+(b or 0)*256} end
		else
			local body=string.match(readAll(CONFIG.ScriptPath.."camp/"..m.."/wuje_campaign.lua") or "","local PERSON=(%b{})") or ""
			for a,b,c in string.gmatch(body,"{(%d+),(%d+),(%d+),%d+}") do local q=tonumber(a) R[#R+1]={q,nm(q),tonumber(b),tonumber(c)} end
		end
	end
	ROSTER[m]=R
	return R
end
-- 그 이야기에서 칸(k=3) · 얼굴(k=4) v 를 쓰는 사람이 모두 이 이름일 때만 (이름 다른 사람이 같이 쓰는 칸 · 얼굴로는 같이 적용하지 않음)
local function storyOnly(m,k,v,name)
	local any=false
	for _,e in ipairs(storyRoster(m)) do if e[k]==v and e[2]~="" then if e[2]~=name then return false end any=true end end
	return any
end
local function storySave(m) if m=="yeonggeol" then return CONFIG.DataPath.."save/" end return CONFIG.DataPath.."save/"..m.."/" end
local function storyList(path,tag,on)-- a tag in or out of CC.koGenEdit of a ko_settings / ko_records file (koSetLit, jymain)
	local t=readAll(path) or ""
	local env={CC={}}
	local f=load(t,"ko","t",env) if f then pcall(f) end
	local s=env.CC.koGenEdit or "" if s=="" then s="," end
	s=string.gsub(s,","..tag..",",",")
	if on then s=s..tag.."," end
	if s=="," then s="" end
	writeAll(path,koSetLit(t,"koGenEdit",s))
end
-- the person numbers of story m that are this officer: same 영걸전 번호 n and the same name (others only borrow the sprite)
local function storyPids(m,n,name)
	local cand={}
	if m=="yeonggeol" then cand[1]=n
	else
		local body=string.match(readAll(CONFIG.ScriptPath.."camp/"..m.."/wuje_campaign.lua") or "","local PERSON=(%b{})") or ""
		for a,b in string.gmatch(body,"{(%d+),(%d+),%d+,%d+}") do if tonumber(b)==n then cand[#cand+1]=tonumber(a) end end
	end
	local data=readAll(CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp") or ""
	local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if #ix<4 then return {} end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local base=b1+b2*256+b3*65536+b4*16777216
	local fo=CC.Person_S[P.NAME][1]
	local fl=CC.Person_S[P.NAME][3]
	local t={}
	for _,q in ipairs(cand) do
		local at=base+q*CC.PersonSize+fo
		local nm=string.match(string.sub(data,at+1,at+fl),"^[^%z]*")
		if nm==name then
			if (STAT_SKIP[m] or {})[q] then t.skipped=true else t[#t+1]=q end
		end
	end
	return t
end
-- this officer's edited stats in a ko_settings / ko_records file; returns the new list text
local function storyStat(path,pids,v)
	local t=readAll(path) or ""
	local env={CC={}}
	local f=load(t,"ko","t",env) if f then pcall(f) end
	local s=env.CC.koGenStat or "" if s=="" then s="," end
	for _,q in ipairs(pids) do
		s=string.gsub(s,","..q..":%d+:%d+:%d+,",",")
		if v then s=s..q..":"..v.wl..":"..v.zl..":"..v.ts.."," end
	end
	if s=="," then s="" end
	writeAll(path,koSetLit(t,"koGenStat",s))
	return s
end
local function shareAsk(pid,auto)
	local order,ch=GE_ORDER,GE_CHANGED
	GE_ORDER,GE_CHANGED={},{}
	if koGenShare.on() then return end   -- 11-11: 장수편집은 모든 모드 공용이라 묻지 않음
	if (#order==0 and not ch.stat) or not rawget(_G,"koSetLit") then return end
	local cur=CONFIG.koCamp or "yeonggeol"
	local n,nb=SP(pid),SPbase(pid)
	local others,names,statTo,skipped={},{},{},{}
	local tagsTo={}   -- 11-08: 얼굴 = 빌린 번호로, 따로 받은 조형 칸은 이 이야기에만
	local myName=JY.Person[pid][P.NAME]
	local function tagsFor(m)   -- 11-08: 같은 이름의 무장만 쓰는 칸 · 얼굴일 때만 (손견전 손책 → 영걸전 61 국의 같은 것 막음)
		local L={}
		for _,tag in ipairs(order) do
			local f=tonumber(string.match(tag,"^f(%d+)$") or "")
			if f then if storyHas(m,nb) and storyOnly(m,4,f,myName) then L[#L+1]=tag end
			elseif n>0 and storyHas(m,n) and storyOnly(m,3,n,myName) then L[#L+1]=tag end
		end
		return L
	end
	local statOn=ch.stat and not (STAT_SKIP[cur] or {})[pid]
	for _,m in ipairs(STORY_ORDER) do
		if m~=cur and (m=="yeonggeol" or exists(CONFIG.ScriptPath.."camp/"..m.."/camp.lua")) then
			local pids=statOn and storyPids(m,nb,JY.Person[pid][P.NAME]) or {}
			if pids.skipped and #pids==0 then skipped[#skipped+1]=STORY_NAME[m] end
			local tl=tagsFor(m)
			if #tl>0 or #pids>0 then others[#others+1]=m names[#names+1]=STORY_NAME[m] statTo[m]=pids tagsTo[m]=tl end
		end
	end
	if #others==0 then return end
	if not auto and not ask({"\129\071 \129\073\131\097\131\098 "..table.concat(names," \161\164 ").."\129\102\129\068 \132\079\129\075\129\076\129\077","\131\091 \129\071\133\069\131\071\129\102\129\068 \132\071\129\071 \131\076\132\111\129\088\129\089\129\090?"},"\129\107","\129\110\129\076\129\091") then return end
	if rawget(_G,"koGenEditSync") then pcall(koGenEditSync) end-- this story's copies (genedit/<tag>.kgs) are written now
	for _,m in ipairs(others) do
		local sd=storySave(m)
		for _,tag in ipairs(tagsTo[m]) do
			local on=ch[tag]
			local dst=sd.."genedit/"..tag..".kgs"
			if on then
				local src=readAll(CONFIG.Save.."genedit/"..tag..".kgs")
				if src then mkdir(string.sub(sd.."genedit/",1,-2)) writeAll(dst,src) end
			else os.remove(dst) end
			mkdir(string.sub(sd,1,-2))
			storyList((m=="yeonggeol") and (CONFIG.CurrentPath.."ko_settings.lua") or (sd.."ko_settings.lua"),tag,on)
			if exists(sd.."ko_records.lua") then storyList(sd.."ko_records.lua",tag,on) end
		end
		if #statTo[m]>0 then
			local v=gsList()[pid]
			local pids=statTo[m]
			mkdir(string.sub(sd,1,-2))
			local list=storyStat((m=="yeonggeol") and (CONFIG.CurrentPath.."ko_settings.lua") or (sd.."ko_settings.lua"),pids,v)
			if exists(sd.."ko_records.lua") then storyStat(sd.."ko_records.lua",pids,v) end
			-- gesync restores an empty list from this copy on a story's first start, so it must follow
			if list~="" or exists(sd.."genedit/stat.txt") then mkdir(string.sub(sd.."genedit/",1,-2)) writeAll(sd.."genedit/stat.txt","KGST1\n"..list) end
		end
	end
	if auto then return names,skipped end
	local koLines={table.concat(names," \161\164 ").."\129\102\129\068 \132\071\129\071 \131\076\132\111\129\080\129\075\129\076\129\077","\131\091 \129\071\133\069\131\071\130\104 \137\097\129\065 \131\085\136\137 \131\095\132\111\129\071 \131\118\133\111\129\076\129\077"}
	if #skipped>0 then koLines[#koLines+1]=table.concat(skipped," \161\164 ").."\131\080 \131\077\131\125\132\081\130\098 \131\091 \129\071\133\069\131\071\129\102\131\087 \132\076\137\110 \131\085\143\097 \130\075\131\111\129\090" end
	msg(koLines)
end
-- (tests) tags changed as if by an edit of pid, then the 「예」 path without the dialogs; returns the stories written to
function koGenEditShareTest(pid,tags,stat) GE_ORDER,GE_CHANGED={},{} for t,on in pairs(tags) do GE_ORDER[#GE_ORDER+1]=t GE_CHANGED[t]=on end GE_CHANGED.stat=stat return shareAsk(pid,true) end
local function geEdit(pid)
	GE_ORDER,GE_CHANGED={},{}
	local ox,oy=oxy()
	local X,Y=ox+250,oy+60   -- 오른쪽 = 신무장 등록과 같은 자리 (10-15)
	local dragging=false
	local function sget(f) return gsGet(pid,f) end
	while true do
		local p=JY.Person[pid]
		local ed={face=geHas(geTag("face",pid)),war=geHas(geTag("war",pid)),city=geHas(geTag("city",pid))}
		local share=faceShare(pid)
		local btns={
			{x=ox+28,y=oy+236,w=130,h=26,s="\140\118\134\094 \134\112\131\071",k="face"},
			{x=ox+28,y=oy+268,w=130,h=26,s="\130\066\132\101 \129\118\136\069 \134\112\131\071",k="war"},
			{x=ox+28,y=oy+300,w=130,h=26,s="\131\119\129\067 \129\118\136\069 \134\112\131\071",k="city"},
			{x=ox+164,y=oy+236,w=62,h=26,s="\131\124\131\071\129\064",reset="face"},   -- 10-13 (사용자): 잘못 넣었을 때 되돌리기
			{x=ox+164,y=oy+268,w=62,h=26,s="\131\124\131\071\129\064",reset="war"},
			{x=ox+164,y=oy+300,w=62,h=26,s="\131\124\131\071\129\064",reset="city"},
			{x=ox+624,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",back=true},
			{x=X+370,y=Y+30,w=114,h=24,s="\131\077\131\125 \131\124\131\071\129\064",statreset=true}}
		statBoxes(function(t) btns[#btns+1]=t end,X,Y+90,sget)
		local function drawScr()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+14,p[P.NAME].."  ("..pid.."\130\087)",C_Name,24)
			lib.PicLoadCache(2,p[P.FACE]*2,ox+28,oy+62,1)
			geAnim(pid,ox+100,oy+70)
			local fcl=ed.face and "\131\085\137\091 \131\091\130\079" or nil
			if #legacyTags(pid,"face")>0 then fcl=(fcl and (fcl.." \161\164 ") or "").."\132\071\129\071 \136\096\138\066 \135\066" end
			DrawString(ox+28,oy+150,"\140\118\134\094: "..(fcl or "\131\081\134\071 \131\091\130\079"),fcl and C_Name or M_Silver,16)
			local fl=famLine(pid)
			if #legacyTags(pid,"war")>0 then fl[#fl+1]="\132\071\129\071 \136\096\138\066 \135\066" end
			DrawString(ox+28,oy+172,"\130\066\132\101: "..((#fl>0) and table.concat(fl," \161\164 ") or "\131\081\134\071 \131\091\130\079"),(#fl>0) and C_Name or M_Silver,16)
			local cl=ed.city and "\131\085\137\091 \131\091\130\079" or nil
			if #legacyTags(pid,"city")>0 then cl=(cl and (cl.." \161\164 ") or "").."\132\071\129\071 \136\096\138\066 \135\066" end
			DrawString(ox+28,oy+194,"\131\119\129\067: "..(cl or "\131\081\134\071 \131\091\130\079"),cl and C_Name or M_Silver,16)
			-- 10-15: 능력치 (신무장 등록과 같은 줄 · 막대 · 입력칸)
			DrawString(X,Y+4,"\129\071\138\075  "..p[P.NAME],C_Name,16)
			DrawString(X,Y+34,"\130\126\129\084  "..JY.Bingzhong[p[P.BZ]][SKN],M_White,16)
			local o=GS_ORIG[pid]
			DrawString(X,Y+64,"\131\077\131\125\132\081",M_White,16)
			statRows(X,Y+90,sget)
			if o and gsChanged(pid) then DrawString(ox+28,oy+348,"\131\081\134\071 \131\077\131\125\132\081",M_Silver,16) DrawString(ox+28,oy+372,o.wl.." / "..o.zl.." / "..o.ts,C_Name,16) end
			DrawString(X,Y+190,"\131\091\130\079 \130\116\131\064 \130\111\131\095",C_Name,16)
			DrawString(X,Y+218,"\144\101\139\074 \132\113\191\205\129\102\131\087 BMP \161\164 PNG \161\164 JPG \134\086\133\073\129\083 \131\100\139\123\129\076\129\077",M_Silver,16)
			DrawString(X,Y+244,"\140\118\134\094  \129\111 \131\097 \161\164 64x80 \132\094\131\071\132\083 \133\120\130\108 \138\071\144\084",M_White,16)
			DrawString(X,Y+268,"\130\066\132\101  MOV \161\164 SPC \161\164 ATK / \131\119\129\067  \130\066\129\065 \161\164 \133\067\129\065",M_White,16)
			DrawString(X,Y+294,"\130\069 \131\091\130\079\131\080 \131\124\131\071\129\064 \132\113\191\205\131\109\132\083 \131\081\134\071\130\095\132\083 \132\067\137\066\132\116\129\076\129\077",M_Silver,16)
			if #share>0 then
				DrawString(X,Y+322,"\132\071\131\098 \140\118\134\094\131\080 \131\097\129\113 "..#share.."\130\088\129\068 \137\072\138\095 \131\085\136\149\129\076\129\077",M_Red,16)
			else
				DrawString(X,Y+322,"\140\118\134\094 \131\091\130\079 "..p[P.FACE].."\130\087",M_Silver,16)
			end
			DrawString(ox+28,oy+438,"\130\116\131\064 \140\097\130\086 \133\102\131\097 \161\164 \130\090\136\101 \133\102\131\097 \131\071\133\108 \130\074\132\111",M_Silver,16)
		end
		local r=koOfficerWait(drawScr,btns,function()
			if statDrag(X,Y+90,sget,function(f,v) gsSet(pid,f,v) end) then dragging=true
			elseif dragging then dragging=false gsCommit(pid) end
		end)
		if dragging then dragging=false gsCommit(pid) end
		local b=btns[r]
		if r==0 or (b and b.back) then gsCommit(pid) shareAsk(pid) return end
		if b and b.act=="statin" then
			local v=statEntry(drawScr,btns,b,sget(b.f))
			if v then gsSet(pid,b.f,v) gsCommit(pid) end
			b=nil
		end
		if b and b.statreset then
			if gsChanged(pid) then for f,_ in pairs(SF) do gsSet(pid,f,GS_ORIG[pid][f]) end gsCommit(pid) pcall(ReSetAttrib,pid,false)
			else msg({"\131\085\137\091 \131\077\131\125\132\081\129\094 \130\097\129\075\129\076\129\077"}) end
			b=nil
		end
		if b and b.reset then   -- 10-13 (사용자): 바꾼 그림을 모두 원래대로 (전투 = 공통 + 병종별 전부)
			local k=b.reset
			local cls={} if k=="war" then for _,bz in ipairs(BZ_LIST) do if bzOn(pid,bz) then cls[#cls+1]=bz end end end
			local leg=legacyTags(pid,k)
			if not (geHas(geTag(k,pid)) or #cls>0 or #leg>0) then msg({"\131\085\137\091 "..PUT_NAME[k].."\129\071 \130\097\129\075\129\076\129\077"})
			elseif ask({PUT_NAME[k].."\129\083 \131\081\134\071 \131\091\130\079\131\109\132\083 \132\067\137\066\132\117\129\089\129\090?",(k=="war") and "\130\074\132\119 \131\091\130\079\129\123 \130\126\129\084\138\090 \131\091\130\079\129\083 \130\090\130\091 \132\067\137\066\132\116\129\076\129\077" or ((k=="face" and #share>0) and "\132\071\131\098 \140\118\134\094\129\083 \136\096\130\098 \131\097\129\113\129\068 \132\071\129\071 \137\066\129\110\134\104\129\076\129\077" or nil)},"\131\124\131\071\129\064","\129\108\129\109") then
				if geHas(geTag(k,pid)) then geRestore(k,pid) end
				for _,bz in ipairs(cls) do bzRestore(pid,bz) end
				if #leg>0 then   -- 11-08: 고치기 전에 같이 쓰던 칸에 넣은 그림도 원래대로
					if k=="face" then FC.FORCE_FACE=FC.rawFace(pid) else FORCE_SP=SPbase(pid) end
					for _,x in ipairs(leg) do pcall(function() if x=="w" or x=="c" or x=="f" then geRestore(k,pid) else bzRestore(pid,x) end end) end
					FORCE_SP=nil FC.FORCE_FACE=nil
				end
				msg({PUT_NAME[k].."\129\083 \131\081\134\071 \131\091\130\079\131\109\132\083 \132\067\137\066\132\126\129\075\129\076\129\077"})
				shareAsk(pid)
			end
			b=nil
		end
		if b and b.k=="war" then-- 10-13: the class grid (its 공통 button runs the common flow)
			local function common()
				local go=true
				if geHas(geTag("war",pid)) then
					local c=ask3({"\129\071\134\119 \131\085\137\091 \130\074\132\119 \130\066\132\101 \129\118\136\069\129\071 \132\079\129\075\129\076\129\077"},"\134\068\132\083 \131\100\130\106\131\071","\131\081\134\071\130\095\132\083","\129\108\129\109")
					if c==2 then geRestore("war",pid) msg({"\130\074\132\119 \130\066\132\101 \129\118\136\069\129\083 \131\081\134\071\130\095\132\083 \132\067\137\066\132\126\129\075\129\076\129\077"}) end
					go=(c==1)
				end
				if go then gePut("war",pid) end
			end
			warGrid(pid,common)
			shareAsk(pid)
			b=nil
		end
		if b and b.k then
			local k=b.k
			local go=true
			if ed[k] then
				local c=ask3({"\129\071\134\119 \131\085\137\091 "..PUT_NAME[k].."\129\071 \132\079\129\075\129\076\129\077"},"\134\068\132\083 \131\100\130\106\131\071","\131\081\134\071\130\095\132\083","\129\108\129\109")
				if c==2 then geRestore(k,pid) msg({PUT_NAME[k].."\129\083 \131\081\134\071\130\095\132\083 \132\067\137\066\132\126\129\075\129\076\129\077"}) end
				go=(c==1)
			end
			if go and k=="face" and #share>0 then
				go=ask({"\140\118\134\094 \131\091\130\079 "..p[P.FACE].."\130\087\129\083 \132\071\129\071 \136\096\130\098 \131\097\129\113\129\094 \132\079\129\075\129\076\129\077",shareText(share),"\129\071 \131\097\129\113\131\082\131\080 \140\118\134\094\129\068 \132\071\129\071 \131\085\136\149\129\076\129\077"},"\131\085\131\086\131\071","\129\108\129\109")
			end
			if go then gePut(k,pid) end
			shareAsk(pid)
		end
	end
end
-- Hide generic soldiers, town NPCs, unused records and the engine test character.
function FC.geBase(pid,p)
	if not p or p[P.NAME]=="" or (pid>=257 and pid<=375) or pid==381 or pid==406 then return false end
	if (SAME_SLOT[CONFIG.koCamp or ""] or {})[pid] then return false end
	if (NOT_IN_GAME[CONFIG.koCamp or ""] or {})[pid] then return false end
	local o=GS_ORIG[pid]
	return ((o and o.wl or p[P.WL])+(o and o.zl or p[P.ZL])+(o and o.ts or p[P.TS]))>0
end
-- 11-11 사용자 「장수편집에 중복 장수가 나오면 안 돼」 → 「동명이인은 남기고 동일인만 제거」: 이야기 자기 칸(1~382)과 같은 사람인
--   영걸전 칸(383+, 이야기에 안 나옴)만 숨김. 열전으로 같은 사람인지 확인한 표 — 진기 396(하후돈 부장 秦琪)은 원술 부장 陳紀 와 다른 사람이라 남김,
--   우금 于禁 · 牛金, 마충, 손소, 장온, 장제, 장패 같은 동명이인도 남김. 새 이야기 · 새 칸이 생기면 이 표에 더할 것.
FC.SAME_PERSON={
	wuje={[387]=true,[399]=true,[401]=true},--전위 · 양의 · 상랑
	sunjian={[392]=true,[402]=true,[410]=true,[411]=true,[412]=true},--한복 · 진도 · 손상향 · 대교 · 소교
	yuanshao={[387]=true,[401]=true,[402]=true},--전위 · 상랑 · 진도
}
local function geListed(pid,p)
	if not FC.geBase(pid,p) then return false end
	return not (FC.SAME_PERSON[CONFIG.koCamp or ""] or {})[pid]
end
-- (tests) the list rule, and an edit of pid as the screen would save it
function koGenEditSameTest(pid,wl,zl,ts)
	if wl then gsSet(pid,"wl",wl) gsSet(pid,"zl",zl) gsSet(pid,"ts",ts) gsCommit(pid) end
	return geListed(pid,JY.Person[pid])
end
local GE_PER=12
-- 11-11 공용화 4단계: 목록 = 통합 명단(genedit_roster.lua, 네 모드 547명). 이름 뒤 [영무손원] = 나오는 모드.
--  지금 모드에 있는 무장은 그 자리에서 편집, 다른 모드에만 있으면 그 이야기로 바꿔(campsel koSoftRestart) 띄운 뒤 그 무장 편집 창을 바로 엶
--  (게임 폴더 genedit/open.txt = 명단 키, 아래 타이틀 훅). 메인 화면 「장수 관리」 단추도 이 화면.
function FC.rosterKey(r) return (type(r[1])=="number") and tostring(r[1]) or (string.gsub(r[1],":","@")) end
FC.MODENAME={yeonggeol="\129\126\130\064\130\066",wuje="\129\073\129\100\130\066",sunjian="\135\089\134\084\130\066",yuanshao="\131\081\129\109\130\066"}
FC.MODETAG={yeonggeol="\129\126",wuje="\129\073",sunjian="\135\089",yuanshao="\131\081"}
function FC.baseStat(m,pid)
	FC.GRP=FC.GRP or {}
	if FC.GRP[m]==nil then FC.GRP[m]=readAll(CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp") or false end
	local d=FC.GRP[m] if not d then return 0,0,0 end
	local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if #ix<4 then return 0,0,0 end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local at=b1+b2*256+b3*65536+b4*16777216+pid*CC.PersonSize
	local function g(f) local o=CC.Person_S[f][1] local a,b=string.byte(d,at+o+1,at+o+2) local v=(a or 0)+(b or 0)*256 if v>=32768 then v=v-65536 end return v end
	return g(P.WL),g(P.ZL),g(P.TS)
end
function FC.allStat(key)
	for k,a,b,c in string.gmatch(CC.koGenStatAll or "","([^,:]+):(%d+):(%d+):(%d+)") do if k==key then return tonumber(a),tonumber(b),tonumber(c) end end
	return nil
end
function FC.openOther(key,m)
	if type(rawget(_G,"koSoftRestart"))~="function" then msg({"\129\071 \129\073\131\097\131\098 "..FC.MODENAME[m].."\129\102\131\087 \132\075\134\076\129\088 \129\113 \132\079\129\075\129\076\129\077"}) return end
	mkdir(CONFIG.CurrentPath.."genedit")
	writeAll(CONFIG.CurrentPath.."genedit/open.txt",key)
	if m=="yeonggeol" then os.remove(CONFIG.CurrentPath.."ko_camp.txt") else writeAll(CONFIG.CurrentPath.."ko_camp.txt",m..string.char(10)) end
	if not koSoftRestart() then os.remove(CONFIG.CurrentPath.."genedit/open.txt") msg({"\129\071\133\069\131\071\130\104 \131\085\131\086\130\067 \136\102\129\080\129\075\129\076\129\077"}) end
end
koOn("title",function()
	local key=readAll(CONFIG.CurrentPath.."genedit/open.txt")
	if not key then return nil end
	os.remove(CONFIG.CurrentPath.."genedit/open.txt")
	key=string.gsub(key,"%s","")
	if key~="" then
		koGenEditScreen(key)
		if type(rawget(_G,"koMainScreen"))=="function" then koMainScreen() end   -- 11-11: 장수 관리는 메인 화면에만 → 닫으면 메인 화면으로
	end
	return nil
end)
function koGenEditScreen(focus)
	LoadRecord(0)
	if focus then local fp=koGenShare.k2p[koGenShare.MODE][focus] if fp and geListed(fp,JY.Person[fp]) then geEdit(fp) end end
	local ox,oy=oxy()
	local page,q,only=1,nil,false
	local sort,desc=nil,false
	local nameKey=koNameKey
	local cols={{f="id",s="\130\087\134\113",x=28,w=76},{f="name",s="\129\071\138\075",x=104,w=300},
		{f="wl",s="\129\073\131\125",x=404,w=110},{f="zl",s="\130\067\131\125",x=514,w=110},{f="ts",s="\132\119\132\120",x=624,w=110}}
	local function rowDraw(b,on,hover)
		local e=b.entry
		if on or hover then lib.FillColor(b.x,b.y,b.x+b.w,b.y+b.h,RGB(40,52,88))
		elseif b.stripe then lib.FillColor(b.x,b.y,b.x+b.w,b.y+b.h,RGB(12,22,48)) end
		local col=(on or hover) and C_Name or M_White
		DrawString(ox+40,b.y+5,e.show or tostring(e.id),M_Silver,16)
		DrawString(ox+120,b.y+5,e.label,col,16)
		for _,c in ipairs(cols) do if c.f=="wl" or c.f=="zl" or c.f=="ts" then
			local text=tostring(e[c.f])
			DrawString(ox+c.x+c.w-30-#text*8,b.y+5,text,col,16)
		end end
	end
	while true do
		local L={}
		local GL=gsList()
		local KS=koGenShare
		for ri,rr in ipairs(rawget(_G,"koGenRoster") or {}) do
			local key=FC.rosterKey(rr)
			local tags,first="",nil
			for _,m in ipairs(KS.MODES) do if (rr[KS.COL[m]] or 0)>0 then tags=tags..FC.MODETAG[m] first=first or m end end
			local pid=KS.k2p[KS.MODE][key]
			local p=pid and JY.Person[pid]
			if pid and geListed(pid,p) then
				local changed=geHas("f"..p[P.FACE]) or geHas(geTag("war",pid)) or famAny(pid) or geHas(geTag("city",pid)) or GL[pid] or #legacyTags(pid,"war")>0 or #legacyTags(pid,"city")>0 or #legacyTags(pid,"face")>0
				if (not only or changed) and (not q or string.find(p[P.NAME],q,1,true)) then
					L[#L+1]={id=pid,name=nameKey(p[P.NAME]),label=p[P.NAME].."  ["..tags.."]",wl=gsGet(pid,"wl"),zl=gsGet(pid,"zl"),ts=gsGet(pid,"ts")}
				end
			elseif not pid and first then
				local a,b2,c=FC.allStat(key)
				if (not only or a) and (not q or string.find(rr[2],q,1,true)) then
					if not a then a,b2,c=FC.baseStat(first,rr[KS.COL[first]]) end
					L[#L+1]={id=1000+ri,show="-",key=key,other=first,name=nameKey(rr[2]),label=rr[2].."  ["..tags.."]",wl=a,zl=b2,ts=c}
				end
			end
		end
		table.sort(L,function(a,b)
			local field=sort or "id"
			if a[field]==b[field] then return a.id<b.id end
			if desc then return a[field]>b[field] end
			return a[field]<b[field]
		end)
		local np=math.max(1,math.ceil(#L/GE_PER))
		page=math.max(1,math.min(page,np))
		local btns={}
		for _,c in ipairs(cols) do
			btns[#btns+1]={x=ox+c.x,y=oy+76,w=c.w-4,h=26,
				s=c.s..((sort==c.f) and (desc and " v" or " ^") or ""),sort=c.f,primary=sort==c.f}
		end
		for i=1,GE_PER do local e=L[(page-1)*GE_PER+i] if not e then break end
			btns[#btns+1]={x=ox+28,y=oy+106+(i-1)*26,w=706,h=26,pid=(not e.key) and e.id or nil,okey=e.key,entry=e,stripe=i%2==0,s="",draw=rowDraw}
		end
		btns[#btns+1]={x=ox+28,y=oy+432,w=88,h=28,s="< \129\071\130\066",d=-1}
		btns[#btns+1]={x=ox+122,y=oy+432,w=88,h=28,s="\129\077\130\077 >",d=1}
		btns[#btns+1]={x=ox+224,y=oy+432,w=104,h=28,s="\129\071\138\075 \136\086\140\089",find=true}
		btns[#btns+1]={x=ox+334,y=oy+432,w=88,h=28,s="\136\086\140\089 \129\066\129\100",clear=true}
		btns[#btns+1]={x=ox+436,y=oy+432,w=156,h=28,s=only and "\130\090\136\101 \131\097\129\113 \131\115\131\071" or "\131\085\137\091 \131\097\129\113\132\086",only=true}
		btns[#btns+1]={x=ox+624,y=oy+432,w=110,h=28,s="\137\066\129\110\129\094\131\071",back=true}
		btns[#btns+1]={x=ox+28,y=oy+12,w=96,h=26,s="\131\095\131\115\131\095\131\071",pexp=true}   -- 11-11: zip 으로 공유
		btns[#btns+1]={x=ox+130,y=oy+12,w=96,h=26,s="\129\094\136\107\129\091\131\071",pimp=true}
		local r=koOfficerWait(function()
			koOfficerBack(OFFICER_BACK_PIC)
			ctext(ox+384,oy+12,"\131\097\129\113\132\075\134\076",C_Name,28)
			DrawString(ox+28,oy+50,(q and ("\136\086\140\089: "..q.." \161\164 ") or "")..#L.."\130\088",M_Silver,16)
			local text=page.." / "..np.."\139\074"
			DrawString(ox+734-#text*8,oy+50,text,M_Silver,16)
			if #L==0 then ctext(ox+384,oy+230,q and "\136\086\140\089 \134\064\129\123\129\094 \130\097\129\075\129\076\129\077" or "\131\085\137\091 \131\097\129\113\129\094 \130\097\129\075\129\076\129\077",M_White) end
		end,btns)
		local b=btns[r]
		if r==0 or (b and b.back) then break end
		if b then
			if b.pid then geEdit(b.pid)
			elseif b.pexp then koGenPackExport("genedit")
			elseif b.pimp then koGenPackImport() LoadRecord(0)
			elseif b.okey then   -- 11-11 사용자 「다른 모드에만 있는 무장도 메인 화면 장수 관리에서」: 묻지 않고 그 모드 기록을 불러와 바로 편집, 닫으면 메인 화면
				FC.openOther(b.okey,b.entry.other)
			elseif b.sort then
				if sort~=b.sort then sort=b.sort desc=false
				elseif not desc then desc=true
				else sort=nil desc=false end
				page=1
			elseif b.d then page=limitX(page+b.d,1,np)
			elseif b.only then only=not only page=1
			elseif b.clear then q=nil page=1
			elseif b.find then
				local n,bad=koNewGenInputName(q or "")
				if n==false then n=namePad(q or "") end
				if bad then msg({"\129\081\129\082 \142\116\140\066\129\102 \130\097\130\098 \142\116\133\120\129\094 \132\079\129\075\129\076\129\077"}) n=nil end
				if n then q=(n~="") and n or nil page=1 end
			end
		end
	end
	LoadRecord(0)
end
-- (모드별 타이틀 「장수 관리 > 장수편집」은 11-11 없앰 — 메인 화면 「장수 관리」)
-- 11-11 메인 화면 「도감」 단추 (campsel): 무장 도감 · 보물 도감. 무장 도감은 명단 · 출현 조건이 이야기마다 달라 이야기를 고름 — 지금 이야기면 바로,
--  다른 이야기면 그 이야기로 바꿔(koSoftRestart, genedit/openbook.txt) 무장 도감을 연 뒤 닫으면 메인 화면. 보물 도감은 공용 기록이라 그 자리에서
function FC.bookOpen(m,pid)
	local K=koGenShare
	if m==K.MODE then koBookUnifiedScreen() return end
	if type(rawget(_G,"koSoftRestart"))~="function" then return end
	mkdir(CONFIG.CurrentPath.."genedit")
	writeAll(CONFIG.CurrentPath.."genedit/openbook.txt",tostring(pid or 0))
	if m=="yeonggeol" then os.remove(CONFIG.CurrentPath.."ko_camp.txt") else writeAll(CONFIG.CurrentPath.."ko_camp.txt",m..string.char(10)) end
	if not koSoftRestart() then os.remove(CONFIG.CurrentPath.."genedit/openbook.txt") end
end
koOn("title",function()
	local s=readAll(CONFIG.CurrentPath.."genedit/openbook.txt")
	if not s then return nil end
	os.remove(CONFIG.CurrentPath.."genedit/openbook.txt")
	local pid=tonumber(string.match(s,"%d+") or "") or 0
	-- 11-11 사용자 「조조 설명이 무제전 기준」: 합친 도감은 영걸전 기준(영걸전에 있는 무장은 영걸전 기록 · 설명). 다른 이야기 무장은 그 이야기로 넘어와
	--  그 무장 창만 보여 준 뒤 영걸전 도감으로 돌아감
	if pid>0 then
		rawset(_G,"koBookFocus",pid) rawset(_G,"koBookFocusOnly",true)
		pcall(koBookUnifiedScreen)
		rawset(_G,"koBookFocusOnly",nil)
		if koGenShare.MODE~="yeonggeol" then FC.bookOpen("yeonggeol",0) end
	end
	koBookUnifiedScreen()
	if type(rawget(_G,"koMainScreen"))=="function" then koMainScreen() end
	return nil
end)
-- 11-11 사용자 「무장 도감도 하나로 합치자」: 네 이야기 무장 도감 명단을 통합 명단 키로 합침. 해금 · 이름 보임 = 어느 이야기든 (각 이야기 ko_settings 의
--  CC.koBookG, 그 이야기 도감 순서). 지금 이야기에 있는 무장은 그 기록 그대로, 없는 무장은 화면 동안만 빈 번호(100001~)에 이름 · 얼굴 · 능력만 둔
--  칸으로 그리고, 누르면 그 이야기로 바꿔(koSoftRestart) 그 무장 정보 창을 바로 엶. 그리기는 record.lua koRecordScreen 그대로(koBookEntries ·
--  koBookForeign · koBookFocus 세 군데만 고침)
FC.HINTS={}
function FC.bookList(m)
	local list
	if m==koGenShare.MODE then list=koRecBook FC.HINTS[m]=koRecHint
	elseif m=="yeonggeol" then   -- record.lua 의 두 줄을 이야기 없는 환경에서 돌려 영걸전 명단 · 출현 조건을 얻음
		local s=readAll(CONFIG.ScriptPath.."addon/record.lua") or ""
		local env=setmetatable({},{__index=function(t,k) return rawget(_G,k) end})
		env._G=env
		for _,ln in ipairs({string.match(s,"\n(koRecBook=[^\n]*)"),string.match(s,"\n(koRecHint=[^\n]*)")}) do
			local f=load(ln,"rec","t",env) if f then pcall(f) end
		end
		list=rawget(env,"koRecBook") FC.HINTS[m]=rawget(env,"koRecHint") or {}
	else
		local cfg=setmetatable({koCampScript=CONFIG.ScriptPath.."camp/"..m.."/"},{__index=CONFIG})
		local env=setmetatable({CONFIG=cfg},{__index=function(t,k) return rawget(_G,k) end})
		local s=readAll(CONFIG.ScriptPath.."camp/"..m.."/camp.lua")
		local f=s and load(s,"camp","t",env) if f then pcall(f) end
		list=rawget(env,"koCamp") and env.koCamp.recBook
		FC.HINTS[m]=(rawget(env,"koCamp") and env.koCamp.recHint) or {}
	end
	local out,seen={},{}
	for _,c in ipairs(list or {}) do if not seen[c] then out[#out+1]=c seen[c]=true end end
	if m~=koGenShare.MODE and rawget(_G,"koHas") and koHas("uhui") and not seen[418] then out[#out+1]=418 end   -- uhui 애드온이 모든 이야기 도감 끝에 붙임
	return out
end
function FC.recIn(m,pid)   -- 그 이야기 새 게임 기록의 이름 · 얼굴 (이야기는 PERSON 표 얼굴 먼저)
	FC.GRP=FC.GRP or {}
	if FC.GRP[m]==nil then FC.GRP[m]=readAll(CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp") or false end
	local d=FC.GRP[m] local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if not d or #ix<4 then return "",0 end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local at=b1+b2*256+b3*65536+b4*16777216+pid*CC.PersonSize
	local no,nl=CC.Person_S[P.NAME][1],CC.Person_S[P.NAME][3]
	local nm=string.match(string.sub(d,at+no+1,at+no+nl),"^[^%z]*") or ""
	local fo=CC.Person_S[P.FACE][1] local a,b=string.byte(d,at+fo+1,at+fo+2) local face=(a or 0)+(b or 0)*256
	if m~="yeonggeol" then for _,e in ipairs(storyRoster(m)) do if e[1]==pid then face=e[4] break end end end
	return nm,face
end
function FC.recBz(m,pid)
	FC.GRP=FC.GRP or {}
	if FC.GRP[m]==nil then FC.GRP[m]=readAll(CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp") or false end
	local d=FC.GRP[m] local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if not d or #ix<4 then return 1 end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local at=b1+b2*256+b3*65536+b4*16777216+pid*CC.PersonSize+CC.Person_S[P.BZ][1]
	local a=string.byte(d,at+1) return (a and a>0) and a or 1
end
function FC.recSk(m,pid,k)
	FC.GRP=FC.GRP or {}
	if FC.GRP[m]==nil then FC.GRP[m]=readAll(CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp") or false end
	local d=FC.GRP[m] local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if not d or #ix<4 then return 0 end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local at=b1+b2*256+b3*65536+b4*16777216+pid*CC.PersonSize+CC.Person_S[P.SK..k][1]
	local a,b=string.byte(d,at+1,at+2) return (a or 0)+(b or 0)*256
end
function koBookUnifiedScreen()
	local K=koGenShare
	if not rawget(_G,"koBookTitleScreen") or not rawget(_G,"koRecUnlocked") then return end
	local cur=K.MODE
	local E,byKey={},{}
	for _,m in ipairs(K.MODES) do
		local L=FC.bookList(m)
		local g=(m==cur) and (CC.koBookG or "") or (K.readSettings(m).koBookG or "")
		for i,c in ipairs(L) do
			local st=tonumber(string.sub(g,i,i)) or 0
			local key=K.p2k[m][c] or (m.."#"..c)
			local e=byKey[key]
			if not e then e={} byKey[key]=e E[#E+1]=e end
			e[m]=c
			if st%2==1 then e.open=true end
			if st>=2 then e.seen=true end
		end
	end
	local entries,F,OPEN,SEEN,SECRET={},{},{},{},{}
	local fake=100000
	for _,e in ipairs(E) do
		local c=e[cur]
		if not c then
			local m for _,mm in ipairs(K.MODES) do if e[mm] then m=mm break end end
			fake=fake+1 c=fake
			local nm,face=FC.recIn(m,e[m])
			local a,b,d=FC.baseStat(m,e[m])
			JY.Person[c]={[P.NAME]=nm,[P.FACE]=face,[P.WL]=a,[P.ZL]=b,[P.TS]=d,[P.WL2]=a,[P.ZL2]=b,[P.TS2]=d,[P.LORD]=0,[P.BZ]=FC.recBz(m,e[m]),[P.LV]=99}
			for k=1,6 do JY.Person[c][P.SK..k]=FC.recSk(m,e[m],k) end
			F[c]={mode=m,pid=e[m]}
			if rawget(_G,"koRecSecret") and koRecSecret[e[m]] then SECRET[c]=true end
		end
		entries[#entries+1]=c
		if e.open then OPEN[c]=true end
		if e.seen then SEEN[c]=true end
	end
	-- 출현 조건: 그 무장이 나오는 이야기마다 「【이야기】 조건」, 모두 같으면 한 번. 병종은 처음 나오는 이야기 것
	local HINT={}
	for i,e in ipairs(E) do
		local c=entries[i]
		-- 11-11 사용자 「(고간) 이게 모든 모드에서 이야기 합류라는 거야?」: 늘 이야기 이름을 붙이고, 조건이 같은 이야기는 「【무제전 · 원소전】 조건」 으로 묶음
		local bz,order,names=nil,{},{}
		for _,m in ipairs(K.MODES) do
			local h=e[m] and FC.HINTS[m] and FC.HINTS[m][e[m]]
			if h then
				local hb,hc=string.match(h,"^(.-)\t(.*)$")
				if not hb then hb,hc="",h end
				if not bz or bz=="" then bz=hb end
				if not names[hc] then names[hc]={} order[#order+1]=hc end
				table.insert(names[hc],FC.MODENAME[m])
			end
		end
		local parts={}
		for _,hc in ipairs(order) do parts[#parts+1]="\161\190"..table.concat(names[hc]," \161\164 ").."\161\191 "..hc end
		if #parts>0 then HINT[c]=(bz or "").."\t"..table.concat(parts,"*") end
	end
	local rHint,rWhere=koRecHint,rawget(_G,"koTavernWhereText")
	koRecHint=HINT
	if rWhere then koTavernWhereText=function() return nil end end   -- 지금 이야기 기준 연고 줄은 합친 도감에서 뺌
	rawset(_G,"koBookShowFace",function(c) if OPEN[c] or (not F[c] and koRecUnlocked(c)) then return JY.Person[c][P.FACE] end return nil end)
	local rU,rS,rH,rT=koRecUnlocked,koRecSeen,koRecHidden,rawget(_G,"koTavernTip")
	koRecUnlocked=function(c) if OPEN[c] then return true end if F[c] then return false end return rU(c) end
	koRecSeen=function(c) if SEEN[c] then return true end if F[c] then return false end return rS(c) end
	koRecHidden=function(c) if F[c] then return SECRET[c] and not SEEN[c] end return rH(c) end
	rawset(_G,"koBookNeutral",true)   -- 11-11: 마우스 창도 지금 이야기 연고 · 호감 줄 없이, 다른 이야기 무장도 (town koTavernTip)
	rawset(_G,"koBookEntries",entries)
	-- 11-11 사용자 「해금 무장 창도 출현 조건 창 형식으로 통일」: 합친 도감은 모든 무장을 출현 조건 창(record.lua hint)으로, 해금이면 얼굴 · 기술 이름
	rawset(_G,"koBookForeign",function(c) return true end)
	rawset(_G,"koBookSkill",function(c,i)
		if not OPEN[c] and not rU(c) then return nil end
		local sid=JY.Person[c][P.SK..i] or 0
		local s=sid>0 and JY.Skill[sid] and JY.Skill[sid]["\195\251\179\198"]
		return (s and s~="") and s or nil
	end)
	local ok,err=pcall(koBookTitleScreen)
	koRecUnlocked,koRecSeen,koRecHidden=rU,rS,rH
	rawset(_G,"koBookNeutral",nil)
	koRecHint=rHint
	if rWhere then koTavernWhereText=rWhere end
	rawset(_G,"koBookShowFace",nil) rawset(_G,"koBookSkill",nil)
	rawset(_G,"koBookEntries",nil) rawset(_G,"koBookForeign",nil) rawset(_G,"koBookFocus",nil)
	for c,_ in pairs(F) do JY.Person[c]=nil end
	if not ok then error(err,0) end
end
function koBookMainMenu()
	local c=ask3({"\129\068\135\078","\129\073\131\097 \129\068\135\078 \161\164 \131\115\131\065 \129\068\135\078 \130\090\130\091 \130\090\136\101 \130\090\133\119 \130\074\132\111"},"\129\073\131\097 \129\068\135\078","\131\115\131\065 \129\068\135\078","\129\108\129\109")
	if c==2 then if rawget(_G,"koBogamScreen") then koBogamScreen() end return end
	if c==1 then koBookUnifiedScreen() end   -- 11-11 사용자 「기준 없이, 출현 조건은 모드별로」: 지금 이야기 그대로
end
-- ---- 11-11 사용자 「장수 관리에서 무장편집 · 신무장 등록을 zip 으로 내보내 공유하고, 남이 공유한 zip 을 가져와 적용」 (PC: ko_sdl.dll ko_zip.txt 요청,
--  저장 파일 옮기기(saveio)와 같은 길 — export = 저장 창 + zip 쓰기, import = 열기 창 + ko_import/ 에 풀기, files = 복사 · 지우기)
--  zip = kopack.lua(PACK: kind · 장수편집 표시 · 능력치 · 따로 받은 칸 · 얼굴 짝 / 신무장 등록부) + genedit/<표시>.kgs + newgen/NN/…bmp
--  가져오기: 장수편집은 같은 키를 가져온 값으로, 따로 받은 조형 칸(803~) · 얼굴 칸(20000~)은 이 PC 의 빈 번호로 바꿔 넣음(표시 · 사본 이름도),
--  그림은 공용 genedit/imported.txt 에 적어 gesync 가 사본대로 넣게 함(장수편집 화면을 나올 때). 신무장은 같은 이름이면 그 칸, 아니면 빈 번호.
FC.PSD="data/save/"
function FC.zipAsk(req)
	local ZREQ,ZOUT=CONFIG.CurrentPath.."ko_zip.txt",CONFIG.CurrentPath.."ko_zip_out.txt"
	os.remove(ZOUT)
	if not writeAll(ZREQ,req) then return nil end
	local frames=0
	while true do
		JY.ReFreshTime=lib.GetTime()
		ShowScreen()
		local s=readAll(ZOUT)
		if s then os.remove(ZOUT) return s end
		frames=frames+1
		if frames>40 and readAll(ZREQ) then os.remove(ZREQ) return nil end
		koPollKey()
		lib.Delay(30)
	end
end
-- ---- 11-11 사용자 「고침 유무에 상관없이 현재 상태로 내보내기(기본값 백업용으로도)」: 장수편집 내보내기 = 통합 명단 전원의 지금 상태
--  무장마다(키 = 통합 명단): 지금 보이는 얼굴(따로 받은 얼굴이면 그것) · 고유 전투 조형 · 고유 평상 조형 · 병종별 조형(있으면) 그림과 능력치(편집 값 또는 기본값).
--  zip: kopack.lua(PACK.full · PACK.people) + snap/<키>_face|war|city|v<병종>.bin (KOB1). 가져오기(snapApply) = 그 상태로 맞춤: 이 PC 의 지금 그림과 다른 것만
--  장수편집 기록(표시 + 공용 사본 genedit/*.kgs, 원래 그림 보관)으로 넣어 gesync 가 넣게 함(초기화로 되돌릴 수 있음). 다른 이름 무장과 같이 쓰는 칸 · 얼굴이면
--  장수편집에서 넣을 때처럼 따로 받은 칸 · 얼굴로. 능력치는 기본값과 같으면 편집 기록을 지우고 다르면 그 값으로.
FC.SNAPTMP="ko_pack_tmp/"
function FC.personSlots(m,pid)   -- (모드, 번호) → 조형 칸(영걸전 번호), 원래 얼굴, 이름
	if m==koGenShare.MODE and JY.Person[pid] then
		local f=rawget(_G,"koWujeIdentity")
		local id=(CONFIG.koCamp and f and f(pid)) or pid
		return id,FC.rawFace(pid),FC.rawName(pid)
	end
	local nm,face=FC.recIn(m,pid)
	local id=pid
	if m~="yeonggeol" then for _,e in ipairs(storyRoster(m)) do if e[1]==pid then id=e[3] break end end end
	return id,face,nm
end
function FC.mixedId(m,id,nm)   -- 그 이야기에서 이름 다른 무장이 같은 조형 칸을 쓰나
	if m=="yeonggeol" then return false end
	for _,e in ipairs(storyRoster(m)) do if e[3]==id and e[2]~="" and e[2]~=nm then return true end end
	return false
end
function FC.faceShared(face,nm)   -- 어느 모드에서든 이름 다른 무장이 같은 얼굴 번호를 쓰나
	for _,m in ipairs(koGenShare.MODES) do for _,e in ipairs(storyRoster(m)) do if e[4]==face and e[2]~="" and e[2]~=nm then return true end end end
	return false
end
function FC.homeOf(key)   -- 그 무장을 볼 모드: 지금 모드에 있으면 지금 모드, 아니면 처음 나오는 모드
	local K=koGenShare
	local q=K.k2p[K.MODE][key] if q then return K.MODE,q end
	for _,m in ipairs(K.MODES) do local p=K.k2p[m][key] if p then return m,p end end
	return nil
end
function FC.snapCollect(lines,L)
	local K=koGenShare
	local SL,FA,ST={},{},{}
	for _,e in ipairs(K.entries(CC.koGenSlotAll)) do SL[e[1]]=tonumber(e[2]) end
	for _,e in ipairs(K.entries(CC.koGenFaceAll)) do local _,v=string.match(e[2],"(%d+):(%d+)") FA[e[1]]=tonumber(v) end
	for _,e in ipairs(K.entries(CC.koGenStatAll)) do ST[e[1]]=e[2] end
	mkdir(CONFIG.CurrentPath..string.sub(FC.SNAPTMP,1,-2))
	local people={}
	for i,r in ipairs(rawget(_G,"koGenRoster") or {}) do
		local key=FC.rosterKey(r)
		local m,pid=FC.homeOf(key)
		if m then
			local id,face,nm=FC.personSlots(m,pid)
			local slot=SL[key] or id
			local fc=FA[key] or face
			local a,b,c=FC.baseStat(m,pid)
			local rec={"key="..string.format("%q",key),"stat="..string.format("%q",ST[key] or (a..":"..b..":"..c))}
			local fn=string.gsub(key,"[^%w@]","_")
			rec[#rec+1]="fn="..string.format("%q",fn)
			local function put(tag,cells)
				local f=FC.SNAPTMP..fn.."_"..tag..".bin"
				writeAll(CONFIG.CurrentPath..f,packCells(true,cells))
				L[#L+1]="snap/"..fn.."_"..tag..".bin|"..f
			end
			if fc and fc>0 then local cl=grpGet(dataPath("hdgrp"),fc,1) if cl and cl[1]~="" then put("face",cl) rec[#rec+1]="face=true" end end
			if rawget(_G,"koUniqueWar") and koUniqueWar[slot] then local cl=grpGet(dataPath("wmap"),20000+slot*50,50) if cl then put("war",cl) rec[#rec+1]="war=true" end end
			if rawget(_G,"koUniqueCity") and koUniqueCity[slot] then local cl=grpGet(dataPath("smap"),200+(300+slot)*4,4) if cl then put("city",cl) rec[#rec+1]="city=true" end end
			local bzs={}
			local U=rawget(_G,"koUniqueBz")
			if U and type(U[slot])=="table" then for bz,at in pairs(U[slot]) do if type(bz)=="number" and type(at)=="number" then local cl=grpGet(dataPath("wmap"),at,50) if cl then put("v"..bz,cl) bzs[#bzs+1]=bz end end end end
			if #bzs>0 then rec[#rec+1]="bz={"..table.concat(bzs,",").."}" end
			people[#people+1]="{"..table.concat(rec,",").."}"
		end
		if i%30==0 then JY.ReFreshTime=lib.GetTime() ShowScreen() end
	end
	lines[#lines+1]="PACK.full=true"
	lines[#lines+1]="PACK.people={\n"..table.concat(people,",\n").."}"
end
function FC.snapApply(P2,IM)
	local K=koGenShare
	local SL,FA,ST={},{},{}
	for _,e in ipairs(K.entries(CC.koGenSlotAll)) do SL[e[1]]=tonumber(e[2]) end
	for _,e in ipairs(K.entries(CC.koGenFaceAll)) do local r,v=string.match(e[2],"(%d+):(%d+)") FA[e[1]]={raw=tonumber(r),new=tonumber(v)} end
	for _,e in ipairs(K.entries(CC.koGenStatAll)) do ST[e[1]]=e[2] end
	local n=math.floor(#(readAll(CONFIG.DataPath.."wmap.idx") or "")/4)
	local U=rawget(_G,"koUniqueBz")
	if U then for key,v in pairs(U) do if type(key)=="number" and type(v)=="table" then for _,b in pairs(v) do if type(b)=="number" then n=math.max(n,b+50) end end end end end
	for _,v in pairs(SL) do n=math.max(n,20000+(v+1)*50) end
	local nextS=math.max(PRIV_MIN,math.ceil((n-20000)/50))
	local nf=math.max(math.floor(#(readAll(CONFIG.DataPath.."hdgrp.idx") or "")/4),FC.FACE_PRIV_MIN)
	for _,e in pairs(FA) do nf=math.max(nf,e.new+1) end
	for v,_ in string.gmatch(CC.koGenFaceOld or "","(%d+):(%d+)") do nf=math.max(nf,tonumber(v)+1) end
	local function differs(x,y) if not x or not y or #x~=#y then return true end for i=1,#x do if x[i]~=y[i] then return true end end return false end
	local copies,nP,fakeAt={},0,1000000
	local UW,UC=rawget(_G,"koUniqueWar") or {},rawget(_G,"koUniqueCity") or {}
	for _,p in ipairs(P2.people or {}) do
		local m,pid=FC.homeOf(p.key or "")
		if m then
			local key=p.key
			local id,face,nm=FC.personSlots(m,pid)
			local before=#copies
			local a,b,c=FC.baseStat(m,pid)
			if (p.stat or "")==(a..":"..b..":"..c) then ST[key]=nil elseif p.stat then ST[key]=p.stat end
			local function read(tag) local _,cells=unpackCells(readAll(IM.."snap/"..(p.fn or "").."_"..tag..".bin")) return cells end
			if p.face then
				local cells=read("face")
				local target=FA[key] and FA[key].new or face
				if cells and target and target>0 and differs(grpGet(dataPath("hdgrp"),target,1),cells) then
					if not FA[key] and FC.faceShared(face,nm) then target=nf nf=nf+1 FA[key]={raw=face,new=target} end
					copies[#copies+1]={tag="f"..target,at=target,cells=cells,orig=packCells(true,grpGet(dataPath("hdgrp"),target,1) or {""})}
				end
			end
			local slot=SL[key] or id
			local wc=p.war and read("war")
			local cc=p.city and read("city")
			local function curW(s) return UW[s] and grpGet(dataPath("wmap"),20000+s*50,50) or nil end
			local function curC(s) return UC[s] and grpGet(dataPath("smap"),200+(300+s)*4,4) or nil end
			if ((wc and differs(curW(slot),wc)) or (cc and differs(curC(slot),cc))) and not SL[key] and FC.mixedId(m,id,nm) then slot=nextS nextS=nextS+1 SL[key]=slot end
			if wc and differs(curW(slot),wc) then copies[#copies+1]={tag="w"..slot,at=20000+slot*50,cells=wc,orig=packCells(UW[slot] and true or false,grpGet(dataPath("wmap"),20000+slot*50,50) or {})} end
			if cc and differs(curC(slot),cc) then copies[#copies+1]={tag="c"..slot,at=200+(300+slot)*4,cells=cc,orig=packCells(UC[slot] and true or false,grpGet(dataPath("smap"),200+(300+slot)*4,4) or {})} end
			for _,bz in ipairs(p.bz or {}) do
				local cells=read("v"..bz)
				local at=U and type(U[slot])=="table" and U[slot][bz]
				if cells and differs(at and grpGet(dataPath("wmap"),at,50),cells) then fakeAt=fakeAt+50 copies[#copies+1]={tag="v"..slot.."_"..bz,at=fakeAt,cells=cells,orig=""} end
			end
			if #copies>before then nP=nP+1 end
		end
	end
	mkdir(CONFIG.CurrentPath..FC.PSD.."genedit")
	local imp={}
	for _,cp in ipairs(copies) do
		local path=CONFIG.CurrentPath..FC.PSD.."genedit/"..cp.tag..".kgs"
		local orig=cp.orig
		local old=readAll(path)
		if old and string.sub(old,1,4)=="KGS1" and #old>=12 then local ol=u32(old,8) if ol>0 then orig=string.sub(old,13,12+ol) end end   -- 이미 바꾼 칸: 처음 원래 그림 그대로
		writeAll(path,"KGS1"..le32(cp.at)..le32(#orig)..orig..packCells(false,cp.cells))
		if not string.find(CC.koGenEdit or "",","..cp.tag..",",1,true) then CC.koGenEdit=((CC.koGenEdit or "")=="" and "," or CC.koGenEdit)..cp.tag.."," end
		imp[#imp+1]=cp.tag
	end
	if #imp>0 then local o=readAll(CONFIG.CurrentPath..FC.PSD.."genedit/imported.txt") or "" writeAll(CONFIG.CurrentPath..FC.PSD.."genedit/imported.txt",o..table.concat(imp,string.char(10))..string.char(10)) end
	local t={} for k,v in pairs(ST) do t[#t+1]=k..":"..v end table.sort(t) CC.koGenStatAll=K.join(t)
	t={} for k,v in pairs(SL) do t[#t+1]=k..":"..v end table.sort(t) CC.koGenSlotAll=K.join(t)
	t={} for k,v in pairs(FA) do t[#t+1]=k..":"..v.raw..":"..v.new end table.sort(t) CC.koGenFaceAll=K.join(t)
	pcall(K.pull)
	return nP,#imp
end
function FC.packExport(kind)
	if not CONFIG.Windows then msg({"\131\095\131\115\131\095\131\071 \161\164 \129\094\136\107\129\091\131\071\130\098 PC \129\102\131\087\132\086 \140\106\129\076\129\077"}) return end
	local L,lines={},{"PACK={kind="..string.format("%q",kind)..",ver=1}"}
	if kind=="genedit" then
		-- 11-11 사용자 「고침 유무에 상관없이 현재 상태로 내보내기」: 통합 명단 전원의 지금 그림 · 능력치 (FC.snapCollect)
		FC.snapCollect(lines,L)
	else
		local reg=koNewGenList() local n=0
		for id,_ in pairs(reg) do
			n=n+1
			local d=string.format("newgen/%02d/",id)
			for _,nm in ipairs(IMGS) do if readAll(CONFIG.CurrentPath..FC.PSD..d..nm) then L[#L+1]=d..nm.."|"..FC.PSD..d..nm end end
			for bz=0,45 do for _,nm in ipairs({"MOV.bmp","SPC.bmp","ATK.bmp"}) do local r=d.."b"..bz.."/"..nm if readAll(CONFIG.CurrentPath..FC.PSD..r) then L[#L+1]=r.."|"..FC.PSD..r end end end
		end
		if n==0 then msg({"\133\125\133\108\129\111 \131\078\129\073\131\097\129\071 \130\097\129\075\129\076\129\077"}) return end
		lines[#lines+1]="PACK.koNewGen="..string.format("%q",CC.koNewGen or "")
	end
	writeAll(CONFIG.CurrentPath.."ko_pack.lua",table.concat(lines,"\n").."\n")
	table.insert(L,1,"kopack.lua|ko_pack.lua")
	local name=((kind=="genedit") and [[군웅록_장수편집_]] or [[군웅록_신무장_]])..os.date("%Y%m%d_%H%M")..".zip"
	local tz=rawget(_G,"koPackTestZip")   -- (시험: 저장 창 없이 이 경로로)
	local s=FC.zipAsk((tz and ("zipto "..tz) or ("export\n"..name)).."\n"..table.concat(L,"\n"))
	os.remove(CONFIG.CurrentPath.."ko_pack.lua")
	if kind=="genedit" then FC.zipAsk("files\nr "..string.sub(FC.SNAPTMP,1,-2)) end
	if not s then msg({"\131\095\131\115\131\095\131\071\130\104 \129\088 \129\113 \130\097\129\075\129\076\129\077 (ko_sdl.dll \129\071 \140\094 \130\070)"}) return end
	local a,b=string.match(s,"^(%-?%d+)%s*(%d*)")
	if a=="1" then msg({"\131\095\131\115\132\106\129\075\129\076\129\077",(kind=="genedit") and "\131\097\129\113\132\075\134\076 \131\071\133\108\129\083 zip \131\109\132\083 \133\102\131\097\129\080\129\075\129\076\129\077" or "\131\078\129\073\131\097\129\083 zip \131\109\132\083 \133\102\131\097\129\080\129\075\129\076\129\077"})
	elseif a~="0" then msg({"\131\095\131\115\131\095\130\067 \136\102\129\080\129\075\129\076\129\077"}) end
end
function FC.packImport()
	if not CONFIG.Windows then msg({"\131\095\131\115\131\095\131\071 \161\164 \129\094\136\107\129\091\131\071\130\098 PC \129\102\131\087\132\086 \140\106\129\076\129\077"}) return end
	local s=FC.zipAsk("import\n"..(rawget(_G,"koPackTestImport") or ""))   -- (시험: 열기 창 없이 이 파일)
	if not s then msg({"\129\094\136\107\129\091\131\071\130\104 \129\088 \129\113 \130\097\129\075\129\076\129\077 (ko_sdl.dll \129\071 \140\094 \130\070)"}) return end
	local got={} for l in string.gmatch(s,"[^\r\n]+") do got[#got+1]=l end
	if got[1]=="0" then return end
	local function done(t) FC.zipAsk("files\nr ko_import") if t then msg(t) end end
	local IM=CONFIG.CurrentPath.."ko_import/"
	local src=readAll(IM.."kopack.lua")
	local env={} local f=src and load(src,"kopack","t",env)
	if not f or not pcall(f) or type(env.PACK)~="table" then return done({"\130\084\134\093\133\108 \131\097\129\113 \205\131(kopack.lua)\129\071 \129\110\130\096\129\076\129\077"}) end
	local P2=env.PACK
	local ops,nE,nG,skip={},0,0,0
	local K=koGenShare
	if P2.full then   -- 전원 현재 상태 팩
		local np,nt=FC.snapApply(P2,IM)
		nE=np
	elseif P2.koGenEdit then
		-- 따로 받은 조형 칸 · 얼굴 칸 번호를 이 PC 의 빈 번호로
		local smap,fmap={},{}
		local n=math.floor(#(readAll(CONFIG.DataPath.."wmap.idx") or "")/4)
		if rawget(_G,"koUniqueBz") then for key,v in pairs(koUniqueBz) do if type(key)=="number" then for _,b in pairs(v) do n=math.max(n,b+50) end end end end
		for _,v in string.gmatch(CC.koGenSlotAll or "","([^,:]+):(%d+)") do n=math.max(n,20000+(tonumber(v)+1)*50) end
		local nextS=math.max(PRIV_MIN,math.ceil((n-20000)/50))
		for _,v in string.gmatch(P2.koGenSlotAll or "","([^,:]+):(%d+)") do v=tonumber(v) if not smap[v] then smap[v]=nextS nextS=nextS+1 end end
		local nf=math.max(math.floor(#(readAll(CONFIG.DataPath.."hdgrp.idx") or "")/4),FC.FACE_PRIV_MIN)
		for _,_,v in string.gmatch(CC.koGenFaceAll or "","([^,:]+):(%d+):(%d+)") do nf=math.max(nf,tonumber(v)+1) end
		for v,_ in string.gmatch(CC.koGenFaceOld or "","(%d+):(%d+)") do nf=math.max(nf,tonumber(v)+1) end
		local function fm(v) v=tonumber(v) if v<FC.FACE_PRIV_MIN then return v end if not fmap[v] then fmap[v]=nf nf=nf+1 end return fmap[v] end
		local function rt(t)
			local x=tonumber(string.match(t,"^f(%d+)$") or "") if x then return "f"..fm(x) end
			local k2,a=string.match(t,"^([wc])(%d+)$") if k2 then a=tonumber(a) return k2..(smap[a] or a) end
			local a2,b2=string.match(t,"^v(%d+)_(%d+)$") if a2 then a2=tonumber(a2) return "v"..(smap[a2] or a2).."_"..b2 end
			return t
		end
		local function setAll(key,t)   -- 같은 키는 가져온 값으로
			local m={} for _,e in ipairs(t) do m[e[1]]=e[2] end
			local out={}
			for _,e in ipairs(K.entries(CC[key])) do if m[e[1]]==nil then out[#out+1]=e[1]..":"..e[2] end end
			for _,e in ipairs(t) do out[#out+1]=e[1]..":"..e[2] end
			CC[key]=K.join(out)
		end
		local st={} for _,e in ipairs(K.entries(P2.koGenStatAll)) do st[#st+1]=e end setAll("koGenStatAll",st)
		local sl={} for k3,v in string.gmatch(P2.koGenSlotAll or "","([^,:]+):(%d+)") do sl[#sl+1]={k3,tostring(smap[tonumber(v)])} end setAll("koGenSlotAll",sl)
		local fc={} for k3,r,v in string.gmatch(P2.koGenFaceAll or "","([^,:]+):(%d+):(%d+)") do fc[#fc+1]={k3,r..":"..fm(v)} end setAll("koGenFaceAll",fc)
		for v,o in string.gmatch(P2.koGenFaceOld or "","(%d+):(%d+)") do local nv=fm(v) if not string.find(CC.koGenFaceOld or "",","..nv..":",1,true) then CC.koGenFaceOld=((CC.koGenFaceOld or "")=="" and "," or CC.koGenFaceOld)..nv..":"..o.."," end end
		local imp={}
		for t in string.gmatch(P2.koGenEdit or "","[^,]+") do
			local nt=rt(t)
			if not string.find(CC.koGenEdit or "",","..nt..",",1,true) then CC.koGenEdit=((CC.koGenEdit or "")=="" and "," or CC.koGenEdit)..nt.."," end
			if readAll(IM.."genedit/"..t..".kgs") then ops[#ops+1]="c ko_import/genedit/"..t..".kgs|"..FC.PSD.."genedit/"..nt..".kgs" imp[#imp+1]=nt end
			nE=nE+1
		end
		if #imp>0 then mkdir(CONFIG.CurrentPath..FC.PSD.."genedit") local o=readAll(CONFIG.CurrentPath..FC.PSD.."genedit/imported.txt") or "" writeAll(CONFIG.CurrentPath..FC.PSD.."genedit/imported.txt",o..table.concat(imp,string.char(10))..string.char(10)) end
		pcall(K.pull)
	end
	local ngIds={}
	if P2.koNewGen then
		local L=koNewGenList()
		local keep=CC.koNewGen CC.koNewGen=P2.koNewGen local IN=koNewGenList() CC.koNewGen=keep
		for oid,g in pairs(IN) do
			local nid=nil
			for id,h in pairs(L) do if h.name==g.name then nid=id end end
			if not nid then for k=1,NG_MAX do if not L[k] then nid=k break end end end
			if nid then
				g.id=nid L[nid]=g ngIds[#ngIds+1]=nid nG=nG+1
				local od,nd=string.format("newgen/%02d/",oid),string.format("newgen/%02d/",nid)
				ops[#ops+1]="r "..FC.PSD..string.sub(nd,1,-2)
				for _,nm in ipairs(got) do if string.sub(nm,1,#od)==od then ops[#ops+1]="c ko_import/"..nm.."|"..FC.PSD..nd..string.sub(nm,#od+1) end end
			else skip=skip+1 end
		end
		koNewGenSave(L)
	end
	ops[#ops+1]="r ko_import"
	FC.zipAsk("files\n"..table.concat(ops,"\n"))
	for _,id in ipairs(ngIds) do
		if rawget(_G,"koUniqueBz") then koUniqueBz[NG_BASE+id]=nil end
		pcall(koNewGenImport,id,koNewGenSaveDir(id))
	end
	if #ngIds>0 then pcall(koNewGenSync) reload({face=true,war=true,city=true}) end
	if rawget(_G,"koSave") then pcall(koSave) end
	local t={"\129\094\136\107\138\088\129\075\129\076\129\077"}
	if nE>0 then t[#t+1]="\131\097\129\113\132\075\134\076 "..nE.."\134\075 (\131\091\130\079\131\098 \131\097\129\113\132\075\134\076 \129\064\129\065\129\083 \131\118\135\121 \132\085 \131\082\130\083\134\104\129\076\129\077)" end
	if nG>0 then t[#t+1]="\131\078\129\073\131\097 "..nG.."\130\088" end
	if skip>0 then t[#t+1]="\131\078\129\073\131\097 \133\120\129\117\129\094 \130\090\133\120\130\102 "..skip.."\130\088\131\098 \131\069\131\070\129\075\129\076\129\077" end
	if nE==0 and nG==0 then t={"\129\094\136\107\131\105 \131\097\129\113\129\094 \130\097\129\075\129\076\129\077"} end
	msg(t)
end
koGenAsk3=ask3   -- 11-11: saveall(메인 「저장 옮기기」)이 빌려 씀
koGenPackExport,koGenPackImport=FC.packExport,FC.packImport   -- 장수편집 · 신무장 화면 단추(앞쪽 코드)가 부름
koGenPackExportT,koGenPackImportT=FC.packExport,FC.packImport   -- (시험)
-- 11-11: 메인 화면 「장수 관리」 단추 (campsel) = 장수편집 · 신무장 등록 고르기
function koGenManageMenu()
	local c=ask3({"\131\097\129\113 \129\101\129\117","\130\090\136\101 \130\090\133\119\129\094 \137\072\138\095 \131\073\129\076\129\077"},"\131\097\129\113\132\075\134\076","\131\078\129\073\131\097 \133\125\133\108","\129\108\129\109")
	if c==1 then koGenEditScreen() elseif c==2 then koNewGenScreen() end
end
-- 11-11 사용자 「장수 해금도 공용」: 이야기마다 따로인 도감 해금 사본 CC.koBookG(bogam, 1 = 해금 · 2 = 이름 보임)에
--  다른 세 이야기의 해금을 합쳐 넣음(같은 사람 = 통합 명단 키, 동명이인 · 한 이야기만의 무장은 그대로).
--  koBookG 를 읽는 곳(이야기 안 기록 화면 · 무장 각성 표 · 병종 도감 · 정벌 출진 명단)이 모두 공용 해금을 봄. 이야기가 열릴 때마다(타이틀) 다시 합침.
function koBookShareMerge()
	local K=koGenShare
	if not K or not rawget(_G,"koRecBook") then return 0 end
	local cur=K.MODE
	local s=CC.koBookG or ""
	if #s<#koRecBook then s=s..string.rep("0",#koRecBook-#s) end
	local t={} for i=1,#koRecBook do t[i]=tonumber(string.sub(s,i,i)) or 0 end
	local pos={} for i,c in ipairs(koRecBook) do if not pos[c] then pos[c]=i end end
	local n=0
	for _,m in ipairs(K.MODES) do
		if m~=cur then
			local ok,L=pcall(FC.bookList,m)
			local g=K.readSettings(m).koBookG or ""
			if ok and L and g~="" then
				for i,c in ipairs(L) do
					local st=tonumber(string.sub(g,i,i)) or 0
					local key=K.p2k[m][c]
					local p=key and K.k2p[cur][key]
					local j=p and pos[p]
					if st>0 and j then
						local v=t[j]
						local nv=v
						if st%2==1 and nv%2==0 then nv=nv+1 end
						if st>=2 and nv<2 then nv=nv+2 end
						if nv~=v then t[j]=nv n=n+1 end
					end
				end
			end
		end
	end
	if n>0 then
		for i=1,#t do t[i]=tostring(t[i]) end
		CC.koBookG=table.concat(t)
		if rawget(_G,"koSave") then pcall(koSave) end
	end
	return n
end
koOn("title",function() pcall(koBookShareMerge) end)
-- 11-11 사용자 「무술 대회는 네 이야기 무장을 합쳐 이야기 고르기 없이」: 지금 이야기 명단 + 다른 이야기에만 있는 무장(통합 명단 키로 같은 사람은 한 번).
--  다른 이야기 무장은 그 이야기 새 게임 기록을 읽는 임시 칸(JY.Person[100001~], 일기토는 Lua 표만 읽음) — 쓰기는 표에만 남고 대회가 끝나면 지움.
--  얼굴 · 조형 번호(代号) = 그 이야기 PERSON 표, 君主 = 0(내 무장 아님). 능력치는 기록 그대로(이야기마다 같게 맞춰 둔 값).
FC.TOURFAKE={}
function koTourAllCleanup() for id in pairs(FC.TOURFAKE) do rawset(JY.Person,id,nil) end FC.TOURFAKE={} end
function koTourAllRoster(T)
	koTourAllCleanup()
	local K=koGenShare
	if not K or type(T)~="table" then return T end
	local cur=K.MODE
	local out,seen={},{}
	local function keyOf(m,p) return K.p2k[m][p] or (m.."#"..p) end
	for _,p in ipairs(T) do local k=keyOf(cur,p) if not seen[k] then seen[k]=true out[#out+1]=p end end
	local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if #ix<4 then return out end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local base=b1+b2*256+b3*65536+b4*16777216
	local fake=100000
	for _,m in ipairs(K.MODES) do
		if m~=cur then
			local list
			if m=="yeonggeol" then local kc=rawget(_G,"koCamp") rawset(_G,"koCamp",nil) local ok,r=pcall(koTourRoster) rawset(_G,"koCamp",kc) list=ok and r or {}
			else local ok,r=pcall(FC.bookList,m) list=ok and r or {} end
			local ident={}
			if m~="yeonggeol" then for _,e in ipairs(storyRoster(m)) do ident[e[1]]={e[3],e[4]} end end
			local buf=nil
			for _,p in ipairs(list) do
				local k=keyOf(m,p)
				if not seen[k] and p>0 and p<JY.PersonNum then
					seen[k]=true
					if not buf then
						buf=Byte.create(CC.PersonSize*JY.PersonNum)
						Byte.loadfile(buf,CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp",base,CC.PersonSize*JY.PersonNum)
					end
					fake=fake+1
					local off=p*CC.PersonSize
					local t=setmetatable({},{__index=function(_,f) return GetDataFromStruct(buf,off,CC.Person_S,f) end})
					local id=ident[p]
					rawset(t,"\180\250\186\197",id and id[1] or p)   -- 代号 (조형 = 영걸전 번호)
					if id then rawset(t,P.FACE,id[2]) end
					rawset(t,"\190\253\214\247",0)   -- 君主
					rawset(JY.Person,fake,t)
					FC.TOURFAKE[fake]=true
					out[#out+1]=fake
				end
			end
		end
	end
	return out
end
-- 11-11 사용자 「정벌도 이야기 고를 필요 없음」: 출진 · 동료 후보에 다른 이야기에만 있는 무장(그 이야기에서 해금한 무장)도 넣음.
--  고르는 화면은 임시 표(100001~ 무술 대회와 같은 방식), 판을 시작할 때 고른 무장만 인물 칸 761→742(시련 증원 칸 끝쪽)에
--  그 이야기 새 게임 기록을 그대로 옮겨 씀(代号 = 조형, 얼굴 = PERSON 표). 판 기록이 그대로 이어지므로 판 동안 유지. 칸이 모자라면 뺌.
FC.CQSRC={}   -- 임시 번호 → {이야기, 번호}
FC.CQBUF={}
function FC.foreignBuf(m)
	if FC.CQBUF[m]~=nil then return FC.CQBUF[m] end
	local ix=readAll(CONFIG.DataPath.."newgame.idx") or ""
	if #ix<4 then FC.CQBUF[m]=false return false end
	local b1,b2,b3,b4=string.byte(ix,1,4)
	local buf=Byte.create(CC.PersonSize*JY.PersonNum)
	Byte.loadfile(buf,CONFIG.DataPath..((m=="yeonggeol") and "" or ("camp/"..m.."/")).."newgame.grp",b1+b2*256+b3*65536+b4*16777216,CC.PersonSize*JY.PersonNum)
	FC.CQBUF[m]=buf
	return buf
end
function FC.foreignIdent(m,p)
	if m=="yeonggeol" then return p,nil end
	for _,e in ipairs(storyRoster(m)) do if e[1]==p then return e[3],e[4] end end
	return p,nil
end
function koConqForeign()
	for id in pairs(FC.CQSRC) do rawset(JY.Person,id,nil) end
	FC.CQSRC={}
	local K=koGenShare
	if not K then return {} end
	local cur=K.MODE
	local have={}
	for _,p in ipairs(rawget(_G,"koRecBook") or {}) do have[K.p2k[cur][p] or (cur.."#"..p)]=true end
	local out={}
	local fake=200000
	for _,m in ipairs(K.MODES) do
		if m~=cur then
			local ok,L=pcall(FC.bookList,m)
			local g=K.readSettings(m).koBookG or ""
			if ok and L then
				for i,p in ipairs(L) do
					local key=K.p2k[m][p] or (m.."#"..p)
					local st=tonumber(string.sub(g,i,i)) or 0
					if st%2==1 and not have[key] and p>1 and p<JY.PersonNum then
						have[key]=true
						local buf=FC.foreignBuf(m)
						if buf then
							fake=fake+1
							local off=p*CC.PersonSize
							local t=setmetatable({},{__index=function(_,f) return GetDataFromStruct(buf,off,CC.Person_S,f) end})
							local idn,face=FC.foreignIdent(m,p)
							rawset(t,"\180\250\186\197",idn)   -- 代号
							if face then rawset(t,P.FACE,face) end
							rawset(t,"\190\253\214\247",0)   -- 君主
							rawset(JY.Person,fake,t)
							FC.CQSRC[fake]={m,p}
							out[#out+1]=fake
						end
					end
				end
			end
		end
	end
	return out
end
-- 판 시작: 목록의 임시 번호를 예비 칸 번호로 (지금 불러온 기록에 씀). 같은 표를 넘기면 같은 칸
function koConqMaterialize(list)
	local out,used,map={},{},{}
	local free={}
	for q=math.min(761,JY.PersonNum-1),742,-1 do if (JY.Person[q][P.FACE] or 0)==0 and (JY.Person[q]["\190\253\214\247"] or 0)~=1 then free[#free+1]=q end end   -- 시련 증원 칸 끝쪽 20칸(정벌 판 기록에선 빔): 얼굴 0 · 君主 아님. 782~801 은 현상 · 보물 각성 기록이라 안 씀
	for _,id in ipairs(list or {}) do
		local src=FC.CQSRC[id]
		if not src then out[#out+1]=id
		elseif map[id] then out[#out+1]=map[id]
		elseif #free>0 then
			local q=table.remove(free,1)
			local buf=FC.foreignBuf(src[1])
			local off=src[2]*CC.PersonSize
			for k in pairs(CC.Person_S) do local ok,v=pcall(GetDataFromStruct,buf,off,CC.Person_S,k) if ok and v~=nil then pcall(function() JY.Person[q][k]=v end) end end
			local idn,face=FC.foreignIdent(src[1],src[2])
			JY.Person[q]["\180\250\186\197"]=idn
			if face then JY.Person[q][P.FACE]=face end
			JY.Person[q]["\190\253\214\247"]=0
			map[id]=q
			out[#out+1]=q
		end
	end
	return out,map
end
