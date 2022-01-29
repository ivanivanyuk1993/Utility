git submodule update --init --jobs "$(grep -c ^processor /proc/cpuinfo)" --recursive --remote -- "RestrictedGitSubmoduleCliUtil" \
&& \
dotnet run \
    --project RestrictedGitSubmoduleCliUtil/GitSubmoduleInitAccessibleCli/GitSubmoduleInitAccessibleCli.csproj \
    --configuration Release \
    -- \
    --git-root-directory-path "." \
&& \
bash git-checkout-with-submodules.sh \
&& \
dotnet run \
    --project RestrictedGitSubmoduleCliUtil/MakeSolutionWithAccessibleCsprojectsCli/MakeSolutionWithAccessibleCsprojectsCli.csproj \
    --configuration Release \
    -- \
    --solution-file-path "./UtilDotnet.sln"