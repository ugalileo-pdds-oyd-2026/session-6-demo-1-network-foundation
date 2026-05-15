module "blog_db" {
  source            = "./modules/rds-postgres"
  vpc_id            = var.vpc_id
  subnet_ids        = var.subnet_ids
  db_name           = var.db_name
  db_username       = var.db_username
  environment       = var.environment
  db_password       = var.db_password
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  multi_az          = var.multi_az
}
