package com.tp.mes.app.prod.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProductionDashboardDTO {
    private String planId;
    private String lineName;
    private String productCode;
    private long targetQuantity;
    private long currentQuantity; // Actual (Good)
    private double achievementRate; // %
    private double defectRate; // %

    private List<MaterialUsage> materialUsageList;

    @Data
    @Builder
    @NoArgsConstructor
    @AllArgsConstructor
    public static class MaterialUsage {
        private String materialName;
        private BigDecimal requiredPerUnit;
        private BigDecimal totalUsed; // Based on currentQuantity
        private BigDecimal currentStock;
    }
}
