package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EquipmentStatusHistory {
    private Long historyId;
    private Long equipmentId;
    private String status;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private Long durationSeconds;
    private LocalDateTime createdAt;
}
