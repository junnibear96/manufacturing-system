package com.tp.mes.app.hr.model;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 부서 정보
 */
public class Department {
        private String departmentId;
        private String deptName;
        private String deptNameEn;
        private String division; // PRODUCTION/LOGISTICS/MANAGEMENT
        private String managerEmpId;
        private LocalDateTime createdAt;
        private LocalDateTime updatedAt;

        public Department() {
        }

        public Department(String departmentId, String deptName, String deptNameEn, String division, String managerEmpId,
                        LocalDateTime createdAt, LocalDateTime updatedAt) {
                this.departmentId = departmentId;
                this.deptName = deptName;
                this.deptNameEn = deptNameEn;
                this.division = division;
                this.managerEmpId = managerEmpId;
                this.createdAt = createdAt;
                this.updatedAt = updatedAt;
        }

        public String getDepartmentId() {
                return departmentId;
        }

        public void setDepartmentId(String departmentId) {
                this.departmentId = departmentId;
        }

        public String getDeptName() {
                return deptName;
        }

        public void setDeptName(String deptName) {
                this.deptName = deptName;
        }

        public String getDeptNameEn() {
                return deptNameEn;
        }

        public void setDeptNameEn(String deptNameEn) {
                this.deptNameEn = deptNameEn;
        }

        public String getDivision() {
                return division;
        }

        public void setDivision(String division) {
                this.division = division;
        }

        public String getManagerEmpId() {
                return managerEmpId;
        }

        public void setManagerEmpId(String managerEmpId) {
                this.managerEmpId = managerEmpId;
        }

        public LocalDateTime getCreatedAt() {
                return createdAt;
        }

        public void setCreatedAt(LocalDateTime createdAt) {
                this.createdAt = createdAt;
        }

        public LocalDateTime getUpdatedAt() {
                return updatedAt;
        }

        public void setUpdatedAt(LocalDateTime updatedAt) {
                this.updatedAt = updatedAt;
        }

        @Override
        public String toString() {
                return "Department{" +
                                "departmentId='" + departmentId + '\'' +
                                ", deptName='" + deptName + '\'' +
                                ", deptNameEn='" + deptNameEn + '\'' +
                                ", division='" + division + '\'' +
                                ", managerEmpId='" + managerEmpId + '\'' +
                                ", createdAt=" + createdAt +
                                ", updatedAt=" + updatedAt +
                                '}';
        }
}
