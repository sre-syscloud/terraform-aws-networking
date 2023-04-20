variable "region" {
  default     = "us-east-1"
  description = "The region to use for this vpc."
}

variable "create_vpc" {
  type        = bool
  description = "A boolean flag to create a vpc or not"
  default     = true
}

variable "vpc_details" {
  type = object({
    vpc_name              = string
    vpc_cidr              = string
    enable_dns_hostnames  = bool
    enable_dns_support    = bool
  })
  default = {
    vpc_name              = "staging-vpc"
    vpc_cidr              = "10.90.0.0/16"
    enable_dns_hostnames  = true
    enable_dns_support    = true
  }
}

variable "public_subnet_details" {
  type = map(object({
    cidr = string
    availability_zone = string
    name = string
  }))
  description = "The list of CIDR blocks, availability zones, subnet names for the public subnets."
  default = {
    "public-subnet-1" = {
      cidr = "10.90.1.0/24"
      availability_zone = "us-east-1b"
      name = "staging-public-subnet-1"
    }
  }
}

variable "private_subnet_details" {
  type = map(object({
    cidr = string
    availability_zone = string
    name = string
  }))
  description = "The list of CIDR blocks, availability zones, subnet names for the private subnets."
  default = {
    "private-subnet-1" = {
      cidr = "10.90.2.0/24"
      availability_zone = "us-east-1b"
      name = "staging-private-subnet-1"
    }
  }
}

variable "create_internet_gateway" {
  type        = bool
  description = "Enter true to create internet gateway"
  default     = false
}

variable "internet_gateway_name" {
  type        = string
  description = "Enter the internet gateway name"
  default     = "staging-internet-gateway"
}

variable "create_nat_eip" {
  type        = bool
  description = "Enter true to create eip for nat"
  default     = false
}

variable "nat_eip_name" {
  type        = string
  description = "Enter the nat eip name"
  default     = "staging-eip"
}

variable "nat_eip_private_ip" {
  type = string
  description = "Enter eip private ip which you will be using to create NAT gateway"
  default = "10.0.0.21"
}

variable "eip_details" {
  type = map(object({
    eip_name = string
    eip_private_ip = string
    eip_instance_id = string
  }))
  description = "Enter the EIP details"
  default = {
    "eip-1" = {
      eip_instance_id = null
      eip_name = "staging-eip"
      eip_private_ip = "10.0.0.21"
    }
  }
}

variable "network_acl_details" {
  type = map(object({
    nacl_name = string
    subnet_names = list(string)
    egress_rules = map(object({
      action     = string
      cidr_block = string
      protocol   = string
      from_port  = number
      rule_no    = number
      to_port    = number
    }))
    ingress_rules = map(object({
      action     = string
      cidr_block = string
      protocol   = string
      from_port  = number
      rule_no    = number
      to_port    = number
    }))
  }))
  default = {
    "public_rt_1" = {
      nacl_name = "staging_nacl"
      subnet_names = ["staging_subnet_1", "staging_subnet_2"]
      egress_rules = {
        "rule_1" = {
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          protocol   = "-1"
          from_port  = 0
          rule_no    = 100
          to_port    = 0
        }
      }
      ingress_rules = {
        "rule_1" = {
          action     = "allow"
          cidr_block = "0.0.0.0/0"
          protocol   = "tcp"
          from_port  = 80
          rule_no    = 100
          to_port    = 80
        }
      }
    }
  }
}

variable "create_nat_gateway" {
  type        = bool
  description = "Enter true to create nat gateway"
  default     = false
}

variable "nat_gateway_name" {
  type = string
  description = "Enter NAT gateway name"
  default = "staging-nat"
}

variable "nat_gateway_subnet_name" {
  type = string
  description = "Enter subnet name where you want to place the NAT gateway"
  default = "staging-subnet"
}

variable "public_route_table_details" {
  type = map(object({
    route_table_name      = string
    rt_subnet_association = list(string)
    internet_gateway_name = string
    peering_connections   = map(object({
      connection_name        = string
      destination_cidr_block = string
    }))
    vpn_gateway_names     = list(string)
  }))
  default = {
    "rt_1" = {
      route_table_name = "staging_rt"
      rt_subnet_association    = ["staging_subnet_1", "staging_subnet_2"]
      internet_gateway_name    = "staging_igw"
      peering_connections = {
        "conn1" = {
          connection_name         = "Mumbai-to-Prod"
          destination_cidr_block  = "10.10.0.0/16"
        },
        "conn2" = {
          connection_name         = "syscloud_us_Australia"
          destination_cidr_block  = "10.30.0.0/16"
        }
      }
      vpn_gateway_names = ["staging-vpn-gateway"]
    }
  }
}

