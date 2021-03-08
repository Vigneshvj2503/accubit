variable "name" {
  description = "The name of the database to create when the DB instance is created"
  type = "string"
}
# Application Environment
variable "app_env" {
  type    = "string"
}
/*
# AWS provider
variable "provider" {
  type    = "string"
  default = "aws"
}
*/

# Application Name
variable "application" {
  type    = "string"
  default = "RDS-Postgres"
}

# Application Id
variable "appid" {
  type    = "string"
  default = ""
}

# Data Type
variable "datatype" {
  type    = "string"
  default = "n/a"
}

# Application Division
variable "division" {
  type    = "string"
  default = "undefined"
}

# Function
variable "function" {
  type    = "string"
  default = "rds"
}

# Application Platform
variable "platform" {
  type    = "string"
  default = "ms"
}

variable "identifier" {
  description = "The name of the database to create when the DB instance is created"
  type = "string"
}

variable "username" {
    description = "Username for the master DB user"
    type = "string"
}

variable "password" {
description = "Password for the master DB user"
type = "string"
}

variable "port" {
description = "something"
type = "string"
  }

variable "multi_az" {
  description = "Set to true if multi AZ deployment must be supported"
  default     = "false"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD)."
  default     = "standard"
}

variable "storage_encrypted" {
  description = "(Optional) Specifies whether the DB instance is encrypted. The default is false if not specified."
  default     = "true"
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'. Default is 0 if rds storage type is not 'io1'"
  default     = "0"
}

variable "allocated_storage" {
  description = "The allocated storage in GBs"

  # Number, e.g. 10
}

variable "engine" {
  description = "Database engine type"
  type = "string"
  default = "postgres"
  }

variable "engine_version" {
  description = "Database engine version, depends on engine type"
  type = "string"
}

variable "instance_class" {
  description = "Class of RDS instance"
  type = "string"
}

# This is for custom parameters to be passed to the DB
# We're "cloning" default ones, but we need to specify which should be copied
variable "parameter_group_name" {
  description = "Parameter group, depends on DB engine used"

  # "mysql5.6"
  # "postgres9.5"
}

variable "publicly_accessible" {
  description = "Determines if database can be publicly available (NOT recommended)"
  default     = "false"
}

variable "db_subnet_group_name" {
  description = "List of subnets for the DB"
  type        = "string"
}

variable "auto_minor_version_upgrade" {
  description = "Allow automated minor version upgrade"
  default     = "true"
}

variable "allow_major_version_upgrade" {
  description = "Allow major version upgrade"
  default     = "false"
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  default     = "false"
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi' UTC "
  default     = "Sun:09:00-Mon:08:00"
}

variable "backup_retention_period" {
  description = "Backup retention period in days. Must be > 0 to enable backups"
  default     = 1
}

variable "backup_window" {
  description = "When AWS can perform DB snapshots, can't overlap with maintenance window"
  default     = "00:30-05:30"
}

variable "skip_final_snapshot" {
        type         = "string"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  default     = []
}

variable "family" {
  description = "DB family for parameter group"
  type        = "string"
}

variable "kms_key_id" {
        type         = "string"
}


variable "component" {
 type ="string"
}

variable "security_groups" {
  description = "security list"
  type        = "map"

  default = {
    "dev.1" = "sg-rjsaahaegh"
  }
}

variable "private_subnets" {
  description = "Subnet list"
  type        = "map"

  default = {
    "env.1" = "subnet-ahsrhsrjsn"
    }
}
