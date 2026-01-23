package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.EquipmentItem;
import com.tp.mes.app.prod.model.ProcessItem;
import com.tp.mes.app.prod.model.ProdPlanItem;
import com.tp.mes.app.prod.model.ProdResultItem;
import com.tp.mes.app.prod.model.QtyStatRow;
import java.util.List;

public interface ProductionService {

  List<ProcessItem> listProcesses();

  List<EquipmentItem> listEquipment();

  List<ProdPlanItem> listPlans();

  long createPlan(String planDate, String itemCode, String qtyPlan, Long createdBy);

  boolean deletePlan(long planId);

  List<ProdResultItem> listResults();

  long createResult(String workDate, String itemCode, String qtyGood, String qtyNg, Long equipmentId, Long createdBy);

  boolean deleteResult(long resultId);

  List<QtyStatRow> dailyStatsLast14Days();

  List<QtyStatRow> monthlyStatsThisYear();
}
