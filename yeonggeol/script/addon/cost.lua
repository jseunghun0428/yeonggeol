-- ko 3.0: cost reward. SelectTerm stores the battle's cost budget and what was spent (Base ÊÂ¼ş1995/1994, so a
-- reload keeps them); after a win in ì¢…íš¡ mode the unused cost pays gold (100 x level per point) and a stat seed
-- (items 71..73) per 5 points. bonus_moneyexp_8 calls it once, and the fields are cleared
function koCostReward()
local budget=JY.Base["ÊÂ¼ş1995"] or 0
local spent=JY.Base["ÊÂ¼ş1994"] or 0
JY.Base["ÊÂ¼ş1995"]=0
JY.Base["ÊÂ¼ş1994"]=0
local lv=JY.Base["ÎŞÓÃ5"] or 0
if budget<=0 or lv<1 or lv>3 then return end
local left=budget-spent
if left<=0 then return end
local gold=left*100*lv
local seeds=math.floor(left/5)
koSetGold(koGold()+gold)
koHook("gold_gain",gold)--ko 3.1
WarDrawStrBoxConfirm("\138\072\131\126\141\074 \131\115\129\067  \133\103\131\098 \138\072\131\126\141\074 "..left.."  \131\103 +"..gold..((seeds>0) and ("  \131\084\132\104 "..seeds) or ""),M_White)
for k=1,seeds do
local item=70+math.random(3)
local given=false
for i=1,JY.PersonNum-1 do
if JY.Person[i]["¾ıÖ÷"]==1 and GetItem(i,item) then given=true break end
end
if not given then break end
end
end

-- ---- registration (ko 3.1 addon "cost": ì½”ìŠ¤íŠ¸ ë³´ìƒ)
koOn("battle_won_bonus",function() koCostReward() end)
