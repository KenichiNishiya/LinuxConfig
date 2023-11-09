#!/bin/bash

REPO=~/re/git/dotfiles/
IN=~/.config/
OUT=~/re/git/dotfiles/config/

cp $IN'alacritty/alacritty.yml' $OUT'alacritty/alacritty.yml'
cp $IN'bspwm/bspwmrc' $OUT'bspwm/bspwmrc'
cp $IN'dunst/dunstrc' $OUT'dunst/dunstrc'
cp $IN'picom/picom.conf' $OUT'picom/picom.conf'
cp $IN'polybar/config.ini' $OUT'polybar/config.ini'
cp $IN'polybar/launch.sh' $OUT'polybar/launch.sh'
cp $IN'rofi/config.rasi' $OUT'rofi/config.rasi'
cp $IN'sxhkd/sxhkdrc' $OUT'sxhkd/sxhkdrc'
cp $IN'waybar/config.jsonc' $OUT'waybar/config.jsonc'
cp $IN'waybar/style.css' $OUT'waybar/style.css'
cp $IN'hypr/hyprland.conf' $OUT'hypr/hyprland.conf'
cp $IN'wofi/config' $OUT'wofi/config'
cp $IN'wofi/style.css' $OUT'wofi/style.css'
cp $IN'kitty/kitty.conf' $OUT'kitty/kitty.conf'
cp $IN'picom/picom.conf' $OUT'picom/picom.conf'
# cp $IN'nvim/lua/custom/init.lua' $OUT'nvim/init/init.lua'
# cp $IN'nvim/lua/custom/chadrc.lua' $OUT'nvim/chadrc/chadrc.lua'
# cp $IN'nvim/lua/custom/plugins.lua' $OUT'nvim/plugins/plugins.lua'
cp $IN'tmux/tmux.conf' $OUT'tmux/tmux.conf'
cp $IN'sway/config' $OUT'sway/config'
cp $IN'mpv/input.conf' $OUT'mpv/input.conf'
cp $IN'mpv/mpv.conf' $OUT'mpv/mpv.conf'
cp -r $IN'antimicrox' $OUT'antimicrox'

# cp ~/Documents/suse.sh $REPO 
# cp ~/.vimrc $REPO'vimrc'
cp ~/.zsh_aliases $REPO'zsh_aliases'
cp ~/.zprofile $REPO'zprofile'
cp ~/.zshrc $REPO'zshrc'
# cp ~/.tmux.conf $REPO'tmux.conf'

cp -r $IN'lutris/games/' $REPO'/bakap/lutris/'
cp -r ~/'.config/bakap/' $REPO
# cp -r /home/yori/Documents/scripts/* $REPO'scripts/'
# cp $IN'nvim/init.vim' $OUT'nvim/init.vim' sudo cp /etc/sddm.conf.d/sddm.conf $OUT'sddm/sddm.conf' 
cp -r /usr/share/sddm/themes/sddm-sugar-candy $OUT'sddm/'

cd $REPO
echo "Changed directory to $(pwd)"
git add .
git commit -m "Update config files"
git push origin main
