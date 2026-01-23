package com.tp.mes.app.factory.model;

import java.time.LocalDateTime;

public class ProductionLine {

    private String lineId; // 라인 ID (PK)
    private String factoryId; // 공장 ID (FK)

    private String lineName; // 라인명
    private String lineCode; // 라인 코드

    // 라인 정보
    private String lineType; // 라인 유형 (MANUAL, SEMI_AUTO, FULL_AUTO)
    private String status; // 운영 상태 (RUNNING, STOPPED, IDLE, MAINTENANCE, ERROR)
    private Boolean isOperating; // 현재 가동 여부

    // 생산 능력
    private Integer maxCapacity; // 최대 생산 능력 (개/일)
    private Integer taktTime; // Takt Time (초)
    private Integer cycleTime; // Cycle Time (초)
    private Double utilizationRate; // 가동률 (%) - DEPRECATED: use utilizationRateDecimal

    // Simulation features (added 2026-01-18)
    private java.math.BigDecimal utilizationRateDecimal; // 정확한 가동률 (0.00 ~ 100.00)
    private LocalDateTime utilizationUpdatedAt; // 가동률 최종 업데이트 시각

    // 인력 정보
    private Integer standardWorkers; // 표준 인원 (명)
    private Integer currentWorkers; // 현재 투입 인원 (명)
    private String lineLeaderEmpId; // 라인 리더 사번

    // 생산 관리
    private String producibleItems; // 생산 가능 품목 (JSON 배열)
    private String equipmentList; // 주요 설비 목록 (JSON 배열)
    private String shiftPattern; // 작업 교대 (DAY_ONLY, 2_SHIFT, 3_SHIFT, 24_HOURS)

    // 메타 정보
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private LocalDateTime lastOperatedAt; // 마지막 가동 시각

    public ProductionLine() {
    }

    public ProductionLine(String lineId, String factoryId, String lineName, String lineCode, String lineType,
            String status, Boolean isOperating, Integer maxCapacity, Integer taktTime, Integer cycleTime,
            Double utilizationRate, java.math.BigDecimal utilizationRateDecimal, LocalDateTime utilizationUpdatedAt,
            Integer standardWorkers, Integer currentWorkers, String lineLeaderEmpId, String producibleItems,
            String equipmentList, String shiftPattern, LocalDateTime createdAt, LocalDateTime updatedAt,
            LocalDateTime lastOperatedAt) {
        this.lineId = lineId;
        this.factoryId = factoryId;
        this.lineName = lineName;
        this.lineCode = lineCode;
        this.lineType = lineType;
        this.status = status;
        this.isOperating = isOperating;
        this.maxCapacity = maxCapacity;
        this.taktTime = taktTime;
        this.cycleTime = cycleTime;
        this.utilizationRate = utilizationRate;
        this.utilizationRateDecimal = utilizationRateDecimal;
        this.utilizationUpdatedAt = utilizationUpdatedAt;
        this.standardWorkers = standardWorkers;
        this.currentWorkers = currentWorkers;
        this.lineLeaderEmpId = lineLeaderEmpId;
        this.producibleItems = producibleItems;
        this.equipmentList = equipmentList;
        this.shiftPattern = shiftPattern;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.lastOperatedAt = lastOperatedAt;
    }

    public String getLineId() {
        return lineId;
    }

    public void setLineId(String lineId) {
        this.lineId = lineId;
    }

    public String getFactoryId() {
        return factoryId;
    }

    public void setFactoryId(String factoryId) {
        this.factoryId = factoryId;
    }

    public String getLineName() {
        return lineName;
    }

    public void setLineName(String lineName) {
        this.lineName = lineName;
    }

    public String getLineCode() {
        return lineCode;
    }

    public void setLineCode(String lineCode) {
        this.lineCode = lineCode;
    }

    public String getLineType() {
        return lineType;
    }

    public void setLineType(String lineType) {
        this.lineType = lineType;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Boolean getIsOperating() {
        return isOperating;
    }

    public void setIsOperating(Boolean isOperating) {
        this.isOperating = isOperating;
    }

    public Integer getMaxCapacity() {
        return maxCapacity;
    }

    public void setMaxCapacity(Integer maxCapacity) {
        this.maxCapacity = maxCapacity;
    }

    public Integer getTaktTime() {
        return taktTime;
    }

    public void setTaktTime(Integer taktTime) {
        this.taktTime = taktTime;
    }

    public Integer getCycleTime() {
        return cycleTime;
    }

    public void setCycleTime(Integer cycleTime) {
        this.cycleTime = cycleTime;
    }

    public Double getUtilizationRate() {
        return utilizationRate;
    }

    public void setUtilizationRate(Double utilizationRate) {
        this.utilizationRate = utilizationRate;
    }

    public java.math.BigDecimal getUtilizationRateDecimal() {
        return utilizationRateDecimal;
    }

    public void setUtilizationRateDecimal(java.math.BigDecimal utilizationRateDecimal) {
        this.utilizationRateDecimal = utilizationRateDecimal;
    }

    public LocalDateTime getUtilizationUpdatedAt() {
        return utilizationUpdatedAt;
    }

    public void setUtilizationUpdatedAt(LocalDateTime utilizationUpdatedAt) {
        this.utilizationUpdatedAt = utilizationUpdatedAt;
    }

    public Integer getStandardWorkers() {
        return standardWorkers;
    }

    public void setStandardWorkers(Integer standardWorkers) {
        this.standardWorkers = standardWorkers;
    }

    public Integer getCurrentWorkers() {
        return currentWorkers;
    }

    public void setCurrentWorkers(Integer currentWorkers) {
        this.currentWorkers = currentWorkers;
    }

    public String getLineLeaderEmpId() {
        return lineLeaderEmpId;
    }

    public void setLineLeaderEmpId(String lineLeaderEmpId) {
        this.lineLeaderEmpId = lineLeaderEmpId;
    }

    public String getProducibleItems() {
        return producibleItems;
    }

    public void setProducibleItems(String producibleItems) {
        this.producibleItems = producibleItems;
    }

    public String getEquipmentList() {
        return equipmentList;
    }

    public void setEquipmentList(String equipmentList) {
        this.equipmentList = equipmentList;
    }

    public String getShiftPattern() {
        return shiftPattern;
    }

    public void setShiftPattern(String shiftPattern) {
        this.shiftPattern = shiftPattern;
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

    public LocalDateTime getLastOperatedAt() {
        return lastOperatedAt;
    }

    public void setLastOperatedAt(LocalDateTime lastOperatedAt) {
        this.lastOperatedAt = lastOperatedAt;
    }

    @Override
    public String toString() {
        return "ProductionLine{" +
                "lineId='" + lineId + '\'' +
                ", lineName='" + lineName + '\'' +
                ", status='" + status + '\'' +
                ", utilizationRateDecimal=" + utilizationRateDecimal +
                '}';
    }
}
