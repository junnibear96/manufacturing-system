package com.tp.mes.mvc.repository;

import java.sql.SQLException;
import org.springframework.dao.DataAccessException;

final class OracleRepositorySupport {

  private OracleRepositorySupport() {}

  static boolean isMissingTableOrView(DataAccessException ex) {
    Throwable t = ex;
    while (t != null) {
      if (t instanceof SQLException) {
        int code = ((SQLException) t).getErrorCode();
        if (code == 942) {
          return true; // ORA-00942: table or view does not exist
        }
      }
      t = t.getCause();
    }
    String msg = ex.getMessage();
    return msg != null && msg.contains("ORA-00942");
  }
}
