variable "tags" {
  default     = {}
  type        = map(string)
  description = "Extra tags to attach to the EC2 security group resources."
}

variable "aws_instance_config_map" {
  description = "Configuration map for AWS instances"
  type        = map(object({
    region        = string
    ami_id        = string
    instance_type = string
    key_name      = string

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

    instance_count = number
    volume_size    = number
    application    = string
    name           = string
    prefix         = string
    environment    = string
  }))
}