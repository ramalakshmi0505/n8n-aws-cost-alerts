variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-1"
}

variable "project_name" {
  description = "Project name for resource naming"
  type        = string
  default     = "n8n-cost-alerts"
}

variable "environment" {
  description = "Environment (dev/staging/prod)"
  type        = string
  default     = "dev"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-1a", "eu-west-1b"]
}

variable "kubernetes_version" {
  description = "Kubernetes version"
  type        = string
  default     = "1.28"
}

variable "instance_type" {
  description = "EC2 instance type for EKS nodes"
  type        = string
  default     = "t3.medium"
}

variable "desired_capacity" {
  description = "Desired number of EKS nodes"
  type        = number
  default     = 2
}

variable "min_capacity" {
  description = "Minimum number of EKS nodes"
  type        = number
  default     = 1
}

variable "max_capacity" {
  description = "Maximum number of EKS nodes"
  type        = number
  default     = 3
}

variable "n8n_username" {
  description = "n8n basic auth username"
  type        = string
  sensitive   = true
}

variable "n8n_password" {
  description = "n8n basic auth password"
  type        = string
  sensitive   = true
}

variable "n8n_host" {
  description = "n8n hostname (will use LoadBalancer DNS if not provided)"
  type        = string
  default     = "n8n.example.com"
}

variable "cost_threshold" {
  description = "Daily cost threshold in USD for alerts"
  type        = number
  default     = 100
}
