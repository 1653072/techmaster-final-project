resource "aws_instance" "ec2_instance_monitoring" {
  ami           = var.ami_id
  key_name      = var.key_name
  instance_type = var.instance_type
  count         = var.instance_count
  user_data = base64encode(templatefile("${path.module}/setup_monitoring.sh", {
    CICD_INSTANCE_PUBLIC_IPS       = join(" ", var.cicd_instance_public_ips),
    KUBERNETES_INSTANCE_PUBLIC_IPS = join(" ", var.kubernetes_instance_public_ips),
  }))

  timeouts {
    create = "20m"
    update = "20m"
    delete = "20m"
  }

  root_block_device {
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  vpc_security_group_ids = var.security_group_ids

  tags = merge(
    {
      Name        = "${var.prefix}-${var.environment}-${var.name}"
      Environment = var.environment
      Application = var.application
    },
    var.tags
  )
}
