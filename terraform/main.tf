provider "aws" {
  region = var.default_region
}

module "ec2_cicd" {
  source                        = "./modules/ec2/cicd"
  region                        = var.aws_instance_config_map["cicd"].region
  ami_id                        = var.aws_instance_config_map["cicd"].ami_id
  key_name                      = var.aws_instance_config_map["cicd"].key_name
  instance_type                 = var.aws_instance_config_map["cicd"].instance_type
  instance_count                = var.aws_instance_config_map["cicd"].instance_count
  volume_size                   = var.aws_instance_config_map["cicd"].volume_size
  volume_type                   = var.aws_instance_config_map["cicd"].volume_type
  environment                   = var.aws_instance_config_map["cicd"].environment
  application                   = var.aws_instance_config_map["cicd"].application
  name                          = var.aws_instance_config_map["cicd"].name
  prefix                        = var.aws_instance_config_map["cicd"].prefix
  security_group_ids            = module.security_group_cicd.cicd_security_group_ids
  initial_argocd_admin_password = var.initial_argocd_admin_password
}

module "ec2_monitoring" {
  source                         = "./modules/ec2/monitoring"
  region                         = var.aws_instance_config_map["monitoring"].region
  ami_id                         = var.aws_instance_config_map["monitoring"].ami_id
  key_name                       = var.aws_instance_config_map["monitoring"].key_name
  instance_type                  = var.aws_instance_config_map["monitoring"].instance_type
  instance_count                 = var.aws_instance_config_map["monitoring"].instance_count
  volume_size                    = var.aws_instance_config_map["monitoring"].volume_size
  volume_type                    = var.aws_instance_config_map["monitoring"].volume_type
  environment                    = var.aws_instance_config_map["monitoring"].environment
  application                    = var.aws_instance_config_map["monitoring"].application
  name                           = var.aws_instance_config_map["monitoring"].name
  prefix                         = var.aws_instance_config_map["monitoring"].prefix
  security_group_ids             = module.security_group_monitoring.monitoring_security_group_ids
  cicd_instance_public_ips       = module.ec2_cicd.cicd_instance_public_ips
  kubernetes_instance_public_ips = module.ec2_kubernetes.kubernetes_instance_public_ips
  depends_on                     = [module.ec2_cicd, module.ec2_kubernetes]
}

module "ec2_kubernetes" {
  source                        = "./modules/ec2/kubernetes"
  region                        = var.aws_instance_config_map["kubernetes"].region
  ami_id                        = var.aws_instance_config_map["kubernetes"].ami_id
  key_name                      = var.aws_instance_config_map["kubernetes"].key_name
  instance_type                 = var.aws_instance_config_map["kubernetes"].instance_type
  instance_count                = var.aws_instance_config_map["kubernetes"].instance_count
  volume_size                   = var.aws_instance_config_map["kubernetes"].volume_size
  volume_type                   = var.aws_instance_config_map["kubernetes"].volume_type
  environment                   = var.aws_instance_config_map["kubernetes"].environment
  application                   = var.aws_instance_config_map["kubernetes"].application
  name                          = var.aws_instance_config_map["kubernetes"].name
  prefix                        = var.aws_instance_config_map["kubernetes"].prefix
  security_group_ids            = module.security_group_kubernetes.kubernetes_security_group_ids
  cicd_instance_public_ips      = module.ec2_cicd.cicd_instance_public_ips
  initial_argocd_admin_password = var.initial_argocd_admin_password
  depends_on                    = [module.ec2_cicd]
}

module "security_group_cicd" {
  source = "./modules/security-group/cicd"

  region      = var.aws_instance_config_map["cicd"].region
  name        = var.aws_instance_config_map["cicd"].name
  prefix      = var.aws_instance_config_map["cicd"].prefix
  environment = var.aws_instance_config_map["cicd"].environment
  application = var.aws_instance_config_map["cicd"].application

