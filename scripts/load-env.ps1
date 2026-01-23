param(
  [string]$EnvFile = (Join-Path (Get-Location) '.env')
)

$ErrorActionPreference = 'Stop'

if (!(Test-Path $EnvFile)) {
  throw "Env file not found: $EnvFile"
}

Get-Content $EnvFile | ForEach-Object {
  $line = $_.Trim()
  if (!$line) { return }
  if ($line.StartsWith('#')) { return }

  $m = [regex]::Match($line, '^(?<k>[A-Za-z_][A-Za-z0-9_]*)=(?<v>.*)$')
  if (!$m.Success) { return }

  $k = $m.Groups['k'].Value
  $v = $m.Groups['v'].Value

  # remove surrounding quotes
  if (($v.StartsWith('"') -and $v.EndsWith('"')) -or ($v.StartsWith("'") -and $v.EndsWith("'"))) {
    $v = $v.Substring(1, $v.Length - 2)
  }

  [System.Environment]::SetEnvironmentVariable($k, $v, 'Process')
  Write-Host "Set $k"
}

Write-Host "Loaded env from $EnvFile"
