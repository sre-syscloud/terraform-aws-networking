locals {
    subnet_list = flatten([
        for nacl_key,nacl_value in var.network_acl_details : [
            for sn_name in nacl_value["subnet_names"] : {
                subnet_name = sn_name
                key = nacl_key
            }
        ]
    ])
    subnets = { for sn in local.subnet_list : sn.subnet_name => sn}
}

data "aws_subnet" "nacl_subnet_id" {
  for_each = local.subnets
  tags = {
    Name = each.value["subnet_name"]
  }
}

resource "aws_network_acl" "network_acl" {
    for_each    = var.network_acl_details
    vpc_id      = local.vpc_id
    dynamic "egress" {
        for_each = each.value["egress_rules"]
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
        for_each = each.value["ingress_rules"]
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
        Name = each.value["nacl_name"]
        Iaac = "terraform"
    }
}

resource "aws_network_acl_association" "nacl_subnet_association" {
    for_each = local.subnets
    network_acl_id = aws_network_acl.network_acl[each.value.key].id
    subnet_id      = data.aws_subnet.nacl_subnet_id[each.key].id
}

