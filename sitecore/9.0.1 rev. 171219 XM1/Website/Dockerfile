# escape=`

FROM VSWebsiteRegistry.azurecr.io/sitecore:9.0.171219-xm1-cm
ARG source
WORKDIR ${SITEPATH}
COPY ${source:-obj/Docker/empty} .
