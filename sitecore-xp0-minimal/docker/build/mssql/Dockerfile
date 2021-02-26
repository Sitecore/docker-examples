# escape=`

ARG BASE_IMAGE
ARG SPE_IMAGE

FROM ${SPE_IMAGE} as spe
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add SPE module
COPY --from=spe \module\db \spe_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\spe_data; `
    Remove-Item -Path C:\spe_data -Recurse -Force;
