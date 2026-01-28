package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.EquipmentStatusHistory;
import com.tp.mes.app.prod.repository.AnalyticsRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

@Service
public class AnalyticsService {

    private final AnalyticsRepository analyticsRepository;

    public AnalyticsService(AnalyticsRepository analyticsRepository) {
        this.analyticsRepository = analyticsRepository;
    }

    @Transactional
    public void logStatusChange(Long equipmentId, String newStatus) {
        // Here we could add logic to check if status actually changed
        analyticsRepository.logStatusChange(equipmentId, newStatus);
    }

    public List<EquipmentStatusHistory> getEquipmentHistory(Long equipmentId) {
        return analyticsRepository.getHistory(equipmentId);
    }

    // Calculated in real-time or cached
    public Double getUtilizationRate(Long equipmentId) {
        return analyticsRepository.calculateUtilization(equipmentId);
    }
}
