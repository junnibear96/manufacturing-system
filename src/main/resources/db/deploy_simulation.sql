-- Execute Migration V002 and Load Sample Data
-- Run this script in SQL*Plus or SQL Developer

-- Step 1: Run Migration
@@V002__add_simulation_features.sql

PROMPT Migration V002 completed.
PROMPT;

-- Step 2: Load Sample Data
@@comprehensive_seed_data.sql

PROMPT Sample data loaded.
PROMPT;

-- Step 3: Verify Data
PROMPT ============================================
PROMPT Verification Summary:
PROMPT ============================================

SELECT 'Total Factories' AS metric, TO_CHAR(COUNT(*)) AS value FROM tp_manufacture.tp_factories
UNION ALL
SELECT 'Total Plants', TO_CHAR(COUNT(*)) FROM tp_manufacture.tp_plants
UNION ALL
SELECT 'Total Production Lines', TO_CHAR(COUNT(*)) FROM tp_manufacture.tp_production_lines
UNION ALL
SELECT 'Total Inventory Items', TO_CHAR(COUNT(*)) FROM tp_manufacture.tp_inventory
UNION ALL
SELECT 'Total BOM Entries', TO_CHAR(COUNT(*)) FROM tp_manufacture.tp_production_bom;

PROMPT;
PROMPT ============================================
PROMPT Utilization Rate Distribution:
PROMPT ============================================

SELECT 
    CASE 
        WHEN utilization_rate = 0 THEN '0% (Stopped)'
        WHEN utilization_rate < 50 THEN '1-49% (Low)'
        WHEN utilization_rate < 80 THEN '50-79% (Medium)'
        ELSE '80-100% (High)'
    END AS range,
    COUNT(*) AS lines
FROM tp_manufacture.tp_production_lines
GROUP BY 
    CASE 
        WHEN utilization_rate = 0 THEN '0% (Stopped)'
        WHEN utilization_rate < 50 THEN '1-49% (Low)'
        WHEN utilization_rate < 80 THEN '50-79% (Medium)'
        ELSE '80-100% (High)'
    END
ORDER BY range;

PROMPT;
PROMPT Deployment completed successfully!
PROMPT You can now restart the application.
