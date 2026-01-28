package com.tp.mes.app.prod.repository;

import com.tp.mes.app.prod.model.EquipmentItem;
import com.tp.mes.app.prod.model.ProcessItem;
import com.tp.mes.app.prod.model.ProdPlanItem;
import com.tp.mes.app.prod.model.ProdResultItem;
import com.tp.mes.app.prod.model.QtyStatRow;
import com.tp.mes.support.OracleErrorSupport;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

@Repository
public class JdbcProductionRepository implements ProductionRepository {

  private static final Logger log = LoggerFactory.getLogger(JdbcProductionRepository.class);

  private final JdbcTemplate jdbcTemplate;
  private final SimpleJdbcInsert insertPlan;
  private final SimpleJdbcInsert insertResult;

  public JdbcProductionRepository(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
    this.insertPlan = new SimpleJdbcInsert(jdbcTemplate)
        .withTableName("production_plan")
        .usingGeneratedKeyColumns("plan_id");
    this.insertResult = new SimpleJdbcInsert(jdbcTemplate)
        .withTableName("production_result")
        .usingGeneratedKeyColumns("result_id");
  }

  @Override
  public List<ProcessItem> listProcesses() {
    try {
      return jdbcTemplate.query(
          "select process_id, process_code, process_name from production_process order by process_code",
          (rs, rowNum) -> new ProcessItem(
              rs.getLong("process_id"),
              rs.getString("process_code"),
              rs.getString("process_name")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_process table not found; returning fallback processes. Run scripts/oracle-init.sql");
        return List.of(new ProcessItem(1L, "PROC", "Process (fallback)"));
      }
      throw ex;
    }
  }

  @Override
  public List<EquipmentItem> listEquipment() {
    try {
      return jdbcTemplate.query(
          "select e.equipment_id, e.equipment_code, e.equipment_name, "
              + "p.process_name, e.active_yn "
              + "from equipment e left join production_process p on p.process_id = e.process_id "
              + "order by e.active_yn desc, e.equipment_code",
          (rs, rowNum) -> new EquipmentItem(
              rs.getLong("equipment_id"),
              rs.getString("equipment_code"),
              rs.getString("equipment_name"),
              rs.getString("process_name"),
              rs.getString("active_yn")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("equipment table not found; returning fallback equipment. Run scripts/oracle-init.sql");
        return List.of(new EquipmentItem(1L, "EQP", "Equipment (fallback)", "-", "Y"));
      }
      throw ex;
    }
  }

  @Override
  public List<ProdPlanItem> listPlans() {
    try {
      return jdbcTemplate.query(
          "select plan_id, to_char(plan_date, 'YYYY-MM-DD') as plan_date, item_code, "
              + "to_char(qty_plan) as qty_plan, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from production_plan order by plan_date desc, plan_id desc",
          (rs, rowNum) -> new ProdPlanItem(
              rs.getLong("plan_id"),
              rs.getString("plan_date"),
              rs.getString("item_code"),
              rs.getString("qty_plan"),
              rs.getString("created_at")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_plan table not found; returning fallback plans. Run scripts/oracle-init.sql");
        return List.of(new ProdPlanItem(1L, "-", "ITEM", "0", "-"));
      }
      throw ex;
    }
  }

  @Override
  public long insertPlan(String planDate, String itemCode, String qtyPlan, Long createdBy) {
    try {
      Map<String, Object> args = new HashMap<>();
      args.put("plan_date", java.sql.Date.valueOf(planDate));
      args.put("item_code", itemCode);
      args.put("qty_plan", qtyPlan);
      args.put("created_by", createdBy);
      args.put("created_at", new java.util.Date());
      return insertPlan.executeAndReturnKey(args).longValue();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_plan table not found; insert is skipped. Run scripts/oracle-init.sql");
        return -1L;
      }
      throw ex;
    }
  }

  @Override
  public boolean deletePlan(long planId) {
    try {
      return jdbcTemplate.update("delete from production_plan where plan_id = ?", planId) == 1;
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_plan table not found; delete is skipped. Run scripts/oracle-init.sql");
        return false;
      }
      throw ex;
    }
  }

  @Override
  public ProdPlanItem getPlan(long planId) {
    try {
      return jdbcTemplate.queryForObject(
          "select plan_id, to_char(plan_date, 'YYYY-MM-DD') as plan_date, item_code, "
              + "to_char(qty_plan) as qty_plan, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from production_plan where plan_id = ?",
          (rs, rowNum) -> new ProdPlanItem(
              rs.getLong("plan_id"),
              rs.getString("plan_date"),
              rs.getString("item_code"),
              rs.getString("qty_plan"),
              rs.getString("created_at")),
          planId);
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        return null;
      }
      throw ex;
    }
  }

