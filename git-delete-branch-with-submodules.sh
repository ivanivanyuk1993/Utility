BRANCH_NAME="${1}"
REMOTE="${2:-origin}"

COMMAND="git fetch && (git push -d ${REMOTE} ${BRANCH_NAME}; git branch -d ${BRANCH_NAME})"
# Running command in parent repository
eval "$COMMAND"
# Running command in submodules
bash git-submodule-foreach-parallel.sh "$COMMAND"