package com.tp.mes.app.hr.mapper;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 사원-권한 MyBatis Mapper
 */
@Mapper
public interface EmployeeRoleMapper {

    /**
     * 사원의 모든 권한 조회
     */
    List<String> findRolesByEmployeeId(String empId);

    /**
     * 사원-권한 매핑 등록
     */
    void insert(@Param("empId") String empId,
            @Param("role") String role,
            @Param("assignedBy") String assignedBy);

    /**
     * 사원의 모든 권한 삭제
     */
    void deleteByEmployeeId(String empId);
}
