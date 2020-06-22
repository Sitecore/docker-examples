[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [string]
    [ValidateNotNullOrEmpty()]
    $LicenseXmlPath
)

$ErrorActionPreference = "Stop";

# Register sc-powershell PSRepository if necessary
Import-Module PowerShellGet
if (!(Get-PSRepository -Name "sc-powershell" -ErrorAction SilentlyContinue)) 
{
    Register-PSRepository -Name "sc-powershell" -SourceLocation "https://sitecore.myget.org/F/sc-powershell/api/v2"
}
# Install SitecoreDockerTools if necessary
if (!(Get-Module SitecoreDockerTools -ErrorAction SilentlyContinue)) 
{
    Install-Module SitecoreDockerTools
}

Import-Module SitecoreDockerTools

if (-not (Test-Path $LicenseXmlPath))
{
    throw "Did not find $LicenseXmlPath"
}
if (-not (Test-Path $LicenseXmlPath -PathType Leaf))
{
    throw "$LicenseXmlPath is not a file"
}

# CM_HOST
Add-HostsEntry "xp0cm.localhost"

# ID_HOST
Add-HostsEntry "xp0id.localhost"

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