package com.tp.mes.app.group.model;

public class GroupCompany {

  private final long companyId;
  private final String companyCode;
  private final String companyName;
  private final String description;
  private final String activeYn;
  private final String createdAt;

  public GroupCompany(
      long companyId,
      String companyCode,
      String companyName,
      String description,
      String activeYn,
      String createdAt
  ) {
    this.companyId = companyId;
    this.companyCode = companyCode;
    this.companyName = companyName;
    this.description = description;
    this.activeYn = activeYn;
    this.createdAt = createdAt;
  }

  public long getCompanyId() {
    return companyId;
  }

  public String getCompanyCode() {
    return companyCode;
  }

  public String getCompanyName() {
    return companyName;
  }

  public String getDescription() {
    return description;
  }

  public String getActiveYn() {
    return activeYn;
  }

  public String getCreatedAt() {
    return createdAt;
  }
}
