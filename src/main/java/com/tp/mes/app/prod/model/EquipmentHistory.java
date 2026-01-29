package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EquipmentHistory {
    private Long historyId;
    private Long equipmentId;
    private String status; // RUNNING, STOPPED, IDLE, ERROR
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Long durationSeconds;
    private LocalDateTime createdAt;
}
