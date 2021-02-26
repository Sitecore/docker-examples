# escape=`

ARG BASE_IMAGE
ARG HEADLESS_IMAGE
ARG SPE_IMAGE
ARG TOOLING_IMAGE

FROM ${TOOLING_IMAGE} as tooling
FROM ${SPE_IMAGE} as spe
FROM ${HEADLESS_IMAGE} as headless
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Install NodeJS
WORKDIR C:\build
ARG NODEJS_VERSION
RUN Invoke-WebRequest -OutFile nodejs.zip -UseBasicParsing "https://nodejs.org/dist/v$env:NODEJS_VERSION/node-v$env:NODEJS_VERSION-win-x64.zip"; `
    Expand-Archive nodejs.zip -DestinationPath C:\; `
    Rename-Item "c:\\node-v$env:NODEJS_VERSION-win-x64" c:\nodejs; `
    setx /M PATH $($Env:PATH + ';C:\nodejs'); `
    Remove-Item -Path nodejs.zip -Force;

# Copy development tools and entrypoint
COPY --from=tooling \tools\ \tools\

WORKDIR C:\inetpub\wwwroot

# Add SPE module
COPY --from=spe \module\cm\content .\
RUN Rename-Item -Path "c:\inetpub\wwwroot\App_Config\Include\Spe\Spe.IdentityServer.config.disabled" -NewName "Spe.IdentityServer.config"

# Add Headless Services module
COPY --from=headless \module\cm\content .\
COPY --from=headless \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Allow configurable JSS Import User
COPY .\config .\App_Config\Include\

# Disable Identity Server
# RUN Copy-Item -Path 'C:\\inetpub\\wwwroot\\App_Config\\Include\\Examples\\Sitecore.Owin.Authentication.IdentityServer.Disabler.config.example' `
#               -Destination 'C:\\inetpub\\wwwroot\\App_Config\\Include\\Sitecore.Owin.Authentication.IdentityServer.Disabler.config';
