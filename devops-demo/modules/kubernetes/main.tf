variable "namespace" {
  type    = string
  default = "devops-demo"
}

# These resources will fail until we have a running Kubernetes cluster
resource "kubernetes_namespace" "devops_demo" {
  metadata {
    name = var.namespace
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