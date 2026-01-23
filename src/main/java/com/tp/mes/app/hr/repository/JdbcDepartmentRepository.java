package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.mapper.DepartmentMapper;
import com.tp.mes.app.hr.model.Department;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor; // Still used for constructor generation? No, I need to check if I should keep it. Yes, keeping it for now if it works on constructors, but likely I should replace it too if I want full manual.
// Actually, RequiredArgsConstructor might work if it's just generating code, but if processor is off, it won't. I'll replace it with manual constructor.
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * 부서 Repository (MyBatis 기반)
 */
@Repository
public class JdbcDepartmentRepository implements DepartmentRepository {

    private static final Logger log = LoggerFactory.getLogger(JdbcDepartmentRepository.class);

    private final DepartmentMapper departmentMapper;

    public JdbcDepartmentRepository(DepartmentMapper departmentMapper) {
        this.departmentMapper = departmentMapper;
    }

    @Override
    public List<Department> findAll() {
        try {
            return departmentMapper.findAll();
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("departments table not found. Run scripts/hrm-schema.sql");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<Department> findByDivision(String division) {
        try {
            return departmentMapper.findByDivision(division);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("departments table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public Optional<Department> findById(String departmentId) {
        try {
            return departmentMapper.findById(departmentId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("departments table not found");
                return Optional.empty();
            }
            throw ex;
        }
    }
}
