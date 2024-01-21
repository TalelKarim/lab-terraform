variable "application_domain_name" {
  type        = string
  description = "The dns name of the whole application"

}

variable "hosted_zone_id" {
  type = string 
  description = "The hosted zone id of route53 where the record will be registered"
}