package com.tp.mes.app.prod.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * BOM (Bill of Materials) - 생산 라인별 자재 소모 정보
 * 특정 생산 라인에서 생산 시 소모되는 재고 아이템과 소모율을 정의
 */
public class ProductionBom {

    private Long bomId; // BOM ID (PK)
    private String lineId; // 생산 라인 ID (FK)
    private Long inventoryId; // 재고 아이템 ID (FK)
    private BigDecimal consumptionRate; // 시간당 소모량 (100% 가동 시 기준)
    private String unit; // 단위 (KG, EA, L 등)
    private String notes; // 비고
    private String isActive; // 활성 여부 (Y/N)
    private LocalDateTime createdAt; // 생성 시각
    private LocalDateTime updatedAt; // 수정 시각

    // Transient fields (조인 데이터)
    private String lineName; // 라인명 (조인)
    private String itemCode; // 품목 코드 (조인)
    private String itemName; // 품목명 (조인)

    public ProductionBom() {
    }

    public ProductionBom(Long bomId, String lineId, Long inventoryId, BigDecimal consumptionRate, String unit,
            String notes, String isActive, LocalDateTime createdAt, LocalDateTime updatedAt, String lineName,
            String itemCode, String itemName) {
        this.bomId = bomId;
        this.lineId = lineId;
        this.inventoryId = inventoryId;
        this.consumptionRate = consumptionRate;
        this.unit = unit;
        this.notes = notes;
        this.isActive = isActive;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.lineName = lineName;
        this.itemCode = itemCode;
        this.itemName = itemName;
    }

    public Long getBomId() {
        return bomId;
    }

    public void setBomId(Long bomId) {
        this.bomId = bomId;
    }

    public String getLineId() {
        return lineId;
    }

    public void setLineId(String lineId) {
        this.lineId = lineId;
    }

    public Long getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(Long inventoryId) {
        this.inventoryId = inventoryId;
    }

    public BigDecimal getConsumptionRate() {
        return consumptionRate;
    }

    public void setConsumptionRate(BigDecimal consumptionRate) {
        this.consumptionRate = consumptionRate;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public String getIsActive() {
        return isActive;
    }

    public void setIsActive(String isActive) {
        this.isActive = isActive;
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

    public String getLineName() {
        return lineName;
    }

    public void setLineName(String lineName) {
        this.lineName = lineName;
    }

    public String getItemCode() {
        return itemCode;
    }

    public void setItemCode(String itemCode) {
        this.itemCode = itemCode;
    }

    public String getItemName() {
        return itemName;
    }

    public void setItemName(String itemName) {
        this.itemName = itemName;
    }

    @Override
    public String toString() {
        return "ProductionBom{" +
                "bomId=" + bomId +
                ", lineId='" + lineId + '\'' +
                ", inventoryId=" + inventoryId +
                '}';
    }

    /**
     * 특정 시간 동안의 실제 소모량 계산
     * 
     * @param utilizationRate 가동률 (0~100)
     * @param hours           시간
     * @return 실제 소모량
     */
    public BigDecimal calculateActualConsumption(BigDecimal utilizationRate, double hours) {
        return consumptionRate
                .multiply(utilizationRate)
                .divide(new BigDecimal("100"), 4, java.math.RoundingMode.HALF_UP)
                .multiply(new BigDecimal(hours));
    }
}
