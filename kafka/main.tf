###############################################################################
#  Terraform Variables file for HDF Kafka
#
#  Version	:	2.0		
#  Date		  : 05/20/2020		
#  Prepared by	:	Devops Team
#  Company	:	New York Life Insurance	
# 
#  This file declares variables used in variables.tf file 
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

resource "random_shuffle" "subnet" {
  input        = data.aws_subnet_ids.compute.ids
  result_count = 2
}

resource "random_shuffle" "subnet2" {
  input        = data.aws_subnet_ids.compute.ids
  result_count = 2
}


data "aws_subnet" "selected" {
  id = random_shuffle.subnet.result[0]
}

data "aws_subnet" "selected2" {
  id = random_shuffle.subnet2.result[0]
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
  source                   = "git::https://git.nylcloud.com/EIS/terraform-aws-nyl-microservice-instance/?ref=v2.0.6"
     
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
  subnet_id                = "subnet-0ed5b1a03cc4379e5"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id, data.aws_security_group.microservices_kafkahdf_sg.id, data.aws_security_group.microservices_kdchdf_sg.id, data.aws_security_group.microservices_zookeeperhdf_sg.id]
  instance_role            = "kafka"
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
  template = file("user-data1.sh")
}

module "microservice_instance2" {
  source                   = "git::https://git.nylcloud.com/EIS/terraform-aws-nyl-microservice-instance/?ref=v2.0.6"

  instance_id              = var.instance_id2
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  lob                      = var.lob
  platform                 = var.platform
  project                  = var.project
  patch_group              = var.patch_group2
  subnet_id                = "subnet-09e15df5f5b280dd7"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id, data.aws_security_group.microservices_kafkahdf_sg.id, data.aws_security_group.microservices_kdchdf_sg.id, data.aws_security_group.microservices_zookeeperhdf_sg.id]
  instance_role            = "kafka"
  default_instance_profile = "${var.lob}-${var.app_env}-instance-profile"
  instance_type            = var.instance_type
  private_ip               = var.private_ip2
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data2.rendered
}

data "template_file" "user_data2" {
  template = file("user-data2.sh")
}

module "microservice_instance3" {
  source                   = "git::https://git.nylcloud.com/EIS/terraform-aws-nyl-microservice-instance/?ref=v2.0.6"

  instance_id              = var.instance_id3
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  lob                      = var.lob
  platform                 = var.platform
  project                  = var.project
  patch_group              = var.patch_group3
  subnet_id                = "subnet-0fd425ca10c009509"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id, data.aws_security_group.microservices_kafkahdf_sg.id, data.aws_security_group.microservices_kdchdf_sg.id, data.aws_security_group.microservices_zookeeperhdf_sg.id]
  instance_role            = "kafka"
  default_instance_profile = "${var.lob}-${var.app_env}-instance-profile"
  instance_type            = var.instance_type
  private_ip               = var.private_ip3
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data3.rendered
}

data "template_file" "user_data3" {
  template = file("user-data3.sh")
}
  
  
module "microservice_instance4" {
  source                   = "git::https://git.nylcloud.com/EIS/terraform-aws-nyl-microservice-instance/?ref=v2.0.6"

  instance_id              = var.instance_id4
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  lob                      = var.lob
  platform                 = var.platform
  project                  = var.project
  patch_group              = var.patch_group4
  subnet_id                = "subnet-0ed5b1a03cc4379e5"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id, data.aws_security_group.microservices_kafkahdf_sg.id, data.aws_security_group.microservices_kdchdf_sg.id, data.aws_security_group.microservices_zookeeperhdf_sg.id]
  instance_role            = "kafka"
  default_instance_profile = "${var.lob}-${var.app_env}-instance-profile"
  instance_type            = var.instance_type
  private_ip               = var.private_ip4
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data4.rendered
}

data "template_file" "user_data4" {
  template = file("user-data4.sh")
}
  
module "microservice_instance5" {
  source                   = "git::https://git.nylcloud.com/EIS/terraform-aws-nyl-microservice-instance/?ref=v2.0.6"

  instance_id              = var.instance_id5
  env                      = var.env
  appid                    = var.appid
  ami_id                   = data.aws_ami.ami.id
  application              = var.application
  component                = var.component
  key_name                 = var.key_name
  lob                      = var.lob
  platform                 = var.platform
  project                  = var.project
  patch_group              = var.patch_group5
  subnet_id                = "subnet-09e15df5f5b280dd7"
  security_group_ids       = [data.aws_security_group.default_remote_access.id, data.aws_security_group.custom_vpc_access.id, data.aws_security_group.microservices_kafkahdf_sg.id, data.aws_security_group.microservices_kdchdf_sg.id, data.aws_security_group.microservices_zookeeperhdf_sg.id]
  instance_role            = "kafka"
  default_instance_profile = "${var.lob}-${var.app_env}-instance-profile"
  instance_type            = var.instance_type
  private_ip               = var.private_ip5
  root_volume_size         = var.root_volume_size
  root_volume_type         = var.root_volume_type
  ebs_volume_size          = var.ebs_volume_size
  ebs_volume_type          = var.ebs_volume_type
  ebs_device_name          = var.ebs_device_name
  gig-backup               = var.gig-backup
  user_data                = data.template_file.user_data5.rendered
}

data "template_file" "user_data5" {
  template = file("user-data5.sh")
}

