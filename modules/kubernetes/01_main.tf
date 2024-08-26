# Combine the private and public subnet IDs into a single list
locals {
  private_subnet_ids = aws_subnet.private_snet[*].id
  public_subnet_ids  = aws_subnet.public_snet[*].id
  subnet_ids         = concat(local.private_subnet_ids, local.public_subnet_ids)

  subnet_associations = {
    "private_eu_central_1a" = {
      subnet_id = element(aws_subnet.private_snet[*].id, 0)
      rtb_id    = aws_route_table.private_rtb.id
    }
    "private_eu_central_1b" = {
      subnet_id = element(aws_subnet.private_snet[*].id, 1)
      rtb_id    = aws_route_table.private_rtb.id
    }
    "public_eu_central_1a" = {
      subnet_id = element(aws_subnet.public_snet[*].id, 0)
      rtb_id    = aws_route_table.public_rtb.id
    }
    "public_eu_central_1b" = {
      subnet_id = element(aws_subnet.public_snet[*].id, 1)
      rtb_id    = aws_route_table.public_rtb.id
    }
  }
}