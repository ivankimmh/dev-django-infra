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
variable "NCP_CONTAINER_REGISTRY" {
  type = string
}
variable "IMAGE_TAG" {
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

# Django setup
variable "DJANGO_SETTINGS_MODULE" {
  type = string
  sensitive = true
}
variable "DJANGO_SECRET_KEY" {
  type = string
  sensitive = true
}