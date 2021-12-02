# escape=`

ARG BASE_IMAGE
ARG SPE_IMAGE

FROM ${SPE_IMAGE} as spe
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Add SPE module
COPY --from=spe C:\module\db C:\resources\spe
