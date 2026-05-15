region      = "us-west-2"
environment = "dev"
db_name     = "blog_db"
db_username = "blog"
vpc_id      = "vpc-2e760856"
subnet_ids  = ["subnet-a88843d0", "subnet-f927d2b3"]
# db_password must be set via TF_VAR_db_password env variable — never hardcoded
