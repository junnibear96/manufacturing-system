package com.tp.mes.app.prod.mapper;

import com.tp.mes.app.prod.model.MaintenanceHistory;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface MaintenanceHistoryMapper {
    List<MaintenanceHistory> findByEquipmentId(@Param("equipmentId") Long equipmentId);

    int insert(MaintenanceHistory history);
}
