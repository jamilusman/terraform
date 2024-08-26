# Defines an EKS node group within the specified cluster.
# - The node group uses the provided IAM role and is deployed in the specified subnets.
# - It attaches security groups to the nodes for remote access.
# - The node group is configured with on-demand instances, using t2.micro instance types.
# - Scaling is set with a desired size of 1, and a max of 5 instances.
# - Dependencies ensure policies are attached before creating the node group.

resource "aws_eks_node_group" "private-nodes" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = var.nodes_group_name
  node_role_arn   = aws_iam_role.nodes_iam.arn

  subnet_ids = local.subnet_ids

  # Attach security groups to the EKS nodes
  remote_access {
    source_security_group_ids = [aws_security_group.eks_public_sg.id]
  }

  capacity_type  = "ON_DEMAND"
  instance_types = ["t2.micro"]

  scaling_config {
    desired_size = var.scaling_config.desired_size
    max_size     = var.scaling_config.max_size
    min_size     = var.scaling_config.min_size
  }

  update_config {
    max_unavailable = 1
  }

  labels = {
    role = "general"
  }


  depends_on = [
    aws_iam_role_policy_attachment.eks_node_group_policy_attachments["AmazonEKSWorkerNodePolicy"],
    aws_iam_role_policy_attachment.eks_node_group_policy_attachments["AmazonEKS_CNI_Policy"],
    aws_iam_role_policy_attachment.eks_node_group_policy_attachments["AmazonEC2ContainerRegistryReadOnly"],
  ]
}