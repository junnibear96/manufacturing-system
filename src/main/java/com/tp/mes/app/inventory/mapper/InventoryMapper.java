package com.tp.mes.app.inventory.mapper;

import com.tp.mes.app.inventory.model.InventoryItem;
import com.tp.mes.app.inventory.model.InventoryStats;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 재고 관리 Mapper
 */
@Mapper
public interface InventoryMapper {

    /**
     * 모든 재고 목록 조회
     */
    List<InventoryItem> findAll();

    /**
     * ID로 재고 조회
     */
    InventoryItem findById(@Param("inventoryId") Long inventoryId);

    /**
     * 아이템 코드로 조회
     */
    InventoryItem findByCode(@Param("itemCode") String itemCode);

    /**
     * 재고 부족 아이템 조회
     */
    List<InventoryItem> findLowStock();

    /**
     * 타입별 조회
     */
    List<InventoryItem> findByType(@Param("itemType") String itemType);

    /**
     * 상태별 조회
     */
    List<InventoryItem> findByStatus(@Param("status") String status);

    /**
     * 검색 (코드 또는 이름으로)
     */
    List<InventoryItem> search(@Param("keyword") String keyword);

    /**
     * 재고 통계 조회
     */
    InventoryStats getStats();

    /**
     * 신규 재고 등록
     */
    int insert(InventoryItem item);

    /**
     * 재고 정보 수정
     */
    int update(InventoryItem item);

    /**
     * 수량 업데이트
     */
    int updateQuantity(@Param("inventoryId") Long inventoryId,
            @Param("quantity") java.math.BigDecimal quantity);

    /**
     * 재고 삭제
     */
    int delete(@Param("inventoryId") Long inventoryId);
}
