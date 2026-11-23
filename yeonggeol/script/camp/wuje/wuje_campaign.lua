-- Full Wu Di Zhuan campaign integration. All files belong to this standalone campaign copy.
local MAPBASE=0
local PERSON={{1,9,1027,202},{2,20,1031,4},{3,19,1030,3},{4,17,1028,204},{5,5,1148,119},{6,86,1155,102},{7,63,1039,12},{8,387,24,16},{9,1,1000,32},{10,213,1067,14},{11,77,1033,24},{12,218,1040,134},{13,228,1143,141},{14,62,1034,22},{15,201,1172,141},{16,79,1038,13},{17,78,1035,25},{18,80,1036,2},{19,94,1042,23},{20,116,1041,9},{21,68,1037,215},{22,103,1117,8},{23,130,1051,141},{24,173,1061,134},{25,239,1204,159},{26,122,1179,27},{27,96,1043,134},{28,84,1100,134},{29,171,1049,141},{30,176,1068,76},{31,41,1194,134},{32,101,1057,18},{33,202,1173,134},{34,214,1066,213},{35,215,1205,134},{36,242,1077,134},{37,37,1180,25},{38,243,1095,141},{39,136,1058,48},{40,212,1053,5},{41,216,1188,10},{42,60,1109,104},{43,57,1118,104},{44,102,1155,143},{45,158,1097,153},{46,89,1158,104},{47,97,1044,134},{48,172,1048,153},{49,210,1050,134},{50,192,1162,104},{51,180,1072,134},{52,257,1215,48},{53,115,1177,48},{54,178,1070,141},{55,179,1071,76},{56,56,1123,104},{57,89,1158,134},{58,71,1157,134},{59,59,1060,134},{60,153,1045,134},{61,119,1199,141},{62,181,1073,141},{63,69,1032,20},{64,104,1125,107},{65,66,1017,102},{66,2,1001,6},{67,3,1002,218},{68,54,1003,220},{69,126,1004,35},{70,82,1014,48},{71,65,1013,41},{72,83,1015,43},{73,64,1012,40},{74,170,1006,36},{75,188,1009,38},{76,209,1024,134},{77,139,1134,141},{78,127,1007,37},{79,190,1186,210},{80,202,1173,63},{81,201,1172,62},{82,257,1215,48},{83,128,1019,207},{84,247,1130,48},{85,67,1165,134},{86,33,1182,153},{87,34,1016,44},{88,39,1147,134},{89,38,1063,51},{90,191,1061,65},{91,208,1022,134},{92,31,1026,50},{93,249,1160,134},{94,154,1046,134},{95,337,1209,48},{96,401,174,38},{97,198,1168,134},{98,29,1184,25},{99,399,167,67},{100,23,1056,134},{101,200,1171,61},{102,199,1169,134},{103,255,1105,134},{104,30,1064,48},{105,140,1135,141},{106,380,1206,141},{107,253,1196,67},{108,244,1021,69},{109,91,1089,134},{110,117,1018,45},{111,254,1106,48},{112,379,1203,104},{113,119,1199,141},{114,257,1215,48},{115,36,1181,48},{116,378,1207,141},{117,252,1119,48},{118,204,1187,211},{119,11,1077,99},{120,142,1079,134},{121,143,1080,219},{122,15,1170,91},{123,14,1078,98},{124,148,1084,206},{125,167,1092,134},{126,149,1083,80},{127,144,1086,78},{128,45,1088,94},{129,163,1102,86},{130,186,1104,102},{131,74,1151,48},{132,71,1157,48},{133,46,1179,134},{134,166,1091,83},{135,138,1133,134},{136,150,1085,214},{137,185,1103,134},{138,139,1134,141},{139,146,1082,79},{140,125,1132,134},{141,26,1108,134},{142,174,1094,82},{143,165,1090,96},{144,157,1096,104},{145,145,1081,88},{146,57,1118,104},{147,106,1127,141},{148,257,1215,134},{149,42,1121,100},{150,60,1109,134},{151,247,1130,48},{152,41,1194,134},{153,151,1087,209},{154,248,1129,48},{155,67,1165,134},{156,228,1143,25},{157,74,1151,141},{158,139,1134,141},{159,36,1181,134},{160,42,1121,102},{161,158,1097,153},{162,162,1101,87},{163,186,1104,48},{164,44,1211,134},{165,168,1093,89},{166,137,1065,48},{167,14,1078,153},{168,10,1110,216},{169,52,1111,134},{170,53,1112,109},{171,93,1115,103},{172,106,1127,111},{173,105,1126,134},{174,230,1208,48},{175,107,1128,141},{176,42,1121,141},{177,158,1097,153},{178,51,1114,105},{179,6,1138,134},{180,181,1073,134},{181,182,1074,48},{182,92,1116,106},{183,252,1119,141},{184,26,1108,134},{185,156,1095,102},{186,200,1171,48},{187,246,1141,134},{188,138,1133,134},{189,249,1160,134},{190,257,1215,48},{191,173,1061,134},{192,193,1163,48},{193,58,1120,134},{194,139,1134,141},{195,140,1135,141},{196,198,1168,134},{197,99,1124,104},{198,171,1049,141},{199,125,1132,134},{200,124,1131,141},{201,12,1144,136},{202,211,1052,134},{203,137,1065,48},{204,257,1215,48},{205,217,1197,134},{206,41,1194,134},{207,57,1118,104},{208,159,1098,102},{209,43,1145,134},{210,72,1156,48},{211,206,1192,141},{212,226,1155,134},{213,70,1146,137},{214,32,1183,134},{215,67,1165,134},{216,72,1156,102},{217,18,1029,7},{218,85,1154,104},{219,86,1155,102},{220,76,1149,126},{221,154,1046,134},{222,228,1143,141},{223,200,1171,141},{224,224,1170,48},{225,72,1156,48},{226,199,1169,134},{227,227,1218,48},{228,89,1158,134},{229,140,1135,141},{230,74,1151,120},{231,75,1152,121},{232,81,1153,122},{233,88,1157,124},{234,73,1150,48},{235,257,1215,48},{236,73,1150,123},{237,60,1109,134},{238,255,1105,134},{239,337,1209,48},{240,275,1210,141},{241,201,1172,141},{242,257,1215,134},{243,163,1102,134},{244,244,1021,134},{245,74,1151,141},{246,95,1174,25},{247,113,1176,134},{248,120,1175,102},{249,120,1175,102},{250,131,1181,141},{251,97,1044,134},{252,257,1215,141},{253,41,1194,134},{254,26,1108,134},{255,45,1088,141},{256,46,1179,134},{257,257,1215,175},{258,257,1215,175},{259,257,1215,175},{260,257,1215,175},{261,257,1215,175},{262,257,1215,175},{263,257,1215,175},{264,257,1215,175},{265,257,1215,175},{266,257,1215,175},{267,379,1203,134},{268,127,1007,134},{269,111,1131,134},{270,257,1215,134},{271,359,1214,141},{272,378,1207,48},{273,8,1195,48},{274,127,1007,37},{275,275,1210,171},{276,275,1210,171},{277,275,1210,171},{278,275,1210,171},{279,275,1210,171},{280,275,1210,171},{281,275,1210,171},{282,275,1210,171},{283,275,1210,171},{284,275,1210,171},{285,44,1211,48},{286,6,1138,134},{287,180,1072,134},{288,16,1189,145},{289,230,1208,48},{290,27,1190,134},{291,359,1214,25},{292,198,1168,134},{293,293,1212,173},{294,293,1212,173},{295,293,1212,173},{296,293,1212,173},{297,293,1212,173},{298,293,1212,173},{299,293,1212,173},{300,293,1212,173},{301,293,1212,173},{302,293,1212,173},{303,4,1136,127},{304,49,1143,130},{305,255,1105,134},{306,22,1140,134},{307,169,1047,48},{308,41,1194,134},{309,275,1210,141},{310,206,1192,141},{311,311,1219,197},{312,311,1219,197},{313,311,1219,197},{314,311,1219,197},{315,311,1219,197},{316,311,1219,197},{317,311,1219,197},{318,311,1219,197},{319,311,1219,197},{320,311,1219,197},{321,248,1129,48},{322,227,1218,48},{323,333,1217,141},{324,35,1216,48},{325,119,1199,141},{326,118,1198,141},{327,217,1197,134},{328,41,1194,134},{329,329,1202,163},{330,329,1202,163},{331,113,1176,134},{332,337,1209,141},{333,333,1217,181},{334,333,1217,181},{335,335,1236,157},{336,335,1236,157},{337,337,1209,0},{338,337,1209,0},{339,337,1209,0},{340,337,1209,0},{341,341,1218,180},{342,341,1218,180},{343,341,1218,180},{344,341,1218,180},{345,37,1180,134},{346,23,1056,134},{347,154,1046,134},{348,256,1179,48},{349,329,1202,163},{350,329,1202,163},{351,129,1062,134},{352,202,1173,48},{353,257,1215,134},{354,201,1172,48},{355,196,1166,141},{356,249,1160,134},{357,35,1216,48},{358,70,1146,48},{359,257,1215,141},{360,337,1209,48},{361,254,1106,48},{362,182,1074,141},{363,155,1020,48},{364,205,1191,140},{365,23,1056,134},{366,206,1192,141},{367,207,1055,48},{368,30,1064,25},{369,369,1222,170},{370,71,1157,141},{371,151,1087,141},{372,13,1107,134},{373,168,1093,48},{374,91,1089,102},{375,375,1232,162},{376,56,1123,104},{377,61,1128,141},{378,41,1194,134},{379,119,1199,141},{380,41,1194,134},{381,381,1228,194},{382,2,1001,6},{383,383,1237,149}}
local EV="\202\194\188\254"
local NAME="\208\213\195\251"
local LORD="\190\253\214\247"
local FACE="\205\183\207\241\180\250\186\197"
local SHAPE="\208\206\207\243"
local IDENT="\180\250\186\197"
local SHOP="\129\068\130\119\129\067"
local active=false
local finalTestSettings=nil
local visual={}
for _,p in ipairs(PERSON) do visual[p[1]]=p[2] end
function koWujeIdentity(pid)
 local town=rawget(_G,"koWujeTownNPC")
 if town and town[pid] then return pid end
 return visual[pid]
