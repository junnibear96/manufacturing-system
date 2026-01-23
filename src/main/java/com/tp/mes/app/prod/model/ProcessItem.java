package com.tp.mes.app.prod.model;

public class ProcessItem {

  private final long processId;
  private final String processCode;
  private final String processName;

  public ProcessItem(long processId, String processCode, String processName) {
    this.processId = processId;
    this.processCode = processCode;
    this.processName = processName;
  }

  public long getProcessId() {
    return processId;
  }

  public String getProcessCode() {
    return processCode;
  }

  public String getProcessName() {
    return processName;
  }
}
