package com.tp.mes.app.factory.repository;

import com.tp.mes.app.factory.model.ProductionLine;
import java.util.List;
import java.util.Optional;

/**
 * 생산라인 Repository 인터페이스
 */
public interface ProductionLineRepository {

    List<ProductionLine> findAll();

    List<ProductionLine> findByFactory(String factoryId);

    List<ProductionLine> findByStatus(String status);

    List<ProductionLine> findRunning();

    Optional<ProductionLine> findById(String lineId);

    void save(ProductionLine line);

    void update(ProductionLine line);

    void delete(String lineId);

    void updateStatus(String lineId, String status, Boolean isOperating);

    void updateCurrentWorkers(String lineId, int currentWorkers);

    void updateUtilizationRate(String lineId, double utilizationRate);

    int countByFactory(String factoryId);

    void incrementWorkerCount(String lineId);

    void decrementWorkerCount(String lineId);
}
