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

resource "aws_lb" "be" {
  name               = "${var.name}-lb-${var.env}"
  internal           = false
  load_balancer_type = "network"
  subnets            = [ var.subnet_main_id ]
  enable_deletion_protection = false

  tags = {
    Environment = var.env
  }
}

resource "aws_lb_target_group" "be" {
  name     = "${var.name}-lb-tg-${var.env}"
  port     = 8000
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    protocol = "TCP"
    port = 8000
    interval = 30
    healthy_threshold = 2
    unhealthy_threshold = 2
  }
}

resource "aws_lb_listener" "be" {
  load_balancer_arn = aws_lb.be.arn
  port              = "80"
  protocol          = "TCP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.be.arn
  }
}

resource "aws_lb_target_group_attachment" "be" {
  target_group_arn = aws_lb_target_group.be.arn
  target_id        = var.instance_id
  port = 8000
}