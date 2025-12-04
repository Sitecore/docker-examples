# Sitecore Docker Examples

This repository contains companion code for the [Sitecore Containers documentation](https://doc.sitecore.com/xp/en/developers/latest/developer-tools/containers-in-sitecore-development.html). Together, these are meant to help you get started using [Docker](https://www.docker.com/) containers with Sitecore.

Briefly, here's what you'll find in this repo:

* Example for running an out of the box Sitecore instance (see `getting-started`).
* Example solution for creating custom Sitecore images, with recommended folder structure for container development (see `custom-images`).
* Sample PowerShell scripts for container-based Sitecore instance preparation (`init.ps1`) and cleanup (`clean.ps1`).
* Docker compose file for running side-by-site XP0 instances with different versions of Sitecore (see `sitecore-compare`).
* Docker compose files for building Sitecore instances in various topologies (see `custom-images`).

Please refer to the [Sitecore Containers documentation](https://doc.sitecore.com/xp/en/developers/latest/developer-tools/containers-in-sitecore-development.html) for complete details, including running the examples and recommended usage.

## Are Docker Examples supported by Sitecore?

Sitecore maintains the Sitecore Containers documentation and Docker Examples, but example code is not supported by Sitecore Product Support Services. Please do not submit support tickets regarding Docker Examples.

## How can I get help with Docker Examples?

Start with the [Sitecore Containers documentation](https://doc.sitecore.com/xp/en/developers/latest/developer-tools/containers-in-sitecore-development.html). For technical issues in particular, check out the [Troubleshooting guide](https://doc.sitecore.com/xp/en/developers/latest/developer-tools/troubleshooting-docker.html)

Beyond that, for usage questions regarding Docker Examples installation or code, or general questions about Sitecore Containers, please utilize [Sitecore StackExchange](https://sitecore.stackexchange.com/questions/tagged/docker) or [#docker](https://sitecorechat.slack.com/messages/docker) on [Sitecore Community Slack](https://sitecore.chat/).

You can use GitHub to submit [issues](https://github.com/Sitecore/docker-examples/issues/new) for Docker Examples, but please do not submit usage questions.

## Steps to setup on the your local Windows machine:

1. Download and install Docker Desktop for Windows: https://docs.docker.com/desktop/install/windows-install/
	- See documentation to learn more: https://docs.docker.com/get-started/overview/
2. Create a folder on your local drive, e.g. 'C:\Sitecore Headless'
	- Open the folder 'C:\Sitecore Headless' in Windows File Explorer
		- Open GitBash command prompt and execute the following git command:
			- git clone https://github.com/Sitecore/docker-examples.git
	- Open Windows Powershell as Administrator
		- Execute the following powersell commands:
			- cd "C:\Sitecore Headless"
			- Copy-Item "C:\Sitecore Headless\docker-examples\GettingStartedSetup\SetupDependecies" "C:\Sitecore Headless" -Force;
			- Copy-Item "C:\Sitecore Headless\docker-examples\GettingStartedSetup\SitecoreHeadless_WithContainers.ps1" "C:\Sitecore Headless" -Force;
				- Manually copy your company's own license file into the "C:\Sitecore Headless\SetupDependecies" folder.
			- powershell.exe -executionpolicy bypass -file .\SitecoreHeadless_WithContainers.ps1 true true
				- Note the first 'true' param in the above command is for a $cleanInstall, i.e. removes the 'MyProject' folder instance created from any previous installation.
				- Note the second 'true' param the above command is for a $switchRunFolderSource (optional param), i.e. copies the content of the 'C:\Sitecore Headless\docker-examples\GettingStartedSetup\SetupDependecies\run' folder into 
				the newly created 'MyProject' folder instance created from this installation.
					- The $switchRunFolderSource param is only if you require custom 'run' folder scripts, 
					i.e. any script commands changes from 'powershell.exe -Command "& C:\tools\entrypoints\iis\Development.ps1' to 'powershell.exe -Command "& C:/tools/entrypoints/iis/Development.ps1'
						- Note this is only in instance when your windows instance an issue with the backslashes in the script command.
