resource "aws_internet_gateway" "ig" {
  count   = var.create_internet_gateway ? 1 : 0
  vpc_id  = local.vpc_id
  tags    = {
    Name  = var.internet_gateway_name
    Iaac  = "terraform" 
  }
}