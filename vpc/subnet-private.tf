/**
 * Subnet: Private.
 */

resource "aws_subnet" "main-private" {
  assign_ipv6_address_on_creation = "false"

  cidr_block        = element(var.private_subnets, count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(var.private_subnets)

  tags = {
    Name                 = "${var.resource_name_prefix}-subnet-${var.vpc_name}-${element(var.abc, count.index)}-private"
    Description          = "Private subnet in ${element(var.availability_zones, count.index)}"
    "evtech:subnet-type" = "private"
  }

  vpc_id = aws_vpc.main.id
}

/**
 * Route Table: Private.
 */

resource "aws_route_table" "main-private" {
  count  = length(var.private_subnets)
  vpc_id = aws_vpc.main.id

  tags = {
    Name        = "${var.resource_name_prefix}-routetable-${var.vpc_name}-private-${element(var.abc, count.index)}"
    Description = "Route table for private subnet ${element(var.abc, count.index)}"
  }
}


resource "aws_route" "main-private-aws-tgw" {
  count                  = var.use_transit_gateway && var.transit_gateway_id != "" ? length(compact(var.private_subnets)) : 0
  route_table_id         = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block = var.ev_aws_cidr
  transit_gateway_id     = var.transit_gateway_id
}

resource "aws_route" "main-private-aws-vgw" {
  count                  = !var.use_transit_gateway && var.virtual_gateway_id != "" ? length(compact(var.private_subnets)) : 0
  route_table_id         = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block = var.ev_aws_cidr
  gateway_id             = var.virtual_gateway_id
}

resource "aws_route" "main-private" {
  count                  = length(compact(var.private_subnets))
  route_table_id         = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "main-private" {
  count          = length(var.private_subnets)
  subnet_id      = element(aws_subnet.main-private.*.id, count.index)
  route_table_id = element(aws_route_table.main-private.*.id, count.index)
}

/**
 * NACL: Private.
 */

resource "aws_network_acl" "main-private" {
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

  subnet_ids = concat([for subnet in aws_subnet.main-private : subnet.id])

  tags = {
    Name        = "${var.resource_name_prefix}-nacl-${var.vpc_name}-private"
    Description = "NACL for private subnets"
  }

  vpc_id = aws_vpc.main.id
}