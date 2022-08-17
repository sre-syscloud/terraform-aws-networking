variable "region" {
  default     = "us-east-1"
  description = "The region to use for this vpc."
}

variable "Environment" {
  type        = string
  description = "Enter the Environment name"
  default     = "dev"
}

variable "vpc_cidr" {
  type        = string
  description = "The CIDR block for the VPC."
  default     = "10.90.0.0/16"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "A boolean flag to enable/disable DNS hostnames in the VPC. Defaults false."
  default     = true
}

variable "enable_dns_support" {
  type        = bool
  description = "A boolean flag to enable/disable DNS support in the VPC. Defaults true."
  default     = true
}

variable "public_subnets_cidr" {
  type        = list(string)
  description = "The list of CIDR block for the public subnets."
  default     = ["10.90.1.0/24"]
}

variable "availability_zones" {
  type        = list(string)
  description = "Enter the availability zone to launch the subnet"
  default     = ["us-east-1b"]
}

variable "private_subnets_cidr" {
  type        = list(string)
  description = "The list of CIDR block for the private subnets."
  default     = ["10.90.2.0/24"]
}

variable "create_network_acl" {
  type        = bool
  description = "Enter true to create network acl"
  default     = true
}

variable "network_acl_rules_egress" {
  type = map(object({
    action     = string
    cidr_block = string
    protocol   = string
    from_port  = number
    rule_no    = number
    to_port    = number

  }))
  description = "(optional) describe your variable"
  default     = {}
}

variable "network_acl_rules_ingress" {
  type = map(object({
    action     = string
    cidr_block = string
    protocol   = string
    from_port  = number
    rule_no    = number
    to_port    = number

  }))
  description = "(optional) describe your variable"
  default     = {}
}

variable "create_public_security_group" {
  type        = bool
  description = "(optional) describe your variable"
  default     = true
}

variable "public_all_ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)

  }))
  description = "(optional) describe your variable"
  default     = {}
}

variable "public_all_egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)

  }))
  description = "(optional) describe your variable"
  default     = {}
}

variable "private_all_ingress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)

  }))
  description = "(optional) describe your variable"
  default     = {}
}

variable "private_all_egress_rules" {
  type = map(object({
    from_port   = number
    to_port     = number
    protocol    = string
    description = string
    cidr_blocks = list(string)

  }))
  description = "(optional) describe your variable"
  default     = {}
}


variable "create_private_security_group" {
  type        = bool
  description = "(optional) describe your variable"
  default     = true
}

variable "create_vpc" {
  type        = bool
  description = "(optional) describe your variable"
  default     = true
}

variable "enable_s3_endpoint" {
  type        = bool
  description = "(optional) describe your variable"
  default     = true
}

variable "create_peering_connection" {
  type        = bool
  description = "Enter true to have peering connection between vpc's"
  default     = true
}

variable "peering_connection" {
  type = map(object({
    peer_owner_id = number
    peer_vpc_id   = string
    peer_region   = string
    peering_name  = string
  }))
  description = "Map of variables to define a peering connection values"
  default     = {}
}

variable "different_account_peering_connection" {
  type        = bool
  description = "Enter the true to have peering connection for different account"
  default     = true
}

variable "create_peering_route" {
  type        = bool
  description = "Enter true to create peering route"
  default     = true
}

variable "peering_route" {
  type = map(object({
    destination_cidr_block = string
  }))
  description = "Map of variables of destination cidr values"
  default     = {}
}

