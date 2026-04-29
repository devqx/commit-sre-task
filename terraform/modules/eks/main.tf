
module "eks_cluster" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.18.0"
  name                      = var.eks_cluster_name
  kubernetes_version        = var.eks_cluster_version
  vpc_id                    = var.vpc_id
  subnet_ids                = var.private_subnet_ids
  endpoint_private_access   = var.eks_cluster_endpoint_private_access
  endpoint_public_access    = var.eks_cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = true
  create_cloudwatch_log_group = false

  addons = {
    coredns = {}
    aws-efs-csi-driver = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    # adot = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    node_group_1 = {
      ami_type       = var.node_group_instance_ami_type
      disk_size      = var.node_group_instance_disk_size
      instance_types = var.node_group_instance_types
      labels = {
        Environment  = var.eks_environment
        "Managed_By" = "terraform"
      }
      tags = {
        Environment = var.eks_environment
        Terraform = "true"
        "k8s.io/cluster-autoscaler/${var.eks_environment}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
      min_size    = var.node_group_instances_min_size
      max_size    = var.node_group_instances_max_size
      desire_size = var.node_group_instances_desire_size
      subnet_ids  = [var.private_subnet_ids[0]]
    }

    node_group_2 = {
      ami_type       = var.node_group_instance_ami_type
      disk_size      = var.node_group_instance_disk_size
      instance_types = var.node_group_instance_types
      labels = {
        Environment  = var.eks_environment
        "Managed_By" = "terraform"
      }
      tags = {
        Environment = var.eks_environment
        Terraform = "true"
        "k8s.io/cluster-autoscaler/${var.eks_environment}" = "owned"
        "k8s.io/cluster-autoscaler/enabled" = "true"
      }
      min_size    = var.node_group_instances_min_size
      max_size    = var.node_group_instances_max_size
      desire_size = var.node_group_instances_desire_size
      subnet_ids  = [var.private_subnet_ids[1]]
    }
  }

  security_group_additional_rules = {
    egress_nodes_ephemeral_ports_tcp = {
      description                = "To node 1025-65535"
      protocol                   = "tcp"
      from_port                  = 1025
      to_port                    = 65535
      type                       = "egress"
      source_node_security_group = true
    }
  }

  node_security_group_additional_rules = {
    ingress_self_all = {
      description = "Node to node all ports/protocols"
      protocol    = "-1"
      from_port   = 0
      to_port     = 0
      type        = "ingress"
      self        = true
    }

    ingress_cluster_control_plane = {
      description                   = "From Control plane security group"
      protocol                      = "tcp"
      from_port                     = 1025
      to_port                       = 65535
      type                          = "ingress"
      source_cluster_security_group = true
    }

    egress_all = {
      description      = "Node all egress"
      protocol         = "-1"
      from_port        = 0
      to_port          = 0
      type             = "egress"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  tags = {
    Environment                                         = var.eks_environment
    Terraform                                           = "true"
    "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                 = "true"
  }

}

module "aws_auth" {
  source           = "../../modules/aws_auth"
  aws_auth_roles = [
    {
      rolearn = "arn:aws:iam::316336724953:role/terraformer"
      username = "terraformer"
      groups   = ["system:masters"]
    }
  ]
  eks_cluster_name = module.eks_cluster.cluster_name
}

data "aws_eks_cluster_auth" "eks_cluster" {
    name = module.eks_cluster.cluster_name
}


