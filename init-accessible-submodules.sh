git submodule update --init --jobs "$(grep -c ^processor /proc/cpuinfo)" --recursive --remote -- \
  "CliExitCodeProvider" \
  "CopyDirectoryAsyncProvider" \
  "ExecuteCliCommandAsyncProvider" \
  "GetGitRepositoryUrlAsyncProvider" \
  "GetJsonDateProvider" \
  "NormalizeLineBreaksProvider" \
  "RestrictedGitSubmoduleCliUtil" \
  "RunCliTaskProvider" \
  "ValueOrError" \
&& \
dotnet run \
    --configuration Release \
    --project RestrictedGitSubmoduleCliUtil/GitSubmoduleInitAccessibleCli/GitSubmoduleInitAccessibleCli.csproj \
    -- \
    --git-root-directory-path "." \
&& \
bash git-checkout-with-submodules.sh \
&& \
dotnet run \
    --configuration Release \
    --project RestrictedGitSubmoduleCliUtil/MakeSolutionWithAccessibleCsprojectsCli/MakeSolutionWithAccessibleCsprojectsCli.csproj \
    -- \
    --solution-file-path "./Utility/dotnet/Utility.sln"