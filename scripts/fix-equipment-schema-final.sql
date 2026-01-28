-- Equipment Schema Fix
-- 1. Create synonym for backward compatibility
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_synonyms WHERE synonym_name = 'TP_EQUIPMENT';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE 'CREATE SYNONYM tp_equipment FOR equipment';
    END IF;
END;
/

-- 2. Add missing columns to EQUIPMENT table
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
