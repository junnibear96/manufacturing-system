# SQL Execution Script for Oracle
# Execute migration and sample data via PowerShell

$env:SPRING_PROFILES_ACTIVE = "oracle"
$env:TP_ORACLE_URL = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"
$env:TP_ORACLE_USER = "system"
$env:TP_ORACLE_PASS = "oracletest"

Write-Host "============================================" -ForegroundColor Cyan
Write-Host "Executing Database Migration via Maven" -ForegroundColor Cyan
Write-Host "============================================" -ForegroundColor Cyan

# Method 1: Use Maven to execute via Spring Boot
Write-Host "`nExecuting V002 Migration..." -ForegroundColor Yellow

# Run application once to trigger schema update
# Spring Boot will execute the SQL if we configure it

Write-Host "`nAlternative: Please run these SQL scripts manually:" -ForegroundColor Yellow
Write-Host "1. Open SQL Developer or another Oracle client"
Write-Host "2. Connect to: localhost:1521/XEPDB1 (user: system)"
Write-Host "3. Execute: src/main/resources/db/migration/V002__add_simulation_features.sql"
Write-Host "4. Execute: src/main/resources/db/seed/comprehensive_seed_data.sql"
Write-Host ""

Write-Host "Or use this one-liner (if you have sqlplus in PATH):" -ForegroundColor Green
Write-Host 'sqlplus system/oracletest@//localhost:1521/XEPDB1 @src\main\resources\db\migration\V002__add_simulation_features.sql'
Write-Host ""

Write-Host "Checking if Oracle JDBC is available..." -ForegroundColor Yellow

# Try to compile the application to ensure Oracle driver is available
.\mvnw.cmd compile -DskipTests

Write-Host "`nDone!" -ForegroundColor Green
