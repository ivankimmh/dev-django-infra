terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.6.0"
    }
  }
  required_version = ">= 0.13"
}

provider "ncloud" {
  access_key  = var.NCP_ACCESS_KEY
  secret_key  = var.NCP_SECRET_KEY
  region      = var.region
  site        = var.site
  support_vpc = var.support_vpc
}

provider "ssh" {}

locals {
  env = "k8s"
}

resource "ncloud_vpc" "vpc" {
  name            = "vpc"
  ipv4_cidr_block = "10.10.0.0/16" # staging & production 과 겹치지 않게
}

resource "ncloud_subnet" "subnet" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 5)
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PUBLIC"
  name           = "k8s-subnet-01"
  usage_type     = "GEN"
}

resource "ncloud_subnet" "subnet_lb" {
  vpc_no         = ncloud_vpc.vpc.id
  subnet         = cidrsubnet(ncloud_vpc.vpc.ipv4_cidr_block, 8, 6)
  zone           = "KR-1"
  network_acl_no = ncloud_vpc.vpc.default_network_acl_no
  subnet_type    = "PRIVATE"
  name           = "k8s-subnet-lb"
  usage_type     = "LOADB"
}

# k8s 는 업데이트가 잦고 이전 버전은 지원하지 않기 때문에 최신버전을 사용하는게 좋다.
data "ncloud_nks_versions" "version" { 
  filter {
    name = "value"
    values = ["1.25.8"]
    regex = true
  }
}

resource "ncloud_login_key" "loginkey" {
  key_name = "k8s-login-key"
}


resource "ncloud_nks_cluster" "cluster" { # minikube 로 했었던 클러스터
  cluster_type                = "SVR.VNKS.STAND.C002.M008.NET.SSD.B050.G002"
  k8s_version                 = data.ncloud_nks_versions.version.versions.0.value
  login_key_name              = ncloud_login_key.loginkey.key_name
  name                        = "ncp-k8s-cluster"
  lb_private_subnet_no        = ncloud_subnet.subnet_lb.id
  kube_network_plugin         = "cilium"
  subnet_no_list              = [ ncloud_subnet.subnet.id ]
  public_network              = true
  vpc_no                      = ncloud_vpc.vpc.id
  zone                        = "KR-1"
  log {
    audit = true
  }
}

###################################################################################################
# node_pool
data "ncloud_server_image" "image" {
  filter {
    name = "product_name"
    values = ["ubuntu-20.04"]
  }
}

data "ncloud_server_product" "product" {
  server_image_product_code = data.ncloud_server_image.image.product_code

  filter {
    name = "product_type"
    values = [ "STAND" ]
  }

  filter {
    name = "cpu_count"
    values = [ 2 ]
  }

  filter {
    name = "memory_size"
    values = [ "8GB" ]
  }

  filter {
    name = "product_code"
    values = [ "SSD" ]
    regex = true
  }
}

resource "ncloud_nks_node_pool" "node_pool" {
  cluster_uuid   = ncloud_nks_cluster.cluster.uuid
  node_pool_name = "k8s-node-pool"
  node_count     = 1
  product_code   = data.ncloud_server_product.product.product_code
#   subnet_no      = [ ncloud_subnet.subnet.id ]

  autoscale {
    enabled = true
    min = 1
    max = 2
  }
  lifecycle {
    ignore_changes = [ node_count, subnet_no_list ]
  }
}

###################################################################################################
