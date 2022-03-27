dotnet run \
    --project AddVcsRootMappingsToIdeAsyncProvider/AddVcsRootMappingsToIdeCli/AddVcsRootMappingsToIdeCli.csproj \
    --configuration Release \
    -- \
    --git-root-directory-path "." \
    --ide-project-root-directory-path "."

dotnet run \
    --project AddVcsRootMappingsToIdeAsyncProvider/AddVcsRootMappingsToIdeCli/AddVcsRootMappingsToIdeCli.csproj \
    --configuration Release \
    -- \
    --git-root-directory-path "." \
    --ide-project-root-directory-path "./Utility/dotnet"