terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  namespace  = "karpenter"

  values = [
    templatefile("${path.module}/manifests/karpenter.yml", {
      clusterName = var.cluster_name
      clusterEndpoint = var.cluster_endpoint
    })
  ]
}

resource "kubectl_manifest" "create-karpenter-provisioner" {
  yaml_body = file("${path.module}/manifests/karpenter-provisioner.yml")
}

