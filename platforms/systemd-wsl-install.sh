#!/bin/bash
echo Ubuntu 22.04
sudo apt-get update
sudo apt-get dist-upgrade -y
sudo apt-get install curl wget -y

wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb

sudo apt-get update

sudo apt-get install -y apt-transport-https && \
sudo apt-get update && \
sudo apt-get install -y aspnetcore-runtime-7.0

sudo wget -O /etc/apt/trusted.gpg.d/wsl-transdebian.gpg https://arkane-systems.github.io/wsl-transdebian/apt/wsl-transdebian.gpg
sudo chmod a+r /etc/apt/trusted.gpg.d/wsl-transdebian.gpg
source /etc/os-release
cat << EOF | sudo tee /etc/apt/sources.list.d/wsl-transdebian.list
deb https://arkane-systems.github.io/wsl-transdebian/apt/ $VERSION_CODENAME main
deb-src https://arkane-systems.github.io/wsl-transdebian/apt/ $VERSION_CODENAME main
EOF
sudo apt-get update
sudo apt-get install systemd-genie -y

sudo update-alternatives --set iptables /usr/sbin/iptables-legacy
sudo update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

