# Configure the AWS Provider

provider "aws" {
  region = var.region
}

provider "vault" {
}


locals {
  rds_host = split(":", module.database.rds_endpoint)[0]
}

data "vault_generic_secret" "database_credentials" {
  path = "kv/rds"
}
module "s3_bucket" {
  source      = "./modules/s3_bucket"
  bucket_name = "alb-logs-tk"
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "main"
}

module "alb" {
  source                = "./modules/alb"
  lb_name               = "tf-alb"
  lb_internal           = false
  lb_load_balancer_type = "application"
  lb_subnets            = module.vpc.public_subnet_ids
  vpc_id                = module.vpc.vpc_id
  input_bucket_name     = module.s3_bucket.bucket_name
  ssl_certificate_arn   = module.tls_certificate.certificate_arn
}


# Create an autoscaling group with the necessary cloudwatch alarms
module "auto_scaling_group" {
  source        = "./modules/asg_group"
  instance_type = "t2.medium"
  user_data_file = templatefile("${path.module}/user_data_template.sh.tpl", {
    DB_USERNAME = data.vault_generic_secret.database_credentials.data.db_username
    DB_PWD      = data.vault_generic_secret.database_credentials.data.db_password
    DBNAME      = data.vault_generic_secret.database_credentials.data.db_name
    DB_HOST     = local.rds_host
    SERVER_PORT = 8080
    PORT        = 8081
  })

  vpc_zone_identifier       = module.vpc.public_subnet_ids
  max_size                  = 5
  min_size                  = 1
  desired_capacity          = 3
  asg_health_check_type     = "ELB"
  input_lb_target_group_arn = module.alb.lb_target_group_arn
  vpc_id                    = module.vpc.vpc_id
}


module "tls_certificate" {
  source                  = "./modules/certificates_manager"
  application_domain_name = var.main_domain
  hosted_zone_id          = module.route53.hosted_zone_id
}

module "route53" {
  source       = "./modules/route53"
  record_name  = var.subdomain
  elb_dns_name = module.alb.load_balancer_dns
  elb_zone_id  = module.alb.load_balancer_zone_id
}


module "database" {
  source                          = "./modules/rds-database"
  engine                          = "mysql"
  instance_class                  = "db.t2.micro"
  allocated_storage               = 5
  storage_type                    = "gp2"
  db_name                         = data.vault_generic_secret.database_credentials.data.db_name
  db_username                     = data.vault_generic_secret.database_credentials.data.db_username
  db_password                     = data.vault_generic_secret.database_credentials.data.db_password
  vpc_id                          = module.vpc.vpc_id
  subnet_ids                      = module.vpc.private_subnet_ids
  load_balancer_security_group_id = module.alb.load_balancer_security_group_id
}
