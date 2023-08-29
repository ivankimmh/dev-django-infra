variable "region" {
  type = string
}

variable "env" {
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