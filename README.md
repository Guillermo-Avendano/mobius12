# Mobius 12

## Introduction

- Mobius 12.1 installation k3d

## Prerequisites

- Ubuntu-WSL / Ubuntu 20.04 or higher
- 16 GB / 4 CPUs
- Ubuntu WSL Installation: <https://learn.microsoft.com/en-us/windows/wsl/install-manual>

## Preinstallation actions

### Ubuntu: get installations scripts (don't use root user)

```bash
git clone https://github.com/guillermo-avendano/mobius12.git
cd mobius12
```

### Edit "$HOME/.profile" (nano $HOME/.profile), and define the variables DOCKER_USERNAME with your RCC username, and DOCKER_PASWORD with the output of previous "echo"

```bash

export DOCKER_USERNAME="[RCC user]@rs.com"
export DOCKER_PASSWORD="[RCC password]"
```

### Edit "$HOME/.profile", and define the variable MOBIUS_LICENSE with MobiusView License

```bash
export MOBIUS_LICENSE="[mobius view license]"
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

### Variables in "./env.sh", update image versions, and MOBIUS_VIEW_URL if needed

```bash
IMAGE_NAME_MOBIUS=mobius-server
IMAGE_VERSION_MOBIUS=12.1.0004
IMAGE_EXTRA_ARGS_MOBIUS=
IMAGE_NAME_MOBIUSVIEW=mobius-view
IMAGE_VERSION_MOBIUSVIEW=12.1.0
IMAGE_EXTRA_ARGS_MOBIUSVIEW=
IMAGE_NAME_EVENTANALYTICS=eventanalytics
IMAGE_VERSION_EVENTANALYTICS=1.3.8
MOBIUS_VIEW_URL="mobius12.local.net"
```

### Add MOBIUS_VIEW_URL to /etc/hosts, or c:/windows/system32/drivers/etc/hosts with the IP where the custer is running, example

```bash
192.168.0.5     mobius12.local.net  pgadmin.local.net  grafana.local.net
```

## Installation sequence

1; Pre-requisites

- Install dos2unix

```bash
sudo apt-get -y update
sudo apt-get -y upgrade
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

3; Install docker (use docker_install.sh for Ubuntu no-WSL)

```bash
# mobius12 folder
./docker_install-wsl-ubuntu.sh
```

4; Verify docker (more information <https://docs.docker.com/desktop/install/ubuntu/>)

```bash
docker version
```

5; Install k3d, helm, kubectl and terraform

```bash
# mobius12 folder
./pre-reqs-install.sh
```

6; Create the cluster for mobius, and pull images from registry.rocketsoftware.com

```bash
# mobius12 folder
./rockcluster.sh create
```

7; Install database, kafka, elasticsearch, pgadmin, and grafana

```bash
# mobius12 folder
cd shared
./install.sh
cd ..
```

8; Install eventanalytics, mobius and mobiusview

```bash
# mobius12 folder
cd mobius-terraform
# "terraform init" - only 1st time required
terraform init
./install.sh
```

9; Mobius URL: <http://mobius12.local.net/mobius/admin>

- user: admin
- password: admin

## Summary of commands

| Command | Description |
|:---|:---|
| ./rockcluster.sh start | start mobius cluster |
| ./rockcluster.sh stop | stop mobius cluster |
| ./rockcluster.sh imgls | list images from registry.rocketsoftware.com |
| ./rockcluster.sh imgpull | pull images from registry.rocketsoftware.com, and push them into cluster |
| ./rockcluster.sh list | list clusters |
| ./rockcluster.sh create | create mobius cluster |
| ./rockcluster.sh remove | remove mobius cluster |
| ./rockcluster.sh debug | output of kubectl get/describe of mobius' kubernetes resources |

#### pgadmin: <http://pgadmin.local.net>

- user: <admin@admin.com>
- password: admin

server: postgresql , database=mobiusserver, user=mobius, password=postgres

#### Grafana: <http://grafana.local.net>

- user: admin
- password: admin

server: postgresql , database=eventanalytics, user=mobius, password=postgres
