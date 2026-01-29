package com.tp.mes.app.prod.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;

/**
 * Material Usage DTO - 자재 소모량 추적
 * BOM 기반으로 실시간 자재 사용량을 계산하여 반환
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class MaterialUsageDTO {

    private Long inventoryId; // 재고 아이템 ID
    private String itemCode; // 품목 코드
    private String itemName; // 품목명
    private BigDecimal consumptionRatePerUnit; // 단위당 소모율 (from BOM)
    private BigDecimal estimatedUsed; // 추정 사용량 (계산값)
    private String unit; // 단위 (KG, EA, L 등)
    private String notes; // 비고

    /**
     * 사용률 계산 (사용량/재고량 * 100)
     */
    public Double calculateUsagePercentage(BigDecimal currentStock) {
        if (currentStock == null || currentStock.compareTo(BigDecimal.ZERO) == 0) {
            return 0.0;
        }
        return estimatedUsed.divide(currentStock, 4, java.math.RoundingMode.HALF_UP)
                .multiply(new BigDecimal("100"))
                .doubleValue();
    }
}
