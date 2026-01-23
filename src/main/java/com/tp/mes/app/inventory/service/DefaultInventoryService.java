package com.tp.mes.app.inventory.service;

import com.tp.mes.app.inventory.mapper.InventoryMapper;
import com.tp.mes.app.inventory.mapper.InventoryTransactionMapper;
import com.tp.mes.app.inventory.model.InventoryItem;
import com.tp.mes.app.inventory.model.InventoryStats;
import com.tp.mes.app.inventory.model.InventoryTransaction;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.util.List;

/**
 * 재고 관리 서비스 구현
 */
@Service
@Transactional
public class DefaultInventoryService implements InventoryService {

    private final InventoryMapper inventoryMapper;
    private final InventoryTransactionMapper transactionMapper;

    public DefaultInventoryService(InventoryMapper inventoryMapper,
            InventoryTransactionMapper transactionMapper) {
        this.inventoryMapper = inventoryMapper;
        this.transactionMapper = transactionMapper;
    }

    @Override
    @Transactional(readOnly = true)
    public List<InventoryItem> getAllItems() {
        return inventoryMapper.findAll();
    }

    @Override
    @Transactional(readOnly = true)
    public InventoryItem getItemById(Long inventoryId) {
        return inventoryMapper.findById(inventoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public InventoryItem getItemByCode(String itemCode) {
        return inventoryMapper.findByCode(itemCode);
    }

    @Override
    @Transactional(readOnly = true)
    public List<InventoryItem> getLowStockItems() {
        return inventoryMapper.findLowStock();
    }

    @Override
    @Transactional(readOnly = true)
    public List<InventoryItem> getItemsByType(String itemType) {
        return inventoryMapper.findByType(itemType);
    }

    @Override
    @Transactional(readOnly = true)
    public List<InventoryItem> searchItems(String keyword) {
        return inventoryMapper.search(keyword);
    }

    @Override
    @Transactional(readOnly = true)
    public InventoryStats getStats() {
        return inventoryMapper.getStats();
    }

    @Override
    public InventoryItem createItem(InventoryItem item) {
        inventoryMapper.insert(item);
        return item;
    }

    @Override
    public InventoryItem updateItem(InventoryItem item) {
        inventoryMapper.update(item);
        return inventoryMapper.findById(item.getInventoryId());
    }

    @Override
    public void adjustQuantity(Long inventoryId, BigDecimal quantity, String reason, String performedBy) {
        InventoryItem item = inventoryMapper.findById(inventoryId);
        if (item == null) {
            throw new IllegalArgumentException("재고를 찾을 수 없습니다: " + inventoryId);
        }

        inventoryMapper.updateQuantity(inventoryId, quantity);

        // Record transaction
        InventoryTransaction transaction = new InventoryTransaction();
        transaction.setInventoryId(inventoryId);
        transaction.setTransactionType("ADJUST");
        transaction.setQuantity(quantity.subtract(item.getCurrentQuantity()));
        transaction.setTransactionReason(reason);
        transaction.setPerformedBy(performedBy);
        transactionMapper.insert(transaction);
    }

    @Override
    public void receiveStock(Long inventoryId, BigDecimal quantity, String reason, String referenceNo,
            String performedBy) {
        InventoryItem item = inventoryMapper.findById(inventoryId);
        if (item == null) {
            throw new IllegalArgumentException("재고를 찾을 수 없습니다: " + inventoryId);
        }

        BigDecimal newQuantity = item.getCurrentQuantity().add(quantity);
        inventoryMapper.updateQuantity(inventoryId, newQuantity);

        // Record transaction
        InventoryTransaction transaction = new InventoryTransaction();
        transaction.setInventoryId(inventoryId);
        transaction.setTransactionType("IN");
        transaction.setQuantity(quantity);
        transaction.setTransactionReason(reason);
        transaction.setReferenceNo(referenceNo);
        transaction.setPerformedBy(performedBy);
        transactionMapper.insert(transaction);
    }

    @Override
    public void issueStock(Long inventoryId, BigDecimal quantity, String reason, String referenceNo,
            String performedBy) {
        InventoryItem item = inventoryMapper.findById(inventoryId);
        if (item == null) {
            throw new IllegalArgumentException("재고를 찾을 수 없습니다: " + inventoryId);
        }

        if (item.getCurrentQuantity().compareTo(quantity) < 0) {
            throw new IllegalArgumentException("재고가 부족합니다. 현재 수량: " + item.getCurrentQuantity());
        }

        BigDecimal newQuantity = item.getCurrentQuantity().subtract(quantity);
        inventoryMapper.updateQuantity(inventoryId, newQuantity);

        // Record transaction
        InventoryTransaction transaction = new InventoryTransaction();
        transaction.setInventoryId(inventoryId);
        transaction.setTransactionType("OUT");
        transaction.setQuantity(quantity);
        transaction.setTransactionReason(reason);
        transaction.setReferenceNo(referenceNo);
        transaction.setPerformedBy(performedBy);
        transactionMapper.insert(transaction);
    }

    @Override
    public void deleteItem(Long inventoryId) {
        inventoryMapper.delete(inventoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<InventoryTransaction> getTransactions(Long inventoryId) {
        return transactionMapper.findByInventoryId(inventoryId);
    }

    @Override
    @Transactional(readOnly = true)
    public List<InventoryTransaction> getRecentTransactions(int limit) {
        return transactionMapper.findRecent(limit);
    }
}
