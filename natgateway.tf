locals {
  nat_subnet_details = var.create_nat_gateway ? split("/",data.aws_subnet.nat_subnet[0].arn) : null
  nat_subnet_id = var.create_nat_gateway ? local.nat_subnet_details[1] : null
}

data "aws_subnet" "nat_subnet" {
  count = var.create_nat_gateway ? 1 : 0
  tags = {
    Name = var.nat_gateway_subnet_name
  }
  depends_on = [
    aws_subnet.public_subnet
  ]
}

resource "aws_nat_gateway" "nat" {
  count         = var.create_nat_gateway ? 1 : 0
  allocation_id = local.nat_eip_id
  subnet_id     = data.aws_subnet.nat_subnet[0].id
  depends_on    = [aws_internet_gateway.ig,aws_subnet.public_subnet]
  tags = {
    Name        = var.nat_gateway_name
    Iaac        = "Terraform"
  }
}

