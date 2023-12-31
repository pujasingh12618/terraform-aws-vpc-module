/**
 * Subnet: Public.
 */

resource "aws_subnet" "main-public" {
  assign_ipv6_address_on_creation = "false"
  map_public_ip_on_launch         = "false"

  cidr_block        = element(var.public_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.public_subnets)

  tags = {
    Name                 = "${var.resource_name_prefix}-subnet-${var.vpc_name}-${element(var.abc, count.index)}-public"
    Description          = "Public subnet in ${element(var.availability_zones, count.index)}"
    "evtech:subnet-type" = "public"
  }

  vpc_id = aws_vpc.main.id
}

/**
 * NACL: Public.
 */

resource "aws_network_acl" "main-public" {
  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = "0"
    icmp_code  = "0"
    icmp_type  = "0"
    protocol   = "-1"
    rule_no    = "100"
    to_port    = "0"
  }

  subnet_ids = [for subnet in aws_subnet.main-public : subnet.id]

  tags = {
    Name        = "${var.resource_name_prefix}-nacl-${var.vpc_name}-public"
    Description = "NACL for public subnets"
  }

  vpc_id = aws_vpc.main.id
}


/**
 * NAT Gateways.
 */

resource "aws_nat_gateway" "main" {
  count         = length(var.private_subnets)
  allocation_id = element(aws_eip.main-natgateway.*.id, count.index)
  subnet_id     = element(aws_subnet.main-public.*.id, count.index)
  depends_on    = [aws_internet_gateway.main]

  tags = {
    Name        = "${var.resource_name_prefix}-natgateway-${var.vpc_name}-${element(var.abc, count.index)}"
    Description = "NAT Gateway in public subnet ${element(var.abc, count.index)}"
  }
}

resource "aws_eip" "main-natgateway" {
  count = length(var.private_subnets)
  vpc   = true

  tags = {
    Name        = "${var.resource_name_prefix}-eip-${var.vpc_name}-natgateway-${element(var.abc, count.index)}"
    Description = "Elastic IP for NAT Gateway in public subnet ${element(var.abc, count.index)}"
  }
}


/**
 * Internet Gateway
 */

resource "aws_internet_gateway" "main" {
  tags = {
    Name        = "${var.resource_name_prefix}-igw-${var.vpc_name}"
    Description = "VPC Internet Gateway"
  }

  vpc_id = aws_vpc.main.id
}


/**
 * Route Table: Public.
 */

resource "aws_route_table" "main-public" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.resource_name_prefix}-routetable-${var.vpc_name}-public"
    Description = "Route table for public subnet"
  }
}

resource "aws_route" "main-public" {
  route_table_id         = aws_route_table.main-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

resource "aws_route_table_association" "main-public" {
  count          = length(var.public_subnets)
  subnet_id      = element(aws_subnet.main-public.*.id, count.index)
  route_table_id = aws_route_table.main-public.id
}