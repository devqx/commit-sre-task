
## VPC Resources Creation ##

locals {
  name   = "ex-eks-mng"
  region = "eu-north-1"

  vpc_cidr = "10.0.0.0/16"
  azs      = ["eu-north-1a", "eu-north-1b"]

  tags = {
    Example    = local.name
    GithubRepo = "terraform-aws-eks"
    GithubOrg  = "terraform-aws-modules"
  }
}

module "vpc_mod" {
  source                         = "../../modules/vpc" # could be a git repo url
  vpc_name                       = "prod_vpc"
  vpc_availability_zones         = ["eu-north-1a", "eu-north-1b"]
  vpc_private_subnet_cidr_blocks = ["20.100.0.0/20", "20.100.16.0/20"]
  vpc_public_subnet_cidr_blocks  = ["20.100.48.0/20", "20.100.64.0/20"]
  vpc_environment                = "prod"
  vpc_cidr_block                 = "20.100.0.0/16"
}

## EKS Resources Creation ##
module "eks_mod" {
  source = "../../modules/eks" # could be a git repo url
  eks_cluster_name    = "prod_eks_cluster"
  eks_cluster_version = "1.35"
  node_group_instance_types = ["r6i.xlarge"]
  private_subnet_ids = module.vpc_mod.private_subnet_ids
  vpc_id              = module.vpc_mod.vpc_id
}

# module "aws_auth" {
#   source           = "../../modules/aws_auth"
#   aws_auth_roles = [{
#     rolearn = "arn:aws:iam::316336724953:role/terraformer"
#     groups = ["system:masters"]
#     username = "terraformer"
#   }]
#   eks_cluster_name = "prod_eks_cluster"
# }

module "efs" {
  source                 = "../../modules/efs"
  subnet_id              = module.vpc_mod.private_subnet_ids[1]
  node_security_group_id = module.eks_mod.node_security_group_id
  vpc_id                 = module.vpc_mod.vpc_id
  vpc_cidr               = "20.100.0.0/16"
}

module "install_tooling" {
  source = "../../modules/tools"
  cluster_name = "prod_eks_cluster"
  region = "eu-north-1"
  acm_ssl_cert_arn = ""
  cidr_block = "20.100.0.0/16"
  ca_role_arn = ""
  git_username = ""
  git_password = ""
  efs_filesystem_id = module.efs.efs_id
  oidc_provider_arn = ""
  aws_efs_role_arn = ""
}

