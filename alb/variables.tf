# =============== Global variables ===============

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "assume_role_arn" {
  type = string
}

variable "external_id" {
  type = string
}


variable "application" {
  type = string
}

#variable "platform" {
# type = string
#}

variable "project" {
  type = string
}

variable "appid" {
  type    = string
  default = "APP-2360"
}

variable "lob" {
  type = string
}

variable "env" {
  type = string
}

variable "cloud_provider" {
  type    = string
  default = "aws"
}

variable "domain_name" {
  type = string
}

variable "lb_idle_timeout" {
  type = string
  default = "60"
}

variable "lb_security_group_ids" {
  type = list(string)
}

variable "certificate_arn" {
  type = string 
}
