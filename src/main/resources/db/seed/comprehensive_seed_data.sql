-- ============================================================================
-- COMPREHENSIVE SAMPLE DATA - Manufacturing Simulation
-- Created: 2026-01-18
-- Purpose: Large-scale sample data for load testing and simulation
-- ============================================================================

-- Note: Run V002 migration first to ensure schema is ready

-- ============================================================================
-- 1. FACTORIES (3 factories across Korea)
-- ============================================================================

DELETE FROM tp_manufacture.tp_factories;

INSERT INTO tp_manufacture.tp_factories (factory_id, factory_name, factory_code, location, established_date, total_area, total_employees, status)
VALUES 
    ('F001', '서울 본사 공장', 'SEL', '서울특별시 금천구 가산디지털1로 181', TO_DATE('2010-03-15', 'YYYY-MM-DD'), 15000.50, 320, 'ACTIVE'),
    ('F002', '부산 제2공장', 'BSN', '부산광역시 강서구 녹산산업중로 326', TO_DATE('2015-07-20', 'YYYY-MM-DD'), 25000.00, 450, 'ACTIVE'),
    ('F003', '대구 제3공장', 'DGU', '대구광역시 달성군 다사읍 세천로 89', TO_DATE('2020-11-05', 'YYYY-MM-DD'), 18000.75, 280, 'ACTIVE');

-- ============================================================================
-- 2. PLANTS (9 plants - 3 per factory)
-- ============================================================================

DELETE FROM tp_manufacture.tp_plants;

-- Seoul Factory Plants
INSERT INTO tp_manufacture.tp_plants (plant_id, factory_id, plant_name, plant_code, plant_type, production_area, office_area, warehouse_area, max_workers, manager_name, phone_number, status)
VALUES
    ('P001', 'F001', '조립 A동', 'SEL-A', 'ASSEMBLY', 5000.00, 500.00, 1000.00, 120, '김철수', '02-1234-5678', 'ACTIVE'),
    ('P002', 'F001', '가공 B동', 'SEL-B', 'PROCESSING', 4000.00, 400.00, 800.00, 100, '이영희', '02-1234-5679', 'ACTIVE'),
    ('P003', 'F001', '품질검사 C동', 'SEL-C', 'INSPECTION', 3000.00, 600.00, 500.00, 80, '박지성', '02-1234-5680', 'ACTIVE');

-- Busan Factory Plants
INSERT INTO tp_manufacture.tp_plants (plant_id, factory_id, plant_name, plant_code, plant_type, production_area, office_area, warehouse_area, max_workers, manager_name, phone_number, status)
VALUES
    ('P004', 'F002', '대형부품 A동', 'BSN-A', 'ASSEMBLY', 8000.00, 700.00, 2000.00, 180, '최민수', '051-2345-6789', 'ACTIVE'),
    ('P005', 'F002', '정밀가공 B동', 'BSN-B', 'PROCESSING', 6000.00, 500.00, 1500.00, 140, '강호동', '051-2345-6790', 'ACTIVE'),
    ('P006', 'F002', '포장 C동', 'BSN-C', 'PACKAGING', 5000.00, 400.00, 2500.00, 100, '유재석', '051-2345-6791', 'ACTIVE');

-- Daegu Factory Plants
INSERT INTO tp_manufacture.tp_plants (plant_id, factory_id, plant_name, plant_code, plant_type, production_area, office_area, warehouse_area, max_workers, manager_name, phone_number, status)
VALUES
    ('P007', 'F003', '전자부품 A동', 'DGU-A', 'ASSEMBLY', 6000.00, 600.00, 1200.00, 110, '송혜교', '053-3456-7890', 'ACTIVE'),
    ('P008', 'F003', '표면처리 B동', 'DGU-B', 'SURFACE_TREATMENT', 5000.00, 400.00, 1000.00, 90, '현빈', '053-3456-7891', 'ACTIVE'),
    ('P009', 'F003', '최종조립 C동', 'DGU-C', 'FINAL_ASSEMBLY', 4500.00, 500.00, 1500.00, 80, '손예진', '053-3456-7892', 'ACTIVE');

