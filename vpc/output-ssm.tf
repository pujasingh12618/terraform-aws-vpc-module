data "aws_region" "current" {}

resource "aws_ssm_parameter" "vpc-id" {
  name        = "/${var.resource_name_prefix}-vpc-${var.vpc_name}/vpc-id"
  description = "SSM for id"
  value       = aws_vpc.main.id
  overwrite   = true
  type        = "String"
}

resource "aws_ssm_parameter" "vpc-private-subnet-ids" {
  name        = "/${var.resource_name_prefix}-vpc-${var.vpc_name}/vpc-private-subnet-ids"
  description = "SSM for private subnet ids"
  type        = "String"
  value       = jsonencode([for subnet in aws_subnet.main-private : subnet.id])
  overwrite   = true
}

resource "aws_ssm_parameter" "vpc-subnet-ids" {
  name        = "/${var.resource_name_prefix}-vpc-${var.vpc_name}/vpc-subnet-ids"
  description = "SSM for subnet ids"
  type        = "String"
  value = jsonencode(concat(
    [for subnet in aws_subnet.main-public : subnet.id],
    [for subnet in aws_subnet.main-private : subnet.id]))
  overwrite = true
}