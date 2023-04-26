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
  ./rockcluster.sh imgls

- Review variables in "./env.sh", example:
      TF_VAR_MOBIUS_VIEW_URL = "mobius12.local.net"

   in "./env.sh", and add these values to /etc/hosts c:/windows/system32/drivers/etc/hosts
  with the IP where the custer will run, example:

     192.168.0.5     mobius12.local.net 

## Installation sequence

1; Install k3d, helm, kubectl and terraform

- ./rockcluster.sh install

2; set environment

- source env.sh

3; Create the cluster for mobius, and pull images from registry.rocketsoftware.com

- ./rockcluster.sh create

4; Initilize Terraform providers

- cd ../mobius
- terraform init

5; Install shared namespace with: postgres, kafka, elasticsearch

- cd shared
- ./install.sh

6; Install mobius-server and mobius-view

- cd mobius
- terraform init
- ./install.sh

## Summary of commands

|---------------------------|-----------------------------------------------------------------|
| rockcluster.sh on         | start mobius cluster
| rockcluster.sh off        | stop mobius cluster
| rockcluster.sh pgport     | Open postgres port if active for remote access from other tools
| rockcluster.sh imgls      | list images from registry.rocketsoftware.com
| rockcluster.sh imgpull    | pull images from registry.rocketsoftware.com
| rockcluster.sh list       | list clusters
| rockcluster.sh create     | create mobius cluster
| rockcluster.sh remove     | remove mobius cluster
| rockcluster.sh debug      | generate outputs for get/describe of each kubernetes resources
| rockcluster.sh install    | install k3d, kubectl, helm, and terraform

### Install of shared componnets

- cd shared
- ./install.sh
### Remove shared componnets with the namespece associated. The cluster and images are maintained

- cd shared
- ./remove.sh

### Install of mobius componnets

- cd mobius
- ./install.sh

### Remove mobius componnets with the namespece associated. The cluster and images are maintained

- cd mobius
- ./remove.sh
