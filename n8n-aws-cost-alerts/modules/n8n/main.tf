# n8n Deployment Module

resource "kubernetes_namespace" "n8n" {
  metadata {
    name = "n8n"
  }
}

resource "kubernetes_persistent_volume_claim" "n8n" {
  metadata {
    name      = "n8n-data"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

resource "kubernetes_deployment" "n8n" {
  metadata {
    name      = "n8n"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        app = "n8n"
      }
    }

    template {
      metadata {
        labels = {
          app = "n8n"
        }
      }

      spec {
        container {
          name  = "n8n"
          image = "n8nio/n8n:latest"

          port {
            container_port = 5678
          }

          env {
            name  = "N8N_BASIC_AUTH_ACTIVE"
            value = "true"
          }

          env {
            name  = "N8N_BASIC_AUTH_USER"
            value = var.n8n_username
          }

          env {
            name  = "N8N_BASIC_AUTH_PASSWORD"
            value = var.n8n_password
          }

          env {
            name  = "N8N_HOST"
            value = var.n8n_host
          }

          env {
            name  = "WEBHOOK_URL"
            value = "https://${var.n8n_host}/"
          }

          volume_mount {
            name       = "n8n-data"
            mount_path = "/home/node/.n8n"
          }

          resources {
            requests = {
              cpu    = "500m"
              memory = "512Mi"
            }
            limits = {
              cpu    = "1000m"
              memory = "1Gi"
            }
          }
        }

        volume {
          name = "n8n-data"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.n8n.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "n8n" {
  metadata {
    name      = "n8n"
    namespace = kubernetes_namespace.n8n.metadata[0].name
  }

  spec {
    selector = {
      app = "n8n"
    }

    port {
      port        = 80
      target_port = 5678
    }

    type = "LoadBalancer"
  }
}
