set -- "${@/#/--csproj-file-path-list }"

dotnet run \
    --project GetGitRepositoryUrlListToWorkWithCsprojectListAsyncProvider/ShowGitRepositoryUrlListToWorkWithCsprojectListCli/ShowGitRepositoryUrlListToWorkWithCsprojectListCli.csproj \
    --configuration Release \
    -- \
    $@