variable "private_route_table_details" {
  type = map(object({
    route_table_name      = string
    rt_subnet_association = list(string)
    nat_gateway_name = string
    peering_connections   = map(object({
      connection_name        = string
      destination_cidr_block = string
    }))
    vpn_gateway_names     = list(string)
  }))
  default = {
    "rt_1" = {
      route_table_name = "staging_rt"
      rt_subnet_association    = ["staging_subnet_1", "staging_subnet_2"]
      nat_gateway_name    = "staging_nat"
      peering_connections = {
        "conn1" = {
          connection_name         = "Mumbai-to-Prod"
          destination_cidr_block  = "10.10.0.0/16"
        },
        "conn2" = {
          connection_name         = "syscloud_us_Australia"
          destination_cidr_block  = "10.30.0.0/16"
        }
      }
      vpn_gateway_names = ["staging-vpn-gateway"]
    }
  }
}

variable "public_security_group_details" {
  type = list(object({
      name = string
      description = string
      public_all_ingress_rules = map(object({
          from_port   = number
          to_port     = number
          protocol    = string
          description = string
          cidr_blocks = list(string)
      }))
      public_all_egress_rules = map(object({
          from_port   = number
          to_port     = number
          protocol    = string
          description = string
          cidr_blocks = list(string)
      }))  
  }))
  description = "describe your variable"
  default     = [
        {
          name = "test1"
          description = "tf test"
          public_all_ingress_rules = {
              "ib1" = {
                  from_port   = 0
                  to_port     = 0
                  protocol    = "-1"
                  description = "Inbound Rule 1"
                  cidr_blocks = ["10.10.0.0/16"]
              }
          }
          public_all_egress_rules = {
              "ob1" = {
                  from_port   = 0
                  to_port     = 0
                  protocol    = "-1"
                  description = "Outbound Rule 1"
                  cidr_blocks = ["0.0.0.0/0"]    
              }
          }
      }
  ]
}

variable "private_security_group_details" {
  type = list(object({
      name = string
      description = string
      private_all_ingress_rules = map(object({
          from_port   = number
          to_port     = number
          protocol    = string
          description = string
          cidr_blocks = list(string)
      }))
      private_all_egress_rules = map(object({
          from_port   = number
          to_port     = number
          protocol    = string
          description = string
          cidr_blocks = list(string)
      }))  
  }))
  description = "describe your variable"
  default     = [
        {
          name = "test1"
          description = "tf test"
          private_all_ingress_rules = {
              "ib1" = {
                  from_port   = 0
                  to_port     = 0
                  protocol    = "-1"
                  description = "Inbound Rule 1 - Private"
                  cidr_blocks = ["10.10.0.0/16"]
              },
              "ib2" = {
                  from_port   = 0
                  to_port     = 0
                  protocol    = "-1"
                  description = "staging account allow"
                  cidr_blocks = ["10.70.0.0/16"]    
              }
          }
          private_all_egress_rules = {
              "ob1" = {
                  from_port   = 0
                  to_port     = 0
                  protocol    = "-1"
                  description = "Outbound Rule 1 - Private"
                  cidr_blocks = ["0.0.0.0/0"]    
              }
          }
      }
  ]
}

variable "create_peering_connection" {
  type        = bool
  description = "Enter true to have peering connection between vpc's"
  default     = true
}

variable "peering_connection" {
  type = map(object({
    different_account_peering_connection = bool
    peer_owner_id = number
    peer_vpc_id   = string
    peer_region   = string
    peering_name  = string
  }))
  description = "Map of variables to define a peering connection values"
  default     = {}
}
variable "vpc_endpoint_details" {
  type = map(object({
    attach_endpoint_policies = bool
    service_name = string
    vpc_endpoint_type = string
    route_table_names = list(string)
    endpoint_name = string
    subnet_names = list(string)
    security_group_names = list(string)
  }))
  default = {
    "ep1" = {
      attach_endpoint_policies = true
      service_name = "com.amazonaws.us-east-1.s3"
      vpc_endpoint_type = "Gateway"
      route_table_names = ["GP3", "SysCloud_PRD_US_PublicRT", "GP2"]
      endpoint_name = "ep1"
      subnet_names = []
      security_group_names = []
    },
    "ep2" = {
      attach_endpoint_policies = false
      service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-01352dc378a6bca83"
      vpc_endpoint_type = "Interface"
      route_table_names = []
      endpoint_name = "ep2"
      subnet_names = ["sys-private-subnet-3", "sys-private-subnet-2"]
      security_group_names = ["sys-private-sg"]
    }
  }
}

