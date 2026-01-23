package com.tp.mes.app.inventory.model;

import java.math.BigDecimal;

/**
 * 재고 통계 DTO
 * 대시보드에 표시할 KPI 데이터
 */
public class InventoryStats {

    private Long totalItems;
    private Long activeItems;
    private Long lowStockItems;
    private BigDecimal totalValue;
    private Long recentTransactions;

    // Getters and Setters

    public Long getTotalItems() {
        return totalItems;
    }

    public void setTotalItems(Long totalItems) {
        this.totalItems = totalItems;
    }

    public Long getActiveItems() {
        return activeItems;
    }

    public void setActiveItems(Long activeItems) {
        this.activeItems = activeItems;
    }

    public Long getLowStockItems() {
        return lowStockItems;
    }

    public void setLowStockItems(Long lowStockItems) {
        this.lowStockItems = lowStockItems;
    }

    public BigDecimal getTotalValue() {
        return totalValue;
    }

    public void setTotalValue(BigDecimal totalValue) {
        this.totalValue = totalValue;
    }

    public Long getRecentTransactions() {
        return recentTransactions;
    }

    public void setRecentTransactions(Long recentTransactions) {
        this.recentTransactions = recentTransactions;
    }
}
