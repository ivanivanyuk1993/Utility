COMMAND="git clean -dfx -e \"**/.idea\""
# Running command in parent repository
eval "$COMMAND"
# Running command in submodules
bash git-submodule-foreach-parallel.sh "$COMMAND"