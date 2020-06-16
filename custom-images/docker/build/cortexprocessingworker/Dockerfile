# escape=`

ARG BASE_IMAGE
ARG SOLUTION_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\service

# Copy solution XConnect model assemblies
COPY --from=solution \artifacts\xconnect\bin\ .\

# Copy solution XConnect model JSON
COPY --from=solution \artifacts\xconnect\App_Data\Models\ .\App_Data\Models\