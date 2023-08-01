# /**
#  * Inbound Endpoint
#  */

# resource "aws_route53_resolver_endpoint" "main" {
#   name      = "${var.resource_name_prefix}-inbound-endpoint-${var.vpc_name}"
#   direction = "INBOUND"

#   security_group_ids = [
#     aws_security_group.main-route53-resolver.id
#   ]

#   ip_address {
#     subnet_id = aws_subnet.main-private[0].id
#   }

#   ip_address {
#     subnet_id = aws_subnet.main-private[1].id
#   }

#   ip_address {
#     subnet_id = aws_subnet.main-private[2].id
#   }

#   tags = {
#     Name        = "${var.resource_name_prefix}-inbound-endpoint-${var.vpc_name}"
#     Description = "Inbound endpoint containing the information that Resolver needs to route DNS queries from your network to your VPCs"
#   }
# }

# resource "aws_security_group" "main-route53-resolver" {
#   description = "Allow inbound UDP and TCP traffic from the remote network on destination port 53"
#   name        = "${var.resource_name_prefix}-sg-${var.vpc_name}-route53-resolver"

#   tags = {
#     Name        = "${var.resource_name_prefix}-sg-${var.vpc_name}-route53-resolver"
#     Description = "Allow inbound UDP and TCP traffic from the remote network on destination port 53"
#   }

#   vpc_id = aws_vpc.main.id
# }

# resource "aws_security_group_rule" "main-route53-resolver-egress" {
#   description       = "Allow all outbound comunications from the route 53 resolver"
#   cidr_blocks       = ["0.0.0.0/0"]
#   from_port         = "0"
#   protocol          = "-1"
#   security_group_id = aws_security_group.main-route53-resolver.id
#   to_port           = "0"
#   type              = "egress"
# }

# resource "aws_security_group_rule" "main-route53-resolver-ingress-tcp" {
#   description       = "Allow tcp (53) inbound communication from the remote network"
#   cidr_blocks       = [var.ev_aws_cidr]
#   from_port         = "53"
#   protocol          = "tcp"
#   security_group_id = aws_security_group.main-route53-resolver.id
#   to_port           = "53"
#   type              = "ingress"
# }

# resource "aws_security_group_rule" "main-route53-resolver-ingress-udp" {
#   description       = "Allow udp (53) inbound communication from the remote network"
#   cidr_blocks       = [var.ev_aws_cidr]
#   from_port         = "53"
#   protocol          = "udp"
#   security_group_id = aws_security_group.main-route53-resolver.id
#   to_port           = "53"
#   type              = "ingress"
# }