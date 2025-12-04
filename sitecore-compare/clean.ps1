# Clean data folders
Get-ChildItem -Path (Join-Path $PSScriptRoot "\mssql-data") -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose
Get-ChildItem -Path (Join-Path $PSScriptRoot "\solr-data") -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose
Get-ChildItem -Path (Join-Path $PSScriptRoot "\device-detection-data_1") -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose
Get-ChildItem -Path (Join-Path $PSScriptRoot "\device-detection-data_2") -Exclude ".gitkeep" -Recurse | Remove-Item -Force -Recurse -Verbose