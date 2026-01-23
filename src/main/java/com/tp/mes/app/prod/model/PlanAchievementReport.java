package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

/**
 * 계획 달성률 분석 결과
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class PlanAchievementReport {

    private Long planId;
    private LocalDate planDate;
    private String itemCode;
    private String lineName;

    // 계획 정보
    private Integer targetQuantity;
    private Integer assignedWorkerCount;

    // 실적 정보
    private Integer actualQuantity;
    private Integer totalDefects;

    // 분석 결과
    private Double achievementRate; // 달성률 (%)
    private Double defectRate; // 불량률 (%)
    private String performanceStatus; // EXCEEDED, ACHIEVED, UNDERPERFORMED, CRITICAL

    /**
     * 목표 초과 여부
     */
    public boolean isExceeded() {
        return "EXCEEDED".equals(performanceStatus);
    }

    /**
     * 목표 달성 여부
     */
    public boolean isAchieved() {
        return "ACHIEVED".equals(performanceStatus);
    }

    /**
     * 미달 여부
     */
    public boolean isUnderperformed() {
        return "UNDERPERFORMED".equals(performanceStatus) ||
                "CRITICAL".equals(performanceStatus);
    }
}
