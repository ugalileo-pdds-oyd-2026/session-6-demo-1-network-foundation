module "network" {
  source = "./modules/network"

  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  db_subnet_cidrs      = var.db_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "blog_db" {
  source            = "./modules/rds-postgres"
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.db_subnet_ids
  db_sg_id          = module.network.db_sg_id
  db_name           = var.db_name
  db_username       = var.db_username
  environment       = var.environment
  db_password       = var.db_password
  instance_class    = var.instance_class
  allocated_storage = var.allocated_storage
  multi_az          = var.multi_az
}
