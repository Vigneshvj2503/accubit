###############################################################################
#  Terraform Variables file for HDF Ambari
#
#  Version	:	2.0		
#  Date		  : 05/20/2020		
#  Prepared by	:	Devops Team
#  Company	:	New York Life Insurance	
# 
#  This file declares variables used in main.tf file 
#  Comments are enclosed in a hash (#).Everything outside is a valid variable.
#  
################################################################################

# AWS region
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "assume_role_arn" {
  type        = string
  description = "The role to assume to authenticate Terraform runs"
}

variable "external_id" {
  type        = string
  description = "The external ID for the role to assume to authenticate Terraform runs"
}

# Key file
variable "key_name" {
  type = string
}

# AWS EC2 instance type
variable "instance_type" {
  type    = string
  default = "m4.4xlarge"
}

# EC2 instance port
variable "instance_port" {
  type    = string
  default = "8443"
}

# Application Name
variable "application" {
  type    = string
  default = "hdf-ambari"
}

# Application ID
variable "appid" {
  type    = string
  default = "APP-2360"
}

variable "patch_group1" {
  type        = string
  default     = "nyldefault"
  description = "Used for patching"
}

variable "patch_group2" {
  type        = string
  default     = "nyldefault"
  description = "Used for patching"
}

variable "patch_group3" {
  type        = string
  default     = "nyldefault"
  description = "Used for patching"
}

# Application Platform
variable "platform" {
  type    = string
  default = "foundation"
}

# Application Project Name
variable "project" {
  type    = string
  default = "MSPAS"
}

# Compnent Name for Billing
variable "component" {
  type    = string
  default = "hdf-ambari"
}

# Application Backup Schedule
variable "backup_schedule" {
  type    = string
  default = "7d-4w-0m"
}

# Application Line of Business
variable "lob" {
  type    = string
  default = "eisfoundationservices"
}

# Application Environment
variable "app_env" {
  type = string
}

# Application Environment
variable "env" {
  type = string
}

# Application Environment
variable "csg_env" {
 type = string
}


# Application Environment
variable "private_ip1" {
  type = string
}


# Root Volume size
variable "root_volume_size" {
  type    = string
  default = "30"
}

# Root Volume type
variable "root_volume_type" {
  type    = string
  default = "standard"
}

# EBS Volume size
variable "ebs_volume_size" {
  type    = string
  default = "500"
}

# EBS Volume type
variable "ebs_volume_type" {
  type    = string
  default = "gp2"
}

# EBS device name
variable "ebs_device_name" {
  type    = string
  default = "/dev/sdf"
}
variable "instance_id1" {
  description = "The numeric id of the instance"
  type        = string
  }

variable "gig-backup" {
  type        = string
  default     = "7d-0w-0m"
  description = "Used by CloudAware to backup resources."
}

/*
variable "certificate_id" {
  description = "ARN id for SSL certificate"
  type        = string
}

variable "certificate_id2" {
  description = "ARN id for SSL certificate"
  type        = string
}
*/

#Alb variable

variable "instance_protocol" {
  type    = string
  default = "HTTPS"
}

variable "domain_name" {
  type = string
  default = ""
}

variable "lb_port" {
  type    = string
  default = "443"
}

variable "lb_protocol" {
  type    = string
  default = "HTTPS"
}

variable "asg_max_size" {
  type    = string
  default = "2"
}

variable "asg_min_size" {
  type    = string
  default = "2"
}

variable "asg_desired_capacity" {
  type    = string
  default = "2"
}

variable "asg_health_check_type" {
  type    = string
  default = "EC2"
}

variable "asg_health_check_matcher" {
  type    = string
  default = "200"
}

variable "elb_health_check_protocol" {
  type    = string
  default = "TCP"
}

variable "elb_health_check_path" {
  type    = string
  default = "/ui/nyldc/services"
}

variable "deregistration_delay" {
  type    = string
  default = "1200"
}

variable "health_check_healthy_threshold" {
  type    = string
  default = "5"
}

variable "health_check_unhealthy_threshold" {
  type    = string
  default = "2"
}

variable "health_check_path" {
  type    = string
  default = "/"
}

variable "health_check_timeout" {
  type    = string
  default = "5"
}

variable "health_check_interval" {
  type    = string
  default = "30"
}

variable "lb_idle_timeout" {
  type    = string
  default = "180"
}

variable "create_alb" {
   type = string
}
