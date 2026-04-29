terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "3.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.38.0"
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
  yaml_body = file("${path.module}/manifests/argocd/argocd-appset.yml")
}

resource "kubectl_manifest" "create-argocd-project" {
  yaml_body = file("${path.module}/manifests/argocd/argocd-project-prod.yml")
}


resource "kubectl_manifest" "create-argocd-repo-credentials" {
  yaml_body = templatefile("${path.module}/manifests/argocd/repos-credentials-template.yml", {
    git_username = var.git_username
    git_password = var.git_password
  })


}

resource "kubectl_manifest" "create-argocd-helm-charts-repository" {
  yaml_body = templatefile("${path.module}/manifests/argocd/add-helm-charts-repository.yml", {
    git_username = var.git_username
    git_password = var.git_password
  })
}

resource "kubectl_manifest" "create-argocd-git-apps-repository" {
  yaml_body = file("${path.module}/manifests/argocd/add-git-apps-repository.yml")
}

resource "kubectl_manifest" "create-argocd-ingress" {
  yaml_body = file("${path.module}/manifests/argocd/argocd-ingress.yml")
}
