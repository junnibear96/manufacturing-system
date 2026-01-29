package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * Production Result Summary - 생산 실적 집계
 * production_result 테이블의 SUM 결과를 담는 헬퍼 클래스
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductionResultSummary {

    private Integer totalGood; // 총 양품 수량
    private Integer totalNg; // 총 불량 수량
    private Integer totalProduced; // 총 생산량 (Good + NG)

    /**
     * 기본 생성자 - 모든 값을 0으로 초기화
     */
    public static ProductionResultSummary empty() {
        return ProductionResultSummary.builder()
                .totalGood(0)
                .totalNg(0)
                .totalProduced(0)
                .build();
    }

    /**
     * 불량률 계산
     */
    public Double calculateDefectRate() {
        if (totalProduced == null || totalProduced == 0) {
            return 0.0;
        }
        int ng = totalNg != null ? totalNg : 0;
        return (double) ng / totalProduced * 100.0;
    }
}
