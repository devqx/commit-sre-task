output "cluster_name" {
  description = "The name of the EKS Cluster"
  value = module.eks_cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.eks_cluster.cluster_endpoint
}

output "cluster_ca_certificate" {
  value = module.eks_cluster.cluster_certificate_authority_data
}

output "eks_token" {
  value = data.aws_eks_cluster_auth.eks_cluster.token
}

output "environment" {
  value = var.eks_environment
}

output "node_security_group_id" {
  value = module.eks_cluster.node_security_group_id
}