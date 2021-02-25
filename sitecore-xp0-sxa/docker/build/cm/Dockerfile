# escape=`

ARG BASE_IMAGE
ARG SXA_IMAGE
ARG SPE_IMAGE
ARG TOOLING_IMAGE

FROM ${TOOLING_IMAGE} as tooling
FROM ${SPE_IMAGE} as spe
FROM ${SXA_IMAGE} as sxa
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy development tools and entrypoint
COPY --from=tooling \tools\ \tools\

WORKDIR C:\inetpub\wwwroot

# Add SPE module
COPY --from=spe \module\cm\content .\
RUN Rename-Item -Path "c:\inetpub\wwwroot\App_Config\Include\Spe\Spe.IdentityServer.config.disabled" -NewName "Spe.IdentityServer.config"

# Add SXA module
COPY --from=sxa \module\cm\content .\
COPY --from=sxa \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Disable Identity Server
# RUN Copy-Item -Path 'C:\\inetpub\\wwwroot\\App_Config\\Include\\Examples\\Sitecore.Owin.Authentication.IdentityServer.Disabler.config.example' `
#               -Destination 'C:\\inetpub\\wwwroot\\App_Config\\Include\\Sitecore.Owin.Authentication.IdentityServer.Disabler.config';
