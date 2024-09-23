output "vpc_id" {
  value = var.create_vpc && length(aws_vpc.vpc) > 0 ? aws_vpc.vpc[0].id : ""
  description = "The ID of the VPC."
}

output "peering_connection_id" {
  value = var.create_peering_connection == true ? [for pc in aws_vpc_peering_connection.peering : pc.id] : []
  description = "ID of the VPC Peering Connection"
  sensitive   = false
}
