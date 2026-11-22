-- Standalone Wu Di Zhuan towns. Native 6.0 scenery and road/furniture routing.
local LOC="\207\214\212\218\181\216"
local FIG="\208\206\207\243"
local CATALOG={{"\132\089\134\111",2},{"\131\097\130\114",3},{"\129\098\130\073",65},{"\137\086\129\110",71},{"\136\124\142\083",82},{"\133\109\131\123",116},{"\135\109\134\103",121},{"\129\113\142\073",125},{"\129\091\130\084",175},{"\134\077\134\111",213},{"\129\107\131\097",229},{"\130\073\129\097",249},{"\131\076\133\087",253},{"\133\103\130\084",280},{"\129\119\134\110",299},{"\130\071\129\113\130\119",349},{"\131\123\129\068",361},{"\135\109\129\068",371},{"\141\069\131\123",408},{"\129\103\129\093",420},{"\134\110\131\123",434},{"\131\097\130\111",455},{"\129\082\130\073",478},{"\129\094\134\095\129\101",494},{"\132\089\131\123",511}}
local EVENTS={[2]="\132\089\134\111",[3]="\131\097\130\114",[14]="\132\089\134\111",[16]="\131\097\130\114",[52]="\131\097\130\114",[65]="\129\098\130\073",[71]="\137\086\129\110",[80]="\137\086\129\110",[82]="\136\124\142\083",[102]="\136\124\142\083",[116]="\133\109\131\123",[121]="\135\109\134\103",[125]="\129\113\142\073",[143]="\129\113\142\073",[147]="\135\109\134\103",[151]="\135\109\134\103",[175]="\129\091\130\084",[183]="\136\124\142\083",[187]="\129\091\130\084",[191]="\136\124\142\083",[194]="\136\124\142\083",[201]="\135\109\134\103",[213]="\134\077\134\111",[216]="\136\124\142\083",[229]="\129\107\131\097",[249]="\130\073\129\097",[250]="\130\073\129\097",[252]="\130\073\129\097",[253]="\131\076\133\087",[254]="\131\076\133\087",[268]="\130\073\129\097",[271]="\135\109\134\103",[280]="\133\103\130\084",[281]="\135\109\134\103",[282]="\133\103\130\084",[296]="\133\103\130\084",[298]="\135\109\134\103",[299]="\129\119\134\110",[309]="\129\119\134\110",[313]="\129\119\134\110",[314]="\129\119\134\110",[319]="\129\107\131\097",[327]="\129\119\134\110",[330]="\129\098\130\073",[334]="\129\091\130\084",[344]="\129\091\130\084",[349]="\130\071\129\113\130\119",[361]="\131\123\129\068",[362]="\129\119\134\110",[365]="\131\123\129\068",[371]="\135\109\129\068",[373]="\129\091\130\084",[382]="\129\119\134\110",[387]="\131\123\129\068",[388]="\129\119\134\110",[391]="\135\109\129\068",[392]="\129\119\134\110",[408]="\141\069\131\123",[420]="\129\103\129\093",[421]="\129\103\129\093",[434]="\134\110\131\123",[436]="\132\089\134\111",[438]="\129\091\130\084",[440]="\132\089\134\111",[442]="\132\089\134\111",[452]="\135\109\129\068",[455]="\131\097\130\111",[465]="\133\103\130\084",[478]="\129\082\130\073",[494]="\129\094\134\095\129\101",[511]="\132\089\131\123",[523]="\131\123\129\068"}
local REGION1={pic=133,w=48,h=48,
road={
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx..xxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.....xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx..xxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxx......xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxx.....xxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxx.xx.xxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxx..xxx.xxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxx.xxxx.xxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxx.xxxx.xxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxx...xxxx.xxxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxx..xxx....xxxxxxxxx....xxxxxx",
"xxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxx.....x",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxx.x",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxx.xx",
"xxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx.xxx",
"xxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx.xxxx",
"xxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxx.xxxxx",
"xxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxx.xxxxx",
"xxxxxxxxxxxxxxxxxxx.xxxxxxxxx.xxxxxxx.....xxxxxx",
".xxxxxxxxxxxxxxxxxx.xxxxxxxxxx.xxxxx.xxx.xxxxxxx",
"x.xxxxxxxxxxxxxxxxx.xxxxxxxxxxx.xxx.xx..x.xxxxxx",
"x.xxxxxxxxxxxxxxxxx.xxxxxxxxxxx.xx.xx.xxx.xxxxxx",
"x.xxxxxxxxxxxxxxxxx.xxxxxxxxxxx.x.xxx.xxxx.xxxxx",
"xx.xxxxxxxxxxxxxxxx.xxxxxxxxxxxx..xxx.xxxx.xxxxx",
"xxx.....xxxxxxxxxxx.xxxxxxxxxxxx......xxxx.xxxxx",
"xxxxxxxx...xxxxxxx.xxxxxxxxxxxx.xxxxxx.xxx.xxxxx",
"xxxxxxxxxxx...xxx.xxxxxxxxxxxx..xxxxxxx..x.xxxxx",
"xxxxxxxxxxxxxx....xxxxxxxxxxx.xxxxxxxxxxx..xxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxx.xxxxxxxxxxxxx.xxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxx.xxxxxxxxxxxxxx.xxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxxxxxx.xxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxxxx..xxxxxx",
"xxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxxxx.xxxxxxxx",
"xxxxxxxxxxxxxxxxxx....xxx.xxxxxxxxxxxxx.xxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxx...xxxxxxxxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxx.x...xxxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxx.xxx.......xxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxx...xxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
},
places={
{"\131\119\131\081",38,9,3},{"\132\089\134\111",1,26,3},{"\129\103\130\071",19,27,3},{"\130\114\129\113\129\101",15,33,2},{"\134\113\132\083\129\101",6,30,2},{"\134\110",18,18,3},
{"\137\082\129\097",30,13,0},{"\134\069\133\108",25,12,0},{"\132\084\132\087",26,16,0},{"\135\107\131\119",39,1,3},{"\135\107\129\066",46,17,3},{"\131\087\130\075",40,24,3},
{"\129\109\129\079",32,30,3},{"\130\124\132\091",29,24,0},{"\135\109\134\103",18,39,3},{"\129\098\133\103",24,46,3},{"\129\097\130\119",36,25,0},{"\129\097\130\080",42,33,3},
{"\131\078\129\068",30,5,3},{"\130\072\130\115",34,9,0},{"\141\069\131\123",36,30,0},{"\130\072\142\083",38,41,0},
},
-- open: from which kdef event a town can be walked to (its first free phase there), and until which (the story has left it)
-- 평원·신도·북평·북해 from their first free phase to the end of 1장 (5.0: they stay open, REVISIT lines after 132); 서주·소패·하비 closed while 여포 holds them, while 유비 stays in 허창
-- with 조조 (177~212) and after he flees to 원소 at 업 (224~); 허창 only while 유비 is there
open={["\131\119\131\081"]={24},["\131\078\129\068"]={37},["\135\107\131\119"]={72},["\135\107\129\066"]={82},
["\131\087\130\075"]={{89,132},{158,175},{213,223}},["\129\109\129\079"]={{101,132},{147,175},{213,223}},["\129\097\130\080"]={{169,175},{213,223}},
["\135\109\134\103"]={{140,146},{177,212}},["\134\110"]={224}},
}
local REGION2={pic=134,w=36,h=56,
road={
"xxxxxxxxxxxxxxxxxxx......xxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxxx",
"xxxxxxxxxxxxxxxxx.xxxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxxxxx.xxxxxxxxx.xxxxxxxxx",
"xxxxxxxxxxxxx...xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxx...xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxx..xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxx..xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxx.x.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxx.xx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxx.x.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxx..xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxx.x.xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxx.xxxxxxxxxxxxxxxxxxx",
"xxxxxxx...xxxxx...xxxxxxxxxxxxxxxxxx",
"xxxxxx.xx......xxx.xxxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxx.xxxx.....xxxxxxxx",
"xxxxx.xxxxxxxxxxxx.x...xxxxx.xxxxxxx",
"xxxxx.xxxxxxxxxxx...xxxxxxxxx.xxxxxx",
"xxxxx.xxxxxxx....xx.xxxxxxxxxx....xx",
"xxxxx.xxxxxx.xxxxxx.xxxxxxxxxxxxxxxx",
"xxxxx.xxxxx.xxxxxxx.xxxxxxxxxxxxxxxx",
"xxxxx.xxxx.xxxxxxxx.xxxxxxxxxxxxxxxx",
"x....x....xxxxxxxxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
},
places={
{"\129\098\133\103",14,30,3},{"\134\110",17,2,3},{"\134\101\133\088",26,3,3},{"\134\111\134\111",5,46,3},{"\131\078\133\069",13,39,3},{"\135\109\134\103",17,23,3},{"\135\088\130\101",1,47,4},{"\136\123\136\111\134\086",16,35,0},
{"\131\097\130\070\134\086",20,41,0},{"\130\073\129\097",33,43,3},{"\133\066\130\075",12,5,0},{"\131\076\133\087",21,50,0},{"\131\100\131\123",16,15,4},{"\129\126\130\115",12,24,0},{"\133\103\134\111",11,35,0},{"\129\091\130\079",19,46,0},
},
-- 관도 (226~252) 업·백마, 고성 (259~267), 여남 (268~278), 형주 (279~) 신야·양양, 융중 (305~), 강하 (377~)
-- 양양·융중 until 형주 surrenders to 조조 (조조 남정 348~), 신야 until the flight to 강하 (377~); 5.0: 업·백마 stay open until
-- 관도 is lost (323), 고성 until 조조 남정 (347), with REVISIT lines once 유비 has moved on
open={["\134\110"]={226,323},["\134\101\133\088"]={229,323},["\131\100\131\123"]={259,347},["\129\098\133\103"]={268,278},["\134\111\134\111"]={279,347},["\131\078\133\069"]={279,376},["\135\088\130\101"]={305,347},["\130\073\129\097"]={377}},
}
local REGION3={pic=135,w=60,h=44,
road={
"xxxxx.xxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxx.xxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxx.xxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxx.....xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxx.xx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxx.xx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx...xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx.xx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxx.xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxx.xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xx",
"xxxxxxxx.xxxx....xxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxx.xx",
"xxxxxxxx.....xxxx.xxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxx.xx",
"xxxxxxxx.xxxxxxxx.xxxxxxxxxxx.xxxxxxxxxxxxxx.xxxxxxxxxxxx.xx",
"xxxxxxxxx.xxxxxxx.xxxxxxxxxxxx.xxxxxxxxxxxxx.xxxxxxxxxxxx...",
"xxxxxxxxx.xxxxxxx.xxxxxxxxxxxxx..xxxxxxxxxxx.xxxxxxxxxxxx.xx",
"xxxxxxxxx.xxxxxxx.xxxxxxxxxxxxxxx.xxxxxxxxxx.xxxxxxxxxxx.xxx",
"xxxxxxxxxx.xxxxx.xxxxxxxxxxxxxxxx..xxxxxxxx.xxxxxxxxxxx.xxxx",
"xxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxxx........xxxxxxxxxxx.xxxxx",
"xxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxxxx.xxxxx.xxxxxxxxxx...xxxxxx",
"xxxxxxxxxxx.xxxxx.xxxxxxxxxxxxxxx.xxxxxx.xxxxxxxx..xxxxxxxxx",
"xxxxxxxxxxx.xxxxxx.xxxxxxxxxxxxx.xxxxxxxx.xxxxxx.xxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxx.xxxxxxxxxxxx..xxxxxxx.x......xxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxx.xxxxxxxxx..xxxxxxxx.xxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxx.xxx......xxxxxxxxx.x.xxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxx.x..xxxxxxxxxxxxxx.xx.xxxxxxxxxxxx.xxxxxx",
"xxxxxxxxxxx.xxxxxxx...xxxxxxxxxxxxxxx.xxx.xxxxxxxxxx.xxxxxxx",
"xxxxxxxxxx.xxxxxxxx.x.xxxxxxxxxxxxxx.xxxxx.xxxxxxx..xxxxxxxx",
"xxxxxxxxxx.xxxx....xx.xxxxxxxxxxxxxx.xx.......xx..xxxxxxxxxx",
"xxxxxxxxxx.xxx.xxxxxx.xxxxxxxxxxxxxx.x.xxx.xxx..xxxxxxxxxxxx",
"xxxxxxxxx.xxx.xxxxxx.xxxxxxxxxxxxxxx.x.xxxx.xxxx.xxxxxxxxxxx",
"xxxxxxxxx....xxxxxxx.xxxxxxxxxxxxxxx..xxxxx.xxxx.xxxxxxxxxxx",
"xxxxxxxxx.xxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx.xxxxx.xxxxxxxxxx",
"xxxxxxxxx.xxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx.xxxxx.xxxxxxxxxx",
"xxxxxxxxx...xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxx",
"xxxxxxxx.xxx......xxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxx",
"xxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxx....xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"x..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
},
places={
{"\134\111\134\111",29,17,3},{"\143\124",33,21,0},{"\130\073\142\083",39,22,3},{"\129\073\142\083",36,35,0},{"\129\126\142\083",43,39,0},{"\132\084\134\111",50,38,0},{"\131\097\130\114",53,29,3},{"\130\073\129\097",57,14,3},
{"\134\101\129\100",23,28,3},{"\132\089",9,38,3},{"\130\094",10,32,3},{"\136\074\134\111\129\114",44,15,4},{"\131\123\129\068",1,42,3},{"\129\111\130\101",12,5,0},{"\134\086\131\087",18,38,0},{"\130\115\140\109\132\091",8,16,0},
{"\129\070\130\084\132\091",16,15,0},{"\129\111\130\101",10,9,0},{"\135\122\130\119\129\101",18,26,2},{"\129\071\142\083",32,26,0},{"\129\094\134\095\129\101",11,27,2},{"\129\065\133\071\129\101",6,41,2},{"\134\111\131\119\129\101",5,2,2},{"\131\087\142\083",29,27,3},
{"\130\074\130\111",44,26,0},
},
-- 형주 (384~469) 강하·강릉, 장사 (419~), 뇌양현 (455~); 익주 (471~) 낙, 부 (475~), 성도 (515~); 서릉 (583~)
-- 5.0: the 형주 towns stay open after 469 (관우 holds 형주), with REVISIT lines
open={["\130\073\129\097"]={384},["\130\073\142\083"]={392},["\134\111\134\111"]={384},["\136\074\134\111\129\114"]={455},["\132\089"]={471},["\130\094"]={475},["\131\123\129\068"]={515},["\131\087\142\083"]={583},["\134\101\129\100"]={583}},
}
local REGION4={pic=136,w=56,h=64,
road={
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxx......xxxxxxxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxx.xxxxxxxx...xxxxxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxx..xxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxx..xxxxx.xxxxxxxxxxxxxx",
"xxxxxxxxxxx.......xxxxxxxxxxxxxxxx.x.......xxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxx..xxxxxxxxxxx",
"xxxxxxx...xxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxxx",
"xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxxxxxx",
"xxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxx.xxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.x.xxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxx",
"xxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.x.xxxxxxxxxxxxxxxx",
"xxxxxx....xxxxxxxxxxxxxxxxxxxxxxxxxx.xxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx.xxxx.xxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx.xxxx..xxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxx.xxxxx.x.xxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxx...xxxxx.xxx.xxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xx......xxxxx...xxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxx..xxxxxxx",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxx.xxxxxx",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xxxxxxx.xxxxxxxxxxxx.xxxxx",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xxxxxx.xxxxxxxxxxxxxx.xxxx",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xxxxx.xxxxxxxxxxxxxxxx..xx",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxx.x....xxxxxxxxxxxxxxxxxxx.x",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxx..xxxxxxxxxxxxxxxxxxxxxxx.x",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx.x",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxx..xxxxxxxxxxxxxxxxxxxxxx.x",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxx..xxxxxxxxxxxxxxxxxxxx.x",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxx.....xxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxx...xxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxxxxxxxxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxxxx..............xxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx.xxx..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxx....xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxx.xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxx..xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"x.....xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
"xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
},
places={
{"\131\123\129\068",1,62,3},{"\130\086\129\067",54,49,0},{"\130\073\142\083",39,51,3},{"\134\111\134\111",29,46,3},{"\133\103\130\114",30,39,0},{"\131\078\133\069",37,39,0},{"\129\087\130\080",45,39,0},
{"\134\108",38,28,3},{"\135\109\134\103",44,20,3},{"\129\103\135\090",9,21,0},{"\131\097\130\111",14,19,0},{"\132\089\134\111",30,16,0},{"\134\110",41,2,0},{"\134\111\131\119\129\101",5,32,2},
},
open={["\131\123\129\068"]={593},["\130\073\142\083"]={600},["\134\111\134\111"]={609},["\134\108"]={631},["\135\109\134\103"]={656}},
}
local REGIONS={REGION1,REGION2,REGION3,REGION4}
local ALIAS={["\129\103\130\071"]="\129\103\129\093",["\134\110\131\123"]="\134\110",["\131\071\130\075"]="\134\110",["\135\109\129\068"]="\135\109\134\103",["\134\108\131\123"]="\134\108",["\129\079\131\123"]="\129\109\129\079",["\133\103\130\084"]="\130\073\142\083"}
local function canon(n) return ALIAS[n] or n end
for _,r in ipairs(REGIONS) do for _,p in ipairs(r.places) do p[1]=canon(p[1]) end end
local ARROW={ul=119,ur=120,dl=121,dr=122}
local STORY={[54]={1.8,2.4,"ul"},[83]={31.5,3.3,"ur"},[84]={32,19.5,"dr"},[53]={31,19.5,"dr"},[44]={6,7,"ul"}}
local T=nil
local talking,eventDepth=0,0
local function ME() return 1 end
local function row(pid) for _,u in ipairs(JY.Smap) do if u[1]==pid then return u end end end
local function frame()
 JY.ReFreshTime=lib.GetTime()
 DrawSMap() lib.GetKey() ReFresh(1)
