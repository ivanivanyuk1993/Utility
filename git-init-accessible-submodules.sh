git submodule update --init --jobs "$(grep -c ^processor /proc/cpuinfo)" --recursive --remote -- "RestrictedGitSubmoduleCliUtil" \
&& \
dotnet run \
    --project RestrictedGitSubmoduleCliUtil/GitSubmoduleInitAccessibleCli/GitSubmoduleInitAccessibleCli.csproj \
    --configuration Release \
    -- \
    --git-root-directory-path "."