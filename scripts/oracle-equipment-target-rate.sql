-- Add Target Utilization Rate to Equipment Table
-- Run this after oracle-init.sql

-- Add target_utilization_rate column to equipment table
ALTER TABLE equipment ADD (
    target_utilization_rate NUMBER(5, 2) DEFAULT 85.0,
    CONSTRAINT ck_equipment_target_util CHECK (target_utilization_rate BETWEEN 0 AND 100)
);

-- Update existing records with default target rate
UPDATE equipment SET target_utilization_rate = 85.0 WHERE target_utilization_rate IS NULL;

COMMIT;
