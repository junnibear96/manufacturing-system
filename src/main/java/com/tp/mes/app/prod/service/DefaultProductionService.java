package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.EquipmentItem;
import com.tp.mes.app.prod.model.ProcessItem;
import com.tp.mes.app.prod.model.ProdPlanItem;
import com.tp.mes.app.prod.model.ProdResultItem;
import com.tp.mes.app.prod.model.QtyStatRow;
import com.tp.mes.app.prod.repository.ProductionRepository;
import java.util.List;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.stereotype.Service;

@Service
public class DefaultProductionService implements ProductionService {

  private final ProductionRepository repository;
  private final com.tp.mes.app.inventory.service.MaterialUsageService materialUsageService;

  public DefaultProductionService(ProductionRepository repository,
      com.tp.mes.app.inventory.service.MaterialUsageService materialUsageService) {
    this.repository = repository;
    this.materialUsageService = materialUsageService;
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
  @Transactional
  public long createPlan(String planDate, String itemCode, String qtyPlan, Long createdBy) {
    return repository.insertPlan(s(planDate), s(itemCode), s(qtyPlan), createdBy);
  }

  @Override
  @Transactional
  public boolean deletePlan(long planId) {
    return repository.deletePlan(planId);
  }

  @Override
  public ProdPlanItem getPlan(long planId) {
    return repository.getPlan(planId);
  }

  @Override
  @Transactional
  public boolean updatePlan(long planId, String planDate, String itemCode, String qtyPlan, Long updatedBy) {
    return repository.updatePlan(planId, s(planDate), s(itemCode), s(qtyPlan), updatedBy);
  }

  @Override
  public List<ProdResultItem> listResults() {
    return repository.listResults();
  }

  @Override
  @Transactional
  public long createResult(
      String workDate,
      String itemCode,
      String qtyGood,
      String qtyNg,
      Long equipmentId,
      Long createdBy) {
    long resultId = repository.insertResult(s(workDate), s(itemCode), s(qtyGood), s(qtyNg), equipmentId, createdBy);

    // Trigger Material Deduction
    try {
      materialUsageService.deductMaterialsForProduction(s(itemCode), new java.math.BigDecimal(s(qtyGood)));
    } catch (Exception e) {
      // Log but don't fail the result creation
      org.slf4j.LoggerFactory.getLogger(DefaultProductionService.class)
          .warn("Material deduction failed for resultId {}: {}", resultId, e.getMessage());
    }

    return resultId;
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
