package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 생산 KPI 요약
 */
public class ProductionKpiSummary {

    // 계획 정보
    private Integer totalPlans;
    private Integer completedPlans;
    private Integer inProgressPlans;

    // 생산 실적
    private Integer todayTargetQuantity;
    private Integer todayActualQuantity;
    private Double todayAchievementRate;

    // 품질 정보
    private Integer todayTotalGood;
    private Integer todayTotalDefect;
    private Double todayDefectRate;

    // 장비 현황
    private Integer totalEquipment;
    private Integer runningEquipment;
    private Integer maintenanceEquipment;
    private Integer errorEquipment;
    private Double equipmentUtilizationRate;

    public ProductionKpiSummary() {
    }

    public ProductionKpiSummary(Integer totalPlans, Integer completedPlans, Integer inProgressPlans,
            Integer todayTargetQuantity, Integer todayActualQuantity, Double todayAchievementRate,
            Integer todayTotalGood, Integer todayTotalDefect, Double todayDefectRate, Integer totalEquipment,
            Integer runningEquipment, Integer maintenanceEquipment, Integer errorEquipment,
            Double equipmentUtilizationRate) {
        this.totalPlans = totalPlans;
        this.completedPlans = completedPlans;
        this.inProgressPlans = inProgressPlans;
        this.todayTargetQuantity = todayTargetQuantity;
        this.todayActualQuantity = todayActualQuantity;
        this.todayAchievementRate = todayAchievementRate;
        this.todayTotalGood = todayTotalGood;
        this.todayTotalDefect = todayTotalDefect;
        this.todayDefectRate = todayDefectRate;
        this.totalEquipment = totalEquipment;
        this.runningEquipment = runningEquipment;
        this.maintenanceEquipment = maintenanceEquipment;
        this.errorEquipment = errorEquipment;
        this.equipmentUtilizationRate = equipmentUtilizationRate;
    }

    public static ProductionKpiSummaryBuilder builder() {
        return new ProductionKpiSummaryBuilder();
    }

    public static class ProductionKpiSummaryBuilder {
        private Integer totalPlans;
        private Integer completedPlans;
        private Integer inProgressPlans;
        private Integer todayTargetQuantity;
        private Integer todayActualQuantity;
        private Double todayAchievementRate;
        private Integer todayTotalGood;
        private Integer todayTotalDefect;
        private Double todayDefectRate;
        private Integer totalEquipment;
        private Integer runningEquipment;
        private Integer maintenanceEquipment;
        private Integer errorEquipment;
        private Double equipmentUtilizationRate;

        ProductionKpiSummaryBuilder() {
        }

        public ProductionKpiSummaryBuilder totalPlans(Integer totalPlans) {
            this.totalPlans = totalPlans;
            return this;
        }

        public ProductionKpiSummaryBuilder completedPlans(Integer completedPlans) {
            this.completedPlans = completedPlans;
            return this;
        }

        public ProductionKpiSummaryBuilder inProgressPlans(Integer inProgressPlans) {
            this.inProgressPlans = inProgressPlans;
            return this;
        }

        public ProductionKpiSummaryBuilder todayTargetQuantity(Integer todayTargetQuantity) {
            this.todayTargetQuantity = todayTargetQuantity;
            return this;
        }

        public ProductionKpiSummaryBuilder todayActualQuantity(Integer todayActualQuantity) {
            this.todayActualQuantity = todayActualQuantity;
            return this;
        }

        public ProductionKpiSummaryBuilder todayAchievementRate(Double todayAchievementRate) {
            this.todayAchievementRate = todayAchievementRate;
            return this;
        }

        public ProductionKpiSummaryBuilder todayTotalGood(Integer todayTotalGood) {
            this.todayTotalGood = todayTotalGood;
            return this;
        }

        public ProductionKpiSummaryBuilder todayTotalDefect(Integer todayTotalDefect) {
            this.todayTotalDefect = todayTotalDefect;
            return this;
        }

        public ProductionKpiSummaryBuilder todayDefectRate(Double todayDefectRate) {
            this.todayDefectRate = todayDefectRate;
            return this;
        }

        public ProductionKpiSummaryBuilder totalEquipment(Integer totalEquipment) {
            this.totalEquipment = totalEquipment;
            return this;
        }

        public ProductionKpiSummaryBuilder runningEquipment(Integer runningEquipment) {
            this.runningEquipment = runningEquipment;
            return this;
        }

