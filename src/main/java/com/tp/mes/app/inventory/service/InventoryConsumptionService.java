package com.tp.mes.app.inventory.service;

import com.tp.mes.app.factory.mapper.ProductionLineMapper;
import com.tp.mes.app.factory.model.ProductionLine;
import com.tp.mes.app.inventory.service.InventoryService;
import com.tp.mes.app.prod.mapper.ProductionBomMapper;
import com.tp.mes.app.prod.model.ProductionBom;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.List;

/**
 * Inventory Consumption Service
 * 생산 라인 가동에 따른 자동 재고 소진 로직
 */
@Service
public class InventoryConsumptionService {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(InventoryConsumptionService.class);

    private final ProductionLineMapper lineMapper;
    private final ProductionBomMapper bomMapper;
    private final InventoryService inventoryService;

    public InventoryConsumptionService(ProductionLineMapper lineMapper, ProductionBomMapper bomMapper,
            InventoryService inventoryService) {
        this.lineMapper = lineMapper;
        this.bomMapper = bomMapper;
        this.inventoryService = inventoryService;
    }

    /**
     * 가동 중인 모든 라인의 재고 소진 처리
     * 
     * @param hours 경과 시간
     */
    @Transactional
    public void consumeInventoryForAllLines(double hours) {
        log.info("Starting inventory consumption for all active lines. Hours: {}", hours);

        // 가동 중인 라인 조회 (utilization_rate > 0)
        List<ProductionLine> allLines = lineMapper.findAll();
        int processedLines = 0;
        int skippedLines = 0;

        for (ProductionLine line : allLines) {
            if (line.getUtilizationRateDecimal() != null &&
                    line.getUtilizationRateDecimal().compareTo(BigDecimal.ZERO) > 0) {
                try {
                    consumeInventoryForLine(line, hours);
                    processedLines++;
                } catch (Exception e) {
                    log.error("Failed to consume inventory for line {}: {}",
                            line.getLineId(), e.getMessage());
                    skippedLines++;
                }
            }
        }

        log.info("Inventory consumption completed. Processed: {}, Skipped: {}",
                processedLines, skippedLines);
    }

    /**
     * 특정 라인의 재고 소진
     * 
     * @param line  생산 라인
     * @param hours 경과 시간
     */
    @Transactional
    public void consumeInventoryForLine(ProductionLine line, double hours) {
        // 해당 라인의 BOM 조회
        List<ProductionBom> bomList = bomMapper.findActiveByLineId(line.getLineId());

        if (bomList.isEmpty()) {
            log.debug("No BOM found for line {}. Skipping consumption.", line.getLineId());
            return;
        }

        log.debug("Processing {} BOM items for line {} (utilization: {}%)",
                bomList.size(), line.getLineId(), line.getUtilizationRateDecimal());

        for (ProductionBom bom : bomList) {
            try {
                // 실제 소모량 계산
                BigDecimal actualConsumption = bom.calculateActualConsumption(
                        line.getUtilizationRateDecimal(), hours);

                // 재고 차감
                inventoryService.issueStock(
                        bom.getInventoryId(),
                        actualConsumption,
                        "AUTO_CONSUMPTION",
                        "Line: " + line.getLineName() + " (" + line.getUtilizationRateDecimal() + "% util, " + hours
                                + "h)",
                        "SYSTEM");

                log.debug("Consumed {} {} from inventory {} for line {}",
                        actualConsumption, bom.getUnit(), bom.getInventoryId(), line.getLineId());

            } catch (Exception e) {
                // 재고 부족 등의 에러 발생 시 로그만 남기고 계속 진행
                log.warn("Failed to consume inventory {} for line {}: {}",
                        bom.getInventoryId(), line.getLineId(), e.getMessage());
            }
        }
    }

    /**
     * 특정 라인의 재고 소진 (수동 트리거)
     * 
     * @param lineId 라인 ID
     * @param hours  경과 시간
     */
    @Transactional
    public void consumeInventoryForLine(String lineId, double hours) {
        ProductionLine line = lineMapper.findById(lineId)
                .orElseThrow(() -> new IllegalArgumentException("Line not found: " + lineId));

        consumeInventoryForLine(line, hours);
    }
}
