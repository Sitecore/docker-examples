param(
    [int]$RequestTimeout = 300,
    [string]$Server = "http://localhost",
    [string]$ReadyCheck = "/healthz/ready",
    [string]$LiveCheck = "/healthz/live",
    [int]$Port = 80
)

function InvokeWebRequest {
    param (
        [string]$Endpoint,
        [int]$RequestTimeout
    )

    try {
        $response = Invoke-WebRequest -Uri $Endpoint -UseBasicParsing -TimeoutSec $RequestTimeout
    }
    catch {
        $response = $_.Exception.Response
    }
    finally {
        Write-Information -MessageData "$Endpoint - $($response.StatusCode)" -InformationAction:Continue

        if ($response.StatusCode -eq 200) {
            $returnCode = 0
        } else {
            $returnCode = 1
        }
    }

    return $returnCode
}

function IsReady {
    param (
        [string]$ReadyLockFile
    )

    if (!(Test-Path -Path $ReadyLockFile -PathType Leaf)) {
        return $false
    }

    $serviceMonitorStartTime = (Get-Process ServiceMonitor).StartTime.Ticks
    $readyLockFileWriteTime = (Get-Item $ReadyLockFile).LastWriteTime.Ticks
    if ($readyLockFileWriteTime -lt $serviceMonitorStartTime) {
        return $false
    }
    
    return $true
}

$readyLockFile = Join-Path -Path $env:LOCALAPPDATA -ChildPath "Healthcheck\readyLock"
$isReady = IsReady -ReadyLockFile $readyLockFile

if ($isReady) {
    $check = $LiveCheck
} else {
    $check = $ReadyCheck
}
$check = "$($Server):$port$check"

$result = InvokeWebRequest -Endpoint $check -RequestTimeout $RequestTimeout

if ($result -eq 1) {
    exit 1
}

if (!$isReady) {
    New-Item -Path $readyLockFile -ItemType File -Force
}

exit 0