package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.mapper.ProductionAnalysisMapper;
import com.tp.mes.app.prod.model.*;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.time.LocalDate;
import java.util.List;

/**
 * Production Analysis Service Implementation
 */
@Service
public class DefaultProductionAnalysisService implements ProductionAnalysisService {

        private static final org.slf4j.Logger log = org.slf4j.LoggerFactory
                        .getLogger(DefaultProductionAnalysisService.class);

        private final ProductionAnalysisMapper analysisMapper;
        private final com.tp.mes.app.prod.repository.ProductionRepository productionRepository;
        private final com.tp.mes.app.prod.service.AnalyticsService analyticsService;
        private final com.tp.mes.app.prod.service.EquipmentService equipmentService;

        public DefaultProductionAnalysisService(ProductionAnalysisMapper analysisMapper,
                        com.tp.mes.app.prod.repository.ProductionRepository productionRepository,
                        com.tp.mes.app.prod.service.AnalyticsService analyticsService,
                        com.tp.mes.app.prod.service.EquipmentService equipmentService) {
                this.analysisMapper = analysisMapper;
                this.productionRepository = productionRepository;
                this.analyticsService = analyticsService;
                this.equipmentService = equipmentService;
        }

        @Override
        public PlanAchievementReport analyzePlanAchievement(Long planId) {
                return analysisMapper.analyzePlanAchievement(planId);
        }

        @Override
        public List<DailyAchievementDto> getDailyAchievementRate(LocalDate startDate, LocalDate endDate) {
                List<DailyAchievementDto> result = new java.util.ArrayList<>();

                for (LocalDate date = startDate; !date.isAfter(endDate); date = date.plusDays(1)) {
                        String dateStr = date.toString();
                        List<com.tp.mes.app.prod.model.DailyProductionSummary> summaries = productionRepository
                                        .getDailySummary(dateStr);

                        // Aggregate all items for the day into one DTO (or return multiple if per-line
                        // supported)
                        // The dashboard seems to expect per-line or per-day.
                        // Let's assume daily totals for now.
                        int totalTarget = summaries.stream().mapToInt(s -> Integer.parseInt(s.getTargetQty())).sum();
                        int totalActual = summaries.stream().mapToInt(s -> Integer.parseInt(s.getActualQty())).sum();
                        int planCount = summaries.size(); // Approximation
                        double rate = totalTarget > 0 ? (double) totalActual / totalTarget * 100 : 0.0;

                        DailyAchievementDto dto = DailyAchievementDto.builder()
                                        .workDate(date)
                                        .lineName("TOTAL") // Aggregated
                                        .totalTarget(totalTarget)
                                        .totalActual(totalActual)
                                        .achievementRate(rate)
                                        .planCount(planCount)
                                        .completedPlanCount(planCount) // Placeholder
                                        .build();
                        result.add(dto);
                }
                return result;
        }

        @Override
        public List<DefectRateDto> getDefectRateByLine(LocalDate startDate, LocalDate endDate) {
                return analysisMapper.getDefectRateByLine(startDate, endDate);
        }

