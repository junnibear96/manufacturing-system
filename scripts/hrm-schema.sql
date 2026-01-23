-- ===================================
-- HRM (Human Resource Management) Schema
-- TP-INC Manufacturing Execution System
-- ===================================

-- 1. 부서 마스터 테이블
CREATE TABLE departments (
    department_id VARCHAR2(20) PRIMARY KEY,
    dept_name VARCHAR2(50) NOT NULL,
    dept_name_en VARCHAR2(50),
    division VARCHAR2(20) NOT NULL,  -- PRODUCTION/LOGISTICS/MANAGEMENT
    manager_emp_id VARCHAR2(20),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. 직급 마스터 테이블
CREATE TABLE positions (
    position_id VARCHAR2(20) PRIMARY KEY,
    position_name VARCHAR2(50) NOT NULL,
    position_name_en VARCHAR2(50),
    level INT NOT NULL,  -- 권한 레벨 (0~5)
    job_category VARCHAR2(20),  -- OFFICE/PRODUCTION
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. 사원 테이블 (확장 버전)
CREATE TABLE employees (
    emp_id VARCHAR2(20) PRIMARY KEY,
    emp_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(20),
    hire_date DATE DEFAULT SYSDATE,
    birth_date DATE,
    gender CHAR(1),  -- M/F/O
    
    -- 조직 정보
    department_id VARCHAR2(20) NOT NULL,
    position_id VARCHAR2(20) NOT NULL,
    job_type VARCHAR2(20) DEFAULT 'OFFICE',  -- OFFICE/PRODUCTION/LOGISTICS
    manager_emp_id VARCHAR2(20),
    
    -- 재직 상태
    status VARCHAR2(20) DEFAULT 'ACTIVE',  -- ACTIVE/LEAVE/RETIRED/TERMINATED/PROBATION
    leave_start_date DATE,
    leave_end_date DATE,
    termination_date DATE,
    termination_reason VARCHAR2(255),
    
    -- 생산 관련 (생산직만 사용)
    shift_type VARCHAR2(10),  -- DAY/SWING/NIGHT
    factory_id VARCHAR2(20),
    production_line_id VARCHAR2(20),
    skill_level INT DEFAULT 1,  -- 1(초급) ~ 5(고급)
    
    -- 인증 정보
    password VARCHAR2(255) NOT NULL,
    last_login_at TIMESTAMP,
    password_changed_at TIMESTAMP,
    is_locked CHAR(1) DEFAULT 'N',
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(department_id),
    CONSTRAINT fk_emp_pos FOREIGN KEY (position_id) REFERENCES positions(position_id),
    CONSTRAINT fk_emp_mgr FOREIGN KEY (manager_emp_id) REFERENCES employees(emp_id)
);

-- 4. 사원-권한 매핑 테이블
CREATE TABLE employee_roles (
    emp_id VARCHAR2(20),
    role_id VARCHAR2(50),
    granted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    granted_by VARCHAR2(20),
    PRIMARY KEY (emp_id, role_id),
    CONSTRAINT fk_emprole_emp FOREIGN KEY (emp_id) REFERENCES employees(emp_id) ON DELETE CASCADE
);

-- 5. 인덱스 생성 (성능 최적화)
CREATE INDEX idx_emp_dept ON employees(department_id);
CREATE INDEX idx_emp_status ON employees(status);
CREATE INDEX idx_emp_email ON employees(email);

-- ===================================
-- 샘플 데이터 삽입
-- ===================================

-- 부서 데이터
INSERT INTO departments VALUES ('IT001', 'IT팀', 'IT Team', 'MANAGEMENT', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('PROD001', '생산1팀', 'Production Team 1', 'PRODUCTION', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('PROD002', '생산2팀', 'Production Team 2', 'PRODUCTION', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('QC001', '품질관리팀', 'Quality Control', 'PRODUCTION', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('INV001', '재고관리팀', 'Inventory Management', 'LOGISTICS', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('SHIP001', '배송관리팀', 'Shipping Management', 'LOGISTICS', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('HR001', '인사팀', 'HR Team', 'MANAGEMENT', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 직급 데이터 (사무직)
INSERT INTO positions VALUES ('POS_EXE', '사장/이사', 'Executive', 5, 'OFFICE', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_GM', '부장', 'General Manager', 4, 'OFFICE', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_SM', '차장', 'Senior Manager', 3, 'OFFICE', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_MGR', '과장', 'Manager', 2, 'OFFICE', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_AM', '대리', 'Assistant Manager', 1, 'OFFICE', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_STAFF', '사원', 'Staff', 0, 'OFFICE', CURRENT_TIMESTAMP);

-- 직급 데이터 (생산직)
INSERT INTO positions VALUES ('POS_SUPERVISOR', '생산팀장', 'Production Supervisor', 3, 'PRODUCTION', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_FOREMAN', '반장', 'Foreman', 2, 'PRODUCTION', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_LEADER', '조장', 'Team Leader', 1, 'PRODUCTION', CURRENT_TIMESTAMP);
INSERT INTO positions VALUES ('POS_OPERATOR', '작업자', 'Operator', 0, 'PRODUCTION', CURRENT_TIMESTAMP);

-- 사원 데이터 (기존 로그인 계정 통합)
-- 주의: 비밀번호는 BCrypt 해시로 저장해야 함

-- admin (IT팀 부장 - 전체 관리자)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, password, status)
VALUES ('admin', '최관리', 'admin@tp-inc.com', '010-1234-5678', TO_DATE('2020-01-01', 'YYYY-MM-DD'), 
        'IT001', 'POS_GM', 'OFFICE', '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- prod001 (생산1팀 생산팀장)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('prod001', '박생산', 'prod001@tp-inc.com', '010-2345-6789', TO_DATE('2021-03-15', 'YYYY-MM-DD'),
        'PROD001', 'POS_SUPERVISOR', 'PRODUCTION', 'DAY', 5, '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- worker001 (생산1팀 작업자)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('worker001', '김작업', 'worker001@tp-inc.com', '010-3456-7890', TO_DATE('2023-06-20', 'YYYY-MM-DD'),
        'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- 추가 샘플 사원
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, password, status)
VALUES ('hr001', '이인사', 'hr001@tp-inc.com', '010-4567-8901', TO_DATE('2022-02-10', 'YYYY-MM-DD'),
        'HR001', 'POS_MGR', 'OFFICE', '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, department_id, position_id, job_type, password, status)
VALUES ('qc001', '정품질', 'qc001@tp-inc.com', '010-5678-9012', TO_DATE('2021-08-05', 'YYYY-MM-DD'),
        'QC001', 'POS_MGR', 'OFFICE', '$2a$10$YZq3VZ.jPQKmXaR1QZqJ0.KfXqZQxJZJxqJxJxJxJxJxJxJxJxJ', 'ACTIVE');

-- 추가 부서 (확장용)
INSERT INTO departments VALUES ('LOG001', '물류팀', 'Logistics Team', 'LOGISTICS', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);
INSERT INTO departments VALUES ('PROD003', '생산3팀', 'Production Team 3', 'PRODUCTION', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP);

-- 추가 직급
INSERT INTO positions VALUES ('POS_DIR', '이사', 'Director', 4, 'OFFICE', CURRENT_TIMESTAMP);

-- 확장된 샘플 직원 (비밀번호: password123)
-- ADMIN 역할 (3명)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('admin001', '최관리자', 'admin001@tp-inc.com', '010-1111-0001', TO_DATE('2018-01-15', 'YYYY-MM-DD'), TO_DATE('1985-03-20', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_GM', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('admin002', '박시스템', 'admin002@tp-inc.com', '010-1111-0002', TO_DATE('2019-06-10', 'YYYY-MM-DD'), TO_DATE('1987-07-15', 'YYYY-MM-DD'), 'F', 'IT001', 'POS_DIR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('admin003', '이보안', 'admin003@tp-inc.com', '010-1111-0003', TO_DATE('2020-03-01', 'YYYY-MM-DD'), TO_DATE('1990-11-08', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- MANAGER 역할 (5명)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr001', '김매니저', 'mgr001@tp-inc.com', '010-2222-0001', TO_DATE('2019-02-20', 'YYYY-MM-DD'), TO_DATE('1986-04-12', 'YYYY-MM-DD'), 'M', 'PROD001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr002', '정생산', 'mgr002@tp-inc.com', '010-2222-0002', TO_DATE('2020-05-15', 'YYYY-MM-DD'), TO_DATE('1988-09-25', 'YYYY-MM-DD'), 'F', 'PROD002', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr003', '강품질', 'mgr003@tp-inc.com', '010-2222-0003', TO_DATE('2018-09-10', 'YYYY-MM-DD'), TO_DATE('1984-12-30', 'YYYY-MM-DD'), 'M', 'QC001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr004', '오인사', 'mgr004@tp-inc.com', '010-2222-0004', TO_DATE('2019-11-05', 'YYYY-MM-DD'), TO_DATE('1987-02-18', 'YYYY-MM-DD'), 'F', 'HR001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('mgr005', '윤물류', 'mgr005@tp-inc.com', '010-2222-0005', TO_DATE('2021-01-20', 'YYYY-MM-DD'), TO_DATE('1989-06-22', 'YYYY-MM-DD'), 'M', 'LOG001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- OPERATOR 역할 (8명)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr001', '손작업자', 'opr001@tp-inc.com', '010-3333-0001', TO_DATE('2021-07-01', 'YYYY-MM-DD'), TO_DATE('1992-03-15', 'YYYY-MM-DD'), 'M', 'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 4, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr002', '임현장', 'opr002@tp-inc.com', '010-3333-0002', TO_DATE('2022-02-10', 'YYYY-MM-DD'), TO_DATE('1995-08-20', 'YYYY-MM-DD'), 'F', 'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr003', '한설비', 'opr003@tp-inc.com', '010-3333-0003', TO_DATE('2020-11-15', 'YYYY-MM-DD'), TO_DATE('1991-05-10', 'YYYY-MM-DD'), 'M', 'PROD002', 'POS_OPERATOR', 'PRODUCTION', 'NIGHT', 5, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr004', '서조립', 'opr004@tp-inc.com', '010-3333-0004', TO_DATE('2023-01-05', 'YYYY-MM-DD'), TO_DATE('1996-11-28', 'YYYY-MM-DD'), 'F', 'PROD002', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 2, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'PROBATION');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr005', '남검사', 'opr005@tp-inc.com', '010-3333-0005', TO_DATE('2021-09-20', 'YYYY-MM-DD'), TO_DATE('1993-01-12', 'YYYY-MM-DD'), 'M', 'QC001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 4, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr006', '차보관', 'opr006@tp-inc.com', '010-3333-0006', TO_DATE('2022-06-12', 'YYYY-MM-DD'), TO_DATE('1994-07-05', 'YYYY-MM-DD'), 'F', 'LOG001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr007', '최포장', 'opr007@tp-inc.com', '010-3333-0007', TO_DATE('2020-08-18', 'YYYY-MM-DD'), TO_DATE('1990-10-22', 'YYYY-MM-DD'), 'M', 'PROD003', 'POS_OPERATOR', 'PRODUCTION', 'NIGHT', 5, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status)
VALUES ('opr008', '배운송', 'opr008@tp-inc.com', '010-3333-0008', TO_DATE('2023-03-25', 'YYYY-MM-DD'), TO_DATE('1997-04-30', 'YYYY-MM-DD'), 'F', 'LOG001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 2, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- VIEWER 역할 (4명)
INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view001', '류조회', 'view001@tp-inc.com', '010-4444-0001', TO_DATE('2022-10-01', 'YYYY-MM-DD'), TO_DATE('1992-02-14', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view002', '전분석', 'view002@tp-inc.com', '010-4444-0002', TO_DATE('2023-04-15', 'YYYY-MM-DD'), TO_DATE('1995-09-08', 'YYYY-MM-DD'), 'F', 'QC001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view003', '신보고', 'view003@tp-inc.com', '010-4444-0003', TO_DATE('2023-08-20', 'YYYY-MM-DD'), TO_DATE('1998-12-01', 'YYYY-MM-DD'), 'M', 'HR001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'PROBATION');

INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status)
VALUES ('view004', '허모니터', 'view004@tp-inc.com', '010-4444-0004', TO_DATE('2022-12-10', 'YYYY-MM-DD'), TO_DATE('1993-06-18', 'YYYY-MM-DD'), 'F', 'IT001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE');

-- 사원-권한 매핑 (자동 매핑된 Role)
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

-- 확장 직원 권한
INSERT INTO employee_roles VALUES ('admin001', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin001', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

INSERT INTO employee_roles VALUES ('admin002', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin002', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

INSERT INTO employee_roles VALUES ('admin003', 'ROLE_ADMIN', CURRENT_TIMESTAMP, 'SYSTEM');
INSERT INTO employee_roles VALUES ('admin003', 'ROLE_USER', CURRENT_TIMESTAMP, 'SYSTEM');

INSERT INTO employee_roles VALUES ('mgr001', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr001', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('mgr002', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr002', 'ROLE_PRODUCTION', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr002', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('mgr003', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr003', 'ROLE_QUALITY', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr003', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('mgr004', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr004', 'ROLE_HR', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr004', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('mgr005', 'ROLE_MANAGER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('mgr005', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

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

INSERT INTO employee_roles VALUES ('view001', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('view001', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

INSERT INTO employee_roles VALUES ('view002', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'mgr003');
INSERT INTO employee_roles VALUES ('view002', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr003');

INSERT INTO employee_roles VALUES ('view003', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'mgr004');
INSERT INTO employee_roles VALUES ('view003', 'ROLE_USER', CURRENT_TIMESTAMP, 'mgr004');

INSERT INTO employee_roles VALUES ('view004', 'ROLE_VIEWER', CURRENT_TIMESTAMP, 'admin');
INSERT INTO employee_roles VALUES ('view004', 'ROLE_USER', CURRENT_TIMESTAMP, 'admin');

COMMIT;

-- 확인 쿼리
SELECT 'Departments' AS table_name, COUNT(*) AS count FROM departments
UNION ALL
SELECT 'Positions', COUNT(*) FROM positions
UNION ALL
SELECT 'Employees', COUNT(*) FROM employees
UNION ALL
SELECT 'Employee Roles', COUNT(*) FROM employee_roles;
