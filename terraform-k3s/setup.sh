#!/bin/bash

# Install k3s
curl -sfL https://get.k3s.io | sh -

# Copy kube config to .kube
mkdir /root/.kube
cp /etc/rancher/k3s/k3s.yaml /root/.kube/config

# Install Flux CLI
curl -s https://fluxcd.io/install.sh | sudo bash

# Install some additional packages
dnf install -y vim wget git

# Set hostname
hostnamectl set-hostname k3s

# Install helm
wget https://get.helm.sh/helm-v3.12.1-linux-amd64.tar.gz
tar -xvf helm-v3.12.1-linux-amd64.tar.gz --strip-components 1 linux-amd64/helm
mv helm /usr/local/bin/
rm -f helm-v3.12.1-linux-amd64.tar.gz

# Install Flux Terraform Controller CLI
wget https://github.com/weaveworks/tf-controller/releases/download/v0.15.0-rc.5/tfctl_Linux_amd64.tar.gz
tar -zxvf tfctl_Linux_amd64.tar.gz tfctl
mv tfctl /usr/local/bin/
rm -f tfctl_Linux_amd64.tar.gz

# Install aliases
echo 'alias k="kubectl"' >> /root/.bashrc

# Install Flux (Replace with your repository values and github token)
export GITHUB_TOKEN="<your-token>"
flux bootstrap github --owner=<your-username> --repository=<your-repo> --path=clusters/my-cluster --personal
