output "db_public_ip" {
  value = module.db.public_ip
}

output "be_public_ip" {
  value = module.be.public_ip
}

output "db_instance_id" {
  value = module.db.instance_id
}

output "lb_dns" {
  value = module.be_lb.lb_dns
}