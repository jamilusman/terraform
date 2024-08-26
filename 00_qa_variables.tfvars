# Configuration for a QA EKS cluster:
# - Defines the cluster name and VPC CIDR block.
# - Specifies CIDR blocks for private and public subnets.
# - Lists the availability zones where the cluster will be deployed.
cluster_name               = "ppro-demo-eks-qa"
vpc_cidr_block             = "10.0.0.0/16"
private_subnet_cidr_blocks = ["10.0.0.0/19", "10.0.32.0/19"]
public_subnet_cidr_blocks  = ["10.0.64.0/19", "10.0.96.0/19"]
availability_zones         = ["eu-central-1a", "eu-central-1b"]
environment                = "qa"

resource_tags = {
  Owner   = "Jamilusman"
  Product = "PPRO 1.0"
  Type    = "IAC"
}

scaling_config = {
  desired_size = 1
  max_size     = 3
  min_size     = 0
}