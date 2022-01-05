# Writing first argument to named variable to increase readability
REPOSITORY_NAME=$1

git submodule add \
  "../UtilDotnet.${REPOSITORY_NAME}.git" \
  "${REPOSITORY_NAME}" \
&& \
dotnet sln UtilDotnet.sln add \
  "${REPOSITORY_NAME}/${REPOSITORY_NAME}NS/${REPOSITORY_NAME}NS.csproj" \
  --solution-folder "${REPOSITORY_NAME}"
