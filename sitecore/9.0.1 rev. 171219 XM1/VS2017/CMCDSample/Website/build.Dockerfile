# escape=`

ARG BASE_IMAGE
FROM ${BASE_IMAGE}
ARG source

COPY ${source:-obj/Docker/publish} ${SITEPATH}

WORKDIR ${SITEPATH}
