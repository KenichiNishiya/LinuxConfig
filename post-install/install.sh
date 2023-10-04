#!/bin/bash
## MANUAL ACTION NEEDED:
# lxappearance and kvantummanager
# TreeSitter and Coc

# TESTED ON FEDORA 38 KDE on 27/09/23
# 4.4G to 11G
# Took 18m30s on a kvm

N='\033[0m'
Y='\033[1;33m'
R='\033[0;31m'
G='\033[0;32m'
CURRENTDIR=$(pwd)

echo "[main]
gpgcheck=True
installonly_limit=3
clearn_requirements_on_remove=True
best=False
skip_if_unavailable=True
fastestmirror=True
max_parallel_downloads=10
defaultyes=Yes" | sudo tee /etc/dnf/dnf.conf
            echo -e $Y"Changed dnf configuration"$N

            echo -e $Y"This will enable RPM fusion repositories"$N
            sudo dnf up -y
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf upgrade -y --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            echo -e $Y"Enabled RPM"$N

            sudo dnf in -y flatpak
            sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            sudo flatpak override --filesystem=$HOME/.themes
            sudo flatpak override --filesystem=$HOME/.icons
            echo -e $Y"Installed flatpak"$N
            sudo dnf in -y snapd
            sudo systemctl enable --now snapd
            # sudo systemctl enable --now snapd.apparmor
            echo -e $Y"Installed snap"$N

            sudo snap install auto-cpufreq
            sudo snap run auto-cpufreq --install
            sudo dnf in -y thermald powertop
            sudo systemctl enable --now thermald
            echo -e $Y"Installed and set up"$N

            sudo systemctl enable fstrim.timer
            echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
            echo -e $Y"Ajusted performance"$N

echo 'Section "InputClass"
    Identifier "touchpad"
    Driver "libinput"
    MatchIsTouchpad "on"
        Option "TapButton1" "1"
        Option "TapButton2" "3"
        Option "TapButton3" "2"
        Option "NaturalScrolling" "on"
        Option "Tapping" "on"
        Option "VertEdgeScroll" "on"
        Option "VertTwoFingerScroll" "on"
        Option "HorizEdgeScroll" "on"
        Option "HorizTwoFingerScroll" "on"
        Option "CircularScrolling" "on"
        Option "CircScrollTrigger" "2"
        Option "EmulateTwoFingerMinZ" "40"
        Option "EmulateTwoFingerMinW" "8"
        Option "CoastingSpeed" "0"
        Option "FingerLow" "20"
        Option "FingerHigh" "40"
        Option "MaxTapTime" "125"
        Option      "VertScrollDelta"          "-111"
        Option      "HorizScrollDelta"         "-111"
EndSection' | sudo tee /etc/X11/xorg.conf.d/70-touchpad.conf
            echo -e $Y"Fixed trackpad"$N
echo 'Section "InputClass"
	Identifier "My Mouse"
	Driver "libinput"
	MatchIsPointer "yes"
	Option "AccelProfile" "flat"
	Option "AccelSpeed" "0"
