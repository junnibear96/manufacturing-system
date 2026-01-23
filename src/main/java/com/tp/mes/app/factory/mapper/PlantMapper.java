package com.tp.mes.app.factory.mapper;

import com.tp.mes.app.factory.model.Plant;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;

/**
 * 사업장 MyBatis Mapper
 */
@Mapper
public interface PlantMapper {

    /**
     * 모든 사업장 조회
     */
    List<Plant> findAll();

    /**
     * 유형별 사업장 조회
     */
    List<Plant> findByType(String plantType);

    /**
     * 상태별 사업장 조회
     */
    List<Plant> findByStatus(String status);

    /**
     * ID로 사업장 조회
     */
    Optional<Plant> findById(String plantId);

    /**
     * 사업장 등록
     */
    void insert(Plant plant);

    /**
     * 사업장 수정
     */
    void update(Plant plant);

    /**
     * 사업장 삭제
     */
    void delete(String plantId);
}