end
local function trace(s)
 local f=io.open(CONFIG.CurrentPath.."wuje_campaign.log","a")
 if f then f:write(os.date("%Y-%m-%d %H:%M:%S").." "..s.."\n") f:close() end
end
local function repairVisuals()
 for _,p in ipairs(PERSON) do
  local who=JY.Person[p[1]]
  who[IDENT]=p[1]
  if not koOfficerEdited(p[1],2) then who[FACE]=p[3] end
  if not koOfficerEdited(p[1],1) then who[SHAPE]=p[4] end
 end
end
local function configure()
 active=true CC.koReplay=nil CC.koFree=nil CC.Enhancement=true
 if (JY.Base[SHOP] or 0)<1 then JY.Base[SHOP]=1 end
 repairVisuals()
 koWujeRepairClasses()
 -- Saved sprite IDs can still refer to the old unconditional personal set.
 for _,p in ipairs(PERSON) do if JY.Person[p[1]][LORD]==1 then GetPic(p[1]) end end
end
local function campaign() return active and JY.Base and JY.Base[EV.."1985"]==6201 end
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
dofile(CONFIG.koCampScript.."campaign/battle_visuals.lua")

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
local function sidecar(id) return CC.R_GRPFilename[id]..".wu.lua" end
-- Native automatic-checkpoint rotation copies .sav files; rotate their event state with them.
local copy=copyfile
function copyfile(from,to)
 local ok=copy(from,to)
 if ok and campaign() and type(from)=="string" and type(to)=="string" and from:match("%.sav$") and to:match("%.sav$") then
  local f=io.open(from..".wu.lua","r")
  if f then
   f:close()
   if not copy(from..".wu.lua",to..".wu.lua") then error("Cannot rotate campaign state: "..to) end
  else os.remove(to..".wu.lua") end
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
 elseif JY.Base and JY.Base[EV.."1985"]==6201 then
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
 JY.Base[EV.."1985"]=6201
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
-- A disposable town walk: the same streets/roads as the campaign, with two test destinations.
local function previewTravel()
 start()
 JY.EventID=2 JY.Status=GAME_SMAP_MANUAL SnrRoom=95
 JY.Smap={{1,25,9,1,0},{4,17,11,3,0},{375,12,18,0,0}}
 SetSceneID(95)
 local ok,err=pcall(koWujeTownVisit,true)
 active=false
 JY.Smap={} SnrRoom=0 JY.SubScene=-1 JY.Status=GAME_START
 if not ok then error(err,0) end
