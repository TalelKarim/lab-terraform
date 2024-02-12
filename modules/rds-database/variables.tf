variable "engine" {
  type        = string
  description = "The engine that will be used by the database"
}


variable "instance_class" {
  type        = string
  description = "The compute power of the database"
}


variable "allocated_storage" {
  type        = number
  description = "The number of gigabytes allocated to the database as storage"
}

variable "storage_type" {
  type        = string
  description = "The type of the storage allocated to the database"
}

variable "db_name" {
  type        = string
  description = "The name of the database"
}

variable "db_username" {
  type        = string
  description = "The username of the database"
}

variable "db_password" {
  type        = string
  description = "The password use to access the database"
}