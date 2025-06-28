# remember log group needs to be created first before ecs
# then only this log group will be used if not ecs will create log group
# with this same name and it will fail
resource "aws_cloudwatch_log_group" "oss_cw_log_group_app" {
  kms_key_id        = aws_kms_key.oss_kms_key_cw.arn
  name              = "/aws/ecs/containerinsights/OssEcsClusterApp/performance"
  retention_in_days = 30
  tags = {
    Name = "OssCwLogGroupApp"
  }
}

resource "aws_cloudwatch_log_group" "oss_cw_log_group_vpc_flow" {
  kms_key_id        = aws_kms_key.oss_kms_key_cw.arn
  name              = "/aws/vpc/flowlogs"
  retention_in_days = 30
  tags = {
    Name = "OssCwLogGroupVpcFlow"
  }
}

resource "aws_cloudwatch_log_group" "oss_cw_log_group_rds_postgresql_logs" {
  kms_key_id        = aws_kms_key.oss_kms_key_cw.arn
  name              = "/aws/rds/instance/keystroke/postgresql"
  retention_in_days = 30
  tags = {
    Name = "OssCwLogGroupRdsPostgres"
  }
}

resource "aws_cloudwatch_log_group" "oss_cw_log_rds_group_error_logs" {
  kms_key_id        = aws_kms_key.oss_kms_key_cw.arn
  name              = "/aws/rds/instance/keystroke/iam-db-auth-error"
  retention_in_days = 30
  tags = {
    Name = "OssCwLogGroupRdsPostgres"
  }
}

resource "aws_cloudwatch_log_group" "oss_cw_log_rds_group_upgrade_logs" {
  kms_key_id        = aws_kms_key.oss_kms_key_cw.arn
  name              = "/aws/rds/instance/keystroke/upgrade"
  retention_in_days = 30
  tags = {
    Name = "OssCwLogGroupRdsPostgres"
  }
}

resource "aws_cloudwatch_log_group" "oss_cw_log_rds_group_metrics_logs" {
  kms_key_id        = aws_kms_key.oss_kms_key_cw.arn
  name              = "RDSOSMetrics"
  retention_in_days = 30
  tags = {
    Name = "OssCwLogGroupRdsPostgres"
  }
}


