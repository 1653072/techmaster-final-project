# EC2 Variables & Tags
aws_instance_config_map = {
  common = {
    # EC2 common configs
    region = "ap-southeast-1"
    ami_id = "ami-060e277c0d4cce553"
    key_name = "techmaster - devops - my ubuntu server"

    # CIDR Ingress Variables
    create_ingress_cidr = true
    ingress_cidr_from_port = [22, 80, 443, 9090, 3000, 8080, 9080]             # List of from ports
    ingress_cidr_to_port = [22, 80, 443, 9090, 3000, 8080, 9080]             # List of to ports
    ingress_cidr_protocol = ["tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp"]
    # Protocol for all rules (you can add more if needed)
    ingress_cidr_block  = [
      "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"
    ]
    ingress_cidr_description = [
      "SSH", "HTTP", "HTTPS", "Prometheus", "Grafana", "Jenkins", "ArgoCD"
    ]

    # CIDR Egress Variables
    create_egress_cidr    = true
    egress_cidr_from_port = [0]
    egress_cidr_to_port   = [0]
    egress_cidr_protocol  = ["-1"]
    egress_cidr_block     = ["0.0.0.0/0"]
  }
  cicd = {
    instance_type  = "t3a.medium"
    instance_count = 1
    volume_size    = 15
    application    = "cicd"
    name           = "cicd"
    prefix         = "quoctran"
    environment    = "all"
  }
  monitoring = {
    instance_type  = "t3a.medium"
    instance_count = 1
    volume_size    = 15
    application    = "monitoring"
    name           = "monitoring"
    prefix         = "quoctran"
    environment    = "all"
  }
  kubernetes = {
    instance_type  = "t3a.medium"
    instance_count = 1
    volume_size    = 15
    application    = "kubernetes"
    name           = "kubernetes"
    prefix         = "quoctran"
    environment    = "all"
  }
}

