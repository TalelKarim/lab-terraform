# output "dns_name" {
#   value = module.alb.load_balancer_dns
# }

# output "vpc_id" {
#   value = module.vpc.vpc_id
# }

# output "subnet_ids" {
#   value = module.vpc.subnet_ids
# }

# output "ssl_certicate_arn" {
#   value = module.tls_certificate.certificate_arn
# }

output "rds-database-endpoint" {
  value = module.database.rds_endpoint
}