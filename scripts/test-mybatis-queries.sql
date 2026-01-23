-- Test SQL for EmployeeMapper
-- Run this in SQL Developer to verify the query works

-- Test 1: Simple count
SELECT COUNT(*) FROM employees;

-- Test 2: Employee list query (from EmployeeMapper.xml)
SELECT e.emp_id, e.emp_name, e.email, e.phone,
       TO_CHAR(e.hire_date, 'YYYY-MM-DD') as hire_date,
       e.department_id, d.dept_name,
       e.position_id, p.position_name,
       e.status, e.job_type
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN positions p ON e.position_id = p.position_id
ORDER BY e.created_at DESC;

-- Test 3: Position list query
SELECT position_id, position_name, position_name_en, level,
       job_category, created_at
FROM positions
ORDER BY level DESC, position_id;

-- Test 4: Check if tables exist
SELECT table_name FROM user_tables WHERE table_name IN ('EMPLOYEES', 'DEPARTMENTS', 'POSITIONS', 'EMPLOYEE_ROLES');
