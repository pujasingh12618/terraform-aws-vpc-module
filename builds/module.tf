/**
* This file contains the tested infrastructure.
* Creates a test-build infrastructure with 2 VPCs.
*/

module "vpc" {
  source               = "../vpc"
  ev_aws_cidr          = local.ev_aws_cidr
  ev_vpn_cidr          = local.ev_vpn_cidr
  vpc_cidr             = local.vpc_cidr
  vpc_name             = local.vpc_name_a
  resource_name_prefix = local.resource_name_prefix_cops
  public_subnets       = local.public_subnets
  private_subnets      = local.private_subnets
  availability_zones   = local.availability_zones
  abc                  = local.abc
  use_transit_gateway  = local.use_transit_gateway
  transit_gateway_id   = local.transit_gateway_id
  virtual_gateway_id   = local.virtual_gateway_id
}

data "aws_caller_identity" "current" {}

output "assumed-identity-arn" {
  value = data.aws_caller_identity.current.arn
}