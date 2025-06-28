resource "aws_secretsmanager_secret" "oss_secretsmanager_secret_rds_user" {
  name        = "OssSecretsManagerSecretRdsUser"
  description = "Database User for keystroke service"
  kms_key_id  = aws_kms_alias.oss_kms_alias_secrets.arn
  tags = {
    Name = "OssSecretsManagerSecretRdsUser"
  }
}

resource "aws_secretsmanager_secret_version" "oss_secretsmanager_secret_rds_user_version" {
  secret_id     = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_user.id
  secret_string = random_string.oss_random_user.result
}

resource "aws_secretsmanager_secret" "oss_secretsmanager_secret_rds_password" {
  name        = "OssSecretsManagerSecretRdsPassword"
  description = "Database Password for keystroke service"
  kms_key_id  = aws_kms_alias.oss_kms_alias_secrets.arn
  tags = {
    Name = "OssSecretsManagerSecretRdsPassword"
  }
}

resource "aws_secretsmanager_secret_version" "oss_secretsmanager_secret_rds_password_version" {
  secret_id     = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_password.id
  secret_string = random_password.oss_random_password.result
}
