package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.model.Employee;
import com.tp.mes.app.hr.model.EmployeeListItem;
import java.util.List;
import java.util.Optional;

public interface EmployeeRepository {
    List<EmployeeListItem> findAllWithDeptAndPosition();

    List<EmployeeListItem> findByDepartment(String departmentId);

    List<EmployeeListItem> findByStatus(String status);

    /**
     * 생산라인별 사원 조회
     */
    List<EmployeeListItem> findByProductionLineId(String lineId);

    Optional<Employee> findById(String empId);

    Optional<EmployeeListItem> findListItemById(String empId);

    long countByDepartment(String departmentId);

    void insert(Employee employee);

    void update(Employee employee);

    /**
     * 사원 상태 변경
     */
    void updateStatus(String empId, String status, String terminationReason);

    /**
     * 사원 생산라인 배정/해제
     */
    void updateProductionLine(String empId, String lineId);
}
