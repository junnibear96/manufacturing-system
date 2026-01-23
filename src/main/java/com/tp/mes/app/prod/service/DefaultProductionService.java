package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.EquipmentItem;
import com.tp.mes.app.prod.model.ProcessItem;
import com.tp.mes.app.prod.model.ProdPlanItem;
import com.tp.mes.app.prod.model.ProdResultItem;
import com.tp.mes.app.prod.model.QtyStatRow;
import com.tp.mes.app.prod.repository.ProductionRepository;
import java.util.List;
import org.springframework.stereotype.Service;

@Service
public class DefaultProductionService implements ProductionService {

  private final ProductionRepository repository;

  public DefaultProductionService(ProductionRepository repository) {
    this.repository = repository;
  }

  @Override
  public List<ProcessItem> listProcesses() {
    return repository.listProcesses();
  }

  @Override
  public List<EquipmentItem> listEquipment() {
    return repository.listEquipment();
  }

  @Override
  public List<ProdPlanItem> listPlans() {
    return repository.listPlans();
  }

  @Override
  public long createPlan(String planDate, String itemCode, String qtyPlan, Long createdBy) {
    return repository.insertPlan(s(planDate), s(itemCode), s(qtyPlan), createdBy);
  }

  @Override
  public boolean deletePlan(long planId) {
    return repository.deletePlan(planId);
  }

  @Override
  public List<ProdResultItem> listResults() {
    return repository.listResults();
  }

  @Override
  public long createResult(String workDate, String itemCode, String qtyGood, String qtyNg, Long equipmentId, Long createdBy) {
    return repository.insertResult(s(workDate), s(itemCode), s(qtyGood), s(qtyNg), equipmentId, createdBy);
  }

  @Override
  public boolean deleteResult(long resultId) {
    return repository.deleteResult(resultId);
  }

  @Override
  public List<QtyStatRow> dailyStatsLast14Days() {
    return repository.dailyStatsLast14Days();
  }

  @Override
  public List<QtyStatRow> monthlyStatsThisYear() {
    return repository.monthlyStatsThisYear();
  }

  private static String s(String v) {
    return v == null ? "" : v.trim();
  }
}
