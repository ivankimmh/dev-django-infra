# Cloud setup
variable "region" {
  type = string
}
variable "site" {
  type = string
}
variable "support_vpc" {
  type = bool
}


# NCP setup
variable "NCP_ACCESS_KEY" {
  type = string
  sensitive = true
}
variable "NCP_SECRET_KEY" {
  type = string
  sensitive = true
}

# env
variable "env" {
  type = string  
}

# vpc
variable "vpc_id" {
  type = string
}

# be_server
variable "be_server" {
  type = string
}

# subnet
variable "subnet_be_loadbalancer" {
  type = string
}