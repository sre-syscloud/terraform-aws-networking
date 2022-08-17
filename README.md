# **AWS NETWORKING MODULE**

## **ABOUT**

This module provides many resources which are required for building a complete network in AWS i.e., this comprises of entire VPC module. The resources that this module provides are described in the below table.

Resource                            | Description                  
--------------------------------|------------------------------
aws_vpc | Provides a VPC resource
aws_subnet | Provides an VPC subnet resource (Public and Private)
aws_security_group | Provides a security group resource (Public and Private)
aws_route_table | Provides a resource to create a VPC routing table (Public and Private)
aws_route | Provides a resource to create a routing table entry (a route) in a VPC routing table
aws_vpc_endpoint | Provides a VPC Endpoint resource
aws_vpc_peering_connection | Provides a resource to manage a VPC peering connection
aws_nat_gateway | Provides a resource to create a VPC NAT Gateway
aws_internet_gateway | Provides a resource to create a VPC Internet Gateway
aws_default_network_acl | Provides a resource to manage a VPC's default network ACL
aws_eip | Provides an Elastic IP resource


## **INPUTS**


Name                            | Description                  | Type             | Default 
--------------------------------|------------------------------|------------------|-----------------
region | The region name where you want to create the resource | string | "us-east-1" 
Environment | The Environment name | string | "dev"
vpc_cidr | The IPv4 CIDR block for the VPC | string | "10.90.0.0/16"
enable_dns_hostnames | A boolean flag to enable/disable DNS hostnames in the VPC | bool | true
enable_dns_support | A boolean flag to enable/disable DNS support in the VPC | bool | true
public_subnets_cidr | The list of IPv4 CIDR block for the public subnet | list(string) | ["10.90.1.0/24"]
availability_zones | The list of availability zones for the subnet respectively | list(string) | ["us-east-1b"]
private_subnets_cidr | The list of IPv4 CIDR block for the private subnet | list(string) | ["10.90.2.0/24"]
create_network_acl | Condition which checks whether to create a network acl or not | bool | true 
[network_acl_rules_egress](#egress-and-ingress-for-acl) | Detailed below in egress and ingress for acl table | map(object) | {}
[network_acl_rules_ingress](#egress-and-ingress-for-acl) | Detailed below in egress and ingress for acl table | map(object) | {}
create_public_security_group | Condition which checks whether to create a public security group or not | bool | true 
[public_all_ingress_rules](#egress-and-ingress-for-sg) | Detailed below in egress and ingress for security groups table | map(object) | {}
[public_all_egress_rules](#egress-and-ingress-for-sg) | Detailed below in egress and ingress for security groups table | map(object) | {}
[private_all_ingress_rules](#egress-and-ingress-for-sg) | Detailed below in egress and ingress for security groups table | map(object) | {}
[private_all_egress_rules](#egress-and-ingress-for-sg) | Detailed below in egress and ingress for security groups table | map(object) | {}
create_private_security_group | Condition which checks whether to create a private security group or not | bool | true 
create_vpc | Condition which checks whether to create a VPC or not | bool | true 
enable_s3_endpoint | Condition which checks whether to enable s3 endpoint or not | bool | true
create_peering_connection | Condition which checks whether to have peering connection between vpc's or not | bool | true 
[peering_connection](#peering-connection) | Detailed below in peering connection table | map(object) | {}
different_account_peering_connection | Condition which checks whether to have peering connection for different account or not | bool | true 
create_peering_route | Condition which checks whether to create peering route or not | bool | true 
peering_route | Map of variables of destination cidr values | map(object({destination_cidr_block = string})) | {}


### **egress and ingress for acl**
#### Both the egress and ingress configuration blocks have the same arguments. They are map(object) type. So, you can give n number of rules, just follow the object structure below and use them in the map. 
Name                            | Description                  | Type             
--------------------------------|------------------------------|------------------
action | The action to take | string 
cidr_block | The CIDR block to match | string 
protocol | The protocol to match. If using the -1 'all' protocol, you must specify a from and to port of 0 | string 
from_port | The from port to match | number 
rule_no | The rule number. Used for ordering | number 
to_port | The to port to match | number 


### **egress and ingress for sg**
#### Both the egress and ingress configuration blocks have the same arguments, and the same are being used to create a public security group and private security group. They are map(object) type. So, you can give n number of rules, just follow the object structure below and use them in the map. 
Name                            | Description                  | Type             
--------------------------------|------------------------------|------------------
from_port | Start port | number  
to_port | End range port | number 
protocol | The protocol to match. If using the -1 'all' protocol, you must specify a from and to port of 0 | string
description | Description of the ingress or egress rule | string
cidr_blocks | List of CIDR blocks | list(string)


### **Peering Connection**
#### It is of the type map(object) where we can define the perring connetion values. The keys of the object are described below.
Name                            | Description                  | Type             
--------------------------------|------------------------------|------------------
peer_owner_id | The AWS account ID of the owner of the peer VPC | number  
peer_vpc_id | The ID of the VPC with which you are creating the VPC Peering Connection | string 
peer_region | The region of the accepter VPC of the VPC Peering Connection | string
peering_name | Any name for the perring to give in under Name key of tags | string


## **OUTPUT**

- vpc_id - The ID of the VPC.


## **Sample Usage**
```
module "VPC" {
    source = "./module/AWS-NETWORKING"
    Environment = "sys-us-dev"
    vpc_cidr = "10.160.0.0/16"
    enable_dns_hostnames = true
    enable_dns_support = true
    public_subnets_cidr = ["10.160.1.0/24","10.160.2.0/24","10.160.3.0/24"]
    private_subnets_cidr = ["10.160.4.0/24","10.160.5.0/24","10.160.6.0/24"]
    availability_zones = ["us-east-1a","us-east-1b","us-east-1a"]
    create_public_security_group = true
    public_all_ingress_rules = {
        "IPV480" = {
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow inbound HTTP access from all IPv4 addresses"
            from_port = 80
            protocol = "TCP"
            to_port = 80        
        },
        "IPV4443" = {
            cidr_blocks = ["0.0.0.0/0"]
            description = "Allow inbound HTTPS access from all IPv4 addresses"
            from_port = 443
            protocol = "TCP"
            to_port = 443     
        },
        "22" = {
            cidr_blocks = ["10.160.0.0/16"]
            description = "Allow inbound SSH access to Linux instances from IPv4 IP addresses in your network (over the internet gateway)"
            from_port = 22
            protocol = "TCP"
            to_port = 22      
        },
        "3389" = {
            cidr_blocks = ["10.160.0.0/16"]
            description = "Allow inbound RDP access to Windows instances from IPv4 IP addresses in your network (over the internet gateway)"
            from_port = 3389
            protocol = "TCP"
            to_port = 3389      
        },   
        "All" = {
            cidr_blocks = ["10.20.0.0/16","10.85.0.0/16","10.70.0.0/16","10.10.0.0/16"]
            description = "All"
            from_port = 0
            protocol = -1
            to_port = 0        
        }   
    }
    public_all_egress_rules = {
        "All" = {
            cidr_blocks = ["0.0.0.0/0"]
            description = "All"
            from_port = 0
            protocol = -1
            to_port = 0        
        }
    }
    create_private_security_group = true
    private_all_ingress_rules = {
        "22" = {
            cidr_blocks = ["10.160.0.0/16"]
            description = "Allow inbound SSH access to Linux instances from IPv4 IP addresses in your network (over the internet gateway)"
            from_port = 22
            protocol = "TCP"
            to_port = 22      
        },
        "3389" = {
            cidr_blocks = ["10.160.0.0/16"]
            description = "Allow inbound RDP access to Windows instances from IPv4 IP addresses in your network (over the internet gateway)"
            from_port = 3389
            protocol = "TCP"
            to_port = 3389      
        },
        "All" = {
            cidr_blocks = ["10.20.0.0/16","10.85.0.0/16","10.70.0.0/16","10.10.0.0/16"]
            description = "All"
            from_port = 0
            protocol = -1
            to_port = 0        
        }    
    }
    private_all_egress_rules = {
        "All" = {
            cidr_blocks = ["0.0.0.0/0"]
            description = "All"
            from_port = 0
            protocol = -1
            to_port = 0        
        }
    }
    create_network_acl = true
    network_acl_rules_egress = {
        "all" = {
            rule_no    = 100
            action     = "allow"
            cidr_block = "0.0.0.0/0"
            from_port  = 0
            to_port    = 0
            protocol   = "-1"
        },
        "ssh" = {
            rule_no    = 200
            action     = "allow"
            cidr_block = "0.0.0.0/0"
            from_port  = 22
            to_port    = 22
            protocol   = "tcp"
        }
    }
    network_acl_rules_ingress = {
        "all" = {
            rule_no    = 100
            action     = "allow"
            cidr_block = "0.0.0.0/0"
            from_port  = 0
            to_port    = 0
            protocol   = "-1"
        },
        "ssh" = {
            rule_no    = 200
            action     = "allow"
            cidr_block = "0.0.0.0/0"
            from_port  = 22
            to_port    = 22
            protocol   = "tcp"
        }
    }
    create_peering_connection = true
    different_account_peering_connection = true
    peering_connection = {  
        "US-DEV-TO-US-STAGING" = {
            "peer_owner_id" = 538782569624,
            "peer_vpc_id" = "vpc-0601f98fc9be4e688",
            "peer_region" = "us-east-1",
            "peering_name" = "US-DEV-TO-US-STAGING"
        },
        "US-DEV-TO-US-PROD" = {
            "peer_owner_id" = 724493240358,
            "peer_vpc_id" = "vpc-86cac1e4",
            "peer_region" = "us-east-1",
            "peering_name" = "US-DEV-TO-US-PROD"
        }
    }
    create_peering_route = true
    peering_route = {
        "US-DEV-TO-US-STAGING" = {  
            "destination_cidr_block" = "10.20.0.0/16"
        },
        "US-DEV-TO-US-PROD" = {
            "destination_cidr_block" = "10.0.0.0/16"
        }
    }
}
```
