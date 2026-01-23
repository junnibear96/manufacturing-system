package com.tp.mes.app.prod.model;

import lombok.Data;
import java.time.LocalDateTime;

public class MaintenanceHistory {
    private Long historyId;
    private Long equipmentId;
    private LocalDateTime maintenanceDate;
    private String worker;
    private String description;
    private LocalDateTime createdAt;

    public Long getHistoryId() {
        return historyId;
    }

    public void setHistoryId(Long historyId) {
        this.historyId = historyId;
    }

    public Long getEquipmentId() {
        return equipmentId;
    }

    public void setEquipmentId(Long equipmentId) {
        this.equipmentId = equipmentId;
    }

    public LocalDateTime getMaintenanceDate() {
        return maintenanceDate;
    }

    public void setMaintenanceDate(LocalDateTime maintenanceDate) {
        this.maintenanceDate = maintenanceDate;
    }

    public String getWorker() {
        return worker;
    }

    public void setWorker(String worker) {
        this.worker = worker;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    @Override
    public String toString() {
        return "MaintenanceHistory{" +
                "historyId=" + historyId +
                ", equipmentId=" + equipmentId +
                ", maintenanceDate=" + maintenanceDate +
                ", worker='" + worker + '\'' +
                ", description='" + description + '\'' +
                ", createdAt=" + createdAt +
                '}';
    }
}
