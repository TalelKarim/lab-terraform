variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Public Subnet CIDR values"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Private Subnet CIDR values"
  default     = ["10.0.4.0/24", "10.0.5.0/24"]
}




variable "azs" {
  type        = list(string)
  description = "Availability Zones"
  default     = ["eu-west-3a", "eu-west-3b", "eu-west-3c"]
}

variable "vpc_name" {
  type        = string
  description = "The name of the vpc where the infrastructure will be deployed"
}