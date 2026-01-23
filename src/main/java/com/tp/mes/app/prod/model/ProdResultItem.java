package com.tp.mes.app.prod.model;

public class ProdResultItem {

  private final long resultId;
  private final String workDate;
  private final String itemCode;
  private final String qtyGood;
  private final String qtyNg;
  private final String equipmentName;
  private final String createdAt;

  public ProdResultItem(
      long resultId,
      String workDate,
      String itemCode,
      String qtyGood,
      String qtyNg,
      String equipmentName,
      String createdAt
  ) {
    this.resultId = resultId;
    this.workDate = workDate;
    this.itemCode = itemCode;
    this.qtyGood = qtyGood;
    this.qtyNg = qtyNg;
    this.equipmentName = equipmentName;
    this.createdAt = createdAt;
  }

  public long getResultId() {
    return resultId;
  }

  public String getWorkDate() {
    return workDate;
  }

  public String getItemCode() {
    return itemCode;
  }

  public String getQtyGood() {
    return qtyGood;
  }

  public String getQtyNg() {
    return qtyNg;
  }

  public String getEquipmentName() {
    return equipmentName;
  }

  public String getCreatedAt() {
    return createdAt;
  }
}
