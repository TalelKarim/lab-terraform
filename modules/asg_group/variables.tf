
variable "project" {
  type        = string
  description = "The name of the project we are working on"
  default     = "tf"
}

variable "instance_name" {
  type        = string
  description = "The name of the EC2 instance"
}

variable "instance_type" {
  type        = string
  description = "Type of the ec2 instance to provision preferably t2.micro"

}
variable "subnet_id" {
  type        = string
  description = "The subnet ID for the EC2 instance"
}

variable "user_data_file" {
  type        = string
  description = "The path to the user data file"
}

variable "key_name" {
  type        = string
  description = "The name of the key that will be used to ssh to the EC2 instance"
}

variable "sg_id" {
  type        = string
  description = "The id of the security group to be referenced in the ec2 instance"
}



variable "max_size" {
  type        = number
  description = "The maximum number of instances for the Autocaling group"
  default     = 5
}

variable "min_size" {
  type        = number
  description = "The minimum number of instances for the Autocaling group"
  default     = 1
}

variable "desired_capacity" {
  type        = number
  description = "The desired capacity for the Autocaling group"
  default     = 3
}

variable "asg_health_check_type" {
  type        = string
  description = "The type of the health check done by the autoscaling group"
  default     = "ELB"
}