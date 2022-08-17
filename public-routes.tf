resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name        = "${var.Environment}-public-route-table"
    Environment = "${var.Environment}"
  }
}


resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "rt_public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id
}

resource "aws_route" "public_peering_route" {
  for_each                  = var.create_peering_route == true ? var.peering_route : {}
  route_table_id            = aws_route_table.public.id
  destination_cidr_block    = each.value["destination_cidr_block"]
  vpc_peering_connection_id = aws_vpc_peering_connection.peering[each.key].id
}


