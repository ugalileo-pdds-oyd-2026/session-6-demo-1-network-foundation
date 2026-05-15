output "endpoint" {
  value       = aws_db_instance.this.endpoint
  description = "Connection endpoint (host:port)"
}

output "db_name" {
  value       = aws_db_instance.this.db_name
  description = "Database name"
}

output "arn" {
  value       = aws_db_instance.this.arn
  description = "RDS instance ARN"
}
