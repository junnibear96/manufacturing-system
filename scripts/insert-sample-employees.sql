-- 샘플 사원 데이터 삽입
-- admin (IT팀 부장 - 전체 관리자)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, password, status)
VALUES ('admin', '최관리', 'admin@gmail.com', '010-1234-5678', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 
        'IT001', 'POS_GM', 'OFFICE', '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- prod001 (생산1팀 생산팀장)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('prod001', '박생산', 'prod001@gmail.com', '010-2345-6789', TO_DATE('2021-03-15', 'YYYY-MM-DD'),
        'PROD001', 'POS_SUPERVISOR', 'PRODUCTION', 'DAY', 5, '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- worker001 (생산1팀 작업자)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('worker001', '김작업', 'worker001@gmail.com', '010-3456-7890', TO_DATE('2023-06-20', 'YYYY-MM-DD'),
        'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- hr001 (인사팀 과장)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, password, status)
VALUES ('hr001', '이인사', 'hr001@gmail.com', '010-4567-8901', TO_DATE('2022-02-10', 'YYYY-MM-DD'),
        'HR001', 'POS_MGR', 'OFFICE', '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- qc001 (품질관리팀 과장)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, password, status)
VALUES ('qc001', '정품질', 'qc001@gmail.com', '010-5678-9012', TO_DATE('2021-08-05', 'YYYY-MM-DD'),
        'QC001', 'POS_MGR', 'OFFICE', '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- 사원-권한 매핑
INSERT INTO employee_roles VALUES ('admin', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

INSERT INTO employee_roles VALUES ('prod001', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('prod001', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('prod001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('worker001', 'ROLE_WORKER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('worker001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('hr001', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('hr001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('qc001', 'ROLE_QUALITY', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('qc001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

COMMIT;
