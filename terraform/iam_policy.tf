data "aws_iam_policy_document" "oss_iam_policy_efs" {
  statement {
    actions = [
      "elasticfilesystem:ClientMount",
      "elasticfilesystem:ClientWrite",
      "elasticfilesystem:ClientRootAccess",
      "elasticfilesystem:DescribeFileSystems"
    ]
    resources = [
      aws_efs_file_system.oss_kafka_efs.arn
    ]
  }
  statement {
    actions = [
      "kms:Decrypt",
      "kms:GenerateDataKey"
    ]
    resources = [
      aws_kms_key.oss_kms_key_efs.arn
    ]
  }
}

resource "aws_iam_policy" "oss_iam_policy_efs" {
  name   = "OssIamPolicyEfs"
  policy = data.aws_iam_policy_document.oss_iam_policy_efs.json
  tags = {
    Name = "OssIamPolicyEfs"
  }
}

resource "aws_iam_policy" "oss_iam_policy_ecs_task_ssm" {
  policy = jsonencode({
    Statement = [
      {
        Action = [
          "ssmmessages:CreateControlChannel",
          "ssmmessages:CreateDataChannel",
          "ssmmessages:OpenControlChannel",
          "ssmmessages:OpenDataChannel"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
    Version = "2012-10-17"
  })
  name = "OssIamPolicyEcsTask"
  tags = {
    Name = "OssIamPolicyEcsTask"
  }
}

resource "aws_iam_policy" "oss_iam_policy_ecs_task_exec_secrets" {
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "secretsmanager:GetSecretValue"
        ],
        Resource = [
          aws_secretsmanager_secret.oss_secretsmanager_secret_rds_user.arn,
          aws_secretsmanager_secret.oss_secretsmanager_secret_rds_password.arn
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        Resource = [
          aws_kms_key.oss_kms_key_secrets.arn
        ]
      }
    ]
  })
  name = "OssIamPolicyEcsTaskExecSecrets"
  tags = {
    Name = "OssIamPolicyEcsTaskExecSecrets"
  }
}
