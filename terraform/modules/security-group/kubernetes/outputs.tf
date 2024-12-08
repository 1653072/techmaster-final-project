output "kubernetes_security_group_ids" {
  description = "ID of the Kubernetes security group."
  value       = aws_security_group.kubernetes_sg.*.id
}
