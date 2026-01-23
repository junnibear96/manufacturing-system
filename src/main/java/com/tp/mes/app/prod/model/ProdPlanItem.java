package com.tp.mes.app.prod.model;

public class ProdPlanItem {

  private final long planId;
  private final String planDate;
  private final String itemCode;
  private final String qtyPlan;
  private final String createdAt;

  public ProdPlanItem(long planId, String planDate, String itemCode, String qtyPlan, String createdAt) {
    this.planId = planId;
    this.planDate = planDate;
    this.itemCode = itemCode;
    this.qtyPlan = qtyPlan;
    this.createdAt = createdAt;
  }

  public long getPlanId() {
    return planId;
  }

  public String getPlanDate() {
    return planDate;
  }

  public String getItemCode() {
    return itemCode;
  }

  public String getQtyPlan() {
    return qtyPlan;
  }

  public String getCreatedAt() {
    return createdAt;
  }
}
