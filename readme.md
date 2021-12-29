# UtilDotnet
Project uses submodules to atomically control access to parts of library `UtilDotnet`, like giving public access to projects we can benefit from sharing(like API interfaces(to talk in same language), or code which won't give too much competitive advantage when hidden, but can give benefit if community finds bugs in it, etc.), and giving access to developers on need to know basis(to not have situation when all developers have access to everything and we can not hire juniors(from any country, even with cheapest salaries and worst reputation) or new developers without fear)

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