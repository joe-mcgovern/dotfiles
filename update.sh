#!/bin/bash

echo "Copying files"
cp ~/.zshrc .
cp ~/.vimrc .
cp ~/.bashrc .
cp ~/.gitconfig .
cp ~/.tmux.conf .
cp ~/.config/starship.toml .
sed -i "" 's/name = .*/name = First Last/' .gitconfig
sed -i "" 's/email = .*/email = youremail@email.com/' .gitconfig
ls ~/.vim/bundle > vim_plugins.txt
ls ~/.tmux/plugins/ > tmux_plugins.txt
echo "Files copied"
echo "Pushing to git..."
git add . > /dev/null
git cim 'Syncing files' > /dev/null
git push origin master
echo "Updated!"
