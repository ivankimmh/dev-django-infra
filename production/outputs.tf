output "lb_dns" {
  value = module.loadbalancer.lb-dns
}

output "db_public_ip" {
  value = ncloud_public_ip.db.public_ip
}

output "be_public_ip" {
  value = ncloud_public_ip.be.public_ip
}