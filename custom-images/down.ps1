param(
  $XM1
)

Write-Host "Down containers..." -ForegroundColor Green
try {
  docker-compose kill mssql
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Container down failed, see errors above."
  }

  if ($XM1 -ieq 'XM1') {
    Write-Host "Down script for XM1......" -ForegroundColor Cyan
    docker-compose -f docker-compose.xm1.yml -f docker-compose.xm1.override.yml down

  }
  elseif ($XM1 -ieq 'XP1') {
    Write-Host "Down script for XP1......" -ForegroundColor Cyan
    docker-compose -f docker-compose.xp1.yml -f docker-compose.xp1.override.yml down

  }

  docker-compose down
  if ($LASTEXITCODE -ne 0) {
    Write-Error "Container down failed, see errors above."
  }


}
finally {
}
