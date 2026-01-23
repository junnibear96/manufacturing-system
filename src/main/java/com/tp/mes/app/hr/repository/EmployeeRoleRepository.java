package com.tp.mes.app.hr.repository;

import java.util.List;

/**
 * 사원-권한 매핑 Repository
 */
public interface EmployeeRoleRepository {
    List<String> findRolesByEmpId(String empId);

    void insert(String empId, String roleId, String grantedBy);

    void deleteAllByEmpId(String empId);
}
