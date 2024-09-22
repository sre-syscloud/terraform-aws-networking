locals {
  vpc_details = var.create_vpc ? null : split("/",data.aws_vpc.vpc[0].arn)
  vpc_id = var.create_vpc ? aws_vpc.vpc[0].id : local.vpc_details[1]
}

data "aws_vpc" "vpc" {
  count = var.create_vpc ? 0 : 1
  tags = {
    "Name" = var.vpc_details["vpc_name"]
  }
}

resource "aws_vpc" "vpc" {
  count = var.create_vpc ? 1 : 0
  cidr_block           = var.vpc_details["vpc_cidr"]
  enable_dns_hostnames = var.vpc_details["enable_dns_hostnames"]
  enable_dns_support   = var.vpc_details["enable_dns_support"]
  tags = {
    Name        = var.vpc_details["vpc_name"]
    Iaac        = "Terraform"
  }
}