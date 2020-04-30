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

# Include TDS Item packages (2 options)

# OPTION 1: Allow TDS to install on startup, knowing this will be done on EVERY container create
COPY --from=solution /artifacts/packages/ /temp/
RUN Get-ChildItem -Path 'C:\\temp\\*.wdp.zip' | % { Expand-Archive -Path $_.FullName -DestinationPath 'C:\\temp' -Force; }; `
    Move-Item -Path 'C:\\temp\\Content\\Website\\Bin\*' -Destination .\bin -Force; `
    Move-Item -Path 'C:\\temp\\Content\\Website\\temp\*' -Destination .\temp -Force; `
    Remove-Item -Path 'C:\\temp' -Recurse -Force; `
    # Ensure TDS has permissions to delete items after install
    cmd /C icacls .\temp\WebDeployItems /grant 'IIS AppPool\DefaultAppPool:(OI)(CI)M';

# OPTION 2: Invoke Deploy-TdsWdpPackages.ps1 on the container as-needed (similar to Unicorn sync) with the following script:
#   docker exec <cm container> powershell -command "C:\install\Deploy-TdsWdpPackages.ps1"
# COPY --from=tooling /tools/scripts/Deploy-TdsWdpPackages.ps1 /install/Deploy-TdsWdpPackages.ps1
# COPY --from=solution /artifacts/packages/ /install/packages/