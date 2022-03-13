AUTHOR_NAME="Ivan Ivanyuk"
REPOSITORY_NAME="${1}"
TYPESCRIPT_PACKAGE_NAME="${2}"

TARGET_DIRECTORY_PATH="./${REPOSITORY_NAME}/TypeScript"

dotnet run \
    --configuration Release \
    --project CreateTypeScriptProjectProvider/CreateTypeScriptProjectCli/CreateTypeScriptProjectCli.csproj \
    -- \
    --author-name "${AUTHOR_NAME}" \
    --package-name "${TYPESCRIPT_PACKAGE_NAME}" \
    --target-directory-path "${TARGET_DIRECTORY_PATH}"