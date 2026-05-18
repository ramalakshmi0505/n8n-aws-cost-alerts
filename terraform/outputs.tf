output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "EKS cluster name"
  value       = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster endpoint"
  value       = module.eks.cluster_endpoint
}

output "n8n_url" {
  description = "n8n URL (LoadBalancer DNS)"
  value       = "http://${module.n8n.n8n_service_hostname}"
}

output "lambda_function_name" {
  description = "Lambda function name for cost checking"
  value       = aws_lambda_function.cost_checker.function_name
}

output "configure_kubectl" {
  description = "Command to configure kubectl"
  value       = "aws eks update-kubeconfig --region ${var.aws_region} --name ${module.eks.cluster_name}"
}
