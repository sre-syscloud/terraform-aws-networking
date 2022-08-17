resource "aws_security_group" "public-sg" {
  count       = var.create_public_security_group ? 1 : 0
  name        = "sys-public-sg"
  description = "Public Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.Environment}-public-sg"
  }
  dynamic "ingress" {
    for_each = var.public_all_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.public_all_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}

resource "aws_security_group" "private-sg" {
  count       = var.create_private_security_group ? 1 : 0
  name        = "sys-private-sg"
  description = "Private Security Group"
  vpc_id      = aws_vpc.vpc.id
  tags = {
    Name = "${var.Environment}-private-sg"
  }
  dynamic "ingress" {
    for_each = var.private_all_ingress_rules
    content {
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      description = ingress.value.description
      cidr_blocks = ingress.value.cidr_blocks
    }
  }
  dynamic "egress" {
    for_each = var.private_all_egress_rules
    content {
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      description = egress.value.description
      cidr_blocks = egress.value.cidr_blocks
    }
  }
}