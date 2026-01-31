package com.tp.mes.app.inventory.service;

import java.math.BigDecimal;
import java.util.List;
import com.tp.mes.app.inventory.model.InventoryItem;
import com.tp.mes.app.inventory.model.InventoryStats;
import com.tp.mes.app.inventory.model.InventoryTransaction;

public interface InventoryService {
    List<InventoryItem> getAllItems();

    void deductMaterialBasedOnBOM(String productItemCode, BigDecimal producedQty);

    InventoryStats getStats();

    List<InventoryItem> getLowStockItems();

    List<InventoryTransaction> getRecentTransactions(int limit);

    List<InventoryItem> searchItems(String keyword);

    List<InventoryItem> getItemsByType(String type);

    InventoryItem getItemById(Long id);

    List<InventoryTransaction> getTransactions(Long inventoryId);

    void createItem(InventoryItem item);

    void updateItem(InventoryItem item);

    void receiveStock(Long id, BigDecimal quantity, String reason, String referenceNo, String username);

    void issueStock(Long id, BigDecimal quantity, String reason, String referenceNo, String username);

    void deleteItem(Long id);
}
