data "aws_security_group" "source_sg" {
    for_each = var.sg_with_sg_rule
    name = each.value["source_security_group_name"]
    depends_on    = [aws_security_group.public-sg,aws_security_group.private-sg]
}

data "aws_security_group" "sg" {
    for_each = var.sg_with_sg_rule
    name = each.value["security_group_name"]
    depends_on    = [aws_security_group.public-sg,aws_security_group.private-sg]
}

resource "aws_security_group_rule" "sg_with_sg_rule" {
    for_each = var.sg_with_sg_rule
    type = each.value["rule_type"]
    from_port = each.value["from_port"]
    to_port = each.value["to_port"]
    protocol = each.value["protocol"]
    description = each.value["description"]
    source_security_group_id = data.aws_security_group.source_sg[each.key].id
    security_group_id = data.aws_security_group.sg[each.key].id
    depends_on    = [aws_security_group.public-sg,aws_security_group.private-sg]
}