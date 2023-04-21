locals {
    private_rt_subnet_list = flatten([
        for rt_key,rt_value in var.private_route_table_details : [
            for sn_name in rt_value["rt_subnet_association"] : {
                subnet_name = sn_name
                key         = rt_key
            }
        ]
    ]) 
    private_rt_subnets = { for sn in local.private_rt_subnet_list : sn.subnet_name => sn}
    private_peering_route_list = flatten([
      for rt_key,rt_value in var.private_route_table_details : [
        for peer_conn in rt_value["peering_connections"] : {
          peering_connection_name = peer_conn["connection_name"]
          destination_cidr_block  = peer_conn["destination_cidr_block"]
          key                     = rt_key
        }
      ]
    ])
    private_peering_routes = { for peer in local.private_peering_route_list : peer.peering_connection_name => peer}
    private_vpn_gateway_list = flatten([
      for rt_key,rt_value in var.private_route_table_details : [
        for gateway in rt_value["vpn_gateway_names"] : {
          vpn_gateway_name = gateway
          key              = rt_key
        }
      ]
    ])
    private_vpn_gateway = { for gateway in local.private_vpn_gateway_list : gateway.vpn_gateway_name => gateway}
}

data "aws_subnet" "private_rt_subnet_id" {
  for_each = local.private_rt_subnets
  tags = {
    Name = each.value["subnet_name"]
  }
  depends_on    = [aws_subnet.private_subnet]
}

data "aws_nat_gateway" "nat_gateway" {
  for_each  = var.private_route_table_details
  tags = {
    Name = each.value["nat_gateway_name"]
  }
  depends_on = [
    aws_nat_gateway.nat
  ]
}

data "aws_vpc_peering_connection" "private_peering_connection_id" {
  for_each = local.private_peering_routes
  tags = {
    Name = each.value["peering_connection_name"]
  }
  depends_on = [aws_vpc_peering_connection.peering]
}

data "aws_vpn_gateway" "private_vpn_gateway" {
  for_each = local.private_vpn_gateway
  tags = {
    Name = each.value["vpn_gateway_name"]
  }
  depends_on = [aws_vpc_endpoint.vpc_endpoint]
}

resource "aws_route_table" "private_route_table" {
  for_each  = var.private_route_table_details
  vpc_id    = local.vpc_id
  tags = {
    Name        = each.value["route_table_name"]
    Iaac        = "terraform"
  }
}

resource "aws_route_table_association" "private_rt_association" {
  for_each        = local.private_rt_subnets
  route_table_id  = aws_route_table.private_route_table[each.value.key].id
  subnet_id       = data.aws_subnet.private_rt_subnet_id[each.key].id
} 

resource "aws_route" "private_igw" {
  for_each               = var.private_route_table_details
  route_table_id         = aws_route_table.private_route_table[each.key].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_nat_gateway.nat_gateway[each.key].id
}

resource "aws_route" "private_peering_route" {
  for_each                  = local.private_peering_routes
  route_table_id            = aws_route_table.private_route_table[each.value.key].id
  destination_cidr_block    = each.value["destination_cidr_block"]
  vpc_peering_connection_id = data.aws_vpc_peering_connection.private_peering_connection_id[each.key].id
}

resource "aws_vpn_gateway_route_propagation" "private_vpn_gateway" {
  for_each          = local.private_vpn_gateway
  vpn_gateway_id    = data.aws_vpn_gateway.private_vpn_gateway[each.key].id
  route_table_id    = aws_route_table.private_route_table[each.value.key].id
}

