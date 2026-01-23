package com.tp.mes.mvc.repository;

import com.tp.mes.mvc.model.ProjectItem;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class JdbcPortfolioRepository implements PortfolioRepository {

  private static final Logger log = LoggerFactory.getLogger(JdbcPortfolioRepository.class);

  private final JdbcTemplate jdbcTemplate;

  public JdbcPortfolioRepository(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
  }

  @Override
  public List<String> getSkills() {
    try {
      return jdbcTemplate.query(
          "select skill_name from skill order by sort_order nulls last, skill_name",
          (rs, rowNum) -> rs.getString(1)
      );
    } catch (DataAccessException ex) {
      if (OracleRepositorySupport.isMissingTableOrView(ex)) {
        log.warn("skill table not found; returning fallback skills. Run scripts/oracle-init.sql to create tables.");
        return List.of("HTML", "Java", "JSP", "JavaScript", "Spring", "Oracle", "PL/SQL");
      }
      throw ex;
    }
  }

  @Override
  public List<ProjectItem> getProjects() {
    try {
      List<ProjectRow> projects = jdbcTemplate.query(
          "select project_id, title, stack from project order by sort_order nulls last, project_id",
          (rs, rowNum) -> new ProjectRow(rs.getLong(1), rs.getString(2), rs.getString(3))
      );

      Map<Long, List<String>> highlightsByProjectId = new HashMap<>();
      jdbcTemplate.query(
          "select project_id, highlight from project_highlight order by sort_order nulls last, highlight_id",
          rs -> {
            long projectId = rs.getLong(1);
            String highlight = rs.getString(2);
            highlightsByProjectId.computeIfAbsent(projectId, k -> new ArrayList<>()).add(highlight);
          }
      );

      List<ProjectItem> result = new ArrayList<>();
      for (ProjectRow p : projects) {
        List<String> highlights = highlightsByProjectId.getOrDefault(p.projectId, List.of());
        result.add(new ProjectItem(p.title, p.stack, highlights));
      }
      return result;
    } catch (DataAccessException ex) {
      if (OracleRepositorySupport.isMissingTableOrView(ex)) {
        log.warn("project/project_highlight tables not found; returning fallback projects. Run scripts/oracle-init.sql to create tables.");
        return List.of(
            new ProjectItem(
                "MES 생산실적/추적성 기능 개선",
                "Java · JSP · Spring · Oracle(PL/SQL)",
                List.of(
                    "현장 프로세스 기반 화면/업무 흐름 정리 및 개선",
                    "대용량 조회 성능 개선(쿼리 튜닝, 인덱스 점검)",
                    "장애 재발 방지(로그/모니터링 기준 정비)"
                )
            ),
            new ProjectItem(
                "기존 시스템 유지보수 & 운영 안정화",
                "운영 · 배포 · RCA · 성능",
                List.of(
                    "반복 이슈 원인 분석 및 조치 표준화",
                    "배치/인터페이스 오류 케이스 보강",
                    "운영 문서화(장애 대응/릴리즈 체크리스트)"
                )
            )
        );
      }
      throw ex;
    }
  }

  private static final class ProjectRow {

    private final long projectId;
    private final String title;
    private final String stack;

    private ProjectRow(long projectId, String title, String stack) {
      this.projectId = projectId;
      this.title = title;
      this.stack = stack;
    }
  }
}
