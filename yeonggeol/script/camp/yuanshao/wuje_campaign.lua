-- Full Wu Di Zhuan campaign integration. All files belong to this standalone campaign copy.
local MAPBASE=0
local PERSON={{1,10,1110,216},{2,99,1124,104},{3,55,1122,102},{4,105,1126,134},{5,5,1148,119},{6,56,1123,104},{7,140,1135,141},{8,42,1121,141},{9,9,1027,202},{10,252,1119,141},{11,204,1187,211},{12,72,1156,141},{13,52,1111,134},{14,53,1112,109},{15,93,1115,103},{16,106,1127,111},{17,107,1128,141},{18,138,1133,134},{19,104,1125,107},{20,86,1155,102},{21,96,1043,134},{22,140,1135,141},{23,139,1134,141},{24,124,1131,141},{25,257,1215,141},{26,359,1214,141},{27,138,1133,134},{28,105,1126,134},{29,257,1215,141},{30,217,1197,134},{31,41,1194,134},{32,125,1132,134},{33,51,1114,105},{34,50,1113,110},{35,92,1116,106},{36,61,1128,141},{37,103,1117,8},{38,197,1167,153},{39,35,1216,134},{40,13,1107,161},{41,54,1003,220},{42,211,1052,134},{43,26,1108,134},{44,186,1104,134},{45,228,1143,141},{46,60,1109,134},{47,89,1158,134},{48,119,1199,141},{49,197,1167,134},{50,201,1172,134},{51,250,1193,102},{52,365,1220,141},{53,247,1130,48},{54,230,1208,48},{55,58,1120,134},{56,218,1040,134},{57,214,1066,213},{58,202,1173,134},{59,79,1038,13},{60,210,1050,134},{61,215,1205,134},{62,62,1034,22},{63,63,1039,12},{64,141,1059,134},{65,59,1060,134},{66,153,1045,134},{67,11,1077,141},{68,68,1037,215},{69,69,1032,20},{70,32,1183,153},{71,71,1157,153},{72,249,1160,134},{73,73,1150,48},{74,33,1182,104},{75,29,1184,25},{76,379,1203,25},{77,77,1033,24},{78,78,1035,25},{79,257,1215,134},{80,137,1065,48},{81,379,1203,104},{82,172,1048,153},{83,154,1046,134},{84,84,1100,21},{85,173,1061,134},{86,37,1180,25},{87,130,1051,141},{88,97,1044,134},{89,29,1184,141},{90,212,1053,5},{91,171,1049,141},{92,20,1031,4},{93,169,1047,104},{94,94,1042,23},{95,239,1204,159},{96,101,1057,18},{97,241,1163,104},{98,18,1029,7},{99,17,1028,204},{100,213,1067,14},{101,116,1041,9},{102,251,1043,150},{103,19,1030,3},{104,105,1126,134},{105,169,1047,48},{106,162,1101,134},{107,242,1077,134},{108,243,1095,141},{109,240,1201,102},{110,95,1174,25},{111,23,1056,134},{112,170,1006,36},{113,113,1176,134},{114,114,1011,39},{115,127,1007,37},{116,208,1022,134},{117,401,174,38},{118,158,1097,153},{119,118,1198,141},{120,120,1175,102},{121,119,1199,141},{122,122,1179,27},{123,123,1180,134},{124,134,1182,153},{125,333,1217,48},{126,227,1218,48},{127,156,1095,102},{128,184,1076,48},{129,183,1075,134},{130,154,1046,134},{131,131,1181,141},{132,253,1196,67},{133,164,1214,134},{134,115,1177,141},{135,148,1084,206},{136,8,1195,76},{137,157,1096,104},{138,41,1194,134},{139,257,1215,141},{140,43,1145,25},{141,127,1007,134},{142,142,1079,134},{143,143,1080,219},{144,144,1086,78},{145,145,1081,88},{146,146,1082,79},{147,147,1057,102},{148,11,1077,99},{149,149,1083,80},{150,150,1085,214},{151,151,1087,209},{152,71,1157,153},{153,151,1087,141},{154,61,1128,141},{155,154,1046,134},{156,156,1095,102},{157,60,1109,134},{158,158,1097,153},{159,159,1098,102},{160,160,1099,104},{161,161,1100,153},{162,162,1101,87},{163,163,1102,86},{164,201,1172,141},{165,165,1090,96},{166,166,1091,83},{167,167,1092,134},{168,168,1093,89},{169,45,1088,94},{170,108,1154,141},{171,136,1058,134},{172,15,1170,91},{173,184,1076,48},{174,174,1094,82},{175,14,1078,98},{176,46,1179,134},{177,186,1104,102},{178,185,1103,134},{179,41,1194,134},{180,387,24,16},{181,182,1074,102},{182,181,1073,48},{183,184,1076,48},{184,16,1189,145},{185,66,1017,102},{186,27,1190,134},{187,209,1024,134},{188,189,1159,160},{189,188,1009,38},{190,250,1193,102},{191,191,1061,65},{192,192,1162,104},{193,193,1163,104},{194,194,1164,134},{195,195,1165,134},{196,196,1166,141},{197,197,1167,134},{198,198,1168,134},{199,199,1169,134},{200,200,1171,61},{201,201,1172,62},{202,202,1173,63},{203,203,1023,48},{204,91,1089,134},{205,254,1106,48},{206,24,1161,104},{207,190,1186,210},{208,216,1188,10},{209,204,1187,211},{210,371,1230,152},{211,99,1124,104},{212,86,1155,102},{213,85,1154,104},{214,87,1156,134},{215,76,1149,126},{216,73,1150,123},{217,201,1172,48},{218,80,1036,2},{219,88,1157,124},{220,41,1194,134},{221,81,1153,122},{222,75,1152,121},{223,74,1151,120},{224,228,1143,141},{225,246,1141,134},{226,1,1000,32},{227,2,1001,6},{228,3,1002,218},{229,112,1005,134},{230,244,1021,69},{231,64,1012,40},{232,133,1008,212},{233,117,1018,45},{234,128,1019,207},{235,155,1020,217},{236,30,1064,53},{237,252,1119,48},{238,34,1016,44},{239,141,1059,134},{240,65,1013,41},{241,175,1025,49},{242,31,1026,50},{243,83,1015,43},{244,402,108,54},{245,82,1014,48},{246,44,1211,54},{247,126,1004,35},{248,185,1103,134},{249,125,1132,134},{250,202,1173,134},{251,141,1059,134},{252,38,1063,104},{253,39,1147,134},{254,102,1155,143},{255,35,1216,48},{256,71,1157,141},{257,36,1181,48},{258,169,1047,104},{259,378,1207,153},{260,58,1120,134},{261,255,1105,153},{262,257,1215,102},{263,209,1024,134},{264,159,1098,48},{265,180,1072,134},{266,180,1072,134},{267,257,1215,175},{268,257,1215,175},{269,257,1215,175},{270,257,1215,175},{271,257,1215,175},{272,257,1215,175},{273,257,1215,175},{274,257,1215,175},{275,204,1187,211},{276,204,1187,211},{277,204,1187,211},{278,204,1187,211},{279,219,1212,141},{280,219,1212,141},{281,219,1212,141},{282,219,1212,141},{283,219,1212,141},{284,219,1212,141},{285,275,1210,171},{286,275,1210,171},{287,275,1210,171},{288,275,1210,171},{289,275,1210,171},{290,275,1210,171},{291,275,1210,171},{292,275,1210,171},{293,4,1136,127},{294,6,1138,134},{295,7,1137,132},{296,26,1108,134},{297,21,1139,102},{298,48,1142,129},{299,206,1192,141},{300,28,1200,134},{301,22,1140,134},{302,293,1212,173},{303,293,1212,173},{304,293,1212,173},{305,293,1212,173},{306,293,1212,173},{307,293,1212,173},{308,293,1212,173},{309,293,1212,173},{310,293,1212,173},{311,220,1212,134},{312,35,1216,48},{313,119,1199,141},{314,217,1197,134},{315,41,1194,134},{316,246,1141,134},{317,178,1070,141},{318,181,1073,48},{319,73,1150,123},{320,73,1150,123},{321,73,1150,123},{322,73,1150,123},{323,180,1072,134},{324,180,1072,134},{325,311,1219,197},{326,311,1219,197},{327,311,1219,197},{328,311,1219,197},{329,183,1075,134},{330,129,1062,134},{331,12,1144,136},{332,33,1182,104},{333,333,1217,181},{334,333,1217,181},{335,70,1146,137},{336,113,1176,134},{337,337,1209,0},{338,337,1209,0},{339,337,1209,0},{340,337,1209,0},{341,150,1085,214},{342,150,1085,214},{343,150,1085,214},{344,150,1085,214},{345,32,1183,25},{346,67,1165,134},{347,43,1145,25},{348,72,1156,102},{349,226,1155,134},{350,379,1203,102},{351,200,1171,61},{352,329,1202,163},{353,200,1171,61},{354,200,1171,61},{355,200,1171,61},{356,311,1219,197},{357,311,1219,197},{358,311,1219,197},{359,311,1219,197},{360,311,1219,197},{361,311,1219,197},{362,311,1219,197},{363,184,1076,141},{364,248,1129,134},{365,35,1216,52},{366,35,1216,52},{367,253,1196,25},{368,228,1143,141},{369,159,1098,48},{370,369,1222,170},{371,35,1216,52},{372,35,1216,52},{373,132,1184,153},{374,34,1016,141},{375,375,1232,162},{376,47,1141,48},{377,359,1214,141},{378,49,1143,130},{379,37,1180,141},{380,23,1056,134},{381,205,1191,134},{382,59,1060,134},{383,383,1237,149},{531,359,1214,193}}
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
 local f=io.open(CONFIG.CurrentPath.."yuanshao_campaign.log","a")
 if f then f:write(os.date("%Y-%m-%d %H:%M:%S").." "..s.."\n") f:close() end
