variable "security_group_ids" {
  description = "List of security group IDs to attach to the EC2 instance."
  type        = list(string)
}

variable "tags" {
  default = {}
  type        = map(string)
  description = "Extra tags to attach to the ec2-sg resources"
}

variable "aws_instance_config_map" {
  description = "Configuration map for AWS instances"
  type        = map(object({
    region   = string
    ami_id   = string
    key_name = string

    instance_type  = string
    instance_count = number
    volume_size    = number
    application    = string
    name           = string
    prefix         = string
    environment    = string
  }))
}