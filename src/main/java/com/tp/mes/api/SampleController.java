package com.tp.mes.api;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.springframework.http.ResponseEntity;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class SampleController {

  private final JdbcTemplate jdbc;

  public SampleController(JdbcTemplate jdbc) {
    this.jdbc = jdbc;
  }

  @GetMapping("/api/sample")
  public ResponseEntity<Map<String, Object>> sample(
      @RequestParam(name = "q", required = false, defaultValue = "TP") String q) {

    Map<String, Object> body = new LinkedHashMap<>();
    body.put("query", q);

    // Demonstrates parameter binding and Oracle SQL; safe from injection.
    List<Map<String, Object>> rows = jdbc.queryForList(
      "select ? as echo, current_timestamp as db_time from dual",
      q
    );

    body.put("rows", rows);
    return ResponseEntity.ok(body);
  }
}
