# Apply Equipment Schema Update for Dashboard
# This script applies the combined equipment schema fix

$ErrorActionPreference = "Stop"

Write-Host "`n=== Applying Equipment Schema Update for Dashboard ===`n" -ForegroundColor Cyan

# Database configuration
$dbUrl = "jdbc:oracle:thin:@nm0uo1ntyefptn5b_medium?TNS_ADMIN=c:/Users/junse/antigravity_project/manufacturing-system/wallet"
$dbUser = "ADMIN"
$dbPass = "NVdh49CQE3gFMWtb0ebJ"

# Read SQL file
$sqlFile = "scripts\update-equipment-for-dashboard.sql"
if (-not (Test-Path $sqlFile)) {
    Write-Host "ERROR: SQL file not found: $sqlFile" -ForegroundColor Red
    exit 1
}

Write-Host "Reading SQL file: $sqlFile`n" -ForegroundColor Yellow
$sqlContent = Get-Content $sqlFile -Raw -Encoding UTF8

# Split by slash for PL/SQL blocks
$statements = $sqlContent -split '/' | Where-Object { $_.Trim() -ne '' }

Write-Host "Found $($statements.Count) SQL statements to execute`n" -ForegroundColor Yellow

# Create a temporary Java program to execute SQL
$javaCode = @"
import java.sql.*;

public class ApplyDashboardFix {
    public static void main(String[] args) {
        String url = args[0];
        String user = args[1];
        String pass = args[2];
        
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
            Connection conn = DriverManager.getConnection(url, user, pass);
            Statement stmt = conn.createStatement();
            
            System.out.println("Connected to Oracle database as " + user);
            System.out.println("");
            
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
                                
                                // Print headers
                                for (int i=1; i<=cols; i++) {
                                    System.out.print(md.getColumnName(i) + "\t");
                                }
                                System.out.println();
                                System.out.println("----------------------------------------");
                                
                                while (rs.next()) {
                                    for (int i=1; i<=cols; i++) {
                                        System.out.print(rs.getString(i) + "\t");
                                    }
                                    System.out.println();
                                }
                                rs.close();
                                System.out.println("");
                            } else {
                                int rows = stmt.executeUpdate(statement);
                                System.out.println("✓ Executed statement (rows affected: " + rows + ")");
                            }
                            count++;
                        } catch (SQLException e) {
                            System.err.println("✗ Error executing statement " + count + ": " + e.getMessage());
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
                        
                        // Print headers
                        for (int i=1; i<=cols; i++) {
                            System.out.print(md.getColumnName(i) + "\t");
                        }
                        System.out.println();
                        System.out.println("----------------------------------------");
                        
                        while (rs.next()) {
                            for (int i=1; i<=cols; i++) {
                                System.out.print(rs.getString(i) + "\t");
                            }
                            System.out.println();
                        }
                        rs.close();
                        System.out.println("");
                    } else {
                        int rows = stmt.executeUpdate(statement);
                        System.out.println("✓ Executed statement (rows affected: " + rows + ")");
                    }
                    count++;
                } catch (SQLException e) {
                    System.err.println("✗ Error executing final statement: " + e.getMessage());
                }
            }
            
            System.out.println("");
            System.out.println("Successfully processed " + count + " SQL blocks");
            
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
$javaFile = "ApplyDashboardFix.java"
$javaCode | Out-File -FilePath $javaFile -Encoding ASCII

Write-Host "Compiling Java loader..." -ForegroundColor Yellow

# Compile with Oracle JDBC driver
$m2Repo = "$env:USERPROFILE\.m2\repository"
$ojdbcJar = Get-ChildItem -Path "$m2Repo\com\oracle\database\jdbc\ojdbc8" -Recurse -Filter "*.jar" | Select-Object -First 1
$pkiJar = Get-ChildItem -Path "$m2Repo\com\oracle\database\security\oraclepki" -Recurse -Filter "*.jar" | Select-Object -First 1
$osdtCertJar = Get-ChildItem -Path "$m2Repo\com\oracle\database\security\osdt_cert" -Recurse -Filter "*.jar" | Select-Object -First 1
$osdtCoreJar = Get-ChildItem -Path "$m2Repo\com\oracle\database\security\osdt_core" -Recurse -Filter "*.jar" | Select-Object -First 1

if (-not $ojdbcJar) {
    Write-Host "ERROR: Oracle JDBC driver not found in Maven repository" -ForegroundColor Red
    exit 1
}

# Build Classpath
$cp = ".;$($ojdbcJar.FullName)"
if ($pkiJar) { $cp += ";$($pkiJar.FullName)" }
if ($osdtCertJar) { $cp += ";$($osdtCertJar.FullName)" }
if ($osdtCoreJar) { $cp += ";$($osdtCoreJar.FullName)" }

javac -encoding UTF-8 -cp $cp $javaFile

if ($LASTEXITCODE -ne 0) {
    Write-Host "ERROR: Java compilation failed" -ForegroundColor Red
    exit 1
}

Write-Host "Executing SQL statements...`n" -ForegroundColor Yellow

# Prepare SQL with separators
$sqlWithSeparators = ($statements | ForEach-Object { $_.Trim() }) -join "`n--SPLIT--`n"

# Execute
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$sqlWithSeparators | & java "-Dfile.encoding=UTF-8" -cp $cp ApplyDashboardFix $dbUrl $dbUser $dbPass

if ($LASTEXITCODE -eq 0) {
    Write-Host "`n=== SUCCESS: Equipment Schema Updated! ===`n" -ForegroundColor Green
    Write-Host "Next steps:" -ForegroundColor Cyan
    Write-Host "  1. Restart your application if it's running" -ForegroundColor White
    Write-Host "  2. Access the dashboard at: http://localhost:8090/production/dashboard" -ForegroundColor White
    Write-Host "  3. Verify that equipment statistics show real data instead of placeholders`n" -ForegroundColor White
}
else {
    Write-Host "`n=== ERROR: Failed to update schema ===`n" -ForegroundColor Red
}

# Cleanup
Remove-Item $javaFile -ErrorAction SilentlyContinue
Remove-Item "ApplyDashboardFix.class" -ErrorAction SilentlyContinue
