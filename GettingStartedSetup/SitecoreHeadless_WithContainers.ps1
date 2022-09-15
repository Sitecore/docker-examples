$RootScriptPath = Get-Location;
$MachineName = $env:computername;

function SitecoreHeadless-Environment-Autotmation {
	
	try 
	{
		if ((Test-Path $RootScriptPath))
		{
			Write-Host "The {$RootScriptPath} folder does exist.";
			
			try 
			{
				Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass;
				$envLicenseFileSourcePath = ("{0}\\SetupDependecies\\license.xml" -f $RootScriptPath);
				$envRunFolderSourcePath = ("{0}\\SetupDependecies\\run" -f $RootScriptPath);
				$envDestPath = ("{0}\\MyProject" -f $RootScriptPath);
				if ($cleanInstall)
				{
					Write-Host "The {$envLicenseDestPath} folder is recursively being removed before executing clean npm install.";
					Remove-Item .\MyProject -Force -Recurse;
				}
				dotnet new -i Sitecore.DevEx.Templates --nuget-source https://sitecore.myget.org/F/sc-packages/api/v3/index.json
				echo y | dotnet new sitecore.aspnet.gettingstarted -n MyProject;
				
				Copy-Item $envLicenseFileSourcePath $envDestPath -Force;
				Write-Host "The {$envLicenseFileSourcePath} file was just copied.";
				
				if ($switchRunFolderSource)
				{
					Copy-Item $envRunFolderSourcePath $envDestPath -Force -Recurse;
					Write-Host "The {$envRunFolderSourcePath} folder was just copied.";
				}
				
				cd $envDestPath;
				iisreset /stop;
				powershell.exe -executionpolicy bypass -file .\init.ps1 -InitEnv -LicenseXmlPath ".\license.xml" -AdminPassword "b";
				powershell.exe -executionpolicy bypass -file .\up.ps1;
			}
			catch 
			{
				Quit ("An Exception error occured in the npm packages restore automation method. {0}." -f $Error[0]);
			}
		}
	}
	catch 
	{
		Quit ("An Exception error occured in the BachmansStoreFront-Environment-Autotmation method. {0}." -f $Error[0]);
	}
}

function Quit($Text) 
{
    Write-Warning $Text;
    cd $RootScriptPath;
    Break Script;
}

[bool] $cleanInstall = $false;
[bool] $switchRunFolderSource = $false;
if ($args[0]) 
{
	$cleanInstall = $true;
}
if ($args[1]) 
{
	$switchRunFolderSource = $true;
}
Write-Host "The cleanInstall param is set to {$cleanInstall}.";
Write-Host "The switchRunFolderSource param is set to {$switchRunFolderSource}.";


Set-ItemProperty 'HKLM:\System\CurrentControlSet\Control\FileSystem' -Name 'LongPathsEnabled' -value 1 -Force;
Write-Host "SitecoreHeadless-Environment Autotmation Setup with Dependencies - Started";
SitecoreHeadless-Environment-Autotmation;
Write-Host "SitecoreHeadless-Environment Autotmation Setup with Dependencies - Completed";
cd -Path $RootScriptPath;