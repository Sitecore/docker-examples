param(
    $XM1
)


Write-Host "The purpose of this script to start setup from scratch`n" -ForegroundColor Magenta
Write-Host "  1. Stop all containers`n" -ForegroundColor DarkCyan
Write-Host "  2. Docker Prune -Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes`n" -ForegroundColor DarkCyan
Write-Host "  3. Stop IIS, Stop/Start Host Network Service (HNS)`n" -ForegroundColor DarkCyan
Write-Host "  4. Run .\clean.ps1 from Sitecore > Docker`n" -ForegroundColor DarkCyan
Write-Host "  5. Restore Sitecore CLI Tool`n" -ForegroundColor DarkCyan
Write-Host "  6. Run docker compose up command`n" -ForegroundColor DarkCyan

Write-Host "`n`n1. Stop all containers..." -ForegroundColor Cyan
docker container stop $(docker container ls -q --filter name=docker-examples*);
docker-compose stop; docker-compose down

Write-Host "`n`n2. Docker Prune" -ForegroundColor Cyan
docker system prune
docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "docker-examples")


if ($XM1 -ieq 'XM1') {
    docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "docker-examples-xm1")
}
elseif ($XM1 -ieq 'XP1') {
    docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "docker-examples-xp1")
}
else {
    docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "docker-examples-xp0")
} 

Write-Host "`n`n3. Stop IIS, Stop/Start Host Network Service (HNS)" -ForegroundColor Cyan
iisreset /stop; net stop hns; net start hns

Write-Host "`n`n4. Clean all previous build artifacts" -ForegroundColor Cyan
Push-Location docker
.\clean.ps1

Write-Host "`n`n5. Restore Sitecore CLI tool" -ForegroundColor Cyan
Pop-Location
dotnet tool restore

Write-Host "`n`n6. Build/Compose Docker" -ForegroundColor Cyan
Pop-Location


if ($XM1 -ieq 'XM1') {
    Write-Host "Start Up script for XM1......" -ForegroundColor Cyan
    docker-compose -f docker-compose.xm1.yml -f docker-compose.xm1.override.yml up -d
}
elseif ($XM1 -ieq 'XP1') {
    Write-Host "Start Up script for XP1......" -ForegroundColor Cyan
    docker-compose -f docker-compose.xp1.yml -f docker-compose.xp1.override.yml up -d
}
else {
    Write-Host "Start Up script for XP0......" -ForegroundColor Cyan
    docker-compose up -d
}

Write-Host "***Setup completed successfully***" -ForegroundColor Green
