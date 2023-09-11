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

# instance setup
variable "username" {
  type = string
}
variable "password" {
  type = string
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
