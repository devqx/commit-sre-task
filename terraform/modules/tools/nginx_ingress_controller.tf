
resource "helm_release" "ingress_nginx" {
  chart = "ingress-nginx"
  name  = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  namespace = "ingress-nginx"
  reuse_values = true
  cleanup_on_fail = true
  create_namespace = true
  values = [
    templatefile(
      "${path.module}/manifests/nginx.yml",
      {
        acm_ssl_cert_arn = var.acm_ssl_cert_arn
        cidr_block = var.cidr_block
      }
    )
  ]
}
