#!/bin/bash

N='\033[0m'
Y='\033[0;33m'
R='\033[0;31m'
G='\033[0;32m'
CURRENTDIR=$(pwd)

while [ True ]
do
    echo -e $Y"Enter a number 
    1- Fix dnf
    2- Enable RPM
    3- Install flatpak and snap
    4- Setup power saving
    5- Optimize performance (SSD trim, adjust swappiness)
    6- Setup mouse/trackpad X11
    7- Install other packages
    8- Setup neovim
    9- Setup zsh (requires reboot)
    10- Setup dotfiles
    "$N
    read NUM 

    case $NUM in

        1)
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
            ;;

        2)
            echo -e $Y"This will enable RPM fusion repositories"$N
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
            sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
            echo -e $Y"Enabled RPM"$N
            ;;
        3)
            sudo dnf in -y flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            sudo flatpak override --filesystem=$HOME/.themes
            sudo flatpak override --filesystem=$HOME/.icons
            echo -e $Y"Installed flatpak"$N
            sudo dnf in -y snapd
            sudo systemctl enable --now snapd
            # sudo systemctl enable --now snapd.apparmor
            echo -e $Y"Installed snap"$N
            ;;
        4)
            sudo snap install auto-cpufreq
            sudo snap run auto-cpufreq --install
            sudo dnf in -y thermald powertop
            sudo systemctl enable --now thermald
            echo -e $Y"Installed and set up"$N
            ;;
        5)
            sudo systemctl enable fstrim.timer
            echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
            echo -e $Y"Ajusted performance"$N
            ;;
        6)
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
            ;;

        7)
            sudo dnf in -y sddm florence acpi alacritty AtomicParsley ark bleachbit brightnessctl dolphin fcitx5 ffmpeg ffmpegthumbnailer ffmpegthumbs htop lutris mpd ncdu ncmpcpp obs-studio okular pavucontrol perl-File-MimeInfo qbittorrent ranger redshift rofi spectacle speedtest-cli steam timeshift unrar xfce4-power-manager xclip xrandr xprop xsel yt-dlp git bspwm rofi nitrogen sxhkd polybar dunst libnotify lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings alacritty zsh lxappearance qt5ct fcitx5 fcitx5-mozc fcitx5-configtool snapd thermald powertop cpu-x flatpak polkit kdeconnect-kde qlipper xkill mpv xclip sqlite3 exa antimicrox leafpad tmux bat fzf gamemode xhost neovim python3-pip nodejs tmux gammastep picom kernel-tools blueman network-manager-applet pulseaudio-utils wdisplays slurp grim libva-utils
            sudo dnf install -y --setopt=install-weak-deps=False nomacs
            sudo dnf groupinstall -y "C Development Tools and Libraries"
            sudo dnf groupinstall -y "Development Tools"
            sudo flatpak install vscodium librewolf brave flatseal obsproject
            echo -e $Y"Installed everything"$N
            ;;

        8)
            sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
            sudo dnf in -y python3-pip nodejs
            sudo npm install -g yarn
            cd ~/.local/share/nvim/plugged/coc.nvim
            yarn install
            yarn build
            pip3 install jedi
            cd $CURRENTDIR
            echo -e $Y"Manual installation of TreeSitter and Coc are necessary"$N
            ;;

        9)
            sudo dnf in -y zsh
            chsh -s $(which zsh)
            sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"
            git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
            git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
echo 'PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%~%{$reset_color%}"
PROMPT+=" $(git_prompt_info)"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[blue]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[blue]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[blue]%})"' | tee ~/.oh-my-zsh/themes/robbyrussell.zsh-theme

        10)
            cp -r ../config/* ~/.config/
            cp -r ../bakap ~/.config/
            cp ../zprofile ~/.zprofile
            cp ../profile ~/.profile
            cp ../zsh_aliases ~/.zsh_aliases
            cp ../zshrc ~/.zshrc
            echo -e $Y"Copied files"$N
            ;;
        *)
            echo -e $R"Invalid Option"$N
            ;;
    esac
done
