package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

/**
 * 일별 달성률 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DailyAchievementDto {

    private LocalDate workDate;
    private String lineId;
    private String lineName;

    private Integer totalTarget;
    private Integer totalActual;
    private Double achievementRate;

    private Integer planCount; // 계획 건수
    private Integer completedPlanCount; // 완료된 계획 건수
}
