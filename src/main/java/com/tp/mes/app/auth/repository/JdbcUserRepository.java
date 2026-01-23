package com.tp.mes.app.auth.repository;

import com.tp.mes.app.auth.model.UserRecord;
import com.tp.mes.support.OracleErrorSupport;
import java.util.List;
import java.util.Optional;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

@Repository
public class JdbcUserRepository implements UserRepository {

  private static final Logger log = LoggerFactory.getLogger(JdbcUserRepository.class);

  private final JdbcTemplate jdbcTemplate;

  public JdbcUserRepository(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
  }

  @Override
  public Optional<UserRecord> findByUsername(String username) {
    try {
      List<UserRecord> list = jdbcTemplate.query(
          "select user_id, username, password_hash, display_name, enabled_yn from app_user where username = ?",
          (rs, rowNum) -> new UserRecord(
              rs.getLong("user_id"),
              rs.getString("username"),
              rs.getString("password_hash"),
              rs.getString("display_name"),
              "Y".equalsIgnoreCase(rs.getString("enabled_yn"))),
          username);
      return list.stream().findFirst();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("app_user table not found; run scripts/oracle-init.sql");
        return Optional.empty();
      }
      throw ex;
    }
  }

  @Override
  public List<String> findRoleCodesByUserId(long userId) {
    try {
      return jdbcTemplate.query(
          "select r.role_code "
              + "from app_user_role ur join app_role r on r.role_id = ur.role_id "
              + "where ur.user_id = ? order by r.role_code",
          (rs, rowNum) -> rs.getString(1),
          userId);
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("app_user_role/app_role table not found; run scripts/oracle-init.sql");
        return List.of();
      }
      throw ex;
    }
  }

  @Override
  public void ensureRoleExists(String roleCode) {
    try {
      Integer count = jdbcTemplate.queryForObject(
          "select count(*) from app_role where role_code = ?",
          Integer.class,
          roleCode);
      if (count != null && count > 0) {
        return;
      }
      jdbcTemplate.update("insert into app_role(role_code) values (?)", roleCode);
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("app_role table not found; run scripts/oracle-init.sql");
        return;
      }
      throw ex;
    }
  }

  @Override
  public boolean hasAnyUser() {
    try {
      Integer count = jdbcTemplate.queryForObject("select count(*) from app_user", Integer.class);
      return count != null && count > 0;
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("app_user table not found; run scripts/oracle-init.sql");
        return true; // avoid boot loop / spam
      }
      throw ex;
    }
  }

  @Override
  public long insertUser(String username, String passwordHash, String displayName) {
    KeyHolder keyHolder = new GeneratedKeyHolder();
    jdbcTemplate.update(connection -> {
      var ps = connection.prepareStatement(
          "insert into app_user(username, password_hash, display_name, enabled_yn) values (?, ?, ?, 'Y')",
          new String[] { "user_id" });
      ps.setString(1, username);
      ps.setString(2, passwordHash);
      ps.setString(3, displayName);
      return ps;
    }, keyHolder);

    Number key = keyHolder.getKey();
    if (key == null) {
      throw new IllegalStateException("Failed to insert user; no generated key returned");
    }
    return key.longValue();
  }

  @Override
  public void ensureUserRole(long userId, String roleCode) {
    try {
      Integer count = jdbcTemplate.queryForObject(
          "select count(*) "
              + "from app_user_role ur "
              + "join app_role r on r.role_id = ur.role_id "
              + "where ur.user_id = ? and r.role_code = ?",
          Integer.class,
          userId,
          roleCode);
      if (count != null && count > 0) {
        return;
      }

      jdbcTemplate.update(
          "insert into app_user_role(user_id, role_id) "
              + "select ?, role_id from app_role where role_code = ?",
          userId,
          roleCode);
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("app_user_role/app_role table not found; run scripts/oracle-init.sql");
        return;
      }
      throw ex;
    }
  }
}
