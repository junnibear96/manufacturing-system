package com.tp.mes.app.notice.repository;

import com.tp.mes.app.notice.model.Notice;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.simple.SimpleJdbcInsert;
import org.springframework.stereotype.Repository;

@Repository
public class JdbcNoticeRepository implements NoticeRepository {

  private static final Logger log = LoggerFactory.getLogger(JdbcNoticeRepository.class);

  private final JdbcTemplate jdbcTemplate;
  private final SimpleJdbcInsert insert;

  public JdbcNoticeRepository(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
    this.insert = new SimpleJdbcInsert(jdbcTemplate)
        .withTableName("notice")
        .usingGeneratedKeyColumns("notice_id");
  }

  @Override
  public List<Notice> listNotices() {
    try {
      return jdbcTemplate.query(
          "select notice_id, title, body, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from notice order by notice_id desc",
          (rs, rowNum) -> new Notice(
              rs.getLong("notice_id"),
              rs.getString("title"),
              rs.getString("body"),
              rs.getString("created_at")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("notice table not found; returning fallback notices. Run scripts/oracle-init.sql");
        return List.of(new Notice(1L, "공지사항(샘플)", "scripts/oracle-init.sql 실행 후 공지 등록이 가능합니다.", "-"));
      }
      throw ex;
    }
  }

  @Override
  public Optional<Notice> findNotice(long noticeId) {
    try {
      List<Notice> items = jdbcTemplate.query(
          "select notice_id, title, body, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from notice where notice_id = ?",
          (rs, rowNum) -> new Notice(
              rs.getLong("notice_id"),
              rs.getString("title"),
              rs.getString("body"),
              rs.getString("created_at")),
          noticeId);
      return items.stream().findFirst();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("notice table not found; cannot lookup notice. Run scripts/oracle-init.sql");
        return Optional.empty();
      }
      throw ex;
    }
  }

  @Override
  public long insertNotice(String title, String body, Long createdByUserId) {
    try {
      Map<String, Object> args = new HashMap<>();
      args.put("title", title);
      args.put("body", body);
      args.put("created_by", createdByUserId);
      args.put("created_at", new java.sql.Timestamp(System.currentTimeMillis()));
      Number key = insert.executeAndReturnKey(args);
      return key.longValue();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("notice table not found; insert is skipped. Run scripts/oracle-init.sql");
        return -1L;
      }
      throw ex;
    }
  }

  @Override
  public void updateNotice(long noticeId, String title, String body, Long updatedByUserId) {
    try {
      jdbcTemplate.update(
          "update notice set title = ?, body = ? where notice_id = ?",
          title, body, noticeId);
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("notice table not found; update is skipped.");
        return;
      }
      throw ex;
    }
  }
}
