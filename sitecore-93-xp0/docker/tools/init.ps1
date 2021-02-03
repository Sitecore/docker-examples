[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateNotNullOrEmpty()]
    [Alias("h")]
    $HostName,
    
    [string]
    [Alias("s")]
    $HostSuffix = "localho.st",
    
    # We do not need to use [SecureString] here since the value will be stored unencrypted in .env,
    # and used only for transient local example environment.
    [string]
    [Alias("a")]
    $SitecoreAdminPassword = "b",
    
    # We do not need to use [SecureString] here since the value will be stored unencrypted in .env,
    # and used only for transient local example environment.
    [string]
    [Alias("sa")]
    $SqlSaPassword = "Password12345",

    [ValidateScript({ $_ -match '\.env$' })]
    [string]
    $Path = "..\.env"
)

$ErrorActionPreference = "Stop";
$FullHostName = -join($HostName, ".", $HostSuffix)

# Check for Sitecore Gallery
Import-Module PowerShellGet
$SitecoreGallery = Get-PSRepository | Where-Object { $_.SourceLocation -eq "https://sitecore.myget.org/F/sc-powershell/api/v2" }
if (-not $SitecoreGallery) {
    Write-Host "Adding Sitecore PowerShell Gallery..." -ForegroundColor Green 
    Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2 -InstallationPolicy Trusted
    $SitecoreGallery = Get-PSRepository -Name SitecoreGallery
}
# Install and Import SitecoreDockerTools 
$dockerToolsVersion = "10.0.5"
Remove-Module SitecoreDockerTools -ErrorAction SilentlyContinue
if (-not (Get-InstalledModule -Name SitecoreDockerTools -RequiredVersion $dockerToolsVersion -ErrorAction SilentlyContinue)) {
    Write-Host "Installing SitecoreDockerTools..." -ForegroundColor Green
    Install-Module SitecoreDockerTools -RequiredVersion $dockerToolsVersion -Scope CurrentUser -Repository $SitecoreGallery.Name
}
Write-Host "Importing SitecoreDockerTools..." -ForegroundColor Green
Import-Module SitecoreDockerTools -RequiredVersion $dockerToolsVersion

###############################
# Populate the environment file
###############################

Write-Host "Populating required .env file variables..." -ForegroundColor Green

# COMPOSE_PROJECT_NAME
Set-DockerComposeEnvFileVariable "COMPOSE_PROJECT_NAME" -Value $HostName -Path $Path

# SITECORE_ADMIN_PASSWORD
#Set-DockerComposeEnvFileVariable "SITECORE_ADMIN_PASSWORD" -Value $SitecoreAdminPassword -Path $Path

# SQL_SA_PASSWORD
Set-DockerComposeEnvFileVariable "SQL_SA_PASSWORD" -Value $SqlSaPassword -Path $Path

# CD_HOST
Set-DockerComposeEnvFileVariable "CD_HOST" -Value "cd.$($FullHostName)" -Path $Path

# CM_HOST
Set-DockerComposeEnvFileVariable "CM_HOST" -Value "cm.$($FullHostName)" -Path $Path

# ID_HOST
Set-DockerComposeEnvFileVariable "ID_HOST" -Value "id.$($FullHostName)" -Path $Path

# REPORTING_API_KEY = random 64-128 chars
#Set-DockerComposeEnvFileVariable "REPORTING_API_KEY" -Value (Get-SitecoreRandomString 64 -DisallowSpecial) -Path $Path

# TELERIK_ENCRYPTION_KEY = random 64-128 chars
Set-DockerComposeEnvFileVariable "TELERIK_ENCRYPTION_KEY" -Value (Get-SitecoreRandomString 128) -Path $Path

# SITECORE_IDSECRET = random 64 chars
#Set-DockerComposeEnvFileVariable "SITECORE_IDSECRET" -Value (Get-SitecoreRandomString 64 -DisallowSpecial) -Path $Path

# SITECORE_ID_CERTIFICATE
$idCertPassword = Get-SitecoreRandomString 12 -DisallowSpecial
#Set-DockerComposeEnvFileVariable "SITECORE_ID_CERTIFICATE" -Value (Get-SitecoreCertificateAsBase64String -DnsName "localhost" -Password (ConvertTo-SecureString -String $idCertPassword -Force -AsPlainText)) -Path $Path

# SITECORE_ID_CERTIFICATE_PASSWORD
#Set-DockerComposeEnvFileVariable "SITECORE_ID_CERTIFICATE_PASSWORD" -Value $idCertPassword -Path $Path

##################################
# Configure TLS/HTTPS certificates
##################################

.\mkcert.ps1 -FullHostName $FullHostName

Write-Host "Done!" -ForegroundColor Green