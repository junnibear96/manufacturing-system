package com.tp.mes.app.prod.mapper;

import com.tp.mes.app.prod.model.ProductionBom;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

/**
 * ProductionBom Mapper
 * BOM (Bill of Materials) 데이터 접근 인터페이스
 */
@Mapper
public interface ProductionBomMapper {

    /**
     * 모든 BOM 조회
     */
    List<ProductionBom> findAll();

    /**
     * 특정 라인의 BOM 목록 조회
     */
    List<ProductionBom> findByLineId(@Param("lineId") String lineId);

    /**
     * 특정 재고 아이템의 BOM 목록 조회
     */
    List<ProductionBom> findByInventoryId(@Param("inventoryId") Long inventoryId);

    /**
     * 활성화된 BOM만 조회
     */
    List<ProductionBom> findActiveByLineId(@Param("lineId") String lineId);

    /**
     * BOM ID로 조회
     */
    ProductionBom findById(@Param("bomId") Long bomId);

    /**
     * BOM 등록
     */
    int insert(ProductionBom bom);

    /**
     * BOM 수정
     */
    int update(ProductionBom bom);

    /**
     * BOM 삭제 (소프트 삭제 - is_active = 'N')
     */
    int delete(@Param("bomId") Long bomId);

    /**
     * BOM 완전 삭제
     */
    int deleteHard(@Param("bomId") Long bomId);
}
