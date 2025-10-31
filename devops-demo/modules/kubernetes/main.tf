variable "namespace" {
  type    = string
  default = "devops-demo"
}

# These resources will fail until we have a running Kubernetes cluster
resource "kubernetes_namespace" "devops_demo" {
  count = var.enable_k8s ? 1 : 0

  metadata {
    name = var.namespace
  }
}

resource "kubernetes_deployment" "nginx" {
  count = var.enable_k8s ? 1 : 0

  metadata {
    name      = "nginx-demo"
    namespace = var.namespace
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
  value = var.namespace
}