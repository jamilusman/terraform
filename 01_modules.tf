# This Terraform module is responsible for deploying and configuring the Kubernetes cluster.
# It sources the Kubernetes module from a relative path ("./modules/kubernetes").
module "kubernetes" {
  source = "./modules/kubernetes"
  cluster_name = var.cluster_name
  tags         = var.resource_tags
  scaling_config = var.scaling_config

  environment                = var.environment
  stage_name                 = var.stage_name
  vpc_cidr_block             = var.vpc_cidr_block
  availability_zones         = var.availability_zones
  private_subnet_cidr_blocks = var.private_subnet_cidr_blocks
  public_subnet_cidr_blocks  = var.public_subnet_cidr_blocks
  nodes_group_name           = "ppro-demo-nodes-rg-${var.stage_name}"
}