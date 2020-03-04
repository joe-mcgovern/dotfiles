#!/bin/bash

echo "Copying files"
cp ~/.zshrc .
cp ~/.vimrc .
cp ~/.bashrc .
cp ~/.gitconfig .
sed -i "" 's/name = .*/name = First Last/' .gitconfig
sed -i "" 's/email = .*/email = youremail@email.com/' .gitconfig
cp ~/local_scripts/.git_update.sh .
cp ~/local_scripts/.sync_master.py .
cp ~/local_scripts/.open_pull.py .
cp ~/.tmux.conf .
ls ~/.vim/bundle > vim_plugins.txt
ls ~/.tmux/plugins/ > tmux_plugins.txt
echo "Files copied"
echo "Pushing to git..."
git add . > /dev/null
git cim 'Syncing files' > /dev/null
git push origin master
echo "Updated!"
