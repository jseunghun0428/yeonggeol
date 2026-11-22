-- ko 6.0 (10-27): bounty — 적장 현상수배 (설계: 개발용/문서/적장 현상수배 설계안.md)
-- (UTF-8 원본: 개발용/addon/bounty_src.lua -> 도구/free_hz.pl -> script/addon/bounty.lua, addons.lua 에서 battlebonus·town·storyhire 뒤, recsave 앞)
--
-- 이야기 전투(외전 포함)마다 현상 1 (1회차부터) · 현상 2 (2회차부터). 조건을 지키며 대상을 쓰러뜨리고 이기면 승리 정산 뒤 보상:
--  금 = 등급별 500 · 1000 · 2000 · 3000 (현상 2 는 1.5배, 회차마다 +10% 최대 3배), 도구 = 등급(하·중·상·특, 3회차부터 한 단계 위), 대상의 술집 사본 호감 +15 / +25.
--  보상은 jymain war_won (이긴 전투 뒤, 모든 모드) 에서. 우리 편 판정은 君主 1 (War.Person.friend 는 소속이 다르다는 뜻이라 안 씀).
--  특 = 새 보물 212~217 (도구/patch_현상보물_데이터.pl). 이미 가졌으면 상 등급 도구 + 금 1.5배.
-- 자유 전투(CC.koFree) · 마을 전투(CC.koTownBattle) · 다시 전투(CC.koReplay) 에는 없음.
-- 표시: 승리조건 창의 보너스 목표 아래 「현상수배」 줄 (battlebonus 의 koBonusFmt 를 감쌈 — 보너스가 없는 전투는 War.koBonusText="" 로 그 창을 씀),
--  대상 부대 왼쪽 위 ◆, 달성 · 실패 순간 한 줄 알림, 기록 화면 「현상」 탭.
-- 저장 (세이브마다, 회차마다 새로 — 새 회차는 LoadRecord(0) 이 인물 칸을 새로 깖):
--  인물 칸 782 = 이번 회차에 받은 현상 비트 (외호 24~36 · 136~150 의 16비트 15칸, 칸마다 15비트 → 225칸 = 전투 112개 x 2)
--  인물 칸 783 = 지금 전투의 상태 (24 전투 번호, 26 상태 2비트 x 2 (0 남음 1 달성 2 실패), 28 · 30 셈)
--  둘 다 君主 0 · 얼굴 0 인 storyhire 예비 칸(782~801)이라 다른 루프가 건드리지 않음. 전투 중 저장 · 되감기도 인물 칸과 함께 돌아감.
-- 표 B 는 덧붙이기만 (순서 = 비트 자리).

local PS=CC.PersonSize
local NAME=string.char(208,213,195,251)      -- 姓名
local HP=string.char(177,248,193,166)        -- 兵力
local LORD=string.char(190,253,214,247)      -- 君主
local ITEM=string.char(181,192,190,223)      -- 道具 (..1~8)
local EQUIP={string.char(206,228,198,247),string.char(183,192,190,223),string.char(184,168,214,250)}-- 武器 防具 辅助
local S_DONE,S_TMP=782,783
local WORDS={24,26,28,30,32,34,36,136,138,140,142,144,146,148,150}

