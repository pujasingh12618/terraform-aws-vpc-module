output "id" {
  description = "Id of the VPC"
  value       = aws_vpc.main.id
}

output "arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.main.arn
}

output "subnet_ids" {
  description = "Subnet ids of the VPC"
  value = concat(
    [for subnet in aws_subnet.main-public : subnet.id],
    [for subnet in aws_subnet.main-private : subnet.id])
}

output "subnet_public_ids" {
  description = "Public subnet ids of the VPC"
  value       = [for subnet in aws_subnet.main-public : subnet.id]
}

output "subnet_private_ids" {
  description = "Private subnet ids of the VPC"
  value       = [for subnet in aws_subnet.main-private : subnet.id]
}