locals {
  nat_eip_id = var.create_nat_eip ? aws_eip.nat_eip[0].id : (var.create_nat_gateway ? data.aws_eip.nat_eip_data[0].id : null)
}

data "aws_eip" "nat_eip_data" {
  count = var.create_nat_gateway ? 1 : 0
  tags = {
    Name = var.nat_eip_name
  }
  depends_on = [
    aws_eip.nat_eip
  ]
} 

resource "aws_eip" "nat_eip" {
  count                     = var.create_nat_eip ? 1 : 0
  vpc                       = true
  associate_with_private_ip = var.nat_eip_private_ip
  tags  = {
    Name = var.nat_eip_name
    Iaac = "terraform"
  }
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_eip" "eip" {
  for_each   = var.eip_details
  vpc        = true
  associate_with_private_ip = each.value["eip_private_ip"]
  instance = each.value["eip_instance_id"]
  tags  = {
    Name = each.value["eip_name"]
    Iaac = "terraform"
  }
  depends_on = [aws_internet_gateway.ig]
}
