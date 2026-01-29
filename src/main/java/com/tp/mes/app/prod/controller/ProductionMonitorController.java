package com.tp.mes.app.prod.controller;

import com.tp.mes.app.prod.dto.ProductionStatusDTO;
import com.tp.mes.app.prod.service.ProductionMonitorService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

/**
 * Production Monitor Controller - 실시간 생산 모니터링 API
 * 라인별/공장별 생산 현황 및 자재 소모량 조회 엔드포인트 제공
 */
@Slf4j
@RestController
@RequestMapping("/api/production/monitor")
@RequiredArgsConstructor
@CrossOrigin(origins = "*") // CORS 허용 (필요시 제한)
public class ProductionMonitorController {

    private final ProductionMonitorService productionMonitorService;

    /**
     * 특정 생산 라인의 실시간 현황 조회
     * 
     * GET /api/production/monitor/line/{lineId}
     * 
     * @param lineId 생산 라인 ID
     * @return 생산 현황 DTO (200 OK)
     * 
     *         Example Response:
     *         {
     *         "lineId": "LINE_ASSEMBLY_001",
     *         "lineName": "조립 라인 1",
     *         "currentProductCode": "PROD-A100",
     *         "metrics": {
     *         "targetQuantity": 1000,
     *         "actualGoodQuantity": 750,
     *         "achievementRate": 75.0,
     *         "defectRate": 3.2
     *         },
     *         "materialUsage": [...]
     *         }
     */
    @GetMapping("/line/{lineId}")
    public ResponseEntity<ProductionStatusDTO> getLineStatus(@PathVariable String lineId) {
        log.info("GET /api/production/monitor/line/{}", lineId);

        try {
            ProductionStatusDTO status = productionMonitorService.getLineStatus(lineId);
            return ResponseEntity.ok(status);

        } catch (Exception e) {
            log.error("Error getting line status for: {}", lineId, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * 공장 전체의 생산 현황 조회
     * 
     * GET /api/production/monitor/factory/{factoryId}
     * 
     * @param factoryId 공장 ID
     * @return 생산 현황 DTO 리스트 (200 OK)
     * 
     *         Example Response:
     *         [
     *         { "lineId": "LINE_001", "metrics": {...}, ... },
     *         { "lineId": "LINE_002", "metrics": {...}, ... }
     *         ]
     */
    @GetMapping("/factory/{factoryId}")
    public ResponseEntity<List<ProductionStatusDTO>> getFactoryStatus(@PathVariable String factoryId) {
        log.info("GET /api/production/monitor/factory/{}", factoryId);

        try {
            List<ProductionStatusDTO> statuses = productionMonitorService.getFactoryStatus(factoryId);
            return ResponseEntity.ok(statuses);

        } catch (Exception e) {
            log.error("Error getting factory status for: {}", factoryId, e);
            return ResponseEntity.internalServerError().build();
        }
    }

    /**
     * Health Check Endpoint
     * 
     * GET /api/production/monitor/health
     * 
     * @return Simple status message
     */
    @GetMapping("/health")
    public ResponseEntity<String> healthCheck() {
        return ResponseEntity.ok("Production Monitor API is running");
    }
}
