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
