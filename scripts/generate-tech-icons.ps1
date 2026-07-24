<# 
.SYNOPSIS
    Downloads real SVG technology logos from Simple Icons and Devicon.
.DESCRIPTION
    Creates assets/tech directory and downloads verified SVG logos for the tech stack.
    Validates HTTP status, SVG content, and prevents overwriting valid files with empty ones.
.NOTES
    Sources: Simple Icons (CC0 1.0), Devicon (MIT)
    Author: Guilherme Ziggiatti
#>

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$techDir = Join-Path $PSScriptRoot "..\assets\tech"
if (-not (Test-Path $techDir)) {
    New-Item -ItemType Directory -Path $techDir -Force | Out-Null
    Write-Host "Created directory: $techDir" -ForegroundColor Green
}

$icons = @(
    # Core Languages - Simple Icons
    @{ name = "C#";           file = "csharp.svg";        url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/csharp/csharp-original.svg" }
    @{ name = "Python";       file = "python.svg";        url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/python.svg" }
    @{ name = "TypeScript";   file = "typescript.svg";    url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/typescript.svg" }
    @{ name = "JavaScript";   file = "javascript.svg";    url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/javascript.svg" }
    
    # Backend & Web - Mix of Devicon and Simple Icons
    @{ name = ".NET";         file = "dotnet.svg";        url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dotnetcore/dotnetcore-original.svg" }
    @{ name = "FastAPI";      file = "fastapi.svg";       url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/fastapi.svg" }
    @{ name = "Node.js";      file = "nodejs.svg";        url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/nodedotjs.svg" }
    @{ name = "Next.js";      file = "nextjs.svg";        url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/nextdotjs.svg" }
    @{ name = "React";        file = "react.svg";         url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/react.svg" }
    
    # Automation & Enterprise - Mix of sources
    @{ name = "n8n";          file = "n8n.svg";           url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/n8n.svg" }
    @{ name = "Power Automate"; file = "power-automate.svg"; url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/powerautomate/powerautomate-original.svg" }
    @{ name = "Selenium";     file = "selenium.svg";      url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/selenium.svg" }
    @{ name = "Playwright";   file = "playwright.svg";    url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/playwright/playwright-original.svg" }
    @{ name = "SharePoint";   file = "sharepoint.svg";    url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/sharepoint/sharepoint-original.svg" }
    
    # Data - Simple Icons
    @{ name = "PostgreSQL";   file = "postgresql.svg";    url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/postgresql.svg" }
    @{ name = "MySQL";        file = "mysql.svg";         url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/mysql.svg" }
    
    # Infrastructure - Simple Icons
    @{ name = "Docker";       file = "docker.svg";        url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/docker.svg" }
    @{ name = "Linux";        file = "linux.svg";         url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/linux.svg" }
)

$expectedCount = $icons.Count
$createdCount = 0
$failed = @()

Write-Host "Downloading $expectedCount SVG icons..." -ForegroundColor Cyan
Write-Host ""

foreach ($icon in $icons) {
    $destPath = Join-Path $techDir $icon.file
    
    if (Test-Path $destPath) {
        $existingContent = Get-Content $destPath -Raw -ErrorAction SilentlyContinue
        if ($existingContent -match "<svg") {
            Write-Host "[SKIP] $($icon.file) already exists and is valid SVG" -ForegroundColor Yellow
            $createdCount++
            continue
        }
    }
    
    try {
        Write-Host "[DOWNLOAD] $($icon.name) -> $($icon.file)" -NoNewline
        $response = Invoke-WebRequest -Uri $icon.url -Method Get -UseBasicParsing -ErrorAction Stop -TimeoutSec 30
        
        if ($response.StatusCode -ne 200) {
            throw "HTTP $($response.StatusCode)"
        }
        
        $content = $response.Content
        
        if ($null -eq $content -or $content.Trim() -eq "" -or $content -notmatch "<svg") {
            throw "Downloaded content is not valid SVG (empty or missing <svg tag)"
        }
        
        Set-Content -Path $destPath -Value $content -Encoding UTF8 -Force
        Write-Host " [OK]" -ForegroundColor Green
        $createdCount++
    }
    catch {
        Write-Host " [FAILED]" -ForegroundColor Red
        Write-Host "  Error: $($_.Exception.Message)" -ForegroundColor Red
        $failed += @{ file = $icon.file; error = $_.Exception.Message }
    }
}

Write-Host ""
Write-Host "========== SUMMARY ==========" -ForegroundColor Cyan
Write-Host "Expected: $expectedCount"
Write-Host "Created/Validated: $createdCount"
Write-Host "Failed: $($failed.Count)"

if ($failed.Count -gt 0) {
    Write-Host ""
    Write-Host "FAILURES:" -ForegroundColor Red
    foreach ($f in $failed) {
        Write-Host "  - $($f.file): $($f.error)" -ForegroundColor Red
    }
    Write-Host ""
    Write-Host "Exit code: 1" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "All icons downloaded successfully to: $techDir" -ForegroundColor Green
Write-Host "Exit code: 0" -ForegroundColor Green
exit 0