resource "aws_efs_file_system" "efs" {
  creation_token = var.efs_creation_token

  performance_mode = var.efs_performance_mode
  throughput_mode  = var.efs_throughput_mode

  lifecycle_policy {
    transition_to_ia = var.efs_transaction_to_ia_period
  }
}

resource "aws_security_group" "efs" {
  name   = var.efs_sg_name
  vpc_id = var.vpc_id

  ingress {
    from_port   = 2049
    to_port     = 2049
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }
}

resource "aws_efs_mount_target" "efs_mount_target" {
  file_system_id  = aws_efs_file_system.efs.id
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.efs.id]
}