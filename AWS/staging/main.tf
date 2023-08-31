terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.region
}

locals {
  env = "staging"
  db_port = "5432"
  be_port = "8000"
}

module "network" {
  source = "../modules/network"

  env = local.env
  region = var.region
}

module "db" {
  source = "../modules/server"

  env  = local.env
  name = "db"
  region = var.region

  vpc_id = module.network.vpc_id
  subnet_main_id = module.network.subnet_main_id
  port_range = local.db_port

  init_script_path = "db_init_script.tftpl"
  init_script_vars = {
    username = var.username
    password = var.password
    db = "lionforum"
    db_port = local.db_port
    db_user = var.db_user
    db_password = var.db_password
  }
}

module "be" {
  source = "../modules/server"

  env = local.env
  name = "be"
  region = var.region

  vpc_id = module.network.vpc_id
  subnet_main_id = module.network.subnet_main_id
  port_range = local.be_port
  
  init_script_path = "be_init_script.tftpl"
  init_script_vars = {
    username = var.username
    password = var.password
    db = "lionforum"
    db_port = local.db_port
    db_user = var.db_user
    db_password = var.db_password
    db_host = module.db.public_ip

    NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
    NCP_SECRET_KEY = var.NCP_SECRET_KEY
    NCP_CONTAINER_REGISTRY = var.NCP_CONTAINER_REGISTRY
    IMAGE_TAG = var.IMAGE_TAG
    DJANGO_SETTINGS_MODULE = var.DJANGO_SETTINGS_MODULE
    DJANGO_SECRET_KEY = var.DJANGO_SECRET_KEY
  }
}

module "be_lb" {
  source = "../modules/loadbalancer"

  name = "be"
  env = local.env
  region = var.region

  vpc_id = module.network.vpc_id
  subnet_main_id = module.network.subnet_main_id
  instance_id = module.be.instance_id
}