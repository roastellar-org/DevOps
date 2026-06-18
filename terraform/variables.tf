variable "aws_region" {
  description = "AWS region for the cluster"
  type        = string
  default     = "ap-south-1"
}

variable "project_name" {
  description = "Project name used in resource naming"
  type        = string
  default     = "arenax"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.30"
}

variable "node_group" {
  description = "Node group sizing"
  type = object({
    desired_size = number
    min_size     = number
    max_size     = number
    instance_types = list(string)
  })
  default = {
    desired_size   = 2
    min_size       = 2
    max_size       = 6
    instance_types = ["t3.medium"]
  }
}
