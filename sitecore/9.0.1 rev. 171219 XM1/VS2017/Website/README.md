# docker-demo for Sitecore 9.0.1 rev. 171219 XM1

This demo showcases how to create a VS2017 project for Sitecore with the following features:

1. Website folder as volume with files stored in the development machine, at debugging time (no need for synchronization)
1. Website folder embedded in the image at runtime.
1. Website folder files, databases and Solr cores are automatically copied from the images to the Development environment (if missing) (same as databases).
1. Attach to IIS process in the container from VS2017 for debugging

## Prerequisites

* Windows 10 Fall Creators Update
* Docker for Windows
* Visual Studio 2017 15.5 or later

## Development Environment Setup

1. Clone [this repository](https://github.com/Ben-m-s/Sitecore82TDS.git) into a folder such as “C:\Docker\Sitecore82TDS” (next steps will asume this folder has been used):
1. Copy "**Sitecore 8.2 rev. 161221.zip**" into “c:\Docker\Sitecore82TDS\\**images\sitecore-82rev161221**“
1. Copy "**license.xml**" into "c:\Docker\Sitecore82TDS\\**storage\Data**“
1. Copy the database files (*.mdf and *.ldf) from "**Sitecore 8.2 rev. 161221.zip**" into "c:\Docker\Sitecore82TDS\\**storage\Databases**“
1. Copy The "Website" folder files from "**Sitecore 8.2 rev. 161221.zip**" into "c:\Docker\Sitecore82TDS\\**storage\Website**“
1. Open VS2017 as Administrator
1. Open the solution “c:\Docker\Sitecore82TDS\\**Sitecore82TDS.sln**”
1. Open a PowerShell console as Administrator.
1. Build base images by running the folliwing PowerShell script:
    ```text
    .\Build.ps1
    ```
1. Copy file “c:\Docker\Sitecore82TDS\src\Website\Properties\PublishProfiles\\**LocalDevContainer.pubxml.example**” as “**LocalDevContainer.pubxml**”
1. Edit the Publication settings "**LocalDevContainer**" for the project “Website”. Set the Target Location to “C:\Docker\Sitecore82TDS\\**storage\website**”
1. Build the solution.
1. Publish the Website project to the local folder "c:\Docker\Sitecore82TDS\\**storage\Website**“
1. Make sure the project “**docker-compose**” is set as StartUp project
1. Run the containers with “**Debug**” configuration. The browser will open with Sitecore’s home page.
1. Copy the container’s IP in the “c:\Windows\System32\drivers\etc\\**hosts**” file with the URL: **sitecore82tds.dev.local**
1. With VS2017, edit the properties of the TDS project “**SampleSite.Master**”.
   1. Select tab “**Build**”
   1. Check the checkbox “**Edit user specific configuration (.user file)**”
   1. Set the following values in the text boxes:
      1. Sitecore Web Url: “http://sitecore82tds.dev.local”
      1. Sitecore Deploy Folder: "c:\Docker\Sitecore82TDS\storage\Website“
   1. Check the checkbox “**Install Sitecore Connector**”. A guid should appear in the “Sitecore Access Guid” field
   1. Click the “**Test**” button to confirm the connection works
   1. Save the project.
1. Deploy the TDS project “**SampleSite.Master**”
1. Browse to “http://sitecore82tds.dev.local/sitecore/shell”
1. Login with “admin” and “b”
1. Browse to “**/sitecore/content/Home**”. Confirm there is a child page deployed by TDS.


## Known issues

1. Visual Studio fails when trying to attach just after starting debugging session. VS can attach to the running process in container afterwards, though.

