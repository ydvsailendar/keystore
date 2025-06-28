resource "aws_iam_role" "oss_iam_role_ecs_task_exec" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17",
  })
  name = "OssIamRoleEcsTaskExec"
  tags = {
    Name = "OssIamRoleEcsTaskExec"
  }
}

resource "aws_iam_role_policy_attachment" "oss_iam_role_policy_attachment_ecs_task_exec" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  role       = aws_iam_role.oss_iam_role_ecs_task_exec.name
}

resource "aws_iam_service_linked_role" "oss_iam_service_linked_role_ecs_service" {
  aws_service_name = "ecs.amazonaws.com"
  description      = "ECS Service Linked Role"
  tags = {
    Name = "OssIamServiceLinkedRoleEcsService"
  }
}

resource "aws_iam_role" "oss_iam_role_ecs_task_kafka" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "OssIamRoleEcsTaskKafka"
  tags = {
    Name = "OssIamRoleEcsTaskKafka"
  }
}

resource "aws_iam_role_policy_attachment" "oss_iam_policy_attachment_ecs_task_kafka" {
  role       = aws_iam_role.oss_iam_role_ecs_task_kafka.name
  policy_arn = aws_iam_policy.oss_iam_policy_efs.arn
}

resource "aws_iam_role_policy_attachment" "oss_iam_policy_attachment_ecs_task_kafka_ssm" {
  role       = aws_iam_role.oss_iam_role_ecs_task_kafka.name
  policy_arn = aws_iam_policy.oss_iam_policy_ecs_task_ssm.arn
}

resource "aws_iam_role" "oss_iam_role_vpc_flow" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "vpc-flow-logs.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "OssIamRoleVpcFlow"
  tags = {
    Name = "OssIamRoleVpcFlow"
  }
}

resource "aws_iam_role_policy" "oss_iam_role_policy_vpc_flow" {
  name = "OssIamPolicyVpcFlow"
  policy = jsonencode({
    Statement : [
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogGroups",
          "logs:DescribeLogStreams"
        ],
        Resource = "*"
      }
    ]
    Version = "2012-10-17",
  })
  role = aws_iam_role.oss_iam_role_vpc_flow.id
}

resource "aws_iam_role" "oss_iam_role_ecs_task" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ecs-tasks.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })
  name = "OssIamRoleEcsTask"
  tags = {
    Name = "OssIamRoleEcsTask"
  }
}

resource "aws_iam_role_policy_attachment" "oss_iam_policy_attachment_ssm" {
  role       = aws_iam_role.oss_iam_role_ecs_task.name
  policy_arn = aws_iam_policy.oss_iam_policy_ecs_task_ssm.arn
}

resource "aws_iam_role_policy_attachment" "oss_iam_policy_attachment_secrets" {
  role       = aws_iam_role.oss_iam_role_ecs_task_exec.name
  policy_arn = aws_iam_policy.oss_iam_policy_ecs_task_exec_secrets.arn
}

resource "aws_iam_role" "oss_iam_role_rds_monitoring" {
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "monitoring.rds.amazonaws.com"
      }
    }]
  })
  name = "OssIamPolicyRdsMonitoring"
  tags = {
    Name = "OssIamPolicyRdsMonitoring"
  }
}

resource "aws_iam_role_policy_attachment" "oss_iam_policy_attachment_rds_monitoring" {
  role       = aws_iam_role.oss_iam_role_rds_monitoring.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}
