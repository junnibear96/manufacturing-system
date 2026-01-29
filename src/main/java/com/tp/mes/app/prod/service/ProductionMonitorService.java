package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.dto.ProductionStatusDTO;
import java.util.List;

/**
 * Production Monitor Service - 실시간 생산 모니터링 서비스
 * 라인별/공장별 생산 현황, 자재 소모량 추적 기능 제공
 */
public interface ProductionMonitorService {

    /**
     * 특정 생산 라인의 실시간 현황 조회
     * - 현재 진행 중인 계획 정보
     * - 생산 진척도 (달성률, 불량률 등)
     * - 자재 소모량 (BOM 기반 계산)
     * 
     * @param lineId 생산 라인 ID
     * @return 생산 현황 DTO (활성 계획이 없으면 빈 상태 반환)
     */
    ProductionStatusDTO getLineStatus(String lineId);

    /**
     * 공장 전체의 생산 현황 조회
     * - 공장 내 모든 라인의 현황을 리스트로 반환
     * 
     * @param factoryId 공장 ID
     * @return 생산 현황 DTO 리스트
     */
    List<ProductionStatusDTO> getFactoryStatus(String factoryId);
}
