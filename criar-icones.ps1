$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$techDirectory = Join-Path $repoRoot "assets\tech"

New-Item -ItemType Directory -Path $techDirectory -Force | Out-Null

$technologies = @(
    @{
        FileName  = "csharp.svg"
        Name      = "C#"
        ShortName = "C#"
        Color     = "#512BD4"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "python.svg"
        Name      = "Python"
        ShortName = "PY"
        Color     = "#3776AB"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "typescript.svg"
        Name      = "TypeScript"
        ShortName = "TS"
        Color     = "#3178C6"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "javascript.svg"
        Name      = "JavaScript"
        ShortName = "JS"
        Color     = "#F7DF1E"
        TextColor = "#111827"
    },
    @{
        FileName  = "dotnet.svg"
        Name      = "ASP.NET Core"
        ShortName = ".NET"
        Color     = "#512BD4"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "fastapi.svg"
        Name      = "FastAPI"
        ShortName = "API"
        Color     = "#009688"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "nodejs.svg"
        Name      = "Node.js"
        ShortName = "NODE"
        Color     = "#339933"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "nextjs.svg"
        Name      = "Next.js"
        ShortName = "NEXT"
        Color     = "#111111"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "react.svg"
        Name      = "React"
        ShortName = "REACT"
        Color     = "#61DAFB"
        TextColor = "#111827"
    },
    @{
        FileName  = "n8n.svg"
        Name      = "n8n"
        ShortName = "n8n"
        Color     = "#EA4B71"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "power-automate.svg"
        Name      = "Power Automate"
        ShortName = "PA"
        Color     = "#0066FF"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "selenium.svg"
        Name      = "Selenium"
        ShortName = "SE"
        Color     = "#43B02A"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "playwright.svg"
        Name      = "Playwright"
        ShortName = "PW"
        Color     = "#2EAD33"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "sharepoint.svg"
        Name      = "SharePoint"
        ShortName = "SP"
        Color     = "#038387"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "postgresql.svg"
        Name      = "PostgreSQL"
        ShortName = "PG"
        Color     = "#4169E1"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "mysql.svg"
        Name      = "MySQL"
        ShortName = "MY"
        Color     = "#4479A1"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "docker.svg"
        Name      = "Docker"
        ShortName = "DK"
        Color     = "#2496ED"
        TextColor = "#FFFFFF"
    },
    @{
        FileName  = "linux.svg"
        Name      = "Linux"
        ShortName = "LX"
        Color     = "#FCC624"
        TextColor = "#111827"
    }
)

foreach ($technology in $technologies) {
    $fontSize = if ($technology.ShortName.Length -le 3) {
        26
    }
    else {
        20
    }

    $svg = @"
<svg
  xmlns="http://www.w3.org/2000/svg"
  width="128"
  height="128"
  viewBox="0 0 128 128"
  role="img"
  aria-label="$($technology.Name)"
>
  <defs>
    <linearGradient id="background" x1="0" y1="0" x2="1" y2="1">
      <stop offset="0%" stop-color="#171124"/>
      <stop offset="100%" stop-color="#0B0F19"/>
    </linearGradient>

    <filter id="shadow" x="-30%" y="-30%" width="160%" height="160%">
      <feDropShadow
        dx="0"
        dy="6"
        stdDeviation="6"
        flood-color="#000000"
        flood-opacity="0.35"
      />
    </filter>
  </defs>

  <rect
    x="4"
    y="4"
    width="120"
    height="120"
    rx="24"
    fill="url(#background)"
    stroke="#6F42C1"
    stroke-width="3"
  />

  <rect
    x="22"
    y="22"
    width="84"
    height="84"
    rx="22"
    fill="$($technology.Color)"
    filter="url(#shadow)"
  />

  <circle
    cx="96"
    cy="32"
    r="7"
    fill="#FFFFFF"
    fill-opacity="0.22"
  />

  <text
    x="64"
    y="72"
    text-anchor="middle"
    dominant-baseline="middle"
    font-family="Inter, Segoe UI, Arial, sans-serif"
    font-size="$fontSize"
    font-weight="800"
    fill="$($technology.TextColor)"
    letter-spacing="-0.5"
  >$($technology.ShortName)</text>
</svg>
"@

    $destination = Join-Path $techDirectory $technology.FileName

    Set-Content `
        -Path $destination `
        -Value $svg `
        -Encoding UTF8
}

Write-Host ""
Write-Host "Ícones criados com sucesso em:" -ForegroundColor Green
Write-Host $techDirectory -ForegroundColor Cyan
Write-Host ""
Write-Host "Total de ícones: $($technologies.Count)" -ForegroundColor Green
