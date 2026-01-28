-- ============================================================
-- Analytics & Inventory Tracking Schema
-- ============================================================

-- 1. Equipment Status History (For Utilization Calculation)
-- Tracks when equipment changes status (Running vs Stopped)
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_tables WHERE table_name = 'EQUIPMENT_STATUS_HISTORY';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE equipment_status_history (
            history_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            equipment_id NUMBER NOT NULL,
            status VARCHAR2(20) NOT NULL,
            start_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            end_time TIMESTAMP,
            duration_seconds NUMBER,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
        )';
    END IF;
END;
/

-- 2. Product BOM (For Material Usage)
-- Maps Product (Item Code) -> Material (Inventory ID)
-- Used to deduct materials based on "Good" production quantity.
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM user_tables WHERE table_name = 'PRODUCT_BOM';
    IF v_count = 0 THEN
        EXECUTE IMMEDIATE '
        CREATE TABLE product_bom (
            bom_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
            product_item_code VARCHAR2(60) NOT NULL,
            material_inventory_id NUMBER NOT NULL,
            quantity_required NUMBER(10,4) NOT NULL,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            CONSTRAINT fk_product_bom_inv FOREIGN KEY (material_inventory_id) REFERENCES tp_inventory(inventory_id)
        )';
    END IF;
END;
/

-- 3. Sample BOM Data
-- Example: FG-MOTOR-100 consumes 1.5 KG of RM-STEEL-001 (ID 1) and 4 EA of COMP-BOLT-M8 (ID 2)
BEGIN
    INSERT INTO product_bom (product_item_code, material_inventory_id, quantity_required)
    SELECT 'FG-MOTOR-100', 1, 1.5 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_item_code = 'FG-MOTOR-100' AND material_inventory_id = 1);

    INSERT INTO product_bom (product_item_code, material_inventory_id, quantity_required)
    SELECT 'FG-MOTOR-100', 2, 4 FROM DUAL
    WHERE NOT EXISTS (SELECT 1 FROM product_bom WHERE product_item_code = 'FG-MOTOR-100' AND material_inventory_id = 2);
    
    COMMIT;
END;
/
