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
variable "instance_type1" {
  type    = string
  default = "t2.xlarge"
}
variable "instance_type2" {
  type    = string
  default = "t2.xlarge"
}
variable "instance_type3" {
  type    = string
  default = "t2.xlarge"
}

# EC2 instance port
variable "instance_port" {
  type    = string
  default = "8500"
}

# Application Name
variable "application" {
  type    = string
  default = ''
}

# Application ID
variable "appid" {
  type    = string
  default = "'
}

variable "patch_group1" {
  type        = string
  default     = "default"
  description = "Used for patching"
}

variable "patch_group2" {
  type        = string
  default     = "default"
  description = "Used for patching"
}

variable "patch_group3" {
  type        = string
  default     = "default"
  description = "Used for patching"
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

# Root Volume size
variable "root_volume_size" {
  type    = string
  default = "8"
}

# Root Volume type
variable "root_volume_type" {
  type    = string
  default = "standard"
}

# EBS Volume size
variable "ebs_volume_size" {
  type    = string
  default = "50"
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

variable "gig-backup" {
  type        = string
  default     = "7d-0w-0m"
  description = ""
}

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
  default = ""
}

variable "deregistration_delay" {
  type    = string
  default = "1200"
}

variable "health_check_healthy_threshold" {
  type    = string
  default = "2"
}

variable "health_check_unhealthy_threshold" {
  type    = string
  default = "2"
}

variable "health_check_path" {
  type    = string
  default = ""
}

variable "health_check_timeout" {
  type    = string
  default = "2"
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
