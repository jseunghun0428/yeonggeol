-- Disposable hall previews using Yuan Shao's own cast and the live layout helpers.
return function(start,finish)
 local TEAM={1,13,14,33,34,35,36,37,19,28,6,15,3,2,16,18,7,38,25,4,55}
 local REPORTERS={369,370,367,368}
 local function run(room,count,reports)
  local settings={}
  for _,entry in ipairs(koAddon.saveKeys) do settings[#settings+1]={entry.key,CC[entry.key]} end
  rawset(_G,"koWujeSystemTest",true)
  local ok,err=pcall(function()
   start()
   JY.EventID=6 SnrRoom=room JY.Status=GAME_SMAP_AUTO
   JY.Base["\207\214\212\218\181\216"]="\129\095\129\066"
   JY.Smap={{1,25,9,1,0},{375,3,17,0,0}}
   for i=1,count+1 do
    local pid=TEAM[i]
    ModifyForce(pid,1) GetPic(pid)
    if i>1 then JY.Smap[#JY.Smap+1]={pid,15,14,0,0} end
   end
   JY.Base["\206\228\189\171\202\253\193\191"]=count+1
   local h=koWujeHallHost(room)
   if h then JY.Smap[1][2],JY.Smap[1][3],JY.Smap[1][4]=h[1],h[2],h[3] end
   SetSceneID(room)
   local function pause(label)
    DrawSMap()
    DrawString(96,440,label,M_White,16)
    ShowScreen() WaitKey(nil,60)
   end
   if reports then
    pause("\131\081\129\109\130\066 20\129\106 \134\099\132\081 \161\164 \137\074\130\104 \134\117\130\106\129\065 \130\066\130\089 "..reports.."\130\088 \129\104\131\097")
    local arrivals,ids={},{}
    for i=1,reports do
     local pid=REPORTERS[i] GetPic(pid)
     arrivals[i]={pid,15,14,0} ids[i]=pid
    end
    SnrEnterMany(arrivals,25,9)
    pause("\130\066\130\089 "..reports.."\130\088 \134\099\132\081 \129\105\129\106 \161\164 \137\074\130\104 \134\117\130\106\129\065 \133\068\131\097")
    SnrLeave(ids,25,9)
    pause("\130\066\130\089 \133\068\131\097 \134\108\129\085 \161\164 \137\074\130\104 \134\117\130\106\129\065 \134\099\131\064 \133\109\133\110\131\109\132\083")
   else
    JY.Status=GAME_SMAP_MANUAL
    pause("\131\081\129\109\130\066 \130\095\130\065 "..count.."\129\106 + \131\081\129\109\161\164\130\084\129\113\129\101 \161\164 \137\074\130\104 \134\117\130\106\129\065 \137\066\129\110\129\094\131\071")
   end
  end)
  for _,entry in ipairs(settings) do CC[entry[1]]=entry[2] end
  rawset(_G,"koWujeSystemTest",nil)
  rawset(_G,"koWujeTownPreview",nil)
  finish()
  if not ok then error(err,0) end
 end
 local function catalog()
  local halls=koWujeHallCatalog();local menu={}
  for i,h in ipairs(halls) do menu[i]={string.format("%02d. ",i)..h[2],nil,1} end
  while true do
   lib.FillColor(0,0,0,0,0)
   local pick=ShowMenu(menu,#menu,10,130,40,0,0,3,1,16,M_White,M_Yellow)
   if not pick or pick<=0 then return end
   local modes={{"\131\124\131\071 \130\094\130\095 3\129\106",nil,1},{"10\129\106 \134\099\132\081",nil,1},{"20\129\106 \134\099\132\081",nil,1},
    {"\130\066\130\089 2\130\088 \129\104\131\097",nil,1},{"\130\066\130\089 3\130\088 \129\104\131\097",nil,1},{"\130\066\130\089 4\130\088 \129\104\131\097",nil,1}}
   local mode=ShowMenu(modes,#modes,0,220,110,0,0,3,1,16,M_White,M_Yellow)
   if mode and mode>0 then
    local count=mode==1 and 2 or mode==2 and 10 or 20
    run(halls[pick][1],count,mode>=4 and mode-2 or nil)
   end
  end
 end
 koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\125\131\080\131\097 \134\099\131\064\138\090 \134\099\132\081 \129\105\129\106",group="\129\105\129\106",run=catalog}
 koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\125\131\080\131\097 10\129\106 \134\099\132\081 \129\105\129\106",group="\129\105\129\106",run=function() run(95,10) end}
 koAddon.titleMenu[#koAddon.titleMenu+1]={label="\130\125\131\080\131\097 20\129\106 \134\099\132\081 \129\105\129\106",group="\129\105\129\106",run=function() run(95,20) end}
end
