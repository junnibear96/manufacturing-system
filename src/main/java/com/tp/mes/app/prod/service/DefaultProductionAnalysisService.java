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

    public DefaultProductionAnalysisService(ProductionAnalysisMapper analysisMapper,
            com.tp.mes.app.prod.repository.ProductionRepository productionRepository,
            com.tp.mes.app.prod.service.AnalyticsService analyticsService) {
        this.analysisMapper = analysisMapper;
        this.productionRepository = productionRepository;
        this.analyticsService = analyticsService;
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
        String dateStr = date.toString();
        List<com.tp.mes.app.prod.model.DailyProductionSummary> summaries = productionRepository
                .getDailySummary(dateStr);

        int totalTarget = summaries.stream().mapToInt(s -> Integer.parseInt(s.getTargetQty())).sum();
        int totalActual = summaries.stream().mapToInt(s -> Integer.parseInt(s.getActualQty())).sum();
        int totalNG = summaries.stream().mapToInt(s -> Integer.parseInt(s.getNgQty())).sum();

        return ProductionKpiSummary.builder()
                .totalPlans(summaries.size()) // Count of items planned
                .todayTargetQuantity(totalTarget)
                .todayActualQuantity(totalActual)
                .todayTotalGood(totalActual)
                .todayTotalDefect(totalNG)
                .todayAchievementRate(totalTarget > 0 ? (double) totalActual / totalTarget * 100 : 0.0)
                .todayDefectRate(totalActual + totalNG > 0 ? (double) totalNG / (totalActual + totalNG) * 100 : 0.0)
                .totalEquipment(10) // Placeholder
                .runningEquipment(5) // Placeholder
                .equipmentUtilizationRate(analyticsService.getUtilizationRate(null))
                .build();
    }

    @Override
    public ProductionKpiSummary getTodayKpiSummary() {
        return getKpiSummary(LocalDate.now());
    }
}
