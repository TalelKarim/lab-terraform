# Configure the AWS Provider

provider "aws" {
  region = var.region
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
  lb_subnets            = module.vpc.subnet_ids
  vpc_id                = module.vpc.vpc_id
  input_bucket_name     = module.s3_bucket.bucket_name
  ssl_certificate_arn   = module.tls_certificate.certificate_arn
}


# Create an autoscaling group with the necessary cloudwatch alarms
module "auto_scaling_group" {
  source                    = "./modules/asg_group"
  instance_type             = "t2.medium"
  user_data_file            = "user_data.sh"
  vpc_zone_identifier       = module.vpc.subnet_ids
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
  hosted_zone_id = module.route53.hosted_zone_id
}

module "route53" {
  source         = "./modules/route53"
  record_name    = var.subdomain
  elb_dns_name   = module.alb.load_balancer_dns
  elb_zone_id    = module.alb.load_balancer_zone_id
}