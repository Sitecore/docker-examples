if ((Test-Path 'env:\DEFAULTWEBSITEPATH') -And (Test-Path 'env:\SITEPATH')){

    [string]$DefaultWebsitePath = $env:DEFAULTWEBSITEPATH + '\*'
	if (-Not (Test-Path $DefaultWebsitePath)){
		Write-Host "### '$DefaultWebsitePath' is not valid."
		Exit
	}
    [string]$WebsitePath = $env:SITEPATH
	if (-Not (Test-Path $WebsitePath -PathType 'Container')){
		Write-Host "### '$WebsitePath' is not valid."
		Exit
	}

	$noSitecoreFiles = ((Get-ChildItem -Path $WebsitePath -Filter "Web.config") -eq $null -or (Get-ChildItem -Path ("{0}\sitecore\service" -f $WebsitePath) -Filter "Heartbeat.aspx") -eq $null)

	if ($noSitecoreFiles)
	{
		Write-Host "### Sitecore files not found in '$WebsitePath', seeding clean Website ..."

		Copy-Item -Path $DefaultWebsitePath -Destination $WebsitePath -Force -Recurse
		$webConfig = Join-Path $WebsitePath "Web.config"
		$doc = new-object System.Xml.XmlDocument
		$doc.Load($webConfig)
		$doc.get_DocumentElement()."system.web".compilation.debug = "true"
		$doc.Save($webConfig)
	}
	else
	{
		Write-Host "### Existing Sitecore files found in '$WebsitePath'..."
	}
	
}
