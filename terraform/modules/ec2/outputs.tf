// AWS EC2 output for CICD services
output "cicd_instance_states" {
  description = "The state of the CICD EC2 instances"
  value       = aws_instance.ec2_instance_cicd.*.instance_state
}

output "cicd_instance_public_dns" {
  description = "The Public DNS addresses of the CICD EC2 instances"
  value       = aws_instance.ec2_instance_cicd.*.public_dns
}

output "cicd_instance_public_ips" {
  description = "The Public IP addresses of the CICD EC2 instances"
  value       = aws_instance.ec2_instance_cicd.*.public_ip
}

// AWS EC2 output for monitoring services
output "monitoring_instance_states" {
  description = "The state of the Monitoring EC2 instances"
  value       = aws_instance.ec2_instance_monitoring.*.instance_state
}

output "monitoring_instance_public_dns" {
  description = "The Public DNS addresses of the Monitoring EC2 instances"
  value       = aws_instance.ec2_instance_monitoring.*.public_dns
}

output "monitoring_instance_public_ips" {
  description = "The Public IP addresses of the Monitoring EC2 instances"
  value       = aws_instance.ec2_instance_monitoring.*.public_ip
}

// AWS EC2 output for Kubernetes services
output "kubernetes_instance_states" {
  description = "The state of the Kubernetes EC2 instances"
  value       = aws_instance.ec2_instance_kubernetes.*.instance_state
}

output "kubernetes_instance_public_dns" {
  description = "The Public DNS addresses of the Kubernetes EC2 instances"
  value       = aws_instance.ec2_instance_kubernetes.*.public_dns
}

output "kubernetes_instance_public_ips" {
  description = "The Public IP addresses of the Kubernetes EC2 instances"
  value       = aws_instance.ec2_instance_kubernetes.*.public_ip
}