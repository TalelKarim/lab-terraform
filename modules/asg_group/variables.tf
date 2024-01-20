
variable "project" {
  type        = string
  description = "The name of the project we are working on"
  default     = "tf"
}


variable "instance_type" {
  type        = string
  description = "Type of the ec2 instance to provision preferably t2.micro"

}

variable "vpc_id" {
  type        = string
  description = "The id of the vpc where all the infrastructure is created"
}
variable "user_data_file" {
  type        = string
  description = "The path to the user data file"
}


variable "vpc_zone_identifier" {
  type        = list(string)
  description = "Subnets where the autoscaling group will deploy ressources"
}

variable "max_size" {
  type        = number
  description = "The maximum number of instances for the Autocaling group"
}

variable "min_size" {
  type        = number
  description = "The minimum number of instances for the Autocaling group"
}

variable "desired_capacity" {
  type        = number
  description = "The desired capacity for the Autocaling group"
}

variable "asg_health_check_type" {
  type        = string
  description = "The type of the health check done by the autoscaling group"
}



variable "input_lb_target_group_arn" {
  type        = string
  description = "The ARN of the target group returned by the load balancer module"
}