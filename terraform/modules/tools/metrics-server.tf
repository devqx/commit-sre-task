resource "helm_release" "metrics_server" {
  chart = "metrics-server"
  name  = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  version = "3.8.3"
  reuse_values = true
  cleanup_on_fail = true
  create_namespace = true
}