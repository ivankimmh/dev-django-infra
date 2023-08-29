variable "region" {
  type = string
}

variable "access_key" {
  type = string
  sensitive = true
}

variable "secret_key" {
  type = string
  sensitive = true
}

# instance setup
variable "username" {
  type = string
}
variable "password" {
  type = string
}

# DB setup
variable "db" {
    type = string
    sensitive = true
}
variable "db_user" {
  type = string
  sensitive = true
}
variable "db_password" {
  type = string
  sensitive = true
}
variable "db_port" {
  type = string
  sensitive = true
}