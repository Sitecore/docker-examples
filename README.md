# Konabos Docker Examples

This repository contains exmaple compose files and associated configuration that we use internally at [Konbabos Consulting](https://www.konabos.com). It is loosely based off the orignal [Docker Examples repo](https://github.com/Sitecore/docker-examples) - be sure to look through that repo and read the documentation provided there.

The examples contained in this repo were designed to allow us to quickly get up and running on a project or just for personal hacking and intended for local development purposes.

Some features:
- Folder based license mount. Simply copy your `license.xml` file to the license folder
- Removed build of layers which were not changed from default images
- Generation of SSL certs for Traefik if they do not exist
- `start.ps1` and `stop.ps1` scripts to bring environments up/down, which allows tabbed completion in a Powershell terminal and to run other commands
- Allow user specific override of environment variables
- Modified `clean.ps1` allowing you to remove files without deleting databases
- Removed the need to modify the `hosts` file by using domain which provides a local loopback

Each topology is designed to work in isolation. To start using a topology on a project, we can simply copy the entire folder without having to worry about files in multiple folders.

## Getting Started

1. Copy your `license.xml` file to the `./docker/license` folder of topologyu of your choice
2. Run `start.ps1`
3. First time you may be prompted a root certication authority (CA) cetificate. This is required by mkcert to allow local SSL certs to be used without warnings and errors. Click yes to install the certificate.

## Custom Settings

We default a bunch of settings and environment variables. For hacking purposes you probably don't care what these are locally. You can regenerate them all:

```
./docker/tools/init.ps1 -HostName myhost
```

| Parameter             | Alias | Default       | 
| ---------             | ----- | -------       | 
| HostName              | h     | -             | 
| HostSuffix            | s     | localho.st    | 
| SitecoreAdminPassword | a     | b             | 
| SqlSaPassword         | sa    | Password12345 | 

We default the host suffix to localho.st, which provides a local loopback to 127.0.0.1 and means that no modifications are required to your hosts files, either manually or using additional containers. 

Modification of the `hosts` files can also be in issue in certain organisations which prevent due to group policy or mandatory use of certain virus scanners such as Symantec Endpoint Security which prevent modificaiton for security reasons.

## Local deployment

The set up is for simplicity. Deploy your files to `./docker/data/cm/website` folder.

This is verysimilar to how the Sitecore 9.3 Community Repository was configured. We do not have volume mounts for XConnect, feel free to add them if you them.

## Removing local files

The `clean.ps1` is a modified version from the original repo and uses [git clean](https://git-scm.com/docs/git-clean) to remove files from the data folder.

By default, mdf/ldf database files are not removed. You can force deletion by passing the `-IncludeDatabases` flag (Alias `-i`).

## User Specific Override of Environment Variables

You can override the variables from `.env` on a per user basis. Copy`.env.user.example` to `.env.user` and modify the values as required.

## Sitecore Container Registry

The Sitecore 10 examples use the official [Sitecore Container Registry](https://doc.sitecore.com/developers/100/developer-tools/en/sitecore-image-reference.html).

The Sitecore 9.3 example requires you to [build your own images](https://github.com/Sitecore/docker-images/blob/master/build/INSTRUCTIONS.md). The default `Registry` setting in the `.env` files is pointing to an internal Konabos container registry. This will not work for you. Update the value as required after you have build the Sitecore 9.3 images.
