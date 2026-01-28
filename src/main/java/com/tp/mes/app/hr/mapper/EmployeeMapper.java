package com.tp.mes.app.hr.mapper;

import com.tp.mes.app.hr.model.Employee;
import com.tp.mes.app.hr.model.EmployeeListItem;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 사원 MyBatis Mapper
 */
@Mapper
public interface EmployeeMapper {

    /**
     * 모든 사원 조회 (부서명, 직급명 포함)
     */
    List<EmployeeListItem> findAllWithDeptAndPosition();

    /**
     * 부서별 사원 조회
     */
    List<EmployeeListItem> findByDepartment(String departmentId);

    /**
     * 상태별 사원 조회
     */
    List<EmployeeListItem> findByStatus(String status);

    /**
     * 생산라인별 사원 조회
     */
    List<EmployeeListItem> findByProductionLineId(String lineId);

    /**
     * ID로 사원 조회
     */
    Optional<Employee> findById(String empId);

    /**
     * ID로 사원 조회 (리스트 항목용)
     */
    Optional<EmployeeListItem> findListItemById(String empId);

    /**
     * 사원 등록
     */
    void insert(Employee employee);

    /**
     * 사원 정보 수정
     */
    void update(Employee employee);

    /**
     * 사원 상태 변경
     */
    void updateStatus(@Param("empId") String empId, @Param("status") String status);

    /**
     * 사원 생산라인 배정/해제
     */
    void updateProductionLine(@Param("empId") String empId, @Param("lineId") String lineId);
}
