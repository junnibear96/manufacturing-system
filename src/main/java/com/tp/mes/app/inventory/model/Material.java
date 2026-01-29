package com.tp.mes.app.inventory.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class Material {
    private String materialId;
    private String materialName;
    private BigDecimal currentStock;
    private String unit;
    private BigDecimal costPerUnit;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
