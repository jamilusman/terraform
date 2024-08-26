resource "aws_vpc" "vpc" {
  # The CIDR block for the VPC
  cidr_block = var.vpc_cidr_block

  # Makes the Instance shared on the host
  instance_tenancy = "default"

  # These arguments are required by EKS. Enable/Disable DNS Support and DNS Hostnames in the VPC
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = var.tags
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = var.tags
}

resource "aws_subnet" "private_snet" {
  count = length(var.private_subnet_cidr_blocks)

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = var.private_subnet_cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = var.tags
}

resource "aws_subnet" "public_snet" {
  count = length(var.public_subnet_cidr_blocks)

  vpc_id                  = aws_vpc.vpc.id
  cidr_block              = var.public_subnet_cidr_blocks[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = var.tags
}

resource "aws_eip" "nat" {
  tags = var.tags
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = element(aws_subnet.public_snet[*].id, 0)

  tags = var.tags

  depends_on = [aws_internet_gateway.igw]
}

resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block     = aws_vpc.vpc.cidr_block
      nat_gateway_id = aws_nat_gateway.nat.id
    }

  tags = var.tags
}

resource "aws_route_table" "public_rtb" {
  vpc_id = aws_vpc.vpc.id

  route {
      cidr_block = aws_vpc.vpc.cidr_block
      gateway_id = aws_internet_gateway.igw.id
    }

  tags = var.tags
}

resource "aws_route_table_association" "subnet_associations" {
  for_each      = local.subnet_associations
  subnet_id     = each.value.subnet_id
  route_table_id = each.value.rtb_id
}