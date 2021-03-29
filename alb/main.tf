########Terraform script
#
#  Version	:	2.0
#  Date		:	03/011/2020
#  Prepared by	: Devops Team
#  Company	:	New York Life Insurance
#
#  This terraform script creates ALB for lisa to enable access V-service from mule,DP and browser.
#  #  Comments are enclosed in a hash (#).Everything outside is a valid variable.
#
#  Usage-Always use terraform plan. See Readme file for detailed instructions
#  updated the variables in TFE variable section
################################################################################
provider "aws" {
  region = var.region

  assume_role {
    role_arn    = var.assume_role_arn
    external_id = var.external_id
  }
}


locals {
  namespace = "${var.lob}-${var.env}-${var.application}"
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["nyl-${var.lob}-${var.env}-vpc"]
  }
}

data "aws_subnet_ids" "inbound" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    tier = "inbound"
  }
}

resource "aws_lb_target_group" "ip_target" {
  name        = "${var.env}-${var.application}-lb-tg"
  port        = 443
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = data.aws_vpc.default.id

}

resource "aws_lb_listener" "alb_forward_listener" {
  load_balancer_arn = aws_lb.alb_forward.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip_target.arn
  }
}

#resource "aws_lb_listener_rule" "static" {
#  listener_arn = aws_lb_listener.alb_forward_listener.arn
#  priority     = 100
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.ip_target.arn
#  }
#}


resource "aws_lb" "alb_forward" {
  name               = "${var.env}-${var.application}-lb"
  load_balancer_type = "application"
  internal           = true
  security_groups    = var.lb_security_group_ids
  subnets            = data.aws_subnet_ids.inbound.ids
  idle_timeout       = var.lb_idle_timeout

  tags = {
    Name        = "${local.namespace}-lb"
    provider    = var.cloud_provider
    application = var.application
    env         = var.env
    lob         = var.lob
    project     = var.project
    appid       = var.appid

  }
}
