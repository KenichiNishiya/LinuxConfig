#!/bin/bash

echo "Changing to so"
cd ~/re/git/so
cp -r ~/re/games/wine/drive_c/osu/Songs .
cp -r ~/re/games/wine/drive_c/osu/Skins .
echo "Copied everything"
git add .
echo "added"
git commit -m 'updating'
echo "commited"
git push origin main
echo "pushed"
