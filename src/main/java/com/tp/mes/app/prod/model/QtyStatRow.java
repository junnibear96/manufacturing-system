package com.tp.mes.app.prod.model;

public class QtyStatRow {

  private final String bucket;
  private final String qtyPlan;
  private final String qtyGood;
  private final String qtyNg;

  public QtyStatRow(String bucket, String qtyPlan, String qtyGood, String qtyNg) {
    this.bucket = bucket;
    this.qtyPlan = qtyPlan;
    this.qtyGood = qtyGood;
    this.qtyNg = qtyNg;
  }

  public String getBucket() {
    return bucket;
  }

  public String getQtyPlan() {
    return qtyPlan;
  }

  public String getQtyGood() {
    return qtyGood;
  }

  public String getQtyNg() {
    return qtyNg;
  }
}
