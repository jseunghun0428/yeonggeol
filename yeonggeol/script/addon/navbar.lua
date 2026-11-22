-- ko 5.0: 내비 바 (addon "navbar", Android only, 2026-10-12 제보: 게임 중 뒤로가기 버튼을 쓰고 싶다).
-- 기능설정 「내비 바」(글꼴 때문에 짧은 이름) 숨김/표시. 표시 = 엔진이 전체 화면(몰입 모드)을 풀어 시스템 바가 늘 보임,
-- 그만큼 게임 화면이 조금 작아짐. 뒤로가기 버튼은 원래대로 취소(오른쪽 클릭)로 동작.
-- 값은 엔진이 ko_navbar.txt 에 따로 적어 다음 실행 때 창을 만들 때부터 씀(lib.KoNavBar, jy_engine.c).
-- On Windows (no lib.KoNavBar) nothing is added.
-- Source: 개발용/addon/navbar_src.lua (UTF-8); script/addon/navbar.lua is made from it by 개발용/도구/free_hz.pl.
if CONFIG.Windows or type(lib.KoNavBar)~="function" then return end
local cur=0
local ok,v=pcall(lib.KoNavBar)
if ok and tonumber(v)==1 then cur=1 end
koAddon.settings[#koAddon.settings+1]={key="koNavBar",label="\131\095\130\080 \131\085",opts={{"\133\126\141\091",0},{"\133\113\130\086",1}},default=cur,
onchange=function(n) pcall(lib.KoNavBar,n) end}
