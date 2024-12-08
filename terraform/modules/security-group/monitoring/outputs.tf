output "monitoring_security_group_ids" {
  description = "ID of the Monitoring security group."
  value       = aws_security_group.monitoring_sg.*.id
}
