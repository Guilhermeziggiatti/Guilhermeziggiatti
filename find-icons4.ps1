$icons = Get-Content icons.json -Raw | ConvertFrom-Json
$searchTerms = @('csharp', 'dotnet', 'asp.net', 'playwright', 'sharepoint', 'powerautomate', 'power-automate', 'fastapi', 'selenium', 'python', 'mysql', 'postgresql', 'n8n', 'linux')
foreach ($term in $searchTerms) {
    $matches = $icons | Where-Object { $_.title -match $term -or $_.slug -match $term }
    if ($matches) {
        Write-Host "=== $term ===" -ForegroundColor Cyan
        $matches | Select-Object title, slug, hex, source | Format-Table -AutoSize
    } else {
        Write-Host "=== $term === NOT FOUND" -ForegroundColor Red
    }
}