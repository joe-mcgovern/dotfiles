#! /usr/bin/env bash

set -e

eval "$(ssh-agent -s)"
ssh-add -K ~/.ssh/id_ed25519

cd ~/.password-store

git pull origin master && git add -A && git commit -m "Automatic sync" && git push origin master
