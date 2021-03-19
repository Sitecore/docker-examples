
Import-Module -Name (Join-Path $PSScriptRoot "..\logo")
Show-Stop

#---------------------------------------------------
## stop and clean up
#---------------------------------------------------

docker-compose down
docker system prune -f