end
local function repairVisuals()
 if rawget(_G,"koWujeRepairClasses") then koWujeRepairClasses() end
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
local function campaign() return active and JY.Base and JY.Base[EV.."1985"]==6203 end
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
local function sidecar(id) return CC.R_GRPFilename[id]..".ys.lua" end
-- Native automatic-checkpoint rotation copies .sav files; rotate their event state with them.
local copy=copyfile
function copyfile(from,to)
 local ok=copy(from,to)
 if ok and campaign() and type(from)=="string" and type(to)=="string" and from:match("%.sav$") and to:match("%.sav$") then
  local f=io.open(from..".ys.lua","r")
  if f then
   f:close()
   if not copy(from..".ys.lua",to..".ys.lua") then error("Cannot rotate campaign state: "..to) end
  else os.remove(to..".ys.lua") end
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
 elseif JY.Base and JY.Base[EV.."1985"]==6203 then
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
 JY.Base[EV.."1985"]=6203
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
 JY.Smap={} SnrRoom=95 JY.SubScene=95
 SnrAdd(1,25,9,1) SnrAdd(13,11,10,3) SnrAdd(14,23,16,2)
 SnrAdd(375,15,18,0)
 JY.EventID=6 JY.Status=GAME_SMAP_MANUAL
 SetSceneID(95)
 departureTestStop=true
 DrawMulitStrBox("\131\081\129\109\130\066 \133\098\129\103 \130\066\134\073 \129\105\129\106\132\111\129\104\129\076\129\077.*\130\111\132\088\129\083 \141\083\133\101 \133\098\129\103\129\083 \133\109\133\110\129\066 \130\075\131\111\129\090. \130\114\129\113\129\101 \129\103\129\104\129\123 \129\116\129\117\129\118\129\119\129\083 \129\105\129\106\129\097\130\086\129\065 \140\106\129\076\129\077.*\131\071\134\079 \133\102\131\097\129\102\130\098 \131\071\133\108\129\097\130\067 \130\107\129\075\129\076\129\077.")
