-- ============================================================
-- Inventory Management Schema
-- ============================================================
-- Purpose: Track raw materials, components, and finished products
-- with transaction history for inventory movements
-- ============================================================

-- Main inventory items table
CREATE TABLE tp_inventory (
    inventory_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    item_code VARCHAR2(50) NOT NULL UNIQUE,
    item_name VARCHAR2(200) NOT NULL,
    item_type VARCHAR2(50) NOT NULL, -- 'RAW_MATERIAL', 'COMPONENT', 'FINISHED_PRODUCT'
    category VARCHAR2(100),
    unit VARCHAR2(20) NOT NULL, -- 'KG', 'EA', 'M', 'L', etc.
    current_quantity NUMBER(10,2) DEFAULT 0,
    min_quantity NUMBER(10,2) DEFAULT 0, -- Low stock threshold
    max_quantity NUMBER(10,2),
    unit_price NUMBER(12,2),
    warehouse_location VARCHAR2(100),
    line_id VARCHAR2(20), -- Optional: link to production line
    specifications CLOB,
    status VARCHAR2(20) DEFAULT 'ACTIVE', -- 'ACTIVE', 'DISCONTINUED'
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_inventory_line FOREIGN KEY (line_id) 
        REFERENCES production_lines(line_id)
);

-- Inventory transactions/movements table
CREATE TABLE tp_inventory_transactions (
    transaction_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    inventory_id NUMBER NOT NULL,
    transaction_type VARCHAR2(20) NOT NULL, -- 'IN', 'OUT', 'ADJUST'
    quantity NUMBER(10,2) NOT NULL,
    transaction_reason VARCHAR2(100), -- 'PURCHASE', 'PRODUCTION', 'SALE', 'DAMAGE', 'ADJUSTMENT'
    reference_no VARCHAR2(100), -- PO number, production plan ID, etc.
    notes VARCHAR2(500),
    performed_by VARCHAR2(100),
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_trans_inventory FOREIGN KEY (inventory_id) 
        REFERENCES tp_inventory(inventory_id)
);

-- Add constraints
COMMENT ON TABLE tp_inventory IS '재고 관리 테이블 - 원자재, 부품, 완제품 추적';
COMMENT ON TABLE tp_inventory_transactions IS '재고 거래 내역 테이블 - 입출고 및 조정 기록';

-- Performance indexes
CREATE INDEX idx_inventory_item_code ON tp_inventory(item_code);
CREATE INDEX idx_inventory_type ON tp_inventory(item_type);
CREATE INDEX idx_inventory_status ON tp_inventory(status);
CREATE INDEX idx_inventory_line ON tp_inventory(line_id);
CREATE INDEX idx_trans_inventory_id ON tp_inventory_transactions(inventory_id);
CREATE INDEX idx_trans_date ON tp_inventory_transactions(transaction_date);
CREATE INDEX idx_trans_type ON tp_inventory_transactions(transaction_type);

-- Sample data for testing
INSERT INTO tp_inventory (item_code, item_name, item_type, category, unit, current_quantity, min_quantity, max_quantity, unit_price, warehouse_location, status)
VALUES ('RM-STEEL-001', '스틸 플레이트 5mm', 'RAW_MATERIAL', '금속', 'KG', 1500.50, 500, 5000, 2500, 'A동-1구역', 'ACTIVE');

INSERT INTO tp_inventory (item_code, item_name, item_type, category, unit, current_quantity, min_quantity, max_quantity, unit_price, warehouse_location, status)
VALUES ('COMP-BOLT-M8', 'M8 볼트 (50mm)', 'COMPONENT', '체결부품', 'EA', 15000, 5000, 50000, 15, 'B동-3구역', 'ACTIVE');

INSERT INTO tp_inventory (item_code, item_name, item_type, category, unit, current_quantity, min_quantity, max_quantity, unit_price, warehouse_location, status)
VALUES ('FG-MOTOR-100', '전동 모터 100W', 'FINISHED_PRODUCT', '완제품', 'EA', 350, 100, 1000, 85000, 'C동-완제품', 'ACTIVE');

INSERT INTO tp_inventory (item_code, item_name, item_type, category, unit, current_quantity, min_quantity, max_quantity, unit_price, warehouse_location, status)
VALUES ('RM-PLASTIC-PP', '폴리프로필렌 수지', 'RAW_MATERIAL', '플라스틱', 'KG', 80, 200, 2000, 1800, 'A동-2구역', 'ACTIVE');

-- Sample transactions
INSERT INTO tp_inventory_transactions (inventory_id, transaction_type, quantity, transaction_reason, reference_no, performed_by, notes)
VALUES (1, 'IN', 500, 'PURCHASE', 'PO-2026-001', 'admin', '신규 입고');

INSERT INTO tp_inventory_transactions (inventory_id, transaction_type, quantity, transaction_reason, reference_no, performed_by, notes)
VALUES (2, 'OUT', 2000, 'PRODUCTION', 'PROD-2026-015', 'prod001', '생산 출고');

INSERT INTO tp_inventory_transactions (inventory_id, transaction_type, quantity, transaction_reason, reference_no, performed_by, notes)
VALUES (3, 'IN', 150, 'PRODUCTION', 'PROD-2026-015', 'prod001', '생산 완료');

INSERT INTO tp_inventory_transactions (inventory_id, transaction_type, quantity, transaction_reason, reference_no, performed_by, notes)
VALUES (4, 'ADJUST', -20, 'DAMAGE', 'DAMAGE-2026-003', 'admin', '불량품 처리');

COMMIT;
