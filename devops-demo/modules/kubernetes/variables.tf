variable "k8s_host" {
  type        = string
  description = "Optional Kubernetes API endpoint (for non-local environments like Codespaces)"
  default     = ""
}
