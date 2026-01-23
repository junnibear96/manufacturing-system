package com.tp.mes.app.hr.model;

import java.time.LocalDateTime;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

/**
 * 직급 정보
 */
public class Position {
        private String positionId;
        private String positionName;
        private String positionNameEn;
        private int level; // 권한 레벨 (0~5)
        private String jobCategory; // OFFICE/PRODUCTION
        private LocalDateTime createdAt;

        public Position() {
        }

        public Position(String positionId, String positionName, String positionNameEn, int level, String jobCategory,
                        LocalDateTime createdAt) {
                this.positionId = positionId;
                this.positionName = positionName;
                this.positionNameEn = positionNameEn;
                this.level = level;
                this.jobCategory = jobCategory;
                this.createdAt = createdAt;
        }

        public String getPositionId() {
                return positionId;
        }

        public void setPositionId(String positionId) {
                this.positionId = positionId;
        }

        public String getPositionName() {
                return positionName;
        }

        public void setPositionName(String positionName) {
                this.positionName = positionName;
        }

        public String getPositionNameEn() {
                return positionNameEn;
        }

        public void setPositionNameEn(String positionNameEn) {
                this.positionNameEn = positionNameEn;
        }

        public int getLevel() {
                return level;
        }

        public void setLevel(int level) {
                this.level = level;
        }

        public String getJobCategory() {
                return jobCategory;
        }

        public void setJobCategory(String jobCategory) {
                this.jobCategory = jobCategory;
        }

        public LocalDateTime getCreatedAt() {
                return createdAt;
        }

        public void setCreatedAt(LocalDateTime createdAt) {
                this.createdAt = createdAt;
        }

        @Override
        public String toString() {
                return "Position{" +
                                "positionId='" + positionId + '\'' +
                                ", positionName='" + positionName + '\'' +
                                ", positionNameEn='" + positionNameEn + '\'' +
                                ", level=" + level +
                                ", jobCategory='" + jobCategory + '\'' +
                                ", createdAt=" + createdAt +
                                '}';
        }
}
