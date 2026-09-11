# Sitecore Custom Images

Example solution for creating [custom Sitecore images](https://doc.sitecore.com/xp/en/developers/103/developer-tools/create-custom-sitecore-images.html), with recommended folder structure for container development.

Please follow below steps to setup this repository on your local system

## Steps

1. Clone this repo

2. Open the PowerShell command prompt with `ADMIN` access

3. Go to the folder `custom-images` in the PowerShell window

4. Execute the `init.ps1` with `ADMIN` access and pass the license file path

```powershell
.\init.ps1 -LicenseXmlPath "<C:\path\to\license.xml><path to your license.xml file>"
```


5. Build the appropriate Docker images and then start up.

```powershell
.\clean-install.ps1 <XP1 or XM1>
```
 - `.\clean-install.ps1 XP1` will create the XP Scaled environment
- `.\clean-install.ps1 XM1` will create the XM environment
- `.\clean-install.ps1` will create the XP0 environment

    The above command will create the specific Sitecore Topology environemnt.

6. Tear down and cleanup code changes when done.
```powershell
.\down.ps1 <XP1 or XM1>
```
 - `.\down.ps1 XP1` will clear artifacts for the XP Scaled environment
- `.\down.ps1 XM1` will clear artifacts for the XM environment
- `.\down.ps1` will clear artifacts for the XP0 environment





