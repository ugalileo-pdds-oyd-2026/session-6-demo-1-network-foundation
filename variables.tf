variable "db_name" {
  type        = string
  description = "Name of the database to create"
}
variable "db_username" {
  type        = string
  description = "Username for the database user"
}
variable "db_password" {
  type        = string
  sensitive   = true
  description = "Password for the database user - ensure this is stored securely and not hardcoded in your configuration"
}
variable "instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "The instance class to use for the RDS instance (e.g., db.t3.micro, db.t3.small, etc.)"
}
variable "allocated_storage" {
  type        = number
  default     = 20
  description = "The amount of storage to allocate for the RDS instance (in GB)"
}
variable "environment" {
  type        = string
  description = "The environment for which to create the RDS instance (e.g., dev, staging, prod)"
}
variable "multi_az" {
  type    = bool
  default = false
}
variable "region" {
  type        = string
  default     = "us-west-2"
  description = "AWS region"
}
variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for public subnets (one per availability zone)"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for private (app) subnets (one per availability zone)"
}

variable "db_subnet_cidrs" {
  type        = list(string)
  description = "CIDR blocks for database subnets (one per availability zone)"
}

variable "availability_zones" {
  type        = list(string)
  description = "List of availability zones to deploy subnets into"
}
