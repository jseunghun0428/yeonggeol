-- Campaign data adapters around the original 6.0 town implementation.
local LOC="\207\214\212\218\181\216"
local NAME="\208\213\195\251"
local FACE="\205\183\207\241\180\250\186\197"
local FIG="\208\206\207\243"
local NPC={{311,"\131\076\130\126",1219,197},{312,"\131\076\130\126",1219,197},{313,"\131\076\130\126",1219,197},{345,"\136\077\130\101",1225,195},{346,"\136\077\130\101",1225,195},{347,"\136\077\130\101",1225,195},{348,"\136\077\130\101",1225,195},{354,"\129\101\129\117",1233,183},{355,"\136\078\136\077",1226,192},{356,"\136\078\136\077",1226,192},{357,"\129\067\129\106",1232,162},{358,"\129\067\129\106",1232,163},{359,"\131\118\131\091\132\112",1214,193},{360,"\131\118\131\091\132\112",1214,193},{361,"\129\098\133\120",1229,154},{362,"\129\098\133\120",1229,155},{367,"\133\090\129\101",1221,185},{368,"\133\090\129\101",1221,185},{369,"\129\073\129\101",1222,170},{370,"\129\073\129\101",1222,170},{371,"\130\094\129\106",1230,152},{372,"\129\109\136\081",1231,195},{375,"\129\068\130\119\129\067",1232,162},{381,"\130\108\133\120",1228,194}}
local ALIAS={["\134\110\131\123"]="\134\110",["\131\071\130\075"]="\134\110",["\135\109\129\068"]="\135\109\134\103",["\134\108\131\123"]="\134\108",["\129\079\131\123"]="\129\109\129\079",["\133\103\130\084"]="\130\073\142\083"}
local function canon(s) return ALIAS[s] or s end
function koWujeNativeTownContext()
 if not koWujeCampaignActive() then return nil end
 local home=canon(koWujeTownFacts())
 local data=koWujeNativeTownModels()
 local preferred=JY.EventID<130 and 133 or JY.EventID<214 and 134 or JY.EventID<299 and 135 or 136
 local best,score
 for _,c in pairs(data) do
  if c.towns[home] then
   local d=math.abs(c.region.pic-preferred)*10+c.region.pic/1000
   if not score or d<score then best,score=c,d end
  end
 end
 if best then return best,home end
end
function koWujeNativeTownKnown(name)
 local home,places=koWujeTownFacts()
 if canon(name)==canon(home) then return true end
 for _,p in ipairs(places) do if p[2]<=JY.EventID and canon(p[1])==canon(name) then return true end end
 return rawget(_G,"koWujeTownPreview") and (name=="\132\089\134\111" or name=="\135\109\134\103") or false
end
local visit=koTownVisit
function koTownVisit(...)
 if not koWujeCampaignActive() then return visit(...) end
 -- Town actors are temporary views; source scenario characters own these physical slots.
 local old={} local mask={}
 for _,n in ipairs(NPC) do
  mask[n[1]]=true
  local p=JY.Person[n[1]]
  old[#old+1]={p,p[NAME],p[FACE],p[FIG]}
  p[NAME],p[FACE],p[FIG]=n[2],n[3],n[4]
 end
 rawset(_G,"koWujeTownNPC",mask)
 local loc,room=JY.Base[LOC],SnrRoom
 local _,home=koWujeNativeTownContext()
 JY.Base[LOC]=home or loc
 local ok,err=pcall(visit,...)
 rawset(_G,"koWujeTownNPC",nil)
 for _,n in ipairs(old) do n[1][NAME],n[1][FACE],n[1][FIG]=n[2],n[3],n[4] end
 JY.Base[LOC],SnrRoom=loc,room
 if not ok then error(err,0) end
 DrawSMap() ShowScreen()
end
local fallback=koWujeTownVisit
function koWujeTownVisit(preview)
 local c=koWujeNativeTownContext()
 if not c then return fallback(preview) end
 rawset(_G,"koWujeTownPreview",preview or nil)
 local ok,err=pcall(koTownVisit)
 rawset(_G,"koWujeTownPreview",nil)
 if not ok then error(err,0) end
end
