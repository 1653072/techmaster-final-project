output "cicd_security_group_ids" {
  description = "ID of the CICD security group."
  value       = aws_security_group.cicd_sg.*.id
}

output "monitoring_security_group_ids" {
  description = "ID of the Monitoring security group."
  value       = aws_security_group.monitoring_sg.*.id
}

output "kubernetes_security_group_ids" {
  description = "ID of the Kubernetes security group."
  value       = aws_security_group.kubernetes_sg.*.id
}

