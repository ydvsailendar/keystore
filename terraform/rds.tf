resource "aws_db_instance" "oss_db_instance_rds" {
  identifier                 = "keystroke"
  engine                     = "postgres"
  engine_version             = "17.5"
  instance_class             = "db.t3.micro"
  allocated_storage          = 20
  storage_type               = "gp2"
  username                   = random_string.oss_random_user.result
  password                   = random_password.oss_random_password.result
  db_name                    = "keystroke"
  publicly_accessible        = false
  multi_az                   = false
  skip_final_snapshot        = true
  backup_retention_period    = 0
  deletion_protection        = false
  auto_minor_version_upgrade = true
  apply_immediately          = true
  storage_encrypted          = true
  kms_key_id                 = aws_kms_key.oss_kms_key_rds.arn
  vpc_security_group_ids     = [aws_security_group.oss_sg_rds_db.id]
  db_subnet_group_name       = aws_db_subnet_group.oss_db_subnet_group_keystore.name
  monitoring_interval        = 60
  monitoring_role_arn        = aws_iam_role.oss_iam_role_rds_monitoring.arn
  tags = {
    Name = "OssDbInstanceRdsKeystroke"
  }
  enabled_cloudwatch_logs_exports = [
    "postgresql",
    "upgrade",
    "iam-db-auth-error"
  ]
}
