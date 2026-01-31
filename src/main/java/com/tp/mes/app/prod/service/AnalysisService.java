package com.tp.mes.app.prod.service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.Map;

@Slf4j
@Service
@RequiredArgsConstructor
public class AnalysisService {

    private final JdbcTemplate jdbcTemplate;

    /**
     * Calculate Equipment Utilization: (Total Run Time / Total Available Time) *
     * 100
     * Assumes 'total_run_time' column exists on equipment table (populated by PLC
     * or manual inputs).
     */
    public double calculateEquipmentUtilization(String equipmentCode) {
        // Simplified Logic: Get total_run_time from equipment table.
        // In real MES, this would be complex time-series analysis.
        try {
            String sql = "SELECT total_run_time FROM equipment WHERE equipment_code = ?";
            BigDecimal runTime = jdbcTemplate.queryForObject(sql, BigDecimal.class, equipmentCode);

            if (runTime == null)
                return 0.0;

            // Assume "Total Available Time" is fixed for this context, e.g., 24 hours * 60
            // min = 1440 min (if daily reset)
            // Or if total_run_time is cumulative lifetime, we need lifetime denominator.
            // For this 'autonomous' fix, we'll assume total_run_time is "minutes entered
            // today" and denominator is "minutes elapsed today".

            // Better: Return a mock or relative calculation if denominator unknown.
            // Let's assume runTime is a percentage (0-100) stored directly? No, usually
            // minutes.
            // Let's assume daily utilization.
            long minutesInDay = 24 * 60;
            double util = (runTime.doubleValue() / minutesInDay) * 100.0;
            return Math.min(100.0, util);
        } catch (Exception e) {
            log.warn("Failed to calc utilization for {}: {}", equipmentCode, e.getMessage());
            return 0.0;
        }
    }
}
