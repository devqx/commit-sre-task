
resource "kubernetes_storage_class" "prod-efs-storage-class" {
  metadata {
    name = "prod-efs-storage-class"
  }
  storage_provisioner = "efs.csi.aws.com"
  parameters = {
    provisioningMode = "efs-ap"
    fileSystemId = var.efs_filesystem_id
    directoryPerms = "700"
  }
}