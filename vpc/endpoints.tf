/**
 * This file contains mocked dependencies for the tested infrastructure
 */

# resource "aws_security_group" "elasticloadbalancing_endpoint_security_group_a" {
#   description = "Communication between all nodes in the cluster"
#   name        = "${local.resource_name_prefix_cops}-elasticloadbalancing_endpoint_security_group-${local.vpc_name_a}"

#   vpc_id = module.vpc_a.id
# }

#resource "aws_security_group" "main-apigateway-access" {
#   description = "Allow a private connection between the VPC and the API Gateway"
#   name        = "${var.resource_name_prefix}-sg-${var.vpc_name}-apigateway-access"

#   tags = {
#     Name        = "${var.resource_name_prefix}-sg-${var.vpc_name}-apigateway-access"
#     Description = "Allow a private connection between the VPC and the API Gateway"
#   }

#   vpc_id = aws_vpc.main.id
# }

# resource "aws_security_group_rule" "main-apigateway-access-egress" {
#   description       = "Allow all outbound comunications from API Gateway endpoint"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = "0"
#   protocol          = "-1"
#   security_group_id = aws_security_group.main-apigateway-access.id
#   to_port           = "0"
#   type              = "egress"
# }

# resource "aws_security_group_rule" "main-apigateway-access-ingress-https" {
#   description       = "Allow https (443) inbound communication from VPC to API Gateway"
#   cidr_blocks       = [var.vpc_cidr]
#   from_port         = "443"
#   protocol          = "tcp"
#   security_group_id = aws_security_group.main-apigateway-access.id
#   to_port           = "443"
#   type              = "ingress"
# }

# resource "aws_security_group_rule" "main-apigateway-access-ingress-http" {
#   description       = "Allow http (80) inbound communication from VPC to API Gateway"
#   cidr_blocks       = [var.vpc_cidr]
#   from_port         = "80"
#   protocol          = "tcp"
#   security_group_id = aws_security_group.main-apigateway-access.id
#   to_port           = "80"
#   type              = "ingress"
# }


# /**
#  * VPC Endpoint: S3
#  */

# resource "aws_vpc_endpoint" "main-s3" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.s3"

#   tags = {
#     Name        = "${var.resource_name_prefix}-vpce-${var.vpc_name}-s3"
#     Description = "Gateway VPC endpoint to establish a private connection between the VPC and S3"
#   }
# }

# resource "aws_vpc_endpoint_route_table_association" "main-private-s3" {
#   count = length(compact(var.private_subnets))

#   vpc_endpoint_id = aws_vpc_endpoint.main-s3.id
#   route_table_id  = element(aws_route_table.main-private.*.id, count.index)
# }

# resource "aws_vpc_endpoint_route_table_association" "main-public-s3" {
#   vpc_endpoint_id = aws_vpc_endpoint.main-s3.id
#   route_table_id  = aws_route_table.main-public.id
# }

# /**
#  * VPC Endpoint: DynamoDB
#  */

# resource "aws_vpc_endpoint" "main-dynamodb" {
#   vpc_id       = aws_vpc.main.id
#   service_name = "com.amazonaws.${data.aws_region.current.name}.dynamodb"

#   tags = {
#     Name        = "${var.resource_name_prefix}-vpce-${var.vpc_name}-dynamodb"
#     Description = "Gateway VPC endpoint to establish a private connection between the VPC and DynamoDB"
#   }
# }

# resource "aws_vpc_endpoint_route_table_association" "main-private-dynamodb" {
#   count = length(compact(var.private_subnets))

#   vpc_endpoint_id = aws_vpc_endpoint.main-dynamodb.id
#   route_table_id  = element(aws_route_table.main-private.*.id, count.index)
# }

# resource "aws_vpc_endpoint_route_table_association" "main-public-dynamodb" {
#   vpc_endpoint_id = aws_vpc_endpoint.main-dynamodb.id
#   route_table_id  = aws_route_table.main-public.id
# }

# /**
#  * VPC Endpoint: Elastic Load Balancing
#  */

# resource "aws_vpc_endpoint" "main-elasticloadbalancing" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.elasticloadbalancing"
#   vpc_endpoint_type = "Interface"
#   subnet_ids        = [for subnet in aws_subnet.main-public : subnet.id]

#   security_group_ids = length(var.vpce_elb_sg_ids) == 0 ? [aws_security_group.main-elasticloadbalancing[0].id] : var.vpce_elb_sg_ids

#   private_dns_enabled = true

#   tags = {
#     Name        = "${var.resource_name_prefix}-vpce-${var.vpc_name}-elasticloadbalancing"
#     Description = "Interface VPC endpoint to establish a private connection between the VPC and the Elastic Load Balancing API"
#   }
# }

# // Security group (when vpce_elb_sg_ids is not provided) used to create the elastic load balancing endpoint
# resource "aws_security_group" "main-elasticloadbalancing" {
#   count = length(var.vpce_elb_sg_ids) == 0 ? 1 : 0

#   vpc_id = aws_vpc.main.id

#   tags = {
#     Name        = "${var.resource_name_prefix}-sg-${var.vpc_name}-elasticloadbalancing"
#     Description = "Elastic load balancing security group"
#   }
# }

# /**
#  * VPC Endpoint: API Gateway
#  */

# resource "aws_vpc_endpoint" "main-execute-api" {
#   vpc_id            = aws_vpc.main.id
#   service_name      = "com.amazonaws.${data.aws_region.current.name}.execute-api"
#   vpc_endpoint_type = "Interface"
#   subnet_ids        = [for subnet in aws_subnet.main-public : subnet.id]

#   security_group_ids = [
#     aws_security_group.main-apigateway-access.id,
#   ]

#   private_dns_enabled = true

#   tags = {
#     Name        = "${var.resource_name_prefix}-vpce-${var.vpc_name}-execute-api"
#     Description = "Interface VPC endpoint to establish a private connection between the VPC and the API Gateway"
#   }
# }