# Mobius 12

## Introduction

- This project includes the installation of k3d, helm, and terraform as infrastructure for installing Mobius 12.
- bash scripts + terraform + helm for mobius12

## Prerequisites

- Ubuntu-WSL / Ubuntu 20.04 or higher
- 16 GB / 4 CPUs
- Ubuntu WSL Installation: https://learn.microsoft.com/en-us/windows/wsl/install-manual

## Preinstallation actions
### Ubuntu: get installations scripts (don't use root user)
```bash
git clone https://github.com/guillermo-avendano/orchestrator.git
cd orchestrator
```
### Define variables DOCKER_USERNAME, and DOCKER_PASSWORD in "$HOME/.profile" for pulling images from "registry.rocketsoftware.com"
- Encrypt password
```bash
echo "RCC password" | base64
```
- Edit "$HOME/.profile" (nano $HOME/.profile), and define the variables DOCKER_USERNAME with your RCC username, and DOCKER_PASWORD with the output of previous "echo"
```bash
export DOCKER_USERNAME="[RCC user]@rs.com"
export DOCKER_PASSWORD="[RCC password encripted base64]"
```
### Optional: add these lines to "$HOME/.profile" for facilitate the commnads' typing
```bash
alias k="kubectl"
alias ta="terraform apply"
alias ti="terraform init"
```
### Refresh environment variables
```bash
source $HOME/.profile
# mobius12 folder
source ./env.sh
```
### Check versions for mobius-server. mobius-view, and eventanalytics
```bash
# mobius12 folder
./rockcluster.sh imgls
```

### Variables in "./env.sh", update image versions, and AEO_URL if needed:
```bash
IMAGE_NAME_MOBIUS=mobius-server
IMAGE_VERSION_MOBIUS=12.1.0004
IMAGE_EXTRA_ARGS_MOBIUS=
IMAGE_NAME_MOBIUSVIEW=mobius-view
IMAGE_VERSION_MOBIUSVIEW=12.1.1
IMAGE_EXTRA_ARGS_MOBIUSVIEW=
IMAGE_NAME_EVENTANALYTICS=eventanalytics
IMAGE_VERSION_EVENTANALYTICS=1.3.8
MOBIUS_VIEW_URL="mobius12.local.net"
```

###  Add AEO_URL to /etc/hosts, or c:/windows/system32/drivers/etc/hosts with the IP where the custer is running, example:
```bash
192.168.0.5     mobius12.local.net
```

## Installation sequence 

1; Pre-requisites
- Install dos2unix
```bash
sudo apt install -y dos2unix
```
- Change file formats
```bash
# mobius12 folder
find . -name "*.yaml" -exec dos2unix {} \;
find . -name "*.sh" -exec dos2unix {} \;
```
- Enable scripts for execution
```bash
# mobius12 folder
chmod -R u+x *.sh
```

2; Refresh environment variables
```bash
source $HOME/.profile
# mobius12 folder
source ./env.sh
```
3; Install docker, k3d, helm, kubectl and terraform
```bash
# mobius12 folder
./pre-reqs-install.sh
```
4; Verify docker (more information https://docs.docker.com/desktop/install/ubuntu/)
```bash
docker version
```
5; Create the cluster for mobius, and pull images from registry.rocketsoftware.com
```bash
# mobius12 folder
./rockcluster.sh create
```
6; Install database, kafka, elasticsearch
```bash
# mobius12 folder
cd shared
./install.sh
cd ..
```
6; Install mobius and mobiusview
```bash
# mobius12 folder
cd mobius-terraform
./install.sh
```
6; Mobius URL: http://mobius12.local.net/mobius/admin
- user: admin
- password: admin

## Summary of commands

| Command | Description |
|:---|:---|
| ./rockcluster.sh on | start mobius cluster |
| ./rockcluster.sh off | stop mobius cluster |
| ./rockcluster.sh pgport | Open postgres port if active for remote access from SQL tools |
| ./rockcluster.sh imgls | list images from registry.rocketsoftware.com |
| ./rockcluster.sh imgpull | pull images from registry.rocketsoftware.com |
| ./rockcluster.sh list | list clusters |
| ./rockcluster.sh create | create mobius cluster |
| ./rockcluster.sh remove | remove mobius cluster |
| ./rockcluster.sh debug | output of kubectl get/describe of mobius' kubernetes resources |


### Activate pgadmin & grafana (pre-requisite: "./rockcluster.sh pgport")
- Start pgadmin & Grafana
```bash
# mobius12 folder
cd tools
./run.sh
```
#### pgadmin: http://mobius12.local.net:5050
- user: admin@admin.com
- password: admin

server: IP Address where cluster is running , database=aeo, user=aeo, password=aeo
#### grafana: http://mobius12.local.net:3000

### Stop pgadmin & grafana
```bash
# mobius12 folder
cd tools
./stop.sh
```

