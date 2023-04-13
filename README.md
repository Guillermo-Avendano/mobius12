# Mobius 12 
## Introduction
- This project includes the installation of k3d, helm, and terraform as infrastructure for installing Mobius 12. 
- There is a basic automation of the installation with bash scripts + terraform + helm for learning/testing purposes

## Prerequisites
- Ubuntu-WSL / Ubuntu 20.04 or higher
- 16 GB / 4 CPUs
- install and activate docker

## Preinstallation actions
- Optional: add these lines to "$HOME/.profile" for facilitate the commnads' typing
    alias k="kubectl"
    alias ta="terraform apply"
    alias ti="terraform init"

- Define the environment variable DOCKER_PASSWORD in "$HOME/.profile"
    export DOCKER_PASSWORD=<RCC password encripted base64>
      

- Check versions for mobius-server. mobius-view, and eventanalytics
•	curl -X GET -u <username RCC>:<password RCC> https://registry.rocketsoftware.com/v2/mobius-server/tags/list
•	curl -X GET -u <username RCC>:<password RCC> https://registry.rocketsoftware.com/v2/mobius-view/tags/list
•	curl -X GET -u <username RCC>:<password RCC> https://registry.rocketsoftware.com/v2/eventanalytics/tags/list

- Adapt the following variables in "common/env.sh" with the rigth values for the versions:
    MOBIUS_SERVER_VERSION="12.1.0004"   
    MOBIUS_VIEW_VERSION="12.1.1"                           
    EVENTANALYTICS_VERSION="1.3.8"                        

- Adapt the variable TF_VAR_MOBIUS_VIEW_URL in "common/env.sh" with hostname for accesing to mobius view:
    export TF_VAR_MOBIUS_VIEW_URL="mobius12.local.net"  

- Add the value of TF_VAR_MOBIUS_VIEW_URL to /etc/hosts c:/windows/system32/drivers/etc/hosts 
  with the IP where the custer will run, example:

     192.168.0.5     mobius12.local.net

## Installation sequence

It installs k3d, helm, kubectl and terraform
- ./mobius_infra.sh install

It creates the cluster for mobius, download the images from registry.rocketsoftware.com
- ./mobius_infra.sh create

- cd shared
- ./install.sh

- cd mobius
- ./install.sh


## Other options
### Removes the cluster
- ./mobius_infra.sh remove

### Create the cluster
- ./mobius_infra.sh create

### Remove shared componnets with the namespece associated. The cluster and images are maintained
- cd shared
- ./remove.sh

### Remove mobius componnets with the namespece associated. The cluster and images are maintained
- cd mobius
- ./remove.sh

###  Install of shared componnets
- cd shared
- ./install.sh

###  Install of mobius componnets
- cd mobius
- ./install.sh

