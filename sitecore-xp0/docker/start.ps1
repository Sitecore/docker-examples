Import-Module -Name (Join-Path $PSScriptRoot "..\logo")
Import-Module -Name (Join-Path $PSScriptRoot ".\tools\config")
Show-Start

#----------------------------------------------------------
## clean up
#----------------------------------------------------------

docker system prune -f

#----------------------------------------------------------
## load variables
#----------------------------------------------------------

$url = Get-EnvVar -Key CM_HOST

#----------------------------------------------------------
## check license is present
#----------------------------------------------------------

$licensePath = Get-EnvVar -Key LICENSE_PATH
if (-not (Test-Path (Join-Path $licensePath "license.xml"))) {
    Write-Host "License file not present in folder." -ForegroundColor Red
    Break
}

#----------------------------------------------------------
## check traefik ssl certs present
#----------------------------------------------------------

if (-not (Test-Path .\traefik\certs\cert.pem)) {
    .\tools\mkcert.ps1 -FullHostName ($url -replace "^.+?(\.)", "")
}

#----------------------------------------------------------
## check if user override env file exists
#----------------------------------------------------------

Read-UserEnvFile

#----------------------------------------------------------
## start docker
#----------------------------------------------------------

docker-compose up -d
Write-Host "`nDone... opening https://$($url)`n" -ForegroundColor DarkGray
start "https://$url"
