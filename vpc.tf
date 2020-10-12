# vpc.tf 

##################################################################################
# Create VPC/Subnet/Security Group/Network ACL
##################################################################################

# create the VPC
resource "aws_vpc" "AWS_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
  tags = {
    Name = "AWS VPC"
  }
} # end resource

# create primary Subnet
resource "aws_subnet" "AWS_VPC_Subnet1" {
  vpc_id                  = aws_vpc.AWS_VPC.id
  cidr_block              = var.subnetCIDRblock1
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.primaryAvailabilityZone
  tags = {
    Name = "AWS VPC Subnet"
  }
} # end resource

# create secondary Subnet
resource "aws_subnet" "AWS_VPC_Subnet2" {
  vpc_id                  = aws_vpc.AWS_VPC.id
  cidr_block              = var.subnetCIDRblock2
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.secondaryAvailabilityZone
  tags = {
    Name = "AWS VPC Subnet"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "AWS_VPC_Security_Group" {
  vpc_id       = aws_vpc.AWS_VPC.id
  name         = "AWS VPC Security Group"
  description  = "AWS VPC Security Group"
  
  # allow ingress of postgres port
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
  }

  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 
  
  # allow all outbound traffic
  egress {
    cidr_blocks = var.ingressCIDRblock
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }

  tags = {
    Name = "AWS VPC Security Group"
    Description = "AWS VPC Security Group"
  }
} # end resource

# create VPC Network access control list
resource "aws_network_acl" "AWS_VPC_Security_ACL" {
  vpc_id = aws_vpc.AWS_VPC.id
  subnet_ids = [ aws_subnet.AWS_VPC_Subnet1.id ]

  # allow ingress port 22
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 22
    to_port    = 22
  }
  
  # allow ingress port 80 
  ingress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock 
    from_port  = 80
    to_port    = 80
  }
  
  # allow ingress ephemeral ports 
  ingress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }
  
  # allow egress port 22 
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 22 
    to_port    = 22
  }
  
  # allow egress port 80 
  egress {
    protocol   = "tcp"
    rule_no    = 200
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 80  
    to_port    = 80 
  }
 
  # allow egress ephemeral ports
  egress {
    protocol   = "tcp"
    rule_no    = 300
    action     = "allow"
    cidr_block = var.destinationCIDRblock
    from_port  = 1024
    to_port    = 65535
  }

  tags = {
    Name = "AWS VPC ACL"
  }
} # end resource

# Create the Internet Gateway
resource "aws_internet_gateway" "AWS_VPC_GW" {
  vpc_id = aws_vpc.AWS_VPC.id
  tags = {
    Name = "AWS VPC Internet Gateway"
  }
} # end resource

# Create the Route Table
resource "aws_route_table" "AWS_VPC_route_table" {
  vpc_id = aws_vpc.AWS_VPC.id
  tags = {
    Name = "AWS VPC Route Table"
  }
} # end resource

# Create the Internet Access
resource "aws_route" "AWS_VPC_internet_access" {
  route_table_id         = aws_route_table.AWS_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.AWS_VPC_GW.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "AWS_VPC_association" {
  subnet_id      = aws_subnet.AWS_VPC_Subnet1.id
  route_table_id = aws_route_table.AWS_VPC_route_table.id
} # end resource

# create DB Subnet Group
resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [aws_subnet.AWS_VPC_Subnet1.id,aws_subnet.AWS_VPC_Subnet2.id]

  tags = {
    Name = "DB subnet group"
  }
} # end resource

# end vpc.tf