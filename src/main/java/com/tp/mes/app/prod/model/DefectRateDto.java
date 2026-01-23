package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDate;

/**
 * 불량률 분석 DTO
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class DefectRateDto {

    private LocalDate workDate;
    private String lineId;
    private String lineName;
    private String itemCode;

    private Integer totalGood;
    private Integer totalDefect;
    private Double defectRate;

    /**
     * 불량률이 높은지 확인 (기준: 5%)
     */
    public boolean isHighDefectRate() {
        return defectRate != null && defectRate > 5.0;
    }

    /**
     * 불량률이 심각한지 확인 (기준: 10%)
     */
    public boolean isCriticalDefectRate() {
        return defectRate != null && defectRate > 10.0;
    }

    /**
     * 총 생산량 (양품 + 불량)
     */
    public Integer getTotalProduction() {
        return (totalGood == null ? 0 : totalGood) + (totalDefect == null ? 0 : totalDefect);
    }
}
