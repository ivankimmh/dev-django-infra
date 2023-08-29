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

//////////////////////////////////////////////////

## VPC setup start 
// cidr_block
resource "ncloud_vpc" "main" {
    name = "lion-${var.env}-tf"
    ipv4_cidr_block = "10.10.0.0/16"
}

resource "ncloud_network_acl" "nacl" {
    vpc_no = ncloud_vpc.main.id
}
## VPC setup end

//////////////////////////////////////////////////

## Subnet setup start 
resource "ncloud_subnet" "be-server" {
    vpc_no         = ncloud_vpc.main.vpc_no
    subnet         = cidrsubnet(ncloud_vpc.main.ipv4_cidr_block, 8, 3)
    zone           = "KR-2"
    network_acl_no = ncloud_vpc.main.default_network_acl_no
    subnet_type    = "PUBLIC"
    name           = "be-server-${var.env}"
    usage_type     = "GEN"
}

# load blanacer
resource "ncloud_subnet" "be-loadbalancer" {
    vpc_no         = ncloud_vpc.main.id
    subnet         = cidrsubnet(ncloud_vpc.main.ipv4_cidr_block, 8, 4)
    zone           = "KR-2"
    network_acl_no = ncloud_vpc.main.default_network_acl_no
    subnet_type    = "PRIVATE" // PUBLIC(Public) | PRIVATE(Private)
    // below fields is optional
    name           = "be-loadbalancer-${var.env}"
    usage_type     = "LOADB"    // GEN(General) | LOADB(For load balancer)
}
## Subnet setup end

//////////////////////////////////////////////////