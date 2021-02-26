# escape=`

ARG BASE_IMAGE
ARG SPE_IMAGE
ARG SXA_IMAGE
ARG HEADLESS_IMAGE

FROM ${SPE_IMAGE} as spe
FROM ${SXA_IMAGE} as sxa
FROM ${HEADLESS_IMAGE} as headless
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add SPE module
COPY --from=spe \module\db \spe_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\spe_data; `
    Remove-Item -Path C:\spe_data -Recurse -Force;

# Add SXA module
COPY --from=sxa \module\db \sxa_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\sxa_data; `
    Remove-Item -Path C:\sxa_data -Recurse -Force;

# Add Headless Services module
COPY --from=headless \module\db \headless_data
RUN C:\DeployDatabases.ps1 -ResourcesDirectory C:\headless_data; `
    Remove-Item -Path C:\headless_data -Recurse -Force;

