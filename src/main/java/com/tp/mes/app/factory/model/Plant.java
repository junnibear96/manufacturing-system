package com.tp.mes.app.factory.model;

import java.time.LocalDate;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 사업장 (Plant) - 최상위 운영 단위
 */
public class Plant {

    private String plantId; // 사업장 ID (PK)
    private String plantName; // 사업장명
    private String plantNameEn; // 사업장명 (영문)

    // 위치 정보
    private String address; // 주소
    private String addressDetail; // 상세 주소
    private String postalCode; // 우편번호
    private String coordinates; // 좌표 (위도,경도 JSON)

    // 사업장 정보
    private String plantType; // 사업장 유형 (MAIN_FACTORY, BRANCH_FACTORY, WAREHOUSE, R&D_CENTER)
    private String status; // 운영 상태 (ACTIVE, MAINTENANCE, SUSPENDED, CLOSED)
    private Double totalArea; // 총 면적 (m²)
    private LocalDate establishedDate; // 설립일

    // 담당자 정보
    private String managerEmpId; // 담당 관리자 사번 (HR 연계)

    // 연락처
    private String phone; // 대표 전화
    private String fax; // 팩스

    // 메타 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Plant() {
    }

    public Plant(String plantId, String plantName, String plantNameEn, String address, String addressDetail,
            String postalCode, String coordinates, String plantType, String status, Double totalArea,
            LocalDate establishedDate, String managerEmpId, String phone, String fax, LocalDateTime createdAt,
            LocalDateTime updatedAt) {
        this.plantId = plantId;
        this.plantName = plantName;
        this.plantNameEn = plantNameEn;
        this.address = address;
        this.addressDetail = addressDetail;
        this.postalCode = postalCode;
        this.coordinates = coordinates;
        this.plantType = plantType;
        this.status = status;
        this.totalArea = totalArea;
        this.establishedDate = establishedDate;
        this.managerEmpId = managerEmpId;
        this.phone = phone;
        this.fax = fax;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public String getPlantId() {
        return plantId;
    }

    public void setPlantId(String plantId) {
        this.plantId = plantId;
    }

    public String getPlantName() {
        return plantName;
    }

    public void setPlantName(String plantName) {
        this.plantName = plantName;
    }

    public String getPlantNameEn() {
        return plantNameEn;
    }

    public void setPlantNameEn(String plantNameEn) {
        this.plantNameEn = plantNameEn;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public String getAddressDetail() {
        return addressDetail;
    }

    public void setAddressDetail(String addressDetail) {
        this.addressDetail = addressDetail;
    }

    public String getPostalCode() {
        return postalCode;
    }

    public void setPostalCode(String postalCode) {
        this.postalCode = postalCode;
    }

    public String getCoordinates() {
        return coordinates;
    }

    public void setCoordinates(String coordinates) {
        this.coordinates = coordinates;
    }

    public String getPlantType() {
        return plantType;
    }

    public void setPlantType(String plantType) {
        this.plantType = plantType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Double getTotalArea() {
        return totalArea;
    }

    public void setTotalArea(Double totalArea) {
        this.totalArea = totalArea;
    }

    public LocalDate getEstablishedDate() {
        return establishedDate;
    }

    public void setEstablishedDate(LocalDate establishedDate) {
        this.establishedDate = establishedDate;
    }

    public String getManagerEmpId() {
        return managerEmpId;
    }

    public void setManagerEmpId(String managerEmpId) {
        this.managerEmpId = managerEmpId;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getFax() {
        return fax;
    }

    public void setFax(String fax) {
        this.fax = fax;
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
        return "Plant{" +
                "plantId='" + plantId + '\'' +
                ", plantName='" + plantName + '\'' +
                ", status='" + status + '\'' +
                '}';
    }
}
