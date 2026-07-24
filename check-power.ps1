$icons = Get-Content icons.json -Raw | ConvertFrom-Json
$icons | Where-Object { $_.title -match 'power|sharepoint|microsoft' } | Select-Object title, slug, hex | Format-Table -AutoSize