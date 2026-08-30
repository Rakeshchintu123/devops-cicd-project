terraform {
  required_version = ">= 1.5.0"

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

resource "local_file" "deployment_info" {
  filename = "${path.module}/deployment-info.txt"

  content = <<-EOT
    Application: ${var.app_name}
    Environment: ${var.environment}
    Docker Image: ${var.docker_image}
    Kubernetes Namespace: ${var.kubernetes_namespace}
  EOT
}