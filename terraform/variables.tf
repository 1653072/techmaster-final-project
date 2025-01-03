variable "default_region" {
  type        = string
  description = "Default AWS region"
}

variable "initial_argocd_admin_password" {
  type        = string
  sensitive   = true
  description = "Initial ArgoCD Admin password"
}

variable "aws_instance_config_map" {
  description = "Configuration map for AWS instances"
  type = map(object({
    region         = string
    ami_id         = string
    key_name       = string
    instance_type  = string
    instance_count = number
    volume_size    = number
    volume_type    = string
    application    = string
    name           = string
    prefix         = string
    environment    = string

    extra_sg_tags            = map(string)
    create_ingress_cidr      = bool
    ingress_cidr_from_port   = list(number)
    ingress_cidr_to_port     = list(number)
    ingress_cidr_protocol    = list(string)
    ingress_cidr_block       = list(string)
    ingress_cidr_description = list(string)

    create_egress_cidr    = bool
    egress_cidr_from_port = list(number)
    egress_cidr_to_port   = list(number)
    egress_cidr_protocol  = list(string)
    egress_cidr_block     = list(string)
  }))
}