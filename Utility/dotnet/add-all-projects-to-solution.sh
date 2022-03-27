dotnet run \
    --configuration Release \
    --project ../../AddProjectsToSolutionAsyncProvider/AddProjectsToSolutionCli/AddProjectsToSolutionCli.csproj \
    -- \
    --directory-path-with-projects "." \
    --solution-file-path "../../RestrictedGitSubmoduleCliUtil/RestrictedGitSubmoduleCliUtil.sln" \
    --solution-folder-path-prefix "Utility"

dotnet run \
    --configuration Release \
    --project ../../AddProjectsToSolutionAsyncProvider/AddProjectsToSolutionCli/AddProjectsToSolutionCli.csproj \
    -- \
    --directory-path-with-projects "." \
    --solution-file-path "./Utility.sln"