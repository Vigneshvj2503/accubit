resource "aws_db_subnet_group" "db" {
  name        = "${var.app_env}-${var.name}-rds"
  #subnet_ids =  ["${module.nyl_finders.private_subnet1_id}", "${module.nyl_finders.private_subnet2_id}", "${module.nyl_finders.private_subnet1_id}"]
subnet_ids = ["${lookup(var.private_subnets, "${var.csg_env}.1")}", "${lookup(var.private_subnets, "${var.csg_env}.2")}"]
  }


resource "aws_db_instance" "default" {
  identifier                  = "${var.identifier}"
  name                        = "${var.name}"
  username                    = "${var.username}"
  password                    = "${var.password}"
  port                        = "${var.port}"
  engine                      = "${var.engine}"
  engine_version              = "${var.engine_version}"
  instance_class              = "${var.instance_class}"
  allocated_storage           = "${var.allocated_storage}"
  storage_encrypted           = "${var.storage_encrypted}"
  kms_key_id                  = "${var.kms_key_id}"
  db_subnet_group_name        = "${aws_db_subnet_group.db.name}"
  parameter_group_name        = "${aws_db_parameter_group.database.name}"
  multi_az                    = "${var.multi_az}"
  storage_type                = "${var.storage_type}"
  iops                        = "${var.iops}"
  publicly_accessible         = "${var.publicly_accessible}"
  #snapshot_identifier        = "${var.snapshot_identifier}"
  allow_major_version_upgrade = "${var.allow_major_version_upgrade}"
  auto_minor_version_upgrade  = "${var.auto_minor_version_upgrade}"
  apply_immediately           = "${var.apply_immediately}"
  maintenance_window          = "${var.maintenance_window}"
  skip_final_snapshot         = "${var.skip_final_snapshot}"
  #copy_tags_to_snapshot      = "${var.copy_tags_to_snapshot}"
  backup_retention_period     = "${var.backup_retention_period}"
  backup_window               = "${var.backup_window}"
  #tags                       = "${var.tags}"
  final_snapshot_identifier   = "${var.identifier}-final-snapshot-${md5(timestamp())}"
  vpc_security_group_ids      =  ["$var.security_groups, "${var.app_env}.1")}", "${lookup(var.security_groups, "${var.app_env}.2")}", "${lookup(var.security_groups, "${var.csg_env}")}"]
  tags = {
    Name        = "${var.identifier}"
    appid       = "${var.appid}"
     lob         = "${var.lob}"
    csg_env     = "${var.csg_env}"
    app_env     = "${var.app_env}"
    project     = "${var.project}"
    platform    = "${var.platform}"
    component   = "${var.name}"
  }
}

resource "aws_db_parameter_group" "database" {
  name   = "${var.app_env}-${var.name}-database-parameter-group"
  family = "${var.family}"


  parameter {
    name         = "rds.force_ssl"
    value        = "1"
    apply_method = "pending-reboot"
  }
}
