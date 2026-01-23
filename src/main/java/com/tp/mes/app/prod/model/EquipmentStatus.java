package com.tp.mes.app.prod.model;

public enum EquipmentStatus {
    RUNNING("가동 중"),
    IDLE("대기"),
    MAINTENANCE("점검 중"),
    ERROR("고장"),
    STOPPED("정지");

    private final String description;

    EquipmentStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
