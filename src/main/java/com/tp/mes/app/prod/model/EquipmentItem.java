package com.tp.mes.app.prod.model;

public class EquipmentItem {

  private final long equipmentId;
  private final String equipmentCode;
  private final String equipmentName;
  private final String processName;
  private final String activeYn;

  public EquipmentItem(
      long equipmentId,
      String equipmentCode,
      String equipmentName,
      String processName,
      String activeYn
  ) {
    this.equipmentId = equipmentId;
    this.equipmentCode = equipmentCode;
    this.equipmentName = equipmentName;
    this.processName = processName;
    this.activeYn = activeYn;
  }

  public long getEquipmentId() {
    return equipmentId;
  }

  public String getEquipmentCode() {
    return equipmentCode;
  }

  public String getEquipmentName() {
    return equipmentName;
  }

  public String getProcessName() {
    return processName;
  }

  public String getActiveYn() {
    return activeYn;
  }
}