        public ProductionKpiSummaryBuilder maintenanceEquipment(Integer maintenanceEquipment) {
            this.maintenanceEquipment = maintenanceEquipment;
            return this;
        }

        public ProductionKpiSummaryBuilder errorEquipment(Integer errorEquipment) {
            this.errorEquipment = errorEquipment;
            return this;
        }

        public ProductionKpiSummaryBuilder equipmentUtilizationRate(Double equipmentUtilizationRate) {
            this.equipmentUtilizationRate = equipmentUtilizationRate;
            return this;
        }

        public ProductionKpiSummary build() {
            return new ProductionKpiSummary(totalPlans, completedPlans, inProgressPlans, todayTargetQuantity,
                    todayActualQuantity, todayAchievementRate, todayTotalGood, todayTotalDefect, todayDefectRate,
                    totalEquipment, runningEquipment, maintenanceEquipment, errorEquipment, equipmentUtilizationRate);
        }
    }

    public Integer getTotalPlans() {
        return totalPlans;
    }

    public void setTotalPlans(Integer totalPlans) {
        this.totalPlans = totalPlans;
    }

    public Integer getCompletedPlans() {
        return completedPlans;
    }

    public void setCompletedPlans(Integer completedPlans) {
        this.completedPlans = completedPlans;
    }

    public Integer getInProgressPlans() {
        return inProgressPlans;
    }

    public void setInProgressPlans(Integer inProgressPlans) {
        this.inProgressPlans = inProgressPlans;
    }

    public Integer getTodayTargetQuantity() {
        return todayTargetQuantity;
    }

    public void setTodayTargetQuantity(Integer todayTargetQuantity) {
        this.todayTargetQuantity = todayTargetQuantity;
    }

    public Integer getTodayActualQuantity() {
        return todayActualQuantity;
    }

    public void setTodayActualQuantity(Integer todayActualQuantity) {
        this.todayActualQuantity = todayActualQuantity;
    }

    public void setTodayAchievementRate(Double todayAchievementRate) {
        this.todayAchievementRate = todayAchievementRate;
    }

    public Integer getTodayTotalGood() {
        return todayTotalGood;
    }

    public void setTodayTotalGood(Integer todayTotalGood) {
        this.todayTotalGood = todayTotalGood;
    }

    public Integer getTodayTotalDefect() {
        return todayTotalDefect;
    }

    public void setTodayTotalDefect(Integer todayTotalDefect) {
        this.todayTotalDefect = todayTotalDefect;
    }

    public void setTodayDefectRate(Double todayDefectRate) {
        this.todayDefectRate = todayDefectRate;
    }

    public Integer getTotalEquipment() {
        return totalEquipment;
    }

    public void setTotalEquipment(Integer totalEquipment) {
        this.totalEquipment = totalEquipment;
    }

    public Integer getRunningEquipment() {
        return runningEquipment;
    }

    public void setRunningEquipment(Integer runningEquipment) {
        this.runningEquipment = runningEquipment;
    }

    public Integer getMaintenanceEquipment() {
        return maintenanceEquipment;
    }

    public void setMaintenanceEquipment(Integer maintenanceEquipment) {
        this.maintenanceEquipment = maintenanceEquipment;
    }

    public Integer getErrorEquipment() {
        return errorEquipment;
    }

    public void setErrorEquipment(Integer errorEquipment) {
        this.errorEquipment = errorEquipment;
    }

    public Double getEquipmentUtilizationRate() {
        return equipmentUtilizationRate;
    }

    public void setEquipmentUtilizationRate(Double equipmentUtilizationRate) {
        this.equipmentUtilizationRate = equipmentUtilizationRate;
    }

    public Double getTodayAchievementRate() {
        if (todayAchievementRate != null)
            return todayAchievementRate;
        if (todayTargetQuantity == null || todayTargetQuantity == 0)
            return 0.0;
        if (todayActualQuantity == null)
            return 0.0;
        return Math.round(todayActualQuantity * 100.0 / todayTargetQuantity * 100) / 100.0;
    }

    public Double getTodayDefectRate() {
        if (todayDefectRate != null)
            return todayDefectRate;
        long total = (todayTotalGood != null ? todayTotalGood : 0) + (todayTotalDefect != null ? todayTotalDefect : 0);
        if (total == 0)
            return 0.0;
        return Math.round((todayTotalDefect != null ? todayTotalDefect : 0) * 100.0 / total * 100) / 100.0;
    }
}
