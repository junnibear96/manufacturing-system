@echo off
REM Load HRM Schema into Oracle Database

echo.
echo === Loading HRM Schema ===
echo.

REM Compile Java loader
echo Compiling Java schema loader...

echo import java.sql.*; > LoadSchema.java
echo import java.io.*; >> LoadSchema.java
echo. >> LoadSchema.java
echo public class LoadSchema { >> LoadSchema.java
echo     public static void main(String[] args) throws Exception { >> LoadSchema.java
echo         String url = "jdbc:oracle:thin:@//localhost:1521/XEPDB1"; >> LoadSchema.java
echo         String user = "system"; >> LoadSchema.java
echo         String pass = "oracletest"; >> LoadSchema.java
echo. >> LoadSchema.java
echo         Class.forName("oracle.jdbc.driver.OracleDriver"); >> LoadSchema.java
echo         Connection conn = DriverManager.getConnection(url, user, pass); >> LoadSchema.java
echo         Statement stmt = conn.createStatement(); >> LoadSchema.java
echo. >> LoadSchema.java
echo         System.out.println("Connected to Oracle database"); >> LoadSchema.java
echo. >> LoadSchema.java
echo         BufferedReader reader = new BufferedReader(new FileReader("scripts/hrm-schema.sql")); >> LoadSchema.java
echo         StringBuilder sql = new StringBuilder(); >> LoadSchema.java
echo         String line; >> LoadSchema.java
echo         int count = 0; >> LoadSchema.java
echo. >> LoadSchema.java
echo         while ((line = reader.readLine()) != null) { >> LoadSchema.java
echo             line = line.trim(); >> LoadSchema.java
echo             if (line.startsWith("--") ^|^| line.isEmpty()) continue; >> LoadSchema.java
echo             sql.append(line).append(" "); >> LoadSchema.java
echo             if (line.endsWith(";")) { >> LoadSchema.java
echo                 String statement = sql.toString().replace(";", ""); >> LoadSchema.java
echo                 try { >> LoadSchema.java
echo                     stmt.execute(statement); >> LoadSchema.java
echo                     count++; >> LoadSchema.java
echo                     if (count %% 10 == 0) System.out.println("Executed " + count + " statements..."); >> LoadSchema.java
echo                 } catch (SQLException e) { >> LoadSchema.java
echo                     if (!e.getMessage().contains("name is already used")) { >> LoadSchema.java
echo                         System.err.println("Warning: " + e.getMessage()); >> LoadSchema.java
echo                     } >> LoadSchema.java
echo                 } >> LoadSchema.java
echo                 sql = new StringBuilder(); >> LoadSchema.java
echo             } >> LoadSchema.java
echo         } >> LoadSchema.java
echo. >> LoadSchema.java
echo         reader.close(); >> LoadSchema.java
echo         System.out.println("Successfully executed " + count + " SQL statements"); >> LoadSchema.java
echo         stmt.close(); >> LoadSchema.java
echo         conn.close(); >> LoadSchema.java
echo     } >> LoadSchema.java
echo } >> LoadSchema.java

REM Find Oracle JDBC JAR
for /r "%USERPROFILE%\.m2\repository\com\oracle\database\jdbc" %%i in (ojdbc*.jar) do set OJDBC_JAR=%%i

if not defined OJDBC_JAR (
    echo Oracle JDBC driver not found. Downloading dependencies...
    call mvnw.cmd dependency:resolve
    for /r "%USERPROFILE%\.m2\repository\com\oracle\database\jdbc" %%i in (ojdbc*.jar) do set OJDBC_JAR=%%i
)

echo Using JDBC driver: %OJDBC_JAR%

javac -cp "%OJDBC_JAR%" LoadSchema.java

if errorlevel 1 (
    echo ERROR: Compilation failed
    exit /b 1
)

echo.
echo Executing SQL statements...
echo.

java -cp ".;%OJDBC_JAR%" LoadSchema

if errorlevel 1 (
    echo.
    echo === ERROR: Failed to load schema ===
    exit /b 1
) else (
    echo.
    echo === SUCCESS: HRM Schema loaded successfully! ===
    echo Tables created: departments, positions, employees, employee_roles
    echo Sample data inserted for testing
    echo.
    echo You can now access /hr/employees in the application
)

REM Cleanup
del LoadSchema.java LoadSchema.class 2>nul

echo.
