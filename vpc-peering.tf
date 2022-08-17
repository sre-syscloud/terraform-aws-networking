resource "aws_vpc_peering_connection" "peering" {
  for_each      = var.create_peering_connection == true ? var.peering_connection : {}
  peer_owner_id = var.different_account_peering_connection == true ? each.value["peer_owner_id"] : null
  peer_vpc_id   = each.value["peer_vpc_id"]
  vpc_id        = aws_vpc.vpc.id
  peer_region   = each.value["peer_region"]
  tags = {
    Name = each.value["peering_name"]
  }
}