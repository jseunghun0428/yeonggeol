-- Full Wu Di Zhuan campaign integration. All files belong to this standalone campaign copy.
local MAPBASE=0
local PERSON={{1,11,1077,99},{2,2,1001,6},{3,61,1128,141},{4,4,1136,127},{5,5,1148,119},{6,6,1138,134},{7,7,1137,132},{8,142,1079,134},{9,9,1027,202},{10,10,1110,216},{11,95,1174,25},{12,12,1144,136},{13,89,1158,134},{14,2,1001,6},{15,3,1002,218},{16,16,1189,153},{17,17,1028,204},{18,18,1029,7},{19,19,1030,3},{20,20,1031,4},{21,21,1139,102},{22,22,1140,134},{23,23,1056,134},{24,24,1161,104},{25,38,1063,104},{26,245,1142,141},{27,113,1176,134},{28,49,1143,130},{29,118,1198,141},{30,30,1064,53},{31,92,1116,153},{32,181,1073,76},{33,119,1199,141},{34,34,1016,44},{35,73,1150,123},{36,66,1017,102},{37,37,1180,25},{38,32,1183,134},{39,39,1147,134},{40,153,1045,134},{41,257,1215,134},{42,42,1121,100},{43,43,1145,25},{44,44,1211,54},{45,128,1019,207},{46,224,1170,48},{47,47,1141,48},{48,48,1142,129},{49,111,1131,104},{50,50,1113,104},{51,120,1175,102},{52,52,1111,141},{53,170,1006,36},{54,148,1084,206},{55,131,1181,141},{56,56,1123,48},{57,105,1126,134},{58,45,1088,94},{59,14,1078,98},{60,230,1208,48},{61,123,1180,134},{62,62,1034,22},{63,63,1039,12},{64,160,1099,104},{65,186,1104,102},{66,140,1135,104},{67,67,1165,134},{68,68,1037,215},{69,69,1032,20},{70,70,1146,137},{71,226,1155,134},{72,72,1156,102},{73,205,1191,153},{74,106,1127,48},{75,75,1152,134},{76,193,1163,48},{77,77,1033,24},{78,78,1035,25},{79,79,1038,13},{80,80,1036,2},{81,150,1085,214},{82,76,1149,134},{83,34,1016,48},{84,84,1100,134},{85,169,1047,48},{86,72,1156,48},{87,249,1160,134},{88,256,1179,104},{89,72,1156,134},{90,81,1153,122},{91,91,1089,134},{92,115,1177,64},{93,104,1125,141},{94,94,1042,23},{95,67,1165,153},{96,176,1068,76},{97,97,1044,102},{98,98,1185,138},{99,134,1182,153},{100,59,1060,134},{101,101,1057,18},{102,89,1158,134},{103,122,1179,27},{104,185,1103,134},{105,154,1046,134},{106,113,1176,134},{107,75,1152,153},{108,108,1154,141},{109,117,1018,141},{110,103,1117,8},{111,111,1131,25},{112,144,1086,78},{113,64,1012,40},{114,136,1058,141},{115,402,108,54},{116,116,1041,9},{117,117,1018,45},{118,118,1198,141},{119,35,1216,141},{120,155,1020,217},{121,121,1178,25},{122,37,1180,25},{123,191,1061,65},{124,184,1076,141},{125,257,1215,48},{126,143,1080,219},{127,149,1083,80},{128,46,1179,134},{129,129,1062,134},{130,130,1051,141},{131,200,1171,61},{132,132,1184,153},{133,146,1082,79},{134,378,1207,104},{135,247,1130,48},{136,33,1182,153},{137,58,1120,153},{138,114,1011,39},{139,253,1196,153},{140,140,1135,141},{141,179,1071,76},{142,1,1000,32},{143,126,1004,35},{144,133,1008,212},{145,175,1025,49},{146,188,1009,38},{147,147,1057,102},{148,54,1003,220},{149,127,1007,37},{150,162,1101,87},{151,112,1005,151},{152,137,1065,48},{153,153,1045,134},{154,38,1063,153},{155,173,1061,134},{156,65,1013,41},{157,82,1014,48},{158,8,1195,76},{159,83,1015,43},{160,53,1112,141},{161,91,1089,134},{162,140,1135,141},{163,190,1186,210},{164,139,1134,141},{165,254,1106,48},{166,24,1161,134},{167,35,1216,52},{168,178,1070,25},{169,169,1047,104},{170,185,1103,134},{171,171,1049,141},{172,172,1048,153},{173,173,1061,134},{174,93,1115,104},{175,145,1081,88},{176,32,1183,102},{177,71,1157,141},{178,185,1103,134},{179,209,1024,134},{180,208,1022,134},{181,204,1187,211},{182,108,1154,141},{183,182,1074,102},{184,184,1076,141},{185,31,1026,50},{186,59,1060,25},{187,157,1096,104},{188,151,1087,209},{189,246,1141,134},{190,26,1108,134},{191,154,1046,134},{192,192,1162,104},{193,193,1163,104},{194,249,1160,134},{195,67,1165,134},{196,106,1127,48},{197,24,1161,134},{198,411,162,154},{199,412,163,155},{200,158,1097,153},{201,159,1098,102},{202,147,1057,102},{203,37,1180,25},{204,174,1094,82},{205,194,1164,134},{206,217,1197,134},{207,90,1054,102},{208,138,1133,102},{209,410,212,152},{210,210,1050,134},{211,211,1052,134},{212,212,1053,5},{213,213,1067,14},{214,214,1066,213},{215,215,1205,134},{216,216,1188,10},{217,250,1193,102},{218,218,1040,134},{219,206,1192,141},{220,8,1195,76},{221,15,1170,91},{222,19,1030,3},{223,201,1172,48},{224,202,1173,134},{225,72,1156,134},{226,392,141,104},{227,227,1218,48},{228,228,1143,141},{229,168,1093,89},{230,230,1208,48},{231,11,1077,48},{232,108,1069,141},{233,86,1155,102},{234,26,1108,134},{235,192,1162,104},{236,163,1102,86},{237,41,1194,134},{238,40,1055,134},{239,239,1204,159},{240,240,1201,134},{241,241,1163,104},{242,242,1077,134},{243,243,1095,141},{244,244,1021,69},{245,198,1168,134},{246,37,1180,134},{247,247,1130,48},{248,156,1095,102},{249,249,1160,134},{250,36,1181,104},{251,251,1043,150},{252,252,1119,48},{253,253,1196,67},{254,165,1090,96},{255,166,1091,83},{256,167,1092,134},{257,257,1215,175},{258,257,1215,175},{259,257,1215,175},{260,257,1215,175},{261,257,1215,175},{262,257,1215,175},{263,257,1215,175},{264,257,1215,175},{265,257,1215,175},{266,257,1215,175},{267,257,1215,175},{268,257,1215,175},{269,257,1215,175},{270,257,1215,175},{271,257,1215,175},{272,257,1215,175},{273,257,1215,175},{274,257,1215,175},{275,275,1210,171},{276,275,1210,171},{277,275,1210,171},{278,275,1210,171},{279,275,1210,171},{280,275,1210,171},{281,275,1210,171},{282,275,1210,171},{283,275,1210,171},{284,275,1210,171},{285,363,1223,184},{286,363,1223,184},{287,363,1223,184},{288,363,1223,184},{289,363,1223,184},{290,363,1223,184},{291,363,1223,184},{292,363,1223,184},{293,293,1212,173},{294,293,1212,173},{295,293,1212,173},{296,293,1212,173},{297,293,1212,173},{298,293,1212,173},{299,293,1212,173},{300,293,1212,173},{301,293,1212,173},{302,293,1212,173},{303,46,1179,134},{304,46,1179,134},{305,46,1179,134},{306,46,1179,134},{307,46,1179,134},{308,46,1179,134},{309,46,1179,134},{310,46,1179,134},{311,311,1219,197},{312,311,1219,197},{313,311,1219,197},{314,311,1219,197},{315,311,1219,197},{316,311,1219,197},{317,311,1219,197},{318,311,1219,197},{319,311,1219,197},{320,311,1219,197},{321,311,1219,197},{322,311,1219,197},{323,365,1220,181},{324,365,1220,181},{325,365,1220,181},{326,365,1220,181},{327,365,1220,181},{328,365,1220,181},{329,329,1202,163},{330,329,1202,163},{331,329,1202,163},{332,329,1202,163},{333,333,1217,181},{334,333,1217,181},{335,335,1236,157},{336,335,1236,157},{337,337,1209,0},{338,337,1209,0},{339,337,1209,0},{340,337,1209,0},{341,208,1022,134},{342,208,1022,134},{343,208,1022,134},{344,208,1022,134},{345,345,1225,195},{346,345,1225,195},{347,345,1225,195},{348,345,1225,195},{349,329,1202,163},{350,329,1202,163},{351,329,1202,163},{352,329,1202,163},{353,353,1234,17},{354,354,1233,183},{355,355,1226,192},{356,355,1226,192},{357,357,1232,162},{358,357,1232,162},{359,359,1214,193},{360,359,1214,193},{361,361,1229,154},{362,361,1229,154},{363,363,1223,184},{364,363,1223,184},{365,365,1220,181},{366,365,1220,181},{367,367,1221,185},{368,367,1221,185},{369,369,1222,170},{370,369,1222,170},{371,371,1230,152},{372,372,1231,195},{373,245,1142,141},{374,147,1057,102},{375,27,1190,134},{376,189,1159,160},{377,205,1191,25},{378,33,1182,104},{379,176,1068,76},{380,217,1197,134},{381,142,1079,134},{382,163,1102,86},{383,383,1237,149},{531,359,1214,193}}
local EV="\202\194\188\254"
local NAME="\208\213\195\251"
local LORD="\190\253\214\247"
local FACE="\205\183\207\241\180\250\186\197"
local SHAPE="\208\206\207\243"
local IDENT="\180\250\186\197"
local SHOP="\129\068\130\119\129\067"
local active=false
local finalTestSettings=nil
local firstTestStop=false
local visual={}
for _,p in ipairs(PERSON) do visual[p[1]]=p[2] end
function koWujeIdentity(pid)
 local town=rawget(_G,"koWujeTownNPC")
 if town and town[pid] then return pid end
 return visual[pid]
