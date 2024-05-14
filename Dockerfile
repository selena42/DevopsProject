# Base image, from microsoft that contains the dotnet sdk to build the project
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env
WORKDIR /App
 
# Copy everything
COPY . ./
# Restore as distinct layers
RUN dotnet restore
# Build and publish a release
RUN dotnet publish -c Release -o out
 
# Build runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /App
# HTTP and HTTPS ports should be exposed so that the web application can be accessed from outside the container
EXPOSE 8080
EXPOSE 8081
COPY --from=build-env /App/out .
# Entry point of the runtime image
ENTRYPOINT ["dotnet", "DotNet.Docker.dll"]