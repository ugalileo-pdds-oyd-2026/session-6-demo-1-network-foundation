# Session 6 — Demo 1: Network Foundation Module

Extend an existing RDS Terraform project with a reusable `modules/network/` module that creates the VPC, subnets, internet gateway, NAT gateway, and security groups — eliminating the hardcoded `vpc_id` and `subnet_ids` that broke portability across AWS accounts.

> **Forked from:** [`ugalileo-pdds-oyd-2026/session-4-demo-3-rds`](https://github.com/ugalileo-pdds-oyd-2026/session-4-demo-3-rds) — the Session 4 RDS module that this demo extends.

## What students learn

- Why hardcoded VPC and subnet IDs in `dev.tfvars` cause plans to fail when the code runs in a different AWS account
- How to build a three-tier subnet layout (public / private / db) using `count` so adding an AZ requires only a new CIDR entry in `dev.tfvars`
- Why `enable_dns_hostnames = true` is required on the VPC for RDS endpoint resolution to work inside the VPC
- How to wire a three-tier security group stack (web → app → db) where each tier only accepts traffic from the tier directly above it
- Why security groups belong in the network module — not in compute or database modules — so all access-control changes happen in one place
- How `module.network.*` outputs replace every hardcoded network reference in the root and child modules

## Project structure

```
.
├── main.tf                          # root module — calls network and rds-postgres modules
├── variables.tf                     # root-level input variables (CIDRs, AZs, db config)
├── provider.tf                      # AWS provider configuration
├── envs/
│   └── dev/
│       └── dev.tfvars               # dev environment values — portable CIDRs, no hardcoded IDs
└── modules/
    ├── network/
    │   ├── main.tf                  # VPC, subnets, IGW, NAT GW, route tables, SGs, NACLs
    │   ├── variables.tf             # vpc_cidr, subnet CIDRs, availability_zones, environment
    │   └── outputs.tf               # vpc_id, db_subnet_ids, db_sg_id (consumed by other modules)
    └── rds-postgres/
        ├── main.tf                  # subnet group, parameter group, db_instance
        ├── variables.tf             # accepts db_sg_id instead of creating its own SG
        └── outputs.tf               # endpoint, db_name, arn
```

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.0
- [AWS CLI](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) configured for `us-west-2`

## Demo workflow

### 1. Explore the module structure

```bash
tree .
```

### 2. Review the hardcoded starting point

The demo evolves from a state where `dev.tfvars` contained fixed AWS resource IDs. The `start/envs/dev/dev.tfvars` file preserves that snapshot:

```hcl
vpc_id     = "vpc-2e760856"                              # ⚠️ hardcoded
subnet_ids = ["subnet-a88843d0", "subnet-f927d2b3"]     # ⚠️ hardcoded
```

The current `envs/dev/dev.tfvars` replaces those IDs with portable CIDR declarations that Terraform will use to create the network from scratch.

### 3. Review the network module

Open `modules/network/main.tf`. The module provisions resources in this dependency order, which Terraform resolves automatically from the references:

1. `aws_vpc.this` — VPC with DNS support and DNS hostnames enabled
2. `aws_subnet.public/private/db` — three subnet tiers, one resource block each, scaled by `count`
3. `aws_internet_gateway.this` — attached to the VPC for public egress
4. `aws_eip.nat` + `aws_nat_gateway.this` — NAT in `public[0]` for private subnet egress
5. `aws_route_table.public/private` — default routes to IGW and NAT GW respectively
6. `aws_security_group.web/app/db` — three-tier SG stack; each tier's ingress references only the SG above it

### 4. Review the network module outputs

Open `modules/network/outputs.tf`. Every downstream module — RDS today, compute tomorrow — consumes references from here:

```hcl
output "vpc_id"          { value = aws_vpc.this.id }
output "db_subnet_ids"   { value = aws_subnet.db[*].id }
output "db_sg_id"        { value = aws_security_group.db.id }
```

### 5. Review how the root module consumes network outputs

Open `main.tf`. The `module "blog_db"` block no longer reads from `var.vpc_id` or `var.subnet_ids`:

```hcl
module "blog_db" {
  source = "./modules/rds-postgres"

  vpc_id     = module.network.vpc_id
  subnet_ids = module.network.db_subnet_ids
  db_sg_id   = module.network.db_sg_id
  ...
}
```

### 6. Review the RDS module changes

Open `modules/rds-postgres/main.tf`. The `aws_security_group.rds` resource has been removed — the SG now lives in the network module. The instance references it through the new input variable:

```hcl
vpc_security_group_ids = [var.db_sg_id]
```

### 7. Set the database password via environment variable

```bash
export TF_VAR_db_password=YourSecurePassword123
```

### 8. Initialize and validate

```bash
terraform init -backend=false
terraform validate
```

Expected output:

```
Success! The configuration is valid.
```

### 9. Plan the deployment

```bash
terraform plan -var-file=envs/dev/dev.tfvars
```

Expected output:

```
Plan: 18 to add, 0 to change, 0 to destroy.
```

### 10. Apply

```bash
terraform apply -var-file=envs/dev/dev.tfvars -auto-approve
```

Expected output (once complete):

```
Apply complete! Resources: 18 added, 0 changed, 0 destroyed.

Outputs:

arn      = "arn:aws:rds:us-west-2:YOUR_ACCOUNT_ID:db:dev-blog-db"
db_name  = "blog_db"
endpoint = "dev-blog-db.XXXXXXXXXX.us-west-2.rds.amazonaws.com:5432"
```

> **Note:** `YOUR_ACCOUNT_ID` and the hostname suffix will reflect your actual AWS account.

### 11. Clean up

```bash
terraform destroy -var-file=envs/dev/dev.tfvars -auto-approve
```

## Expected outcomes

By the end of this demo, students should be able to:

1. Explain why hardcoded VPC and subnet IDs in `dev.tfvars` break plans when the code is cloned to a different AWS account
2. Build a VPC with three isolated subnet tiers using `count` so adding an availability zone requires only a new CIDR entry in `dev.tfvars`
3. Explain why `enable_dns_hostnames = true` is required on the VPC for RDS endpoint resolution to work
4. Wire a three-tier security group stack where each tier accepts traffic only from the tier directly above it
5. Move security group ownership into the network module so all access-control changes happen in one place
6. Replace hardcoded network references in a root module with `module.network.*` outputs
