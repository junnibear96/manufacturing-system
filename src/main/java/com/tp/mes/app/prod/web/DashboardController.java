package com.tp.mes.app.prod.web;

import com.tp.mes.app.prod.dto.ProductionDashboardDTO;
import com.tp.mes.app.prod.service.AnalysisService;
import com.tp.mes.app.prod.service.ProductionService;
import com.tp.mes.app.inventory.service.InventoryService;
import com.tp.mes.app.prod.model.ProdPlanItem;
import com.tp.mes.app.prod.model.ProdResultItem;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/dashboard")
@RequiredArgsConstructor
public class DashboardController {

    private final ProductionService productionService;
    private final InventoryService inventoryService;
    private final AnalysisService analysisService;

    @GetMapping("/realtime")
    public List<ProductionDashboardDTO> getRealTimeDashboard() {
        List<ProductionDashboardDTO> dashboardData = new ArrayList<>();

        // 1. Get Today's Plans
        List<ProdPlanItem> plans = productionService.listPlans(); // In real app, filter by today
        List<ProdResultItem> results = productionService.listResults();

        // Group results by Item Code
        Map<String, Long> actualsByItem = results.stream()
                .collect(Collectors.groupingBy(
                        ProdResultItem::getItemCode,
                        Collectors.summingLong(r -> parseLong(r.getQtyGood()))));

        Map<String, Long> ngByItem = results.stream()
                .collect(Collectors.groupingBy(
                        ProdResultItem::getItemCode,
                        Collectors.summingLong(r -> parseLong(r.getQtyNg()))));

        // Build DTOs
        for (ProdPlanItem plan : plans) {
            String itemCode = plan.getItemCode();
            long target = parseLong(plan.getQtyPlan());
            long actual = actualsByItem.getOrDefault(itemCode, 0L);
            long ng = ngByItem.getOrDefault(itemCode, 0L);
            long total = actual + ng;

            double achievement = (target > 0) ? (double) actual / target * 100.0 : 0.0;
            double defectRate = (total > 0) ? (double) ng / total * 100.0 : 0.0;

            // Material Usage (Mock or calc via BOM)
            // For MVP, simple list
            List<ProductionDashboardDTO.MaterialUsage> materialUsages = new ArrayList<>();
            // In real app, fetch BOM and calc usage

            dashboardData.add(ProductionDashboardDTO.builder()
                    .planId(String.valueOf(plan.getPlanId()))
                    .lineName("Line-1") // Placeholder
                    .productCode(itemCode)
                    .targetQuantity(target)
                    .currentQuantity(actual)
                    .achievementRate(achievement)
                    .defectRate(defectRate)
                    .materialUsageList(materialUsages)
                    .build());
        }

        return dashboardData;
    }

    private long parseLong(String s) {
        try {
            return Long.parseLong(s);
        } catch (Exception e) {
            return 0;
        }
    }
}
