#!/bin/bash
set -e

### ura
LOCAL_OBS="$HOME/Documents/obsidian"
REMOTE_OBS="$HOME/re/git/ura/obsidian"

echo "Fetch any update from ura repo"
cd $REMOTE_OBS
git pull

echo "Copy to local obsidian folder"
rsync -a --ignore-existing $REMOTE_OBS/* $LOCAL_OBS

cd $HOME

### study

LOCAL_STU="$HOME/study"
REMOTE_STU="$HOME/re/git/study"

echo "Fetch any update from study repo"
cd $REMOTE_STU
git pull

echo "Copy to local study folder"
rsync -a --ignore-existing $REMOTE_STU/* $LOCAL_STU

cd $HOME
