resource "aws_kms_key" "oss_kms_key_cw" {
  description             = "KMS key for encrypting CloudWatch Logs for Container Insights"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement = [
      {
        Action = [
          "kms:*"
        ],
        Effect = "Allow",
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Sid      = "Allow administration of the key",
        Resource = "*"
      },
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:ReEncrypt*"
        ],
        Effect = "Allow",
        Principal = {
          Service = "logs.${data.aws_region.current.name}.amazonaws.com"
        },
        Sid      = "Allow CloudWatch Logs to use the key",
        Resource = "*"
      }
    ],
    Version = "2012-10-17"
  })
  tags = {
    Name = "OssKmsKeyCw"
  }
}

resource "aws_kms_alias" "oss_kms_alias_cw" {
  name          = "alias/OssKmsKeyCw"
  target_key_id = aws_kms_key.oss_kms_key_cw.key_id
}

resource "aws_kms_key" "oss_kms_key_ecr" {
  description             = "KMS key for encrypting Amazon ECR images"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement : [
      {
        Action : [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*"
        ],
        Effect : "Allow",
        Principal : {
          Service : "ecr.amazonaws.com"
        },
        Resource : "*",
        Sid : "Allow ECR to use key"
      },
      {
        Action : "kms:*",
        Effect : "Allow",
        Principal : {
          AWS : "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        },
        Resource : "*",
        Sid : "Allow account admins to use the key"
      }
    ],
    Version = "2012-10-17"
  })
  tags = {
    Name = "OssKmsKeyEcr"
  }
}

resource "aws_kms_alias" "oss_kms_alias_ecr" {
  name          = "alias/OssKmsKeyEcr"
  target_key_id = aws_kms_key.oss_kms_key_ecr.key_id
}

resource "aws_kms_key" "oss_kms_key_efs" {
  description             = "KMS key for Kafka EFS encryption"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "AllowAccountFullAccess"
      },
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Effect = "Allow"
        Principal = {
          Service = "elasticfilesystem.amazonaws.com"
        }
        Resource = "*"
        Sid      = "AllowEFSUseOfTheKey"
      }
    ],
    Version = "2012-10-17"
  })
  tags = {
    Name = "OssKmsKeyEfs"
  }
}

resource "aws_kms_alias" "oss_kms_alias_efs" {
  name          = "alias/OssKmsKeyEfs"
  target_key_id = aws_kms_key.oss_kms_key_efs.key_id
}

resource "aws_kms_key" "oss_kms_key_rds" {
  description             = "KMS key for RDS encryption"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "AllowAccountFullAccess"
      },
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Effect = "Allow"
        Principal = {
          Service = "elasticfilesystem.amazonaws.com"
        }
        Resource = "*"
        Sid      = "AllowRdsUseOfTheKey"
      }
    ],
    Version = "2012-10-17"
  })
  tags = {
    Name = "OssKmsKeyRds"
  }
}

resource "aws_kms_alias" "oss_kms_alias_rds" {
  name          = "alias/OssKmsKeyRds"
  target_key_id = aws_kms_key.oss_kms_key_rds.key_id
}

resource "aws_kms_key" "oss_kms_key_secrets" {
  description             = "KMS key for Secrets Manager"
  deletion_window_in_days = 7

  policy = jsonencode({
    Statement = [
      {
        Action = "kms:*"
        Effect = "Allow"
        Principal = {
          AWS = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
        Resource = "*"
        Sid      = "AllowAccountFullAccess"
      },
      {
        Action = [
          "kms:Encrypt",
          "kms:Decrypt",
          "kms:GenerateDataKey*",
          "kms:DescribeKey"
        ]
        Effect = "Allow"
        Principal = {
          Service = "secretsmanager.amazonaws.com"
        }
        Resource = "*"
        Sid      = "AllowSecretsManagerAccess"
      }
    ],
    Version = "2012-10-17"
  })
  tags = {
    Name = "OssKmsKeySecrets"
  }
}

resource "aws_kms_alias" "oss_kms_alias_secrets" {
  name          = "alias/OssKmsKeySecrets"
  target_key_id = aws_kms_key.oss_kms_key_secrets.key_id
}
