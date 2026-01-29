# Remove TP Branding from JSP Files
# This script replaces "- TP MES" and "TP ·" from all JSP titles

$ErrorActionPreference = "Stop"

Write-Host "`n=== Removing TP Branding from JSP Files ===`n" -ForegroundColor Cyan

# Define replacement patterns
$replacements = @(
    @{Pattern = "- TP MES"; Replacement = "" }
    @{Pattern = "TP · "; Replacement = "" }
    @{Pattern = "TP Manufacturing System"; Replacement = "Manufacturing Execution System" }
    @{Pattern = "<span class=`"logo-text`">TP</span>"; Replacement = "<span class=`"logo-text`">MES</span>" }
)

# Find all JSP files
$jspFiles = Get-ChildItem -Path "src\main\webapp" -Filter "*.jsp" -Recurse

$modifiedCount = 0
$totalReplacements = 0

foreach ($file in $jspFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $originalContent = $content
    $fileModified = $false
    
    foreach ($rep in $replacements) {
        if ($content -match [regex]::Escape($rep.Pattern)) {
            $content = $content -replace [regex]::Escape($rep.Pattern), $rep.Replacement
            $fileModified = $true
            $totalReplacements++
        }
    }
    
    if ($fileModified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8 -NoNewline
        Write-Host "✓ Modified: $($file.FullName.Replace((Get-Location).Path + '\', ''))" -ForegroundColor Green
        $modifiedCount++
    }
}

Write-Host "`n=== Summary ===`n" -ForegroundColor Cyan
Write-Host "Files modified: $modifiedCount" -ForegroundColor Yellow
Write-Host "Total replacements: $totalReplacements" -ForegroundColor Yellow
Write-Host "`n✓ TP branding removed from JSP files!`n" -ForegroundColor Green
