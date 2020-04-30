# escape=`

ARG BASE_IMAGE
ARG TOOLING_IMAGE
ARG SOLUTION_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${TOOLING_IMAGE} as tooling
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\inetpub\wwwroot

# Copy built website files
COPY --from=solution /artifacts/files/ ./

# Copy tools
COPY --from=tooling /tools/ /tools/

# Find transform files and do transformation
RUN $xdts = Get-ChildItem -Path '.\\*.xdt' -Recurse; `
    $xdts | ForEach-Object { & 'C:\\tools\\scripts\\Invoke-XdtTransform.ps1' -Path $_.FullName.Replace('.xdt', '') -XdtPath $_.FullName; }; `
    $xdts | ForEach-Object { Remove-Item -Path $_.FullName; };