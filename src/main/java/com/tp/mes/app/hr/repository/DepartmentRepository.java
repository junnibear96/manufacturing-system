package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.model.Department;
import java.util.List;
import java.util.Optional;

public interface DepartmentRepository {
    List<Department> findAll();

    List<Department> findByDivision(String division);

    Optional<Department> findById(String departmentId);
}