-- ---------------------------------------------------------------- 현상 표
-- {전투 이름, {현상 1}, {현상 2}}. 줄: s 문구, p 대상(인물 번호), by 지정 무장 이름들, t 턴 안, mg 책략으로, cnt 지정 무장(by[1])의 격파 수,
--  g 등급 1 하 2 중 3 상 4 특, it 특 등급 보물. 현상 2 가 없으면 nil. 보너스 목표와 겹치면 현상이 더 어렵게 (설계안 4-1-1).
local B=(rawget(_G,"koCamp") and koCamp.bounty) or {
{"\131\087\131\097 \130\114\129\113\129\101 \130\066\132\101",{s="\129\071\134\102 \130\112\134\086",p=21,g=1},{s="\129\118\135\100\129\083 4\129\112 \130\111\129\102 \130\112\134\086",p=28,t=4,g=2}},
{"\131\087\131\097 \134\113\132\098\129\101 \130\066\132\101",{s="\135\112\135\113 \130\112\134\086",p=75,g=1},{s="\131\097\129\085\130\104 4\129\112 \130\111\129\102 \130\112\134\086",p=80,t=4,g=4,it=212}},
{"\129\1001\131\097 \131\078\129\068\131\123 \130\066\132\101",{s="\132\065\131\079\131\064\129\083 6\129\112 \130\111\129\102 \130\112\134\086",p=106,t=6,g=1},{s="\129\101\131\079\132\083 \132\065\131\079\131\064\129\083 5\129\112 \130\111\129\102 \130\112\134\086",p=106,by={"\129\101\131\079"},t=5,g=2}},
{"\129\1001\131\097 \130\072\130\115 \130\066\132\101",{s="\131\097\130\080\132\083 \135\087\131\071 \130\112\134\086",p=55,by={"\131\097\130\080"},g=1},{s="\135\087\131\071\130\104 4\129\112 \130\111\129\102 \130\112\134\086",p=55,t=4,g=2}},
{"\129\1001\131\097 \137\082\129\097 \130\066\132\101",{s="\129\125\131\080\130\104 8\129\112 \130\111\129\102 \130\112\134\086",p=61,t=8,g=1},{s="\129\125\131\080\130\104 5\129\112 \130\111\129\102 \130\112\134\086",p=61,t=5,g=2}},
{"\129\1001\131\097 \134\069\133\108 \130\066\132\101",{s="\131\100\134\118 \130\112\134\086",p=104,g=1},{s="\129\101\131\079\132\083 \130\111\132\088 \130\112\134\086",p=52,by={"\129\101\131\079"},g=2}},
{"\129\1001\131\097 \132\084\132\087 \130\066\132\101",{s="\133\090\133\099 \130\112\134\086",p=53,g=1},{s="\133\102\129\113\130\104 \130\117\130\118\131\109\132\083 \130\112\134\086",p=51,mg=true,g=2}},
{"\129\1001\131\097 \135\107\129\066 \130\066\132\101",{s="\129\101\131\079\132\083 \129\101\129\066 \130\112\134\086",p=217,by={"\129\101\131\079"},g=1},{s="\129\101\129\066\130\104 6\129\112 \130\111\129\102 \130\112\134\086",p=217,t=6,g=2}},
{"\129\1001\131\097 \131\087\130\075I \130\066\132\101",{s="\135\106\129\094 \130\112\134\086",p=62,g=1},{s="\131\097\130\080\132\083 \131\079\131\103\129\083 8\129\112 \130\111\129\102 \130\112\134\086",p=63,by={"\131\097\130\080"},t=8,g=2}},
{"\129\1001\131\097 \129\109\129\079 \130\066\132\101",{s="\130\066\130\110 \130\112\134\086",p=387,g=2},{s="\129\101\131\079\132\083 \129\097\133\067\135\093 \130\112\134\086",p=17,by={"\129\101\131\079"},g=3}},
{"\129\1001\131\097 \130\124\132\091 \130\066\132\101",{s="\131\097\130\080\129\094 \131\076 \130\094\130\095 4 \130\112\134\086",by={"\131\097\130\080"},cnt=4,g=1},nil},
{"\129\1001\131\097 \141\069\131\123 \130\066\132\101",{s="\129\101\131\079\132\083 \129\118\129\097 \130\112\134\086",p=224,by={"\129\101\131\079"},g=1},nil},
{"\129\1001\131\097 \129\097\130\119 \130\066\132\101",{s="\129\101\131\079\129\094 \131\076 \130\094\130\095 3 \130\112\134\086",by={"\129\101\131\079"},cnt=3,g=1},nil},
{"\129\1001\131\097 \130\125\133\103 \130\066\132\101",{s="\131\071\130\089 \130\112\134\086",p=70,g=1},{s="\131\097\130\080\132\083 \131\100\132\065 \130\112\134\086",p=73,by={"\131\097\130\080"},g=2}},
{"\129\1001\131\097 \141\069\131\123II \130\066\132\101",{s="\135\106\129\094\129\094 \131\076 \130\094\130\095 2 \130\112\134\086",by={"\135\106\129\094"},cnt=2,g=1},nil},-- 11-08: 장료는 하구II 에만 나옴 → 하구II 줄은 맨 끝(비트 자리 유지)
{"\129\1001\131\097 \129\097\130\080 \130\066\132\101",{s="\131\100\132\065 \130\112\134\086",p=73,g=2},{s="\129\103\134\088\129\083 \130\117\130\118\131\109\132\083 \130\112\134\086",p=76,mg=true,g=4,it=213}},
{"\129\1001\131\097 \130\072\142\083 \130\066\132\101",{s="\131\097\130\080\132\083 \131\071\130\089 \130\112\134\086",p=70,by={"\131\097\130\080"},g=1},{s="\131\081\135\104\129\083 6\129\112 \130\111\129\102 \130\112\134\086",p=43,t=6,g=2}},
{"\129\1001\131\097 \131\087\130\075II \130\066\132\101",{s="\132\121\130\075 \130\112\134\086",p=90,g=2},{s="\135\109\133\102 \130\112\134\086",p=68,g=3}},
{"\129\1002\131\097 \133\066\130\075 \130\066\132\101",{s="\129\118\135\083\131\109\132\083 \135\106\129\068 \130\112\134\086",p=93,by={"\129\118\135\083"},g=2},{s="\131\097\129\087 \130\112\134\086",p=103,g=3}},
{"\129\1002\131\097 \129\126\130\115 \130\066\132\101",{s="\130\075\130\089 \130\112\134\086",p=96,g=2},{s="\129\101\131\079\132\083 \133\094\134\111\129\083 12\129\112 \130\111\129\102 \130\112\134\086",p=153,by={"\129\101\131\079"},t=12,g=3}},
{"\129\1002\131\097 \129\098\133\103 \130\066\132\101",{s="\131\087\130\085 \130\112\134\086",p=79,g=2},{s="\131\097\130\080\132\083 \135\109\133\102 \130\112\134\086",p=68,by={"\131\097\130\080"},g=3}},
{"\129\1002\131\097 \130\073\129\097 \130\066\132\101",{s="\129\118\135\083\131\109\132\083 \129\103\135\089 \130\112\134\086",p=119,by={"\129\118\135\083"},g=2},{s="\129\103\135\089\129\083 5\129\112 \130\111\129\102 \130\112\134\086",p=119,t=5,g=3}},
{"\129\1002\131\097 \133\103\134\111 \130\066\132\101",{s="\129\118\135\095 \130\112\134\086",p=20,g=2},{s="\129\098\129\067\129\083 \130\117\130\118\131\109\132\083 \130\112\134\086",p=125,mg=true,g=3}},
{"\129\1002\131\097 \131\078\133\069I \130\066\132\101",{s="\129\111\134\113 \130\112\134\086",p=130,g=2},{s="\129\097\133\067\130\100\129\083 \130\117\130\118\131\109\132\083 \130\112\134\086",p=129,mg=true,g=3}},
{"\129\1002\131\097 \136\123\136\111\134\086 \130\066\132\101",{s="\131\079\131\103\129\083 \130\117\130\118\131\109\132\083 \130\112\134\086",p=63,mg=true,g=2},{s="\129\071\130\066\129\083 \130\117\130\118\131\109\132\083 8\129\112 \130\111\129\102 \130\112\134\086",p=116,mg=true,t=8,g=3}},
{"\129\1002\131\097 \134\111\134\111I \130\066\132\101",{s="\131\097\135\104 \130\112\134\086",p=131,g=2},{s="\129\118\135\083\131\109\132\083 \133\090\135\120 \130\112\134\086",p=122,by={"\129\118\135\083"},g=3}},
{"\129\1002\131\097 \131\097\130\070\134\086I \130\066\132\101",{s="\129\118\135\083\131\109\132\083 \129\097\133\067\131\098 \130\112\134\086",p=136,by={"\129\118\135\083"},g=2},{s="\129\118\135\083\129\071 \131\076 \130\094\130\095 6 \130\112\134\086",by={"\129\118\135\083"},cnt=6,g=4,it=215}},
{"\129\1002\131\097 \131\097\130\070\134\086II \130\066\132\101",{s="\131\097\130\080\132\083 \129\097\133\067\130\064 \130\112\134\086",p=141,by={"\131\097\130\080"},g=2},{s="\129\118\135\083\131\109\132\083 \132\065\131\079\131\064 \130\112\134\086",p=106,by={"\129\118\135\083"},g=3}},
{"\129\1003\131\097 \130\073\142\083 \130\066\132\101",{s="\131\079\131\103 \130\112\134\086",p=171,g=2},{s="\135\078\135\125 \130\112\134\086",p=148,g=3}},
{"\129\1003\131\097 \129\073\142\083 \130\066\132\101",{s="\134\111\136\065 \130\112\134\086",p=225,g=2},nil},
{"\129\1003\131\097 \129\126\142\083 \130\066\132\101",{s="\131\097\130\080\132\083 \136\069\129\068\129\126 \130\112\134\086",p=178,by={"\131\097\130\080"},g=2},nil},
{"\129\1003\131\097 \132\084\134\111 \130\066\132\101",{s="\129\118\135\083\131\109\132\083 \134\097\135\108 \130\112\134\086",p=152,by={"\129\118\135\083"},g=2},{s="\129\103\132\105\129\083 8\129\112 \130\111\129\102 \130\112\134\086",p=180,t=8,g=3}},
{"\129\1003\131\097 \131\097\130\114 \130\066\132\101",{s="\129\101\131\079\129\094 \131\076 \130\094\130\095 3 \130\112\134\086",by={"\129\101\131\079"},cnt=3,g=2},{s="\129\111\129\114 \130\112\134\086",p=183,g=3}},
{"\129\1003\131\097 \130\074\130\111 \130\066\132\101",{s="\131\097\136\067 \130\112\134\086",p=162,g=2},{s="\131\077\132\119 \130\112\134\086",p=167,g=3}},
{"\129\1003\131\097 \132\089I \130\066\132\101",{s="\130\110\133\066\131\109\132\083 \136\073\134\097 \130\112\134\086",p=195,by={"\130\110\133\066"},g=2},{s="\131\097\130\080\132\083 \131\097\129\082 \130\112\134\086",p=196,by={"\131\097\130\080"},g=3}},
{"\129\1003\131\097 \132\089II \130\066\132\101",{s="\133\125\129\114 \130\112\134\086",p=197,g=2},{s="\130\071\136\072\130\104 8\129\112 \130\111\129\102 \130\112\134\086",p=194,t=8,g=3}},
{"\129\1003\131\097 \129\094\134\095\129\101I \130\066\132\101",{s="\134\111\135\112 \130\112\134\086",p=250,g=2},{s="\131\097\130\110\130\104 6\129\112 \130\111\129\102 \130\112\134\086",p=206,t=6,g=3}},
{"\129\1003\131\097 \135\122\130\119\129\101I \130\066\132\101",{s="\131\097\130\080\132\083 \131\097\129\087 \130\112\134\086",p=103,by={"\131\097\130\080"},g=2},nil},
{"\129\1003\131\097 \135\122\130\119\129\101II \130\066\132\101",{s="\129\111\134\113 \130\112\134\086",p=130,g=2},{s="\131\097\130\080\132\083 \131\097\129\087\129\083 8\129\112 \130\111\129\102 \130\112\134\086",p=103,by={"\131\097\130\080"},t=8,g=3}},
{"\129\1003\131\097 \129\094\134\095\129\101II \130\066\132\101",{s="\130\085\135\116\129\071 \131\076 \130\094\130\095 3 \130\112\134\086",by={"\130\085\135\116"},cnt=3,g=2},nil},
{"\129\1003\131\097 \129\070\130\084\132\091 \130\066\132\101",{s="\130\091\129\075 \130\112\134\086",p=37,g=2},{s="\129\097\133\067\129\067\129\083 6\129\112 \130\111\129\102 \130\112\134\086",p=210,t=6,g=3}},
{"\129\1003\131\097 \130\115\140\109\132\091I \130\066\132\101",{s="\130\085\135\116\131\109\132\083 \129\097\133\067\135\086 \130\112\134\086",p=211,by={"\130\085\135\116"},g=2},nil},
{"\129\1003\131\097 \130\115\140\109\132\091II \130\066\132\101",{s="\130\091\129\075 \130\112\134\086",p=37,g=2},{s="\135\110\130\111\131\109\132\083 \129\097\133\067\129\067 \130\112\134\086",p=210,by={"\135\110\130\111"},g=3}},
{"\129\1003\131\097 \129\111\129\113 \130\066\132\101",{s="\129\118\135\083\131\109\132\083 \129\097\133\067\135\086 \130\112\134\086",p=211,by={"\129\118\135\083"},g=2,alt={s="\129\118\135\083\131\109\132\083 \129\118\135\095 \130\112\134\086",p=20,by={"\129\118\135\083"},g=2}},{s="\129\118\134\103 \130\112\134\086",p=212,g=3}},
{"\129\1003\131\097 \134\111\131\119\129\101 \130\066\132\101",{s="\134\111\129\113 \130\112\134\086",p=251,g=3},{s="\130\114\133\088\131\080\130\104 \130\117\130\118\131\109\132\083 \130\112\134\086",p=214,mg=true,g=3}},
{"\129\1003\131\097 \143\124\131\123 \130\066\132\101",{s="\133\065\131\097 \130\112\134\086",p=174,g=3},{s="\129\101\131\079\132\083 \129\098\135\126 \130\112\134\086",p=149,by={"\129\101\131\079"},g=3}},
{"\129\1003\131\097 \131\087\142\083 \130\066\132\101",{s="\134\081\131\076 \130\112\134\086",p=160,g=3},{s="\135\089\134\073\129\083 8\129\112 \130\111\129\102 \130\112\134\086",p=42,t=8,g=3}},
{"\129\1003\131\097 \129\071\142\083 \130\066\132\101",{s="\129\101\133\077\131\109\132\083 \133\088\135\116 \130\112\134\086",p=108,by={"\129\101\133\077"},g=3},{s="\130\071\130\080\132\083 \134\081\135\089 \130\112\134\086",p=151,by={"\130\071\130\080"},g=4,it=216}},
{"\129\1004\131\097 \134\111\134\111II \130\066\132\101",{s="\130\090\134\075 \130\112\134\086",p=169,g=3},{s="\133\090\135\120\129\083 10\129\112 \130\111\129\102 \130\112\134\086",p=122,t=10,g=3}},
{"\129\1004\131\097 \131\078\133\069II \130\066\132\101",{s="\131\097\129\113 \130\112\134\086",p=102,g=3},{s="\129\071\130\066\129\083 8\129\112 \130\111\129\102 \130\112\134\086",p=116,t=8,g=3}},
{"\129\1004\131\097 \133\103\130\084 \130\066\132\101",{s="\129\097\133\067\129\067 \130\112\134\086",p=210,g=3},{s="\129\118\135\083\131\109\132\083 \131\097\129\113 \130\112\134\086",p=102,by={"\129\118\135\083"},g=3}},
{"\129\1004\131\097 \134\108II \130\066\132\101",{s="\129\094\133\067\130\104 \130\117\130\118\131\109\132\083 \130\112\134\086",p=94,mg=true,g=3},{s="\131\097\130\080\132\083 \135\109\133\102 \130\112\134\086",p=68,by={"\131\097\130\080"},g=3}},
{"\129\1004\131\097 \134\108I \130\066\132\101",{s="\133\118\129\103 \130\112\134\086",p=218,g=3},{s="\130\071\130\080\132\083 \131\097\129\085\130\104 8\129\112 \130\111\129\102 \130\112\134\086",p=80,by={"\130\071\130\080"},t=8,g=3}},-- 11-13 (제보: 관우는 571 맥성 뒤 631 까지 없음, 조운도 관중 기습대(89)면 없음) 관우 → 유비
{"\129\1004\131\097 \131\097\130\111 \130\066\132\101",{s="\129\118\130\120 \130\112\134\086",p=215,g=3},{s="\130\071\135\117\129\083 \130\117\130\118\131\109\132\083 \130\112\134\086",p=101,mg=true,g=3}},
{"\129\1004\131\097 \132\089\134\111 \130\066\132\101",{s="\129\118\135\083\131\109\132\083 \129\118\135\095 \130\112\134\086",p=20,by={"\129\118\135\083"},g=3},{s="\131\097\129\087\129\083 10\129\112 \130\111\129\102 \130\112\134\086",p=103,t=10,g=3}},
{"\129\1004\131\097 \135\109\134\103I \130\066\132\101",{s="\129\118\130\121 \130\112\134\086",p=239,g=3},{s="\130\114\133\088\130\114\130\104 \130\117\130\118\131\109\132\083 \130\112\134\086",p=240,mg=true,g=3}},
{"\129\1004\131\097 \135\109\134\103II \130\066\132\101",{s="\131\097\130\080\132\083 \129\118\134\103 \130\112\134\086",p=212,by={"\131\097\130\080"},g=3},{s="\129\100\135\121\132\088\131\109\132\083 \129\094\133\067 \130\112\134\086",p=94,by={"\129\100\135\121\132\088"},g=3}},
{"\129\1004\131\097 \134\110I \130\066\132\101",{s="\129\118\130\120 \130\112\134\086",p=215,g=3},{s="\129\101\131\079\132\083 \129\097\133\067\135\093 \130\112\134\086",p=17,by={"\129\101\131\079"},g=3,alt={s="\129\101\131\079\132\083 \131\087\130\085 \130\112\134\086",p=79,by={"\129\101\131\079"},g=3}}},
{"\129\1004\131\097 \134\110II \130\066\132\101",{s="\131\097\130\080\132\083 \135\109\133\102 \130\112\134\086",p=68,by={"\131\097\130\080"},g=3},{s="\129\101\131\079\132\083 \131\097\129\085 \130\112\134\086",p=80,by={"\129\101\131\079"},g=3,alt={s="\129\101\131\079\132\083 \132\078\135\086 \130\112\134\086",p=216,by={"\129\101\131\079"},g=3}}},
{"\129\1004\131\097 \134\110III \130\066\132\101",{s="\129\101\131\079\132\083 \130\066\130\110 \130\112\134\086",p=387,by={"\129\101\131\079"},g=3},{s="\130\114\133\088\131\080\130\104 \130\117\130\118\131\109\132\083 \130\112\134\086",p=214,mg=true,g=4,it=217}},
{"\133\126\132\125\129\103 \129\101\133\090 \129\109\129\079 \130\066\132\101",{s="\131\097\129\085 \130\112\134\086",p=80,g=2},nil},
{"\131\107\130\066 \129\101\131\079 \129\097\130\080 \137\083\132\091 \130\066\132\101",{s="\129\101\131\079\132\083 \131\087\130\085 \130\112\134\086",p=79,by={"\129\101\131\079"},g=2},nil},
{"\131\107\130\066 \129\101\131\079 \134\101\133\088 \130\066\132\101",{s="\132\065\131\079\131\064 \130\112\134\086",p=106,g=2},{s="\129\101\131\079\132\083 \130\111\132\088\129\083 4\129\112 \130\111\129\102 \130\112\134\086",p=52,by={"\129\101\131\079"},t=4,g=4,it=214}},
{"\131\107\130\066 \129\101\131\079 \133\066\129\103 \130\066\132\101",{s="\133\102\129\113\130\104 \130\117\130\118\131\109\132\083 \130\112\134\086",p=51,mg=true,g=2},{s="\134\100\134\099\130\104 6\129\112 \130\111\129\102 \130\112\134\086",p=92,t=6,g=3}},
{"\131\107\130\066 \129\101\131\079 \130\108\130\089\129\101 \130\066\132\101",{s="\129\101\131\079\132\083 \130\074\129\113\130\104 4\129\112 \130\111\129\102 \130\112\134\086",p=391,by={"\129\101\131\079"},t=4,g=2},nil},
{"\131\107\130\066 \129\101\131\079 \132\089\134\111 \130\066\132\101",{s="\129\101\131\079\132\083 \129\111\130\068\129\083 5\129\112 \130\111\129\102 \130\112\134\086",p=392,by={"\129\101\131\079"},t=5,g=2},nil},
{"\131\107\130\066 \129\101\131\079 \130\114\129\113\129\101 \130\066\132\101",{s="\129\101\131\079\132\083 \130\116\138\115\130\104 4\129\112 \130\111\129\102 \130\112\134\086",p=394,by={"\129\101\131\079"},t=4,g=2},nil},
{"\131\107\130\066 \129\101\131\079 \136\069\134\111 \130\066\132\101",{s="\135\101\130\121 \130\112\134\086",p=395,g=2},nil},
{"\131\107\130\066 \129\101\131\079 \130\085\129\097 \131\118\131\094 \130\066\132\101",{s="\129\097\133\067\135\093 \130\112\134\086",p=17,g=3},nil},
{"\131\107\130\066 \129\101\131\079 \131\097\130\114 \130\066\132\101",{s="\135\078\135\125 \130\112\134\086",p=148,g=2},{s="\129\101\131\079\132\083 \129\098\135\126\129\083 6\129\112 \130\111\129\102 \130\112\134\086",p=149,by={"\129\101\131\079"},t=6,g=3}},
{"\131\107\130\066 \129\101\131\079 \130\087\131\123 \130\066\132\101",{s="\132\086\135\084 \130\112\134\086",p=84,g=2},{s="\129\101\131\079\132\083 \129\118\129\106 \130\112\134\086",p=19,by={"\129\101\131\079"},g=3}},
{"\131\107\130\066 \131\097\130\080 \136\111\140\109\132\091 \130\066\132\101",{s="\131\097\130\080\132\083 \129\097\133\067\133\066 \130\112\134\086",p=18,by={"\131\097\130\080"},g=2},nil},
{"\131\107\130\066 \131\097\130\080 \131\100\131\123 \135\070\134\069 \130\066\132\101",{s="\129\073\129\101\129\083 3\129\112 \130\111\129\102 \130\112\134\086",p=369,t=3,g=1},nil},
{"\131\107\130\066 \131\097\130\080 \129\109\129\079 \133\069\129\075 \130\066\132\101",{s="\133\118\129\103 \130\112\134\086",p=218,g=2},nil},
{"\131\107\130\066 \131\097\130\080 \130\084\132\088\130\095 \129\075\130\112 \130\066\132\101",{s="\129\071\130\066 \130\112\134\086",p=116,g=2},nil},
{"\131\107\130\066 \131\097\130\080 \134\107\130\101 \130\066\132\101",{s="\131\097\130\080\132\083 \130\109\130\073\129\083 4\129\112 \130\111\129\102 \130\112\134\086",p=397,by={"\131\097\130\080"},t=4,g=2},nil},
{"\129\1001\131\097 \129\097\130\119II \130\066\132\101",{s="\131\097\129\085\130\104 8\129\112 \130\111\129\102 \130\112\134\086",p=80,t=8,g=1},nil},-- 11-08: 옛 팽성II 줄(장료가 없는 전투였음)
}
local IDX={}
for i,e in ipairs(B) do IDX[e[1]]=i end
local BEV=rawget(_G,"koCamp") and koCamp.bountyEvent--ko 6.0 campaigns: battle by event number (same-name rematches)
function koBountyTable() return B,IDX end-- for test scripts

