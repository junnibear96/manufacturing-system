-- HRM Seed Data

-- 1. Departments
INSERT INTO departments (department_id, dept_name, location) VALUES ('DEP001', 'Management', 'HQ-101');
INSERT INTO departments (department_id, dept_name, location) VALUES ('DEP002', 'HR & Admin', 'HQ-102');
INSERT INTO departments (department_id, dept_name, location) VALUES ('DEP003', 'Production 1', 'FAC-A');
INSERT INTO departments (department_id, dept_name, location) VALUES ('DEP004', 'Production 2', 'FAC-A');
INSERT INTO departments (department_id, dept_name, location) VALUES ('DEP005', 'Quality Control', 'FAC-B');

-- 2. Positions
-- Office
INSERT INTO positions (position_id, position_name, job_category, sort_order) VALUES ('POS_CEO', 'CEO', 'OFFICE', 1);
INSERT INTO positions (position_id, position_name, job_category, sort_order) VALUES ('POS_MGR', 'Manager', 'OFFICE', 2);
INSERT INTO positions (position_id, position_name, job_category, sort_order) VALUES ('POS_STAFF', 'Staff', 'OFFICE', 3);
-- Production
INSERT INTO positions (position_id, position_name, job_category, sort_order) VALUES ('POS_PLANT_HEAD', 'Plant Head', 'PRODUCTION', 10);
INSERT INTO positions (position_id, position_name, job_category, sort_order) VALUES ('POS_SV', 'Supervisor', 'PRODUCTION', 11);
INSERT INTO positions (position_id, position_name, job_category, sort_order) VALUES ('POS_OP', 'Operator', 'PRODUCTION', 12);

-- 3. Employees (Admin / Sample)
-- Password is '1234' (BCrypt: $2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu)
INSERT INTO employees (
  emp_id, emp_name, email, hire_date, 
  department_id, position_id, job_type, status, 
  password, skill_level, created_at
) VALUES (
  'admin', 'System Admin', 'admin@tp.com', SYSDATE, 
  'DEP001', 'POS_MGR', 'OFFICE', 'ACTIVE',
  '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 5, SYSDATE
);

-- Assign Admin Role
INSERT INTO employee_roles (emp_id, role_id, granted_by) VALUES ('admin', 'ROLE_ADMIN', 'SYSTEM');
INSERT INTO employee_roles (emp_id, role_id, granted_by) VALUES ('admin', 'ROLE_HR', 'SYSTEM');

commit;
