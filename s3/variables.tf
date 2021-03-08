# AWS region
variable "region" {
  type    = "string"
  default = "us-east-1"
}

variable "assume_role_arn" {
  type        = "string"
  description = "The role to assume to authenticate Terraform runs"
}

variable "external_id" {
  type        = string
  description = "The external ID for the role to assume to authenticate Terraform runs"
}



# Bucket Names
variable "bucketname" {
  type    = "string"
}

# Application Environment
variable "app_env" {
  type    = "string"
}

# Application ID
variable "app_id" {
  type    = "string"
  default = ""
}
