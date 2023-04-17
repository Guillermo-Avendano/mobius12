# Mobius 12

## Introduction

- This project includes the installation of k3d, helm, and terraform as infrastructure for installing Mobius 12.
- bash scripts + terraform + helm for mobius12

## Prerequisites

- Ubuntu-WSL / Ubuntu 20.04 or higher
- 16 GB / 4 CPUs

## Preinstallation actions

- Optional: add these lines to "$HOME/.profile" for facilitate the commnads' typing
    alias k="kubectl"
    alias ta="terraform apply"
    alias ti="terraform init"

- Define the environment variable DOCKER_PASSWORD in "$HOME/.profile"
        export DOCKER_PASSWORD=[RCC password encripted base64]

- Check versions for mobius-server. mobius-view, and eventanalytics
  ./mvcluster.sh imgls

- Adapt the following variables in "./env.sh" with the rigth values for the versions:
    export KUBE_IMAGES=("mobius-server:12.1.0004" "mobius-view:12.1.1" "eventanalytics:1.3.8")
    MOBIUS_SERVER_VERSION="12.1.0004"
    MOBIUS_VIEW_VERSION="12.1.1"
    EVENTANALYTICS_VERSION="1.3.8"

- Adapt the variables:
      TF_VAR_MOBIUS_VIEW_URL = "mobius12.local.net"
      TF_VAR_PGADMIN_URL     = "pgadmin.local.net"
      TF_VAR_ELASTIC_URL     = "elastic.local.net"
   in "./env.sh", and add these values to /etc/hosts c:/windows/system32/drivers/etc/hosts
  with the IP where the custer will run, example:

     192.168.0.5     mobius12.local.net pgadmin.local.net elactic.local.net

## Installation sequence

1; Install k3d, helm, kubectl and terraform

- cd kube
  install.sh

2; set environment

- source env.sh

3; Create the cluster for mobius, and pull images from registry.rocketsoftware.com

- ./mvcluster.sh create

4; Initilize Terraform providers

- cd shared
- terraform init
- cd ../mobius
- terraform init

5; Install shared namespace with: postgres, pgadmin, kafka, elasticsearch

- cd shared
- terraform init
- ./install.sh

6; Install mobius-server and mobius-view

- cd mobius
- terraform init
- ./install.sh

## Summary of commands

|-------------------------|-----------------------------------------------------------------|
| mvcluster.sh on         | start mobius cluster
| mvcluster.sh off        | stop mobius cluster
| mvcluster.sh imgls      | list images from registry.rocketsoftware.com
| mvcluster.sh imgpull    | pull images from registry.rocketsoftware.com
| mvcluster.sh list       | list clusters
| mvcluster.sh create     | create mobius cluster
| mvcluster.sh remove     | remove mobius cluster
| mvcluster.sh debug      | generate outputs for get/describe of each kubernetes resources

### Install of shared componnets

- cd shared
- ./install.sh

### Install of mobius componnets

- cd mobius
- ./install.sh

### Remove shared componnets with the namespece associated. The cluster and images are maintained

- cd shared
- ./remove.sh

### Remove mobius componnets with the namespece associated. The cluster and images are maintained

- cd mobius
- ./remove.sh
