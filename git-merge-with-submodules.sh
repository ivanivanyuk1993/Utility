BRANCH_NAME="${1:-main}"

COMMAND="git merge \"${BRANCH_NAME}\""
# Running command in parent repository
eval "$COMMAND"
# Running command in submodules
bash git-submodule-foreach-parallel.sh "$COMMAND"