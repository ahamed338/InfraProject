variable "k8s_host" {
  type        = string
  description = "Optional Kubernetes API endpoint (for non-local environments like Codespaces)"
  default     = ""
}

variable "namespace" {
  type    = string
  default = "devops-demo"
}

variable "enable_k8s" {
  description = "Whether to create Kubernetes resources (requires kubeconfig)."
  type        = bool
  default     = false
}
