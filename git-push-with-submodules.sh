REMOTE="${1:-origin}"

COMMAND="git fetch && git push --set-upstream ${REMOTE} HEAD"
# Running command in parent repository
eval "$COMMAND"
# Running command in submodules
bash git-submodule-foreach-parallel.sh "$COMMAND"