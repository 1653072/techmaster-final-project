resource "aws_security_group" "cicd_sg" {
  name        = "${var.aws_instance_config_map["cicd"].prefix}-${var.aws_instance_config_map["cicd"].environment}-${var.aws_instance_config_map["cicd"].application}"
  description = "Security Group for CICD Instance"

  dynamic "ingress" {
    for_each = var.aws_instance_config_map["common"].create_ingress_cidr ?
      toset(range(length(var.aws_instance_config_map["common"].ingress_cidr_from_port))) : []
    content {
      from_port   = var.aws_instance_config_map["common"].ingress_cidr_from_port[ingress.key]
      to_port     = var.aws_instance_config_map["common"].ingress_cidr_to_port[ingress.key]
      protocol    = var.aws_instance_config_map["common"].ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.aws_instance_config_map["common"].ingress_cidr_block
      description = var.aws_instance_config_map["common"].ingress_cidr_description[ingress.key]
    }
  }

  dynamic "egress" {
    for_each = var.aws_instance_config_map["common"].create_egress_cidr ?
      toset(range(length(var.aws_instance_config_map["common"].egress_cidr_from_port))) : []
    content {
      from_port   = var.aws_instance_config_map["common"].egress_cidr_from_port[egress.key]
      to_port     = var.aws_instance_config_map["common"].egress_cidr_to_port[egress.key]
      protocol    = var.aws_instance_config_map["common"].egress_cidr_protocol[egress.key]
      cidr_blocks = var.aws_instance_config_map["common"].egress_cidr_block
    }
  }

  tags = merge(
    {
      Name        = "${var.aws_instance_config_map["cicd"].prefix}-${var.aws_instance_config_map["cicd"].environment}-${var.aws_instance_config_map["cicd"].application}"
      Environment = var.aws_instance_config_map["cicd"].environment
      Application = var.aws_instance_config_map["cicd"].application
    },
    var.tags
  )
}

resource "aws_security_group" "monitoring_sg" {
  name        = "${var.aws_instance_config_map["monitoring"].prefix}-${var.aws_instance_config_map["monitoring"].environment}-${var.aws_instance_config_map["monitoring"].application}"
  description = "Security Group for Monitoring Instance"

  dynamic "ingress" {
    for_each = var.aws_instance_config_map["common"].create_ingress_cidr ?
      toset(range(length(var.aws_instance_config_map["common"].ingress_cidr_from_port))) : []
    content {
      from_port   = var.aws_instance_config_map["common"].ingress_cidr_from_port[ingress.key]
      to_port     = var.aws_instance_config_map["common"].ingress_cidr_to_port[ingress.key]
      protocol    = var.aws_instance_config_map["common"].ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.aws_instance_config_map["common"].ingress_cidr_block
      description = var.aws_instance_config_map["common"].ingress_cidr_description[ingress.key]
    }
  }

  dynamic "egress" {
    for_each = var.aws_instance_config_map["common"].create_egress_cidr ?
      toset(range(length(var.aws_instance_config_map["common"].egress_cidr_from_port))) : []
    content {
      from_port   = var.aws_instance_config_map["common"].egress_cidr_from_port[egress.key]
      to_port     = var.aws_instance_config_map["common"].egress_cidr_to_port[egress.key]
      protocol    = var.aws_instance_config_map["common"].egress_cidr_protocol[egress.key]
      cidr_blocks = var.aws_instance_config_map["common"].egress_cidr_block
    }
  }

  tags = merge(
    {
      Name        = "${var.aws_instance_config_map["monitoring"].prefix}-${var.aws_instance_config_map["monitoring"].environment}-${var.aws_instance_config_map["monitoring"].application}"
      Environment = var.aws_instance_config_map["monitoring"].environment
      Application = var.aws_instance_config_map["monitoring"].application
    },
    var.tags
  )
}

resource "aws_security_group" "kubernetes_sg" {
  name        = "${var.aws_instance_config_map["kubernetes"].prefix}-${var.aws_instance_config_map["kubernetes"].environment}-${var.aws_instance_config_map["kubernetes"].application}"
  description = "Security Group for Kubernetes Instance"

  dynamic "ingress" {
    for_each = var.aws_instance_config_map["common"].create_ingress_cidr ?
      toset(range(length(var.aws_instance_config_map["common"].ingress_cidr_from_port))) : []
    content {
      from_port   = var.aws_instance_config_map["common"].ingress_cidr_from_port[ingress.key]
      to_port     = var.aws_instance_config_map["common"].ingress_cidr_to_port[ingress.key]
      protocol    = var.aws_instance_config_map["common"].ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.aws_instance_config_map["common"].ingress_cidr_block
      description = var.aws_instance_config_map["common"].ingress_cidr_description[ingress.key]
    }
  }

  dynamic "egress" {
    for_each = var.aws_instance_config_map["common"].create_egress_cidr ?
      toset(range(length(var.aws_instance_config_map["common"].egress_cidr_from_port))) : []
    content {
      from_port   = var.aws_instance_config_map["common"].egress_cidr_from_port[egress.key]
      to_port     = var.aws_instance_config_map["common"].egress_cidr_to_port[egress.key]
      protocol    = var.aws_instance_config_map["common"].egress_cidr_protocol[egress.key]
      cidr_blocks = var.aws_instance_config_map["common"].egress_cidr_block
    }
  }

  tags = merge(
    {
      Name        = "${var.aws_instance_config_map["kubernetes"].prefix}-${var.aws_instance_config_map["kubernetes"].environment}-${var.aws_instance_config_map["kubernetes"].application}"
      Environment = var.aws_instance_config_map["kubernetes"].environment
      Application = var.aws_instance_config_map["kubernetes"].application
    },
    var.tags
  )
}
