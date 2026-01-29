package com.tp.mes.app.prod.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import com.tp.mes.app.prod.model.ProductionPlan;
import com.tp.mes.app.prod.model.ProductionBom;
import com.tp.mes.app.prod.model.ProductionResultSummary;
import java.util.List;

/**
 * Production Monitor Mapper - 실시간 생산 모니터링용 매퍼
 * 활성 계획, 실적 집계, BOM 조회 기능 제공
 */
@Mapper
public interface ProductionMonitorMapper {

    /**
     * 특정 라인의 활성 생산 계획 조회
     * - 상태가 IN_PROGRESS이거나
     * - 오늘 날짜의 SCHEDULED/PENDING 계획 중 우선순위가 가장 높은 것
     * 
     * @param lineId 생산 라인 ID
     * @return 활성 생산 계획 (없으면 null)
     */
    ProductionPlan findActivePlanByLineId(@Param("lineId") String lineId);

    /**
     * 특정 계획의 생산 실적 집계
     * - 양품/불량 수량을 합산
     * 
     * @param planId 생산 계획 ID
     * @return 생산 실적 집계 결과
     */
    ProductionResultSummary sumResultsByPlanId(@Param("planId") Long planId);

    /**
     * 특정 라인의 활성 BOM 목록 조회 (재고 정보 포함)
     * - is_active = 'Y'인 항목만
     * - 재고 테이블과 조인하여 품목 정보 포함
     * 
     * @param lineId 생산 라인 ID
     * @return BOM 목록 (재고 정보 포함)
     */
    List<ProductionBom> findActiveBomWithInventory(@Param("lineId") String lineId);

    /**
     * 공장 ID로 모든 라인 ID 조회
     * 
     * @param factoryId 공장 ID
     * @return 라인 ID 목록
     */
    List<String> findLineIdsByFactoryId(@Param("factoryId") String factoryId);
}
