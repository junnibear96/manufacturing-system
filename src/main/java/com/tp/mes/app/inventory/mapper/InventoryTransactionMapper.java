package com.tp.mes.app.inventory.mapper;

import com.tp.mes.app.inventory.model.InventoryTransaction;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * 재고 거래 내역 Mapper
 */
@Mapper
public interface InventoryTransactionMapper {

    /**
     * 모든 거래 내역 조회
     */
    List<InventoryTransaction> findAll();

    /**
     * 특정 재고의 거래 내역 조회
     */
    List<InventoryTransaction> findByInventoryId(@Param("inventoryId") Long inventoryId);

    /**
     * 최근 거래 내역 조회
     */
    List<InventoryTransaction> findRecent(@Param("limit") int limit);

    /**
     * 거래 내역 등록
     */
    int insert(InventoryTransaction transaction);
}
