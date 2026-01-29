package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.DailyProductionSummary;
import com.tp.mes.app.prod.repository.EquipmentHistoryRepository;
import com.tp.mes.app.prod.repository.ProductionStatsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class ProductionAnalyticsService {

    private final EquipmentHistoryRepository equipmentHistoryRepository;
    private final ProductionStatsRepository productionStatsRepository;

    /**
     * Calculate Utilization Rate (%) for a specific equipment on a date
     */
    public double calculateUtilization(Long equipmentId, String date) {
        long runningSeconds = equipmentHistoryRepository.getTotalRunningSeconds(equipmentId, date);
        long availableSeconds = equipmentHistoryRepository.getTotalAvailableSeconds();

        if (availableSeconds == 0)
            return 0.0;

        return ((double) runningSeconds / availableSeconds) * 100.0;
    }

    /**
     * Get aggregated daily production summary
     */
    public List<DailyProductionSummary> getDailyProductionSummary(String date) {
        return productionStatsRepository.getDailySummary(date);
    }
}
