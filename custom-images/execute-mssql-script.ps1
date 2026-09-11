<#
.SYNOPSIS
    Executes a SQL script against a Microsoft SQL Server instance using sqlcmd.

.DESCRIPTION
    This script connects to a specified SQL Server instance and executes a provided SQL script file.
    Connection parameters such as server name, user, password, database, and script path are accepted as parameters.
    The script checks for the existence of the SQL script file before execution and reports errors if not found.

.PARAMETER Server
    The SQL Server instance to connect to. Default is "localhost,14330".

.PARAMETER User
    The SQL Server login to use for authentication. Default is "sa".

.PARAMETER Password
    The password for the SQL Server login.

.PARAMETER Database
    The name of the database to execute the script against. Default is "Sitecore_Core".

.PARAMETER ScriptPath
    The full path to the SQL script file to execute.

.EXAMPLE
    .\execute-mssql-script.ps1 -Password "yourPassword" -ScriptPath "C:\Path\To\Your.sql"

    Executes the specified SQL script against the default server and database using the provided password.

.EXAMPLE
    .\execute-mssql-script.ps1 -Server "localhost,14330" -User "sa" -Password "yourPassword" -Database "Sitecore_Core" -ScriptPath "C:\Path\To\Your.sql"

    Executes the specified SQL script against the given server and database using the provided credentials.

.NOTES
    Requires sqlcmd to be installed and available in the system PATH.
#>

[CmdletBinding(DefaultParameterSetName = "no-arguments")]
Param (
        [Parameter(Mandatory = $true, HelpMessage = "Specifies the path of the .env file.")]
        [string]$filePath = ".env"  # Default path for the .env file
)

# Get the environment variable from the .env file
function GetEnvVariable {
    param(
        [Parameter(Mandatory = $true, HelpMessage = "Specifies the path of the .env file.")]
        [string]$filePath = ".env",  # Default path for the .env file
        [Parameter(Mandatory = $true, HelpMessage = "Specifies the .env name.")]
        [string]$varName  # Name of the environment variable to retrieve
    )

    Write-Host "Inside GetEnvVariable"  # Log entry into the function

    $envFilePath = Resolve-Path "$PSScriptRoot\$filePath"  # Resolve the full path of the .env file

    if (Test-Path $envFilePath) {  # Check if the .env file exists
        if ($varName -ne "" -and $envFilePath -ne "") {  # Ensure parameters are not empty
            Write-Host "Using .env file: $envFilePath" -ForegroundColor Cyan  # Log the file being used
            # Read the contents of the .env file
            $envFileContent = Get-Content -Path $envFilePath  # Load the file content into an array

            # Iterate through each line to find the variable
            foreach ($line in $envFileContent) {
                if ($line -match "^\s*$varName\s*=\s*(.+)\s*$") {  # Check if the line matches the variable name
                    $varValue = $matches[1].Trim()  # Extract the variable value
                    #Write-Host "Environment variable '$varName' found with value '$varValue'."  # Log success message
                    Write-Host "Environment variable '$varName' found" -ForegroundColor DarkMagenta  # Log success message
                    return $varValue  # Return the found value
                }
            }

            Write-Host "Environment variable '$varName' not found in the .env file." -ForegroundColor Yellow  # Log if not found
            return $null  # Return null if not found
        } else {
            Write-Host "Invalid parameters" -ForegroundColor Red  # Log error for invalid parameters
            return $null  # Return null for invalid parameters
        }
    } else {
        Write-Error "The .env file does not exist at the specified path: $envFilePath"  # Log error if file doesn't exist
        return $null  # Return null if file doesn't exist
    }
}

$saLogin = GetEnvVariable -filePath $filePath -varName "SQL_SA_LOGIN"  # Retrieve the SA login from the .env file
$saPassword = GetEnvVariable -filePath $filePath -varName "SQL_SA_PASSWORD"  # Retrieve the SA login from the .env file

$currentDirectory = Get-Location
$sqlFiltePath = Join-Path -Path $currentDirectory -ChildPath "\docker\build\mssql\CMS_security_IdentityServer.sql"


if (-not (Test-Path $sqlFiltePath)) {
	Write-Error "Could not find SQL script at path '$sqlFiltePath'."
    return
}

Write-Host "Found the MSSQL container SQL script at $sqlFiltePath" -ForegroundColor DarkCyan

Write-Host "Executing SQL script using sqlcmd..." -ForegroundColor Cyan

# Run the script using sqlcmd from host
# Based on Sitecore Identity Server 8 Upgrade Guide https://scdp.blob.core.windows.net/downloads/Sitecore%20Identity/8x/Sitecore_Identity_Server_8016/Sitecore_Identity_Server_Upgrade-DockerCompose-8.0.pdf

sqlcmd -S localhost,14330 -U $saLogin -P $saPassword -d "Sitecore.Core" -i $sqlFiltePath

Write-Host "Done  - MSSQL container SQL script." -ForegroundColor Green