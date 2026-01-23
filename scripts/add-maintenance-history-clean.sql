CREATE SEQUENCE seq_maintenance_history_id START WITH 1 INCREMENT BY 1 NOCACHE NOCYCLE
/
CREATE TABLE tp_maintenance_history (
    history_id NUMBER PRIMARY KEY,
    equipment_id NUMBER NOT NULL,
    maintenance_date TIMESTAMP DEFAULT SYSTIMESTAMP,
    worker VARCHAR2(50),
    description VARCHAR2(500),
    created_at TIMESTAMP DEFAULT SYSTIMESTAMP,
    CONSTRAINT fk_history_equipment FOREIGN KEY (equipment_id) REFERENCES tp_equipment(equipment_id)
)
/
