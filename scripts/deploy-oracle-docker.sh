#!/bin/bash
# =============================================================================
# Oracle Docker Deployment Script
# This script sets up Oracle database in Docker and initializes the schema
# =============================================================================

echo "=========================================="
echo "TP MES - Oracle Docker Deployment"
echo "=========================================="

# Configuration
ORACLE_CONTAINER_NAME="oracle-mes"
ORACLE_PASSWORD="oracletest"
ORACLE_PORT="1521"
ORACLE_VERSION="21.3.0-xe"

# Step 1: Pull Oracle Docker Image
echo ""
echo "Step 1: Pulling Oracle Database image..."
docker pull gvenzl/oracle-xe:${ORACLE_VERSION}

# Step 2: Create and Start Oracle Container
echo ""
echo "Step 2: Creating Oracle container..."
docker run -d \
  --name ${ORACLE_CONTAINER_NAME} \
  -p ${ORACLE_PORT}:1521 \
  -p 5500:5500 \
  -e ORACLE_PASSWORD=${ORACLE_PASSWORD} \
  -v oracle-data:/opt/oracle/oradata \
  gvenzl/oracle-xe:${ORACLE_VERSION}

# Step 3: Wait for Oracle to be ready
echo ""
echo "Step 3: Waiting for Oracle to start (this may take 2-3 minutes)..."
for i in {1..60}; do
  if docker exec ${ORACLE_CONTAINER_NAME} sqlplus -s system/${ORACLE_PASSWORD}@//localhost:1521/XEPDB1 <<< "SELECT 1 FROM DUAL;" > /dev/null 2>&1; then
    echo "✓ Oracle is ready!"
    break
  fi
  echo "Waiting... ($i/60)"
  sleep 5
done

# Step 4: Create Database User and Schema
echo ""
echo "Step 4: Creating database user and schema..."
docker exec -i ${ORACLE_CONTAINER_NAME} sqlplus system/${ORACLE_PASSWORD}@//localhost:1521/XEPDB1 <<EOF
-- Create tp_manufacture schema
CREATE USER tp_manufacture IDENTIFIED BY ${ORACLE_PASSWORD}
  DEFAULT TABLESPACE USERS
  TEMPORARY TABLESPACE TEMP
  QUOTA UNLIMITED ON USERS;

-- Grant necessary privileges
GRANT CONNECT, RESOURCE, CREATE VIEW, CREATE SYNONYM TO tp_manufacture;
GRANT UNLIMITED TABLESPACE TO tp_manufacture;

-- Verify user creation
SELECT username FROM all_users WHERE username = 'TP_MANUFACTURE';

EXIT;
EOF

# Step 5: Create Tables (Initial Schema)
echo ""
echo "Step 5: Creating initial database schema..."
docker exec -i ${ORACLE_CONTAINER_NAME} sqlplus tp_manufacture/${ORACLE_PASSWORD}@//localhost:1521/XEPDB1 < ../src/main/resources/db/schema.sql

# Step 6: Apply Migration V002 (Simulation Features)
echo ""
echo "Step 6: Applying migration V002 (Simulation Features)..."
docker exec -i ${ORACLE_CONTAINER_NAME} sqlplus tp_manufacture/${ORACLE_PASSWORD}@//localhost:1521/XEPDB1 < ../src/main/resources/db/migration/V002__add_simulation_features.sql

# Step 7: Load Sample Data
echo ""
echo "Step 7: Loading comprehensive sample data..."
docker exec -i ${ORACLE_CONTAINER_NAME} sqlplus tp_manufacture/${ORACLE_PASSWORD}@//localhost:1521/XEPDB1 < ../src/main/resources/db/seed/comprehensive_seed_data.sql

# Step 8: Verification
echo ""
echo "Step 8: Verifying deployment..."
docker exec -i ${ORACLE_CONTAINER_NAME} sqlplus -s tp_manufacture/${ORACLE_PASSWORD}@//localhost:1521/XEPDB1 <<EOF
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
EOF

# Complete
echo ""
echo "=========================================="
echo "✓ Deployment Complete!"
echo "=========================================="
echo ""
echo "Oracle Connection Details:"
echo "  Host: localhost"
echo "  Port: ${ORACLE_PORT}"
echo "  SID: XEPDB1"
echo "  User: tp_manufacture"
echo "  Password: ${ORACLE_PASSWORD}"
echo ""
echo "Connection String:"
echo "  jdbc:oracle:thin:@//localhost:${ORACLE_PORT}/XEPDB1"
echo ""
echo "Docker Commands:"
echo "  Start:   docker start ${ORACLE_CONTAINER_NAME}"
echo "  Stop:    docker stop ${ORACLE_CONTAINER_NAME}"
echo "  Remove:  docker rm ${ORACLE_CONTAINER_NAME}"
echo "  Logs:    docker logs ${ORACLE_CONTAINER_NAME}"
echo ""
echo "Next Steps:"
echo "1. Update .env file with connection details"
echo "2. Run: java -jar target/TP-exec.jar"
echo "3. Access: http://localhost:8090"
echo "=========================================="
