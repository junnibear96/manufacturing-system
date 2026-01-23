package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.model.Equipment;
import com.tp.mes.app.prod.model.EquipmentStatus;
import com.tp.mes.app.prod.model.MaintenanceHistory;
import java.util.List;

/**
 * Equipment Service Interface
 */
public interface EquipmentService {

    /**
     * 전체 장비 목록 조회
     */
    List<Equipment> listAllEquipment();

    /**
     * 라인별 장비 목록 조회
     */
    List<Equipment> listEquipmentByLine(String lineId);

    /**
     * 상태별 장비 목록 조회
     */
    List<Equipment> listEquipmentByStatus(EquipmentStatus status);

    /**
     * 장비 검색 (키워드 + 상태)
     */
    List<Equipment> searchEquipment(String keyword, EquipmentStatus status);

    /**
     * ID로 장비 조회
     */
    Equipment getEquipmentById(Long equipmentId);

    /**
     * 장비 상태 변경
     */
    void updateEquipmentStatus(Long equipmentId, EquipmentStatus status);

    /**
     * 점검 기록
     */
    void recordMaintenance(Long equipmentId);

    /**
     * 점검 필요한 장비 목록
     */
    List<Equipment> findMaintenanceDueEquipment();

    /**
     * 라인의 평균 가동률
     */
    Double getAverageUtilizationRateByLine(String lineId);

    /**
     * 가동률 업데이트
     */
    void updateUtilizationRate(Long equipmentId, Double rate);

    /**
     * 점검 이력 조회
     */
    List<MaintenanceHistory> getMaintenanceHistory(Long equipmentId);

    /**
     * 점검 이력 등록
     */
    void addMaintenanceHistory(MaintenanceHistory history);
}
