output "public_ip" {
  value = aws_instance.app_server.public_ip
}

output "instance_id" {
  value = aws_instance.app_server.id
}

output "ssh_command" {
  value = "ssh -i ${var.project_name}-key.pem ec2-user@${aws_instance.app_server.public_ip}"
}
output "security_group_id" {
  value = aws_security_group.backend_sg.id
}