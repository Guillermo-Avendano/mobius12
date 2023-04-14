#!/bin/bash

if ! [[ docker --version ]]; then
   # install docker 
   # kubernetes.sh
   install_docker;
if

if ! [[ docker-compose --version ]]; then
   # install docker 
   # kubernetes.sh
   install_docker_compose;
if

if ! [[ k3d --version ]]; then
   # install k3d 
   # kubernetes.sh
   install_k3d;
if

if ! [[ kubectl version ]]; then
   # install kubectl
   # kubernetes.sh
   install_kubectl;
if

if ! [[ helm version ]]; then
   # Install helm (from https://helm.sh/docs/intro/install/)
   # /kubernetes.sh
   install_helm;
if

if ! [[ terraform -version ]]; then
   # Install Terraform
   # common/kubernetes.sh
   install_terraform;
if





