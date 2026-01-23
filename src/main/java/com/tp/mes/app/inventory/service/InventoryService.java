package com.tp.mes.app.inventory.service;

import com.tp.mes.app.inventory.model.InventoryItem;
import com.tp.mes.app.inventory.model.InventoryStats;
import com.tp.mes.app.inventory.model.InventoryTransaction;

import java.math.BigDecimal;
import java.util.List;

/**
 * 재고 관리 서비스 인터페이스
 */
public interface InventoryService {

    /**
     * 모든 재고 목록 조회
     */
    List<InventoryItem> getAllItems();

    /**
     * 재고 항목 조회
     */
    InventoryItem getItemById(Long inventoryId);

    /**
     * 아이템 코드로 조회
     */
    InventoryItem getItemByCode(String itemCode);

    /**
     * 재고 부족 항목 조회
     */
    List<InventoryItem> getLowStockItems();

    /**
     * 타입별 조회
     */
    List<InventoryItem> getItemsByType(String itemType);

    /**
     * 검색
     */
    List<InventoryItem> searchItems(String keyword);

    /**
     * 재고 통계 조회
     */
    InventoryStats getStats();

    /**
     * 신규 재고 등록
     */
    InventoryItem createItem(InventoryItem item);

    /**
     * 재고 정보 수정
     */
    InventoryItem updateItem(InventoryItem item);

    /**
     * 재고 수량 조정
     */
    void adjustQuantity(Long inventoryId, BigDecimal quantity, String reason, String performedBy);

    /**
     * 재고 입고
     */
    void receiveStock(Long inventoryId, BigDecimal quantity, String reason, String referenceNo, String performedBy);

    /**
     * 재고 출고
     */
    void issueStock(Long inventoryId, BigDecimal quantity, String reason, String referenceNo, String performedBy);

    /**
     * 재고 삭제
     */
    void deleteItem(Long inventoryId);

    /**
     * 거래 내역 조회
     */
    List<InventoryTransaction> getTransactions(Long inventoryId);

    /**
     * 최근 거래 내역
     */
    List<InventoryTransaction> getRecentTransactions(int limit);
}