end
local function trace(s)
 local f=io.open(CONFIG.CurrentPath.."sonjian_campaign.log","a")
 if f then f:write(os.date("%Y-%m-%d %H:%M:%S").." "..s.."\n") f:close() end
end
local function repairVisuals()
 for _,p in ipairs(PERSON) do
  local who=JY.Person[p[1]]
  who[IDENT]=p[1] who[FACE]=p[3] who[SHAPE]=p[4]
 end
end
local function configure()
 active=true CC.koReplay=nil CC.koFree=nil CC.Enhancement=true
 if (JY.Base[SHOP] or 0)<1 then JY.Base[SHOP]=1 end
 repairVisuals()
 -- Saved sprite IDs can still refer to the old unconditional personal set.
 for _,p in ipairs(PERSON) do if JY.Person[p[1]][LORD]==1 then GetPic(p[1]) end end
end
local function campaign() return active and JY.Base and JY.Base[EV.."1985"]==6202 end
function koWujeCampaignActive() return campaign() end
local fixedBZ=koFixedBZ
function koFixedBZ(pid) if active and pid<=383 then return false end return fixedBZ(pid) end

dofile(CONFIG.koCampScript.."campaign/runtime.lua")
dofile(CONFIG.koCampScript.."campaign/story.lua")
dofile(CONFIG.koCampScript.."campaign/city_layout.lua")
dofile(CONFIG.koCampScript.."campaign/town.lua")
dofile(CONFIG.koCampScript.."campaign/town_bridge.lua")
dofile(CONFIG.koCampScript.."campaign/native_ids.lua")
-- ko 11-06: calculated furniture-safe campaign movement.
dofile(CONFIG.koCampScript.."campaign/calculated_routes.lua").install()

