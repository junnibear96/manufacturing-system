package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.*;
import java.time.LocalDate;
import java.util.List;

/**
 * Production Analysis Service Interface
 */
public interface ProductionAnalysisService {

    /**
     * 계획 대비 실적 분석
     */
    PlanAchievementReport analyzePlanAchievement(Long planId);

    /**
     * 일별 달성률 조회
     */
    List<DailyAchievementDto> getDailyAchievementRate(LocalDate startDate, LocalDate endDate);

    /**
     * 라인별 불량률 조회
     */
    List<DefectRateDto> getDefectRateByLine(LocalDate startDate, LocalDate endDate);

    /**
     * KPI 요약 조회
     */
    ProductionKpiSummary getKpiSummary(LocalDate date);

    /**
     * 최근 7일 KPI 요약
     */
    ProductionKpiSummary getTodayKpiSummary();
}
