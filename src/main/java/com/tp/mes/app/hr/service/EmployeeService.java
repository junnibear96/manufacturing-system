package com.tp.mes.app.hr.service;

import com.tp.mes.app.hr.model.Department;
import com.tp.mes.app.hr.model.Employee;
import com.tp.mes.app.hr.model.EmployeeListItem;
import com.tp.mes.app.hr.model.Position;
import com.tp.mes.app.hr.repository.DepartmentRepository;
import com.tp.mes.app.hr.repository.EmployeeRepository;
import com.tp.mes.app.hr.repository.EmployeeRoleRepository;
import com.tp.mes.app.hr.repository.PositionRepository;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 인사관리 서비스
 * TEMPORARILY DISABLED - HRM system being reimplemented
 */
@Service
public class EmployeeService {

    private static final Logger log = LoggerFactory.getLogger(EmployeeService.class);

    private final EmployeeRepository employeeRepository;
    private final EmployeeRoleRepository employeeRoleRepository;
    private final DepartmentRepository departmentRepository;
    private final PositionRepository positionRepository;
    private final RoleAutoAssignService roleAutoAssignService;

    public EmployeeService(
            EmployeeRepository employeeRepository,
            EmployeeRoleRepository employeeRoleRepository,
            DepartmentRepository departmentRepository,
            PositionRepository positionRepository,
            RoleAutoAssignService roleAutoAssignService) {
        this.employeeRepository = employeeRepository;
        this.employeeRoleRepository = employeeRoleRepository;
        this.departmentRepository = departmentRepository;
        this.positionRepository = positionRepository;
        this.roleAutoAssignService = roleAutoAssignService;
    }

    // ===== 조회 =====

    public List<EmployeeListItem> getAllEmployees() {
        return employeeRepository.findAllWithDeptAndPosition();
    }

    public List<EmployeeListItem> getEmployeesByDepartment(String departmentId) {
        return employeeRepository.findByDepartment(departmentId);
    }

    public List<EmployeeListItem> getEmployeesByStatus(String status) {
        return employeeRepository.findByStatus(status);
    }

    public Optional<Employee> getEmployeeById(String empId) {
        return employeeRepository.findById(empId);
    }

    public List<Department> getAllDepartments() {
        return departmentRepository.findAll();
    }

    public List<Position> getAllPositions() {
        return positionRepository.findAll();
    }

    public List<Position> getPositionsByJobCategory(String jobCategory) {
        return positionRepository.findByJobCategory(jobCategory);
    }

    public List<String> getEmployeeRoles(String empId) {
        return employeeRoleRepository.findRolesByEmpId(empId);
    }

    // ===== 등록 =====

    @Transactional
    public void createEmployee(Employee employee) {
        log.info("Creating new employee: {}", employee.getEmpId());

        // 1. 사원 등록
        employeeRepository.insert(employee);

        // 2. Role 자동 매핑
        List<String> roles = roleAutoAssignService.assignRoles(
                employee.getDepartmentId(),
                employee.getPositionId());

        log.info("Auto-assigned roles for {}: {}", employee.getEmpId(), roles);

        // 3. employee_roles 테이블에 INSERT
        for (String role : roles) {
            employeeRoleRepository.insert(employee.getEmpId(), role, "SYSTEM");
        }
    }

    // ===== 수정 =====

    @Transactional
    public void updateEmployee(Employee employee) {
        log.info("Updating employee: {}", employee.getEmpId());

        // 1. 사원 정보 수정
        employeeRepository.update(employee);

        // 2. 부서/직급이 변경되었으면 Role 재계산
        // (실제로는 변경 감지가 필요하지만, 여기서는 항상 재계산)
        employeeRoleRepository.deleteAllByEmpId(employee.getEmpId());

        List<String> roles = roleAutoAssignService.assignRoles(
                employee.getDepartmentId(),
                employee.getPositionId());

        log.info("Re-assigned roles for {}: {}", employee.getEmpId(), roles);

        for (String role : roles) {
            employeeRoleRepository.insert(employee.getEmpId(), role, "SYSTEM");
        }
    }

    // ===== 재직 상태 변경 =====

    @Transactional
    public void changeEmployeeStatus(String empId, String newStatus, String reason) {
        log.info("Changing status of {} to {}", empId, newStatus);
        employeeRepository.updateStatus(empId, newStatus, reason);

        // 퇴사/휴직 시 권한 제거 (선택적)
        if ("RETIRED".equals(newStatus) || "TERMINATED".equals(newStatus)) {
            log.info("Removing all roles for retired/terminated employee: {}", empId);
            employeeRoleRepository.deleteAllByEmpId(empId);
        }
    }

    // ===== 통계 =====

    public long countActiveEmployeesByDepartment(String departmentId) {
        return employeeRepository.countByDepartment(departmentId);
    }
}

