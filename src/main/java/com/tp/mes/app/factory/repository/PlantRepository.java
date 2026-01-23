package com.tp.mes.app.factory.repository;

import com.tp.mes.app.factory.model.Plant;
import java.util.List;
import java.util.Optional;

/**
 * 사업장 Repository 인터페이스
 */
public interface PlantRepository {

    List<Plant> findAll();

    List<Plant> findByType(String plantType);

    List<Plant> findByStatus(String status);

    Optional<Plant> findById(String plantId);

    void save(Plant plant);

    void update(Plant plant);

    void delete(String plantId);
}