EndSection' | sudo tee /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
            echo -e $Y"Fixed mouse"$N

            sudo dnf in -y --skip-broken sddm florence acpi alacritty AtomicParsley ark bleachbit brightnessctl dolphin fcitx5 ffmpeg ffmpegthumbnailer ffmpegthumbs htop lutris mpd ncdu ncmpcpp obs-studio okular pavucontrol perl-File-MimeInfo qbittorrent ranger redshift rofi spectacle speedtest-cli steam timeshift unrar xfce4-power-manager xclip xrandr xprop xsel yt-dlp git bspwm rofi nitrogen sxhkd polybar dunst libnotify lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings alacritty zsh lxappearance qt5ct fcitx5 fcitx5-mozc fcitx5-configtool snapd thermald powertop cpu-x flatpak polkit kdeconnect-kde qlipper xkill mpv xclip sqlite3 exa antimicrox leafpad tmux bat fzf gamemode xhost neovim python3-pip nodejs tmux gammastep picom kernel-tools blueman network-manager-applet pulseaudio-utils wdisplays slurp grim libva-utils neovim kitty alacritty intel-gpu-tools lxqt-policykit wmname
            sudo dnf install -y --setopt=install-weak-deps=False nomacs
            sudo dnf groupinstall -y "C Development Tools and Libraries"
            sudo dnf groupinstall -y "Development Tools"
            sudo flatpak install -y vscodium librewolf brave flatseal obsidian
            sudo flatpak install -y app/com.obsproject.Studio/x86_64/stable
            echo -e $Y"Installed everything"$N

            sudo dnf in -y neovim
            sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            sudo dnf in -y python3-pip nodejs
            sudo npm install -g yarn
            cd ~/.local/share/nvim/plugged/coc.nvim
            yarn install
            yarn build
            pip3 install jedi
            cd $CURRENTDIR
            echo -e $Y"Manual installation of TreeSitter and Coc are necessary"$N

            sudo dnf in -y zsh
            sudo chsh -s $(which zsh)
            yes n | sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo 'PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=" $(git_prompt_info)"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"' | tee ~/.oh-my-zsh/themes/robbyrussell.zsh-theme

            cp -r ../config/* ~/.config/
            cp -r ../bakap ~/.config/
            cp ../zprofile ~/.zprofile
            cp ../profile ~/.profile
            cp ../zsh_aliases ~/.zsh_aliases
            cp ../zshrc ~/.zshrc
            echo -e $Y"Copied files"$N

            sudo dnf in -y google-noto-sans-jp-fonts

            sudo mkdir /usr/share/fonts/jetbrains-mono-fonts
            cd /usr/share/fonts/jetbrains-mono-fonts
            sudo wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.2.2/JetBrainsMono.zip
            sudo unzip JetBrainsMono.zip
            sudo rm -rf JetBrainsMono.zip

            sudo mkdir /usr/share/fonts/noto-nerd-font
            cd /usr/share/fonts/noto-nerd-font
            sudo wget https://github.com/ryanoasis/nerd-fonts/blob/master/patched-fonts/Noto/Sans/NotoSansNerdFont-Regular.ttf

            cd $CURRENTDIR
            echo -e $Y"Installed fonts"$N

            sudo dnf in -y lxappearance qt5ct kvantummanager nitrogen
            mkdir -p ~/.themes
            cd ~/.themes
            wget https://github.com/dracula/gtk/archive/master.zip
            unzip master.zip
            rm -rf master.zip
            mkdir -p ~/.icons
            cd ~/.icons
            git clone https://github.com/m4thewz/dracula-icons

            sudo cp -r ~/.themes/gtk-master /usr/share/themes
            sudo cp -r ~/.icons/dracula-icons /usr/share/icons/
            sudo mkdir /usr/share/themes/dracula
            sudo cp -r ~/.themes/Dracula-cursors.tar.gz /usr/share/themes/dracula/
            echo -e $Y"Themed GTK"$N

            ### QT ###
            mkdir -p ~/.themes/Dracula
            cd ~/.themes/
            git clone https://github.com/dracula/gtk.git
            mv ~/.themes/gtk-master/kde/kvantum/* ~/.themes/Dracula
            rm -rf gtk-master

            echo -e $Y"Themed QT"$N
            echo -e $Y"But manual set is necessary (lxappearance, kvantummanager and qt5ct)"$N

            wget https://github.com/catppuccin/qbittorrent/blob/main/mocha.qbtheme

            ### SDDM ###
            cd $CURRENTDIR
            sudo cp ../config/sddm/sddm.conf /etc/sddm.conf.d/
            sudo cp -r ../config/sddm/sddm-sugar-candy /usr/share/sddm/themes/

            sudo dnf in -y sway waybar gammastep wofi clipman libappindicator wl-clipboard
            sudo dnf in -y bspwm rofi nitrogen sxhkd polybar dunst sddm lxqt-policykit picom
            echo -e $Y"Installed both wm"$N

            mkdir ~/.local/share/mpd
            mkdir ~/.local/share/mpd/playlists
            touch ~/.local/share/mpd/database
            touch ~/.local/share/mpd/state
            touch ~/.local/share/mpd/sticker.sql
            echo -e $Y"Created mpd files"$N

            curl https://raw.githubusercontent.com/GeorgeFilipkin/pulsemixer/master/pulsemixer > pulsemixer && chmod +x ./pulsemixer
            sudo mv pulsemixer /opt
            echo -e $Y"Downloaded pulsemixer"$N

            sudo dnf in -y steam lutris goverlay mangohud gamemode gamescope wine winetricks
            echo -e $Y"Installed game related packages"$N

        sudo dnf in -y gtk3-devel gcc gcc-c++ kernel-devel pkg-config make hostapd qrencode-devel libpng-devel
        sudo chmod 777 /opt
        cd /opt

        git clone https://github.com/lakinduakash/linux-wifi-hotspot
        cd linux-wifi-hotspot
        sudo make
        sudo make install
        cd $CURRENTDIR
        echo -e $Y"Installed wihotspot"$N