-- ============================================================================
-- 3. PRODUCTION LINES (45 lines - 5 per plant)
-- ============================================================================

DELETE FROM tp_manufacture.tp_production_lines;

-- Helper function to generate random utilization rate
DECLARE
    v_line_id VARCHAR2(50);
    v_plant_id VARCHAR2(50);
    v_line_num NUMBER;
    v_status VARCHAR2(20);
    v_utilization NUMBER(5,2);
BEGIN
    -- Lines for each plant (5 lines per plant, 45 total)
    FOR plant_num IN 1..9 LOOP
        v_plant_id := 'P' || LPAD(plant_num, 3, '0');
        
        FOR line_num IN 1..5 LOOP
            v_line_id := v_plant_id || '-L' || line_num;
            
            -- Randomize status
            CASE MOD(line_num, 4)
                WHEN 0 THEN v_status := 'RUNNING';
                WHEN 1 THEN v_status := 'IDLE';
                WHEN  2 THEN v_status := 'RUNNING';
                ELSE v_status := 'STOPPED';
            END CASE;
            
            -- Set utilization based on status
            CASE v_status
                WHEN 'RUNNING' THEN v_utilization := ROUND(DBMS_RANDOM.VALUE(60, 95), 2);
                WHEN 'IDLE' THEN v_utilization := ROUND(DBMS_RANDOM.VALUE(10, 40), 2);
                WHEN 'STOPPED' THEN v_utilization := 0.00;
                ELSE v_utilization := ROUND(DBMS_RANDOM.VALUE(20, 80), 2);
            END CASE;
            
            INSERT INTO tp_manufacture.tp_production_lines (
                line_id, factory_id, line_name, line_code, line_type, status, is_operating,
                max_capacity, takt_time, cycle_time, utilization_rate,
                standard_workers, current_workers, shift_pattern,
                created_at, updated_at, utilization_updated_at
            ) VALUES (
                v_line_id,
                'F' || LPAD(CEIL(plant_num/3), 3, '0'),
                'Line ' || line_num || ' - Plant ' || v_plant_id,
                v_plant_id || '-L' || line_num,
                CASE MOD(line_num, 3) WHEN 0 THEN 'FULL_AUTO' WHEN 1 THEN 'SEMI_AUTO' ELSE 'MANUAL' END,
                v_status,
                CASE WHEN v_status = 'RUNNING' THEN 1 ELSE 0 END,
                100 + (line_num * 50),
                60 - (line_num * 5),
                50 + (line_num * 10),
                v_utilization,
                5 + line_num,
                CASE WHEN v_status = 'RUNNING' THEN 5 + line_num ELSE FLOOR(DBMS_RANDOM.VALUE(0, 5 + line_num)) END,
                CASE MOD(line_num, 4) WHEN 0 THEN '3_SHIFT' WHEN 1 THEN '2_SHIFT' ELSE 'DAY_ONLY' END,
                CURRENT_TIMESTAMP - DBMS_RANDOM.VALUE(30, 365),
                CURRENT_TIMESTAMP,
                CURRENT_TIMESTAMP - DBMS_RANDOM.VALUE(0, 24)/24
            );
        END LOOP;
    END LOOP;
    
    COMMIT;
END;
/

-- ============================================================================
-- 4. INVENTORY ITEMS (65 items)
-- ============================================================================

-- Raw Materials (20 items)
DECLARE
    v_counter NUMBER := 0;
