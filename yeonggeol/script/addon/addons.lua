-- ko 3.1: the addons script/addon/<name>.lua, loaded in this order (later ones may need earlier ones).
-- false = not loaded: its menu rows, settings rows and hooks disappear; saves and ko_settings.lua are unaffected.
return {
{"base",true},    -- 기능 확장 (유광판 기본 기능. 끄면 순정/오리진)
{"fight",true},    -- 전투 장면 (일기토식 공격 연출)
{"preview",true},  -- 전투 미리보기
{"threat",true},   -- 위협 범위 (단일 + 전체)
{"range",true},    -- 이동·공격 범위 표시 (색 상자: 아군 이동 보라, 적군 이동 황토, 공격·책략·도구 대상 빨강)
{"pia",true},      -- 피아 표시 (유닛 발밑 진영 색 타원: 아군 하늘 · 행동 끝 회색 · 적 빨강 · 우군 노랑, 11-10)
{"hotkey",true},   -- 전투 단축키 (Enter/Space/Tab/A/E/F/V/Esc/방향키)
{"night",true}, -- ko 5.0: 야간 전투 4곳(형양·소패 야습·파군·낭중의 밤)은 밤 지도 (10-11)
{"cost",true},     -- 코스트 보상
{"inherit",true},  -- 회차 계승 선택 창
{"record",true},   -- 기록·도감
{"tourney",true},  -- 무술 대회 (record 필요)
{"gate",true},     -- 술집 조건 (tourney·record 필요)
{"drink",true},    -- 술집 연전 (술 겨루기: 무장 메뉴 > 연전, record 필요)
{"free",true},     -- 자유 전투 (record·tourney 필요)
{"bzshop",true},  -- 병종 교환 (무장 메뉴에서 금을 내고 병종 변경)
{"dojo",true}, -- ko 5.2.5 (10-18): 연무장 (무장 메뉴에서 금으로 뒤처진 무장 레벨 올리기, 가장 높은 무장 같게~-5 까지)
{"bzbook",true},  -- 병종 도감 (기록 화면 탭, record 필요)
{"battlelog",true}, -- 전투 기록 (공격·책략 기록 창: 위쪽 막대 기록, 기능 메뉴, L 키)
{"rewind",true},   -- 이 전투 처음부터 (기능 메뉴, R 키; 10-10 이번 턴 → 전투 처음)
{"gearcmp",true},  -- 장비 비교 (도구 교환 화면)
{"freeplus",true}, -- 자유 전투 외전·와룡의 시련 (강동의 세 여걸·선인의 시험, 타이틀 메뉴 와룡의 시련, free 필요)
{"achieve",true},  -- 무장 전적·마왕 토벌 등급 (업적은 10-11 없앰) (기록 화면, record 필요)
{"saveio",true},
{"saveall",true},   -- 11-11: 메인 화면 「저장 옮기기」 — 네 이야기 세이브 · 기록 · 공용 기록 한 번에 (PC, 이야기별 메뉴는 없앰)
   -- 저장 파일 옮기기 (휴대폰판 전용: 타이틀 메뉴, zip 내보내기·가져오기)
{"navbar",true},   -- ko 5.0: 내비 바 (휴대폰판 전용: 기능설정에서 시스템 내비게이션 바 숨김/표시, 10-12)
{"unique",true},   -- 고유 조형 (조형 교체기로 지정한 장수의 전용 전투 조형)
{"spriteclass",true}, -- ko 5.0: 성삼국 조형을 받은 장수 148명의 병종을 조형에 맞춤 (unique 뒤, 10-11)
{"town",true},     -- 성내 거리 (자유 행동 때 회의장 왼쪽 아래 화살표 → 거리·주점·집회소, 주민 대화. 시험: 제1장 평원)
{"taverntalk",true}, -- ko 5.0: 주점 무장 대화 대사 (town 애드온이 씀)
{"exprate",true},  -- ko 5.0: exp rate setting (100/75/50%), after free
{"formation",true}, -- ko 5.0: 진형 (삼국지5 陣形, 종횡 모드·기능설정 진형)
{"preview2",true}, -- ko 5.0: 전투·책략 미리보기 새 배치 (공격/반격 칸, 병력 막대, 보정을 진형·지형·특기로 나눠 표시)
{"dmgvary",true}, -- ko 5.0: 일반 공격 피해 변동 ±10% (기능설정 「피해 변동」, 미리보기는 범위·격파 가능 — preview2 뒤, 10-13)
{"fixlv",true}, -- ko 5.1.5 (10-15): 적 레벨 원작 고정 (기능설정 적 레벨 따라옴/원작)
{"bond",true}, -- ko 5.0: 연계 손질 (같이 출진하면 켜짐 — 10-11 거리 없앰, 역사 관계 연계 4종)
{"tank",true}, -- ko 5.0: 탱커 특기 호위·도발 (주위 아군 대신 받기, 적 끌어들이기) — preview2·formation 뒤 (10-11)
{"newgen",true}, -- ko 5.0: 사용자 신무장 (타이틀 「신무장 등록」, 칸 511~530, 연고 주점에서 고용) (10-12)
{"gesync",true}, -- ko 5.1 (10-15): 장수편집 그림 사본(세이브 폴더 genedit/) · 시작할 때 다시 넣기, 세이브 옮기기로 들어온 신무장 · 장수편집 그림 넣기 — newgen 뒤
{"statsync",true}, -- 11-14: same-person slots outside the genedit roster (story enemy-only slots) follow the roster stats and genedit stat edits
{"battlebonus",true}, -- ko 5.0: 이야기 전투 개량 (보너스 목표·추가 사건 공용 함수, kdef 개량 코드가 씀 — 끄지 말 것)
{"view",true}, -- ko 5.0: 삼형제 모드 (분기마다 형제 고르기·외전, koStoryEv 감싸기) — 맨 끝(다른 애드온의 전역 함수를 감쌈)
{"ifbranch",true}, -- ko 6.0 (10-30): 역사 IF 분기 (여포 · 서서 · 장송 갈림길, kdef 860~889, view 뒤)
{"enemygear",true}, -- ko 5.2.8 (10-26): 회차가 오를수록 적장이 진짜 보물 (원작 사본 칸: 2회차 하나, 3회차부터 둘) — diff 앞
{"diff",true}, -- ko 5.0 (10-13): 도전 난이도 개편 (병력·피해·레벨·보상, 단계 규칙 2·4·6·8·10) — view 뒤 (jymain 함수를 감쌈)
{"trial",true}, -- ko 5.0 (10-13): 21회차부터 시련 (코스트만큼 고르기, 적군 출격·적장 출진도 여기로) — diff 뒤
{"storyhire",true}, -- ko 5.1 (10-14): story generals in the inn from the 2nd cycle, parking (enemy appearances), storehouse
{"saveslots",true},
{"epilogue",true}, -- ko 6.0 (10-27): 엔딩 후일담 (본편 엔딩에서 회차 계승 묻기 전에 무장마다 그 뒤 이야기, CC.koOffer 감쌈, record 필요) -- ko 5.2.6 (10-20): 기록 100칸 (10칸씩 10쪽, 목록 아래 쪽 줄)
{"ifcamp",true}, -- 군웅록 (11-04): 이야기 IF 분기 (Event[n] 감싸기, 자료 script/camp/<id>/ifcamp_data.lua)
{"kinship",true}, -- ko 6.0 (10-30): 무장 인연 이벤트 (짝 30쌍 · 함께 이긴 수 3 · 6 · 10 장면 · 인연 연계 같이 출진 +10%, 기록 화면 「인연」 탭)
{"bounty",true}, -- ko 6.0 (10-27): 적장 현상수배 (전투마다 현상 1 · 2회차부터 현상 2, 승리조건 창 · ◆ 표시 · 기록 「현상」 탭, 보상 금 · 도구 · 새 보물 212~217 · 주점 호감) — battlebonus · town · storyhire 뒤, recsave 앞
{"itemsync",true}, -- ko 6.0 (10-27): 옛 세이브를 불러오면 보물 특기 · 전용 무장 · 전용 특기 칸을 newgame 값으로 (기술 새기기로 새길 수 있는 도구의 특기는 그대로) — awaken 앞
{"awaken",false}, -- ko 6.0 (10-28 저녁 끔: gear 애드온으로 합침 — 원작 명품도 전용 보물) (10-27): 명품 각성 ★ (원래 주인이 원작 명품을 들고 싸우면 ★ 판 218~222 로 깨어남, 각성 특기는 koLinkSkill 감쌈) — bond · bounty 뒤, recsave 앞
{"gear",true}, -- ko 6.0 (10-28): 무장 전용 보물 (합류 때 지급 · 2회차부터 적이 듦 · 주인 각성 ★, 데이터 gear_data.lua) — storyhire · awaken 뒤, recsave 앞
{"engrave",true}, -- 11-15: 천공개물로 새긴 장비는 그 한 개만 (도구 표 1000~1999 복사본, 도구 표 2000 칸) — gear · itemsync 뒤
{"bogam",true}, -- ko 6.0 (10-28): 보물 도감 (기록 화면 탭 · 타이틀 메뉴, 기기 공통 CC.koBogam, 그림 data/bogam.grp) — gear 뒤 · recsave 앞
{"conquest",true}, -- ko 6.0 (10-30): 정벌 모드 4판 (3구역 × 10단 갈림길 · 지도 74~97 · 출진 4 · 부대 6 · 군령 12 · 사건 12 · 판 상태 = 인물 칸 650·651, free · freeplus 필요) — bogam 뒤 · recsave 앞
{"puzzle",true}, -- ko 6.0 (10-30): 고사 재현 퍼즐 전투 (제목 다른 모드 > 고사 재현, 8개 · 별 셋, free · view 필요)
{"foeside",true}, -- ko 6.0 (10-30): 적 진영 외전 (제목 다른 모드 > 적 진영, 조조 · 손권 · 위 막마다 전투 셋, 본편 배치 공수 뒤집기)
{"statusslots",true}, -- ko 6.0: character equipment icon slots
{"campsel",true}, -- ko 6.0 (11-01): 이야기 고르기 (타이틀, ko_camp.txt + 다시 시작, script/camp/<id> 묶음)
{"battlehub",true}, -- 11-11: 메인 화면 「전투」(무술 대회 · 자유 전투 · 정벌), 자유 전투 네 이야기 목록, 정벌 기록 공용
{"awakeperson",true}, -- 군웅록 (11-04): 무장 각성 (이야기 클리어로 해금, Lv40 + 금, 병종 그대로 공방 보정 · 특기)
{"recsave",true}, -- ko 6.0 (10-27): 기기 공통 기록(시련·자유 모드·무술 대회 ...)을 data/save/ko_records.lua 에도 저장, 새 판에서 세이브와 함께 이어짐 — 맨 끝(koSave 감쌈, 모든 saveKeys 뒤)
{"uhui",true}, -- 군웅록 (11-06): 숨은 무장 우희 · 외전 해하의 밤
{"bgm",true}, -- 군웅록 (11-03): 새 배경 음악 (sound/B###.mp3 133곡, 이야기 · 모드별 묶음, 기능설정 「배경 음악」 새 곡/원본) — 맨 끝(모드 함수 감쌈)
{"officer_editor",true}, -- Apply explicit developer battle appearances after the normal sprite rules.
{"treasure_inventory",true}, -- Story treasure ownership and next-cycle placement, after engraving restores its copies.
}
