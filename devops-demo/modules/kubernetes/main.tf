terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.32.0"
    }
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "kind-kind" # Works with local minikube/kind
}

resource "kubernetes_namespace" "devops_demo" {
  metadata {
    name = "devops-demo"
  }
}

resource "kubernetes_deployment" "nginx" {
  metadata {
    name      = "nginx-demo"
    namespace = kubernetes_namespace.devops_demo.metadata[0].name
  }

  spec {
    replicas = 1
    selector {
      match_labels = {
        app = "nginx"
      }
    }
    template {
      metadata {
        labels = {
          app = "nginx"
        }
      }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port {
            container_port = 80
          }
        }
      }
    }
  }
}

output "namespace" {
  value = kubernetes_namespace.devops_demo.metadata[0].name
}
