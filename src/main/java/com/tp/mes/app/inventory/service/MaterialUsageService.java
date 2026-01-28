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
    private final InventoryService inventoryService;

    public MaterialUsageService(ProductBomRepository productBomRepository, InventoryService inventoryService) {
        this.productBomRepository = productBomRepository;
        this.inventoryService = inventoryService;
    }

    @Transactional
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
                inventoryService.issueStock(
                        bom.getMaterialInventoryId(),
                        amountToDeduct,
                        "PRODUCTION",
                        "PROD-AUTO-" + System.currentTimeMillis(), // Ideally link to Result ID
                        "SYSTEM");
                log.info("Deducted {} of material ID {} for product {}", amountToDeduct, bom.getMaterialInventoryId(),
                        productItemCode);
            } catch (Exception e) {
                log.error("Failed to deduct material ID {} for product {}: {}", bom.getMaterialInventoryId(),
                        productItemCode, e.getMessage());
                // Decide whether to throw exception (rollback production result) or just log.
                // For now, logging to avoid stopping production reporting.
            }
        }
    }
}
