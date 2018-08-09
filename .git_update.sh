#!/bin/bash

branch=$(git symbolic-ref --short HEAD)
if [ "$branch" == "master" ] ; then
    read -p "You are about to commit to master. Are you sure you want to do that? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        :
    else
        echo "Aborting";
        exit 1;
    fi
fi
git diff | grep -q '\+\s*print\s'
if [[ $? == 0 ]] ; then
    read -p "The changes you are staging include at least one print statement. Are you sure you want to stage? [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        echo "Changes staged";
    else
        echo "Changes not staged";
        exit 2;
    fi
else
    echo "Changes staged";
fi
FIRST_COMMIT_MESSAGE="$(git fcm)"
git add .
if [ -n "$1" ] ; then
    commit_message=$1
else
    echo -n "Commit message: "
    read commit_message
fi
if [ "$FIRST_COMMIT_MESSAGE" ]; then
    commit_message=$(printf "%s\n- %s" "$FIRST_COMMIT_MESSAGE" "$commit_message")
fi
echo $commit_message
git cim "$commit_message"
if [[ $? != 0 ]] ; then
    echo "Not commiting, working branch clean"
    exit 3;
fi
echo "Pushing..."
git push origin $branch
