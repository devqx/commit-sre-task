terraform {
  required_version = ">= 1.5.0"
  required_providers {

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}

resource "kubectl_manifest" "create-storage-class" {
  yaml_body = file("${path.module}/manifests/storage-class.yml")
}