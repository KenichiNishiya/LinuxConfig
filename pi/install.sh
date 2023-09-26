# TODO
### Install all programs
# Configure NEOVIM

N='\033[0m'
Y='\033[0;33m'

echo "fastestmirror=True
max_parallel_downloads=10
defaultyes=Yes" | sudo tee /etc/dnf/dnf.conf
echo "Changed dnf configuration"

### ENABLE RPM
echo -e $Y"This will enable RPM fusion repositories"$N
            sudo dnf install -y https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm
	        sudo dnf upgrade --refresh
            sudo dnf groupupdate -y core
            sudo dnf install -y rpmfusion-free-release-tainted
            sudo dnf install -y dnf-plugins-core
echo "Install programs"
sudo dnf in -y sddm florence acpi alacritty AtomicParsley ark bleachbit brightnessctl dolphin fcitx5 ffmpeg ffmpegthumbnailer ffmpegthumbs htop lutris mpd ncdu ncmpcpp obs-studio okular pavucontrol perl-File-MimeInfo qbittorrent ranger redshift rofi spectacle speedtest-cli steam timeshift unrar xfce4-power-manager xclip xrandr xprop xsel yt-dlp git bspwm rofi nitrogen sxhkd polybar dunst libnotify lightdm lightdm-gtk-greeter lightdm-gtk-greeter-settings alacritty zsh lxappearance qt5ct fcitx5 fcitx5-mozc fcitx5-configtool snapd thermald powertop cpu-x flatpak polkit kdeconnect-kde qlipper xkill mpv xclip sqlite3 nomacs exa antimicrox leafpad tmux bat fzf gamemode xhost neovim python3-pip nodejs tmux gammastep picom kernel-tools blueman network-manager-applet pulseaudio-utils wdisplays slurp grim
sudo dnf in -y --setopt=install-weak-deps=False nomacs
sudo dnf groupinstall -y "C Development Tools and Libraries"
sudo dnf groupinstall -y "Development Tools"

echo "Installed programs"

echo "Install neovim"
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

sudo dnf in -y python3-pip nodejs
sudo npm install -g yarn
cd ~/.local/share/nvim/plugged/coc.nvim
yarn install
yarn build
pip3 install jedi

###
echo "Manual action needed to install plugins"


