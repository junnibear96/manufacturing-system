package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.mapper.EmployeeRoleMapper;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

/**
 * 사원-권한 Repository (MyBatis 기반)
 */
@Repository
@RequiredArgsConstructor
public class JdbcEmployeeRoleRepository implements EmployeeRoleRepository {

    private final EmployeeRoleMapper employeeRoleMapper;

    @Override
    public List<String> findRolesByEmpId(String empId) {
        return employeeRoleMapper.findRolesByEmployeeId(empId);
    }

    @Override
    public void insert(String empId, String roleId, String grantedBy) {
        employeeRoleMapper.insert(empId, roleId, grantedBy);
    }

    @Override
    public void deleteAllByEmpId(String empId) {
        employeeRoleMapper.deleteByEmployeeId(empId);
    }
}
