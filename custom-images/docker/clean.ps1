Get-ChildItem -Path (Join-Path $PSScriptRoot "\data") -Directory | ForEach-Object {
    $dataPath = $_.FullName

    Get-ChildItem -Path $dataPath -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose
}

Get-ChildItem -Path (Join-Path $PSScriptRoot "\deploy") -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose