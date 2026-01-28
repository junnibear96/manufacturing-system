package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class DailyProductionSummary {
    private String workDate;
    private String lineName;
    private String itemCode;
    private String itemName;
    private String targetQty; // From Plan
    private String actualQty; // From Result (Good)
    private String ngQty; // From Result (NG)
    private String achieveRate; // (Actual / Target) * 100
}