end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\133\098\129\103 \130\066\134\073 \129\105\129\106",group="\129\105\129\106",run=previewDeparture}
koOn("title",function() departureTestStop=false end)
local nativeTitle=koTitleMenu
local function firstBattleTest() previewDeparture() end
koAddon.titleMenu[#koAddon.titleMenu+1]={label="\131\081\129\109\130\066 \137\112 \130\066\132\101 \129\105\129\106",group="\129\105\129\106",run=firstBattleTest}
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
 if departureTestStop and id==10 then
  DrawStrBoxCenter("\133\098\129\103 \130\066\134\073 \129\105\129\106 \134\108\129\085")
  departureTestStop=false active=false JY.Status=GAME_START return false
 end
 if firstTestStop and id==10 then
  DrawStrBoxCenter("\130\114\129\113\129\101 \130\066\132\101 \129\105\129\106 \134\108\129\085")
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
  JY.Base[EV.."1985"]=6203
  JY.Base[EV.."1986"]=0
  SnrRoom=0 SnrChoiceResult=0 SnrW={} SnrBld=0
  JY.Smap={} JY.SubScene=-1
  configure()
 end
 return r
end
function SnrComplete()
 if rawget(_G,"koWujeSystemTest") then
  DrawStrBoxCenter("\131\081\129\109\130\066 \129\105\129\106 \134\108\129\085")
  active=false JY.Status=GAME_START return
 end
 JY.Base[EV.."1986"]=1
 trace("CAMPAIGN COMPLETE")
 DrawStrBoxCenter("\131\081\129\109\130\066 \134\108\134\064 \161\164 \130\115\129\097 \132\119\133\073")
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

dofile(CONFIG.koCampScript.."campaign/battle_visuals.lua")

dofile(CONFIG.koCampScript.."campaign/battle_facing.lua")

dofile(CONFIG.koCampScript.."campaign/city_roles.lua")

-- ko 6.0 merge (11-01): the port's test rows (title group "\129\105\129\106") are not shown in the merged game
for i=#koAddon.titleMenu,1,-1 do if koAddon.titleMenu[i].group=="\129\105\129\106" then table.remove(koAddon.titleMenu,i) end end
