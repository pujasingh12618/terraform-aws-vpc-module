
locals {

  /**
 * Environment Configuration
 */

  cidr_base_block           = "10.101"
  environment               = "sbox"
  vpc_module_version        = "?ref=release/vpc-test-build"
  deployment_version        = "1x0"
  resource_name_prefix_cops = "tb-${local.environment}-${local.deployment_version}"
  region                    = "us-east-2"
  ev_aws_cidr               = "10.0.0.0/8"
  ev_vpn_cidr               = "172.16.0.0/12"
  provisioned_by_tag        = "terraform-cloudops"

  /**
 * VPC Configuration
 */

  vpc_cidr             = "${local.cidr_base_block}.0.0/16"
  vpc_name_a           = "vpc"
  private_subnets      = ["${local.cidr_base_block}.0.0/19", "${local.cidr_base_block}.32.0/19", "${local.cidr_base_block}.64.0/19"]
  public_subnets       = ["${local.cidr_base_block}.152.0/24", "${local.cidr_base_block}.153.0/24", "${local.cidr_base_block}.154.0/24"]
  availability_zones   = ["${local.region}a", "${local.region}b", "${local.region}c"]
  abc                  = ["a", "b", "c"]
  use_transit_gateway  = false
  transit_gateway_id   = ""
  virtual_gateway_id   = ""
}