-- Create sequence for history ID
CREATE SEQUENCE seq_maintenance_history_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE;
/

-- Create Maintenance History Table
CREATE TABLE tp_maintenance_history (
    history_id NUMBER PRIMARY KEY,
    equipment_id NUMBER NOT NULL,
    maintenance_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    worker VARCHAR2(50),
    description VARCHAR2(500),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_history_equipment FOREIGN KEY (equipment_id) REFERENCES tp_equipment(equipment_id)
);
/

-- Add comments
COMMENT ON TABLE tp_maintenance_history IS '장비 점검 이력';
COMMENT ON COLUMN tp_maintenance_history.history_id IS '이력 ID';
COMMENT ON COLUMN tp_maintenance_history.equipment_id IS '장비 ID';
COMMENT ON COLUMN tp_maintenance_history.maintenance_date IS '점검 일시';
COMMENT ON COLUMN tp_maintenance_history.worker IS '작업자';
COMMENT ON COLUMN tp_maintenance_history.description IS '점검 내용';
/
