package com.tp.mes.app.board.repository;

import com.tp.mes.app.board.model.BoardPost;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

@Repository
public class JdbcBoardRepository implements BoardRepository {

  private static final Logger log = LoggerFactory.getLogger(JdbcBoardRepository.class);

  private final JdbcTemplate jdbcTemplate;

  public JdbcBoardRepository(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
  }

  @Override
  public List<BoardPost> listPosts() {
    try {
      return jdbcTemplate.query(
          "select post_id, title, body, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from board_post order by post_id desc",
          (rs, rowNum) -> new BoardPost(
              rs.getLong("post_id"),
              rs.getString("title"),
              rs.getString("body"),
              rs.getString("created_at")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("board_post table not found; returning fallback posts. Run scripts/oracle-init.sql");
        return List.of(new BoardPost(1L, "게시판(샘플)", "테이블 생성 후 조회가 가능합니다.", "-"));
      }
      throw ex;
    }
  }

  @Override
  public Optional<BoardPost> findPost(long postId) {
    try {
      List<BoardPost> items = jdbcTemplate.query(
          "select post_id, title, body, to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from board_post where post_id = ?",
          (rs, rowNum) -> new BoardPost(
              rs.getLong("post_id"),
              rs.getString("title"),
              rs.getString("body"),
              rs.getString("created_at")),
          postId);
      return items.stream().findFirst();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("board_post table not found; cannot lookup post. Run scripts/oracle-init.sql");
        return Optional.empty();
      }
      throw ex;
    }
  }
}
