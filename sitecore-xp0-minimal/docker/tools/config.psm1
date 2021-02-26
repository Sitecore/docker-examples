function Get-EnvVar {
  param(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string] 
    $Key
  )

  select-string -Path ".env" -Pattern "^$Key=(.+)$" | % { $_.Matches.Groups[1].Value }
}


function Read-UserEnvFile {
  param(
    [Parameter()]
    [string] $EnvFile = ".env.user"
  )

  if (Test-Path $EnvFile) {
      Write-Host "User specific .env file found. Starting Docker with custom user settings." -ForegroundColor Green
      Write-Host "Variable overrides:-" -ForegroundColor Yellow
      
      Get-Content $EnvFile | Where-Object { $_ -notmatch '^#.*' -and $_ -notmatch '^\s*$' } | ForEach-Object {
          $var, $val = $_.trim().Split('=')
          Write-Host "  $var=$val" -ForegroundColor Yellow
          Set-Item -Path "env:$($var)" -Value $val
      }
  }
}


Export-ModuleMember -Function *
