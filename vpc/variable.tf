variable "vpc_name" {
  description = "The name of the VPC"
}

variable "vpc_cidr" {
  description = "The CIDR of the VPC"
}

variable "ev_aws_cidr" {
  description = "CIDR for aws VPCs/VPN"
}

variable "ev_vpn_cidr" {
  description = "CIDR for EV VPN"
}

variable "resource_name_prefix" {
  description = "The resource name prefix"
}

variable "public_subnets" {
  description = "The public subnets of the VPC"
}

variable "private_subnets" {
  description = "The private subnets of the VPC"
}

variable "availability_zones" {
  description = "The availability zones"
}

# variable "vpce_elb_sg_ids" {
#   description = "Security groups to be attached to the Elastic Load Balancing Endpoint"
# }

variable "abc" {
  description = "A, B, C characters of the availability zones"
}

variable "use_transit_gateway" {
  description = "Value indicating when to use the transit gateway to route to other VPCs/VPN (transit_gateway_id should be set). Otherwise will try to use the virtual private gateway (virtual_gateway_id should be set)."
}

variable "transit_gateway_id" {
  description = "The id of the configured transit gateway (use_transit_gateway should be set to true)"
}

variable "virtual_gateway_id" {
  description = "The id of the configured virtual private gateway (use_transit_gateway should be set to false)"
}