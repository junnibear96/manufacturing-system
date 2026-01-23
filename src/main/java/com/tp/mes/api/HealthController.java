package com.tp.mes.api;

import java.time.Instant;
import java.util.LinkedHashMap;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HealthController {

  private final JdbcTemplate jdbcTemplate;

  public HealthController(JdbcTemplate jdbcTemplate) {
    this.jdbcTemplate = jdbcTemplate;
  }

  @GetMapping("/api/health")
  public ResponseEntity<Map<String, Object>> health() {
    Map<String, Object> body = new LinkedHashMap<>();
    body.put("status", "UP");
    body.put("time", Instant.now().toString());

    Map<String, Object> db = new LinkedHashMap<>();
    try {
      Object now = jdbcTemplate.queryForObject("select current_timestamp from dual", Object.class);
      db.put("connected", true);
      db.put("current_timestamp", String.valueOf(now));
    } catch (Exception ex) {
      db.put("connected", false);
      db.put("error", ex.getClass().getSimpleName());
      db.put("message", ex.getMessage());
    }

    body.put("db", db);
    return ResponseEntity.ok(body);
  }
}
