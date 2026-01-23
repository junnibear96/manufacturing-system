package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 생산 실적 (Production Result) - 실제 생산 결과 기록
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductionResult {

    private Long resultId; // PK
    private Long planId; // FK → ProductionPlan (NULL 허용)
    private LocalDate workDate; // 작업 일자

    // 생산 정보
    private String itemCode; // 품목 코드
    private Double qtyGood; // 양품 수량
    private Double qtyNg; // 불량 수량
    private Double defectRate; // 불량률 (%)

    // 작업 현장
    private Long equipmentId; // FK → Equipment
    private String lineId; // FK → ProductionLine
    private ShiftType shiftType; // 작업 교대

    // 작업자 정보
    private Long workerId; // FK → Employee (추후 연동)
    private Integer workHours; // 작업 시간 (분)

    // 추적
    private Long createdBy; // 기록자 (FK → User)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /**
     * 총 생산 수량 계산
     */
    public Double getTotalQuantity() {
        return (qtyGood != null ? qtyGood : 0.0) +
                (qtyNg != null ? qtyNg : 0.0);
    }

    /**
     * 불량률 자동 계산
     */
    public Double calculateDefectRate() {
        Double total = getTotalQuantity();
        if (total == 0) {
            return 0.0;
        }
        return ((qtyNg != null ? qtyNg : 0.0) / total) * 100.0;
    }

    /**
     * 불량률 업데이트
     */
    public void updateDefectRate() {
        this.defectRate = calculateDefectRate();
    }

    /**
     * 계획과 연결되어 있는지 확인
     */
    public boolean hasLinkedPlan() {
        return planId != null;
    }

    /**
     * 불량률이 높은지 확인 (기준: 5%)
     */
    public boolean isHighDefectRate() {
        return defectRate != null && defectRate > 5.0;
    }
}
