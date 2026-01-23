# =============================================================================
# Oracle Docker Deployment Script (PowerShell)
# This script sets up Oracle database in Docker and initializes the schema
# =============================================================================

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "TP MES - Oracle Docker Deployment" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan

# Configuration
$ORACLE_CONTAINER_NAME = "oracle-mes"
$ORACLE_PASSWORD = "oracletest"
$ORACLE_PORT = "1521"
$ORACLE_VERSION = "21.3.0-xe"

# Step 1: Pull Oracle Docker Image
Write-Host "`nStep 1: Pulling Oracle Database image..." -ForegroundColor Yellow
docker pull "gvenzl/oracle-xe:$ORACLE_VERSION"

# Step 2: Create and Start Oracle Container
Write-Host "`nStep 2: Creating Oracle container..." -ForegroundColor Yellow
docker run -d `
    --name $ORACLE_CONTAINER_NAME `
    -p "${ORACLE_PORT}:1521" `
    -p "5500:5500" `
    -e ORACLE_PASSWORD=$ORACLE_PASSWORD `
    -v oracle-data:/opt/oracle/oradata `
    "gvenzl/oracle-xe:$ORACLE_VERSION"

# Step 3: Wait for Oracle to be ready
Write-Host "`nStep 3: Waiting for Oracle to start (this may take 2-3 minutes)..." -ForegroundColor Yellow
$maxAttempts = 60
for ($i = 1; $i -le $maxAttempts; $i++) {
    try {
        $result = docker exec $ORACLE_CONTAINER_NAME sqlplus -s "system/$ORACLE_PASSWORD@//localhost:1521/XEPDB1" '@-' @'
SELECT 1 FROM DUAL;
EXIT;
'@ 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "✓ Oracle is ready!" -ForegroundColor Green
            break
        }
    }
    catch {}
    Write-Host "Waiting... ($i/$maxAttempts)"
    Start-Sleep -Seconds 5
}

# Step 4: Create Database User and Schema
Write-Host "`nStep 4: Creating database user and schema..." -ForegroundColor Yellow
$createUserSQL = @"
CREATE USER tp_manufacture IDENTIFIED BY $ORACLE_PASSWORD
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM TO tp_manufacture;
GRANT UNLIMITED TABLESPACE TO tp_manufacture;

SELECT username FROM all_users WHERE username = 'TP_MANUFACTURE';
EXIT;
"@

$createUserSQL | docker exec -i $ORACLE_CONTAINER_NAME sqlplus "system/$ORACLE_PASSWORD@//localhost:1521/XEPDB1"

# Step 5: Create Tables (Initial Schema)
Write-Host "`nStep 5: Creating initial database schema..." -ForegroundColor Yellow
if (Test-Path "src\main\resources\db\schema.sql") {
    Get-Content "src\main\resources\db\schema.sql" | docker exec -i $ORACLE_CONTAINER_NAME sqlplus "tp_manufacture/$ORACLE_PASSWORD@//localhost:1521/XEPDB1"
}
else {
    Write-Host "  ⚠ schema.sql not found - skipping" -ForegroundColor Yellow
}

# Step 6: Apply Migration V002
Write-Host "`nStep 6: Applying migration V002 (Simulation Features)..." -ForegroundColor Yellow
if (Test-Path "src\main\resources\db\migration\V002__add_simulation_features.sql") {
    Get-Content "src\main\resources\db\migration\V002__add_simulation_features.sql" | docker exec -i $ORACLE_CONTAINER_NAME sqlplus "tp_manufacture/$ORACLE_PASSWORD@//localhost:1521/XEPDB1"
}

# Step 7: Load Sample Data
Write-Host "`nStep 7: Loading comprehensive sample data..." -ForegroundColor Yellow
if (Test-Path "src\main\resources\db\seed\comprehensive_seed_data.sql") {
    Get-Content "src\main\resources\db\seed\comprehensive_seed_data.sql" | docker exec -i $ORACLE_CONTAINER_NAME sqlplus "tp_manufacture/$ORACLE_PASSWORD@//localhost:1521/XEPDB1"
}

# Step 8: Verification
Write-Host "`nStep 8: Verifying deployment..." -ForegroundColor Yellow
$verifySQL = @"
SET PAGESIZE 50
SET LINESIZE 120

PROMPT ==========================================
PROMPT Database Verification Summary
PROMPT ==========================================

SELECT 'Factories' AS entity, COUNT(*) AS count FROM tp_manufacture.tp_factories
UNION ALL
SELECT 'Plants', COUNT(*) FROM tp_manufacture.tp_plants
UNION ALL
SELECT 'Production Lines', COUNT(*) FROM tp_manufacture.tp_production_lines
UNION ALL
SELECT 'Inventory Items', COUNT(*) FROM tp_manufacture.tp_inventory
UNION ALL
SELECT 'BOM Entries', COUNT(*) FROM tp_manufacture.tp_production_bom;

EXIT;
"@

$verifySQL | docker exec -i $ORACLE_CONTAINER_NAME sqlplus -s "tp_manufacture/$ORACLE_PASSWORD@//localhost:1521/XEPDB1"

# Complete
Write-Host "`n==========================================" -ForegroundColor Green
Write-Host "✓ Deployment Complete!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Oracle Connection Details:" -ForegroundColor Cyan
Write-Host "  Host: localhost"
Write-Host "  Port: $ORACLE_PORT"
Write-Host "  SID: XEPDB1"
Write-Host "  User: tp_manufacture"
Write-Host "  Password: $ORACLE_PASSWORD"
Write-Host ""
Write-Host "Connection String:" -ForegroundColor Cyan
Write-Host "  jdbc:oracle:thin:@//localhost:${ORACLE_PORT}/XEPDB1"
Write-Host ""
Write-Host "Docker Commands:" -ForegroundColor Cyan
Write-Host "  Start:   docker start $ORACLE_CONTAINER_NAME"
Write-Host "  Stop:    docker stop $ORACLE_CONTAINER_NAME"
Write-Host "  Remove:  docker rm $ORACLE_CONTAINER_NAME"
Write-Host "  Logs:    docker logs $ORACLE_CONTAINER_NAME"
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Update .env file with connection details"
Write-Host "2. Run: java -jar target/TP-exec.jar"
Write-Host "3. Access: http://localhost:8090"
Write-Host "==========================================" -ForegroundColor Green
