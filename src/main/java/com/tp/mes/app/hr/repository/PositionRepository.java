package com.tp.mes.app.hr.repository;

import com.tp.mes.app.hr.model.Position;
import java.util.List;
import java.util.Optional;

public interface PositionRepository {
    List<Position> findAll();

    List<Position> findByJobCategory(String jobCategory);

    Optional<Position> findById(String positionId);
}
