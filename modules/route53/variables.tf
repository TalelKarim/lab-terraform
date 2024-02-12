
variable "record_name" {
  type        = string
  description = "The actual record name that will be used for the application"
}

variable "elb_dns_name" {
  type        = string
  description = "The dns of the application load balancer where the traffic will be route to"
}

variable "elb_zone_id" {
  type        = string
  description = "The zone id of the application load balancer"
}

variable "hosted_zone_name" {
  type        = string
  description = "The name of the hosted zone that will be created"
  default     = "test-zone.com"
}