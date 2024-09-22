resource "aws_security_group" "private-sg" {
    count       = length(var.private_security_group_details)
    name        = var.private_security_group_details[count.index].name
    description = var.private_security_group_details[count.index].description  
    vpc_id      = local.vpc_id
    tags                    = {
        Name = var.private_security_group_details[count.index].name
        Iaac = "Terraform" 
    }
    dynamic "ingress" {
        for_each = var.private_security_group_details[count.index].private_all_ingress_rules
        content {
            from_port   = ingress.value.from_port
            to_port     = ingress.value.to_port
            protocol    = ingress.value.protocol
            description = ingress.value.description
            cidr_blocks = ingress.value.cidr_blocks
        }
    }
    dynamic "egress" {
        for_each = var.private_security_group_details[count.index].private_all_egress_rules
        content {
            from_port   = egress.value.from_port
            to_port     = egress.value.to_port
            protocol    = egress.value.protocol
            description = egress.value.description
            cidr_blocks = egress.value.cidr_blocks
        }
    }
}