# Oracle Cloud Connection Troubleshooting Guide

## ❌ Connection Failed

**Error:** `IO 오류: Undefined Error`
**Cause:** SSL/TLS configuration issue

Oracle Autonomous Database requires either:
1. **Wallet files** (Recommended)
2. **Proper SSL certificates**
3. **JDBC thin client with proper SSL settings**

---

## ✅ Solution Options

### Option 1: Download and Use Wallet (Recommended)

1. **Download Wallet from Oracle Cloud:**
   - Go to your Autonomous Database
   - Click **DB Connection**
   - Click **Download Wallet**
   - Save as `Wallet_*.zip`

2. **Extract Wallet:**
   ```powershell
   mkdir wallet
   Expand-Archive -Path Wallet_*.zip -DestinationPath wallet\
   ```

3. **Update Connection Test:**
   ```java
   // Set wallet location
   System.setProperty("oracle.net.tns_admin", "C:\\path\\to\\wallet");
   System.setProperty("oracle.net.wallet_location", "C:\\path\\to\\wallet");
   
   // Use TNS_ADMIN connection string
   String url = "jdbc:oracle:thin:@nm0uo1ntyefptn5b_medium";
   ```

### Option 2: Use mTLS (Mutual TLS) without Wallet

**Requirements:**
- Oracle JDBC 21.7+ with built-in SSL support
- Proper SSL configuration

**Update pom.xml:**
```xml
<dependency>
    <groupId>com.oracle.database.jdbc</groupId>
    <artifactId>ojdbc11</artifactId>
    <version>21.9.0.0</version>
</dependency>
<dependency>
    <groupId>com.oracle.database.security</groupId>
    <artifactId>oraclepki</artifactId>
    <version>21.9.0.0</version>
</dependency>
<dependency>
    <groupId>com.oracle.database.security</groupId>
    <artifactId>osdt_core</artifactId>
    <version>21.9.0.0</version>
</dependency>
<dependency>
    <groupId>com.oracle.database.security</groupId>
    <artifactId>osdt_cert</artifactId>
    <version>21.9.0.0</version>
</dependency>
```

### Option 3: Use Simplified Connection

```properties
# In application-railway.properties
spring.datasource.url=jdbc:oracle:thin:@tcps://adb.ap-chuncheon-1.oraclecloud.com:1522/g92c39197b30b7e_nm0uo1ntyefptn5b_medium.adb.oraclecloud.com
spring.datasource.username=ADMIN
spring.datasource.password=NVdh49CQE3gFMWtb0ebJ

# SSL Properties
oracle.jdbc.fanEnabled=false
oracle.net.ssl_version=1.2
javax.net.ssl.trustStoreType=JKS
```

---

## 🔧 Immediate Fix for Railway Deployment

### Step 1: Download Wallet

1. Go to Oracle Cloud Console
2. Your Database → **DB Connection**
3. Download Wallet
4. Extract to `wallet/` folder in project

### Step 2: Add Wallet to Repository

```bash
# Create wallet directory
mkdir wallet

# Extract wallet (don't commit to git!)
# Add to .gitignore
echo "wallet/*" >> .gitignore
echo "!wallet/.gitkeep" >> .gitignore
```

### Step 3: Update Dockerfile

```dockerfile
FROM openjdk:17-slim

WORKDIR /app

# Copy wallet files
COPY wallet/ /app/wallet/

# Copy JAR
COPY target/TP-exec.jar /app/app.jar

# Set TNS_ADMIN
ENV TNS_ADMIN=/app/wallet
ENV ORACLE_NET_TNS_ADMIN=/app/wallet

ENTRYPOINT ["java", "-jar", "app.jar"]
CMD ["--spring.profiles.active=railway"]
```

### Step 4: Update application-railway.properties

```properties
# Use wallet-based connection
spring.datasource.url=jdbc:oracle:thin:@nm0uo1ntyefptn5b_medium
spring.datasource.username=${ORACLE_USER}
spring.datasource.password=${ORACLE_PASSWORD}

# No need for host/service when using wallet
```

---

## 🎯 Next Steps

1. Download wallet from Oracle Cloud
2. Extract to `wallet/` folder
3. Test connection locally:
   ```powershell
   $env:TNS_ADMIN="C:\path\to\wallet"
   java -jar target\TP-exec.jar --spring.profiles.active=railway
   ```
4. If works locally, deploy to Railway with wallet included

---

## 📌 Railway Environment Variables (with Wallet)

```bash
SPRING_PROFILES_ACTIVE=railway
ORACLE_USER=ADMIN
ORACLE_PASSWORD=NVdh49CQE3gFMWtb0ebJ
TNS_ADMIN=/app/wallet
```

**Note:** HOST and SERVICE not needed when using wallet!

---

## 🔍 Alternative: Test with SQL Developer

Before deploying, test connection with SQL Developer:
1. Open SQL Developer
2. New Connection
3. Connection Type: Cloud Wallet
4. Configuration File: Select your wallet zip
5. Username: ADMIN
6. Password: Your password
7. Service: nm0uo1ntyefptn5b_medium

If SQL Developer connects successfully, the credentials are correct.

---

## ❓ Need Wallet?

If you haven't downloaded the wallet yet:

1. **Oracle Cloud Console**
2. **Menu** → **Oracle Database** → **Autonomous Database**
3. Click your database name
4. Click **DB Connection** button
5. Click **Download Wallet**
6. Enter wallet password (create new one)
7. Download and extract

The wallet contains:
- `tnsnames.ora` - Connection names
- `sqlnet.ora` - Network configuration  
- `ewallet.p12` - Encryption wallet
- `cwallet.sso` - Auto-login wallet

---

Would you like me to help you set up the wallet-based connection?
