// Default AWS region
default_region = "ap-southeast-1"

// Initial ArgoCD admin password
initial_argocd_admin_password = "admin@123"

# EC2 Variables & Tags
aws_instance_config_map = {
  cicd = {
    # EC2 common configs
    region         = "ap-southeast-1"
    ami_id         = "ami-060e277c0d4cce553"
    key_name       = "techmaster - devops - my ubuntu server"
    instance_type  = "t3a.medium"
    instance_count = 1
    volume_size    = 25
    volume_type    = "gp2"
    application    = "cicd"
    name           = "cicd"
    prefix         = "quoctran"
    environment    = "all"

    # CIDR Ingress Variables
    extra_sg_tags          = {}
    create_ingress_cidr    = true
    ingress_cidr_from_port = [22, 80, 443, 8080, 8081, 9100, 9080, 9082, 9083, 9084] # List of from ports
    ingress_cidr_to_port   = [22, 80, 443, 8080, 8081, 9100, 9080, 9082, 9083, 9084] # List of to ports
    ingress_cidr_protocol  = ["tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp"]
    # Protocol for all rules (you can add more if needed)
    ingress_cidr_block = [
      "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"
    ]
    ingress_cidr_description = [
      "SSH", "HTTP", "HTTPS", "Jenkins", "cAdvisor", "Prometheus-Node-Exporter", "ArgoCD-Server", "ArgoCD-Metrics", "ArgoCD-Server-Metrics", "ArgoCD-Repo-Server-Metrics"
    ]

    # CIDR Egress Variables
    create_egress_cidr    = true
    egress_cidr_from_port = [0]
    egress_cidr_to_port   = [0]
    egress_cidr_protocol  = ["-1"]
    egress_cidr_block     = ["0.0.0.0/0"]
  }
  monitoring = {
    # EC2 common configs
    region         = "ap-southeast-1"
    ami_id         = "ami-060e277c0d4cce553"
    key_name       = "techmaster - devops - my ubuntu server"
    instance_type  = "t3a.medium"
    instance_count = 1
    volume_size    = 18
    volume_type    = "gp2"
    application    = "monitoring"
    name           = "monitoring"
    prefix         = "quoctran"
    environment    = "all"

    # CIDR Ingress Variables
    extra_sg_tags          = {}
    create_ingress_cidr    = true
    ingress_cidr_from_port = [22, 80, 443, 9090, 3000] # List of from ports
    ingress_cidr_to_port   = [22, 80, 443, 9090, 3000] # List of to ports
    ingress_cidr_protocol  = ["tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp"]
    # Protocol for all rules (you can add more if needed)
    ingress_cidr_block = [
      "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"
    ]
    ingress_cidr_description = [
      "SSH", "HTTP", "HTTPS", "Prometheus", "Grafana"
    ]

    # CIDR Egress Variables
    create_egress_cidr    = true
    egress_cidr_from_port = [0]
    egress_cidr_to_port   = [0]
    egress_cidr_protocol  = ["-1"]
    egress_cidr_block     = ["0.0.0.0/0"]
  }
  kubernetes = {
    # EC2 common configs
    region         = "ap-southeast-1"
    ami_id         = "ami-060e277c0d4cce553"
    key_name       = "techmaster - devops - my ubuntu server"
    instance_type  = "t3a.medium"
    instance_count = 1
    volume_size    = 15
    volume_type    = "gp2"
    application    = "kubernetes"
    name           = "kubernetes"
    prefix         = "quoctran"
    environment    = "all"

    # CIDR Ingress Variables
    extra_sg_tags          = {}
    create_ingress_cidr    = true
    ingress_cidr_from_port = [22, 80, 443, 9100] # List of from ports
    ingress_cidr_to_port   = [22, 80, 443, 9100] # List of to ports
    ingress_cidr_protocol  = ["tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp", "tcp"]
    # Protocol for all rules (you can add more if needed)
    ingress_cidr_block = [
      "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0", "0.0.0.0/0"
    ]
    ingress_cidr_description = [
      "SSH", "HTTP", "HTTPS", "Prometheus-Node-Exporter"
    ]

    # CIDR Egress Variables
    create_egress_cidr    = true
    egress_cidr_from_port = [0]
    egress_cidr_to_port   = [0]
    egress_cidr_protocol  = ["-1"]
    egress_cidr_block     = ["0.0.0.0/0"]
  }
}

