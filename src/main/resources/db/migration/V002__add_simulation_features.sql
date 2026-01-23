-- ============================================================================
-- Manufacturing Simulation Feature - Database Migration
-- Created: 2026-01-18
-- Purpose: Add utilization rate tracking and BOM (Bill of Materials) support
-- ============================================================================

-- ============================================================================
-- 1. Add Utilization Rate to Production Lines
-- ============================================================================

-- Add utilization_rate column to tp_production_lines
ALTER TABLE tp_manufacture.tp_production_lines
ADD (
    utilization_rate NUMBER(5,2) DEFAULT 0.00 NOT NULL,
    utilization_updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Add check constraint to ensure valid utilization rate (0-100%)
ALTER TABLE tp_manufacture.tp_production_lines
ADD CONSTRAINT chk_utilization_rate 
    CHECK (utilization_rate >= 0 AND utilization_rate <= 100);

-- Add comments
COMMENT ON COLUMN tp_manufacture.tp_production_lines.utilization_rate 
    IS '가동률 (0.00 ~ 100.00) - 현재 라인 가동 비율';
    
COMMENT ON COLUMN tp_manufacture.tp_production_lines.utilization_updated_at 
    IS '가동률 최종 업데이트 시각';

-- Create index for frequently queried utilization rates
CREATE INDEX idx_production_lines_utilization 
    ON tp_manufacture.tp_production_lines(utilization_rate);

-- ============================================================================
-- 2. Create BOM (Bill of Materials) Table
-- ============================================================================

-- Drop table if exists (for re-running migration)
BEGIN
    EXECUTE IMMEDIATE 'DROP TABLE tp_manufacture.tp_production_bom CASCADE CONSTRAINTS';
EXCEPTION
    WHEN OTHERS THEN
        IF SQLCODE != -942 THEN
            RAISE;
        END IF;
END;
/

-- Create BOM table
CREATE TABLE tp_manufacture.tp_production_bom (
    bom_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    line_id VARCHAR2(50) NOT NULL,
    inventory_id NUMBER NOT NULL,
    consumption_rate NUMBER(10,4) NOT NULL,
    unit VARCHAR2(10) NOT NULL,
    notes VARCHAR2(500),
    is_active VARCHAR2(1) DEFAULT 'Y' NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT fk_bom_line 
        FOREIGN KEY (line_id) REFERENCES tp_manufacture.tp_production_lines(line_id),
    CONSTRAINT fk_bom_inventory 
        FOREIGN KEY (inventory_id) REFERENCES tp_manufacture.tp_inventory(inventory_id),
    CONSTRAINT chk_consumption_rate 
        CHECK (consumption_rate > 0),
    CONSTRAINT chk_is_active 
        CHECK (is_active IN ('Y', 'N'))
);

-- Add comments
COMMENT ON TABLE tp_manufacture.tp_production_bom 
    IS '생산 라인별 자재 소모 정보 (Bill of Materials) - 라인과 재고 간 소모 관계 정의';

COMMENT ON COLUMN tp_manufacture.tp_production_bom.bom_id 
    IS 'BOM ID (Primary Key)';
    
COMMENT ON COLUMN tp_manufacture.tp_production_bom.line_id 
    IS '생산 라인 ID (Foreign Key)';
    
COMMENT ON COLUMN tp_manufacture.tp_production_bom.inventory_id 
    IS '재고 아이템 ID (Foreign Key)';
    
COMMENT ON COLUMN tp_manufacture.tp_production_bom.consumption_rate 
    IS '시간당 소모량 (100% 가동 시 기준) - 예: 10.5 KG/hour';
    
COMMENT ON COLUMN tp_manufacture.tp_production_bom.unit 
    IS '단위 (KG, EA, L 등)';
    
COMMENT ON COLUMN tp_manufacture.tp_production_bom.notes 
    IS '비고';
    
COMMENT ON COLUMN tp_manufacture.tp_production_bom.is_active 
    IS '활성 여부 (Y/N)';

-- Create indexes for performance
CREATE INDEX idx_bom_line_id 
    ON tp_manufacture.tp_production_bom(line_id);
    
CREATE INDEX idx_bom_inventory_id 
    ON tp_manufacture.tp_production_bom(inventory_id);

CREATE INDEX idx_bom_active 
    ON tp_manufacture.tp_production_bom(is_active);

-- ============================================================================
-- 3. Update existing production lines with initial utilization rates
-- ============================================================================

-- Set random initial utilization rates for existing lines (for testing)
UPDATE tp_manufacture.tp_production_lines
SET utilization_rate = CASE 
    WHEN status = 'RUNNING' THEN ROUND(DBMS_RANDOM.VALUE(60, 95), 2)
    WHEN status = 'IDLE' THEN ROUND(DBMS_RANDOM.VALUE(10, 40), 2)
    WHEN status = 'STOPPED' THEN 0.00
    WHEN status = 'MAINTENANCE' THEN 0.00
    ELSE ROUND(DBMS_RANDOM.VALUE(20, 80), 2)
END,
utilization_updated_at = CURRENT_TIMESTAMP;

COMMIT;

-- ============================================================================
-- 4. Verification Queries
-- ============================================================================

-- Verify utilization_rate column added
SELECT column_name, data_type, nullable, data_default
FROM user_tab_columns
WHERE table_name = 'TP_PRODUCTION_LINES'
AND column_name IN ('UTILIZATION_RATE', 'UTILIZATION_UPDATED_AT');

-- Verify BOM table created
SELECT table_name, num_rows
FROM user_tables
WHERE table_name = 'TP_PRODUCTION_BOM';

-- Verify constraints
SELECT constraint_name, constraint_type, search_condition
FROM user_constraints
WHERE table_name IN ('TP_PRODUCTION_LINES', 'TP_PRODUCTION_BOM')
AND constraint_name LIKE '%UTILIZATION%' OR constraint_name LIKE '%BOM%';

-- Check current utilization rates
SELECT line_id, line_name, status, utilization_rate, utilization_updated_at
FROM tp_manufacture.tp_production_lines
ORDER BY utilization_rate DESC;

-- ============================================================================
-- Migration Complete
-- ============================================================================

SELECT 'Migration completed successfully!' AS status,
       CURRENT_TIMESTAMP AS completed_at
FROM DUAL;
