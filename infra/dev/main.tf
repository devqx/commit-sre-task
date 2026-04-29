## VPC Resources Creation ##

locals {
  cluster_name = "dev_eks_cluster"
  vpc_cidr_block = "20.100.0.0/16"
  environment = "dev"
  vpc_name = "dev_vpc"
  cluster_version = "1.35"
}

module "vpc_mod" {
  source                         = "../modules/vpc" # could be a git repo url
  vpc_name                       = local.vpc_name
  vpc_availability_zones         = ["eu-north-1a", "eu-north-1b"]
  vpc_private_subnet_cidr_blocks = ["20.100.0.0/20", "20.100.16.0/20"]
  vpc_public_subnet_cidr_blocks  = ["20.100.48.0/20", "20.100.64.0/20"]
  vpc_environment                = local.environment
  vpc_cidr_block                 = local.vpc_cidr_block
}

## EKS Resources Creation ##

module "eks_mod" {
  source = "../modules/eks" # could be a git repo url
  eks_cluster_name    = local.cluster_name
  eks_cluster_version = local.cluster_version
  node_group_instance_types = ["r6i.xlarge"]
  private_subnet_ids = module.vpc_mod.private_subnet_ids
  vpc_id              = module.vpc_mod.vpc_id
}

module "efs-csi" {
  source           = "../modules/efs-csi"
  cluster_resource = module.eks_mod
}

## EKS Resources Creation ##

module "efs" {
  source                 = "../modules/efs"
  subnet_id              = module.vpc_mod.private_subnet_ids[1]
  vpc_id                 = module.vpc_mod.vpc_id
  vpc_cidr               = local.vpc_cidr_block
  efs_sg_name            = "efs-sg"

}

module "karpenter" {
  source           = "../modules/karpenter"
  cluster_name     = local.cluster_name
  cluster_endpoint = module.eks_mod.cluster_endpoint
}

module "storage-class" {
  source = "../modules/storage"
}

module "argocd" {
  source       = "../modules/argocd"
  git_password = "xxxx"
  git_username = "xxxx"
}

module "install_apps" {
  source   = "../modules/install_apps"
  pvc_name = "shared-efs-pvc"
}

