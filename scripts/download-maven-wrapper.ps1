param(
  [string]$ProjectBaseDir = (Get-Location).Path
)

$ErrorActionPreference = 'Stop'

$wrapperJar = Join-Path $ProjectBaseDir '.mvn\wrapper\maven-wrapper.jar'
$wrapperProps = Join-Path $ProjectBaseDir '.mvn\wrapper\maven-wrapper.properties'

$wrapperUrl = 'https://repo.maven.apache.org/maven2/org/apache/maven/wrapper/maven-wrapper/3.2.0/maven-wrapper-3.2.0.jar'
if (Test-Path $wrapperProps) {
  $line = (Get-Content $wrapperProps | Where-Object { $_ -match '^wrapperUrl=' } | Select-Object -First 1)
  if ($line) {
    $wrapperUrl = $line.Substring('wrapperUrl='.Length)
  }
}

$dir = Split-Path -Parent $wrapperJar
if (!(Test-Path $dir)) {
  New-Item -ItemType Directory -Force -Path $dir | Out-Null
}

Write-Host "Downloading Maven Wrapper jar..."
Write-Host "- URL: $wrapperUrl"
Write-Host "- OUT: $wrapperJar"

Invoke-WebRequest -UseBasicParsing -Uri $wrapperUrl -OutFile $wrapperJar
Write-Host "Done."