  @Override
  public boolean updatePlan(long planId, String planDate, String itemCode, String qtyPlan, Long updatedBy) {
    try {
      return jdbcTemplate.update(
          "update production_plan set plan_date = TO_DATE(?, 'YYYY-MM-DD'), item_code = ?, qty_plan = ? "
              + "where plan_id = ?",
          planDate, itemCode, qtyPlan, planId) == 1;
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        return false;
      }
      throw ex;
    }
  }

  @Override
  public List<ProdResultItem> listResults() {
    try {
      return jdbcTemplate.query(
          "select r.result_id, to_char(r.work_date, 'YYYY-MM-DD') as work_date, r.item_code, "
              + "to_char(r.qty_good) as qty_good, to_char(r.qty_ng) as qty_ng, "
              + "e.equipment_name, to_char(r.created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from production_result r left join equipment e on e.equipment_id = r.equipment_id "
              + "order by r.work_date desc, r.result_id desc",
          (rs, rowNum) -> new ProdResultItem(
              rs.getLong("result_id"),
              rs.getString("work_date"),
              rs.getString("item_code"),
              rs.getString("qty_good"),
              rs.getString("qty_ng"),
              rs.getString("equipment_name"),
              rs.getString("created_at")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_result table not found; returning fallback results. Run scripts/oracle-init.sql");
        return List.of(new ProdResultItem(1L, "-", "ITEM", "0", "0", "-", "-"));
      }
      throw ex;
    }
  }

  @Override
  public long insertResult(
      String workDate,
      String itemCode,
      String qtyGood,
      String qtyNg,
      Long equipmentId,
      Long createdBy) {
    try {
      Map<String, Object> args = new HashMap<>();
      args.put("work_date", java.sql.Date.valueOf(workDate));
      args.put("item_code", itemCode);
      args.put("qty_good", qtyGood);
      args.put("qty_ng", qtyNg);
      args.put("equipment_id", equipmentId);
      args.put("created_by", createdBy);
      args.put("created_at", new java.util.Date());
      return insertResult.executeAndReturnKey(args).longValue();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_result table not found; insert is skipped. Run scripts/oracle-init.sql");
        return -1L;
      }
      throw ex;
    }
  }

  @Override
  public boolean deleteResult(long resultId) {
    try {
      return jdbcTemplate.update("delete from production_result where result_id = ?", resultId) == 1;
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production_result table not found; delete is skipped. Run scripts/oracle-init.sql");
        return false;
      }
      throw ex;
    }
  }

  @Override
  public List<QtyStatRow> dailyStatsLast14Days() {
    try {
      return jdbcTemplate.query(
          "with d as (\n"
              + "  select trunc(sysdate) - level + 1 as day_key from dual connect by level <= 14\n"
              + ")\n"
              + "select to_char(d.day_key, 'YYYY-MM-DD') as bucket,\n"
              + "  nvl((select sum(p.qty_plan) from production_plan p where trunc(p.plan_date) = d.day_key), 0) as qty_plan,\n"
              + "  nvl((select sum(r.qty_good) from production_result r where trunc(r.work_date) = d.day_key), 0) as qty_good,\n"
              + "  nvl((select sum(r.qty_ng) from production_result r where trunc(r.work_date) = d.day_key), 0) as qty_ng\n"
              + "from d\n"
              + "order by d.day_key",
          (rs, rowNum) -> new QtyStatRow(
              rs.getString("bucket"),
              rs.getString("qty_plan"),
              rs.getString("qty_good"),
              rs.getString("qty_ng")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production tables not found; returning fallback stats. Run scripts/oracle-init.sql");
        return List.of(new QtyStatRow("-", "0", "0", "0"));
      }
      throw ex;
    }
  }

  @Override
  public List<com.tp.mes.app.prod.model.DailyProductionSummary> getDailySummary(String date) {
    try {
      String sql = "WITH plans AS (" +
          "  SELECT item_code, SUM(qty_plan) as total_plan " +
          "  FROM production_plan WHERE TRUNC(plan_date) = TO_DATE(?, 'YYYY-MM-DD') GROUP BY item_code" +
          "), results AS (" +
          "  SELECT item_code, SUM(qty_good) as total_good, SUM(qty_ng) as total_ng " +
          "  FROM production_result WHERE TRUNC(work_date) = TO_DATE(?, 'YYYY-MM-DD') GROUP BY item_code" +
          ") " +
          "SELECT COALESCE(p.item_code, r.item_code) as item_code, " +
          "       MAX(i.item_name) as item_name, " +
          "       NVL(p.total_plan, 0) as target_qty, " +
          "       NVL(r.total_good, 0) as actual_qty, " +
          "       NVL(r.total_ng, 0) as ng_qty " +
          "FROM plans p " +
          "FULL OUTER JOIN results r ON p.item_code = r.item_code " +
          "LEFT JOIN tp_inventory i ON COALESCE(p.item_code, r.item_code) = i.item_code " +
          "ORDER BY item_code";

      return jdbcTemplate.query(sql, (rs, rowNum) -> {
        double plan = rs.getDouble("target_qty");
        double actual = rs.getDouble("actual_qty");
        String rate = plan > 0 ? String.format("%.1f", (actual / plan) * 100) : "0.0";

        return new com.tp.mes.app.prod.model.DailyProductionSummary(
            date,
            "-",
            rs.getString("item_code"),
            rs.getString("item_name"),
            String.valueOf((int) plan),
            String.valueOf((int) actual),
            rs.getString("ng_qty"),
            rate);
      }, date, date);
    } catch (DataAccessException ex) {
      return java.util.Collections.emptyList();
    }
  }

  @Override
  public List<QtyStatRow> monthlyStatsThisYear() {
    try {
      return jdbcTemplate.query(
          "with m as (\n"
              + "  select add_months(trunc(sysdate, 'YYYY'), level-1) as month_key\n"
              + "  from dual connect by level <= 12\n"
              + ")\n"
              + "select to_char(m.month_key, 'YYYY-MM') as bucket,\n"
              + "  nvl((select sum(p.qty_plan) from production_plan p where trunc(p.plan_date, 'MM') = trunc(m.month_key, 'MM')), 0) as qty_plan,\n"
              + "  nvl((select sum(r.qty_good) from production_result r where trunc(r.work_date, 'MM') = trunc(m.month_key, 'MM')), 0) as qty_good,\n"
              + "  nvl((select sum(r.qty_ng) from production_result r where trunc(r.work_date, 'MM') = trunc(m.month_key, 'MM')), 0) as qty_ng\n"
              + "from m\n"
              + "order by m.month_key",
          (rs, rowNum) -> new QtyStatRow(
              rs.getString("bucket"),
              rs.getString("qty_plan"),
              rs.getString("qty_good"),
              rs.getString("qty_ng")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("production tables not found; returning fallback stats. Run scripts/oracle-init.sql");
        return List.of(new QtyStatRow("-", "0", "0", "0"));
      }
      throw ex;
    }
  }
}
