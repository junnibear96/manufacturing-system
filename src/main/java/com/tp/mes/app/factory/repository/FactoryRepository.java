package com.tp.mes.app.factory.repository;

import com.tp.mes.app.factory.model.Factory;
import java.util.List;
import java.util.Optional;

/**
 * 공장 Repository 인터페이스
 */
public interface FactoryRepository {

    List<Factory> findAll();

    List<Factory> findByPlant(String plantId);

    List<Factory> findByType(String factoryType);

    List<Factory> findByStatus(String status);

    Optional<Factory> findById(String factoryId);

    void save(Factory factory);

    void update(Factory factory);

    void delete(String factoryId);

    int countByPlant(String plantId);
}
