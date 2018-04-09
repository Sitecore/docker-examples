#TDS Sample

## Demo Introduction

This demo showcases how to create a VS2017 project for Sitecore with the following features:

1. TDS sample project for Sitecore "master" database
1. Processor example for debugging demo
1. Website folder as volume with files stored in the development machine, at debugging time (no need for synchronization)
1. Website folder embedded in the image at runtime.
1. Website folder files, databases and Solr cores are automatically copied from the images to the Development environment (if missing) (same as databases).
1. Attach to IIS process in the container from VS2017 for debugging

# TDS Introduction

TDS stand for [Team Development for Sitecore](https://www.teamdevelopmentforsitecore.com/). It is a suite of commercial products built and maintained by [Hedgehog](https://www.hhog.com/).

To run this demo only one tool from the suite is necessary. Its name is [TDS Classic](https://www.teamdevelopmentforsitecore.com/TDS-Classic).

This project shows how to do basic TDS Classic tasks with a Sitecore instance running in a container.

## Prerequisites

* Windows 10 Fall Creators Update
* Docker for Windows
* Visual Studio 2017 15.5 or later
* Clone the [Sitecore base docker-images repository](https://github.com/Sitecore/docker-images) and build the images for the Sitecore version "9.0.1 rev. 171219 XM1 CM".
* TDS Classic needs to be installed, which requires a commercial license. It has been tested with TDS Classic version 5.7.0.13 although it may work with other versions.

## Development Environment Setup

1. Clone [this repository](https://github.com/Sitecore/docker-demo) into a folder such as “c:\Docker\Sitecore\docker-demo” (next steps will assume this folder has been used):
1. Copy "**license.xml**" into "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**storage\Data**“
1. Open VS2017 as Administrator
1. Open the solution “C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**TDSSample.sln**”
1. Copy the file “C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\src\Website\Properties\PublishProfiles\\**LocalDevContainer.pubxml.example**” as “**LocalDevContainer.pubxml**”, in the same folder.
1. From VS2017, edit the Publication settings for the project “Website”. Set the Target Location to “C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**storage\Website**”
1. Review the files "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**Website\Dockerfile**" and "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**Website\build.Dockerfile**" and update the `FROM` clause with the name used to build the base images.
1. Make sure the project “**docker-compose**” is set as StartUp project
1. Run the solution with “**Debug**” configuration ("F5").
   >The first time the containers run, the base images will detect that the required assets (databases, indexes and site files) are missing in their respected VOLUMEs (pointing to the development environment) and will take some time to create them. VS will build the containers and will try to attach to the IIS's process running in website's container, however it will fail (TODO: fix this known issue). In the meantime, the file transfer from the images to the Development environment will keep progressing. Please be patient.
1. Copy the website's container’s IP from the VS' "Output" panel (make sure it is the "Docker" output) and paste the IP on a browser's address bar. Please notice that Sitecore needs some time to warm-up, therefore the initial start may take a bit (up to 5-6 min).
1. The browser will display the OOTB Sitecore’s home page.

## Development Process

Every time VS2017 is open, it must be run at least one to get containers run. After that initial run, the containers will remain up running meanwhile VS2017 is open, allowing us to make changes and published them to the following folder through the standard VS publishing feature (as if the container was an IIS instance running locally).
    "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**storage\Website**“

Every time the containers are run, they get a new internal IP which needs to be set in the development environment's "**host**" file to be able to access the site through a URL. For this example, we will use "**sitecore901.xm1.tds.dev.local**"

## Deploy the TDS project

1. With VS2017, edit the properties of the TDS project “**TDS.Website.master**”.
   1. Select tab “**Build**”
   1. Check the checkbox “Edit user specific configuration (.user file)”
   1. Set the following values in the text boxes:
   1. Sitecore Web Url: “http://sitecore901.xm1.tds.dev.local”
   1. Sitecore Deploy Folder: "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**storage\Website**“
   1. Check the checkbox “**Install Sitecore Connector**”. A guid should appear in the “Sitecore Access Guid” field
   1. Save the project.
   1. Click the “Test” button to confirm the connection works
1. Deploy the TDS project “**TDS.Website.master**”
1. Browse to “http://sitecore901.xm1.tds.dev.local/sitecore/shell”
1. Login with “admin” and “b”
1. With the “Content Editor” expand the item “/sitecore/content/Home” to see its children. There should be a child page deployed by the TDS project.


## Debugging Sitecore with VS2017

### Attaching VS2017 to Sitecore

The following steps describes how to attach VS2017 to the IIS process where Sitecore is running within its container.

1. Make sure Sitecore is running by browsing to its IP which can be obtained with either of the following procedures:
   1. Through VS2017
      1. When VS2017 runs a docker project (it must be selected as StartUp project) the website container's IP is displayed in the "Output" panel ("Docker" output). There should be as below example:
         ```text
         ========== Debugging ==========
         docker ps --filter "status=running" --filter "name=dockercompose14165912220825680628_website_" --format {{.ID}} -n 1
         ac58646e9013
         docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" ac58646e9013
         172.22.99.92 
         ```
          * Notice that the "**ac58646e9013**" is the container id. It is different every time the container is created
          * The following instruction is used to get the container's IP. Notice the container ID at the end.
         ```text
         docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" ac58646e9013
         ```
          * Finally, the last line is the container's IP which also changes every time the container is run.
   1. Through a console
      1. Get the container's ID: 
         ```text
         PS C:\> docker ps -a
         CONTAINER ID        IMAGE                                                   COMMAND                  CREATED             STATUS                       PORTS                   NAMES
         ac58646e9013        website:dev                                             "powershell -Command…"   About an hour ago   Up About an hour             0.0.0.0:37434->80/tcp   dockercompose14165912220825680628_website_1
         984cdde5faee        VSWebsiteRegistry.azurecr.io/sitecore:9.0.171219-sql    "powershell -Command…"   About an hour ago   Up About an hour (healthy)                           dockercompose14165912220825680628_sql_1
         da78adba6ac0        VSWebsiteRegistry.azurecr.io/sitecore:9.0.171219-solr   "powershell -Command…"   About an hour ago   Up About an hour             8983/tcp                dockercompose14165912220825680628_solr_1
         PS C:\>
         ```
          Notice in the table above the container named "**\*_website_1**", with image named "website:dev". This is the website container which IP is needed.
      1. Make sure the container status is "Up" by checking the "STATUS" column.
      1. Copy the container id value.
      4. Run the following command to get the container's IP.
         ```text
         PS C:\> docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" ac58646e9013
         172.22.99.92
         PS C:\>
         ```

### Debugging Test

1. Make sure the "**TDS.Website.master**" project has been configured and deployed as explained in previous section.
1. Browse to "http://sitecore901.xm1.tds.dev.local" and confirm that the Home page has a customisation that displays the container's Computer Name which is a code matching with the initial characters of the container's ID. This is a small customisation made for demo purposes.
1. With VS2017 open the file "c:\docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\src\Website\Processors\\**ExampleProcessor.cs**" and set an interruption point in the line 12 of the code.
1. Attach VS2017 to the IIS process running in the container as described in previous section.
1. Refresh the Home page in the browser. VS2017 should stop execution where the interruption point was set and allow the user to change execution by skipping one line, for instance.

### Sitecore logs

Sitecore logs can be found in the following location:
   "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**storage\Data**“

### Sitecore site files

The sitecore site files, in the Container, are directly accessible from the following folder in the development machine:
   "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\TDSSample\\**storage\Website**“

Any change made in the above folder will be automatically detected by Sitecore in the container.

## Release Configuration

If the solution is switched to the "Release" configuration re-run, the container is re-created with the Website folder embedded inside along with the project output. This simplifies deployments to other environments (QA, UAT and Production).

## Known issues

1. Visual Studio fails when trying to attach just after starting debugging session. VS can attach to the running process in container afterwards, though. See section "Attaching VS2017 to Sitecore" for a workaround
