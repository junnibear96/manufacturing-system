-- ====================================
-- Production Management Schema Enhancement
-- 기존 테이블 확장 및 도메인 연계
-- ====================================
-- 작성일: 2026-01-14
-- 목적: Production Management Design을 기반으로 기존 테이블 확장

-- ====================================
-- 1. tp_equipment 테이블 확장
-- ====================================

-- 컬럼 추가
ALTER TABLE tp_equipment ADD (
    line_id VARCHAR2(20),                    -- FK to production_lines
    status VARCHAR2(20) DEFAULT 'STOPPED',   -- RUNNING, IDLE, MAINTENANCE, ERROR, STOPPED
    last_maintenance_at TIMESTAMP,           -- 최근 점검 일시
    maintenance_interval NUMBER(5) DEFAULT 30,  -- 점검 주기 (일)
    utilization_rate NUMBER(5,2) DEFAULT 0,  -- 가동률 (%)
    oee NUMBER(5,2) DEFAULT 0,               -- Overall Equipment Effectiveness
    specifications CLOB,                     -- JSON 형식 스펙
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- FK 추가 (production_lines 테이블이 있을 경우)
-- Note: factory 도메인이 구현되어 있으므로 연결
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD CONSTRAINT fk_equipment_line 
        FOREIGN KEY (line_id) REFERENCES production_lines(line_id)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2264 THEN -- 이미 존재하는 경우 무시
            RAISE;
        END IF;
END;
/

-- 인덱스 추가
CREATE INDEX idx_equipment_line ON tp_equipment(line_id);
CREATE INDEX idx_equipment_status ON tp_equipment(status);

-- ====================================
-- 2. tp_prod_plan 테이블 확장
-- ====================================

ALTER TABLE tp_prod_plan ADD (
    line_id VARCHAR2(20),                    -- FK to production_lines
    target_quantity NUMBER(10) DEFAULT 0,    -- 목표 수량 (qty_plan 보완)
    priority_level NUMBER(1) DEFAULT 3,      -- 우선순위 1(최고) ~ 5(최저)
    status VARCHAR2(20) DEFAULT 'SCHEDULED', -- SCHEDULED, IN_PROGRESS, COMPLETED, CANCELLED
    assigned_worker_count NUMBER(5) DEFAULT 0,
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- FK 추가
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD CONSTRAINT fk_prod_plan_line 
        FOREIGN KEY (line_id) REFERENCES production_lines(line_id)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2264 THEN
            RAISE;
        END IF;
END;
/

-- 인덱스 추가
CREATE INDEX idx_prod_plan_line ON tp_prod_plan(line_id);
CREATE INDEX idx_prod_plan_date ON tp_prod_plan(plan_date);
CREATE INDEX idx_prod_plan_status ON tp_prod_plan(status);

-- ====================================
-- 3. tp_prod_result 테이블 확장
-- ====================================

ALTER TABLE tp_prod_result ADD (
    plan_id NUMBER,                          -- FK to tp_prod_plan (NULL 허용 - 계획 없는 생산 가능)
    line_id VARCHAR2(20),                    -- FK to production_lines
    shift_type VARCHAR2(20),                 -- DAY, NIGHT, AFTERNOON
    worker_id NUMBER,                        -- FK to employees (추후 연동)
    work_hours NUMBER(5) DEFAULT 0,          -- 작업 시간 (분)
    defect_rate NUMBER(5,2) DEFAULT 0,       -- 불량률 (%)
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- FK 추가
ALTER TABLE tp_prod_result ADD CONSTRAINT fk_prod_result_plan 
    FOREIGN KEY (plan_id) REFERENCES tp_prod_plan(plan_id);

BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD CONSTRAINT fk_prod_result_line 
        FOREIGN KEY (line_id) REFERENCES production_lines(line_id)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -2264 THEN
            RAISE;
        END IF;
END;
/

-- 인덱스 추가
CREATE INDEX idx_prod_result_plan ON tp_prod_result(plan_id);
CREATE INDEX idx_prod_result_line ON tp_prod_result(line_id);
CREATE INDEX idx_prod_result_date ON tp_prod_result(work_date);

-- ====================================
-- 4. tp_process 테이블 확장
-- ====================================

ALTER TABLE tp_process ADD (
    sequence_order NUMBER(3) DEFAULT 0,      -- 공정 순서
    standard_time NUMBER(10) DEFAULT 0,      -- 표준 작업 시간 (초)
    qc_criteria CLOB,                        -- 품질 기준 (JSON)
    updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
);

-- ====================================
-- 5. 기존 데이터 마이그레이션 (샘플)
-- ====================================

-- tp_prod_plan의 qty_plan 값을 target_quantity로 복사
UPDATE tp_prod_plan 
SET target_quantity = qty_plan
WHERE target_quantity = 0 OR target_quantity IS NULL;

-- tp_prod_result의 불량률 계산
UPDATE tp_prod_result
SET defect_rate = ROUND(
    CASE 
        WHEN (qty_good + qty_ng) > 0 
        THEN (qty_ng / (qty_good + qty_ng)) * 100
        ELSE 0
    END, 2
)
WHERE defect_rate = 0;

-- ====================================
-- 6. 샘플 데이터 업데이트
-- ====================================

-- 기존 장비에 라인 할당 (LINE001이 있다고 가정)
UPDATE tp_equipment 
SET line_id = 'LINE001',
    status = 'RUNNING',
    last_maintenance_at = SYSTIMESTAMP - INTERVAL '10' DAY,
    utilization_rate = 85.5,
    oee = 72.3
WHERE equipment_code IN ('EQ-CUT-01', 'EQ-ASM-01');

-- 기존 계획에 라인 할당
UPDATE tp_prod_plan
SET line_id = 'LINE001',
    status = 'COMPLETED',
    assigned_worker_count = 10
WHERE plan_id IN (SELECT plan_id FROM tp_prod_plan WHERE ROWNUM = 1);

-- 기존 실적에 plan_id 연결
UPDATE tp_prod_result r
SET plan_id = (
    SELECT p.plan_id 
    FROM tp_prod_plan p 
    WHERE p.plan_date = r.work_date 
    AND p.item_code = r.item_code
    AND ROWNUM = 1
),
line_id = 'LINE001',
shift_type = 'DAY',
work_hours = 480
WHERE r.result_id IN (SELECT result_id FROM tp_prod_result WHERE ROWNUM = 1);

COMMIT;

-- ====================================
-- 7. 검증 쿼리
-- ====================================

-- 확장된 컬럼 확인
SELECT 
    equipment_code,
    equipment_name,
    line_id,
    status,
    last_maintenance_at,
    utilization_rate,
    oee
FROM tp_equipment;

SELECT 
    plan_id,
    plan_date,
    item_code,
    target_quantity,
    status,
    line_id
FROM tp_prod_plan;

SELECT 
    result_id,
    work_date,
    item_code,
    qty_good,
    qty_ng,
    defect_rate,
    plan_id,
    line_id,
    shift_type
FROM tp_prod_result;

-- 계획 대비 실적 분석 샘플 쿼리
SELECT 
    p.plan_id,
    p.plan_date,
    p.item_code,
    p.target_quantity AS target,
    NVL(SUM(r.qty_good), 0) AS actual,
    ROUND(
        NVL(SUM(r.qty_good), 0) * 100.0 / NULLIF(p.target_quantity, 0),
        2
    ) AS achievement_rate,
    CASE 
        WHEN NVL(SUM(r.qty_good), 0) >= p.target_quantity THEN 'EXCEEDED'
        WHEN NVL(SUM(r.qty_good), 0) >= p.target_quantity * 0.9 THEN 'ACHIEVED'
        ELSE 'UNDERPERFORMED'
    END AS performance_status
FROM tp_prod_plan p
LEFT JOIN tp_prod_result r ON p.plan_id = r.plan_id
WHERE p.plan_date >= TRUNC(SYSDATE - 7)
GROUP BY p.plan_id, p.plan_date, p.item_code, p.target_quantity
ORDER BY p.plan_date DESC;
