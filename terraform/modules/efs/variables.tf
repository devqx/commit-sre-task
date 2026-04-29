variable "efs_availability_zone_name" {
  type = string
  default = "eu-north-1b"
}

variable "efs_performance_mode" {
  type = string
  default = "generalPurpose"
}

variable "efs_throughput_mode" {
  type = string
  default = "bursting"
}

variable "subnet_id" {
  type = string
}
variable "node_security_group_id" {
  type = string
}

variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
  type = string
}