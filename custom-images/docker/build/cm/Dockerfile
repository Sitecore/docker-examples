# escape=`

ARG BASE_IMAGE
ARG SXA_IMAGE
ARG SPE_IMAGE
ARG TOOLING_IMAGE
ARG SOLUTION_IMAGE
ARG HORIZON_RESOURCES_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLING_IMAGE} as tooling
FROM ${SPE_IMAGE} as spe
FROM ${SXA_IMAGE} as sxa
FROM ${HORIZON_RESOURCES_IMAGE} as horizon_resources
FROM ${BASE_IMAGE}


SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Copy development tools and entrypoint
COPY --from=tooling \tools\ \tools\

WORKDIR C:\inetpub\wwwroot

# Add SPE module
COPY --from=spe \module\cm\content .\

# Add SXA module
COPY --from=sxa \module\cm\content .\
COPY --from=sxa \module\tools \module\tools
RUN C:\module\tools\Initialize-Content.ps1 -TargetPath .\; `
    Remove-Item -Path C:\module -Recurse -Force;

# Add horizon module
COPY --from=horizon_resources \module\cm\content \inetpub\wwwroot

# Copy solution website files
COPY --from=solution \artifacts\website\ .\

# Copy solution transforms
COPY --from=solution \artifacts\transforms\ \transforms\solution\

# Copy role transforms
COPY .\transforms\ \transforms\role\

# Perform solution transforms
RUN C:\tools\scripts\Invoke-XdtTransform.ps1 -Path .\ -XdtPath C:\transforms\solution\DockerExamples.Website

# Perform role transforms
RUN C:\tools\scripts\Invoke-XdtTransform.ps1 -Path .\ -XdtPath C:\transforms\role