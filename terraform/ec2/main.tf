// AWS EC2 for CICD services
resource "aws_instance" "ec2_instance_cicd" {
  ami           = var.aws_instance_config_map["common"].ami_id
  key_name      = var.aws_instance_config_map["common"].key_name
  instance_type = var.aws_instance_config_map["cicd"].instance_type
  count         = var.aws_instance_config_map["cicd"].instance_count
  user_data     = base64encode(file("${path.module}/setup_cicd.sh"))

  root_block_device {
    volume_size = var.aws_instance_config_map["cicd"].volume_size # Size in GB
    volume_type = "gp2"           # EBS volume type
  }

  vpc_security_group_ids = var.security_group_ids

  tags = merge(
    {
      Name        = "${var.aws_instance_config_map["cicd"].prefix}-${var.aws_instance_config_map["cicd"].environment}-${var.aws_instance_config_map["cicd"].name}"
      Environment = var.aws_instance_config_map["cicd"].environment
      Application = var.aws_instance_config_map["cicd"].application
    },
    var.tags
  )
}

// AWS EC2 for monitoring services
resource "aws_instance" "ec2_instance_monitoring" {
  ami           = var.aws_instance_config_map["common"].ami_id
  key_name      = var.aws_instance_config_map["common"].key_name
  instance_type = var.aws_instance_config_map["monitoring"].instance_type
  count         = var.aws_instance_config_map["monitoring"].instance_count
  user_data     = base64encode(file("${path.module}/setup_monitoring.sh"))

  root_block_device {
    volume_size = var.aws_instance_config_map["monitoring"].volume_size # Size in GB
    volume_type = "gp2"           # EBS volume type
  }

  vpc_security_group_ids = var.security_group_ids

  tags = merge(
    {
      Name        = "${var.aws_instance_config_map["monitoring"].prefix}-${var.aws_instance_config_map["monitoring"].environment}-${var.aws_instance_config_map["monitoring"].name}"
      Environment = var.aws_instance_config_map["monitoring"].environment
      Application = var.aws_instance_config_map["monitoring"].application
    },
    var.tags
  )
}

// AWS EC2 for Kubernetes services
resource "aws_instance" "ec2_instance_kubernetes" {
  ami           = var.aws_instance_config_map["common"].ami_id
  key_name      = var.aws_instance_config_map["common"].key_name
  instance_type = var.aws_instance_config_map["kubernetes"].instance_type
  count         = var.aws_instance_config_map["kubernetes"].instance_count
  user_data     = base64encode(file("${path.module}/setup_kubernetes.sh"))

  root_block_device {
    volume_size = var.aws_instance_config_map["kubernetes"].volume_size # Size in GB
    volume_type = "gp2"           # EBS volume type
  }

  vpc_security_group_ids = var.security_group_ids

  tags = merge(
    {
      Name        = "${var.aws_instance_config_map["kubernetes"].prefix}-${var.aws_instance_config_map["kubernetes"].environment}-${var.aws_instance_config_map["kubernetes"].name}"
      Environment = var.aws_instance_config_map["kubernetes"].environment
      Application = var.aws_instance_config_map["kubernetes"].application
    },
    var.tags
  )
}
