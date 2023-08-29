terraform {
  required_providers {
    ncloud = {
      source = "NaverCloudPlatform/ncloud"
    }
  }
  required_version = ">= 0.13"
}

# // Configure the ncloud provider
provider "ncloud" {
  access_key  = var.NCP_ACCESS_KEY
  secret_key  = var.NCP_SECRET_KEY
  region      = var.region
  site        = var.site
  support_vpc = var.support_vpc
}

## load balancer setup start
# load balancer
resource "ncloud_lb" "be" {
  name = "tf-lb-${var.env}"
  network_type = "PUBLIC"
  type = "NETWORK_PROXY"
  throughput_type = "SMALL"
  subnet_no_list = [ var.subnet_be_loadbalancer ]
}
# target group
resource "ncloud_lb_target_group" "be" {
    name = "be-tg-${var.env}"
    vpc_no   = var.vpc_id
    protocol = "PROXY_TCP"
    target_type = "VSVR"
    port        = 8000
    description = "for django prod backend"
    health_check {
        protocol = "TCP"
        http_method = "GET"
        port           = 8000
        url_path       = "/monitor/l7check"
        cycle          = 30
        up_threshold   = 2
        down_threshold = 2
    }
    algorithm_type = "RR"
}
# listening protocal
resource "ncloud_lb_listener" "be" {
    load_balancer_no = ncloud_lb.be.id
    protocol = "TCP"
    port = 80
    target_group_no = ncloud_lb_target_group.be.id
}

# select applying instance
resource "ncloud_lb_target_group_attachment" "be" {
  target_group_no = ncloud_lb_target_group.be.id
  target_no_list = [ var.be_server ]
}

## load balancer setup end