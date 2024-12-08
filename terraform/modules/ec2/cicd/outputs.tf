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
