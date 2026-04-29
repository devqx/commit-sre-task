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

variable "vpc_id" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "efs_sg_name" {
  type = string
  default = "efs-sg"
}

variable "efs_creation_token" {
  default = "efs-one-zone"
  type = string
}

variable "efs_transaction_to_ia_period" {
  default = "AFTER_30_DAYS"
  type = string
}