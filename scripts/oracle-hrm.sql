-- HRM Module Tables
-- Run after oracle-init.sql

-- ===== Departments =====
create table departments (
  department_id varchar2(50) not null,
  dept_name varchar2(100) not null,
  location varchar2(100),
  cnt_employees number default 0,
  created_at timestamp default systimestamp not null,
  constraint pk_departments primary key (department_id)
);

-- ===== Positions (Job Titles) =====
create table positions (
  position_id varchar2(50) not null,
  position_name varchar2(100) not null,
  job_category varchar2(50), -- OFFICE, PRODUCTION, LOGISTICS
  base_salary number,
  sort_order number,
  constraint pk_positions primary key (position_id)
);

-- ===== Employees =====
create table employees (
  emp_id varchar2(50) not null,
  emp_name varchar2(100) not null,
  email varchar2(100),
  phone varchar2(50),
  hire_date date not null,
  birth_date date,
  gender char(1), -- M, F
  
  -- Organization
  department_id varchar2(50),
  position_id varchar2(50),
  job_type varchar2(50), -- OFFICE, PRODUCTION
  manager_emp_id varchar2(50),
  
  -- Status
  status varchar2(20) default 'ACTIVE' not null, -- ACTIVE, OFF, RETIRED
  leave_start_date date,
  leave_end_date date,
  termination_date date,
  termination_reason varchar2(200),
  
  -- Production
  shift_type varchar2(20), -- DAY, NIGHT
  factory_id varchar2(50),
  production_line_id varchar2(50),
  skill_level number(1),
  
  -- Auth (Simple implementation for demo)
  password varchar2(200),
  
  -- Meta
  created_at timestamp default systimestamp not null,
  updated_at timestamp,
  
  constraint pk_employees primary key (emp_id),
  constraint fk_employees_dept foreign key (department_id) references departments(department_id),
  constraint fk_employees_pos foreign key (position_id) references positions(position_id)
);

-- ===== Employee Roles (Mapping) =====
-- Maps employee to simplified role strings (e.g. ROLE_USER, ROLE_ADMIN)
create table employee_roles (
  emp_id varchar2(50) not null,
  role_id varchar2(50) not null, -- using role_code actually
  granted_at timestamp default systimestamp,
  granted_by varchar2(50),
  
  constraint pk_employee_roles primary key (emp_id, role_id),
  constraint fk_employee_roles_emp foreign key (emp_id) references employees(emp_id)
);
