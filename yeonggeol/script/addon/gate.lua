-- ko 3.0: 술집 조건에 무술 대회 (무장 메뉴 > 무술 대회, 우승 事件1971 / 4강 진출 事件1972; both carried into the next cycle).
if not koNeeds("tourney","record") then return end
--   진평 403: 술 겨루기 12번째 또는 4강 1회   목인 388: 술 겨루기 10번째 + 우승 1회   호적 405: 술 겨루기 13번째 + 우승 2회
--   (ko 4.0 later: 술 겨루기 N번째 = the drink addon's boss at stage N beaten = 연전 record >= N)
--   여포 (tavern slot 442): 술 겨루기 11번째 + 서주 2번째 전투 후 (as before) + 우승 3회 -> until then shown as ??? with the conditions
local koEV="\202\194\188\254"
local function koLlk() return JY.Base[koEV.."333"] or 0 end
function koTourWins() return JY.Base[koEV.."1971"] or 0 end
function koTourSemis() return JY.Base[koEV.."1972"] or 0 end
-- ko 4.0 later: the condition line for the 연전 boss at stage n (drink addon; the old 연전 N회 text when it is off)
function koStreakLine(n)
local dc=rawget(_G,"koDrinkCond") if dc then return dc(n) end-- strict _G: an absent global errors on read
return "\133\066\130\066 "..n.."\130\125 ("..math.min(koLlk(),n).."/"..n..")"-- 연전 N회 (x/N)
end
-- db3 entry v (its old 연전 threshold i): shown at all? locked (??? + conditions) while the tournament part is missing?
function koTourGate(v,i)
if v==403 then return (koStreakOK(12) or koTourSemis()>=1),false end
if v==388 then return koStreakOK(10),(koTourWins()<1) end
if v==405 then return koStreakOK(13),(koTourWins()<2) end
return koStreakOK(i),false
end
-- the tavern's locked-entry text for these three (nil for anyone else, so koUnlockText keeps 유방·항우)
function koTourLockText(pid)
local c={}
local who
if pid==442 then
who="\129\098\134\097\130\104 \133\086\131\109\131\096\129\065"-- 여포를 얻으려면
c[1]={koStreakOK(11),koStreakLine(11)}-- 술 겨루기 11번째 여포
c[2]={JY.EventID>koEvScale(226),CONFIG.koCamp and "\129\071\133\069\131\071\130\104 \132\108 \129\103\130\093\129\111 \135\068" or "1\131\097 \131\087\130\075 2\130\087\142\091 \130\066\132\101 \133\067"}-- 1장 서주 2번째 전투 후
c[3]={koTourWins()>=3,"\129\073\131\072 \130\095\130\125 \131\079\129\116 3\130\125 ("..math.min(koTourWins(),3).."/3)"}-- 무술 대회 우승 3회
elseif pid==388 then
who="\131\099\129\106\129\083 \133\086\131\109\131\096\129\065"-- 목인을 얻으려면
c[1]={koStreakOK(10),koStreakLine(10)}-- 술 겨루기 10번째 목인
c[2]={koTourWins()>=1,"\129\073\131\072 \130\095\130\125 \131\079\129\116 1\130\125 ("..math.min(koTourWins(),1).."/1)"}
elseif pid==405 then
who="\134\113\131\076\129\083 \133\086\131\109\131\096\129\065"-- 호적을 얻으려면
c[1]={koStreakOK(13),koStreakLine(13)}-- 술 겨루기 13번째 호적
c[2]={koTourWins()>=2,"\129\073\131\072 \130\095\130\125 \131\079\129\116 2\130\125 ("..math.min(koTourWins(),2).."/2)"}
else
return nil
end
local s=who
for _,x in ipairs(c) do s=s.."*"..(x[1] and "O " or "X ")..x[2] end
s=s.."*\129\118\129\119\129\083 \130\090\130\091 \133\094\131\079\129\065 \133\125\132\111\129\088 \129\113 \132\079\129\075\129\076\129\077"-- 조건을 모두 채우면 등용할 수 있습니다
return s
end


-- ---- registration (ko 3.1 addon "gate": 술집 조건에 무술 대회; needs tourney + record)
koAddon.carry[#koAddon.carry+1]={from=1971,to=1972}
koOn("tavern_show",function(v,i) local show,lock=koTourGate(v,i) return show end)
koOn("tavern_lock",function(v,i) local show,lock=koTourGate(v,i) return lock end)
koOn("tavern_slot_lock",function(i) if i==442 and koTourWins()<3 then return true end return nil end)-- 여포
koOn("tavern_lock_text",function(pid) return koTourLockText(pid) end)
