#!/bin/bash

N='\033[0m'
Y='\033[0;33m'
R='\033[0;31m'
G='\033[0;32m'
while [ True ]
do
    echo -e $Y"Enter a number 
    1- Fix dnf
    2- Enable RPM
    3- Install flatpak and snap
    4- Setup power saving
    5- Optimize performance (SSD trim, adjust swappiness)
    6- Setup mouse/trackpad X11
    "
    $N
    read NUM 

    case $NUM in

        1)
            echo "fastestmirror=True
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
            sudo dnf in flatpak
            flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
            sudo flatpak override --filesystem=$HOME/.themes
            sudo flatpak override --filesystem=$HOME/.icons
            echo -e $Y"Installed flatpak"$N
            sudo dnf in snapd
            sudo systemctl enable --now snapd
            sudo systemctl enable --now snapd.apparmor
            echo -e $Y"Installed snap"$N
            ;;
        4)
            sudo snap install auto-cpufreq
            sudo snap run auto-cpufreq --install
            sudo dnf in thermald powertop
            sudo systemctl enable --now thermald
            echo -e $Y"Installed and set up"$N
            ;;
        5)
            sudo systemctl enable fstrim.timer
            echo "vm.swappiness=10" | sudo tee /etc/sysctl.d/99-swappiness.conf
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
                EndSection
                ' | sudo tee /etc/X11/xorg.conf.d/70-touchpad.conf
                ;;

                        *)
                            echo -e $R"Invalid Option"$N
                            ;;
    esac
done
