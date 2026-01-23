package com.tp.mes.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class DataLoaderController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/load-employees")
    public Map<String, Object> loadEmployees() {
        try {
            int employeeCount = 0;
            int roleCount = 0;
            int deptCount = 0;

            // Insert missing departments
            try {
                jdbcTemplate.execute(
                        "INSERT INTO departments VALUES ('LOG001', '물류팀', 'Logistics Team', 'LOGISTICS', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
                jdbcTemplate.execute(
                        "INSERT INTO departments VALUES ('PROD003', '생산3팀', 'Production Team 3', 'PRODUCTION', NULL, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP)");
                deptCount += 2;
            } catch (Exception e) {
                // Ignore if already exists
            }

            // Insert missing position
            try {
                jdbcTemplate.execute(
                        "INSERT INTO positions VALUES ('POS_DIR', '이사', 'Director', 4, 'OFFICE', CURRENT_TIMESTAMP)");
            } catch (Exception e) {
                // Ignore if already exists
            }

            // ADMIN users (3)
            String[] adminEmployees = {
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('admin001', '최관리자', 'admin001@tp-inc.com', '010-1111-0001', TO_DATE('2018-01-15', 'YYYY-MM-DD'), TO_DATE('1985-03-20', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_GM', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('admin002', '박시스템', 'admin002@tp-inc.com', '010-1111-0002', TO_DATE('2019-06-10', 'YYYY-MM-DD'), TO_DATE('1987-07-15', 'YYYY-MM-DD'), 'F', 'IT001', 'POS_DIR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('admin003', '이보안', 'admin003@tp-inc.com', '010-1111-0003', TO_DATE('2020-03-01', 'YYYY-MM-DD'), TO_DATE('1990-11-08', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')"
            };

            // MANAGER users (5)
            String[] managerEmployees = {
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('mgr001', '김매니저', 'mgr001@tp-inc.com', '010-2222-0001', TO_DATE('2019-02-20', 'YYYY-MM-DD'), TO_DATE('1986-04-12', 'YYYY-MM-DD'), 'M', 'PROD001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('mgr002', '정생산', 'mgr002@tp-inc.com', '010-2222-0002', TO_DATE('2020-05-15', 'YYYY-MM-DD'), TO_DATE('1988-09-25', 'YYYY-MM-DD'), 'F', 'PROD002', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('mgr003', '강품질', 'mgr003@tp-inc.com', '010-2222-0003', TO_DATE('2018-09-10', 'YYYY-MM-DD'), TO_DATE('1984-12-30', 'YYYY-MM-DD'), 'M', 'QC001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('mgr004', '오인사', 'mgr004@tp-inc.com', '010-2222-0004', TO_DATE('2019-11-05', 'YYYY-MM-DD'), TO_DATE('1987-02-18', 'YYYY-MM-DD'), 'F', 'HR001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('mgr005', '윤물류', 'mgr005@tp-inc.com', '010-2222-0005', TO_DATE('2021-01-20', 'YYYY-MM-DD'), TO_DATE('1989-06-22', 'YYYY-MM-DD'), 'M', 'LOG001', 'POS_MGR', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')"
            };

            // OPERATOR users (8)
            String[] operatorEmployees = {
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr001', '손작업자', 'opr001@tp-inc.com', '010-3333-0001', TO_DATE('2021-07-01', 'YYYY-MM-DD'), TO_DATE('1992-03-15', 'YYYY-MM-DD'), 'M', 'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 4, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr002', '임현장', 'opr002@tp-inc.com', '010-3333-0002', TO_DATE('2022-02-10', 'YYYY-MM-DD'), TO_DATE('1995-08-20', 'YYYY-MM-DD'), 'F', 'PROD001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr003', '한설비', 'opr003@tp-inc.com', '010-3333-0003', TO_DATE('2020-11-15', 'YYYY-MM-DD'), TO_DATE('1991-05-10', 'YYYY-MM-DD'), 'M', 'PROD002', 'POS_OPERATOR', 'PRODUCTION', 'NIGHT', 5, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr004', '서조립', 'opr004@tp-inc.com', '010-3333-0004', TO_DATE('2023-01-05', 'YYYY-MM-DD'), TO_DATE('1996-11-28', 'YYYY-MM-DD'), 'F', 'PROD002', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 2, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'PROBATION')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr005', '남검사', 'opr005@tp-inc.com', '010-3333-0005', TO_DATE('2021-09-20', 'YYYY-MM-DD'), TO_DATE('1993-01-12', 'YYYY-MM-DD'), 'M', 'QC001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 4, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr006', '차보관', 'opr006@tp-inc.com', '010-3333-0006', TO_DATE('2022-06-12', 'YYYY-MM-DD'), TO_DATE('1994-07-05', 'YYYY-MM-DD'), 'F', 'LOG001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 3, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr007', '최포장', 'opr007@tp-inc.com', '010-3333-0007', TO_DATE('2020-08-18', 'YYYY-MM-DD'), TO_DATE('1990-10-22', 'YYYY-MM-DD'), 'M', 'PROD003', 'POS_OPERATOR', 'PRODUCTION', 'NIGHT', 5, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, shift_type, skill_level, password, status) VALUES ('opr008', '배운송', 'opr008@tp-inc.com', '010-3333-0008', TO_DATE('2023-03-25', 'YYYY-MM-DD'), TO_DATE('1997-04-30', 'YYYY-MM-DD'), 'F', 'LOG001', 'POS_OPERATOR', 'PRODUCTION', 'DAY', 2, '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')"
            };

            // VIEWER users (4)
            String[] viewerEmployees = {
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('view001', '류조회', 'view001@tp-inc.com', '010-4444-0001', TO_DATE('2022-10-01', 'YYYY-MM-DD'), TO_DATE('1992-02-14', 'YYYY-MM-DD'), 'M', 'IT001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('view002', '전분석', 'view002@tp-inc.com', '010-4444-0002', TO_DATE('2023-04-15', 'YYYY-MM-DD'), TO_DATE('1995-09-08', 'YYYY-MM-DD'), 'F', 'QC001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('view003', '신보고', 'view003@tp-inc.com', '010-4444-0003', TO_DATE('2023-08-20', 'YYYY-MM-DD'), TO_DATE('1998-12-01', 'YYYY-MM-DD'), 'M', 'HR001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'PROBATION')",
                    "INSERT INTO employees (emp_id, emp_name, email, phone, hire_date, birth_date, gender, department_id, position_id, job_type, password, status) VALUES ('view004', '허모니터', 'view004@tp-inc.com', '010-4444-0004', TO_DATE('2022-12-10', 'YYYY-MM-DD'), TO_DATE('1993-06-18', 'YYYY-MM-DD'), 'F', 'IT001', 'POS_STAFF', 'OFFICE', '$2a$10$5PwHqG/TomigDFdLktj5ueuCXtwKDM031eRB53MPVRMQ43bTP8Tyu', 'ACTIVE')"
            };

            // Insert all employees
            for (String sql : adminEmployees) {
                try {
                    jdbcTemplate.execute(sql);
                    employeeCount++;
                } catch (Exception e) {
                    /* skip duplicates */ }
            }
            for (String sql : managerEmployees) {
                try {
                    jdbcTemplate.execute(sql);
                    employeeCount++;
                } catch (Exception e) {
                    /* skip duplicates */ }
            }
            for (String sql : operatorEmployees) {
                try {
                    jdbcTemplate.execute(sql);
                    employeeCount++;
                } catch (Exception e) {
                    /* skip duplicates */ }
            }
            for (String sql : viewerEmployees) {
                try {
                    jdbcTemplate.execute(sql);
                    employeeCount++;
                } catch (Exception e) {
                    /* skip duplicates */ }
            }

            // Insert roles
            String[][] roleAssignments = {
                    // Admin roles
                    { "admin001", "ROLE_ADMIN" }, { "admin001", "ROLE_USER" },
                    { "admin002", "ROLE_ADMIN" }, { "admin002", "ROLE_USER" },
                    { "admin003", "ROLE_ADMIN" }, { "admin003", "ROLE_USER" },
                    // Manager roles
                    { "mgr001", "ROLE_MANAGER" }, { "mgr001", "ROLE_PRODUCTION" }, { "mgr001", "ROLE_USER" },
                    { "mgr002", "ROLE_MANAGER" }, { "mgr002", "ROLE_PRODUCTION" }, { "mgr002", "ROLE_USER" },
                    { "mgr003", "ROLE_MANAGER" }, { "mgr003", "ROLE_QUALITY" }, { "mgr003", "ROLE_USER" },
                    { "mgr004", "ROLE_MANAGER" }, { "mgr004", "ROLE_HR" }, { "mgr004", "ROLE_USER" },
                    { "mgr005", "ROLE_MANAGER" }, { "mgr005", "ROLE_USER" },
                    // Operator roles
                    { "opr001", "ROLE_OPERATOR" }, { "opr001", "ROLE_PRODUCTION" }, { "opr001", "ROLE_USER" },
                    { "opr002", "ROLE_OPERATOR" }, { "opr002", "ROLE_PRODUCTION" }, { "opr002", "ROLE_USER" },
                    { "opr003", "ROLE_OPERATOR" }, { "opr003", "ROLE_PRODUCTION" }, { "opr003", "ROLE_USER" },
                    { "opr004", "ROLE_OPERATOR" }, { "opr004", "ROLE_PRODUCTION" }, { "opr004", "ROLE_USER" },
                    { "opr005", "ROLE_OPERATOR" }, { "opr005", "ROLE_QUALITY" }, { "opr005", "ROLE_USER" },
                    { "opr006", "ROLE_OPERATOR" }, { "opr006", "ROLE_USER" },
                    { "opr007", "ROLE_OPERATOR" }, { "opr007", "ROLE_PRODUCTION" }, { "opr007", "ROLE_USER" },
                    { "opr008", "ROLE_OPERATOR" }, { "opr008", "ROLE_USER" },
                    // Viewer roles
                    { "view001", "ROLE_VIEWER" }, { "view001", "ROLE_USER" },
                    { "view002", "ROLE_VIEWER" }, { "view002", "ROLE_USER" },
                    { "view003", "ROLE_VIEWER" }, { "view003", "ROLE_USER" },
                    { "view004", "ROLE_VIEWER" }, { "view004", "ROLE_USER" }
            };

            for (String[] role : roleAssignments) {
                try {
                    jdbcTemplate.execute(
                            "INSERT INTO employee_roles VALUES ('" + role[0] + "', '" + role[1]
                                    + "', CURRENT_TIMESTAMP, 'admin')");
                    roleCount++;
                } catch (Exception e) {
                    // Skip duplicates
                }
            }

            Map<String, Object> result = new HashMap<>();
            result.put("success", true);
            result.put("departments", deptCount);
            result.put("employees", employeeCount);
            result.put("roles", roleCount);
            result.put("message",
                    "Successfully loaded " + employeeCount + " employees with " + roleCount + " role assignments");

            return result;
        } catch (Exception e) {
            Map<String, Object> error = new HashMap<>();
            error.put("success", false);
            error.put("error", e.getMessage());
            e.printStackTrace();
            return error;
        }
    }
}
