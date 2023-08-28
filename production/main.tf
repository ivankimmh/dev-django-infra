terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

// Configure the ncloud provider
provider "ncloud" {
  access_key  = var.NCP_ACCESS_KEY
  secret_key  = var.NCP_SECRET_KEY
  region      = var.region
  site        = var.site
  support_vpc = var.support_vpc
}

locals {
  env = "prod"
  db = "lionforum"
  db_port = "5432"
}

module "network" {
  source = "../modules/network"

  env = local.env
  region = var.region
  site = var.site
  support_vpc = var.support_vpc
  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
}

module "be" {
  source = "../modules/server"

  env = local.env
  name = "be"
  
  region = var.region
  site = var.site
  support_vpc = var.support_vpc

  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY

  vpc_id = module.network.vpc_id
  subnet_be_server = module.network.subnet_be_server
  acg_port_range = "8000"
  server_product_code = data.ncloud_server_products.sm.server_products[0].product_code

  init_script_envs = {
  username = var.username
  password = var.password
  db = local.db
  db_port = local.db_port
  db_host = ncloud_public_ip.db.public_ip
  db_user = var.db_user
  db_password = var.db_password

  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY
  NCP_CONTAINER_REGISTRY = var.NCP_CONTAINER_REGISTRY
  IMAGE_TAG = var.IMAGE_TAG

  DJANGO_SETTINGS_MODULE = "lion_app.settings.prod"
  DJANGO_SECRET_KEY = var.DJANGO_SECRET_KEY
  }
  init_script_path = "be_init_script.tftpl"

}

module "db" {
  source = "../modules/server"

  env = local.env
  name = "db"
  
  region = var.region
  site = var.site
  support_vpc = var.support_vpc

  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY

  vpc_id = module.network.vpc_id
  subnet_be_server = module.network.subnet_be_server
  acg_port_range = "5432"
  server_product_code = data.ncloud_server_products.sm.server_products[0].product_code

  init_script_envs = {
  username = var.username
  password = var.password
  db = local.db
  db_port = local.db_port
  db_user = var.db_user
  db_password = var.db_password
  }

  init_script_path = "db_init_script.tftpl"

}

module "loadbalancer" {
  source = "../modules/loadbalancer"

  env = local.env

  region = var.region
  site = var.site
  support_vpc = var.support_vpc

  NCP_ACCESS_KEY = var.NCP_ACCESS_KEY
  NCP_SECRET_KEY = var.NCP_SECRET_KEY

  vpc_id = module.network.vpc_id
  be_server = module.be.instance_no
  subnet_be_loadbalancer = module.network.subnet_be_loadbalancer
}

data "ncloud_server_products" "sm" {
  server_image_product_code = "SW.VSVR.OS.LNX64.UBNTU.SVR2004.B050"

  filter {
    name   = "product_code"
    values = ["SSD"]
    regex  = true
  }

  filter {
    name   = "cpu_count"
    values = ["2"]
  }

  filter {
    name   = "memory_size"
    values = ["4GB"]
  }

  filter {
    name   = "base_block_storage_size"
    values = ["50GB"]
  }

  filter {
    name   = "product_type"
    values = ["HICPU"]
  }

  output_file = "product.json"
}

resource "ncloud_public_ip" "be" {
  server_instance_no = module.be.instance_no
}

resource "ncloud_public_ip" "db" {
  server_instance_no = module.db.instance_no
}