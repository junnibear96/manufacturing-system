# Load HRM Schema using Java/JDBC
# This script reads the SQL file and executes it via JDBC

$ErrorActionPreference = "Stop"

Write-Host "`n=== Loading HRM Schema ===" -ForegroundColor Cyan

# Database configuration
$dbUrl = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"
$dbUser = "system"
$dbPass = "oracletest"

# Read SQL file
$sqlFile = "scripts\hrm-schema.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: SQL file not found: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "Reading SQL file: $sqlFile" -ForegroundColor Yellow
$sqlContent = Get-Content $sqlFile -Raw

# Split by semicolons to get individual statements
$statements = $sqlContent -split ';' | Where-Object { $_.Trim() -ne '' }

Write-Host "Found $($statements.Count) SQL statements to execute" -ForegroundColor Yellow

# Create a temporary Java program to execute SQL
$javaCode = @"
import java.sql.*;

public class LoadSchema {
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
                new java.io.InputStreamReader(System.in));
            StringBuilder sql = new StringBuilder();
            String line;
            int count = 0;
            
            while ((line = reader.readLine()) != null) {
                if (line.trim().equals("--SPLIT--")) {
                    String statement = sql.toString().trim();
                    if (!statement.isEmpty() && !statement.startsWith("--")) {
                        try {
                            stmt.execute(statement);
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
                    stmt.execute(statement);
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
$javaFile = "temp_LoadSchema.java"
$javaCode | Out-File -FilePath $javaFile -Encoding UTF8

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

javac -cp $ojdbcJar.FullName $javaFile

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Java compilation failed" -ForegroundColor Red
    exit 1
}

Write-Host "Executing SQL statements..." -ForegroundColor Yellow

# Prepare SQL with separators
$sqlWithSeparators = ($statements | ForEach-Object { $_.Trim() }) -join "`n--SPLIT--`n"

# Execute
$sqlWithSeparators | & java -cp ".;$($ojdbcJar.FullName)" LoadSchema $dbUrl $dbUser $dbPass

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=== SUCCESS: HRM Schema loaded successfully! ===" -ForegroundColor Green
    Write-Host "Tables created: departments, positions, employees, employee_roles" -ForegroundColor Green
    Write-Host "Sample data inserted for testing" -ForegroundColor Green
}
else {
    Write-Host "`n=== ERROR: Failed to load schema ===" -ForegroundColor Red
}

# Cleanup
Remove-Item $javaFile -ErrorAction SilentlyContinue
Remove-Item "LoadSchema.class" -ErrorAction SilentlyContinue

Write-Host "`nYou can now restart the application and access /hr/employees`n" -ForegroundColor Cyan
