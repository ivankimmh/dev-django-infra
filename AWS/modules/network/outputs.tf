output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_main_id" {
  value = aws_subnet.main.id
}