package com.tp.mes.app.prod.mapper;

import com.tp.mes.app.prod.model.Equipment;
import org.apache.ibatis.annotations.*;
import java.util.List;

/**
 * Equipment MyBatis Mapper
 */
@Mapper
public interface EquipmentMapper {

        /**
         * ID로 장비 조회
         */
        Equipment findById(@Param("equipmentId") Long equipmentId);

        /**
         * 코드로 장비 조회
         */
        Equipment findByCode(@Param("equipmentCode") String equipmentCode);

        /**
         * 라인별 장비 목록
         */
        List<Equipment> findByLineId(@Param("lineId") String lineId);

        /**
         * 상태별 장비 목록
         */
        List<Equipment> findByStatus(@Param("status") String status);

        /**
         * 장비 검색 (키워드 + 상태)
         */
        List<Equipment> search(@Param("keyword") String keyword, @Param("status") String status);

        /**
         * 전체 장비 목록
         */
        List<Equipment> findAll();

        /**
         * 장비 상태 업데이트
         */
        int updateStatus(@Param("equipmentId") Long equipmentId, @Param("status") String status);

        /**
         * 점검 기록
         */
        int recordMaintenance(@Param("equipmentId") Long equipmentId);

        /**
         * 가동률 업데이트
         */
        int updateUtilizationRate(@Param("equipmentId") Long equipmentId, @Param("rate") Double rate);

        /**
         * 점검이 필요한 장비 목록 조회
         */
        List<Equipment> findMaintenanceDue();

        /**
         * 라인의 평균 가동률 조회
         */
        Double getAverageUtilizationRateByLine(@Param("lineId") String lineId);

        /**
         * 목표 가동률 업데이트
         */
        int updateTargetUtilizationRate(@Param("equipmentId") Long equipmentId, @Param("rate") Double targetRate);
}