end
local nativeSettingsSave=koSave
function koSave(...)
 if rawget(_G,"koWujeSystemTest") then return end
 return nativeSettingsSave(...)
end
-- Disposable native-system test hub; save slots cannot be written in this mode.
local function previewSystems(side20,room)
 local settings={}
 for _,entry in ipairs(koAddon.saveKeys) do settings[#settings+1]={entry.key,CC[entry.key]} end
 rawset(_G,"koWujeSystemTest",true)
 local ok,err=pcall(function()
  start()
  local hall=room or 95
  JY.EventID=2 JY.Status=GAME_SMAP_MANUAL SnrRoom=hall
  JY.Base["\207\214\212\218\181\216"]="\129\103\129\093"
  JY.Base[SHOP]=8
  local team=side20 and {1,4,8,21,63,2,3,6,7,10,11,12,13,14,15,16,17,18,19,20,22} or {1,4,8,21,63,2}
  if side20==10 then
   while #team>11 do table.remove(team) end
  end
  for i,pid in ipairs(team) do
   ModifyForce(pid,1)
   JY.Person[pid]["\181\200\188\182"]=(({20,16,12,8,10,14})[i] or 12)
   ReSetAttrib(pid,true) GetPic(pid)
  end
  JY.Base["\206\228\189\171\202\253\193\191"]=#team
  koSetGold(99999)
  for _,it in ipairs({28,29,53,54,74,140}) do GetItem(1,it) end
  JY.Smap={{1,25,9,1,0},{4,17,11,3,0},{8,25,14,2,0},{21,15,12,3,0},{63,23,15,2,0},{2,13,13,3,0},{375,12,18,0,0}}
  if side20 then
   JY.Smap={{1,25,9,1,0},{375,3,17,0,0}}
   for i=2,#team do JY.Smap[#JY.Smap+1]={team[i],15,14,0,0} end
  end
  local h=koWujeHallHost(hall)
  if h then for _,u in ipairs(JY.Smap) do if u[1]==1 then u[2],u[3],u[4]=h[1],h[2],h[3] end end end
  SetSceneID(hall)
  DrawMulitStrBox(side20 and (side20==10 and "\134\111\139\074 5\130\088\143\093, \130\095\130\065 10\130\088\129\102 \130\075\130\084\129\123 \129\067\129\106\129\083 \138\090\129\068\132\083 \134\099\132\081\129\111 \129\082\130\086 \129\105\129\106 \129\064\129\065\129\104\129\076\129\077.*\131\071\134\079 \133\102\131\097 \134\086\133\073\129\102\130\098 \131\071\133\108\129\097\130\067 \130\107\129\075\129\076\129\077." or "\134\111\139\074 10\130\088\143\093, \130\095\130\065 20\130\088\129\102 \130\075\130\084\129\123 \129\067\129\106\129\083 \138\090\129\068\132\083 \134\099\132\081\129\111 \129\082\130\086 \129\105\129\106 \129\064\129\065\129\104\129\076\129\077.*\131\071\134\079 \133\102\131\097 \134\086\133\073\129\102\130\098 \131\071\133\108\129\097\130\067 \130\107\129\075\129\076\129\077.") or "\132\118\132\075 \130\086\131\126\190\077 \129\105\129\106\132\111 \129\082\130\086 \129\067\130\124\129\104\129\076\129\077. \131\103 99,999\135\122 \131\097\129\113 6\130\088\129\083 \131\101\130\080\129\080\129\075\129\076\129\077.*\131\071\134\079 \133\102\131\097 \134\086\133\073\129\102\130\098 \131\071\133\108\129\097\130\067 \130\107\129\075\129\076\129\077. \129\105\129\106\129\083 \133\088\132\081\129\065 \129\129\131\126\141\074 \129\084\129\085\130\104 \133\109\133\110\129\097\135\073\130\086\129\091.")
  if side20 then
   DrawSMap()
   DrawString(170,440,(side20==10 and "10\129\106" or "20\129\106").." \130\095\130\065 \129\105\129\106 \161\164 \137\074\130\104 \134\117\130\106\129\065 \129\253\199\245\132\083",M_White,16)
   ShowScreen() WaitKey(nil,60)
  end
  local menu={
   {"\133\088\129\083 \161\164 \130\075\135\070 \161\164 \129\077\135\077 \133\088\129\083 \129\071\130\108",nil,1},
   {"\129\073\131\097 \129\253\199\245 \161\164 \131\097\130\080 \161\164 \134\103\131\100",nil,1},
   {"\129\067\135\070 \161\164 \130\070\135\071 \161\164 \131\071\131\072 \134\068\131\071\131\071",nil,1},
   {"\130\126\129\084 \130\116\131\064",nil,1},
   {"\133\066\129\073\131\097",nil,1},
   {"\129\073\131\072\130\095\130\125",nil,1},
   {"\131\071\133\108 \161\164 \129\068\135\078 \161\164 \129\106\133\066",nil,1},
   {"\129\129\131\126\141\074 \129\084\129\085",nil,1}
  }
  while true do
   DrawSMap()
   local n=ShowMenu(menu,#menu,0,150,70,0,0,3,1,16,M_White,M_Yellow)
   if n<=0 or n==8 then break
   elseif n==1 then koWujeTownVisit(true)
   elseif n==2 then Person_Menu()
   elseif n==3 then Shop()
   elseif n==4 then koBzShop()
   elseif n==5 then koDojoRun()
   elseif n==6 then koTourneyCity(koTourRoster())
   elseif n==7 then koRecordScreen() end
  end
 end)
 for _,entry in ipairs(settings) do CC[entry[1]]=entry[2] end
 rawset(_G,"koWujeSystemTest",nil)
 rawset(_G,"koWujeTownPreview",nil)
 active=false JY.Smap={} SnrRoom=0 JY.SubScene=-1 JY.Status=GAME_START
 if not ok then error(err,0) end
end
-- Replay actual SNR entrance/formation/exit helpers with the full twenty-person hall.
local function previewReports(count,room)
 local settings={}
 for _,entry in ipairs(koAddon.saveKeys) do settings[#settings+1]={entry.key,CC[entry.key]} end
 rawset(_G,"koWujeSystemTest",true)
 local ok,err=pcall(function()
  start()
  local hall=room or 95
  JY.EventID=2 JY.Status=GAME_SMAP_AUTO SnrRoom=hall
  JY.Base["\207\214\212\218\181\216"]="\129\103\129\093"
  local team={1,4,8,21,63,2,3,6,7,10,11,12,13,14,15,16,17,18,19,20,22}
  JY.Base["\206\228\189\171\202\253\193\191"]=#team
  JY.Smap={{1,25,9,1,0},{375,3,17,0,0}}
  for i=2,#team do JY.Smap[#JY.Smap+1]={team[i],15,14,0,0} end
  local h=koWujeHallHost(hall)
  if h then JY.Smap[1][2],JY.Smap[1][3],JY.Smap[1][4]=h[1],h[2],h[3] end
  SetSceneID(hall)
  local function pause(label)
   DrawSMap()
   DrawString(170,440,label,M_White,16)
   ShowScreen() WaitKey(nil,60)
  end
  pause("\137\074\130\104 \134\117\130\106\129\065 \130\066\130\089 "..count.."\130\088\129\071 \129\104\131\097\129\087\129\076\129\077")
  local pool={369,370,378,380}
  local list,ids={},{}
  for i=1,count do list[i]={pool[i],15,14,0} ids[i]=pool[i] GetPic(pool[i]) end
  SnrEnterMany(list,25,9)
  pause("\130\066\130\089 "..count.."\130\088 \134\099\132\081 \129\105\129\106 \161\164 \137\074\130\104 \134\117\130\106\129\065 \133\068\131\097")
  SnrLeave(ids,25,9)
  pause("\130\066\130\089 \133\068\131\097 \134\108\129\085 \161\164 \137\074\130\104 \134\117\130\106\129\065 \133\064\129\071\140\071\132\083")
 end)
 for _,entry in ipairs(settings) do CC[entry[1]]=entry[2] end
 rawset(_G,"koWujeSystemTest",nil)
 active=false JY.Smap={} SnrRoom=0 JY.SubScene=-1 JY.Status=GAME_START
 if not ok then error(err,0) end
end
local function previewHallCatalog()
 local halls=koWujeHallCatalog()
 local menu={}
 for i,h in ipairs(halls) do menu[i]={string.format("%02d. ",i)..h[2],nil,1} end
 while true do
  lib.FillColor(0,0,0,0,0)
  local pick=ShowMenu(menu,#menu,10,130,40,0,0,3,1,16,M_White,M_Yellow)
  if pick<=0 then return end
  local modes={{"10\129\106 \134\099\132\081",nil,1},{"20\129\106 \134\099\132\081",nil,1},{"\130\066\130\089 2\130\088 \129\104\131\097",nil,1},{"\130\066\130\089 3\130\088 \129\104\131\097",nil,1},{"\130\066\130\089 4\130\088 \129\104\131\097",nil,1}}
  local mode=ShowMenu(modes,#modes,0,220,110,0,0,3,1,16,M_White,M_Yellow)
  local room=halls[pick][1]
  if mode==1 then previewSystems(10,room)
  elseif mode==2 then previewSystems(true,room)
  elseif mode>=3 then previewReports(mode-1,room) end
 end
end
local function previewFinalBattle()
 finalTestSettings={}
 for _,entry in ipairs(koAddon.saveKeys) do finalTestSettings[#finalTestSettings+1]={entry.key,CC[entry.key]} end
 rawset(_G,"koWujeSystemTest",true)
 local ok,err=pcall(function()
  start()
  local team=koWujeFinalTestTeam()
  for _,pid in ipairs(team) do
   ModifyForce(pid,1)
   JY.Person[pid]["\181\200\188\182"]=99
   ReSetAttrib(pid,true) GetPic(pid)
  end
  JY.Base["\206\228\189\171\202\253\193\191"]=#team
  koSetGold(99999)
  JY.EventID=399 SnrRoom=0 JY.SubScene=-1 JY.Smap={}
  JY.Status=GAME_SMAP_AUTO
  DrawMulitStrBox("\133\088\130\067\135\102 \129\119\134\110 \134\064\130\066 \129\105\129\106\132\111\129\104\129\076\129\077. \129\110\130\084\131\098 \129\129\131\126\141\074\132\111 99\130\082\130\123\132\083 \131\101\130\080\129\080\129\075\129\076\129\077.*\130\066\131\097 \129\103\129\104, \129\064\130\074 \129\071\139\071\141\074, \130\075\130\071 \130\112\134\086 \133\067 \137\096\143\228 \129\103\130\093\129\083 \129\105\129\106\129\066 \130\075\131\111\129\090.*\131\071\134\079 \133\102\131\097\129\102\130\098 \131\071\133\108\129\097\130\067 \130\107\129\075\129\076\129\077. \129\084\129\085 \133\067 \133\064\129\071\140\071\132\083 \137\066\129\110\134\104\129\076\129\077.")
 end)
 if not ok then
  for _,entry in ipairs(finalTestSettings) do CC[entry[1]]=entry[2] end
  finalTestSettings=nil rawset(_G,"koWujeSystemTest",nil)
  active=false JY.Status=GAME_START
  error(err,0)
 end
end
-- Keep the native title renderer and all registered officer/tournament/codex entries.
local departureTestStop=false
local function previewDeparture()
 finalTestSettings={}
 for _,entry in ipairs(koAddon.saveKeys) do finalTestSettings[#finalTestSettings+1]={entry.key,CC[entry.key]} end
 rawset(_G,"koWujeSystemTest",true)
 start()
 koSetGold(700)
 for _,pid in ipairs({1,4}) do
  ModifyForce(pid,1) ReSetAttrib(pid,true) GetPic(pid)
 end
 JY.Smap={} SnrRoom=95 JY.SubScene=95
 SnrAdd(1,25,9,1)
 SnrAdd(4,11,10,3)
 SnrAdd(375,15,18,0)
 JY.EventID=2 JY.Status=GAME_SMAP_MANUAL
 SetSceneID(95)
 departureTestStop=true
 DrawMulitStrBox("\133\098\129\103 \130\066\134\073 \129\105\129\106\132\111 \129\082\130\086 \129\081\129\082\129\104\129\076\129\077.*\129\097\133\067\135\093\129\083 \141\083\133\101 \133\098\129\103\129\083 \133\109\133\110\129\066 \130\075\131\111\129\090.*\130\125\131\080\131\097 \130\095\130\114\130\094\131\104 \130\066\131\097\129\123 \129\116\129\117\129\118\129\119 \133\113\130\086\129\089\130\067 \129\105\129\106\129\097\130\086\129\065 \140\106\129\076\129\077. \133\102\131\097\131\098 \129\097\130\067 \130\107\129\075\129\076\129\077.")
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\133\098\129\103 \130\066\134\073 \129\105\129\106",group="\129\105\129\106",run=previewDeparture}
koOn("title",function() departureTestStop=false end)

local nativeTitle=koTitleMenu
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\129\073\129\100\130\066 \136\122\129\084\130\066 \129\105\129\106",group="\129\105\129\106",run=previewFinalBattle}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\125\131\080\131\097 \134\099\131\064\138\090 \134\099\132\081 \129\105\129\106",group="\129\105\129\106",run=previewHallCatalog}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\132\118\132\075 \130\086\131\126\190\077 \129\105\129\106",group="\129\105\129\106",run=previewSystems}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\125\131\080\131\097 10\129\106 \134\099\132\081 \129\105\129\106",group="\129\105\129\106",run=function() previewSystems(10) end}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\125\131\080\131\097 20\129\106 \134\099\132\081 \129\105\129\106",group="\129\105\129\106",run=function() previewSystems(true) end}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\133\088\129\083 \129\071\130\108 \129\105\129\106",group="\129\105\129\106",run=previewTravel}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\066\130\089 2\130\088 \129\104\131\097 \129\105\129\106",group="\129\105\129\106",run=function() previewReports(2) end}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\066\130\089 3\130\088 \129\104\131\097 \129\105\129\106",group="\129\105\129\106",run=function() previewReports(3) end}
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\066\130\089 4\130\088 \129\104\131\097 \129\105\129\106",group="\129\105\129\106",run=function() previewReports(4) end}
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
 if departureTestStop and id==6 then
  DrawStrBoxCenter("\133\098\129\103 \130\066\134\073 \129\105\129\106 \134\108\129\085")
  departureTestStop=false active=false JY.Status=GAME_START return false
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
  JY.Base[EV.."1985"]=6201
  JY.Base[EV.."1986"]=0
  SnrRoom=0 SnrChoiceResult=0 SnrW={} SnrBld=0
  JY.Smap={} JY.SubScene=-1
  configure()
 end
 return r
end
function SnrComplete()
 if rawget(_G,"koWujeSystemTest") then
  DrawStrBoxCenter("\136\122\129\084\130\066 \135\085 \137\096\143\228 \129\105\129\106 \134\108\129\085")
  active=false JY.Status=GAME_START return
 end
 JY.Base[EV.."1986"]=1
 trace("CAMPAIGN COMPLETE")
 DrawStrBoxCenter("\129\073\129\100\130\066 \134\108\134\064 \161\164 \130\115\129\097 \132\119\133\073")
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
