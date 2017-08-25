#!/bin/bash

cp ~/.zshrc .
cp ~/.vimrc .
cp ~/.bashrc .
git add .
git cim 'Syncing files'
git push origin master
