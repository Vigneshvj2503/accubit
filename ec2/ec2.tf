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
    values = ["${var.env}-amzlinux1"]
  }
}

data "aws_vpc" "default" {
  filter {
    name   = "tag:Name"
    values = ["${var.env}-vpc"]
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
  name = "${var.env}-custom-vpc-access-sg"
}

data "aws_security_group" "default_remote_access" {
  name = "${var.env}-remote-access-sg"
}

module "microservice_instance1" {
  source                   = "https://github.com/Vigneshvj2503/accubit.git"
  instance_id              = var.instance_id1
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  subnet_id                = "subnet-0ed5b1a03cc4379e5"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id]
  instance_role            = "client"
  default_instance_profile = "${var.env}-instance-profile"
  instance_type            = var.instance_type1
  private_ip               = var.private_ip1
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  appname                  = var.appname
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data1.rendered
}

data "template_file" "user_data1" {
  template = file("user-data.sh")
}

module "microservice_instance2" {
  source                   = "https://github.com/Vigneshvj2503/accubit.git"
  instance_id              = var.instance_id2
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  subnet_id                = "subnet-09e15df5f5b280dd7"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id]
  instance_role            = "client"
  default_instance_profile = "${var.env}-instance-profile"
  instance_type            = var.instance_type2
  private_ip               = var.private_ip2
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  appname                  = var.appname
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data2.rendered
}

data "template_file" "user_data2" {
  template = file("user-data.sh")
}

module "microservice_instance3" {
  source                   = "https://github.com/Vigneshvj2503/accubit.git"
  instance_id              = var.instance_id3
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  subnet_id                = "subnet-0fd425ca10c009509"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id]
  instance_role            = "client"
  default_instance_profile = "${var.lob}-${var.app_env}-instance-profile"
  instance_type            = var.instance_type3
  private_ip               = var.private_ip3
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  appname                  = var.appname
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data3.rendered
}

data "template_file" "user_data3" {
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
  namespace = "${var.env}-${var.application}"
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
  name                  = "${var.application}-${var.env}-tg"
  port                  = var.instance_port
  protocol              = var.instance_protocol
  vpc_id                = data.aws_vpc.default.id
  deregistration_delay  = var.deregistration_delay

  health_check {

   interval            = var.health_check_interval
   path                = var.health_check_path
   protocol            = var.lb_protocol
   timeout             = var.health_check_timeout
   healthy_threshold   = var.health_check_healthy_threshold
   unhealthy_threshold = var.health_check_unhealthy_threshold
   matcher             = var.asg_health_check_matcher

 }

  tags = {
    Name        = "${local.namespace}-tg"
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

resource "aws_lb_target_group_attachment" "agy_ec2_attach_2" {
  count = var.create_alb == "true" ? 1 : 0
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = module.microservice_instance2.id
  port             = var.instance_port
 
}

resource "aws_lb_target_group_attachment" "agy_ec2_attach_3" {
  count = var.create_alb == "true" ? 1 : 0
  target_group_arn = aws_lb_target_group.target_group[count.index].arn
  target_id        = module.microservice_instance3.id
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
    bucket  = "${var.lob}-${var.env}-lb-access-log-bucket"
    prefix  = "${local.namespace}-private-alb"
    enabled = true
  }

  tags = {
    Name        = "${local.namespace}-lb"
    application = var.application
    env         = var.env
    lob         = var.lob
    project     = var.project
    appid       = var.appid
 
  }
}
