package com.tp.mes.app.prod.repository;

import com.tp.mes.app.prod.model.EquipmentItem;
import com.tp.mes.app.prod.model.ProcessItem;
import com.tp.mes.app.prod.model.ProdPlanItem;
import com.tp.mes.app.prod.model.ProdResultItem;
import com.tp.mes.app.prod.model.QtyStatRow;
import java.util.List;

public interface ProductionRepository {

  List<ProcessItem> listProcesses();

  List<EquipmentItem> listEquipment();

  List<ProdPlanItem> listPlans();

  long insertPlan(String planDate, String itemCode, String qtyPlan, Long createdBy);

  boolean deletePlan(long planId);

  ProdPlanItem getPlan(long planId);

  boolean updatePlan(long planId, String planDate, String itemCode, String qtyPlan, Long updatedBy);

  List<ProdResultItem> listResults();

  long insertResult(String workDate, String itemCode, String qtyGood, String qtyNg, Long equipmentId, Long createdBy);

  boolean deleteResult(long resultId);

  List<QtyStatRow> dailyStatsLast14Days();

  List<QtyStatRow> monthlyStatsThisYear();

  List<com.tp.mes.app.prod.model.DailyProductionSummary> getDailySummary(String date);
}
