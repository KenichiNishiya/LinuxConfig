#!/bin/bash
# export PATH=/usr/bin:/bin:/usr/local/bin
# export GIT_SSH_COMMAND="ssh -i /home/yori/.config/tk/tk"
cd /home/yori/study
git pull
git add .
git commit -m 'Upload files'
git push origin main

