variable "cluster_name" {
  type = string
}
variable "region" {
  type = string
}
variable "ca_role_arn" {
  type = string
}

variable "acm_ssl_cert_arn" {
  type = string
}

variable "cidr_block" {
  type = string
}

variable "git_username" {
  type = string
}
variable "git_password" {
  type = string
}

variable "efs_filesystem_id" {
  type = string
}

variable "oidc_provider_arn" {
  type = string
}

variable "aws_efs_role_arn" {
  type = string
}