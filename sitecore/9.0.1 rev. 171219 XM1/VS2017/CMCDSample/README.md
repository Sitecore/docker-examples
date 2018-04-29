# CMCDSample Demo

## Demo Introduction

This demo showcases how to create a VS2017 project for Sitecore with the following features:

1. Two different Sitecore role servers, Content Manager and Content Delivery, available for debugging.
1. Each Sitecore role server has a "Website" folder mounted as volume with its files stored in the development machine, at debugging time (no need for synchronization)
1. The "Website" folders are embedded in the image at runtime.
1. The Sitecore files, databases and Solr cores are automatically copied from the images to the Development environment (if missing).
1. Support for attaching to IIS process in the Content Manager and Content Delivery containers from VS2017 for debugging

## Prerequisites

* Windows 10 Fall Creators Update
* Docker for Windows
* Visual Studio 2017 15.5 or later
* Clone the [Sitecore base docker-images repository](https://github.com/Sitecore/docker-images) and build the images for the Sitecore version "9.0.1 rev. 171219 XM1 CM".

## Development Environment Setup

1. Clone [this repository](https://github.com/Sitecore/docker-demo) into a folder such as “c:\Docker\Sitecore\docker-demo” (next steps will assume this folder has been used):
1. Copy "**license.xml**" into:
   1.  "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CD\Data**“
   1.  "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CM\Data**“
1. Open VS2017 as Administrator
1. Open the solution “C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**CMCDSample.sln**”
1. Copy all files with extension "*.sample" located in the folder “C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\src\Website\Properties\PublishProfiles\”, and remove the "sample" extension to leave them as “**\*.pubxml**”, in the same folder.
1. Make sure the project “**docker-compose**” is set as StartUp project
1. Build the solution. The two projects in the solution should compile.
1. Review the file "C:\docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**docker-compose.yml**" and update the `BASE_IMAGE` argument with the name used to build the Content Manager (cm) and Content Deliver (cd) base images.
1. Build the solution with the “**DebugCM**” solution configuration ("F5").
   >The first time the containers run, the base images will detect that the required assets (databases, indexes and site files) are missing in their respected VOLUMEs (pointing to the development environment) and will take some time to create them. VS will build the containers and will try to attach to the IIS's process running in one of the sitecore's container (cm or cd), however it will fail because the container will not be ready yet (it will need some more time). In the meantime, the file transfer from the images to the Development environment will keep progressing. Please be patient.
1. The VS' "Output" panel ("Docker" output) will display the IP of one of the sitecore's containers (cm or cd). Use one of the following commands to get the other:
    ```text
    # Get the CM IP
    docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" $(docker ps -q -f "status=running" -f "name=_cm_")

    # Get the CD IP
    docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" $(docker ps -q -f "status=running" -f "name=_cd_")
    ```
1. Paste each IP on a browser's address bar. Please notice that Sitecore needs some time to warm-up, therefore the initial start may take a bit (up to 1-2 min).
1. The browser will display the OOTB Sitecore’s home page for both, the Content Manager and the Content Delivery servers.
1. Choose one domain for each Sitecore server (ie: "sitecore901.xm1.cm.dev.local" and "sitecore901.xm1.cd.dev.local") and update the local "host" file, associating each of these domains with the IP of the corresponding sitecore container "**cd**" or "**cm**".
1. Confirm that you can browse to both containers using their respective domains.
1. Deploy the Sitecore customizations made in the project "Website" to both, the Content Manager and the Content Deliver Servers:
   1. **Content Delivery:** Use the publication profile named "**Local Dev CD**" to publish the "Website" project to the "**cd**" service
      "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CD\Website**“
   1. **Content Manager:** Use the publication profile named "**Local Dev CM**" to publish the "Website" project to the "**cm**" service
      "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CM\Website**“
1. Refresh the browser (Ctrl + F5) and confirm that the Sitecore default home page has a customization that displays the name of the container and also its Sitecore role.

## Development Process

Sitecore supports multiple sites and multiple URL for each site. It may be necessary to access the site with a specific URL (other than the IP). In these cases, it is necessary to update the development environment's host file every time the container is run (instantiated), which happens the first time VS runs the project.

Following the initial container run, the containers can remain running meanwhile changes are done to the website and published to either the Content Manager or the Content Deliver containers through the standard VS publishing feature, as if the containers were IIS instances running in the development environment (no containerised).
The "Website" project has the following publication profiles to publish changes locally:

* **Local Dev CD:** Publish changes to the "" server/container:
    * "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CD\Website**“
* **Local Dev CM:** Publish changes to the "" server/container:
    * "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CM\Website**“

### Configuration transformations

Each Sitecore role requires its specific configuration settings. Standard configurarion transformations are used in this example to generate the Web.confg file specific for each server role.

The base "Web.config" file that can be found in the "Website" project has been taken directly from the standard base image for the Content Manager role. This allows us to detect changes made in this file in future versions of the same image.

There is one transformation file for each Solution configuration: combination of Debug|Release and Sitecore role (CM|CD)

* DebugCD
* DebugCM
* ReleaseCD
* ReleaseCM


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

### Sitecore logs

Sitecore logs can be found in the following location:
   "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\Data**“

### Content Manager and Content Deliver site files

The site files for the two sitecore roles, in the containers, are directly accessible from the following folders in the development machine:

* Content Deliver:
   * "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CD\Website**“
* Content Manager:
   * "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\CMCDSample\\**storage\CM\Website**“

Any change made in the above folders will be automatically detected by Sitecore in the corresponding container.

## Release Configurations

If the solution is switched to the "ReleaseCD" or "ReleaseCM" configurations and re-built, the Sitecore containers are re-created with the Website folder embedded inside along with the project output. This simplifies deployments to other environments (QA, UAT and Production).

## Known issues

1. Visual Studio fails when trying to attach just after starting a debugging session. VS can attach to the running process in container afterwards, though. See section "Attaching VS2017 to Sitecore"
