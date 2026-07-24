<#
.SYNOPSIS
    Downloads and normalizes the 15 tech SVG icons used in the profile README.
.DESCRIPTION
    Fetches official color SVGs from Devicon, Simple Icons, and official brand sources.
    Validates file existence, SVG content, and downloads into temporary files before replacing targets.
#>

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

$techDir = Join-Path $PSScriptRoot "..\assets\tech"
if (-not (Test-Path $techDir)) {
    New-Item -ItemType Directory -Path $techDir -Force | Out-Null
}

function Convert-SimpleIconToColorSvg {
    param(
        [Parameter(Mandatory=$true)][string]$Svg,
        [Parameter(Mandatory=$true)][string]$Color
    )

    $svg = $Svg
    $svg = $svg -replace 'fill="currentColor"', "fill=`"$Color`""
    $svg = $svg -replace 'fill:currentColor', "fill:$Color"
    if ($svg -notmatch 'fill="') {
        $svg = $svg -replace '<path\b', "<path fill=`"$Color`""
    }
    return $svg
}

$icons = @(
    @{ name = "C#"; file = "csharp.svg"; url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/csharp/csharp-original.svg"; mode = "raw" }
    @{ name = ".NET"; file = "dotnet.svg"; url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/dotnetcore/dotnetcore-original.svg"; mode = "raw" }
    @{ name = "Python"; file = "python.svg"; url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/python/python-original.svg"; mode = "raw" }
    @{ name = "FastAPI"; file = "fastapi.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/fastapi.svg"; mode = "simple"; color = "#009688" }
    @{ name = "TypeScript"; file = "typescript.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/typescript.svg"; mode = "simple"; color = "#3178C6" }
    @{ name = "JavaScript"; file = "javascript.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/javascript.svg"; mode = "simple"; color = "#F7DF1E" }
    @{ name = "Node.js"; file = "nodejs.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/nodedotjs.svg"; mode = "simple"; color = "#339933" }
    @{ name = "Next.js"; file = "nextjs.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/nextdotjs.svg"; mode = "nextjs" }
    @{ name = "React"; file = "react.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/react.svg"; mode = "simple"; color = "#61DAFB" }
    @{ name = "n8n"; file = "n8n.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/n8n.svg"; mode = "simple"; color = "#EA4B71" }
    @{ name = "Selenium"; file = "selenium.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/selenium.svg"; mode = "simple"; color = "#43B02A" }
    @{ name = "Playwright"; file = "playwright.svg"; url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/playwright/playwright-original.svg"; mode = "raw" }
    @{ name = "PostgreSQL"; file = "postgresql.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/postgresql.svg"; mode = "simple"; color = "#4169E1" }
    @{ name = "MySQL"; file = "mysql.svg"; url = "https://cdn.jsdelivr.net/gh/devicons/devicon/icons/mysql/mysql-original.svg"; mode = "raw" }
    @{ name = "Docker"; file = "docker.svg"; url = "https://raw.githubusercontent.com/simple-icons/simple-icons/develop/icons/docker.svg"; mode = "simple"; color = "#2496ED" }
)

function Get-IconSvgContent {
    param([Parameter(Mandatory=$true)]$Icon)

    $response = Invoke-WebRequest -Uri $Icon.url -Method Get -UseBasicParsing -ErrorAction Stop -TimeoutSec 30
    if ($response.StatusCode -ne 200) {
        throw "HTTP $($response.StatusCode)"
    }

    $content = $response.Content
    if ([string]::IsNullOrWhiteSpace($content) -or $content -notmatch '<svg') {
        throw "Invalid SVG payload"
    }

    switch ($Icon.mode) {
        'simple' {
            return (Convert-SimpleIconToColorSvg -Svg $content -Color $Icon.color)
        }
        'nextjs' {
            $svg = $content -replace 'fill="currentColor"', 'fill="#FFFFFF"'
            $svg = $svg -replace 'stroke="currentColor"', 'stroke="#FFFFFF"'
            $svg = $svg -replace 'style="[^"]*color:currentColor;?"', ''
            if ($svg -notmatch 'fill="#FFFFFF"') {
                $svg = $svg -replace '<path\b', '<path fill="#FFFFFF"'
            }
            return $svg
        }
        default {
            return $content
        }
    }
}

$expectedCount = $icons.Count
$failed = @()
$processed = 0

foreach ($icon in $icons) {
    $tempPath = [System.IO.Path]::GetTempFileName()
    try {
        $svg = Get-IconSvgContent -Icon $icon
        if ([string]::IsNullOrWhiteSpace($svg) -or $svg -notmatch '<svg') {
            throw "Generated SVG is invalid"
        }
        [System.IO.File]::WriteAllText($tempPath, $svg, [System.Text.UTF8Encoding]::new($false))
        $tempContent = Get-Content $tempPath -Raw
        if ([string]::IsNullOrWhiteSpace($tempContent) -or $tempContent -notmatch '<svg') {
            throw "Temporary SVG validation failed"
        }

        $destPath = Join-Path $techDir $icon.file
        Move-Item -Path $tempPath -Destination $destPath -Force
        $processed++
        Write-Host "[OK] $($icon.file)"
    }
    catch {
        $failed += @{ file = $icon.file; error = $_.Exception.Message }
        Write-Host "[FAILED] $($icon.file): $($_.Exception.Message)" -ForegroundColor Red
        if (Test-Path $tempPath) {
            Remove-Item $tempPath -Force -ErrorAction SilentlyContinue
        }
    }
}

Write-Host ""
Write-Host "Expected: $expectedCount"
Write-Host "Processed: $processed"
Write-Host "Failed: $($failed.Count)"

if ($failed.Count -gt 0) {
    exit 1
}

exit 0
