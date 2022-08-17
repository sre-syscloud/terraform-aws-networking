locals {
  endpoint_policies = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
}


resource "aws_vpc_endpoint" "s3" {
  count             = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  policy            = local.endpoint_policies
  vpc_id            = aws_vpc.vpc.id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"
}

resource "aws_vpc_endpoint_route_table_association" "private_s3" {
  count           = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  vpc_endpoint_id = aws_vpc_endpoint.s3[count.index].id
  route_table_id  = aws_route_table.private.id
}

resource "aws_vpc_endpoint_route_table_association" "public_s3" {
  count           = var.create_vpc && var.enable_s3_endpoint ? 1 : 0
  vpc_endpoint_id = aws_vpc_endpoint.s3[count.index].id
  route_table_id  = aws_route_table.public.id
}