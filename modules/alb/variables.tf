
# # Tags
# variable "project" {}
# variable "createdby" {

# }
# variable "prefix" {}
# # General 
# variable "aws_region" {}

# Load Balancer
# variable "lb_name" {
#   type = string
# }

variable "lb_name" {}
variable "lb_internal" {}
variable "lb_load_balancer_type" {}
variable "lb_subnets" {}
variable "input_bucket_name" {
  type        = string
  description = "The bucket name that will extracted from the bucket module"
}

variable "account_id" {
  type        = string
  description = "The id of the aws account"
  default     = "123905443795"
}
# variable "lb_target_port" {}
# variable "lb_protocol" {}
# variable "lb_target_type" {}
variable "vpc_id" {}
# variable "lb_listener_port" {}
# variable "lb_listener_protocol" {}

variable "lb_target_tags_map" {
  description = "Tag map for the LB target resources"
  type        = map(string)
  default     = {}
}

variable "ssl_certificate_arn" {
  type        = string
  description = "The arn of the SSL certifcate used with HTTPS traffic"
}