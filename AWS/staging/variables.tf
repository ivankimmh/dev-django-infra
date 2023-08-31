variable "region" {
  type = string
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

# NCP
variable "NCP_ACCESS_KEY" {
  type = string
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

# Django
variable "DJANGO_SETTINGS_MODULE" {
  type = string
}

variable "DJANGO_SECRET_KEY" {
  type = string
  sensitive = true
}