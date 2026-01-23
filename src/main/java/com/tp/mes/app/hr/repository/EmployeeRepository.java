package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.model.Employee;
import com.tp.mes.app.hr.model.EmployeeListItem;
import java.util.List;
import java.util.Optional;

public interface EmployeeRepository {
    List<EmployeeListItem> findAllWithDeptAndPosition();

    List<EmployeeListItem> findByDepartment(String departmentId);

    List<EmployeeListItem> findByStatus(String status);

    Optional<Employee> findById(String empId);

    long countByDepartment(String departmentId);

    void insert(Employee employee);

    void update(Employee employee);

    void updateStatus(String empId, String status, String terminationReason);
}
