[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateNotNullOrEmpty()]
    $LicenseXmlPath,

    [string]
    $HostName = "dockerexamples"
)

$ErrorActionPreference = "Stop";

if (-not (Test-Path $LicenseXmlPath)) {
    throw "Did not find $LicenseXmlPath"
}
if (-not (Test-Path $LicenseXmlPath -PathType Leaf)) {
    throw "$LicenseXmlPath is not a file"
}

# Register Sitecore Gallery if necessary
Import-Module PowerShellGet
$SitecoreGallery = Get-PSRepository | Where-Object { $_.SourceLocation -eq "https://sitecore.myget.org/F/sc-powershell/api/v2" }
if (-not $SitecoreGallery) {
    Write-Host "Adding Sitecore PowerShell Gallery..." -ForegroundColor Green 
    Register-PSRepository -Name SitecoreGallery -SourceLocation https://sitecore.myget.org/F/sc-powershell/api/v2 -InstallationPolicy Trusted
    $SitecoreGallery = Get-PSRepository -Name SitecoreGallery
}
# Install SitecoreDockerTools if necessary
if (!(Get-Module SitecoreDockerTools -ErrorAction SilentlyContinue))
{
    Write-Host "Installing SitecoreDockerTools..." -ForegroundColor Green
    Install-Module SitecoreDockerTools -Repository $SitecoreGallery.Name
}

Import-Module SitecoreDockerTools

###############################
# Populate the environment file
###############################

Write-Host "Populating required .env file variables..." -ForegroundColor Green

# CD_HOST
Set-DockerComposeEnvFileVariable "CD_HOST" -Value "cd.$($HostName).localhost"

# CM_HOST
Set-DockerComposeEnvFileVariable "CM_HOST" -Value "cm.$($HostName).localhost"

# ID_HOST
Set-DockerComposeEnvFileVariable "ID_HOST" -Value "id.$($HostName).localhost"

# REPORTING_API_KEY = random 64-128 chars
Set-DockerComposeEnvFileVariable "REPORTING_API_KEY" -Value (Get-SitecoreRandomString 64 -AlphanumericOnly)

# TELERIK_ENCRYPTION_KEY = random 64-128 chars
Set-DockerComposeEnvFileVariable "TELERIK_ENCRYPTION_KEY" -Value (Get-SitecoreRandomString 128)

# SITECORE_IDSECRET = random 64 chars
Set-DockerComposeEnvFileVariable "SITECORE_IDSECRET" -Value (Get-SitecoreRandomString 64 -AlphanumericOnly)

# SITECORE_ID_CERTIFICATE
$idCertPassword = Get-SitecoreRandomString 12 -AlphanumericOnly
Set-DockerComposeEnvFileVariable "SITECORE_ID_CERTIFICATE" -Value (Get-SitecoreCertificateAsBase64String -DnsName "localhost" -Password (ConvertTo-SecureString -String $idCertPassword -Force -AsPlainText))

# SITECORE_ID_CERTIFICATE_PASSWORD
Set-DockerComposeEnvFileVariable "SITECORE_ID_CERTIFICATE_PASSWORD" -Value $idCertPassword

# SITECORE_LICENSE
Set-DockerComposeEnvFileVariable "SITECORE_LICENSE" -Value (ConvertTo-CompressedBase64String -Path $LicenseXmlPath)

##################################
# Configure TLS/HTTPS certificates
##################################

Push-Location docker\traefik\certs
try {
    if (!(Test-Path mkcert.exe)) {
        Write-Host "Downloading and installing mkcert certificate tool..." -ForegroundColor Green 
        Invoke-WebRequest "https://github.com/FiloSottile/mkcert/releases/download/v1.4.1/mkcert-v1.4.1-windows-amd64.exe" -UseBasicParsing -OutFile mkcert.exe
        if ((Get-FileHash mkcert.exe).Hash -ne "1BE92F598145F61CA67DD9F5C687DFEC17953548D013715FF54067B34D7C3246") {
            Remove-Item mkcert.exe -Force
            throw "mkcert.exe hash mismatch"
        }
        .\mkcert.exe -install
    }
    Write-Host "Generating Traefik TLS certificate..." -ForegroundColor Green
    .\mkcert.exe "*.$($HostName).localhost"
}
catch {
    Write-Host "An error occurred while attempting to generate TLS certificate: $_" -ForegroundColor Red
}
finally {
    Pop-Location
}

################################
# Add Windows hosts file entries
################################

Write-Host "Adding Windows hosts file entries..." -ForegroundColor Green

Add-HostsEntry "cd.$($HostName).localhost"
Add-HostsEntry "cm.$($HostName).localhost"
Add-HostsEntry "id.$($HostName).localhost"

Write-Host "Done!" -ForegroundColor Green