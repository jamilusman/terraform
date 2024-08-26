variable "cluster_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

variable "environment" {
  description = "The environment (e.g., qa, prd)."
  type        = string
}

variable "stage_name" {
  description = "The name of the stage to deploy (qa, rel, prd)"
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
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

variable "nodes_group_name" {
  description = "The name of the nodes group that gets created by the deployment (should not exist yet)"
  type        = string
}

variable "scaling_config" {
  description = "Configuration for scaling the EKS node group"
  type        = object({
    desired_size = number
    max_size     = number
    min_size     = number
  })
}