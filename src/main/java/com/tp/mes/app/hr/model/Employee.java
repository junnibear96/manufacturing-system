package com.tp.mes.app.hr.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사원 정보
 */
public class Employee {
    private String empId;
    private String empName;
    private String email;
    private String phone;
    private LocalDate hireDate;
    private LocalDate birthDate;
    private String gender; // M/F/O

    // 조직 정보
    private String departmentId;
    private String positionId;
    private String jobType; // OFFICE/PRODUCTION/LOGISTICS
    private String managerEmpId;

    // 재직 상태
    private String status; // ACTIVE/LEAVE/RETIRED/TERMINATED/PROBATION
    private LocalDate leaveStartDate;
    private LocalDate leaveEndDate;
    private LocalDate terminationDate;
    private String terminationReason;

    // 생산 관련
    private String shiftType; // DAY/SWING/NIGHT
    private String factoryId;
    private String productionLineId;
    private Integer skillLevel; // 1~5

    // 메타 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Employee() {
    }

    public Employee(String empId, String empName, String email, String phone, LocalDate hireDate, LocalDate birthDate,
            String gender, String departmentId, String positionId, String jobType, String managerEmpId, String status,
            LocalDate leaveStartDate, LocalDate leaveEndDate, LocalDate terminationDate, String terminationReason,
            String shiftType, String factoryId, String productionLineId, Integer skillLevel, LocalDateTime createdAt,
            LocalDateTime updatedAt) {
        this.empId = empId;
        this.empName = empName;
        this.email = email;
        this.phone = phone;
        this.hireDate = hireDate;
        this.birthDate = birthDate;
        this.gender = gender;
        this.departmentId = departmentId;
        this.positionId = positionId;
        this.jobType = jobType;
        this.managerEmpId = managerEmpId;
        this.status = status;
        this.leaveStartDate = leaveStartDate;
        this.leaveEndDate = leaveEndDate;
        this.terminationDate = terminationDate;
        this.terminationReason = terminationReason;
        this.shiftType = shiftType;
        this.factoryId = factoryId;
        this.productionLineId = productionLineId;
        this.skillLevel = skillLevel;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public String getEmpId() {
        return empId;
    }

    public void setEmpId(String empId) {
        this.empId = empId;
    }

    public String getEmpName() {
        return empName;
    }

    public void setEmpName(String empName) {
        this.empName = empName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public LocalDate getHireDate() {
        return hireDate;
    }

    public void setHireDate(LocalDate hireDate) {
        this.hireDate = hireDate;
    }

    public LocalDate getBirthDate() {
        return birthDate;
    }

    public void setBirthDate(LocalDate birthDate) {
        this.birthDate = birthDate;
    }

    public String getGender() {
        return gender;
    }

    public void setGender(String gender) {
        this.gender = gender;
    }

    public String getDepartmentId() {
        return departmentId;
    }

    public void setDepartmentId(String departmentId) {
        this.departmentId = departmentId;
    }

    public String getPositionId() {
        return positionId;
    }

    public void setPositionId(String positionId) {
        this.positionId = positionId;
    }

    public String getJobType() {
        return jobType;
    }

    public void setJobType(String jobType) {
        this.jobType = jobType;
    }

    public String getManagerEmpId() {
        return managerEmpId;
    }

    public void setManagerEmpId(String managerEmpId) {
        this.managerEmpId = managerEmpId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDate getLeaveStartDate() {
        return leaveStartDate;
    }

    public void setLeaveStartDate(LocalDate leaveStartDate) {
        this.leaveStartDate = leaveStartDate;
    }

    public LocalDate getLeaveEndDate() {
        return leaveEndDate;
    }

    public void setLeaveEndDate(LocalDate leaveEndDate) {
        this.leaveEndDate = leaveEndDate;
    }

    public LocalDate getTerminationDate() {
        return terminationDate;
    }

    public void setTerminationDate(LocalDate terminationDate) {
        this.terminationDate = terminationDate;
    }

    public String getTerminationReason() {
        return terminationReason;
    }

    public void setTerminationReason(String terminationReason) {
        this.terminationReason = terminationReason;
    }

    public String getShiftType() {
        return shiftType;
    }

    public void setShiftType(String shiftType) {
        this.shiftType = shiftType;
    }

    public String getFactoryId() {
        return factoryId;
    }

    public void setFactoryId(String factoryId) {
        this.factoryId = factoryId;
    }

    public String getProductionLineId() {
        return productionLineId;
    }

    public void setProductionLineId(String productionLineId) {
        this.productionLineId = productionLineId;
    }

    public Integer getSkillLevel() {
        return skillLevel;
    }

    public void setSkillLevel(Integer skillLevel) {
        this.skillLevel = skillLevel;
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
        return "Employee{" +
                "empId='" + empId + '\'' +
                ", empName='" + empName + '\'' +
                ", email='" + email + '\'' +
                ", phone='" + phone + '\'' +
                ", hireDate=" + hireDate +
                ", birthDate=" + birthDate +
                ", gender='" + gender + '\'' +
                ", departmentId='" + departmentId + '\'' +
                ", positionId='" + positionId + '\'' +
                ", jobType='" + jobType + '\'' +
                ", managerEmpId='" + managerEmpId + '\'' +
                ", status='" + status + '\'' +
                ", leaveStartDate=" + leaveStartDate +
                ", leaveEndDate=" + leaveEndDate +
                ", terminationDate=" + terminationDate +
                ", terminationReason='" + terminationReason + '\'' +
                ", shiftType='" + shiftType + '\'' +
                ", factoryId='" + factoryId + '\'' +
                ", productionLineId='" + productionLineId + '\'' +
                ", skillLevel=" + skillLevel +
                ", createdAt=" + createdAt +
                ", updatedAt=" + updatedAt +
                '}';
    }
}
