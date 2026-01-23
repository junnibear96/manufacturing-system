package com.tp.mes.app.prod.mapper;

import com.tp.mes.app.prod.model.*;
import org.apache.ibatis.annotations.*;
import java.time.LocalDate;
import java.util.List;

/**
 * Production Analysis MyBatis Mapper
 */
@Mapper
public interface ProductionAnalysisMapper {

    /**
     * 계획 대비 실적 분석
     */
    PlanAchievementReport analyzePlanAchievement(@Param("planId") Long planId);

    /**
     * 일별 달성률 조회
     */
    List<DailyAchievementDto> getDailyAchievementRate(
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);

    /**
     * 라인별 불량률 조회
     */
    List<DefectRateDto> getDefectRateByLine(
            @Param("startDate") LocalDate startDate,
            @Param("endDate") LocalDate endDate);

    /**
     * 일자별 KPI 요약
     */
    ProductionKpiSummary getKpiSummary(@Param("date") LocalDate date);
}
