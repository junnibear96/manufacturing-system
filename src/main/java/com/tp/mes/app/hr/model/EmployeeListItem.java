package com.tp.mes.app.hr.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사원 목록 조회용 DTO (조인 결과 포함)
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class EmployeeListItem {
        private String empId;
        private String empName;
        private String email;
        private String phone;
        private String hireDate; // 문자열로 간단히 표현

        // 조인된 정보
        private String departmentId;
        private String deptName;
        private String positionId;
        private String positionName;

        private String status;
        private String jobType;
}
