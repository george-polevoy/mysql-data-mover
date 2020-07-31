FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as builder
COPY src ./src
COPY mysql-data-mover.sln .
ENV SOLUTION_NAME "./mysql-data-mover.sln"
RUN dotnet restore ${SOLUTION_NAME}
RUN dotnet build --no-restore --configuration Release ${SOLUTION_NAME}
RUN dotnet test --no-restore --configuration Release ${SOLUTION_NAME}
RUN dotnet publish --no-restore --no-build --configuration Release --output ./output ${SOLUTION_NAME}

FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY --from=builder ./output/ .
CMD [ "/app/Dodo.DataMover" ]