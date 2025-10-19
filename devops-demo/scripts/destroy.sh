#!/bin/bash
echo "Destroying Terraform-managed resources..."
terraform destroy -auto-approve
