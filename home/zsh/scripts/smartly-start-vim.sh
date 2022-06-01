#!/usr/bin/env bash

files=$(ls)

vim="/usr/local/bin/vim"
cmd="$vim"
if echo $files | grep -q "Pipfile"; then
    echo "Make sure dependencies are installed by running: pipenv install --dev"
    cmd="pipenv run $vim"
elif echo $files | grep -q "pyproject.toml"; then
    echo "Make sure dependencies are installed by running: poetry install"
    cmd="poetry run $vim"
fi

echo "Opening vim via: $cmd"

exec $cmd $@
