FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS base
ENV ASPNETCORE_URLS=http://+:80
WORKDIR /app

# Ensure we listen on any IP Address 
ENV DOTNET_URLS=http://+:5000

FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src
COPY ["DolarApi.csproj", "."]
RUN dotnet restore "./DolarApi.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "DolarApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "DolarApi.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DolarApi.dll"]