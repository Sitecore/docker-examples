# escape=`

ARG BASE_IMAGE
ARG JSS_IMAGE
ARG SPE_IMAGE

FROM ${SPE_IMAGE} as spe
FROM ${JSS_IMAGE} as jss
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add SPE module
COPY --from=spe \module\db \spe_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\spe_data; `
    Remove-Item -Path C:\spe_data -Recurse -Force;

# Add JSS module
COPY --from=jss \module\db \jss_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\jss_data; `
    Remove-Item -Path C:\jss_data -Recurse -Force;

# Run custom SQL scripts
COPY .\scripts\ \scripts\
RUN Invoke-Sqlcmd -InputFile (Join-Path \scripts\ "UpdateItemPermissions.sql");
