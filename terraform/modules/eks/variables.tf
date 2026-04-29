#############################
## EKS cluster resources ##
#############################

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "aws_eks_module_version" {
  type        = string
  description = "AWS EKS Module Version"
  default     = "6.17.0"

}

variable "eks_cluster_version" {
  type        = string
  description = "AWS EKS Cluster Version"
  default     = "1.35"
}

variable "eks_cluster_name" {
  type        = string
  description = "AWS EKS Cluster Name"
  default     = "prod_eks_cluster"

}

variable "eks_environment" {
  type    = string
  default = "prod"
}

variable "node_group_instance_ami_type" {
  default = "AL2023_x86_64_STANDARD"
}

variable "node_group_instance_disk_size" {
  type    = number
  default = 100
}

variable "node_group_instance_types" {
  type = list(string)
}

variable "eks_cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "eks_cluster_endpoint_public_access" {
  type    = bool
  default = true
}

############################
## Node Group             ##
###########################

variable "node_group_instances_min_size" {
  type    = number
  default = 0
}

variable "node_group_instances_max_size" {
  type    = number
  default = 2
}

variable "node_group_instances_desire_size" {
  type    = number
  default = 1
}

###########################
## Cluster Addons       ##

variable "aws-efs-csi-driver" {
  type = object({
    resolve_conflicts = string
    addon_version = string
  })

  default = {
    addon_version = "v3.0.1-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }

}
variable "coredns" {
  type = object({
    resolve_conflicts = string
    addon_version = string
  })

  default = {
    addon_version = "v1.12.4-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
}

variable "kube-proxy" {
  type = object({
    resolve_conflicts = string
    addon_version = string
  })

  default = {
    addon_version = "v1.33.3-eksbuild.10"
    resolve_conflicts = "OVERWRITE"
  }
}

variable "vpc-cni" {
  type = object({
    resolve_conflicts = string
    addon_version = string
  })

  default = {
    addon_version = "v1.20.3-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
}

variable "adot" {
  type = object({
    resolve_conflicts = string
    addon_version = string
  })

  default = {
    addon_version = "v0.109.0-eksbuild.2"
    resolve_conflicts = "OVERWRITE"
  }
}

variable "aws-ebs-csi-driver" {
  type = object({
    resolve_conflicts = string
    addon_version = string
  })

  default = {
    addon_version = "v1.37.0-eksbuild.1"
    resolve_conflicts = "OVERWRITE"
  }
}


