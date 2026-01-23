package com.tp.mes.app.factory.mapper;

import com.tp.mes.app.factory.model.Factory;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;

/**
 * 공장 MyBatis Mapper
 */
@Mapper
public interface FactoryMapper {

    /**
     * 모든 공장 조회
     */
    List<Factory> findAll();

    /**
     * 사업장별 공장 조회
     */
    List<Factory> findByPlant(String plantId);

    /**
     * 유형별 공장 조회
     */
    List<Factory> findByType(String factoryType);

    /**
     * 상태별 공장 조회
     */
    List<Factory> findByStatus(String status);

    /**
     * ID로 공장 조회
     */
    Optional<Factory> findById(String factoryId);

    /**
     * 공장 등록
     */
    void insert(Factory factory);

    /**
     * 공장 수정
     */
    void update(Factory factory);

    /**
     * 공장 삭제
     */
    void delete(String factoryId);

    /**
     * 사업장별 공장 수 조회
     */
    int countByPlant(String plantId);
}
