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
    default_tags {
      tags = {
        Env = var.env
      }
    }
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

data "vpc_id" "main" {
  id = var.vpc_id
}

data "subnet_main" "main" {
  id = var.subnet_main
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  subnet_id = var.subnet_main
  vpc_security_group_ids = [
    aws_security_group.main.id
  ]
  
  user_data = templatefile("${path.module}/${var.init_script_path}", var.init_script_envs)
  associate_public_ip_address = true
  
  tags = {
    Name = "${var.name}-server-${var.env}"
  }
}

resource "aws_security_group" "main" {
  name        = "lion-${var.name}-${var.env}"
  description = "Allow SSH, ${var.port_range} inbound traffic"
  vpc_id      = data.vpc_id.main.id

  ingress {
    description      = "${var.port_range} from VPC"
    from_port        = var.port_range
    to_port          = var.port_range
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  ingress {
    description      = "SSH"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_ssh_${var.name}_${var.env}"
  }
}
