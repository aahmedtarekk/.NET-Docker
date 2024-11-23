# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# Copy the CSPROJ file and restore dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application files
COPY . ./

# Build the application
RUN dotnet publish -c Release -o /app/out

# Use the official .NET Runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:7.0
WORKDIR /app

# Copy the built files from the build stage
COPY --from=build /app/out .

# Expose the ports used by the application
# HTTP (development)
EXPOSE 5092   
# HTTPS (optional)
EXPOSE 443    

# Run the application
ENTRYPOINT ["dotnet", "MyAspNetApp.dll"]
