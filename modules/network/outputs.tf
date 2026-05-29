output "vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the VPC"
}

output "public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of the public subnets"
}

output "private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of the private (app) subnets"
}

output "db_subnet_ids" {
  value       = aws_subnet.db[*].id
  description = "IDs of the database subnets"
}

output "web_sg_id" {
  value       = aws_security_group.web.id
  description = "ID of the web-tier security group"
}

output "app_sg_id" {
  value       = aws_security_group.app.id
  description = "ID of the app-tier security group"
}

output "db_sg_id" {
  value       = aws_security_group.db.id
  description = "ID of the database security group — passed to the rds-postgres module as db_sg_id"
}
