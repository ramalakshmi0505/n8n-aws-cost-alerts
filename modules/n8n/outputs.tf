output "n8n_service_hostname" {
  description = "n8n service load balancer hostname"
  value       = kubernetes_service.n8n.status[0].load_balancer[0].ingress[0].hostname
}

output "n8n_namespace" {
  description = "n8n Kubernetes namespace"
  value       = kubernetes_namespace.n8n.metadata[0].name
}
