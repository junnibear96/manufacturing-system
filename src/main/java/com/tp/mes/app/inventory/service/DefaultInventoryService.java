package com.tp.mes.app.inventory.service;

import com.tp.mes.app.inventory.model.ProductBom;
import com.tp.mes.app.inventory.repository.ProductBomRepository;
import com.tp.mes.app.inventory.repository.MaterialRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.Collections;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class DefaultInventoryService implements InventoryService {

    private final ProductBomRepository productBomRepository;
    private final MaterialRepository materialRepository;

    @Override
    public List<com.tp.mes.app.inventory.model.InventoryItem> getAllItems() {
        return Collections.emptyList();
    }

    @Override
    @Transactional(propagation = Propagation.REQUIRED)
    public void deductMaterialBasedOnBOM(String productItemCode, BigDecimal producedQty) {
        if (producedQty.compareTo(BigDecimal.ZERO) <= 0)
            return;

        List<ProductBom> boms = productBomRepository.findByProductItemCode(productItemCode);
        if (boms.isEmpty()) {
            log.warn("No BOM found for product: {}. Skipped deduction.", productItemCode);
            return;
        }

        for (ProductBom bom : boms) {
            BigDecimal totalRequired = bom.getQuantityRequired().multiply(producedQty);
            try {
                int rows = materialRepository.deductStock(bom.getMaterialInventoryId(), totalRequired);
                if (rows == 0) {
                    log.error("Failed to deduct stock for Material: {}. Material may not exist.",
                            bom.getMaterialInventoryId());
                } else {
                    log.info("Deducted {} of {} for Product {}", totalRequired, bom.getMaterialInventoryId(),
                            productItemCode);
                }
            } catch (Exception e) {
                // If strict consistency is required (Result Save Fail -> Inv Not Deducted), we
                // need Inv Fail -> Result Fail?
                // The prompt says: "inventory isn't deducted if the result save fails"
                // (Atomic).
                // It does NOT explicitly say "Fail result if inventory fails".
                // But usually standard PROPER MES requires it.
                // Assuming "Autonomous Mode", I will throw RuntimeException to rollback
                // everything if stock deduction technically fails (DB error).
                throw new RuntimeException("Inventory deduction failed", e);
            }
        }
    }

    @Override
    public com.tp.mes.app.inventory.model.InventoryStats getStats() {
        return new com.tp.mes.app.inventory.model.InventoryStats();
    }

    @Override
    public List<com.tp.mes.app.inventory.model.InventoryItem> getLowStockItems() {
        return Collections.emptyList();
    }

    @Override
    public List<com.tp.mes.app.inventory.model.InventoryTransaction> getRecentTransactions(int limit) {
        return Collections.emptyList();
    }

    @Override
    public List<com.tp.mes.app.inventory.model.InventoryItem> searchItems(String keyword) {
        return Collections.emptyList();
    }

    @Override
    public List<com.tp.mes.app.inventory.model.InventoryItem> getItemsByType(String type) {
        return Collections.emptyList();
    }

    @Override
    public com.tp.mes.app.inventory.model.InventoryItem getItemById(Long id) {
        return new com.tp.mes.app.inventory.model.InventoryItem();
    }

    @Override
    public List<com.tp.mes.app.inventory.model.InventoryTransaction> getTransactions(Long inventoryId) {
        return Collections.emptyList();
    }

    @Override
    public void createItem(com.tp.mes.app.inventory.model.InventoryItem item) {
        // TODO: Implement
    }

    @Override
    public void updateItem(com.tp.mes.app.inventory.model.InventoryItem item) {
        // TODO: Implement
    }

    @Override
    public void receiveStock(Long id, BigDecimal quantity, String reason, String referenceNo, String username) {
        // TODO: Implement
    }

    @Override
    public void issueStock(Long id, BigDecimal quantity, String reason, String referenceNo, String username) {
        // TODO: Implement
    }

    @Override
    public void deleteItem(Long id) {
        // TODO: Implement
    }
}
