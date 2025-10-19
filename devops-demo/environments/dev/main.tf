terraform {
  required_version = ">= 1.5.0"
}

module "network" {
  source = "../../modules/network"
}

module "kubernetes" {
  source = "../../modules/kubernetes"
}

output "local_resources" {
  value = {
    bucket_name = module.network.bucket_name
    namespace   = module.kubernetes.namespace
  }
}
