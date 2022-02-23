#!/bin/bash

set -euo pipefail

####################################################################################
##### Specify software and dependencies that are required for this project     #####
#####                                                                          #####
##### Note:                                                                    #####
##### The working directory is /home/brev/<PROJECT_FOLDER_NAME>. Execution of  #####
##### this file happens at this level.                                         #####
####################################################################################

#### Install Gcloud ####
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-373.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-sdk-373.0.0-linux-x86_64.tar.gz
mv google-cloud-sdk ../
echo "" | sudo tee -a ~/.bashrc
echo "export PATH=\$PATH:/home/brev/workspace/google-cloud-sdk/bin" | sudo tee -a ~/.bashrc
echo "" | sudo tee -a ~/.zshrc
echo "export PATH=\$PATH:/home/brev/workspace/google-cloud-sdk/bin" | sudo tee -a ~/.zshrc
rm google-cloud-sdk-373.0.0-linux-x86_64.tar.gz

#### Install Kind ####
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

#### Create Kind Cluster ####
kind create cluster --image=nestybox/kindestnode:v1.20.7


#### Install Minikube ####
if (($(cat /proc/cpuinfo | grep processor | wc -l) > 2 )) && ls /dev/fuse > /dev/null; then
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
sudo install minikube-linux-amd64 /usr/local/bin/minikube

#### Create Minikube Cluster ####
minikube start --base-image=nestybox/minikube-kicbase:v0.0.28
else
echo "not installing minikube since insufficient CPU or /dev/fuse not available"
fi

#### Kubectl ####
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl