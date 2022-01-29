BRANCH_NAME="${1:-main}"

COMMAND="git fetch && (git checkout \"${BRANCH_NAME}\" || git checkout -b \"${BRANCH_NAME}\")"
# Running command in parent repository
eval "$COMMAND"
# Running command in submodules
bash git-submodule-foreach-parallel.sh "$COMMAND"