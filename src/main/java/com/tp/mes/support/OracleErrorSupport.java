package com.tp.mes.support;

import java.sql.SQLException;
import org.springframework.dao.DataAccessException;

public final class OracleErrorSupport {

  private OracleErrorSupport() {}

  public static boolean isMissingTableOrView(DataAccessException ex) {
    Throwable t = ex;
    while (t != null) {
      if (t instanceof SQLException) {
        int code = ((SQLException) t).getErrorCode();
        if (code == 942) {
          return true;
        }
      }
      t = t.getCause();
    }
    String msg = ex.getMessage();
    return msg != null && msg.contains("ORA-00942");
  }
}
