# UtilDotnet
## How to
### Start working with repository
- Clone repository with git
- Open console(which supports bash) in repository root
- Run command
```
bash init-accessible-submodules.sh
```
- Open generated `UtilDotnet.only-accessible.generated.sln` in IDE
### Make commits
- Commit convention was not chosen, so you can follow any convention you like, but do not forget to add information on which changes were made, where and why, like
```
Fixed bug in logic ... in file ... to prevent errors like ...
```

## Architecture decision explanations
### Why heavy use of submodules
Project uses submodules to atomically control access to parts of library `UtilDotnet`, like giving public access to projects we can benefit from sharing(like API interfaces(to talk in same language), or code which won't give too much competitive advantage when hidden, but can give benefit if community finds bugs in it, etc.), and giving access to developers on need to know basis(to not have situation when all developers have access to everything and we can not hire juniors(from any country, even with cheapest salaries and worst reputation) or new developers without fear)

Ideally, we want to give developers access only to those modules, which they need for current task(or code review), and revoke access as soon as task is completed(notice that it work also in favor of honest developers, because they won't need to think about security too much, and we may have not hired them at all if we didn't have increased security, especially if they are from countries with bad reputation)

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