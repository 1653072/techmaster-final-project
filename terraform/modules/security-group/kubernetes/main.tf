resource "aws_security_group" "kubernetes_sg" {
  name        = "${var.prefix}-${var.environment}-${var.application}"
  description = "Security Group for Kubernetes Instance"

  dynamic "ingress" {
    for_each = var.create_ingress_cidr ? toset(range(length(var.ingress_cidr_from_port))) : []
    content {
      from_port   = var.ingress_cidr_from_port[ingress.key]
      to_port     = var.ingress_cidr_to_port[ingress.key]
      protocol    = var.ingress_cidr_protocol[ingress.key]
      cidr_blocks = var.ingress_cidr_block
      description = var.ingress_cidr_description[ingress.key]
    }
  }

  dynamic "egress" {
    for_each = var.create_egress_cidr ? toset(range(length(var.egress_cidr_from_port))) : []
    content {
      from_port   = var.egress_cidr_from_port[egress.key]
      to_port     = var.egress_cidr_to_port[egress.key]
      protocol    = var.egress_cidr_protocol[egress.key]
      cidr_blocks = var.egress_cidr_block
    }
  }

  tags = merge(
    {
      Name        = "${var.prefix}-${var.environment}-${var.application}"
      Environment = var.environment
      Application = var.application
    },
    var.extra_sg_tags
  )
}
