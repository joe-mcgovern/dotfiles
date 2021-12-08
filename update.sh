#!/bin/bash

echo "Copying files"
cp ~/.zshrc .
cp ~/.vimrc .
cp ~/.bashrc .
cp ~/.gitconfig .
cp ~/.tmux.conf .
cp ~/.starship.toml .
cp ~/Library/Application\ Support/lazygit/config.yml lazygit_config.yaml
sed -i "" 's/name = .*/name = First Last/' .gitconfig
sed -i "" 's/email = .*/email = youremail@email.com/' .gitconfig
export SAFE_HOME=$(echo $HOME | sed 's/\//\\\//g')
find ~/.vim/pack -name '.git' | sed "s/${SAFE_HOME}\//~\//" >> vim_plugins.txt
find ~/.vim/pack -name '.git' >> vim_plugins.txt
mkdir -p my_vim_plugins
cp -R ~/.vim/plugin my_vim_plugins
echo "Files copied"
echo "Pushing to git..."
git add . > /dev/null
git cim 'Syncing files' > /dev/null
git push origin master
echo "Updated!"
