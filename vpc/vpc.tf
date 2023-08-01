/**
 * VPC
 */

resource "aws_vpc" "main" {
  assign_generated_ipv6_cidr_block = "false"
  cidr_block                       = var.vpc_cidr
  enable_classiclink               = "false"
  enable_classiclink_dns_support   = "false"
  enable_dns_hostnames             = "true"
  enable_dns_support               = "true"
  instance_tenancy                 = "default"

  tags = {
    Name        = "${var.resource_name_prefix}-vpc-${var.vpc_name}"
    Description = "${var.resource_name_prefix} Terraform VPC"
  }
}

/**
 * Security group: Default
 */

resource "aws_default_security_group" "main-default" {
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow all inbound communications from parent security group"
    protocol    = -1
    self        = true
    from_port   = 0
    to_port     = 0
  }

  ingress {
    description = "Allow PostgreSQL (5432) inbound communication from other vpcs/vpn"
    protocol    = "tcp"
    from_port   = 5432
    to_port     = 5432
    cidr_blocks = [var.ev_aws_cidr]
  }

# Enable these lines when you need VPN network. to have VPN network uncomment vpn.tf file as well.
  # ingress {
  #   description = "Allow PostgreSQL (5432) inbound communication from private cidrs"
  #   protocol    = "tcp"
  #   from_port   = 5432
  #   to_port     = 5432
  #   cidr_blocks = [var.ev_vpn_cidr]
  # }

  egress {
    description = "Allow all outbound comunications"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.resource_name_prefix}-sg-${var.vpc_name}-default"
    Description = "Default VPC security group with PostgreSQL inbound communication from private networks"
  }
}

/**
 * NACL: Default
 */

resource "aws_default_network_acl" "main-default" {
  default_network_acl_id = aws_vpc.main.default_network_acl_id

  ingress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  egress {
    protocol   = -1
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name        = "${var.resource_name_prefix}-nacl-${var.vpc_name}-default"
    Description = "Default VPC NACL"
  }
}

/**
 * Route Table: Default
 */

resource "aws_default_route_table" "main-default" {
  default_route_table_id = aws_vpc.main.default_route_table_id

  tags = {
    Name        = "${var.resource_name_prefix}-routetable-${var.vpc_name}-default"
    Description = "Default VPC Route Table"
  }
}







