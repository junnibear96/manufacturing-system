package com.tp.mes.app.prod.dto;

import com.tp.mes.app.prod.model.PlanStatus;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

/**
 * Production Status DTO - 실시간 생산 현황
 * 라인별 생산 진행 상황, 자재 소모량 등 종합 정보
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductionStatusDTO {

    // Current Info
    private String lineId; // 생산 라인 ID
    private String lineName; // 생산 라인명
    private String currentProductCode; // 현재 생산 중인 품목 코드
    private String currentProductName; // 현재 생산 중인 품목명
    private PlanStatus planStatus; // 계획 상태

    // Progress Metrics
    private LiveProductionMetricsDTO metrics; // 생산 지표

    // Material Usage
    private List<MaterialUsageDTO> materialUsage; // 자재 소모 현황

    // Timestamps
    private LocalDateTime lastUpdated; // 마지막 업데이트 시각
    private LocalDate workDate; // 작업 일자

    /**
     * 활성 생산 계획이 있는지 확인
     */
    public boolean hasActivePlan() {
        return planStatus != null &&
                (planStatus == PlanStatus.IN_PROGRESS || planStatus == PlanStatus.SCHEDULED);
    }

    /**
     * 자재가 소모되고 있는지 확인
     */
    public boolean hasMaterialConsumption() {
        return materialUsage != null && !materialUsage.isEmpty();
    }

    /**
     * 생산이 진행 중인지 확인
     */
    public boolean isProducing() {
        return metrics != null && metrics.getTotalProduced() != null && metrics.getTotalProduced() > 0;
    }
}
