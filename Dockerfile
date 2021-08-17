FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS publish-artifact
WORKDIR /app

# Copy csproj and restore
COPY ./devops-demo/*.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Generate runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
EXPOSE 80
COPY --from=publish-artifact /app/out .
ENTRYPOINT ["dotnet", "devops-demo.dll"]