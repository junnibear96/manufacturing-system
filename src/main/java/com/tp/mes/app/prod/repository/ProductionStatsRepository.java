package com.tp.mes.app.prod.repository;

import com.tp.mes.app.prod.model.DailyProductionSummary;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Select;
import java.util.List;

@Mapper
public interface ProductionStatsRepository {

    @Select("SELECT " +
            "  TO_CHAR(r.work_date, 'YYYY-MM-DD') as workDate, " +
            "  e.equipment_name as lineName, " +
            "  r.item_code as itemCode, " +
            "  'N/A' as itemName, " + // Simplified, assuming no join with Item Master yet
            "  NVL(p.qty_plan, 0) as targetQty, " +
            "  SUM(r.qty_good) as actualQty, " +
            "  SUM(r.qty_ng) as ngQty, " +
            "  CASE WHEN NVL(p.qty_plan, 0) > 0 " +
            "       THEN ROUND((SUM(r.qty_good) / p.qty_plan) * 100, 2) " +
            "       ELSE 0 END as achieveRate " +
            "FROM production_result r " +
            "LEFT JOIN equipment e ON r.equipment_id = e.equipment_id " +
            "LEFT JOIN production_plan p ON r.item_code = p.item_code AND r.work_date = p.plan_date " +
            "WHERE r.work_date = TO_DATE(#{date}, 'YYYY-MM-DD') " +
            "GROUP BY r.work_date, e.equipment_name, r.item_code, p.qty_plan")
    List<DailyProductionSummary> getDailySummary(@Param("date") String date);
}
