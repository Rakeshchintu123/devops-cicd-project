output "application_name" {
  description = "Application name"
  value       = var.app_name
}

output "environment" {
  description = "Deployment environment"
  value       = var.environment
}

output "docker_image" {
  description = "Docker image"
  value       = var.docker_image
}

output "kubernetes_namespace" {
  description = "Kubernetes namespace"
  value       = var.kubernetes_namespace
}

output "deployment_info_file" {
  description = "Generated deployment information file"
  value       = local_file.deployment_info.filename
}