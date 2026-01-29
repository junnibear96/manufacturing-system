-- Combined Equipment Schema Fixes
-- Execute this to ensure equipment table has all necessary columns and correct data

-- 1. Create synonym for backward compatibility (if not exists)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_synonyms WHERE synonym_name = 'TP_EQUIPMENT';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SYNONYM tp_equipment FOR equipment';
    END IF;
END;
/

-- 2. Add missing columns to EQUIPMENT table (if not exists)
DECLARE
    v_count NUMBER;
BEGIN
    -- Check LINE_ID
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'LINE_ID';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD line_id VARCHAR2(20)';
    END IF;

    -- Check STATUS
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'STATUS';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD status VARCHAR2(20) DEFAULT ''STOPPED''';
    END IF;

    -- Check LAST_MAINTENANCE_AT
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'LAST_MAINTENANCE_AT';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD last_maintenance_at TIMESTAMP';
    END IF;

    -- Check MAINTENANCE_INTERVAL
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'MAINTENANCE_INTERVAL';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD maintenance_interval NUMBER(5) DEFAULT 30';
    END IF;

    -- Check UTILIZATION_RATE
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'UTILIZATION_RATE';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD utilization_rate NUMBER(5,2) DEFAULT 0';
    END IF;

    -- Check TARGET_UTILIZATION_RATE
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'TARGET_UTILIZATION_RATE';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD target_utilization_rate NUMBER(5,2) DEFAULT 85';
    END IF;

    -- Check OEE
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'OEE';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD oee NUMBER(5,2) DEFAULT 0';
    END IF;

    -- Check SPECIFICATIONS
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'SPECIFICATIONS';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD specifications CLOB';
    END IF;

    -- Check CREATED_AT
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'CREATED_AT';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD created_at TIMESTAMP DEFAULT SYSTIMESTAMP';
    END IF;

    -- Check UPDATED_AT
    SELECT COUNT(*) INTO v_count FROM user_tab_columns WHERE table_name = 'EQUIPMENT' AND column_name = 'UPDATED_AT';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'ALTER TABLE equipment ADD updated_at TIMESTAMP DEFAULT SYSTIMESTAMP';
    END IF;
END;
/

-- 3. Fix NULL values
UPDATE equipment SET status = 'STOPPED' WHERE status IS NULL;
UPDATE equipment SET utilization_rate = 0 WHERE utilization_rate IS NULL;
UPDATE equipment SET target_utilization_rate = 85 WHERE target_utilization_rate IS NULL;
UPDATE equipment SET oee = 0 WHERE oee IS NULL;
UPDATE equipment SET maintenance_interval = 30 WHERE maintenance_interval IS NULL;

-- 4. Update some equipment to have realistic statuses for testing
UPDATE equipment SET status = 'RUNNING', utilization_rate = 85.5 WHERE equipment_id = 1;
UPDATE equipment SET status = 'RUNNING', utilization_rate = 92.3 WHERE equipment_id = 2;
UPDATE equipment SET status = 'IDLE', utilization_rate = 15.2 WHERE equipment_id = 3;
UPDATE equipment SET status = 'MAINTENANCE', utilization_rate = 0 WHERE equipment_id = 4;
UPDATE equipment SET status = 'STOPPED', utilization_rate = 0 WHERE equipment_id = 5;

COMMIT;

-- 5. Verify the changes
SELECT 'Equipment Status Summary:' as info FROM dual;
SELECT status, COUNT(*) as count FROM equipment GROUP BY status;

SELECT 'Equipment Details:' as info FROM dual;
SELECT equipment_id, equipment_code, equipment_name, status, utilization_rate, target_utilization_rate
FROM equipment
ORDER BY equipment_id;