BEGIN
    FOR i IN 1..20 LOOP
        v_counter := v_counter + 1;
        INSERT INTO tp_manufacture.tp_inventory (
            item_code, item_name, item_type, unit, current_quantity, min_quantity, unit_price, warehouse_location, status
        ) VALUES (
            'RM-' || LPAD(i, 3, '0'),
            CASE MOD(i, 10)
                WHEN 0 THEN 'Steel Plate ' || i || ' mm'
                WHEN 1 THEN 'Aluminum Rod ' || i || ' cm'
                WHEN 2 THEN 'Copper Wire ' || i || ' m'
                WHEN 3 THEN 'Plastic Pellets Type ' || i
                WHEN 4 THEN 'Rubber Sheet ' || i || ' mm'
                WHEN 5 THEN 'Carbon Fiber ' || i || ' g'
                WHEN 6 THEN 'Titanium Alloy ' || i
                WHEN 7 THEN 'Glass Fiber ' || i || ' m'
                WHEN 8 THEN 'Silicon Wafer ' || i
                ELSE 'Composite Material ' || i
            END,
            'RAW_MATERIAL',
            CASE MOD(i, 4) WHEN 0 THEN 'KG' WHEN 1 THEN 'M' WHEN 2 THEN 'L' ELSE 'EA' END,
            ROUND(DBMS_RANDOM.VALUE(500, 5000), 2),
            ROUND(DBMS_RANDOM.VALUE(100, 500), 2),
            ROUND(DBMS_RANDOM.VALUE(10, 500), 2),
            'A동-' || CEIL(i/5) || '구역',
            'ACTIVE'
        );
    END LOOP;
    COMMIT;
END;
/

-- Components (30 items)
DECLARE
    v_counter NUMBER := 0;
BEGIN
    FOR i IN 1..30 LOOP
        v_counter := v_counter + 1;
        INSERT INTO tp_manufacture.tp_inventory (
            item_code, item_name, item_type, unit, current_quantity, min_quantity, unit_price, warehouse_location, status
        ) VALUES (
            'CMP-' || LPAD(i, 3, '0'),
            CASE MOD(i, 10)
                WHEN 0 THEN 'Motor Unit ' || i
                WHEN 1 THEN 'Gear Assembly ' || i
                WHEN 2 THEN 'Bearing ' || i || 'mm'
                WHEN 3 THEN 'PCB Board ' || i
                WHEN 4 THEN 'LED Module ' || i
                WHEN 5 THEN 'Sensor Unit ' || i
                WHEN 6 THEN 'Controller ' || i
                WHEN 7 THEN 'Power Supply ' || i || 'W'
                WHEN 8 THEN 'Housing ' || i
                ELSE 'Connector Set ' || i
            END,
            'COMPONENT',
            'EA',
            ROUND(DBMS_RANDOM.VALUE(100, 2000), 2),
            ROUND(DBMS_RANDOM.VALUE(20, 200), 2),
            ROUND(DBMS_RANDOM.VALUE(50, 2000), 2),
            'B동-' || CEIL(i/6) || '구역',
            'ACTIVE'
        );
    END LOOP;
    COMMIT;
END;
/

-- Finished Products (15 items)
DECLARE
    v_counter NUMBER := 0;
BEGIN
    FOR i IN 1..15 LOOP
        v_counter := v_counter + 1;
        INSERT INTO tp_manufacture.tp_inventory (
            item_code, item_name, item_type, unit, current_quantity, min_quantity, unit_price, warehouse_location, status
        ) VALUES (
            'FP-' || LPAD(i, 3, '0'),
            CASE MOD(i, 7)
                WHEN 0 THEN 'Industrial Robot Model ' || i
                WHEN 1 THEN 'Precision Machine ' || i
                WHEN 2 THEN 'Electronic Device ' || i
                WHEN 3 THEN 'Assembly Unit ' || i
                WHEN 4 THEN 'Control Panel ' || i
                WHEN 5 THEN 'Testing Equipment ' || i
                ELSE 'Production Module ' || i
            END,
            'FINISHED_PRODUCT',
            'EA',
            ROUND(DBMS_RANDOM.VALUE(10, 500), 2),
            ROUND(DBMS_RANDOM.VALUE(5, 50), 2),
            ROUND(DBMS_RANDOM.VALUE(5000, 50000), 2),
            'C동-' || CEIL(i/3) || '구역',
            'ACTIVE'
        );
    END LOOP;
    COMMIT;
END;
/

-- ============================================================================
-- 5. PRODUCTION BOM (Bill of Materials) - Link lines to inventory
-- ============================================================================

