variable "cloud_provider" {
  type        = string
  description = "The name of the cloud provider"
  default     = "aws"
}

variable "region" {
  type        = string
  description = "The region to deploy in (should be us-east)"
  default     = "us-east-1"
}

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to deploy to"
}

variable "instance_id" {
  type        = string
  description = "The ID (count) of the instance"
  default     = "0"
}

variable "instance_role" {
  type        = string
  description = "The role of the instance"
  default     = "instance"
}

variable "key_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.medium"
}

variable "instance_port" {
  type    = string
  default = "8080"
}

variable "private_ip" {
  type    = string
  default = ""
}

variable "default_instance_profile" {
  type = string
}

variable "ami_id" {
  type = string
}

variable "security_group_ids" {
  type = list
}

variable "root_volume_size" {
  type    = string
  default = "8"
}

variable "root_volume_type" {
  type    = string
  default = "standard"
}

variable "ebs_volume_size" {
  type    = string
  default = "20"
}

variable "ebs_volume_type" {
  type    = string
  default = "gp2"
}

variable "ebs_device_name" {
  type    = string
  default = "/dev/sdf"
}

variable "user_data" {
  description = "The user data to provide when launching the instance"
  type        = string
}
