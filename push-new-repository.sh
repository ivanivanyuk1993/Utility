# Writing first argument to named variable to increase readability
REPOSITORY_NAME=$1

git remote add origin "git@github.com:ivanivanyuk1993/UtilDotnet.${REPOSITORY_NAME}.git"
git branch -M main
git push -u origin main