-- For each production line, assign 3-5 raw materials/components
DECLARE
    v_line_id VARCHAR2(50);
    v_inventory_id NUMBER;
    v_consumption_rate NUMBER(10,4);
    v_item_count NUMBER := 0;
BEGIN
    -- Get all production lines
    FOR line_rec IN (SELECT line_id FROM tp_manufacture.tp_production_lines) LOOP
        v_line_id := line_rec.line_id;
        
        -- Each line consumes 3-5 items
        v_item_count := FLOOR(DBMS_RANDOM.VALUE(3, 6));
        
        FOR i IN 1..v_item_count LOOP
            -- Select random raw material or component
            SELECT inventory_id INTO v_inventory_id
            FROM (
                SELECT inventory_id 
                FROM tp_manufacture.tp_inventory
                WHERE item_type IN ('RAW_MATERIAL', 'COMPONENT')
                ORDER BY DBMS_RANDOM.VALUE
            )
            WHERE ROWNUM = 1;
            
            -- Random consumption rate (0.5 to 50 units per hour at 100% utilization)
            v_consumption_rate := ROUND(DBMS_RANDOM.VALUE(0.5, 50), 4);
            
            -- Insert BOM entry
            BEGIN
                INSERT INTO tp_manufacture.tp_production_bom (
                    line_id, inventory_id, consumption_rate, unit, notes, is_active
                ) VALUES (
                    v_line_id,
                    v_inventory_id,
                    v_consumption_rate,
                    'KG',
                    'Auto-generated BOM for simulation',
                    'Y'
                );
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    NULL; -- Skip duplicates
            END;
        END LOOP;
    END LOOP;
    
    COMMIT;
END;
/

-- ============================================================================
-- 6. PRODUCTION PLANS (100+ plans for last 30 days)
-- ============================================================================

-- Generate plans - This will be handled by existing data or manually

-- ============================================================================
-- 7. VERIFICATION QUERIES
-- ============================================================================

-- Count records
SELECT 'Factories' AS entity, COUNT(*) AS count FROM tp_manufacture.tp_factories
UNION ALL
SELECT 'Plants', COUNT(*) FROM tp_manufacture.tp_plants
UNION ALL
SELECT 'Production Lines', COUNT(*) FROM tp_manufacture.tp_production_lines
UNION ALL
SELECT 'Inventory Items', COUNT(*) FROM tp_manufacture.tp_inventory
UNION ALL
SELECT 'BOM Entries', COUNT(*) FROM tp_manufacture.tp_production_bom;

-- Check line utilization distribution
SELECT 
    CASE 
        WHEN utilization_rate = 0 THEN '0% (Stopped)'
        WHEN utilization_rate < 50 THEN '1-49% (Low)'
        WHEN utilization_rate < 80 THEN '50-79% (Medium)'
        ELSE '80-100% (High)'
    END AS utilization_range,
    COUNT(*) AS line_count
FROM tp_manufacture.tp_production_lines
GROUP BY 
    CASE 
        WHEN utilization_rate = 0 THEN '0% (Stopped)'
        WHEN utilization_rate < 50 THEN '1-49% (Low)'
        WHEN utilization_rate <80 THEN '50-79% (Medium)'
        ELSE '80-100% (High)'
    END
ORDER BY utilization_range;

-- Check inventory distribution
SELECT item_type, COUNT(*) AS count, 
       ROUND(SUM(current_quantity * unit_price), 2) AS total_value
FROM tp_manufacture.tp_inventory
GROUP BY item_type;

-- Sample BOM data
SELECT l.line_name, i.item_code, i.item_name, b.consumption_rate, b.unit
FROM tp_manufacture.tp_production_bom b
JOIN tp_manufacture.tp_production_lines l ON b.line_id = l.line_id
JOIN tp_manufacture.tp_inventory i ON b.inventory_id = i.inventory_id
WHERE ROWNUM <= 10;

SELECT 'Sample data loaded successfully!' AS status FROM DUAL;
