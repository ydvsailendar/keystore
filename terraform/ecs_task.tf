resource "aws_ecs_task_definition" "oss_ecs_task_def_kafka_ui" {
  container_definitions = jsonencode([
    {
      environment = [
        { name = "KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS", value = "kafka.oss.local:9092" },
        { name = "KAFKA_CLUSTERS_0_NAME", value = "keystroke" }
      ]
      essential = true
      image     = "provectuslabs/kafka-ui"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.oss_cw_log_group_app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      name = "OssEcsTaskDefKafkaUi"
      portMappings = [
        { containerPort = 8080, protocol = "tcp" }
      ]
    }
  ])
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.oss_iam_role_ecs_task_exec.arn
  family                   = "OssEcsTaskDefKafkaUi"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "OssEcsTaskDefKafkaUi"
  }
  task_role_arn = aws_iam_role.oss_iam_role_ecs_task.arn
}

resource "aws_ecs_task_definition" "oss_ecs_task_def_kafka" {
  container_definitions = jsonencode([
    {
      environment = [
        { name = "KAFKA_ADVERTISED_LISTENERS", value = "PLAINTEXT://kafka.oss.local:9092" },
        { name = "KAFKA_CONTROLLER_LISTENER_NAMES", value = "CONTROLLER" },
        { name = "KAFKA_CONTROLLER_QUORUM_VOTERS", value = "1@kafka.oss.local:9093" },
        { name = "KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS", value = "0" },
        { name = "KAFKA_LISTENERS", value = "PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093" },
        { name = "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP", value = "CONTROLLER:PLAINTEXT,PLAINTEXT:PLAINTEXT" },
        { name = "KAFKA_LOG_DIRS", value = "/var/lib/kafka/data" },
        { name = "KAFKA_NODE_ID", value = "1" },
        { name = "KAFKA_NUM_PARTITIONS", value = "3" },
        { name = "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR", value = "1" },
        { name = "KAFKA_PROCESS_ROLES", value = "broker,controller" },
        { name = "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR", value = "1" },
        { name = "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR", value = "1" }
      ]
      essential = true
      image     = "apache/kafka"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.oss_cw_log_group_app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      mountPoints = [
        {
          containerPath = "/var/lib/kafka/data"
          readOnly      = false
          sourceVolume  = "OssKafkaData"
        }
      ]
      name = "OssEcsTaskDefKafka"
      portMappings = [
        { containerPort = 9092, protocol = "tcp" },
        { containerPort = 9093, protocol = "tcp" }
      ]
    }
  ])
  cpu                      = "1024"
  execution_role_arn       = aws_iam_role.oss_iam_role_ecs_task_exec.arn
  family                   = "OssEcsTaskDefKafka"
  memory                   = "2048"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "OssEcsTaskDefKafka"
  }
  task_role_arn = aws_iam_role.oss_iam_role_ecs_task_kafka.arn
  volume {
    efs_volume_configuration {
      authorization_config {
        access_point_id = aws_efs_access_point.oss_efs_access_point_kafka.id
        iam             = "ENABLED"
      }
      file_system_id     = aws_efs_file_system.oss_kafka_efs.id
      root_directory     = "/"
      transit_encryption = "ENABLED"
    }
    name = "OssKafkaData"
  }
}

resource "aws_ecs_task_definition" "oss_ecs_task_def_consumer_app" {
  container_definitions = jsonencode([
    {
      secrets = [
        {
          name      = "POSTGRES_USER"
          valueFrom = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_user.arn
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_password.arn
        }
      ]
      environment = [
        {
          name  = "POSTGRES_DB"
          value = aws_db_instance.oss_db_instance_rds.db_name
        },
        {
          name  = "POSTGRES_HOST"
          value = aws_db_instance.oss_db_instance_rds.address
        },
        {
          name  = "POSTGRES_PORT"
          value = tostring(aws_db_instance.oss_db_instance_rds.port)
        },
        {
          name  = "KAFKA_BROKER",
          value = "kafka.oss.local:9092"
        },
        {
          name  = "DB_USERNAME_SECRET_VERSION"
          value = aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_user_version.version_id
        },
        {
          name  = "DB_PASSWORD_SECRET_VERSION"
          value = aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_password_version.version_id
        }
      ]
      essential = true
      image     = "${aws_ecr_repository.oss_ecr_repo_consumer.repository_url}:v1.0.0"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.oss_cw_log_group_app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      name = "OssEcsTaskDefConsumerApp"
    }
  ])
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.oss_iam_role_ecs_task_exec.arn
  family                   = "OssEcsTaskDefConsumerApp"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "OssEcsTaskDefConsumerApp"
  }
  task_role_arn = aws_iam_role.oss_iam_role_ecs_task.arn
}

