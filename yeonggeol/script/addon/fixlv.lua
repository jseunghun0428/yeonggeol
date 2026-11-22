-- ko 5.1.5 (10-15): 적 레벨 원작 고정 (addon "fixlv"; 카페 의견 "\131\126\137\083\129\117\130\090\133\119\129\102\131\087\129\068 \131\100\129\070\147\144\131\109\132\083 \129\088 \129\113 \132\079\130\098 \132\078\136\070" → 사용자 "\133\109\133\110\130\067 \134\112\130\083\140\110").
-- 기능설정 2쪽 「적 레벨」 따라옴(기본) / 원작.
--  · 따라옴 = 지금까지 그대로: jymain SelectEnemy 가 대본(kdef) 레벨에 「출진 아군 평균 − 적 평균 + 적 평균/10」(0 아래는 0) 을 더하고,
--    도전 모드가 아니면 아군 상위 평균/10 (0~3) 을 또 더함.
--  · 원작 = 이야기 전투만 대본 레벨 그대로: SelectEnemy 동안 CC.lv 를 0 으로(→ 보정 0, 「보정−4 보다 낮으면 +보정」도 0)
--    pjlv 를 0 으로(→ 상위 평균 보정 0) 바꿔 두고 끝나면 되돌림. 도전 모드의 도전 레벨 · diff 애드온의 단계 레벨은 그대로 붙음.
--    자유 전투 · 다시 전투(CC.koFree / koReplay)는 원래 저마다 레벨을 정하므로 손대지 않음.
-- Source: 개발용/addon/fixlv_src.lua (UTF-8); script/addon/fixlv.lua is made from it by 개발용/도구/free_hz.pl.
function koFixLvOn() return (CC.koFixLv or 0)==1 and not CC.koFree and not CC.koReplay end
local rawSel=SelectEnemy
function SelectEnemy(...)
if not koFixLvOn() then return rawSel(...) end
local oldLv,oldPj=CC.lv,pjlv
CC.lv=0
pjlv=function() return 0 end
local r=table.pack(pcall(rawSel,...))
CC.lv,pjlv=oldLv,oldPj
if not r[1] then error(r[2],0) end
return table.unpack(r,2,r.n)
end
koAddon.settings[#koAddon.settings+1]={key="koFixLv",label="\131\076 \130\082\130\123",opts={{"\130\105\130\102\203\136",0},{"\131\081\129\074",1}},default=0}
koSetOrder.koFixLv=8
