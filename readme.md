# UtilDotnet
## How to
### Git flow with submodules
- Initialize/checkout feature branch
```
BRANCH_NAME=feature/some-feature-name
bash git-checkout-with-submodules.sh "${BRANCH_NAME}"
```
- Do commits in your IDE(like Rider from JetBrains or VisualStudio from Microsoft)
  - Notice that you may want to configure VCS root mappings in your IDE, similar to how it is done for JetBrains IDE-s in `add-vcs-root-mappings-to-ide.sh` of this repository to see changes in child repositories
- Push feature branch
```
bash git-push-with-submodules.sh
```
- Merge branch `main` into current branch
```
BRANCH_NAME=main
bash git-merge-with-submodules.sh "${BRANCH_NAME}"
```
- Create PR in your git provider(like github), code review will look like on screenshot
  ![Code review with submodules](code-review-with-submodules.png?raw=true "Code review with submodules")
  (Please upvote this discussion which proposes to support atomic merges in PR-s in github https://github.com/github/feedback/discussions/10968)
- After PR is merged into main branch and feature branch is no longer needed, delete branch with
```
BRANCH_NAME=feature/some-feature-name
bash git-delete-branch-with-submodules.sh "${BRANCH_NAME}"
```
### Show list of git repositories, needed to work on `csproj` list
Run command like
```
bash show-git-repository-list-to-work-with-csproject-list.sh \
    GetGitRepositoryUrlListToWorkWithCsprojectListAsyncProvider/ShowGitRepositoryUrlListToWorkWithCsprojectListCli/ShowGitRepositoryUrlListToWorkWithCsprojectListCli.csproj \
    FairAsyncReadWriteLock/FairAsyncReadWriteLockTestNS/FairAsyncReadWriteLockTestNS.csproj
```
### Make commits
- Commit convention was not chosen, so you can follow any convention you like, but do not forget to add information on which changes were made, where and why, like
```
Fixed bug in logic ... in method `{method_name}` in class `class_name` ... to prevent errors like ...
```
### Register submodules in VCS mappings of JetBrains IDE
- Open solution in IDE at least once - to generate directory `.idea`
- Run `add-vcs-root-mappings-to-ide.sh`
### Start working with repository
- Clone repository with git
- Open console(which supports bash) in repository root
- Run command
```
bash init-accessible-submodules.sh
```
- Open generated `UtilDotnet.only-accessible.generated.sln` in IDE

## Architecture decision explanations
### Why heavy use of submodules
Project uses submodules to atomically control access to parts of library `UtilDotnet`, like giving public access to projects we can benefit from sharing(like API interfaces(to talk in same language), or code which won't give too much competitive advantage when hidden, but can give benefit if community finds bugs in it, etc.), and giving access to developers on need to know basis(to not have situation when all developers have access to everything and we can not hire juniors(from any country, even with cheapest salaries and worst reputation) or new developers without fear)

Ideally, we want to give developers access only to those modules, which they need for current task(or code review), and revoke access as soon as task is completed(notice that it works also in favor of honest developers, because they won't need to think about security too much, and we may have not hired them at all if we didn't have increased security, especially if they are from countries with bad reputation)

Notice that project assumes flat structure and expects that all projects are modified as part of solution `UtilNet.sln`, but if you need more complex structure, you can start using(on first need) following approach
- Add properties with path to correct solution to your csproj(and optionally, default value, which points to locally included submodule)
```
<PropertyGroup>
    <KubernetesConfigurationInstanceProviderRootPath Condition="'$(KubernetesConfigurationInstanceProviderRootPath)' == ''">../KubernetesConfigurationInstanceProvider.local</KubernetesConfigurationInstanceProviderRootPath>
    <KubernetesConfigurationInstanceProviderSlnPath>$(KubernetesConfigurationInstanceProviderRootPath)/KubernetesConfigurationInstanceProvider.sln</KubernetesConfigurationInstanceProviderSlnPath>

    <UtilDotnetRootPath Condition="'$(UtilDotnetRootPath)' == ''">../UtilDotnet</UtilDotnetRootPath>
    <UtilDotnetSlnPath>$(UtilDotnetRootPath)/UtilDotnet.sln</UtilDotnetSlnPath>
</PropertyGroup>
```
- Add build of dynamically included solutions to your csproj
```
<Target Name="BuildExternalDependencies" BeforeTargets="PreBuildEvent">
    <MSBuild Projects="$(KubernetesConfigurationInstanceProviderSlnPath)" Targets="Restore;Build"/>
    <MSBuild Projects="$(UtilDotnetSlnPath)" Targets="Restore;Build"/>
</Target>
```
- Add project references to your csproj like
```
<ItemGroup>
    <ProjectReference Include="$(KubernetesConfigurationInstanceProviderRootPath)/KubernetesConfigurationInstanceProviderNS/KubernetesConfigurationInstanceProviderNS.csproj"/>
    <ProjectReference Include="$(UtilDotnetRootPath)/ConvertObjectToFlatDictionaryProvider/ConvertObjectToFlatDictionaryProviderNS/ConvertObjectToFlatDictionaryProviderNS.csproj"/>
    <ProjectReference Include="$(UtilDotnetRootPath)/GetCallerFilePathProvider/GetCallerFilePathProviderNS/GetCallerFilePathProviderNS.csproj"/>
    <ProjectReference Include="$(UtilDotnetRootPath)/MakeConfigurationFilesFromTemplatesProvider/MakeConfigurationFilesFromTemplatesProviderNS/MakeConfigurationFilesFromTemplatesProviderNS.csproj"/>
    <ProjectReference Include="$(UtilDotnetRootPath)/RunCLITaskProvider/RunCLITaskProviderNS/RunCLITaskProviderNS.csproj"/>
</ItemGroup>
```
- Build like
```
ENVIRONMENT_NAME="local"

KubernetesConfigurationInstanceProviderRootPath="$(pwd)/ConfigurationInstanceProvider/KubernetesConfigurationInstanceProvider.${ENVIRONMENT_NAME}"

dotnet build \
    ./Deploy/Deploy.sln \
    --configuration Release \
    /p:KubernetesConfigurationInstanceProviderRootPath="${KubernetesConfigurationInstanceProviderRootPath}"
```
### Why security is needed for employer
Because you want to hire developers from least expensive to live areas. You usually can't do it, because it usually means you usually give new developers too much access to your system, and you don't trust new developers(because it is correct and logical not to trust new developers or people). With atomic access(like with using submodules) you can hire developers from cheapest areas to live(such areas usually have worst reputation, but it is not a problem anymore)
### Why security is needed for developer
For me it is needed, because I live not in most expensive area to live and will benefit from being hire-able by employers from such areas