resource "aws_ecs_task_definition" "oss_ecs_task_def_producer_app" {
  container_definitions = jsonencode([
    {
      environment = [{ name = "KAFKA_BROKER", value = "kafka.oss.local:9092" }]
      essential   = true
      image       = "${aws_ecr_repository.oss_ecr_repo_producer.repository_url}:v1.0.0"
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.oss_cw_log_group_app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      name = "OssEcsTaskDefProducerApp"
    }
  ])
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.oss_iam_role_ecs_task_exec.arn
  family                   = "OssEcsTaskDefProducerApp"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "OssEcsTaskDefProducerApp"
  }
  task_role_arn = aws_iam_role.oss_iam_role_ecs_task.arn
}

resource "aws_ecs_task_definition" "oss_ecs_task_def_dashboard_app" {
  container_definitions = jsonencode([
    {
      essential = true
      image     = "${aws_ecr_repository.oss_ecr_repo_dashboard.repository_url}:v1.0.0"
      secrets = [
        {
          name      = "POSTGRES_USER"
          valueFrom = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_user.arn
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_password.arn
        }
      ]
      environment = [
        {
          name  = "POSTGRES_DB"
          value = aws_db_instance.oss_db_instance_rds.db_name
        },
        {
          name  = "POSTGRES_HOST"
          value = aws_db_instance.oss_db_instance_rds.address
        },
        {
          name  = "POSTGRES_PORT"
          value = tostring(aws_db_instance.oss_db_instance_rds.port)
        },
        {
          name  = "DB_USERNAME_SECRET_VERSION"
          value = aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_user_version.version_id
        },
        {
          name  = "DB_PASSWORD_SECRET_VERSION"
          value = aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_password_version.version_id
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.oss_cw_log_group_app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      name = "OssEcsTaskDefDashboardApp"
      portMappings = [
        { containerPort = 8000, protocol = "tcp" }
      ]
    }
  ])
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.oss_iam_role_ecs_task_exec.arn
  family                   = "OssEcsTaskDefDashboardApp"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "OssEcsTaskDefDashboardApp"
  }
  task_role_arn = aws_iam_role.oss_iam_role_ecs_task.arn
}

resource "aws_ecs_task_definition" "oss_ecs_task_def_migrator" {
  container_definitions = jsonencode([
    {
      essential = true
      image     = "${aws_ecr_repository.oss_ecr_repo_migrator.repository_url}:v1.0.0"
      secrets = [
        {
          name      = "POSTGRES_USER"
          valueFrom = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_user.arn
        },
        {
          name      = "POSTGRES_PASSWORD"
          valueFrom = aws_secretsmanager_secret.oss_secretsmanager_secret_rds_password.arn
        }
      ]
      environment = [
        {
          name  = "POSTGRES_DB"
          value = aws_db_instance.oss_db_instance_rds.db_name
        },
        {
          name  = "POSTGRES_HOST"
          value = aws_db_instance.oss_db_instance_rds.address
        },
        {
          name  = "POSTGRES_PORT"
          value = tostring(aws_db_instance.oss_db_instance_rds.port)
        },
        {
          name  = "DB_USERNAME_SECRET_VERSION"
          value = aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_user_version.version_id
        },
        {
          name  = "DB_PASSWORD_SECRET_VERSION"
          value = aws_secretsmanager_secret_version.oss_secretsmanager_secret_rds_password_version.version_id
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.oss_cw_log_group_app.name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "ecs"
        }
      }
      name = "OssEcsTaskDefMigrator"
    }
  ])
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.oss_iam_role_ecs_task_exec.arn
  family                   = "OssEcsTaskDefMigrator"
  memory                   = "512"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  tags = {
    Name = "OssEcsTaskDefMigrator"
  }
  task_role_arn = aws_iam_role.oss_iam_role_ecs_task.arn
}
