resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.Environment}-private-route-table"
    Environment = "${var.Environment}"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

resource "aws_route" "rt_private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

resource "aws_route" "private_peering_route" {
  for_each                  = var.create_peering_route == true ? var.peering_route : {}
  route_table_id            = aws_route_table.private.id
  destination_cidr_block    = each.value["destination_cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[each.key].id
}