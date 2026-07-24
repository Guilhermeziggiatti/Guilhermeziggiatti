$techDir = ".\assets\tech"
$urls = @{
    "power-automate.svg" = "https://raw.githubusercontent.com/microsoft/fluentui-system-icons/main/assets/Services/Services%20Power%20Automate/SVG/ic_fluent_power_automate_24_filled.svg"
    "sharepoint.svg" = "https://raw.githubusercontent.com/microsoft/fluentui-system-icons/main/assets/Product%20Brands/SharePoint/SVG/ic_fluent_sharepoint_24_filled.svg"
}
foreach ($file in $urls.Keys) {
    $dest = Join-Path $techDir $file
    try {
        $r = Invoke-WebRequest -Uri $urls[$file] -UseBasicParsing -ErrorAction Stop
        if ($r.StatusCode -eq 200 -and $r.Content -match "<svg") {
            Set-Content -Path $dest -Value $r.Content -Encoding UTF8 -Force
            Write-Host "[OK] $file" -ForegroundColor Green
        } else {
            Write-Host "[FAIL] $file - invalid content" -ForegroundColor Red
        }
    } catch {
        Write-Host "[FAIL] $file - $($_.Exception.Message)" -ForegroundColor Red
    }
}