-- ko 5.0 (10-13): 일반 공격 피해 변동 (addon "dmgvary"; 사용자 제보 "\130\074\130\112 \133\104\134\119\130\067\129\094 1\129\068 \130\111 \140\071\129\117\131\100 \140\064 \131\115\129\071\130\098 \129\081 \129\110\135\064\129\077, \130\110\129\110\134\071 10~20%").
-- 공격·반격·협공 피해에 ±10% (두 난수 평균 = 가운데가 잦은 삼각 분포). jymain WarAtkHurt 의 기본 식 바로 뒤에서 koVaryHurt 를
-- 부르므로(개발용/addon/patch_피해변동.pl) 견고 1/5 상한·회심 바닥·최소 1·병력 상한·회심/방어 판정·사기·경험치는 굴린 값으로 그대로 계산된다.
-- 굴리는 건 WarAtk 의 실제 한 방(koVaryRoll)뿐: AI 의 표적 고르기와 미리보기는 가운데 값. 미리보기(preview2)는 koVaryMode "min"/"max"
-- 로 양 끝을 따로 물어 "108~132"·「격파」(최소로도 잡힘)/「격파 가능」(최대일 때만) 을 그린다. 책략은 원래의 0~+10% 그대로.
-- 기능설정 2쪽 「피해 변동」 켬/끔 (기본 켬).
-- Source: 개발용/addon/dmgvary_src.lua (UTF-8); script/addon/dmgvary.lua is made from it by 개발용/도구/free_hz.pl.
local SPREAD=0.10
function koVaryOn() return (CC.koDmgVary or 1)==1 end
-- the spread range of a base damage h, as the hit will roll it: lo, hi (the preview's labels)
function koVaryHurt(h)
if not koVaryOn() or type(h)~="number" or h<=0 then return h end
local mode=rawget(_G,"koVaryMode")
local f
if mode=="min" then f=1-SPREAD
elseif mode=="max" then f=1+SPREAD
elseif rawget(_G,"koVaryRoll") then f=1+SPREAD*(math.random()+math.random()-1)
else return h end
local v=math.modf(h*f+0.5)
return v
end
koAddon.settings[#koAddon.settings+1]={key="koDmgVary",label="\137\088\129\066 \130\116\130\108",opts={{"\133\122",1},{"\133\117",0}},default=1}
koSetOrder.koDmgVary=7
