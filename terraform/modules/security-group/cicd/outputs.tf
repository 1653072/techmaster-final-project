output "cicd_security_group_ids" {
  description = "ID of the CICD security group."
  value       = aws_security_group.cicd_sg.*.id
}
