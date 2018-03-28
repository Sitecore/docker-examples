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
* Clone the [Sitecore base docker-images repository](https://github.com/Sitecore/docker-images) and build the images for the Sitecore version "9.0.1 rev. 171219 XM1 CM".

## Development Environment Setup

1. Clone [this repository](https://github.com/Sitecore/docker-demo) into a folder such as “c:\Docker\Sitecore\docker-demo” (next steps will asume this folder has been used):
1. Copy "**license.xml**" into "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\SimpleSample\\**storage\Data**“
1. Open VS2017 as Administrator
1. Open the solution “C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\SimpleSample\\**SimpleSample.sln**”
1. Make sure the project “**docker-compose**” is set as StartUp project
1. Build the solution. The two projects in the solution should compile.
1. Build the solution with “**Debug**” configuration ("F5").
   >The first time the containers run, the base images will detect that the required assets (databases, indexes and site files) are missing in their respected VOLUMEs (pointing to the development environment) and will take some time to create them. VS will build the containers and will try to attach to the IIS's process running in website's container, however it will fail (TODO: fix this known issue). In the meantime, the file transfer from the images to the Development environment will keep progresing. Please be patient.
1. Copy the website's container’s IP from the VS' "Output" panel (make sure it is the "Docker" output) and paste the IP on a browser's address bar. Please notice that Sitecore needs some time to warm-up, therefore the initial start may take a bit (up to 1-2 min).
1. The browser will display the OOTB Sitecore’s home page.
1. Any change made to the following folder will be automatically detected by sitecore 
   "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\SimpleSample\\**storage\Website**“

## Development Process

Sitecore supports multiple sites and also multiple URL for each site. It may be necessary to access the site with a specific URL (other than the IP). In these cases, it is necessary to update the development environment's host file every time the container is run (instantiated), which happens the first time VS runs the project.

Following the initial container run, the container can remain running meanwhile changes are done to the website and published to the following folder through the standard VS publishing feature (as if the container was an IIS instance running locally).
    "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\SimpleSample\\**storage\Website**“

## Debugging Sitecore with VS2017

### Attaching VS2017 to Sitecore

The following steps describes how to attach VS2017 to the IIS process where Sitecore is running within its container.

1. Make sure Sitecore is running by browising to its IP which can be obtained with either of the following procedures:
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
          * Finally the last line is the container's IP which also changes every time the container is run.
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
      4. Run the following command to the the container's IP.
         ```text
         PS C:\> docker inspect --format="{{range .NetworkSettings.Networks}}{{.IPAddress}} {{end}}" ac58646e9013
         172.22.99.92
         PS C:\>
         ```

### Sitecore logs

Sitecore logs can be found in the follwing location:
   "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\SimpleSample\\**storage\Data**“

### Sitecore site files

The sitecore site files, in the Container, are directly accessible from the following folder in the development machine:
   "C:\Docker\Sitecore\docker-demo\sitecore\9.0.1 rev. 171219 XM1\VS2017\SimpleSample\\**storage\Website**“

Any change made in the above folder will be automatically detected by Sitecore in the container.

## Release Configuration

If the solution is switched to the "Release" configuration re-run, the container is re-created with the Website folder embedded inside along with the project output. This simplifies deployments to other environments (QA, UAT and Production).

## Known issues

1. Visual Studio fails when trying to attach just after starting debugging session. VS can attach to the running process in container afterwards, though. See section "Attaching VS2017 to Sitecore" for a workaround


