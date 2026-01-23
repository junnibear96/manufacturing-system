# Run Equipment Fix Script
# This script reads the SQL file and executes it via JDBC

$ErrorActionPreference = "Stop"

Write-Host "`n=== Running Equipment Fix ===" -ForegroundColor Cyan

# Database configuration
$dbUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"
$dbUser = "system"
$dbPass = "oracletest"

# Read SQL file
$sqlFile = "scripts\check_employee_roles.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: SQL file not found: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "Reading SQL file: $sqlFile" -ForegroundColor Yellow
$sqlContent = Get-Content $sqlFile -Raw -Encoding UTF8

# Split by slash for PL/SQL blocks
$statements = $sqlContent -split '/' | Where-Object { $_.Trim() -ne '' }

Write-Host "Found $($statements.Count) SQL statements to execute" -ForegroundColor Yellow

# Create a temporary Java program to execute SQL
$javaCode = @"
import java.sql.*;

public class RunFix {
    public static void main(String[] args) {
        String url = args[0];
        String user = args[1];
        String pass = args[2];
        
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            
            System.out.println("Connected to Oracle database");
            
            // Read SQL from stdin
            java.io.BufferedReader reader = new java.io.BufferedReader(
                new java.io.InputStreamReader(System.in, "UTF-8"));
            StringBuilder sql = new StringBuilder();
            String line;
            int count = 0;
            
            while ((line = reader.readLine()) != null) {
                if (line.trim().equals("--SPLIT--")) {
                    String statement = sql.toString().trim();
                    if (!statement.isEmpty() && !statement.startsWith("--")) {
                        try {
                            if (statement.toUpperCase().startsWith("SELECT")) {
                                ResultSet rs = stmt.executeQuery(statement);
                                ResultSetMetaData md = rs.getMetaData();
                                int cols = md.getColumnCount();
                                while (rs.next()) {
                                    for (int i=1; i<=cols; i++) {
                                        System.out.print(rs.getString(i) + "\t");
                                    }
                                    System.out.println();
                                }
                                rs.close();
                            } else {
                                int rows = stmt.executeUpdate(statement);
                                System.out.println("Affected rows: " + rows);
                            }
                            count++;
                        } catch (SQLException e) {
                            System.err.println("Error executing statement " + count + ": " + e.getMessage());
                            System.err.println("Statement: " + statement.substring(0, Math.min(100, statement.length())) + "...");
                        }
                    }
                    sql = new StringBuilder();
                } else {
                    sql.append(line).append("\n");
                }
            }
            
            // Execute last statement
            String statement = sql.toString().trim();
            if (!statement.isEmpty() && !statement.startsWith("--")) {
                try {
                     if (statement.toUpperCase().startsWith("SELECT")) {
                        ResultSet rs = stmt.executeQuery(statement);
                        ResultSetMetaData md = rs.getMetaData();
                        int cols = md.getColumnCount();
                        while (rs.next()) {
                            for (int i=1; i<=cols; i++) {
                                System.out.print(rs.getString(i) + "\t");
                            }
                            System.out.println();
                        }
                        rs.close();
                    } else {
                        int rows = stmt.executeUpdate(statement);
                        System.out.println("Affected rows: " + rows);
                    }
                    count++;
                } catch (SQLException e) {
                    System.err.println("Error executing final statement: " + e.getMessage());
                }
            }
            
            System.out.println("Successfully executed " + count + " SQL statements");
            
            stmt.close();
            conn.close();
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
            System.exit(1);
        }
    }
}
"@

# Save Java code to temp file
$javaFile = "RunFix.java"
$javaCode | Out-File -FilePath $javaFile -Encoding ASCII

Write-Host "Compiling Java loader..." -ForegroundColor Yellow

# Compile with Oracle JDBC driver
$m2Repo = "$env:USERPROFILE\.m2\repository"
$ojdbcJar = Get-ChildItem -Path "$m2Repo\com\oracle\database\jdbc\ojdbc8" -Recurse -Filter "*.jar" | Select-Object -First 1

if (-not $ojdbcJar) {
    Write-Host "ERROR: Oracle JDBC driver not found in Maven repository" -ForegroundColor Red
    Write-Host "Running Maven to download dependencies..." -ForegroundColor Yellow
    & .\mvnw.cmd dependency:resolve
    $ojdbcJar = Get-ChildItem -Path "$m2Repo\com\oracle\database\jdbc\ojdbc8" -Recurse -Filter "*.jar" | Select-Object -First 1
}

javac -encoding UTF-8 -cp $ojdbcJar.FullName $javaFile

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Java compilation failed" -ForegroundColor Red
    exit 1
}

Write-Host "Executing SQL statements..." -ForegroundColor Yellow

# Prepare SQL with separators
$sqlWithSeparators = ($statements | ForEach-Object { $_.Trim() }) -join "`n--SPLIT--`n"

# Execute
# Ensure output encoding is UTF-8 to capture results
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$sqlWithSeparators | & java "-Dfile.encoding=UTF-8" -cp ".;$($ojdbcJar.FullName)" RunFix $dbUrl $dbUser $dbPass

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=== SUCCESS: Fix applied successfully! ===" -ForegroundColor Green
}
else {
    Write-Host "`n=== ERROR: Failed to apply fix ===" -ForegroundColor Red
}

# Cleanup
Remove-Item $javaFile -ErrorAction SilentlyContinue
Remove-Item "RunFix.class" -ErrorAction SilentlyContinue
Remove-Item "temp_RunFix.class" -ErrorAction SilentlyContinue
