#!/bin/bash
set -e

echo "Waiting for LocalStack to start..."
sleep 10 # adjust if needed

# Create S3 bucket in LocalStack if not exists
aws --endpoint-url=http://localhost:4566 s3 mb s3://terraform-demo-bucket || true

echo "Setup complete. Ready to run Terraform, Kubernetes, and Cloudflare Tunnel commands."
