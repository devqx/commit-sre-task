variable "vpc_module_version" {
  type        = string
  description = "AWS vpc module version"
  default     = "6.17.0"
}

variable "vpc_name" {
  type        = string
  description = "VPC name"
}

variable "vpc_cidr_block" {
  type        = string
  description = "VPC network Cidr"
}

variable "vpc_availability_zones" {
  type        = list(string)
  description = "Availability Zones for the subnets creation for high availability"
}

variable "vpc_private_subnet_cidr_blocks" {
  type        = list(string)
  description = "Private subnets for the VPC"
}

variable "vpc_public_subnet_cidr_blocks" {
  type        = list(string)
  description = "Public subnets for the VPC"
}

variable "vpc_enable_nat_gateway" {
  type        = bool
  default     = true
  description = "Enable or disable nat gateway creation and attachment to the vpc"
}

variable "vpc_environment" {
  type        = string
  description = "VPC Environment"

}