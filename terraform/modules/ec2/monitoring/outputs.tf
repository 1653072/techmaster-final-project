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