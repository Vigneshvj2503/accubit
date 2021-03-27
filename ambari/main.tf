################################################################################
#   Terraform Development main file for HDF Ambari Instance
#
#  Version	:	2.0
#  Date		  :	05/20/2020
#  Prepared by	:	Devops Team
#  Company	:	New York Life Insurance
#
#  This is terraform module to create 1 EC2 instance with 1 ALB
#  Comments are enclosed in a hash (#).Everything outside is a valid variable.
#
################################################################################

provider "aws" {
  region = var.region
  version = "~> 2.64.0"

  assume_role {
    role_arn    = var.assume_role_arn
    external_id = var.external_id
  }
}

data "aws_ami" "ami" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["${var.lob}-${var.app_env}-amzlinux2"]
  }
}


data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["nyl-${var.lob}-${var.app_env}-vpc"]
  }
}

data "aws_subnet_ids" "compute" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    tier = "compute"
  }
}

data "aws_subnet_ids" "inbound" {
  vpc_id = data.aws_vpc.default.id

  tags = {
    tier = "inbound"
  }
}


resource "random_shuffle" "subnet" {
  input        = data.aws_subnet_ids.compute.ids
  result_count = 1
}

data "aws_subnet" "selected" {
  id = random_shuffle.subnet.result[0]
}

data "aws_security_group" "custom_vpc_access" {
  name = "nyl-${var.lob}-${var.app_env}-custom-vpc-access-sg"
}

data "aws_security_group" "default_remote_access" {
  name = "nyl-${var.lob}-${var.app_env}-remote-access-sg"
}

data "aws_security_group" "microservices_zookeeperhdf_sg" {
  name = "nyl-${var.lob}-${var.app_env}-microservices-zookeeperhdf-sg"
}

data "aws_security_group" "microservices_kdchdf_sg" {
  name = "nyl-${var.lob}-${var.app_env}-microservices-kdchdf-sg"
}

data "aws_security_group" "microservices_kafkahdf_sg" {
  name = "nyl-${var.lob}-${var.app_env}-microservices-kafkahdf-sg"
}

module "microservice_instance1" {
  source                   = "git::https://git.nylcloud.com/EIS/terraform-aws-nyl-microservice-instance/?ref=v2.0.14"
  instance_id              = var.instance_id1
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  lob                      = var.lob
  platform                 = var.platform
  project                  = var.project
  patch_group              = var.patch_group1
  subnet_id                = data.aws_subnet.selected.id
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id, data.aws_security_group.microservices_kafkahdf_sg.id, data.aws_security_group.microservices_kdchdf_sg.id, data.aws_security_group.microservices_zookeeperhdf_sg.id]
  instance_role            = "ambari"
  default_instance_profile = "${var.lob}-${var.app_env}-instance-profile"
  instance_type            = var.instance_type
  private_ip               = var.private_ip1
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data1.rendered
}

data "template_file" "user_data1" {
  template = file("user-data.sh")
}
  
 #Create ALB 
data "aws_acm_certificate" "certificate" {
  count       = var.create_alb == "true" ? 1 : 0
  domain      = var.domain_name
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

locals {
  namespace = "${var.lob}-${var.env}-${var.application}"
}


resource "aws_lb_listener" "lb_listener" {
  count = var.create_alb == "true" ? 1 : 0
  load_balancer_arn = aws_lb.lb[count.index].arn
  port              = var.lb_port
  protocol          = var.lb_protocol
  certificate_arn   = data.aws_acm_certificate.certificate[count.index].arn

  default_action {
    target_group_arn = aws_lb_target_group.target_group[count.index].arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "http_redirect" {
  count = var.create_alb == "true" ? 1 : 0
  load_balancer_arn = aws_lb.lb[count.index].arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "target_group" {
  count = var.create_alb == "true" ? 1 : 0
  name                  = "nyl-${var.application}-${var.env}-tg"
  port                  = var.instance_port
  protocol              = var.instance_protocol
  vpc_id                = data.aws_vpc.default.id
  deregistration_delay  = var.deregistration_delay


  tags = {
    Name        = "nyl-${local.namespace}-tg"
    application = var.application
    app         = var.env
    lob         = var.lob
    project     = var.project
    appid       = var.appid
  }
}

resource "aws_lb_target_group_attachment" "agy_ec2_attach_1" {
  count = var.create_alb == "true" ? 1 : 0
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = module.microservice_instance1.id
  port             = var.instance_port
 
}
  
  
resource "aws_lb" "lb" {
  count = var.create_alb == "true" ? 1 : 0
  name               = "${var.application}-${var.env}-lb"
  load_balancer_type = "application"
  internal           = true
  security_groups    = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id]
  subnets            = data.aws_subnet_ids.inbound.ids
  idle_timeout       = var.lb_idle_timeout
  
  access_logs {
    bucket  = "nyl-${var.lob}-${var.env}-lb-access-log-bucket"
    prefix  = "${local.namespace}-private-alb"
    enabled = true
  }

  tags = {
    Name        = "nyl-${local.namespace}-lb"
    application = var.application
    env         = var.env
    lob         = var.lob
    project     = var.project
    appid       = var.appid
 
  }
}
