#!/bin/bash
set -e

echo "Updating and installing dependencies..."
sudo apt-get update && sudo apt-get install -y \
  unzip curl wget jq python3-pip awscli apt-transport-https ca-certificates curl software-properties-common

echo "Installing Terraform..."
TERRAFORM_VERSION="1.4.6"
wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
sudo mv terraform /usr/local/bin/
rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip

echo "Installing kubectl..."
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
rm kubectl

echo "Installing cloudflared..."
curl -LO https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb
sudo dpkg -i cloudflared-linux-amd64.deb
rm cloudflared-linux-amd64.deb

echo "Installing LocalStack..."
pip3 install localstack

echo "Starting LocalStack in background..."
nohup localstack start &

echo "Configuring environment variables..."
export AWS_ACCESS_KEY_ID=test
export AWS_SECRET_ACCESS_KEY=test
export AWS_REGION=us-east-1
export AWS_DEFAULT_REGION=us-east-1
export LOCALSTACK_HOST=localhost
export AWS_ENDPOINT_URL=http://localhost:4566

echo "Setup complete. You can now use Terraform, kubectl, AWS CLI, LocalStack, and Cloudflare Tunnel in this container."
