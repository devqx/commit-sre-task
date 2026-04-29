terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}



resource "kubernetes_manifest" "log-generator-deployment" {
  manifest = yamldecode(file("${path.module}/apps/base/log-reader/deployment.yaml"))
}

resource "kubernetes_manifest" "log-generator-pvc" {
  manifest = yamldecode(file("${path.module}/apps/base/log-reader/pvc.yaml"))
}

resource "helm_release" "install-log-reader-app" {
  chart = "${path.module}/apps/base/log-generator-app/chart"
  name  = "log-reader-app"
  values = [
    file("${path.module}/apps/environments/dev/log-writer-app-values.yaml")
  ]
}






