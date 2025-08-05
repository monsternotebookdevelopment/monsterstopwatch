set -e

npm run build

cd dist

git init
git checkout -B main
git add -A
git commit -m 'deploy'
git push -f https://github.com/monsternotebookdevelopment/monsterstopwatch.git main:gh-pages

cd -