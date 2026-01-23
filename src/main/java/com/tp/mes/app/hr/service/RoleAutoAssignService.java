package com.tp.mes.app.hr.service;

import com.tp.mes.app.hr.model.Position;
import com.tp.mes.app.hr.repository.PositionRepository;
import java.util.ArrayList;
import java.util.List;
import org.springframework.stereotype.Service;

/**
 * 부서 + 직급 기반 Role 자동 매핑 서비스
 * 
 * 매핑 규칙:
 * - IT팀 + 과장 이상 → ROLE_ADMIN
 * - 생산팀 + 팀장/차장 → ROLE_MANAGER + ROLE_PRODUCTION
 * - 생산팀 + 반장/조장 → ROLE_PRODUCTION
 * - 생산팀 + 작업자 → ROLE_WORKER
 * - 품질관리팀 → ROLE_QUALITY
 * - 재고관리팀 → ROLE_INVENTORY
 * - 모든 사용자 → ROLE_USER (기본)
 * TEMPORARILY DISABLED - HRM system being reimplemented
 */
@Service
public class RoleAutoAssignService {

    private final PositionRepository positionRepository;

    public RoleAutoAssignService(PositionRepository positionRepository) {
        this.positionRepository = positionRepository;
    }

    /**
     * 부서 + 직급에 따라 자동으로 Role 목록 반환
     */
    public List<String> assignRoles(String departmentId, String positionId) {
        List<String> roles = new ArrayList<>();

        // 기본 권한
        roles.add("ROLE_USER");

        // 직급 정보 조회
        Position position = positionRepository.findById(positionId).orElse(null);
        int level = (position != null) ? position.getLevel() : 0;

        // 부서별 자동 할당
        if ("IT001".equals(departmentId)) {
            // IT팀은 과장(level 2) 이상만 전체 관리자
            if (level >= 2) {
                roles.add("ROLE_ADMIN");
                roles.add("ROLE_MANAGER");
            }
        } else if (departmentId.startsWith("PROD")) {
            // 생산팀
            if (level >= 3) {
                // 팀장급 이상: 관리자 + 생산 권한
                roles.add("ROLE_MANAGER");
                roles.add("ROLE_PRODUCTION");
            } else if (level >= 1) {
                // 조장/반장: 생산 권한만
                roles.add("ROLE_PRODUCTION");
            } else {
                // 작업자: Worker 권한
                roles.add("ROLE_WORKER");
            }
        } else if ("QC001".equals(departmentId)) {
            // 품질관리팀
            roles.add("ROLE_QUALITY");
            if (level >= 2) {
                roles.add("ROLE_MANAGER");
            }
        } else if (departmentId.startsWith("INV") || departmentId.startsWith("SHIP")) {
            // 재고/배송 관리팀
            roles.add("ROLE_INVENTORY");
            if (level >= 2) {
                roles.add("ROLE_MANAGER");
            }
        } else if ("HR001".equals(departmentId)) {
            // 인사팀
            if (level >= 2) {
                roles.add("ROLE_MANAGER");
            }
        }

        return roles;
    }

    /**
     * 자동 매핑 규칙 설명 반환 (UI에 표시용)
     */
    public String getRoleMappingDescription(String departmentId, String positionId) {
        List<String> roles = assignRoles(departmentId, positionId);
        return String.join(", ", roles);
    }
}
