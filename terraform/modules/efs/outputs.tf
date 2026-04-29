output "efs_id" {
  value = aws_efs_file_system.efs.id
}

output "efs_access_point_id" {
  value = aws_efs_mount_target.efs_mount_target.id
}