package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.dto.LiveProductionMetricsDTO;
import com.tp.mes.app.prod.dto.MaterialUsageDTO;
import com.tp.mes.app.prod.dto.ProductionStatusDTO;
import com.tp.mes.app.prod.mapper.ProductionMonitorMapper;
import com.tp.mes.app.prod.model.PlanStatus;
import com.tp.mes.app.prod.model.ProductionBom;
import com.tp.mes.app.prod.model.ProductionPlan;
import com.tp.mes.app.prod.model.ProductionResultSummary;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDateTime;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Default Production Monitor Service Implementation
 * 실시간 생산 모니터링 서비스 구현
 */
@Slf4j
@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DefaultProductionMonitorService implements ProductionMonitorService {

    private final ProductionMonitorMapper productionMonitorMapper;

    @Override
    public ProductionStatusDTO getLineStatus(String lineId) {
        log.debug("Getting production status for line: {}", lineId);

        try {
            // Step 1: Find active production plan
            ProductionPlan activePlan = productionMonitorMapper.findActivePlanByLineId(lineId);

            if (activePlan == null) {
                log.debug("No active plan found for line: {}", lineId);
                return buildEmptyStatus(lineId);
            }

            log.debug("Found active plan: {} for line: {}", activePlan.getPlanId(), lineId);

            // Step 2: Sum production results
            ProductionResultSummary summary = productionMonitorMapper.sumResultsByPlanId(activePlan.getPlanId());
            if (summary == null) {
                summary = ProductionResultSummary.empty();
            }

            log.debug("Production summary - Good: {}, NG: {}, Total: {}",
                    summary.getTotalGood(), summary.getTotalNg(), summary.getTotalProduced());

            // Step 3: Calculate production metrics
            LiveProductionMetricsDTO metrics = calculateMetrics(activePlan, summary);

            // Step 4: Get BOM and calculate material usage
            List<ProductionBom> boms = productionMonitorMapper.findActiveBomWithInventory(lineId);
            if (boms == null) {
                boms = Collections.emptyList();
            }

            List<MaterialUsageDTO> materialUsage = calculateMaterialUsage(boms, summary.getTotalGood());

            log.debug("Calculated material usage for {} BOM items", materialUsage.size());

            // Step 5: Build and return response
            return ProductionStatusDTO.builder()
                    .lineId(lineId)
                    .lineName(extractLineName(lineId)) // TODO: Join with Line table if needed
                    .currentProductCode(activePlan.getItemCode())
                    .currentProductName(null) // TODO: Join with Product/Inventory table if needed
                    .planStatus(activePlan.getStatus())
                    .metrics(metrics)
                    .materialUsage(materialUsage)
                    .lastUpdated(LocalDateTime.now())
                    .workDate(activePlan.getPlanDate())
                    .build();

        } catch (Exception e) {
            log.error("Error getting production status for line: {}", lineId, e);
            return buildEmptyStatus(lineId);
        }
    }

    @Override
    public List<ProductionStatusDTO> getFactoryStatus(String factoryId) {
        log.debug("Getting production status for factory: {}", factoryId);

        try {
            // Get all line IDs in the factory
            List<String> lineIds = productionMonitorMapper.findLineIdsByFactoryId(factoryId);

            if (lineIds == null || lineIds.isEmpty()) {
                log.warn("No production lines found for factory: {}", factoryId);
                return Collections.emptyList();
            }

            log.debug("Found {} lines in factory: {}", lineIds.size(), factoryId);

            // Get status for each line
            return lineIds.stream()
                    .map(this::getLineStatus)
                    .filter(status -> status.hasActivePlan()) // Only include lines with active plans
                    .collect(Collectors.toList());

        } catch (Exception e) {
            log.error("Error getting factory status for: {}", factoryId, e);
            return Collections.emptyList();
        }
    }

    // ==================== Private Helper Methods ====================

    /**
     * Calculate production metrics (achievement rate, defect rate, etc.)
     */
    private LiveProductionMetricsDTO calculateMetrics(ProductionPlan plan, ProductionResultSummary summary) {
        int target = plan.getEffectiveTargetQuantity();
        int actualGood = summary.getTotalGood() != null ? summary.getTotalGood() : 0;
        int actualNg = summary.getTotalNg() != null ? summary.getTotalNg() : 0;
        int totalProduced = summary.getTotalProduced() != null ? summary.getTotalProduced() : 0;

        double achievementRate = calculatePercentage(actualGood, target);
        double defectRate = calculatePercentage(actualNg, totalProduced);

        int remaining = Math.max(0, target - actualGood);
        String statusIndicator = determineStatusIndicator(achievementRate);

        return LiveProductionMetricsDTO.builder()
                .targetQuantity(target)
                .actualGoodQuantity(actualGood)
                .actualNgQuantity(actualNg)
                .totalProduced(totalProduced)
                .achievementRate(achievementRate)
                .defectRate(defectRate)
                .remainingQuantity(remaining)
                .statusIndicator(statusIndicator)
                .build();
    }

    /**
     * Calculate material usage based on BOM and produced quantity
     */
    private List<MaterialUsageDTO> calculateMaterialUsage(List<ProductionBom> boms, Integer producedQty) {
        if (producedQty == null || producedQty == 0) {
            // No production yet, return empty list
            return Collections.emptyList();
        }

        return boms.stream()
                .map(bom -> {
                    BigDecimal consumptionRate = bom.getConsumptionRate();
                    if (consumptionRate == null) {
                        consumptionRate = BigDecimal.ZERO;
                    }

                    // Calculate estimated usage: consumption_rate * produced_qty
                    BigDecimal estimatedUsed = consumptionRate.multiply(new BigDecimal(producedQty));

                    return MaterialUsageDTO.builder()
                            .inventoryId(bom.getInventoryId())
                            .itemCode(bom.getItemCode())
                            .itemName(bom.getItemName())
                            .consumptionRatePerUnit(consumptionRate)
                            .estimatedUsed(estimatedUsed)
                            .unit(bom.getUnit())
                            .notes(bom.getNotes())
                            .build();
                })
                .collect(Collectors.toList());
    }

    /**
     * Calculate percentage safely (handles division by zero)
     */
    private double calculatePercentage(int numerator, int denominator) {
        if (denominator == 0) {
            return 0.0;
        }
        return (double) numerator / denominator * 100.0;
    }

    /**
     * Determine status indicator based on achievement rate
     */
    private String determineStatusIndicator(double achievementRate) {
        if (achievementRate >= 95.0) {
            return "AHEAD"; // Ahead of schedule
        } else if (achievementRate >= 80.0) {
            return "ON_TRACK"; // On track
        } else {
            return "BEHIND"; // Behind schedule
        }
    }

    /**
     * Build empty status (no active plan)
     */
    private ProductionStatusDTO buildEmptyStatus(String lineId) {
        return ProductionStatusDTO.builder()
                .lineId(lineId)
                .lineName(extractLineName(lineId))
                .currentProductCode(null)
                .currentProductName(null)
                .planStatus(null)
                .metrics(LiveProductionMetricsDTO.builder()
                        .targetQuantity(0)
                        .actualGoodQuantity(0)
                        .actualNgQuantity(0)
                        .totalProduced(0)
                        .achievementRate(0.0)
                        .defectRate(0.0)
                        .remainingQuantity(0)
                        .statusIndicator("IDLE")
                        .build())
                .materialUsage(Collections.emptyList())
                .lastUpdated(LocalDateTime.now())
                .workDate(null)
                .build();
    }

    /**
     * Extract line name from line ID (temporary until proper join is implemented)
     */
    private String extractLineName(String lineId) {
        // TODO: Implement proper line name lookup via join or separate query
        return lineId; // For now, just return the ID
    }
}
