package com.tp.mes.app.prod.model;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.time.LocalDateTime;

/**
 * 생산 장비 (Equipment) - ProductionLine에 배치되는 실제 장비
 */
@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Equipment {

    private Long equipmentId; // PK
    private String equipmentCode; // 장비 코드
    private String equipmentName; // 장비명

    // 관계
    private Long processId; // FK → Process (공정)
    private String lineId; // FK → ProductionLine

    // 상태 관리
    private EquipmentStatus status; // 가동 상태
    private String activeYn; // 활성 여부 (Y/N)

    // 점검 관리
    private LocalDateTime lastMaintenanceAt; // 최근 점검 일시
    private Integer maintenanceInterval; // 점검 주기 (일)

    // 성능 지표
    private Double utilizationRate; // 가동률 (%) - 실제 가동률
    private Double targetUtilizationRate; // 목표 가동률 (%) - 설정 가능
    private Double oee; // Overall Equipment Effectiveness (종합 설비 효율)

    // 추가 정보
    private String specifications; // 스펙 (JSON 형식)

    // 메타데이터
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    /**
     * 점검이 필요한지 확인
     */
    public boolean isMaintenanceDue() {
        if (lastMaintenanceAt == null || maintenanceInterval == null) {
            return false;
        }
        return LocalDateTime.now().isAfter(
                lastMaintenanceAt.plusDays(maintenanceInterval));
    }

    /**
     * 가동 가능한 상태인지 확인
     */
    public boolean isOperational() {
        return "Y".equals(activeYn) &&
                (status == EquipmentStatus.RUNNING || status == EquipmentStatus.IDLE);
    }
}
