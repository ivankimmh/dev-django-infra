output "public_ip" {
  value = aws_instance.main.public_ip
}

output "instance_id" {
  value = aws_instance.main.id
}

output "security_group_id" {
  value = aws_security_group.main.id
}