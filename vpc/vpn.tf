/**
 * VPN Gateway
 */


resource "aws_vpn_gateway_attachment" "this" {
  count = var.virtual_gateway_id != "" ? 1 : 0

  vpc_id         = aws_vpc.main.id
  vpn_gateway_id = var.virtual_gateway_id
}

resource "aws_route" "main-private-vpn-vgw" {
  count                  = !var.use_transit_gateway && var.virtual_gateway_id != "" ? length(compact(var.private_subnets)) : 0
  route_table_id         = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block = var.ev_vpn_cidr
  gateway_id             = var.virtual_gateway_id
}

resource "aws_vpn_gateway_route_propagation" "main-private" {
  count          = !var.use_transit_gateway && var.virtual_gateway_id != "" ? length(compact(var.private_subnets)) : 0
  vpn_gateway_id = var.virtual_gateway_id
  route_table_id = element(aws_route_table.main-private.*.id, count.index)
}

resource "aws_route" "main-private-vpn-tgw" {
  count                  = var.use_transit_gateway && var.transit_gateway_id != "" ? length(compact(var.private_subnets)) : 0
  route_table_id         = element(aws_route_table.main-private.*.id, count.index)
  destination_cidr_block = var.ev_vpn_cidr
  transit_gateway_id     = var.transit_gateway_id
}
