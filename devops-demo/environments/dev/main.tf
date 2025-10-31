terraform {
  required_version = ">= 1.5.0"
}

module "kubernetes" {
  source    = "../../modules/kubernetes"
  namespace = "devops-demo"
}

output "local_resources" {
  value = {
    bucket_name = "skipped-due-to-localstack-issues"
    namespace   = module.kubernetes.namespace
  }
}
