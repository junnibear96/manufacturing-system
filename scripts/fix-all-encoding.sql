SELECT 1 FROM DUAL;




UPDATE tp_process SET process_name = '절단' WHERE TRIM(process_code) = 'CUT';
UPDATE tp_process SET process_name = '조립' WHERE TRIM(process_code) = 'ASM';

UPDATE tp_equipment SET equipment_name = '절단기 1호' WHERE equipment_code = 'EQ-CUT-01';
UPDATE tp_equipment SET equipment_name = '조립기 1호' WHERE equipment_code = 'EQ-ASM-01';



DELETE FROM tp_project_highlight;
DELETE FROM tp_project;
DELETE FROM tp_company_section;
DELETE FROM tp_company_keyword;
DELETE FROM tp_notice;
DELETE FROM tp_board_post;
DELETE FROM tp_group_company;




insert into tp_project(title, stack, sort_order) values ('MES 생산실적/추적성 기능 개선', 'Java · JSP · Spring · Oracle(PL/SQL)', 10);
insert into tp_project(title, stack, sort_order) values ('기존 시스템 유지보수 & 운영 안정화', '운영 · 배포 · RCA · 성능', 20);


insert into tp_project_highlight(project_id, highlight, sort_order)
select p.project_id, '현장 프로세스 기반 화면/업무 흐름 정리 및 개선', 10 from tp_project p where p.sort_order = 10;
insert into tp_project_highlight(project_id, highlight, sort_order)
select p.project_id, '대용량 조회 성능 개선(쿼리 튜닝, 인덱스 점검)', 20 from tp_project p where p.sort_order = 10;
insert into tp_project_highlight(project_id, highlight, sort_order)
select p.project_id, '장애 재발 방지(로그/모니터링 기준 정비)', 30 from tp_project p where p.sort_order = 10;


insert into tp_project_highlight(project_id, highlight, sort_order)
select p.project_id, '반복 이슈 원인 분석 및 조치 표준화', 10 from tp_project p where p.sort_order = 20;
insert into tp_project_highlight(project_id, highlight, sort_order)
select p.project_id, '배치/인터페이스 오류 케이스 보강', 20 from tp_project p where p.sort_order = 20;
insert into tp_project_highlight(project_id, highlight, sort_order)
select p.project_id, '운영 문서화(장애 대응/릴리즈 체크리스트)', 30 from tp_project p where p.sort_order = 20;


insert into tp_company_keyword(keyword, sort_order) values ('Manufacturing', 10);
insert into tp_company_keyword(keyword, sort_order) values ('MES', 20);
insert into tp_company_keyword(keyword, sort_order) values ('Operations', 30);
insert into tp_company_keyword(keyword, sort_order) values ('Quality', 40);
insert into tp_company_keyword(keyword, sort_order) values ('Traceability', 50);


insert into tp_company_section(category, title, anchor, body, sort_order)
values ('TP 소개', 'CEO 인사말', 'ceo-message', '현장과 고객을 먼저 생각하며, 실행 가능한 개선을 꾸준히 만들어냅니다. 시스템은 현장을 따라가야 하며, 데이터는 운영을 돕도록 설계되어야 합니다.', 10);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('TP 소개', '연혁', 'history', '핵심 시스템의 개발부터 운영 안정화까지, 단계적으로 역량을 확장해왔습니다. 장애 대응/재발 방지와 표준화된 릴리즈 프로세스를 중요하게 봅니다.', 20);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('TP 소개', '미션·비전', 'mission-vision', '제조 현장의 흐름을 이해하고, 품질과 생산성을 동시에 높이는 운영 중심의 시스템을 제공합니다.', 30);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('TP 소개', 'CI', 'ci', '단순하고 명확한 정보 전달을 위해 일관된 디자인 시스템을 지향합니다. (포트폴리오용 예시 텍스트)', 40);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('TP 소개', '계열사', 'affiliates', '그룹 내 협업을 통해 공정/품질/물류 등 다양한 도메인 요구를 반영합니다. (포트폴리오용 예시 텍스트)', 50);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('TP 소개', '글로벌 사업장', 'global-sites', '다국적 운영 환경에서도 동일한 기준으로 데이터를 수집/추적할 수 있도록 표준을 맞춥니다. (포트폴리오용 예시 텍스트)', 60);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('회사 소개', '우리가 하는 일', 'what-we-do', '생산 실행(MES) 기능 개발 및 운영 · 현장 이슈 대응 및 안정적인 서비스 운영 · 기존 시스템 유지보수 및 개선', 10);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('회사 소개', '강점(예시)', 'strengths', '현장 프로세스에 맞춘 업무 설계 · 데이터 모델링/성능 최적화 · Spring 기반 확장성 있는 구조', 20);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('사업부문', 'MES / 생산', 'business-mes', '생산실적/투입/공정/불량 등 핵심 데이터를 연결하고, 현장 사용성을 고려해 화면과 업무 흐름을 설계합니다.', 10);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('사업부문', '추적성 / 품질', 'business-quality', 'LOT/Serial 기반 추적성과 품질 지표를 통합해, 원인 분석과 재발 방지를 빠르게 지원합니다.', 20);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('지속가능경영', '안전/윤리', 'sustainability-ethics', '운영 리스크를 줄이기 위해 권한/감사/로그를 체계화하고, 변경 이력을 남기는 것을 기본으로 합니다.', 10);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('지속가능경영', '환경/에너지', 'sustainability-esg', '데이터 기반으로 에너지/자원 사용을 모니터링하고 개선 사이클을 만드는 방향을 지향합니다. (포트폴리오용 예시 텍스트)', 20);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('투자정보', '공시/리포트', 'invest-disclosure', '핵심 지표를 일관된 기준으로 제공하기 위해 데이터 품질과 정합성을 우선합니다. (포트폴리오용 예시 텍스트)', 10);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('미디어', '보도자료', 'media-press', '주요 업데이트와 릴리즈 노트를 명확하게 공유하여 운영 혼선을 줄입니다. (포트폴리오용 예시 텍스트)', 10);

insert into tp_company_section(category, title, anchor, body, sort_order)
values ('채용', '채용 안내', 'careers', '문제를 끝까지 파고들고, 팀과 함께 개선을 만들어가는 개발 문화를 지향합니다. (포트폴리오용 예시 텍스트)', 10);


insert into tp_notice(title, body, created_by)
values ('[공지] 내부 시스템 MVP 오픈', '로그인/권한 + 그룹사/공지/게시판(조회)까지 연결했습니다.\n다음 단계: 생산 계획/실적/통계 화면을 추가합니다.', null);


insert into tp_board_post(title, body, created_by)
values ('첫 글', '게시판은 list/view MVP로 시작합니다.\n(요구사항: 공지 create는 admin만)', null);


insert into tp_group_company(company_code, company_name, description, active_yn)
values ('TP-HQ', 'TP 본사', '내부 시스템 데모용 기본 회사', 'Y');

insert into tp_group_company(company_code, company_name, description, active_yn)
values ('TP-PLANT1', 'TP 1공장', '생산 계획/실적 데이터의 기준 사업장(예시)', 'Y');

COMMIT;


SELECT equipment_name FROM tp_equipment WHERE equipment_code = 'EQ-CUT-01';
SELECT title FROM tp_project WHERE ROWNUM = 1;

