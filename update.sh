#!/bin/bash

echo "Copying files"
cp ~/.zshrc .
cp ~/.vimrc .
cp ~/.bashrc .
cp ~/.gitconfig .
sed -i "" 's/name = .*/name = First Last/' .gitconfig
sed -i "" 's/email = .*/email = youremail@email.com/' .gitconfig
cp ~/.git_update.sh .
cp ~/.sync_master.py .
cp ~/.open_pull.py .
cp ~/.tmux.conf .
echo "Files copied"
echo "Pushing to git..."
git add . > /dev/null
git cim 'Syncing files' > /dev/null
git push origin master
echo "Updated!"
