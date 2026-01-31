package com.tp.mes.app.inventory.model;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.math.BigDecimal;
import java.time.LocalDateTime;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProductBom {
    private Long bomId;
    private String productItemCode;
    private String materialInventoryId;
    private BigDecimal quantityRequired;
    private LocalDateTime createdAt;

    // Transient fields
    private String materialName;
    private String materialCode;

}
