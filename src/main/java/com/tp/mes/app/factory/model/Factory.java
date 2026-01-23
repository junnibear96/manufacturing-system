package com.tp.mes.app.factory.model;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 공장 (Factory) - 사업장 내 생산 기능별 구역
 */
public class Factory {

    private String factoryId; // 공장 ID (PK)
    private String plantId; // 사업장 ID (FK)

    private String factoryName; // 공장명
    private String factoryNameEn; // 공장명 (영문)
    private String factoryCode; // 공장 코드

    // 공장 정보
    private String factoryType; // 공장 유형 (ASSEMBLY, PROCESSING, PACKAGING, TESTING, LOGISTICS)
    private String status; // 운영 상태 (ACTIVE, IDLE, MAINTENANCE, SHUTDOWN)
    private String productCategory; // 생산 품목군

    // 위치 정보
    private String buildingCode; // 건물/동 코드
    private String floor; // 층
    private Double area; // 면적 (m²)

    // 운영 정보
    private Double targetUtilizationRate; // 가동률 목표 (%)

    // 담당자
    private String managerEmpId; // 담당 관리자 사번

    // 메타 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    public Factory() {
    }

    public Factory(String factoryId, String plantId, String factoryName, String factoryNameEn, String factoryCode,
            String factoryType, String status, String productCategory, String buildingCode, String floor, Double area,
            Double targetUtilizationRate, String managerEmpId, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.factoryId = factoryId;
        this.plantId = plantId;
        this.factoryName = factoryName;
        this.factoryNameEn = factoryNameEn;
        this.factoryCode = factoryCode;
        this.factoryType = factoryType;
        this.status = status;
        this.productCategory = productCategory;
        this.buildingCode = buildingCode;
        this.floor = floor;
        this.area = area;
        this.targetUtilizationRate = targetUtilizationRate;
        this.managerEmpId = managerEmpId;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    public String getFactoryId() {
        return factoryId;
    }

    public void setFactoryId(String factoryId) {
        this.factoryId = factoryId;
    }

    public String getPlantId() {
        return plantId;
    }

    public void setPlantId(String plantId) {
        this.plantId = plantId;
    }

    public String getFactoryName() {
        return factoryName;
    }

    public void setFactoryName(String factoryName) {
        this.factoryName = factoryName;
    }

    public String getFactoryNameEn() {
        return factoryNameEn;
    }

    public void setFactoryNameEn(String factoryNameEn) {
        this.factoryNameEn = factoryNameEn;
    }

    public String getFactoryCode() {
        return factoryCode;
    }

    public void setFactoryCode(String factoryCode) {
        this.factoryCode = factoryCode;
    }

    public String getFactoryType() {
        return factoryType;
    }

    public void setFactoryType(String factoryType) {
        this.factoryType = factoryType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getProductCategory() {
        return productCategory;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public String getBuildingCode() {
        return buildingCode;
    }

    public void setBuildingCode(String buildingCode) {
        this.buildingCode = buildingCode;
    }

    public String getFloor() {
        return floor;
    }

    public void setFloor(String floor) {
        this.floor = floor;
    }

    public Double getArea() {
        return area;
    }

    public void setArea(Double area) {
        this.area = area;
    }

    public Double getTargetUtilizationRate() {
        return targetUtilizationRate;
    }

    public void setTargetUtilizationRate(Double targetUtilizationRate) {
        this.targetUtilizationRate = targetUtilizationRate;
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
        return "Factory{" +
                "factoryId='" + factoryId + '\'' +
                ", plantId='" + plantId + '\'' +
                ", factoryName='" + factoryName + '\'' +
                '}';
    }
}
