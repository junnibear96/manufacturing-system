package com.tp.mes.app.group.repository;

import com.tp.mes.app.group.model.GroupCompany;
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
public class JdbcGroupCompanyRepository implements GroupCompanyRepository {

  private static final Logger log = LoggerFactory.getLogger(JdbcGroupCompanyRepository.class);

  private final JdbcTemplate jdbcTemplate;
  private final SimpleJdbcInsert insert;

  public JdbcGroupCompanyRepository(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
    this.insert = new SimpleJdbcInsert(jdbcTemplate)
        .withTableName("group_company")
        .usingGeneratedKeyColumns("company_id");
  }

  @Override
  public List<GroupCompany> listCompanies() {
    try {
      return jdbcTemplate.query(
          "select company_id, company_code, company_name, description, active_yn, "
              + "to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from group_company "
              + "order by active_yn desc, company_name",
          (rs, rowNum) -> new GroupCompany(
              rs.getLong("company_id"),
              rs.getString("company_code"),
              rs.getString("company_name"),
              rs.getString("description"),
              rs.getString("active_yn"),
              rs.getString("created_at")));
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("group_company table not found; returning fallback companies. Run scripts/oracle-init.sql");
        return List.of(
            new GroupCompany(1L, "TP", "TP", "Demo group company", "Y", "-"));
      }
      throw ex;
    }
  }

  @Override
  public Optional<GroupCompany> findCompany(long companyId) {
    try {
      List<GroupCompany> items = jdbcTemplate.query(
          "select company_id, company_code, company_name, description, active_yn, "
              + "to_char(created_at, 'YYYY-MM-DD HH24:MI') as created_at "
              + "from group_company where company_id = ?",
          (rs, rowNum) -> new GroupCompany(
              rs.getLong("company_id"),
              rs.getString("company_code"),
              rs.getString("company_name"),
              rs.getString("description"),
              rs.getString("active_yn"),
              rs.getString("created_at")),
          companyId);
      return items.stream().findFirst();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("group_company table not found; cannot lookup company. Run scripts/oracle-init.sql");
        return Optional.empty();
      }
      throw ex;
    }
  }

  @Override
  public long insertCompany(String companyCode, String companyName, String description, String activeYn) {
    try {
      Map<String, Object> args = new HashMap<>();
      args.put("company_code", companyCode);
      args.put("company_name", companyName);
      args.put("description", description);
      args.put("active_yn", activeYn);
      Number key = insert.executeAndReturnKey(args);
      return key.longValue();
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("group_company table not found; insert is skipped. Run scripts/oracle-init.sql");
        return -1L;
      }
      throw ex;
    }
  }

  @Override
  public boolean updateCompany(long companyId, String companyCode, String companyName, String description,
      String activeYn) {
    try {
      int updated = jdbcTemplate.update(
          "update group_company "
              + "set company_code = ?, company_name = ?, description = ?, active_yn = ? "
              + "where company_id = ?",
          companyCode,
          companyName,
          description,
          activeYn,
          companyId);
      return updated == 1;
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("group_company table not found; update is skipped. Run scripts/oracle-init.sql");
        return false;
      }
      throw ex;
    }
  }

  @Override
  public boolean deleteCompany(long companyId) {
    try {
      int updated = jdbcTemplate.update(
          "delete from group_company where company_id = ?",
          companyId);
      return updated == 1;
    } catch (DataAccessException ex) {
      if (OracleErrorSupport.isMissingTableOrView(ex)) {
        log.warn("group_company table not found; delete is skipped. Run scripts/oracle-init.sql");
        return false;
      }
      throw ex;
    }
  }
}
