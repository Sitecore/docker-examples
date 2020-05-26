# escape=`

ARG BASE_IMAGE
ARG SOLUTION_IMAGE

FROM ${SOLUTION_IMAGE} as solution
FROM ${BASE_IMAGE}

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

WORKDIR C:\inetpub\wwwroot

# Copy XConnect model assemblies
COPY --from=solution /artifacts/xconnect/bin/ ./bin/
COPY --from=solution /artifacts/xconnect/bin/ ./App_Data/jobs/continuous/AutomationEngine/

# Copy XConnect model JSON files
COPY --from=solution /artifacts/xconnect/models/ ./App_Data/Models/
COPY --from=solution /artifacts/xconnect/models/ ./App_Data/jobs/continuous/IndexWorker/App_Data/Models/
COPY --from=solution /artifacts/xconnect/models/ ./App_Data/jobs/continuous/ProcessingEngine/App_Data/Models/

# Copy XConnect model config for Automation Engine
COPY configs/sc.DockerDemo.CustomModel.xml ./App_Data/jobs/continuous/AutomationEngine/App_Data/Config/sitecore/