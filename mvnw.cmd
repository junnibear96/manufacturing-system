@echo off
setlocal

set BASEDIR=%~dp0
if "%BASEDIR%"=="" set BASEDIR=.

REM Strip trailing backslash to avoid Windows quote escaping issues.
if "%BASEDIR:~-1%"=="\" set BASEDIR=%BASEDIR:~0,-1%

set WRAPPER_JAR=%BASEDIR%\.mvn\wrapper\maven-wrapper.jar

if not exist "%WRAPPER_JAR%" (
  echo Maven Wrapper jar not found, downloading...
  powershell -NoProfile -ExecutionPolicy Bypass -File "%BASEDIR%\scripts\download-maven-wrapper.ps1" -ProjectBaseDir "%BASEDIR%"
)

if not exist "%WRAPPER_JAR%" (
  echo ERROR: Maven Wrapper jar is missing.
  exit /b 1
)

set JAVA_EXE=java
set JAVA_FROM_HOME=

if not "%JAVA_HOME%"=="" (
  if exist "%JAVA_HOME%\bin\java.exe" (
    set JAVA_EXE=%JAVA_HOME%\bin\java.exe
    set JAVA_FROM_HOME=1
  )
)

if "%JAVA_FROM_HOME%"=="1" (
  if not exist "%JAVA_EXE%" (
    echo ERROR: JAVA_HOME is set but java.exe is missing.
    echo - JAVA_HOME=%JAVA_HOME%
    exit /b 1
  )
) else (
  where java >nul 2>nul
  if errorlevel 1 (
    echo ERROR: Java JDK 17+ is required.
    echo - Install JDK 17 and ensure java works in a new terminal.
    echo - Or set JAVA_HOME to your JDK folder.
    exit /b 1
  )
)

if "%JAVA_FROM_HOME%"=="1" goto run

REM java found in PATH
goto run

:run
"%JAVA_EXE%" %MAVEN_OPTS% -classpath "%WRAPPER_JAR%" -Dmaven.multiModuleProjectDirectory=%BASEDIR% org.apache.maven.wrapper.MavenWrapperMain %*

goto :eof
