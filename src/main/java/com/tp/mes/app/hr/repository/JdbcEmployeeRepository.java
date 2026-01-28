package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.mapper.EmployeeMapper;
import com.tp.mes.app.hr.model.Employee;
import com.tp.mes.app.hr.model.EmployeeListItem;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * 사원 Repository (MyBatis 기반)
 */
@Repository
public class JdbcEmployeeRepository implements EmployeeRepository {

    private static final Logger log = LoggerFactory.getLogger(JdbcEmployeeRepository.class);

    private final EmployeeMapper employeeMapper;

    public JdbcEmployeeRepository(EmployeeMapper employeeMapper) {
        this.employeeMapper = employeeMapper;
    }

    @Override
    public List<EmployeeListItem> findAllWithDeptAndPosition() {
        try {
            log.debug("Calling EmployeeMapper.findAllWithDeptAndPosition()");
            List<EmployeeListItem> results = employeeMapper.findAllWithDeptAndPosition();
            log.debug("EmployeeMapper.findAllWithDeptAndPosition() returned {} employees", results.size());
            return results;
        } catch (DataAccessException ex) {
            log.error("DataAccessException in EmployeeRepository.findAllWithDeptAndPosition()", ex);
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found. Run scripts/hrm-schema.sql");
                return List.of();
            }
            throw ex;
        } catch (Exception ex) {
            log.error("Unexpected exception in EmployeeRepository.findAllWithDeptAndPosition()", ex);
            throw ex;
        }
    }

    @Override
    public List<EmployeeListItem> findByDepartment(String departmentId) {
        try {
            return employeeMapper.findByDepartment(departmentId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<EmployeeListItem> findByStatus(String status) {
        try {
            return employeeMapper.findByStatus(status);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<EmployeeListItem> findByProductionLineId(String lineId) {
        try {
            return employeeMapper.findByProductionLineId(lineId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public Optional<Employee> findById(String empId) {
        try {
            return employeeMapper.findById(empId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found");
                return Optional.empty();
            }
            throw ex;
        }
    }

    @Override
    public Optional<EmployeeListItem> findListItemById(String empId) {
        try {
            return employeeMapper.findListItemById(empId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found");
                return Optional.empty();
            }
            throw ex;
        }
    }

    @Override
    public void insert(Employee employee) {
        try {
            employeeMapper.insert(employee);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.error("employees table not found. Cannot insert employee.");
            }
            throw ex;
        }
    }

    @Override
    public void update(Employee employee) {
        try {
            employeeMapper.update(employee);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.error("employees table not found. Cannot update employee.");
            }
            throw ex;
        }
    }

    @Override
    public long countByDepartment(String departmentId) {
        try {
            List<EmployeeListItem> employees = employeeMapper.findByDepartment(departmentId);
            return employees.size();
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("employees table not found");
                return 0;
            }
            throw ex;
        }
    }

    @Override
    public void updateStatus(String empId, String status, String terminationReason) {
        try {
            employeeMapper.updateStatus(empId, status);
            // terminationReason is handled separately in update if needed
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.error("employees table not found. Cannot change status.");
            }
            throw ex;
        }
    }

    @Override
    public void updateProductionLine(String empId, String lineId) {
        try {
            employeeMapper.updateProductionLine(empId, lineId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.error("employees table not found. Cannot update production line.");
            }
            throw ex;
        }
    }
}
