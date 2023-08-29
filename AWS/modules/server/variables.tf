variable "region" {
  type = string
}

variable "env" {
  type = string
}

variable "name" {
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


variable "vpc_id" {
  type = string
}

variable "subnet_main" {
  type = string
}

variable "port_range" {
  type = string
}

# init_script
variable "init_script_path" {
  type = string
}

variable "init_script_envs" {
  type = map(any)
}