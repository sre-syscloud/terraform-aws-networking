resource "aws_subnet" "public_subnet" {
  vpc_id                  = local.vpc_id
  for_each                = var.public_subnet_details
  cidr_block              = each.value["cidr"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true
  tags = merge(each.value["custom_tags"],{
    Name        = each.value["name"]
    Iaac        = "Terraform"
  })
}