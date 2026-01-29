package com.tp.mes.app.inventory.repository;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import org.apache.ibatis.annotations.Update;
import java.math.BigDecimal;

@Mapper
public interface MaterialRepository {

    @Update("UPDATE materials SET current_stock = current_stock - #{amount}, updated_at = SYSDATE WHERE material_id = #{materialId}")
    int deductStock(@Param("materialId") String materialId, @Param("amount") BigDecimal amount);

    @Update("UPDATE materials SET current_stock = current_stock + #{amount}, updated_at = SYSDATE WHERE material_id = #{materialId}")
    int addStock(@Param("materialId") String materialId, @Param("amount") BigDecimal amount);
}
