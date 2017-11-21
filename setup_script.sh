#!/bin/bash

which -s brew
if [[ $? != 0 ]] ; then
    echo "Installing homebrew..."
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
else
    echo "Updating homebrew..."
    brew update
fi
printf "\xE2\x9C\x94 homebrew\n"

which -s git
if [[ $? != 0 ]] ; then
    echo "Installing git..."
fi

printf "\xE2\x9C\x94 git\n"

which -s zsh
if [[ $? != 0 ]] ; then
    echo "Installing zsh..."
    brew install zsh zsh-completions
fi

printf "\xE2\x9C\x94 git\n"


which -s vim
if [[ $? != 0 ]] ; then
    echo "Installing vim..."
    brew install vim && brew install macvim
    brew link macvim
fi

printf "\xE2\x9C\x94 vim\n"

mkdir -p ~/.vim

which -s nvim
if [[ $? != 0 ]] ; then
    echo "Installing nvim..."
    brew install neovim/neovim/neovim
fi

printf "\xE2\x9C\x94 nvim\n"

which -s python
if [[ $? != 0 ]] ; then
    echo "Installing python..."
    brew install python
fi

printf "\xE2\x9C\x94 python\n"

which -s virtualenv
if [[ $? != 0 ]] ; then
    echo "Installing virtualenv..."
    pip install virtualenv
fi

printf "\xE2\x9C\x94 virtualenv\n"

if [ ! -d ~/.vim/bundle/ ] ; then
    echo "Installing pathogen..."
    mkdir -p ~/.vim/autoload ~/.vim/bundle && \
    curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim
fi

printf "\xE2\x9C\x94 pathogen\n"

if [ ! -d ~/.vim/bundle/ctrlp.vim/ ] ; then
    echo "Installing ctrlp..."
    git clone https://github.com/kien/ctrlp.vim.git ~/.vim/bundle/ctrlp.vim
fi

printf "\xE2\x9C\x94 ctrlp\n"

if [ ! -d ~/.vim/bundle/nerdtree/ ] ; then
    echo "Installing nerdtree..."
    git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree
fi

printf "\xE2\x9C\x94 nerdtree\n"

if [ ! -d ~/.vim/bundle/syntastic ] ; then
    git clone --depth=1 https://github.com/vim-syntastic/syntastic.git ~/.vim/bundle/syntastic
fi

printf "\xE2\x9C\x94 syntastic\n"

if [ ! -d ~/.vim/bundle/vim-airline ] ; then
    git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline
    git clone https://github.com/vim-airline/vim-airline-themes ~/.vim/bundle/vim-airline-themes
fi

printf "\xE2\x9C\x94 vim-airline\n"

if [ ! -d ~/.vim/bundle/vim-gitgutter ] ; then
    git clone git://github.com/airblade/vim-gitgutter.git ~/.vim/bundle/vim-gitgutter
fi

printf "\xE2\x9C\x94 vim-gitgutter\n"

if [ ! -d ~/.vim/bundle/vim-surround ] ; then
    git clone git://github.com/tpope/vim-surround.git ~/.vim/bundle/vim-surround
fi

printf "\xE2\x9C\x94 vim-surround\n"

if [ ! -d ~/.vim/bundle/vim-easymotion ] ; then
    git clone https://github.com/easymotion/vim-easymotion ~/.vim/bundle/vim-easymotion

fi

printf "\xE2\x9C\x94 vim-easymotion\n"

if [ ! -d ~/.vim/bundle/incsearch.vim ] ; then
    git clone https://github.com/haya14busa/incsearch.vim ~/.vim/bundle/incsearch.vim
    git clone https://github.com/haya14busa/incsearch-fuzzy.vim ~/.vim/bundle/incsearch-fuzzy.vim
    git clone https://github.com/haya14busa/incsearch-easymotion.vim ~/.vim/bundle/incsearch-easymotion.vim
fi

printf "\xE2\x9C\x94 incsearch\n"

if [ ! -d ~/.vim/bundle/YouCompleteMe ] ; then
    git clone https://github.com/Valloric/YouCompleteMe.git ~/.vim/bundle/YouCompleteMe
    cd ~/.vim/bundle/YouCompleteMe
    git submodule update --init --recursive
    ./install.sh --clang-completer
    cd
fi

printf "\xE2\x9C\x94 YouCompleteMe\n"

if [ ! -d ~/.vim/colors ] ; then
    git clone git@github.com:sickill/vim-monokai.git
    mv vim-monokai/colors ~/.vim/
    rm -rf vim-monokai
fi

printf "\xE2\x9C\x94 Monokai Theme\n"
