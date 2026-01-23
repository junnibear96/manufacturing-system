package com.tp.mes.util;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Component;

import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;

//@Component  // Uncomment to enable automatic execution on startup
public class EmployeeDataLoader implements CommandLineRunner {

    @Autowired
    private JdbcTemplate jdbcTemplate;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("\n=== Loading Extended Employee Data ===");

        String scriptPath = "scripts/insert-extended-employees.sql";
        String content = new String(Files.readAllBytes(Paths.get(scriptPath)));

        // Split by semicolons
        String[] statements = content.split(";");
        int employeeCount = 0;
        int roleCount = 0;

        for (String sql : statements) {
            sql = sql.trim();
            if (sql.isEmpty() || sql.startsWith("--") || sql.equalsIgnoreCase("COMMIT")) {
                continue;
            }

            try {
                jdbcTemplate.execute(sql);

                if (sql.toUpperCase().startsWith("INSERT INTO EMPLOYEES")) {
                    employeeCount++;
                    System.out.println("✓ Employee " + employeeCount + " inserted");
                } else if (sql.toUpperCase().startsWith("INSERT INTO EMPLOYEE_ROLES")) {
                    roleCount++;
                    if (roleCount % 10 == 0) {
                        System.out.println("✓ " + roleCount + " roles assigned");
                    }
                }
            } catch (Exception e) {
                // Skip duplicate entries
                if (!e.getMessage().contains("unique constraint") && !e.getMessage().contains("duplicate")) {
                    System.err.println("Error: " + e.getMessage().substring(0, Math.min(100, e.getMessage().length())));
                }
            }
        }

        System.out.println("\n=== Summary ===");
        System.out.println("Total employees inserted: " + employeeCount);
        System.out.println("Total roles assigned: " + roleCount);
        System.out.println("✓ Employee data loaded successfully!\n");
    }
}