  extra_sg_tags            = var.aws_instance_config_map["cicd"].extra_sg_tags
  ingress_cidr_from_port   = var.aws_instance_config_map["cicd"].ingress_cidr_from_port
  ingress_cidr_to_port     = var.aws_instance_config_map["cicd"].ingress_cidr_to_port
  ingress_cidr_protocol    = var.aws_instance_config_map["cicd"].ingress_cidr_protocol
  ingress_cidr_block       = var.aws_instance_config_map["cicd"].ingress_cidr_block
  ingress_cidr_description = var.aws_instance_config_map["cicd"].ingress_cidr_description
  create_ingress_cidr      = var.aws_instance_config_map["cicd"].create_ingress_cidr

  egress_cidr_from_port = var.aws_instance_config_map["cicd"].egress_cidr_from_port
  egress_cidr_to_port   = var.aws_instance_config_map["cicd"].egress_cidr_to_port
  egress_cidr_protocol  = var.aws_instance_config_map["cicd"].egress_cidr_protocol
  egress_cidr_block     = var.aws_instance_config_map["cicd"].egress_cidr_block
  create_egress_cidr    = var.aws_instance_config_map["cicd"].create_egress_cidr
}

module "security_group_monitoring" {
  source = "./modules/security-group/monitoring"

  region      = var.aws_instance_config_map["monitoring"].region
  name        = var.aws_instance_config_map["monitoring"].name
  prefix      = var.aws_instance_config_map["monitoring"].prefix
  environment = var.aws_instance_config_map["monitoring"].environment
  application = var.aws_instance_config_map["monitoring"].application

  extra_sg_tags            = var.aws_instance_config_map["monitoring"].extra_sg_tags
  ingress_cidr_from_port   = var.aws_instance_config_map["monitoring"].ingress_cidr_from_port
  ingress_cidr_to_port     = var.aws_instance_config_map["monitoring"].ingress_cidr_to_port
  ingress_cidr_protocol    = var.aws_instance_config_map["monitoring"].ingress_cidr_protocol
  ingress_cidr_block       = var.aws_instance_config_map["monitoring"].ingress_cidr_block
  ingress_cidr_description = var.aws_instance_config_map["monitoring"].ingress_cidr_description
  create_ingress_cidr      = var.aws_instance_config_map["monitoring"].create_ingress_cidr

  egress_cidr_from_port = var.aws_instance_config_map["monitoring"].egress_cidr_from_port
  egress_cidr_to_port   = var.aws_instance_config_map["monitoring"].egress_cidr_to_port
  egress_cidr_protocol  = var.aws_instance_config_map["monitoring"].egress_cidr_protocol
  egress_cidr_block     = var.aws_instance_config_map["monitoring"].egress_cidr_block
  create_egress_cidr    = var.aws_instance_config_map["monitoring"].create_egress_cidr
}

module "security_group_kubernetes" {
  source = "./modules/security-group/kubernetes"

  region      = var.aws_instance_config_map["kubernetes"].region
  name        = var.aws_instance_config_map["kubernetes"].name
  prefix      = var.aws_instance_config_map["kubernetes"].prefix
  environment = var.aws_instance_config_map["kubernetes"].environment
  application = var.aws_instance_config_map["kubernetes"].application

  extra_sg_tags            = var.aws_instance_config_map["kubernetes"].extra_sg_tags
  ingress_cidr_from_port   = var.aws_instance_config_map["kubernetes"].ingress_cidr_from_port
  ingress_cidr_to_port     = var.aws_instance_config_map["kubernetes"].ingress_cidr_to_port
  ingress_cidr_protocol    = var.aws_instance_config_map["kubernetes"].ingress_cidr_protocol
  ingress_cidr_block       = var.aws_instance_config_map["kubernetes"].ingress_cidr_block
  ingress_cidr_description = var.aws_instance_config_map["kubernetes"].ingress_cidr_description
  create_ingress_cidr      = var.aws_instance_config_map["kubernetes"].create_ingress_cidr

  egress_cidr_from_port = var.aws_instance_config_map["kubernetes"].egress_cidr_from_port
  egress_cidr_to_port   = var.aws_instance_config_map["kubernetes"].egress_cidr_to_port
  egress_cidr_protocol  = var.aws_instance_config_map["kubernetes"].egress_cidr_protocol
  egress_cidr_block     = var.aws_instance_config_map["kubernetes"].egress_cidr_block
  create_egress_cidr    = var.aws_instance_config_map["kubernetes"].create_egress_cidr
}
