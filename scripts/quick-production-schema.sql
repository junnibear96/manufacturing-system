-- ========================================
-- 빠른 스키마 확인 및 적용 스크립트
-- ========================================

-- 1. 현재 스키마 상태 확인
SELECT 
    'tp_equipment' AS table_name,
    column_name,
    data_type
FROM user_tab_columns
WHERE table_name = 'TP_EQUIPMENT'
  AND column_name IN ('LINE_ID', 'STATUS', 'UTILIZATION_RATE', 'OEE')
ORDER BY column_name;

-- 결과가 0건이면 스키마가 적용되지 않은 것입니다.
-- 결과가 4건이면 스키마가 정상 적용된 것입니다.

-- ========================================
-- 2. 스키마가 적용되지 않았다면 이 스크립트를 실행하세요
-- ========================================

-- tp_equipment 테이블 확장
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD (
        line_id VARCHAR2(20),
        status VARCHAR2(20) DEFAULT ''STOPPED'',
        last_maintenance_at TIMESTAMP,
        maintenance_interval NUMBER(5) DEFAULT 30,
        utilization_rate NUMBER(5,2) DEFAULT 0,
        oee NUMBER(5,2) DEFAULT 0,
        specifications CLOB,
        updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
    )';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN  -- column already exists
            DBMS_OUTPUT.PUT_LINE('tp_equipment columns already exist');
        ELSE
            RAISE;
        END IF;
END;
/

-- tp_prod_plan 테이블 확장
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD (
        line_id VARCHAR2(20),
        target_quantity NUMBER(10) DEFAULT 0,
        priority_level NUMBER(1) DEFAULT 3,
        status VARCHAR2(20) DEFAULT ''SCHEDULED'',
        assigned_worker_count NUMBER(5) DEFAULT 0,
        updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
    )';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('tp_prod_plan columns already exist');
        ELSE
            RAISE;
        END IF;
END;
/

-- tp_prod_result 테이블 확장  
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD (
        plan_id NUMBER,
        line_id VARCHAR2(20),
        shift_type VARCHAR2(20),
        worker_id NUMBER,
        work_hours NUMBER(5) DEFAULT 0,
        defect_rate NUMBER(5,2) DEFAULT 0,
        updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
    )';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('tp_prod_result columns already exist');
        ELSE
            RAISE;
        END IF;
END;
/

-- tp_process 테이블 확장
BEGIN
    EXECUTE IMMEDIATE 'ALTER TABLE tp_process ADD (
        sequence_order NUMBER(3) DEFAULT 0,
        standard_time NUMBER(10) DEFAULT 0,
        qc_criteria CLOB,
        updated_at TIMESTAMP DEFAULT SYSTIMESTAMP
    )';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -1430 THEN
            DBMS_OUTPUT.PUT_LINE('tp_process columns already exist');
        ELSE
            RAISE;
        END IF;
END;
/

-- 인덱스 생성
BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_equipment_status ON tp_equipment(status)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN  -- name already used
            NULL;
        ELSE
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_prod_plan_date ON tp_prod_plan(plan_date)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            NULL;
        ELSE
            RAISE;
        END IF;
END;
/

BEGIN
    EXECUTE IMMEDIATE 'CREATE INDEX idx_prod_result_date ON tp_prod_result(work_date)';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE = -955 THEN
            NULL;
        ELSE
            RAISE;
        END IF;
END;
/

-- 기존 데이터 업데이트
UPDATE tp_prod_plan 
SET target_quantity = NVL(qty_plan, 0)
WHERE target_quantity = 0 OR target_quantity IS NULL;

UPDATE tp_prod_result
SET defect_rate = ROUND(
    CASE 
        WHEN (qty_good + qty_ng) > 0 
        THEN (qty_ng / (qty_good + qty_ng)) * 100
        ELSE 0
    END, 2
)
WHERE defect_rate = 0;

UPDATE tp_equipment 
SET status = 'STOPPED',
    utilization_rate = 0
WHERE status IS NULL;

COMMIT;

-- ========================================
-- 3. 적용 확인
-- ========================================
SELECT 'Schema applied successfully!' AS result FROM dual;

SELECT equipment_code, status, utilization_rate 
FROM tp_equipment 
WHERE ROWNUM <= 5;
