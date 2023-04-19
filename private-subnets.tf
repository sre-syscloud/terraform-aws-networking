resource "aws_subnet" "private_subnet" {
  vpc_id                  = local.vpc_id
  for_each                = var.private_subnet_details
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = false
  tags = {
    Name        = each.value["name"]
    Iaac        = "terraform"
  }
}