end
local function leg(v,d,n)
if n<0.01 then return end
v[4]=d
v[5]=1
while n>0 do
local s=math.min(0.25,n)
v[2]=v[2]+CC.DX[d]*s
v[3]=v[3]+CC.DY[d]*s
n=n-s
frame()
end
v[5]=0
end
-- furniture and walls of the town pictures (rects x1,y1,x2,y2 on the scene grid, inside = blocked) and open spots to go round
-- them by. A walk is two legs along the iso axes (one turn); when both ways round would cross something, he goes by a hub.
-- top: blocked above the line through {x,y} points (house fronts), bot: below it (bushes), left: {y,x} blocked left of it (trees)
local BLOCK={
[116]={-- 마을 거리 (성영걸전 132)
rects={{0,0,7.5,7},{1.5,12,7,14.5},{0,14,2.5,16.5},{22.5,7,34,12.5}},
top={{10,2},{12,2.5},{16,4},{18,4},{20,3},{23,4.5},{24,7},{26,8.5},{30,8.5},{34,8}},
bot={{9,22},{10,18},{12,16.5},{16,16},{20,17},{22,19},{23,22}},
hubs={{16,11},{12,9},{20,10},{10,15}}},
[125]={-- 시골 마을 (성영걸전 208)
top={{8,3},{9.5,4.5},{10,6.2},{13,7.5},{16,8},{17,8},{18,7},{20,7.5},{22,5.5},{25,5},{28,4},{31,3},{34,2.5}},
bot={{0,22},{12,22},{13,18.5},{16,17},{20,15.5},{24,14.5},{28,13.5},{30,12},{34,11}},
left={{0,4},{3,4.5},{9,4.5},{11,5},{12,6.5},{14,7},{16,6.5},{17,5},{18,4},{20,3},{22,3}},
hubs={{12,11},{18,11},{9,10},{9,17}}},
[117]={-- 주점 (성영걸전 134): tables with their cushions, the counter, jars, stairs, the wall left of the door
rects={{5,10.5,12.5,16},{19,9,29,14.5},{2,17.5,9,21.5},{14.5,16.5,22,21},{32,8,34,11},{13,3,24,8},{21,0,30,5},{30,0,34,7},{0,0,6,11}},
hubs={{15,9.5},{16,15.5},{24,16},{12,17},{30,15}}},
}
-- 회의장 장면 (story scene pictures): benches as segs {x1,y1,x2,y2} (blocked within 0.9 of the line, y counted double like the
-- iso grid), pillars / desks / thrones / screens as rects, the back walls as top lines. Carpets are walked on.
local BENCH=0.9
BLOCK[54]={rects={{21.5,0,24,5.5},{29,0,32,9},{20.5,13.5,25.5,16},{26,15,33,22},{12,16.5,15,21},{24.5,9.5,29.5,12}},
top={{20,0},{24,1.5},{26,3},{30,5},{34,6}},
segs={{6,3,13,7},{0,7.5,5.5,10.5},{15,8,23,12},{7.5,11.5,15,15}}}
BLOCK[87]={rects={{2,0,5,9},{9,0,12,6},{9.5,13,14,16},{0,15.5,8,22},{17.5,17.5,21,21},{4.5,10,8.5,12.5}},
top={{0,7},{6,6},{9,4},{12,3},{14,1},{16,0}},
segs={{20,6,27,2.5},{10,10.5,17,7},{31,11,34,9.5},{21,16,28,12.5}}}
BLOCK[83]={rects={{2,0,5,9},{10,0,12,5},{5.5,3,10,7.5},{13.5,0,18.5,3},{10,13,14.5,15.5},{0,15,9,22},{30,13.5,35,21},{4.5,9.5,8.5,12}},
top={{0,7},{6,6},{9,4},{12,3},{14,1},{16,0}},
segs={{20,5.5,27,2},{9,10,16,7},{31,11,34,9.5},{20.5,16,27.5,12.5}}}
BLOCK[48]={rects={{3.5,0,6,9},{11,0,13.5,4.5},{16,3,20,5.5},{23,6.5,27,9},{29,2.5,35,8},{32.5,8.5,35,11}},
top={{0,8},{4,7},{9,4},{14,2},{17,0}},
segs={{11.5,11,18.5,8},{2.5,15.5,9.5,12.5},{19,15,26,11.5},{10,19.5,17.5,16.5}}}
BLOCK[86]={rects={{3,0,6,8.5},{10,0,12.5,7},{6,3.5,10,7.5},{13.5,0,17.5,4},{22,7.5,26,10},{28,1,35,8},{30,15.5,35,22},{28.5,10,33,12.5}},
top={{0,7},{3,6},{6,4},{10,2},{14,0}},
segs={{10.5,11.5,17,8.5},{1,16,8,13},{19,16,26,12.5},{9,20,16,17.5}}}
BLOCK[85]={rects={{3,0,6,9.5},{10,0,12.5,7},{6,4,10,8},{13,0,18,3},{24,1,26,7},{22,7.5,26,10},{28,1,35,8.5},{31,16,35,21},{29.5,10,33.5,12}},
top={{0,7},{3,6},{6,4},{10,2},{14,0}},
segs={{10.5,11.5,17.5,8.5},{1,16,8,13},{18.5,16,26,12.5},{9,20,16,17}}}
BLOCK[84]={rects={{0,0,6,8},{6,6.5,11,9.5},{0,8.5,3,11},{14,3.5,18,6},{20.5,0,23,5},{27.5,0,30.5,8}},
top={{20,0},{25,1.5},{30,3.5},{34,5}},
segs={{16.5,7.5,23.5,11},{25,11.5,32.5,15.5},{8.5,11.5,15.5,15.5},{17.5,16,24.5,19.5}}}
BLOCK[53]={rects={{0,0,5,7},{6.5,6.5,11,9},{1.5,10,6.5,12.5},{17,0,21,4},{0,14.5,4,20},{21.5,0,24,5},{29.5,0,32.5,8.5}},
top={{20,0},{25,2},{30,4},{34,6}},
segs={{17.5,8.5,25.5,12.5},{9,13,16.5,17},{27.5,13.5,34,17},{19,18,26,21.5}}}
BLOCK[77]={rects={{2,0,8,9.5},{0,8,3,12},{17,0,23,8},{13,2,16,5},{23.5,3,30,8},{29,6,31,9},{28.5,8,29.5,11},{26.5,10,35,16},{27,17,28.5,21},{31,15,32.5,19},{17,9,23,12}},
top={{0,4},{10,0}}}
BLOCK[71]={top={{0,10},{4,8},{7,7},{12,4.5},{14,3},{20,1.5},{22,0}},rects={{29,11,35,20}}}
BLOCK[46]={rects={{7.5,0,9.5,9.5},{16.5,0,18.5,5},{25,0,27,9.5},{13,3,16,6},{9,4,11,7},{19.5,8,24,11},{30,9,31.5,11.5},{26.5,17.5,35,22},{0,7,3,12}},
top={{0,8},{6,6.5},{10,4.5},{15,3},{20,3},{25,5},{30,7.5},{34,9}}}
BLOCK[49]={rects={{0,0,5,7},{9,7.5,12,9.5},{1,5,2,8},{8,2,9.5,4.5},{9,0,11,2.5},{21,0,23.5,5},{28,0,31,8.5},{17,0,20.5,3.5},{23,3,27,7.5},{0,15,3.5,20},{0.5,10,2,11.5}},
top={{19,0},{24,1},{30,3},{34,5}},
segs={{2,9.5,4.5,11},{17,8,24,11.5},{9,12,16,15},{26,12.5,33,16},{18.5,17,25.5,20.5}}}
BLOCK[56]={rects={{0,0,13,10.5},{13,5,17,8},{2,10,6,12},{17,5,18.5,7.5},{7,11.5,8.5,13},{21,1,26,5.5},{29,5,32,9},{0,15.5,4,21},{4.5,18,8,22},{19,0,21,2},{26.5,0,29,5},{33,0,35,9}},
top={{18,0},{25,1},{30,2.5},{34,4}}}
BLOCK[47]={rects={{21.5,0,24,5},{29,0,32,9},{16,0,21.5,4},{23.5,2,29,8},{0,13.5,4.5,20.5},{20.5,12.5,25,15.5},{26,15.5,35,22},{25.5,10,29.5,12.5}},
top={{16,0},{24,1},{30,4},{34,6}},
segs={{8,2,15,5.5},{0,8.5,3.5,11},{18.5,7,25.5,11},{7.5,12.5,14.5,16.5}}}
BLOCK[44]={top={{0,11},{6,8},{11,6},{18,2},{19,1.5},{26,5},{34,9}},
rects={{13,4,16.5,7.5},{28,6,35,12},{26.5,8.5,30.5,11.5},{9,14,13,16.5},{0,15,7,22},{26,15.5,30,22}}}
local function lerp(t,u)-- the line value at u of points {u,v}
if u<=t[1][1] then return t[1][2] end
for i=2,#t do if u<=t[i][1] then local a,b=t[i-1],t[i] return a[2]+(b[2]-a[2])*(u-a[1])/(b[1]-a[1]) end end
return t[#t][2]
end
local function blocked(B,x,y)
for _,r in ipairs(B.rects or {}) do if x>r[1] and x<r[3] and y>r[2] and y<r[4] then return true end end
if B.top and y<lerp(B.top,x) then return true end
if B.bot and y>lerp(B.bot,x) then return true end
if B.left and x<lerp(B.left,y) then return true end
for _,s in ipairs(B.segs or {}) do
local ux,uy=s[3]-s[1],2*(s[4]-s[2])
local wx,wy=x-s[1],2*(y-s[2])
local t=math.max(0,math.min(1,(wx*ux+wy*uy)/(ux*ux+uy*uy)))
local ex,ey=wx-ux*t,wy-uy*t
if ex*ex+ey*ey<BENCH*BENCH then return true end
end
return false
end
function koTownBlocked(bg,x,y) return BLOCK[bg]~=nil and blocked(BLOCK[bg],x,y) end-- for test scripts
-- the turning point of a walk from (x0,y0) to (x,y): first = true -> the dir-0/1 leg first
local function turn(x0,y0,x,y,first)
local dx,dy=x-x0,y-y0
if first then local a=(dx/2-dy)/2 return x0+2*a,y0-a end
local b=(dx/2+dy)/2 return x0+2*b,y0+b
end
local function clearLine(B,x0,y0,x1,y1,ex,ey,sx,sy)
local n=math.max(1,math.ceil(math.max(math.abs(x1-x0)/2,math.abs(y1-y0))*4))
for i=0,n do
local x,y=x0+(x1-x0)*i/n,y0+(y1-y0)*i/n
if x<0 or x>35 or y<1 or y>22 then return false end-- off the picture
if (x-ex)^2+(2*(y-ey))^2>1.5 and (x-sx)^2+(2*(y-sy))^2>1.5 then-- the spots he walks from and to may stand against a wall
if blocked(B,x,y) then return false end
end
end
return true
end
local function len(x0,y0,mx,my,x,y) return math.abs(mx-x0)+math.abs(my-y0)*2+math.abs(x-mx)+math.abs(y-my)*2 end
-- the points 유비 passes from (x0,y0) to (x,y) (turning points and hubs), or the middle rule when the picture has no furniture list
function koTownRoute(bg,x0,y0,x,y)
local B=BLOCK[bg]
local best,bl
local function try(pts)
local l=0
for i=2,#pts do
if B and not clearLine(B,pts[i-1][1],pts[i-1][2],pts[i][1],pts[i][2],x,y,x0,y0) then return end
l=l+math.abs(pts[i][1]-pts[i-1][1])+2*math.abs(pts[i][2]-pts[i-1][2])
end
if not bl or l<bl then best,bl=pts,l end
end
local ax,ay=turn(x0,y0,x,y,true)
local bx,by=turn(x0,y0,x,y,false)
local amid=(ax-17)^2+(2*(ay-11))^2<=(bx-17)^2+(2*(by-11))^2
local p1={{x0,y0},{ax,ay},{x,y}}
local p2={{x0,y0},{bx,by},{x,y}}
if not B then return amid and p1 or p2 end
try(amid and p1 or p2)
if best then return best end
try(amid and p2 or p1)
if best then return best end
-- neither way round is clear: search the half-step lattice of the iso axes from (x0,y0) (state = a,b steps and the last dir,
-- a step costs 1 and a turn 3, so the fewest turns win), to the lattice point next to (x,y), then the last short two legs
local SA={[0]=1,-1,0,0}-- dir 0 +a, 1 -a, 2 -b, 3 +b
local SB={[0]=0,0,-1,1}
local function px(i,j) return x0+i+j,y0-i*0.5+j*0.5 end
local ta,tb=(x-x0)/2-(y-y0),(x-x0)/2+(y-y0)-- target in half steps
local gi,gj=math.floor(ta+0.5),math.floor(tb+0.5)
local function search(B)
local function key(i,j,d) return ((i+100)*201+(j+100))*4+d end
local dist,prev={},{}
local buckets={[0]={}}
for d=0,3 do local k=key(0,0,d) dist[k]=0 buckets[0][#buckets[0]+1]={0,0,d} end
local found
for c=0,600 do
local bq=buckets[c]
if bq then
for _,s in ipairs(bq) do
local i,j,d=s[1],s[2],s[3]
local k=key(i,j,d)
if dist[k]==c then
if i==gi and j==gj then found=k break end
for nd=0,3 do
local ni,nj=i+SA[nd],j+SB[nd]
local nx,ny=px(ni,nj)
if nx>=0 and nx<=35 and ny>=1 and ny<=22 and math.abs(ni)<100 and math.abs(nj)<100 then
local free=(nx-x)^2+(2*(ny-y))^2<=1.5 or (nx-x0)^2+(2*(ny-y0))^2<=4 or not blocked(B,nx,ny)
if free then
local nc=c+1+(nd~=d and 3 or 0)
local nk=key(ni,nj,nd)
if not dist[nk] or nc<dist[nk] then
dist[nk]=nc prev[nk]=k
buckets[nc]=buckets[nc] or {}
local nb=buckets[nc] nb[#nb+1]={ni,nj,nd}
end
end
end
end
end
end
if found then break end
end
end
if not found then return nil end
-- back from the goal, keeping the points where the dir changes
local cells={}
local k=found
while k do
local d=k%4 local r=(k-d)/4 local j=r%201-100 local i=(r-(j+100))/201-100
table.insert(cells,1,{i,j,d})
k=prev[k]
end
local pts={{x0,y0}}
for n=2,#cells do
if n==#cells or cells[n+1][3]~=cells[n][3] then local qx,qy=px(cells[n][1],cells[n][2]) pts[#pts+1]={qx,qy} end
end
local lx,ly=pts[#pts][1],pts[#pts][2]
if math.abs(lx-x)>0.01 or math.abs(ly-y)>0.01 then
local tx,ty=turn(lx,ly,x,y,true)
pts[#pts+1]={tx,ty}
pts[#pts+1]={x,y}
end
return pts
end
return search(B) or search({}) or (amid and p1 or p2)-- {}: no furniture, only the screen edges
end
-- one straight walk along an iso axis (or both axes when the line is diagonal on the grid: it never is)
local function walkLine(v,x,y)
local dx,dy=x-v[2],y-v[3]
if math.abs(dx)<0.01 and math.abs(dy)<0.01 then return end
local a=(dx/2-dy)/2
local b=(dx/2+dy)/2
if math.abs(a)>0.01 then leg(v,a>0 and 0 or 1,math.abs(a)) end
if math.abs(b)>0.01 then leg(v,b>0 and 3 or 2,math.abs(b)) end
end
-- 유비 walks to x,y by koTownRoute: around the furniture of the picture, turning nearer the middle
local function walkTo(x,y)
local v=row(ME())
if not v then return end
local pts=koTownRoute(JY.SubScene,v[2],v[3],x,y)
for i=2,#pts do walkLine(v,pts[i][1],pts[i][2]) v[2],v[3]=pts[i][1],pts[i][2] end
v[2],v[3]=x,y
v[5]=0
frame()
end


local function currentCity()
 local city="\129\103\129\093"
 for ev=1,JY.EventID do if EVENTS[ev] then city=EVENTS[ev] end end
 return city
end
function koWujeTownFacts() return currentCity(),CATALOG end
local function available()
 local native=rawget(_G,"koTownData")
 if native and native() then return false end
 local f=rawget(_G,"koWujeCampaignActive")
 return not T and f and f() and JY.Status==GAME_SMAP_MANUAL and JY.SubScene>0 and eventDepth==0 and talking==0
end
local function exitSpot()
 local f=rawget(_G,"koWujeHallExit")
 return (f and f(JY.SubScene)) or STORY[JY.SubScene] or {2.5,20,"dl"}
end
local function arrowRect(s)
 local x,y=27+18*s[1],19+18*s[2]
 return x-44,y-26,x+44,y+26
end
local function arrow(s)
 lib.PicLoadCache(5,ARROW[s[3]]*2,27+18*s[1]-48,19+18*s[2]-28,1)
end
local function textButton(x,y,w,label)
 lib.Background(x,y,x+w,y+28,210,RGB(26,35,66))
 lib.DrawRect(x,y,x+w,y+28,C_Name)
 DrawString(x+8,y+6,label,M_White,16)
end
local function stamp(x,y,label)
 local w=#label*8+16
 textButton(math.max(18,math.min(638-w,x-w/2)),math.max(20,y-62),w,label)
end
local function known(name)
 name=canon(name)
 if name==canon(T.home) then return true end
 for _,p in ipairs(CATALOG) do if canon(p[1])==name and p[2]<=JY.EventID then return true end end
 return T.preview and (name=="\132\089\134\111" or name=="\135\109\134\103")
end
local function findPlace(r,name)
 for _,p in ipairs(r.places) do if p[1]==canon(name) then return p end end
end
local function regionFor(name)
 for _,r in ipairs(REGIONS) do if findPlace(r,name) then return r end end
end
-- 6.0 (11-03, 다시 전투 이야기판 — 도구/캠페인다시전투.py): a place where a battle of this story can be replayed now (town.lua koCampReplayAt),
-- and the region map with the most of them (opened when the home town is on none)
local function replayAt(name) local f=rawget(_G,"koCampReplayAt") return f~=nil and #f(name)>0 end
local function replayRegion() local best,bn for _,r in ipairs(REGIONS) do local n=0 for _,p in ipairs(r.places) do if replayAt(p[1]) then n=n+1 end end if n>0 and (not bn or n>bn) then best,bn=r,n end end return best end
local CELL=40
local function RG() return T.region end
local function road(x,y)
 local r=RG().road[y+1]
 return r and r:sub(x+1,x+1)=="."
end
local function camFollow()
 local q=T.R
 q.camx=math.max(0,math.min(RG().w*CELL-640,q.px-320))
 q.camy=math.max(0,math.min(RG().h*CELL-400,q.py-200))
end
local function regionDir(dx,dy)
 if dy<0 then return dx>0 and 0 or 2 elseif dy>0 then return dx<0 and 1 or 3 end
 return dx>0 and 3 or 1
end
local function findPath(tx,ty)
local Q=T.R
local W,H=RG().w,RG().h
local sx,sy=Q.cx,Q.cy
local prev={}
local function key(x,y) return y*W+x end
local q,qi={{sx,sy}},1
prev[key(sx,sy)]=-1
while q[qi] do
local x,y=q[qi][1],q[qi][2]
qi=qi+1
if x==tx and y==ty then break end
for dy=-1,1 do for dx=-1,1 do
local nx,ny=x+dx,y+dy
if (dx~=0 or dy~=0) and nx>=0 and ny>=0 and nx<W and ny<H and prev[key(nx,ny)]==nil and (road(nx,ny) or (nx==tx and ny==ty)) then
prev[key(nx,ny)]=key(x,y)
q[#q+1]={nx,ny}
end
end end
end
if prev[key(tx,ty)]==nil then return nil end
local path={}
local k=key(tx,ty)
while k~=-1 do
table.insert(path,1,{k%W,math.floor(k/W)})
k=prev[k]
end
return path
end
local function regionWalk(path)
local Q=T.R
for i=2,#path do
local tx,ty=path[i][1]*CELL+CELL/2,path[i][2]*CELL+CELL/2
local dx,dy=tx-Q.px,ty-Q.py
Q.dir=regionDir(dx,dy)
local n=math.max(1,math.floor(math.max(math.abs(dx),math.abs(dy))/5))
for s=1,n do
Q.px=Q.px+dx/n Q.py=Q.py+dy/n
Q.anim=(Q.anim%4)+1
camFollow()
frame()
end
Q.px,Q.py=tx,ty
Q.cx,Q.cy=path[i][1],path[i][2]
end
Q.anim=0
frame()
end

local function buildStreet(name)
 T.town=name T.mode="street" JY.Base[LOC]=name
 JY.SubScene=116 JY.Smap={{1,8,17,0,0},{375,25,14,1,0}}
 JY.Tid=0
end
local function enterStreet(name)
 Dark() buildStreet(name) DrawSMap() Light()
end
local function mapOut()
 local r=regionFor(T.town) or replayRegion()
 if not r then return false end
 local p=findPlace(r,T.town)
 if not p then for _,v in ipairs(r.places) do if replayAt(v[1]) then p=v break end end end
 T.region=r T.mode="region"
 T.R={cx=p[2],cy=p[3],px=p[2]*CELL+20,py=p[3]*CELL+20,dir=1,anim=0}
 camFollow() Dark() DrawSMap() Light()
 return true
end
local function destinationMenu()
 local list,menu={},{}
 local seen={}
 local function add(name)
  local k=canon(name)
  if seen[k] or k==canon(T.town) then return end
  seen[k]=true list[#list+1]=name
  menu[#menu+1]={name..(k==canon(T.home) and " (\134\069\135\070)" or ""),nil,1}
 end
 add(T.home)
 for _,p in ipairs(CATALOG) do if known(p[1]) then add(p[1]) end end
 if T.preview then add("\132\089\134\111") add("\135\109\134\103") end
 if #menu==0 then DrawMulitStrBox("\129\110\132\076 \129\071\130\108\129\088 \129\113 \132\079\130\098 \129\077\135\077 \133\088\129\083\129\071 \130\097\129\075\129\076\129\077.") return end
 DrawSMap()
 local n=ShowMenu(menu,#menu,math.min(10,#menu),180,70,0,0,3,1,16,M_White,M_Yellow)
 if n>0 then
  local name=list[n]
  if WarDrawStrBoxYesNo(name.." \133\088\129\083\132\083 \129\071\130\108\129\097\130\086\134\121\129\075\129\076\129\089?",M_White,true) then
   -- On a shared native map the entire journey follows its road bitmap.
   local p=T.mode=="region" and findPlace(RG(),name)
   if p then
    local path=findPath(p[2],p[3])
    if not path then DrawMulitStrBox("\129\071 \130\067\129\068\129\102\131\087\130\098 \134\114\129\071 \133\066\134\064\132\067\130\083 \132\079\130\067 \130\107\129\075\129\076\129\077.") return end
    regionWalk(path)
   end
   enterStreet(name)
  end
 end
end
local function drawRegion()
 local q=T.R
 lib.FillColor(0,0,0,0,0)
 lib.SetClip(16,16,656,416)
 lib.PicLoadCache(5,RG().pic*2,16-q.camx,16-q.camy,1)
 local x,y=16+q.px-q.camx,16+q.py-q.camy
 local anim=({[0]=0,1,0,2,0})[q.anim] or 0
 if x>40 and x<632 and y>80 and y<416 then
  lib.SetClip(x-24,y-64,x+24,y)
  lib.PicLoadCache(5,(200+JY.Person[1][FIG]*4+q.dir)*2,x-24,y-64-anim*64,1)
 end
 lib.SetClip(0,0,0,0)
 lib.PicLoadCache(4,201*2,0,0,1) DrawGameStatus()
 lib.SetClip(16,16,656,416)
 for _,p in ipairs(RG().places) do if known(p[1]) or replayAt(p[1]) then
  local px,py=16+p[2]*CELL+20-q.camx,16+p[3]*CELL+20-q.camy
  if px>70 and px<600 and py>80 and py<385 then stamp(px,py+90,p[1]) end
 end end
 lib.SetClip(0,0,0,0)
 textButton(24,24,112,"\134\069\135\070 \137\066\129\110\129\094\131\071") textButton(144,24,112,"\129\071\130\108\129\088 \133\088\129\083")
end
local draw=DrawSMap
function DrawSMap(...)
 if T and T.mode=="region" then drawRegion() return end
 draw(...)
 if T then
  if T.mode=="street" then
   arrow({8,4,"ul"}) arrow({3,19,"dl"})
   stamp(27+18*8,19+18*4,"\130\125\131\080\131\097") stamp(27+18*3,19+18*19,"\133\088\129\083 \139\119")
   stamp(27+18*23,19+18*5,"\130\075\135\070")
  else arrow({9,8,"ul"}) end
 elseif available() then arrow(exitSpot()) end
end
local function quiet(fn)
 return function(...)
  talking=talking+1
  local ok,r=pcall(fn,...)
  talking=talking-1
  if not ok then error(r,0) end
  return r
 end
end
talk=quiet(talk) talkYesNo=quiet(talkYesNo)
local de=DoEvent
function DoEvent(...)
 eventDepth=eventDepth+1
 local ok,r=pcall(de,...)
 eventDepth=eventDepth-1
 if not ok then error(r,0) end
 return r
end
local function hit(x,y,rx,ry)
 return MOUSE.CLICK(x-rx,y-ry,x+rx,y+ry)
end
local function townLoop()
 while true do
  JY.ReFreshTime=lib.GetTime() DrawSMap() ShowScreen()
  local e,k=koPollKey()
  if MOUSE.EXIT() then koExit() end
  if T.mode=="region" then
   local q=T.R
   if MOUSE.CLICK(24,24,136,52) then
    local p=findPlace(RG(),T.home)
    if p then local path=findPath(p[2],p[3]) if path then regionWalk(path) end end
    return
   elseif MOUSE.CLICK(144,24,256,52) then destinationMenu()
   elseif (e==1 and k==27) or MOUSE.ESC() then enterStreet(T.town)
   elseif MOUSE.CLICK(16,55,656,416) then
    local p,best
    for _,v in ipairs(RG().places) do
     local x,y=16+v[2]*CELL+20-q.camx,16+v[3]*CELL+20-q.camy
     local d=(MOUSE.x-x)^2+(MOUSE.y-y)^2
     if d<48^2 and (not best or d<best) then p,best=v,d end
    end
    if p and replayAt(p[1]) then
     local path=findPath(p[2],p[3])
     if path then regionWalk(path)
      local r=koCampReplayAsk(p[1],known(p[1]))
      if r==0 then enterStreet(p[1]) elseif r then T.replay=r return end
     else DrawMulitStrBox("\129\071 \130\067\129\068\129\102\131\087\130\098 \134\114\129\071 \133\066\134\064\132\067\130\083 \132\079\130\067 \130\107\129\075\129\076\129\077.") end
    elseif p then
     if known(p[1]) then
      local path=findPath(p[2],p[3])
      if path then regionWalk(path) if WarDrawStrBoxYesNo(p[1].." \133\088\129\083\132\083 \131\082\130\083\129\094\130\086\134\121\129\075\129\076\129\089?",M_White,true) then enterStreet(p[1]) end
      else DrawMulitStrBox("\129\071 \130\067\129\068\129\102\131\087\130\098 \134\114\129\071 \133\066\134\064\132\067\130\083 \132\079\130\067 \130\107\129\075\129\076\129\077.") end
     else DrawMulitStrBox("\129\110\132\076 \132\078\133\090\129\097\130\067 \130\107\131\098 \130\067\134\074\129\104\129\076\129\077.") end
    end
   else
    if MOUSE.IN(16,55,656,416) then
     if MOUSE.x<40 then q.camx=q.camx-12 elseif MOUSE.x>632 then q.camx=q.camx+12 end
     if MOUSE.y<75 then q.camy=q.camy-12 elseif MOUSE.y>392 then q.camy=q.camy+12 end
    end
    if e==1 then
     if k==VK_LEFT then q.camx=q.camx-40 elseif k==VK_RIGHT then q.camx=q.camx+40
     elseif k==VK_UP then q.camy=q.camy-40 elseif k==VK_DOWN then q.camy=q.camy+40 end
    end
    q.camx=math.max(0,math.min(RG().w*CELL-640,q.camx)) q.camy=math.max(0,math.min(RG().h*CELL-400,q.camy))
   end
  elseif T.mode=="inn" then
   if MOUSE.CLICK(673,321,710,366) then HirePerson()
   elseif (e==1 and k==27) or MOUSE.ESC() or MOUSE.CLICK(arrowRect({9,8,"ul"})) then enterStreet(T.town) end
  else
   if MOUSE.CLICK(arrowRect({8,4,"ul"})) then
    walkTo(8,4)
    if canon(T.town)==canon(T.home) then return end
    DrawMulitStrBox("\133\098\130\066 \131\101\130\080\130\098 "..T.home.." \134\069\135\070 \130\125\131\080\131\097\129\102\131\087 \129\088 \129\113 \132\079\129\075\129\076\129\077.")
   elseif MOUSE.CLICK(arrowRect({3,19,"dl"})) then
    walkTo(3,19)
    if not mapOut() then destinationMenu() end
   elseif hit(27+18*23,math.max(20,19+18*5-48),55,22) then
    walkTo(23,5) Dark() T.mode="inn" JY.SubScene=117 JY.Smap={{1,16,15,0,0}} DrawSMap() Light()
    HirePerson()
   elseif hit(27+18*25,19+18*14-32,24,32) or MOUSE.CLICK(673,369,710,414) then
    walkTo(23,15) koWujeTownShop() DrawSMap()
   elseif MOUSE.CLICK(713,321,750,366) then Person_Menu()
   elseif MOUSE.CLICK(713,369,750,414) then DrawMulitStrBox("\133\102\131\097\129\123 \132\118\132\075 \129\103\130\093\131\098 \134\069\135\070 \130\125\131\080\131\097\131\109\132\083 \137\066\129\110\129\094\131\087 \129\088 \129\113 \132\079\129\075\129\076\129\077.")
   elseif (e==1 and k==27) or MOUSE.ESC() then
    if canon(T.town)==canon(T.home) then return else
     if WarDrawStrBoxYesNo(T.home.." \134\069\135\070\131\109\132\083 \137\066\129\110\129\094\130\086\134\121\129\075\129\076\129\089?",M_White,true) then return end
    end
   end
  end
  if MOUSE.status=="CLICK" then MOUSE.status="IDLE" end
  lib.Delay(10)
 end
end
function koWujeTownVisit(preview)
 if T or not available() then return end
 local old={scene=JY.SubScene,smap=JY.Smap,room=SnrRoom,loc=JY.Base[LOC],tid=JY.Tid,status=JY.Status,event=JY.EventID}
 local hero=row(1)
 local pos=hero and {hero[2],hero[3],hero[4],hero[5]}
 T={home=currentCity(),town=currentCity(),preview=preview}
 local ok,err=pcall(function()
  if hero then local out=exitSpot() walkTo(out[1],out[2]) end
  enterStreet(T.home)
  if preview then DrawMulitStrBox("\133\088\129\083 \139\119 \129\064\134\106\133\113\132\083 \131\118\129\094 \132\089\134\111\161\164\135\109\134\103\131\109\132\083 \129\071\130\108\129\066 \131\115\135\073\130\086\129\091.*\130\125\131\080\131\097 \135\079\130\098 \130\067\134\074 \130\067\129\068\131\080 \134\069\135\070 \137\066\129\110\129\094\131\071\132\083 \137\066\129\110\131\105 \129\113 \132\079\129\075\129\076\129\077.") end
  townLoop()
 end)
 local rp=T and T.replay
 T=nil
 if hero and pos then hero[2],hero[3],hero[4],hero[5]=pos[1],pos[2],pos[3],pos[4] end
 JY.SubScene,JY.Smap,SnrRoom=old.scene,old.smap,old.room
 JY.Base[LOC],JY.Tid,JY.Status,JY.EventID=old.loc,old.tid,old.status,old.event
 if not ok then error(err,0) end
 Dark() DrawSMap() Light()
 if rp and rawget(_G,"koCampReplayStart") then koCampReplayStart(rp) end-- 6.0 (11-03): the picked battle, after the walk
end
local smapEvent=SMapEvent
function SMapEvent(...)
 smapEvent(...)
 if available() and MOUSE.CLICK(arrowRect(exitSpot())) then PlayWavE(0) koWujeTownVisit(false) end
end
