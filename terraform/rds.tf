resource "aws_db_instance" "oss_db_instance_rds" {
  identifier                   = "keystroke"
  engine                       = "postgres"
  engine_version               = "17.5"
  instance_class               = "db.t3.micro"
  allocated_storage            = 20
  storage_type                 = "gp2"
  username                     = random_string.oss_random_user.result
  password                     = random_password.oss_random_password.result
  db_name                      = "keystroke"
  publicly_accessible          = false
  multi_az                     = false
  skip_final_snapshot          = true
  backup_retention_period      = 0
  deletion_protection          = false
  auto_minor_version_upgrade   = true
  apply_immediately            = true
  storage_encrypted            = true
  kms_key_id                   = aws_kms_key.oss_kms_key_rds.arn
  vpc_security_group_ids       = [aws_security_group.oss_sg_rds_db.id]
  db_subnet_group_name         = aws_db_subnet_group.oss_db_subnet_group_keystore.name
  monitoring_interval          = 60
  monitoring_role_arn          = aws_iam_role.oss_iam_role_rds_monitoring.arn
  parameter_group_name         = aws_db_parameter_group.oss_db_pg.name
  performance_insights_enabled = true
  tags = {
    Name = "OssDbInstanceRdsKeystroke"
  }
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade",
    "iam-db-auth-error"
  ]
}

resource "aws_db_parameter_group" "oss_db_pg" {
  name        = "keystroke"
  family      = "postgres17"
  description = "Postgres log settings"

  parameter {
    name  = "log_destination"
    value = "stderr"
  }

  parameter {
    name  = "logging_collector"
    value = "on"
  }

  parameter {
    name  = "log_statement"
    value = "all"
  }

  parameter {
    name  = "log_min_duration_statement"
    value = "0"
  }
  tags = {
    Name = "OssDbPG"
  }
}
