#!/bin/bash
export KUBECONFIG=~/.kube/config
helm install postgresdb postgres/ --namespace=acme --create-namespace --wait