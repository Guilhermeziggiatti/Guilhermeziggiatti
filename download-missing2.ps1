$techDir = ".\assets\tech"
$urls = @{
    "power-automate.svg" = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/powerautomate.svg"
    "sharepoint.svg" = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/microsoftsharepoint.svg"
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