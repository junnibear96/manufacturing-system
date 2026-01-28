package com.tp.mes.app.prod.repository;

import com.tp.mes.app.prod.model.EquipmentStatusHistory;
import java.util.List;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class AnalyticsRepository {

    private final JdbcTemplate jdbcTemplate;

    public AnalyticsRepository(JdbcTemplate jdbcTemplate) {
        this.jdbcTemplate = jdbcTemplate;
    }

    // Equipment History
    public void logStatusChange(Long equipmentId, String status) {
        // 1. Close open history for this equipment
        String closeSql = "UPDATE equipment_status_history SET end_time = SYSTIMESTAMP, duration_seconds = EXTRACT(SECOND FROM (SYSTIMESTAMP - start_time)) + EXTRACT(MINUTE FROM (SYSTIMESTAMP - start_time)) * 60 + EXTRACT(HOUR FROM (SYSTIMESTAMP - start_time)) * 3600 WHERE equipment_id = ? AND end_time IS NULL";
        jdbcTemplate.update(closeSql, equipmentId);

        // 2. Insert new status
        String insertSql = "INSERT INTO equipment_status_history (equipment_id, status) VALUES (?, ?)";
        jdbcTemplate.update(insertSql, equipmentId, status);
    }

    public List<EquipmentStatusHistory> getHistory(Long equipmentId) {
        String sql = "SELECT * FROM equipment_status_history WHERE equipment_id = ? ORDER BY start_time DESC";
        return jdbcTemplate.query(sql, (rs, rowNum) -> new EquipmentStatusHistory(
                rs.getLong("history_id"),
                rs.getLong("equipment_id"),
                rs.getString("status"),
                rs.getTimestamp("start_time").toLocalDateTime(),
                rs.getTimestamp("end_time") != null ? rs.getTimestamp("end_time").toLocalDateTime() : null,
                rs.getLong("duration_seconds"),
                rs.getTimestamp("created_at").toLocalDateTime()), equipmentId);
    }

    // Utilization Rate (Last 24 Hours)
    public Double calculateUtilization(Long equipmentId) {
        // Calculate total running seconds in last 24h
        String sql = "SELECT SUM(duration_seconds) FROM equipment_status_history " +
                "WHERE status = 'RUNNING' " +
                "AND start_time >= SYSTIMESTAMP - INTERVAL '1' DAY";
        try {
            if (equipmentId != null) {
                sql += " AND equipment_id = ?";
                Double runningSeconds = jdbcTemplate.queryForObject(sql, Double.class, equipmentId);
                return runningSeconds != null ? (runningSeconds / 86400.0) * 100.0 : 0.0;
            } else {
                // For all equipment
                Double runningSeconds = jdbcTemplate.queryForObject(sql, Double.class);
                // Count total equipment
                Integer totalEq = jdbcTemplate.queryForObject("SELECT COUNT(*) FROM equipment", Integer.class);
                if (totalEq == null || totalEq == 0)
                    return 0.0;
                return runningSeconds != null ? (runningSeconds / (86400.0 * totalEq)) * 100.0 : 0.0;
            }
        } catch (org.springframework.dao.DataAccessException e) {
            return 0.0;
        }
    }
}
