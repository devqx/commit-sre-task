terraform {
  required_version = ">= 1.5.0"
  required_providers {

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubernetes_manifest" "create-storage-class" {
  manifest = yamldecode(file("${path.module}/manifests/storage-class.yml"))
}