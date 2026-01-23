package com.tp.mes.app.hr.mapper;

import com.tp.mes.app.hr.model.Position;
import java.util.List;
import java.util.Optional;
import org.apache.ibatis.annotations.Mapper;

/**
 * 직급 MyBatis Mapper
 */
@Mapper
public interface PositionMapper {

    /**
     * 모든 직급 조회
     */
    List<Position> findAll();

    /**
     * 직무 카테고리별 직급 조회
     */
    List<Position> findByJobCategory(String jobCategory);

    /**
     * ID로 직급 조회
     */
    Optional<Position> findById(String positionId);
}
