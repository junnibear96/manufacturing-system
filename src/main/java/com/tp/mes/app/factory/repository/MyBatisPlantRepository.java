package com.tp.mes.app.factory.repository;

import com.tp.mes.app.factory.mapper.PlantMapper;
import com.tp.mes.app.factory.model.Plant;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.dao.DataAccessException;
import org.springframework.stereotype.Repository;

/**
 * 사업장 Repository 구현체
 */
@Repository
public class MyBatisPlantRepository implements PlantRepository {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(MyBatisPlantRepository.class);

    private final PlantMapper plantMapper;

    public MyBatisPlantRepository(PlantMapper plantMapper) {
        this.plantMapper = plantMapper;
    }

    @Override
    public List<Plant> findAll() {
        try {
            log.debug("Fetching all plants");
            return plantMapper.findAll();
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("plants table not found. Run scripts/factory-schema.sql");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<Plant> findByType(String plantType) {
        try {
            return plantMapper.findByType(plantType);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("plants table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public List<Plant> findByStatus(String status) {
        try {
            return plantMapper.findByStatus(status);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("plants table not found");
                return List.of();
            }
            throw ex;
        }
    }

    @Override
    public Optional<Plant> findById(String plantId) {
        try {
            return plantMapper.findById(plantId);
        } catch (DataAccessException ex) {
            if (OracleErrorSupport.isMissingTableOrView(ex)) {
                log.warn("plants table not found");
                return Optional.empty();
            }
            throw ex;
        }
    }

    @Override
    public void save(Plant plant) {
        plantMapper.insert(plant);
    }

    @Override
    public void update(Plant plant) {
        plantMapper.update(plant);
    }

    @Override
    public void delete(String plantId) {
        plantMapper.delete(plantId);
    }
}
