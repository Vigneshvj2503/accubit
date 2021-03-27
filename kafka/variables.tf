###############################################################################
#  Terraform Variables file for  Kafka
#
#  Version	:	2.0		
#  Date		  : 05/20/2020		
#  Prepared by	:	Devops Team
#  Company	:	New York Life Insurance	
# 
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
  default = "443"
}

# Application Name
variable "application" {
  type    = string
  default = "hdf-kafka"
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

variable "patch_group4" {
  type        = string
  default     = "nyldefault"
  description = "Used for patching"
}

variable "patch_group5" {
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
  default = "hdf-kafka"
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
variable "private_ip2" {
  type = string
}

variable "private_ip3" {
  type = string
}

variable "private_ip4" {
  type = string
}

variable "private_ip5" {
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
variable "instance_id2" {
  description = "The numeric id of the instance"
  type        = string
}
variable "instance_id3" {
  description = "The numeric id of the instance"
  type        = string
}

variable "instance_id4" {
  description = "The numeric id of the instance"
  type        = string
}

variable "instance_id5" {
  description = "The numeric id of the instance"
  type        = string
}

variable "gig-backup" {
  type        = string
  default     = "7d-0w-0m"
  description = "Used by CloudAware to backup resources."
}

