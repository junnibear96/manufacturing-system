package com.tp.mes.app.prod.service;

import com.tp.mes.app.prod.mapper.EquipmentMapper;
import com.tp.mes.app.prod.model.Equipment;
import com.tp.mes.app.prod.model.EquipmentStatus;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * Equipment Service Implementation
 */
@Service
public class DefaultEquipmentService implements EquipmentService {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(DefaultEquipmentService.class);

    private final EquipmentMapper equipmentMapper;
    private final com.tp.mes.app.prod.mapper.MaintenanceHistoryMapper historyMapper;

    public DefaultEquipmentService(EquipmentMapper equipmentMapper,
            com.tp.mes.app.prod.mapper.MaintenanceHistoryMapper historyMapper) {
        this.equipmentMapper = equipmentMapper;
        this.historyMapper = historyMapper;
    }

    @Override
    public List<Equipment> listAllEquipment() {
        log.debug("Listing all equipment");
        return equipmentMapper.findAll();
    }

    @Override
    public List<Equipment> listEquipmentByLine(String lineId) {
        log.debug("Listing equipment for line: {}", lineId);
        return equipmentMapper.findByLineId(lineId);
    }

    @Override
    public List<Equipment> listEquipmentByStatus(EquipmentStatus status) {
        log.debug("Listing equipment by status: {}", status);
        return equipmentMapper.findByStatus(status.name());
    }

    @Override
    public List<Equipment> searchEquipment(String keyword, EquipmentStatus status) {
        log.debug("Searching equipment with keyword: {}, status: {}", keyword, status);
        String statusStr = status != null ? status.name() : null;
        return equipmentMapper.search(keyword, statusStr);
    }

    @Override
    public Equipment getEquipmentById(Long equipmentId) {
        log.debug("Getting equipment by ID: {}", equipmentId);
        return equipmentMapper.findById(equipmentId);
    }

    @Override
    @Transactional
    public void updateEquipmentStatus(Long equipmentId, EquipmentStatus status) {
        log.info("Updating equipment {} status to {}", equipmentId, status);
        int updated = equipmentMapper.updateStatus(equipmentId, status.name());
        if (updated == 0) {
            log.warn("Equipment {} not found", equipmentId);
            throw new IllegalArgumentException("Equipment not found: " + equipmentId);
        }
    }

    @Override
    @Transactional
    public void recordMaintenance(Long equipmentId) {
        log.info("Recording maintenance for equipment {}", equipmentId);

        // 점검 기록
        int updated = equipmentMapper.recordMaintenance(equipmentId);
        if (updated == 0) {
            log.warn("Equipment {} not found", equipmentId);
            throw new IllegalArgumentException("Equipment not found: " + equipmentId);
        }

        // 상태를 MAINTENANCE로 변경
        equipmentMapper.updateStatus(equipmentId, EquipmentStatus.MAINTENANCE.name());
    }

    @Override
    public List<Equipment> findMaintenanceDueEquipment() {
        log.debug("Finding maintenance due equipment");
        return equipmentMapper.findMaintenanceDue();
    }

    @Override
    public Double getAverageUtilizationRateByLine(String lineId) {
        log.debug("Getting average utilization rate for line: {}", lineId);
        Double rate = equipmentMapper.getAverageUtilizationRateByLine(lineId);
        return rate != null ? rate : 0.0;
    }

    @Override
    @Transactional
    public void updateUtilizationRate(Long equipmentId, Double rate) {
        log.info("Updating utilization rate for equipment {}: {}%", equipmentId, rate);
        int updated = equipmentMapper.updateUtilizationRate(equipmentId, rate);
        if (updated == 0) {
            log.warn("Equipment {} not found", equipmentId);
            throw new IllegalArgumentException("Equipment not found: " + equipmentId);
        }
    }

    @Override
    public List<com.tp.mes.app.prod.model.MaintenanceHistory> getMaintenanceHistory(Long equipmentId) {
        return historyMapper.findByEquipmentId(equipmentId);
    }

    @Override
    public void addMaintenanceHistory(com.tp.mes.app.prod.model.MaintenanceHistory history) {
        historyMapper.insert(history);
    }
}
