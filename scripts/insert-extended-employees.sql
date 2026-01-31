-- 확장된 샘플 직원 데이터
-- 비밀번호: 모든 계정 "password123" (BCrypt 해시)


-- ========================================
-- ADMIN 역할 (3명)
-- ========================================
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('admin001', '최관리자', 'admin001@gmail.com', '010-1111-0001', TO_DATE('2018-01-15', 'YYYY-MM-DD'), TO_DATE('1985-03-20', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_GM', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('admin002', '박시스템', 'admin002@gmail.com', '010-1111-0002', TO_DATE('2019-06-10', 'YYYY-MM-DD'), TO_DATE('1987-07-15', 'YYYY-MM-DD'), 'F', 'IT001', 'POS_DIR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('admin003', '이보안', 'admin003@gmail.com', '010-1111-0003', TO_DATE('2020-03-01', 'YYYY-MM-DD'), TO_DATE('1990-11-08', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- ========================================
-- MANAGER 역할 (5명)
-- ========================================
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr001', '김매니저', 'mgr001@gmail.com', '010-2222-0001', TO_DATE('2019-02-20', 'YYYY-MM-DD'), TO_DATE('1986-04-12', 'YYYY-MM-DD'), 'M', 'PROD001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr002', '정생산', 'mgr002@gmail.com', '010-2222-0002', TO_DATE('2020-05-15', 'YYYY-MM-DD'), TO_DATE('1988-09-25', 'YYYY-MM-DD'), 'F', 'PROD002', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr003', '강품질', 'mgr003@gmail.com', '010-2222-0003', TO_DATE('2018-09-10', 'YYYY-MM-DD'), TO_DATE('1984-12-30', 'YYYY-MM-DD'), 'M', 'QC001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr004', '오인사', 'mgr004@gmail.com', '010-2222-0004', TO_DATE('2019-11-05', 'YYYY-MM-DD'), TO_DATE('1987-02-18', 'YYYY-MM-DD'), 'F', 'HR001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr005', '윤물류', 'mgr005@gmail.com', '010-2222-0005', TO_DATE('2021-01-20', 'YYYY-MM-DD'), TO_DATE('1989-06-22', 'YYYY-MM-DD'), 'M', 'LOG001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- ========================================
-- OPERATOR 역할 (8명 - 생산 현장 근무자)
-- ========================================
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr001', '손작업자', 'opr001@gmail.com', '010-3333-0001', TO_DATE('2021-07-01', 'YYYY-MM-DD'), TO_DATE('1992-03-15', 'YYYY-MM-DD'), 'M', 'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 4, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr002', '임현장', 'opr002@gmail.com', '010-3333-0002', TO_DATE('2022-02-10', 'YYYY-MM-DD'), TO_DATE('1995-08-20', 'YYYY-MM-DD'), 'F', 'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr003', '한설비', 'opr003@gmail.com', '010-3333-0003', TO_DATE('2020-11-15', 'YYYY-MM-DD'), TO_DATE('1991-05-10', 'YYYY-MM-DD'), 'M', 'PROD002', 'POS_OPERATOR', 'PRODUCTION', 'NIGHT', 5, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr004', '서조립', 'opr004@gmail.com', '010-3333-0004', TO_DATE('2023-01-05', 'YYYY-MM-DD'), TO_DATE('1996-11-28', 'YYYY-MM-DD'), 'F', 'PROD002', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 2, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'PROBATION');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr005', '남검사', 'opr005@gmail.com', '010-3333-0005', TO_DATE('2021-09-20', 'YYYY-MM-DD'), TO_DATE('1993-01-12', 'YYYY-MM-DD'), 'M', 'QC001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 4, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr006', '차보관', 'opr006@gmail.com', '010-3333-0006', TO_DATE('2022-06-12', 'YYYY-MM-DD'), TO_DATE('1994-07-05', 'YYYY-MM-DD'), 'F', 'LOG001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr007', '최포장', 'opr007@gmail.com', '010-3333-0007', TO_DATE('2020-08-18', 'YYYY-MM-DD'), TO_DATE('1990-10-22', 'YYYY-MM-DD'), 'M', 'PROD003', 'POS_OPERATOR', 'PRODUCTION', 'NIGHT', 5, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr008', '배운송', 'opr008@gmail.com', '010-3333-0008', TO_DATE('2023-03-25', 'YYYY-MM-DD'), TO_DATE('1997-04-30', 'YYYY-MM-DD'), 'F', 'LOG001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 2, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- ========================================
-- VIEWER 역할 (4명 - 조회 권한만)
-- ========================================
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view001', '류조회', 'view001@gmail.com', '010-4444-0001', TO_DATE('2022-10-01', 'YYYY-MM-DD'), TO_DATE('1992-02-14', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view002', '전분석', 'view002@gmail.com', '010-4444-0002', TO_DATE('2023-04-15', 'YYYY-MM-DD'), TO_DATE('1995-09-08', 'YYYY-MM-DD'), 'F', 'QC001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view003', '신보고', 'view003@gmail.com', '010-4444-0003', TO_DATE('2023-08-20', 'YYYY-MM-DD'), TO_DATE('1998-12-01', 'YYYY-MM-DD'), 'M', 'HR001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'PROBATION');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view004', '허모니터', 'view004@gmail.com', '010-4444-0004', TO_DATE('2022-12-10', 'YYYY-MM-DD'), TO_DATE('1993-06-18', 'YYYY-MM-DD'), 'F', 'IT001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- ========================================
-- 역할 매핑 (employee_roles)
-- ========================================

-- ADMIN 역할 매핑 (전체 권한)
INSERT INTO employee_roles VALUES ('admin001', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin001', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

INSERT INTO employee_roles VALUES ('admin002', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin002', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

INSERT INTO employee_roles VALUES ('admin003', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin003', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

-- MANAGER 역할 매핑
INSERT INTO employee_roles VALUES ('mgr001', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr001', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin001');

INSERT INTO employee_roles VALUES ('mgr002', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr002', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr002', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin001');

INSERT INTO employee_roles VALUES ('mgr003', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr003', 'ROLE_QUALITY', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr003', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin001');

INSERT INTO employee_roles VALUES ('mgr004', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr004', 'ROLE_HR', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr004', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin001');

INSERT INTO employee_roles VALUES ('mgr005', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('mgr005', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin001');

-- OPERATOR 역할 매핑 (작업자)
INSERT INTO employee_roles VALUES ('opr001', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr001');
INSERT INTO employee_roles VALUES ('opr001', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'mgr001');
INSERT INTO employee_roles VALUES ('opr001', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr001');

INSERT INTO employee_roles VALUES ('opr002', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr001');
INSERT INTO employee_roles VALUES ('opr002', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'mgr001');
INSERT INTO employee_roles VALUES ('opr002', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr001');

INSERT INTO employee_roles VALUES ('opr003', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr002');
INSERT INTO employee_roles VALUES ('opr003', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'mgr002');
INSERT INTO employee_roles VALUES ('opr003', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr002');

INSERT INTO employee_roles VALUES ('opr004', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr002');
INSERT INTO employee_roles VALUES ('opr004', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'mgr002');
INSERT INTO employee_roles VALUES ('opr004', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr002');

INSERT INTO employee_roles VALUES ('opr005', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr003');
INSERT INTO employee_roles VALUES ('opr005', 'ROLE_QUALITY', CURRENT_TIMESTAMP, 'mgr003');
INSERT INTO employee_roles VALUES ('opr005', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr003');

INSERT INTO employee_roles VALUES ('opr006', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr005');
INSERT INTO employee_roles VALUES ('opr006', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr005');

INSERT INTO employee_roles VALUES ('opr007', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr002');
INSERT INTO employee_roles VALUES ('opr007', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'mgr002');
INSERT INTO employee_roles VALUES ('opr007', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr002');

INSERT INTO employee_roles VALUES ('opr008', 'ROLE_OPERATOR', CURRENT_TIMESTAMP, 'mgr005');
INSERT INTO employee_roles VALUES ('opr008', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr005');

-- VIEWER 역할 매핑 (조회 전용)
INSERT INTO employee_roles VALUES ('view001', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'admin001');
INSERT INTO employee_roles VALUES ('view001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin001');

INSERT INTO employee_roles VALUES ('view002', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'mgr003');
INSERT INTO employee_roles VALUES ('view002', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr003');

INSERT INTO employee_roles VALUES ('view003', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'mgr004');
INSERT INTO employee_roles VALUES ('view003', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr004');

INSERT INTO employee_roles VALUES ('view004', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'admin002');
INSERT INTO employee_roles VALUES ('view004', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin002');

COMMIT;
