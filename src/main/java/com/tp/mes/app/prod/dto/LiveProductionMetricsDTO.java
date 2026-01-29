package com.tp.mes.app.prod.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Live Production Metrics DTO - 생산 진행 지표
 * 실시간 달성률, 불량률, 진행 상태 등을 포함
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class LiveProductionMetricsDTO {

    // Quantities
    private Integer targetQuantity; // 목표 수량 (from production_plan)
    private Integer actualGoodQuantity; // 실제 양품 수량 (from production_result)
    private Integer actualNgQuantity; // 불량 수량 (from production_result)
    private Integer totalProduced; // 총 생산량 (Good + NG)

    // Rates (%)
    private Double achievementRate; // 달성률: (actual / target) * 100
    private Double defectRate; // 불량률: (NG / total) * 100

    // Derived metrics
    private Integer remainingQuantity; // 남은 수량: target - actual
    private String statusIndicator; // 상태 지표: "AHEAD" / "ON_TRACK" / "BEHIND"

    /**
     * 목표 대비 앞서가는지 확인
     */
    public boolean isAheadOfTarget() {
        return statusIndicator != null && statusIndicator.equals("AHEAD");
    }

    /**
     * 목표 대비 뒤처지는지 확인
     */
    public boolean isBehindTarget() {
        return statusIndicator != null && statusIndicator.equals("BEHIND");
    }

    /**
     * 불량률이 높은지 확인 (기준: 5%)
     */
    public boolean hasHighDefectRate() {
        return defectRate != null && defectRate > 5.0;
    }
}
