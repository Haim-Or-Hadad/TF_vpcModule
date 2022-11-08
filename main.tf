module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs = ["eu-central-1a", "eu-central-1b"]
  private_subnets = ["10.0.1.0/24","10.0.2.0/24"]
  public_subnets = ["10.0.3.0/24", "10.0.4.0/24"]
  private_subnet_names = ["private_subnet_1","private_subnet_2"]
  public_subnet_names = ["public_subnet_1","public_subnet_2"]

  enable_nat_gateway = true
  single_nat_gateway = false
  one_nat_gateway_per_az = true

}

# terraform {
#   backend "s3" {
#     bucket         = "haimbucket1"
#     key            = "terraform.tfstate"
#     region         = "eu-central-1"
#     dynamodb_table = "haimtable1"
#     access_key = "AKIAWKAEGLSRFDLBF5WN"
#     secret_key = "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"
#   }
# }
# resource "aws_vpc" "main" {
#  cidr_block =  "10.0.0.0/16"
#  instance_tenancy = "default"
#  enable_dns_hostnames = true
#  enable_dns_support   = true
# tags = {
#   "Name" = "main"
# }
# }

# //Create public Subnet 1
# resource "aws_subnet" "public_subnet1" {
#   vpc_id     = aws_vpc.main.id
#   cidr_block = "10.0.1.0/24"
#   availability_zone = "eu-central-1a"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public_subnet1"
#   }
# }

# //Create public Subnet 2
# resource "aws_subnet" "public_subnet2" {
#   vpc_id     = "${aws_vpc.main.id}"
#   cidr_block = "10.0.2.0/24"
#   availability_zone = "eu-central-1b"
#   map_public_ip_on_launch = true
#   tags = {
#     Name = "public_subnet2"
#   }
# }

# //Create private Subnet 1
# resource "aws_subnet" "private_subnet1" {
#   vpc_id = "${aws_vpc.main.id}"
#   cidr_block = "10.0.3.0/24"
#   availability_zone = "eu-central-1a"
# tags = {
#   Name = "private_subnet1"
# }
# }

# //Create private Subnet 2
# resource "aws_subnet" "private_subnet2" {
#   vpc_id = "${aws_vpc.main.id}"
#   cidr_block = "10.0.4.0/24"
#   availability_zone = "eu-central-1b"
# tags = {
#   Name = "private_subnet2"
# }
# }


# # Internet GW
# resource "aws_internet_gateway" "main-GW" {
#   vpc_id = "${aws_vpc.main.id}"

#   tags = {
#     Name = "main-GW"
#   }
# }

# #route tables
# resource "aws_route_table" "route-table-1" {
#   vpc_id = "${aws_vpc.main.id}"
#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = "${aws_internet_gateway.main-GW.id}"
#   }
#   tags = {
#     Name = "main-public-1"
#   }
# }

# # Creating a resource for the Route Table Association!
# resource "aws_route_table_association" "IG-Association1" {

# # Public Subnet ID
#   subnet_id      = aws_subnet.public_subnet1.id
# #  Route Table ID
#   route_table_id = aws_route_table.route-table-1.id
# }

# resource "aws_route_table_association" "IG-Association2" {

# # Public Subnet ID
#   subnet_id      = aws_subnet.public_subnet2.id
# #  Route Table ID
#   route_table_id = aws_route_table.route-table-1.id
# }
# # Allocate Elastic IP Address(EIP 1)
# # terraform aws allocate elastic ip
# resource "aws_eip" "eip-for-nat-gateway-1" {
#   vpc = true // EIP IN VPC

#   tags = {
#     "Name" = "EIP 1"
#   }
# }

# # Allocate Elastic IP Address(EIP 1)
# # terraform aws allocate elastic ip
# resource "aws_eip" "eip-for-nat-gateway-2" {
#   vpc = true // EIP IN VPC
  
#   tags = {
#     "Name" = "EIP 2"
#   }
# }


# # Creating a NAT Gateway!
# resource "aws_nat_gateway" "nat-gateway-1" {
#   # Allocating the Elastic IP to the NAT Gateway!
#   allocation_id = aws_eip.eip-for-nat-gateway-1.id 
#   # Associating it in the Public Subnet!
#   subnet_id = aws_subnet.public_subnet1.id

#   tags = {
#     Name = "NAT GATEWAY Public Subnet 1"
#   }
# }

# # Creating a NAT Gateway!
# resource "aws_nat_gateway" "nat-gateway-2" {
#   # Allocating the Elastic IP to the NAT Gateway!
#   allocation_id = aws_eip.eip-for-nat-gateway-2.id 
#   # Associating it in the private Subnet!
#   subnet_id = aws_subnet.public_subnet2.id

#   tags = {
#     Name = "NAT GATEWAY Public Subnet 1"
#   }
# }


# # Creating a Route Table for the Nat Gateway!
# resource "aws_route_table" "route-table-2a" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat-gateway-1.id
#   }
#   tags = {
#     Name = "Route Table 2"
#   }
# }


# # Creating an Route Table Association of the NAT Gateway route 
# # table with the Private Subnet!
# resource "aws_route_table_association" "private-subnet-1route-table-association" {
# #  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
#   subnet_id  = aws_subnet.private_subnet1.id
# # Route Table ID
#   route_table_id = aws_route_table.route-table-2a.id
# }

# # Creating a Route Table for the Nat Gateway!
# resource "aws_route_table" "route-table-2b" {
#   vpc_id = aws_vpc.main.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     nat_gateway_id = aws_nat_gateway.nat-gateway-2.id
#   }
#   tags = {
#     Name = "Route Table 2"
#   }
# }

# resource "aws_route_table_association" "private-subnet-2route-table-association" {
# #  Private Subnet ID for adding this route table to the DHCP server of Private subnet!
#   subnet_id  = aws_subnet.private_subnet2.id
# # Route Table ID
#   route_table_id = aws_route_table.route-table-2b.id
# }