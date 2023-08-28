output "vpc_id" {
  value = ncloud_vpc.main.id
}

output "subnet_be_server" {
  value = ncloud_subnet.be-server.id
}

output "subnet_be_loadbalancer" {
  value = ncloud_subnet.be-loadbalancer.id
}