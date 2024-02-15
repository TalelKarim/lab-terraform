# variables.tf
variable "prefixes" {
  type        = list(string)
  description = "Prefixes to be used for naming"
  default     = ["a", "b", "c"]
}

variable "region" {
  type        = string
  description = "The region where the project infrastructure will be deployed"
  default     = "eu-west-3"
}

variable "db_username" {
  type        = string
  description = "The username of the database"
  default     = "talel"
}

variable "db_password" {
  type        = string
  description = "The password of the database"
  default     = "00000000"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
  default     = "test"
}




variable "main_domain" {
  type        = string
  description = "The main domain of the application"
  default     = "test-zone.com"
}

variable "subdomain" {
  type        = string
  description = "The main domain of the application"
  default     = "test.test-zone.com"
}