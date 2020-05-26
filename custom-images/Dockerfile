# escape=`

ARG BASE_IMAGE
ARG BUILD_IMAGE

FROM ${BUILD_IMAGE} AS prep

# Gather only artifacts necessary for NuGet restore, retaining directory structure
COPY *.sln nuget.config /nuget/
COPY src/ /temp/
RUN Invoke-Expression 'robocopy C:/temp C:/nuget/src /s /ndl /njh /njs *.csproj *.scproj packages.config'

FROM ${BUILD_IMAGE} AS builder

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# Create an empty working directory
WORKDIR /build

# Copy prepped NuGet artifacts, and restore as distinct layer to take better advantage of caching
COPY --from=prep ./nuget ./
RUN nuget restore

# Copy remaining source code
COPY src/ ./src/

# Copy transforms, retaining directory structure
RUN Invoke-Expression 'robocopy C:/build/src C:/out/transforms /s /ndl /njh /njs *.xdt'

# Build solution with file publish
RUN msbuild /p:Configuration=Release /p:DeployOnBuild=True /p:DeployDefaultTarget=WebPublish /p:WebPublishMethod=FileSystem /p:PublishUrl=C:\out\files

# Build XConnect ModelBuilder, then use it to generate XConnect model JSON files
RUN msbuild ./src/Build.XConnect.ModelBuilder/Build.XConnect.ModelBuilder.csproj /p:Configuration=Release /p:OutDir=C:\build
RUN .\Build.XConnect.ModelBuilder C:\out\xconnect\models

# Collect XConnect model assemblies
RUN New-Item 'C:\out\xconnect\bin' -Type 'Directory' | Out-Null; `
    Copy-Item 'C:\out\files\bin\DockerDemo.XConnect.dll' -Destination 'C:\out\xconnect\bin'

FROM ${BASE_IMAGE}

WORKDIR /artifacts

# Copy final build artifacts
COPY --from=builder C:\out\files ./files/
COPY --from=builder C:\out\transforms ./transforms/
COPY --from=builder C:\out\xconnect ./xconnect/