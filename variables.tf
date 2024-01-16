# variables.tf

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "prefixes" {
  type        = list(string)
  description = "Prefixes to be used for naming"
  default     = ["a", "b", "c"]
}