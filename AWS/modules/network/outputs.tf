output "vpc_id" {
  value = aws_vpc.main.id
}

output "subnet_main" {
  value = aws_subnet.main.id
}