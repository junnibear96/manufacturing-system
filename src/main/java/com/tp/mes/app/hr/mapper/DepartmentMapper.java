package com.tp.mes.app.hr.mapper;

import com.tp.mes.app.hr.model.Department;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;

/**
 * 부서 MyBatis Mapper
 */
@Mapper
public interface DepartmentMapper {

    /**
     * 모든 부서 조회
     */
    List<Department> findAll();

    /**
     * 사업부별 부서 조회
     */
    List<Department> findByDivision(String division);

    /**
     * ID로 부서 조회
     */
    Optional<Department> findById(String departmentId);
}
