package com.tp.mes.app.factory.repository;

import com.tp.mes.app.factory.mapper.ProductionLineMapper;
import com.tp.mes.app.factory.model.ProductionLine;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * 생산라인 Repository 구현체
 */
@Repository
public class MyBatisProductionLineRepository implements ProductionLineRepository {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory
            .getLogger(MyBatisProductionLineRepository.class);

    private final ProductionLineMapper productionLineMapper;

    public MyBatisProductionLineRepository(ProductionLineMapper productionLineMapper) {
        this.productionLineMapper = productionLineMapper;
    }

    @Override
    public List<ProductionLine> findAll() {
        try {
            return productionLineMapper.findAll();
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("production_lines table not found. Run scripts/factory-schema.sql");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<ProductionLine> findByFactory(String factoryId) {
        try {
            return productionLineMapper.findByFactory(factoryId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("production_lines table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<ProductionLine> findByStatus(String status) {
        try {
            return productionLineMapper.findByStatus(status);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("production_lines table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<ProductionLine> findRunning() {
        try {
            return productionLineMapper.findRunning();
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("production_lines table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public Optional<ProductionLine> findById(String lineId) {
        try {
            return productionLineMapper.findById(lineId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("production_lines table not found");
                return Optional.empty();
            }
            throw ex;
        }
    }

    @Override
    public void save(ProductionLine line) {
        productionLineMapper.insert(line);
    }

    @Override
    public void update(ProductionLine line) {
        productionLineMapper.update(line);
    }

    @Override
    public void delete(String lineId) {
        productionLineMapper.delete(lineId);
    }

    @Override
    public void updateStatus(String lineId, String status, Boolean isOperating) {
        productionLineMapper.updateStatus(lineId, status, isOperating);
    }

    @Override
    public void updateCurrentWorkers(String lineId, int currentWorkers) {
        productionLineMapper.updateCurrentWorkers(lineId, currentWorkers);
    }

    @Override
    public void updateUtilizationRate(String lineId, double utilizationRate) {
        productionLineMapper.updateUtilizationRate(lineId, utilizationRate);
    }

    @Override
    public int countByFactory(String factoryId) {
        try {
            return productionLineMapper.countByFactory(factoryId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("production_lines table not found");
                return 0;
            }
            throw ex;
        }
    }

    @Override
    public void incrementWorkerCount(String lineId) {
        productionLineMapper.incrementWorkerCount(lineId);
    }

    @Override
    public void decrementWorkerCount(String lineId) {
        productionLineMapper.decrementWorkerCount(lineId);
    }
}