-- 등급별 도구 (하 회복·책략서, 중 경험의 씨앗·명주·책략서, 상 능력 씨앗·경험의 씨앗)
local POOL={{53,54,29,48,50},{173,30,49,51},{71,72,73,173}}

-- ---------------------------------------------------------------- 저장 칸
local function have() return (JY.PersonNum or 0)>S_TMP end
local function raw(i,o) return Byte.get16(JY.Data_Person,i*PS+o) end
local function setraw(i,o,v) Byte.set16(JY.Data_Person,i*PS+o,v) end
local function gotBit(idx,k)
if not have() then return false end
local n=(idx-1)*2+(k-1)
local w=WORDS[math.floor(n/15)+1]
if not w then return false end
return math.floor(raw(S_DONE,w)/2^(n%15))%2==1
end
local function setGot(idx,k)
local n=(idx-1)*2+(k-1)
local w=WORDS[math.floor(n/15)+1]
if not w then return end
if not gotBit(idx,k) then setraw(S_DONE,w,math.floor(raw(S_DONE,w)+2^(n%15))) end
end
local function tIdx() return have() and raw(S_TMP,24) or 0 end
local function st(k) return math.floor(raw(S_TMP,26)/4^(k-1))%4 end
local function setSt(k,v) local o=raw(S_TMP,26) setraw(S_TMP,26,math.floor(o-st(k)*4^(k-1)+v*4^(k-1))) end
local function cnt(k) return raw(S_TMP,26+2*k) end
local function setCnt(k,v) setraw(S_TMP,26+2*k,math.min(v,30000)) end
local function cyc() local ng=CC.koNG return (ng and ng.rcycle and ng.rcycle()) or 1 end
local function active() return have() and not CC.koFree and not CC.koTownBattle and not CC.koReplay end
-- this battle's entry and its rows (현상 2 from the 2nd cycle), or nil
local function cur()
if not active() then return nil end
local i=tIdx()
local e=B[i]
if not e or e[1]~=War.WarName then return nil end
local rows={e[2]}
if e[3] and cyc()>=2 then rows[2]=e[3] end
-- 11-15 카페 제보 (업I 「관우로 하후돈」 · 업II 「관우로 장료」 = 대상이 앞 전투에서 죽음 · 항복해 이 전투에 아예 안 나옴, 한수 하후덕도 같음):
--  줄에 alt 가 있고 대상이 이 전투 부대 명단(숨은 증원 포함)에 없으면 alt 줄로 (비트 자리는 같음)
for k,row in ipairs(rows) do if row.alt and row.p and War and War.Person and GetWarID(row.p)==0 then rows[k]=row.alt end end
return e,i,rows
end
function koBountyCur() return cur() end-- for test scripts
function koBountyStateT(k) return st(k),cnt(k) end-- for test scripts

