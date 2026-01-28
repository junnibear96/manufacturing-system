package com.tp.mes.app.factory.mapper;

import com.tp.mes.app.factory.model.ProductionLine;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

/**
 * 생산라인 MyBatis Mapper
 */
@Mapper
public interface ProductionLineMapper {

    /**
     * 모든 생산라인 조회
     */
    List<ProductionLine> findAll();

    /**
     * 공장별 생산라인 조회
     */
    List<ProductionLine> findByFactory(String factoryId);

    /**
     * 상태별 생산라인 조회
     */
    List<ProductionLine> findByStatus(String status);

    /**
     * 가동 중인 생산라인 조회
     */
    List<ProductionLine> findRunning();

    /**
     * ID로 생산라인 조회
     */
    Optional<ProductionLine> findById(String lineId);

    /**
     * 생산라인 등록
     */
    void insert(ProductionLine line);

    /**
     * 생산라인 수정
     */
    void update(ProductionLine line);

    /**
     * 생산라인 삭제
     */
    void delete(String lineId);

    /**
     * 생산라인 상태 변경
     */
    void updateStatus(String lineId, String status, Boolean isOperating);

    /**
     * 현재 투입 인원 업데이트
     */
    void updateCurrentWorkers(String lineId, int currentWorkers);

    /**
     * 가동률 업데이트
     */
    void updateUtilizationRate(String lineId, double utilizationRate);

    /**
     * 가동률 업데이트 (BigDecimal) - Simulation feature
     */
    void updateUtilizationRateDecimal(@Param("lineId") String lineId,
            @Param("utilizationRate") java.math.BigDecimal utilizationRate);

    /**
     * 공장별 생산라인 수
     */
    int countByFactory(String factoryId);

    /**
     * 현재 투입 인원 증가
     */
    void incrementWorkerCount(String lineId);

    /**
     * 현재 투입 인원 감소
     */
    void decrementWorkerCount(String lineId);
}
