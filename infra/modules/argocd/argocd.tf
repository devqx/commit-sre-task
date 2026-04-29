terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}


resource "helm_release" "argocd" {
  name = "argocd"
  chart = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  namespace = "argo-cd"
  reuse_values = true
  max_history = 5
  cleanup_on_fail = true
  create_namespace = true
  values = [
    file(
      "${path.module}/manifests/argocd.yml"
    )
  ]
}

resource "kubectl_manifest" "prod-eks-cluster-appset" {
  depends_on = [
    helm_release.argocd
  ]
  yaml_body = file("${path.module}/manifests/appset.yml")
}