-- Primitive-only, campaign-owned state. A companion file uses exactly the same slot as its .sav.
local function serialize(v)
 local t=type(v)
 if t=="nil" then return "nil" elseif t=="number" or t=="boolean" then return tostring(v)
 elseif t=="string" then return string.format("%q",v)
 elseif t=="table" then
  local a={"{"}
  for k,x in pairs(v) do a[#a+1]="["..serialize(k).."]="..serialize(x).."," end
  a[#a+1]="}" return table.concat(a)
 end
 return "nil"
end
local function sidecar(id) return CC.R_GRPFilename[id]..".sj.lua" end
-- Native automatic-checkpoint rotation copies .sav files; rotate their event state with them.
local copy=copyfile
function copyfile(from,to)
 local ok=copy(from,to)
 if ok and campaign() and type(from)=="string" and type(to)=="string" and from:match("%.sav$") and to:match("%.sav$") then
  local f=io.open(from..".sj.lua","r")
  if f then
   f:close()
   if not copy(from..".sj.lua",to..".sj.lua") then error("Cannot rotate campaign state: "..to) end
  else os.remove(to..".sj.lua") end
 end
 return ok
end
local save=SaveRecord
local nativeWarSave=WarSave
function WarSave(...)
 if rawget(_G,"koWujeSystemTest") then return false end
 return nativeWarSave(...)
end
function SaveRecord(id)
 if rawget(_G,"koWujeSystemTest") then return false end
 local ok=save(id)
 if ok and campaign() and id>0 then
  local scene={}
  for _,u in ipairs(JY.Smap) do scene[#scene+1]={u[1],u[2],u[3],u[4],0} end
  local state={version=2,event=JY.EventID,room=SnrRoom,choice=SnrChoiceResult,pending=SnrW,
   building=SnrBld,scene=scene,layout=koWujeCityState(),
   once=War and War.koSnrOnce or {},noauto=War and War.koSnrNoAuto or false,
   objectivePending=War and War.koSnrPend or false,
   cls=rawget(_G,"koWujeClassDone") and koWujeClassDone() or nil}
  local f=io.open(sidecar(id),"w")
  if not f then error("Cannot save campaign state: "..sidecar(id)) end
  f:write("return "..serialize(state)) f:close()
 end
 return ok
end
local load=LoadRecord
function LoadRecord(id,...)
 -- 11-16 (cafe report, 1.0.34: Guo Jia made a sorcerer turns back into a swordsman): read the remembered class moves before
 --  the inner loaders run, so the spriteclass addon (load-time sprite class fit) can leave an ally that was already moved alone
 --  (a save whose state file has no remembered moves - made before 1.0.22, or a battle restart copied from a .rws without its state
 --  file - used to clear the memory, so the move ran again on every such load: below, the allies of that save count as moved)
 local cls0=nil
 if id and id>0 then local ok0,st0=pcall(dofile,sidecar(id)) if ok0 and type(st0)=="table" and type(st0.cls)=="table" then cls0=st0.cls end end
 if cls0 and rawget(_G,"koWujeClassDone") then koWujeClassDone(cls0) end
 local r=load(id,...)
 if id==0 then
  if rawget(_G,"koWujeClassDone") then koWujeClassDone({}) end
  active=false SnrRoom=0 SnrChoiceResult=0 SnrW={} SnrBld=0
 elseif JY.Base and JY.Base[EV.."1985"]==6202 then
  if rawget(_G,"koWujeClassDone") then
   if not cls0 then cls0={} for p=1,JY.PersonNum-1 do if JY.Person[p][LORD]==1 then cls0[p]=true end end end
   koWujeClassDone(cls0)
  end
  configure()
  local ok,st=pcall(dofile,sidecar(id))
  local restored=false
  if ok and type(st)=="table" and (st.version==1 or st.version==2) and (not st.event or st.event==JY.EventID) then
   SnrRoom=st.room or JY.SubScene SnrChoiceResult=st.choice or 0 SnrW=st.pending or {}
   SnrBld=st.building or 0
   if st.version==2 then
    if JY.Status~=GAME_WMAP and JY.Status~=GAME_WARWIN and JY.Status~=GAME_WARLOSE and type(st.scene)=="table" then
     local valid=#st.scene==#JY.Smap local loaded={}
     for _,u in ipairs(JY.Smap) do loaded[u[1]]=true end
     for _,u in ipairs(st.scene) do
      if type(u)~="table" or not loaded[u[1]] or type(u[2])~="number" or type(u[3])~="number" or type(u[4])~="number" then valid=false break end
      loaded[u[1]]=nil
     end
     if valid then JY.Smap=st.scene restored=koWujeCityRestore(st.layout) end
    end
    if War then War.koSnrNoAuto=st.noauto or nil War.koSnrPend=st.objectivePending or nil end
   end
   if War then War.koSnrOnce=st.once or {} end
  else SnrRoom=JY.SubScene SnrChoiceResult=0 SnrW={} SnrBld=0 end
  if JY.SubScene and JY.SubScene>0 and not restored then koWujeCityRepair(true) end
  if JY.Status==GAME_WMAP or JY.Status==GAME_WARWIN or JY.Status==GAME_WARLOSE then
   koWarRes(true) koWarLayout()
   DrawWarMap()
  else DrawSMap() end
  ShowScreen()
  trace("LOAD slot="..id.." event="..tostring(JY.EventID))
 end
 return r
end
local function start()
 LoadRecord(0)
 JY.Base[EV.."1985"]=6202
 JY.Base["\211\206\207\183\196\163\202\189"]=1
 JY.Base["\206\222\211\1955"]=0
 JY.Person[1]["\195\216\188\1881"]=0
 JY.Person[1]["\183\220\213\189"]=0
 koSetGold(0)
 configure()
 for i=1,JY.PersonNum-1 do GetPic(i) end
 JY.Smap={} JY.SubScene=-1 JY.EventID=1 JY.Status=GAME_SMAP_AUTO
 trace("START full campaign")
end
local nativeSettingsSave=koSave
function koSave(...)
 if rawget(_G,"koWujeSystemTest") then return end
 return nativeSettingsSave(...)
end
-- Keep the native title renderer and all registered officer/tournament/codex entries.
local departureTestStop=false
local function previewDeparture()
 finalTestSettings={}
 for _,entry in ipairs(koAddon.saveKeys) do finalTestSettings[#finalTestSettings+1]={entry.key,CC[entry.key]} end
 rawset(_G,"koWujeSystemTest",true)
 start()
 koSetGold(700)
 for _,pid in ipairs({1,59,58,221,228}) do
  ModifyForce(pid,1) ReSetAttrib(pid,true) GetPic(pid)
 end
 JY.Smap={} SnrRoom=95 JY.SubScene=95
 SnrAdd(1,25,9,1)
 SnrAdd(59,11,10,3)
 SnrAdd(58,5,13,3)
 SnrAdd(221,23,16,2)
 SnrAdd(228,17,19,2)
 SnrAdd(375,15,18,0)
 JY.EventID=5 JY.Status=GAME_SMAP_MANUAL
 SetSceneID(95)
 departureTestStop=true
 DrawMulitStrBox("\133\098\129\103 \130\066\134\073 \129\105\129\106\132\111 \129\082\130\086 \129\081\129\082\129\104\129\076\129\077.*\129\070\131\115\129\083 \141\083\133\101 \133\098\129\103\129\083 \133\109\133\110\129\066 \130\075\131\111\129\090.*\130\125\131\080\131\097 \130\095\130\114\130\094\131\104 \130\066\131\097\129\123 \129\116\129\117\129\118\129\119 \133\113\130\086\129\089\130\067 \129\105\129\106\129\097\130\086\129\065 \140\106\129\076\129\077. \133\102\131\097\131\098 \129\097\130\067 \130\107\129\075\129\076\129\077.")
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\133\098\129\103 \130\066\134\073 \129\105\129\106",group="\129\105\129\106",run=previewDeparture}
koOn("title",function() departureTestStop=false end)

local nativeTitle=koTitleMenu
local function firstBattleTest()
 finalTestSettings={}
 for _,entry in ipairs(koAddon.saveKeys) do finalTestSettings[#finalTestSettings+1]={entry.key,CC[entry.key]} end
 rawset(_G,"koWujeSystemTest",true)
 start()
 for _,pid in ipairs({1,59,58,221,228}) do
  JY.Person[pid][LORD]=1 JY.Person[pid]["\181\200\188\182"]=5
  ReSetAttrib(pid,true) GetPic(pid)
 end
 koSetGold(1000)
 SnrSetAllies(30,5,{0,18,0,3,0,-1,0,58,17,0,3,0,-1,0,57,19,0,3,0,-1,0,220,19,1,3,0,-1,0,227,18,1,3,0,-1,0})
 JY.EventID=6 JY.Status=GAME_SMAP_AUTO
 firstTestStop=true
 DrawMulitStrBox("\135\089\134\084\130\066 \137\112 \130\066\132\101 \129\105\129\106\132\111\129\104\129\076\129\077. \135\089\134\084\161\164\129\111\135\105\161\164\129\070\131\115\161\164\130\085\134\075\161\164\129\118\129\073\130\104 5\130\082\130\123\132\083 \131\101\130\080\129\080\129\075\129\076\129\077.*\131\097\130\114 \130\066\132\101\131\080 \130\067\129\068, \134\099\132\081, \130\095\129\064\135\122 \129\116\129\117 \133\067 \129\103\130\093\129\083 \129\105\129\106\129\066 \130\075\131\111\129\090.*\131\071\134\079 \133\102\131\097\129\102\130\098 \131\071\133\108\129\097\130\067 \130\107\129\075\129\076\129\077.")
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\135\089\134\084\130\066 \137\112 \130\066\132\101 \129\105\129\106",group="\129\105\129\106",run=firstBattleTest}
dofile(CONFIG.koCampScript.."campaign/hall_preview.lua")(start,function()
 active=false firstTestStop=false
 JY.Smap={} SnrRoom=0 JY.SubScene=-1 JY.Status=GAME_START
end)
function koTitleMenu(menu,n,...)
 -- The original story-view entry addresses Liu Bei's event graph; this campaign has its own story.
 local storyRow=6+#koAddon.titleMenu
 if menu[storyRow] then menu[storyRow][3]=0 end
 local r=nativeTitle(menu,n,...)
 if r==1 then start() return 0 end
 return r
end
koOn("title",function()
 active=false
 firstTestStop=false
 if finalTestSettings then
  for _,entry in ipairs(finalTestSettings) do CC[entry[1]]=entry[2] end
  finalTestSettings=nil rawset(_G,"koWujeSystemTest",nil)
 end
end)

local startWar=SnrStartWar
function SnrStartWar(map,name,...)
 startWar(MAPBASE+map,name,...)
 -- Source events can show objectives before returning to the native battle loop.
 -- The new map dimensions are ready now; fit the window before any introduction.
 koWarRes(true)
 koWarLayout()
 trace("BATTLE event="..JY.EventID.." source_map="..map.." units="..War.PersonNum)
end

-- Use the native shop, engraving, sale and tavern menus without campaign-wide suppression.
function koWujeStock() return nil end
function SnrShop(goods) return Shop() end
function koWujeTownShop() return Shop() end

-- Preserve source scripted-duel outcomes; use the 6.0 battle scene only for presentation.
local duel={}
function SnrDuel(a,b) duel={a,b,shown=false} end
function SnrDuelShow()
 if duel.shown or not duel[1] or not duel[2] then return end
 duel.shown=true
 local a,b=GetWarID(duel[1]),GetWarID(duel[2])
 if a>0 and b>0 and War.Person[a].live and War.Person[b].live then
  WarAction(1,duel[1],duel[2])
  koFightScene(a,b,0,0,0,"")
  DrawWarMap() Light()
 end
end
function SnrDuelAct(pid,act)
 local w=GetWarID(pid)
 if w<=0 or not War.Person[w].live or War.Person[w].hide then return end
 local other=pid==duel[1] and duel[2] or duel[1]
 if (act==1 or act==7 or act==10) and other and GetWarID(other)>0 then
  WarAction(act==10 and 8 or 4,pid,other)
 else
  local u=War.Person[w]
  local poses={[0]=0,[2]=3,[3]=4,[4]=4,[6]=4,[8]=6}
  u.action=poses[act] or 0 u.frame=0 WarDelay(2)
  u.action=0 u.frame=-1
 end
end
function SnrDuelClose() duel={} end

-- The DOS world-map motions become actors over the matching 6.0 world backdrop.
local function worldxy(x,y) return 1+x*.57,2+y*.38 end
function SnrWorldAdd(pid,x,y)
 if SnrRoom~=0 or JY.Status==GAME_WMAP or not JY.Person[pid] then return end
 local xx,yy=worldxy(x,y)
 for _,u in ipairs(JY.Smap) do if u[1]==pid then u[2]=xx u[3]=yy return end end
 AddPerson(pid,xx,yy,1)
end
function SnrWorldMove(pid,x,y)
 if SnrRoom~=0 or JY.Status==GAME_WMAP then return end
 local xx,yy=worldxy(x,y);local unit
 for _,u in ipairs(JY.Smap) do if u[1]==pid then unit=u break end end
 if not unit then SnrWorldAdd(pid,x,y) return end
 local sx,sy=unit[2],unit[3]
 for k=1,20 do
  unit[2]=sx+(xx-sx)*k/20 unit[3]=sy+(yy-sy)*k/20 unit[5]=1
  JY.ReFreshTime=lib.GetTime() DrawSMap() ReFresh()
 end
 unit[2]=xx unit[3]=yy unit[5]=0
end

-- Objective text is byte-width wrapped and paginated inside the original frame.
local function targetLines(s)
 local out={}
 for line in (s.."*"):gmatch("(.-)%*") do
  local row,w="",0;local i=1
  while i<=#line do
   local n=line:byte(i)>=128 and 2 or 1
   if w+n*8>256 then out[#out+1]=row row="   " w=24 end
   row=row..line:sub(i,i+n-1) w=w+n*8 i=i+n
  end
  out[#out+1]=row
 end
 return out
end
local showTarget=WarShowTarget
function WarShowTarget(first)
 if not campaign() then return showTarget(first) end
 local original=War.WarTarget;local name=War.WarName
 local text=original or ""
 local bounty=rawget(_G,"koBountyLines")
 local extra=bounty and bounty()
 if extra and not rawget(_G,"koSBText") then text=text.."*"..extra end
 local lines=targetLines(text);local pages=math.max(1,math.ceil(#lines/4))
 for page=1,pages do
  local part={} for k=(page-1)*4+1,math.min(#lines,page*4) do part[#part+1]=lines[k] end
  War.WarTarget=table.concat(part,"*")
  if pages>1 then War.WarName=name.." "..page.."/"..pages end
  local ok,e=pcall(showTarget,first)
  War.WarTarget=original War.WarName=name
  if not ok then error(e,0) end
 end
end

-- Log progression for user playtesting without auto-controlling or simulating any battles.
local doEvent=DoEvent
local last=-1
function DoEvent(id)
 if departureTestStop and id==9 then
  DrawStrBoxCenter("\133\098\129\103 \130\066\134\073 \129\105\129\106 \134\108\129\085")
  departureTestStop=false active=false JY.Status=GAME_START return false
 end
 if firstTestStop and id==9 then
  DrawStrBoxCenter("\131\097\130\114 \130\066\132\101 \129\105\129\106 \134\108\129\085")
  firstTestStop=false active=false JY.Status=GAME_START return false
 end
 if campaign() and id~=last then last=id trace("EVENT "..id.." status="..JY.Status.." room="..JY.SubScene) end
 return doEvent(id)
end
-- Native cycle inheritance stays in charge; restore only the campaign's event graph after reset.
local nativeCycleReset=CC.koNG.reset
CC.koNG.reset=function(...)
 local was=campaign()
 local r=nativeCycleReset(...)
 if was and r~=false then
  JY.Base[EV.."1985"]=6202
  JY.Base[EV.."1986"]=0
  SnrRoom=0 SnrChoiceResult=0 SnrW={} SnrBld=0
  JY.Smap={} JY.SubScene=-1
  configure()
 end
 return r
end
function SnrComplete()
 if rawget(_G,"koWujeSystemTest") then
  DrawStrBoxCenter("\135\089\134\084\130\066 \129\105\129\106 \134\108\129\085")
  active=false JY.Status=GAME_START return
 end
 JY.Base[EV.."1986"]=1
 trace("CAMPAIGN COMPLETE")
 DrawStrBoxCenter("\135\089\134\084\130\066 \134\108\134\064 \161\164 \130\115\129\097 \132\119\133\073")
 CC.koOffer()
 if JY.Status==GAME_START then active=false end
end
function SnrGameOver()
 trace("CAMPAIGN DEFEAT event="..JY.EventID)
 active=false CC.koReplay=nil JY.Status=GAME_START
end
trace("FULL CAMPAIGN LOADED")

-- Shared native departure presentation.
dofile(CONFIG.koCampScript.."campaign/departure.lua")

dofile(CONFIG.koCampScript.."campaign/battle_facing.lua")

dofile(CONFIG.koCampScript.."campaign/city_roles.lua")

-- ko 6.0 merge (11-01): the port's test rows (title group "\129\105\129\106") are not shown in the merged game
for i=#koAddon.titleMenu,1,-1 do if koAddon.titleMenu[i].group=="\129\105\129\106" then table.remove(koAddon.titleMenu,i) end end
