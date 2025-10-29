# DevOps Makefile: Terraform workflows, linting, and security checks

SHELL := /bin/bash
.DEFAULT_GOAL := help

# Usage:
#   make help
#   make init ENV=dev
#   make plan ENV=staging
#   make apply ENV=prod
#   make tfsec ENV=dev

# Default environment can be overridden: ENV=dev|staging|prod
ENV ?= dev
STACK := devops-demo/environments/$(ENV)

TF := terraform
TF_CMD := $(TF) -chdir=$(STACK)

PLAN_FILE := plan.out

.PHONY: help init validate plan plan-destroy show apply destroy output fmt fmt-check tflint tfsec checkov cost precommit-install clean bootstrap env-list print-stack

help:
	@echo "DevOps Makefile"
	@echo "Targets:"
	@echo "  help                Show this help"
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
	@echo "  tflint              Run tflint against current ENV stack"
	@echo "  tfsec               Run tfsec security scan on current ENV stack"
	@echo "  checkov             Run Checkov security scan on current ENV stack"
	@echo "  cost                Infracost breakdown for current ENV stack"
	@echo "  precommit-install   Install pre-commit hooks (if pre-commit is installed)"
	@echo "  clean               Remove generated plan file"
	@echo "  bootstrap           Run fmt, init, validate, tflint, tfsec, checkov"
	@echo "  env-list            List available environments"
	@echo "  print-stack         Print the resolved stack directory"
	@echo "\nVariables: ENV={dev|staging|prod} (default: dev)"

init:
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

bootstrap: fmt init validate tflint tfsec checkov

env-list:
	@ls -1 devops-demo/environments | sed 's/^/- /'

print-stack:
	@echo $(STACK)


