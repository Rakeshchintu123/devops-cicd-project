variable "app_name" {
  description = "Application name"
  type        = string
  default     = "devops-cicd-app"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "development"
}

variable "docker_image" {
  description = "Docker image used by the application"
  type        = string
  default     = "rakeshvijay8413/devops-cicd-app:latest"
}

variable "kubernetes_namespace" {
  description = "Kubernetes namespace"
  type        = string
  default     = "default"
}