
# Mobius 12 

# Introduction
- This project includes the installation of k3d, helm, and terraform as infrastructure for installing Mobius 12. 
- There is a basic automation of the installation with bash scripts + terraform + helm for learning/testing purposes

## Prerequisites
- Ubuntu 20.04 or higher, wsl included
- install and activate docker

## Preinstallation actions
- Add these lines to $HOME/.profile
    alias k="kubectl"
    alias ta="terraform apply"
    alias ti="terraform init"
    export DOCKER_USER="<rocket-user-rcc>@rs.com"
    export DOCKER_PASS="<rocket-pass-rcc>"

## Installation sequence

Install k3d, helm, kubectl and terraform
- ./mobius_infra.sh install

Create the cluster for mobius, download the images from registry.rocketsoftware.com
- ./mobius_infra.sh create

- cd shared
- ./install.sh

- cd mobius
- ./install.sh


## UnInstall All
Removes the cluster
- ./mobius_infra.sh remove

## Partial UnInstall of shared componnets, cluster and images are maintained
- cd shared
- ./remove.sh

## Partial UnInstall of mobius componnets, cluster and images are maintained
- cd mobius
- ./remove.sh

## Partial Install of shared componnets - when partial uninstall is applied
- cd shared
- ./install.sh

## Partial Install of mobius componnets- when partial uninstall is applied
- cd mobius
- ./install.sh

