resource "aws_default_network_acl" "vpc_acl" {
  count      = var.create_network_acl ? 1 : 0
  default_network_acl_id = aws_vpc.vpc.default_network_acl_id
  subnet_ids = flatten([aws_subnet.public_subnet[*].id, aws_subnet.private_subnet[*].id])
  dynamic "egress" {
    for_each = var.network_acl_rules_egress
    content {
      action     = egress.value.action
      cidr_block = egress.value.cidr_block
      protocol   = egress.value.protocol
      from_port  = egress.value.from_port
      rule_no    = egress.value.rule_no
      to_port    = egress.value.to_port
    }
  }
  dynamic "ingress" {
    for_each = var.network_acl_rules_ingress
    content {
      action     = ingress.value.action
      cidr_block = ingress.value.cidr_block
      protocol   = ingress.value.protocol
      from_port  = ingress.value.from_port
      rule_no    = ingress.value.rule_no
      to_port    = ingress.value.to_port
    }
  }
  tags = {
    Name = "${var.Environment}-Nacl"
  }
}