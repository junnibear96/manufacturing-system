package com.tp.mes.app.prod.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;

@Mapper
public interface EquipmentHistoryRepository {

    /**
     * Calculate Total Running Time in Seconds for a specific date and equipment
     */
    @Select("SELECT COALESCE(SUM(duration_seconds), 0) FROM equipment_history " +
            "WHERE equipment_id = #{equipmentId} " +
            "AND status = 'RUNNING' " +
            "AND TRUNC(created_at) = TO_DATE(#{targetDate}, 'YYYY-MM-DD')")
    long getTotalRunningSeconds(@Param("equipmentId") Long equipmentId, @Param("targetDate") String targetDate);

    /**
     * Get Total Available Time (Assuming 24h for simplicity, or we can use shift
     * info)
     * For now, returning 86400 (24 hours) as baseline
     */
    default long getTotalAvailableSeconds() {
        return 24 * 60 * 60;
    }
}
