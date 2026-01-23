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

    public DefaultProductionAnalysisService(ProductionAnalysisMapper analysisMapper) {
        this.analysisMapper = analysisMapper;
    }

    @Override
    public PlanAchievementReport analyzePlanAchievement(Long planId) {
        log.debug("Analyzing plan achievement for plan ID: {}", planId);
        return analysisMapper.analyzePlanAchievement(planId);
    }

    @Override
    public List<DailyAchievementDto> getDailyAchievementRate(LocalDate startDate, LocalDate endDate) {
        log.debug("Getting daily achievement rate from {} to {}", startDate, endDate);
        return analysisMapper.getDailyAchievementRate(startDate, endDate);
    }

    @Override
    public List<DefectRateDto> getDefectRateByLine(LocalDate startDate, LocalDate endDate) {
        log.debug("Getting defect rate by line from {} to {}", startDate, endDate);
        return analysisMapper.getDefectRateByLine(startDate, endDate);
    }

    @Override
    public ProductionKpiSummary getKpiSummary(LocalDate date) {
        log.debug("Getting KPI summary for date: {}", date);
        ProductionKpiSummary summary = analysisMapper.getKpiSummary(date);

        // Null-safe defaults
        if (summary == null) {
            log.warn("No KPI summary found for date: {}", date);
            return ProductionKpiSummary.builder()
                    .totalPlans(0)
                    .completedPlans(0)
                    .inProgressPlans(0)
                    .todayTargetQuantity(0)
                    .todayActualQuantity(0)
                    .todayAchievementRate(0.0)
                    .todayTotalGood(0)
                    .todayTotalDefect(0)
                    .todayDefectRate(0.0)
                    .totalEquipment(0)
                    .runningEquipment(0)
                    .maintenanceEquipment(0)
                    .errorEquipment(0)
                    .equipmentUtilizationRate(0.0)
                    .build();
        }

        return summary;
    }

    @Override
    public ProductionKpiSummary getTodayKpiSummary() {
        return getKpiSummary(LocalDate.now());
    }
}
