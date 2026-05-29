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
variable "vpc_id" {
  type        = string
  description = "The ID of the VPC where the RDS instance will be deployed"
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs where the RDS instance will be deployed"
}
variable "db_sg_id" {
  type        = string
  description = "ID of the security group to attach to the RDS instance — provided by the network module"
}
variable "environment" {
  type        = string
  description = "The environment for which to create the RDS instance (e.g., dev, staging, prod)"
}
variable "multi_az" {
  type        = bool
  default     = false
  description = "Whether to create a Multi-AZ RDS instance for high availability"
}
