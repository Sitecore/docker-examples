# escape=`

FROM VSWebsiteRegistry.azurecr.io/sitecore:9.0.171219-xm1-cm
ARG source

ENV DEFAULTWEBSITENAME='__DefaultWebsite'
ENV DEFAULTWEBSITEPATH=${SITEPATH}\..\${DEFAULTWEBSITENAME}

RUN Rename-Item -Path $env:SITEPATH -NewName $env:DEFAULTWEBSITENAME; `
    New-Item -Path $env:SITEPATH -ItemType Directory | Out-Null; 

VOLUME ${SITEPATH}

COPY DebugBoot.ps1 .
COPY ${source:-obj/Docker/empty} ${SITEPATH}

WORKDIR ${SITEPATH}
