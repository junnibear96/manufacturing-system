package com.tp.mes.app.prod.model;

public enum PlanStatus {
    SCHEDULED("예정"),
    IN_PROGRESS("진행 중"),
    COMPLETED("완료"),
    CANCELLED("취소");

    private final String description;

    PlanStatus(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
