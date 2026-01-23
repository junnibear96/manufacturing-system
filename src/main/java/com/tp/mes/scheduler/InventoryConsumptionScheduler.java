package com.tp.mes.scheduler;

import com.tp.mes.app.inventory.service.InventoryConsumptionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

/**
 * Inventory Consumption Scheduler
 * 주기적으로 생산 라인의 재고 소진을 처리
 */
@Component
@EnableScheduling
public class InventoryConsumptionScheduler {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(InventoryConsumptionScheduler.class);

    private final InventoryConsumptionService consumptionService;

    public InventoryConsumptionScheduler(InventoryConsumptionService consumptionService) {
        this.consumptionService = consumptionService;
    }

    /**
     * 매 시간마다 실행 - 1시간 분량의 재고 소진
     * Cron: 초 분 시 일 월 요일
     */
    @Scheduled(cron = "0 0 * * * *")
    public void consumeInventoryHourly() {
        log.info("=== Hourly Inventory Consumption Started ===");
        try {
            consumptionService.consumeInventoryForAllLines(1.0);
        } catch (Exception e) {
            log.error("Hourly inventory consumption failed", e);
        }
        log.info("=== Hourly Inventory Consumption Completed ===");
    }

    /**
     * 매 10분마다 실행 - 0.167시간(10분) 분량의 재고 소진
     * 더 세밀한 시뮬레이션을 위한 옵션
     */
    // @Scheduled(fixedRate = 600000) // 10분 = 600,000ms
    public void consumeInventoryPeriodic() {
        log.debug("=== Periodic Inventory Consumption Started (10min) ===");
        try {
            consumptionService.consumeInventoryForAllLines(0.167);
        } catch (Exception e) {
            log.error("Periodic inventory consumption failed", e);
        }
        log.debug("=== Periodic Inventory Consumption Completed ===");
    }
}
