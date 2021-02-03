param(
  [Parameter()]
  [switch]$IncludeDatabases
)

# Remove all unsused containers, networks, images, volumes
docker system prune -f

# Clean the data
$Path = (Join-Path $PSScriptRoot .\data)
if ($IncludeDatabases)
{
  Write-Host "Cleaning all data..." -ForegroundColor DarkRed -BackgroundColor Yellow
  git clean -xdf $Path
}
else 
{
  Write-Host "Cleaning data but not databases..." -ForegroundColor DarkRed -BackgroundColor Yellow
  git clean -xdf $Path -e *.mdf -e *.ldf
}
 