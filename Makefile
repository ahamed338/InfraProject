# DevOps Makefile: Terraform workflows, linting, and security checks with LocalStack setup for Codespaces

SHELL := /bin/bash
.DEFAULT_GOAL := help

# ----------------------------
# Local environment variables
# ----------------------------
export AWS_ACCESS_KEY_ID = test
export AWS_SECRET_ACCESS_KEY = test
export AWS_DEFAULT_REGION = us-east-1
export LOCALSTACK_HOSTNAME = localhost
export EDGE_PORT = 4566
export SERVICES = s3,lambda,cloudformation,iam

# ----------------------------
# Default environment
# ----------------------------
ENV ?= dev
STACK := devops-demo/environments/$(ENV)
TF := terraform
TF_CMD := $(TF) -chdir=$(STACK)
PLAN_FILE := plan.out

.PHONY: help setup check-localstack start-localstack all init validate plan plan-destroy show apply destroy output fmt fmt-check tflint tfsec checkov cost precommit-install clean bootstrap env-list print-stack helm-lint helm-template

# ----------------------------
# Helper targets
# ----------------------------

help:
	@echo "DevOps Makefile"
	@echo "Targets:"
	@echo "  setup               Setup environment and start LocalStack (for Codespaces)"
	@echo "  all                 Run fmt, init, validate, plan, and apply"
	@echo "  init                Terraform init for ENV=$(ENV)"
	@echo "  validate            Terraform validate"
	@echo "  plan                Terraform plan (writes $(PLAN_FILE))"
	@echo "  plan-destroy        Terraform destroy plan (no apply)"
	@echo "  show                Show human-readable plan from $(PLAN_FILE)"
	@echo "  apply               Terraform apply (uses $(PLAN_FILE) if present)"
	@echo "  destroy             Terraform destroy"
	@echo "  output              Show Terraform outputs (JSON)"
	@echo "  fmt                 terraform fmt -recursive"
	@echo "  fmt-check           terraform fmt -recursive -check"
	@echo "  tflint              Run tflint"
	@echo "  tfsec               Run tfsec security scan"
	@echo "  checkov             Run Checkov security scan"
	@echo "  cost                Infracost breakdown"
	@echo "  precommit-install   Install pre-commit hooks"
	@echo "  clean               Remove generated plan file"
	@echo "  bootstrap           Run fmt, init, validate, tflint, tfsec, checkov"
	@echo "  env-list            List available environments"
	@echo "  print-stack         Print the resolved stack directory"
	@echo "  helm-lint           Helm lint for app chart"
	@echo "  helm-template       Helm template (no cluster needed)"
	@echo ""
	@echo "Variables: ENV={dev|staging|prod} (default: dev)"

# ----------------------------
# LocalStack management
# ----------------------------

check-localstack:
	@if docker ps --format '{{.Names}}' | grep -q '^localstack_main$$'; then \
		echo "✅ LocalStack is already running."; \
	else \
		echo "⚙️  LocalStack not running. Starting it now..."; \
		$(MAKE) start-localstack; \
	fi; \
	echo "⏳ Waiting for LocalStack services to be ready..."; \
	sleep 10; \
	curl -s http://localhost:4566/health | grep '"init_scripts": "initialized"' >/dev/null && \
	echo "✅ LocalStack is healthy." || echo "⚠️  LocalStack might still be starting."


start-localstack:
	@echo "🚀 Starting LocalStack using Docker Compose..."
	@docker-compose up -d localstack
	@echo "⏳ Waiting for LocalStack to initialize..."
	@sleep 10
	@curl -s http://localhost:4566/health | jq '.services.s3' || echo "⚠️ Could not verify LocalStack health (check docker logs)."

setup: check-localstack
	@echo "🔧 Environment setup complete for Codespaces."

# ----------------------------
# Terraform workflow
# ----------------------------

all: fmt setup init validate plan apply
	@echo "✅ All Terraform steps completed successfully for ENV=$(ENV)"

init: setup
	@echo "🔄 Initializing Terraform..."
	$(TF_CMD) init -upgrade

validate:
	$(TF_CMD) validate

plan:
	$(TF_CMD) plan -out=$(PLAN_FILE)
	@echo "Plan written to $(STACK)/$(PLAN_FILE)"

plan-destroy:
	$(TF_CMD) plan -destroy

show:
	@if [ -f "$(STACK)/$(PLAN_FILE)" ]; then \
		$(TF_CMD) show $(PLAN_FILE); \
	else \
		echo "No $(PLAN_FILE) found in $(STACK). Run 'make plan' first."; \
		exit 1; \
	fi

apply:
	@if [ -f "$(STACK)/$(PLAN_FILE)" ]; then \
		$(TF_CMD) apply -input=false $(PLAN_FILE); \
	else \
		$(TF_CMD) apply -input=false -auto-approve; \
	fi

destroy:
	$(TF_CMD) destroy -auto-approve

output:
	$(TF_CMD) output -json

fmt:
	$(TF_CMD) fmt -recursive

fmt-check:
	$(TF_CMD) fmt -recursive -check

tflint:
	cd $(STACK) && tflint --init >/dev/null 2>&1 || true
	cd $(STACK) && tflint

tfsec:
	cd $(STACK) && tfsec .

checkov:
	cd $(STACK) && checkov -d .

cost:
	@command -v infracost >/dev/null 2>&1 || { echo "infracost not installed"; exit 1; }
	cd $(STACK) && infracost breakdown --path .

precommit-install:
	@command -v pre-commit >/dev/null 2>&1 && pre-commit install || echo "pre-commit not installed; skip"

clean:
	rm -f $(STACK)/$(PLAN_FILE)

bootstrap: fmt setup init validate tflint tfsec checkov

env-list:
	@ls -1 devops-demo/environments | sed 's/^/- /'

print-stack:
	@echo $(STACK)

# ----------------------------
# Helm
# ----------------------------
HELM_CHART ?= devops-demo/modules/app/helm

helm-lint:
	helm lint $(HELM_CHART)

helm-template:
	helm template demo $(HELM_CHART) --namespace default