local function pname(p) return (p and JY.Person[p] and JY.Person[p][NAME]) or "" end
local function nameIn(pid,list)
local nm=pname(pid)
for _,s in ipairs(list or {}) do if s==nm then return true end end
return false
end
-- 11-12 카페 제보 (낙I 「장비로 장임」 · 완I 「관우로 장료」 = 그 무장이 그 전투 때 우리 편이 아님): 지정 무장이 우리 편(君主 1)에도
--  이 전투의 우군 부대에도 없으면 그 줄은 누구나 (승리조건 창에 「(○○ 없음: 누구나)」). 관우가 맥성에서 죽은 판의 4장 줄도 같음
local function byHere(row)
if not row.by then return false end
for _,v in pairs(War.Person or {}) do if type(v)=="table" and v.id and not v.enemy and nameIn(v.id,row.by) then return true end end
for i=1,JY.PersonNum-1 do if (i<762 or i>801) and JY.Person[i][LORD]==1 and nameIn(i,row.by) then return true end end
return false
end

-- ---------------------------------------------------------------- 전투 시작
local rawDWM=DefineWarMap
function DefineWarMap(id,name,...)
local r=rawDWM(id,name,...)
if have() then
local i=(active() and ((BEV and BEV[JY.EventID]) or (not BEV and IDX[name]))) or 0
setraw(S_TMP,24,i) setraw(S_TMP,26,0) setraw(S_TMP,28,0) setraw(S_TMP,30,0)
if i>0 then
War.koBonusText=War.koBonusText or ""-- the battlebonus 승리조건 창 carries the 현상 lines too
for k=1,2 do if gotBit(i,k) then setSt(k,1) end end-- taken this cycle: shown as done, nothing more to pay
end
end
return r
end
local function notice(s,ok)
if ok then PlayWavE(11) end
if JY.Status==GAME_WMAP then WarDrawStrBoxDelay(s,ok and M_Yellow or M_White,-1,-1,24) end
end
local function finish(e,i,k,row,ok,why)
setSt(k,ok and 1 or 2)
if ok then notice("\129\114\129\067 \136\071\131\123: "..row.s,true)
else notice("\129\114\129\067 \129\078\129\079: "..row.s..(why and ("*"..why) or ""),false) end
end
-- an enemy general went down: tpid, by a general on our side apid (nil = by nobody of our side), magic = by a 책략,
--  mine = apid is ours (君主 1). 11-12 카페 제보 (팽성II 「곽가가 적 부대 2 격파」 = 곽가는 조조군 우군): 지정 무장 줄은 우군 부대여도 이름으로 셈
local function onKill(tpid,apid,magic,mine)
local e,i,rows=cur()
if not e then return end
for k,row in ipairs(rows) do
if st(k)==0 then
local by=byHere(row)
local who=apid~=nil and ((by and nameIn(apid,row.by)) or ((not by) and mine))
if row.cnt then
if who then
setCnt(k,cnt(k)+1)
if cnt(k)>=row.cnt then finish(e,i,k,row,true) end
end
elseif row.p==tpid then
local ok=who and ((not row.t) or War.Turn<=row.t) and ((not row.mg) or magic)
local why=nil
if not ok then
if not apid or ((not by) and not mine) then why="\129\077\135\077 \130\094\130\095\129\094 \136\096\133\101\132\093\132\126\129\077"
elseif row.t and War.Turn>row.t then why=row.t.."\129\112\129\071 \130\067\138\103\129\077"
elseif row.mg and not magic then why="\130\117\130\118\129\071 \129\110\134\109 \130\074\130\112\131\109\132\083 \136\096\133\101\132\093\132\126\129\077"
else why="\130\067\129\070\129\111 \129\073\131\097\129\071 \129\110\134\109 \129\073\131\097\129\071 \136\096\133\101\132\093\132\126\129\077" end
end
finish(e,i,k,row,ok,why)
end
end
end
end
function koBountyKillT(tpid,apid,magic) return onKill(tpid,apid,magic,apid~=nil and JY.Person[apid][LORD]==1) end-- for test scripts
-- 우리 편 부대: 적이 아니고 우리 무장(君主 1). War.Person 의 friend 는 「출진 세력과 소속이 다름」 이라 서장처럼 아군 무장에게도 켜짐 (10-27 시험) → 우군 NPC 는 君主 가 1 이 아니라서 빠짐
local function ours(a) return a~=nil and not a.enemy and JY.Person[a.id]~=nil and JY.Person[a.id][LORD]==1 end
koOn("unit_down",function(wid,atk)
local v=War.Person[wid]
if not v then return end
War.koBountySeen=War.koBountySeen or {}
if War.koBountySeen[v.id] then return end
War.koBountySeen[v.id]=true
local a=atk and War.Person[atk]
if a and not a.enemy then onKill(v.id,a.id,false,ours(a)) else onKill(v.id,nil,false,false) end
end)
-- 11-14 (카페 제보: 손견전 남양 전투 현상 「왕예 격파」 — 손견과의 대본 일기토로 왕예가 쓰러지면 SnrWarHide 가 전장에서 치울 뿐이라
--  「대상이 전장을 떠났다」 실패): 이야기 대본(SnrDuel → SnrWarHide)에서 일기토 상대가 치워지면 그 상대를 이긴 쪽 무장의 격파로 셈.
--  SnrDuel · SnrWarHide 는 이야기 묶음 런타임이 나중에 깔므로 전투 시작 때 감쌈 (한 번만)
koOn("war_begin",function()
if War then War.koBountyDuel=nil end
local d,h=rawget(_G,"SnrDuel"),rawget(_G,"SnrWarHide")
if type(d)=="function" and not (rawget(_G,"koBountyDuelWrapped")==d) then
local raw=d
SnrDuel=function(a,b,...) if War then War.koBountyDuel={a,b} end return raw(a,b,...) end
rawset(_G,"koBountyDuelWrapped",SnrDuel)
end
if type(h)=="function" and not (rawget(_G,"koBountyHideWrapped")==h) then
local raw=h
SnrWarHide=function(pid,...)
local du=War and War.koBountyDuel
if du and (pid==du[1] or pid==du[2]) then
local other=(pid==du[1]) and du[2] or du[1]
local w,ow=GetWarID(pid),GetWarID(other)
War.koBountySeen=War.koBountySeen or {}
if w>0 and ow>0 and War.Person[w].live and War.Person[w].enemy and not War.Person[ow].enemy and not War.koBountySeen[pid] then
War.koBountySeen[pid]=true
pcall(onKill,pid,other,false,JY.Person[other][LORD]==1)
end
end
return raw(pid,...)
end
rawset(_G,"koBountyHideWrapped",SnrWarHide)
end
end)
-- 11-21 카페 제보 (영걸전 2회차 계교 「문추 격파」 — 장비가 일기토로 이기면 실패): 본편 대본(kdef)은 fight(a,b) 를 이긴 뒤
--  WarAction(16/17/18, 진 쪽) 으로 퇴각 · 패주시킬 뿐이라 unit_down 이 안 불리고 다음 턴 「대상이 전장을 떠났다」. 위 SnrDuel 과 같게
--  일기토에서 진 적이 바로 이어 물러나면 이긴 아군 무장의 격파로 셈 (본편 일기토 대사 수십 곳 공통)
if type(rawget(_G,"fight"))=="function" then
local rawF=fight
function fight(a,b,...)
local r=rawF(a,b,...)
if War and JY.Status==GAME_WMAP then
if r==1 then War.koBountyFight={a,b} elseif r==2 then War.koBountyFight={b,a} else War.koBountyFight=nil end
end
return r
end
end
if type(rawget(_G,"WarAction"))=="function" then
local rawWA=WarAction
function WarAction(kind,id1,...)
local f=War and War.koBountyFight
if f and (kind==16 or kind==17 or kind==18) and id1==f[2] then
War.koBountyFight=nil
pcall(function()
local w,ow=GetWarID(f[2]),GetWarID(f[1])
War.koBountySeen=War.koBountySeen or {}
if w>0 and ow>0 and War.Person[w].live and War.Person[w].enemy and not War.Person[ow].enemy and not War.koBountySeen[f[2]] then
War.koBountySeen[f[2]]=true
onKill(f[2],f[1],false,JY.Person[f[1]][LORD]==1)
end
end)
end
return rawWA(kind,id1,...)
end
end
-- a 책략 took an enemy down (the hook only names the caster: the fallen are the enemies still marked live with no troops)
koOn("magic_kill",function(cw)
local c=War.Person[cw]
if not ours(c) then return end
War.koBountySeen=War.koBountySeen or {}
for _,v in pairs(War.Person) do
if v.enemy and v.live and JY.Person[v.id][HP]<=0 and not War.koBountySeen[v.id] then
War.koBountySeen[v.id]=true
onKill(v.id,c.id,true,true)
end
end
end)
-- 11-12: jymain magic_kill 은 friend(출진 세력과 소속이 다름 — 우군 NPC · 서장 아군) 시전자에게 안 불림 → WarMagic 을 감싸
--  시전 전에 살아 있던 적 중 병력 0 이 된 부대를 우리 쪽(적이 아닌) 시전자의 책략 격파로 셈 (위 훅이 먼저 센 것은 koBountySeen 으로 건너뜀)
if type(rawget(_G,"WarMagic"))=="function" then
local rawWM=WarMagic
function WarMagic(wid,eid,...)
local c=War.Person and War.Person[wid]
local alive=nil
if c and not c.enemy and cur() then
alive={}
for _,v in pairs(War.Person) do if type(v)=="table" and v.enemy and v.live and JY.Person[v.id][HP]>0 then alive[v.id]=true end end
end
local r=table.pack(rawWM(wid,eid,...))
if alive then
War.koBountySeen=War.koBountySeen or {}
for _,v in pairs(War.Person) do
if type(v)=="table" and v.id and alive[v.id] and JY.Person[v.id][HP]<=0 and not War.koBountySeen[v.id] then
War.koBountySeen[v.id]=true
onKill(v.id,c.id,true,ours(c))
end
end
end
return table.unpack(r,1,r.n)
end
end
-- 턴 제한이 지남 / 대상이 우리 손이 아닌 길로 빠짐 (사건 퇴각 등)
koOn("turn_ready",function()
local e,i,rows=cur()
if not e then return end
for k,row in ipairs(rows) do
if st(k)==0 then
if row.t and War.Turn>row.t then finish(e,i,k,row,false,row.t.."\129\112\129\071 \130\067\138\103\129\077")
elseif row.p then
local w=GetWarID(row.p)
if w>0 and not War.Person[w].live then finish(e,i,k,row,false,"\130\095\129\067\129\071 \130\066\131\097\129\083 \139\088\138\103\129\077") end
end
end
end
end)

