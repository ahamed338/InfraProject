#!/bin/bash

# Get the environment name from the first argument, default to 'dev' if not provided
ENV=${1:-dev}

echo "Initializing Terraform for environment: $ENV"

# Construct the path dynamically based on environment
TARGET_DIR="../environments/$ENV"

# Check if target directory exists
if [ -d "$TARGET_DIR" ]; then
  cd "$TARGET_DIR" || { echo "Failed to cd to $TARGET_DIR"; exit 1; }
  terraform destroy -auto-approve
else
  echo "Directory $TARGET_DIR does not exist. Please provide a valid environment."
  exit 1
fi
