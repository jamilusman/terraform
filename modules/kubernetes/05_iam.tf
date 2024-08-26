# IAM role for the EKS cluster, allowing the EKS service to assume this role
resource "aws_iam_role" "eks_iam" {
  name = "ppro_demo_eks_iam_${var.stage_name}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
}

# Attaches the AmazonEKSClusterPolicy to the EKS IAM role, enabling necessary permissions for the EKS cluster
resource "aws_iam_role_policy_attachment" "eks-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_iam.name
}

# IAM role for the worker nodes, allowing EC2 instances to assume this role
resource "aws_iam_role" "nodes_iam" {
  name = "ppro_demo_nodes_iam_${var.stage_name}"

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
}

# Attaches necessary policies to the worker node IAM role, including permissions for EKS worker nodes, and CNI
resource "aws_iam_role_policy_attachment" "eks_node_group_policy_attachments" {
  for_each = {
    "AmazonEKSWorkerNodePolicy"          = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
    "AmazonEKS_CNI_Policy"               = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
    "AmazonEC2ContainerRegistryReadOnly" = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  }

  policy_arn = each.value
  role       = aws_iam_role.nodes_iam.name
}

# Retrieves the TLS certificate for the EKS cluster's OpenID Connect (OIDC) provider
data "tls_certificate" "tls" {
  url = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}

# Creates an OpenID Connect (OIDC) provider for the EKS cluster, allowing the cluster to use IAM roles for service accounts
resource "aws_iam_openid_connect_provider" "openid" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.tls.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks_cluster.identity[0].oidc[0].issuer
}