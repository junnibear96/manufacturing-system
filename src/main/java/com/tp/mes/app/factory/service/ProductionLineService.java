package com.tp.mes.app.factory.service;

import com.tp.mes.app.factory.mapper.ProductionLineMapper;
import com.tp.mes.app.factory.model.ProductionLine;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * Production Line Service
 * 생산 라인 비즈니스 로직 처리
 */
@Service
@Transactional
public class ProductionLineService {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(ProductionLineService.class);

    private final ProductionLineMapper productionLineMapper;

    public ProductionLineService(ProductionLineMapper productionLineMapper) {
        this.productionLineMapper = productionLineMapper;
    }

    /**
     * 모든 생산 라인 조회
     */
    public List<ProductionLine> getAllLines() {
        return productionLineMapper.findAll();
    }

    /**
     * 특정 공장의 생산 라인 조회
     */
    public List<ProductionLine> getLinesByFactory(String factoryId) {
        return productionLineMapper.findByFactory(factoryId);
    }

    /**
     * 가동 중인 라인 조회
     */
    public List<ProductionLine> getRunningLines() {
        return productionLineMapper.findRunning();
    }

    /**
     * ID로 라인 조회
     */
    public ProductionLine getLineById(String lineId) {
        return productionLineMapper.findById(lineId)
                .orElseThrow(() -> new IllegalArgumentException("Line not found: " + lineId));
    }

    /**
     * 라인 생성
     */
    @Transactional
    public void createLine(ProductionLine line) {
        log.info("Creating production line: {}", line.getLineId());
        productionLineMapper.insert(line);
    }

    /**
     * 라인 수정
     */
    @Transactional
    public void updateLine(ProductionLine line) {
        log.info("Updating production line: {}", line.getLineId());
        productionLineMapper.update(line);
    }

    /**
     * 라인 삭제
     */
    @Transactional
    public void deleteLine(String lineId) {
        log.info("Deleting production line: {}", lineId);
        productionLineMapper.delete(lineId);
    }

    /**
     * 가동률 업데이트 (Simulation feature)
     * 
     * @param lineId          라인 ID
     * @param utilizationRate 가동률 (0.00 ~ 100.00)
     */
    @Transactional
    public void updateUtilizationRate(String lineId, BigDecimal utilizationRate) {
        // 유효성 검증
        if (utilizationRate.compareTo(BigDecimal.ZERO) < 0 ||
                utilizationRate.compareTo(new BigDecimal("100")) > 0) {
            throw new IllegalArgumentException(
                    "Utilization rate must be between 0 and 100. Provided: " + utilizationRate);
        }

        log.info("Updating utilization rate for line {}: {}%", lineId, utilizationRate);
        productionLineMapper.updateUtilizationRateDecimal(lineId, utilizationRate);
    }

    /**
     * 라인 상태 변경
     */
    @Transactional
    public void updateStatus(String lineId, String status, Boolean isOperating) {
        log.info("Updating line {} status to: {}", lineId, status);
        productionLineMapper.updateStatus(lineId, status, isOperating);
    }

    /**
     * 투입 인원 업데이트
     */
    @Transactional
    public void updateCurrentWorkers(String lineId, int currentWorkers) {
        log.info("Updating line {} current workers to: {}", lineId, currentWorkers);
        productionLineMapper.updateCurrentWorkers(lineId, currentWorkers);
    }
}
