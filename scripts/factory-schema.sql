-- ====================================
-- Factory Management Schema
-- 공장 관리 스키마
-- ====================================

-- 1. 사업장 (Plants) 테이블
CREATE TABLE plants (
    plant_id VARCHAR2(20) PRIMARY KEY,
    plant_name VARCHAR2(100) NOT NULL,
    plant_name_en VARCHAR2(100),
    
    address VARCHAR2(200),
    address_detail VARCHAR2(200),
    postal_code VARCHAR2(10),
    coordinates VARCHAR2(100), -- JSON: {"lat": 37.xxx, "lng": 127.xxx}
    
    plant_type VARCHAR2(20) NOT NULL, -- MAIN_FACTORY, BRANCH_FACTORY, WAREHOUSE, R&D_CENTER
    status VARCHAR2(20) DEFAULT 'ACTIVE', -- ACTIVE, MAINTENANCE, SUSPENDED, CLOSED
    total_area NUMBER(10,2),
    established_date DATE,
    
    manager_emp_id VARCHAR2(20), -- FK to employees
    phone VARCHAR2(20),
    fax VARCHAR2(20),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 공장 (Factories) 테이블
CREATE TABLE factories (
    factory_id VARCHAR2(20) PRIMARY KEY,
    plant_id VARCHAR2(20) NOT NULL,
    
    factory_name VARCHAR2(100) NOT NULL,
    factory_name_en VARCHAR2(100),
    factory_code VARCHAR2(20),
    
    factory_type VARCHAR2(20) NOT NULL, -- ASSEMBLY, PROCESSING, PACKAGING, TESTING, LOGISTICS
    status VARCHAR2(20) DEFAULT 'ACTIVE', -- ACTIVE, IDLE, MAINTENANCE, SHUTDOWN
    product_category VARCHAR2(100),
    
    building_code VARCHAR2(20),
    floor VARCHAR2(10),
    area NUMBER(10,2),
    
    target_utilization_rate NUMBER(5,2), -- 목표 가동률 (%)
    
    manager_emp_id VARCHAR2(20), -- FK to employees
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_factory_plant FOREIGN KEY (plant_id) REFERENCES plants(plant_id)
);

-- 3. 생산라인 (Production Lines) 테이블
CREATE TABLE production_lines (
    line_id VARCHAR2(20) PRIMARY KEY,
    factory_id VARCHAR2(20) NOT NULL,
    
    line_name VARCHAR2(100) NOT NULL,
    line_code VARCHAR2(20),
    
    line_type VARCHAR2(20) NOT NULL, -- MANUAL, SEMI_AUTO, FULL_AUTO
    status VARCHAR2(20) DEFAULT 'STOPPED', -- RUNNING, STOPPED, IDLE, MAINTENANCE, ERROR
    is_operating NUMBER(1) DEFAULT 0, -- 0: false, 1: true
    
    max_capacity NUMBER(10) DEFAULT 0,
    takt_time NUMBER(10) DEFAULT 0, -- 초 단위
    cycle_time NUMBER(10) DEFAULT 0, -- 초 단위
    utilization_rate NUMBER(5,2) DEFAULT 0, -- %
    
    standard_workers NUMBER(5) DEFAULT 0,
    current_workers NUMBER(5) DEFAULT 0,
    line_leader_emp_id VARCHAR2(20), -- FK to employees
    
    producible_items CLOB, -- JSON 배열
    equipment_list CLOB, -- JSON 배열
    shift_pattern VARCHAR2(20), -- DAY_ONLY, 2_SHIFT, 3_SHIFT, 24_HOURS
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_operated_at TIMESTAMP,
    
    CONSTRAINT fk_line_factory FOREIGN KEY (factory_id) REFERENCES factories(factory_id)
);

-- 인덱스 생성
CREATE INDEX idx_factory_plant ON factories(plant_id);
CREATE INDEX idx_factory_status ON factories(status);
CREATE INDEX idx_line_factory ON production_lines(factory_id);
CREATE INDEX idx_line_status ON production_lines(status);

-- ====================================
-- Sample Data
-- ====================================

-- 사업장 샘플 데이터
INSERT INTO plants VALUES (
    'PLT001', 
    'TP 본사 공장', 
    'TP Main Plant',
    '경기도 성남시 분당구 판교로 123',
    '테크노밸리 A동',
    '13487',
    '{"lat": 37.394, "lng": 127.111}',
    'MAIN_FACTORY',
    'ACTIVE',
    15000.00,
    TO_DATE('2020-03-15', 'YYYY-MM-DD'),
    NULL,
    '031-1234-5678',
    '031-1234-5679',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO plants VALUES (
    'PLT002',
    'TP 천안 물류센터',
    'TP Cheonan Logistics',
    '충청남도 천안시 서북구 공단로 456',
    NULL,
    '31100',
    '{"lat": 36.815, "lng": 127.114}',
    'WAREHOUSE',
    'ACTIVE',
    8000.00,
    TO_DATE('2021-06-01', 'YYYY-MM-DD'),
    NULL,
    '041-9876-5432',
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- 공장 샘플 데이터
INSERT INTO factories VALUES (
    'FAC001',
    'PLT001',
    '1공장 (조립)',
    'Factory 1 (Assembly)',
    'F001',
    'ASSEMBLY',
    'ACTIVE',
    '전자제품',
    'A동',
    '1F',
    3000.00,
    85.00,
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO factories VALUES (
    'FAC002',
    'PLT001',
    '2공장 (가공)',
    'Factory 2 (Processing)',
    'F002',
    'PROCESSING',
    'ACTIVE',
    '부품',
    'B동',
    '1F-2F',
    2500.00,
    80.00,
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO factories VALUES (
    'FAC003',
    'PLT001',
    '3공장 (포장)',
    'Factory 3 (Packaging)',
    'F003',
    'PACKAGING',
    'ACTIVE',
    '완제품',
    'C동',
    '1F',
    1500.00,
    90.00,
    NULL,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

-- 생산라인 샘플 데이터
INSERT INTO production_lines VALUES (
    'LINE001',
    'FAC001',
    '조립 라인 1',
    'AS-001',
    'SEMI_AUTO',
    'RUNNING',
    1,
    500,
    60,
    65,
    92.5,
    10,
    10,
    NULL,
    '["스마트폰", "태블릿"]',
    '["컨베이어 벨트", "자동 나사조임기", "검사장비"]',
    '2_SHIFT',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO production_lines VALUES (
    'LINE002',
    'FAC001',
    '조립 라인 2',
    'AS-002',
    'MANUAL',
    'RUNNING',
    1,
    300,
    90,
    95,
    85.0,
    15,
    14,
    NULL,
    '["노트북", "모니터"]',
    '["작업대", "수동 조립 도구"]',
    '2_SHIFT',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

INSERT INTO production_lines VALUES (
    'LINE003',
    'FAC002',
    '가공 라인 1',
    'PR-001',
    'FULL_AUTO',
    'MAINTENANCE',
    0,
    800,
    45,
    47,
    0,
    5,
    0,
    NULL,
    '["PCB", "메인보드"]',
    '["CNC 기계", "자동 절단기", "품질검사 로봇"]',
    '3_SHIFT',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP - INTERVAL '2' HOUR
);

INSERT INTO production_lines VALUES (
    'LINE004',
    'FAC003',
    '포장 라인 1',
    'PK-001',
    'SEMI_AUTO',
    'RUNNING',
    1,
    1000,
    30,
    32,
    95.0,
    8,
    8,
    NULL,
    '["박스 포장", "팔레트 적재"]',
    '["포장기", "라벨링 머신", "박스 실러"]',
    '2_SHIFT',
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
);

COMMIT;
