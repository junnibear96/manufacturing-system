package com.tp.mes.api;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/admin")
public class SchemaInitController {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @PostMapping("/init-full-data")
    public Map<String, Object> initFullData() {
        Map<String, Object> response = new HashMap<>();
        List<String> logs = new ArrayList<>();

        try {
            // 1. Initialize Schema (Create Tables)
            logs.add("=== Stage 1: Initializing Schema ===");
            executeScript("scripts/hrm-schema.sql", logs);

            // 2. Load Extended Data (Insert Employees)
            logs.add("=== Stage 2: Loading Employee Data ===");
            executeScript("scripts/insert-extended-employees.sql", logs);

            response.put("success", true);
            response.put("message", "Full initialization completed successfully.");
            response.put("logs", logs);

        } catch (Exception e) {
            response.put("success", false);
            response.put("error", e.getMessage());
            response.put("logs", logs);
            e.printStackTrace();
        }

        return response;
    }

    private void executeScript(String scriptPath, List<String> logs) throws Exception {
        try {
            String content = new String(Files.readAllBytes(Paths.get(scriptPath)), StandardCharsets.UTF_8);
            String[] statements = content.split(";");
            int successCount = 0;
            int failCount = 0;

            for (String sql : statements) {
                sql = sql.trim();

                // Skip comments and empty lines
                if (sql.isEmpty() || sql.startsWith("--") || sql.startsWith("//")) {
                    continue;
                }

                // Skip COMMIT/ROLLBACK as we might want transaction control or auto-commit
                if (sql.equalsIgnoreCase("COMMIT") || sql.equalsIgnoreCase("ROLLBACK")) {
                    continue;
                }

                // Skip SELECT statements which are usually for verification
                if (sql.toUpperCase().startsWith("SELECT")) {
                    continue;
                }

                try {
                    jdbcTemplate.execute(sql);
                    successCount++;
                } catch (Exception e) {
                    failCount++;
                    // Log specific errors for debugging if needed, but usually we continue
                    // ORA-00955: name is already used by an existing object (Table exists)
                    // ORA-00001: unique constraint violated (Data exists)
                    String msg = e.getMessage();
                    if (msg != null && !msg.contains("ORA-00955") && !msg.contains("ORA-00001")) {
                        logs.add("Error executing: " + (sql.length() > 50 ? sql.substring(0, 50) + "..." : sql) + " -> "
                                + msg);
                    }
                }
            }
            logs.add("Executed " + scriptPath + ": " + successCount + " success, " + failCount + " ignored/failed.");

        } catch (Exception e) {
            logs.add("Failed to read or execute script " + scriptPath + ": " + e.getMessage());
            throw e;
        }
    }
}