        @Override
        public ProductionKpiSummary getKpiSummary(LocalDate date) {
                log.debug("Calculating KPI summary for date: {}", date);

                try {
                        String dateStr = date.toString();
                        List<com.tp.mes.app.prod.model.DailyProductionSummary> summaries = productionRepository
                                        .getDailySummary(dateStr);

                        // Calculate production statistics
                        int totalTarget = summaries.stream()
                                        .mapToInt(s -> parseIntSafely(s.getTargetQty()))
                                        .sum();
                        int totalActual = summaries.stream()
                                        .mapToInt(s -> parseIntSafely(s.getActualQty()))
                                        .sum();
                        int totalNG = summaries.stream()
                                        .mapToInt(s -> parseIntSafely(s.getNgQty()))
                                        .sum();

                        // Get real equipment statistics
                        List<com.tp.mes.app.prod.model.Equipment> allEquipment = equipmentService.listAllEquipment();

                        if (allEquipment == null) {
                                log.warn("Equipment list is null, using empty list");
                                allEquipment = java.util.Collections.emptyList();
                        }

                        int totalEquipment = allEquipment.size();

                        // Count equipment by status using single stream pass for better performance
                        java.util.Map<com.tp.mes.app.prod.model.EquipmentStatus, Long> statusCounts = allEquipment
                                        .stream()
                                        .filter(e -> e.getStatus() != null)
                                        .collect(java.util.stream.Collectors.groupingBy(
                                                        com.tp.mes.app.prod.model.Equipment::getStatus,
                                                        java.util.stream.Collectors.counting()));

                        int runningEquipment = statusCounts.getOrDefault(
                                        com.tp.mes.app.prod.model.EquipmentStatus.RUNNING, 0L).intValue();
                        int maintenanceEquipment = statusCounts.getOrDefault(
                                        com.tp.mes.app.prod.model.EquipmentStatus.MAINTENANCE, 0L).intValue();
                        int errorEquipment = statusCounts.getOrDefault(
                                        com.tp.mes.app.prod.model.EquipmentStatus.ERROR, 0L).intValue();

                        // Calculate average utilization rate
                        double avgUtilization = allEquipment.stream()
                                        .map(com.tp.mes.app.prod.model.Equipment::getUtilizationRate)
                                        .filter(rate -> rate != null && rate >= 0 && rate <= 100)
                                        .mapToDouble(Double::doubleValue)
                                        .average()
                                        .orElse(0.0);

                        log.debug("KPI Summary: Total Equipment={}, Running={}, Maintenance={}, Error={}, Avg Utilization={}",
                                        totalEquipment, runningEquipment, maintenanceEquipment, errorEquipment,
                                        avgUtilization);

                        return ProductionKpiSummary.builder()
                                        .totalPlans(summaries.size())
                                        .todayTargetQuantity(totalTarget)
                                        .todayActualQuantity(totalActual)
                                        .todayTotalGood(totalActual)
                                        .todayTotalDefect(totalNG)
                                        .todayAchievementRate(calculatePercentage(totalActual, totalTarget))
                                        .todayDefectRate(calculatePercentage(totalNG, totalActual + totalNG))
                                        .totalEquipment(totalEquipment)
                                        .runningEquipment(runningEquipment)
                                        .maintenanceEquipment(maintenanceEquipment)
                                        .errorEquipment(errorEquipment)
                                        .equipmentUtilizationRate(avgUtilization)
                                        .build();
                } catch (Exception e) {
                        log.error("Error calculating KPI summary for date: {}", date, e);
                        // Return empty KPI summary on error to prevent dashboard from crashing
                        return ProductionKpiSummary.builder()
                                        .totalPlans(0)
                                        .todayTargetQuantity(0)
                                        .todayActualQuantity(0)
                                        .todayTotalGood(0)
                                        .todayTotalDefect(0)
                                        .todayAchievementRate(0.0)
                                        .todayDefectRate(0.0)
                                        .totalEquipment(0)
                                        .runningEquipment(0)
                                        .maintenanceEquipment(0)
                                        .errorEquipment(0)
                                        .equipmentUtilizationRate(0.0)
                                        .build();
                }
        }

        /**
         * Safely calculate percentage avoiding division by zero
         * 
         * @param numerator   the numerator
         * @param denominator the denominator
         * @return percentage value or 0.0 if denominator is 0
         */
        private double calculatePercentage(int numerator, int denominator) {
                return denominator > 0 ? (double) numerator / denominator * 100.0 : 0.0;
        }

        /**
         * Safely parse integer from string, returning 0 on error
         * 
         * @param value the string value to parse
         * @return parsed integer or 0 on error
         */
        private int parseIntSafely(String value) {
                try {
                        return value != null && !value.trim().isEmpty() ? Integer.parseInt(value.trim()) : 0;
                } catch (NumberFormatException e) {
                        log.warn("Failed to parse integer value: '{}', using 0", value);
                        return 0;
                }
        }

        @Override
        public ProductionKpiSummary getTodayKpiSummary() {
                return getKpiSummary(LocalDate.now());
        }
}
