variable "environment" {
  type        = string
  description = "Environment name used as a prefix for all resource names (e.g., dev, staging, prod)"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets — one per availability zone; hosts load balancers and NAT Gateway"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private (app) subnets — one per availability zone; hosts application servers"
}

variable "db_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for database subnets — one per availability zone; hosts RDS instances"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to spread subnets across (must match the length of each CIDR list)"
}
