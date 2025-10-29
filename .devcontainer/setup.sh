#!/bin/bash
set -e

echo "🚀 Setting up Kubernetes cluster..."

# Install k3d and kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
curl -s https://raw.githubusercontent.com/k3d-io/k3d/main/install.sh | bash

# Create k3d cluster
k3d cluster create devops-cluster \
  --agents 1 \
  --servers 1 \
  --port "8080:80@loadbalancer" \
  --wait

echo "✅ k3d cluster ready!"
kubectl cluster-info