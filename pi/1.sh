#/bin/bash
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

