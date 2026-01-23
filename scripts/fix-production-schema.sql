-- ========================================
-- 스키마 상태 확인 및 누락 컬럼 수정
-- ========================================

-- 1단계: 현재 컬럼 상태 확인
SELECT '=== TP_EQUIPMENT 컬럼 확인 ===' AS info FROM dual;
SELECT column_name, data_type, data_length
FROM user_tab_columns
WHERE table_name = 'TP_EQUIPMENT'
ORDER BY column_id;

SELECT '=== TP_PROD_PLAN 컬럼 확인 ===' AS info FROM dual;
SELECT column_name, data_type, data_length
FROM user_tab_columns
WHERE table_name = 'TP_PROD_PLAN'
ORDER BY column_id;

SELECT '=== TP_PROD_RESULT 컬럼 확인 ===' AS info FROM dual;
SELECT column_name, data_type, data_length
FROM user_tab_columns
WHERE table_name = 'TP_PROD_RESULT'
ORDER BY column_id;

-- 2단계: 누락된 컬럼이 있으면 아래 스크립트 실행
-- (위 결과를 보고 STATUS, LINE_ID 등이 없으면 실행)

-- TP_EQUIPMENT의 STATUS 컬럼 추가
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'STATUS';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD status VARCHAR2(20) DEFAULT ''STOPPED''';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.STATUS 추가 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('○ tp_equipment.STATUS 이미 존재');
    END IF;
END;
/

-- TP_EQUIPMENT의 나머지 컬럼 추가
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'LINE_ID';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD line_id VARCHAR2(20)';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.LINE_ID 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'LAST_MAINTENANCE_AT';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD last_maintenance_at TIMESTAMP';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.LAST_MAINTENANCE_AT 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'MAINTENANCE_INTERVAL';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD maintenance_interval NUMBER(5) DEFAULT 30';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.MAINTENANCE_INTERVAL 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'UTILIZATION_RATE';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD utilization_rate NUMBER(5,2) DEFAULT 0';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.UTILIZATION_RATE 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'OEE';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD oee NUMBER(5,2) DEFAULT 0';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.OEE 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_EQUIPMENT' AND column_name = 'UPDATED_AT';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_equipment ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP';
        DBMS_OUTPUT.PUT_LINE('✓ tp_equipment.UPDATED_AT 추가 완료');
    END IF;
END;
/

-- TP_PROD_PLAN의 STATUS 컬럼 추가
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_PLAN' AND column_name = 'STATUS';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD status VARCHAR2(20) DEFAULT ''SCHEDULED''';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_plan.STATUS 추가 완료');
    ELSE
        DBMS_OUTPUT.PUT_LINE('○ tp_prod_plan.STATUS 이미 존재');
    END IF;
END;
/

-- TP_PROD_PLAN의 나머지 컬럼 추가
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_PLAN' AND column_name = 'LINE_ID';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD line_id VARCHAR2(20)';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_plan.LINE_ID 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_PLAN' AND column_name = 'TARGET_QUANTITY';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD target_quantity NUMBER(10) DEFAULT 0';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_plan.TARGET_QUANTITY 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_PLAN' AND column_name = 'PRIORITY_LEVEL';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD priority_level NUMBER(1) DEFAULT 3';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_plan.PRIORITY_LEVEL 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_PLAN' AND column_name = 'ASSIGNED_WORKER_COUNT';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD assigned_worker_count NUMBER(5) DEFAULT 0';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_plan.ASSIGNED_WORKER_COUNT 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_PLAN' AND column_name = 'UPDATED_AT';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_plan ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_plan.UPDATED_AT 추가 완료');
    END IF;
END;
/

-- TP_PROD_RESULT 컬럼 추가
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'PLAN_ID';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD plan_id NUMBER';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.PLAN_ID 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'LINE_ID';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD line_id VARCHAR2(20)';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.LINE_ID 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'SHIFT_TYPE';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD shift_type VARCHAR2(20)';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.SHIFT_TYPE 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'WORKER_ID';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD worker_id NUMBER';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.WORKER_ID 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'WORK_HOURS';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD work_hours NUMBER(5) DEFAULT 0';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.WORK_HOURS 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'DEFECT_RATE';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD defect_rate NUMBER(5,2) DEFAULT 0';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.DEFECT_RATE 추가 완료');
    END IF;
    
    SELECT COUNT(*) INTO v_count
    FROM user_tab_columns
    WHERE table_name = 'TP_PROD_RESULT' AND column_name = 'UPDATED_AT';
    
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE tp_prod_result ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP';
        DBMS_OUTPUT.PUT_LINE('✓ tp_prod_result.UPDATED_AT 추가 완료');
    END IF;
END;
/

-- 3단계: 기본 데이터 업데이트
UPDATE tp_equipment 
SET status = 'STOPPED'
WHERE status IS NULL;

UPDATE tp_equipment
SET utilization_rate = 0
WHERE utilization_rate IS NULL;

UPDATE tp_prod_plan
SET target_quantity = NVL(qty_plan, 0)
WHERE target_quantity IS NULL OR target_quantity = 0;

UPDATE tp_prod_plan
SET status = 'SCHEDULED'
WHERE status IS NULL;

COMMIT;

-- 4단계: 최종 확인
SELECT '=== 최종 확인: TP_EQUIPMENT ===' AS info FROM dual;
SELECT equipment_code, status, utilization_rate, oee
FROM tp_equipment
WHERE ROWNUM <= 3;

SELECT '=== 최종 확인: TP_PROD_PLAN ===' AS info FROM dual;
SELECT plan_id, status, target_quantity, priority_level
FROM tp_prod_plan
WHERE ROWNUM <= 3;

SELECT '✓✓✓ 스키마 수정 완료! ✓✓✓' AS result FROM dual;
