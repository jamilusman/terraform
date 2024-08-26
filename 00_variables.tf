variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., qa, prd)."
  type        = string
}

variable "stage_name" {
  type = string
  validation {
    condition     = contains(["qa", "prd"], var.stage_name)
    error_message = "Valid values for var: test_variable are (qa, or prd)."
  }
}

variable "resource_tags" {
  description = "Default resource tags"
  type        = map(string)
  default = {
    Owner   = "Jamilusman"
    Product = "PPRO 1.0"
    Type    = "IAC"
  }
}

variable "vpc_cidr_block" {
  type        = string
  description = "The VPC CIDR block"
}

variable "private_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the private subnets."
  type        = list(string)
}

variable "public_subnet_cidr_blocks" {
  description = "List of CIDR blocks for the public subnets."
  type        = list(string)
}

variable "availability_zones" {
  description = "List of availability zones for the subnets."
  type        = list(string)
}

variable "scaling_config" {
  description = "Configuration for scaling the EKS node group"
  type        = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}