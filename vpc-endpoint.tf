locals {
  endpoint_policies = jsonencode({
    "Version" : "2008-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "*",
        "Resource" : "*"
      }
    ]
  })
  ep_keys = keys(var.vpc_endpoint_details)
  rt_association_list = flatten([
    for ep_key,ep_value in var.vpc_endpoint_details : [
      for rt_name in ep_value["route_table_names"] : {
        route_table_name = rt_name
        index = index(local.ep_keys,ep_key)
      }
    ]
  ])
  sn_association_list = flatten([
    for ep_key,ep_value in var.vpc_endpoint_details : [
      for sn_name in ep_value["subnet_names"] : {
        subnet_name = sn_name
        index = index(local.ep_keys,ep_key)
      }
    ]
  ])
  sg_association_list = flatten([
    for ep_key,ep_value in var.vpc_endpoint_details : [
      for sg_name in ep_value["security_group_names"] : {
        security_group_name = sg_name
        index = index(local.ep_keys,ep_key)
      }
    ]
  ])
  rt_association = { for rt in local.rt_association_list : rt.route_table_name => rt}
  sn_association = { for sn in local.sn_association_list : sn.subnet_name => sn}
  sg_association = { for sg in local.sg_association_list : sg.security_group_name => sg}
}

data "aws_route_table" "route_table_id" {
  for_each = local.rt_association
  tags = {
    Name = each.value["route_table_name"]
  }
}

data "aws_subnet" "subnet_id" {
  for_each = local.sn_association
  tags = {
    Name = each.value["subnet_name"]
  }
}

data "aws_security_groups" "security_group_id" {
  for_each = local.sg_association
  tags = {
    Name = each.value["security_group_name"]
  }
}

resource "aws_vpc_endpoint" "vpc_endpoint" {
  for_each          = var.vpc_endpoint_details
  policy            = each.value["attach_endpoint_policies"] ? local.endpoint_policies : null
  vpc_id            = local.vpc_id
  service_name      = each.value["service_name"]
  vpc_endpoint_type = each.value["vpc_endpoint_type"]
  tags = {
    Name = each.value["endpoint_name"]
    Iaac = "terraform" 
  }
}

resource "aws_vpc_endpoint_route_table_association" "rt_association" {
  for_each          = local.rt_association
  vpc_endpoint_id   = aws_vpc_endpoint.vpc_endpoint[each.value.index].id
  route_table_id    = data.aws_route_table.route_table_id[each.key].id
} 

resource "aws_vpc_endpoint_subnet_association" "sn_association" {
  for_each          = local.sn_association
  vpc_endpoint_id   = aws_vpc_endpoint.vpc_endpoint[each.value.index].id
  subnet_id         = data.aws_subnet.subnet_id[each.key].id
}

resource "aws_vpc_endpoint_security_group_association" "sg_association" {
  for_each          = local.sg_association
  vpc_endpoint_id   = aws_vpc_endpoint.vpc_endpoint[each.value.index].id
  security_group_id = data.aws_security_groups.security_group_id[each.key].id
}