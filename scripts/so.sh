#!/bin/bash

echo "Changing to so"
cd ~/re/git/so
cp -ru ~/re/games/wine/drive_c/osu/Songs .
cp -ru ~/re/games/wine/drive_c/osu/Skins .
echo "Copied everything"
git add .
echo "added"
git commit -m 'updating'
echo "commited"
git push origin main
echo "pushed"
