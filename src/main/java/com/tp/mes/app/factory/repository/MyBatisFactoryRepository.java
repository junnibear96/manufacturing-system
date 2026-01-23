package com.tp.mes.app.factory.repository;

import com.tp.mes.app.factory.mapper.FactoryMapper;
import com.tp.mes.app.factory.model.Factory;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * 공장 Repository 구현체
 */
@Repository
public class MyBatisFactoryRepository implements FactoryRepository {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MyBatisFactoryRepository.class);

    private final FactoryMapper factoryMapper;

    public MyBatisFactoryRepository(FactoryMapper factoryMapper) {
        this.factoryMapper = factoryMapper;
    }

    @Override
    public List<Factory> findAll() {
        try {
            return factoryMapper.findAll();
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("factories table not found. Run scripts/factory-schema.sql");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<Factory> findByPlant(String plantId) {
        try {
            return factoryMapper.findByPlant(plantId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("factories table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<Factory> findByType(String factoryType) {
        try {
            return factoryMapper.findByType(factoryType);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("factories table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<Factory> findByStatus(String status) {
        try {
            return factoryMapper.findByStatus(status);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("factories table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public Optional<Factory> findById(String factoryId) {
        try {
            return factoryMapper.findById(factoryId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("factories table not found");
                return Optional.empty();
            }
            throw ex;
        }
    }

    @Override
    public void save(Factory factory) {
        factoryMapper.insert(factory);
    }

    @Override
    public void update(Factory factory) {
        factoryMapper.update(factory);
    }

    @Override
    public void delete(String factoryId) {
        factoryMapper.delete(factoryId);
    }

    @Override
    public int countByPlant(String plantId) {
        try {
            return factoryMapper.countByPlant(plantId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("factories table not found");
                return 0;
            }
            throw ex;
        }
    }
}
