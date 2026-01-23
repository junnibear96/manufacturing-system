package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * 생산 계획 (Production Plan) - 일자별 생산 목표
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductionPlan {

    private Long planId; // PK
    private LocalDate planDate; // 계획 일자
    private String lineId; // FK → ProductionLine

    // 생산 목표
    private String itemCode; // 품목 코드
    private Double qtyPlan; // 계획 수량 (기존 컬럼)
    private Integer targetQuantity; // 목표 수량 (신규 컬럼)
    private Integer priorityLevel; // 우선순위 (1: 최고 ~ 5: 최저)

    // 실행 정보
    private PlanStatus status; // 계획 상태
    private Integer assignedWorkerCount;// 할당된 작업자 수

    // 추적
    private Long createdBy; // 작성자 (FK → User)
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /**
     * 우선순위가 높은지 확인 (1~2)
     */
    public boolean isHighPriority() {
        return priorityLevel != null && priorityLevel <= 2;
    }

    /**
     * 완료 상태인지 확인
     */
    public boolean isCompleted() {
        return status == PlanStatus.COMPLETED;
    }

    /**
     * 진행 중인지 확인
     */
    public boolean isInProgress() {
        return status == PlanStatus.IN_PROGRESS;
    }

    /**
     * 목표 수량 반환 (targetQuantity 우선, 없으면 qtyPlan)
     */
    public Integer getEffectiveTargetQuantity() {
        if (targetQuantity != null && targetQuantity > 0) {
            return targetQuantity;
        }
        return qtyPlan != null ? qtyPlan.intValue() : 0;
    }
}
