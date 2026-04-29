terraform {

  backend "s3" {
    bucket  = "eu-north-1-prod-eks-terraform-bucket"
    region  = "eu-north-1"
    key     = "prod/state/terraform.tfstate"
    encrypt = true
  }

  required_version = ">=1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
  assume_role {
    role_arn = "arn:aws:iam::316336724953:role/terraformer"
  }
  allowed_account_ids = ["316336724953"]
}

provider "kubernetes" {
  host = module.eks_mod.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_mod.cluster_ca_certificate)
  token = module.eks_mod.eks_token
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args = ["eks", "get-token", "--cluster-name", module.eks_mod.cluster_name]
    command     = "aws"
  }
}

provider "helm" {
  kubernetes = {
    host = module.eks_mod.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks_mod.cluster_ca_certificate)
    token = module.eks_mod.eks_token
    exec = {
      api_version = "client.authentication.k8s.io/v1beta1"
      args = ["eks", "get-token", "--cluster-name", module.eks_mod.cluster_name]
      command     = "aws"
    }
  }
}


