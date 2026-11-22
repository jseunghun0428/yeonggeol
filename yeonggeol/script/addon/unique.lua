-- ko 4.0 unique sprites (goyu johyeong). The johyeong tool rewrites the lists between the LIST / CITY markers.
-- Battle: a listed person always uses his own 50-cell wmap set at KO_UNIQUE_BASE+pid*50, one colour for every side and class,
-- like the original special sprites in GetPic (a catapult, class 21, keeps the normal catapult sprite).
KO_UNIQUE_BASE=20000
koUniqueWar={
--LIST BEGIN
[7]=true,
[8]=true,
[12]=true,
[14]=true,
[16]=true,
[20]=true,
[21]=true,
[22]=true,
[24]=true,
[26]=true,
[28]=true,
[29]=true,
[32]=true,
[33]=true,
[37]=true,
[38]=true,
[39]=true,
[42]=true,
[44]=true,
[45]=true,
[46]=true,
[47]=true,
[48]=true,
[50]=true,
[51]=true,
[55]=true,
[56]=true,
[57]=true,
[60]=true,
[61]=true,
[62]=true,
[63]=true,
[64]=true,
[65]=true,
[66]=true,
[67]=true,
[69]=true,
[72]=true,
[74]=true,
[75]=true,
[76]=true,
[77]=true,
[78]=true,
[81]=true,
[82]=true,
[83]=true,
[84]=true,
[87]=true,
[88]=true,
[89]=true,
[91]=true,
[92]=true,
[93]=true,
[94]=true,
[95]=true,
[96]=true,
[98]=true,
[101]=true,
[102]=true,
[104]=true,
[106]=true,
[108]=true,
[109]=true,
[110]=true,
[112]=true,
[113]=true,
[114]=true,
[115]=true,
[117]=true,
[120]=true,
[121]=true,
[122]=true,
[123]=true,
[124]=true,
[125]=true,
[130]=true,
[131]=true,
[134]=true,
[136]=true,
[138]=true,
[139]=true,
[140]=true,
[141]=true,
[144]=true,
[145]=true,
[146]=true,
[147]=true,
[148]=true,
[149]=true,
[153]=true,
[157]=true,
[158]=true,
[162]=true,
[165]=true,
[166]=true,
[167]=true,
[169]=true,
[171]=true,
[172]=true,
[173]=true,
[174]=true,
[175]=true,
[176]=true,
[177]=true,
[178]=true,
[179]=true,
[180]=true,
[181]=true,
[182]=true,
[183]=true,
[184]=true,
[188]=true,
[189]=true,
[191]=true,
[193]=true,
[195]=true,
[197]=true,
[198]=true,
[199]=true,
[200]=true,
[201]=true,
[202]=true,
[203]=true,
[206]=true,
[208]=true,
[209]=true,
[210]=true,
[211]=true,
[212]=true,
[213]=true,
[215]=true,
[217]=true,
[218]=true,
[221]=true,
[222]=true,
[223]=true,
[224]=true,
[228]=true,
[229]=true,
[239]=true,
[242]=true,
[248]=true,
[249]=true,
[250]=true,
[251]=true,
[252]=true,
[254]=true,
[255]=true,
[352]=true,
[376]=true,
[378]=true,
[391]=true,
[392]=true,
[393]=true,
[394]=true,
[395]=true,
[396]=true,
[402]=true,
[416]=true,
[417]=true,
[418]=true,
--LIST END
}
-- ko 5.0 (10-13, user: 장수편집 battle sprites class by class): koUniqueBz[pid][class] = the first wmap cell of a 50-cell set
-- that person uses while he has that class (several classes may share one set). koUniqueBz.free = sets no class uses any
-- more (reused first). A class with no set of its own falls back to the common unique set (koUniqueWar), then to the
-- original sprite (the catapult, class 21, too). The 장수편집 screen (newgen addon) rewrites the lines between the BZ markers.
koUniqueBz={
--BZ BEGIN
[210]={[21]=50600},
--BZ END
}
local SPR="\213\189\182\183\182\175\215\247"  -- battle sprite field
local BZ="\177\248\214\214"                   -- class field
-- koU16: the battle sprite field is a signed 16-bit slot, so for person 256 and later 20000+pid*50 passed 32767
-- and read back negative (blank or old sprite on screens that read the field). Read and write it unsigned.
CC.Person_S[SPR][2]=1
-- 10-13 (user: room for every general's class sets): the engine draws wmap cells far past 65535 (tried 600000 on Windows;
-- the Android engine sizes its tables from the file), but the person record keeps the sprite number in 2 bytes. A number
-- past 65535 is kept here in Lua beside the record (for the person data now loaded) and the record itself gets the
-- sprite the person would show without his class set (KO_SPR_FALLBACK), so a save never holds a cut-off number;
-- GetPic sets the big one again whenever it runs.
local koGDS,koSDS=GetDataFromStruct,SetDataFromStruct
local koBig,koBigData={},nil
KO_SPR_FALLBACK=0
function SetDataFromStruct(data,offset,t_struct,key,v)
if key==SPR and t_struct==CC.Person_S then
if koBigData~=data then koBig={} koBigData=data end
if type(v)=="number" and v>65535 then koBig[offset]=v return koSDS(data,offset,t_struct,key,KO_SPR_FALLBACK or 0) end
koBig[offset]=nil
end
return koSDS(data,offset,t_struct,key,v)
end
function GetDataFromStruct(data,offset,t_struct,key)
if key==SPR and data==koBigData then local b=koBig[offset] if b then return b end end
return koGDS(data,offset,t_struct,key)
end
-- koTav: tavern generals (person 421 and later) are copies of another record (HirePerson copies the name, portrait
-- and stats), so a copy that is not listed itself uses the set of the listed person with the same name and portrait.
local NM="\208\213\195\251"                   -- name field
local FACE="\205\183\207\241\180\250\186\197" -- portrait field
local function koUniqueSrc(pid)
local ps=rawget(_G,"koGenPrivSlot") local pv=ps and ps(pid)--ko 11-08: a story officer's own slot (newgen, officers who borrow a slot shared by other names)
if pv and koUniqueWar[pv] then return pv end
local f=rawget(_G,"koWujeIdentity") local id=f and f(pid)
if id and id~=pid then return koUniqueWar[id] and id or nil end
if koUniqueWar[pid] then return pid end
if pid<=420 then return nil end
local p=JY.Person[pid]
if not p then return nil end
-- koUniqueKey (10-11): with 150+ listed persons the old scan of the whole list per call was slow; look up name+portrait
local key=tostring(p[NM])..":"..tostring(p[FACE])
local UK=rawget(_G,"koUniqueKey")
if not UK then
UK={} rawset(_G,"koUniqueKey",UK)
for s in pairs(koUniqueWar) do
local q=s<=420 and JY.Person[s]
if q then UK[tostring(q[NM])..":"..tostring(q[FACE])]=s end
end
end
return UK[key]
end
-- 10-13: the set of this person (or of the listed person a tavern copy stands for) for class bz, or nil
function koUniqueBzPic(pid,bz)
bz=bz or JY.Person[pid][BZ]
local ps=rawget(_G,"koGenPrivSlot") local pv=ps and ps(pid)--ko 11-08: own slot first; with an own common set the shared slot's class sets are not his
if pv then local t=koUniqueBz[pv] if t and t[bz] then return t[bz] end if koUniqueWar[pv] then return nil end end
local f=rawget(_G,"koWujeIdentity") local id=(f and f(pid)) or pid
local t=koUniqueBz[id]
if not t and pid>420 then
local p=JY.Person[pid]
local key=tostring(p[NM])..":"..tostring(p[FACE])
for s,v in pairs(koUniqueBz) do local q=type(s)=="number" and s<=420 and JY.Person[s] if q and tostring(q[NM])..":"..tostring(q[FACE])==key then t=v break end end
end
return t and t[bz] or nil
end
local koGetPicBase=GetPic
function GetPic(pid,enemy,friend)
local r=koGetPicBase(pid,enemy,friend)
local bz=JY.Person[pid][BZ]
local cb=koUniqueBzPic(pid,bz)
local src=koUniqueSrc(pid)
if cb then
KO_SPR_FALLBACK=(src and bz~=21) and (KO_UNIQUE_BASE+src*50) or r-- 10-13: what the record keeps when cb is past 65535
r=cb
JY.Person[pid][SPR]=r
elseif src and bz~=21 then
r=KO_UNIQUE_BASE+src*50
JY.Person[pid][SPR]=r
end
return r
end
-- City: a listed person is drawn with city figure KO_CITY_BASE+pid (smap 200+(KO_CITY_BASE+pid)*4, 4 directions).
-- The figure field is swapped only while DrawSMap runs, so saves keep the original number.
KO_CITY_BASE=300
koUniqueCity={
--CITY BEGIN
[8]=true,
[27]=true,
[55]=true,
[66]=true,
[72]=true,
[78]=true,
[89]=true,
[92]=true,
[259]=true,
[260]=true,
[261]=true,
[311]=true,
[312]=true,
[313]=true,
[355]=true,
[356]=true,
[357]=true,
[358]=true,
[365]=true,
[366]=true,
[367]=true,
[368]=true,
[369]=true,
[370]=true,
[375]=true,
[384]=true,
[391]=true,
[392]=true,
[393]=true,
[394]=true,
[395]=true,
[396]=true,
[416]=true,
[417]=true,
[418]=true,
--CITY END
}
local XS="\208\206\207\243"                   -- city figure field
local koDrawSMapBase=DrawSMap
function DrawSMap()
local keep={}
local koWI,koCF,koPS=rawget(_G,"koWujeIdentity"),rawget(_G,"koWujeCityFigure"),rawget(_G,"koGenPrivSlot")--ko 6.0 campaigns: any person may stand for a listed one
if koWI or koCF then
for pid=1,JY.PersonNum-1 do
local p=JY.Person[pid]
local id=(koWI and koWI(pid)) or pid
local fig=koCF and koCF(pid)
local pv=koPS and koPS(pid)
if p and pv and koUniqueCity[pv] then keep[pid]=p[XS] p[XS]=KO_CITY_BASE+pv--ko 11-08: own city slot
elseif p and koUniqueCity[id] and (not CONFIG.koCamp or string.find(CC.koGenEdit or "",",c"..id..",",1,true)) then keep[pid]=p[XS] p[XS]=KO_CITY_BASE+id--ko 6.0: a story's own genedit city sprite first
elseif p and fig then keep[pid]=p[XS] p[XS]=fig
elseif p and koUniqueCity[id] then keep[pid]=p[XS] p[XS]=KO_CITY_BASE+id end
end
else
for pid in pairs(koUniqueCity) do
local p=JY.Person[pid]
if p then keep[pid]=p[XS] p[XS]=KO_CITY_BASE+pid end
end
end
local ok,err=pcall(koDrawSMapBase)
for pid,v in pairs(keep) do JY.Person[pid][XS]=v end
if not ok then error(err,0) end
end
