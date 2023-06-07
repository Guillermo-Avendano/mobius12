#!/bin/bash
set -Eeuo pipefail
sudo apt-get -y update
sudo apt-get -y upgrade

#Install k3d (from https://k3d.io/)
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | TAG=v5.4.6 bash

#Install kubectl
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.21.2/2021-07-05/bin/linux/amd64/kubectl
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

#Install helm (from https://helm.sh/docs/intro/install/)
export DESIRED_VERSION=v3.8.2
curl -s https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
#Install docker-compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
