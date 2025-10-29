terraform {
  required_version = ">= 1.5.0"
}

module "network" {
  source = "../../modules/network"
}

output "local_resources" {
  value = {
    bucket_name = module.network.bucket_name
    namespace   = module.kubernetes.namespace
  }
}

module "kubernetes" {
  source   = "../../modules/kubernetes"
  k8s_host = "" # or "http://localhost:8080" if you have a local cluster
}
