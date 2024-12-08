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