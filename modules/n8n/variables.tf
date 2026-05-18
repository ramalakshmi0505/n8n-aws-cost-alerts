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
  description = "n8n hostname"
  type        = string
}
