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

devops-demo/
├── modules/
│   ├── network/                # Reusable module for networking setup
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── kubernetes/             # Module for Kubernetes resources
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   └── app/                    # Optional app deployment (e.g., Nginx)
│       ├── deployment.tf
│       ├── service.tf
│       ├── variables.tf
│       ├── outputs.tf
│
├── environments/
│   ├── dev/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   ├── provider.tf
│   │   └── backend.tf          # Defines state backend (Terraform Cloud or local)
│   ├── staging/
│   │   ├── main.tf
│   │   ├── terraform.tfvars
│   └── prod/
│       ├── main.tf
│       ├── terraform.tfvars
│
├── scripts/
│   ├── init.sh                 # Automates terraform init & validate
│   ├── plan.sh                 # Runs terraform plan
│   ├── apply.sh                # Runs terraform apply with safety prompts
│   └── destroy.sh              # Destroys infrastructure safely
│
├── ci-cd-pipelines/
│   ├── github-actions.yml      # CI/CD pipeline for automation (optional)
│   ├── gitlab-ci.yml
│
├── diagrams/
│   └── architecture.png        # Visual representation for documentation
│
├── README.md                   # Overview, setup steps, and usage
└── .gitignore



Purpose of Each Section

modules/:
Holds reusable Terraform modules (network, Kubernetes cluster, app). Modules make your code modular, maintainable, and easier to reuse across environments.

environments/:
Defines separate configuration per environment (dev, staging, prod).
Each folder reuses modules and has its own variable files, ensuring isolation.

scripts/:
Provides automation for common Terraform operations.
These scripts simulate automation pipelines for local testing or CI/CD usage.

ci-cd-pipelines/:
Stores CI/CD config files for GitHub Actions, GitLab, or Jenkins.
Demonstrates automation and infrastructure pipeline management.

diagrams/:
Contains architecture diagrams explaining infrastructure flow — this improves employer presentation clarity.