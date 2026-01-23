package com.tp.mes.app.prod.model;

public enum ShiftType {
    DAY("주간"),
    AFTERNOON("오후"),
    NIGHT("야간");

    private final String description;

    ShiftType(String description) {
        this.description = description;
    }

    public String getDescription() {
        return description;
    }
}
