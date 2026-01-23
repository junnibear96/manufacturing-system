package com.tp.mes.app.factory.service;

import com.tp.mes.app.factory.model.Factory;
import com.tp.mes.app.factory.model.Plant;
import com.tp.mes.app.factory.model.ProductionLine;
import com.tp.mes.app.factory.repository.FactoryRepository;
import com.tp.mes.app.factory.repository.PlantRepository;
import com.tp.mes.app.factory.repository.ProductionLineRepository;
import java.util.List;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * 공장 관리 Service
 */
@Service
@Transactional(readOnly = true)
public class FactoryService {

    private static final org.slf4j.Logger log = org.slf4j.LoggerFactory.getLogger(FactoryService.class);

    private final PlantRepository plantRepository;
    private final FactoryRepository factoryRepository;
    private final ProductionLineRepository lineRepository;

    public FactoryService(PlantRepository plantRepository, FactoryRepository factoryRepository,
            ProductionLineRepository lineRepository) {
        this.plantRepository = plantRepository;
        this.factoryRepository = factoryRepository;
        this.lineRepository = lineRepository;
    }

    // ========== Plant 관련 ==========

    public List<Plant> getAllPlants() {
        return plantRepository.findAll();
    }

    public List<Plant> getPlantsByType(String type) {
        return plantRepository.findByType(type);
    }

    public List<Plant> getPlantsByStatus(String status) {
        return plantRepository.findByStatus(status);
    }

    public Optional<Plant> getPlantById(String plantId) {
        return plantRepository.findById(plantId);
    }

    @Transactional
    public void createPlant(Plant plant) {
        log.info("Creating new plant: {}", plant.getPlantId());
        plantRepository.save(plant);
    }

    @Transactional
    public void updatePlant(Plant plant) {
        log.info("Updating plant: {}", plant.getPlantId());
        plantRepository.update(plant);
    }

    @Transactional
    public void deletePlant(String plantId) {
        log.info("Deleting plant: {}", plantId);
        plantRepository.delete(plantId);
    }

    // ========== Factory 관련 ==========

    public List<Factory> getAllFactories() {
        return factoryRepository.findAll();
    }

    public List<Factory> getFactoriesByPlant(String plantId) {
        return factoryRepository.findByPlant(plantId);
    }

    public List<Factory> getFactoriesByType(String type) {
        return factoryRepository.findByType(type);
    }

    public List<Factory> getFactoriesByStatus(String status) {
        return factoryRepository.findByStatus(status);
    }

    public Optional<Factory> getFactoryById(String factoryId) {
        return factoryRepository.findById(factoryId);
    }

    @Transactional
    public void createFactory(Factory factory) {
        log.info("Creating new factory: {} in plant: {}", factory.getFactoryId(), factory.getPlantId());
        factoryRepository.save(factory);
    }

    @Transactional
    public void updateFactory(Factory factory) {
        log.info("Updating factory: {}", factory.getFactoryId());
        factoryRepository.update(factory);
    }

    @Transactional
    public void deleteFactory(String factoryId) {
        log.info("Deleting factory: {}", factoryId);
        factoryRepository.delete(factoryId);
    }

    public int getFactoryCountByPlant(String plantId) {
        return factoryRepository.countByPlant(plantId);
    }

    // ========== Production Line 관련 ==========

    public List<ProductionLine> getAllLines() {
        return lineRepository.findAll();
    }

    public List<ProductionLine> getLinesByFactory(String factoryId) {
        return lineRepository.findByFactory(factoryId);
    }

    public List<ProductionLine> getLinesByStatus(String status) {
        return lineRepository.findByStatus(status);
    }

    public List<ProductionLine> getRunningLines() {
        return lineRepository.findRunning();
    }

    public Optional<ProductionLine> getLineById(String lineId) {
        return lineRepository.findById(lineId);
    }

    @Transactional
    public void createLine(ProductionLine line) {
        log.info("Creating new production line: {} in factory: {}", line.getLineId(), line.getFactoryId());
        lineRepository.save(line);
    }

    @Transactional
    public void updateLine(ProductionLine line) {
        log.info("Updating production line: {}", line.getLineId());
        lineRepository.update(line);
    }

    @Transactional
    public void deleteLine(String lineId) {
        log.info("Deleting production line: {}", lineId);
        lineRepository.delete(lineId);
    }

    @Transactional
    public void changeLineStatus(String lineId, String status, Boolean isOperating) {
        log.info("Changing line {} status to: {} (operating: {})", lineId, status, isOperating);
        lineRepository.updateStatus(lineId, status, isOperating);
    }

    @Transactional
    public void updateLineWorkers(String lineId, int currentWorkers) {
        log.info("Updating line {} workers to: {}", lineId, currentWorkers);
        lineRepository.updateCurrentWorkers(lineId, currentWorkers);
    }

    @Transactional
    public void updateLineUtilization(String lineId, double utilizationRate) {
        log.info("Updating line {} utilization to: {}%", lineId, utilizationRate);
        lineRepository.updateUtilizationRate(lineId, utilizationRate);
    }

    public int getLineCountByFactory(String factoryId) {
        return lineRepository.countByFactory(factoryId);
    }

    // ========== 통합 조회 ==========

    /**
     * 사업장의 모든 운영 정보 조회 (사업장 + 공장 + 라인)
     */
    public PlantOperationInfo getPlantOperationInfo(String plantId) {
        Plant plant = plantRepository.findById(plantId)
                .orElseThrow(() -> new IllegalArgumentException("Plant not found: " + plantId));

        List<Factory> factories = factoryRepository.findByPlant(plantId);

        // 각 공장의 라인 정보도 조회
        for (Factory factory : factories) {
            List<ProductionLine> lines = lineRepository.findByFactory(factory.getFactoryId());
            // DTO에 추가 로직 필요시 여기서 처리
        }

        return new PlantOperationInfo(plant, factories);
    }

    /**
     * 사업장 운영 정보 DTO
     */
    public record PlantOperationInfo(Plant plant, List<Factory> factories) {
    }
}
