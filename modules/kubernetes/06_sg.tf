# Security group for public-facing resources (e.g., EKS nodes that need public access)
resource "aws_security_group" "eks_public_sg" {
  vpc_id = aws_vpc.vpc.id

  # Inbound rules for public-facing EKS nodes
  ingress {
    description      = "Allow all inbound traffic within the VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  ingress {
    description      = "Allow SSH access"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # This can be adjusted to only necessary IP ranges, Ports and Protocols depending on the requirements
  }

  # Outbound rules for public-facing EKS nodes
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1" 
    cidr_blocks      = ["0.0.0.0/0"] # This can be adjusted to only necessary IP ranges, Ports and Protocols depending on the requirements
  }

  tags = var.tags
}

# Security group for private EKS nodes (if applicable)
resource "aws_security_group" "eks_private_sg" {
  vpc_id = aws_vpc.vpc.id

  # Inbound rules for private EKS nodes
  ingress {
    description      = "Allow all inbound traffic within the VPC"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [aws_vpc.vpc.cidr_block]
  }

  # Outbound rules for private EKS nodes
  egress {
    description      = "Allow all outbound traffic"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"] # This can be adjusted to only necessary IP ranges, Ports and Protocols depending on the requirements
  }

  tags = var.tags
}