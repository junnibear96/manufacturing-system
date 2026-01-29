package com.tp.mes.app.inventory.service;

import com.tp.mes.app.inventory.model.ProductBom;
import com.tp.mes.app.inventory.repository.ProductBomRepository;
import java.math.BigDecimal;
import java.util.List;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
public class MaterialUsageService {

    private final ProductBomRepository productBomRepository;
    private final com.tp.mes.app.inventory.repository.MaterialRepository materialRepository;

    public MaterialUsageService(ProductBomRepository productBomRepository,
            com.tp.mes.app.inventory.repository.MaterialRepository materialRepository) {
        this.productBomRepository = productBomRepository;
        this.materialRepository = materialRepository;
    }

    @Transactional(propagation = org.springframework.transaction.annotation.Propagation.REQUIRES_NEW)
    public void deductMaterialsForProduction(String productItemCode, BigDecimal quantityProduced) {
        if (quantityProduced.compareTo(BigDecimal.ZERO) <= 0) {
            return;
        }

        List<ProductBom> boms = productBomRepository.findByProductItemCode(productItemCode);
        if (boms.isEmpty()) {
            log.warn("No BOM defined for product: {}. Material deduction skipped.", productItemCode);
            return;
        }

        for (ProductBom bom : boms) {
            BigDecimal amountToDeduct = bom.getQuantityRequired().multiply(quantityProduced);

            try {
                // Using MaterialRepository to deduct stock directly from 'materials' table
                int updatedRows = materialRepository.deductStock(bom.getMaterialInventoryId(), amountToDeduct);

                if (updatedRows > 0) {
                    log.info("Deducted {} of material ID {} for product {}", amountToDeduct,
                            bom.getMaterialInventoryId(),
                            productItemCode);
                } else {
                    log.warn("Failed to deduct material ID {} - Material ID not found", bom.getMaterialInventoryId());
                }
            } catch (Exception e) {
                log.error("Failed to deduct material ID {} for product {}: {}", bom.getMaterialInventoryId(),
                        productItemCode, e.getMessage());
            }
        }
    }
}