-- ---------------------------------------------------------------- 보상
-- 금: 등급별 고정 (현상 2 는 1.5배), 회차마다 +10% (최대 3배). 승리 정산 금은 도전 모드에만 있어 기준으로 못 씀 (10-27 시험)
local GOLD={500,1000,2000,3000}
koOn("war_begin",function() War.koBountySeen={} end)
local function who()
if rawget(_G,"koViewSide") and koViewSide() and koViewBro()>0 then return koViewBro() end
return 1
end
local function owned(item)
for i=1,JY.PersonNum-1 do
local p=JY.Person[i]
if p[LORD]==1 then
for k=1,8 do if p[ITEM..k]==item then return true end end
for _,q in ipairs(EQUIP) do if p[q]==item then return true end end
end
end
if rawget(_G,"koStoreList") then for _,e in ipairs(koStoreList()) do if e.iid==item then return true end end end
return false
end
local function pick(g,i,k)
local t=POOL[g]
return t[((i*7+k*3+cyc())%#t)+1]
end
-- 이긴 전투가 끝난 뒤 (jymain war_won: 모든 모드, 패배 · 중단 · 다시 전투 빼고). battle_won_bonus 는 도전 모드 정산에서만 불려서 쓰지 않음
koOn("war_won",function()
local e,i,rows=cur()
if not e then return end
for k,row in ipairs(rows) do
if st(k)==1 and not gotBit(i,k) then
setGot(i,k)
local gold=math.floor(GOLD[row.g]*((k==1) and 1 or 1.5)*math.min(3,1+0.1*(cyc()-1)))
local g=row.g
if g<3 and cyc()>=3 then g=g+1 end
local item
if g==4 then
item=row.it
if owned(item) then item=pick(3,i,k) gold=math.floor(gold*1.5) end
else item=pick(g,i,k) end
koSetGold(koGold()+gold)
koHook("gold_gain",gold)
WarDrawStrBoxConfirm("\129\114\129\067 \131\115\129\067 ("..row.s..")*\130\085\131\103 "..gold.."\129\083 \133\072\131\116\129\077.",M_White,true)
GetItem(who(),item)
if row.p and rawget(_G,"koTavernCreditT") then pcall(koTavernCreditT,row.p,(k==1) and 15 or 25) end
CC.koBountyTotal=(CC.koBountyTotal or 0)+1
pcall(koSave)
end
end
end)
koAddon.saveKeys[#koAddon.saveKeys+1]={key="koBountyTotal",default=0}

-- ---------------------------------------------------------------- 승리조건 창 · 대상 표시
local function lines()
local e,i,rows=cur()
if not e then return nil end
local t={"\129\114\129\067\129\113\134\099"}
for k,row in ipairs(rows) do
local s=st(k)
local mark=(s==1) and "\161\246 " or ((s==2) and "\161\193 " or "\161\245 ")
local tail=""
if row.cnt and s==0 then tail=" ("..cnt(k).."/"..row.cnt..")" end
if row.by and s==0 and not byHere(row) then tail=tail.." ("..row.by[1].." \130\097\130\077: \134\117\130\119\131\118)" end
if row.p and s==0 then
local w=GetWarID(row.p)
if w<=0 or War.Person[w].hide then tail=tail.." (\129\110\132\076 \131\118\133\064\131\118\130\067 \130\107\130\077)" end
end
if s==1 and gotBit(i,k) then tail=tail.." (\133\072\130\077)" end
t[#t+1]=mark..row.s..tail
end
return table.concat(t,"*")
end
function koBountyLines() return lines() end-- for test scripts
if type(rawget(_G,"koBonusFmt"))=="function" then
local rawFmt=koBonusFmt
function koBonusFmt(s,done)
local b=lines()
if not b then return rawFmt(s,done) end
if s==nil or s=="" then return b end
return rawFmt(s,done).."*"..b
end
end
if type(rawget(_G,"WarShowTarget"))=="function" then
local rawWST=WarShowTarget
function WarShowTarget(...)
if War.koBonusText==nil and cur() then War.koBonusText=(rawget(_G,"koBonusPreT") and koBonusPreT[War.WarName]) or "" end
return rawWST(...)
end
end
local MARK=RGB(255,210,60)
koOn("draw_units_over",function()
local e,i,rows=cur()
if not e then return nil end
for k,row in ipairs(rows) do
if st(k)==0 and row.p then
local w=GetWarID(row.p)
local v=w>0 and War.Person[w]
if v and v.live and not v.hide and between(v.x,War.CX,War.CX+War.MW-1) and between(v.y,War.CY,War.CY+War.MD-1) then
local left=War.OX+War.BoxWidth*(v.x-War.CX)
local top=War.OY+War.BoxDepth*(v.y-War.CY)
DrawString(left+1,top,"\161\244",M_Black,16)
DrawString(left,top-1,"\161\244",MARK,16)
end
end
end
return nil
end)

-- ---------------------------------------------------------------- 기록 화면 「현상」 탭
local PER=18
local VIEW_BEFORE={["\129\1001\131\097 \129\097\130\119II \130\066\132\101"]="\129\1001\131\097 \141\069\131\123II \130\066\132\101"}
local function tabPages() return math.max(1,math.ceil(#B/PER)) end
local function tabDraw(page,c)
local n,m=0,0
for i,e in ipairs(B) do
m=m+(e[3] and 2 or 1)
for k=1,2 do if gotBit(i,k) then n=n+1 end end
end
c.txt(c.ox+24,c.oy+60,"\129\114\129\067 \131\097\130\094 (\129\071\130\087 \130\125\132\121)",C_Name)
c.rtext(c.ox+744,c.oy+60,"\133\072\130\077 "..n.." / "..m.."   \132\119\132\091 "..(CC.koBountyTotal or 0),M_Gray)
local x=c.ox+24
local ord={}-- 11-08: rows appended later (bit slot = table order) are shown before the row named in VIEW_BEFORE
for i,e in ipairs(B) do if not VIEW_BEFORE[e[1]] then ord[#ord+1]=i end end
for i,e in ipairs(B) do local t=VIEW_BEFORE[e[1]] if t then local at=#ord+1 for j,k in ipairs(ord) do if B[k][1]==t then at=j break end end table.insert(ord,at,i) end end
for r=1,PER do
local i=ord[(page-1)*PER+r]
local e=i and B[i]
if not e then break end
local y=c.oy+90+(r-1)*20
local a=gotBit(i,1) and "\161\246" or "\161\245"
local b=e[3] and (gotBit(i,2) and "\161\246" or "\161\245") or "\161\161"
c.txt(x,y,a.." "..b,gotBit(i,1) and M_Yellow or M_White)
c.txt(x+48,y,e[1],M_White)
c.txt(x+300,y,e[2].s,M_Gray)
end
end
if rawget(_G,"koRecTabs") and #B>0 then-- 6.0: a story without its own table (koCamp.bounty={}) has no tab
koRecTabs[#koRecTabs+1]={label="\129\114\129\067",per=1,n=tabPages,draw=tabDraw}
end
