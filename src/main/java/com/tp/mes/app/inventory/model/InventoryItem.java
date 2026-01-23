package com.tp.mes.app.inventory.model;

import java.math.BigDecimal;
import java.time.LocalDateTime;

/**
 * 재고 아이템 모델
 * 원자재, 부품, 완제품 정보를 관리
 */
public class InventoryItem {

    private Long inventoryId;
    private String itemCode;
    private String itemName;
    private String itemType; // RAW_MATERIAL, COMPONENT, FINISHED_PRODUCT
    private String category;
    private String unit; // KG, EA, M, L, etc.
    private BigDecimal currentQuantity;
    private BigDecimal minQuantity;
    private BigDecimal maxQuantity;
    private BigDecimal unitPrice;
    private String warehouseLocation;
    private Long lineId;
    private String specifications;
    private String status; // ACTIVE, DISCONTINUED
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    // Getters and Setters

    public Long getInventoryId() {
        return inventoryId;
    }

    public void setInventoryId(Long inventoryId) {
        this.inventoryId = inventoryId;
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

    public String getItemType() {
        return itemType;
    }

    public void setItemType(String itemType) {
        this.itemType = itemType;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getCurrentQuantity() {
        return currentQuantity;
    }

    public void setCurrentQuantity(BigDecimal currentQuantity) {
        this.currentQuantity = currentQuantity;
    }

    public BigDecimal getMinQuantity() {
        return minQuantity;
    }

    public void setMinQuantity(BigDecimal minQuantity) {
        this.minQuantity = minQuantity;
    }

    public BigDecimal getMaxQuantity() {
        return maxQuantity;
    }

    public void setMaxQuantity(BigDecimal maxQuantity) {
        this.maxQuantity = maxQuantity;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }

    public String getWarehouseLocation() {
        return warehouseLocation;
    }

    public void setWarehouseLocation(String warehouseLocation) {
        this.warehouseLocation = warehouseLocation;
    }

    public Long getLineId() {
        return lineId;
    }

    public void setLineId(Long lineId) {
        this.lineId = lineId;
    }

    public String getSpecifications() {
        return specifications;
    }

    public void setSpecifications(String specifications) {
        this.specifications = specifications;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
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

    /**
     * 재고 부족 여부 확인
     */
    public boolean isLowStock() {
        if (currentQuantity == null || minQuantity == null) {
            return false;
        }
        return currentQuantity.compareTo(minQuantity) < 0;
    }

    /**
     * 재고 가치 계산
     */
    public BigDecimal getTotalValue() {
        if (currentQuantity == null || unitPrice == null) {
            return BigDecimal.ZERO;
        }
        return currentQuantity.multiply(unitPrice);
    }
}
