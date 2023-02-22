
GITUSER=${USER:-dummy}

git config --global user.name "${GITUSER}"
git config --global user.email "${GITUSER}@container"

git config --global core.editor vim
git config --global log.date iso
git config --global init.defaultBranch master

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.up rebase
git config --global alias.ci commit
git config --global alias.lol 'log --graph --decorate --pretty=oneline --abbrev-commit --all'
git config --global alias.rr 'remote -v'
git config --global alias.ac '!git add -A && git commit'
git config --global alias.puff 'pull --ff-only'
