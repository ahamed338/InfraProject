#!/bin/bash

# Define directories for DevOps demo project
PROJECT_DIR="devops-demo"

# Explicitly run mkdir commands to avoid literal braces
mkdir -p $PROJECT_DIR/modules/network
mkdir -p $PROJECT_DIR/modules/kubernetes
mkdir -p $PROJECT_DIR/modules/app

mkdir -p $PROJECT_DIR/environments/dev
mkdir -p $PROJECT_DIR/environments/staging
mkdir -p $PROJECT_DIR/environments/prod

mkdir -p $PROJECT_DIR/scripts
mkdir -p $PROJECT_DIR/ci-cd-pipelines
mkdir -p $PROJECT_DIR/diagrams

# Create placeholder Terraform and config files
touch $PROJECT_DIR/modules/network/{main.tf,variables.tf,outputs.tf}
touch $PROJECT_DIR/modules/kubernetes/{main.tf,variables.tf,outputs.tf}
touch $PROJECT_DIR/modules/app/{deployment.tf,service.tf,variables.tf,outputs.tf}

touch $PROJECT_DIR/environments/dev/{main.tf,terraform.tfvars,variables.tf,provider.tf,backend.tf}
touch $PROJECT_DIR/environments/staging/{main.tf,terraform.tfvars}
touch $PROJECT_DIR/environments/prod/{main.tf,terraform.tfvars}

touch $PROJECT_DIR/scripts/{init.sh,plan.sh,apply.sh,destroy.sh}
touch $PROJECT_DIR/ci-cd-pipelines/{github-actions.yml,gitlab-ci.yml}
touch $PROJECT_DIR/diagrams/architecture.png

touch $PROJECT_DIR/.gitignore

# Create README.md with project documentation
cat << 'EOF' > $PROJECT_DIR/README.md
# DevOps Demo Project

This project demonstrates Terraform and Kubernetes setup with a modular structure.

## Structure
- modules/: Contains reusable Terraform modules for network, Kubernetes cluster, and apps.
- environments/: Environment-wise configurations (dev, staging, prod).
- scripts/: Helper scripts to automate Terraform operations.
- ci-cd-pipelines/: Example CI/CD workflows for Terraform and Kubernetes.
- diagrams/: Architecture visuals.

## Getting Started
1. Navigate to an environment folder, e.g., environments/dev.
2. Run `./scripts/init.sh` to initialize Terraform.
3. Use `./scripts/plan.sh` and `./scripts/apply.sh` to preview and apply infrastructure changes.
4. Destroy resources using `./scripts/destroy.sh`.

## Future Enhancements
- Add CI/CD pipelines using GitHub Actions or GitLab CI.
- Integrate Localstack or a cloud provider.
- Automate Kubernetes deployments.
EOF

echo "Project directory structure created successfully."
