param(
  [string]$EnvFile = (Join-Path (Get-Location) '.env'),
  [int]$Port = 8090
)

$ErrorActionPreference = 'Stop'

$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# Load local env vars if a .env exists (ignored by git)
if (Test-Path $EnvFile) {
  & (Join-Path $PSScriptRoot 'load-env.ps1') -EnvFile $EnvFile
}

function Get-JavaMajorVersionFromOutput([string]$firstLine) {
  if (-not $firstLine) { return $null }

  # Examples:
  # openjdk version "21.0.9" 2025-10-21 LTS
  # java version "1.8.0_202" ...
  $m = [regex]::Match($firstLine, 'version\s+"(?<v>[0-9]+)(?:\.(?<minor>[0-9]+))?')
  if (-not $m.Success) { return $null }

  $major = [int]$m.Groups['v'].Value
  if ($major -eq 1 -and $m.Groups['minor'].Success) {
    return [int]$m.Groups['minor'].Value
  }
  return $major
}

function Get-JavaVersionFirstLine([string]$javaExe) {
  if (-not $javaExe) { return $null }

  # `java -version` writes to stderr; in PowerShell 7+ this can become a terminating
  # NativeCommandError when $ErrorActionPreference='Stop'. Running via cmd.exe and
  # merging streams avoids that.
  $exe = $javaExe
  if ($exe -match '\s') {
    $exe = '"' + $exe + '"'
  }

  return [string]((cmd /c "$exe -version 2>&1" | Select-Object -First 1))
}

function Get-CurrentJavaMajorVersion {
  $cmd = Get-Command java -ErrorAction SilentlyContinue
  if (-not $cmd) { return $null }
  $firstLine = Get-JavaVersionFirstLine 'java'
  return Get-JavaMajorVersionFromOutput $firstLine
}

function Use-MicrosoftOpenJdk21 {
  $msDir = 'C:\Program Files\Microsoft'
  if (-not (Test-Path $msDir)) {
    throw "Microsoft OpenJDK install directory not found: $msDir"
  }

  $jdk = Get-ChildItem $msDir -Directory -ErrorAction SilentlyContinue |
  Where-Object { $_.Name -match '^jdk-21' } |
  Sort-Object Name -Descending |
  Select-Object -First 1

  if (-not $jdk) {
    throw "Microsoft OpenJDK 21 not found under '$msDir'. Install it with: winget install -e --id Microsoft.OpenJDK.21"
  }

  $env:JAVA_HOME = $jdk.FullName
  $env:Path = (Join-Path $env:JAVA_HOME 'bin') + ';' + $env:Path
  Write-Host "JAVA_HOME=$env:JAVA_HOME"
}

function Prepend-JavaHomeBinToPath {
  if (-not $env:JAVA_HOME) { return }
  $bin = Join-Path $env:JAVA_HOME 'bin'
  if (-not (Test-Path $bin)) { return }
  $prefix = $bin + ';'
  if ($env:Path -like ($prefix + '*')) { return }
  $env:Path = $prefix + $env:Path
}

# Ensure Java 21 is used in this session.
$javaHomeBin = if ($env:JAVA_HOME) { Join-Path $env:JAVA_HOME 'bin' } else { $null }
$javaHomeJava = if ($javaHomeBin) { Join-Path $javaHomeBin 'java.exe' } else { $null }
$javaHomeMajor = $null
if ($javaHomeJava -and (Test-Path $javaHomeJava)) {
  $firstLine = Get-JavaVersionFirstLine $javaHomeJava
  $javaHomeMajor = Get-JavaMajorVersionFromOutput $firstLine
}

$currentMajor = Get-CurrentJavaMajorVersion

if ($javaHomeMajor -eq 21) {
  # JAVA_HOME already points to 21; ensure PATH resolves `java` from JAVA_HOME first.
  Prepend-JavaHomeBinToPath
}
elseif ($currentMajor -ne 21) {
  Use-MicrosoftOpenJdk21
}

Write-Host 'Building & running via Maven Wrapper...'

# Auto-stop existing process if port is in use.
$portPid = (Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1 -ExpandProperty OwningProcess)
if ($portPid) {
  $p = Get-Process -Id $portPid -ErrorAction SilentlyContinue
  $name = if ($p) { $p.ProcessName } else { 'unknown' }
  Write-Host "Port $Port is already in use (PID=$portPid, Process=$name). Stopping it..." -ForegroundColor Yellow
  Stop-Process -Id $portPid -Force -ErrorAction SilentlyContinue
  Start-Sleep -Seconds 2
  Write-Host "Process stopped. Continuing..." -ForegroundColor Green
}

# Run with spring-boot:run (faster for dev, doesn't require executable WAR repackaging)
Write-Host "Starting app: http://localhost:$Port/ (Environment variables loaded)"
& .\mvnw.cmd -DskipTests spring-boot:run "-Dspring-boot.run.arguments=--server.port=$Port"
