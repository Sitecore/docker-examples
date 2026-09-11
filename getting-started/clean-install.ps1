,
$Topology="XP0"
Write-Host $Topology
Write-Host "The purpose of this script to start setup from scratch`n" -ForegroundColor Magenta
Write-Host "  1. Stop all containers`n" -ForegroundColor DarkCyan
Write-Host "  2. Docker Prune -Remove all unused containers, networks, images (both dangling and unreferenced), and optionally, volumes`n" -ForegroundColor DarkCyan
Write-Host "  3. Stop IIS, Stop/Start Host Network Service (HNS)`n" -ForegroundColor DarkCyan
Write-Host "  4. Run .\clean.ps1 from Sitecore > Docker`n" -ForegroundColor DarkCyan
Write-Host "  5. Restore Sitecore CLI Tool`n" -ForegroundColor DarkCyan
Write-Host "  6. Run .\up.ps1 from Sitecore`n" -ForegroundColor DarkCyan

Write-Host "`n`n1. Stop all containers..." -ForegroundColor Cyan

docker-compose stop; docker-compose down

Write-Host "`n`n Remove Orphan Containers" -ForegroundColor Cyan
docker-compose down --remove-orphans


Write-Host "`n`n2. Docker Prune" -ForegroundColor Cyan
docker system prune
docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "sitecore-xp0")
docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "nonproduction-api")

if ($Topology -ieq 'XP0') {
    docker container rm "sitecore-xp0-xconnect-1"
    docker rmi $(docker images --format "{{.Repository}}:{{.Tag}}" | findstr "sitecore-xp0")
}


Write-Host "`n`n3. Stop IIS, Stop/Start Host Network Service (HNS)" -ForegroundColor Cyan
iisreset /stop; net stop hns; net start hns

Write-Host "`n`n4. Clean all previous build artifacts" -ForegroundColor Cyan
.\clean.ps1


docker compose up -d

# Wait for Traefik to expose CM route
Write-Host "Waiting for CM to become available..." -ForegroundColor Green
$startTime = Get-Date
do {
    Start-Sleep -Milliseconds 100
    try {
        $status = Invoke-RestMethod "http://localhost:8079/api/http/routers/cm-secure@docker"
    } catch {
        if ($_.Exception.Response.StatusCode.value__ -ne "404") {
            throw
        }
    }
} while ($status.status -ne "enabled" -and $startTime.AddSeconds(15) -gt (Get-Date))
if (-not $status.status -eq "enabled") {
    $status
    Write-Error "Timeout waiting for Sitecore CM to become available via Traefik proxy. Check CM container logs."
}

# Execute the Sitecore Identity Server 8 upgrade script
.\execute-mssql-script.ps1 -filePath ".env"

Write-Host "***Setup completed successfully***" -ForegroundColor Green
