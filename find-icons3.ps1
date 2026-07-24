$icons = Get-Content icons.json -Raw | ConvertFrom-Json
$searchTerms = @('csharp', 'dotnet', 'asp.net', 'next', 'power', 'playwright', 'sharepoint', 'docker', 'node', 'typescript')
foreach ($term in $searchTerms) {
    $matches = $icons | Where-Object { $_.title -match $term -or $_.slug -match $term }
    if ($matches) {
        Write-Host "=== $term ===" -ForegroundColor Cyan
        $matches | Select-Object title, slug, hex, source | Format-Table -AutoSize
    }
}