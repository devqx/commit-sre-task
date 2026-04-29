module "vpc" {
  source               = "terraform-aws-modules/vpc/aws"
  version              = "~> 6.0"
  name                 = var.vpc_name
  cidr                 = var.vpc_cidr_block
  azs                  = var.vpc_availability_zones
  private_subnets      = var.vpc_private_subnet_cidr_blocks
  public_subnets       = var.vpc_public_subnet_cidr_blocks
  enable_nat_gateway   = var.vpc_enable_nat_gateway
  enable_dns_hostnames = true
  map_public_ip_on_launch = true
  single_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = 1
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = 1
  }

  tags = {
    Terraform   = "true"
    Environment = var.vpc_environment
  }
}
